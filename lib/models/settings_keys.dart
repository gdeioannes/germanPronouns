/// SharedPreferences key names for the global user settings.
///
/// Single source of truth shared by [NounSettings] and the settings store, so
/// the two can't drift — and the exact keys a future database row would map
/// to. Never change these values without a migration: users' saved settings
/// depend on them.
class SettingsKeys {
  const SettingsKeys._();

  static const String disabledNouns = 'global_disabled_nouns';
  static const String showEnglishPrefix = 'show_english_';

  /// Legacy per-page "color nouns" key prefix, kept only so [load] can migrate
  /// pre-existing values to the single [colorNouns] setting.
  static const String colorNounsLegacyPrefix = 'color_nouns_';
  static const String colorNouns = 'color_nouns';
  static const String lastPage = 'last_page';
  static const String completedNounCategories =
      'noun_progress_completed_categories';
  static const String lastNounProgressionKey = 'last_noun_progression_key';
  static const String answerRevealMode = 'answer_reveal_mode';
  static const String progressionUnlockLaps = 'progression_unlock_laps';
  static const String showFirstLetterHint = 'show_first_letter_hint';

  /// Quest (CEFR A-level) progression keys — the linear streak chain in
  /// `questEntries`, kept separate from the noun-category chain.
  static const String questUnlockLaps = 'quest_unlock_laps';
  static const String completedQuestQuizzes = 'quest_completed_quizzes';
  static const String lastQuestQuizKey = 'last_quest_quiz_key';

  /// Per-gender highlight color key (gender is 'm'/'f'/'n').
  static String genderColor(String gender) => 'gender_color_$gender';
}
