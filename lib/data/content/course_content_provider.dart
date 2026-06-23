import 'dart:convert';

import '../../models/content/catalog.dart';
import '../../models/content/populated_course.dart';

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
}

/// Where raw collection JSON comes from. Splitting this out keeps the caching
/// provider free of Flutter/IO so it can be unit-tested with an in-memory
/// source, and lets a future remote-DB/download source slot in unchanged.
abstract interface class ContentSource {
  Future<String> catalogJson();
  Future<String> appConfigJson();
  Future<String> courseJson(String courseId);
}

/// [CourseContentProvider] that parses JSON from a [ContentSource] and caches
/// the results: the catalog and app config are memoized, and each course's
/// populated bundle is fetched + parsed once, then served from memory — so
/// opening a course is lazy (nothing course-specific loads until asked) and
/// re-opening is instant.
class CachingCourseProvider implements CourseContentProvider {
  CachingCourseProvider(this._source);

  final ContentSource _source;

  Catalog? _catalog;
  AppConfig? _appConfig;
  final Map<String, PopulatedCourse> _courses = {};

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
    final json =
        jsonDecode(await _source.courseJson(courseId)) as Map<String, dynamic>;
    return _courses[courseId] = PopulatedCourse.fromJson(json);
  }

  /// Drops the cached bundle for [courseId] (e.g. after a teacher edit or a
  /// version bump), forcing the next [populated] call to reload it.
  void invalidate(String courseId) => _courses.remove(courseId);
}
