import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_page.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../theme/app_theme.dart';
import '../widgets/multiple_choice_questions.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_panel.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/speak_icon_button.dart';

/// A reading-comprehension quiz ([QuizKind.reading]): a short A1 passage shown
/// first, then a set of multiple-choice questions (rendered by the shared
/// [MultipleChoiceQuestions]). The learner answers every question, submits, sees
/// the score with per-question feedback, and can retry.
///
/// Reading needs no microphone, so — unlike the listen-&-repeat quizzes — it is
/// a properly scored, gated step: passing (≥ [_passThreshold] of the questions)
/// marks [questProgressionKey] complete via [NounSettings.markQuestQuizCompleted],
/// unlocking the next quiz in the Quest chain. Best score is stored locally.
class ReadingQuizPage extends StatefulWidget {
  const ReadingQuizPage({
    super.key,
    required this.content,
    required this.currentPage,
    this.questProgressionKey,
  });

  final QuizContent content;
  final AppPage currentPage;

  /// When set, this quiz is a Quest-chain entry: passing marks this key
  /// complete, unlocking the next chain quiz.
  final String? questProgressionKey;

  @override
  State<ReadingQuizPage> createState() => _ReadingQuizPageState();
}

class _ReadingQuizPageState extends State<ReadingQuizPage> {
  /// Two stages: read the passage, then answer the questions.
  bool _showQuestions = false;

  /// Selected option index per question (null = unanswered), stored as the
  /// option's *original* index so scoring is unaffected by the shuffled order.
  late final List<int?> _selected = List<int?>.filled(_questions.length, null);

  /// Per-question display order (original option indices), reshuffled per attempt.
  late List<List<int>> _optionOrder = _shuffledOptionOrder();

  List<List<int>> _shuffledOptionOrder() => [
        for (final q in _questions)
          List<int>.generate(q.options.length, (i) => i)..shuffle(),
      ];

  bool _submitted = false;
  int? _bestCorrect;
  NextExercise? _nextExercise;

  List<ReadingQuestion> get _questions => widget.content.readingQuestions;

  /// Questions to answer correctly to pass: at least 65% of them, rounded up.
  int get _passThreshold =>
      _questions.isEmpty ? 0 : (_questions.length * 65 + 99) ~/ 100;

  int get _correctCount {
    var n = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_selected[i] == _questions[i].correctIndex) n++;
    }
    return n;
  }

  bool get _passed => _correctCount >= _passThreshold;

  String get _bestKey => '${widget.content.storageKeyPrefix}reading_best';

  @override
  void initState() {
    super.initState();
    _loadBest();
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      _nextExercise = questNextExercise(questKey);
    } else {
      resolveNextExerciseForContent(widget.content.id).then((next) {
        if (mounted && next != null) setState(() => _nextExercise = next);
      });
    }
  }

  Future<void> _loadBest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final best = prefs.getInt(_bestKey);
      if (mounted && best != null) setState(() => _bestCorrect = best);
    } catch (_) {
      // Best-effort; a missing value just hides the "best" line.
    }
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    final correct = _correctCount;
    if (_bestCorrect == null || correct > _bestCorrect!) {
      _bestCorrect = correct;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_bestKey, correct);
      } catch (_) {
        // Best-effort persistence.
      }
    }
    if (_passed) {
      await NounSettings.instance.markReadingQuizCompleted(widget.content.id);
      if (widget.questProgressionKey != null) {
        await NounSettings.instance.markQuestQuizCompleted(
          widget.questProgressionKey!,
        );
      }
    }
  }

  void _retry() {
    setState(() {
      _submitted = false;
      for (var i = 0; i < _selected.length; i++) {
        _selected[i] = null;
      }
      _optionOrder = _shuffledOptionOrder();
      _showQuestions = false;
    });
  }

  /// Floating panel with the translation of the reading passage, so the passage
  /// itself can stay in German with the translation one tap away.
  void _showPassageTranslation(BuildContext context) {
    final translation = widget.content.readingPassageTranslation;
    if (translation == null) return;
    final title = widget.content.readingTitle;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.translate_rounded, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(title ?? CourseSession.instance.strings.help)),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              translation,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(CourseSession.instance.strings.close),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuizScaffold(
      content: widget.content,
      currentPage: widget.currentPage,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                if (!_showQuestions) _buildPassage(context) else ...[
                  _buildPassageCard(context, collapsed: true),
                  const SizedBox(height: 12),
                  MultipleChoiceQuestions(
                    questions: _questions,
                    selected: _selected,
                    optionOrder: _optionOrder,
                    submitted: _submitted,
                    bestCorrect: _bestCorrect,
                    nextExercise: _nextExercise,
                    onSelect: (q, o) => setState(() => _selected[q] = o),
                    onSubmit: _submit,
                    onRetry: _retry,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassage(BuildContext context) {
    final strings = CourseSession.instance.strings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPassageCard(context),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => setState(() => _showQuestions = true),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text(strings.readingStartQuestions),
        ),
      ],
    );
  }

  Widget _buildPassageCard(BuildContext context, {bool collapsed = false}) {
    final theme = Theme.of(context);
    final content = widget.content;
    return QuizPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.readingCategory != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(kRadiusSmall),
              ),
              child: Text(
                content.readingCategory!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: content.readingTitle != null
                    ? Text(
                        content.readingTitle!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // Read the whole passage aloud in the target language.
              SpeakIconButton(text: content.readingPassage ?? '', size: 20),
              if (content.readingPassageTranslation != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                  tooltip: CourseSession.instance.strings.help,
                  icon: const Icon(Icons.translate_rounded, size: 20),
                  onPressed: () => _showPassageTranslation(context),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content.readingPassage ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
