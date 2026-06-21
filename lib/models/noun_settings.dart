import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_keys.dart';
import 'user_settings.dart';

/// How long the correct answer (typed out letter by letter) stays on screen
/// after an incorrect submission, before moving on to the next question.
enum AnswerRevealMode {
  /// Brief pause before advancing.
  quick,

  /// Moderate pause before advancing.
  normal,

  /// Extended pause before advancing, giving slower readers more time.
  slow,
}

/// Global, app-wide set of nouns excluded from quizzes that draw from the
/// shared noun database (Artikel and Nouns & Articles). Managed from the
/// Word Library page and shared across all quizzes that use it.
class NounSettings {
  NounSettings._();

  static final NounSettings instance = NounSettings._();

  // Key names live in [SettingsKeys] so this singleton and the settings store
  // share one source of truth (and map to the same future database columns).
  static const String _storageKey = SettingsKeys.disabledNouns;
  static const String _showEnglishKeyPrefix = SettingsKeys.showEnglishPrefix;
  static const String _colorNounsKeyPrefix = SettingsKeys.colorNounsLegacyPrefix;
  static const String _colorNounsKey = SettingsKeys.colorNouns;
  static const String _lastPageKey = SettingsKeys.lastPage;
  static const String _lastContentIdKey = SettingsKeys.lastContentId;
  static const String _completedNounCategoriesKey =
      SettingsKeys.completedNounCategories;
  static const String _lastNounProgressionKeyPref =
      SettingsKeys.lastNounProgressionKey;
  static const String _answerRevealModeKey = SettingsKeys.answerRevealMode;
  static const String _progressionUnlockLapsKey =
      SettingsKeys.progressionUnlockLaps;
  static const String _showFirstLetterHintKey = SettingsKeys.showFirstLetterHint;
  static const String _questUnlockLapsKey = SettingsKeys.questUnlockLaps;
  static const String _completedQuestQuizzesKey =
      SettingsKeys.completedQuestQuizzes;
  static const String _lastQuestQuizKeyPref = SettingsKeys.lastQuestQuizKey;
  static const String _completedSpeakQuizzesKey =
      SettingsKeys.completedSpeakQuizzes;
  static const String _completedReadingQuizzesKey =
      SettingsKeys.completedReadingQuizzes;
  static const String _seenHelpMemoryKey = SettingsKeys.seenHelpMemory;

  /// Size of one "streak" — a run of this many correct answers in a row.
  static const int streakLapSize = 5;

  /// Default value for [progressionUnlockLaps]. Two 5-answer streaks, so a
  /// fill-in quiz is "done" (and its ribbon shows) — and the next noun category
  /// unlocks — at ×2/2, matching the Quest goal rather than a longer grind.
  static const int defaultProgressionUnlockLaps = 2;

  /// Default number of 5-answer streaks (laps) needed to pass a Quest quiz — a
  /// shorter goal than the noun-category default so cert quizzes advance faster.
  static const int defaultQuestUnlockLaps = 2;

  /// Page key used by the Word Library page, which isn't tied to a
  /// [QuizConfig.storageKeyPrefix].
  static const String wordLibraryPageKey = 'word_library_';

  /// Default highlight colors per grammatical gender: der (masculine) ->
  /// blue, die (feminine) -> red, das (neuter) -> green.
  static const Map<String, Color> defaultGenderColors = {
    'm': Colors.blue,
    'f': Colors.red,
    'n': Colors.green,
  };

  Set<String> _disabledNouns = {};
  Map<String, bool> _showEnglishByPage = {};
  bool _colorNouns = false;
  Map<String, Color> _genderColors = Map.of(defaultGenderColors);
  String? _lastPage;
  String? _lastContentId;
  Set<String> _completedNounCategories = {};
  String? _lastNounProgressionKey;
  AnswerRevealMode _answerRevealMode = AnswerRevealMode.normal;
  int _progressionUnlockLaps = defaultProgressionUnlockLaps;
  int _questUnlockLaps = defaultQuestUnlockLaps;
  Set<String> _completedQuestQuizzes = {};
  String? _lastQuestQuizKey;
  Set<String> _completedSpeakQuizzes = {};
  Set<String> _completedReadingQuizzes = {};
  Set<String> _seenHelpMemory = {};
  bool _showFirstLetterHint = false;
  bool _loaded = false;

  bool isEnabled(String noun) => !_disabledNouns.contains(noun);

  /// Name of the [AppPage] the user last navigated to, or null if none was
  /// recorded yet. Used to reopen the app on the same page it was closed on.
  String? get lastPage => _lastPage;

  /// `QuizContent.id` of the last data-driven nav quiz the user opened, used to
  /// reopen the app on it. Null if the last page wasn't a nav quiz.
  String? get lastContentId => _lastContentId;

  /// Progression keys (noun-category keys, or `kAllNounsProgressionKey`)
  /// whose quiz has reached a [progressionUnlockStreak]-answer streak at
  /// least once, permanently unlocking the next entry in the noun-category
  /// progression.
  Set<String> get completedNounCategories => _completedNounCategories;

  bool isNounCategoryCompleted(String key) =>
      _completedNounCategories.contains(key);

  /// The progression key (noun-category key, or `kAllNounsProgressionKey`)
  /// of the noun-progression entry the user last opened, or null if none was
  /// recorded yet.
  String? get lastNounProgressionKey => _lastNounProgressionKey;

  /// How long the typed-out correct answer stays on screen after an
  /// incorrect answer, before moving to the next question.
  AnswerRevealMode get answerRevealMode => _answerRevealMode;

  /// Number of consecutive 5-answer "streaks" needed in a noun-category
  /// sub-quiz to unlock the next entry in the noun-category progression.
  /// User-configurable from 1 to 100, defaults to
  /// [defaultProgressionUnlockLaps].
  int get progressionUnlockLaps => _progressionUnlockLaps;

  /// Whether to show the first letter of the answer (with a non-deletable red
  /// asterisk) when a question is answered incorrectly. The user still loses
  /// their streak. If they answer the same question incorrectly again, the
  /// answer is shown normally. Defaults to false.
  bool get showFirstLetterHint => _showFirstLetterHint;

  /// Total correct answers in a row needed to unlock the next entry in the
  /// noun-category progression ([progressionUnlockLaps] streaks of 5
  /// correct answers each).
  int get progressionUnlockStreak => _progressionUnlockLaps * streakLapSize;

  /// Number of consecutive 5-answer "streaks" needed in a Quest quiz to unlock
  /// the next quiz in the Quest (CEFR A-level) chain. Independent of the
  /// noun-category goal. User-configurable 1–100, defaults to
  /// [defaultQuestUnlockLaps].
  int get questUnlockLaps => _questUnlockLaps;

  /// Total correct answers in a row needed to unlock the next Quest quiz
  /// ([questUnlockLaps] streaks of 5 correct answers each).
  int get questUnlockStreak => _questUnlockLaps * streakLapSize;

  /// Quest quiz keys (from `questEntries`) whose quiz has reached a
  /// [questUnlockStreak]-answer streak at least once, permanently unlocking the
  /// next quiz in the Quest chain.
  Set<String> get completedQuestQuizzes => _completedQuestQuizzes;

  bool isQuestQuizCompleted(String key) =>
      _completedQuestQuizzes.contains(key);

  /// `QuizContent.id`s of listen-&-repeat (audio) quizzes the learner has
  /// played through to the end at least once. Such quizzes have no streak, so
  /// they count as "done" once seen in full rather than via a goal.
  Set<String> get completedSpeakQuizzes => _completedSpeakQuizzes;

  bool isSpeakQuizCompleted(String contentId) =>
      _completedSpeakQuizzes.contains(contentId);

  /// `QuizContent.id`s of reading-comprehension quizzes the learner has passed
  /// at least once. Reading is scored but has no streak, so it counts as "done"
  /// once passed rather than via the streak goal.
  Set<String> get completedReadingQuizzes => _completedReadingQuizzes;

  bool isReadingQuizCompleted(String contentId) =>
      _completedReadingQuizzes.contains(contentId);

  /// Best-streak a plain (non-progression) quiz must reach to count as "done"
  /// in the menu. Reuses the same configurable lap goal as the noun-category
  /// progression so the whole app shares one "goal".
  int get quizGoalStreak => progressionUnlockStreak;

  /// Whether a quiz has passed its streak goal (shown as a "Done" badge in the
  /// drawer and on the quiz home page). Quest and noun-category quizzes use
  /// their permanent completion sets; every other quiz is done once its best
  /// streak reaches [quizGoalStreak].
  bool isQuizDone({
    String? progressionKey,
    bool questProgression = false,
    required int bestStreakAbsolute,
  }) {
    if (progressionKey != null) {
      return questProgression
          ? isQuestQuizCompleted(progressionKey)
          : isNounCategoryCompleted(progressionKey);
    }
    return bestStreakAbsolute >= quizGoalStreak;
  }

  /// The Quest quiz key the user last opened, or null if none recorded yet.
  String? get lastQuestQuizKey => _lastQuestQuizKey;

  /// Whether the learner has already had the Help Memory panel auto-open for
  /// the quiz identified by [storageKeyPrefix]. Used to auto-open it only on
  /// the first visit.
  bool hasSeenHelpMemory(String storageKeyPrefix) =>
      _seenHelpMemory.contains(storageKeyPrefix);

  /// Whether English translations should be shown alongside nouns in
  /// reference/analytics tables, keyed by page (a [QuizConfig.storageKeyPrefix]
  /// or [wordLibraryPageKey]). Saved independently per page.
  bool showEnglishFor(String pageKey) => _showEnglishByPage[pageKey] ?? true;

  /// Whether nouns should be highlighted by their article's color in the
  /// word display, tables, and sentences. A single app-wide setting,
  /// adjustable from any quiz's settings panel. Defaults to off, since the
  /// color can reveal quiz answers.
  bool get colorNouns => _colorNouns;

  /// Highlight color for gender key 'm'/'f'/'n', used to color nouns by
  /// their article in noun-focused pages.
  Color colorForGender(String gender) =>
      _genderColors[gender] ?? defaultGenderColors[gender] ?? Colors.grey;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _disabledNouns = (prefs.getStringList(_storageKey) ?? const []).toSet();
    final legacyColorNounsKeys = <String>[];
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_showEnglishKeyPrefix)) {
        _showEnglishByPage[key.substring(_showEnglishKeyPrefix.length)] =
            prefs.getBool(key) ?? true;
      } else if (key.startsWith(_colorNounsKeyPrefix)) {
        legacyColorNounsKeys.add(key);
      }
    }
    if (prefs.containsKey(_colorNounsKey)) {
      _colorNouns = prefs.getBool(_colorNounsKey) ?? false;
    } else {
      // Migrate from the old per-page setting: on if any page had it on.
      _colorNouns = legacyColorNounsKeys.any(
        (key) => prefs.getBool(key) ?? false,
      );
    }
    for (final key in legacyColorNounsKeys) {
      await prefs.remove(key);
    }
    _genderColors = {
      for (final entry in defaultGenderColors.entries)
        entry.key: Color(
          prefs.getInt(_colorKey(entry.key)) ?? entry.value.toARGB32(),
        ),
    };
    _lastPage = prefs.getString(_lastPageKey);
    _lastContentId = prefs.getString(_lastContentIdKey);
    _completedNounCategories =
        (prefs.getStringList(_completedNounCategoriesKey) ?? const []).toSet();
    _lastNounProgressionKey = prefs.getString(_lastNounProgressionKeyPref);
    _answerRevealMode = AnswerRevealMode.values.firstWhere(
      (mode) => mode.name == prefs.getString(_answerRevealModeKey),
      orElse: () => AnswerRevealMode.normal,
    );
    _progressionUnlockLaps =
        prefs.getInt(_progressionUnlockLapsKey) ?? defaultProgressionUnlockLaps;
    _questUnlockLaps =
        prefs.getInt(_questUnlockLapsKey) ?? defaultQuestUnlockLaps;
    _completedQuestQuizzes =
        (prefs.getStringList(_completedQuestQuizzesKey) ?? const []).toSet();
    _lastQuestQuizKey = prefs.getString(_lastQuestQuizKeyPref);
    _completedSpeakQuizzes =
        (prefs.getStringList(_completedSpeakQuizzesKey) ?? const []).toSet();
    _completedReadingQuizzes =
        (prefs.getStringList(_completedReadingQuizzesKey) ?? const []).toSet();
    _seenHelpMemory =
        (prefs.getStringList(_seenHelpMemoryKey) ?? const []).toSet();
    _showFirstLetterHint =
        prefs.getBool(_showFirstLetterHintKey) ?? false;
    _loaded = true;
  }

  Future<void> setLastPage(String page) async {
    _lastPage = page;
    // Leaving a data-driven quiz for a fixed page: clear the content resume.
    _lastContentId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPageKey, page);
    await prefs.remove(_lastContentIdKey);
  }

  /// Records [contentId] as the last data-driven nav quiz opened (takes resume
  /// priority over [lastPage] until a fixed page is opened).
  Future<void> setLastContentId(String contentId) async {
    _lastContentId = contentId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastContentIdKey, contentId);
  }

  /// Marks [key] (a noun-category key, or `kAllNounsProgressionKey`) as
  /// having reached a [progressionUnlockStreak]-answer streak, permanently
  /// unlocking the next entry in the noun-category progression. No-op if
  /// already marked.
  Future<void> markNounCategoryCompleted(String key) async {
    if (_completedNounCategories.contains(key)) return;
    _completedNounCategories = {..._completedNounCategories, key};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _completedNounCategoriesKey,
      _completedNounCategories.toList(),
    );
  }

  Future<void> setLastNounProgressionKey(String key) async {
    _lastNounProgressionKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNounProgressionKeyPref, key);
  }

  Future<void> setAnswerRevealMode(AnswerRevealMode mode) async {
    _answerRevealMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_answerRevealModeKey, mode.name);
  }

  /// Sets [progressionUnlockLaps], clamped to the 1-100 range.
  Future<void> setProgressionUnlockLaps(int laps) async {
    _progressionUnlockLaps = laps.clamp(1, 100);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_progressionUnlockLapsKey, _progressionUnlockLaps);
  }

  /// Sets [questUnlockLaps], clamped to the 1-100 range.
  Future<void> setQuestUnlockLaps(int laps) async {
    _questUnlockLaps = laps.clamp(1, 100);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_questUnlockLapsKey, _questUnlockLaps);
  }

  /// Marks Quest quiz [key] as having reached a [questUnlockStreak]-answer
  /// streak, permanently unlocking the next quiz in the Quest chain. No-op if
  /// already marked.
  Future<void> markQuestQuizCompleted(String key) async {
    if (_completedQuestQuizzes.contains(key)) return;
    _completedQuestQuizzes = {..._completedQuestQuizzes, key};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _completedQuestQuizzesKey,
      _completedQuestQuizzes.toList(),
    );
  }

  Future<void> setLastQuestQuizKey(String key) async {
    _lastQuestQuizKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastQuestQuizKeyPref, key);
  }

  /// Marks listen-&-repeat quiz [contentId] as played through to the end,
  /// permanently flagging it "done" on the quiz home page. No-op if already
  /// marked.
  Future<void> markSpeakQuizCompleted(String contentId) async {
    if (_completedSpeakQuizzes.contains(contentId)) return;
    _completedSpeakQuizzes = {..._completedSpeakQuizzes, contentId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _completedSpeakQuizzesKey,
      _completedSpeakQuizzes.toList(),
    );
  }

  /// Marks reading-comprehension quiz [contentId] as passed, permanently
  /// flagging it "done" (ribbon) on the quiz home page and drawer. No-op if
  /// already marked.
  Future<void> markReadingQuizCompleted(String contentId) async {
    if (_completedReadingQuizzes.contains(contentId)) return;
    _completedReadingQuizzes = {..._completedReadingQuizzes, contentId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _completedReadingQuizzesKey,
      _completedReadingQuizzes.toList(),
    );
  }

  /// Marks the Help Memory panel for [storageKeyPrefix] as seen, so it won't
  /// auto-open again. No-op if already marked.
  Future<void> markHelpMemorySeen(String storageKeyPrefix) async {
    if (_seenHelpMemory.contains(storageKeyPrefix)) return;
    _seenHelpMemory = {..._seenHelpMemory, storageKeyPrefix};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_seenHelpMemoryKey, _seenHelpMemory.toList());
  }

  Future<void> setShowFirstLetterHint(bool value) async {
    _showFirstLetterHint = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showFirstLetterHintKey, value);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _disabledNouns.toList());
  }

  Future<void> setShowEnglishFor(String pageKey, bool value) async {
    _showEnglishByPage = Map.of(_showEnglishByPage);
    _showEnglishByPage[pageKey] = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_showEnglishKeyPrefix$pageKey', value);
  }

  Future<void> setColorNouns(bool value) async {
    _colorNouns = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_colorNounsKey, value);
  }

  String _colorKey(String gender) => SettingsKeys.genderColor(gender);

  /// Database-ready snapshot of the current in-memory settings. The serializable
  /// twin a [SettingsStore] (today SharedPreferences, later a database) persists.
  UserSettings toUserSettings() => UserSettings(
    disabledNouns: _disabledNouns.toList(),
    showEnglishByPage: Map.of(_showEnglishByPage),
    colorNouns: _colorNouns,
    genderColors: {
      for (final entry in _genderColors.entries) entry.key: entry.value.toARGB32(),
    },
    lastPage: _lastPage,
    lastContentId: _lastContentId,
    completedNounCategories: _completedNounCategories.toList(),
    lastNounProgressionKey: _lastNounProgressionKey,
    answerRevealMode: _answerRevealMode.name,
    progressionUnlockLaps: _progressionUnlockLaps,
    questUnlockLaps: _questUnlockLaps,
    completedQuestQuizzes: _completedQuestQuizzes.toList(),
    lastQuestQuizKey: _lastQuestQuizKey,
    completedSpeakQuizzes: _completedSpeakQuizzes.toList(),
    completedReadingQuizzes: _completedReadingQuizzes.toList(),
    seenHelpMemory: _seenHelpMemory.toList(),
    showFirstLetterHint: _showFirstLetterHint,
  );

  Future<void> setGenderColor(String gender, Color color) async {
    _genderColors = Map.of(_genderColors);
    _genderColors[gender] = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey(gender), color.toARGB32());
  }

  Future<void> resetGenderColors() async {
    _genderColors = Map.of(defaultGenderColors);
    final prefs = await SharedPreferences.getInstance();
    for (final gender in defaultGenderColors.keys) {
      await prefs.remove(_colorKey(gender));
    }
  }

  /// Wipes all stored progress and settings (quiz scores/streaks/history,
  /// noun-category progression, disabled nouns, gender colors, the
  /// answer-reveal preference, the progression streak-unlock goal, and the
  /// first-letter hint preference), restoring everything to its default state.
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _disabledNouns = {};
    _showEnglishByPage = {};
    _colorNouns = false;
    _genderColors = Map.of(defaultGenderColors);
    _showFirstLetterHint = false;
    _lastPage = null;
    _lastContentId = null;
    _completedNounCategories = {};
    _lastNounProgressionKey = null;
    _answerRevealMode = AnswerRevealMode.normal;
    _progressionUnlockLaps = defaultProgressionUnlockLaps;
    _questUnlockLaps = defaultQuestUnlockLaps;
    _completedQuestQuizzes = {};
    _lastQuestQuizKey = null;
    _completedSpeakQuizzes = {};
    _completedReadingQuizzes = {};
    _seenHelpMemory = {};
  }

  Future<void> toggle(String noun) async {
    _disabledNouns = Set.of(_disabledNouns);
    if (!_disabledNouns.remove(noun)) {
      _disabledNouns.add(noun);
    }
    await _save();
  }

  Future<void> setEnabled(Iterable<String> nouns, bool enabled) async {
    _disabledNouns = Set.of(_disabledNouns);
    if (enabled) {
      _disabledNouns.removeAll(nouns);
    } else {
      _disabledNouns.addAll(nouns);
    }
    await _save();
  }
}
