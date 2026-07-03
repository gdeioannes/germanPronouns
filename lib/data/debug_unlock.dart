import 'package:flutter/foundation.dart';

import '../models/coin_wallet.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../widgets/completion_ribbon.dart';
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
      case QuizKind.listening:
        await NounSettings.instance.markListeningQuizCompleted(content.id);
      case QuizKind.dictation:
        await NounSettings.instance.markDictationQuizCompleted(content.id);
      case QuizKind.draw:
        // Drawing completes on play-through, sharing the speak completion set.
        await NounSettings.instance.markSpeakQuizCompleted(content.id);
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

/// Typed from any screen, grants [debugCoinAmount] coins — a debug shortcut to
/// fill the wallet for testing the apartment shop. See the global key handler
/// in `main.dart`.
const String debugCoinTrigger = 'coincoin';

/// How many coins [debugCoinTrigger] grants each time it's typed.
const int debugCoinAmount = 100000;

/// Typed from any screen, reveals every element in the room shop at once
/// (bypassing the earn-as-you-go reveal gate). See the global key handler in
/// `main.dart`.
const String debugRevealAllTrigger = 'roomroom';

/// Typed from any screen, toggles ribbon debug mode on/off: while active,
/// tapping a quiz in the navigation drawer completes it instead of opening it.
/// The first touch finishes the quiz (bronze ribbon, unlocking the next quiz
/// in its gated chain); each further touch raises the ribbon a tier — silver,
/// then gold — and every touch pays the coin roll of the tier reached. A
/// warning bar shows while the mode is on (see `main.dart`); it can also be
/// switched from the hidden Debug section of the Settings page (the typed
/// trigger needs a hardware keyboard).
const String debugRibbonTrigger = 'ribonribon';

/// Whether ribbon debug mode (see [debugRibbonTrigger]) is currently on.
/// Session-only — never persisted, so a restart always starts clean. The app
/// shell listens to show the warning bar; the drawer checks it on every tap.
final ValueNotifier<bool> debugRibbonModeActive = ValueNotifier<bool>(false);

/// One ribbon-debug step for a quiz (see [debugRibbonTrigger]). A quiz that
/// isn't [isDone] yet is completed: [markDone] applies its kind-specific
/// completion set (play-through / passed; fill-in quizzes have none and are
/// covered by the streak-goal bump below), which shows its ribbon and unlocks
/// the next quiz in a gated chain. A quiz that's already done jumps its best
/// streak to the next ribbon-tier boundary instead. Every step pays the coin
/// roll of the tier reached. Returns (coins granted, tier reached), or null
/// when the quiz already has the gold ribbon.
Future<(int, RibbonTier)?> debugAdvanceRibbon({
  required String storageKeyPrefix,
  required bool isDone,
  required Future<void> Function() markDone,
}) async {
  final stats = await quizStatsStore.load(storageKeyPrefix);
  final laps = stats.bestStreakAbsolute ~/ NounSettings.streakLapSize;
  if (isDone && ribbonTierForLaps(laps) == RibbonTier.gold) return null;

  final int targetStreak;
  if (!isDone) {
    await markDone();
    // The shared streak goal makes a fill-in quiz count as done and gives
    // every kind the same starting point.
    targetStreak = NounSettings.instance.quizGoalStreak;
  } else {
    // Silver at 3 laps, gold at 5 — the [ribbonTierForLaps] boundaries.
    final nextLaps = ribbonTierForLaps(laps) == RibbonTier.bronze ? 3 : 5;
    targetStreak = nextLaps * NounSettings.streakLapSize;
  }
  final newBest = stats.bestStreakAbsolute < targetStreak
      ? targetStreak
      : stats.bestStreakAbsolute;
  if (newBest != stats.bestStreakAbsolute) {
    await quizStatsStore.save(
      storageKeyPrefix,
      stats.copyWith(bestStreakAbsolute: newBest),
    );
  }
  final newLaps = newBest ~/ NounSettings.streakLapSize;
  final coins = CoinWallet.rollRibbonCoins(newLaps);
  await CoinWallet.instance.add(coins);
  return (coins, ribbonTierForLaps(newLaps));
}
