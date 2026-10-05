// "Order the round": friends shout a number over the music, the learner shows
// it to the bartender on two hands — counted the German way, from the thumb
// (thumb = 1, thumb + index = 2 … a whole hand = 5, then the second hand).

import type { CallLine } from './callTask';

export interface BarRound {
	answer: number;
	clip: CallLine;
}

export interface BartenderLine extends CallLine {
	count: number;
}

export interface BarTaskContent {
	id: string;
	title: string;
	intro: string;
	culture: string;
	rounds: BarRound[];
	/** "Zwei Bier? Kommt sofort!" for every count 1–10. */
	bartender: BartenderLine[];
	/** Jokes for an order that is short or over; `{n}` is what arrived. */
	tooFew: string[];
	tooMany: string[];
	ending: CallLine;
}

/** Thumb, index, middle, ring, little — the order a German counts in. */
export const FINGERS = ['thumb', 'index finger', 'middle finger', 'ring finger', 'little finger'] as const;

/** Which fingers are up on each hand for `count` (0–10). */
export function handsFor(count: number): [boolean[], boolean[]] {
	const first = Math.max(0, Math.min(5, count));
	const second = Math.max(0, Math.min(5, count - 5));
	return [FINGERS.map((_, i) => i < first), FINGERS.map((_, i) => i < second)];
}

/**
 * A tap on a finger: shows the count that finger stands for (the second
 * hand's thumb is 6). Tapping the top raised finger again folds it.
 */
export function countAfterTap(current: number, hand: 0 | 1, finger: number): number {
	const target = hand * 5 + finger + 1;
	return target === current ? current - 1 : target;
}

/** The joke for a wrong order, with the delivered count spliced in. */
export function wrongOrderLine(content: BarTaskContent, delivered: number, wanted: number, pick: number): string {
	const pool = delivered < wanted ? content.tooFew : content.tooMany;
	return pool[pick % pool.length].replace('{n}', String(delivered));
}
