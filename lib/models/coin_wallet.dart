import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/completion_ribbon.dart';
import 'settings_keys.dart';

/// The learner's global coin balance — one app-wide "wallet" shared by every
/// quiz, replacing the old per-quiz point score.
///
/// Gameplay only ever **adds** coins — a wrong answer costs nothing. The one
/// place coins leave the wallet is a deliberate purchase ([spend], used by the
/// apartment shop). A [ChangeNotifier] (not a plain singleton like
/// [NounSettings]) so the coin-holder badge can rebuild itself whenever the
/// balance changes, from anywhere in the app.
class CoinWallet extends ChangeNotifier {
  CoinWallet._();

  static final CoinWallet instance = CoinWallet._();

  /// Probability that a single correct answer drops one coin. There is always a
  /// *chance* to earn a coin per answer; ribbons and quiz completion are the
  /// guaranteed rewards.
  static const double coinChancePerAnswer = 0.20;

  /// Flat bonus for finishing a quiz (its progression goal unlocked / "done").
  static const int quizFinishedBonus = 5;

  /// Coin reward range (inclusive) per ribbon tier. Each time a ribbon is earned
  /// or renewed, a random amount in its tier's band is paid out. Every completed
  /// quiz earns at least a bronze ribbon, so a completion is never worth nothing.
  static const Map<RibbonTier, (int min, int max)> ribbonCoinRange = {
    RibbonTier.bronze: (10, 30),
    RibbonTier.silver: (35, 70),
    RibbonTier.gold: (100, 200),
  };

  static final Random _rng = Random();

  /// A random coin reward for the ribbon tier [laps] reaches — bronze 10–30,
  /// silver 35–70, gold 100–200. Always ≥ 10, so finishing any quiz (every
  /// type: typed, reading, long-text, listening, dictation, speaking) pays out.
  static int rollRibbonCoins(int laps) {
    final (lo, hi) = ribbonCoinRange[ribbonTierForLaps(laps)]!;
    return lo + _rng.nextInt(hi - lo + 1);
  }

  int _balance = 0;
  bool _loaded = false;

  /// The current coin total.
  int get balance => _balance;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SettingsKeys.coinBalance)) {
      _balance = prefs.getInt(SettingsKeys.coinBalance) ?? 0;
    } else {
      // First run on the coin system: seed the wallet from whatever points the
      // learner already accumulated across quizzes, so existing progress carries
      // over as coins. Old scores could be negative (the points system used to
      // subtract); coins never go below zero, so clamp each quiz's contribution.
      _balance = _seedFromLegacyScores(prefs);
      await prefs.setInt(SettingsKeys.coinBalance, _balance);
    }
    _loaded = true;
  }

  /// Sum of every persisted per-quiz score, each clamped to ≥ 0. Per-quiz score
  /// keys end in `quiz_score` (see `QuizStatsKeys.score`).
  static int _seedFromLegacyScores(SharedPreferences prefs) {
    var total = 0;
    for (final key in prefs.getKeys()) {
      if (key.endsWith('quiz_score')) {
        final value = prefs.getInt(key) ?? 0;
        if (value > 0) total += value;
      }
    }
    return total;
  }

  /// Adds [coins] to the balance, persists, and notifies listeners. A
  /// non-positive amount is a no-op, so callers can pass a computed reward
  /// without guarding it and the balance can never decrease.
  Future<void> add(int coins) async {
    if (coins <= 0) return;
    _balance += coins;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SettingsKeys.coinBalance, _balance);
  }

  /// Attempts to spend [amount] coins on a purchase. Returns `false` (changing
  /// nothing) when [amount] is non-positive or larger than the [balance] — the
  /// wallet can never go negative. On success it subtracts, notifies and
  /// persists. The only path that removes coins.
  Future<bool> spend(int amount) async {
    if (amount <= 0 || amount > _balance) return false;
    _balance -= amount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SettingsKeys.coinBalance, _balance);
    return true;
  }

  /// Test-only reset of the in-memory state (does not touch storage).
  @visibleForTesting
  void resetForTest() {
    _balance = 0;
    _loaded = false;
  }
}
