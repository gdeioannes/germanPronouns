import 'package:flutter/material.dart';

import '../../data/content/content_editor.dart';
import '../../models/content/quiz.dart';
import '../../models/quiz_content.dart';

/// The multiple-choice questions of a [ReadingQuiz] or [ListeningQuiz] (which
/// share the questions shape), with their options and which option is correct.
List<ReadingQuestion> questionsOf(Quiz quiz) => switch (quiz) {
  ReadingQuiz() => quiz.questions,
  ListeningQuiz() => quiz.questions,
  _ => const [],
};

/// Edits the multiple-choice questions of a reading/listening quiz in the JSON
/// content collections — add, edit (text, options, correct answer) and delete —
/// persisted through [ContentEditor] so changes reach learners.
class CourseReadingQuestionsPage extends StatefulWidget {
  const CourseReadingQuestionsPage({
    super.key,
    required this.editor,
    required this.courseId,
    required this.quizId,
    required this.title,
  });

  final ContentEditor editor;
  final String courseId;
  final String quizId;
  final String title;

  @override
  State<CourseReadingQuestionsPage> createState() =>
      _CourseReadingQuestionsPageState();
}

class _CourseReadingQuestionsPageState
    extends State<CourseReadingQuestionsPage> {
  Quiz? _quiz;
  List<ReadingQuestion> _questions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final course = await widget.editor.course(widget.courseId);
    final quiz = course.quizById(widget.quizId);
    if (!mounted) return;
    setState(() {
      _quiz = quiz is ReadingQuiz || quiz is ListeningQuiz ? quiz : null;
      _questions = _quiz == null ? [] : [...questionsOf(_quiz!)];
      _loading = false;
    });
  }

  /// Rebuilds the quiz with the current questions (keeping its type + every
  /// other field via a JSON round-trip) and saves it.
  Future<void> _persist() async {
    final quiz = _quiz;
    if (quiz == null) return;
    final updated = Quiz.fromJson(
      quiz.toJson()..['questions'] = [for (final q in _questions) q.toJson()],
    );
    await widget.editor.saveQuiz(widget.courseId, updated);
  }

  Future<void> _addOrEdit({int? index}) async {
    final result = await showDialog<ReadingQuestion>(
      context: context,
      builder: (_) =>
          _QuestionDialog(existing: index == null ? null : _questions[index]),
    );
    if (result == null) return;
    setState(() {
      _questions = [
        for (var i = 0; i < _questions.length; i++)
          i == index ? result : _questions[i],
        if (index == null) result,
      ];
    });
    await _persist();
  }

  Future<void> _delete(int index) async {
    setState(() {
      _questions = [
        for (var i = 0; i < _questions.length; i++)
          if (i != index) _questions[i],
      ];
    });
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _quiz == null
          ? const Center(child: Text('This quiz has no questions.'))
          : ListView.separated(
              itemCount: _questions.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final q = _questions[index];
                final correct = q.correctIndex >= 0 &&
                        q.correctIndex < q.options.length
                    ? q.options[q.correctIndex]
                    : '?';
                return ListTile(
                  title: Text(q.question),
                  subtitle: Text('${q.options.length} options · ✓ $correct'),
                  onTap: () => _addOrEdit(index: index),
                  trailing: IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => _delete(index),
                  ),
                );
              },
            ),
      floatingActionButton: _quiz == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _addOrEdit(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add question'),
            ),
    );
  }
}

/// Add/edit dialog for one multiple-choice question: the stem, a dynamic list of
/// options (each with a radio to mark the correct one). Translations/explanation
/// of an edited question are preserved.
class _QuestionDialog extends StatefulWidget {
  const _QuestionDialog({this.existing});

  final ReadingQuestion? existing;

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  late final TextEditingController _question = TextEditingController(
    text: widget.existing?.question ?? '',
  );
  late final List<TextEditingController> _options = [
    for (final o in widget.existing?.options ?? const ['', ''])
      TextEditingController(text: o),
  ];
  late int _correct = widget.existing?.correctIndex ?? 0;

  @override
  void dispose() {
    _question.dispose();
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final stem = _question.text.trim();
    final options = [
      for (final c in _options)
        if (c.text.trim().isNotEmpty) c.text.trim(),
    ];
    if (stem.isEmpty || options.length < 2) return;
    final correct = _correct.clamp(0, options.length - 1);
    final base = widget.existing;
    Navigator.pop(
      context,
      ReadingQuestion(
        question: stem,
        options: options,
        correctIndex: correct,
        explanation: base?.explanation,
        questionTranslation: base?.questionTranslation,
        optionsTranslation: base?.optionsTranslation,
        explanationTranslation: base?.explanationTranslation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add question' : 'Edit question'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _question,
                autofocus: true,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 12),
              const Text('Options (select the correct one):'),
              for (var i = 0; i < _options.length; i++)
                Row(
                  children: [
                    Radio<int>(
                      value: i,
                      // ignore: deprecated_member_use — RadioGroup not yet on stable here.
                      groupValue: _correct,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setState(() => _correct = v ?? 0),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _options[i],
                        decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                      ),
                    ),
                    if (_options.length > 2)
                      IconButton(
                        tooltip: 'Remove option',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() {
                          _options.removeAt(i).dispose();
                          if (_correct >= _options.length) _correct = 0;
                        }),
                      ),
                  ],
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _options.add(TextEditingController())),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add option'),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
