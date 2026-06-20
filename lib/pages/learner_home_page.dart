import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quest_data.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import 'course_home_page.dart';
import 'course_intro_page.dart';

/// The learner-facing entry point: opens the active course on its overview
/// [CourseHomePage] (history, share of quizzes finished, and the global PDF),
/// from which the learner picks a quiz to practice.
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
    setState(() => _home = const CourseHomePage());
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

  @override
  Widget build(BuildContext context) =>
      _home ?? const Scaffold(body: SizedBox.shrink());
}
