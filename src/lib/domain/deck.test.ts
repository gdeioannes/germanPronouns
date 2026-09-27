import { describe, expect, it } from 'vitest';
import { buildDeck, courseLevels, deckLevel } from './deck';
import type { QuizFacts } from './recommend';
import type { QuizSummary as Quiz, QuizType } from '$lib/content/types';

function quiz(id: string, type: QuizType, level: string, covers: string[] = []): Quiz {
	return { id, type, level, covers, title: `${level} · ${id}`, storageKeyPrefix: `${id}_` };
}

const COURSE: Quiz[] = [
	quiz('zahlen', 'fillBlank', 'A1.1', ['numbers']),
	quiz('artikel', 'fillBlank', 'A1.1', ['articles']),
	quiz('plural', 'fillBlank', 'A1.1', ['plural', 'articles']),
	quiz('hoeren', 'listening', 'A1.1', ['numbers']),
	quiz('akk', 'fillBlank', 'A1.2', ['accusative', 'articles']),
	quiz('uhrzeit', 'listening', 'A1.2', ['time']),
	quiz('reise', 'reading', 'A2.1', ['travel']),
	quiz('meinung', 'fillBlank', 'B1.1', ['subjunctive']),
	quiz('far', 'fillBlank', 'B2.1', ['passive'])
];

const done = (mistakeRate = 0): QuizFacts => ({ done: true, tier: 'gold', answered: 20, mistakeRate });
const fixed = () => 0.5;

describe('courseLevels / deckLevel', () => {
	it('lists sub-levels in ladder order', () => {
		expect(courseLevels(COURSE)).toEqual(['A1.1', 'A1.2', 'A2.1', 'B1.1', 'B2.1']);
	});

	it('centres on A1.1 for a newcomer with no pick', () => {
		expect(deckLevel(COURSE, {}, null)).toBe('A1.1');
	});

	it('takes the picked level, or the furthest finished one if that is further', () => {
		expect(deckLevel(COURSE, {}, 'A2.1')).toBe('A2.1');
		expect(deckLevel(COURSE, { reise: done() }, 'A1.1')).toBe('A2.1');
	});
});

describe('buildDeck', () => {
	it('deals a full deck to a newcomer from the first sub-level and the one above', () => {
		const deck = buildDeck(COURSE, {}, { random: fixed });
		expect(deck.length).toBeGreaterThan(0);
		expect(deck.every((c) => c.kind === 'fresh')).toBe(true);
		expect(deck.map((c) => c.quiz.level)).not.toContain('A2.1');
		expect(deck.map((c) => c.quiz.level)).not.toContain('B2.1');
		expect(deck[0].reason).toMatch(/first A1.1 exercise/);
	});

	it('follows the level the learner picked', () => {
		const deck = buildDeck(COURSE, {}, { level: 'A2.1', random: fixed });
		const levels = new Set(deck.map((c) => c.quiz.level));
		expect(levels.has('A2.1')).toBe(true);
		expect(levels.has('A1.2')).toBe(true); // one step back
		expect(levels.has('B1.1')).toBe(true); // one step up
		expect(levels.has('B2.1')).toBe(false); // two steps up, out of reach
		expect(levels.has('A1.1')).toBe(false);
	});

	it('mixes practise and next-step cards in with fresh ones, without repeats', () => {
		const deck = buildDeck(COURSE, { artikel: done(0.4), zahlen: done() }, { random: fixed });
		const ids = deck.map((c) => c.quiz.id);
		expect(new Set(ids).size).toBe(ids.length);
		expect(deck.find((c) => c.kind === 'practise')?.quiz.id).toBe('artikel');
		expect(deck.some((c) => c.kind === 'next')).toBe(true);
		expect(deck.some((c) => c.kind === 'fresh')).toBe(true);
	});

	it('never deals a skipped or excluded card', () => {
		const deck = buildDeck(
			COURSE,
			{},
			{ skipped: new Set(['zahlen']), exclude: new Set(['artikel']), random: fixed }
		);
		const ids = deck.map((c) => c.quiz.id);
		expect(ids).not.toContain('zahlen');
		expect(ids).not.toContain('artikel');
	});

	it('respects the size cap', () => {
		expect(buildDeck(COURSE, {}, { size: 2, random: fixed })).toHaveLength(2);
	});

	it('is empty once everything in reach is skipped', () => {
		const all = new Set(COURSE.map((q) => q.id));
		expect(buildDeck(COURSE, {}, { skipped: all, random: fixed })).toEqual([]);
	});
});
