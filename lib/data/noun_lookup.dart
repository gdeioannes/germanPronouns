import 'german_grammar.dart';
import 'noun_database.dart';

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
  // Plurals & inflected forms from the Pronouns & Articles quiz sentences
  'Tauben': 'Taube',
  'Pinguine': 'Pinguin',
  'Pinguinen': 'Pinguin',
  'Zwillinge': 'Zwilling',
  'Touristen': 'Tourist',
  'Mitarbeitern': 'Mitarbeiter',
  'Spielern': 'Spieler',
  'Tablets': 'Tablet',
  'Brieffreunde': 'Brieffreund',
  'Brieffreunden': 'Brieffreund',
  'Witze': 'Witz',
  'Profis': 'Profi',
  'Katzen': 'Katze',
  'Keksen': 'Keks',
  'Regeln': 'Regel',
  'Hausaufgaben': 'Hausaufgabe',
  'Ohren': 'Ohr',
  'Stunden': 'Stunde',
  'Pausen': 'Pause',
  'Namen': 'Name',
  'Gästen': 'Gast',
  'Schülern': 'Schüler',
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
    article: baseArticles[dictionaryNoun.gender] ?? 'das',
  );
}
