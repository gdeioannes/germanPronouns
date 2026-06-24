import 'package:flutter/material.dart';

import '../../data/content/content_editor.dart';
import '../../models/content/quiz.dart';

/// The spoken lines of a [SpeakRepeatQuiz] (phrases) or [DictationQuiz] (items)
/// — both are lists of [SpokenLine] (German text + translation).
List<SpokenLine> linesOf(Quiz quiz) => switch (quiz) {
  SpeakRepeatQuiz() => quiz.phrases,
  DictationQuiz() => quiz.items,
  _ => const [],
};

/// The JSON key each kind stores its lines under.
String? _linesKey(Quiz quiz) => switch (quiz) {
  SpeakRepeatQuiz() => 'phrases',
  DictationQuiz() => 'items',
  _ => null,
};

/// Edits the spoken lines of a speak/dictation quiz in the JSON content
/// collections — add, edit (German text + translation) and delete — persisted
/// through [ContentEditor] so changes reach learners.
class CourseSpokenLinesPage extends StatefulWidget {
  const CourseSpokenLinesPage({
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
  State<CourseSpokenLinesPage> createState() => _CourseSpokenLinesPageState();
}

class _CourseSpokenLinesPageState extends State<CourseSpokenLinesPage> {
  Quiz? _quiz;
  List<SpokenLine> _lines = [];
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
      _quiz = quiz is SpeakRepeatQuiz || quiz is DictationQuiz ? quiz : null;
      _lines = _quiz == null ? [] : [...linesOf(_quiz!)];
      _loading = false;
    });
  }

  Future<void> _persist() async {
    final quiz = _quiz;
    final key = quiz == null ? null : _linesKey(quiz);
    if (quiz == null || key == null) return;
    final updated = Quiz.fromJson(
      quiz.toJson()..[key] = [for (final l in _lines) l.toJson()],
    );
    await widget.editor.saveQuiz(widget.courseId, updated);
  }

  /// A line id not already in use within the quiz.
  String _freshId() {
    var i = 0;
    while (_lines.any((l) => l.id == 's$i')) {
      i++;
    }
    return 's$i';
  }

  Future<void> _addOrEdit({int? index}) async {
    final result = await showDialog<SpokenLine>(
      context: context,
      builder: (_) => _LineDialog(
        existing: index == null ? null : _lines[index],
        newId: _freshId(),
      ),
    );
    if (result == null) return;
    setState(() {
      _lines = [
        for (var i = 0; i < _lines.length; i++)
          i == index ? result : _lines[i],
        if (index == null) result,
      ];
    });
    await _persist();
  }

  Future<void> _delete(int index) async {
    setState(() {
      _lines = [
        for (var i = 0; i < _lines.length; i++)
          if (i != index) _lines[i],
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
          ? const Center(child: Text('This quiz has no spoken lines.'))
          : ListView.separated(
              itemCount: _lines.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final l = _lines[index];
                return ListTile(
                  title: Text(l.text),
                  subtitle: (l.translation ?? '').isEmpty
                      ? null
                      : Text(l.translation!),
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
              label: const Text('Add line'),
            ),
    );
  }
}

/// Add/edit dialog for one spoken line: the German [text] and its translation.
class _LineDialog extends StatefulWidget {
  const _LineDialog({this.existing, required this.newId});

  final SpokenLine? existing;
  final String newId;

  @override
  State<_LineDialog> createState() => _LineDialogState();
}

class _LineDialogState extends State<_LineDialog> {
  late final TextEditingController _text = TextEditingController(
    text: widget.existing?.text ?? '',
  );
  late final TextEditingController _translation = TextEditingController(
    text: widget.existing?.translation ?? '',
  );

  @override
  void dispose() {
    _text.dispose();
    _translation.dispose();
    super.dispose();
  }

  void _save() {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    final translation = _translation.text.trim();
    Navigator.pop(
      context,
      SpokenLine(
        id: widget.existing?.id ?? widget.newId,
        text: text,
        translation: translation.isEmpty ? null : translation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add line' : 'Edit line'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _text,
            autofocus: true,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'German text'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _translation,
            decoration: const InputDecoration(labelText: 'Translation'),
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
