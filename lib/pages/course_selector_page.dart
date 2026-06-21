import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/quest_data.dart';
import '../models/course.dart';
import '../models/course_session.dart';

/// Lets the learner pick a language-pair course ("speak X, learn Y"). Shown on
/// first launch and reachable later via the "Switch course" menu entry.
class CourseSelectorPage extends StatelessWidget {
  const CourseSelectorPage({super.key});

  Future<void> _pick(BuildContext context, Course course) async {
    await CourseSession.instance.setActiveCourse(course.id);
    // Apply this course's Quest chain order (no-op for courses without one).
    applyQuestOrderFromLayout(course.nav);
    if (!context.mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final courses = CourseSession.instance.courses;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Choose your course',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Elige tu curso',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                for (final course in courses) ...[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => _pick(context, course),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              '${course.speakFlag} → ${course.learnFlag}',
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    course.name,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    course.tagline,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
