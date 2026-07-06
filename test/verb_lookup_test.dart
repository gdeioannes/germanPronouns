import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/shared_verbs/verbs_de.dart';
import 'package:german_pronouns_articles/data/verb_lookup.dart';

/// The verb surface-form index that makes verbs tappable in quiz text: every
/// conjugated form resolves to its dictionary verb, auxiliaries stay owned by
/// sein/haben/werden (not by the verbs whose compound tenses mention them),
/// and non-verbs stay untouched.
void main() {
  test('dictionary forms and one-word conjugated forms resolve', () {
    expect(lookupVerb('sein')?.verb, 'sein');
    expect(lookupVerb('ist')?.verb, 'sein');
    expect(lookupVerb('war')?.verb, 'sein');
    expect(lookupVerb('ging')?.verb, 'gehen');
    expect(lookupVerb('möchte')?.verb, 'mögen');
    expect(lookupVerb('iss')?.verb, 'essen');
  });

  test('participles from compound tenses resolve to their own verb', () {
    expect(lookupVerb('gewesen')?.verb, 'sein');
    expect(lookupVerb('gemacht')?.verb, 'machen');
    expect(lookupVerb('gegessen')?.verb, 'essen');
  });

  test('auxiliaries belong to sein/haben/werden, not to compound-tense users',
      () {
    expect(lookupVerb('wird')?.verb, 'werden');
    expect(lookupVerb('werde')?.verb, 'werden');
    expect(lookupVerb('habe')?.verb, 'haben');
    expect(lookupVerb('bin')?.verb, 'sein');
  });

  test('sentence-start capitalization is tolerated', () {
    expect(lookupVerb('Ist')?.verb, 'sein');
    expect(lookupVerb('Gehe')?.verb, 'gehen');
  });

  test('non-verbs (including the person token "Sie") return null', () {
    expect(lookupVerb('Hund'), isNull);
    expect(lookupVerb('Sie'), isNull);
    expect(lookupVerb('und'), isNull);
  });

  test('the quiz-sentence verbs that started this all resolve', () {
    // "Ich fotografiere den Elefanten." / "Ich frage den Nachbarn."
    expect(lookupVerb('fotografiere')?.verb, 'fotografieren');
    expect(lookupVerb('frage')?.verb, 'fragen');
    expect(lookupVerb('fragt')?.verb, 'fragen');
  });

  test('Konjunktiv II and passive forms resolve to their verbs', () {
    expect(lookupVerb('wäre')?.verb, 'sein');
    expect(lookupVerb('hätte')?.verb, 'haben');
    expect(lookupVerb('würde')?.verb, 'werden');
    expect(lookupVerb('worden')?.verb, 'werden');
    expect(lookupVerb('gäbe')?.verb, 'geben');
    expect(lookupVerb('möchte')?.verb, 'mögen');
  });

  test('separable-verb tokens resolve; the base verb owns the shared stem',
      () {
    expect(lookupVerb('aufgestanden')?.verb, 'aufstehen');
    expect(lookupVerb('aufstehen')?.verb, 'aufstehen');
    // "stehe" alone belongs to stehen — the base verb wins the shared form.
    expect(lookupVerb('stehe')?.verb, 'stehen');
    expect(lookupVerb('angerufen')?.verb, 'anrufen');
    expect(lookupVerb('lädt')?.verb, 'einladen');
    // Separable prefixes themselves never resolve.
    expect(lookupVerb('auf'), isNull);
    expect(lookupVerb('ein'), isNull);
  });

  test('possessive lookalikes are excluded ("meine Mutter")', () {
    expect(lookupVerb('meine'), isNull);
    expect(lookupVerb('meinen'), isNull);
    expect(lookupVerb('meint')?.verb, 'meinen');
  });

  test('the lookup is per learned language', () {
    expect(lookupVerb('pregunto', lang: 'es')?.verb, 'preguntar');
    expect(lookupVerb('sea', lang: 'es')?.verb, 'ser');
    expect(lookupVerb('gustaría', lang: 'es')?.verb, 'gustar');
    // German forms don't leak into the Spanish index and vice versa.
    expect(lookupVerb('fragte', lang: 'es'), isNull);
    expect(lookupVerb('pregunto', lang: 'de'), isNull);
    // Czech: feminine participles and the perfective/colloquial aliases.
    expect(lookupVerb('jela', lang: 'cs')?.verb, 'jet');
    expect(lookupVerb('šla', lang: 'cs')?.verb, 'jít');
    expect(lookupVerb('koupím', lang: 'cs')?.verb, 'kupovat');
    expect(lookupVerb('čtu', lang: 'cs')?.verb, 'číst');
    // English: irregulars and modals.
    expect(lookupVerb('bought', lang: 'en')?.verb, 'buy');
    expect(lookupVerb('could', lang: 'en')?.verb, 'can');
    expect(lookupVerb('understood', lang: 'en')?.verb, 'understand');
    // Unknown language: never crashes, never matches.
    expect(lookupVerb('ist', lang: 'zz'), isNull);
  });

  test('every verb in the shared list is reachable by its infinitive', () {
    for (final v in germanVerbCollection.verbs) {
      // "meinen" is deliberately blocked: as a sentence token it's almost
      // always the possessive, so only meint/meinte/gemeint resolve.
      if (v.verb == 'meinen') continue;
      expect(lookupVerb(v.verb)?.verb, v.verb, reason: v.verb);
    }
  });
}
