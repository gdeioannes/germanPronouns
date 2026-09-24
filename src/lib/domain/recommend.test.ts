import { describe, expect, it } from 'vitest';
import { pickNext, recommend, type QuizFacts } from './recommend';
import type { Quiz, QuizType } from '$lib/content/types';

function quiz(id: string, type: QuizType, level: string, covers: string[]): Quiz {
	return { id, type, level, covers, title: `${level} · ${id}`, storageKeyPrefix: `${id}_` } as Quiz;
}

const COURSE: Quiz[] = [
	quiz('zahlen', 'fillBlank', 'A1.1', ['numbers']),
	quiz('artikel', 'fillBlank', 'A1.1', ['articles']),
	quiz('plural', 'fillBlank', 'A1.1', ['plural', 'articles']),
	quiz('hoeren', 'listening', 'A1.1', ['numbers', 'greetings']),
	quiz('lesen', 'reading', 'A1.1', ['greetings']),
	quiz('akk', 'fillBlank', 'A1.2', ['accusative', 'articles']),
	quiz('uhrzeit', 'listening', 'A1.2', ['time']),
	quiz('far', 'fillBlank', 'B2.1', ['articles', 'passive'])
];

const done = (tier: QuizFacts['tier'] = 'gold', mistakeRate = 0, answered = 20): QuizFacts => ({
	done: true,
	tier,
	answered,
	mistakeRate
});

describe('recommend', () => {
	it('suggests nothing to a learner with no history', () => {
		const recs = recommend(COURSE, {});
		expect(recs.practise).toEqual([]);
		expect(recs.next).toEqual([]);
		expect(recs.mix).toEqual([]);
	});

	it('ranks practise: unfinished first, then high mistake rate, then bronze', () => {
		const recs = recommend(COURSE, {
			zahlen: done('bronze'),
			artikel: done('gold', 0.4),
			plural: { done: false, tier: null, answered: 3, mistakeRate: 0.3 },
			akk: done('gold', 0.05)
		});
		expect(recs.practise.map((r) => r.quiz.id)).toEqual(['plural', 'artikel', 'zahlen']);
		expect(recs.practise[1].reason).toContain('40%');
	});

	it('ignores the fixed bronze of a finished play-through quiz', () => {
		const recs = recommend(COURSE, { lesen: done('bronze', 0, 0) });
		expect(recs.practise).toEqual([]);
	});

	it('suggests next steps that share a topic with finished work, within reach', () => {
		const recs = recommend(COURSE, { artikel: done() });
		const ids = recs.next.map((r) => r.quiz.id);
		expect(ids).toEqual(expect.arrayContaining(['plural', 'akk']));
		// B2.1 is far past the A1.1 frontier, even though it shares "articles".
		expect(ids).not.toContain('far');
		// No shared topic, so not "adjacent".
		expect(ids).not.toContain('lesen');
		expect(recs.next[0].reason).toContain('artikel');
	});

	it('mixes in the exercise types the learner has neglected', () => {
		const recs = recommend(COURSE, { zahlen: done(), artikel: done() });
		const types = recs.mix.map((r) => r.quiz.type);
		expect(types).toContain('listening');
		expect(types).toContain('reading');
		expect(types).not.toContain('fillBlank');
		expect(recs.mix.find((r) => r.quiz.type === 'listening')!.reason).toMatch(
			/2 grammar drills but no listening exercises/
		);
	});

	it('never suggests an excluded quiz', () => {
		const recs = recommend(COURSE, { artikel: done() }, new Set(['plural']));
		expect(recs.next.map((r) => r.quiz.id)).not.toContain('plural');
	});
});

describe('pickNext', () => {
	const recs = recommend(COURSE, {
		zahlen: done('bronze'),
		artikel: done()
	});

	it('picks the kind at random', () => {
		expect(pickNext(recs, new Set(), null, () => 0)?.kind).toBe('practise');
		expect(pickNext(recs, new Set(), null, () => 0.5)?.kind).toBe('next');
		expect(pickNext(recs, new Set(), null, () => 0.99)?.kind).toBe('mix');
	});

	it('never repeats the kind just turned down while another has a pick', () => {
		for (const r of [0, 0.3, 0.6, 0.99]) {
			expect(pickNext(recs, new Set(), 'next', () => r)?.kind).not.toBe('next');
		}
	});

	it('reuses the same kind only when it is the last one left', () => {
		const onlyPractise = { ...recs, next: [], mix: [] };
		expect(pickNext(onlyPractise, new Set(), 'practise')?.kind).toBe('practise');
	});

	it('returns null once everything has been skipped', () => {
		const every = new Set(COURSE.map((q) => q.id));
		expect(pickNext(recs, every, 'practise')).toBeNull();
	});
});
