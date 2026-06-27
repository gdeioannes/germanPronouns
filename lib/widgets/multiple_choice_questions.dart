import 'package:flutter/material.dart';

import '../models/course_session.dart';
import '../models/quiz_content.dart';
import '../theme/app_theme.dart';
import 'next_exercise.dart';
import 'quiz_panel.dart';
import 'speak_icon_button.dart';

/// The multiple-choice questions panel shared by the reading and listening
/// quizzes (their question/option/submit/result rendering was byte-identical).
///
/// It is a pure view over the parent's state: the parent owns [selected] /
/// [submitted] and the persistence/unlock side effects, and supplies the
/// callbacks. Pass-threshold and score are derived here for display, so the two
/// pages share one implementation.
class MultipleChoiceQuestions extends StatelessWidget {
  const MultipleChoiceQuestions({
    super.key,
    required this.questions,
    required this.selected,
    required this.optionOrder,
    required this.submitted,
    required this.bestCorrect,
    required this.nextExercise,
    required this.onSelect,
    required this.onSubmit,
    required this.onRetry,
  });

  final List<ReadingQuestion> questions;

  /// Selected *original* option index per question (null = unanswered).
  final List<int?> selected;

  /// Per-question display order (original option indices), reshuffled per attempt.
  final List<List<int>> optionOrder;

  final bool submitted;
  final int? bestCorrect;
  final NextExercise? nextExercise;

  final void Function(int questionIndex, int optionIndex) onSelect;
  final VoidCallback onSubmit;
  final VoidCallback onRetry;

  int get _passThreshold =>
      questions.isEmpty ? 0 : (questions.length * 65 + 99) ~/ 100;

  int get _correctCount {
    var n = 0;
    for (var i = 0; i < questions.length; i++) {
      if (selected[i] == questions[i].correctIndex) n++;
    }
    return n;
  }

  bool get _passed => _correctCount >= _passThreshold;
  bool get _allAnswered => !selected.contains(null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    return QuizPanel(
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
          for (var i = 0; i < questions.length; i++) _buildQuestion(context, i),
          const SizedBox(height: 8),
          if (submitted) _buildResult(context) else _buildSubmit(context),
        ],
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, int index) {
    final theme = Theme.of(context);
    final question = questions[index];
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
              // Hear the question read aloud in the target language.
              SpeakIconButton(text: question.question, size: 20),
              if (question.questionTranslation != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                  tooltip: CourseSession.instance.strings.help,
                  icon: const Icon(Icons.translate_rounded, size: 20),
                  onPressed: () =>
                      _showTranslation(context, question, optionOrder[index]),
                ),
            ],
          ),
          const SizedBox(height: 6),
          for (final o in optionOrder[index]) _buildOption(context, index, o),
          if (submitted && question.explanation != null) ...[
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
    final question = questions[qIndex];
    final isSelected = selected[qIndex] == oIndex;
    final isCorrect = question.correctIndex == oIndex;

    Color? tileColor;
    Color borderColor = theme.colorScheme.outlineVariant;
    Widget? trailing;
    if (submitted) {
      if (isCorrect) {
        tileColor = Colors.green.withValues(alpha: 0.12);
        borderColor = Colors.green.shade600;
        trailing = Icon(Icons.check_circle_rounded, color: Colors.green.shade700);
      } else if (isSelected) {
        tileColor = theme.colorScheme.errorContainer.withValues(alpha: 0.4);
        borderColor = theme.colorScheme.error;
        trailing = Icon(Icons.cancel_rounded, color: theme.colorScheme.error);
      }
    } else if (isSelected) {
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
          onTap: submitted ? null : () => onSelect(qIndex, oIndex),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: isSelected
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
                // Hear this answer option in the target language.
                SpeakIconButton(text: question.options[oIndex], size: 18),
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
          onPressed: _allAnswered ? onSubmit : null,
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
          '$_correctCount / ${questions.length} ${strings.readingCorrect}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        if (bestCorrect != null)
          Text(
            '${strings.best}: $bestCorrect / ${questions.length}',
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
                onPressed: onRetry,
                icon: const Icon(Icons.replay_rounded),
                label: Text(strings.readingTryAgain),
              ),
            ),
            if (passed && nextExercise != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => nextExercise!.open(context),
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
                if (submitted && explanationTranslation != null) ...[
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
}
