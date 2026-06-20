import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sembast/sembast.dart';

import '../../models/course.dart';
import '../../models/nav_layout.dart';
import '../../models/quiz_content.dart';
import '../course_catalog.dart';
import '../quiz_content_library.dart';
import 'content_database_factory.dart';

/// Asset holding the published content the database is seeded from. Regenerate
/// it with `dart run tool/generate_seed.dart`; a teacher's Export overwrites it
/// to publish edits in the next build.
const String _seedAsset = 'assets/seed/quiz_content.json';

/// Version of the shipped/published content. **Bump this whenever the seeded
/// content changes** (new quizzes, edited sentences, reordered chains, etc.):
/// on launch, an existing install whose stored version differs is automatically
/// re-seeded from the published content, so learners get content updates without
/// a manual reset. Re-seeding replaces any local back-office edits with the
/// published content; learner progress (SharedPreferences) is not affected.
const int kSeedVersion = 20;

/// Lightweight summary of a quiz for the back-office list.
class QuizSummary {
  const QuizSummary({
    required this.id,
    required this.title,
    required this.storageKeyPrefix,
    required this.sentenceCount,
    this.kind = QuizKind.fillBlank,
  });

  final String id;
  final String title;

  /// The quiz's SharedPreferences key prefix (for reading its score/streak).
  final String storageKeyPrefix;
  final int sentenceCount;

  /// The quiz type, so the UI can pick a kind-specific icon (e.g. an audio
  /// glyph for [QuizKind.speakRepeat] listen-&-repeat quizzes).
  final QuizKind kind;
}

/// A stored sentence together with its database record key, so the UI can
/// update or delete it.
class SentenceRecord {
  const SentenceRecord({required this.key, required this.data});

  final int key;
  final QuizSentenceData data;
}

/// Local, editable store of quiz content backed by sembast (IndexedDB on web,
/// a file on desktop/mobile).
///
/// Quiz metadata (title, subjects, categories, templates, reference tables)
/// lives in the `quizzes` store keyed by quiz id; each fill-in sentence is its
/// own record in the `sentences` store (tagged with `quizId`) so the back
/// office can add and delete sentences individually.
class ContentRepository {
  ContentRepository(this.db);

  final Database db;

  final StoreRef<String, Map<String, Object?>> _quizzes =
      stringMapStoreFactory.store('quizzes');
  final StoreRef<int, Map<String, Object?>> _sentences =
      intMapStoreFactory.store('sentences');
  final StoreRef<String, Map<String, Object?>> _meta =
      stringMapStoreFactory.store('meta');

  /// Seeds the database from [contents] on first run (when it has no quizzes).
  Future<void> seedIfEmpty(List<QuizContent> contents) async {
    if (await _quizzes.count(db) > 0) return;
    await _writeContents(contents);
  }

  /// The [kSeedVersion] the database was last seeded with, or null if it
  /// predates version tracking.
  Future<int?> seededVersion() async =>
      (await _meta.record('seed').get(db))?['version'] as int?;

  /// Seeds on first run; on later runs, re-seeds from [contents] if the stored
  /// content version differs from [kSeedVersion], so shipped content updates
  /// reach existing installs automatically. (Installs predating version
  /// tracking re-seed once.) Learner progress in SharedPreferences is untouched.
  Future<void> seedOrUpgrade(
    List<QuizContent> contents, {
    List<Course>? courses,
  }) async {
    if (await _quizzes.count(db) == 0) {
      await _writeContents(contents);
      if (courses != null) await saveCourses(courses);
      return;
    }
    if (await seededVersion() != kSeedVersion) {
      await reseed(contents, courses: courses);
    }
  }

  /// Wipes all content and re-seeds from [contents] (and [courses] if given) —
  /// used by the back office's "Reset to published content" action.
  Future<void> reseed(List<QuizContent> contents, {List<Course>? courses}) async {
    await db.transaction((txn) async {
      await _quizzes.delete(txn);
      await _sentences.delete(txn);
    });
    await _writeContents(contents);
    if (courses != null) await saveCourses(courses);
  }

  /// The editable courses (each with its own drawer layout), or
  /// [defaultCourses] if none has been stored yet.
  Future<List<Course>> courses() async {
    final json = await _meta.record('courses').get(db);
    final list = json?['list'] as List?;
    if (list == null) return defaultCourses;
    return [
      for (final c in list) Course.fromJson(Map<String, dynamic>.from(c as Map)),
    ];
  }

  Future<void> saveCourses(List<Course> courses) => _meta.record('courses').put(
    db,
    {'list': [for (final c in courses) c.toJson()]},
  );

  /// Replaces the navigation layout of the course with [courseId].
  Future<void> saveNavLayout(String courseId, NavLayout nav) async {
    final list = await courses();
    await saveCourses([
      for (final c in list) c.id == courseId ? c.copyWith(nav: nav) : c,
    ]);
  }

  Future<void> _writeContents(List<QuizContent> contents) async {
    await db.transaction((txn) async {
      for (final content in contents) {
        final json = content.toJson();
        final sentences = (json.remove('sentences') as List?) ?? const [];
        await _quizzes.record(content.id).put(txn, Map<String, Object?>.from(json));
        for (final sentence in sentences) {
          await _sentences.add(txn, {
            'quizId': content.id,
            ...(sentence as Map),
          });
        }
      }
      await _meta.record('seed').put(txn, {'version': kSeedVersion});
    });
  }

  Future<List<QuizSummary>> listQuizzes() async {
    final records = await _quizzes.find(db);
    final summaries = <QuizSummary>[];
    for (final record in records) {
      final count =
          await _sentences.count(db, filter: Filter.equals('quizId', record.key));
      summaries.add(
        QuizSummary(
          id: record.key,
          title: (record.value['title'] as String?) ?? record.key,
          storageKeyPrefix:
              (record.value['storageKeyPrefix'] as String?) ?? '${record.key}_',
          sentenceCount: count,
          kind: QuizKind.values.byName(
            (record.value['kind'] as String?) ?? 'fillBlank',
          ),
        ),
      );
    }
    return summaries;
  }

  /// Reconstructs the full [QuizContent] for [quizId] (metadata + its
  /// sentences), or null if it doesn't exist.
  Future<QuizContent?> quizContent(String quizId) async {
    final quizJson = await _quizzes.record(quizId).get(db);
    if (quizJson == null) return null;
    final records = await _sentences.find(
      db,
      finder: Finder(filter: Filter.equals('quizId', quizId)),
    );
    final sentences = [
      for (final record in records)
        Map<String, Object?>.from(record.value)..remove('quizId'),
    ];
    return QuizContent.fromJson({
      ...Map<String, dynamic>.from(quizJson),
      'sentences': sentences,
    });
  }

  Future<List<SentenceRecord>> sentencesFor(String quizId) async {
    final records = await _sentences.find(
      db,
      finder: Finder(
        filter: Filter.equals('quizId', quizId),
        sortOrders: [SortOrder('categoryLabel'), SortOrder('subjectKey')],
      ),
    );
    return [
      for (final record in records)
        SentenceRecord(
          key: record.key,
          data: QuizSentenceData.fromJson(
            Map<String, dynamic>.from(record.value)..remove('quizId'),
          ),
        ),
    ];
  }

  Future<int> addSentence(String quizId, QuizSentenceData sentence) =>
      _sentences.add(db, {'quizId': quizId, ...sentence.toJson()});

  Future<void> updateSentence(
    String quizId,
    int key,
    QuizSentenceData sentence,
  ) => _sentences.record(key).put(db, {'quizId': quizId, ...sentence.toJson()});

  Future<void> deleteSentence(int key) => _sentences.record(key).delete(db);

  /// Serializes the whole database back to the seed JSON shape
  /// (`{ "quizzes": [...], "courses": [...] }`), so a teacher can commit it to
  /// `assets/` to publish both content and the courses/menus.
  Future<String> exportJson() async {
    final records = await _quizzes.find(db);
    final contents = <Map<String, dynamic>>[];
    for (final record in records) {
      final content = await quizContent(record.key);
      if (content != null) contents.add(content.toJson());
    }
    final courseList = await courses();
    return const JsonEncoder.withIndent('  ').convert({
      'quizzes': contents,
      'courses': [for (final c in courseList) c.toJson()],
    });
  }
}

/// Published content + courses, parsed from the seed asset.
class PublishedContent {
  const PublishedContent({required this.quizzes, required this.courses});

  final List<QuizContent> quizzes;
  final List<Course> courses;
}

/// The published content the database seeds from: the [_seedAsset] JSON if it
/// is present and valid, otherwise the compiled-in [allQuizContent] +
/// [defaultCourses] as a fallback. Accepts the new `{quizzes, courses}` shape,
/// the legacy `{quizzes, nav}` (wrapped as the default course), and a bare list.
Future<PublishedContent> loadPublishedContent() async {
  try {
    final raw = await rootBundle.loadString(_seedAsset);
    final decoded = jsonDecode(raw);

    List<QuizContent> parseQuizzes(List<dynamic> list) => [
      for (final entry in list)
        QuizContent.fromJson(Map<String, dynamic>.from(entry as Map)),
    ];

    if (decoded is List) {
      return PublishedContent(quizzes: parseQuizzes(decoded), courses: defaultCourses);
    }
    final map = Map<String, dynamic>.from(decoded as Map);
    final quizzes = parseQuizzes((map['quizzes'] as List?) ?? const []);

    List<Course> courses;
    if (map['courses'] is List) {
      courses = [
        for (final c in map['courses'] as List)
          Course.fromJson(Map<String, dynamic>.from(c as Map)),
      ];
    } else if (map['nav'] is Map) {
      // Legacy single-nav seed → apply it to the default (English) course.
      final nav = NavLayout.fromJson(Map<String, dynamic>.from(map['nav'] as Map));
      courses = [
        for (final c in defaultCourses)
          c.id == kDefaultCourseId ? c.copyWith(nav: nav) : c,
      ];
    } else {
      courses = defaultCourses;
    }

    return PublishedContent(
      quizzes: quizzes.isEmpty ? allQuizContent : quizzes,
      courses: courses.isEmpty ? defaultCourses : courses,
    );
  } catch (_) {
    return PublishedContent(quizzes: allQuizContent, courses: defaultCourses);
  }
}

/// Opens the local content database and seeds it from the published content on
/// first run.
Future<ContentRepository> openContentRepository() async {
  final db = await openContentDatabase();
  final repository = ContentRepository(db);
  final published = await loadPublishedContent();
  await repository.seedOrUpgrade(published.quizzes, courses: published.courses);
  return repository;
}

Future<ContentRepository>? _shared;

/// The app-wide [ContentRepository], opened once and shared by the back office
/// and the learner quizzes so they use a single database connection.
Future<ContentRepository> contentRepository() =>
    _shared ??= openContentRepository();
