import 'dart:convert';

import '../../models/content/catalog.dart';
import '../../models/content/populated_course.dart';
import 'noun_collection.dart';

/// Read seam for the JSON content collections. The learner UI depends only on
/// this interface, so the backing store can change (bundled assets now, a remote
/// database later) without touching any screen.
abstract interface class CourseContentProvider {
  /// The always-loaded course index (cheap; no course content).
  Future<Catalog> catalog();

  /// The always-loaded global, non-course UI content.
  Future<AppConfig> appConfig();

  /// The populated bundle for [courseId] — loaded on first open and cached.
  Future<PopulatedCourse> populated(String courseId);

  /// The shared noun list for a learned-language code (e.g. `de`), used
  /// cross-course; empty when that language has no noun collection.
  Future<NounCollection> nounCollection(String langCode);
}

/// Where raw collection JSON comes from. Splitting this out keeps the caching
/// provider free of Flutter/IO so it can be unit-tested with an in-memory
/// source, and lets a future remote-DB/download source slot in unchanged.
abstract interface class ContentSource {
  Future<String> catalogJson();
  Future<String> appConfigJson();
  Future<String> courseJson(String courseId);
  Future<String> sharedNounsJson(String langCode);
}

/// A writable override store for teacher-edited course bundles. When it has a
/// bundle for a course, the provider serves that instead of the shipped asset —
/// so edits persist locally and reach learners (the local stand-in for writing
/// to a remote database).
abstract interface class CourseBundleStore {
  Future<Map<String, dynamic>?> read(String courseId);
  Future<void> write(String courseId, Map<String, dynamic> json);
  Future<void> remove(String courseId);
}

/// [CourseContentProvider] that parses JSON from a [ContentSource] and caches
/// the results: the catalog and app config are memoized, and each course's
/// populated bundle is fetched + parsed once, then served from memory — so
/// opening a course is lazy (nothing course-specific loads until asked) and
/// re-opening is instant.
class CachingCourseProvider implements CourseContentProvider {
  CachingCourseProvider(this._source, {this._store});

  final ContentSource _source;

  /// Optional writable override (teacher edits); consulted before the asset.
  final CourseBundleStore? _store;

  Catalog? _catalog;
  AppConfig? _appConfig;
  final Map<String, PopulatedCourse> _courses = {};
  final Map<String, NounCollection> _nouns = {};

  @override
  Future<Catalog> catalog() async => _catalog ??= Catalog.fromJson(
    jsonDecode(await _source.catalogJson()) as Map<String, dynamic>,
  );

  @override
  Future<AppConfig> appConfig() async => _appConfig ??= AppConfig.fromJson(
    jsonDecode(await _source.appConfigJson()) as Map<String, dynamic>,
  );

  @override
  Future<PopulatedCourse> populated(String courseId) async {
    final cached = _courses[courseId];
    if (cached != null) return cached;
    // Teacher-edited override first, then the shipped asset bundle.
    final edited = await _store?.read(courseId);
    final json = edited ??
        jsonDecode(await _source.courseJson(courseId)) as Map<String, dynamic>;
    return _courses[courseId] = PopulatedCourse.fromJson(json);
  }

  @override
  Future<NounCollection> nounCollection(String langCode) async {
    final cached = _nouns[langCode];
    if (cached != null) return cached;
    try {
      final json =
          jsonDecode(await _source.sharedNounsJson(langCode))
              as Map<String, dynamic>;
      return _nouns[langCode] = NounCollection.fromJson(json);
    } catch (_) {
      // No shared noun collection for this language — serve an empty one.
      return _nouns[langCode] = const NounCollection();
    }
  }

  /// Drops the cached bundle for [courseId] (e.g. after a teacher edit or a
  /// version bump), forcing the next [populated] call to reload it.
  void invalidate(String courseId) => _courses.remove(courseId);
}
