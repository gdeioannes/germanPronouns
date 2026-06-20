import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/course_catalog.dart';
import '../data/db/content_repository.dart';
import '../l10n/app_strings.dart';
import 'course.dart';

/// App-wide selected course (language pair). Holds the loaded course list (from
/// the content database) and the learner's chosen course, and exposes the
/// localized [strings] for the active course's UI language.
class CourseSession extends ChangeNotifier {
  CourseSession._();

  static final CourseSession instance = CourseSession._();

  static const String _activeKey = 'active_course_id';

  List<Course> _courses = defaultCourses;
  String? _activeCourseId;

  List<Course> get courses => _courses;

  String? get activeCourseId => _activeCourseId;

  /// Whether the learner has picked a course yet.
  bool get hasChosenCourse => _activeCourseId != null;

  /// The active course, or the first available if none/unknown is selected.
  Course get activeCourse {
    for (final course in _courses) {
      if (course.id == _activeCourseId) return course;
    }
    return _courses.isNotEmpty ? _courses.first : defaultCourses.first;
  }

  /// Localized chrome strings for the active course's UI language.
  AppStrings get strings => stringsFor(activeCourse.uiLang);

  /// Loads the chosen course id from SharedPreferences (fast — safe to await at
  /// startup). The course list defaults to [defaultCourses] until
  /// [loadCourses] reads any teacher edits from the database.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _activeCourseId = prefs.getString(_activeKey);
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
    notifyListeners();
  }

  Future<void> setActiveCourse(String id) async {
    _activeCourseId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKey, id);
    notifyListeners();
  }
}
