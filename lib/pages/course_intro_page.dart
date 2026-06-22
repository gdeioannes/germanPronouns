import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/intro_strings.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/country_flag.dart';

/// A friendly, illustrated "what this app is and how to use it" page, localized
/// per course. Shown automatically the first time a learner opens a course and
/// reachable any time from the "How it works" menu entry.
///
/// The feature previews are small in-app mockups (built with widgets, styled
/// like the real quiz UI) rather than screenshots, so they always stay accurate.
class CourseIntroPage extends StatelessWidget {
  const CourseIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final course = CourseSession.instance.activeCourse;
    final s = introStringsFor(course.uiLang);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.menuTitle),
        backgroundColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                // ── Hero ──────────────────────────────────────────────────
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
                Text(
                  s.headline,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s.intro,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Philosophy / companion callout ────────────────────────
                _CompanionCard(title: s.companionTitle, body: s.companionBody),
                const SizedBox(height: 24),

                // ── Features ──────────────────────────────────────────────
                Text(
                  s.featuresHeader,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                _FeatureSection(
                  icon: Icons.quiz_rounded,
                  accent: kSectionAccentColors[0],
                  title: s.quizTitle,
                  body: s.quizBody,
                  mockup: const _QuizMockup(),
                ),
                _FeatureSection(
                  icon: Icons.bolt_rounded,
                  accent: kSectionAccentColors[1],
                  title: s.streakTitle,
                  body: s.streakBody,
                  mockup: const _StreakMockup(),
                ),
                _FeatureSection(
                  icon: Icons.menu_book_rounded,
                  accent: kSectionAccentColors[2],
                  title: s.helpTitle,
                  body: s.helpBody,
                  mockup: const _HelpMockup(),
                ),
                _FeatureSection(
                  icon: Icons.lightbulb_outline_rounded,
                  accent: kSectionAccentColors[3],
                  title: s.tipsTitle,
                  body: s.tipsBody,
                  mockup: const _TipMockup(),
                ),
                _FeatureSection(
                  icon: Icons.picture_as_pdf_rounded,
                  accent: kSectionAccentColors[1],
                  title: s.pdfTitle,
                  body: s.pdfBody,
                  mockup: const _PdfMockup(),
                ),
                _FeatureSection(
                  icon: Icons.insights_rounded,
                  accent: kSectionAccentColors[0],
                  title: s.analyticsTitle,
                  body: s.analyticsBody,
                  mockup: const _AnalyticsMockup(),
                ),

                const SizedBox(height: 8),
                Text(
                  s.closing,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(s.startButton),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      padding: const EdgeInsets.all(18),
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
            size: 40,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: textTheme.bodyMedium?.copyWith(height: 1.4),
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
            // Preview canvas.
            Container(
              width: double.infinity,
              color: colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.all(16),
              child: Center(child: mockup),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconBadge(icon: icon, color: accent, size: 36),
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
                          style: textTheme.bodyMedium?.copyWith(
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
// Small, non-interactive previews of real features, styled like the app.

Color _genderColor(String g) => NounSettings.instance.colorForGender(g);

/// A faux quiz card: prompt, a sentence with a blank, and answer options with
/// the correct one selected.
class _QuizMockup extends StatelessWidget {
  const _QuizMockup();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Der / Die / Das?',
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
                const TextSpan(text: ' Hund ist groß.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _optionChip('der', _genderColor('m'), selected: true),
              const SizedBox(width: 8),
              _optionChip('die', _genderColor('f')),
              const SizedBox(width: 8),
              _optionChip('das', _genderColor('n')),
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

/// A faux streak bar with a fill and a "best" counter.
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

/// A faux Help Memory: gender legend pills plus a tiny color-coded table.
class _HelpMockup extends StatelessWidget {
  const _HelpMockup();

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
              _legendPill('der', _genderColor('m')),
              _legendPill('die', _genderColor('f')),
              _legendPill('das', _genderColor('n')),
            ],
          ),
          const SizedBox(height: 10),
          _tableRow('der', 'Mann', _genderColor('m')),
          const SizedBox(height: 4),
          _tableRow('die', 'Frau', _genderColor('f')),
          const SizedBox(height: 4),
          _tableRow('das', 'Kind', _genderColor('n')),
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

/// A faux tip card, matching the Help Memory tip styling.
class _TipMockup extends StatelessWidget {
  const _TipMockup();

  @override
  Widget build(BuildContext context) {
    final accent = kSectionAccentColors[3];
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(kRadiusSmall),
          border: Border.all(color: accent.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline_rounded, size: 18, color: accent),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tip',
                    style: textTheme.labelMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'After a preposition like "mit", the article takes the '
                    'dative: mit dem Hund.',
                    style: textTheme.bodySmall?.copyWith(height: 1.3),
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

/// A faux PDF preview with the brand header bar and a download cue.
class _PdfMockup extends StatelessWidget {
  const _PdfMockup();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(kRadiusSmall),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_rounded,
                    size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Help Memory',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.picture_as_pdf_rounded,
                    size: 14, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(0.9, colorScheme),
                const SizedBox(height: 6),
                _line(0.65, colorScheme),
                const SizedBox(height: 6),
                _line(0.8, colorScheme),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(kRadiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.download_rounded,
                            size: 14, color: colorScheme.primary),
                        const SizedBox(width: 5),
                        Text(
                          'Save as PDF',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(double widthFactor, ColorScheme colorScheme) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 7,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// A faux analytics view: a small bar chart and an accuracy figure.
class _AnalyticsMockup extends StatelessWidget {
  const _AnalyticsMockup();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const heights = [0.4, 0.7, 0.55, 0.85, 1.0];
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final h in heights)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      width: 14,
                      height: 56 * h,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.35 + 0.5 * h,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '82%',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'accuracy',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
  const _Card({required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsetsGeometry padding;

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
