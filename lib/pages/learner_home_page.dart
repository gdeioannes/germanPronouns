import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/course_catalog.dart';
import '../data/quest_data.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../widgets/app_drawer.dart';
import 'course_intro_page.dart';

/// The learner-facing entry point: opens the active course on the quiz the user
/// last visited (within that course), or the course's first quiz.
class LearnerHomePage extends StatefulWidget {
  const LearnerHomePage({super.key});

  @override
  State<LearnerHomePage> createState() => _LearnerHomePageState();
}

class _LearnerHomePageState extends State<LearnerHomePage> {
  Widget? _home;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await NounSettings.instance.load();
    await CourseSession.instance.loadCourses();
    final course = CourseSession.instance.activeCourse;
    // Apply this course's Quest chain order before any quiz can unlock the next.
    applyQuestOrderFromLayout(course.nav);
    if (!mounted) return;
    setState(() => _home = _resumeHome(course));
    await _maybeShowIntro(course.id);
  }

  /// Shows the course intro page the first time this course is opened, then
  /// remembers it so it isn't shown again (it stays reachable from the menu).
  Future<void> _maybeShowIntro(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'course_intro_seen_$courseId';
    if (prefs.getBool(key) ?? false) return;
    await prefs.setBool(key, true);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CourseIntroPage()),
    );
  }

  /// Resumes within the active [course]: the last-opened quiz if it belongs to
  /// this course, else the course's first quiz (the default course keeps its
  /// original last-page resume).
  Widget _resumeHome(Course course) {
    final navRefs = <String>{
      for (final group in course.nav.groups)
        if (group.type == NavGroupType.quizzes)
          for (final item in group.items) item.ref,
    };
    final lastId = NounSettings.instance.lastContentId;
    if (lastId != null && navRefs.contains(lastId)) {
      return buildQuizPageForContent(lastId);
    }
    if (course.id == kDefaultCourseId) {
      return buildAppPage(
        appPageFromName(NounSettings.instance.lastPage) ?? AppPage.pronouns,
      );
    }
    for (final group in course.nav.groups) {
      if (group.type == NavGroupType.quizzes && group.items.isNotEmpty) {
        return buildQuizPageForContent(group.items.first.ref);
      }
    }
    return buildAppPage(AppPage.pronouns);
  }

  @override
  Widget build(BuildContext context) =>
      _home ?? const Scaffold(body: SizedBox.shrink());
}
