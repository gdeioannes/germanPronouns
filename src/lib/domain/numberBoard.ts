// The number board: the practice task on the first quiz's task menu
// (quiz/NumberTasks), played instead of the typed drill.
//
// Three stages, easiest first, so a first-time learner wins from the first
// tap and never meets the keyboard until the very end:
//
//   hear  — a number is spoken, tap it on the board; it pops off when right.
//           Every number once, so the board empties as the stage goes on.
//   read  — the word is written, tap its number.
//   write — the number and its word are shown and spoken: type the word.
//           Copying, not recalling — spelling from memory comes later.
//
// A miss never costs progress: the item simply stays until it is got right
// (the board stages) or is shown and moves on (the write stage).

import type { FillBlankQuiz } from '$lib/content/types';

export interface BoardNumber {
	/** What the board button shows: "7". */
	digit: string;
	/** The German word: "sieben". */
	word: string;
}

export type BoardStage = 'hear' | 'read' | 'write';

export const BOARD_STAGES: BoardStage[] = ['hear', 'read', 'write'];

/** How many items the read stage asks; hear asks every number once. */
export const READ_COUNT = 6;

/**
 * The words the write stage asks for, easiest first: short, spelt the way
 * they sound, and close to English. Missing ones fall back to the shortest.
 */
export const WRITE_WORDS = ['acht', 'drei', 'null'];

/** The board's numbers, from the quiz's subjects and its first category. */
export function boardNumbers(quiz: FillBlankQuiz): BoardNumber[] {
	const values = quiz.categories?.[0]?.values ?? [];
	return (quiz.subjects ?? []).flatMap((subject, i) =>
		values[i] ? [{ digit: subject.display, word: values[i] }] : []
	);
}

function shuffled<T>(items: readonly T[], random: () => number): T[] {
	const out = [...items];
	for (let i = out.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}

/** The items each stage asks, in order. */
export function stagePlan(
	numbers: readonly BoardNumber[],
	random: () => number = Math.random
): Record<BoardStage, BoardNumber[]> {
	const preferred = WRITE_WORDS.flatMap((w) => numbers.filter((n) => n.word === w));
	const rest = [...numbers]
		.filter((n) => !preferred.includes(n))
		.sort((a, b) => a.word.length - b.word.length);
	return {
		hear: shuffled(numbers, random),
		read: shuffled(numbers, random).slice(0, READ_COUNT),
		write: [...preferred, ...rest].slice(0, WRITE_WORDS.length)
	};
}

/** Every item across the three stages — the length of the progress bar. */
export function planLength(plan: Record<BoardStage, BoardNumber[]>): number {
	return BOARD_STAGES.reduce((sum, stage) => sum + plan[stage].length, 0);
}
