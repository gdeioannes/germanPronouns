import { describe, expect, it } from 'vitest';
import type { VocabCard } from '$lib/content/types';
import {
	checkWritten,
	chooseOptions,
	fullForm,
	genderRule,
	clearsNeeded,
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

describe('gender rules', () => {
	const noun = (de: string, article: string, en = 'x'): VocabCard => ({ de, en, kind: 'noun', article, sourceQuizId: 'q' });

	it('names the ending a noun follows', () => {
		expect(genderRule(noun('Wohnung', 'die'))).toMatchObject({ ending: 'ung', article: 'die', how: 'always', follows: true });
		expect(genderRule(noun('Mädchen', 'das'))).toMatchObject({ ending: 'chen', follows: true });
		expect(genderRule(noun('Lehrer', 'der'))).toMatchObject({ ending: 'er', how: 'usually', follows: true });
	});

	it('takes the longest ending', () => {
		expect(genderRule(noun('Freiheit', 'die'))?.ending).toBe('heit');
	});

	it('marks an exception', () => {
		expect(genderRule(noun('Mutter', 'die'))).toMatchObject({ ending: 'er', article: 'der', follows: false });
		expect(genderRule(noun('Kuchen', 'der'))).toMatchObject({ ending: 'chen', follows: false });
	});

	it('judges a phrase card by its noun', () => {
		expect(genderRule(noun('schlechte Wetter', 'das'))).toMatchObject({ noun: 'Wetter', follows: false });
		expect(genderRule(noun('Bitte um', 'die'))).toMatchObject({ noun: 'Bitte', ending: 'e', follows: true });
	});

	it('stays quiet where no rule applies', () => {
		expect(genderRule(chef)).toBeNull();
		expect(genderRule(berlin)).toBeNull();
		expect(genderRule(noun('Papier', 'das'))).toBeNull();
		expect(genderRule(noun('Baum', 'der'))).toBeNull();
		expect(genderRule(noun('Geschwister', 'die', 'siblings'))).toBeNull();
		expect(genderRule(noun('Ei', 'das'))).toBeNull();
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
	it('is not weak until missed, and one slip is cleared by one right answer', () => {
		let r = EMPTY_WORD;
		expect(isWeak(r)).toBe(false);
		r = recordOutcome(r, false, 'write', new Date('2026-09-27T00:00:00Z'));
		expect(isWeak(r)).toBe(true);
		expect(r.lastWrong).toBe('2026-09-27T00:00:00.000Z');
		expect(r.mode).toBe('write');
		r = recordOutcome(r, true, 'write');
		expect(isWeak(r)).toBe(false);
		expect(r.seen).toBe(2);
		expect(r.wrong).toBe(1);
	});

	it('asks as many right in a row as the misses, up to three', () => {
		const missed = (n: number) =>
			Array.from({ length: n }).reduce<typeof EMPTY_WORD>((r) => recordOutcome(r, false, 'write'), EMPTY_WORD);
		const rightTimes = (r: typeof EMPTY_WORD, n: number) =>
			Array.from({ length: n }).reduce<typeof EMPTY_WORD>((x) => recordOutcome(x, true, 'write'), r);
		expect(clearsNeeded(missed(2))).toBe(2);
		expect(isWeak(rightTimes(missed(2), 1))).toBe(true);
		expect(isWeak(rightTimes(missed(2), 2))).toBe(false);
		expect(clearsNeeded(missed(7))).toBe(3);
		expect(isWeak(rightTimes(missed(7), 2))).toBe(true);
		expect(isWeak(rightTimes(missed(7), 3))).toBe(false);
	});
});
