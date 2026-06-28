import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_page.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../services/tts/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/multiple_choice_questions.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_panel.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/speak_icon_button.dart';
import '../widgets/voice_status_chip.dart';

/// A listening-comprehension quiz ([QuizKind.listening]) — the audio twin of
/// [ReadingQuizPage]. A short German passage (~50 words) is **read aloud by TTS
/// and never shown on screen**; the learner then answers the same multiple-choice
/// questions (rendered by the shared [MultipleChoiceQuestions]). The German
/// script and its English translation sit behind an info button (the script is
/// the help, not the question), and the audio can be replayed at any time.
///
/// Listening needs no microphone, so — like reading — it is a properly scored,
/// gated step: passing (≥ [_passThreshold] of the questions) marks
/// [questProgressionKey] complete via [NounSettings.markListeningQuizCompleted]
/// (and [NounSettings.markQuestQuizCompleted]), unlocking the next quiz in the
/// Quest chain. Best score is stored locally.
class ListeningQuizPage extends StatefulWidget {
  const ListeningQuizPage({
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
  State<ListeningQuizPage> createState() => _ListeningQuizPageState();
}

class _ListeningQuizPageState extends State<ListeningQuizPage>
    with SingleTickerProviderStateMixin {
  /// Reads the passage aloud through the premium-cloud → on-device fallback
  /// chain, and exposes which voice is live (shown by [VoiceStatusChip]).
  final TtsService _voice = TtsService.instance;

  /// Drives the pulsing "speaking" indicator while TTS plays.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  /// True while the passage is being read aloud, mirrored from the engine.
  bool _speaking = false;

  /// True while playback is paused (mirrored from the engine). Distinct from
  /// [_speaking], which is false both when paused and when idle.
  bool _paused = false;

  /// Bumped on every play request; a play only reaches `speak()` if its token
  /// is still the latest, so overlapping taps can't stack up.
  int _speakGen = 0;

  /// Two stages: listen to the passage, then answer the questions.
  bool _showQuestions = false;

  /// Selected option index per question (null = unanswered), stored as the
  /// option's *original* index so scoring is unaffected by the shuffled order.
  late final List<int?> _selected = List<int?>.filled(_questions.length, null);

  /// Per-question display order, reshuffled on each attempt.
  late List<List<int>> _optionOrder = _shuffledOptionOrder();

  List<List<int>> _shuffledOptionOrder() => [
        for (final q in _questions)
          List<int>.generate(q.options.length, (i) => i)..shuffle(),
      ];

  bool _submitted = false;
  int? _bestCorrect;
  NextExercise? _nextExercise;

  List<ReadingQuestion> get _questions => widget.content.readingQuestions;

  String get _passage => widget.content.readingPassage ?? '';

  /// The active course's target locale (German for the cert course).
  String get _learnLocale => CourseSession.instance.activeCourse.learnLocale;

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
  String get _bestKey => '${widget.content.storageKeyPrefix}listening_best';

  @override
  void initState() {
    super.initState();
    _voice.speaking.addListener(_onSpeakingChanged);
    _voice.paused.addListener(_onPausedChanged);
    _loadBest();
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      _nextExercise = questNextExercise(questKey);
    } else {
      resolveNextExerciseForContent(widget.content.id).then((next) {
        if (mounted && next != null) setState(() => _nextExercise = next);
      });
    }
    // Warm up the German voice so the first play isn't read in English, but do
    // NOT auto-play: playback is started by the learner (tapping the play
    // surface). On the web the speech engine won't start an utterance before
    // the page has had a user gesture, so an auto-play on load stalls; letting
    // the learner press play also keeps them in control of when they listen.
    _voice.warmUp(_learnLocale);
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

  void _onPausedChanged() {
    if (!mounted) return;
    final paused = _voice.paused.value;
    if (_paused != paused) setState(() => _paused = paused);
  }

  /// Reads the (hidden) passage aloud once, superseding any in-flight play.
  Future<void> _playPassage() async {
    if (_passage.trim().isEmpty) return;
    final gen = ++_speakGen;
    try {
      await _voice.stop();
      // A short gap after stop() makes web SpeechSynthesis playback reliable;
      // the generation check then guarantees only the latest request speaks.
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!mounted || gen != _speakGen) return;
      await _voice.speak(
        _passage,
        _learnLocale,
        gender: widget.content.voiceGender,
      );
    } catch (_) {
      // Ignore playback errors (e.g. no audio output available).
    }
  }

  /// Pauses the passage mid-playback (the learner can resume from where it
  /// stopped, or stop entirely).
  Future<void> _pausePlayback() => _voice.pause();

  /// Resumes a paused passage. The premium voices resume in place; the on-device
  /// floor can't, so [TtsService.resume] reports false and we replay from the
  /// start.
  Future<void> _resumePlayback() async {
    final resumed = await _voice.resume();
    if (!resumed && mounted) await _playPassage();
  }

  /// Stops playback entirely and supersedes any in-flight play.
  Future<void> _stopPlayback() async {
    _speakGen++;
    await _voice.stop();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _voice.speaking.removeListener(_onSpeakingChanged);
    _voice.paused.removeListener(_onPausedChanged);
    _voice.stop();
    super.dispose();
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
      final newlyDone =
          !NounSettings.instance.isListeningQuizCompleted(widget.content.id);
      await NounSettings.instance.markListeningQuizCompleted(widget.content.id);
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

  void _retry() {
    setState(() {
      _submitted = false;
      for (var i = 0; i < _selected.length; i++) {
        _selected[i] = null;
      }
      _optionOrder = _shuffledOptionOrder();
      _showQuestions = false;
    });
    // Back on the listen screen, but idle — the learner taps play to hear it
    // again, matching the user-initiated playback everywhere else on this page.
    _voice.stop();
  }

  /// The transcript behind the info button: the German script the learner just
  /// heard, plus its English translation. Available any time so the quiz stays
  /// audio-first but the text is one tap away.
  void _showScript(BuildContext context) {
    final translation = widget.content.readingPassageTranslation;
    final title = widget.content.readingTitle;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.subject_rounded, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title ?? CourseSession.instance.strings.help),
              ),
              // Replay the script aloud in the target language.
              SpeakIconButton(text: _passage, size: 20),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _passage,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                if (translation != null) ...[
                  const Divider(height: 24),
                  Text(
                    translation,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
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
                if (!_showQuestions)
                  _buildListen(context)
                else ...[
                  _buildAudioBar(context),
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

  /// Stage 1 — the listen panel: a big play/replay surface (no passage text), a
  /// "Show text" info action, and a button to move on to the questions.
  Widget _buildListen(BuildContext context) {
    final theme = Theme.of(context);
    final content = widget.content;
    final strings = CourseSession.instance.strings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuizPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (content.readingCategory != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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
                  const Spacer(),
                  const VoiceStatusChip(),
                ],
              ),
              const SizedBox(height: 6),
              if (content.readingTitle != null)
                Text(
                  content.readingTitle!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const SizedBox(height: 16),
              // The big tappable play surface — the audio, never the text.
              _buildPlaySurface(context),
              // Pause / Resume / Stop, shown only while the audio is running.
              _buildPlaybackControls(context),
              const SizedBox(height: 12),
              // The script (German + English) is help, behind an info action.
              Center(
                child: TextButton.icon(
                  onPressed: () => _showScript(context),
                  icon: const Icon(Icons.subject_rounded, size: 18),
                  label: Text(CourseSession.instance.strings.showScript),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => setState(() => _showQuestions = true),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text(strings.readingStartQuestions),
        ),
      ],
    );
  }

  /// A large, full-width surface that starts the hidden passage when tapped (and
  /// pauses / resumes it while it plays), with a pulsing speaker while it reads.
  Widget _buildPlaySurface(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    // Tapping the surface drives the obvious next action for the current state:
    // start when idle, pause while playing, resume while paused.
    final VoidCallback onTap = _speaking
        ? _pausePlayback
        : _paused
            ? _resumePlayback
            : _playPassage;
    final String label = _speaking
        ? strings.playing
        : _paused
            ? strings.resume
            : strings.tapToListen;
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                _buildSpeakingIndicator(context),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _speaking
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CourseSession.instance.strings.listeningInstruction,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pause/Resume + Stop controls, shown under the play surface only while a
  /// passage is playing or paused, so the learner can hold or stop the audio.
  Widget _buildPlaybackControls(BuildContext context) {
    final strings = CourseSession.instance.strings;
    if (!_speaking && !_paused) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: _paused
                ? FilledButton.tonalIcon(
                    onPressed: _resumePlayback,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(strings.resume),
                  )
                : FilledButton.tonalIcon(
                    onPressed: _pausePlayback,
                    icon: const Icon(Icons.pause_rounded),
                    label: Text(strings.pause),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _stopPlayback,
              icon: const Icon(Icons.stop_rounded),
              label: Text(strings.stop),
            ),
          ),
        ],
      ),
    );
  }

  /// A circular speaker badge that pulses while the passage is being read aloud.
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
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: active ? 0.16 : 0.08),
            ),
            child: Icon(
              active ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
              color: color,
              size: 34,
            ),
          ),
        );
      },
    );
  }

  /// Stage 2 — a slim bar that keeps the audio one tap away while answering.
  Widget _buildAudioBar(BuildContext context) {
    final theme = Theme.of(context);
    return QuizPanel(
      child: Row(
        children: [
          Icon(Icons.hearing_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.content.readingTitle ?? 'Audio',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => _showScript(context),
            icon: const Icon(Icons.subject_rounded, size: 18),
            label: Text(CourseSession.instance.strings.scriptLabel),
          ),
          ..._buildAudioBarControls(context),
        ],
      ),
    );
  }

  /// Trailing playback controls for the stage-2 audio bar: a Replay button when
  /// idle, or compact Pause/Resume + Stop buttons while the audio is running, so
  /// the learner can hold or stop it without leaving the questions.
  List<Widget> _buildAudioBarControls(BuildContext context) {
    final strings = CourseSession.instance.strings;
    if (!_speaking && !_paused) {
      return [
        FilledButton.tonalIcon(
          onPressed: _playPassage,
          icon: const Icon(Icons.replay_rounded),
          label: Text(strings.replay),
        ),
      ];
    }
    return [
      IconButton(
        onPressed: _paused ? _resumePlayback : _pausePlayback,
        tooltip: _paused ? strings.resume : strings.pause,
        icon: Icon(_paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
      ),
      IconButton(
        onPressed: _stopPlayback,
        tooltip: strings.stop,
        icon: const Icon(Icons.stop_rounded),
      ),
    ];
  }
}
