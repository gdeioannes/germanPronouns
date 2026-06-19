import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/data/quiz_stats_store.dart';
import 'package:german_pronouns_articles/models/quiz_stats.dart';

Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sample = QuizStats(
    score: 42,
    streak: 7,
    bestStreakLap: 1,
    bestStreakAbsolute: 12,
    answerHistory: [
      {'exercise': 'Ich sehe ____.', 'answer': 'ihn', 'correct': true},
      {'exercise': 'Das gehört ____.', 'answer': 'mir', 'correct': false},
    ],
    mistakesByCase: {'Dative': 3, 'Accusative': 1},
    enabledSubjects: [0, 1, 2],
    enabledCategories: ['Accusative', 'Dative'],
  );

  test('QuizStats round-trips through JSON unchanged', () {
    expect(
      QuizStats.fromJson(_throughJson(sample.toJson())).toJson(),
      sample.toJson(),
    );
  });

  test('SharedPreferencesQuizStatsStore round-trips through prefs', () async {
    SharedPreferences.setMockInitialValues({});
    const store = SharedPreferencesQuizStatsStore();

    await store.save('article_', sample);
    final loaded = await store.load('article_');

    expect(loaded.toJson(), sample.toJson());
  });

  test('stats are namespaced per quiz by storage prefix', () async {
    SharedPreferences.setMockInitialValues({});
    const store = SharedPreferencesQuizStatsStore();

    await store.save('article_', sample);
    final other = await store.load('preposition_');

    // A different quiz's prefix sees its own (empty) stats, not article_'s.
    expect(other.score, 0);
    expect(other.enabledCategories, isEmpty);
  });

  test('applies legacy category-label migration on load', () async {
    SharedPreferences.setMockInitialValues({});
    const store = SharedPreferencesQuizStatsStore();

    await store.save(
      '',
      const QuizStats(enabledCategories: ['Poss. Masc.']),
    );
    final loaded = await store.load(
      '',
      legacyCategoryLabelMigration: {'Poss. Masc.': 'Poss. Masc. Nom.'},
    );

    expect(loaded.enabledCategories, ['Poss. Masc. Nom.']);
  });
}
