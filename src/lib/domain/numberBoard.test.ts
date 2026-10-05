import { describe, expect, it } from 'vitest';
import type { FillBlankQuiz } from '$lib/content/types';
import course from '$content/courses/de_cert_a1.json';
import { READ_COUNT, boardNumbers, planLength, stagePlan } from './numberBoard';

const zahlen = (course.quizzes as unknown as FillBlankQuiz[]).find((q) => q.id === 'quest_a1_1_zahlen')!;

describe('boardNumbers', () => {
	it('pairs each digit with its word', () => {
		const numbers = boardNumbers(zahlen);
		expect(numbers).toHaveLength(11);
		expect(numbers[0]).toEqual({ digit: '0', word: 'null' });
		expect(numbers[7]).toEqual({ digit: '7', word: 'sieben' });
	});
});

describe('stagePlan', () => {
	const numbers = boardNumbers(zahlen);

	it('hears every number once, reads six, writes the three easy ones', () => {
		const plan = stagePlan(numbers);
		expect(new Set(plan.hear.map((n) => n.digit)).size).toBe(numbers.length);
		expect(plan.read).toHaveLength(READ_COUNT);
		expect(new Set(plan.read.map((n) => n.digit)).size).toBe(READ_COUNT);
		expect(plan.write.map((n) => n.word)).toEqual(['acht', 'drei', 'null']);
		expect(planLength(plan)).toBe(20);
	});

	it('falls back to the shortest words when the easy ones are missing', () => {
		const plan = stagePlan([
			{ digit: '4', word: 'vier' },
			{ digit: '7', word: 'sieben' },
			{ digit: '1', word: 'eins' },
			{ digit: '2', word: 'zwei' }
		]);
		expect(plan.write.map((n) => n.word)).toEqual(['vier', 'eins', 'zwei']);
	});
});

describe('the bundle', () => {
	it('plays the first quiz as the number-task menu', () => {
		expect(course.quizzes[0].id).toBe('quest_a1_1_zahlen');
		expect((zahlen as { game?: string }).game).toBe('numberTasks');
	});
});
