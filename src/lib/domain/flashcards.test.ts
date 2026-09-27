import { describe, expect, it } from 'vitest';
import type { VocabCard } from '$lib/content/types';
import {
	checkWritten,
	chooseOptions,
	fullForm,
	isWeak,
	recordOutcome,
	EMPTY_WORD
} from './flashcards';

const stelle: VocabCard = { de: 'Stelle', en: 'job', kind: 'noun', article: 'die', sourceQuizId: 'q' };
const vertrag: VocabCard = { de: 'Vertrag', en: 'contract', kind: 'noun', article: 'der', sourceQuizId: 'q' };
const betrag: VocabCard = { de: 'Betrag', en: 'amount', kind: 'noun', article: 'der', sourceQuizId: 'q' };
const gehalt: VocabCard = { de: 'Gehalt', en: 'salary', kind: 'noun', article: 'das', sourceQuizId: 'q' };
const chef: VocabCard = { de: 'Chef', en: 'boss', kind: 'noun', article: 'der', sourceQuizId: 'q' };
const berlin: VocabCard = { de: 'Berlin', en: 'Berlin', kind: 'name', sourceQuizId: 'q' };
const arbeiten: VocabCard = { de: 'arbeiten', en: 'to work', kind: 'word', sourceQuizId: 'q' };
const aepfel: VocabCard = { de: 'Äpfel', en: 'apples', kind: 'noun', article: 'die', sourceQuizId: 'q' };

describe('written answers', () => {
	it('always wants the article on a noun', () => {
		expect(fullForm(stelle)).toBe('die Stelle');
		expect(checkWritten('die Stelle', stelle, true)).toEqual({ correct: true, missingArticle: false });
		expect(checkWritten('Stelle', stelle, true)).toEqual({ correct: false, missingArticle: true });
		expect(checkWritten('der Stelle', stelle, true)).toEqual({ correct: false, missingArticle: false });
	});

	it('takes a name or a plain word without one', () => {
		expect(fullForm(berlin)).toBe('Berlin');
		expect(checkWritten('berlin', berlin, true).correct).toBe(true);
		expect(checkWritten('arbeiten', arbeiten, true).correct).toBe(true);
	});

	it('accepts a listed synonym', () => {
		const angry: VocabCard = { de: 'verärgert', en: 'annoyed', kind: 'word', also: ['ungehalten'], sourceQuizId: 'q' };
		expect(checkWritten('ungehalten', angry, true).correct).toBe(true);
		const post: VocabCard = { de: 'Stelle', en: 'post', kind: 'noun', article: 'die', also: ['die Position'], sourceQuizId: 'q' };
		expect(checkWritten('die Position', post, true).correct).toBe(true);
		expect(checkWritten('Position', post, true).correct).toBe(false);
	});

	it('is umlaut-strict even in relaxed mode', () => {
		expect(checkWritten('die Apfel', aepfel, true).correct).toBe(false);
		expect(checkWritten('die Äpfel.', aepfel, true).correct).toBe(true);
	});
});

describe('choose-mode options', () => {
	const deck = [stelle, vertrag, betrag, gehalt, chef, berlin, arbeiten];

	it('offers four distinct options including the answer', () => {
		const options = chooseOptions(vertrag, deck, () => 0.3);
		expect(options).toHaveLength(4);
		expect(new Set(options).size).toBe(4);
		expect(options).toContain('der Vertrag');
	});

	it('prefers distractors of the same gender', () => {
		const options = chooseOptions(vertrag, deck, () => 0.3);
		expect(options).toContain('der Betrag');
		expect(options).toContain('der Chef');
		expect(options).not.toContain('Berlin');
	});

	it('falls back to other kinds when the deck is small', () => {
		const options = chooseOptions(berlin, [berlin, stelle, arbeiten, chef], () => 0.5);
		expect(options).toHaveLength(4);
	});
});

describe('weak words', () => {
	it('is not weak until missed, and clears after three in a row', () => {
		let r = EMPTY_WORD;
		expect(isWeak(r)).toBe(false);
		r = recordOutcome(r, false, 'write', new Date('2026-09-27T00:00:00Z'));
		expect(isWeak(r)).toBe(true);
		expect(r.lastWrong).toBe('2026-09-27T00:00:00.000Z');
		expect(r.mode).toBe('write');
		r = recordOutcome(r, true, 'write');
		r = recordOutcome(r, true, 'write');
		expect(isWeak(r)).toBe(true);
		r = recordOutcome(r, true, 'write');
		expect(isWeak(r)).toBe(false);
		expect(r.seen).toBe(4);
		expect(r.wrong).toBe(1);
	});
});
