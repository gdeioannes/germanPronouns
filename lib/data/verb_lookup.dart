import 'content/verb_collection.dart';
import 'shared_verbs/verbs_cs.dart';
import 'shared_verbs/verbs_de.dart';
import 'shared_verbs/verbs_en.dart';
import 'shared_verbs/verbs_es.dart';
import 'shared_verbs/verbs_zh.dart';

/// Maps verb surface forms (as they appear in sentences — "ist", "ging",
/// "gemacht", "pregunto", …) back to their dictionary verb, per learned
/// language, so quiz text can make verbs tappable the same way nouns are.
/// The index is derived from the conjugation tables themselves, so it can
/// never drift from the shared verb lists.
final Map<String, VerbCollection> _collectionsByLang = {
  'de': germanVerbCollection,
  'es': spanishVerbCollection,
  'cs': czechVerbCollection,
  'en': englishVerbCollection,
  'zh': mandarinVerbCollection,
};

final Map<String, Map<String, VerbEntry>> _indexByLang = {};

/// Conjugated forms are lowercase words; this keeps person tokens like the
/// formal "Sie" (from "gehen Sie") out of the index. Unicode letters, so
/// accented Spanish/Czech forms index whole.
final RegExp _lowercaseWord = RegExp(r'^\p{Ll}+$', unicode: true);

/// Function words that appear inside compound/reflexive forms ("stehe früh
/// auf", "freue mich") but must never resolve to a verb themselves — plus
/// verb forms that collide with far more common function words ("meine
/// Mutter" is possessive, not the verb meinen).
const Set<String> _neverVerbs = {
  // German separable prefixes / prepositions / pronouns / possessives.
  'ab', 'an', 'auf', 'aus', 'bei', 'ein', 'mit', 'nach', 'vor', 'zu', 'um',
  'weg', 'zurück', 'los', 'fern', 'statt', 'teil',
  'mich', 'dich', 'sich', 'uns', 'euch', 'mir', 'dir', 'nicht',
  'meine', 'meinen',
  // Spanish clitics/negation, English particles, Czech reflexives.
  'me', 'te', 'se', 'nos', 'os', 'no', 'not', 'si',
};

/// Sentence forms that no conjugation table carries but that should still
/// resolve (passive "worden", the strong Konjunktiv II forms B-level texts
/// use), keyed by language then surface form → dictionary verb.
const Map<String, Map<String, String>> _extraSurfaceForms = {
  'de': {
    'worden': 'werden',
    'gäbe': 'geben',
    'käme': 'kommen',
    'ginge': 'gehen',
    'ließe': 'lassen',
    'bräuchte': 'brauchen',
    // Konjunktiv I (indirect speech, B2 module).
    'könne': 'können',
    'müsse': 'müssen',
    'wolle': 'wollen',
    'dürfe': 'dürfen',
    'möge': 'mögen',
    'wisse': 'wissen',
  },
  // The perfective twin (koupit) and the colloquial -uju forms the de_cs
  // course uses resolve to the imperfective dictionary entry.
  'cs': {
    'koupit': 'kupovat',
    'koupím': 'kupovat',
    'koupíš': 'kupovat',
    'koupí': 'kupovat',
    'koupíme': 'kupovat',
    'koupíte': 'kupovat',
    'koupil': 'kupovat',
    'koupila': 'kupovat',
    'kupuju': 'kupovat',
    'kupujou': 'kupovat',
  },
};

Map<String, VerbEntry> _buildIndex(String lang, VerbCollection collection) {
  final index = <String, VerbEntry>{};
  void add(String token, VerbEntry verb) {
    if (_neverVerbs.contains(token)) return;
    if (_lowercaseWord.hasMatch(token)) index.putIfAbsent(token, () => verb);
  }

  // Pass 1 — dictionary forms and one-word conjugated forms (Präsens,
  // Präteritum, Konjunktiv II, bare imperatives): each token unambiguously
  // belongs to its own verb.
  for (final verb in collection.verbs) {
    add(verb.verb, verb);
    for (final set in verb.sets) {
      for (final form in set.forms) {
        if (!form.form.contains(' ')) add(form.form, verb);
      }
    }
  }

  // Pass 2 — tokens of compound forms (Perfekt "bin gewesen", Futur I "werde
  // gehen", "gehen Sie"). The auxiliaries were claimed by sein/haben/werden in
  // pass 1, so putIfAbsent only picks up what's new: the participles.
  for (final verb in collection.verbs) {
    for (final set in verb.sets) {
      for (final form in set.forms) {
        for (final token in form.form.split(' ')) {
          add(token, verb);
        }
      }
    }
  }

  // Extra surface forms outside any table (passive "worden", gäbe/käme, …).
  for (final entry in (_extraSurfaceForms[lang] ?? const {}).entries) {
    final target = index[entry.value];
    if (target != null) index.putIfAbsent(entry.key, () => target);
  }
  return index;
}

/// Looks up [word] against the [lang] (learned-language code, e.g. `de`)
/// verb index, tolerating the capitalization of a sentence-start word
/// ("Ist" → sein). Returns null if [word] isn't a known verb form.
VerbEntry? lookupVerb(String word, {String lang = 'de'}) {
  final collection = _collectionsByLang[lang];
  if (collection == null) return null;
  final index = _indexByLang.putIfAbsent(
    lang,
    () => _buildIndex(lang, collection),
  );
  return index[word] ?? index[word.toLowerCase()];
}
