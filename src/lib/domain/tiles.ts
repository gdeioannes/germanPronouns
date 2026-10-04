// Word-tile items: a fill-in sentence whose gap is built by tapping tiles into
// order rather than typed — the story's ordering puzzle, brought to the drills.
// Typing "Morgen ____ ich nach Berlin. (fahren)" only tests the verb form; the
// learner never decides where the verb goes. Tiles make the order the answer.
//
// The built text is checked like any typed answer (matchesGaps against
// acceptedAnswers), so several correct orders are simply several keys.

import type { QuizSentence } from '$lib/content/types';
import { normalizeAnswer } from './answers';
import { seededShuffle } from './lesson';

/** One tile on offer. The id keeps two identical words ("die … die") apart. */
export interface Tile {
	id: number;
	text: string;
}

/** The text a run of tiles spells: the words with single spaces between. */
export function joinTiles(texts: readonly string[]): string {
	return texts.join(' ').replace(/\s+([,.!?;:])/g, '$1');
}

/**
 * The tiles in the order they are offered. Seeded by the sentence, so the
 * prerendered page and the hydrated one agree; and never with an answer
 * readable left to right — not even with a distractor between its words —
 * which would hand it over.
 */
export function tileBank(item: QuizSentence): Tile[] {
	const tiles = (item.tiles ?? []).map((text, id) => ({ id, text }));
	const seed = `${item.sentence}|${item.english ?? ''}`;
	const givesAway = (bank: Tile[]) =>
		item.acceptedAnswers.some((a) => buildableFromTiles(a, bank.map((t) => t.text), true));
	for (let attempt = 0; attempt < 24; attempt++) {
		const bank = seededShuffle(tiles, `${seed}#${attempt}`);
		if (!givesAway(bank)) return bank;
	}
	// Only a two-tile item can run out of honest orders; reversed is the best left.
	return [...tiles].reverse();
}

/**
 * Whether `answer` can be laid from `tiles`, each tile used at most once —
 * what the content gate holds every key of a tile item to. With `inOrder`,
 * only tiles left to right may be taken (skipping some is fine).
 */
export function buildableFromTiles(answer: string, tiles: readonly string[], inOrder = false): boolean {
	const norm = (s: string) => normalizeAnswer(s, true);
	const words = tiles.map(norm);
	const used = new Array(words.length).fill(false);
	const lay = (rest: string, from: number): boolean => {
		if (!rest) return true;
		for (let i = inOrder ? from : 0; i < words.length; i++) {
			const word = words[i];
			if (used[i] || !word || !rest.startsWith(word)) continue;
			if (rest.length > word.length && rest[word.length] !== ' ') continue;
			used[i] = true;
			if (lay(rest.slice(word.length).trimStart(), i + 1)) return true;
			used[i] = false;
		}
		return false;
	};
	return lay(norm(answer), 0);
}
