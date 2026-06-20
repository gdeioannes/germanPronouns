import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import 'noun_progression_data.dart';
import 'quest_data.dart';
import 'quiz_content_library.dart';

/// Debug helper: marks every Quest quiz and noun-category as completed and
/// every listen-&-repeat quiz as played through, so the whole app is unlocked.
///
/// Triggered either from the hidden Debug section of the Settings page or by
/// typing the word "debug" twice from anywhere in the app (see
/// [debugUnlockTrigger] and the global key handler in `main.dart`).
Future<void> unlockEverything() async {
  for (final entry in questEntries) {
    await NounSettings.instance.markQuestQuizCompleted(entry.key);
  }
  for (final entry in nounProgressionEntries) {
    await NounSettings.instance.markNounCategoryCompleted(entry.key);
  }
  for (final content in allQuizContent) {
    if (content.kind == QuizKind.speakRepeat) {
      await NounSettings.instance.markSpeakQuizCompleted(content.id);
    }
  }
}

/// The word that, typed twice in a row from any screen, unlocks the whole app.
const String debugUnlockTrigger = 'debugdebug';
