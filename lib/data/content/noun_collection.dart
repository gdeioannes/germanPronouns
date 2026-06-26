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
    this.progressionOrder = const [],
    this.allNounsLabel,
  });

  /// Bilingual display label per category key (e.g. `kitchen` → `Kitchen (Küche)`).
  final Map<String, String> categoryDisplayNames;

  final List<GermanNoun> nouns;

  /// The noun-category progression in chain order (easiest first): one entry per
  /// category key, the same order the learner unlocks them in. The "All Nouns"
  /// capstone ([allNounsLabel]) is implied as the final step after these. The
  /// serialized twin of the difficulty-sorted order computed in
  /// `noun_progression_data.dart`.
  final List<String> progressionOrder;

  /// Display name of the "All Nouns" final-challenge capstone that closes the
  /// progression (e.g. "All Nouns — Final Challenge").
  final String? allNounsLabel;

  bool get isEmpty => nouns.isEmpty;

  Map<String, dynamic> toJson() => {
    'categoryDisplayNames': categoryDisplayNames,
    if (progressionOrder.isNotEmpty) 'progressionOrder': progressionOrder,
    if (allNounsLabel != null) 'allNounsLabel': allNounsLabel,
    'nouns': [for (final n in nouns) n.toJson()],
  };

  factory NounCollection.fromJson(Map<String, dynamic> json) => NounCollection(
    categoryDisplayNames:
        (json['categoryDisplayNames'] as Map?)?.cast<String, String>() ??
        const {},
    progressionOrder:
        (json['progressionOrder'] as List?)?.cast<String>() ?? const [],
    allNounsLabel: json['allNounsLabel'] as String?,
    nouns: [
      for (final n in (json['nouns'] as List?) ?? const [])
        GermanNoun.fromJson(Map<String, dynamic>.from(n as Map)),
    ],
  );
}
