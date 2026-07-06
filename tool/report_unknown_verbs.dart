// Reports lowercase word tokens from a language's course bundles that the
// verb index does NOT recognize — the worklist for extending the shared verb
// lists so every verb a learner meets in a sentence is tappable:
//
//   dart run tool/report_unknown_verbs.dart de
//
// Tokens are frequency-sorted; the output still contains adjectives/adverbs
// and other-language contamination (prompts), so it's a human worklist, not
// an automated gate.
import 'dart:convert';
import 'dart:io';

import 'package:german_pronouns_articles/data/verb_lookup.dart';

/// The course bundles whose sentences teach each language.
const Map<String, List<String>> bundlesByLang = {
  'de': ['en_de', 'de_cert_a1', 'es_de', 'es_de_emotions'],
  'es': ['de_es'],
  'cs': ['de_cs'],
  'en': ['zh_en'],
};

/// High-frequency function words (articles, pronouns, prepositions,
/// conjunctions) of the app's languages — never verbs, pure noise here.
const Set<String> stop = {
  // German
  'der', 'die', 'das', 'den', 'dem', 'des', 'ein', 'eine', 'einen', 'einem',
  'einer', 'eines', 'und', 'oder', 'aber', 'nicht', 'kein', 'keine', 'keinen',
  'ich', 'du', 'er', 'sie', 'es', 'wir', 'ihr', 'mich', 'dich', 'sich', 'uns',
  'euch', 'mir', 'dir', 'ihm', 'ihnen', 'mein', 'dein', 'sein', 'unser',
  'euer', 'meine', 'deine', 'seine', 'ihre', 'unsere', 'eure', 'meinen',
  'deinen', 'seinen', 'ihren', 'meinem', 'deinem', 'seinem', 'ihrem',
  'meiner', 'deiner', 'seiner', 'ihrer', 'auf', 'aus', 'bei', 'mit', 'nach',
  'seit', 'von', 'zu', 'zum', 'zur', 'für', 'gegen', 'ohne', 'durch', 'über',
  'unter', 'vor', 'hinter', 'neben', 'zwischen', 'als', 'wenn', 'weil',
  'dass', 'ob', 'wie', 'wo', 'was', 'wer', 'wen', 'wem', 'warum', 'auch',
  'noch', 'schon', 'nur', 'sehr', 'hier', 'dort', 'heute', 'morgen',
  'gestern', 'jetzt', 'dann', 'denn', 'doch', 'mal', 'man', 'am', 'im', 'ins',
  'beim', 'vom', 'ans', 'aufs',
  // English
  'the', 'and', 'you', 'your', 'his', 'her', 'its', 'our', 'their', 'this',
  'that', 'these', 'those', 'with', 'for', 'from', 'into', 'onto', 'about',
  'not', 'but', 'when', 'where', 'why', 'how', 'who', 'whom', 'which',
  'all', 'any', 'some', 'one', 'two', 'three', 'they', 'them', 'him', 'she',
  'out', 'off', 'too', 'very', 'here', 'there', 'now', 'then', 'than',
  'because', 'while', 'after', 'before', 'over', 'under', 'again',
  // Spanish
  'los', 'las', 'una', 'unos', 'unas', 'del', 'con', 'sin', 'por', 'para',
  'que', 'qué', 'como', 'cómo', 'cuando', 'cuándo', 'donde', 'dónde',
  'pero', 'porque', 'muy', 'más', 'menos', 'también', 'hoy', 'ayer',
  'mañana', 'ahora', 'aquí', 'allí', 'ella', 'ellos', 'ellas', 'usted',
  'nosotros', 'vosotros', 'este', 'esta', 'ese', 'esa', 'sus', 'les',
  // Czech
  'ten', 'ta', 'to', 'na', 'do', 'od', 'po', 'pro', 'při', 'bez',
  'ale', 'nebo', 'když', 'protože', 'jak', 'kde', 'kdo', 'co', 'proč',
};

final RegExp _word = RegExp(r'\p{L}+', unicode: true);

void main(List<String> args) {
  final lang = args.isEmpty ? 'de' : args.first;
  final bundles = bundlesByLang[lang];
  if (bundles == null) {
    stderr.writeln('No bundles configured for "$lang".');
    exit(1);
  }

  final counts = <String, int>{};
  void walk(Object? node) {
    if (node is String) {
      // Sentences only — single-token strings are ids/enum metadata, not text.
      if (!node.contains(' ')) return;
      for (final m in _word.allMatches(node)) {
        final t = m.group(0)!;
        if (t.length < 3) continue;
        if (t.toLowerCase() != t) continue; // mid-sentence verbs are lowercase
        if (stop.contains(t)) continue;
        if (lookupVerb(t, lang: lang) != null) continue;
        counts[t] = (counts[t] ?? 0) + 1;
      }
    } else if (node is List) {
      node.forEach(walk);
    } else if (node is Map) {
      node.values.forEach(walk);
    }
  }

  for (final id in bundles) {
    walk(jsonDecode(File('assets/content/courses/$id.json').readAsStringSync()));
  }
  if (lang == 'de') {
    walk(
      jsonDecode(
        File('assets/content/shared/nouns/de.json').readAsStringSync(),
      ),
    );
  }

  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  for (final e in sorted) {
    stdout.writeln('${e.value}\t${e.key}');
  }
  stderr.writeln('${sorted.length} distinct unknown lowercase tokens ($lang)');
}
