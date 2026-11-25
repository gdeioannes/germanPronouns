// The fill-in medal ladder: the choices, the cue the gold step drops, and the
// sentences it draws on.
import { describe, expect, it } from 'vitest';
import type { QuizSentence } from '$lib/content/types';
import { choicesFor, cueParts, goldSentence, MIN_HARD_POOL, stepPool } from './fillLadder';
import { answerTileIds } from './tiles';

const s = (sentence: string, answer: string, extra: Partial<QuizSentence> = {}): QuizSentence => ({
	subjectKey: 's0',
	categoryLabel: 'Verb',
	sentence,
	acceptedAnswers: [answer],
	english: 'An English line.',
	...extra
});

describe('choices', () => {
	it('uses the authored wrong options, with the answer among the four', () => {
		const item = s('Ich ____ gestern gekommen. (sein)', 'bin', { options: ['habe', 'war', 'ist'] });
		const choices = choicesFor(item, [item]);
		expect([...choices].sort()).toEqual(['bin', 'habe', 'ist', 'war']);
		expect(choicesFor(item, [item])).toEqual(choices); // seeded: stable
	});

	it('falls back to the drill’s other answers, same category first, never a right one', () => {
		const pool = [
			s('____ Hund', 'der', { categoryLabel: 'Artikel', acceptedAnswers: ['der'] }),
			s('____ Katze', 'die', { categoryLabel: 'Artikel' }),
			s('____ Haus', 'das', { categoryLabel: 'Artikel' }),
			s('____ Mann', 'der', { categoryLabel: 'Artikel' }),
			s('ich ____', 'bin', { categoryLabel: 'Verb' })
		];
		const choices = choicesFor(pool[1], pool);
		expect(choices).toContain('die');
		expect(choices.filter((c) => c === 'die')).toHaveLength(1);
		expect(new Set(choices).size).toBe(choices.length);
		expect(choices).toEqual(expect.arrayContaining(['der', 'das']));
	});

	it('keeps a two-gap answer’s shape', () => {
		const item = s('Er ____ gestern ____. (gehen)', 'ist … gegangen', {
			options: ['hat … gegangen', 'ist … gegeht', 'war … gegangen']
		});
		expect(choicesFor(item, [item])).toContain('ist … gegangen');
		expect(choicesFor(item, [item])).toHaveLength(4);
	});
});

describe('the no-help step', () => {
	it('drops the trailing cue, unless it must stay', () => {
		expect(goldSentence(s('Wir ____ nach Berlin. (fahren)', 'fahren'))).toBe('Wir ____ nach Berlin.');
		expect(goldSentence(s('____ Sie Deutsch? (formal)', 'Sprechen', { keepCue: true }))).toBe(
			'____ Sie Deutsch? (formal)'
		);
		expect(goldSentence(s('Ein Satz (mit Klammer) ____ hier.', 'steht'))).toBe(
			'Ein Satz (mit Klammer) ____ hier.'
		);
	});

	it('drops a cue with a bracket inside it', () => {
		expect(goldSentence(s('Das ist ____ . (der Tisch (neu))', 'ein neuer Tisch'))).toBe('Das ist ____ .');
	});

	it('keeps the cue when there is no English line: it is the only question there is', () => {
		expect(goldSentence(s('Ich sehe zwei ____ . (der Hund)', 'Hunde', { english: undefined }))).toBe(
			'Ich sehe zwei ____ . (der Hund)'
		);
	});

	it('draws on the hard sentences once there are enough of them', () => {
		const easy = Array.from({ length: 20 }, (_, i) => s(`e${i} ____`, 'x'));
		const hard = Array.from({ length: MIN_HARD_POOL }, (_, i) => s(`h${i} ____`, 'x', { hard: true }));
		expect(stepPool([...easy, ...hard], 2)).toEqual(hard);
		expect(stepPool([...easy, ...hard.slice(1)], 2)).toHaveLength(29);
		expect(stepPool([...easy, ...hard], 1)).toHaveLength(30);
	});
});

describe('word tiles on the choose step', () => {
	it('offers only the tiles the answer needs', () => {
		const item = s('Ich bleibe zu Hause, ____.', 'weil ich müde bin', {
			tiles: ['bin', 'weil', 'müde', 'ich', 'habe', 'denn']
		});
		expect([...answerTileIds(item)].sort()).toEqual([0, 1, 2, 3]);
	});
});

describe('cueParts', () => {
	// A stand-in dictionary: "be" is in it, as the letter Be is in the real one.
	const german = new Set(['Er', 'spricht', 'langsam', 'be', 'die', 'hohen', 'Kosten', 'wiederholen', 'sein']);
	const known = (w: string) => german.has(w);
	const plain = (run: string) =>
		cueParts(run, known)
			.filter((p) => !p.german)
			.map((p) => p.text)
			.join('');

	it('keeps an English cue out of word help, even a word the dictionary knows', () => {
		const parts = cueParts('. (be understood better)', known);
		expect(parts.map((p) => p.text).join('')).toBe('. (be understood better)');
		expect(parts.find((p) => p.text.includes('be '))?.german).toBe(false);
	});

	it('leaves a German cue to word help', () => {
		expect(cueParts(' (wiederholen)', known).find((p) => p.text === 'wiederholen')?.german).toBe(true);
	});

	it('splits a mixed cue at its separators', () => {
		const parts = cueParts(' (despite: die hohen Kosten)', known);
		expect(parts.find((p) => p.text === 'despite')?.german).toBe(false);
		expect(parts.find((p) => p.text.includes('Kosten'))?.german).toBe(true);
		expect(plain(' (sein, now)')).toContain('now');
	});

	it('leaves a run with no cue whole', () => {
		expect(cueParts('Er spricht langsam, ', known)).toEqual([{ text: 'Er spricht langsam, ', german: true }]);
	});
});
