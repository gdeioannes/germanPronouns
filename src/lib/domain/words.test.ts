import { describe, expect, it } from 'vitest';
import { caseTable, dativePlural, exampleSentence, pluralForm, wordSlug } from './words';

describe('word pages', () => {
	it('slugs umlauts and sharp s to ASCII', () => {
		expect(wordSlug('Käse')).toBe('kaese');
		expect(wordSlug('Straße')).toBe('strasse');
		expect(wordSlug('Öl')).toBe('oel');
		expect(wordSlug('Frühstück')).toBe('fruehstueck');
	});

	it('spells the plural out from the dictionary notation', () => {
		expect(pluralForm('Topf', '¨-e')).toBe('Töpfe');
		expect(pluralForm('Apfel', '¨-')).toBe('Äpfel');
		expect(pluralForm('Haus', '¨-er')).toBe('Häuser');
		expect(pluralForm('Baum', '¨-e')).toBe('Bäume');
		expect(pluralForm('Kind', '-er')).toBe('Kinder');
		expect(pluralForm('Lehrerin', '-nen')).toBe('Lehrerinnen');
		expect(pluralForm('Auto', '-s')).toBe('Autos');
		expect(pluralForm('Lehrer', '-')).toBe('Lehrer');
		expect(pluralForm('Museum', 'Museen')).toBe('Museen');
		expect(pluralForm('Milch', '—')).toBeNull();
		expect(pluralForm('Milch', undefined)).toBeNull();
	});

	it('adds -n in the dative plural unless it already ends in n or s', () => {
		expect(dativePlural('Töpfe')).toBe('Töpfen');
		expect(dativePlural('Frauen')).toBe('Frauen');
		expect(dativePlural('Autos')).toBe('Autos');
	});

	it('fills the example sentence with the capitalised article', () => {
		expect(
			exampleSentence({ noun: 'Topf', gender: 'm', english: 'pot', categories: [], sentence: '____ Topf steht auf dem Herd.' })
		).toBe('Der Topf steht auf dem Herd.');
	});

	it('gives a case table only to nouns whose singular is safe to decline', () => {
		const apfel = caseTable({ noun: 'Apfel', gender: 'm', english: 'apple', categories: [], declensionSafe: true, plural: '¨-' });
		expect(apfel?.map((r) => r.singular)).toEqual(['der Apfel', 'den Apfel', 'dem Apfel']);
		expect(apfel?.map((r) => r.plural)).toEqual(['die Äpfel', 'die Äpfel', 'den Äpfeln']);
		expect(caseTable({ noun: 'Junge', gender: 'm', english: 'boy', categories: [], declensionSafe: false, plural: '-n' })).toBeNull();
	});
});
