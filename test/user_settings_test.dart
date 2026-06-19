import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/data/settings_store.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/models/user_settings.dart';

Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sample = UserSettings(
    disabledNouns: ['Hund', 'Katze'],
    showEnglishByPage: {'article_': false, 'word_library_': true},
    colorNouns: true,
    genderColors: {'m': 0xFF2196F3, 'f': 0xFFF44336, 'n': 0xFF4CAF50},
    lastPage: 'prepositions',
    completedNounCategories: ['kitchen', 'food'],
    lastNounProgressionKey: 'kitchen',
    answerRevealMode: 'slow',
    progressionUnlockLaps: 7,
    showFirstLetterHint: true,
  );

  test('UserSettings round-trips through JSON unchanged', () {
    expect(UserSettings.fromJson(_throughJson(sample.toJson())).toJson(),
        sample.toJson());
  });

  test('SharedPreferencesSettingsStore round-trips through prefs', () async {
    SharedPreferences.setMockInitialValues({});
    const store = SharedPreferencesSettingsStore();

    await store.save(sample);
    final loaded = await store.load();

    expect(loaded.toJson(), sample.toJson());
  });

  test('NounSettings snapshot is database-ready', () {
    final snapshot = NounSettings.instance.toUserSettings();
    expect(UserSettings.fromJson(_throughJson(snapshot.toJson())).toJson(),
        snapshot.toJson());
  });
}
