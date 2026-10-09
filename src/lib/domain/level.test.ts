import { describe, expect, it } from 'vitest';
import { estimateLevel, levelEvidence } from './level';
import type { QuizFacts } from './recommend';
import type { QuizSummary as Quiz } from '$lib/content/types';

function quiz(id: string, level: string): Quiz {
	return { id, type: 'fillBlank', level, covers: [], title: `${level} · ${id}`, storageKeyPrefix: `${id}_` };
}

/** Six sub-levels with eight exercises each, ids like "A1.1-3". */
const LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'C2.2'];
const COURSE: Quiz[] = LEVELS.flatMap((level) => Array.from({ length: 8 }, (_, i) => quiz(`${level}-${i}`, level)));

const done = (mistakeRate = 0, answered = 20): QuizFacts => ({ done: true, tier: 'gold', answered, mistakeRate });
const finished = (level: string, n: number, mistakeRate = 0) =>
	Object.fromEntries(Array.from({ length: n }, (_, i) => [`${level}-${i}`, done(mistakeRate)]));

describe('estimateLevel', () => {
	it('starts a newcomer at the first level', () => {
		expect(estimateLevel(COURSE, {})).toBe('A1.1');
		expect(estimateLevel([], {})).toBeNull();
	});

	it('ignores a single peek at a high level', () => {
		const facts = { ...finished('A1.1', 5), ...finished('C2.2', 1) };
		expect(estimateLevel(COURSE, facts)).toBe('A1.1');
	});

	it('ignores a few high finishes that are a small share of the work', () => {
		const facts = { ...finished('A1.1', 8), ...finished('A1.2', 8), ...finished('A2.1', 6), ...finished('C2.2', 3) };
		expect(estimateLevel(COURSE, facts)).toBe('A2.1');
	});

	it('follows the learner once a level has real evidence', () => {
		const facts = { ...finished('A1.1', 3), ...finished('B1.1', 5) };
		expect(estimateLevel(COURSE, facts)).toBe('B1.1');
	});

	it('lets strong work above prove the levels beneath it', () => {
		// Thin A2 evidence, but plenty of B1.1 finishes: the learner is a B1 learner,
		// not stuck at A1.2 because A2.1 is a small share of their total.
		const facts = {
			...finished('A1.1', 8),
			...finished('A1.2', 7),
			...finished('A2.1', 4),
			...finished('A2.2', 3),
			...finished('B1.1', 7),
			...finished('C2.2', 1)
		};
		expect(estimateLevel(COURSE, facts)).toBe('B1.1');
	});

	it('does not let a thin level above bridge a gap', () => {
		// Three C2.2 finishes are a peek, not proof of B1 and A2.
		const facts = { ...finished('A1.1', 8), ...finished('A1.2', 8), ...finished('A2.1', 6), ...finished('C2.2', 3) };
		expect(estimateLevel(COURSE, facts)).toBe('A2.1');
	});

	it('uses the level with the most done before anything is held', () => {
		expect(estimateLevel(COURSE, { ...finished('A1.2', 2), ...finished('A2.1', 1) })).toBe('A1.2');
	});

	it('steps up once a level is finished through', () => {
		expect(estimateLevel(COURSE, finished('A1.1', 8))).toBe('A1.2');
	});

	it('steps down when most finishes at the level went badly', () => {
		const facts = { ...finished('A1.1', 8), ...finished('A1.2', 4, 0.5) };
		expect(estimateLevel(COURSE, facts)).toBe('A1.1');
		// Shaky finishes carry little weight, so they do not make the level held.
		expect(levelEvidence(COURSE, facts).find((r) => r.level === 'A1.2')).toMatchObject({ weak: 4, solid: 0, score: 1 });
	});

	it('does not count a shaky mistake rate from too few answers', () => {
		expect(estimateLevel(COURSE, { 'A2.1-0': done(0.5, 2), 'A2.1-1': done(0.5, 2), 'A2.1-2': done(0.5, 2) })).toBe('A2.1');
	});
});
