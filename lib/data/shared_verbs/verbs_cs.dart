import '../content/verb_collection.dart';

/// The shared Czech verb list — the ~16 most common verbs with the five
/// conjugation tables a learner needs first: přítomný čas, minulý čas
/// (masculine forms), budoucí čas, kondicionál and zápor (negated present).
/// Past, future, conditional and negation are derived from the present forms
/// and the l-participle; irregulars (být, jít, jet) pass overrides.
/// Meanings: German (the `de_cs` course's main language) + English fallback.
/// Published to `assets/content/shared/verbs/cs.json`.
const List<String> _p = ['já', 'ty', 'on/ona', 'my', 'vy', 'oni'];

List<ConjugationForm> _zip(List<String> forms) => [
  for (var i = 0; i < _p.length; i++)
    ConjugationForm(person: _p[i], form: forms[i]),
];

VerbEntry _v(
  String infinitive,
  String english,
  String de, {
  required List<String> pritomny,
  required String participle, // masculine sg l-participle, e.g. 'byl'
  String? participleFeminine, // feminine sg, defaults to participle + 'a'
  String? participlePlural, // masculine pl, defaults to participle + 'i'
  List<String>? budouci, // overrides 'budu <infinitive>' (být, jít, jet)
  List<String>? zapor, // overrides 'ne' + present (být: není)
}) {
  final fem = participleFeminine ?? '${participle}a';
  final pl = participlePlural ?? '${participle}i';
  // Feminine plural: mohli → mohly, šli → šly.
  final plFem = '${pl.substring(0, pl.length - 1)}y';
  return VerbEntry(
    verb: infinitive,
    english: english,
    meanings: {'de': de},
    sets: [
      ConjugationSet(label: 'Přítomný čas', forms: _zip(pritomny)),
      ConjugationSet(
        // Both genders, the way Czech textbooks show the past: byl / byla jsem.
        label: 'Minulý čas',
        forms: _zip([
          '$participle / $fem jsem',
          '$participle / $fem jsi',
          '$participle / $fem',
          '$pl / $plFem jsme',
          '$pl / $plFem jste',
          '$pl / $plFem',
        ]),
      ),
      ConjugationSet(
        label: 'Budoucí čas',
        forms: _zip(
          budouci ??
              [
                'budu $infinitive',
                'budeš $infinitive',
                'bude $infinitive',
                'budeme $infinitive',
                'budete $infinitive',
                'budou $infinitive',
              ],
        ),
      ),
      ConjugationSet(
        label: 'Kondicionál',
        forms: _zip([
          '$participle bych',
          '$participle bys',
          '$participle by',
          '$pl bychom',
          '$pl byste',
          '$pl by',
        ]),
      ),
      ConjugationSet(
        label: 'Zápor (přítomný)',
        forms: _zip(zapor ?? [for (final f in pritomny) 'ne$f']),
      ),
    ],
  );
}

final VerbCollection czechVerbCollection = VerbCollection(
  verbs: [
    _v('být', 'to be', 'sein',
        pritomny: ['jsem', 'jsi', 'je', 'jsme', 'jste', 'jsou'],
        participle: 'byl',
        budouci: ['budu', 'budeš', 'bude', 'budeme', 'budete', 'budou'],
        zapor: ['nejsem', 'nejsi', 'není', 'nejsme', 'nejste', 'nejsou']),
    _v('mít', 'to have', 'haben',
        pritomny: ['mám', 'máš', 'má', 'máme', 'máte', 'mají'],
        participle: 'měl'),
    _v('dělat', 'to do, to make', 'machen / tun',
        pritomny: ['dělám', 'děláš', 'dělá', 'děláme', 'děláte', 'dělají'],
        participle: 'dělal'),
    _v('jít', 'to go (on foot)', 'gehen (zu Fuß)',
        pritomny: ['jdu', 'jdeš', 'jde', 'jdeme', 'jdete', 'jdou'],
        participle: 'šel', participleFeminine: 'šla', participlePlural: 'šli',
        budouci: ['půjdu', 'půjdeš', 'půjde', 'půjdeme', 'půjdete', 'půjdou']),
    _v('jet', 'to go (by vehicle)', 'fahren',
        pritomny: ['jedu', 'jedeš', 'jede', 'jedeme', 'jedete', 'jedou'],
        participle: 'jel',
        budouci: ['pojedu', 'pojedeš', 'pojede', 'pojedeme', 'pojedete', 'pojedou']),
    _v('vidět', 'to see', 'sehen',
        pritomny: ['vidím', 'vidíš', 'vidí', 'vidíme', 'vidíte', 'vidí'],
        participle: 'viděl'),
    _v('vědět', 'to know (a fact)', 'wissen',
        pritomny: ['vím', 'víš', 'ví', 'víme', 'víte', 'vědí'],
        participle: 'věděl'),
    _v('chtít', 'to want', 'wollen',
        pritomny: ['chci', 'chceš', 'chce', 'chceme', 'chcete', 'chtějí'],
        participle: 'chtěl'),
    _v('moct', 'can, to be able to', 'können',
        pritomny: ['můžu', 'můžeš', 'může', 'můžeme', 'můžete', 'můžou'],
        participle: 'mohl'),
    _v('muset', 'must, to have to', 'müssen',
        pritomny: ['musím', 'musíš', 'musí', 'musíme', 'musíte', 'musí'],
        participle: 'musel'),
    _v('mluvit', 'to speak', 'sprechen',
        pritomny: ['mluvím', 'mluvíš', 'mluví', 'mluvíme', 'mluvíte', 'mluví'],
        participle: 'mluvil'),
    _v('rozumět', 'to understand', 'verstehen',
        pritomny: ['rozumím', 'rozumíš', 'rozumí', 'rozumíme', 'rozumíte', 'rozumějí'],
        participle: 'rozuměl'),
    _v('jíst', 'to eat', 'essen',
        pritomny: ['jím', 'jíš', 'jí', 'jíme', 'jíte', 'jedí'],
        participle: 'jedl'),
    _v('pít', 'to drink', 'trinken',
        pritomny: ['piji', 'piješ', 'pije', 'pijeme', 'pijete', 'pijí'],
        participle: 'pil'),
    _v('spát', 'to sleep', 'schlafen',
        pritomny: ['spím', 'spíš', 'spí', 'spíme', 'spíte', 'spí'],
        participle: 'spal'),
    _v('kupovat', 'to buy', 'kaufen',
        pritomny: ['kupuji', 'kupuješ', 'kupuje', 'kupujeme', 'kupujete', 'kupují'],
        participle: 'kupoval'),
    _v('číst', 'to read', 'lesen',
        pritomny: ['čtu', 'čteš', 'čte', 'čteme', 'čtete', 'čtou'],
        participle: 'četl'),
    _v('jmenovat', 'to name; jmenovat se = to be called',
        'nennen; jmenovat se = heißen',
        pritomny: ['jmenuji', 'jmenuješ', 'jmenuje', 'jmenujeme', 'jmenujete', 'jmenují'],
        participle: 'jmenoval'),
  ],
);
