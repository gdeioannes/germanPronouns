import 'package:flutter/material.dart';

import '../../data/content/ai_authoring_service.dart';
import '../../data/content/asset_course_provider.dart';
import '../../data/content/content_editor.dart';
import '../../models/content/catalog.dart';
import '../../models/content/populated_course.dart';
import '../../models/content/quiz.dart';
import 'course_quiz_sentences_page.dart';
import 'course_reading_questions_page.dart';
import 'course_spoken_lines_page.dart';

/// Teacher editor over the JSON content **collections**: pick a course, see its
/// quizzes (served from the per-course bundle), edit one, and the change is
/// persisted locally (overriding the shipped bundle) and shown to learners.
///
/// This is the collections-native back office — it writes through
/// [ContentEditor], the same seam a future remote database will implement. It
/// edits a quiz's title here; richer per-type forms (sentences, questions, help)
/// extend the same save path.
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
  Future<PopulatedCourse>? _courseFuture;

  void _selectCourse(String id) {
    setState(() {
      _courseId = id;
      _courseFuture = _editor.course(id);
    });
  }

  void _reload() {
    final id = _courseId;
    if (id != null) setState(() => _courseFuture = _editor.course(id));
  }

  /// Opens [page], then reloads the quiz list so edits made there show up.
  Future<void> _openPage(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    _reload();
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
    if (mounted) _reload();
  }

  Future<void> _editQuizTitle(Quiz quiz) async {
    final controller = TextEditingController(text: quiz.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit quiz title'),
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
    _reload();
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
    _reload();
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
    );
  }

  Widget _quizList() {
    final future = _courseFuture;
    if (future == null) {
      return const Center(child: Text('Pick a course to edit its quizzes.'));
    }
    return FutureBuilder<PopulatedCourse>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final quizzes = snapshot.data!.quizzes;
        return ListView.separated(
          itemCount: quizzes.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            return ListTile(
              title: Text(quiz.title),
              subtitle: Text('${quiz.type} · ${quiz.storageKeyPrefix}'),
              trailing: quiz is FillBlankQuiz
                  ? IconButton(
                      tooltip: 'Edit sentences',
                      icon: const Icon(Icons.notes_rounded),
                      onPressed: () => _openPage(
                        CourseQuizSentencesPage(
                          editor: _editor,
                          courseId: _courseId!,
                          quizId: quiz.id,
                          title: quiz.title,
                        ),
                      ),
                    )
                  : (quiz is ReadingQuiz || quiz is ListeningQuiz)
                  ? IconButton(
                      tooltip: 'Edit questions',
                      icon: const Icon(Icons.quiz_rounded),
                      onPressed: () => _openPage(
                        CourseReadingQuestionsPage(
                          editor: _editor,
                          courseId: _courseId!,
                          quizId: quiz.id,
                          title: quiz.title,
                        ),
                      ),
                    )
                  : (quiz is SpeakRepeatQuiz || quiz is DictationQuiz)
                  ? IconButton(
                      tooltip: 'Edit lines',
                      icon: const Icon(Icons.record_voice_over_rounded),
                      onPressed: () => _openPage(
                        CourseSpokenLinesPage(
                          editor: _editor,
                          courseId: _courseId!,
                          quizId: quiz.id,
                          title: quiz.title,
                        ),
                      ),
                    )
                  : const Icon(Icons.edit_rounded),
              onTap: () => _editQuizTitle(quiz),
            );
          },
        );
      },
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
