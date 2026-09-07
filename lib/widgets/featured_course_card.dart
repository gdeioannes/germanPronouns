import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/brand_palette.dart';
import 'country_flag.dart';

/// One featured course on the landing page, drawn as a row inside the
/// showcase container (see `FeaturedCourseShowcase`): flags, name with level
/// badge, tagline, and an explicit "start" pill — a single tap begins the
/// course (quick placement, then the first quiz), so the row sells that
/// promise up front.
class FeaturedCourseCard extends StatelessWidget {
  const FeaturedCourseCard({super.key, required this.course, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  /// The card speaks the course's own UI language, like the finder's tiles.
  static const Map<UiLang, String> _startLabel = {
    UiLang.en: 'Start now',
    UiLang.de: 'Jetzt starten',
    UiLang.es: 'Empezar ahora',
    UiLang.zh: '立即开始',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: const Color(kBrandNavy).withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // On narrow (phone) rows the labelled pill would squeeze the
              // course name into a sliver — collapse it to a round arrow.
              final compact = constraints.maxWidth < 400;
              return Row(
                children: [
                  CourseFlagPair(
                    speakFlag: course.speakFlag,
                    learnFlag: course.learnFlag,
                    diameter: 34,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                course.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            if (course.level != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  course.level!,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          course.tagline,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  _StartPill(
                    label: compact
                        ? null
                        : _startLabel[course.uiLang] ?? _startLabel[UiLang.en]!,
                    enabled: onTap != null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The row's call-to-action: a navy pill echoing the primary button style.
/// It is decorative (the whole row is the tap target) but makes the one-tap
/// promise explicit in the course's own language. A null [label] renders the
/// compact form — a round arrow badge for narrow rows.
class _StartPill extends StatelessWidget {
  const _StartPill({required this.label, required this.enabled});

  final String? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final background = enabled
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final foreground = enabled
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    if (label == null) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(Icons.arrow_forward_rounded, size: 18, color: foreground),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward_rounded, size: 16, color: foreground),
        ],
      ),
    );
  }
}

/// The showcase itself: one elevated container holding the featured course
/// rows, separated by hairline dividers — a curated menu rather than a stack
/// of loose cards. Rounded corners clip the rows' ink so hover/press stays
/// inside the frame.
class FeaturedCourseShowcase extends StatelessWidget {
  const FeaturedCourseShowcase({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(kBrandNavy).withValues(alpha: 0.10),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(kBrandNavy).withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: colorScheme.outlineVariant,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}
