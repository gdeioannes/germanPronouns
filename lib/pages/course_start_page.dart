import 'package:flutter/material.dart';

import '../app_router.dart';
import '../models/app_session.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../services/analytics.dart';

/// Deep-link entry point: `/start/:courseId` takes a visitor straight into a
/// course — no landing page, no course finder. Share a URL like
/// `https://languagequiz.org/#/start/en_de_ai` and the app silently signs the
/// visitor in as a learner (the app is account-free anyway), activates the
/// course, and lands on that course's home.
///
/// A returning learner following the link just switches to (or stays on) that
/// course; an unknown course id falls back to the normal entry flow.
class CourseStartPage extends StatefulWidget {
  const CourseStartPage({super.key, required this.courseId});

  final String courseId;

  @override
  State<CourseStartPage> createState() => _CourseStartPageState();
}

class _CourseStartPageState extends State<CourseStartPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final session = CourseSession.instance;
    final known = session.courses.any((c) => c.id == widget.courseId);
    if (!known) {
      // Stale/mistyped link: fall back to the normal front door.
      appRouter.go('/home');
      return;
    }

    await session.setActiveCourse(widget.courseId);
    await session.ensureActiveNavLoaded();
    await NounSettings.instance.load();
    Analytics.track('course_link_start', {'course': widget.courseId});

    // Visitors arriving signed out become learners on the spot (same as the
    // landing quick start); a signed-in teacher keeps their role.
    if (!AppSession.instance.isSignedIn) {
      AppSession.instance.signInAsLearner();
    } else if (AppSession.instance.role == UserRole.teacher) {
      appRouter.go('/back-office');
      return;
    }
    appRouter.go('/course/${widget.courseId}');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
