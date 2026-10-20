import { afterEach, describe, expect, it } from 'vitest';
import {
	answerSquares,
	decodeAnswers,
	encodeAnswers,
	isPair,
	mixBar,
	plainText,
	shareLine,
	shareText,
	whatsappHref,
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
	resultStats,
	ROUND_LENGTH,
	ROUND_ORDER,
	scoreRound,
	shuffled
} from './janeinRounds';


// A Map-backed localStorage: the played list and the shelf live there.
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
	it('are ten themes of ten rounds of twelve, each with five personas of its own', () => {
		expect(JA_NEIN_CATEGORIES).toHaveLength(10);
		expect(ROUND_ORDER).toHaveLength(100);
		expect(ALL_QUESTIONS).toHaveLength(1200);
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
		expect(ROUND_ORDER[0].categoryId).toBe('stadt');
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

	it('writes a share text with the question, the type in percent, every type as a bar, and the link last', () => {
		const answers: Answer[] = ['ja', 'nein', 'ja'];
		const three = qs.slice(0, 3);
		const result = scoreRound(round, three, answers);
		expect(answerSquares(answers)).toBe('🟩🟥🟩');
		expect(result.mix).toHaveLength(5);
		expect(result.mix[0].persona).toBe(result.persona);
		expect(result.slices.map((m) => m.persona.id)).toEqual(result.category.personas.map((p) => p.id));
		expect(result.slices.reduce((n, m) => n + m.count, 0)).toBe(3);
		expect(result.mix.reduce((n, m) => n + m.count, 0)).toBe(3);
		expect(result.match.id).toBe(result.persona.match);
		expect(result.clash.id).toBe(result.persona.clash);
		expect(mixBar(0.5)).toBe('▰▰▰▰▱▱▱▱');
		const text = shareText(result, 'https://languagequiz.org/play/ja-nein');
		const lines = text.split('\n');
		expect(lines[0]).toBe(`${result.category.emoji} *${result.category.title}*`);
		expect(lines[1]).toBe(`Ich bin *${result.persona.title}* ${result.persona.emoji} – zu ${Math.round(result.mix[0].share * 100)} %`);
		// five bars in the theme's fixed order, mine in bold
		expect(lines.slice(3, 8).map((l) => l.split(' ')[0])).toEqual(result.category.personas.map((p) => p.emoji));
		expect(lines.slice(3, 8).filter((l) => l.includes(`*${result.persona.title}*`))).toHaveLength(1);
		expect(text).toContain(`💞 Passt zu: ${result.match.emoji} ${result.match.title}`);
		expect(text).toContain(`_${result.persona.de.line}_`);
		// never the answers themselves: the type is the message
		expect(text).not.toContain('✅');
		expect(text).not.toContain('❌');
		expect(lines.slice(-2)).toEqual(['👉 Und du? Gleiche 12 Fragen:', 'https://languagequiz.org/play/ja-nein']);
		const english = shareText(result, 'https://languagequiz.org/play/ja-nein', 'en');
		expect(english.split('\n')[0]).toBe(`${result.category.emoji} *${result.category.en}*`);
		expect(english).toContain("I'm *");
		expect(english).toContain(`_${result.persona.line}_`);
		expect(english.split('\n').at(-2)).toBe('👉 Your turn, same 12 questions:');
		expect(whatsappHref('a b')).toBe('https://wa.me/?text=a%20b');
		const plain = plainText(text);
		expect(plain).not.toMatch(/\p{Extended_Pictographic}/u);
		expect(plain).toContain('▰');
		expect(plain.split('\n')[0]).toBe(`*${result.category.title}*`);
	});

	it('reads the answers back: how clear the verdict was, the Ja/Nein balance, the longest run', () => {
		const allJa = scoreRound(round, qs, qs.map(() => 'ja' as Answer));
		const s = resultStats(allJa);
		expect(s.style).toBe('You said Ja to everything. Life says thank you.');
		expect(s.streak).toEqual({ answer: 'ja', length: ROUND_LENGTH });
		expect(s.verdict).toContain(allJa.persona.title);
		const mixed = scoreRound(round, qs, ['ja', 'nein', 'nein', 'nein', 'ja', 'nein', 'ja', 'nein', 'ja', 'ja', 'nein', 'ja']);
		const m = resultStats(mixed);
		expect(m.style.startsWith('6 Ja, 6 Nein')).toBe(true);
		expect(m.streak).toEqual({ answer: 'nein', length: 3 });
		const german = resultStats(mixed, 'de');
		expect(german.style.startsWith('6 Ja, 6 Nein: ausgeglichen')).toBe(true);
		expect(resultStats(allJa, 'de').style).toBe('Du hast zu allem Ja gesagt. Das Leben sagt danke.');
	});

	it('carries the answers in the link, in the original order, and reads them back', () => {
		const played = shuffled(round, () => 0.3);
		const answers: Answer[] = played.map((_, i) => (i % 2 ? 'ja' : 'nein'));
		const code = encodeAnswers(round.questions, played, answers);
		expect(code).toHaveLength(ROUND_LENGTH);
		const back = decodeAnswers(code, ROUND_LENGTH)!;
		// the same answer for the same question, whatever the order it was asked in
		round.questions.forEach((q, i) => expect(back[i]).toBe(answers[played.indexOf(q)]));
		expect(scoreRound(round, round.questions, back).persona).toBe(scoreRound(round, played, answers).persona);
		expect(decodeAnswers('jnx', 3)).toBeNull();
		expect(decodeAnswers('jn', ROUND_LENGTH)).toBeNull();
	});

	it('writes a this-or-that line as the chosen over the other, German or English', () => {
		const q = ALL_QUESTIONS.find(isPair)!;
		expect(q).toBeDefined();
		const cap = (w: string) => w.charAt(0).toUpperCase() + w.slice(1);
		expect(shareLine(q, 'ja')).toBe(`⚖️ ${cap(q.right.de)} > ${cap(q.left.de)}`);
		expect(shareLine(q, 'nein')).toBe(`⚖️ ${cap(q.left.de)} > ${cap(q.right.de)}`);
		expect(shareLine(q, 'ja', 'en')).toBe(`⚖️ ${cap(q.right.en)} > ${cap(q.left.en)}`);
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
