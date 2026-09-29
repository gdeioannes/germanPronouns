import { describe, expect, it } from 'vitest';
import {
	reviewDue,
	reviewIntervalDays,
	strengths,
	strongTopics,
	topicLabel,
	topicMastery
} from './review';
import type { QuizFacts } from './recommend';
import type { QuizSummary as Quiz, QuizType } from '$lib/content/types';

const DAY = 24 * 60 * 60 * 1000;
const NOW = 1_800_000_000_000;

function quiz(id: string, type: QuizType, level: string, covers: string[] = []): Quiz {
	return { id, type, level, covers, title: `${level} · ${id}`, storageKeyPrefix: `${id}_` };
}

const COURSE: Quiz[] = [
	quiz('artikel', 'fillBlank', 'A1.1', ['a1.articles-nom']),
	quiz('plural', 'fillBlank', 'A1.1', ['a1.plural', 'a1.articles-nom']),
	quiz('lesen', 'reading', 'A1.1', ['a1.family-people']),
	quiz('akk', 'fillBlank', 'A1.2', ['a1.accusative-articles', 'a1.articles-nom']),
	quiz('zahlen', 'fillBlank', 'A1.2', ['a1.numbers']),
	quiz('far', 'fillBlank', 'B2.1', ['a1.articles-nom', 'b2.passive'])
];

const open = () => true;
const inReach = (q: Quiz) => q.level !== 'B2.1';

function done(daysAgo: number | null, extra: Partial<QuizFacts> = {}): QuizFacts {
	return {
		done: true,
		tier: 'gold',
		answered: 20,
		mistakeRate: 0,
		lastPlayedAt: daysAgo === null ? null : NOW - daysAgo * DAY,
		...extra
	};
}

describe('reviewIntervalDays', () => {
	it('grows with the medal and shrinks when recent answers are shaky', () => {
		const q = COURSE[0];
		expect(reviewIntervalDays(q, done(0, { tier: 'bronze' }))).toBe(3);
		expect(reviewIntervalDays(q, done(0, { tier: 'silver' }))).toBe(7);
		expect(reviewIntervalDays(q, done(0, { tier: 'gold' }))).toBe(14);
		expect(reviewIntervalDays(q, done(0, { tier: 'gold', recentMistakeRate: 0.3 }))).toBe(1);
	});

	it('gives play-through kinds a flat week', () => {
		expect(reviewIntervalDays(COURSE[2], done(0, { answered: 0 }))).toBe(7);
	});
});

describe('reviewDue', () => {
	it('deals nothing to a learner with no finished work', () => {
		expect(reviewDue(COURSE, {}, open, NOW)).toEqual([]);
	});

	it('leaves alone what was played inside its interval', () => {
		expect(reviewDue(COURSE, { artikel: done(3) }, open, NOW)).toEqual([]);
	});

	it('brings back a gold exercise after a fortnight, a shaky one the next day', () => {
		const due = reviewDue(
			COURSE,
			{
				artikel: done(15),
				plural: done(1, { recentMistakeRate: 0.4 }),
				zahlen: done(2)
			},
			open,
			NOW
		);
		expect(due.map((p) => p.quiz.id)).toEqual(['artikel', 'plural']);
		expect(due[0].reason).toMatch(/Gold 15 days ago/);
		expect(due[1].reason).toMatch(/yesterday.*wobbly/);
	});

	it('ranks the most overdue first and an undated finish last', () => {
		const due = reviewDue(
			COURSE,
			{ artikel: done(20), plural: done(null), zahlen: done(60) },
			open,
			NOW
		);
		expect(due.map((p) => p.quiz.id)).toEqual(['zahlen', 'artikel', 'plural']);
		expect(due[2].reason).toMatch(/a while back/);
	});

	it('respects the open filter', () => {
		expect(reviewDue(COURSE, { artikel: done(30) }, (q) => q.id !== 'artikel', NOW)).toEqual([]);
	});
});

describe('topicMastery / strongTopics', () => {
	it('pools answers across the exercises that cover a topic', () => {
		const m = topicMastery(COURSE, {
			artikel: done(0, { answered: 10, mistakeRate: 0.1 }),
			plural: done(0, { answered: 10, mistakeRate: 0.3 })
		});
		expect(m.get('a1.articles-nom')).toEqual({ answered: 20, mistakeRate: 0.2 });
		expect(m.get('a1.plural')).toEqual({ answered: 10, mistakeRate: 0.3 });
	});

	it('only calls a topic strong with enough answers and few mistakes', () => {
		const m = topicMastery(COURSE, {
			artikel: done(0, { answered: 4, mistakeRate: 0 }),
			zahlen: done(0, { answered: 30, mistakeRate: 0.1 }),
			plural: done(0, { answered: 30, mistakeRate: 0.4 })
		});
		expect(strongTopics(m)).toEqual(['a1.numbers']);
	});
});

describe('strengths', () => {
	it('offers nothing before any topic is strong', () => {
		expect(strengths(COURSE, { artikel: done(0, { answered: 3 }) }, open, inReach)).toEqual([]);
	});

	it('picks untouched, in-reach exercises that extend a strong topic', () => {
		const picks = strengths(
			COURSE,
			{ artikel: done(0, { answered: 20, mistakeRate: 0.05 }) },
			open,
			inReach
		);
		const ids = picks.map((p) => p.quiz.id);
		expect(ids).toContain('akk');
		expect(ids).toContain('plural');
		expect(ids).not.toContain('far'); // out of reach
		expect(ids).not.toContain('artikel'); // already done
		// Both add a new topic on top of the strong one; ladder order breaks the tie.
		expect(ids[0]).toBe('plural');
		expect(picks[0].reason).toMatch(/95% right on articles nom/);
	});

	it('skips anything already started', () => {
		const picks = strengths(
			COURSE,
			{
				artikel: done(0, { answered: 20 }),
				akk: { done: false, tier: null, answered: 2, mistakeRate: 0.5 }
			},
			open,
			inReach
		);
		expect(picks.map((p) => p.quiz.id)).not.toContain('akk');
	});
});

describe('topicLabel', () => {
	it('drops the level prefix and the dashes', () => {
		expect(topicLabel('a1.accusative-articles')).toBe('accusative articles');
		expect(topicLabel('b2.passive')).toBe('passive');
		expect(topicLabel('numbers')).toBe('numbers');
	});
});
