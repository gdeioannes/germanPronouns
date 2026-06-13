import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global, app-wide set of nouns excluded from quizzes that draw from the
/// shared noun database (Artikel and Nouns & Articles). Managed from the
/// Word Library page and shared across all quizzes that use it.
class NounSettings {
  NounSettings._();

  static final NounSettings instance = NounSettings._();

  static const String _storageKey = 'global_disabled_nouns';
  static const String _showEnglishKey = 'global_show_english';
  static const String _colorNounsKey = 'global_color_nouns';

  /// Default highlight colors per grammatical gender: der (masculine) ->
  /// blue, die (feminine) -> red, das (neuter) -> green.
  static const Map<String, Color> defaultGenderColors = {
    'm': Colors.blue,
    'f': Colors.red,
    'n': Colors.green,
  };

  Set<String> _disabledNouns = {};
  bool _showEnglish = true;
  bool _colorNouns = false;
  Map<String, Color> _genderColors = Map.of(defaultGenderColors);
  bool _loaded = false;

  bool isEnabled(String noun) => !_disabledNouns.contains(noun);

  /// Whether English translations should be shown alongside nouns in
  /// reference/analytics tables and the Word Library.
  bool get showEnglish => _showEnglish;

  /// Whether nouns should be highlighted by their article's color in the
  /// word display, tables, and sentences. Defaults to off in the Artikel
  /// and Nouns & Articles quizzes, since the color reveals the answer.
  bool get colorNouns => _colorNouns;

  /// Highlight color for gender key 'm'/'f'/'n', used to color nouns by
  /// their article in noun-focused pages.
  Color colorForGender(String gender) =>
      _genderColors[gender] ?? defaultGenderColors[gender] ?? Colors.grey;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _disabledNouns = (prefs.getStringList(_storageKey) ?? const []).toSet();
    _showEnglish = prefs.getBool(_showEnglishKey) ?? true;
    _colorNouns = prefs.getBool(_colorNounsKey) ?? false;
    _genderColors = {
      for (final entry in defaultGenderColors.entries)
        entry.key: Color(
          prefs.getInt(_colorKey(entry.key)) ?? entry.value.toARGB32(),
        ),
    };
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _disabledNouns.toList());
  }

  Future<void> setShowEnglish(bool value) async {
    _showEnglish = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showEnglishKey, value);
  }

  Future<void> setColorNouns(bool value) async {
    _colorNouns = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_colorNounsKey, value);
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
