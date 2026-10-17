// Every "Schreib mir!" chat, checked the same way (assets/content/match/*.json):
// its structure, its word banks, its media, and the tests and playthroughs the
// author wrote into the file itself. A chat that fails here is not shipped.
import { describe, expect, it } from 'vitest';
import {
	gradeSentence,
	MATCH_CHATS,
	NAME_TILE,
	playTurn,
	startState,
	tilesFor,
	turnById,
	type ChatMessage,
	type ChatState,
	type MatchChat
} from './matchChat';

const LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
/** The Gemini TTS voices tool/gen-story-audio.mjs can cast. */
const VOICES = new Set([
	'Achernar', 'Achird', 'Algenib', 'Algieba', 'Alnilam', 'Aoede', 'Autonoe', 'Callirrhoe', 'Charon', 'Despina',
	'Enceladus', 'Erinome', 'Fenrir', 'Gacrux', 'Iapetus', 'Kore', 'Laomedeia', 'Leda', 'Orus', 'Puck',
	'Pulcherrima', 'Rasalgethi', 'Sadachbia', 'Sadaltager', 'Schedar', 'Sulafat', 'Umbriel', 'Vindemiatrix',
	'Zephyr', 'Zubenelgenubi'
]);
const NAME = 'Sam';
const FORMAL = new Set(['Sie', 'Ihnen', 'Ihr', 'Ihre', 'Ihren', 'Ihrem', 'Ihrer', 'Ihres']);

/** Every message of a chat, wherever it sits. */
function messagesOf(chat: MatchChat): ChatMessage[] {
	const out: ChatMessage[] = [...chat.intro, chat.offTopic, ...chat.confused];
	for (const t of chat.turns) {
		out.push(...t.before);
		for (const i of t.intents) out.push(...i.reply);
	}
	const e = chat.endings;
	out.push(...e.win, ...e.secret, ...e.partial, ...Object.values(e.deleted), e.sunday);
	return out;
}

function imagesOf(chat: MatchChat): string[] {
	const ids = [chat.image];
	for (const m of messagesOf(chat)) if (m.image) ids.push(m.image);
	for (const t of chat.turns) for (const i of t.intents) if (i.photo) ids.push(i.photo);
	return ids;
}

describe('all chats together', () => {
	it('ids, clip ids and picture ids are unique across chats', () => {
		const ids = MATCH_CHATS.map((c) => c.id);
		expect(new Set(ids).size).toBe(ids.length);
		const clips = MATCH_CHATS.flatMap((c) => [...new Set(messagesOf(c).flatMap((m) => (m.audio ? [m.audio] : [])))]);
		const dupes = clips.filter((c, i) => clips.indexOf(c) !== i);
		expect(dupes).toEqual([]);
		const pictures = MATCH_CHATS.flatMap((c) => (c.imagePrompts ?? []).map((p) => p.id));
		expect(pictures.filter((p, i) => pictures.indexOf(p) !== i)).toEqual([]);
	});

	it('a hidden chat is unlocked by some other chat', () => {
		for (const c of MATCH_CHATS.filter((c) => c.hidden))
			expect(MATCH_CHATS.some((o) => o.unlocks?.id === c.id), c.id).toBe(true);
	});
});

describe.each(MATCH_CHATS.map((c) => [c.id, c] as const))('%s', (_id, chat) => {
	it('has a complete profile', () => {
		expect(LEVELS).toContain(chat.level);
		for (const k of ['name', 'bio', 'bioEn', 'goal', 'tagline', 'emoji', 'image'] as const) expect(chat[k], k).toBeTruthy();
		expect(chat.voice && VOICES.has(chat.voice), `voice ${chat.voice}`).toBe(true);
		expect(chat.brief, 'brief').toBeTruthy();
		expect(chat.share?.win && chat.share.partial && chat.share.deleted, 'share texts').toBeTruthy();
		expect(chat.partialTitle, 'partialTitle').toBeTruthy();
		expect(chat.turns.length).toBeGreaterThanOrEqual(5);
	});

	it('every message is complete, and voiced unless it says the learner’s name', () => {
		for (const m of messagesOf(chat)) {
			expect(m.who, JSON.stringify(m)).toBe(chat.id);
			if (m.type === 'photo') {
				expect(m.image && m.alt, `photo ${m.image}`).toBeTruthy();
				continue;
			}
			expect(m.de && m.en, `message ${m.de}`).toBeTruthy();
			if (!m.de!.includes('{name}')) expect(m.audio, `no audio: ${m.de}`).toBeTruthy();
			if (m.audio) expect(m.audio.startsWith(`mc_${chat.id}_`), m.audio).toBe(true);
			if (m.type === 'voice') expect(m.bg === undefined || ['techno', 'scratch'].includes(m.bg)).toBe(true);
		}
	});

	it('every picture has a prompt', () => {
		// A prompt may live in another chat (Günther's portrait is in Helga's file).
		const prompts = new Set(MATCH_CHATS.flatMap((c) => (c.imagePrompts ?? []).map((p) => p.id)));
		for (const id of imagesOf(chat)) expect(prompts.has(id), `no prompt for ${id}`).toBe(true);
		for (const p of chat.imagePrompts ?? []) expect(p.id.startsWith('match_'), p.id).toBe(true);
	});

	it('turn links and deletion causes resolve', () => {
		for (const turn of chat.turns) {
			if (turn.next) expect(turnById(chat, turn.next), turn.next).toBeTruthy();
			for (const intent of turn.intents) {
				if (intent.next) expect(turnById(chat, intent.next), intent.next).toBeTruthy();
				if (intent.cause) expect(chat.endings.deleted[intent.cause], intent.cause).toBeTruthy();
			}
		}
		expect(chat.endings.deleted.default && chat.endings.deleted.confused).toBeTruthy();
	});

	it('every bank is sound: keywords in it, nouns known, a sensible size', () => {
		for (const turn of chat.turns) {
			const bank = turn.tiles.map((t) => t.toLowerCase());
			expect(turn.tiles.length, turn.id).toBeGreaterThanOrEqual(8);
			expect(turn.tiles.length, turn.id).toBeLessThanOrEqual(24);
			expect(turn.intents.length, `${turn.id}: answers`).toBeGreaterThanOrEqual(3);
			for (const intent of turn.intents) {
				const keys = [...(intent.when.all ?? []), ...(intent.when.any ?? []), ...(intent.when.none ?? [])];
				for (const k of keys) {
					const ok = k.endsWith('*') ? bank.some((b) => b.startsWith(k.slice(0, -1))) : bank.includes(k);
					expect(ok, `${turn.id}/${intent.id}: "${k}" not in the bank`).toBe(true);
				}
			}
			for (const t of turn.tiles) {
				if (t === NAME_TILE || t.includes(' ')) continue;
				// A capitalised tile is a noun or a name the checker must know (or formal Sie/Ihr/Ihnen).
				if (t[0] !== t[0].toLowerCase() && !FORMAL.has(t))
					expect(t in chat.lexicon.nouns || chat.lexicon.names.includes(t), `${turn.id}: "${t}" not in the lexicon`).toBe(true);
			}
			for (const w of Object.keys(turn.wrong)) expect(bank, `${turn.id}: wrong "${w}"`).toContain(w.toLowerCase());
		}
	});

	it('its own sentence tests pass', () => {
		expect((chat.tests ?? []).length, 'tests').toBeGreaterThanOrEqual(chat.turns.length * 3);
		for (const t of chat.tests ?? []) {
			const turn = turnById(chat, t.turn)!;
			expect(turn, t.turn).toBeTruthy();
			const tokens = tilesFor(turn, t.say);
			const label = `${t.turn} · ${t.say}`;
			if (t.score !== undefined)
				expect(gradeSentence(tokens, chat.lexicon, turn.wrong, NAME, turn.prepCase).score, label).toBe(t.score);
			const state: ChatState = { ...startState(chat), current: turn };
			const r = playTurn(chat, state, tokens, NAME).results.at(-1)!;
			if (t.intent !== undefined) expect(r.intent?.id ?? null, label).toBe(t.intent);
			if (t.delta !== undefined) expect(r.delta, label).toBe(t.delta);
		}
	});

	it('its playthroughs end where they say', () => {
		const runs = chat.playthroughs ?? [];
		expect(runs.some((p) => p.ending === 'win' || p.ending === 'secret'), 'a winning run').toBe(true);
		expect(runs.some((p) => p.ending === 'deleted'), 'a deleted run').toBe(true);
		for (const run of runs) {
			let state = startState(chat);
			for (const [turnId, sentence] of run.say) {
				expect(state.current?.id, `${run.name}: on ${turnId}`).toBe(turnId);
				state = playTurn(chat, state, tilesFor(state.current!, sentence), NAME);
			}
			expect(state.ending, run.name).toBe(run.ending);
		}
	});
});
