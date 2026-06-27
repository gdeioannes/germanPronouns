import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_page.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../theme/app_theme.dart';
import '../theme/brand_palette.dart';
import '../utils/answer_normalization.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_panel.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/speak_icon_button.dart';

/// One run of the parsed [QuizContent.inlineTemplate]: either a literal stretch
/// of [text], or the [blankIndex]-th interactive blank.
class _Token {
  const _Token.text(this.text) : blankIndex = -1;
  const _Token.blank(this.blankIndex) : text = '';

  final String text;
  final int blankIndex;

  bool get isBlank => blankIndex >= 0;
}

final RegExp _placeholder = RegExp(r'\{\{(\d+)\}\}');

/// Splits an [inlineTemplate] into literal-text and blank tokens, in order.
List<_Token> _tokenize(String template) {
  final tokens = <_Token>[];
  var cursor = 0;
  for (final match in _placeholder.allMatches(template)) {
    if (match.start > cursor) {
      tokens.add(_Token.text(template.substring(cursor, match.start)));
    }
    tokens.add(_Token.blank(int.parse(match.group(1)!)));
    cursor = match.end;
  }
  if (cursor < template.length) {
    tokens.add(_Token.text(template.substring(cursor)));
  }
  return tokens;
}

/// An inline "big text" reading quiz ([QuizKind.reading] carrying
/// [QuizContent.inlineBlanks]): the learner answers *inside* the passage — a
/// dropdown picks the case at each marked phrase (`select`), or a small field is
/// typed into the text (`input`, e.g. an adjective ending). Submitting marks
/// each blank ✓/✗, reveals the correct answers, and — like the multiple-choice
/// reading page — passing (≥ 65 %) marks the quiz complete (unlocking the next
/// Quest step when [questProgressionKey] is set). Best score is stored locally.
class InlineClozeQuizPage extends StatefulWidget {
  const InlineClozeQuizPage({
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
  State<InlineClozeQuizPage> createState() => _InlineClozeQuizPageState();
}

class _InlineClozeQuizPageState extends State<InlineClozeQuizPage> {
  late final List<_Token> _tokens = _tokenize(widget.content.inlineTemplate ?? '');
  List<InlineBlank> get _blanks => widget.content.inlineBlanks;

  /// Current answer per blank: the chosen option for a select blank, or the
  /// controller's text for an input blank (kept in [_controllers]).
  late final List<String?> _answers = List<String?>.filled(_blanks.length, null);
  late final Map<int, TextEditingController> _controllers = {
    for (var i = 0; i < _blanks.length; i++)
      if (!_blanks[i].isSelect) i: TextEditingController(),
  };

  bool _submitted = false;
  int? _bestCorrect;
  NextExercise? _nextExercise;

  int get _correctCount {
    var n = 0;
    for (var i = 0; i < _blanks.length; i++) {
      if (_isCorrect(i)) n++;
    }
    return n;
  }

  /// At least 65 % of the blanks, rounded up — matching the reading quiz.
  int get _passThreshold =>
      _blanks.isEmpty ? 0 : (_blanks.length * 65 + 99) ~/ 100;

  bool get _passed => _correctCount >= _passThreshold;

  bool get _allAnswered {
    for (var i = 0; i < _blanks.length; i++) {
      if ((_currentAnswer(i) ?? '').trim().isEmpty) return false;
    }
    return true;
  }

  String? _currentAnswer(int i) =>
      _blanks[i].isSelect ? _answers[i] : _controllers[i]?.text;

  /// The full passage with every blank filled by its correct answer — the
  /// natural, complete target-language text to read aloud via the speak icon.
  String get _solvedPassage {
    final buffer = StringBuffer();
    for (final token in _tokens) {
      buffer.write(token.isBlank ? _blanks[token.blankIndex].answer : token.text);
    }
    return buffer.toString();
  }

  bool _isCorrect(int i) {
    final blank = _blanks[i];
    final given = _currentAnswer(i) ?? '';
    if (blank.isSelect) return given == blank.answer;
    final relaxed = NounSettings.instance.relaxedCorrection;
    final norm = normalizeAnswer(given, relaxed: relaxed);
    if (norm.isEmpty) return false;
    return norm == normalizeAnswer(blank.answer, relaxed: relaxed) ||
        blank.accepted.any((a) => norm == normalizeAnswer(a, relaxed: relaxed));
  }

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

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
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
      for (var i = 0; i < _answers.length; i++) {
        _answers[i] = null;
      }
      for (final c in _controllers.values) {
        c.clear();
      }
    });
  }

  void _showPassageTranslation(BuildContext context) {
    final translation = widget.content.readingPassageTranslation;
    if (translation == null) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.translate_rounded, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.content.readingTitle ??
                      CourseSession.instance.strings.help,
                ),
              ),
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
    return QuizScaffold(
      content: widget.content,
      currentPage: widget.currentPage,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              // Pad past the keyboard so the focused blank can scroll above it
              // (QuizScaffold no longer reserves keyboard space).
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              children: [
                const SizedBox(height: 8),
                _buildPassageCard(context),
                const SizedBox(height: 16),
                if (!_submitted) ...[
                  if (!_allAnswered)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        strings.readingAnswerAll,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: _allAnswered ? _submit : null,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(strings.readingCheckAnswers),
                  ),
                ] else
                  _buildResult(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassageCard(BuildContext context) {
    final theme = Theme.of(context);
    final content = widget.content;
    return QuizPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              // Read the full passage (blanks filled in) in the target language.
              SpeakIconButton(text: _solvedPassage, size: 20),
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
          const SizedBox(height: 12),
          _buildInlineText(context),
        ],
      ),
    );
  }

  /// The passage as flowing rich text with each `{{n}}` rendered as an inline
  /// control (dropdown or typed field) via a [WidgetSpan].
  Widget _buildInlineText(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyLarge?.copyWith(height: 1.9);
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          for (final token in _tokens)
            if (token.isBlank)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildBlank(context, token.blankIndex),
                ),
              )
            else
              TextSpan(text: token.text),
        ],
      ),
    );
  }

  Widget _buildBlank(BuildContext context, int i) {
    final blank = _blanks[i];
    return blank.isSelect ? _buildSelect(context, i) : _buildInput(context, i);
  }

  /// Border/fill color of a blank: neutral before submit, green/red after.
  Color _blankColor(BuildContext context, int i) {
    final scheme = Theme.of(context).colorScheme;
    if (!_submitted) return scheme.outline;
    return _isCorrect(i) ? const Color(kBrandForest) : scheme.error;
  }

  Widget _buildSelect(BuildContext context, int i) {
    final theme = Theme.of(context);
    final blank = _blanks[i];
    final color = _blankColor(context, i);
    final correct = _submitted && _isCorrect(i);
    final wrong = _submitted && !_isCorrect(i);

    final dropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: _submitted ? 2 : 1),
        borderRadius: BorderRadius.circular(kRadiusSmall),
        color: _submitted
            ? color.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _answers[i],
          isDense: true,
          hint: Text('— ?', style: theme.textTheme.bodyMedium),
          icon: Icon(
            correct
                ? Icons.check_rounded
                : wrong
                    ? Icons.close_rounded
                    : Icons.arrow_drop_down_rounded,
            size: 20,
            color: _submitted ? color : theme.colorScheme.onSurfaceVariant,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          onChanged: _submitted
              ? null
              : (v) => setState(() => _answers[i] = v),
          items: [
            for (final option in blank.options)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
        ),
      ),
    );

    if (wrong) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [dropdown, _correctionChip(context, blank.answer)],
      );
    }
    return dropdown;
  }

  Widget _buildInput(BuildContext context, int i) {
    final theme = Theme.of(context);
    final blank = _blanks[i];
    final color = _blankColor(context, i);
    final wrong = _submitted && !_isCorrect(i);

    final field = IntrinsicWidth(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 64, maxWidth: 160),
        child: TextField(
          controller: _controllers[i],
          enabled: !_submitted,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: blank.hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              borderSide: BorderSide(color: color),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              borderSide: BorderSide(color: color, width: 2),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );

    if (wrong) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [field, _correctionChip(context, blank.answer)],
      );
    }
    return field;
  }

  /// The small green "→ correct answer" shown under a wrong blank after submit.
  Widget _correctionChip(BuildContext context, String answer) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        '→ $answer',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(kBrandForest),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final correct = _correctCount;
    final total = _blanks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (_passed ? const Color(kBrandForest) : theme.colorScheme.error)
                .withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(kRadiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _passed ? strings.readingPassed : strings.readingKeepPracticing,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _passed
                      ? const Color(kBrandForest)
                      : theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$correct / $total ${strings.readingCorrect}'
                '${_bestCorrect != null ? '   ·   best $_bestCorrect / $total' : ''}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_passed && _nextExercise != null)
          FilledButton.icon(
            onPressed: () => _nextExercise!.open(context),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text('${strings.nextExercise}: ${_nextExercise!.title}'),
          ),
        if (_passed && _nextExercise != null) const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _retry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(strings.readingTryAgain),
        ),
      ],
    );
  }
}
