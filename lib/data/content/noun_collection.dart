import '../noun_database.dart';

/// A learned language's shared noun list plus its category display labels —
/// cross-course reference data used by every course that teaches that language
/// (the Word Library and, later, the noun quizzes).
///
/// Stored once at `assets/content/shared/nouns/<lang>.json` (keyed by the
/// learned-language code, e.g. `de`, `es`) instead of being duplicated into
/// each course bundle — the normalized "shared collection" half of the model.
class NounCollection {
  const NounCollection({
    this.categoryDisplayNames = const {},
    this.nouns = const [],
  });

  /// Bilingual display label per category key (e.g. `kitchen` → `Kitchen (Küche)`).
  final Map<String, String> categoryDisplayNames;

  final List<GermanNoun> nouns;

  bool get isEmpty => nouns.isEmpty;

  Map<String, dynamic> toJson() => {
    'categoryDisplayNames': categoryDisplayNames,
    'nouns': [for (final n in nouns) n.toJson()],
  };

  factory NounCollection.fromJson(Map<String, dynamic> json) => NounCollection(
    categoryDisplayNames:
        (json['categoryDisplayNames'] as Map?)?.cast<String, String>() ??
        const {},
    nouns: [
      for (final n in (json['nouns'] as List?) ?? const [])
        GermanNoun.fromJson(Map<String, dynamic>.from(n as Map)),
    ],
  );
}
