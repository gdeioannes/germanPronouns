import 'package:flutter/material.dart';

import '../data/course_progress.dart';
import '../data/placement/placement_modules.dart';
import '../data/placement/placement_test.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../pages/placement_test_page.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';

/// Opens the "where should this course start?" sheet and runs whichever route
/// the learner picks through to the end.
///
/// Returns true when the course's starting point actually changed, so the
/// caller can reload its rows. All three routes converge on [_applyPlacement],
/// which is the only place that writes.
Future<bool> showPlacementStartSheet(BuildContext context) async {
  final course = CourseSession.instance.activeCourse;
  final modules = placementModules(course);
  if (modules.isEmpty) return false;

  final choice = await showModalBottomSheet<_PlacementRoute>(
    context: context,
    // The learner shell's RoomPanel door tab covers non-root sheets.
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _StartSheet(modules: modules),
  );
  if (choice == null || !context.mounted) return false;

  switch (choice) {
    case _PlacementRoute.test:
      return _runPlacementTest(context, modules);
    case _PlacementRoute.pick:
      final index = await _pickLevel(context, modules);
      if (index == null || !context.mounted) return false;
      return _applyPlacement(context, modules, index, source: 'manual');
    case _PlacementRoute.reset:
      // "Start from the beginning" is the same operation with the frontier at
      // the very first module: wipe, open nothing.
      return _applyPlacement(context, modules, 0, source: 'reset');
  }
}

/// Which of the three starting points the learner chose.
enum _PlacementRoute { test, pick, reset }

Future<bool> _runPlacementTest(
  BuildContext context,
  List<PlacementModule> modules,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final strings = CourseSession.instance.strings.placement;
  final questions = await buildPlacementTest(modules);
  if (!context.mounted) return false;
  // A course can be gated but still have too few auto-checkable questions (a
  // chain of reading/speaking quizzes, say). Say so plainly rather than showing
  // a two-question "test" — the manual picker is still there.
  if (questions.length < modules.length) {
    messenger.showSnackBar(SnackBar(content: Text(strings.notEnoughContent)));
    return false;
  }

  Analytics.track('placement_test_started', {
    'course': CourseSession.instance.activeCourse.id,
    'questions': questions.length,
  });
  final index = await Navigator.of(context, rootNavigator: true).push<int>(
    MaterialPageRoute(
      builder: (_) =>
          PlacementTestPage(modules: modules, questions: questions),
    ),
  );
  if (index == null || !context.mounted) return false;
  return _applyPlacement(context, modules, index, source: 'test');
}

/// The self-declared level picker.
Future<int?> _pickLevel(
  BuildContext context,
  List<PlacementModule> modules,
) async {
  final strings = CourseSession.instance.strings;
  final s = strings.placement;
  return showDialog<int>(
    context: context,
    useRootNavigator: true,
    builder: (context) => AlertDialog(
      title: Text(s.pickTitle),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.pickBody, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              for (var i = 0; i < modules.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(modules[i].title),
                  onTap: () => Navigator.of(context).pop(i),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
      ],
    ),
  );
}

/// Wipes the course and reopens it at [moduleIndex].
///
/// Every route lands here, so the destructive confirmation exists once. The
/// wipe is unconditional (a fresh starting point shouldn't leave half of an old
/// run behind), but the learner is only *asked* when there is something to
/// lose — and a cancel writes nothing at all.
Future<bool> _applyPlacement(
  BuildContext context,
  List<PlacementModule> modules,
  int moduleIndex, {
  required String source,
}) async {
  final course = CourseSession.instance.activeCourse;
  final strings = CourseSession.instance.strings;
  final s = strings.placement;
  final messenger = ScaffoldMessenger.of(context);
  final module = modules[moduleIndex];

  final progress = (await loadCourseProgress([course]))[course.id];
  if (!context.mounted) return false;

  if (progress != null && progress.hasActivity) {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: Text(s.wipeTitle),
        content: Text(
          s.wipeBody
              .replaceAll('{n}', '${progress.finished}')
              .replaceAll('{level}', module.shortTitle),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(s.wipeConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return false;
  }

  await clearCourseProgress(course);
  await NounSettings.instance.setPlacementUnlocked(
    courseRefs: [for (final m in modules) ...m.quizRefs],
    unlocked: refsUnlockedUpTo(modules, moduleIndex),
  );
  Analytics.track('placement_applied', {
    'course': course.id,
    'module': module.id,
    'source': source,
  });
  messenger.showSnackBar(
    SnackBar(content: Text(s.applied.replaceAll('{level}', module.shortTitle))),
  );
  return true;
}

/// The three-option sheet itself.
class _StartSheet extends StatelessWidget {
  const _StartSheet({required this.modules});

  final List<PlacementModule> modules;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = CourseSession.instance.strings.placement;
    final questionCount = modules.length * kPlacementQuestionsPerModule;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.entryTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              s.entryBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _option(
              context,
              icon: Icons.checklist_rounded,
              title: s.optionTestTitle,
              body: s.optionTestBody.replaceAll('{n}', '$questionCount'),
              route: _PlacementRoute.test,
              emphasized: true,
            ),
            const SizedBox(height: 10),
            _option(
              context,
              icon: Icons.tune_rounded,
              title: s.optionPickTitle,
              body: s.optionPickBody,
              route: _PlacementRoute.pick,
            ),
            const SizedBox(height: 10),
            _option(
              context,
              icon: Icons.restart_alt_rounded,
              title: s.optionResetTitle,
              body: s.optionResetBody,
              route: _PlacementRoute.reset,
            ),
            const SizedBox(height: 16),
            Text(
              s.noRewardsNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
    required _PlacementRoute route,
    bool emphasized = false,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: emphasized
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
          : theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(kRadiusLarge),
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadiusLarge),
        onTap: () => Navigator.of(context).pop(route),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
