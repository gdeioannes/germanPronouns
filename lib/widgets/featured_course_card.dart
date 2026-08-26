import 'package:flutter/material.dart';

import '../models/course.dart';
import '../theme/app_theme.dart';
import 'country_flag.dart';

/// One featured course on the landing page: flags, name, level badge, tagline
/// and an explicit "start" affordance — a single tap begins the course (quick
/// placement, then the first quiz), so the card sells that promise up front.
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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CourseFlagPair(
                    speakFlag: course.speakFlag,
                    learnFlag: course.learnFlag,
                    diameter: 30,
                  ),
                  const Spacer(),
                  if (course.level != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
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
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                course.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                course.tagline,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(kRadiusLarge),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _startLabel[course.uiLang] ?? _startLabel[UiLang.en]!,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
