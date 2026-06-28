import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_page.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../services/tts/tts_service.dart';
import '../theme/app_theme.dart';
import '../utils/speech_match.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_panel.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/speak_icon_button.dart';
import '../widgets/voice_status_chip.dart';

/// One sentence to dictate: the German [sentence] read aloud (and the target the
/// typed answer is checked against) and its [meaning] revealed after answering.
/// [gender] picks the voice that dictates it.
class _DictationItem {
  const _DictationItem({
    required this.sentence,
    required this.meaning,
    required this.gender,
  });
  final String sentence;
  final String meaning;
  final VoiceGender gender;
}

/// A dictation (Diktat) quiz ([QuizKind.dictation]) — a listen-&-write exercise
/// and the writing (Schreiben) counterpart of the listening quiz. TTS reads each
/// German sentence aloud (never shown until answered) and the learner **types**
/// what they hear. The answer is checked forgivingly via [normalizeForSpeech]
/// (case, punctuation and umlaut spelling ä/ae are folded away) plus a small
/// [similarity] tolerance, so a single typo doesn't fail an otherwise-correct
/// sentence.
///
/// Dictation needs no microphone. It is scored like reading/listening: getting
/// at least [_passThreshold] of the sentences right marks [questProgressionKey]
/// complete (via [NounSettings.markDictationQuizCompleted] and
/// [NounSettings.markQuestQuizCompleted]), unlocking the next Quest quiz.
class DictationQuizPage extends StatefulWidget {
  const DictationQuizPage({
    super.key,
    required this.content,
    required this.currentPage,
    this.questProgressionKey,
  });

  final QuizContent content;
  final AppPage currentPage;
  final String? questProgressionKey;

  @override
  State<DictationQuizPage> createState() => _DictationQuizPageState();
}

class _DictationQuizPageState extends State<DictationQuizPage>
    with SingleTickerProviderStateMixin {
  final TtsService _voice = TtsService.instance;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  bool _speaking = false;
  int _speakGen = 0;

  late final List<_DictationItem> _items = [
    for (final s in widget.content.subjects)
      _DictationItem(
        sentence: s.display,
        meaning: s.english ?? '',
        // Per-line speaker if set, otherwise the quiz's default voice.
        gender: s.voiceGender ?? widget.content.voiceGender,
      ),
  ];

  int _index = 0;

  /// True once the current sentence has been checked (reveals the answer).
  bool _checked = false;

  /// Whether the checked answer was accepted. Null while unanswered.
  bool? _correct;

  /// How many sentences were typed correctly (each counts once).
  int _correctCount = 0;

  bool _finished = false;
  int? _bestCorrect;
  NextExercise? _nextExercise;

  _DictationItem get _item => _items[_index];

  String get _learnLocale => CourseSession.instance.activeCourse.learnLocale;

  /// Sentences to get right to pass: at least 65%, rounded up.
  int get _passThreshold =>
      _items.isEmpty ? 0 : (_items.length * 65 + 99) ~/ 100;

  bool get _passed => _correctCount >= _passThreshold;
  String get _bestKey => '${widget.content.storageKeyPrefix}dictation_best';

  @override
  void initState() {
    super.initState();
    _voice.speaking.addListener(_onSpeakingChanged);
    _loadBest();
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      _nextExercise = questNextExercise(questKey);
    } else {
      resolveNextExerciseForContent(widget.content.id).then((next) {
        if (mounted && next != null) setState(() => _nextExercise = next);
      });
    }
    _warmUpAndPlay();
  }

  Future<void> _warmUpAndPlay() async {
    await _voice.warmUp(_learnLocale);
    if (!mounted) return;
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted && !_finished) _play();
    });
  }

  Future<void> _loadBest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final best = prefs.getInt(_bestKey);
      if (mounted && best != null) setState(() => _bestCorrect = best);
    } catch (_) {
      // Best-effort.
    }
  }

  void _onSpeakingChanged() {
    if (!mounted) return;
    final speaking = _voice.speaking.value;
    if (_speaking == speaking) return;
    // Run the pulse clock only while audio actually plays. Left repeating, it
    // rebuilds the indicator 60×/sec for nothing — a needless battery/heat drain
    // (notably on web), since the scale ignores [_pulse] unless [_speaking].
    if (speaking) {
      _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
    setState(() => _speaking = speaking);
  }

  /// Reads the current sentence aloud, superseding any in-flight play.
  Future<void> _play() async {
    if (_items.isEmpty) return;
    final gen = ++_speakGen;
    try {
      await _voice.stop();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!mounted || gen != _speakGen) return;
      await _voice.speak(_item.sentence, _learnLocale, gender: _item.gender);
    } catch (_) {
      // Ignore playback errors.
    }
  }

  /// Whether [typed] is accepted for [target]: a normalized exact match (folding
  /// case, punctuation and umlaut spelling) or a ≥ 0.9 similarity, so one small
  /// typo in a longer sentence still passes.
  bool _isCorrect(String typed, String target) {
    final t = normalizeForSpeech(typed);
    final g = normalizeForSpeech(target);
    if (g.isEmpty) return false;
    if (t == g) return true;
    return similarity(t, g) >= 0.9;
  }

  void _check() {
    if (_checked || _controller.text.trim().isEmpty) return;
    final correct = _isCorrect(_controller.text, _item.sentence);
    setState(() {
      _checked = true;
      _correct = correct;
      if (correct) _correctCount++;
    });
  }

  Future<void> _next() async {
    _speakGen++;
    await _voice.stop();
    if (_index >= _items.length - 1) {
      await _finish();
      return;
    }
    setState(() {
      _index++;
      _checked = false;
      _correct = null;
      _controller.clear();
    });
    _focus.requestFocus();
    _play();
  }

  Future<void> _finish() async {
    setState(() => _finished = true);
    if (_bestCorrect == null || _correctCount > _bestCorrect!) {
      _bestCorrect = _correctCount;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_bestKey, _correctCount);
      } catch (_) {
        // Best-effort.
      }
    }
    if (_passed) {
      final newlyDone =
          !NounSettings.instance.isDictationQuizCompleted(widget.content.id);
      await NounSettings.instance.markDictationQuizCompleted(widget.content.id);
      // Finishing any quiz earns its (bronze) ribbon and pays out coins.
      if (newlyDone) {
        await CoinWallet.instance.add(CoinWallet.rollRibbonCoins(1));
      }
      if (widget.questProgressionKey != null) {
        await NounSettings.instance.markQuestQuizCompleted(
          widget.questProgressionKey!,
        );
      }
    }
  }

  void _restart() {
    _speakGen++;
    _voice.stop();
    setState(() {
      _index = 0;
      _checked = false;
      _correct = null;
      _correctCount = 0;
      _finished = false;
      _controller.clear();
    });
    _play();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _voice.speaking.removeListener(_onSpeakingChanged);
    _voice.stop();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
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
              // Pad past the keyboard so the answer field can scroll above it
              // (QuizScaffold no longer reserves keyboard space).
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              children: [
                const SizedBox(height: 8),
                if (_items.isEmpty)
                  _panel(
                    context,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No sentences to dictate.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (_finished)
                  _buildSummary(context)
                else
                  _buildCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context, {required Widget child}) =>
      QuizPanel(child: child);

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    return _panel(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: VoiceStatusChip(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_index + 1) / _items.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(kRadiusSmall),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_index + 1} / ${_items.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPlaySurface(context),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            focusNode: _focus,
            autofocus: false,
            enabled: !_checked,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _checked ? null : _check(),
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Type what you hear',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.edit_rounded),
            ),
          ),
          const SizedBox(height: 12),
          if (_checked) _buildFeedback(context),
          const SizedBox(height: 12),
          _buildControls(context),
        ],
      ),
    );
  }

  /// A tappable surface that plays (or replays) the current sentence, with a
  /// pulsing speaker while it reads. The sentence text stays hidden until the
  /// learner has answered.
  Widget _buildPlaySurface(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(kRadiusLarge),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _speaking ? null : _play,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              _buildSpeakingIndicator(context),
              const SizedBox(height: 10),
              Text(
                _speaking ? strings.playing : strings.tapToListen,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: _speaking
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to hear the sentence again.',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakingIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final active = _speaking;
        final color = active
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
        return Transform.scale(
          scale: active ? 1 + 0.18 * _pulse.value : 1,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: active ? 0.16 : 0.08),
            ),
            child: Icon(
              active ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              color: color,
              size: 28,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedback(BuildContext context) {
    final theme = Theme.of(context);
    final correct = _correct ?? false;
    final color = correct ? Colors.green.shade700 : theme.colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              correct
                  ? CourseSession.instance.strings.wellDone
                  : CourseSession.instance.strings.almostTryAgain,
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Reveal the correct sentence so the learner can compare spelling.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(kRadiusSmall),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _item.sentence,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Replay just this sentence in the target language.
                  SpeakIconButton(
                    text: _item.sentence,
                    gender: _item.gender,
                    size: 20,
                  ),
                ],
              ),
              if (_item.meaning.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _item.meaning,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final isLast = _index >= _items.length - 1;
    final strings = CourseSession.instance.strings;
    if (!_checked) {
      return FilledButton.icon(
        onPressed: _check,
        icon: const Icon(Icons.check_rounded),
        label: Text(strings.readingCheckAnswers),
      );
    }
    return FilledButton.icon(
      onPressed: _next,
      icon: Icon(isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded),
      label: Text(isLast ? strings.finish : strings.next),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final passed = _passed;
    final color = passed ? Colors.green.shade700 : theme.colorScheme.error;
    return _panel(
      context,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.celebration_rounded : Icons.refresh_rounded,
              size: 56,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              passed ? strings.readingPassed : strings.readingKeepPracticing,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$_correctCount / ${_items.length} ${strings.readingCorrect}',
              style: theme.textTheme.bodyMedium,
            ),
            if (_bestCorrect != null)
              Text(
                '${strings.best}: $_bestCorrect / ${_items.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _restart,
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
        ),
      ),
    );
  }
}
