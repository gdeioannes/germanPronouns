import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/content/asset_course_provider.dart';
import '../data/course_catalog.dart';
import '../data/db/content_repository.dart';
import '../l10n/app_strings.dart';
import 'course.dart';
import 'nav_layout.dart';
import 'noun_settings.dart';

/// App-wide selected course (language pair). Holds the loaded course list (from
/// the content database) and the learner's chosen course, and exposes the
/// localized [strings] for the active course's UI language.
class CourseSession extends ChangeNotifier {
  CourseSession._();

  static final CourseSession instance = CourseSession._();

  static const String _activeKey = 'active_course_id';

  List<Course> _courses = defaultCourses;
  String? _activeCourseId;

  /// Navs hydrated from the JSON course bundles, by course id (see
  /// [ensureActiveNavLoaded]). The menu/home structure as data, not compiled.
  final Map<String, NavLayout> _navByCourse = {};

  List<Course> get courses => _courses;

  String? get activeCourseId => _activeCourseId;

  /// Whether the learner has picked a course yet.
  bool get hasChosenCourse => _activeCourseId != null;

  /// The active course, or the first available if none/unknown is selected. Its
  /// nav is overlaid from the JSON bundle once [ensureActiveNavLoaded] has run,
  /// so the drawer/home menu is sourced from the content collections rather than
  /// the compiled [defaultCourses] (which remain the fallback).
  Course get activeCourse {
    final base = _activeBaseCourse();
    final nav = _navByCourse[base.id];
    return nav == null ? base : base.copyWith(nav: nav);
  }

  Course _activeBaseCourse() {
    for (final course in _courses) {
      if (course.id == _activeCourseId) return course;
    }
    return _courses.isNotEmpty ? _courses.first : defaultCourses.first;
  }

  /// Loads the active course's nav from its JSON bundle (lazy + cached by the
  /// content provider) and overlays it onto [activeCourse], so the menu/home
  /// structure comes from the content collections. Idempotent; on failure keeps
  /// the compiled nav so navigation never breaks. The home and drawer await this
  /// before reading the nav.
  Future<void> ensureActiveNavLoaded() async {
    final id = _activeBaseCourse().id;
    if (_navByCourse.containsKey(id)) return;
    try {
      final populated = await courseContentProvider.populated(id);
      _navByCourse[id] = populated.course.nav;
      notifyListeners();
    } catch (_) {
      // Keep the compiled nav (fallback) if the bundle can't be loaded.
    }
  }

  /// Localized chrome strings for the active course's UI language.
  AppStrings get strings => stringsFor(activeCourse.uiLang);

  /// Pushes the active course's [CourseGating] into [NounSettings] as the unlock
  /// defaults, so each course carries its own unlock economy. The learner's own
  /// override (if any) still wins; this only sets the per-course fallback.
  void _applyActiveGating() {
    final g = _activeBaseCourse().gating;
    NounSettings.instance.applyCourseGating(
      progressionUnlockLaps: g.progressionUnlockLaps,
      questUnlockLaps: g.questUnlockLaps,
    );
  }

  /// Loads the chosen course id from SharedPreferences (fast — safe to await at
  /// startup). The course list defaults to [defaultCourses] until
  /// [loadCourses] reads any teacher edits from the database.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _activeCourseId = prefs.getString(_activeKey);
    _applyActiveGating();
  }

  /// Loads the course list from the content database (teacher-edited menus),
  /// falling back to [defaultCourses]. Done lazily so opening the database
  /// never blocks the initial route.
  Future<void> loadCourses() async {
    try {
      _courses = await (await contentRepository()).courses();
    } catch (_) {
      _courses = defaultCourses;
    }
    _applyActiveGating();
    notifyListeners();
  }

  Future<void> setActiveCourse(String id) async {
    _activeCourseId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKey, id);
    _applyActiveGating();
    notifyListeners();
  }
}
