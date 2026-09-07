import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_router.dart';
import '../data/placement/quick_start.dart';
import '../models/app_session.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../services/site_lang.dart';
import '../theme/brand_palette.dart';
import '../widgets/feature_poll.dart';
import '../widgets/featured_course_card.dart';
import '../widgets/person_scene.dart';

/// The app's front door: a split brand poster. One pane is a navy field with
/// the wordmark and the People cast greeting in four languages; the other IS
/// the offer — three featured courses a visitor can start with a single tap
/// (quick placement test, then straight into the first quiz). Which courses,
/// and in which language, comes from the URL's `?lang=` parameter (so shared
/// links can lead with specific courses) or the browser language.
///
/// Learners enter directly (no account); teachers unlock the back office with
/// the local passcode behind a quiet footer link. The full course finder stays
/// one tap away behind "More courses".
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.startInTeacherMode = false});

  /// Opens directly in teacher-passcode mode — used when a remembered teacher
  /// returns and just needs to re-enter the passcode.
  final bool startInTeacherMode;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passcodeController = TextEditingController();
  late bool _teacherMode = widget.startInTeacherMode;
  String? _error;

  /// Site language(s) from the URL's `?lang=` parameter or the browser,
  /// resolved once — they pick the landing copy and the featured courses.
  late final List<UiLang> _langs = siteLangs();

  /// Guards against a second card tap while the quick start is preparing.
  bool _starting = false;

  // Landing copy in the primary site language (this screen renders before any
  // course — and thus any AppStrings bundle — is chosen).
  static const Map<UiLang, String> _titleText = {
    UiLang.en: 'Pick a course, start right away',
    UiLang.de: 'Wähle einen Kurs und leg direkt los',
    UiLang.es: 'Elige un curso y empieza ya',
    UiLang.zh: '选择课程，马上开始',
  };
  static const Map<UiLang, String> _subtitleText = {
    UiLang.en:
        'One tap: a short placement, then your first quiz. '
        'Free, no account needed.',
    UiLang.de:
        'Ein Tipp: kurze Einstufung, dann dein erstes Quiz. '
        'Kostenlos, ohne Konto.',
    UiLang.es:
        'Un toque: una breve prueba de nivel y tu primer quiz. '
        'Gratis, sin cuenta.',
    UiLang.zh: '轻点一下：快速定级，然后开始第一个测验。免费，无需注册。',
  };
  static const Map<UiLang, String> _moreCoursesText = {
    UiLang.en: 'More courses',
    UiLang.de: 'Alle Kurse ansehen',
    UiLang.es: 'Ver todos los cursos',
    UiLang.zh: '查看全部课程',
  };

  Future<void> _startCourse(Course course) async {
    if (_starting) return;
    setState(() => _starting = true);
    try {
      await quickStartCourse(course);
    } finally {
      // Normally this page is gone by now (signing in re-routes); if the flow
      // bailed early, re-arm the cards.
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  void _submitTeacher() {
    final ok = AppSession.instance.signInAsTeacher(_passcodeController.text);
    if (!ok) {
      setState(() => _error = 'Incorrect passcode.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          if (wide) {
            return Row(
              children: [
                Expanded(flex: 5, child: _PosterPane(compact: false)),
                Expanded(flex: 6, child: _actionPane()),
              ],
            );
          }
          // Stacked: actions first so the enter button sits in easy reach,
          // the brand poster grounding the bottom of the screen.
          return Column(
            children: [
              Expanded(child: _actionPane()),
              SizedBox(
                height: (constraints.maxHeight * 0.40).clamp(240.0, 380.0),
                child: _PosterPane(compact: true),
              ),
            ],
          );
        },
      ),
    );
  }

  /// The light half: one welcome + one action (or the passcode form), with
  /// the teacher door demoted to a quiet footer link.
  Widget _actionPane() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 56),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_teacherMode) ...[
                      Text(
                        _titleText[_langs.first] ?? _titleText[UiLang.en]!,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _subtitleText[_langs.first] ??
                            _subtitleText[UiLang.en]!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // The offer itself: three courses in one showcase frame,
                      // a tap on any row starting that course.
                      FeaturedCourseShowcase(
                        children: [
                          for (final course in featuredCourses(
                            _langs,
                            CourseSession.instance.courses,
                          ))
                            FeaturedCourseCard(
                              course: course,
                              onTap: _starting
                                  ? null
                                  : () => _startCourse(course),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Everything else (the full finder) stays one tap away.
                      TextButton.icon(
                        onPressed: _starting
                            ? null
                            : () {
                                AppSession.instance.signInAsLearner();
                                // An earlier visitor may already have a course
                                // (the guard would resume it) — this button
                                // explicitly promises the finder.
                                appRouter.go('/courses');
                              },
                        icon: const Icon(Icons.search_rounded, size: 18),
                        label: Text(
                          _moreCoursesText[_langs.first] ??
                              _moreCoursesText[UiLang.en]!,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          textStyle: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Who makes this — readable before signing in. Set in
                      // the display face like the heading above, a size down,
                      // so it reads as part of the invitation rather than as
                      // corner chrome.
                      Center(
                        child: TextButton(
                          onPressed: () => context.push('/about-me'),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            textStyle: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('About me'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // The roadmap poll, offered before signing in: returning
                      // learners land here every visit, so it is the one place
                      // everybody passes through. Kept below "About me" in the
                      // hierarchy, but in the link colour — muted grey read as
                      // disabled rather than tappable.
                      Center(
                        child: TextButton.icon(
                          onPressed: () => showFeaturePoll(
                            context,
                            source: kFeaturePollSourceLogin,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            textStyle: textTheme.bodyLarge,
                          ),
                          icon: const Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                          ),
                          label: Text(
                            CourseSession.instance.strings.featurePollOpen,
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Back office',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passcodeController,
                        autofocus: true,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Teacher passcode',
                          errorText: _error,
                          prefixIcon: const Icon(Icons.lock_rounded),
                        ),
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        onSubmitted: (_) => _submitTeacher(),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _submitTeacher,
                        child: const Text('Enter back office'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {
                          _teacherMode = false;
                          _error = null;
                          _passcodeController.clear();
                        }),
                        child: const Text('Back'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Teacher access is a local gate, not secure sign-in.',
                        textAlign: TextAlign.center,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Immediate response to a card tap: dim the landing and spin while
          // the placement test is prepared (the test replaces this page).
          if (_starting)
            Positioned.fill(
              child: ColoredBox(
                color: colorScheme.surface.withValues(alpha: 0.7),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          // The staff door: present but quiet, out of the learner's way.
          if (!_teacherMode && !_starting)
            Positioned(
              right: 8,
              bottom: 4,
              child: TextButton(
                onPressed: () => setState(() => _teacherMode = true),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  textStyle: textTheme.labelMedium,
                ),
                child: const Text('Teacher sign in'),
              ),
            ),
        ],
      ),
    );
  }
}

/// The navy brand field: wordmark, promise line and the greeting cast.
/// [compact] tightens spacing and type for the stacked phone layout.
class _PosterPane extends StatelessWidget {
  const _PosterPane({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: const Color(kBrandNavy),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: compact ? 20 : 48,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Language Quiz',
            textAlign: TextAlign.center,
            style:
                (compact ? textTheme.headlineMedium : textTheme.displayMedium)
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: compact ? 4 : 8),
          Text(
            'Free interactive courses · A1–C2',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFC8D2E0),
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: compact ? 18 : 40),
          // The cast greets in the app's four course languages. FittedBox
          // scales the scene down on narrow panes instead of clipping it.
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: PersonScene(
                PersonSceneKind.greeters,
                height: compact ? 120 : 210,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
