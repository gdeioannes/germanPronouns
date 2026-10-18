// The fill-in medal ladder: the choices, the cue the gold step drops, and the
// sentences it draws on.
import { describe, expect, it } from 'vitest';
import type { QuizSentence } from '$lib/content/types';
import { choicesFor, goldSentence, MIN_HARD_POOL, stepPool } from './fillLadder';
import { answerTileIds } from './tiles';

const s = (sentence: string, answer: string, extra: Partial<QuizSentence> = {}): QuizSentence => ({
	subjectKey: 's0',
	categoryLabel: 'Verb',
	sentence,
	acceptedAnswers: [answer],
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
