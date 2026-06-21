import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import 'noun_progression_data.dart';
import 'quest_data.dart';
import 'quiz_content_library.dart';
import 'quiz_stats_store.dart';

/// Debug helper: marks every quiz "done" and unlocks every chain, so the whole
/// app shows as completed — Quest quizzes and noun-categories via their
/// completion sets, listen-&-repeat as played through, reading as passed, and
/// fill-in quizzes by bumping their best streak to the goal (the streak the
/// home/drawer check for the ribbon).
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
  // The best streak a plain fill-in quiz must reach to count as "done".
  final goalStreak = NounSettings.instance.quizGoalStreak;
  for (final content in allQuizContent) {
    switch (content.kind) {
      case QuizKind.speakRepeat:
        await NounSettings.instance.markSpeakQuizCompleted(content.id);
      case QuizKind.reading:
        await NounSettings.instance.markReadingQuizCompleted(content.id);
      case QuizKind.fillBlank:
        // No completion set for plain fill-in quizzes — they're "done" once
        // their stored best streak reaches the goal, so bump it there.
        final stats = await quizStatsStore.load(content.storageKeyPrefix);
        if (stats.bestStreakAbsolute < goalStreak) {
          await quizStatsStore.save(
            content.storageKeyPrefix,
            stats.copyWith(bestStreakAbsolute: goalStreak),
          );
        }
    }
  }
}

/// The word that, typed twice in a row from any screen, unlocks the whole app.
const String debugUnlockTrigger = 'debugdebug';
