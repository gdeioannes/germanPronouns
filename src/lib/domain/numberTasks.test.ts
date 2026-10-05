import { describe, expect, it } from 'vitest';
import barJson from '$content/tasks/order_the_round.json';
import ubahnJson from '$content/tasks/last_ubahn.json';
import { countAfterTap, handsFor, wrongOrderLine, type BarTaskContent } from './barTask';
import type { UbahnTaskContent } from './ubahnTask';

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
	it('every friend line names the number the round wants', () => {
		for (const round of bar.rounds) expect(round.clip.de.toLowerCase()).toContain(WORDS[round.answer]);
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
	it('each announcement says its platform, and the answer is among the signs', () => {
		for (const round of ubahn.rounds) {
			expect(round.options).toContain(round.answer);
			expect(round.clip.de.toLowerCase()).toContain(`gleis ${WORDS[Number(round.answer)]}`);
		}
	});
});
