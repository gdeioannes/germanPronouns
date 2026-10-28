import { describe, expect, it } from 'vitest';
import { loadCourse, catalog } from '$lib/content';
import { buildPlacementBank, grammarLevel, nextGrammarLevel, placementLevel, GRAMMAR_ITEMS, type GrammarAnswer } from './placement';

const LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];

describe('placement bank', async () => {
	const bank = buildPlacementBank(await loadCourse(catalog.defaultCourseId));

	it('covers every sub-level with grammar, a reading and a listening text', () => {
		expect(bank.levels).toEqual(LEVELS);
		for (const level of LEVELS) {
			expect(bank.grammar[level].length, level).toBeGreaterThanOrEqual(GRAMMAR_ITEMS);
			expect(bank.reading[level]?.questions.length, `reading ${level}`).toBe(3);
			expect(bank.listening[level]?.questions.length, `listening ${level}`).toBe(3);
		}
	});

	it('asks one gap per item, with the answer not among the wrong options', () => {
		for (const items of Object.values(bank.grammar))
			for (const item of items) {
				expect(item.sentence.match(/____/g)?.length).toBe(1);
				expect(item.wrong).not.toContain(item.answer);
				expect(item.wrong.length).toBe(3);
			}
	});

	it('spreads a level’s items over several drills', () => {
		for (const level of LEVELS) expect(new Set(bank.grammar[level].map((i) => i.quizId)).size, level).toBeGreaterThan(3);
	});
});

describe('the staircase', () => {
	const run = (start: string, answer: (level: string) => boolean) => {
		const answers: GrammarAnswer[] = [];
		for (let n = 0; n < GRAMMAR_ITEMS; n++) {
			const level = nextGrammarLevel(LEVELS, start, answers);
			answers.push({ level, right: answer(level) });
		}
		return grammarLevel(LEVELS, answers);
	};

	it('settles at the edge of what the learner knows', () => {
		// Knows everything up to B1.2, nothing above.
		const at = run('A1.1', (l) => LEVELS.indexOf(l) <= LEVELS.indexOf('B1.2'));
		expect(['B1.2', 'B2.1']).toContain(at);
	});

	it('keeps a true beginner at the bottom', () => {
		expect(run('A2.1', () => false)).toBe('A1.1');
	});

	it('takes a learner who knows everything to the top', () => {
		expect(run('A1.1', () => true)).toBe('C2.2');
	});
});

describe('the result', () => {
	it('moves the grammar level with reading and listening', () => {
		expect(placementLevel(LEVELS, null, 'B1.1', [3, 3], [3, 3])).toBe('B1.2');
		expect(placementLevel(LEVELS, null, 'B1.1', [1, 3], [0, 3])).toBe('A2.2');
		expect(placementLevel(LEVELS, null, 'B1.1', [2, 3], [2, 3])).toBe('B1.1');
	});

	it('lets the word level pull a third of the way', () => {
		expect(placementLevel(LEVELS, 'A2.2', 'B1.2', [2, 3], [2, 3])).toBe('B1.1');
	});

	it('never leaves the scale', () => {
		expect(placementLevel(LEVELS, 'C2.2', 'C2.2', [3, 3], [3, 3])).toBe('C2.2');
		expect(placementLevel(LEVELS, 'A1.1', 'A1.1', [0, 3], [0, 3])).toBe('A1.1');
	});
});
