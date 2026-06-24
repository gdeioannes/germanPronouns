import 'package:flutter/material.dart';

import '../../data/content/content_editor.dart';
import '../../models/content/quiz.dart';
import '../../models/quiz_content.dart';

/// Edits the fill-in sentences of one [FillBlankQuiz] in the JSON content
/// collections — add, edit the text / accepted answers, and delete — persisted
/// through [ContentEditor] (which overrides the shipped bundle, so the change
/// shows for learners). The richer per-type editor for the back office.
class CourseQuizSentencesPage extends StatefulWidget {
  const CourseQuizSentencesPage({
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
  State<CourseQuizSentencesPage> createState() =>
      _CourseQuizSentencesPageState();
}

class _CourseQuizSentencesPageState extends State<CourseQuizSentencesPage> {
  FillBlankQuiz? _quiz;
  List<QuizSentenceData> _sentences = [];
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
      _quiz = quiz is FillBlankQuiz ? quiz : null;
      _sentences = _quiz == null ? [] : [..._quiz!.sentences];
      _loading = false;
    });
  }

  /// Rebuilds the quiz with the current sentences and saves it (keeping every
  /// other field via a JSON round-trip — sentences are the only thing changed).
  Future<void> _persist() async {
    final quiz = _quiz;
    if (quiz == null) return;
    final updated = Quiz.fromJson(
      quiz.toJson()..['sentences'] = [for (final s in _sentences) s.toJson()],
    );
    await widget.editor.saveQuiz(widget.courseId, updated);
  }

  Future<void> _addOrEdit({int? index}) async {
    final result = await showDialog<QuizSentenceData>(
      context: context,
      builder: (_) => _SentenceDialog(
        quiz: _quiz!,
        existing: index == null ? null : _sentences[index],
      ),
    );
    if (result == null) return;
    setState(() {
      _sentences = [
        for (var i = 0; i < _sentences.length; i++)
          i == index ? result : _sentences[i],
        if (index == null) result,
      ];
    });
    await _persist();
  }

  Future<void> _delete(int index) async {
    setState(() {
      _sentences = [
        for (var i = 0; i < _sentences.length; i++)
          if (i != index) _sentences[i],
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
          ? const Center(child: Text('This quiz has no fill-in sentences.'))
          : ListView.separated(
              itemCount: _sentences.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final s = _sentences[index];
                return ListTile(
                  title: Text(s.sentence),
                  subtitle: s.acceptedAnswers.isEmpty
                      ? null
                      : Text('✓ ${s.acceptedAnswers.join(', ')}'),
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
              label: const Text('Add sentence'),
            ),
    );
  }
}

/// Add/edit dialog for one sentence: the text (with a `____` blank) and the
/// comma-separated accepted answers. Other fields of an edited sentence
/// (hint/english/explanation) are preserved.
class _SentenceDialog extends StatefulWidget {
  const _SentenceDialog({required this.quiz, this.existing});

  final FillBlankQuiz quiz;
  final QuizSentenceData? existing;

  @override
  State<_SentenceDialog> createState() => _SentenceDialogState();
}

class _SentenceDialogState extends State<_SentenceDialog> {
  late final TextEditingController _sentence = TextEditingController(
    text: widget.existing?.sentence ?? '',
  );
  late final TextEditingController _accepted = TextEditingController(
    text: widget.existing?.acceptedAnswers.join(', ') ?? '',
  );

  @override
  void dispose() {
    _sentence.dispose();
    _accepted.dispose();
    super.dispose();
  }

  void _save() {
    final text = _sentence.text.trim();
    if (text.isEmpty) return;
    final accepted = _accepted.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final base = widget.existing;
    Navigator.pop(
      context,
      QuizSentenceData(
        subjectKey:
            base?.subjectKey ??
            (widget.quiz.subjects.isNotEmpty
                ? widget.quiz.subjects.first.key
                : 's0'),
        categoryLabel:
            base?.categoryLabel ??
            (widget.quiz.categories.isNotEmpty
                ? widget.quiz.categories.first.label
                : ''),
        sentence: text,
        acceptedAnswers: accepted,
        prompt: base?.prompt,
        hint: base?.hint,
        english: base?.english,
        referenceExample: base?.referenceExample,
        explanationSections: base?.explanationSections ?? const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add sentence' : 'Edit sentence'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _sentence,
            autofocus: true,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Sentence (use ____ for the blank)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _accepted,
            decoration: const InputDecoration(
              labelText: 'Accepted answers (comma-separated)',
            ),
          ),
        ],
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
