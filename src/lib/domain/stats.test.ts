import { describe, expect, it } from 'vitest';
import { levelLine, percentOf, progressStats } from './stats';
import type { QuizFacts } from './recommend';
import type { QuizSummary as Quiz, QuizType } from '$lib/content/types';

function quiz(id: string, type: QuizType, level: string, covers: string[] = []): Quiz {
	return { id, type, level, covers, title: id, storageKeyPrefix: `${id}_` };
}

const NOW = 1_800_000_000_000;
const DAY = 24 * 60 * 60 * 1000;

const COURSE: Quiz[] = [
	quiz('a', 'fillBlank', 'A1.1', ['a1.articles']),
	quiz('b', 'fillBlank', 'A1.1', ['a1.articles']),
	quiz('c', 'listening', 'A1.1', ['a1.numbers']),
	quiz('d', 'fillBlank', 'A1.2', ['a1.accusative']),
	quiz('e', 'reading', 'A1.2')
];

const FACTS: Record<string, QuizFacts> = {
	a: { done: true, tier: 'gold', answered: 20, mistakeRate: 0.05, lastPlayedAt: NOW - 2 * DAY },
	b: { done: true, tier: 'bronze', answered: 10, mistakeRate: 0.1, lastPlayedAt: NOW - 20 * DAY },
	d: { done: false, tier: null, answered: 12, mistakeRate: 0.5, recentMistakeRate: 0.25, lastPlayedAt: NOW - DAY }
};

describe('progressStats', () => {
	const stats = progressStats(COURSE, FACTS, { 'A1.1': 'Getting started' }, NOW);

	it('counts the course and each sub-level', () => {
		expect(stats.course).toEqual({ done: 2, total: 5 });
		expect(stats.levels).toEqual([
			{ level: 'A1.1', title: 'Getting started', done: 2, total: 3 },
			{ level: 'A1.2', title: 'A1.2', done: 0, total: 2 }
		]);
	});

	it('tallies medals, answers and accuracy', () => {
		expect(stats.medals).toEqual({ gold: 1, silver: 0, bronze: 1 });
		expect(stats.answers).toBe(42);
		// 19 + 9 + 6 right of 42.
		expect(stats.accuracy).toBeCloseTo(34 / 42, 5);
		// Recent: d's 12 answers at 75% instead of 50%.
		expect(stats.recentAccuracy).toBeCloseTo((19 + 9 + 9) / 42, 5);
	});

	it('reports activity and due reviews', () => {
		expect(stats.playedThisWeek).toBe(2);
		expect(stats.daysSincePlayed).toBe(1);
		// b: bronze, 20 days old — past its 3-day interval. a: gold, 2 days — not yet.
		expect(stats.reviewsDue).toBe(1);
	});

	it('splits topics into strengths and weak spots', () => {
		expect(stats.strengths.map((t) => t.label)).toEqual(['articles']);
		expect(stats.weakSpots.map((t) => t.label)).toEqual(['accusative']);
	});

	it('lists only the exercise types the course has', () => {
		expect(stats.types.map((t) => t.type)).toEqual(['fillBlank', 'reading', 'listening']);
		expect(stats.types[0]).toMatchObject({ done: 2, total: 3 });
		expect(stats.types[1].accuracy).toBeNull();
	});

	it('is empty but well-formed for a newcomer', () => {
		const empty = progressStats(COURSE, {}, {}, NOW);
		expect(empty.accuracy).toBeNull();
		expect(empty.daysSincePlayed).toBeNull();
		expect(empty.strengths).toEqual([]);
	});
});

describe('levelLine / percentOf', () => {
	const row = (done: number, total = 30) => ({ level: 'A1.1', title: '', done, total });

	it('counts, then counts down near the end, then says done', () => {
		expect(levelLine(row(4))).toBe('A1.1 · 4 / 30');
		expect(levelLine(row(27))).toBe('A1.1 · 3 to go');
		expect(levelLine(row(30))).toBe('A1.1 · done');
	});

	it('rounds, and treats an empty tally as 0', () => {
		expect(percentOf({ done: 1, total: 3 })).toBe(33);
		expect(percentOf({ done: 0, total: 0 })).toBe(0);
	});
});
