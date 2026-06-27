import 'package:flutter/material.dart';

import '../models/course_session.dart';
import '../models/voice_gender.dart';
import '../services/tts/tts_service.dart';

/// A compact speaker icon that reads [text] aloud in [locale] through the shared
/// premium-cloud → on-device TTS chain ([TtsService]). Dropped next to any
/// learning-content sentence — a reading passage, a quiz question or option, a
/// help-memory example — so the learner can always hear it in the right
/// language.
///
/// [locale] defaults to the active course's *target* language
/// ([Course.learnLocale]); the content this sits next to is the language being
/// learned, so that is what should be voiced. Renders nothing when [text] is
/// blank, so callers can place it unconditionally.
class SpeakIconButton extends StatelessWidget {
  const SpeakIconButton({
    super.key,
    required this.text,
    this.locale,
    this.gender = VoiceGender.female,
    this.size = 18,
    this.color,
    this.tooltip,
  });

  /// The sentence/phrase to read aloud. Pass already-clean text (no `**bold**`
  /// or other markup) — what the learner sees on screen.
  final String text;

  /// BCP-47 locale to speak in. Defaults to the active course's target language.
  final String? locale;

  /// Voice gender, matching the per-line/quiz voice used elsewhere.
  final VoiceGender gender;

  /// Icon size; the tap target grows a little around it.
  final double size;

  /// Icon color; defaults to the theme's muted on-surface color so it reads as
  /// a quiet affordance rather than competing with the text.
  final Color? color;

  /// Tooltip; defaults to the localized "Listen".
  final String? tooltip;

  /// Stops anything currently playing, then reads [text] in [resolvedLocale].
  /// Fire-and-forget: playback errors (e.g. no audio output) are swallowed so a
  /// tap never throws.
  Future<void> _speak(String resolvedLocale) async {
    final voice = TtsService.instance;
    try {
      await voice.stop();
      // A short gap after stop() makes web SpeechSynthesis playback reliable
      // (the same pattern the listen/dictation pages use before speaking).
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await voice.speak(text, resolvedLocale, gender: gender);
    } catch (_) {
      // Best effort — listening is an aid, never required.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    final resolvedLocale =
        locale ?? CourseSession.instance.activeCourse.learnLocale;
    return IconButton(
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints(minWidth: size + 14, minHeight: size + 14),
      padding: EdgeInsets.zero,
      tooltip: tooltip ?? CourseSession.instance.strings.listen,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
      icon: Icon(Icons.volume_up_rounded, size: size),
      onPressed: () => _speak(resolvedLocale),
    );
  }
}
