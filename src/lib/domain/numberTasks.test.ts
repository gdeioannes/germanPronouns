import { describe, expect, it } from 'vitest';
import barJson from '$content/tasks/order_the_round.json';
import ubahnJson from '$content/tasks/last_ubahn.json';
import { BAR_ROUNDS, countAfterTap, handsFor, planBarRounds, wrongOrderLine, type BarTaskContent } from './barTask';
import { planUbahnRounds, signsFor, UBAHN_KINDS, type UbahnTaskContent } from './ubahnTask';

const bar = barJson as BarTaskContent;
const ubahn = ubahnJson as UbahnTaskContent;
const WORDS = ['null', 'eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun', 'zehn'];

describe('handsFor', () => {
	it('counts from the thumb and fills the first hand first', () => {
		expect(handsFor(1)).toEqual([[true, false, false, false, false], [false, false, false, false, false]]);
		expect(handsFor(6)[0].every(Boolean)).toBe(true);
		expect(handsFor(6)[1]).toEqual([true, false, false, false, false]);
		expect(handsFor(10).flat().every(Boolean)).toBe(true);
		expect(handsFor(0).flat().some(Boolean)).toBe(false);
	});
});

describe('countAfterTap', () => {
	it('shows the count a finger stands for, and folds the top finger on a second tap', () => {
		expect(countAfterTap(0, 0, 0)).toBe(1);
		expect(countAfterTap(1, 0, 3)).toBe(4);
		expect(countAfterTap(4, 0, 3)).toBe(3);
		expect(countAfterTap(3, 1, 1)).toBe(7);
	});
});

describe('order the round content', () => {
	it('the friends can shout every count from one to ten, each naming only its own number', () => {
		expect(bar.calls.map((c) => c.count)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
		for (const c of bar.calls) {
			const line = c.clip.de.toLowerCase();
			// Before a noun the one is the article: ein Bier, never eins Bier.
			expect(line).toContain(c.count === 1 ? "ein bier" : WORDS[c.count]);
			for (const [n, w] of WORDS.entries()) if (n !== c.count && n > 0) expect(line).not.toContain(w);
		}
	});

	it('plans rising orders that end on ten, different every night', () => {
		let seed = 0.13;
		const random = () => (seed = (seed * 9301 + 0.49297) % 1);
		const rounds = planBarRounds(bar, random);
		expect(rounds).toHaveLength(BAR_ROUNDS);
		expect(rounds.at(-1)!.answer).toBe(10);
		const counts = rounds.map((r) => r.answer);
		expect([...counts].sort((a, b) => a - b)).toEqual(counts);
		expect(new Set(counts).size).toBe(counts.length);
		expect(planBarRounds(bar, () => 0).map((r) => r.answer)).toEqual([1, 2, 3, 4, 10]);
		expect(planBarRounds(bar, () => 0.999).map((r) => r.answer)).toEqual([6, 7, 8, 9, 10]);
	});

	it('the bartender can confirm every count from one to ten', () => {
		expect(bar.bartender.map((b) => b.count)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
		for (const b of bar.bartender.slice(1)) expect(b.de.toLowerCase()).toContain(WORDS[b.count]);
	});

	it('picks the short or the over joke and splices the count in', () => {
		expect(wrongOrderLine(bar, 3, 5, 0)).toBe(bar.tooFew[0].replace('{n}', '3'));
		expect(wrongOrderLine(bar, 8, 5, 0)).toBe(bar.tooMany[0].replace('{n}', '8'));
		expect(wrongOrderLine(bar, 8, 5, 1)).toBe(bar.tooMany[1]);
	});
});

describe('last U-Bahn content', () => {
	it('has every kind of announcement for every platform, each saying its platform', () => {
		for (const platform of ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']) {
			for (const kind of ['plain', 'change', 'last']) {
				const a = ubahn.announcements.find((x) => x.platform === platform && x.kind === kind)!;
				expect(a, `${kind} ${platform}`).toBeDefined();
				expect(a.clip.de.toLowerCase()).toContain(`gleis ${WORDS[Number(platform)]}`);
			}
		}
	});

	it('plans one train per kind on distinct platforms, answer among the signs', () => {
		const rounds = planUbahnRounds(ubahn);
		expect(rounds).toHaveLength(UBAHN_KINDS.length);
		expect(new Set(rounds.map((r) => r.answer)).size).toBe(rounds.length);
		rounds.forEach((round, i) => {
			expect(round.options).toContain(round.answer);
			expect(round.options).toHaveLength(3);
			expect(round.clip.audio.startsWith(`task_ubahn_${{ plain: 'p', change: 'w', last: 'l' }[UBAHN_KINDS[i]]}`)).toBe(true);
		});
		expect(signsFor('2')).toEqual(['1', '2', '3']);
		expect(signsFor('10')).toEqual(['6', '9', '10']);
	});
});
