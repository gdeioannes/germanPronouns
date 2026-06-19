import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_stats.dart';
import '../models/quiz_stats_keys.dart';

/// Where one quiz's [QuizStats] (score/streak/history/selections) are
/// persisted, keyed by the quiz's `QuizConfig.storageKeyPrefix`.
///
/// The app currently reads/writes these inline in the quiz engine via
/// SharedPreferences; [SharedPreferencesQuizStatsStore] is the same logic
/// behind this interface, the seam for the planned database step (a
/// `DbQuizStatsStore` implements it). Mirrors [SettingsStore] and
/// `QuizRepository`.
abstract class QuizStatsStore {
  Future<QuizStats> load(
    String storageKeyPrefix, {
    Map<String, String> legacyCategoryLabelMigration,
  });

  Future<void> save(String storageKeyPrefix, QuizStats stats);
}

/// [QuizStatsStore] backed by SharedPreferences, matching the storage format
/// the quiz engine uses today (ints for counters, JSON strings for the history,
/// mistakes, and enabled-selection lists).
class SharedPreferencesQuizStatsStore implements QuizStatsStore {
  const SharedPreferencesQuizStatsStore();

  @override
  Future<QuizStats> load(
    String storageKeyPrefix, {
    Map<String, String> legacyCategoryLabelMigration = const {},
  }) async {
    final keys = QuizStatsKeys(storageKeyPrefix);
    final prefs = await SharedPreferences.getInstance();

    final streak = prefs.getInt(keys.streak) ?? 0;

    final history = <Map<String, dynamic>>[];
    final decodedHistory = _decode(prefs.getString(keys.answerHistory));
    if (decodedHistory is List) {
      for (final item in decodedHistory) {
        if (item is Map) {
          history.add(item.map((k, v) => MapEntry(k.toString(), v)));
        }
      }
    }

    var mistakes = <String, int>{};
    final decodedMistakes = _decode(prefs.getString(keys.mistakesByCase));
    if (decodedMistakes is Map) {
      mistakes = decodedMistakes.map(
        (k, v) => MapEntry(k.toString(), (v as num).toInt()),
      );
    }

    final subjects = <int>[];
    final decodedSubjects = _decode(prefs.getString(keys.enabledSubjects));
    if (decodedSubjects is List) {
      subjects.addAll(decodedSubjects.map((v) => (v as num).toInt()));
    }

    final categories = <String>[];
    final decodedCategories = _decode(prefs.getString(keys.enabledCategories));
    if (decodedCategories is List) {
      categories.addAll(
        decodedCategories
            .map((v) => v.toString())
            .map((label) => legacyCategoryLabelMigration[label] ?? label),
      );
    }

    return QuizStats(
      score: prefs.getInt(keys.score) ?? 0,
      streak: streak,
      bestStreakLap: prefs.getInt(keys.bestStreakLap) ?? 0,
      // Falls back to the current streak when no separate best was ever stored,
      // matching the engine's original load behavior.
      bestStreakAbsolute: prefs.getInt(keys.bestStreakAbsolute) ?? streak,
      answerHistory: history,
      mistakesByCase: mistakes,
      enabledSubjects: subjects,
      enabledCategories: categories,
    );
  }

  @override
  Future<void> save(String storageKeyPrefix, QuizStats stats) async {
    final keys = QuizStatsKeys(storageKeyPrefix);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(keys.score, stats.score);
    await prefs.setInt(keys.streak, stats.streak);
    await prefs.setInt(keys.bestStreakLap, stats.bestStreakLap);
    await prefs.setInt(keys.bestStreakAbsolute, stats.bestStreakAbsolute);
    await prefs.setString(keys.answerHistory, jsonEncode(stats.answerHistory));
    await prefs.setString(keys.mistakesByCase, jsonEncode(stats.mistakesByCase));
    await prefs.setString(keys.enabledSubjects, jsonEncode(stats.enabledSubjects));
    await prefs.setString(
      keys.enabledCategories,
      jsonEncode(stats.enabledCategories),
    );
  }

  Object? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw);
  }
}

/// The stats store the app reads from. Swap this for a DB-backed implementation
/// when the database step lands.
const QuizStatsStore quizStatsStore = SharedPreferencesQuizStatsStore();
