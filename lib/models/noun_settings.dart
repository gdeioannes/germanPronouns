import 'package:shared_preferences/shared_preferences.dart';

/// Global, app-wide set of nouns excluded from quizzes that draw from the
/// shared noun database (Artikel and Nouns & Articles). Managed from the
/// Word Library page and shared across all quizzes that use it.
class NounSettings {
  NounSettings._();

  static final NounSettings instance = NounSettings._();

  static const String _storageKey = 'global_disabled_nouns';
  static const String _showEnglishKey = 'global_show_english';

  Set<String> _disabledNouns = {};
  bool _showEnglish = true;
  bool _loaded = false;

  bool isEnabled(String noun) => !_disabledNouns.contains(noun);

  /// Whether English translations should be shown alongside nouns in
  /// reference/analytics tables and the Word Library.
  bool get showEnglish => _showEnglish;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _disabledNouns = (prefs.getStringList(_storageKey) ?? const []).toSet();
    _showEnglish = prefs.getBool(_showEnglishKey) ?? true;
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
