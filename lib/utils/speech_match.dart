/// Forgiving comparison of a spoken transcript against a target phrase, used by
/// the "listen & repeat" pronunciation quizzes (`SpeakRepeatQuizPage`).
///
/// Speech recognition is imperfect and accent-sensitive, so an exact string
/// match would reject far too many genuinely-correct attempts. Instead both
/// strings are normalized (case, punctuation, German umlauts/ß) and then
/// compared with some tolerance.
library;

/// Normalizes [input] for comparison: lowercases, maps German umlauts and ß to
/// their ASCII digraphs (ä→ae, ö→oe, ü→ue, ß→ss), drops punctuation, and
/// collapses runs of whitespace. Recognizers vary in whether they return "ß"
/// or "ss" and whether they add trailing punctuation, so this folds those
/// differences away.
String normalizeForSpeech(String input) {
  final lowered = input.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lowered.runes) {
    final ch = String.fromCharCode(rune);
    switch (ch) {
      case 'ä':
        buffer.write('ae');
      case 'ö':
        buffer.write('oe');
      case 'ü':
        buffer.write('ue');
      case 'ß':
        buffer.write('ss');
      default:
        // Keep letters and digits (any script); turn everything else (spaces,
        // punctuation) into a single space, collapsed below.
        if (RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(ch)) {
          buffer.write(ch);
        } else {
          buffer.write(' ');
        }
    }
  }
  return buffer.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
}

/// Levenshtein edit distance between [a] and [b] (already normalized).
int levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var previous = List<int>.generate(b.length + 1, (i) => i);
  var current = List<int>.filled(b.length + 1, 0);
  for (var i = 0; i < a.length; i++) {
    current[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
      current[j + 1] = [
        current[j] + 1, // insertion
        previous[j + 1] + 1, // deletion
        previous[j] + cost, // substitution
      ].reduce((m, e) => e < m ? e : m);
    }
    final swap = previous;
    previous = current;
    current = swap;
  }
  return previous[b.length];
}

/// Similarity of [a] and [b] in [0, 1] (1 = identical), derived from the
/// Levenshtein distance relative to the longer string.
double similarity(String a, String b) {
  if (a.isEmpty && b.isEmpty) return 1;
  final maxLen = a.length > b.length ? a.length : b.length;
  if (maxLen == 0) return 1;
  return 1 - levenshtein(a, b) / maxLen;
}

/// Whether [heard] should be accepted as a correct spoken rendering of
/// [target]. Forgiving by design: accepts on a normalized exact match, when one
/// string contains the other (recognizers often add or drop leading words), or
/// when the overall [similarity] clears [threshold] (default 0.8) to tolerate
/// minor mis-hearings.
bool matchesSpoken(String heard, String target, {double threshold = 0.8}) {
  final h = normalizeForSpeech(heard);
  final t = normalizeForSpeech(target);
  if (t.isEmpty) return false;
  if (h == t) return true;
  if (h.isNotEmpty && (h.contains(t) || t.contains(h))) return true;
  return similarity(h, t) >= threshold;
}
