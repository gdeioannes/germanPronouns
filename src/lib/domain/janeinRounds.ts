// "Ja oder Nein?" rounds: the bank is ten categories of ten themed rounds
// of eight questions (assets/content/janein/<category>.json), each category
// with five personas of its own. The deck deals the rounds in turn, round-
// robin across the categories, so two hands in a row never land on the
// same shelf; a finished round's persona goes into the collection the
// learner can brag about (/play/ja-nein/personas).

import type { Answer, JaNeinQuestion, Persona } from './janein';

export interface JaNeinCategory {
	id: string;
	title: string;
	en: string;
	emoji: string;
	personas: Persona[];
	rounds: JaNeinRound[];
}

export interface JaNeinRound {
	/** `<category>/<round>`, the key the played list and links use. */
	key: string;
	id: string;
	categoryId: string;
	title: string;
	en: string;
	hook: string;
	questions: JaNeinQuestion[];
}

export const ROUND_LENGTH = 8;

/** The shelves in the order the deck walks them: the classic five first. */
const CATEGORY_ORDER = ['typisch', 'uhr', 'teller', 'nacht', 'zuhause', 'draussen', 'ordnung', 'stadtland', 'jahr', 'unterwegs'];

type RawQuestion =
	| { de: string; en: string; ja: string; nein: string }
	| { left: { de: string; en: string; vibe: string }; right: { de: string; en: string; vibe: string } };

interface RawCategory {
	id: string;
	title: string;
	en: string;
	emoji: string;
	personas: Persona[];
	rounds: { id: string; title: string; en: string; hook: string; questions: RawQuestion[] }[];
}

const raw = import.meta.glob<RawCategory>('/assets/content/janein/*.json', { eager: true, import: 'default' });

function question(q: RawQuestion): JaNeinQuestion {
	if ('left' in q) {
		return {
			de: `${q.left.de} oder ${q.right.de}?`,
			en: `${q.left.en} or ${q.right.en}?`,
			nein: q.left.vibe,
			ja: q.right.vibe,
			left: { de: q.left.de, en: q.left.en },
			right: { de: q.right.de, en: q.right.en }
		};
	}
	return { de: q.de, en: q.en, ja: q.ja, nein: q.nein };
}

export const JA_NEIN_CATEGORIES: JaNeinCategory[] = Object.values(raw)
	.map((c) => ({
		id: c.id,
		title: c.title,
		en: c.en,
		emoji: c.emoji,
		personas: c.personas,
		rounds: c.rounds.map((r) => ({
			key: `${c.id}/${r.id}`,
			id: r.id,
			categoryId: c.id,
			title: r.title,
			en: r.en,
			hook: r.hook,
			questions: r.questions.map(question)
		}))
	}))
	.sort((a, b) => {
		const ia = CATEGORY_ORDER.indexOf(a.id);
		const ib = CATEGORY_ORDER.indexOf(b.id);
		return (ia < 0 ? 99 : ia) - (ib < 0 ? 99 : ib) || a.id.localeCompare(b.id);
	});

/**
 * Every round, in dealing order: the first round of each category, then
 * the second of each, and so on, so the shelves fill side by side.
 */
export const ROUND_ORDER: JaNeinRound[] = (() => {
	const out: JaNeinRound[] = [];
	const depth = Math.max(0, ...JA_NEIN_CATEGORIES.map((c) => c.rounds.length));
	for (let i = 0; i < depth; i++) for (const c of JA_NEIN_CATEGORIES) if (c.rounds[i]) out.push(c.rounds[i]);
	return out;
})();

/** Every question in the bank, for counts and the dev table. */
export const ALL_QUESTIONS: JaNeinQuestion[] = ROUND_ORDER.flatMap((r) => r.questions);

export function categoryOf(round: JaNeinRound): JaNeinCategory {
	return JA_NEIN_CATEGORIES.find((c) => c.id === round.categoryId)!;
}

export function findRound(key: string | null | undefined): JaNeinRound | undefined {
	return key ? ROUND_ORDER.find((r) => r.key === key) : undefined;
}

export function personaOf(category: JaNeinCategory, vibe: string): Persona {
	return category.personas.find((p) => p.id === vibe) ?? category.personas[0];
}

// -- which round comes next ---------------------------------------------------

const PLAYED_KEY = 'janein_played';

/** The rounds this device has finished, by key, in the order they were played. */
export function playedRounds(): string[] {
	try {
		const p = JSON.parse(localStorage.getItem(PLAYED_KEY) ?? '[]');
		return Array.isArray(p) ? p.map(String) : [];
	} catch {
		return [];
	}
}

export function markRoundPlayed(key: string, played: string[] = playedRounds()): string[] {
	const next = [...played.filter((k) => k !== key), key];
	try {
		localStorage.setItem(PLAYED_KEY, JSON.stringify(next));
	} catch {
		/* no storage: the same round may come round again */
	}
	return next;
}

/**
 * The round the deck deals next: the first in dealing order not yet played.
 * Once every round has been played the tour starts over, oldest first, so
 * there is always a next one and the shelves keep filling with new personas.
 */
export function nextRound(played: string[] = playedRounds()): JaNeinRound | null {
	if (ROUND_ORDER.length === 0) return null;
	const done = new Set(played);
	const fresh = ROUND_ORDER.find((r) => !done.has(r.key));
	if (fresh) return fresh;
	// All played: the one played longest ago (keys not in the bank any more are skipped).
	for (const key of played) {
		const r = findRound(key);
		if (r) return r;
	}
	return ROUND_ORDER[0];
}

/** A round's questions shuffled, so a replay asks them in a new order. */
export function shuffled(round: JaNeinRound, random: () => number = Math.random): JaNeinQuestion[] {
	const pool = [...round.questions];
	const out: JaNeinQuestion[] = [];
	while (pool.length) out.push(pool.splice(Math.floor(random() * pool.length), 1)[0]);
	return out;
}

// -- scoring --------------------------------------------------------------------

export interface RoundResult {
	round: JaNeinRound;
	category: JaNeinCategory;
	persona: Persona;
	questions: JaNeinQuestion[];
	tally: Record<string, number>;
	runnerUp: Persona | null;
	ja: number;
	nein: number;
	answers: Answer[];
}

/** Who you are tonight: the persona the answers fed most; ties go to the one fed first. */
export function scoreRound(round: JaNeinRound, questions: JaNeinQuestion[], answers: Answer[]): RoundResult {
	const category = categoryOf(round);
	const vibes = category.personas.map((p) => p.id);
	const tally = Object.fromEntries(vibes.map((v) => [v, 0])) as Record<string, number>;
	const firstFed: Record<string, number> = {};
	answers.forEach((answer, i) => {
		const q = questions[i];
		if (!q) return;
		const vibe = q[answer];
		tally[vibe] = (tally[vibe] ?? 0) + 1;
		firstFed[vibe] ??= i;
	});
	const ranked = [...vibes].sort((a, b) => tally[b] - tally[a] || (firstFed[a] ?? Infinity) - (firstFed[b] ?? Infinity));
	return {
		round,
		category,
		persona: personaOf(category, ranked[0]),
		questions,
		tally,
		runnerUp: tally[ranked[1]] > 0 ? personaOf(category, ranked[1]) : null,
		ja: answers.filter((a) => a === 'ja').length,
		nein: answers.filter((a) => a === 'nein').length,
		answers
	};
}

// -- the collection -------------------------------------------------------------

const PERSONAS_KEY = 'janein_personas';

/** `<category>/<persona>` → the day it was first earned (ISO date). */
export type Collection = Record<string, string>;

export function collection(): Collection {
	try {
		const p = JSON.parse(localStorage.getItem(PERSONAS_KEY) ?? '{}');
		return p && typeof p === 'object' ? p : {};
	} catch {
		return {};
	}
}

export function personaKey(categoryId: string, personaId: string): string {
	return `${categoryId}/${personaId}`;
}

/** Add a round's persona to the collection. True when it is new to the shelf. */
export function earnPersona(result: RoundResult, now = new Date()): boolean {
	const key = personaKey(result.category.id, result.persona.id);
	const have = collection();
	if (have[key]) return false;
	have[key] = now.toISOString().slice(0, 10);
	try {
		localStorage.setItem(PERSONAS_KEY, JSON.stringify(have));
	} catch {
		/* no storage: the shelf stays empty */
	}
	return true;
}

export function collectionCount(have: Collection = collection()): { earned: number; total: number } {
	const total = JA_NEIN_CATEGORIES.reduce((n, c) => n + c.personas.length, 0);
	const earned = JA_NEIN_CATEGORIES.reduce((n, c) => n + c.personas.filter((p) => have[personaKey(c.id, p.id)]).length, 0);
	return { earned, total };
}

/**
 * The brag: one row of squares per shelf, filled for every persona earned,
 * the count, and the link. "23 von 50" is the number worth sending.
 */
export function collectionShareText(url: string, have: Collection = collection(), lang: 'de' | 'en' = 'de'): string {
	const { earned, total } = collectionCount(have);
	const head =
		lang === 'de'
			? `Ja oder Nein? 🇩🇪 Meine Personas: ${earned} von ${total}`
			: `Ja oder Nein? 🇩🇪 My personas: ${earned} of ${total}`;
	const rows = JA_NEIN_CATEGORIES.map(
		(c) => `${c.emoji} ${c.personas.map((p) => (have[personaKey(c.id, p.id)] ? '🟪' : '⬜')).join('')} ${c.title}`
	);
	return [head, ...rows, url].join('\n');
}
