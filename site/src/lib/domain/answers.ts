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

const RELAXED_PUNCTUATION = /[?!¿¡]/g;

/**
 * Normalizes an answer for comparison: trimmed and lower-cased, and in
 * `relaxed` mode also diacritic-folded with ?/!/¿/¡ dropped — so a learner
 * whose keyboard can't reach umlauts isn't marked wrong for it.
 */
export function normalizeAnswer(answer: string, relaxed: boolean): string {
	const base = answer.trim().toLowerCase();
	if (!relaxed) return base;
	return stripDiacritics(base).replace(RELAXED_PUNCTUATION, '').trim();
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

/**
 * Whether an answer would have been accepted only thanks to relaxed mode —
 * i.e. it is wrong strictly, right relaxed. Drives the one-time hint offering
 * to turn relaxed correction on.
 */
export function acceptedViaRelaxedOnly(
	answer: string,
	accepted: readonly string[]
): boolean {
	return !isAcceptedAnswer(answer, accepted, false) &&
		isAcceptedAnswer(answer, accepted, true);
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
