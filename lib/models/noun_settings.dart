import 'package:shared_preferences/shared_preferences.dart';

/// Global, app-wide set of nouns excluded from quizzes that draw from the
/// shared noun database (Artikel and Nouns & Articles). Managed from the
/// Word Library page and shared across all quizzes that use it.
class NounSettings {
  NounSettings._();

  static final NounSettings instance = NounSettings._();

  static const String _storageKey = 'global_disabled_nouns';

  Set<String> _disabledNouns = {};
  bool _loaded = false;

  bool isEnabled(String noun) => !_disabledNouns.contains(noun);

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _disabledNouns = (prefs.getStringList(_storageKey) ?? const []).toSet();
    _loaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _disabledNouns.toList());
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
