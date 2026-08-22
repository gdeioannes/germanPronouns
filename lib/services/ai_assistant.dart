import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// The AI assistants the speaking exercise can hand the learner off to.
///
/// Deliberately a short list of the two we point people at, not a directory:
/// the exercise only needs a way *out* of the app, and every extra choice is
/// another decision between the learner and talking.
enum AiAssistant {
  chatGpt('ChatGPT', 'chatgpt.com'),
  gemini('Gemini', 'gemini.google.com');

  const AiAssistant(this.label, this.host);

  /// The product's own name. Never translated — a brand name is the same in
  /// every locale, and it's what the learner looks for on their home screen.
  final String label;

  final String host;

  /// The persisted-choice key. Values are [name]s, so renaming an enum entry
  /// would silently orphan a saved choice.
  static const String prefsKey = 'speaking_preferred_ai';

  /// The longest percent-encoded prompt we'll try to carry in a URL.
  ///
  /// Browsers, web servers and OS intent handlers all cap URL length at
  /// different points; ~2000 is the widely safe floor. Measured against the
  /// real speaking template, a rendered prompt encodes to ~4600 characters, so
  /// in practice this guard always trips and we fall back to opening the
  /// assistant bare. It stays because the fallback has to be correct either
  /// way, and a shorter prompt should get the better path for free.
  static const int maxPrefillLength = 2000;

  /// Whether [urlFor] will carry [prompt] into the assistant's composer.
  ///
  /// False means the learner has to paste — which is why the copy always
  /// happens first, never instead.
  bool prefills(String prompt) =>
      this == AiAssistant.chatGpt &&
      Uri.encodeComponent(prompt).length <= maxPrefillLength;

  /// Where to send the learner.
  ///
  /// ChatGPT accepts the prompt as `?q=` and sends it on arrival. Gemini has no
  /// public prompt parameter, so it can only be opened bare. On mobile these
  /// are universal links: the installed app takes them, and a browser tab is
  /// the fallback. From a web build the browser keeps them — Chrome doesn't
  /// hand a same-browser navigation off to an Android app link.
  Uri urlFor(String prompt) => switch (this) {
    AiAssistant.chatGpt => prefills(prompt)
        ? Uri.https(host, '/', {'q': prompt})
        : Uri.https(host, '/'),
    AiAssistant.gemini => Uri.https(host, '/app'),
  };

  Future<bool> open(String prompt) => launchUrl(
    urlFor(prompt),
    // Leave our app: an in-app webview can't reach the assistant's voice mode,
    // which is the entire point of the exercise.
    mode: LaunchMode.externalApplication,
  );

  /// The assistant the learner picked last time, or null on a first run.
  static Future<AiAssistant?> lastUsed() async {
    try {
      final saved = (await SharedPreferences.getInstance()).getString(prefsKey);
      return AiAssistant.values.where((a) => a.name == saved).firstOrNull;
    } catch (_) {
      return null;
    }
  }

  Future<void> remember() async {
    try {
      await (await SharedPreferences.getInstance()).setString(prefsKey, name);
    } catch (_) {
      // Best-effort: the choice is a convenience, not state the exercise needs.
    }
  }
}
