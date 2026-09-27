// The swipe deck: the stack of exercise cards the course home deals out.
//
// Each card is one exercise with a one-line reason. Swiping right opens it,
// swiping left drops it; the deck is rebuilt from what the learner has done and
// the level they say they are at. It draws from four pools:
//
//   practise / next / mix — the recommender's three kinds (see recommend.ts)
//   fresh                 — untouched exercises around the learner's level, so
//                           a brand-new learner (or one who has only picked a
//                           level) still gets a full deck
//
// The pools are interleaved so consecutive cards feel different from each
// other, and the "fresh" pool is shuffled inside each sub-level so the deck is
// not just the ladder in order with a nicer coat.

import type { QuizSummary as Quiz, QuizType } from '$lib/content/types';
import { recommend, type QuizFacts, type RecommendationKind } from './recommend';

export type DeckKind = RecommendationKind | 'fresh';

export const DECK_KIND_LABELS: Record<DeckKind, string> = {
	practise: 'Practise',
	next: 'Learn next',
	mix: 'Mix it up',
	fresh: 'Something new'
};

export interface DeckCard {
	kind: DeckKind;
	quiz: Quiz;
	reason: string;
}

export interface DeckOptions {
	/** The sub-level the learner says they are at, e.g. "A2.1"; null = unknown. */
	level?: string | null;
	/** Cards the learner has swiped away; never dealt again until forgotten. */
	skipped?: Set<string>;
	/** Ids never to deal at all. */
	exclude?: Set<string>;
	/** How many cards to deal. */
	size?: number;
	random?: () => number;
}

const DEFAULT_SIZE = 12;

const TYPE_LABELS: Record<QuizType, string> = {
	fillBlank: 'grammar drill',
	reading: 'reading',
	listening: 'listening',
	dictation: 'dictation',
	speakRepeat: 'repeat aloud',
	speaking: 'speaking',
	vocabulary: 'flashcards'
};

/** The learner-facing name of a quiz type, for the card's meta line. */
export function typeLabel(type: QuizType): string {
	return TYPE_LABELS[type];
}

/** The distinct sub-levels of a course, in ladder order. */
export function courseLevels(quizzes: Quiz[]): string[] {
	return [...new Set(quizzes.map((quiz) => quiz.level ?? '').filter(Boolean))];
}

/**
 * The sub-level the deck centres on: whichever is further along — the level
 * the learner picked, or the furthest sub-level with anything finished.
 */
export function deckLevel(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	picked: string | null | undefined
): string | null {
	const levels = courseLevels(quizzes);
	if (levels.length === 0) return null;
	let index = picked ? levels.indexOf(picked) : -1;
	for (const quiz of quizzes) {
		if (facts[quiz.id]?.done) index = Math.max(index, levels.indexOf(quiz.level ?? ''));
	}
	return levels[Math.max(0, index)];
}

export function buildDeck(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	options: DeckOptions = {}
): DeckCard[] {
	const skipped = options.skipped ?? new Set<string>();
	const exclude = options.exclude ?? new Set<string>();
	const size = options.size ?? DEFAULT_SIZE;
	const random = options.random ?? Math.random;

	const recs = recommend(quizzes, facts, exclude, { floorLevel: options.level });
	const levels = courseLevels(quizzes);
	const centre = deckLevel(quizzes, facts, options.level);
	const centreIndex = centre ? levels.indexOf(centre) : 0;

	const pools: DeckCard[][] = [
		recs.practise,
		recs.next,
		recs.mix,
		fresh(quizzes, facts, exclude, levels, centreIndex, random)
	];

	// Round-robin over the pools, starting from a random one so the first card
	// is not always a "practise" — a learner with a bad run behind them should
	// still open the app to something inviting now and then.
	const deck: DeckCard[] = [];
	const seen = new Set<string>();
	const cursors = pools.map(() => 0);
	let pool = Math.floor(random() * pools.length);
	let idle = 0;
	while (deck.length < size && idle < pools.length) {
		const list = pools[pool];
		let dealt = false;
		while (cursors[pool] < list.length) {
			const card = list[cursors[pool]++];
			if (seen.has(card.quiz.id) || skipped.has(card.quiz.id)) continue;
			seen.add(card.quiz.id);
			deck.push(card);
			dealt = true;
			break;
		}
		idle = dealt ? 0 : idle + 1;
		pool = (pool + 1) % pools.length;
	}
	return deck;
}

/**
 * Untouched exercises near the learner's level: the centre sub-level first,
 * then one step up, then one step back, each shuffled. Reading order inside a
 * sub-level is deliberately not kept — the ladder view has that.
 */
function fresh(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	exclude: Set<string>,
	levels: string[],
	centreIndex: number,
	random: () => number
): DeckCard[] {
	const untouched = (quiz: Quiz) => {
		const f = facts[quiz.id];
		return !exclude.has(quiz.id) && quiz.status !== 'placeholder' && !(f?.done || (f?.answered ?? 0) > 0);
	};
	const window = [centreIndex, centreIndex + 1, centreIndex - 1].filter(
		(i) => i >= 0 && i < levels.length
	);
	const cards: DeckCard[] = [];
	for (const index of window) {
		const level = levels[index];
		const atLevel = quizzes.filter((quiz) => quiz.level === level);
		const doneHere = atLevel.filter((quiz) => facts[quiz.id]?.done).length;
		const open = shuffle(atLevel.filter(untouched), random);
		for (const quiz of open) {
			cards.push({ kind: 'fresh', quiz, reason: freshReason(level, index - centreIndex, doneHere, atLevel.length) });
		}
	}
	return cards;
}

function freshReason(level: string, offset: number, done: number, total: number): string {
	if (offset > 0) return `A peek at ${level}, one step up from where you are.`;
	if (offset < 0) return `Back at ${level} — a quick one to keep it warm.`;
	if (done === 0) return `Your first ${level} exercise — a taste of the level.`;
	return `New at ${level}, where you have ${done} of ${total} done.`;
}

function shuffle<T>(items: T[], random: () => number): T[] {
	const out = [...items];
	for (let i = out.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}
