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

  /// The cloud REST endpoints both return MP3 (see the synthesize requests).
  static const String _audioMimeType = 'audio/mpeg';

  /// Hard cap so a stuck playback can never wedge the play funnel.
  static const Duration _playbackTimeout = Duration(seconds: 30);

  @override
  VoiceTier get tier => VoiceTier.premium;

  @override
  bool get isConfigured => apiKey.isNotEmpty;

  /// The provider's API key, or '' when none was supplied at build time.
  String get apiKey;

  /// Calls the provider's REST API and returns encoded audio bytes for [text]
  /// in [locale], or null on failure. Implemented per provider.
  Future<List<int>?> synthesize(String text, String locale);

  @override
  Future<void> warmUp(String locale) async {
    // Cloud voices need no warm-up; the voice is chosen per request.
  }

  @override
  Future<bool> speak(String text, String locale) async {
    final bytes = await synthesize(text, locale);
    if (bytes == null || bytes.isEmpty) return false;
    onSpeakingChanged?.call(true);
    try {
      await _player.stop();
      // Subscribe before play() so we can't miss a fast completion.
      final completed = _player.onPlayerComplete.first;
      await _player.play(
        BytesSource(Uint8List.fromList(bytes), mimeType: _audioMimeType),
      );
      await completed.timeout(_playbackTimeout, onTimeout: () {});
    } finally {
      onSpeakingChanged?.call(false);
    }
    return true;
  }

  @override
  Future<void> stop() async {
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
  Future<List<int>?> synthesize(String text, String locale) async {
    final region = TtsCloudConfig.azureRegion;
    if (region.isEmpty || apiKey.isEmpty) return null;
    final voice = _voiceFor(locale);
    if (voice == null) return null;
    final uri = Uri.parse(
      'https://$region.tts.speech.microsoft.com/cognitiveservices/v1',
    );
    final ssml =
        '<speak version="1.0" xml:lang="$locale">'
        '<voice xml:lang="$locale" name="$voice">'
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

  /// Azure neural voice name for [locale]; null for an unsupported language.
  String? _voiceFor(String locale) =>
      switch (locale.split('-').first.toLowerCase()) {
        'de' => 'de-DE-KatjaNeural',
        'es' => 'es-ES-ElviraNeural',
        'en' => 'en-US-JennyNeural',
        _ => null,
      };
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
  Future<List<int>?> synthesize(String text, String locale) async {
    if (apiKey.isEmpty) return null;
    final uri = Uri.parse(
      'https://texttospeech.googleapis.com/v1/text:synthesize?key=$apiKey',
    );
    try {
      final resp = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'input': {'text': text},
          'voice': {'languageCode': locale, 'name': _voiceFor(locale)},
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

  /// Google neural voice name for [locale], defaulting to German.
  String _voiceFor(String locale) =>
      switch (locale.split('-').first.toLowerCase()) {
        'es' => 'es-ES-Neural2-A',
        'en' => 'en-US-Neural2-C',
        _ => 'de-DE-Neural2-C',
      };
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
  Future<List<int>?> synthesize(String text, String locale) async {
    final url = TtsCloudConfig.proxyUrl;
    if (url.isEmpty) return null;
    try {
      final resp = await http.post(
        Uri.parse(url),
        headers: const {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'text': text, 'locale': locale}),
      );
      if (resp.statusCode != 200 || resp.bodyBytes.isEmpty) return null;
      return resp.bodyBytes;
    } catch (_) {
      return null;
    }
  }
}
