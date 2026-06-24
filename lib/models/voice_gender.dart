/// The gender of the voice that reads a phrase aloud.
///
/// Lives in `models/` (not the TTS layer) because it's authored *content* — a
/// spoken line / passage / quiz declares who is speaking — and the TTS service
/// merely honours it when picking a neural voice. [female] is the default
/// everywhere, matching the female cloud voices the app has always used (Azure
/// Katja, Google Neural2-C, …), so existing content sounds unchanged.
enum VoiceGender {
  female,
  male;

  /// Parses a stored name ('male'/'female'), falling back to [female] for an
  /// unknown or missing value so old data and typos degrade gracefully.
  static VoiceGender fromName(String? name) {
    for (final g in VoiceGender.values) {
      if (g.name == name) return g;
    }
    return VoiceGender.female;
  }
}
