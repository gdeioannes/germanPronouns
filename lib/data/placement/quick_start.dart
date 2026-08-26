import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_router.dart';
import '../../models/app_session.dart';
import '../../models/course.dart';
import '../../models/course_session.dart';
import '../../models/nav_layout.dart';
import '../../models/noun_settings.dart';
import '../../pages/placement_test_page.dart';
import '../../services/analytics.dart';
import '../noun_progression_data.dart';
import '../quest_data.dart';
import 'placement_modules.dart';
import 'placement_test.dart';

/// The landing page's one-tap fast path: makes [course] the active course and
/// takes the visitor straight into its placement test, then straight into the
/// first quiz of the level they placed into — no finder, no course intro, no
/// course home to scroll first. Those screens still exist for the returning
/// learner; this path is for the very first minute.
///
/// Courses without a placeable progression (or without enough auto-checkable
/// questions) skip the test and open the course's first quiz directly. Backing
/// out of the test leaves the learner on the course home — nothing is written.
Future<void> quickStartCourse(Course course) async {
  final prefs = await SharedPreferences.getInstance();
  // The auto-pushed course intro would be one more screen between the tap and
  // the quiz — mark it seen (it stays reachable from the course menu).
  await prefs.setBool('course_intro_seen_${course.id}', true);

  await CourseSession.instance.setActiveCourse(course.id);
  await CourseSession.instance.ensureActiveNavLoaded();
  await NounSettings.instance.load();

  final active = CourseSession.instance.activeCourse;
  Analytics.track('landing_quick_start', {'course': active.id});

  // Build the test while the landing page is still up (it shows the spinner):
  // signing in earlier would swap to the course home and leave the visitor
  // staring at it for however long the course content takes to load.
  final modules = placementModules(active);
  var questions = const <PlacementQuestion>[];
  if (modules.isNotEmpty) {
    questions = await buildPlacementTest(modules);
  }
  final runTest = modules.isNotEmpty && questions.length >= modules.length;

  // Signing in flips the router's guard: the course home renders underneath
  // while the placement test (pushed on the root navigator) covers it.
  AppSession.instance.signInAsLearner();

  if (!runTest) {
    final first = firstQuizLocation(active);
    if (first != null) appRouter.go(first);
    return;
  }

  // Let the router finish swapping to the course home before pushing: a
  // pageless route is anchored to the page below it, and one anchored to the
  // outgoing landing page would be disposed along with it.
  await WidgetsBinding.instance.endOfFrame;

  Analytics.track('placement_test_started', {
    'course': active.id,
    'questions': questions.length,
    'source': 'landing',
  });
  final index = await rootNavigatorKey.currentState!.push<int>(
    MaterialPageRoute(
      builder: (_) => PlacementTestPage(modules: modules, questions: questions),
    ),
  );
  // Backed out: stay on the course home the router already shows.
  if (index == null) return;
  // A brand-new course has no progress to wipe, so this writes the unlock
  // set directly instead of going through the start sheet's confirm flow.
  await NounSettings.instance.setPlacementUnlocked(
    courseRefs: [for (final m in modules) ...m.quizRefs],
    unlocked: refsUnlockedUpTo(modules, index),
  );
  Analytics.track('placement_applied', {
    'course': active.id,
    'module': modules[index].id,
    'source': 'landing',
  });
  appRouter.go(_locationForRef(modules[index].quizRefs.first));
}

/// A placement ref is either a `QuizContent.id` (gated quizzes group) or a
/// Quest entry key (quest-chain slice) — the same two namespaces the placement
/// test itself draws from.
String _locationForRef(String ref) {
  for (final entry in questEntries) {
    if (entry.key == ref) return '/quest/$ref';
  }
  return '/quiz/$ref';
}

/// The very first quiz of [course] in its nav order, as a router location —
/// where the fast path lands when there is no placement test to offer.
String? firstQuizLocation(Course course) {
  for (final group in course.nav.groups) {
    switch (group.type) {
      case NavGroupType.quizzes:
        for (final item in group.items) {
          if (!item.hidden) return '/quiz/${item.ref}';
        }
      case NavGroupType.questChain:
        for (final entry in questEntries) {
          if (group.level == null || entry.levelLabel == group.level) {
            return '/quest/${entry.key}';
          }
        }
      case NavGroupType.nounChain:
        if (nounProgressionEntries.isNotEmpty) {
          return '/noun/${nounProgressionEntries.first.key}';
        }
      case NavGroupType.links:
        break;
    }
  }
  return null;
}
