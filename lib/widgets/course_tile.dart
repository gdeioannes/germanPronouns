import 'package:flutter/material.dart';

import '../data/course_progress.dart';
import '../l10n/app_strings.dart';
import '../models/course.dart';
import 'country_flag.dart';

/// A course card shared by the course finder and the My Courses page: the
/// language-pair flags, name + level badge, tagline, and — when [progress] is
/// given — a completion bar with the same finished/accuracy/points figures as
/// the course home's overview.
///
/// The [active] course (the one currently in use) is tinted and check-marked;
/// an [archived] one renders muted. [trailing] replaces the default
/// chevron/check (the My Courses page puts its actions menu there).
class CourseTile extends StatelessWidget {
  const CourseTile({
    super.key,
    required this.course,
    this.onTap,
    this.active = false,
    this.archived = false,
    this.progress,
    this.trailing,
  });

  final Course course;
  final VoidCallback? onTap;
  final bool active;
  final bool archived;
  final CourseProgress? progress;
  final Widget? trailing;

  /// "3/24 quizzes finished · 82% · 1240 pts", in the course's own language
  /// (accuracy and points are dropped while there's nothing to report).
  String _statsLine(CourseProgress p) {
    final s = stringsFor(course.uiLang);
    final parts = ['${p.finished}/${p.total} ${s.quizzesFinished}'];
    final acc = p.accuracyPct;
    if (acc != null) parts.add('$acc%');
    if (p.score > 0) parts.add('${p.score} pts');
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget body = Row(
      children: [
        CourseFlagPair(
          speakFlag: course.speakFlag,
          learnFlag: course.learnFlag,
          diameter: 28,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      course.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
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
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                course.tagline,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress!.fractionFinished,
                    minHeight: 5,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _statsLine(progress!),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
    // Mute the course info of an archived card; its trailing actions (below)
    // stay fully opaque so restoring remains inviting.
    if (archived) body = Opacity(opacity: 0.55, child: body);

    return Card(
      color: active
          ? colorScheme.primaryContainer.withValues(alpha: 0.5)
          : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: body),
              const SizedBox(width: 4),
              trailing ??
                  Icon(
                    active
                        ? Icons.check_circle_rounded
                        : Icons.chevron_right_rounded,
                    color: active
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
