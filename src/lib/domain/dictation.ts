// Grading a dictation line.
//
// The old check was all-or-nothing: one missing umlaut, one comma, one typo
// and the whole line was simply "Not quite" — which tells a learner who heard
// nine words out of ten almost nothing. This grades the line word by word and
// reports how close it came:
//
//   * perfect — the line as written (punctuation and umlauts per the
//     learner's strictness setting), 100%;
//   * close   — 80% or better, where what is off is spelling rather than
//     hearing: a dropped umlaut in an umlaut-strict quiz, a typo, a word
//     out. Still counts as a right answer;
//   * partial — half the words or better. The line was heard but not
//     written: a miss for the streak, with the slips named;
//   * off     — below half.
//
// Words are aligned, not compared position for position, so one word left out
// does not throw every word after it off.

import { matchesAccepted, similarity, stripDiacritics } from './answers';

/** How a graded line came out. */
export type DictationBand = 'perfect' | 'close' | 'partial' | 'off';

/**
 * One word of the target line with what was written in its place: `hit`
 * right, `slip` nearly (an umlaut or a typo), `wrong` a different word,
 * `miss` nothing at all. An `extra` mark is a word the learner added that the
 * line does not have — its `target` is empty.
 */
export interface WordMark {
	target: string;
	typed: string;
	state: 'hit' | 'slip' | 'wrong' | 'miss' | 'extra';
}

export interface DictationGrade {
	band: DictationBand;
	/** Words placed right, 0–100. */
	score: number;
	/** The target line's words in order, then any extras. */
	marks: WordMark[];
	/** Perfect or close: counts as a right answer for the run and the streak. */
	right: boolean;
}

/** The bar for `close`, in percent. */
export const CLOSE_MARK = 80;
/** The bar for `partial`, in percent. */
export const PARTIAL_MARK = 50;

/** Credit a slip earns against a whole word. */
const SLIP_CREDIT = 0.5;
/** What each invented word costs. */
const EXTRA_COST = 0.5;
/** The edit similarity at which two words are the same word, badly typed. */
const TYPO_SIMILARITY = 0.7;

/** Splits a line into the words being tested, punctuation dropped. */
export function dictationWords(line: string): string[] {
	return line
		.split(/\s+/)
		.map((w) => w.replace(/[^\p{L}\p{N}'’-]/gu, ''))
		.filter(Boolean);
}

/** The comparable core of a word — punctuation is already gone. */
const core = (word: string) => word.toLowerCase();

/**
 * How well one word stands in for another: 1 the same word, SLIP_CREDIT
 * nearly it (an umlaut folded away, or a typo), 0 a different word.
 *
 * `foldable` is true where the learner's setting forgives umlauts — then
 * "schon" for "schön" is simply right, exactly as the whole-line check has
 * always treated it. In an umlaut-strict quiz it is a slip, because the
 * umlaut is the thing that drill exists to catch.
 */
function wordCredit(target: string, typed: string, foldable: boolean): number {
	const a = core(target);
	const b = core(typed);
	if (a === b) return 1;
	if (stripDiacritics(a) === stripDiacritics(b)) return foldable ? 1 : SLIP_CREDIT;
	return similarity(a, b) >= TYPO_SIMILARITY ? SLIP_CREDIT : 0;
}

type Step = 'pair' | 'miss' | 'extra';

/**
 * Aligns the typed words against the target's, Needleman–Wunsch style: a
 * pairing costs what the two words differ by, a gap on either side costs a
 * whole word. So a line with one word left out still scores every other word
 * in it.
 */
function align(target: string[], typed: string[], foldable: boolean): Step[] {
	const n = target.length;
	const m = typed.length;
	/** cost[i][j]: the cheapest alignment of target[i..] with typed[j..]. */
	const cost: number[][] = Array.from({ length: n + 1 }, () => new Array<number>(m + 1).fill(0));
	const from: Step[][] = Array.from({ length: n + 1 }, () => new Array<Step>(m + 1).fill('pair'));
	for (let i = n - 1; i >= 0; i--) {
		cost[i][m] = cost[i + 1][m] + 1;
		from[i][m] = 'miss';
	}
	for (let j = m - 1; j >= 0; j--) {
		cost[n][j] = cost[n][j + 1] + 1;
		from[n][j] = 'extra';
	}
	for (let i = n - 1; i >= 0; i--) {
		for (let j = m - 1; j >= 0; j--) {
			const pair = cost[i + 1][j + 1] + (1 - wordCredit(target[i], typed[j], foldable));
			const miss = cost[i + 1][j] + 1;
			const extra = cost[i][j + 1] + 1;
			const best = Math.min(pair, miss, extra);
			cost[i][j] = best;
			from[i][j] = best === pair ? 'pair' : best === miss ? 'miss' : 'extra';
		}
	}

	const steps: Step[] = [];
	let i = 0;
	let j = 0;
	while (i < n || j < m) {
		const step = from[i][j];
		steps.push(step);
		if (step === 'pair') {
			i++;
			j++;
		} else if (step === 'miss') i++;
		else j++;
	}
	return steps;
}

/**
 * Grades a typed line against the one that was read out.
 *
 * `relaxed` is the learner's forgiving-correction setting (punctuation, and
 * umlauts unless the quiz is umlaut-strict); `strictDiacritics` is the quiz's
 * own insistence on the umlauts.
 */
export function gradeDictation(
	typedLine: string,
	target: string,
	relaxed: boolean,
	strictDiacritics = false
): DictationGrade {
	const targetWords = dictationWords(target);
	const typedWords = dictationWords(typedLine);

	// A perfect answer is still decided by the very check every other quiz
	// kind uses, so the two can never disagree about what "right" means.
	if (matchesAccepted(typedLine, [target], relaxed, strictDiacritics)) {
		return {
			band: 'perfect',
			score: 100,
			marks: targetWords.map((w) => ({ target: w, typed: w, state: 'hit' as const })),
			right: true
		};
	}

	if (targetWords.length === 0) return { band: 'off', score: 0, marks: [], right: false };

	const foldable = relaxed && !strictDiacritics;
	const marks: WordMark[] = [];
	const extras: WordMark[] = [];
	let credit = 0;
	let i = 0;
	let j = 0;
	for (const step of align(targetWords, typedWords, foldable)) {
		if (step === 'pair') {
			const earned = wordCredit(targetWords[i], typedWords[j], foldable);
			credit += earned;
			marks.push({
				target: targetWords[i],
				typed: typedWords[j],
				state: earned === 1 ? 'hit' : earned > 0 ? 'slip' : 'wrong'
			});
			i++;
			j++;
		} else if (step === 'miss') {
			marks.push({ target: targetWords[i], typed: '', state: 'miss' });
			i++;
		} else {
			extras.push({ target: '', typed: typedWords[j], state: 'extra' });
			credit -= EXTRA_COST;
			j++;
		}
	}

	// Capped at 99: every word can be in place and the line still not be the
	// line (capitals, punctuation the strict setting wants), and only an exact
	// match is allowed to read 100.
	const score = Math.min(99, Math.max(0, Math.round((credit / targetWords.length) * 100)));
	const band: DictationBand =
		score >= CLOSE_MARK ? 'close' : score >= PARTIAL_MARK ? 'partial' : 'off';

	return { band, score, marks: [...marks, ...extras], right: band === 'close' };
}

/** What each band is called on screen. */
export const BAND_LABELS: Record<DictationBand, string> = {
	perfect: 'Word for word',
	close: 'Nearly — a slip or two',
	partial: 'Half of it',
	off: 'Not this one'
};

/** A line on what to make of the result. */
export function bandNote(band: DictationBand): string {
	switch (band) {
		case 'perfect':
			return 'Every word, exactly as read.';
		case 'close':
			return 'Counts as right — the marks show the spelling to fix.';
		case 'partial':
			return 'You caught the shape of it. The words in red are the ones to listen for.';
		case 'off':
			return 'Play it once more, slower, before you move on.';
	}
}
