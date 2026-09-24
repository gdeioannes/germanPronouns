// "Recommended for you" on the course home: beyond "continue where you left
// off", three kinds of next step drawn from what the learner has actually done.
//
//   practise — go back to something that went badly (or was left unfinished)
//   next     — something new that builds on a topic already practised
//   mix      — an exercise type the learner has barely touched
//
// Pure functions over plain facts, so the ranking is unit-testable without a
// browser; the course page gathers the facts from the progress store.

import type { Quiz, QuizType } from '$lib/content/types';
import type { RibbonTier } from './progress';
import { topicOf } from '$lib/seo';

export type RecommendationKind = 'practise' | 'next' | 'mix';

/** Every kind; which one is shown is picked at random. */
export const RECOMMENDATION_KINDS: RecommendationKind[] = ['practise', 'next', 'mix'];

export const KIND_LABELS: Record<RecommendationKind, string> = {
	practise: 'Practise',
	next: 'Learn next',
	mix: 'Mix it up'
};

/** What the progress store knows about one quiz. */
export interface QuizFacts {
	done: boolean;
	/** The ribbon a finished quiz shows; null when unfinished. */
	tier: RibbonTier | null;
	/** Answers on record — zero for play-through kinds that keep no history. */
	answered: number;
	/** Share of recorded answers that were wrong, 0–1. */
	mistakeRate: number;
}

export interface Recommendation {
	kind: RecommendationKind;
	quiz: Quiz;
	/** One line on why this one, in the learner's terms. */
	reason: string;
}

/** A mistake rate at or above this makes a finished quiz worth redoing. */
export const WEAK_MISTAKE_RATE = 0.2;

/** Answers needed before a mistake rate means anything. */
const MIN_ANSWERS = 5;

const TYPE_NAMES: Record<QuizType, { one: string; many: string; pitch: string }> = {
	fillBlank: { one: 'grammar drill', many: 'grammar drills', pitch: 'tighten up the grammar' },
	reading: { one: 'reading', many: 'readings', pitch: 'read some real German' },
	listening: { one: 'listening exercise', many: 'listening exercises', pitch: 'train your ear' },
	dictation: { one: 'dictation', many: 'dictations', pitch: 'fix spelling by ear' },
	speakRepeat: { one: 'repeat-aloud', many: 'repeat-alouds', pitch: 'get your mouth moving' },
	speaking: { one: 'speaking exercise', many: 'speaking exercises', pitch: 'say it out loud' }
};

const EMPTY: QuizFacts = { done: false, tier: null, answered: 0, mistakeRate: 0 };

/**
 * Every recommendation, grouped by kind and ranked best-first. `quizzes` is
 * the course in ladder order; `exclude` holds ids never to suggest (the
 * "Continue" quiz, which already has its own card).
 */
export function recommend(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	exclude: Set<string> = new Set()
): Record<RecommendationKind, Recommendation[]> {
	const factsOf = (quiz: Quiz) => facts[quiz.id] ?? EMPTY;
	const done = quizzes.filter((quiz) => factsOf(quiz).done);
	const open = (quiz: Quiz) => !exclude.has(quiz.id) && quiz.status !== 'placeholder';

	// The learner's frontier: the furthest sub-level with anything finished.
	// New suggestions stay at or one step past it, never a leap to C2.
	const levels = [...new Set(quizzes.map((quiz) => quiz.level ?? ''))];
	const levelIndex = (quiz: Quiz) => levels.indexOf(quiz.level ?? '');
	const frontier = Math.max(-1, ...done.map(levelIndex));
	const inReach = (quiz: Quiz) => levelIndex(quiz) <= frontier + 1;

	return {
		practise: practise(quizzes, factsOf, open),
		next: next(quizzes, done, factsOf, open, inReach, levelIndex, frontier),
		mix: mix(quizzes, done, factsOf, open, inReach)
	};
}

function practise(
	quizzes: Quiz[],
	factsOf: (quiz: Quiz) => QuizFacts,
	open: (quiz: Quiz) => boolean
): Recommendation[] {
	const ranked: { quiz: Quiz; weight: number; reason: string }[] = [];
	for (const quiz of quizzes) {
		if (!open(quiz)) continue;
		const f = factsOf(quiz);
		const measured = f.answered >= MIN_ANSWERS;
		const percent = Math.round(f.mistakeRate * 100);
		if (!f.done && f.answered > 0) {
			ranked.push({
				quiz,
				weight: 3 + f.mistakeRate,
				reason: measured
					? `You started this one and missed ${percent}% of answers — finish it off.`
					: 'You started this one — finish it off.'
			});
		} else if (f.done && measured && f.mistakeRate >= WEAK_MISTAKE_RATE) {
			ranked.push({
				quiz,
				weight: 2 + f.mistakeRate,
				reason: `You missed ${percent}% of answers here — another run will make it stick.`
			});
		} else if (quiz.type !== 'fillBlank') {
			// Only fill-ins earn a medal by streak; a finished reading or
			// listening always shows bronze, so its tier says nothing.
			continue;
		} else if (f.done && f.tier === 'bronze') {
			ranked.push({
				quiz,
				weight: 1,
				reason: 'Finished with bronze — a longer streak lifts it to silver.'
			});
		} else if (f.done && f.tier === 'silver') {
			ranked.push({
				quiz,
				weight: 0.5,
				reason: 'Silver so far — one strong run takes it to gold.'
			});
		}
	}
	return ranked
		.sort((a, b) => b.weight - a.weight)
		.map(({ quiz, reason }) => ({ kind: 'practise', quiz, reason }));
}

function next(
	quizzes: Quiz[],
	done: Quiz[],
	factsOf: (quiz: Quiz) => QuizFacts,
	open: (quiz: Quiz) => boolean,
	inReach: (quiz: Quiz) => boolean,
	levelIndex: (quiz: Quiz) => number,
	frontier: number
): Recommendation[] {
	// Which finished quiz first taught each syllabus topic — the "builds on"
	// in the reason line.
	const taughtBy = new Map<string, Quiz>();
	for (const quiz of done) {
		for (const topic of quiz.covers ?? []) {
			if (!taughtBy.has(topic)) taughtBy.set(topic, quiz);
		}
	}
	if (taughtBy.size === 0) return [];

	const ranked: { quiz: Quiz; weight: number; reason: string }[] = [];
	quizzes.forEach((quiz, order) => {
		if (!open(quiz) || factsOf(quiz).done || factsOf(quiz).answered > 0 || !inReach(quiz)) return;
		const shared = (quiz.covers ?? []).filter((topic) => taughtBy.has(topic));
		if (shared.length === 0) return;
		const fresh = (quiz.covers ?? []).length - shared.length;
		const base = taughtBy.get(shared[0])!;
		// Shared topics make it adjacent; a new topic on top makes it a real
		// step forward rather than a rerun; the frontier level beats older
		// ones; and ladder order breaks ties.
		const weight =
			shared.length * 2 +
			Math.min(fresh, 2) +
			(levelIndex(quiz) >= frontier ? 1 : 0) -
			order / 10_000;
		ranked.push({
			quiz,
			weight,
			reason: `Builds on “${topicOf(base.title)}”, which you’ve finished.`
		});
	});
	return ranked
		.sort((a, b) => b.weight - a.weight)
		.map(({ quiz, reason }) => ({ kind: 'next', quiz, reason }));
}

function mix(
	quizzes: Quiz[],
	done: Quiz[],
	factsOf: (quiz: Quiz) => QuizFacts,
	open: (quiz: Quiz) => boolean,
	inReach: (quiz: Quiz) => boolean
): Recommendation[] {
	if (done.length === 0) return [];
	const count = new Map<QuizType, number>();
	for (const quiz of quizzes) count.set(quiz.type, 0);
	for (const quiz of done) count.set(quiz.type, (count.get(quiz.type) ?? 0) + 1);

	// The type done most is the one being over-relied on; the others, least
	// done first, are what to mix in.
	const byUse = [...count].sort((a, b) => a[1] - b[1]);
	const [topType, topCount] = byUse.at(-1)!;

	const picks: Recommendation[] = [];
	for (const [type, n] of byUse) {
		if (type === topType || n >= topCount) continue;
		const quiz = quizzes.find(
			(q) => q.type === type && open(q) && !factsOf(q).done && inReach(q)
		);
		if (!quiz) continue;
		const names = TYPE_NAMES[type];
		const top = TYPE_NAMES[topType];
		const tally =
			n === 0
				? `no ${names.many} yet`
				: `only ${n} ${n === 1 ? names.one : names.many}`;
		picks.push({
			kind: 'mix',
			quiz,
			reason: `You’ve done ${topCount} ${topCount === 1 ? top.one : top.many} but ${tally} — ${names.pitch}.`
		});
	}
	return picks;
}

/**
 * The next suggestion to show: the top unskipped pick of a randomly chosen
 * kind. After a "no" (`from` set) a different kind is preferred, so the
 * learner sees a new idea rather than the runner-up of the one they turned
 * down; `from`'s kind is only reused when it is the last one left.
 * Returns null only when every candidate has been skipped.
 */
export function pickNext(
	all: Record<RecommendationKind, Recommendation[]>,
	skipped: Set<string>,
	from: RecommendationKind | null,
	random: () => number = Math.random
): Recommendation | null {
	const top = (kind: RecommendationKind) => all[kind].find((rec) => !skipped.has(rec.quiz.id));
	const available = RECOMMENDATION_KINDS.filter((kind) => top(kind));
	if (available.length === 0) return null;
	const others = available.filter((kind) => kind !== from);
	const pool = others.length > 0 ? others : available;
	return top(pool[Math.floor(random() * pool.length)])!;
}
