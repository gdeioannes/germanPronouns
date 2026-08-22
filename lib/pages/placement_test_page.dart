import 'package:flutter/material.dart';

import '../data/placement/placement_modules.dart';
import '../data/placement/placement_test.dart';
import '../l10n/placement_strings.dart';
import '../models/course_session.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';

/// The placement test: fill-in questions drawn from every module of the active
/// course, asked from the easiest module upward.
///
/// It stops the moment a module is failed — that module is the answer, and
/// asking the learner forty more questions about levels they've already shown
/// they aren't at would be pure friction. Nothing here writes progress: the
/// page returns the chosen module index and the caller decides whether to
/// apply it (see `placement_start_sheet.dart`).
class PlacementTestPage extends StatefulWidget {
  const PlacementTestPage({
    super.key,
    required this.modules,
    required this.questions,
  });

  final List<PlacementModule> modules;
  final List<PlacementQuestion> questions;

  @override
  State<PlacementTestPage> createState() => _PlacementTestPageState();
}

class _PlacementTestPageState extends State<PlacementTestPage> {
  final TextEditingController _answer = TextEditingController();

  /// Held so every question can take the caret back. Tapping "Next" or "I
  /// don't know" hands focus to the button, and the field is the same widget
  /// across questions, so `autofocus` only ever fires on the first one.
  final FocusNode _answerFocus = FocusNode();

  final List<String> _answers = [];

  PlacementResult? _result;

  PlacementStrings get _s => CourseSession.instance.strings.placement;

  List<PlacementQuestion> get _questions => widget.questions;

  PlacementQuestion get _current => _questions[_answers.length];

  @override
  void dispose() {
    _answer.dispose();
    _answerFocus.dispose();
    super.dispose();
  }

  void _submit() {
    _answers.add(_answer.text);
    _answer.clear();
    // Stop as soon as a finished module has been failed, or when the paper runs
    // out. Either way the scorer sees only the answers actually given.
    if (_answers.length >= _questions.length ||
        placementDecided(_questions, _answers)) {
      final result = scorePlacement(
        _questions,
        _answers,
        moduleCount: widget.modules.length,
      );
      Analytics.track('placement_test_finished', {
        'course': CourseSession.instance.activeCourse.id,
        'module': widget.modules[result.moduleIndex].id,
        'answered': _answers.length,
        'whole_test': result.completedWholeTest,
      });
      setState(() => _result = result);
      return;
    }
    setState(() {});
    // Straight on to the next question with the caret already in the field, so
    // the whole test can be typed without reaching for the screen.
    _answerFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: Text(_s.testTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: result == null
                ? _questionView(context)
                : _resultView(context, result),
          ),
        ),
      ),
    );
  }

  Widget _questionView(BuildContext context) {
    final theme = Theme.of(context);
    final q = _current;
    final index = _answers.length;
    final isLast = index == _questions.length - 1;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      children: [
        LinearProgressIndicator(value: index / _questions.length),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                _s.questionCounter
                    .replaceAll('{i}', '${index + 1}')
                    .replaceAll('{n}', '${_questions.length}'),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            // The band this question is testing. Shown deliberately: the test
            // climbs the levels, and seeing that is half of what makes the
            // result believable.
            Chip(
              label: Text(widget.modules[q.moduleIndex].shortTitle),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (q.prompt != null) ...[
          Text(q.prompt!, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
        ],
        Text(
          q.sentence,
          style: theme.textTheme.headlineSmall?.copyWith(height: 1.4),
        ),
        if (q.english != null) ...[
          const SizedBox(height: 8),
          Text(
            q.english!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: _answer,
          focusNode: _answerFocus,
          autofocus: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: _s.answerLabel,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submit,
            child: Text(isLast ? _s.seeResult : _s.next),
          ),
        ),
        const SizedBox(height: 8),
        // An explicit "I don't know" beats a guessed answer: it keeps the
        // placement honest and costs the learner nothing.
        Center(
          child: TextButton(onPressed: _submit, child: Text(_s.dontKnow)),
        ),
      ],
    );
  }

  Widget _resultView(BuildContext context, PlacementResult result) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final module = widget.modules[result.moduleIndex];
    final asked = result.askedByModule[result.moduleIndex] ?? 0;
    final correct = result.correctByModule[result.moduleIndex] ?? 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        Text(
          _s.resultTitle.replaceAll('{level}', module.shortTitle),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          module.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          result.completedWholeTest ? _s.resultCleared : _s.resultStopped,
          style: theme.textTheme.bodyMedium,
        ),
        if (asked > 0) ...[
          const SizedBox(height: 12),
          Text(
            _s.resultScoreLine
                .replaceAll('{correct}', '$correct')
                .replaceAll('{asked}', '$asked'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(kRadiusLarge),
          ),
          child: Text(
            _s.noRewardsNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          // Returns the placement to the caller, which handles the
          // delete-your-progress confirmation before anything is written.
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(result.moduleIndex),
            child: Text(_s.startHere),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.cancel),
          ),
        ),
      ],
    );
  }
}
