import { describe, expect, it } from 'vitest';
import { clozeMisses, gapSentence } from './clozeReview';
import type { InlineBlank } from '$lib/content/types';

const blanks: InlineBlank[] = [
	{ kind: 'input', answer: 'der', hint: '(f) Wand', why: 'Where? Dative.' },
	{ kind: 'input', answer: 'dem', hint: '(n) Bett' },
	{ kind: 'input', answer: 'den' }
];
const template =
	'Mein Zimmer ist klein. Das Bett steht an {{0}} Wand, und über {{1}} Bett hängt ein Poster. Jetzt räume ich auf: Ich hänge die Jacke in {{2}} Schrank.';

describe('gapSentence', () => {
	it('cuts the sentence at the gap and fills the other gaps', () => {
		expect(gapSentence(template, blanks, 1)).toEqual({
			before: 'Das Bett steht an der Wand, und über',
			after: ' Bett hängt ein Poster.'
		});
	});

	it('gives the same sentence however many were asked for before', () => {
		gapSentence(template, blanks, 0);
		gapSentence(template, blanks, 2);
		expect(gapSentence(template, blanks, 1).before).toBe('Das Bett steht an der Wand, und über');
	});

	it('starts after a colon, so the line stays short', () => {
		expect(gapSentence(template, blanks, 2)).toEqual({
			before: 'Ich hänge die Jacke in',
			after: ' Schrank.'
		});
	});
});

describe('clozeMisses', () => {
	it('lists only the misses, in text order, with what was written and why', () => {
		const misses = clozeMisses(template, blanks, [' die ', 'dem', ''], [false, true, false]);
		expect(misses.map((m) => m.index)).toEqual([0, 2]);
		expect(misses[0]).toMatchObject({ given: 'die', answer: 'der', hint: '(f) Wand', why: 'Where? Dative.' });
		expect(misses[1]).toMatchObject({ given: '', answer: 'den', why: undefined });
	});
});
