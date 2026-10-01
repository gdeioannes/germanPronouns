// The swipe deck: the stack of exercise cards the course home deals out.
//
// Each card is one exercise with a one-line reason. Swiping right opens it,
// swiping left drops it; the deck is rebuilt from what the learner has done and
// the level they say they are at.
//
// The mix follows three findings from the learning literature:
//
//   * The "85% rule" (Wilson, Shenhav, Straccia & Cohen, Nat. Commun. 2019):
//     learning is fastest when the learner is getting roughly 85% right, so
//     about one card in four should be something they are still shaky on —
//     not more, or the deck feels like punishment; not less, or nothing sticks.
//     That is the REPAIR quota: weak, unfinished and review-due exercises.
//   * Spaced review (Leitner / Duolingo's half-life regression): a finished
//     exercise comes back after an interval that grows with how well it is
//     held — see review.ts. Overdue ones jump the queue.
//   * Interleaving (Rohrer): old and new, and different exercise types, are
//     shuffled together rather than blocked, and the deck never opens on the
//     same kind twice in a row.
//
// The rest is new material: mostly the learner's own sub-level, a taste of the
// one above, a little of the one below — plus "learn next" / "build on a
// strength" picks that connect to what is already done.
//
// Sameness is fought in two ways. Within a pool, cards are drawn by a
// rank-weighted lottery rather than taking the top of the list, so a good
// candidate that lost the toss today shows up tomorrow. And a pool that is
// short hands its unused slots to the others, so the deck is always full.

import type { QuizSummary as Quiz, QuizType } from '$lib/content/types';
import { recommend, type QuizFacts, type RecommendationKind } from './recommend';
import { reviewDue, strengths } from './review';

export type DeckKind = RecommendationKind | 'review' | 'fresh';

export const DECK_KIND_LABELS: Record<DeckKind, string> = {
	practise: 'Practise',
	review: 'Review',
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
	/** How the learner wants to move; shapes the mix. Defaults to "steady". */
	pace?: DeckPace;
	/** How many cards to deal. */
	size?: number;
	/** Epoch ms "now", for the review schedule; defaults to Date.now(). */
	now?: number;
	random?: () => number;
}

const DEFAULT_SIZE = 12;

/**
 * How the learner wants to move through the course. Each pace is a different
 * mix of the same three groups plus a different spread of levels for the new
 * material:
 *
 *   * quota — share of the deck each group gets. Steady's repair quarter sits
 *     inside the 20–30% band that keeps the learner around 85% accuracy;
 *     the others trade some of it for speed, breadth or consolidation.
 *     Explore is the "learn next" / "strength" / "mix" picks.
 *   * levels — how the fresh slots are shared out, by distance from the
 *     learner's sub-level (0 = their own, 1 = one up, -1 = one back).
 */
export type DeckPace = 'steady' | 'fast' | 'adventurous' | 'review';

export interface PaceSpec {
	label: string;
	/** One line under the label in the chooser. */
	blurb: string;
	quota: { repair: number; fresh: number; explore: number };
	levels: { offset: number; weight: number }[];
}

export const DECK_PACES: Record<DeckPace, PaceSpec> = {
	steady: {
		label: 'Slow & steady',
		blurb: 'Your own level, with regular review.',
		quota: { repair: 0.25, fresh: 0.5, explore: 0.25 },
		levels: [
			{ offset: 0, weight: 0.6 },
			{ offset: 1, weight: 0.25 },
			{ offset: -1, weight: 0.15 }
		]
	},
	fast: {
		label: 'Fast learner',
		blurb: 'Mostly new, pushing a level ahead.',
		quota: { repair: 0.15, fresh: 0.6, explore: 0.25 },
		levels: [
			{ offset: 0, weight: 0.45 },
			{ offset: 1, weight: 0.4 },
			{ offset: 2, weight: 0.15 }
		]
	},
	adventurous: {
		label: 'Adventurous',
		blurb: 'A wide spread, two levels either way.',
		quota: { repair: 0.1, fresh: 0.7, explore: 0.2 },
		levels: [
			{ offset: 0, weight: 0.3 },
			{ offset: 1, weight: 0.25 },
			{ offset: 2, weight: 0.15 },
			{ offset: -1, weight: 0.2 },
			{ offset: -2, weight: 0.1 }
		]
	},
	review: {
		label: 'Polish up',
		blurb: 'Weak spots and due reviews first.',
		quota: { repair: 0.6, fresh: 0.2, explore: 0.2 },
		levels: [
			{ offset: 0, weight: 0.6 },
			{ offset: -1, weight: 0.4 }
		]
	}
};

export const DECK_PACE_ORDER: DeckPace[] = ['steady', 'fast', 'adventurous', 'review'];

export function isDeckPace(value: unknown): value is DeckPace {
	return typeof value === 'string' && value in DECK_PACES;
}

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
	const now = options.now ?? Date.now();
	const pace = DECK_PACES[options.pace ?? 'steady'];

	const levels = courseLevels(quizzes);
	const centre = deckLevel(quizzes, facts, options.level);
	const centreIndex = centre ? levels.indexOf(centre) : 0;
	const open = (quiz: Quiz) =>
		!exclude.has(quiz.id) && !skipped.has(quiz.id) && quiz.status !== 'placeholder';
	const reach = Math.max(1, ...pace.levels.map((l) => l.offset));
	const inReach = (quiz: Quiz) => levels.indexOf(quiz.level ?? '') <= centreIndex + reach;

	const recs = recommend(quizzes, facts, exclude, { floorLevel: options.level });

	// ---- the three groups, each ranked best-first ------------------------
	const repair = dedupe([
		...recs.practise.filter((r) => open(r.quiz)),
		...reviewDue(quizzes, facts, open, now).map(
			(pick): DeckCard => ({ kind: 'review', quiz: pick.quiz, reason: pick.reason })
		)
	]);
	const explore = dedupe([
		...recs.next.filter((r) => open(r.quiz)),
		...strengths(quizzes, facts, open, inReach).map(
			(pick): DeckCard => ({ kind: 'next', quiz: pick.quiz, reason: pick.reason })
		),
		...recs.mix.filter((r) => open(r.quiz))
	]);
	const freshPool = fresh(quizzes, facts, open, levels, centreIndex, pace.levels, random);

	// ---- quotas, with spill-over ------------------------------------------
	const want = {
		repair: Math.round(size * pace.quota.repair),
		explore: Math.round(size * pace.quota.explore),
		fresh: 0
	};
	want.fresh = size - want.repair - want.explore;

	const seen = new Set<string>();
	const draw = (pool: DeckCard[], n: number) => lottery(pool, n, seen, random);
	// The narrow pools draw first so the wide fresh pool cannot eat their
	// candidates (a "learn next" quiz is also an untouched one).
	const repairPicked = draw(repair, want.repair);
	const explorePicked = draw(explore, want.explore);
	const picked = {
		repair: repairPicked,
		explore: explorePicked,
		fresh: draw(freshPool, want.fresh)
	};
	// Whatever is left over goes to the pools that still have candidates,
	// fresh first (it is the widest), then repair, then explore.
	let short = size - picked.repair.length - picked.fresh.length - picked.explore.length;
	for (const key of ['fresh', 'repair', 'explore'] as const) {
		if (short <= 0) break;
		const pool = key === 'fresh' ? freshPool : key === 'repair' ? repair : explore;
		const extra = draw(pool, short);
		picked[key].push(...extra);
		short -= extra.length;
	}

	return interleave([picked.repair, picked.fresh, picked.explore], random);
}

/** Keeps the first card for each quiz id, in order. */
function dedupe(cards: DeckCard[]): DeckCard[] {
	const ids = new Set<string>();
	return cards.filter((card) => !ids.has(card.quiz.id) && ids.add(card.quiz.id));
}

/**
 * Draws `n` cards from a best-first list without replacement. Each draw is
 * weighted by rank — the top card is about twice as likely as the fourth and
 * four times as likely as the tenth — so the ranking still matters but the
 * deck is not the same list every day.
 */
function lottery(pool: DeckCard[], n: number, seen: Set<string>, random: () => number): DeckCard[] {
	const candidates = pool.filter((card) => !seen.has(card.quiz.id));
	const out: DeckCard[] = [];
	while (out.length < n && candidates.length > 0) {
		const weights = candidates.map((_, rank) => 1 / (1 + rank / 3));
		const total = weights.reduce((a, b) => a + b, 0);
		let roll = random() * total;
		let index = 0;
		while (index < candidates.length - 1 && (roll -= weights[index]) > 0) index++;
		const [card] = candidates.splice(index, 1);
		seen.add(card.quiz.id);
		out.push(card);
	}
	return out;
}

/**
 * Spreads the groups evenly through the deck, so a repair card lands about
 * every fourth position rather than all up front or all at the back. The
 * starting group is random so the first card is not always a "practise".
 */
function interleave(groups: DeckCard[][], random: () => number): DeckCard[] {
	const total = groups.reduce((n, g) => n + g.length, 0);
	const out: DeckCard[] = [];
	const cursors = groups.map(() => 0);
	let g = Math.floor(random() * groups.length);
	// Each group advances at its own pace: pick the group furthest behind its
	// fair share, which yields e.g. R F F E F F R F F E F F for 3/6/3.
	for (let i = 0; i < total; i++) {
		let best = -1;
		let bestGap = -Infinity;
		for (let k = 0; k < groups.length; k++) {
			const idx = (g + k) % groups.length;
			if (cursors[idx] >= groups[idx].length) continue;
			const gap = groups[idx].length / total - cursors[idx] / Math.max(1, i);
			if (gap > bestGap) (bestGap = gap), (best = idx);
		}
		out.push(groups[best][cursors[best]++]);
		g = (best + 1) % groups.length;
	}
	return out;
}

/**
 * Untouched exercises near the learner's level, ranked by a lottery over the
 * pace's level spread — for "steady", mostly the centre sub-level, a taste of
 * the one above, a little of the one below. Reading order inside a sub-level
 * is deliberately not kept — the ladder view has that.
 */
function fresh(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	open: (quiz: Quiz) => boolean,
	levels: string[],
	centreIndex: number,
	spread: PaceSpec['levels'],
	random: () => number
): DeckCard[] {
	const untouched = (quiz: Quiz) => {
		const f = facts[quiz.id];
		return open(quiz) && !(f?.done || (f?.answered ?? 0) > 0);
	};
	const window = spread
		.map(({ offset, weight }) => ({ index: centreIndex + offset, weight }))
		.filter(({ index }) => index >= 0 && index < levels.length);

	const lists = window.map(({ index, weight }) => {
		const level = levels[index];
		const atLevel = quizzes.filter((quiz) => quiz.level === level);
		const doneHere = atLevel.filter((quiz) => facts[quiz.id]?.done).length;
		const cards = shuffle(atLevel.filter(untouched), random).map(
			(quiz): DeckCard => ({
				kind: 'fresh',
				quiz,
				reason: freshReason(level, index - centreIndex, doneHere, atLevel.length)
			})
		);
		return { cards, weight };
	});

	// Merge the per-level lists into one ranking by weighted coin toss, so the
	// top of the fresh pool is ~60% own level, ~25% one up, ~15% one back.
	const out: DeckCard[] = [];
	while (lists.some((l) => l.cards.length > 0)) {
		const live = lists.filter((l) => l.cards.length > 0);
		const total = live.reduce((n, l) => n + l.weight, 0);
		let roll = random() * total;
		let pick = live[live.length - 1];
		for (const l of live) {
			if ((roll -= l.weight) <= 0) {
				pick = l;
				break;
			}
		}
		out.push(pick.cards.shift()!);
	}
	return out;
}

function freshReason(level: string, offset: number, done: number, total: number): string {
	if (offset > 1) return `A stretch: ${level}, two steps up from where you are.`;
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
