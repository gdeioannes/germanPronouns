/// A learned language's shared verb list — cross-course reference data used by
/// every course that teaches that language (the Word Library's Verbs tab).
///
/// Stored once at `assets/content/shared/verbs/<lang>.json` (keyed by the
/// learned-language code, e.g. `de`, `es`), mirroring the shared noun
/// collections, so multiple courses for the same language share one list.
library;

/// One conjugated (or pattern) form: the person/label cell and the form cell
/// of a conjugation-table row (e.g. `ich` → `bin`, or for Chinese a pattern
/// row like `完成` → `吃了`).
class ConjugationForm {
  const ConjugationForm({required this.person, required this.form});

  final String person;
  final String form;

  Map<String, dynamic> toJson() => {'person': person, 'form': form};

  factory ConjugationForm.fromJson(Map<String, dynamic> json) =>
      ConjugationForm(
        person: json['person'] as String? ?? '',
        form: json['form'] as String,
      );
}

/// One named conjugation table of a verb (e.g. "Präsens" with its six person
/// forms). A verb ships with at least the five most useful tenses/patterns of
/// its language.
class ConjugationSet {
  const ConjugationSet({required this.label, required this.forms});

  /// Tense/pattern name in the learned language (e.g. `Präsens`, `Presente`,
  /// `了 · completed action`) — part of what the learner is studying.
  final String label;

  final List<ConjugationForm> forms;

  Map<String, dynamic> toJson() => {
    'label': label,
    'forms': [for (final f in forms) f.toJson()],
  };

  factory ConjugationSet.fromJson(Map<String, dynamic> json) => ConjugationSet(
    label: json['label'] as String,
    forms: [
      for (final f in (json['forms'] as List?) ?? const [])
        ConjugationForm.fromJson(Map<String, dynamic>.from(f as Map)),
    ],
  );
}

/// A verb of the learned language: dictionary form, meanings per UI language,
/// and its conjugation tables.
class VerbEntry {
  const VerbEntry({
    required this.verb,
    required this.english,
    required this.sets,
    this.meanings = const {},
  });

  /// Dictionary form (infinitive), e.g. `sein`, `hablar`, `吃`.
  final String verb;

  /// Canonical English meaning — the fallback when [meanings] has no entry
  /// for the course's UI language.
  final String english;

  /// Additional meanings keyed by UI-language code (e.g. `de` → 'sprechen').
  final Map<String, String> meanings;

  /// The verb's conjugation tables, most useful first (≥ 5 per verb).
  final List<ConjugationSet> sets;

  /// The meaning shown to a learner whose UI language is [uiLangCode]
  /// (a `UiLang` name). Falls back to [english].
  String meaningFor(String uiLangCode) =>
      uiLangCode == 'en' ? english : (meanings[uiLangCode] ?? english);

  Map<String, dynamic> toJson() => {
    'verb': verb,
    'english': english,
    if (meanings.isNotEmpty) 'meanings': meanings,
    'sets': [for (final s in sets) s.toJson()],
  };

  factory VerbEntry.fromJson(Map<String, dynamic> json) => VerbEntry(
    verb: json['verb'] as String,
    english: json['english'] as String,
    meanings: (json['meanings'] as Map?)?.cast<String, String>() ?? const {},
    sets: [
      for (final s in (json['sets'] as List?) ?? const [])
        ConjugationSet.fromJson(Map<String, dynamic>.from(s as Map)),
    ],
  );
}

/// A learned language's shared verb list, in study order (most common first).
class VerbCollection {
  const VerbCollection({this.verbs = const []});

  final List<VerbEntry> verbs;

  bool get isEmpty => verbs.isEmpty;

  Map<String, dynamic> toJson() => {
    'verbs': [for (final v in verbs) v.toJson()],
  };

  factory VerbCollection.fromJson(Map<String, dynamic> json) => VerbCollection(
    verbs: [
      for (final v in (json['verbs'] as List?) ?? const [])
        VerbEntry.fromJson(Map<String, dynamic>.from(v as Map)),
    ],
  );
}
