import { describe, expect, it } from 'vitest';
import {
	findChat,
	gradeSentence,
	matchIntent,
	MATCH_CHATS,
	NAME_TILE,
	playTurn,
	replay,
	startState,
	STOP,
	sundayAfter,
	turnById,
	cleanName,
	chatDeckCard,
	tilesFor,
	type ChatState,
	type MatchChat,
	type Turn
} from './matchChat';

const helga = findChat('helga') as MatchChat;
const NAME = 'Sam';

const tiles = tilesFor;

/** Plays one sentence on `turnId` from a state at `interest` with `flags`. */
function play(turnId: string, sentence: string, interest = 5, flags: string[] = []) {
	const turn = turnById(helga, turnId)!;
	const state: ChatState = { ...startState(helga), interest, flags, current: turn };
	const next = playTurn(helga, state, tiles(turn, sentence), NAME);
	return next.results.at(-1)!;
}

describe('the Helga content', () => {
	it('loads, and every turn link points at a real turn', () => {
		expect(MATCH_CHATS.length).toBeGreaterThan(0);
		for (const turn of helga.turns) {
			if (turn.next) expect(turnById(helga, turn.next), turn.next).toBeTruthy();
			for (const intent of turn.intents) if (intent.next) expect(turnById(helga, intent.next)).toBeTruthy();
		}
	});

	it('every deletion cause has a last line', () => {
		const causes = helga.turns.flatMap((t) => t.intents.map((i) => i.cause).filter(Boolean)) as string[];
		for (const c of [...causes, 'confused', 'default']) expect(helga.endings.deleted[c], c).toBeTruthy();
	});

	it('every intent keyword is a word in its own bank', () => {
		for (const turn of helga.turns) {
			const bank = turn.tiles.map((t) => t.toLowerCase());
			for (const intent of turn.intents) {
				const keys = [...(intent.when.all ?? []), ...(intent.when.any ?? []), ...(intent.when.none ?? [])];
				for (const k of keys) {
					const ok = k.endsWith('*') ? bank.some((b) => b.startsWith(k.slice(0, -1))) : bank.includes(k);
					expect(ok, `${turn.id}/${intent.id}: "${k}"`).toBe(true);
				}
			}
		}
	});
});

describe('the sentence score', () => {
	const cases: Array<[string, string, number]> = [
		['t1', 'Hallo! Ich heiße {name}.', 100],
		['t1', 'Ich bin {name}. Ich tanze gern.', 100],
		['t1', 'Ich heißt {name}.', 80],
		['t1', 'Ich {name} heiße.', 70],
		['t2', 'Ja, ich tanze sehr gern!', 100],
		['t2', 'Nein, aber ich trinke gern.', 100],
		['t2', 'Nein, ich tanze nicht, aber ich trinke gern.', 100],
		['t2', 'Gern tanze ich.', 100],
		['t2', 'Ich tanzt gern.', 80],
		['t2', 'Ich gern Techno.', 50],
		['t3', 'Um dreiundzwanzig Uhr.', 100],
		['t3', 'Die Party beginnt am Samstag um elf.', 100],
		['t3', 'Die Party beginnen um elf.', 80],
		['t3', 'Um elf die Party beginnt.', 70],
		['t4', 'Keine Fotos und nur schwarze Kleidung.', 100],
		['t4', 'Kein Fotos und schwarz Kleidung.', 70],
		['t5', 'Ich trage alles schwarz.', 100],
		['t5', 'Meine Hose und mein Pullover sind schwarz.', 100],
		['t5', 'Mein Hose ist schwarz.', 85],
		['t5', 'Ich trage ein Dirndl.', 100],
		['t5', 'Ich trage eine Lederhose.', 100],
		['t5', 'Ich trage ein Lederhose.', 85],
		['t6', 'Die Tür rechts.', 100],
		['t6', 'Es ist die schwarze Tür rechts.', 100],
		['t6', 'Der Tür rechts.', 85],
		['t6', 'Die Tür mit dem Fahrrad.', 100],
		['t6', 'Die Tür mit dem roten Fahrrad.', 100],
		['t7', 'Ich komme mit meiner Schwester.', 100],
		['t7', 'Ich komme mit meinem Schwester.', 85],
		['t7', 'Ich komme mit meinem Opa. Er heißt Günther.', 100],
		['t7b', 'Er bist nett.', 80],
		['t7b', 'Ich weiß es nicht.', 100],
		['t7b', 'Er hat viele Platten.', 100],
		['t8', 'Hallo! Ich bin {name}. Ich bin auf der Liste von Helga.', 100],
		['t8', 'Ich heiße {name}. Gästeliste Helga.', 100],
		['t8', 'Ich bin auf die Liste von Helga.', 85]
	];
	it.each(cases)('%s · %s → %i', (turnId, sentence, score) => {
		const turn = turnById(helga, turnId)!;
		expect(gradeSentence(tiles(turn, sentence), helga.lexicon, turn.wrong, NAME).score).toBe(score);
	});

	it('writes the recast with the fix applied', () => {
		const turn = turnById(helga, 't4')!;
		const g = gradeSentence(tiles(turn, 'Kein Fotos und schwarz Kleidung.'), helga.lexicon, turn.wrong, NAME);
		expect(g.text).toBe('Kein Fotos und schwarz Kleidung.');
		expect(g.fixed).toBe('Keine Fotos und schwarze Kleidung.');
	});

	it('punctuates: comma after Ja, comma before aber, the name filled in', () => {
		const turn = turnById(helga, 't2')!;
		expect(gradeSentence(tiles(turn, 'Nein, aber ich trinke gern.'), helga.lexicon, {}, NAME).text).toBe(
			'Nein, aber ich trinke gern.'
		);
		const t1 = turnById(helga, 't1')!;
		expect(gradeSentence(tiles(t1, 'Hallo! Ich heiße {name}.'), helga.lexicon, {}, NAME).text).toBe(
			'Hallo! Ich heiße Sam.'
		);
	});
});

describe('meaning and interest', () => {
	const cases: Array<[string, string, string | null, number, string[]?]> = [
		['t1', 'Hallo! Ich heiße {name}.', 'name', 2],
		['t1', 'Ich heißt {name}.', 'name', 1],
		['t1', 'Hallo!', 'greeting', -1],
		['t2', 'Ja, ich tanze sehr gern!', 'yes', 2],
		['t2', 'Gern! Ich liebe Techno.', 'techno', 3],
		['t2', 'Nein, aber ich trinke gern.', 'drink', 1],
		['t2', 'Nein, ich tanze nicht, aber ich trinke gern.', 'drink', 1],
		['t2', 'Ich tanze nur Walzer.', 'waltz', 2],
		['t2', 'Ich tanzt gern.', 'yes', 1],
		['t2', 'Ich tanze nicht gern.', 'no', -1],
		['t2', 'Ich gern Techno.', null, -1],
		['t3', 'Um dreiundzwanzig Uhr.', 'right', 2],
		['t3', 'Die Party beginnen um elf.', 'right', 1],
		['t3', 'Um vierzehn Uhr.', 'end', -1],
		['t3', 'Um zwei.', 'night', -1],
		['t4', 'Keine Fotos und nur schwarze Kleidung.', 'both', 3],
		['t4', 'Keine Fotos.', 'photos', 2],
		['t4', 'Nur schwarze Kleidung.', 'black', 2],
		['t4', 'Kein Fotos und schwarz Kleidung.', 'both', 2],
		['t4', 'Fotos und schwarze Kleidung.', 'lostNegation', -2],
		['t4', 'Viel Bier und Tanzen.', 'beer', -1],
		['t5', 'Ich trage alles schwarz.', 'black', 2],
		['t5', 'Mein Hose ist schwarz.', 'black', 1],
		['t5', 'Ich trage ein Dirndl.', 'costume', 1],
		['t5', 'Ich trage Gelb.', 'yellow', -1],
		['t5', 'Ich trage Gelb.', 'contradiction', -2, ['saidBlack']],
		['t5', 'Ich trage Schwarz und Gelb.', 'bee', -1],
		['t6', 'Die Tür rechts.', 'right', 2],
		['t6', 'Es ist die schwarze Tür rechts.', 'right', 2],
		['t6', 'Der Tür rechts.', 'right', 1],
		['t6', 'Die Tür mit dem Fahrrad.', 'vague', 1],
		['t6', 'Die Tür mit dem roten Fahrrad.', 'redBike', 2],
		['t6', 'Die Tür mit dem gelben Fahrrad.', 'yellowBike', -1],
		['t6', 'Die grüne Tür.', 'middle', -1],
		['t6', 'Die Tür in der Mitte.', 'middle', -1],
		['t6', 'Die Tür links.', 'left', -1],
		['t7', 'Ich komme allein.', 'alone', 2],
		['t7', 'Ich komme mit meiner Schwester.', 'plusOne', 1],
		['t7', 'Ich komme mit meinem Schwester.', 'plusOne', 0],
		['t7', 'Ich komme mit fünf Freunden.', 'group', -1],
		['t7', 'Ich komme mit meinem Opa. Er heißt Günther.', 'guenther', 0],
		['t7b', 'Ja, er ist sehr nett.', 'nice', 2],
		['t7b', 'Er hat viele Platten.', 'records', 2],
		['t7b', 'Er bist nett.', 'nice', 1],
		['t7b', 'Nein, er ist nicht nett.', 'notNice', 2],
		['t7b', 'Ich weiß es nicht.', 'dontKnow', -2],
		['t8', 'Hallo! Ich bin {name}. Ich bin auf der Liste von Helga.', 'list', 2],
		['t8', 'Ich heiße {name}. Gästeliste Helga.', 'list', 2],
		['t8', 'Ich bin auf die Liste von Helga.', 'list', 1],
		['t8', 'Ich bin {name}.', 'nameOnly', -1],
		['t8', 'Ich bin Helga.', 'iAmHelga', -2],
		// Near-answers that used to fall through to "das war nicht meine Frage".
		['t1', 'Ich komme aus Berlin.', 'origin', 1],
		['t1', 'Ich tanze gern.', 'dance', 1],
		['t3', 'Am Samstag.', 'day', 1],
		['t3', 'Am Sonntag.', 'sunday', -1],
		['t4', 'Keine Handys.', 'phones', 2],
		['t4', 'Handys.', 'phonesLost', -2],
		['t4', 'Tanzen.', 'dance', 1],
		['t5', 'Ich trage eine Hose.', 'noColour', 1],
		['t7', 'Ich komme mit Freunden.', 'friends', 1],
		['t7', 'Ich komme nicht allein.', 'notAlone', 1],
		['t7', 'Ich komme mit meinem Opa.', 'opa', 1],
		['t7b', 'Ja.', 'nice', 2],
		['t7b', 'Nein.', 'no', 2],
		['t8', 'Ich bin auf der Liste.', 'list', 2]
	];
	it.each(cases)('%s · %s → %s, %i', (turnId, sentence, intent, delta, flags = []) => {
		const r = play(turnId, sentence, 5, flags);
		expect(r.intent?.id ?? null).toBe(intent);
		expect(r.delta).toBe(delta);
	});

	it('a sentence nobody can follow is "Hä?" whatever it says', () => {
		const r = play('t2', 'Ich gern Techno.');
		expect(r.heard).toBe('confused');
		expect(r.reply).toBe(helga.confused);
	});

	it('Günther opens the secret branch, everyone else skips it', () => {
		const t7 = turnById(helga, 't7')!;
		const s = { ...startState(helga), current: t7 };
		expect(playTurn(helga, s, tiles(t7, 'Ich komme mit meinem Opa. Er heißt Günther.'), NAME).current?.id).toBe('t7b');
		expect(playTurn(helga, s, tiles(t7, 'Ich komme allein.'), NAME).current?.id).toBe('t8');
	});

	it('matchIntent reads negation: Fotos without keine', () => {
		const t4 = turnById(helga, 't4')!;
		expect(matchIntent(t4.intents, ['Fotos'], [])?.id).toBe('lostNegation');
		expect(matchIntent(t4.intents, ['keine', 'Fotos'], [])?.id).toBe('photos');
	});
});

/** Plays a whole chat: [turnId, sentence] in order; checks the turn each lands on. */
function run(script: Array<[string, string]>) {
	let state = startState(helga);
	const trail: number[] = [];
	for (const [turnId, sentence] of script) {
		expect(state.current?.id, `expected to be on ${turnId}`).toBe(turnId);
		state = playTurn(helga, state, tiles(state.current!, sentence), NAME);
		trail.push(state.interest);
	}
	return { state, trail };
}

describe('three playthroughs (docs/match_chat_helga.md)', () => {
	it('the perfect path ends liked, Deutsch 100', () => {
		const { state, trail } = run([
			['t1', 'Hallo! Ich heiße {name}.'],
			['t2', 'Ja, ich tanze sehr gern!'],
			['t3', 'Um dreiundzwanzig Uhr.'],
			['t4', 'Keine Fotos und nur schwarze Kleidung.'],
			['t5', 'Ich trage alles schwarz.'],
			['t6', 'Die Tür rechts.'],
			['t7', 'Ich komme allein.'],
			['t8', 'Ich bin auf der Liste von Helga.']
		]);
		expect(trail).toEqual([7, 9, 10, 10, 10, 10, 10, 10]);
		expect(state.ending).toBe('win');
		expect(state.average).toBe(100);
		expect(state.facts).toEqual(['💃 tanzt gern', '📵 kennt die Regeln', '🖤 trägt Schwarz', '🚪 findet geheime Türen']);
	});

	it('messy but saved still gets the like', () => {
		const { state, trail } = run([
			['t1', 'Ich heißt {name}.'],
			['t2', 'Nein, aber ich trinke gern.'],
			['t3', 'Die Party beginnen um elf.'],
			['t4', 'Kein Fotos.'],
			['t5', 'Ich trage ein Lederhose.'],
			['t6', 'Die Tür links.'],
			['t7', 'Ich komme mit fünf Freunden.'],
			['t8', 'Ich bin auf die Liste von Helga.']
		]);
		expect(trail).toEqual([6, 7, 8, 9, 9, 8, 7, 8]);
		expect(state.ending).toBe('win');
		expect(state.average).toBe(89);
	});

	it('deleted at turn 5 with perfect German', () => {
		const { state, trail } = run([
			['t1', 'Hallo!'],
			['t2', 'Ich trinke gern.'],
			['t3', 'Um zwei.'],
			['t4', 'Fotos und schwarze Kleidung.'],
			['t5', 'Ich trage Gelb.']
		]);
		expect(trail).toEqual([4, 5, 4, 2, 0]);
		expect(state.ending).toBe('deleted');
		expect(state.cause).toBe('yellow');
		expect(state.current).toBeNull();
		expect(state.average).toBe(100);
	});

	it('the secret ending: Günther is nice and interest is high', () => {
		const { state } = run([
			['t1', 'Hallo! Ich heiße {name}.'],
			['t2', 'Ich liebe Techno.'],
			['t3', 'Um elf.'],
			['t4', 'Keine Fotos.'],
			['t5', 'Ich trage alles schwarz.'],
			['t6', 'Die Tür rechts.'],
			['t7', 'Ich komme mit meinem Opa. Er heißt Günther.'],
			['t7b', 'Er hat viele Platten.'],
			['t8', 'Ich bin auf der Liste von Helga.']
		]);
		expect(state.ending).toBe('secret');
	});

	it('the middle: on the list, carrying the records', () => {
		const { state } = run([
			['t1', 'Hallo!'],
			['t2', 'Ich tanze nicht gern.'],
			['t3', 'Um vierzehn Uhr.'],
			['t4', 'Keine Fotos.'],
			['t5', 'Ich trage ein Dirndl.'],
			['t6', 'Die Tür links.'],
			['t7', 'Ich komme mit fünf Freunden.'],
			['t8', 'Ich bin auf der Liste von Helga.']
		]);
		expect(state.interest).toBeGreaterThanOrEqual(4);
		expect(state.interest).toBeLessThan(7);
		expect(state.ending).toBe('partial');
	});

	it('replays a saved log to the same place', () => {
		const t1 = turnById(helga, 't1')!;
		const t2 = turnById(helga, 't2')!;
		const log = [
			{ turn: 't1', tokens: tiles(t1, 'Hallo! Ich heiße {name}.') },
			{ turn: 't2', tokens: tiles(t2, 'Ich tanze nur Walzer.') }
		];
		const s = replay(helga, log, NAME);
		expect(s.current?.id).toBe('t3');
		expect(s.interest).toBe(9);
		expect(s.flags).toContain('waltz');
	});
});

describe('little helpers', () => {
	it('cleanName keeps one word of letters', () => {
		expect(cleanName('  Ana-Lu  Smith ')).toBe('Ana-Lu');
		expect(cleanName('R2D2!')).toBe('RD');
	});

	it('the follow-up arrives the next Sunday at 14:05', () => {
		const wed = new Date(2026, 9, 14, 20, 0).getTime(); // a Wednesday
		const sun = new Date(sundayAfter(wed));
		expect(sun.getDay()).toBe(0);
		expect(sun.getHours()).toBe(14);
		expect(sun.getMinutes()).toBe(5);
		const lateSunday = new Date(2026, 9, 18, 15, 0).getTime();
		expect(sundayAfter(lateSunday) - lateSunday).toBeGreaterThan(6 * 86400000);
	});
});

describe('the course deck deals characters', () => {
	const none = () => null;
	it('without a ticket: only now and then, as a locked teaser', () => {
		expect(chatDeckCard('A1.1', new Set(), 0, () => 0.2, none)).toBeNull();
		expect(chatDeckCard('A1.1', new Set(), 0, () => 0.1, none)?.resume).toBe(false);
	});
	it('with a ticket and a lucky deal: the next character at the learner module', () => {
		const deal = chatDeckCard('B1.1', new Set(), 1, () => 0, none)!;
		expect(deal.resume).toBe(false);
		expect(deal.chat.level).toBe('B1.1');
	});
	it('an unlucky deal deals nothing', () => {
		expect(chatDeckCard('A1.1', new Set(), 2, () => 0.99, none)).toBeNull();
	});
	it('a chat in progress always comes back, free, even with no ticket', () => {
		const saved = (id: string) => (id === 'bernd' ? { name: 'Sam', log: [{ turn: 't1', tokens: ['ich'] }], startedAt: 1 } : null);
		const deal = chatDeckCard('C2.2', new Set(), 0, () => 0.99, saved)!;
		expect(deal).toEqual(expect.objectContaining({ resume: true }));
		expect(deal.chat.id).toBe('bernd');
	});
	it('never deals a hidden character or a skipped one', () => {
		const deal = chatDeckCard('A2.1', new Set(['chat:klara', 'chat:grog', 'chat:uwe', 'chat:nebel', 'chat:jupp']), 1, () => 0, none)!;
		expect(deal.chat.id).not.toBe('guenther');
		expect(['klara', 'grog', 'uwe', 'nebel', 'jupp']).not.toContain(deal.chat.id);
	});
});
