import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global, app-wide set of nouns excluded from quizzes that draw from the
/// shared noun database (Artikel and Nouns & Articles). Managed from the
/// Word Library page and shared across all quizzes that use it.
class NounSettings {
  NounSettings._();

  static final NounSettings instance = NounSettings._();

  static const String _storageKey = 'global_disabled_nouns';
  static const String _showEnglishKeyPrefix = 'show_english_';
  static const String _colorNounsKeyPrefix = 'color_nouns_';
  static const String _lastPageKey = 'last_page';
  static const String _completedNounCategoriesKey =
      'noun_progress_completed_categories';
  static const String _lastNounProgressionKeyPref =
      'last_noun_progression_key';

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
  Map<String, bool> _colorNounsByPage = {};
  Map<String, Color> _genderColors = Map.of(defaultGenderColors);
  String? _lastPage;
  Set<String> _completedNounCategories = {};
  String? _lastNounProgressionKey;
  bool _loaded = false;

  bool isEnabled(String noun) => !_disabledNouns.contains(noun);

  /// Name of the [AppPage] the user last navigated to, or null if none was
  /// recorded yet. Used to reopen the app on the same page it was closed on.
  String? get lastPage => _lastPage;

  /// Progression keys (noun-category keys, or `kAllNounsProgressionKey`)
  /// whose quiz has reached a 10-answer streak at least once, permanently
  /// unlocking the next entry in the noun-category progression.
  Set<String> get completedNounCategories => _completedNounCategories;

  bool isNounCategoryCompleted(String key) =>
      _completedNounCategories.contains(key);

  /// The progression key (noun-category key, or `kAllNounsProgressionKey`)
  /// of the noun-progression entry the user last opened, or null if none was
  /// recorded yet.
  String? get lastNounProgressionKey => _lastNounProgressionKey;

  /// Whether English translations should be shown alongside nouns in
  /// reference/analytics tables, keyed by page (a [QuizConfig.storageKeyPrefix]
  /// or [wordLibraryPageKey]). Saved independently per page.
  bool showEnglishFor(String pageKey) => _showEnglishByPage[pageKey] ?? true;

  /// Whether nouns should be highlighted by their article's color in the
  /// word display, tables, and sentences, keyed by page (a
  /// [QuizConfig.storageKeyPrefix] or [wordLibraryPageKey]). Defaults to off,
  /// since the color can reveal quiz answers. Saved independently per page.
  bool colorNounsFor(String pageKey) => _colorNounsByPage[pageKey] ?? false;

  /// Highlight color for gender key 'm'/'f'/'n', used to color nouns by
  /// their article in noun-focused pages.
  Color colorForGender(String gender) =>
      _genderColors[gender] ?? defaultGenderColors[gender] ?? Colors.grey;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _disabledNouns = (prefs.getStringList(_storageKey) ?? const []).toSet();
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_showEnglishKeyPrefix)) {
        _showEnglishByPage[key.substring(_showEnglishKeyPrefix.length)] =
            prefs.getBool(key) ?? true;
      } else if (key.startsWith(_colorNounsKeyPrefix)) {
        _colorNounsByPage[key.substring(_colorNounsKeyPrefix.length)] =
            prefs.getBool(key) ?? false;
      }
    }
    _genderColors = {
      for (final entry in defaultGenderColors.entries)
        entry.key: Color(
          prefs.getInt(_colorKey(entry.key)) ?? entry.value.toARGB32(),
        ),
    };
    _lastPage = prefs.getString(_lastPageKey);
    _completedNounCategories =
        (prefs.getStringList(_completedNounCategoriesKey) ?? const []).toSet();
    _lastNounProgressionKey = prefs.getString(_lastNounProgressionKeyPref);
    _loaded = true;
  }

  Future<void> setLastPage(String page) async {
    _lastPage = page;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPageKey, page);
  }

  /// Marks [key] (a noun-category key, or `kAllNounsProgressionKey`) as
  /// having reached a 10-answer streak, permanently unlocking the next entry
  /// in the noun-category progression. No-op if already marked.
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

  Future<void> setColorNounsFor(String pageKey, bool value) async {
    _colorNounsByPage = Map.of(_colorNounsByPage);
    _colorNounsByPage[pageKey] = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_colorNounsKeyPrefix$pageKey', value);
  }

  String _colorKey(String gender) => 'gender_color_$gender';

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
