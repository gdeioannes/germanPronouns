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

const NOW = 1_800_000_000_000;
const DAY = 24 * 60 * 60 * 1000;
const done = (mistakeRate = 0, extra: Partial<QuizFacts> = {}): QuizFacts => ({
	done: true,
	tier: 'gold',
	answered: 20,
	mistakeRate,
	lastPlayedAt: NOW,
	...extra
});
const fixed = () => 0.5;
/** A deterministic pseudo-random sequence, so lottery-based tests are stable. */
function seeded(seed: number): () => number {
	let s = seed;
	return () => {
		s = (s * 1664525 + 1013904223) % 4294967296;
		return s / 4294967296;
	};
}
const opts = (extra: Partial<Parameters<typeof buildDeck>[2]> = {}) => ({ random: fixed, now: NOW, ...extra });

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
		const deck = buildDeck(COURSE, {}, opts());
		expect(deck.length).toBeGreaterThan(0);
		expect(deck.every((c) => c.kind === 'fresh')).toBe(true);
		expect(deck.map((c) => c.quiz.level)).not.toContain('A2.1');
		expect(deck.map((c) => c.quiz.level)).not.toContain('B2.1');
		expect(deck[0].reason).toMatch(/first A1.1 exercise/);
	});

	it('follows the level the learner picked', () => {
		const deck = buildDeck(COURSE, {}, opts({ level: 'A2.1' }));
		const levels = new Set(deck.map((c) => c.quiz.level));
		expect(levels.has('A2.1')).toBe(true);
		expect(levels.has('A1.2')).toBe(true); // one step back
		expect(levels.has('B1.1')).toBe(true); // one step up
		expect(levels.has('B2.1')).toBe(false); // two steps up, out of reach
		expect(levels.has('A1.1')).toBe(false);
	});

	it('mixes practise and next-step cards in with fresh ones, without repeats', () => {
		const deck = buildDeck(COURSE, { artikel: done(0.4), zahlen: done() }, opts());
		const ids = deck.map((c) => c.quiz.id);
		expect(new Set(ids).size).toBe(ids.length);
		expect(deck.some((c) => c.kind === 'practise' && c.quiz.id === 'artikel')).toBe(true);
		expect(deck.some((c) => c.kind === 'next')).toBe(true);
		expect(deck.some((c) => c.kind === 'fresh')).toBe(true);
	});

	it('never deals a skipped or excluded card', () => {
		const deck = buildDeck(
			COURSE,
			{},
			opts({ skipped: new Set(['zahlen']), exclude: new Set(['artikel']) })
		);
		const ids = deck.map((c) => c.quiz.id);
		expect(ids).not.toContain('zahlen');
		expect(ids).not.toContain('artikel');
	});

	it('respects the size cap', () => {
		expect(buildDeck(COURSE, {}, opts({ size: 2 }))).toHaveLength(2);
	});

	it('is empty once everything in reach is skipped', () => {
		const all = new Set(COURSE.map((q) => q.id));
		expect(buildDeck(COURSE, {}, opts({ skipped: all }))).toEqual([]);
	});

	it('deals about a quarter repair cards when there is enough to repair', () => {
		// 16 finished, weak or overdue A1 exercises plus plenty of fresh ones.
		const big: Quiz[] = [];
		const facts: Record<string, QuizFacts> = {};
		for (let i = 0; i < 16; i++) {
			big.push(quiz(`weak${i}`, 'fillBlank', 'A1.1', ['x']));
			facts[`weak${i}`] = done(0.5, { lastPlayedAt: NOW - 2 * DAY });
		}
		for (let i = 0; i < 20; i++) big.push(quiz(`new${i}`, 'fillBlank', 'A1.1', ['y']));
		for (let i = 0; i < 20; i++) big.push(quiz(`up${i}`, 'listening', 'A1.2', ['z']));
		const deck = buildDeck(big, facts, { random: seeded(7), now: NOW, size: 12 });
		const repair = deck.filter((c) => c.kind === 'practise' || c.kind === 'review').length;
		expect(repair).toBe(3);
		expect(deck.filter((c) => c.kind === 'fresh').length).toBeGreaterThanOrEqual(6);
		// Repair cards are spread through the deck, not stacked at the front.
		const positions = deck.flatMap((c, i) => (c.kind === 'fresh' ? [] : [i]));
		expect(Math.max(...positions) - Math.min(...positions)).toBeGreaterThanOrEqual(6);
	});

	it('brings back a gold exercise only once its review interval has passed', () => {
		const fresh = buildDeck(COURSE, { zahlen: done(0, { lastPlayedAt: NOW - 3 * DAY }) }, opts());
		expect(fresh.find((c) => c.quiz.id === 'zahlen')?.kind).toBeUndefined();
		const due = buildDeck(COURSE, { zahlen: done(0, { lastPlayedAt: NOW - 20 * DAY }) }, opts());
		expect(due.find((c) => c.quiz.id === 'zahlen')?.kind).toBe('review');
	});

	it('does not deal the same fresh order every time', () => {
		const many = Array.from({ length: 30 }, (_, i) => quiz(`q${i}`, 'fillBlank', 'A1.1'));
		const a = buildDeck(many, {}, { random: seeded(1), now: NOW }).map((c) => c.quiz.id);
		const b = buildDeck(many, {}, { random: seeded(2), now: NOW }).map((c) => c.quiz.id);
		expect(a).not.toEqual(b);
	});

	it("leans on the learner's own level, with a taste of the one above", () => {
		const many: Quiz[] = [];
		for (const lv of ['A1.1', 'A1.2', 'A2.1']) {
			for (let i = 0; i < 30; i++) many.push(quiz(`${lv}-${i}`, 'fillBlank', lv));
		}
		const tally = { 'A1.1': 0, 'A1.2': 0, 'A2.1': 0 };
		for (let seed = 0; seed < 40; seed++) {
			for (const c of buildDeck(many, {}, { level: 'A1.2', random: seeded(seed), now: NOW })) {
				tally[c.quiz.level as keyof typeof tally]++;
			}
		}
		expect(tally['A1.2']).toBeGreaterThan(tally['A2.1']);
		expect(tally['A2.1']).toBeGreaterThan(tally['A1.1']);
	});
});
