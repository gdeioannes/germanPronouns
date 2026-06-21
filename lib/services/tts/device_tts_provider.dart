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

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

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
    _tts.setStartHandler(() => onSpeakingChanged?.call(true));
    _tts.setCompletionHandler(() => onSpeakingChanged?.call(false));
    _tts.setCancelHandler(() => onSpeakingChanged?.call(false));
    _tts.setErrorHandler((_) => onSpeakingChanged?.call(false));
  }

  @override
  Future<void> warmUp(String locale) async {
    await _ensureInitialized();
    await _applyLanguage(locale);
  }

  @override
  Future<bool> speak(String text, String locale) async {
    if (text.trim().isEmpty) return true;
    await _ensureInitialized();
    await _applyLanguage(locale);
    await _tts.speak(text); // awaits completion (awaitSpeakCompletion is on)
    return true;
  }

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
