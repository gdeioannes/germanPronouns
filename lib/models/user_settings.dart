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
    this.lastContentId,
    this.completedNounCategories = const [],
    this.lastNounProgressionKey,
    this.answerRevealMode = 'normal',
    this.progressionUnlockLaps = 2,
    this.questUnlockLaps = 2,
    this.completedQuestQuizzes = const [],
    this.lastQuestQuizKey,
    this.completedSpeakQuizzes = const [],
    this.completedReadingQuizzes = const [],
    this.completedListeningQuizzes = const [],
    this.completedDictationQuizzes = const [],
    this.seenHelpMemory = const [],
    this.showFirstLetterHint = false,
    this.relaxedCorrection = false,
    this.seenRelaxedCorrectionHint = false,
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

  /// `QuizContent.id` of the last data-driven nav quiz opened (resume).
  final String? lastContentId;

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

  /// `QuizContent.id`s of listen-&-repeat quizzes played through to the end.
  final List<String> completedSpeakQuizzes;

  /// `QuizContent.id`s of reading-comprehension quizzes passed at least once.
  final List<String> completedReadingQuizzes;

  /// `QuizContent.id`s of listening-comprehension (Hörverstehen) quizzes passed
  /// at least once.
  final List<String> completedListeningQuizzes;

  /// `QuizContent.id`s of dictation (Diktat) quizzes passed at least once.
  final List<String> completedDictationQuizzes;

  /// Quiz storage-key prefixes whose Help Memory has already auto-opened once.
  final List<String> seenHelpMemory;

  final bool showFirstLetterHint;

  /// Whether typed answers are checked leniently (accents/umlauts/ß folded to
  /// their base letter before comparison).
  final bool relaxedCorrection;

  /// Whether the one-time relaxed-correction hint panel has been shown.
  final bool seenRelaxedCorrectionHint;

  UserSettings copyWith({
    List<String>? disabledNouns,
    Map<String, bool>? showEnglishByPage,
    bool? colorNouns,
    Map<String, int>? genderColors,
    String? lastPage,
    String? lastContentId,
    List<String>? completedNounCategories,
    String? lastNounProgressionKey,
    String? answerRevealMode,
    int? progressionUnlockLaps,
    int? questUnlockLaps,
    List<String>? completedQuestQuizzes,
    String? lastQuestQuizKey,
    List<String>? completedSpeakQuizzes,
    List<String>? completedReadingQuizzes,
    List<String>? completedListeningQuizzes,
    List<String>? completedDictationQuizzes,
    List<String>? seenHelpMemory,
    bool? showFirstLetterHint,
    bool? relaxedCorrection,
    bool? seenRelaxedCorrectionHint,
  }) => UserSettings(
    disabledNouns: disabledNouns ?? this.disabledNouns,
    showEnglishByPage: showEnglishByPage ?? this.showEnglishByPage,
    colorNouns: colorNouns ?? this.colorNouns,
    genderColors: genderColors ?? this.genderColors,
    lastPage: lastPage ?? this.lastPage,
    lastContentId: lastContentId ?? this.lastContentId,
    completedNounCategories:
        completedNounCategories ?? this.completedNounCategories,
    lastNounProgressionKey:
        lastNounProgressionKey ?? this.lastNounProgressionKey,
    answerRevealMode: answerRevealMode ?? this.answerRevealMode,
    progressionUnlockLaps: progressionUnlockLaps ?? this.progressionUnlockLaps,
    questUnlockLaps: questUnlockLaps ?? this.questUnlockLaps,
    completedQuestQuizzes: completedQuestQuizzes ?? this.completedQuestQuizzes,
    lastQuestQuizKey: lastQuestQuizKey ?? this.lastQuestQuizKey,
    completedSpeakQuizzes: completedSpeakQuizzes ?? this.completedSpeakQuizzes,
    completedReadingQuizzes:
        completedReadingQuizzes ?? this.completedReadingQuizzes,
    completedListeningQuizzes:
        completedListeningQuizzes ?? this.completedListeningQuizzes,
    completedDictationQuizzes:
        completedDictationQuizzes ?? this.completedDictationQuizzes,
    seenHelpMemory: seenHelpMemory ?? this.seenHelpMemory,
    showFirstLetterHint: showFirstLetterHint ?? this.showFirstLetterHint,
    relaxedCorrection: relaxedCorrection ?? this.relaxedCorrection,
    seenRelaxedCorrectionHint:
        seenRelaxedCorrectionHint ?? this.seenRelaxedCorrectionHint,
  );

  Map<String, dynamic> toJson() => {
    'disabledNouns': disabledNouns,
    'showEnglishByPage': showEnglishByPage,
    'colorNouns': colorNouns,
    'genderColors': genderColors,
    if (lastPage != null) 'lastPage': lastPage,
    if (lastContentId != null) 'lastContentId': lastContentId,
    'completedNounCategories': completedNounCategories,
    if (lastNounProgressionKey != null)
      'lastNounProgressionKey': lastNounProgressionKey,
    'answerRevealMode': answerRevealMode,
    'progressionUnlockLaps': progressionUnlockLaps,
    'questUnlockLaps': questUnlockLaps,
    'completedQuestQuizzes': completedQuestQuizzes,
    if (lastQuestQuizKey != null) 'lastQuestQuizKey': lastQuestQuizKey,
    'completedSpeakQuizzes': completedSpeakQuizzes,
    'completedReadingQuizzes': completedReadingQuizzes,
    'completedListeningQuizzes': completedListeningQuizzes,
    'completedDictationQuizzes': completedDictationQuizzes,
    'seenHelpMemory': seenHelpMemory,
    'showFirstLetterHint': showFirstLetterHint,
    'relaxedCorrection': relaxedCorrection,
    'seenRelaxedCorrectionHint': seenRelaxedCorrectionHint,
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
    lastContentId: json['lastContentId'] as String?,
    completedNounCategories:
        (json['completedNounCategories'] as List?)?.cast<String>() ?? const [],
    lastNounProgressionKey: json['lastNounProgressionKey'] as String?,
    answerRevealMode: json['answerRevealMode'] as String? ?? 'normal',
    progressionUnlockLaps: json['progressionUnlockLaps'] as int? ?? 2,
    questUnlockLaps: json['questUnlockLaps'] as int? ?? 2,
    completedQuestQuizzes:
        (json['completedQuestQuizzes'] as List?)?.cast<String>() ?? const [],
    lastQuestQuizKey: json['lastQuestQuizKey'] as String?,
    completedSpeakQuizzes:
        (json['completedSpeakQuizzes'] as List?)?.cast<String>() ?? const [],
    completedReadingQuizzes:
        (json['completedReadingQuizzes'] as List?)?.cast<String>() ?? const [],
    completedListeningQuizzes:
        (json['completedListeningQuizzes'] as List?)?.cast<String>() ??
        const [],
    completedDictationQuizzes:
        (json['completedDictationQuizzes'] as List?)?.cast<String>() ??
        const [],
    seenHelpMemory:
        (json['seenHelpMemory'] as List?)?.cast<String>() ?? const [],
    showFirstLetterHint: json['showFirstLetterHint'] as bool? ?? false,
    relaxedCorrection: json['relaxedCorrection'] as bool? ?? false,
    seenRelaxedCorrectionHint:
        json['seenRelaxedCorrectionHint'] as bool? ?? false,
  );
}
