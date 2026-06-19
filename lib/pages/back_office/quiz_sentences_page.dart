import 'package:flutter/material.dart';

import '../../data/db/content_repository.dart';
import '../../models/quiz_content.dart';

/// Lists and edits the fill-in sentences of one quiz: add, edit, and delete,
/// all persisted to the local content database.
class QuizSentencesPage extends StatefulWidget {
  const QuizSentencesPage({
    super.key,
    required this.repository,
    required this.quizId,
    required this.title,
  });

  final ContentRepository repository;
  final String quizId;
  final String title;

  @override
  State<QuizSentencesPage> createState() => _QuizSentencesPageState();
}

class _QuizSentencesPageState extends State<QuizSentencesPage> {
  QuizContent? _content;
  List<SentenceRecord> _sentences = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final content = await widget.repository.quizContent(widget.quizId);
    final sentences = await widget.repository.sentencesFor(widget.quizId);
    if (!mounted) return;
    setState(() {
      _content = content;
      _sentences = sentences;
      _loading = false;
    });
  }

  Future<void> _addOrEdit({SentenceRecord? existing}) async {
    final content = _content;
    if (content == null) return;
    final result = await showDialog<QuizSentenceData>(
      context: context,
      builder: (_) => _SentenceEditorDialog(content: content, existing: existing?.data),
    );
    if (result == null) return;
    if (existing == null) {
      await widget.repository.addSentence(widget.quizId, result);
    } else {
      await widget.repository.updateSentence(widget.quizId, existing.key, result);
    }
    await _load();
  }

  Future<void> _delete(SentenceRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete sentence?'),
        content: Text(record.data.sentence),
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
    await widget.repository.deleteSentence(record.key);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _content == null ? null : () => _addOrEdit(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add sentence'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sentences.isEmpty
          ? const Center(child: Text('No sentences yet. Tap "Add sentence".'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: _sentences.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final record = _sentences[index];
                final data = record.data;
                final meta = [
                  data.subjectKey,
                  data.categoryLabel,
                  if (data.acceptedAnswers.isNotEmpty)
                    '→ ${data.acceptedAnswers.join(', ')}',
                ].join('  ·  ');

                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(data.sentence),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        meta,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(Icons.edit_rounded),
                          onPressed: () => _addOrEdit(existing: record),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () => _delete(record),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// Add/edit form for a single sentence. Returns the new [QuizSentenceData] on
/// save, or null on cancel.
class _SentenceEditorDialog extends StatefulWidget {
  const _SentenceEditorDialog({required this.content, this.existing});

  final QuizContent content;
  final QuizSentenceData? existing;

  @override
  State<_SentenceEditorDialog> createState() => _SentenceEditorDialogState();
}

class _SentenceEditorDialogState extends State<_SentenceEditorDialog> {
  late String _subjectKey;
  late String _categoryLabel;
  late final TextEditingController _sentence;
  late final TextEditingController _acceptedAnswers;
  late final TextEditingController _hint;
  late final TextEditingController _english;
  String? _error;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _subjectKey = existing?.subjectKey ?? widget.content.subjects.first.key;
    _categoryLabel =
        existing?.categoryLabel ?? widget.content.categories.first.label;
    _sentence = TextEditingController(text: existing?.sentence ?? '');
    _acceptedAnswers = TextEditingController(
      text: existing?.acceptedAnswers.join(', ') ?? '',
    );
    _hint = TextEditingController(text: existing?.hint ?? '');
    _english = TextEditingController(text: existing?.english ?? '');
  }

  @override
  void dispose() {
    _sentence.dispose();
    _acceptedAnswers.dispose();
    _hint.dispose();
    _english.dispose();
    super.dispose();
  }

  void _save() {
    final sentence = _sentence.text.trim();
    if (sentence.isEmpty) {
      setState(() => _error = 'Sentence is required.');
      return;
    }
    final answers = _acceptedAnswers.text
        .split(',')
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toList();
    final hint = _hint.text.trim();
    final english = _english.text.trim();

    Navigator.pop(
      context,
      QuizSentenceData(
        subjectKey: _subjectKey,
        categoryLabel: _categoryLabel,
        sentence: sentence,
        acceptedAnswers: answers,
        hint: hint.isEmpty ? null : hint,
        english: english.isEmpty ? null : english,
        // Preserve fields the form doesn't edit.
        prompt: widget.existing?.prompt,
        explanationSections: widget.existing?.explanationSections ?? const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add sentence' : 'Edit sentence'),
      content: ConstrainedBox(
        // Cap the width, but shrink to the actual available width on narrow
        // windows/phones so the form never overflows horizontally.
        constraints: const BoxConstraints(maxWidth: 460),
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _subjectKey,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: [
                  for (final s in widget.content.subjects)
                    DropdownMenuItem(
                      value: s.key,
                      child: Text(
                        s.display,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _subjectKey = v ?? _subjectKey),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoryLabel,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  for (final c in widget.content.categories)
                    DropdownMenuItem(
                      value: c.label,
                      child: Text(
                        c.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) =>
                    setState(() => _categoryLabel = v ?? _categoryLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sentence,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Sentence (use ____ for the blank)',
                  errorText: _error,
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _acceptedAnswers,
                decoration: const InputDecoration(
                  labelText: 'Accepted answers (comma-separated, optional)',
                  helperText: 'Leave empty to use the category default answer.',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _english,
                decoration: const InputDecoration(
                  labelText: 'English translation (optional)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _hint,
                decoration: const InputDecoration(
                  labelText: 'Hint (optional)',
                ),
              ),
            ],
          ),
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
