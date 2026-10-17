import { describe, expect, it } from 'vitest';
import { pickSurprise, SURPRISE_BOOST_CHANCE, SURPRISE_CHANCE, surpriseChance, type SurpriseCandidate } from './surprise';

const all: SurpriseCandidate<string>[] = [
	{ kind: 'story', card: 'S' },
	{ kind: 'song', card: 'M' },
	{ kind: 'play', card: 'J' },
	{ kind: 'chat', card: 'C' }
];
const seq = (...n: number[]) => () => n.shift() ?? 0;

describe('the deck surprise', () => {
	it('one roll decides whether a hand gets one at all', () => {
		expect(pickSurprise(all, SURPRISE_CHANCE, seq(SURPRISE_CHANCE))).toBeNull();
		expect(pickSurprise(all, SURPRISE_CHANCE, seq(0, 0, 0))).not.toBeNull();
	});
	it('then one kind, among the kinds that have something to offer', () => {
		expect(pickSurprise(all, 1, seq(0, 0.99, 0))?.kind).toBe('chat');
		expect(pickSurprise(all, 1, seq(0, 0.3, 0))?.kind).toBe('song');
		const onlyStories: SurpriseCandidate<string>[] = [
			{ kind: 'story', card: 'S' },
			{ kind: 'song', card: null },
			{ kind: 'play', card: null },
			{ kind: 'chat', card: null }
		];
		expect(pickSurprise(onlyStories, 1, seq(0, 0.99, 0))?.kind).toBe('story');
	});
	it('nothing on offer: no surprise, whatever the roll', () => {
		expect(pickSurprise(all.map((c) => ({ ...c, card: null })), 1, seq(0))).toBeNull();
	});
	it('goes from the second to the fifth card', () => {
		expect(pickSurprise(all, 1, seq(0, 0, 0))?.slot).toBe(1);
		expect(pickSurprise(all, 1, seq(0, 0, 0.99))?.slot).toBe(4);
	});
	it('the very first one is sure, and prefers the story', () => {
		expect(surpriseChance(true, false)).toBe(1);
		expect(pickSurprise(all, 1, seq(0, 0.99, 0), true)?.kind).toBe('story');
	});
	it('a passed run makes the next hand likelier to hold one', () => {
		expect(surpriseChance(false, true)).toBe(SURPRISE_BOOST_CHANCE);
		expect(surpriseChance(false, false)).toBe(SURPRISE_CHANCE);
		expect(SURPRISE_BOOST_CHANCE).toBeGreaterThan(SURPRISE_CHANCE);
	});
});
