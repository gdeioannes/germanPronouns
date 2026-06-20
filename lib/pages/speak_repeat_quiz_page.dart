import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/course.dart';
import '../models/course_session.dart';
import '../models/quiz_content.dart';
import '../theme/app_theme.dart';
import '../utils/speech_match.dart';
import '../widgets/app_drawer.dart';
import '../widgets/help_memory.dart';

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
  });

  final QuizContent content;
  final AppPage currentPage;

  @override
  State<SpeakRepeatQuizPage> createState() => _SpeakRepeatQuizPageState();
}

class _SpeakRepeatQuizPageState extends State<SpeakRepeatQuizPage>
    with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
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

  /// Whether each phrase auto-plays (after a ~1s pause) when its card appears.
  /// Toggleable from the quiz box; manual playback (button or tile tap) always
  /// works regardless.
  bool _autoPlay = true;

  /// True once the browser/engine has reported its (asynchronously-loaded)
  /// voice list, so we only wait for voices once.
  bool _voicesLoaded = false;

  /// The locale currently applied to the TTS engine, so we skip re-selecting a
  /// voice when speaking consecutive phrases in the same language.
  String? _appliedLocale;

  /// Bumped on every play request (and when starting the mic). A play only
  /// reaches `speak()` if its token is still the latest, so overlapping
  /// requests from auto-play, the button, and advancing can't stack up or
  /// leave a stale utterance playing.
  int _speakGen = 0;

  /// Whether playback (auto-play and the "Escuchar" action) also reads the
  /// meaning aloud in the learner's language after the German phrase.
  bool _alsoMeaning = false;

  /// The language being learned (the phrase to repeat).
  static const String _learnLocale = 'de-DE';

  /// TTS locale for the meaning, derived from the active course's UI language.
  String get _meaningLocale =>
      switch (CourseSession.instance.activeCourse.uiLang) {
        UiLang.es => 'es-ES',
        UiLang.en => 'en-US',
      };

  /// Human label for the meaning's language, used in buttons/toggles.
  String get _meaningLangLabel =>
      switch (CourseSession.instance.activeCourse.uiLang) {
        UiLang.es => 'español',
        UiLang.en => 'inglés',
      };

  @override
  void initState() {
    super.initState();
    _initEngines();
  }

  Future<void> _initEngines() async {
    try {
      await _tts.setSpeechRate(0.45);
      await _tts.awaitSpeakCompletion(true);
      _tts.setStartHandler(() {
        if (mounted) setState(() => _speaking = true);
      });
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _speaking = false);
      });
      _tts.setCancelHandler(() {
        if (mounted) setState(() => _speaking = false);
      });
      _tts.setErrorHandler((_) {
        if (mounted) setState(() => _speaking = false);
      });
      // Warm up the German voice so the first auto-play isn't read in English.
      await _applyLanguage(_learnLocale);
    } catch (_) {
      // TTS is best-effort; a silent failure just means no audio playback.
    }
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
    // Auto-play the first card (after a brief pause) once everything is ready.
    _autoSpeak();
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;
    final stillGoing = status == SpeechToText.listeningStatus;
    if (_listening != stillGoing) setState(() => _listening = stillGoing);
  }

  _SpeakCard get _card => _cards[_index];

  /// Waits (briefly, once) for the engine to report its voice list. On web the
  /// browser loads voices asynchronously and `setLanguage` only takes effect
  /// once they're available, so applying a language before this resolves would
  /// silently leave the default (usually English) voice.
  Future<void> _waitForVoices() async {
    if (_voicesLoaded) return;
    for (var attempt = 0; attempt < 8; attempt++) {
      try {
        final voices = await _tts.getVoices;
        if (voices is List && voices.isNotEmpty) {
          _voicesLoaded = true;
          return;
        }
      } catch (_) {
        // Engine may not expose voices on this platform; stop waiting.
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    _voicesLoaded = true; // Give up waiting and proceed with whatever exists.
  }

  /// Applies [localeId] (e.g. 'de-DE', 'es-ES') to the engine and selects a
  /// matching voice, so each language is read with its proper pronunciation.
  /// Skips work when the locale is already applied.
  Future<void> _applyLanguage(String localeId) async {
    if (_appliedLocale == localeId) return;
    await _waitForVoices();
    await _tts.setLanguage(localeId);
    await _selectVoice(localeId.split('-').first.toLowerCase());
    _appliedLocale = localeId;
  }

  /// Picks the first voice whose locale starts with [langPrefix] ('de', 'es',
  /// …), where the engine exposes a voice list. A no-op elsewhere.
  Future<void> _selectVoice(String langPrefix) async {
    try {
      final voices = await _tts.getVoices;
      if (voices is! List) return;
      for (final voice in voices) {
        if (voice is! Map) continue;
        final locale = (voice['locale'] ?? '').toString().toLowerCase();
        if (locale.startsWith(langPrefix)) {
          await _tts.setVoice({
            'name': (voice['name'] ?? '').toString(),
            'locale': (voice['locale'] ?? '').toString(),
          });
          return;
        }
      }
    } catch (_) {
      // Voice selection is best-effort; setLanguage already covers most cases.
    }
  }

  /// Speaks [text] in [localeId], but only while [gen] is still the latest play
  /// request. Includes the post-stop gap that makes web playback reliable.
  Future<void> _speakOnce(String text, String localeId, int gen) async {
    if (text.trim().isEmpty) return;
    try {
      await _tts.stop();
      // The web SpeechSynthesis API silently drops an utterance when speak()
      // runs in the same tick as a cancel(); a short gap makes playback
      // reliable. The generation check then guarantees that only the latest
      // request actually speaks, so rapid taps / auto-play / advancing never
      // overlap or leave a stale phrase playing.
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!mounted || gen != _speakGen || _listening) return;
      await _applyLanguage(localeId);
      if (!mounted || gen != _speakGen || _listening) return;
      await _tts.speak(text); // awaits completion (awaitSpeakCompletion is on)
    } catch (_) {
      // Ignore playback errors (e.g. no audio output available).
    }
  }

  /// Reads the current phrase (German), then — if [_alsoMeaning] is on — its
  /// meaning in the learner's language.
  Future<void> _speakCurrent() async {
    if (_finished || _cards.isEmpty || _listening) return;
    final gen = ++_speakGen;
    await _speakOnce(_card.phrase, _learnLocale, gen);
    if (_alsoMeaning) await _speakOnce(_card.meaning, _meaningLocale, gen);
  }

  /// Reads just the meaning aloud in the learner's language (manual button).
  Future<void> _speakMeaning() async {
    if (_finished || _cards.isEmpty || _listening) return;
    final gen = ++_speakGen;
    await _speakOnce(_card.meaning, _meaningLocale, gen);
  }

  /// Plays the current card automatically after a ~1s pause, unless the learner
  /// has turned auto-play off. Skips if the card changed or the page closed
  /// during the wait, so a stale card is never spoken.
  void _autoSpeak() {
    if (!_autoPlay) return;
    final scheduledIndex = _index;
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted || _finished || _index != scheduledIndex || _listening) {
        return;
      }
      _speakCurrent();
    });
  }

  Future<void> _startListening() async {
    if (_sttAvailable != true || _listening) return;
    // Cancel any in-flight or scheduled playback so TTS can't talk over the mic.
    _speakGen++;
    setState(() {
      _heard = null;
      _correct = null;
    });
    try {
      await _tts.stop();
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
    if (_index >= _cards.length - 1) {
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _index++;
      _heard = null;
      _correct = null;
    });
    _autoSpeak();
  }

  void _restart() {
    setState(() {
      _index = 0;
      _heard = null;
      _correct = null;
      _finished = false;
    });
    _autoSpeak();
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

  @override
  void dispose() {
    _pulse.dispose();
    _tts.stop();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
        actions: [
          IconButton(
            tooltip: 'Ayuda',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: _showHelp,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentPage: widget.currentPage,
        currentContentId: widget.content.id,
      ),
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

  Widget _buildBody(BuildContext context) {
    final Widget content;
    if (_cards.isEmpty) {
      content = _panel(
        context,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No hay frases en esta lección.',
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
          // Progress.
          LinearProgressIndicator(
            value: (_index + 1) / _cards.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
          const SizedBox(height: 8),
          Text(
            'Tarjeta ${_index + 1} de ${_cards.length}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _buildPhrase(context),
          const SizedBox(height: 8),
          _buildAutoPlayToggle(context),
          _buildAlsoMeaningToggle(context),
          const SizedBox(height: 12),
          _buildFeedback(context),
          const SizedBox(height: 24),
          _buildControls(context),
        ],
      ),
    );
  }

  /// The phrase to repeat, in a contained tile with the animated speaking
  /// indicator and a replay button. Tapping anywhere on the tile reads the
  /// phrase aloud, so the whole panel — not just the "Escuchar" button — says
  /// the word.
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _buildSpeakingIndicator(context),
              const SizedBox(height: 14),
              Text(
                _card.phrase,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_card.meaning.isNotEmpty) ...[
                const SizedBox(height: 10),
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
                    const SizedBox(width: 4),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 20,
                      tooltip: 'Escuchar en $_meaningLangLabel',
                      color: theme.colorScheme.onSurfaceVariant,
                      onPressed: canSpeak ? _speakMeaning : null,
                      icon: const Icon(Icons.volume_up_rounded),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: canSpeak ? _speakCurrent : null,
                icon: Icon(
                  _speaking
                      ? Icons.graphic_eq_rounded
                      : Icons.volume_up_rounded,
                ),
                label: Text(
                  _speaking ? 'Reproduciendo…' : 'Escuchar · toca la frase',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A compact switch in the quiz box to turn the 1-second auto-play of each
  /// phrase on or off.
  Widget _buildAutoPlayToggle(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_circle_outline_rounded,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          'Reproducir automáticamente',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Switch(
          value: _autoPlay,
          onChanged: (value) {
            setState(() => _autoPlay = value);
            // Turning it on mid-card plays the current phrase right away.
            if (value) _speakCurrent();
          },
        ),
      ],
    );
  }

  /// A compact switch to also read each phrase's meaning aloud (in the
  /// learner's language) after the German phrase, during playback.
  Widget _buildAlsoMeaningToggle(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.translate_rounded,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          'Decir también en $_meaningLangLabel',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Switch(
          value: _alsoMeaning,
          onChanged: (value) => setState(() => _alsoMeaning = value),
        ),
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
          'Micrófono no disponible. Escucha la frase y repítela en voz alta, '
          'luego pulsa Siguiente.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      }
      return Text(
        _listening
            ? 'Escuchando… repite la frase.'
            : 'Pulsa el micrófono y repite la frase.',
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
              correct ? '¡Bien hecho!' : 'Casi… inténtalo otra vez',
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
            'Te escuché: "${_heard!}"',
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
    final nextLabel = isLast ? 'Terminar' : 'Siguiente';

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
                  label: const Text('Detener'),
                )
              : FilledButton.tonalIcon(
                  onPressed: _startListening,
                  icon: const Icon(Icons.mic_rounded),
                  label: Text(_heard == null ? 'Repetir' : 'Reintentar'),
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
            Text('¡Terminado!', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Has practicado ${_cards.length} frases. '
              'Repite la lección cuando quieras.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Repetir de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}
