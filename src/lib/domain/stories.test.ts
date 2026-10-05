import { describe, expect, it } from 'vitest';
import { STORY_EPISODES, reachedQuiz, storyDeckCard } from './stories';

const quizzes = ['q1', 'q2', 'q3', 'q4', 'q5'].map((id) => ({ id, level: 'A1.1' }));

describe('reachedQuiz', () => {
	it('counts the quiz itself, or as many done quizzes as come before it', () => {
		const done = (ids: string[]) => (id: string) => ids.includes(id);
		expect(reachedQuiz(quizzes, done([]), 'q3')).toBe(false);
		expect(reachedQuiz(quizzes, done(['q3']), 'q3')).toBe(true);
		expect(reachedQuiz(quizzes, done(['q1', 'q2']), 'q3')).toBe(false);
		// skipping around still counts: three done, any three
		expect(reachedQuiz(quizzes, done(['q1', 'q4', 'q5']), 'q3')).toBe(true);
		expect(reachedQuiz(quizzes, done([]), 'not-a-quiz')).toBe(true);
	});
});

describe('storyDeckCard', () => {
	it('deals the prologue first and holds Episode 1 back until mid-A1.1', () => {
		const first = STORY_EPISODES[0];
		const later = STORY_EPISODES.find((e) => e.after);
		expect(first.after).toBeUndefined();
		expect(later?.after).toBe('quest_a1_1_diktat_steckbrief');

		// prologue skipped, Episode 1 not reached yet: nothing to deal
		const skipped = new Set([`story:${first.id}`]);
		expect(storyDeckCard('de_cert_a1', 'A1.1', skipped, () => false)).toBeNull();
		// reached: Episode 1 comes up
		expect(storyDeckCard('de_cert_a1', 'A1.1', skipped, () => true)?.quiz.id).toBe(`story:${later?.id}`);
		// nothing skipped: the prologue leads
		expect(storyDeckCard('de_cert_a1', 'A1.1', new Set(), () => true)?.quiz.id).toBe(`story:${first.id}`);
	});
});
