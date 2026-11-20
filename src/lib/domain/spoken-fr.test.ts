// French noun templates (spoken.ts frenchLine): article, gender pairs, elision, plural.
import { describe, expect, it } from 'vitest';
import { frenchLine } from './spoken';

describe('frenchLine', () => {
	it('takes the article and gender from the noun', () => {
		expect(frenchLine("C'est {a} {subject}.", 'une table')).toBe("C'est une table.");
		expect(frenchLine("Ce n'est pas {a} {subject}.", 'un homme')).toBe("Ce n'est pas un homme.");
		expect(frenchLine('{Le/La} {subject} est ici.', 'une table')).toBe('La table est ici.');
		expect(frenchLine("C'est {mon/ma} {subject}.", 'une voiture')).toBe("C'est ma voiture.");
	});
	it('elides before a vowel', () => {
		expect(frenchLine('{Le/La} {subject} est ici.', 'un enfant')).toBe("L'enfant est ici.");
		expect(frenchLine("C'est {mon/ma} {subject}.", 'une amie')).toBe("C'est mon amie.");
	});
	it('makes plurals, or takes the given one', () => {
		expect(frenchLine('Je vois deux {pl}.', 'une pomme')).toBe('Je vois deux pommes.');
		expect(frenchLine('Je vois deux {pl}.', 'un gâteau')).toBe('Je vois deux gâteaux.');
		expect(frenchLine('Je vois deux {pl}.', 'un journal')).toBe('Je vois deux journaux.');
		expect(frenchLine('Je vois deux {pl}.', 'une nouvelle table|nouvelles tables')).toBe('Je vois deux nouvelles tables.');
	});
	it('uses a word without article as it is', () => {
		expect(frenchLine('{subject} : hier, impossible de venir.', 'je')).toBe('je : hier, impossible de venir.');
	});
});
