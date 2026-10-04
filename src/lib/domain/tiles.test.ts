import { describe, expect, it } from 'vitest';
import type { QuizSentence } from '$lib/content/types';
import { buildableFromTiles, joinTiles, tileBank } from './tiles';

const item = (tiles: string[], acceptedAnswers: string[], sentence = 'Morgen ____.'): QuizSentence => ({
	subjectKey: 's0',
	categoryLabel: 'Verb an Position 2',
	sentence,
	acceptedAnswers,
	tiles
});

describe('joinTiles', () => {
	it('spaces words and keeps a comma on its word', () => {
		expect(joinTiles(['nicht', 'das Museum,', 'sondern'])).toBe('nicht das Museum, sondern');
	});
});

describe('buildableFromTiles', () => {
	it('lays an answer from multi-word tiles in any order', () => {
		expect(buildableFromTiles('fahre ich nach Berlin', ['ich', 'nach Berlin', 'fahre'])).toBe(true);
	});

	it('ignores case, so a capitalised answer fits lower-case tiles', () => {
		expect(buildableFromTiles('Kommst du morgen', ['morgen', 'du', 'kommst'])).toBe(true);
	});

	it('uses each tile once, but allows a repeated word on two tiles', () => {
		expect(buildableFromTiles('die die', ['die'])).toBe(false);
		expect(buildableFromTiles('die die', ['die', 'die'])).toBe(true);
	});

	it('leaves distractors unused and rejects a word that is not a tile', () => {
		expect(buildableFromTiles('ich krank bin', ['krank', 'bin', 'ich', 'ist'])).toBe(true);
		expect(buildableFromTiles('ich krank war', ['krank', 'bin', 'ich'])).toBe(false);
	});

	it('does not split a tile across a word boundary', () => {
		expect(buildableFromTiles('ein Auto', ['ein', 'Autobahn'])).toBe(false);
	});
});

describe('tileBank', () => {
	it('offers every tile once, with stable ids', () => {
		const bank = tileBank(item(['ich', 'nach Berlin', 'fahre'], ['fahre ich nach Berlin']));
		expect(bank.map((t) => t.text).sort()).toEqual(['fahre', 'ich', 'nach Berlin']);
		expect(new Set(bank.map((t) => t.id)).size).toBe(3);
	});

	it('is the same on every call — prerender and hydration agree', () => {
		const one = item(['ich', 'nach Berlin', 'fahre'], ['fahre ich nach Berlin']);
		expect(tileBank(one)).toEqual(tileBank(one));
	});

	it('never lets an answer be read left to right, even past a distractor', () => {
		for (let n = 0; n < 40; n++) {
			const three = item(['das Buch', 'meinem Bruder', 'meinen Bruder'], ['meinem Bruder das Buch'], `Satz ${n} ____.`);
			const offered = tileBank(three).map((t) => t.text);
			expect(buildableFromTiles('meinem Bruder das Buch', offered, true), offered.join(' | ')).toBe(false);
		}
	});

	it('never offers the tiles already in an answer order', () => {
		for (let n = 0; n < 40; n++) {
			const two = item(['es', 'ihr'], ['es ihr'], `Satz ${n} ____.`);
			expect(joinTiles(tileBank(two).map((t) => t.text))).not.toBe('es ihr');
		}
	});
});
