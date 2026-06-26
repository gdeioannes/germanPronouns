import 'package:flutter/material.dart';

import '../../data/content/ai_authoring_service.dart';
import '../../data/content/asset_course_provider.dart';
import '../../data/content/content_editor.dart';
import '../../models/content/catalog.dart';
import '../../models/content/quiz.dart';
import 'course_quiz_sentences_page.dart';
import 'course_reading_questions_page.dart';
import 'course_spoken_lines_page.dart';

/// The quiz [Quiz.type] discriminators with teacher-friendly labels, used by the
/// "New quiz" dialog.
const Map<String, String> _quizTypeLabels = {
  'fillBlank': 'Fill in the blank',
  'reading': 'Reading (passage + questions)',
  'listening': 'Listening (audio + questions)',
  'speakRepeat': 'Speak & repeat (phrases)',
  'dictation': 'Dictation (type what you hear)',
};

/// Teacher editor over the JSON content **collections**: pick a course, see its
/// quizzes (served from the per-course bundle), then **organize** them — drag to
/// reorder, add a new quiz of any type, rename, delete, or drill in to edit a
/// quiz's elements (which themselves reorder/add/edit/delete). Every change is
/// persisted locally through [ContentEditor] (overriding the shipped bundle, so
/// it shows for learners) — the same write seam a future remote database will
/// implement.
class CourseContentEditorPage extends StatefulWidget {
  const CourseContentEditorPage({super.key});

  @override
  State<CourseContentEditorPage> createState() =>
      _CourseContentEditorPageState();
}

class _CourseContentEditorPageState extends State<CourseContentEditorPage> {
  final ContentEditor _editor = ContentEditor(
    provider: courseContentProvider,
    store: const RepositoryBundleStore(),
  );

  final AiAuthoringService _ai = const TemplateAiAuthoringService();

  final Future<Catalog> _catalogFuture = courseContentProvider.catalog();
  String? _courseId;
  List<Quiz>? _quizzes;
  bool _loading = false;

  void _selectCourse(String id) {
    setState(() {
      _courseId = id;
      _quizzes = null;
    });
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final id = _courseId;
    if (id == null) return;
    setState(() => _loading = true);
    final course = await _editor.course(id);
    if (!mounted) return;
    setState(() {
      _quizzes = [...course.quizzes];
      _loading = false;
    });
  }

  /// Opens [page], then reloads the quiz list so edits made there show up.
  Future<void> _openPage(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    await _loadQuizzes();
  }

  /// Drag-to-reorder the quizzes. [newIndex] is already adjusted for the removed
  /// item (onReorderItem); persist the new order through the editor.
  Future<void> _reorderQuiz(int oldIndex, int newIndex) async {
    final quizzes = _quizzes;
    final id = _courseId;
    if (quizzes == null || id == null) return;
    setState(() {
      final item = quizzes.removeAt(oldIndex);
      quizzes.insert(newIndex, item);
    });
    await _editor.reorderQuizzes(id, quizzes);
  }

  Future<void> _newQuiz() async {
    final courseId = _courseId;
    if (courseId == null) return;
    final spec = await showDialog<_NewQuizSpec>(
      context: context,
      builder: (_) => const _NewQuizDialog(),
    );
    if (spec == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _editor.createQuiz(
        courseId,
        type: spec.type,
        id: spec.id,
        title: spec.title,
        storageKeyPrefix: spec.storageKeyPrefix,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('Added "${spec.title}" — tap it to add content.')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not add quiz: $e')));
    }
    await _loadQuizzes();
  }

  /// Generates a draft quiz with the AI authoring service and saves it into the
  /// selected course (the teacher then edits it with the per-type forms). This
  /// is the in-UI half of the AI-authoring seam: draft -> validate-on-save.
  Future<void> _aiDraft() async {
    final courseId = _courseId;
    if (courseId == null) return;
    final spec = await showDialog<({AiQuizType type, String topic})>(
      context: context,
      builder: (_) => const _AiDraftDialog(),
    );
    if (spec == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final id = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    try {
      final draft = await _ai.draftQuiz(
        type: spec.type,
        id: id,
        topic: spec.topic,
      );
      await _editor.saveQuiz(courseId, draft);
      messenger.showSnackBar(
        SnackBar(content: Text('Added draft "${spec.topic}" — edit it below.')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Draft failed: $e')));
    }
    await _loadQuizzes();
  }

  Future<void> _editQuizTitle(Quiz quiz) async {
    final controller = TextEditingController(text: quiz.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename quiz'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newTitle == null || newTitle.isEmpty || newTitle == quiz.title) return;
    final edited = Quiz.fromJson(quiz.toJson()..['title'] = newTitle);
    await _editor.saveQuiz(_courseId!, edited);
    await _loadQuizzes();
  }

  Future<void> _deleteQuiz(Quiz quiz) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${quiz.title}"?'),
        content: const Text(
          'Removes the quiz from this course. Learner progress saved under its '
          'key is left untouched. You can Reset the course to restore it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _editor.deleteQuiz(_courseId!, quiz.id);
    await _loadQuizzes();
  }

  Future<void> _resetCourse() async {
    final id = _courseId;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset course to published?'),
        content: const Text('Discards local edits for this course.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _editor.resetCourse(id);
    await _loadQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Content'),
        actions: [
          if (_courseId != null)
            IconButton(
              tooltip: 'AI draft a quiz',
              icon: const Icon(Icons.auto_awesome_rounded),
              onPressed: _aiDraft,
            ),
          if (_courseId != null)
            IconButton(
              tooltip: 'Reset course to published',
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: _resetCourse,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder<Catalog>(
              future: _catalogFuture,
              builder: (context, snapshot) {
                final courses = snapshot.data?.courses ?? const <CourseCard>[];
                return DropdownButtonFormField<String>(
                  initialValue: _courseId,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final c in courses)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (id) {
                    if (id != null) _selectCourse(id);
                  },
                );
              },
            ),
          ),
          Expanded(child: _quizList()),
        ],
      ),
      floatingActionButton: _courseId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _newQuiz,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New quiz'),
            ),
    );
  }

  Widget _quizList() {
    if (_courseId == null) {
      return const Center(child: Text('Pick a course to edit its quizzes.'));
    }
    final quizzes = _quizzes;
    if (_loading || quizzes == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (quizzes.isEmpty) {
      return const Center(
        child: Text('No quizzes yet — tap "New quiz" to add one.'),
      );
    }
    return ReorderableListView.builder(
      itemCount: quizzes.length,
      onReorderItem: _reorderQuiz,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return ListTile(
          key: ValueKey(quiz.id),
          leading: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle_rounded),
          ),
          title: Text(quiz.title),
          subtitle: Text(
            '${_quizTypeLabels[quiz.type] ?? quiz.type} · ${quiz.storageKeyPrefix}',
          ),
          onTap: () => _openElementEditor(quiz),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'rename') _editQuizTitle(quiz);
              if (value == 'delete') _deleteQuiz(quiz);
              if (value == 'edit') _openElementEditor(quiz);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit content')),
              PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        );
      },
    );
  }

  /// Opens the per-type element editor for [quiz] (sentences / questions /
  /// lines), reloading the list afterwards.
  void _openElementEditor(Quiz quiz) {
    final courseId = _courseId!;
    final page = switch (quiz) {
      FillBlankQuiz() => CourseQuizSentencesPage(
        editor: _editor,
        courseId: courseId,
        quizId: quiz.id,
        title: quiz.title,
      ),
      ReadingQuiz() || ListeningQuiz() => CourseReadingQuestionsPage(
        editor: _editor,
        courseId: courseId,
        quizId: quiz.id,
        title: quiz.title,
      ),
      SpeakRepeatQuiz() || DictationQuiz() => CourseSpokenLinesPage(
        editor: _editor,
        courseId: courseId,
        quizId: quiz.id,
        title: quiz.title,
      ),
    };
    _openPage(page);
  }
}

/// The fields collected by the "New quiz" dialog.
typedef _NewQuizSpec = ({
  String type,
  String id,
  String title,
  String storageKeyPrefix,
});

/// Collects the type, id, title and storage-key prefix for a brand-new quiz.
class _NewQuizDialog extends StatefulWidget {
  const _NewQuizDialog();

  @override
  State<_NewQuizDialog> createState() => _NewQuizDialogState();
}

class _NewQuizDialogState extends State<_NewQuizDialog> {
  String _type = 'fillBlank';
  final TextEditingController _id = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _prefix = TextEditingController();

  @override
  void dispose() {
    _id.dispose();
    _title.dispose();
    _prefix.dispose();
    super.dispose();
  }

  void _create() {
    final id = _id.text.trim();
    final title = _title.text.trim();
    if (id.isEmpty || title.isEmpty) return;
    // Default the storage key to the id (the teacher can override it); it keys
    // saved learner progress and is validated unique on save.
    final prefix = _prefix.text.trim().isEmpty
        ? '${id}_'
        : _prefix.text.trim();
    Navigator.pop<_NewQuizSpec>(
      context,
      (type: _type, id: id, title: title, storageKeyPrefix: prefix),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New quiz'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final entry in _quizTypeLabels.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (v) => setState(() => _type = v ?? 'fillBlank'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _id,
              decoration: const InputDecoration(
                labelText: 'Id (stable, unique — e.g. greetings_a1)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _prefix,
              decoration: const InputDecoration(
                labelText: 'Storage key prefix (optional — defaults to id_)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _create, child: const Text('Create')),
      ],
    );
  }
}

/// Picks the quiz [AiQuizType] and a topic for an AI-drafted quiz.
class _AiDraftDialog extends StatefulWidget {
  const _AiDraftDialog();

  @override
  State<_AiDraftDialog> createState() => _AiDraftDialogState();
}

class _AiDraftDialogState extends State<_AiDraftDialog> {
  AiQuizType _type = AiQuizType.fillBlank;
  final TextEditingController _topic = TextEditingController();

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  void _generate() {
    final topic = _topic.text.trim();
    if (topic.isEmpty) return;
    Navigator.pop(context, (type: _type, topic: topic));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AI draft a quiz'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<AiQuizType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: [
              for (final t in AiQuizType.values)
                DropdownMenuItem(value: t, child: Text(t.name)),
            ],
            onChanged: (v) => setState(() => _type = v ?? AiQuizType.fillBlank),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _topic,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Topic'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _generate, child: const Text('Generate')),
      ],
    );
  }
}
