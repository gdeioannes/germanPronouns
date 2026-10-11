import { describe, expect, it } from 'vitest';
import {
	answerSquares,
	DEAL_CHANCE,
	dealJaNein,
	JA_NEIN_CARD_ID,
	JA_NEIN_QUESTIONS,
	isPair,
	jaNeinDealSlot,
	markSeenJaNein,
	shareLine,
	PERSONAS,
	WELCOME_MINUTES,
	QUIET_HOURS,
	ROUND_LENGTH,
	scoreJaNein,
	shareText,
	whatsappHref,
	type Answer
} from './janein';

const NOW = 1_800_000_000_000;
const HOUR = 60 * 60 * 1000;

describe('the question bank', () => {
	it('is big enough that two rounds rarely repeat, and every question is short and a question', () => {
		expect(JA_NEIN_QUESTIONS.length).toBeGreaterThanOrEqual(60);
		expect(new Set(JA_NEIN_QUESTIONS.map((q) => q.de)).size).toBe(JA_NEIN_QUESTIONS.length);
		for (const q of JA_NEIN_QUESTIONS) {
			expect(q.de.endsWith('?'), q.de).toBe(true);
			expect(q.de.length, q.de).toBeLessThanOrEqual(48);
			expect(q.ja).not.toBe(q.nein);
			if (isPair(q)) {
				expect(q.de).toBe(`${q.left.de} oder ${q.right.de}?`);
				expect(q.left.de.length, q.left.de).toBeLessThanOrEqual(18);
				expect(q.right.de.length, q.right.de).toBeLessThanOrEqual(18);
			}
		}
		expect(JA_NEIN_QUESTIONS.filter(isPair).length).toBeGreaterThanOrEqual(30);
	});

	it('feeds every vibe from both a Ja and a Nein, so no answer is a dead end', () => {
		for (const vibe of Object.keys(PERSONAS)) {
			expect(JA_NEIN_QUESTIONS.some((q) => q.ja === vibe), `ja → ${vibe}`).toBe(true);
			expect(JA_NEIN_QUESTIONS.some((q) => q.nein === vibe), `nein → ${vibe}`).toBe(true);
		}
	});

	it('deals ten distinct questions', () => {
		const round = dealJaNein(() => 0.37, ROUND_LENGTH, new Set());
		expect(round).toHaveLength(ROUND_LENGTH);
		expect(new Set(round.map((q) => q.de)).size).toBe(ROUND_LENGTH);
	});

	it('deals a requested question first, even one already seen', () => {
		const want = JA_NEIN_QUESTIONS[5];
		const round = dealJaNein(() => 0.5, ROUND_LENGTH, new Set([want.de]), want);
		expect(round[0]).toBe(want);
		expect(round).toHaveLength(ROUND_LENGTH);
		expect(new Set(round.map((q) => q.de)).size).toBe(ROUND_LENGTH);
	});

	it('never repeats a question on one device until the whole bank has been asked', () => {
		let seed = 0.42;
		const random = () => (seed = (seed * 9301 + 0.49297) % 1);
		let seen = new Set<string>();
		const asked: string[] = [];
		const fullRounds = Math.floor(JA_NEIN_QUESTIONS.length / ROUND_LENGTH);
		for (let r = 0; r < fullRounds; r++) {
			const round = dealJaNein(random, ROUND_LENGTH, seen);
			for (const q of round) expect(asked, q.de).not.toContain(q.de);
			asked.push(...round.map((q) => q.de));
			seen = markSeenJaNein(round, seen);
		}
		// The tail: the few unasked ones first, then old ones fill the round, and the bank resets.
		const tail = dealJaNein(random, ROUND_LENGTH, seen);
		const unasked = JA_NEIN_QUESTIONS.filter((q) => !seen.has(q.de)).map((q) => q.de);
		for (const de of unasked) expect(tail.map((q) => q.de)).toContain(de);
		expect(markSeenJaNein(tail, seen).size).toBe(0);
	});
});

describe('scoring', () => {
	it('names the vibe the answers fed most, and the runner-up', () => {
		const qs = JA_NEIN_QUESTIONS.slice(0, 4); // wild/gem, gem/ord, ord/wild, natur/ord
		const result = scoreJaNein(qs, ['ja', 'nein', 'nein', 'nein']); // wild, ordnung, wild, ordnung
		expect(result.ja).toBe(1);
		expect(result.nein).toBe(3);
		expect(result.tally.wild).toBe(2);
		expect(result.tally.ordnung).toBe(2);
		// A tie goes to the vibe fed first: wild, on question one.
		expect(result.persona.title).toBe(PERSONAS.wild.title);
		expect(result.runnerUp?.vibe).toBe('ordnung');
	});

	it('writes a share text with every answer as a line, in order, and the link last', () => {
		const answers: Answer[] = ['ja', 'nein', 'ja'];
		const qs = JA_NEIN_QUESTIONS.slice(0, 3);
		const result = scoreJaNein(qs, answers);
		expect(answerSquares(answers)).toBe('🟩🟥🟩');
		const text = shareText(result, 'https://languagequiz.org/play/ja-nein');
		expect(text).toContain(result.persona.title);
		expect(text.startsWith('Ja oder Nein? 🇩🇪 Heute bin ich ')).toBe(true);
		expect(text.split('\n').slice(1, 4)).toEqual([`✅ ${qs[0].de}`, `❌ ${qs[1].de}`, `✅ ${qs[2].de}`]);
		const english = shareText(result, 'https://languagequiz.org/play/ja-nein', 'en');
		expect(english.startsWith("Ja oder Nein? 🇩🇪 Tonight I'm ")).toBe(true);
		expect(english.split('\n').slice(1, 4)).toEqual([`✅ ${qs[0].en}`, `❌ ${qs[1].en}`, `✅ ${qs[2].en}`]);
		expect(text.endsWith('https://languagequiz.org/play/ja-nein')).toBe(true);
		expect(whatsappHref('a b')).toBe('https://wa.me/?text=a%20b');
	});

	it('writes a this-or-that line as the chosen over the other, German or English', () => {
		const q = JA_NEIN_QUESTIONS.find((q) => q.left?.de === 'Oktoberfest')!;
		expect(shareLine(q, 'ja')).toBe('⚖️ Weihnachtsmarkt > Oktoberfest');
		expect(shareLine(q, 'nein')).toBe('⚖️ Oktoberfest > Weihnachtsmarkt');
		expect(shareLine(q, 'ja', 'en')).toBe('⚖️ Christmas market > Oktoberfest');
	});
});

describe('the deck card', () => {
	const LONG_AGO = NOW - 30 * 24 * HOUR;

	it('is a sure thing, second from the top, in the first minutes of the first visit', () => {
		expect(jaNeinDealSlot(new Set(), () => 0.99, null, NOW, NOW - (WELCOME_MINUTES - 1) * 60_000)).toBe(1);
		expect(jaNeinDealSlot(new Set(), () => 0.99, null, NOW, NOW - (WELCOME_MINUTES + 1) * 60_000)).toBeNull();
	});

	it('stays out when swiped away, or played in the last two days', () => {
		expect(jaNeinDealSlot(new Set([JA_NEIN_CARD_ID]), () => 0, null, NOW, NOW)).toBeNull();
		expect(jaNeinDealSlot(new Set(), () => 0, NOW - (QUIET_HOURS - 1) * HOUR, NOW, LONG_AGO)).toBeNull();
		expect(jaNeinDealSlot(new Set(), () => 0, NOW - (QUIET_HOURS + 1) * HOUR, NOW, LONG_AGO)).not.toBeNull();
	});

	it('is a rare coin toss later, and never the top card nor deeper than the fifth', () => {
		expect(DEAL_CHANCE).toBeLessThanOrEqual(0.2);
		expect(jaNeinDealSlot(new Set(), () => DEAL_CHANCE, null, NOW, LONG_AGO)).toBeNull();
		const rolls = [0.1, 0.99];
		expect(jaNeinDealSlot(new Set(), () => rolls.shift()!, null, NOW, LONG_AGO)).toBe(4);
		const low = [0.1, 0];
		expect(jaNeinDealSlot(new Set(), () => low.shift()!, null, NOW, LONG_AGO)).toBe(1);
	});
});
