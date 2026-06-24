import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'tts_provider.dart';

/// The always-available, on-device floor of the TTS chain. Hands text to the
/// platform/browser speech engine via [FlutterTts] — robotic on some platforms
/// (Windows SAPI, many browsers), but it needs no network, key, or audio-asset
/// pipeline, so it guarantees the learner always hears *something*.
///
/// The voice-selection and engine-setup logic here was lifted verbatim from the
/// speak-&-repeat quiz page, which previously drove [FlutterTts] directly.
class DeviceTtsProvider implements TtsProvider {
  DeviceTtsProvider({this.onSpeakingChanged});

  /// Notified true when the engine starts a phrase and false when it stops
  /// (completed, cancelled, or errored) — drives the speaking indicator.
  final ValueChanged<bool>? onSpeakingChanged;

  /// A short pause prepended to every phrase. Browser SpeechSynthesis and the
  /// Windows SAPI engine drop the first fraction of a second while their audio
  /// pipeline spins up, clipping the start of the first word. A leading comma
  /// renders as a brief silence — it isn't vocalised at the default punctuation
  /// verbosity — so the spin-up swallows that silence instead of the word.
  /// (SSML's `<break>` can't be used here: these engines read the tag literally
  /// rather than honouring it; `setSilence` is Android-only. The comma is the
  /// portable lever.)
  static const String _leadInPause = ', ';

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  /// True once the engine has been kicked with a silent priming utterance, so
  /// we only do it once per app load.
  bool _primed = false;

  /// True only while the silent priming utterance is in flight, so its
  /// start/stop events don't blink the "speaking" indicator during warm-up.
  bool _priming = false;

  /// True once the engine has reported its (asynchronously-loaded) voice list,
  /// so we only wait for voices once.
  bool _voicesLoaded = false;

  /// The locale currently applied to the engine, so we skip re-selecting a
  /// voice when speaking consecutive phrases in the same language.
  String? _appliedLocale;

  @override
  String get id => 'device';

  @override
  String get displayName => 'Offline';

  @override
  VoiceTier get tier => VoiceTier.device;

  @override
  bool get isConfigured => true; // The floor is always available.

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    await _tts.setSpeechRate(0.45);
    await _tts.awaitSpeakCompletion(true);
    // The silent priming utterance must not drive the speaking indicator.
    _tts.setStartHandler(() {
      if (!_priming) onSpeakingChanged?.call(true);
    });
    _tts.setCompletionHandler(() {
      if (!_priming) onSpeakingChanged?.call(false);
    });
    _tts.setCancelHandler(() {
      if (!_priming) onSpeakingChanged?.call(false);
    });
    _tts.setErrorHandler((_) {
      if (!_priming) onSpeakingChanged?.call(false);
    });
  }

  @override
  Future<void> warmUp(String locale) async {
    await _ensureInitialized();
    await _applyLanguage(locale);
    await _prime();
  }

  /// Kicks the speech engine with a single inaudible utterance so the *first*
  /// real phrase actually plays. After a page load/refresh, browser
  /// SpeechSynthesis (and, less often, Windows SAPI) routinely drops or clips
  /// the first utterance — short ones can vanish entirely — until the engine
  /// has run once; the later phrases work because by then it's warm. Speaking a
  /// lone comma is silent (it isn't vocalised), so nothing is heard.
  ///
  /// Bounded by a timeout: on web a sub-second utterance sometimes never fires
  /// `onend`, and [_tts.speak] awaits completion (we turned that on), so without
  /// the cap a missing event would hang warm-up and stall the page.
  Future<void> _prime() async {
    if (_primed) return;
    _primed = true;
    _priming = true;
    try {
      var stalled = false;
      await _tts.speak(_leadInPause).timeout(
        const Duration(milliseconds: 800),
        onTimeout: () {
          stalled = true;
          return null;
        },
      );
      // A stalled prime leaves a pending utterance queued; clear it so it can't
      // sit in front of (and block) the first real phrase.
      if (stalled) await _tts.stop();
    } catch (_) {
      // Best effort; a failed prime just restores the old cold-start behaviour.
    } finally {
      _priming = false;
    }
  }

  @override
  Future<bool> speak(String text, String locale) async {
    if (text.trim().isEmpty) return true;
    await _ensureInitialized();
    await _applyLanguage(locale);
    // Lead-in pause so the engine's spin-up doesn't clip the first word.
    final phrase = '$_leadInPause$text';
    // Watchdog: web SpeechSynthesis can stall an utterance — typically the
    // first one after a refresh, before the page has had a user gesture — so it
    // never starts and never fires `onend`. Because we await completion, that
    // missing event would otherwise wedge this Future and leave the speaking
    // indicator stuck on. Cap the wait well above the clip's real length, then
    // cancel, so a stall degrades to silence instead of a permanent freeze.
    var stalled = false;
    await _tts.speak(phrase).timeout(
      _maxSpeakDuration(phrase),
      onTimeout: () {
        stalled = true;
        return null;
      },
    );
    if (stalled) await stop(); // clears the stuck utterance and resets state
    return true;
  }

  /// A deliberately generous upper bound on how long [text] takes to read at our
  /// slow speech rate — high enough never to cut real speech, only to break a
  /// stall. Scales with length so long passages (dictation/listening) aren't
  /// clipped.
  Duration _maxSpeakDuration(String text) =>
      const Duration(seconds: 4) + Duration(milliseconds: 200 * text.length);

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Best effort; nothing to stop is fine.
    }
  }

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
}
