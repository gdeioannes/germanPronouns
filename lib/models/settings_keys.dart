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

  /// The learner's global coin balance (the coin "wallet"). One app-wide value,
  /// not per-quiz: every quiz adds to and shows the same total. See [CoinWallet].
  static const String coinBalance = 'coin_balance';

  /// Ids of the furniture the learner has bought for the apartment mini-game
  /// (a `StringList`). See `Apartment` and `shopCatalog`.
  static const String apartmentItems = 'apartment_items';

  /// Where each owned item sits in the room, as a JSON map of `id -> [x, y]`
  /// with x/y normalized to 0..1 (so positions survive across different screen
  /// sizes). See `Apartment`.
  static const String apartmentLayout = 'apartment_layout';

  /// Ids of the furniture that has been *revealed* (became affordable at least
  /// once, so it appears in the shop and stays). A `StringList`. See
  /// `Apartment` and `shopCatalog`.
  static const String apartmentRevealed = 'apartment_revealed';

  /// Whether the room is shown at night (lights cast warm pools) vs day. A
  /// `bool`. See `Apartment.isNight`.
  static const String apartmentNight = 'apartment_night';

  /// `QuizContent.id` of the last data-driven nav quiz opened, for resume.
  static const String lastContentId = 'last_content_id';
  static const String completedNounCategories =
      'noun_progress_completed_categories';
  static const String lastNounProgressionKey = 'last_noun_progression_key';
  static const String answerRevealMode = 'answer_reveal_mode';
  static const String progressionUnlockLaps = 'progression_unlock_laps';
  static const String showFirstLetterHint = 'show_first_letter_hint';

  /// Whether typed answers are checked leniently — accents, umlauts and ß are
  /// folded to their plain base letter before comparison (see
  /// `utils/answer_normalization.dart`), so a learner without the right keyboard
  /// isn't marked wrong for a missing mark.
  static const String relaxedCorrection = 'relaxed_correction';

  /// Whether the one-time "turn on relaxed correction" hint has been shown after
  /// the learner's first answer that was wrong only because of an accent/umlaut.
  static const String seenRelaxedCorrectionHint = 'seen_relaxed_correction_hint';

  /// Quest (CEFR A-level) progression keys — the linear streak chain in
  /// `questEntries`, kept separate from the noun-category chain.
  static const String questUnlockLaps = 'quest_unlock_laps';
  static const String completedQuestQuizzes = 'quest_completed_quizzes';
  static const String lastQuestQuizKey = 'last_quest_quiz_key';

  /// `QuizContent.id`s of listen-&-repeat (audio) quizzes the learner has played
  /// through to the end at least once. Marks them "done" on the quiz home page.
  static const String completedSpeakQuizzes = 'speak_completed_quizzes';

  /// `QuizContent.id`s of reading-comprehension quizzes the learner has passed
  /// at least once. Reading has no streak, so this marks them "done" (ribbon) on
  /// the quiz home page and drawer, the same way [completedSpeakQuizzes] does for
  /// listen-&-repeat quizzes.
  static const String completedReadingQuizzes = 'reading_completed_quizzes';

  /// `QuizContent.id`s of listening-comprehension (Hörverstehen) quizzes the
  /// learner has passed at least once. Like reading, listening is scored but has
  /// no streak, so this marks them "done" (ribbon), the same way
  /// [completedReadingQuizzes] does for reading.
  static const String completedListeningQuizzes = 'listening_completed_quizzes';

  /// `QuizContent.id`s of dictation (Diktat) quizzes the learner has passed at
  /// least once. Like reading/listening, dictation is scored with no streak, so
  /// this marks them "done" (ribbon).
  static const String completedDictationQuizzes = 'dictation_completed_quizzes';

  /// Quiz storage-key prefixes whose Help Memory panel the learner has already
  /// seen auto-opened (so it only auto-opens once per quiz).
  static const String seenHelpMemory = 'seen_help_memory';

  /// Whether the learner has forced the low-quality on-device voice instead of
  /// the premium cloud voices (the voice-quality "offline only" toggle). A
  /// per-device playback preference owned by `TtsService`, not part of the
  /// learner-progress snapshot.
  static const String voiceOfflineOnly = 'voice_offline_only';

  /// Per-gender highlight color key (gender is 'm'/'f'/'n').
  static String genderColor(String gender) => 'gender_color_$gender';
}
