/// Text normalization for quiz answer checking.
///
/// "Relaxed correction" (see [NounSettings.relaxedCorrection]) lets a learner
/// whose keyboard can't easily type German umlauts or Spanish/Latin accents
/// answer without being marked wrong for a missing mark. Both the learner's
/// answer and every acceptable answer are run through [stripDiacritics] before
/// comparison, so a correctly-accented answer still passes too.
library;

/// Single accented Latin letters mapped to their plain base letter. Covers the
/// German umlauts and the accents used across the app's languages (Spanish,
/// plus common French/Portuguese marks), in both lower and upper case. Letters
/// that expand to two characters (ß, æ, œ) are handled separately below.
const Map<String, String> _diacriticMap = {
  // a
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
  'Á': 'A', 'À': 'A', 'Â': 'A', 'Ä': 'A', 'Ã': 'A', 'Å': 'A',
  // e
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
  // i
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
  // o
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o',
  'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Ö': 'O', 'Õ': 'O', 'Ø': 'O',
  // u
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
  // other consonants
  'ñ': 'n', 'Ñ': 'N',
  'ç': 'c', 'Ç': 'C',
  'ý': 'y', 'ÿ': 'y', 'Ý': 'Y',
};

/// Multi-character expansions, applied before the single-letter map.
const Map<String, String> _diacriticExpansions = {
  'ß': 'ss',
  'æ': 'ae', 'Æ': 'ae',
  'œ': 'oe', 'Œ': 'oe',
};

/// Returns [input] with German umlauts, the "ß" and Spanish/Latin accents
/// folded to their plain ASCII base (ä→a, ö→o, ü→u, ß→ss, á/é/í/ó/ú→a/e/i/o/u,
/// ñ→n, ç→c, …). Characters without a mapping are left unchanged.
String stripDiacritics(String input) {
  final buffer = StringBuffer();
  for (final char in input.split('')) {
    final expansion = _diacriticExpansions[char];
    if (expansion != null) {
      buffer.write(expansion);
      continue;
    }
    buffer.write(_diacriticMap[char] ?? char);
  }
  return buffer.toString();
}

/// Question/exclamation marks dropped in relaxed mode, including the Spanish
/// opening "¿"/"¡", so a missing or extra "?"/"!" doesn't count against the
/// learner.
final RegExp _relaxedPunctuation = RegExp(r'[?!¿¡]');

/// Normalizes a quiz answer for comparison: trimmed and lower-cased, and — when
/// [relaxed] is true — with diacritics stripped via [stripDiacritics] and "?"/
/// "!" (and the Spanish "¿"/"¡") removed.
String normalizeAnswer(String answer, {required bool relaxed}) {
  final base = answer.trim().toLowerCase();
  if (!relaxed) return base;
  return stripDiacritics(base).replaceAll(_relaxedPunctuation, '').trim();
}
