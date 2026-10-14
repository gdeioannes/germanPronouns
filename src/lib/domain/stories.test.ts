import { afterEach, describe, expect, it } from 'vitest';
import { STORY_EPISODES, reachedQuiz, storyDeckCard } from './stories';

// A Map-backed localStorage: the player's finished flag lives there.
const store = new Map<string, string>();
Object.defineProperty(globalThis, 'localStorage', {
	configurable: true,
	value: {
		getItem: (k: string) => store.get(k) ?? null,
		setItem: (k: string, v: string) => store.set(k, v),
		removeItem: (k: string) => store.delete(k),
		clear: () => store.clear()
	}
});
const finish = (id: string) => store.set(`story_${id}`, JSON.stringify({ finished: true }));

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
	afterEach(() => store.clear());

	it('deals the episodes in strict order, one finished before the next', () => {
		const [ep0, ep1, ep2] = STORY_EPISODES;
		expect(ep0.after).toBeUndefined();
		expect(ep1.after).toBe('quest_a1_1_diktat_steckbrief');

		// nothing finished: the prologue leads, even with everything reached
		expect(storyDeckCard('de_cert_a1', 'A1.1', new Set(), () => true)?.quiz.id).toBe(`story:${ep0.id}`);
		// prologue skipped this deal: no story card — the deck never jumps to Episode 1
		const skipped = new Set([`story:${ep0.id}`]);
		expect(storyDeckCard('de_cert_a1', 'A1.1', skipped, () => true)).toBeNull();

		// prologue finished: Episode 1, but only once its material is reached
		finish(ep0.id);
		expect(storyDeckCard('de_cert_a1', 'A1.1', new Set(), () => false)).toBeNull();
		expect(storyDeckCard('de_cert_a1', 'A1.1', new Set(), () => true)?.quiz.id).toBe(`story:${ep1.id}`);

		// Episode 1 finished too: Episode 2
		finish(ep1.id);
		expect(storyDeckCard('de_cert_a1', 'A1.1', new Set(), () => true)?.quiz.id).toBe(`story:${ep2.id}`);
		// all finished: the deck stops dealing stories
		finish(ep2.id);
		expect(storyDeckCard('de_cert_a1', 'A1.1', new Set(), () => true)).toBeNull();
	});

	it('holds a later episode back when the deck is on another sub-level', () => {
		expect(storyDeckCard('de_cert_a1', 'A1.2', new Set(), () => true)).toBeNull();
	});
});
