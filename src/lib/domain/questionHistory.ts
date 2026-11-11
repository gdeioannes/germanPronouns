// How a learner has done on one particular question, so the card can show it
// as a row of dots before they answer again. Per quiz, a record keyed by a
// hash of the question's text — sentences have no id of their own — holding
// the last few verdicts, oldest first.
//
// Counts alone would do for "3 of 4 right", but the trend is the useful part
// when practising ("I keep missing this one"), so the sequence is kept — and
// capped, so a drill played every day for a year stays a few bytes a question.

/** How many verdicts a question remembers. Also how many dots the card shows. */
export const QUESTION_HISTORY_LIMIT = 6;

/** One past answer: whether it was right, and when. */
export interface Verdict {
	c: boolean;
	at: number;
}

export type QuestionHistory = Record<string, Verdict[]>;

/**
 * A short, stable key for a question: a hash of its text. Two drills sharing a
 * sentence keep separate rows, since the record is per quiz already.
 */
export function questionKey(text: string): string {
	// FNV-1a, 32-bit: fast, no dependencies, and collisions among a drill's
	// few hundred sentences are vanishingly unlikely.
	let hash = 0x811c9dc5;
	for (let i = 0; i < text.length; i++) {
		hash ^= text.charCodeAt(i);
		hash = Math.imul(hash, 0x01000193) >>> 0;
	}
	return hash.toString(36);
}

export function parseQuestionHistory(raw: unknown): QuestionHistory {
	if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return {};
	const out: QuestionHistory = {};
	for (const [key, value] of Object.entries(raw as Record<string, unknown>)) {
		if (!Array.isArray(value)) continue;
		const verdicts = value
			.filter((v): v is Verdict => !!v && typeof v === 'object' && typeof (v as Verdict).c === 'boolean')
			.map((v) => ({ c: v.c, at: Number(v.at) || 0 }));
		if (verdicts.length) out[key] = verdicts.slice(-QUESTION_HISTORY_LIMIT);
	}
	return out;
}

/** The record with one more verdict on `key`, trimmed to the limit. */
export function withVerdict(
	history: QuestionHistory,
	key: string,
	correct: boolean,
	at = Date.now()
): QuestionHistory {
	const next = [...(history[key] ?? []), { c: correct, at }].slice(-QUESTION_HISTORY_LIMIT);
	return { ...history, [key]: next };
}

/**
 * Two devices' records into one. Per question the verdicts are merged by
 * time, the same timestamp counting once (the push that saved it and the
 * pull that read it back), then the latest few kept.
 */
export function mergeQuestionHistory(a: QuestionHistory, b: QuestionHistory): QuestionHistory {
	const out: QuestionHistory = {};
	for (const key of new Set([...Object.keys(a), ...Object.keys(b)])) {
		const byTime = new Map<number, Verdict>();
		for (const v of [...(a[key] ?? []), ...(b[key] ?? [])]) byTime.set(v.at, v);
		out[key] = [...byTime.values()].sort((x, y) => x.at - y.at).slice(-QUESTION_HISTORY_LIMIT);
	}
	return out;
}
