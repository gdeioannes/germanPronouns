// The medal ladder for the fill-in drills: three ways of answering the same
// sentences, each with its own medal (see domain/progress.ts).
//
//   * Choose  (bronze) — the answer is one of four: the authored three wrong
//     options beside it. A word-tile item offers only the tiles its answer
//     needs; the order is still the learner's to find.
//   * Type    (silver) — the drill as it always was: typed, with the cue in
//     brackets and the hint line.
//   * No help (gold)   — typed with the trailing cue gone (unless it carries
//     something the English line doesn't: `keepCue`), no hint, no first
//     letter, and drawn from the drill's hard sentences. A tile item is
//     typed too. The English line stays: without it many gaps would have
//     more than one right answer.

import type { QuizSentence } from '$lib/content/types';
import { gapCount, normalizeAnswer } from './answers';
import { seededShuffle } from './lesson';

export type FillStep = 0 | 1 | 2;

/** Hard sentences the gold step needs before it draws on them alone. */
export const MIN_HARD_POOL = 10;

/** The sentence's trailing "(…)" cue, with the space before it. */
const TRAILING_CUE = /\s*\([^()]*\)\s*$/;

/** The sentence as the gold step shows it: the trailing cue dropped, unless it must stay. */
export function goldSentence(item: QuizSentence): string {
	if (item.keepCue) return item.sentence;
	const bare = item.sentence.replace(TRAILING_CUE, '');
	// A cue that was the whole sentence after the gap would leave nothing to read.
	return bare.trim() ? bare : item.sentence;
}

/**
 * The sentences a step draws on. Gold takes the hard ones once there are
 * enough of them for a run; until then (and for the other steps) the pool.
 */
export function stepPool(pool: readonly QuizSentence[], step: FillStep): readonly QuizSentence[] {
	if (step !== 2) return pool;
	const hard = pool.filter((s) => s.hard);
	return hard.length >= MIN_HARD_POOL ? hard : pool;
}

/** The answer a choice stands for: the first key, the way it is written. */
export function choiceAnswer(item: QuizSentence): string {
	return item.acceptedAnswers[0] ?? '';
}

/**
 * The four choices for the "choose" step, in a seeded order (the same on
 * the prerendered page and after hydration). The authored wrong options
 * when there are three; otherwise other answers from the same drill —
 * the same category first, which for a closed set (der/die/das, the
 * pronouns) is exactly the right confusion — never one that is also right.
 */
export function choicesFor(item: QuizSentence, pool: readonly QuizSentence[]): string[] {
	const answer = choiceAnswer(item);
	const right = new Set(item.acceptedAnswers.map((a) => normalizeAnswer(a, false)));
	const parts = Math.max(1, gapCount(item.sentence));
	const usable = (option: string) =>
		!!option.trim() &&
		!right.has(normalizeAnswer(option, false)) &&
		(parts === 1 ? !option.includes('…') : option.split('…').length === parts);

	let wrong = (item.options ?? []).filter(usable);
	if (wrong.length < 3) {
		const seen = new Set([...right, ...wrong.map((w) => normalizeAnswer(w, false))]);
		const fromPool = (same: boolean) =>
			pool
				.filter((s) => s !== item && (s.categoryLabel === item.categoryLabel) === same)
				.map(choiceAnswer);
		for (const option of seededShuffle([...fromPool(true)], item.sentence).concat(
			seededShuffle([...fromPool(false)], item.sentence)
		)) {
			const key = normalizeAnswer(option, false);
			if (wrong.length >= 3) break;
			if (!usable(option) || seen.has(key)) continue;
			seen.add(key);
			wrong = [...wrong, option];
		}
	}
	return seededShuffle([answer, ...wrong.slice(0, 3)], `${item.sentence}|choices`);
}
