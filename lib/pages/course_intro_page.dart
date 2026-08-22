import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/placement/placement_modules.dart';
import '../l10n/app_strings.dart';
import '../l10n/intro_strings.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/coin_balance_pill.dart';
import '../widgets/country_flag.dart';
import '../widgets/person_scene.dart';
import '../widgets/placement_start_sheet.dart';

/// A short, per-course "what this is and how to use it" page. Shown
/// automatically the first time a learner opens a course and reachable any
/// time from the "How it works" menu entry.
///
/// Deliberately minimal: a headline, one quiz preview **in the course's own
/// target language**, the level path this course actually has, the
/// cheat-sheet and streak cards — and a pinned action bar so "start" (and,
/// for gated courses, the placement test) is always one tap away, never at
/// the bottom of a scroll.
class CourseIntroPage extends StatelessWidget {
  const CourseIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final course = CourseSession.instance.activeCourse;
    final s = introStringsFor(course.uiLang);
    final appStrings = stringsFor(course.uiLang);
    final sample = _LangSample.forCourse(course);
    final levels = _levelChain(course);
    final hasPlacement = supportsPlacement(course);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.menuTitle),
        backgroundColor: colorScheme.surface,
        actions: const [CoinBalancePill()],
      ),
      // The always-visible action bar: start the course, and (for gated
      // courses) jump straight to the placement / starting-point options.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          // heightFactor keeps the bar hugging its content — a plain Center
          // would greedily take all the height the Scaffold offers.
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final start = FilledButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      s.startButton,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                  if (!hasPlacement) {
                    return SizedBox(width: double.infinity, child: start);
                  }
                  final placementButton = OutlinedButton.icon(
                    onPressed: () => showPlacementStartSheet(context),
                    icon: const Icon(Icons.flag_rounded, size: 20),
                    label: Text(
                      appStrings.placement.entryButton,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  );
                  // Two buttons side by side need room for both labels;
                  // narrow phones stack them instead of truncating.
                  if (constraints.maxWidth < 440) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        start,
                        const SizedBox(height: 8),
                        placementButton,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: placementButton),
                      const SizedBox(width: 12),
                      Expanded(child: start),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // ── Hero: this course, not "the app" ─────────────────────
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/QuizLogo-02.svg',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            course.name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              CourseFlagPair(
                                speakFlag: course.speakFlag,
                                learnFlag: course.learnFlag,
                                diameter: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  course.tagline,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        s.headline,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    PersonScene(personSceneForGoal(course.goal), height: 96),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  s.intro,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // ── The quiz, in this course's target language ───────────
                _FeatureSection(
                  icon: Icons.quiz_rounded,
                  accent: kSectionAccentColors[0],
                  title: s.quizTitle,
                  body: s.quizBody,
                  mockup: _QuizMockup(sample: sample),
                ),

                // ── The level path this course actually has ──────────────
                if (levels.isNotEmpty)
                  _FeatureSection(
                    icon: Icons.route_rounded,
                    accent: kSectionAccentColors[2],
                    title: s.pathTitle,
                    body: s.pathBody,
                    mockup: _PathMockup(levels: levels),
                  ),

                // ── Cheat-sheet, in the target language too ──────────────
                _FeatureSection(
                  icon: Icons.menu_book_rounded,
                  accent: kSectionAccentColors[3],
                  title: s.helpTitle,
                  body: s.helpBody,
                  mockup: _HelpMockup(sample: sample),
                ),

                // ── Streak & coins ───────────────────────────────────────
                _FeatureSection(
                  icon: Icons.bolt_rounded,
                  accent: kSectionAccentColors[1],
                  title: s.streakTitle,
                  body: s.streakBody,
                  mockup: const _StreakMockup(),
                ),

                const SizedBox(height: 12),
                _CompanionCard(title: s.companionTitle, body: s.companionBody),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The compact level-chain labels of a gated course ("A1.1", "A1.2", …,
/// "C2.2"), derived from the course's own nav so the path never drifts from
/// the content. Ungated courses yield an empty list (no path card).
List<String> _levelChain(Course course) {
  final labels = <String>[];
  for (final g in course.nav.groups) {
    final gated = g.type == NavGroupType.questChain ||
        (g.type == NavGroupType.quizzes && g.gated);
    if (!gated) continue;
    // Quest groups carry an explicit level; quiz groups encode it as the
    // first "·"-separated half of the title ("A1.1 · PRIMER CONTACTO").
    final label = (g.level ?? g.title.split('·').first).trim();
    if (label.isNotEmpty) labels.add(label);
  }
  return labels;
}

/// The per-target-language sample driving the quiz + cheat-sheet mockups, so
/// a Spanish course previews Spanish, a Chinese course Chinese — never
/// someone else's grammar.
class _LangSample {
  const _LangSample({
    required this.quizLabel,
    required this.sentenceAfterBlank,
    required this.options,
    required this.selectedIndex,
    required this.rows,
  });

  /// The little category label above the sample sentence ("Der / Die / Das?").
  final String quizLabel;

  /// What follows the `____` blank in the sample sentence.
  final String sentenceAfterBlank;

  /// The answer chips (label + color).
  final List<(String, Color)> options;
  final int selectedIndex;

  /// Three cheat-sheet rows: (highlighted word, rest, color).
  final List<(String, String, Color)> rows;

  static Color _g(String gender) =>
      NounSettings.instance.colorForGender(gender);

  /// The sample for [course], keyed by the language it teaches.
  static _LangSample forCourse(Course course) {
    final lang = course.learnLocale.split('-').first;
    switch (lang) {
      case 'es':
        return _LangSample(
          quizLabel: '¿El o la?',
          sentenceAfterBlank: ' mano es pequeña.',
          options: [('el', _g('m')), ('la', _g('f'))],
          selectedIndex: 1,
          rows: [
            ('el', 'día', _g('m')),
            ('la', 'mano', _g('f')),
            ('el', 'problema', _g('m')),
          ],
        );
      case 'en':
        return _LangSample(
          quizLabel: 'a / an / the?',
          sentenceAfterBlank: ' apple, please.',
          options: [('a', _g('m')), ('an', _g('f')), ('the', _g('n'))],
          selectedIndex: 1,
          rows: [
            ('an', 'apple', _g('f')),
            ('a', 'university', _g('m')),
            ('an', 'hour', _g('f')),
          ],
        );
      case 'zh':
        return _LangSample(
          quizLabel: '了 / 过 / 着?',
          sentenceAfterBlank: ' 北京。(wǒ qù … Běijīng)',
          options: [('了', _g('m')), ('过', _g('f')), ('着', _g('n'))],
          selectedIndex: 1,
          rows: [
            ('了', 'done · 吃了', _g('m')),
            ('过', 'ever · 去过', _g('f')),
            ('着', 'ongoing · 开着', _g('n')),
          ],
        );
      case 'cs':
        return _LangSample(
          quizLabel: 'Ten / Ta / To?',
          sentenceAfterBlank: ' pes je velký.',
          options: [('ten', _g('m')), ('ta', _g('f')), ('to', _g('n'))],
          selectedIndex: 0,
          rows: [
            ('ten', 'muž', _g('m')),
            ('ta', 'žena', _g('f')),
            ('to', 'dítě', _g('n')),
          ],
        );
      default: // German-target courses.
        return _LangSample(
          quizLabel: 'Der / Die / Das?',
          sentenceAfterBlank: ' Hund ist groß.',
          options: [('der', _g('m')), ('die', _g('f')), ('das', _g('n'))],
          selectedIndex: 0,
          rows: [
            ('der', 'Mann', _g('m')),
            ('die', 'Frau', _g('f')),
            ('das', 'Kind', _g('n')),
          ],
        );
    }
  }
}

/// The highlighted "use this alongside your main course" message.
class _CompanionCard extends StatelessWidget {
  const _CompanionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(
            icon: Icons.extension_rounded,
            color: colorScheme.primary,
            size: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One feature block: a preview mockup, then an icon + title + description.
class _FeatureSection extends StatelessWidget {
  const _FeatureSection({
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
    required this.mockup,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String body;
  final Widget mockup;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(kRadiusLarge),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              color: colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.all(16),
              child: Center(child: mockup),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconBadge(icon: icon, color: accent, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          body,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mockups ───────────────────────────────────────────────────────────────
// Small, non-interactive previews of real features, styled like the app and
// fed with the course's own target-language sample.

/// A faux quiz card: prompt, a sentence with a blank, and answer options with
/// the correct one selected — in the course's target language.
class _QuizMockup extends StatelessWidget {
  const _QuizMockup({required this.sample});

  final _LangSample sample;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sample.quizLabel,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: '____',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: sample.sentenceAfterBlank),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < sample.options.length; i++)
                _optionChip(
                  sample.options[i].$1,
                  sample.options[i].$2,
                  selected: i == sample.selectedIndex,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _optionChip(String label, Color color, {bool selected = false}) {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.16)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(kRadiusSmall),
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 5),
                Icon(Icons.check_circle_rounded, size: 15, color: color),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// The course's own pass-to-unlock chain: the first levels open, a faded
/// middle, and the final level as the goal flag.
class _PathMockup extends StatelessWidget {
  const _PathMockup({required this.levels});

  final List<String> levels;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Show at most: first two (started / next), an ellipsis, the last one.
    final compact = levels.length > 4;
    final shown = compact ? [...levels.take(2), '…', levels.last] : levels;
    return _Card(
      child: Wrap(
        spacing: 6,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            if (i > 0)
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: colorScheme.outline,
              ),
            _levelChip(
              context,
              shown[i],
              // First chip is unlocked, the rest locked; the last one gets
              // the goal flag instead of a padlock.
              state: i == 0
                  ? _LevelState.open
                  : (i == shown.length - 1
                        ? _LevelState.goal
                        : _LevelState.locked),
            ),
          ],
        ],
      ),
    );
  }

  Widget _levelChip(BuildContext context, String label,
      {required _LevelState state}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if (label == '…') {
      return Text(
        '…',
        style: textTheme.titleMedium?.copyWith(color: colorScheme.outline),
      );
    }
    final (color, icon) = switch (state) {
      _LevelState.open => (colorScheme.primary, Icons.lock_open_rounded),
      _LevelState.locked => (colorScheme.outline, Icons.lock_rounded),
      _LevelState.goal => (colorScheme.secondary, Icons.flag_rounded),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(kRadiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum _LevelState { open, locked, goal }

/// A faux Help Memory: legend pills plus a tiny color-coded table — in the
/// course's target language.
class _HelpMockup extends StatelessWidget {
  const _HelpMockup({required this.sample});

  final _LangSample sample;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (label, color) in sample.options)
                _legendPill(label, color),
            ],
          ),
          const SizedBox(height: 10),
          for (final (word, rest, color) in sample.rows) ...[
            _tableRow(word, rest, color),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }

  Widget _legendPill(String label, Color color) {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(kRadiusSmall),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tableRow(String article, String noun, Color color) {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 34,
                child: Text(
                  article,
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(noun, style: textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

/// A faux streak bar with a fill, a "best" counter and a coin payout.
class _StreakMockup extends StatelessWidget {
  const _StreakMockup();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, size: 18, color: colorScheme.secondary),
              const SizedBox(width: 6),
              Text(
                'Streak',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Icon(Icons.monetization_on_rounded,
                  size: 16, color: colorScheme.tertiary),
              const SizedBox(width: 4),
              Text(
                '+25',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'best ×5',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.7,
              minHeight: 10,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: i < 4
                        ? colorScheme.secondary
                        : colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small white "device" card the mockups sit on, for a consistent frame.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  static const EdgeInsetsGeometry padding = EdgeInsets.all(14);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
