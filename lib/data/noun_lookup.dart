import 'noun_database.dart';

const Map<String, String> _baseArticles = {'m': 'der', 'f': 'die', 'n': 'das'};

/// Maps an inflected surface form (as it appears in sentences, e.g. a
/// genitive "-es" or a plural) to the dictionary noun in [germanNouns] it
/// belongs to. Only forms that differ from the dictionary form need an
/// entry here.
const Map<String, String> nounSurfaceForms = {
  // Genitive singular (-s/-es)
  'Arztes': 'Arzt',
  'Lehrers': 'Lehrer',
  'Bruders': 'Bruder',
  'Freundes': 'Freund',
  'Hundes': 'Hund',
  'Mannes': 'Mann',
  'Chefs': 'Chef',
  'Vaters': 'Vater',
  'Kindes': 'Kind',
  'Tieres': 'Tier',
  'Babys': 'Baby',
  'Autos': 'Auto',
  'Hauses': 'Haus',
  'Haustiers': 'Haustier',
  // Plurals
  'Kinder': 'Kind',
  'Freunde': 'Freund',
  'Bücher': 'Buch',
  'Töchter': 'Tochter',
  'Nachbarn': 'Nachbar',
  'Kollegen': 'Kollege',
};

final Map<String, GermanNoun> _nounsByName = {
  for (final n in germanNouns) n.noun: n,
};

/// A noun recognized in some piece of text, together with the definite
/// article for its dictionary form (e.g. "der Hund").
class NounInfo {
  const NounInfo({required this.noun, required this.article});

  final GermanNoun noun;
  final String article;
}

/// Looks up [word] against the noun database, either directly (dictionary
/// form) or via [nounSurfaceForms] (inflected forms). Returns null if [word]
/// doesn't match a known noun.
NounInfo? lookupNoun(String word) {
  final dictionaryNoun = _nounsByName[word] ?? _nounsByName[nounSurfaceForms[word]];
  if (dictionaryNoun == null) return null;
  return NounInfo(
    noun: dictionaryNoun,
    article: _baseArticles[dictionaryNoun.gender] ?? 'das',
  );
}
