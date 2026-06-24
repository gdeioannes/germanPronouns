import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../l10n/app_strings.dart';
import '../models/app_page.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../services/tts/tts_service.dart';
import '../theme/app_theme.dart';
import '../utils/speech_match.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_panel.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/voice_status_chip.dart';

/// One phrase to practice: the German text read aloud and repeated, plus its
/// Spanish meaning shown underneath.
class _SpeakCard {
  const _SpeakCard({required this.phrase, required this.meaning});
  final String phrase;
  final String meaning;
}

/// A "listen & repeat" pronunciation quiz ([QuizKind.speakRepeat]): the app
/// reads each German phrase aloud (TTS) and the learner repeats it, which is
/// checked with on-device/browser speech recognition (STT).
///
/// Speech recognition is feature-detected at runtime via [SpeechToText]
/// `initialize`. Where it isn't available (no microphone, an unsupported
/// browser, or a platform without a recognizer), the quiz degrades to a plain
/// "listen and press Next" flow.
class SpeakRepeatQuizPage extends StatefulWidget {
  const SpeakRepeatQuizPage({
    super.key,
    required this.content,
    required this.currentPage,
    this.questProgressionKey,
  });

  final QuizContent content;
  final AppPage currentPage;

  /// When set, this quiz is a Quest-chain entry: playing through to the end
  /// marks this key complete, unlocking the next chain quiz. Speaking never
  /// requires a microphone, so reaching the end is always achievable.
  final String? questProgressionKey;

  @override
  State<SpeakRepeatQuizPage> createState() => _SpeakRepeatQuizPageState();
}

class _SpeakRepeatQuizPageState extends State<SpeakRepeatQuizPage>
    with SingleTickerProviderStateMixin {
  /// Reads phrases aloud through the premium-cloud → on-device fallback chain,
  /// and exposes which voice is live (shown by [VoiceStatusChip]).
  final TtsService _voice = TtsService.instance;
  final SpeechToText _speech = SpeechToText();

  /// Drives the pulsing "speaking" indicator while TTS plays.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  /// True while the phrase is being read aloud (TTS), driven by the engine's
  /// start/completion handlers.
  bool _speaking = false;

  late final List<_SpeakCard> _cards = [
    for (final s in widget.content.subjects)
      _SpeakCard(phrase: s.display, meaning: s.english ?? ''),
  ];

  int _index = 0;

  /// Null until STT initialization finishes; then whether recognition is usable
  /// on this device/browser. Drives the mic-vs-Next-only UI.
  bool? _sttAvailable;

  bool _listening = false;

  /// The most recent transcript heard for the current card, or null if the
  /// learner hasn't spoken yet.
  String? _heard;

  /// Whether [_heard] matched the current phrase. Null while unanswered.
  bool? _correct;

  bool _finished = false;

  /// The exercise to advance to from the "Next exercise" button shown on the
  /// finished screen. Null when this is the last quiz in the course's nav.
  NextExercise? _nextExercise;

  /// Whether each phrase auto-plays (after a ~1s pause) when its card appears.
  /// Toggleable from the quiz box; manual playback (button or tile tap) always
  /// works regardless.
  bool _autoPlay = true;

  /// Bumped on every play request (and when starting the mic). A play only
  /// reaches `speak()` if its token is still the latest, so overlapping
  /// requests from auto-play, the button, and advancing can't stack up or
  /// leave a stale utterance playing.
  int _speakGen = 0;

  /// Whether playback (auto-play and the "Escuchar" action) also reads the
  /// meaning aloud in the learner's language after the German phrase.
  bool _alsoMeaning = false;

  /// How many times the loop plays through the whole word list. Editable, min 1.
  int _loopCount = 1;

  /// The largest loop count the stepper allows.
  static const int _maxLoopCount = 10;

  /// True while a loop playthrough of all words is running (drives the loop
  /// button's play/stop state).
  bool _looping = false;

  /// The language being learned (the phrase to repeat) — the active course's
  /// target locale (German for the original courses, Spanish for `de_es`).
  String get _learnLocale => CourseSession.instance.activeCourse.learnLocale;

  /// TTS locale for the meaning, derived from the active course's UI language.
  String get _meaningLocale =>
      switch (CourseSession.instance.activeCourse.uiLang) {
        UiLang.es => 'es-ES',
        UiLang.en => 'en-US',
        UiLang.de => 'de-DE',
      };

  /// Human label for the meaning's language (the learner's own language), used
  /// in buttons/toggles.
  String get _meaningLangLabel =>
      switch (CourseSession.instance.activeCourse.uiLang) {
        UiLang.es => 'español',
        UiLang.en => 'English',
        UiLang.de => 'Deutsch',
      };

  /// Localized chrome strings for the active course's UI language.
  AppStrings get _strings => CourseSession.instance.strings;

  @override
  void initState() {
    super.initState();
    _initEngines();
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      // A Quest-chain entry: the next exercise is the next chain quiz (the cert
      // course has no `quizzes` nav group for the nav-based resolver to use).
      _nextExercise = questNextExercise(questKey);
    } else {
      resolveNextExerciseForContent(widget.content.id).then((next) {
        if (mounted && next != null) setState(() => _nextExercise = next);
      });
    }
  }

  Future<void> _initEngines() async {
    // Mirror the shared engine's speaking state onto this page's indicator.
    _voice.speaking.addListener(_onSpeakingChanged);
    // Warm up the German voice so the first auto-play isn't read in English.
    await _voice.warmUp(_learnLocale);
    var available = false;
    try {
      available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: (_) {
          if (mounted) setState(() => _listening = false);
        },
      );
    } catch (_) {
      available = false;
    }
    if (!mounted) return;
    setState(() => _sttAvailable = available);
    // The first card deliberately does NOT auto-play. On the web the speech
    // engine won't start an utterance until the page has had a user gesture, so
    // an auto-play right after load (especially a refresh) stalls and gets stuck
    // instead of speaking. The learner taps play for this first card; from card
    // two onward that tap counts as the gesture and auto-play (in _next) works.
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;
    final stillGoing = status == SpeechToText.listeningStatus;
    if (_listening != stillGoing) setState(() => _listening = stillGoing);
  }

  /// Reflects the shared TTS engine's "speaking" state onto this page (drives
  /// the pulsing indicator and disables play taps while a phrase plays).
  void _onSpeakingChanged() {
    if (!mounted) return;
    final speaking = _voice.speaking.value;
    if (_speaking != speaking) setState(() => _speaking = speaking);
  }

  _SpeakCard get _card => _cards[_index];

  /// Speaks [text] in [localeId], but only while [gen] is still the latest play
  /// request. Includes the post-stop gap that makes web playback reliable.
  Future<void> _speakOnce(String text, String localeId, int gen) async {
    if (text.trim().isEmpty) return;
    try {
      await _voice.stop();
      // The web SpeechSynthesis API silently drops an utterance when speak()
      // runs in the same tick as a cancel(); a short gap makes playback
      // reliable. The generation check then guarantees that only the latest
      // request actually speaks, so rapid taps / auto-play / advancing never
      // overlap or leave a stale phrase playing.
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!mounted || gen != _speakGen || _listening) return;
      await _voice.speak(text, localeId);
    } catch (_) {
      // Ignore playback errors (e.g. no audio output available).
    }
  }

  /// Reads the current phrase (German) once, then — if [_alsoMeaning] is on —
  /// its meaning in the learner's language, all under play request [gen].
  Future<void> _speakSequence(int gen) async {
    await _speakOnce(_card.phrase, _learnLocale, gen);
    if (_alsoMeaning) await _speakOnce(_card.meaning, _meaningLocale, gen);
  }

  /// Bumps the play token and clears any running loop, so a one-off play
  /// supersedes a loop cleanly. Returns the new token.
  int _supersede() {
    if (_looping) _looping = false;
    return ++_speakGen;
  }

  /// Plays the current card once (phrase, plus meaning if enabled).
  Future<void> _speakCurrent() async {
    if (_finished || _cards.isEmpty || _listening) return;
    final gen = _supersede();
    if (mounted) setState(() {});
    await _speakSequence(gen);
  }

  /// Plays every word in the quiz, [_loopCount] times through, advancing the
  /// visible card as it goes. Tapping the loop button again (or any other play /
  /// the mic / navigating) stops it. Safe against overlap via the play token.
  Future<void> _playLoop() async {
    if (_finished || _cards.isEmpty || _listening) return;
    // Toggle: a second tap while looping stops playback.
    if (_looping) {
      _stopLoop();
      return;
    }
    final gen = ++_speakGen;
    setState(() => _looping = true);
    for (var pass = 0; pass < _loopCount; pass++) {
      for (var i = 0; i < _cards.length; i++) {
        if (!mounted || gen != _speakGen || _listening) {
          _finishLoop(gen);
          return;
        }
        setState(() {
          _index = i;
          _heard = null;
          _correct = null;
        });
        await _speakSequence(gen);
      }
    }
    _finishLoop(gen);
  }

  /// Clears the looping flag if this play token still owns it.
  void _finishLoop(int gen) {
    if (mounted && gen == _speakGen && _looping) {
      setState(() => _looping = false);
    }
  }

  /// Stops a running loop immediately.
  void _stopLoop() {
    _speakGen++;
    _voice.stop();
    if (mounted) setState(() => _looping = false);
  }

  /// Reads just the meaning aloud in the learner's language (manual button).
  Future<void> _speakMeaning() async {
    if (_finished || _cards.isEmpty || _listening) return;
    final gen = _supersede();
    if (mounted) setState(() {});
    await _speakOnce(_card.meaning, _meaningLocale, gen);
  }

  /// Plays the current card automatically after a ~1s pause, unless the learner
  /// has turned auto-play off. Skips if the card changed or the page closed
  /// during the wait, so a stale card is never spoken.
  void _autoSpeak() {
    if (!_autoPlay) return;
    final scheduledIndex = _index;
    final scheduledGen = _speakGen;
    Future<void>.delayed(const Duration(seconds: 1), () {
      // Skip if the card changed, the page closed, the mic is active, or any
      // other playback (e.g. a loop) started in the meantime.
      if (!mounted ||
          _finished ||
          _index != scheduledIndex ||
          _listening ||
          _speakGen != scheduledGen) {
        return;
      }
      _speakCurrent();
    });
  }

  Future<void> _startListening() async {
    if (_sttAvailable != true || _listening) return;
    // Cancel any in-flight or scheduled playback (including a loop) so TTS can't
    // talk over the mic.
    _speakGen++;
    setState(() {
      _looping = false;
      _heard = null;
      _correct = null;
    });
    try {
      await _voice.stop();
      await _speech.listen(
        onResult: _onResult,
        listenOptions: SpeechListenOptions(
          localeId: 'de_DE',
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
          pauseFor: const Duration(seconds: 3),
          listenFor: const Duration(seconds: 8),
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _listening = false);
    }
  }

  void _onResult(SpeechRecognitionResult result) {
    if (!mounted || !result.finalResult) return;
    final heard = result.recognizedWords;
    setState(() {
      _heard = heard;
      _correct = matchesSpoken(heard, _card.phrase);
      _listening = false;
    });
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {
      // Ignore.
    }
    if (mounted) setState(() => _listening = false);
  }

  void _next() {
    // Navigating supersedes any running loop / in-flight playback.
    _speakGen++;
    _voice.stop();
    if (_index >= _cards.length - 1) {
      setState(() {
        _looping = false;
        _finished = true;
      });
      // Played through every phrase to the end: flag this quiz "done" so it
      // shows the ribbon on the quiz home page.
      NounSettings.instance.markSpeakQuizCompleted(widget.content.id);
      // As a Quest-chain entry, playing through also unlocks the next quiz.
      final questKey = widget.questProgressionKey;
      if (questKey != null) {
        NounSettings.instance.markQuestQuizCompleted(questKey);
      }
      return;
    }
    setState(() {
      _looping = false;
      _index++;
      _heard = null;
      _correct = null;
    });
    _autoSpeak();
  }

  void _restart() {
    _speakGen++;
    _voice.stop();
    setState(() {
      _looping = false;
      _index = 0;
      _heard = null;
      _correct = null;
      _finished = false;
    });
    _autoSpeak();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _voice.speaking.removeListener(_onSpeakingChanged);
    _voice.stop();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuizScaffold(
      content: widget.content,
      currentPage: widget.currentPage,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  /// Centers content and caps its width to match the other quizzes (which use
  /// a 620px panel) so it doesn't stretch across wide screens.
  Widget _sectionWithMaxWidth(Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: child,
      ),
    );
  }

  /// The bordered, shadowed, rounded panel used by the other quiz pages.
  Widget _panel(BuildContext context, {required Widget child}) =>
      QuizPanel(child: child);

  Widget _buildBody(BuildContext context) {
    final Widget content;
    if (_cards.isEmpty) {
      content = _panel(
        context,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            _strings.noPhrases,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (_sttAvailable == null) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_finished) {
      content = _buildSummary(context);
    } else {
      content = _buildCard(context);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        _sectionWithMaxWidth(content),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    return _panel(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Which voice is reading aloud (premium cloud vs offline), tappable
          // to retry premium or force the offline voice.
          const Align(
            alignment: Alignment.centerRight,
            child: VoiceStatusChip(),
          ),
          const SizedBox(height: 10),
          // Progress + counter on one line.
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_index + 1) / _cards.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(kRadiusSmall),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_index + 1} / ${_cards.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPhrase(context),
          const SizedBox(height: 12),
          _buildOptions(context),
          const SizedBox(height: 14),
          _buildFeedback(context),
          const SizedBox(height: 16),
          _buildControls(context),
        ],
      ),
    );
  }

  /// The phrase to repeat, in a contained tile. Tapping anywhere on the tile
  /// reads the phrase aloud (the whole panel is the play button); a small icon
  /// next to the meaning plays it in the learner's language.
  Widget _buildPhrase(BuildContext context) {
    final theme = Theme.of(context);
    final canSpeak = !_listening && !_speaking;
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(kRadiusLarge),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canSpeak ? _speakCurrent : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              _buildSpeakingIndicator(context),
              const SizedBox(height: 12),
              Text(
                _card.phrase,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_card.meaning.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _card.meaning,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 20,
                      tooltip: '${_strings.listenIn} $_meaningLangLabel',
                      color: theme.colorScheme.onSurfaceVariant,
                      onPressed: canSpeak ? _speakMeaning : null,
                      icon: const Icon(Icons.volume_up_rounded),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 6),
              Text(
                _speaking ? _strings.playing : _strings.tapToListen,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _speaking
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Compact playback options: chip toggles for auto-play and reading the
  /// meaning, plus the "play all in a loop" control with its count.
  Widget _buildOptions(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              avatar: const Icon(Icons.play_circle_outline_rounded, size: 18),
              label: const Text('Auto'),
              selected: _autoPlay,
              onSelected: (value) {
                setState(() => _autoPlay = value);
                // Turning it on mid-card plays the current phrase right away.
                if (value) _speakCurrent();
              },
            ),
            FilterChip(
              avatar: const Icon(Icons.translate_rounded, size: 18),
              label: Text(_meaningLangLabel),
              selected: _alsoMeaning,
              onSelected: (value) => setState(() => _alsoMeaning = value),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildLoopControls(context),
      ],
    );
  }

  /// A circular speaker badge that pulses while the phrase is being read aloud.
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
    if (_heard == null) {
      if (_sttAvailable != true) {
        return Text(
          _strings.micUnavailable,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      }
      return Text(
        _listening ? _strings.listening : _strings.tapMicAndRepeat,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    final correct = _correct ?? false;
    final color = correct ? Colors.green.shade700 : theme.colorScheme.error;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              correct ? _strings.wellDone : _strings.almostTryAgain,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (_heard!.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '${_strings.iHeard} "${_heard!}"',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final isLast = _index >= _cards.length - 1;
    final nextLabel = isLast ? _strings.finish : _strings.next;

    if (_sttAvailable != true) {
      // No recognizer: listen-and-advance only.
      return FilledButton.icon(
        onPressed: _next,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(nextLabel),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _listening
              ? FilledButton.tonalIcon(
                  onPressed: _stopListening,
                  icon: const Icon(Icons.stop_rounded),
                  label: Text(_strings.stop),
                )
              : FilledButton.tonalIcon(
                  onPressed: _startListening,
                  icon: const Icon(Icons.mic_rounded),
                  label: Text(_heard == null ? _strings.repeat : _strings.retry),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _listening ? null : _next,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(nextLabel),
          ),
        ),
      ],
    );
  }

  /// A "play all in a loop" button beside an editable count (min 1): tapping it
  /// plays through every word in the quiz, that many times. Tapping again stops.
  Widget _buildLoopControls(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: _listening ? null : _playLoop,
          icon: Icon(_looping ? Icons.stop_rounded : Icons.repeat_rounded),
          label: Text(_looping ? _strings.stop : _strings.playAll),
        ),
        const SizedBox(width: 12),
        // Editable loop count: − / value / +.
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadiusSmall),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _strings.decrease,
                onPressed: _loopCount > 1
                    ? () => setState(() => _loopCount--)
                    : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(
                width: 24,
                child: Text(
                  '$_loopCount',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _strings.increase,
                onPressed: _loopCount < _maxLoopCount
                    ? () => setState(() => _loopCount++)
                    : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    return _panel(
      context,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(_strings.finished, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              _strings.speakFinishedBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.replay_rounded),
              label: Text(_strings.repeatAgain),
            ),
            if (_nextExercise != null) ...[
              const SizedBox(height: 12),
              _buildNextExerciseButton(context, _nextExercise!),
            ],
          ],
        ),
      ),
    );
  }

  /// A full-width "Next exercise" call-to-action shown on the finished screen,
  /// advancing to [next].
  Widget _buildNextExerciseButton(BuildContext context, NextExercise next) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => next.open(context),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        ),
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CourseSession.instance.strings.nextExercise,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              next.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
