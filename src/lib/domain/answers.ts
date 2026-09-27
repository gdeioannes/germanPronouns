// Answer checking, ported from lib/utils/answer_normalization.dart and
// lib/utils/speech_match.dart. Pure and dependency-free.

const EXPANSIONS: Record<string, string> = {
	ß: 'ss',
	æ: 'ae',
	Æ: 'ae',
	œ: 'oe',
	Œ: 'oe'
};

const DIACRITICS: Record<string, string> = {
	á: 'a', à: 'a', â: 'a', ä: 'a', ã: 'a', å: 'a',
	Á: 'A', À: 'A', Â: 'A', Ä: 'A', Ã: 'A', Å: 'A',
	é: 'e', è: 'e', ê: 'e', ë: 'e',
	É: 'E', È: 'E', Ê: 'E', Ë: 'E',
	í: 'i', ì: 'i', î: 'i', ï: 'i',
	Í: 'I', Ì: 'I', Î: 'I', Ï: 'I',
	ó: 'o', ò: 'o', ô: 'o', ö: 'o', õ: 'o', ø: 'o',
	Ó: 'O', Ò: 'O', Ô: 'O', Ö: 'O', Õ: 'O', Ø: 'O',
	ú: 'u', ù: 'u', û: 'u', ü: 'u',
	Ú: 'U', Ù: 'U', Û: 'U', Ü: 'U',
	ñ: 'n', Ñ: 'N',
	ç: 'c', Ç: 'C',
	ý: 'y', ÿ: 'y', Ý: 'Y'
};

/**
 * Folds German umlauts, ß and Latin accents to their plain ASCII base
 * (ä→a, ß→ss, é→e, ñ→n …). Unmapped characters pass through.
 */
export function stripDiacritics(input: string): string {
	let out = '';
	for (const char of input) {
		const expansion = EXPANSIONS[char];
		out += expansion ?? DIACRITICS[char] ?? char;
	}
	return out;
}

/**
 * Everything relaxed mode ignores: punctuation and the typographic marks a
 * learner has no easy way to type — the full stop and comma the eye skips,
 * apostrophes and quotes their keyboard may smarten, dashes, brackets. What
 * survives is letters, digits and the spaces between words, because those are
 * what the exercise is actually testing.
 */
const RELAXED_IGNORED = /[^\p{L}\p{N}\s]/gu;

/**
 * Normalizes an answer for comparison: trimmed and lower-cased, and in
 * `relaxed` mode also diacritic-folded (ä→a, ß→ss, é→e) with punctuation
 * dropped and runs of whitespace collapsed — so a missing umlaut, a missing
 * full stop or a straight apostrophe is not what fails an otherwise correct
 * answer. The correct spelling is still written back into the field, so the
 * learner sees what they missed.
 */
export function normalizeAnswer(answer: string, relaxed: boolean): string {
	const base = answer.trim().toLowerCase();
	if (!relaxed) return base;
	return stripDiacritics(base).replace(RELAXED_IGNORED, '').replace(/\s+/g, ' ').trim();
}

/** Whether `answer` matches any of `accepted`, under the current strictness. */
export function isAcceptedAnswer(
	answer: string,
	accepted: readonly string[],
	relaxed: boolean
): boolean {
	const normalized = normalizeAnswer(answer, relaxed);
	if (!normalized) return false;
	return accepted.some((a) => normalizeAnswer(a, relaxed) === normalized);
}

// ---------------------------------------------------------------------------
// Umlaut-strict quizzes
// ---------------------------------------------------------------------------

/**
 * Relaxed mode folds ä→a and ß→ss so a missing umlaut never fails an answer
 * that is otherwise right. In a quiz whose whole point IS the umlaut — hätte
 * vs hatte, könnte vs konnte, größer, Äpfel — that leniency lets the exact
 * error the drill exists to catch pass unnoticed. Such quizzes are flagged
 * `strictDiacritics` in the bundle, and for them relaxed mode keeps its
 * punctuation and spacing tolerance but not the folding.
 */
export function normalizeAnswerKeepingDiacritics(answer: string, relaxed: boolean): string {
	const base = answer.trim().toLowerCase();
	if (!relaxed) return base;
	return base.replace(RELAXED_IGNORED, '').replace(/\s+/g, ' ').trim();
}

/**
 * The general check, with the quiz's own say on umlauts: a strict quiz never
 * folds them, whatever the learner's setting.
 */
export function matchesAccepted(
	answer: string,
	accepted: readonly string[],
	relaxed: boolean,
	strictDiacritics = false
): boolean {
	if (!strictDiacritics) return isAcceptedAnswer(answer, accepted, relaxed);
	const normalized = normalizeAnswerKeepingDiacritics(answer, relaxed);
	if (!normalized) return false;
	return accepted.some((a) => normalizeAnswerKeepingDiacritics(a, relaxed) === normalized);
}

// ---------------------------------------------------------------------------
// Multi-gap sentences
// ---------------------------------------------------------------------------

/** The blank marker in a fill-in sentence: four or more underscores. */
export const BLANK = /_{4,}/g;

/** The separator between the parts of a multi-gap answer key: "je … desto". */
const GAP_SEPARATOR = /\s*…\s*/;

/** How many gaps a sentence has. */
export function gapCount(sentence: string): number {
	return (sentence.match(BLANK) ?? []).length;
}

/**
 * Splits an accepted answer into one part per gap. A key with the wrong
 * number of parts for the sentence is unusable and yields null, so a stray
 * single-string key on a two-gap sentence can neither be matched nor shown.
 */
export function splitGapAnswer(key: string, gaps: number): string[] | null {
	if (gaps <= 1) return [key];
	const parts = key.split(GAP_SEPARATOR).map((p) => p.trim());
	return parts.length === gaps && parts.every(Boolean) ? parts : null;
}

/**
 * Whether the parts a learner typed into each gap match some accepted key,
 * gap for gap. A single-gap sentence reduces to the ordinary check.
 */
export function matchesGaps(
	typed: readonly string[],
	accepted: readonly string[],
	relaxed: boolean,
	strictDiacritics = false
): boolean {
	const gaps = typed.length;
	return accepted.some((key) => {
		const parts = splitGapAnswer(key, gaps);
		if (!parts) return false;
		return parts.every((part, i) => matchesAccepted(typed[i] ?? '', [part], relaxed, strictDiacritics));
	});
}

/**
 * The key whose parts the typed answer matched, split for writing back into
 * the gaps; or the first usable key when nothing matched.
 */
export function canonicalGapAnswer(
	typed: readonly string[],
	accepted: readonly string[],
	relaxed: boolean,
	strictDiacritics = false
): string[] {
	const gaps = typed.length;
	const usable = accepted
		.map((key) => splitGapAnswer(key, gaps))
		.filter((parts): parts is string[] => parts !== null);
	const matched = usable.find((parts) =>
		parts.every((part, i) => matchesAccepted(typed[i] ?? '', [part], relaxed, strictDiacritics))
	);
	return matched ?? usable[0] ?? new Array(gaps).fill('');
}

// ---------------------------------------------------------------------------
// Spoken answers
// ---------------------------------------------------------------------------

const LETTER_OR_DIGIT = /[\p{L}\p{N}]/u;

/**
 * Normalizes a transcript for comparison: lowercases, maps umlauts and ß to
 * their digraphs (ä→ae, ß→ss), and reduces everything non-alphanumeric to
 * single spaces. Recognizers differ on ß vs ss and on trailing punctuation.
 */
export function normalizeForSpeech(input: string): string {
	let out = '';
	for (const char of input.toLowerCase()) {
		switch (char) {
			case 'ä': out += 'ae'; break;
			case 'ö': out += 'oe'; break;
			case 'ü': out += 'ue'; break;
			case 'ß': out += 'ss'; break;
			default:
				out += LETTER_OR_DIGIT.test(char) ? char : ' ';
		}
	}
	return out.trim().replace(/\s+/g, ' ');
}

/** Levenshtein edit distance between two already-normalized strings. */
export function levenshtein(a: string, b: string): number {
	if (a === b) return 0;
	if (!a.length) return b.length;
	if (!b.length) return a.length;

	let previous = Array.from({ length: b.length + 1 }, (_, i) => i);
	let current = new Array<number>(b.length + 1).fill(0);
	for (let i = 0; i < a.length; i++) {
		current[0] = i + 1;
		for (let j = 0; j < b.length; j++) {
			const cost = a[i] === b[j] ? 0 : 1;
			current[j + 1] = Math.min(
				current[j] + 1,
				previous[j + 1] + 1,
				previous[j] + cost
			);
		}
		[previous, current] = [current, previous];
	}
	return previous[b.length];
}

/** Similarity in [0,1], 1 being identical. */
export function similarity(a: string, b: string): number {
	const maxLen = Math.max(a.length, b.length);
	if (maxLen === 0) return 1;
	return 1 - levenshtein(a, b) / maxLen;
}

/**
 * Whether a transcript should count as a correct spoken rendering. Forgiving
 * by design — recognition is accent-sensitive, so an exact match would reject
 * far too many genuinely correct attempts.
 */
export function matchesSpoken(heard: string, target: string, threshold = 0.8): boolean {
	const h = normalizeForSpeech(heard);
	const t = normalizeForSpeech(target);
	if (!t) return false;
	if (h === t) return true;
	if (h && (h.includes(t) || t.includes(h))) return true;
	return similarity(h, t) >= threshold;
}
