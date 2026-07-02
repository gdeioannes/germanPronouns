import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/course_progress.dart';
import '../data/quest_data.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../widgets/course_tile.dart';

// Localized chrome, keyed by the active course's UI language (a course is
// always active by the time this page is reachable).
const Map<UiLang, String> _titleText = {
  UiLang.en: 'My courses',
  UiLang.es: 'Mis cursos',
  UiLang.de: 'Meine Kurse',
};
const Map<UiLang, String> _activeText = {
  UiLang.en: 'Active',
  UiLang.es: 'Activos',
  UiLang.de: 'Aktiv',
};
const Map<UiLang, String> _archivedText = {
  UiLang.en: 'Archived',
  UiLang.es: 'Archivados',
  UiLang.de: 'Archiviert',
};
const Map<UiLang, String> _archiveAction = {
  UiLang.en: 'Archive',
  UiLang.es: 'Archivar',
  UiLang.de: 'Archivieren',
};
const Map<UiLang, String> _restoreAction = {
  UiLang.en: 'Restore',
  UiLang.es: 'Restaurar',
  UiLang.de: 'Wiederherstellen',
};
const Map<UiLang, String> _deleteAction = {
  UiLang.en: 'Delete',
  UiLang.es: 'Eliminar',
  UiLang.de: 'Löschen',
};
const Map<UiLang, String> _deleteTitle = {
  UiLang.en: 'Delete course?',
  UiLang.es: '¿Eliminar el curso?',
  UiLang.de: 'Kurs löschen?',
};

/// `{course}` is replaced with the course name.
const Map<UiLang, String> _deleteBody = {
  UiLang.en:
      'This permanently deletes all your progress in "{course}" — scores, '
      'streaks, history and completed quizzes. The course stays in the '
      'catalog, so you can start it again from zero.',
  UiLang.es:
      'Esto elimina permanentemente todo tu progreso en «{course}»: '
      'puntuaciones, rachas, historial y quizzes completados. El curso sigue '
      'en el catálogo, así que puedes empezarlo de nuevo desde cero.',
  UiLang.de:
      'Damit wird dein gesamter Fortschritt in „{course}" endgültig gelöscht — '
      'Punkte, Serien, Verlauf und abgeschlossene Quizze. Der Kurs bleibt im '
      'Katalog und kann jederzeit wieder von vorn begonnen werden.',
};
const Map<UiLang, String> _findNewText = {
  UiLang.en: 'Find a new course',
  UiLang.es: 'Encontrar un curso nuevo',
  UiLang.de: 'Neuen Kurs finden',
};

/// The learner's courses-taken management page: every started course with its
/// progress, most recent first. The current course is marked (and protected —
/// switch away before archiving or deleting it); any other course can be
/// switched to by tapping, archived into a muted "not active" section (and
/// restored from it), or deleted entirely after a warning — which wipes all of
/// its progress data.
class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  Map<String, CourseProgress> _progress = const {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final session = CourseSession.instance;
    final started = [
      for (final c in session.courses)
        if (session.startedCourseIds.contains(c.id)) c,
    ];
    if (started.isEmpty) return;
    final progress = await loadCourseProgress(started);
    if (mounted) setState(() => _progress = progress);
  }

  /// Switches to [course] and opens its home (same flow as the finder).
  Future<void> _open(Course course) async {
    await CourseSession.instance.setActiveCourse(course.id);
    applyQuestOrderFromLayout(course.nav);
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _archive(Course course) async {
    await CourseSession.instance.archiveCourse(course.id);
    if (mounted) setState(() {});
  }

  Future<void> _restore(Course course) async {
    await CourseSession.instance.unarchiveCourse(course.id);
    if (mounted) setState(() {});
  }

  /// Confirms with an all-data-will-be-deleted warning, then wipes the
  /// course's progress and forgets it (back to a fresh course in the finder).
  Future<void> _delete(Course course, UiLang uiLang) async {
    final strings = CourseSession.instance.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          icon: Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.error,
            size: 32,
          ),
          title: Text(_deleteTitle[uiLang]!),
          content: Text(
            '${_deleteBody[uiLang]!.replaceFirst('{course}', course.name)}\n\n'
            '${strings.resetProgressIrreversible}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: Text(_deleteAction[uiLang]!),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    await clearCourseProgress(course);
    await CourseSession.instance.removeStartedCourse(course.id);
    if (mounted) setState(() {});
  }

  /// The per-course actions menu (archive/restore + delete). The current
  /// course gets none — it can't be archived or deleted while in use.
  Widget _actionsMenu(
    Course course, {
    required bool archived,
    required UiLang uiLang,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurfaceVariant),
      onSelected: (action) => switch (action) {
        'archive' => _archive(course),
        'restore' => _restore(course),
        'delete' => _delete(course, uiLang),
        _ => null,
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: archived ? 'restore' : 'archive',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              archived ? Icons.unarchive_rounded : Icons.archive_outlined,
            ),
            title: Text(
              archived ? _restoreAction[uiLang]! : _archiveAction[uiLang]!,
            ),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.delete_outline_rounded,
              color: colorScheme.error,
            ),
            title: Text(
              _deleteAction[uiLang]!,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        text,
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = CourseSession.instance;
    final uiLang = session.activeCourse.uiLang;
    final activeId = session.activeCourseId;

    // Started courses in most-recently-used order, split by archive state.
    final byId = {for (final c in session.courses) c.id: c};
    final active = <Course>[];
    final archived = <Course>[];
    for (final id in session.startedCourseIds) {
      final course = byId[id];
      if (course == null) continue;
      (session.isArchived(id) ? archived : active).add(course);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText[uiLang]!),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                // ── Active courses ───────────────────────────────────────
                if (archived.isNotEmpty)
                  _sectionLabel('${_activeText[uiLang]!} (${active.length})'),
                for (final course in active) ...[
                  CourseTile(
                    course: course,
                    active: course.id == activeId,
                    progress: _progress[course.id],
                    onTap: () => _open(course),
                    trailing: course.id == activeId
                        ? null // current course: check mark, no actions
                        : _actionsMenu(course, archived: false, uiLang: uiLang),
                  ),
                  const SizedBox(height: 12),
                ],

                // ── Archived ("not active") courses ──────────────────────
                if (archived.isNotEmpty) ...[
                  _sectionLabel(
                    '${_archivedText[uiLang]!} (${archived.length})',
                  ),
                  for (final course in archived) ...[
                    CourseTile(
                      course: course,
                      archived: true,
                      progress: _progress[course.id],
                      trailing: _actionsMenu(
                        course,
                        archived: true,
                        uiLang: uiLang,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],

                // ── Find a new course ────────────────────────────────────
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop(); // back to the finder
                    } else {
                      context.go('/courses');
                    }
                  },
                  icon: const Icon(Icons.travel_explore_rounded),
                  label: Text(_findNewText[uiLang]!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
