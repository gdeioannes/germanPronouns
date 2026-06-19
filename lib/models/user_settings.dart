/// Serializable, database-ready snapshot of the global user settings.
///
/// This is the persistent twin of the mutable [NounSettings] singleton: pure
/// data (no Flutter types — gender colors are stored as ARGB ints, the
/// answer-reveal mode as its enum name), so it can be written to and read from
/// a database or JSON. The settings store (see data/settings_store.dart) reads
/// and writes this; `NounSettings.toUserSettings()` produces it from the live
/// in-memory state.
class UserSettings {
  const UserSettings({
    this.disabledNouns = const [],
    this.showEnglishByPage = const {},
    this.colorNouns = false,
    this.genderColors = const {},
    this.lastPage,
    this.completedNounCategories = const [],
    this.lastNounProgressionKey,
    this.answerRevealMode = 'normal',
    this.progressionUnlockLaps = 5,
    this.questUnlockLaps = 5,
    this.completedQuestQuizzes = const [],
    this.lastQuestQuizKey,
    this.seenHelpMemory = const [],
    this.showFirstLetterHint = false,
  });

  /// Nouns excluded from quizzes that draw on the shared noun database.
  final List<String> disabledNouns;

  /// "Show English meanings" toggle per page key.
  final Map<String, bool> showEnglishByPage;

  final bool colorNouns;

  /// Highlight color per gender ('m'/'f'/'n') as an ARGB int. Empty means the
  /// app's default colors.
  final Map<String, int> genderColors;

  final String? lastPage;
  final List<String> completedNounCategories;
  final String? lastNounProgressionKey;

  /// Name of an `AnswerRevealMode` value ('quick'/'normal'/'slow').
  final String answerRevealMode;

  final int progressionUnlockLaps;

  /// Streaks needed to unlock the next Quest quiz (separate from
  /// [progressionUnlockLaps]).
  final int questUnlockLaps;

  /// Quest quiz keys that have reached the Quest streak goal at least once.
  final List<String> completedQuestQuizzes;

  /// The Quest quiz key last opened.
  final String? lastQuestQuizKey;

  /// Quiz storage-key prefixes whose Help Memory has already auto-opened once.
  final List<String> seenHelpMemory;

  final bool showFirstLetterHint;

  UserSettings copyWith({
    List<String>? disabledNouns,
    Map<String, bool>? showEnglishByPage,
    bool? colorNouns,
    Map<String, int>? genderColors,
    String? lastPage,
    List<String>? completedNounCategories,
    String? lastNounProgressionKey,
    String? answerRevealMode,
    int? progressionUnlockLaps,
    int? questUnlockLaps,
    List<String>? completedQuestQuizzes,
    String? lastQuestQuizKey,
    List<String>? seenHelpMemory,
    bool? showFirstLetterHint,
  }) => UserSettings(
    disabledNouns: disabledNouns ?? this.disabledNouns,
    showEnglishByPage: showEnglishByPage ?? this.showEnglishByPage,
    colorNouns: colorNouns ?? this.colorNouns,
    genderColors: genderColors ?? this.genderColors,
    lastPage: lastPage ?? this.lastPage,
    completedNounCategories:
        completedNounCategories ?? this.completedNounCategories,
    lastNounProgressionKey:
        lastNounProgressionKey ?? this.lastNounProgressionKey,
    answerRevealMode: answerRevealMode ?? this.answerRevealMode,
    progressionUnlockLaps: progressionUnlockLaps ?? this.progressionUnlockLaps,
    questUnlockLaps: questUnlockLaps ?? this.questUnlockLaps,
    completedQuestQuizzes: completedQuestQuizzes ?? this.completedQuestQuizzes,
    lastQuestQuizKey: lastQuestQuizKey ?? this.lastQuestQuizKey,
    seenHelpMemory: seenHelpMemory ?? this.seenHelpMemory,
    showFirstLetterHint: showFirstLetterHint ?? this.showFirstLetterHint,
  );

  Map<String, dynamic> toJson() => {
    'disabledNouns': disabledNouns,
    'showEnglishByPage': showEnglishByPage,
    'colorNouns': colorNouns,
    'genderColors': genderColors,
    if (lastPage != null) 'lastPage': lastPage,
    'completedNounCategories': completedNounCategories,
    if (lastNounProgressionKey != null)
      'lastNounProgressionKey': lastNounProgressionKey,
    'answerRevealMode': answerRevealMode,
    'progressionUnlockLaps': progressionUnlockLaps,
    'questUnlockLaps': questUnlockLaps,
    'completedQuestQuizzes': completedQuestQuizzes,
    if (lastQuestQuizKey != null) 'lastQuestQuizKey': lastQuestQuizKey,
    'seenHelpMemory': seenHelpMemory,
    'showFirstLetterHint': showFirstLetterHint,
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    disabledNouns:
        (json['disabledNouns'] as List?)?.cast<String>() ?? const [],
    showEnglishByPage:
        (json['showEnglishByPage'] as Map?)?.cast<String, bool>() ?? const {},
    colorNouns: json['colorNouns'] as bool? ?? false,
    genderColors:
        (json['genderColors'] as Map?)?.cast<String, int>() ?? const {},
    lastPage: json['lastPage'] as String?,
    completedNounCategories:
        (json['completedNounCategories'] as List?)?.cast<String>() ?? const [],
    lastNounProgressionKey: json['lastNounProgressionKey'] as String?,
    answerRevealMode: json['answerRevealMode'] as String? ?? 'normal',
    progressionUnlockLaps: json['progressionUnlockLaps'] as int? ?? 5,
    questUnlockLaps: json['questUnlockLaps'] as int? ?? 5,
    completedQuestQuizzes:
        (json['completedQuestQuizzes'] as List?)?.cast<String>() ?? const [],
    lastQuestQuizKey: json['lastQuestQuizKey'] as String?,
    seenHelpMemory:
        (json['seenHelpMemory'] as List?)?.cast<String>() ?? const [],
    showFirstLetterHint: json['showFirstLetterHint'] as bool? ?? false,
  );
}
