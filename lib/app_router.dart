import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/noun_progression_data.dart';
import 'data/quest_data.dart';
import 'models/app_session.dart';
import 'models/course_session.dart';
import 'pages/apartment_page.dart';
import 'pages/back_office/back_office_home_page.dart';
import 'pages/course_intro_page.dart';
import 'pages/course_selector_page.dart';
import 'pages/learner_home_page.dart';
import 'pages/login_page.dart';
import 'pages/settings_page.dart';
import 'pages/word_library_page.dart';
import 'widgets/app_drawer.dart';
import 'widgets/mystery_bottom_bar.dart';
import 'widgets/noun_progression_quiz_loader.dart';
import 'widgets/quest_quiz_loader.dart';

/// The app's single source of navigation truth.
///
/// Replaces the old imperative AuthGate + `Navigator.pushReplacement` flow: the
/// URL now drives which screen is shown, so the browser back/forward buttons
/// (web) and the system back button/gesture (Android, desktop) work, and a
/// learner can deep-link or refresh straight onto any quiz.
///
/// Switching quizzes uses `context.go(...)` (a *replace* — keeping the flat
/// stack the app always had) while overlays that should return to where they
/// were opened (the course intro, the in-quiz word library) use
/// `context.push(...)`.
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  // Re-run [_guard] whenever sign-in or the chosen course changes, so signing
  // in/out or picking a course redirects without any manual navigation.
  refreshListenable: Listenable.merge([
    AppSession.instance,
    CourseSession.instance,
  ]),
  redirect: _guard,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(
        startInTeacherMode:
            AppSession.instance.rememberedRole == UserRole.teacher,
      ),
    ),
    GoRoute(
      path: '/courses',
      builder: (context, state) => const CourseSelectorPage(),
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) => const CourseIntroPage(),
    ),
    GoRoute(
      // Stable alias used throughout the app (drawer home tile, post-login,
      // resets, fallbacks). Resolves to the active course's own home, or the
      // course picker when none is chosen yet.
      path: '/home',
      redirect: (context, state) => homeLocation(),
    ),
    GoRoute(
      // The room mini-game — a top-level route (outside the learner shell) so it
      // opens full-screen over everything, without the room door at its bottom.
      path: '/apartment',
      builder: (context, state) => const ApartmentPage(),
    ),
    GoRoute(
      path: '/back-office',
      builder: (context, state) => const BackOfficeHomePage(),
    ),
    // Every learner content screen sits inside this shell, which pins the room
    // door ("???") to the bottom — so the room is always one tap away. Sign-in /
    // onboarding, the back office and the room itself stay outside it.
    ShellRoute(
      builder: (context, state, child) => _LearnerShell(child: child),
      routes: [
        GoRoute(
          // Each course has its own addressable home, so switching course is a
          // real navigation (distinct URL) and browser back/forward move between
          // course homes — no hidden "which course am I on?" state.
          path: '/course/:courseId',
          redirect: (context, state) =>
              courseExists(state.pathParameters['courseId']!)
                  ? null
                  : homeLocation(),
          // Keyed by the course id: `/course/A` and `/course/B` match the same
          // route template, so without a param-derived key go_router reuses the
          // page (and its State) and the home never reloads on switch.
          pageBuilder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            return MaterialPage(
              key: ValueKey('course-$courseId'),
              child: LearnerHomePage(courseId: courseId),
            );
          },
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const WordLibraryPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/quiz/:id',
          builder: (context, state) =>
              buildQuizPageForContent(state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/quest/:key',
          // A stale link to a removed/renamed quiz falls back home rather than
          // throwing on the null entry.
          redirect: (context, state) =>
              questEntryByKey(state.pathParameters['key']!) == null
                  ? '/home'
                  : null,
          // Keyed by the quest key: every `/quest/:key` shares one page key (the
          // route template), so without a param key go_router reuses the loader's
          // State and its already-resolved quiz when switching quests.
          builder: (context, state) {
            final key = state.pathParameters['key']!;
            return QuestQuizLoader(
              key: ValueKey('quest-$key'),
              entry: questEntryByKey(key)!,
            );
          },
        ),
        GoRoute(
          path: '/noun/:key',
          redirect: (context, state) =>
              nounEntryByKey(state.pathParameters['key']!) == null
                  ? '/home'
                  : null,
          builder: (context, state) {
            final key = state.pathParameters['key']!;
            return NounProgressionQuizLoader(
              key: ValueKey('noun-$key'),
              entry: nounEntryByKey(key)!,
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Page not found'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go home'),
          ),
        ],
      ),
    ),
  ),
);

/// The persistent shell around every learner content screen: the page on top,
/// the always-present room door ("???") pinned at the bottom. One shared bar for
/// the whole learner area, instead of one per page.
class _LearnerShell extends StatelessWidget {
  const _LearnerShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const MysteryBottomBar(),
      ],
    );
  }
}

/// The auth/onboarding gate, expressed as redirects (this is what the old
/// [AuthGate] widget did imperatively):
///
///  * not signed in → `/login`;
///  * a signed-in teacher → the back office (learner screens stay reachable so
///    the back office's "Open learner view" preview still works);
///  * a learner who hasn't chosen a course yet → `/courses`.
String? _guard(BuildContext context, GoRouterState state) {
  final session = AppSession.instance;
  final loc = state.matchedLocation;

  if (!session.isSignedIn) {
    return loc == '/login' ? null : '/login';
  }
  // Signed in but still on the login screen — send them to the right home.
  if (loc == '/login') {
    return session.role == UserRole.teacher ? '/back-office' : '/home';
  }
  if (session.role == UserRole.learner) {
    // The back office is teacher-only.
    if (loc.startsWith('/back-office')) return '/home';
    // First-run learners must pick a course before any learner screen.
    if (!CourseSession.instance.hasChosenCourse && loc != '/courses') {
      return '/courses';
    }
  }
  return null;
}

/// Location of the active course's home, or the course picker when the learner
/// hasn't chosen one yet. `/home` is a stable alias that redirects here, so
/// callers can keep navigating to `/home` without knowing the course id.
String homeLocation() {
  final id = CourseSession.instance.activeCourseId;
  return id == null ? '/courses' : '/course/$id';
}

/// Whether [id] names a known course — guards `/course/:courseId` against stale
/// deep links (which fall back to [homeLocation]).
bool courseExists(String id) =>
    CourseSession.instance.courses.any((course) => course.id == id);

/// Looks up a Quest entry by its stable [key] (as carried in `/quest/:key`), or
/// null if none match — e.g. a stale deep link, in which case the route
/// redirects home.
QuestEntry? questEntryByKey(String key) {
  for (final entry in questEntries) {
    if (entry.key == key) return entry;
  }
  return null;
}

/// Looks up a noun-progression entry by its [key] (`/noun/:key`), or null if
/// none match.
NounProgressionEntry? nounEntryByKey(String key) {
  for (final entry in nounProgressionEntries) {
    if (entry.key == key) return entry;
  }
  return null;
}
