import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'tts_provider.dart';

/// API keys / endpoints for the premium cloud voices.
///
/// Empty by default, so the cloud providers self-disable ([TtsProvider.isConfigured]
/// is false) and the chain quietly falls to the on-device voice. Supply at build
/// time with `--dart-define` (or `--dart-define-from-file=tts_secrets.json`),
/// e.g.
///
/// ```
/// flutter run --dart-define-from-file=tts_secrets.json
/// ```
///
/// where `tts_secrets.json` (gitignored) holds `AZURE_TTS_KEY`,
/// `AZURE_TTS_REGION`, and/or `GOOGLE_TTS_KEY`.
class TtsCloudConfig {
  const TtsCloudConfig._();

  static const String azureKey = String.fromEnvironment('AZURE_TTS_KEY');
  static const String azureRegion = String.fromEnvironment('AZURE_TTS_REGION');
  static const String googleKey = String.fromEnvironment('GOOGLE_TTS_KEY');

  /// URL of the server-side TTS proxy (e.g. a Cloudflare Worker) that holds the
  /// cloud keys. Used by [ProxyTtsProvider] on web, where a baked-in key would
  /// be exposed. NOT a secret, so pass it as a plain `--dart-define`:
  /// `flutter build web --dart-define=TTS_PROXY_URL=https://xxx.workers.dev`.
  static const String proxyUrl = String.fromEnvironment('TTS_PROXY_URL');
}

/// Shared scaffolding for the premium cloud voices. Each subclass turns
/// (text, locale) into encoded audio bytes via its REST API ([synthesize]);
/// this base then plays those bytes through [audioplayers] and reports
/// speaking state so the UI indicator pulses for cloud playback too.
///
/// Returning false (no bytes / a failed request) tells the chain to fall
/// through to the next provider, so a network hiccup degrades gracefully to the
/// on-device voice rather than going silent.
abstract class CloudTtsProvider implements TtsProvider {
  CloudTtsProvider({this.onSpeakingChanged});

  /// Notified true while a phrase plays and false when it ends — drives the
  /// shared speaking indicator, the same way the device provider does.
  final ValueChanged<bool>? onSpeakingChanged;

  /// Created on first playback (so unconfigured providers cost nothing).
  late final AudioPlayer _player = AudioPlayer();

  /// True while playback is paused via [pause] (the audio clock is frozen).
  bool _paused = false;

  /// When the current pause began, used to keep paused time out of the clip's
  /// elapsed-time accounting (see [_awaitClipEnd]).
  DateTime? _pausedAt;

  /// Total time spent paused during the current clip, excluded from its
  /// elapsed-time wait so a pause never ends the clip early.
  Duration _pausedAccrued = Duration.zero;

  /// Bumped by [stop] (and each [speak]) so a running [_awaitClipEnd] wait can
  /// tell its clip was superseded — including while it sits paused — and bail
  /// out instead of spinning forever.
  int _playGen = 0;

  /// The cloud REST endpoints both return MP3 (see the synthesize requests).
  static const String _audioMimeType = 'audio/mpeg';

  /// Hard cap so a stuck playback can never wedge the play funnel.
  static const Duration _playbackTimeout = Duration(seconds: 30);

  /// A short silence synthesized at the head of every clip. The audio
  /// device/decoder takes a beat to start emitting samples on Windows (Media
  /// Foundation) and on web; without a silent head, that start-up latency
  /// swallows the first word. Long enough to cover the spin-up, short enough to
  /// not read as a deliberate pause.
  static const Duration _leadInSilence = Duration(milliseconds: 250);

  /// An SSML `<break>` element that prepends [_leadInSilence] inside a `<speak>`
  /// body, so the synthesized audio already carries the silent head.
  static String get leadInBreak =>
      '<break time="${_leadInSilence.inMilliseconds}ms"/>';

  @override
  VoiceTier get tier => VoiceTier.premium;

  @override
  bool get isConfigured => apiKey.isNotEmpty;

  /// The provider's API key, or '' when none was supplied at build time.
  String get apiKey;

  /// Calls the provider's REST API and returns encoded audio bytes for [text]
  /// in [locale] read by a [gender]-matched voice, or null on failure.
  /// Implemented per provider.
  Future<List<int>?> synthesize(String text, String locale, VoiceGender gender);

  @override
  Future<void> warmUp(String locale) async {
    // Cloud voices need no warm-up; the voice is chosen per request.
  }

  @override
  Future<bool> speak(
    String text,
    String locale, {
    VoiceGender gender = VoiceGender.female,
  }) async {
    // A failed synthesis (no bytes) is the only thing that demotes this provider
    // and lets the chain fall back to the on-device voice. Once we *have* audio
    // for the requested locale, we commit to it: returning false here would hand
    // the phrase to the device voice, which on some platforms (notably web) has
    // no voice for the target language and would read it in the wrong accent.
    final bytes = await synthesize(text, locale, gender);
    if (bytes == null || bytes.isEmpty) return false;
    onSpeakingChanged?.call(true);
    // Fresh clip: clear any pause state from a previous one and claim a new
    // generation so a stale [_awaitClipEnd] wait bows out.
    _paused = false;
    _pausedAt = null;
    _pausedAccrued = Duration.zero;
    final gen = ++_playGen;
    try {
      await _player.stop();
      final source = BytesSource(
        Uint8List.fromList(bytes),
        mimeType: _audioMimeType,
      );
      // Subscribe before playback so we can't miss a completion event.
      final completed = _player.onPlayerComplete.first;
      // Load the clip and let the engine prepare it *before* starting the
      // playback clock. play() is setSource+resume in one step, which begins
      // counting the moment the bytes are handed over — but the audio
      // device/decoder takes a beat to actually emit samples on Windows (Media
      // Foundation) and web, so that head start is lost and the first word is
      // clipped. Pre-buffering, then resuming, keeps the start of the clip.
      //
      // On web `audioplayers`' resume() Future can also reject *after* the
      // audio has already started — the cause of the earlier double-voice (the
      // throw used to cascade the chain into the device voice while the cloud
      // clip kept playing). Swallow it and keep going: the audio is playing.
      // Captured at resume(), not before setSource, so the pre-buffer time
      // isn't mistaken for playback elapsed and doesn't shorten the tail wait.
      var startedAt = DateTime.now();
      try {
        await _player.setSource(source);
        await _awaitSourceReady();
        startedAt = DateTime.now();
        await _player.resume();
      } catch (_) {
        // Playback Future rejected; the clip may still be playing, so don't
        // stop it or fall back — wait it out below.
      }
      await _awaitClipEnd(completed, startedAt, gen);
    } finally {
      onSpeakingChanged?.call(false);
    }
    return true;
  }

  @override
  Future<void> pause() async {
    if (_paused) return;
    try {
      await _player.pause();
      _paused = true;
      _pausedAt = DateTime.now();
      // The clip is silent now, so drop the speaking indicator while paused.
      onSpeakingChanged?.call(false);
    } catch (_) {
      // Nothing playing to pause is fine.
    }
  }

  @override
  Future<bool> resume() async {
    if (!_paused) return false;
    try {
      await _player.resume();
      final pausedAt = _pausedAt;
      if (pausedAt != null) {
        _pausedAccrued += DateTime.now().difference(pausedAt);
      }
      _pausedAt = null;
      _paused = false;
      onSpeakingChanged?.call(true);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Waits (briefly) for the just-set source to finish loading, signalled by a
  /// readable duration, so [_player.resume] starts a clip the engine has
  /// already decoded rather than one it's still fetching — the head of which
  /// would otherwise be dropped while the device spins up. Gives up after a
  /// short budget and resumes anyway; a missing duration just means we proceed
  /// as the old [play] did.
  Future<void> _awaitSourceReady() async {
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        final duration = await _player.getDuration();
        if (duration != null && duration > Duration.zero) return;
      } catch (_) {
        // Metadata not available yet on this platform; retry briefly.
      }
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }
  }

  /// Blocks until the clip has really finished, so the caller awaiting [speak]
  /// only continues once the audio is done — otherwise a follow-up utterance
  /// (e.g. the translation read right after the phrase) would `stop()` this clip
  /// and cut it off mid-word.
  ///
  /// The clip's own **duration** is the reliable signal: on web `audioplayers`
  /// fires [onPlayerComplete] *early* (often as soon as playback starts), so the
  /// passed-in [completed] event is only a fallback for when the duration can't
  /// be read. Capped by [_playbackTimeout] so a stuck clip can't wedge playback.
  Future<void> _awaitClipEnd(
    Future<void> completed,
    DateTime startedAt,
    int gen,
  ) async {
    Duration? duration;
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        duration = await _player.getDuration();
      } catch (_) {
        // Not available yet (web loads metadata asynchronously) — retry briefly.
      }
      if (duration != null && duration > Duration.zero) break;
      await Future<void>.delayed(const Duration(milliseconds: 60));
    }
    if (duration != null && duration > Duration.zero) {
      // Hold for the rest of the clip (plus a small tail so the last word isn't
      // clipped by the next utterance). Polled in small steps rather than slept
      // in one shot so that time spent paused — during which the player's clock
      // is frozen — is excluded: a fixed wall-clock wait would otherwise lapse
      // mid-pause and let the next utterance start over the paused one.
      final target = duration + const Duration(milliseconds: 200);
      while (gen == _playGen) {
        // Active (non-paused) time the clip has been playing.
        final pausing = _paused && _pausedAt != null
            ? DateTime.now().difference(_pausedAt!)
            : Duration.zero;
        final played =
            DateTime.now().difference(startedAt) - _pausedAccrued - pausing;
        if (!_paused && played >= target) break;
        // Safety net: never wait more than the timeout of *active* playback, so
        // a clip whose duration was misread can't wedge the funnel (a long
        // pause, which freezes `played`, is intentionally exempt).
        if (played >= _playbackTimeout) break;
        await Future<void>.delayed(const Duration(milliseconds: 80));
      }
    } else {
      try {
        await completed.timeout(_playbackTimeout, onTimeout: () {});
      } catch (_) {
        // Completion event errored after playback — the audio still played.
      }
    }
  }

  @override
  Future<void> stop() async {
    // Supersede any running clip-end wait (including one sitting paused) and
    // clear pause state so the next clip starts clean.
    _playGen++;
    _paused = false;
    _pausedAt = null;
    _pausedAccrued = Duration.zero;
    try {
      await _player.stop();
    } catch (_) {
      // Nothing playing is fine.
    }
  }

  /// XML-escapes [text] for safe inclusion in an SSML body.
  static String escapeXml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

/// Azure Cognitive Services neural voices (de-DE: Katja, plus Elvira/Jenny for
/// the meaning languages). Clear German articulation and CORS-friendly on the
/// web — the preferred top of the chain.
class AzureTtsProvider extends CloudTtsProvider {
  AzureTtsProvider({super.onSpeakingChanged});

  @override
  String get id => 'azure';

  @override
  String get displayName => 'Azure';

  @override
  String get apiKey => TtsCloudConfig.azureKey;

  /// Azure also needs the resource region for its endpoint, so require it here.
  @override
  bool get isConfigured =>
      apiKey.isNotEmpty && TtsCloudConfig.azureRegion.isNotEmpty;

  @override
  Future<List<int>?> synthesize(
    String text,
    String locale,
    VoiceGender gender,
  ) async {
    final region = TtsCloudConfig.azureRegion;
    if (region.isEmpty || apiKey.isEmpty) return null;
    final voice = _voiceFor(locale, gender);
    if (voice == null) return null;
    final uri = Uri.parse(
      'https://$region.tts.speech.microsoft.com/cognitiveservices/v1',
    );
    final ssml =
        '<speak version="1.0" xml:lang="$locale">'
        '<voice xml:lang="$locale" name="$voice">'
        '${CloudTtsProvider.leadInBreak}'
        '${CloudTtsProvider.escapeXml(text)}'
        '</voice></speak>';
    try {
      final resp = await http.post(
        uri,
        headers: {
          'Ocp-Apim-Subscription-Key': apiKey,
          'Content-Type': 'application/ssml+xml',
          'X-Microsoft-OutputFormat': 'audio-24khz-48kbitrate-mono-mp3',
          'User-Agent': 'german-pronouns-articles',
        },
        body: ssml,
      );
      if (resp.statusCode != 200) return null;
      return resp.bodyBytes;
    } catch (_) {
      return null;
    }
  }

  /// Azure neural voice name for [locale] and [gender]; null for an unsupported
  /// language. The female voices are the app's long-standing defaults (Katja /
  /// Elvira / Jenny); the male voices are their well-known counterparts.
  String? _voiceFor(String locale, VoiceGender gender) {
    final male = gender == VoiceGender.male;
    return switch (locale.split('-').first.toLowerCase()) {
      'de' => male ? 'de-DE-ConradNeural' : 'de-DE-KatjaNeural',
      'es' => male ? 'es-ES-AlvaroNeural' : 'es-ES-ElviraNeural',
      'en' => male ? 'en-US-GuyNeural' : 'en-US-JennyNeural',
      'cs' => male ? 'cs-CZ-AntoninNeural' : 'cs-CZ-VlastaNeural',
      'fr' => male ? 'fr-FR-HenriNeural' : 'fr-FR-DeniseNeural',
      _ => null,
    };
  }
}

/// Google Cloud Text-to-Speech neural voices (Neural2). Excellent German and a
/// generous free tier — the second link in the chain.
class GoogleTtsProvider extends CloudTtsProvider {
  GoogleTtsProvider({super.onSpeakingChanged});

  @override
  String get id => 'google';

  @override
  String get displayName => 'Google';

  @override
  String get apiKey => TtsCloudConfig.googleKey;

  @override
  Future<List<int>?> synthesize(
    String text,
    String locale,
    VoiceGender gender,
  ) async {
    if (apiKey.isEmpty) return null;
    final uri = Uri.parse(
      'https://texttospeech.googleapis.com/v1/text:synthesize?key=$apiKey',
    );
    try {
      final resp = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          // SSML (not plain text) so the clip carries the lead-in silence that
          // keeps the device's start-up latency from clipping the first word.
          'input': {
            'ssml':
                '<speak>${CloudTtsProvider.leadInBreak}'
                '${CloudTtsProvider.escapeXml(text)}</speak>',
          },
          'voice': {'languageCode': locale, 'name': _voiceFor(locale, gender)},
          'audioConfig': {'audioEncoding': 'MP3'},
        }),
      );
      if (resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final audio = data['audioContent'] as String?;
      if (audio == null || audio.isEmpty) return null;
      return base64Decode(audio);
    } catch (_) {
      return null;
    }
  }

  /// Google neural voice name for [locale] and [gender], defaulting to German.
  /// The female voices are the app's long-standing defaults; the male voices
  /// are the matching Neural2 male voices for each language.
  String _voiceFor(String locale, VoiceGender gender) {
    final male = gender == VoiceGender.male;
    return switch (locale.split('-').first.toLowerCase()) {
      'es' => male ? 'es-ES-Neural2-B' : 'es-ES-Neural2-A',
      'en' => male ? 'en-US-Neural2-D' : 'en-US-Neural2-C',
      'cs' => male ? 'cs-CZ-Wavenet-B' : 'cs-CZ-Wavenet-A',
      'fr' => male ? 'fr-FR-Neural2-B' : 'fr-FR-Neural2-A',
      _ => male ? 'de-DE-Neural2-B' : 'de-DE-Neural2-C',
    };
  }
}

/// Routes synthesis through a standalone server-side proxy (the Cloudflare
/// Worker in `cloudflare-tts-proxy/`) that holds the cloud keys.
///
/// This is the web path: shipping a real key in the JS bundle would expose it
/// to every visitor, and Azure's REST endpoint also CORS-blocks browsers. The
/// app is hosted on static GitHub Pages (which can't hold a key), so it calls
/// the Worker cross-origin; the Worker adds the key server-side, returns MP3,
/// and CORS-allows the Pages origin. Point at it with
/// `--dart-define=TTS_PROXY_URL=https://<worker>.workers.dev`; without that this
/// provider is unconfigured and the chain falls back to the on-device voice.
/// Playback is inherited from [CloudTtsProvider].
class ProxyTtsProvider extends CloudTtsProvider {
  ProxyTtsProvider({super.onSpeakingChanged});

  @override
  String get id => 'proxy';

  @override
  String get displayName => 'Cloud';

  @override
  String get apiKey => ''; // No client-side key — that's the whole point.

  @override
  bool get isConfigured => TtsCloudConfig.proxyUrl.isNotEmpty;

  @override
  Future<List<int>?> synthesize(
    String text,
    String locale,
    VoiceGender gender,
  ) async {
    final url = TtsCloudConfig.proxyUrl;
    if (url.isEmpty) return null;
    try {
      final resp = await http.post(
        Uri.parse(url),
        headers: const {'Content-Type': 'application/json; charset=utf-8'},
        // `gender` lets the worker pick a male/female voice; older workers that
        // ignore it simply read in the default voice, so this stays compatible.
        body: jsonEncode({'text': text, 'locale': locale, 'gender': gender.name}),
      );
      if (resp.statusCode != 200 || resp.bodyBytes.isEmpty) return null;
      return resp.bodyBytes;
    } catch (_) {
      return null;
    }
  }
}
