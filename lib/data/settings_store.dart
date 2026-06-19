import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_keys.dart';
import '../models/user_settings.dart';

/// Where the global [UserSettings] are persisted.
///
/// The app currently uses [SharedPreferencesSettingsStore]. This interface is
/// the seam for the planned database step: a `DbSettingsStore` can implement
/// it to read/write settings from a database without changing the rest of the
/// app. Mirrors the `QuizRepository` seam used for quiz content.
abstract class SettingsStore {
  Future<UserSettings> load();
  Future<void> save(UserSettings settings);
}

/// [SettingsStore] backed by SharedPreferences, using the [SettingsKeys] key
/// names (the same keys [NounSettings] reads/writes today).
class SharedPreferencesSettingsStore implements SettingsStore {
  const SharedPreferencesSettingsStore();

  static const List<String> _genders = ['m', 'f', 'n'];

  @override
  Future<UserSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    final showEnglish = <String, bool>{};
    final legacyColorKeys = <String>[];
    for (final key in prefs.getKeys()) {
      if (key.startsWith(SettingsKeys.showEnglishPrefix)) {
        showEnglish[key.substring(SettingsKeys.showEnglishPrefix.length)] =
            prefs.getBool(key) ?? true;
      } else if (key.startsWith(SettingsKeys.colorNounsLegacyPrefix)) {
        legacyColorKeys.add(key);
      }
    }

    // Single color-nouns setting, migrating from the old per-page values: on
    // if any page had it on.
    final bool colorNouns;
    if (prefs.containsKey(SettingsKeys.colorNouns)) {
      colorNouns = prefs.getBool(SettingsKeys.colorNouns) ?? false;
    } else {
      colorNouns = legacyColorKeys.any((k) => prefs.getBool(k) ?? false);
    }

    final genderColors = <String, int>{};
    for (final gender in _genders) {
      final value = prefs.getInt(SettingsKeys.genderColor(gender));
      if (value != null) genderColors[gender] = value;
    }

    return UserSettings(
      disabledNouns:
          prefs.getStringList(SettingsKeys.disabledNouns) ?? const [],
      showEnglishByPage: showEnglish,
      colorNouns: colorNouns,
      genderColors: genderColors,
      lastPage: prefs.getString(SettingsKeys.lastPage),
      completedNounCategories:
          prefs.getStringList(SettingsKeys.completedNounCategories) ?? const [],
      lastNounProgressionKey:
          prefs.getString(SettingsKeys.lastNounProgressionKey),
      answerRevealMode:
          prefs.getString(SettingsKeys.answerRevealMode) ?? 'normal',
      progressionUnlockLaps:
          prefs.getInt(SettingsKeys.progressionUnlockLaps) ?? 5,
      showFirstLetterHint:
          prefs.getBool(SettingsKeys.showFirstLetterHint) ?? false,
    );
  }

  @override
  Future<void> save(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      SettingsKeys.disabledNouns,
      settings.disabledNouns,
    );
    for (final entry in settings.showEnglishByPage.entries) {
      await prefs.setBool(
        '${SettingsKeys.showEnglishPrefix}${entry.key}',
        entry.value,
      );
    }
    await prefs.setBool(SettingsKeys.colorNouns, settings.colorNouns);
    for (final entry in settings.genderColors.entries) {
      await prefs.setInt(SettingsKeys.genderColor(entry.key), entry.value);
    }
    final lastPage = settings.lastPage;
    if (lastPage != null) await prefs.setString(SettingsKeys.lastPage, lastPage);
    await prefs.setStringList(
      SettingsKeys.completedNounCategories,
      settings.completedNounCategories,
    );
    final lastKey = settings.lastNounProgressionKey;
    if (lastKey != null) {
      await prefs.setString(SettingsKeys.lastNounProgressionKey, lastKey);
    }
    await prefs.setString(
      SettingsKeys.answerRevealMode,
      settings.answerRevealMode,
    );
    await prefs.setInt(
      SettingsKeys.progressionUnlockLaps,
      settings.progressionUnlockLaps,
    );
    await prefs.setBool(
      SettingsKeys.showFirstLetterHint,
      settings.showFirstLetterHint,
    );
  }
}

/// The settings store the app reads from. Swap this for a DB-backed
/// implementation when the database step lands.
const SettingsStore settingsStore = SharedPreferencesSettingsStore();
