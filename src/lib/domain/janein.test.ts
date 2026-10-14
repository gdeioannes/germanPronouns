import { afterEach, describe, expect, it } from 'vitest';
import {
	answerSquares,
	DEAL_CHANCE,
	JA_NEIN_CARD_ID,
	isPair,
	jaNeinDealSlot,
	newWallet,
	refillWallet,
	REFILL_HOURS,
	shareLine,
	shareText,
	TICKET_CAP,
	ticketWinChance,
	whatsappHref,
	WIN_CHANCE,
	type Answer
} from './janein';
import {
	ALL_QUESTIONS,
	collectionCount,
	collectionShareText,
	earnPersona,
	JA_NEIN_CATEGORIES,
	markRoundPlayed,
	nextRound,
	personaKey,
	ROUND_LENGTH,
	ROUND_ORDER,
	scoreRound,
	shuffled
} from './janeinRounds';

const NOW = 1_800_000_000_000;
const HOUR = 60 * 60 * 1000;

// A Map-backed localStorage: the wallet, the played list and the shelf live there.
const store = new Map<string, string>();
Object.defineProperty(globalThis, 'localStorage', {
	configurable: true,
	value: {
		getItem: (k: string) => store.get(k) ?? null,
		setItem: (k: string, v: string) => store.set(k, v),
		removeItem: (k: string) => store.delete(k),
		clear: () => store.clear()
	}
});
afterEach(() => store.clear());

describe('the shelves', () => {
	it('are ten categories of ten rounds of eight, each with five personas of its own', () => {
		expect(JA_NEIN_CATEGORIES).toHaveLength(10);
		expect(ROUND_ORDER).toHaveLength(100);
		expect(ALL_QUESTIONS).toHaveLength(800);
		for (const c of JA_NEIN_CATEGORIES) {
			expect(c.personas, c.id).toHaveLength(5);
			expect(c.rounds, c.id).toHaveLength(10);
			const vibes = new Set(c.personas.map((p) => p.id));
			for (const r of c.rounds) {
				expect(r.questions, r.key).toHaveLength(ROUND_LENGTH);
				expect(new Set(r.questions.map((q) => q.de)).size, r.key).toBe(ROUND_LENGTH);
				for (const q of r.questions) {
					expect(q.de.endsWith('?'), q.de).toBe(true);
					expect(q.de.length, q.de).toBeLessThanOrEqual(48);
					expect(q.ja, q.de).not.toBe(q.nein);
					expect(vibes.has(q.ja) && vibes.has(q.nein), `${r.key}: ${q.de}`).toBe(true);
					if (isPair(q)) expect(q.de).toBe(`${q.left.de} oder ${q.right.de}?`);
				}
			}
			// every persona reachable from a Ja and from a Nein
			for (const v of vibes) {
				const qs = c.rounds.flatMap((r) => r.questions);
				expect(qs.some((q) => q.ja === v), `${c.id} ja → ${v}`).toBe(true);
				expect(qs.some((q) => q.nein === v), `${c.id} nein → ${v}`).toBe(true);
			}
		}
	});

	it('deals the rounds round-robin across the shelves, the classics first, and starts over when all are played', () => {
		expect(ROUND_ORDER[0].categoryId).toBe('typisch');
		const firstTen = ROUND_ORDER.slice(0, 10).map((r) => r.categoryId);
		expect(new Set(firstTen).size).toBe(10);
		expect(nextRound([])).toBe(ROUND_ORDER[0]);
		expect(nextRound([ROUND_ORDER[0].key])).toBe(ROUND_ORDER[1]);
		// all played: the one played longest ago comes back first
		const all = ROUND_ORDER.map((r) => r.key);
		expect(nextRound([...all.slice(1), all[0]])).toBe(ROUND_ORDER[1]);
		// the played list persists and dedupes
		expect(markRoundPlayed('a', ['a', 'b'])).toEqual(['b', 'a']);
		expect(JSON.parse(store.get('janein_played')!)).toEqual(['b', 'a']);
	});

	it('shuffles a round without losing or doubling a question', () => {
		const r = ROUND_ORDER[3];
		const qs = shuffled(r, () => 0.7);
		expect(qs).toHaveLength(ROUND_LENGTH);
		expect(new Set(qs)).toEqual(new Set(r.questions));
	});
});

describe('scoring', () => {
	const round = ROUND_ORDER[0];
	const qs = round.questions;

	it('names the persona the answers fed most, and the runner-up, ties to the first fed', () => {
		const answers: Answer[] = qs.map(() => 'ja');
		const result = scoreRound(round, qs, answers);
		expect(result.ja).toBe(ROUND_LENGTH);
		expect(result.nein).toBe(0);
		const fed = qs.map((q) => q.ja);
		const counts = Object.fromEntries(round.questions.map((q) => [q.ja, 0]));
		for (const v of fed) counts[v]++;
		const max = Math.max(...Object.values(counts));
		expect(result.tally[result.persona.id]).toBe(max);
		// tie-break: of the top vibes, the one fed first
		const top = fed.find((v) => counts[v] === max);
		expect(result.persona.id).toBe(top);
		expect(result.category.personas.map((p) => p.id)).toContain(result.persona.id);
	});

	it('writes a share text with the round, every answer as a line, in order, and the link last', () => {
		const answers: Answer[] = ['ja', 'nein', 'ja'];
		const three = qs.slice(0, 3);
		const result = scoreRound(round, three, answers);
		expect(answerSquares(answers)).toBe('🟩🟥🟩');
		const text = shareText(result, 'https://languagequiz.org/play/ja-nein');
		expect(text).toContain(result.persona.title);
		expect(text.startsWith(`Ja oder Nein? · ${round.title} 🇩🇪 Heute bin ich `)).toBe(true);
		expect(text.split('\n').slice(1, 4)).toEqual(three.map((q, i) => shareLine(q, answers[i])));
		const english = shareText(result, 'https://languagequiz.org/play/ja-nein', 'en');
		expect(english).toContain("🇩🇪 Tonight I'm ");
		expect(text.split('\n').slice(-2)).toEqual(['Und du? Gleiche Fragen:', 'https://languagequiz.org/play/ja-nein']);
		expect(english.split('\n').at(-2)).toBe('Your turn, same questions:');
		expect(whatsappHref('a b')).toBe('https://wa.me/?text=a%20b');
	});

	it('writes a this-or-that line as the chosen over the other, German or English', () => {
		const q = ALL_QUESTIONS.find((q) => q.left?.de === 'Oktoberfest' && q.right?.de === 'Weihnachtsmarkt')!;
		expect(q).toBeDefined();
		expect(shareLine(q, 'ja')).toBe('⚖️ Weihnachtsmarkt > Oktoberfest');
		expect(shareLine(q, 'nein')).toBe('⚖️ Oktoberfest > Weihnachtsmarkt');
		expect(shareLine(q, 'ja', 'en')).toBe('⚖️ Christmas market > Oktoberfest');
		const plain = qs.find((q) => !isPair(q))!;
		expect(shareLine(plain, 'nein')).toBe(`❌ ${plain.de}`);
	});
});

describe('the collection', () => {
	it('shelves a persona once, counts it, and sends the whole grid', () => {
		const round = ROUND_ORDER[0];
		const result = scoreRound(round, round.questions, round.questions.map(() => 'ja' as Answer));
		expect(collectionCount()).toEqual({ earned: 0, total: 50 });
		expect(earnPersona(result, new Date('2026-10-14T10:00:00Z'))).toBe(true);
		expect(earnPersona(result)).toBe(false);
		expect(collectionCount()).toEqual({ earned: 1, total: 50 });
		expect(JSON.parse(store.get('janein_personas')!)[personaKey(round.categoryId, result.persona.id)]).toBe('2026-10-14');
		const text = collectionShareText('https://languagequiz.org/play/ja-nein/personas');
		const lines = text.split('\n');
		expect(lines[0]).toBe('Ja oder Nein? 🇩🇪 Meine Personas: 1 von 50');
		expect(lines).toHaveLength(12);
		expect(lines.slice(1, 11).join('')).toContain('🟪');
		expect((text.match(/⬜/g) ?? []).length).toBe(49);
		expect(lines[11]).toBe('https://languagequiz.org/play/ja-nein/personas');
	});
});

describe('tickets', () => {
	it('starts with one, and a free one arrives every twelve hours up to a pocket of two', () => {
		const w = newWallet(NOW);
		expect(w.tickets).toBe(1);
		expect(refillWallet(w, NOW + (REFILL_HOURS - 1) * HOUR).tickets).toBe(1);
		expect(refillWallet(w, NOW + (REFILL_HOURS + 1) * HOUR).tickets).toBe(2);
		// a week away does not bank a week of refills
		const full = refillWallet(w, NOW + 7 * 24 * HOUR);
		expect(full.tickets).toBe(TICKET_CAP);
		expect(TICKET_CAP).toBe(2);
		// at the cap the clock waits: spend one and the next is twelve hours off
		expect(refillWallet({ ...full, tickets: 1 }, NOW + 7 * 24 * HOUR + HOUR).tickets).toBe(1);
	});

	it('is won by a pass at a quarter with an empty pocket, an eighth with one, never at the cap', () => {
		expect(ticketWinChance(false, 0)).toBe(0);
		expect(ticketWinChance(true, 0)).toBe(1 / 4);
		expect(ticketWinChance(true, 1)).toBe(1 / 8);
		expect(ticketWinChance(true, TICKET_CAP)).toBe(0);
		expect(WIN_CHANCE.length).toBe(TICKET_CAP);
	});
});

describe('the deck card', () => {
	const pocket = (tickets: number, sureDeal = false) => ({ tickets, refillAt: NOW + HOUR, sureDeal });

	it('is a sure thing, second from the top, for the very first ticket', () => {
		expect(jaNeinDealSlot(new Set(), () => 0.99, pocket(1, true))).toBe(1);
	});

	it('stays out without a ticket, or when swiped away', () => {
		expect(jaNeinDealSlot(new Set(), () => 0, pocket(0, true))).toBeNull();
		expect(jaNeinDealSlot(new Set(), () => 0, pocket(0))).toBeNull();
		expect(jaNeinDealSlot(new Set([JA_NEIN_CARD_ID]), () => 0, pocket(2, true))).toBeNull();
	});

	it('is a coin toss with a ticket in the pocket, and never the top card nor deeper than the fifth', () => {
		expect(DEAL_CHANCE).toBe(0.3);
		expect(jaNeinDealSlot(new Set(), () => DEAL_CHANCE, pocket(1))).toBeNull();
		const rolls = [0.1, 0.99];
		expect(jaNeinDealSlot(new Set(), () => rolls.shift()!, pocket(1))).toBe(4);
		const low = [0.1, 0];
		expect(jaNeinDealSlot(new Set(), () => low.shift()!, pocket(2))).toBe(1);
	});
});
