import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:sembast/sembast.dart';

import '../../models/course.dart';
import '../../models/nav_layout.dart';
import '../../models/quiz_content.dart';
import '../course_catalog.dart';
import '../data_version.dart';
import '../quiz_content_library.dart';
import 'content_database_factory.dart';

/// Asset holding the published content the database is seeded from. Regenerate
/// it with `dart run tool/generate_seed.dart`; a teacher's Export overwrites it
/// to publish edits in the next build.
const String _seedAsset = 'assets/seed/quiz_content.json';

// The published content version lives in [kDataVersion] (see
// `lib/data/data_version.dart`) and is carried in the seed JSON's `"version"`.

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

  /// Teacher-edited per-course bundles, keyed by course id. When present, one of
  /// these overrides the shipped `assets/content/courses/<id>.json` (the
  /// `CourseContentProvider` reads this first) — this is the editable, writable
  /// half of "keep the DB as the cache". Empty until a teacher saves an edit.
  final StoreRef<String, Map<String, Object?>> _bundles =
      stringMapStoreFactory.store('course_bundles');

  /// The teacher-edited bundle JSON for [courseId], or null if unedited.
  Future<Map<String, Object?>?> readBundle(String courseId) =>
      _bundles.record(courseId).get(db);

  /// Saves a teacher-edited [json] bundle for [courseId].
  Future<void> writeBundle(String courseId, Map<String, Object?> json) =>
      _bundles.record(courseId).put(db, json);

  /// Drops [courseId]'s edits, so it reverts to the shipped bundle.
  Future<void> removeBundle(String courseId) =>
      _bundles.record(courseId).delete(db);

  /// Seeds the database from [contents] on first run (when it has no quizzes).
  Future<void> seedIfEmpty(List<QuizContent> contents) async {
    if (await _quizzes.count(db) > 0) return;
    await db.transaction(
      (txn) => _writeContentsInto(txn, contents, kDataVersion),
    );
  }

  /// The data version the database was last seeded with, or null if it predates
  /// version tracking (older int-versioned installs read as null and re-seed).
  Future<String?> seededDataVersion() async =>
      (await _meta.record('seed').get(db))?['dataVersion'] as String?;

  /// Seeds on first run; on later runs, re-seeds from [contents] when the stored
  /// data version differs from [version], so shipped content updates reach
  /// existing installs automatically. An empty quiz store is always (re-)seeded —
  /// this self-heals a database left blank by a previously interrupted seed.
  /// (Installs predating version tracking re-seed once.) Learner progress in
  /// SharedPreferences is untouched.
  Future<void> seedOrUpgrade(
    List<QuizContent> contents, {
    List<Course>? courses,
    String version = kDataVersion,
  }) async {
    final isEmpty = await _quizzes.count(db) == 0;
    if (isEmpty || await seededDataVersion() != version) {
      await reseed(contents, courses: courses, version: version);
    }
  }

  /// Wipes all content and re-seeds from [contents] (and [courses] if given) —
  /// used on a version change and by the back office's "Reset to published
  /// content" action.
  ///
  /// This also drops any teacher-edited course-bundle overrides (the `_bundles`
  /// store). Those overrides are consulted *before* the shipped
  /// `assets/content/courses/<id>.json` (see [CachingCourseProvider.populated]),
  /// so a stale override would otherwise keep hiding updated shipped content
  /// after an app update — the new content would only appear after the user
  /// cleared app data (which is what wipes `_bundles`). Clearing them on a
  /// version change lets the fresh asset bundles win. Learner progress lives in
  /// SharedPreferences, a separate store, so it is untouched.
  ///
  /// The wipe and the re-seed run in a *single* transaction, so an interrupted
  /// or failed re-seed rolls back as a whole rather than leaving the database
  /// half-empty (which previously could blank out all content on web).
  Future<void> reseed(
    List<QuizContent> contents, {
    List<Course>? courses,
    String version = kDataVersion,
  }) async {
    await db.transaction((txn) async {
      await _quizzes.delete(txn);
      await _sentences.delete(txn);
      await _bundles.delete(txn);
      await _writeContentsInto(txn, contents, version);
      if (courses != null) {
        await _meta.record('courses').put(txn, {
          'list': [for (final c in courses) c.toJson()],
        });
      }
    });
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

  /// Writes [contents] (quiz metadata + sentences) and records [version] using
  /// [client], which may be the database or an open transaction — letting a
  /// caller bundle the write into a larger atomic transaction (see [reseed]).
  Future<void> _writeContentsInto(
    DatabaseClient client,
    List<QuizContent> contents,
    String version,
  ) async {
    for (final content in contents) {
      final json = content.toJson();
      final sentences = (json.remove('sentences') as List?) ?? const [];
      await _quizzes.record(content.id).put(
        client,
        Map<String, Object?>.from(json),
      );
      for (final sentence in sentences) {
        await _sentences.add(client, {
          'quizId': content.id,
          ...(sentence as Map),
        });
      }
    }
    await _meta.record('seed').put(client, {'dataVersion': version});
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
  /// (`{ "version": ..., "quizzes": [...], "courses": [...] }`), so a teacher
  /// can commit it to `assets/` to publish both content and the courses/menus.
  /// The exported `"version"` is the currently-seeded one; bump it (in the JSON
  /// or [kDataVersion]) to make existing installs re-seed from the new content.
  Future<String> exportJson() async {
    final records = await _quizzes.find(db);
    final contents = <Map<String, dynamic>>[];
    for (final record in records) {
      final content = await quizContent(record.key);
      if (content != null) contents.add(content.toJson());
    }
    final courseList = await courses();
    return const JsonEncoder.withIndent('  ').convert({
      'version': await seededDataVersion() ?? kDataVersion,
      'quizzes': contents,
      'courses': [for (final c in courseList) c.toJson()],
    });
  }
}

/// Published content + courses, parsed from the seed asset.
class PublishedContent {
  const PublishedContent({
    required this.version,
    required this.quizzes,
    required this.courses,
  });

  /// The published data version (the seed JSON's `"version"`), compared against
  /// the installed version to decide whether to re-seed.
  final String version;
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
      return PublishedContent(
        version: kDataVersion,
        quizzes: parseQuizzes(decoded),
        courses: defaultCourses,
      );
    }
    final map = Map<String, dynamic>.from(decoded as Map);
    final version = (map['version'] as String?) ?? kDataVersion;
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
      version: version,
      quizzes: quizzes.isEmpty ? allQuizContent : quizzes,
      courses: courses.isEmpty ? defaultCourses : courses,
    );
  } catch (_) {
    return PublishedContent(
      version: kDataVersion,
      quizzes: allQuizContent,
      courses: defaultCourses,
    );
  }
}

/// Opens the local content database and seeds it from the published content on
/// first run.
Future<ContentRepository> openContentRepository() async {
  final db = await openContentDatabase();
  final repository = ContentRepository(db);
  final published = await loadPublishedContent();
  await repository.seedOrUpgrade(
    published.quizzes,
    courses: published.courses,
    version: published.version,
  );
  return repository;
}

Future<ContentRepository>? _shared;

/// The app-wide [ContentRepository], opened once and shared by the back office
/// and the learner quizzes so they use a single database connection.
Future<ContentRepository> contentRepository() =>
    _shared ??= openContentRepository();
