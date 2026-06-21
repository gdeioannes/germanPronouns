import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/help_memory.dart';
import '../widgets/next_exercise.dart';

/// A reading-comprehension quiz ([QuizKind.reading]): a short A1 passage shown
/// first, then a set of multiple-choice questions. The learner answers every
/// question, submits, sees the score with per-question feedback, and can retry.
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

  /// Selected option index per question (null = unanswered). Stored as the
  /// option's *original* index, so scoring against [ReadingQuestion.correctIndex]
  /// is unaffected by the shuffled display order.
  late final List<int?> _selected = List<int?>.filled(_questions.length, null);

  /// Per-question display order as a list of original option indices, reshuffled
  /// on each attempt so the correct answer's position can't be memorized.
  late List<List<int>> _optionOrder = _shuffledOptionOrder();

  List<List<int>> _shuffledOptionOrder() => [
        for (final q in _questions)
          List<int>.generate(q.options.length, (i) => i)..shuffle(),
      ];

  /// True once the learner has submitted; reveals correctness + explanations.
  bool _submitted = false;

  /// Best score (number correct) recorded for this quiz, loaded from storage.
  int? _bestCorrect;

  NextExercise? _nextExercise;

  List<ReadingQuestion> get _questions => widget.content.readingQuestions;

  /// Questions to answer correctly to pass: at least 65% of them, rounded up
  /// (e.g. 2/3, 3/4, 4/5, 7/10).
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

  bool get _allAnswered => !_selected.contains(null);

  String get _bestKey => '${widget.content.storageKeyPrefix}reading_best';

  @override
  void initState() {
    super.initState();
    _loadBest();
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      // A Quest-chain entry: the next exercise is the next chain quiz.
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
      // Passing flags this reading quiz "done" so it shows the ribbon on the
      // quiz home page and drawer (reading has no streak to reach a goal with).
      await NounSettings.instance.markReadingQuizCompleted(widget.content.id);
      // As a Quest-chain entry, passing also unlocks the next chain quiz.
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
      // Reshuffle so a retry doesn't present the same option order.
      _optionOrder = _shuffledOptionOrder();
      _showQuestions = false;
    });
  }

  void _showHelp() {
    final content = widget.content;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text(content.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (content.helpMemoryIntro != null)
              HelpMemoryIntro(text: content.helpMemoryIntro!),
            for (final tip in content.helpMemoryTips) HelpTipCard(tip: tip),
          ],
        ),
      ),
    );
  }

  /// Floating panel with the translation of [question] and its options (and the
  /// explanation, once revealed), so the quiz can stay in German while help is
  /// one tap away.
  void _showTranslation(
    BuildContext context,
    ReadingQuestion question,
    List<int> order,
  ) {
    final optionsTranslation = question.optionsTranslation;
    final explanationTranslation = question.explanationTranslation;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.translate_rounded, size: 20),
              const SizedBox(width: 8),
              Text(CourseSession.instance.strings.help),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  question.questionTranslation ?? question.question,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (optionsTranslation != null) ...[
                  const SizedBox(height: 12),
                  for (final o in order)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: question.options[o],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (o < optionsTranslation.length)
                              TextSpan(
                                text: '  —  ${optionsTranslation[o]}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
                // Only worth showing the explanation translation once the
                // learner has submitted and the German explanation is visible.
                if (_submitted && explanationTranslation != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    explanationTranslation,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
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
    final strings = CourseSession.instance.strings;
    return Scaffold(
      appBar: AppBar(
        // Shrink long titles to fit on one line instead of truncating with "…".
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(widget.content.title),
        ),
        actions: [
          IconButton(
            tooltip: strings.help,
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: _showHelp,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentPage: widget.currentPage,
        currentContentId: widget.content.id,
      ),
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
                  _buildQuestions(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context, {required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadiusLarge),
        boxShadow: [
          BoxShadow(color: colorScheme.outline, offset: const Offset(0, 3)),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
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
    return _panel(
      context,
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
              // The passage stays in German; its translation lives behind this
              // info button.
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

  Widget _buildQuestions(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    return _panel(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.readingQuestionsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _questions.length; i++)
            _buildQuestion(context, i),
          const SizedBox(height: 8),
          if (_submitted) _buildResult(context) else _buildSubmit(context),
        ],
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, int index) {
    final theme = Theme.of(context);
    final question = _questions[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${index + 1}. ${question.question}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // The quiz stays in German; the translation of the question and
              // its options lives behind this info button.
              if (question.questionTranslation != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                  tooltip: CourseSession.instance.strings.help,
                  icon: const Icon(Icons.translate_rounded, size: 20),
                  onPressed: () =>
                      _showTranslation(context, question, _optionOrder[index]),
                ),
            ],
          ),
          const SizedBox(height: 6),
          for (final o in _optionOrder[index]) _buildOption(context, index, o),
          if (_submitted && question.explanation != null) ...[
            const SizedBox(height: 4),
            Text(
              question.explanation!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, int qIndex, int oIndex) {
    final theme = Theme.of(context);
    final question = _questions[qIndex];
    final selected = _selected[qIndex] == oIndex;
    final isCorrect = question.correctIndex == oIndex;

    Color? tileColor;
    Color borderColor = theme.colorScheme.outlineVariant;
    Widget? trailing;
    if (_submitted) {
      if (isCorrect) {
        tileColor = Colors.green.withValues(alpha: 0.12);
        borderColor = Colors.green.shade600;
        trailing = Icon(Icons.check_circle_rounded, color: Colors.green.shade700);
      } else if (selected) {
        tileColor = theme.colorScheme.errorContainer.withValues(alpha: 0.4);
        borderColor = theme.colorScheme.error;
        trailing = Icon(Icons.cancel_rounded, color: theme.colorScheme.error);
      }
    } else if (selected) {
      tileColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.4);
      borderColor = theme.colorScheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: tileColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(kRadiusSmall),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusSmall),
          onTap: _submitted
              ? null
              : () => setState(() => _selected[qIndex] = oIndex),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.options[oIndex],
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmit(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_allAnswered)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              strings.readingAnswerAll,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        FilledButton.icon(
          onPressed: _allAnswered ? _submit : null,
          icon: const Icon(Icons.check_rounded),
          label: Text(strings.readingCheckAnswers),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final passed = _passed;
    final color = passed ? Colors.green.shade700 : theme.colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.celebration_rounded : Icons.refresh_rounded,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              passed ? strings.readingPassed : strings.readingKeepPracticing,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$_correctCount / ${_questions.length} ${strings.readingCorrect}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        if (_bestCorrect != null)
          Text(
            '${strings.best}: $_bestCorrect / ${_questions.length}',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: _retry,
                icon: const Icon(Icons.replay_rounded),
                label: Text(strings.readingTryAgain),
              ),
            ),
            if (passed && _nextExercise != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _nextExercise!.open(context),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(strings.nextExercise),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
