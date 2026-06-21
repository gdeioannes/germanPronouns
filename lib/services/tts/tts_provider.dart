/// The audio-quality tier a [TtsProvider] belongs to.
///
/// Tiers order the fallback chain (premium cloud voices first, the on-device
/// engine last) and label the active source in the UI so the learner can tell
/// whether they're hearing a high-quality voice or the offline floor.
enum VoiceTier { premium, device }

/// A single text-to-speech backend the app can read phrases through.
///
/// The app runs an ordered chain of these, best first; see TtsService. Each
/// provider is independently gated by [isConfigured] (a cloud provider needs its
/// API key, for instance), so playback degrades gracefully: a premium cloud
/// voice where one is set up and reachable, the on-device engine as the
/// always-present floor.
abstract class TtsProvider {
  /// Stable identifier ('azure', 'google', 'device'); not shown to learners.
  String get id;

  /// Brand/display name for the status panel ('Azure', 'Google', 'Offline').
  String get displayName;

  VoiceTier get tier;

  /// Whether this provider can run at all on this build/device — e.g. a cloud
  /// provider whose API key was supplied. Unconfigured providers are skipped
  /// silently by the chain (never counted as a failure).
  bool get isConfigured;

  /// Prepares [locale] (selecting a matching voice where applicable). Best
  /// effort and safe to call repeatedly; the chain calls it before the first
  /// phrase so the opening word isn't read in the wrong language.
  Future<void> warmUp(String locale);

  /// Reads [text] in [locale], completing when playback finishes. Returns true
  /// when audio was actually produced; returning false (or throwing) tells the
  /// chain this provider failed and to fall through to the next one.
  Future<bool> speak(String text, String locale);

  /// Stops any in-progress playback immediately.
  Future<void> stop();
}

/// An immutable snapshot of one provider's state, for the status panel.
class TtsProviderInfo {
  const TtsProviderInfo({
    required this.id,
    required this.displayName,
    required this.tier,
    required this.configured,
    required this.healthy,
  });

  final String id;
  final String displayName;
  final VoiceTier tier;

  /// Whether the provider is usable at all (configured, has its key, etc.).
  final bool configured;

  /// Whether it's currently considered working — false after a failure, until
  /// its retry cooldown elapses or the learner retries the premium voice.
  final bool healthy;
}
