// The level check: "Which of these words do you know?"
//
// A screen of word chips from one sub-level, a few of them made up. The
// learner taps the ones they know, and the check climbs: a level nearly all
// known skips the next one, a fair share steps one up, and too little stops it
// (after filling in a level it jumped over). A strong learner is done in five
// or six screens instead of twelve.
//
// The made-up words are what make the answer worth anything. Ticking words is
// easy to overdo, so the share of fakes ticked (the false alarms) is taken off
// every level's score: a learner who ticks everything comes out near zero, not
// at C2. It measures recognising a word, not using it, which is all a starting
// point needs.
//
// Nothing here earns a medal or marks anything done. The result is a level, an
// estimated vocabulary size and a suggested deck pace, kept in a small history
// so the next check can show the growth.

import type { DeckPace } from './deck';

export interface WordEntry {
	/** The word as shown: a noun with its article ("der Topf"). */
	de: string;
	en: string;
}

export interface WordCheckBank {
	levels: { level: string; words: [string, string][] }[];
	/** Made-up words by tier: a for the A levels, b for B, c for C. */
	fakes: { a: string[]; b: string[]; c: string[] };
}

export interface CheckItem {
	de: string;
	/** The English, for the real words. */
	en?: string;
	fake: boolean;
}

export interface CheckScreen {
	level: string;
	items: CheckItem[];
	/** The chips the learner tapped, by their German. */
	ticked: string[];
}

/** Real words per screen. */
export const REAL_PER_SCREEN = 15;
/** Made-up words per screen: a quarter of the chips. */
export const FAKES_PER_SCREEN = 5;
/** The longest a check runs. */
export const MAX_SCREENS = 9;
/** A level known at least this well skips the next one. */
export const JUMP = 0.85;
/** A level known at least this well steps one up. */
export const GO = 0.5;
/** Below GO but at least this: one more level, unless the last one was low too. */
export const EDGE = 0.35;
/** The first level known less than this is the learner's level: where to work. */
export const SOLID = 0.75;
/** Ticking this share of the fakes or more makes the result a careful one. */
export const CAREFUL = 0.2;

/**
 * Roughly how many words each sub-level adds, for the "about N words" line:
 * about 650 by the end of A1, 1,300 by A2, 2,500 by B1, 4,000 by B2, 6,000 by
 * C1 and 9,000 by C2. A learner's known share of each level is multiplied by
 * these. Only an estimate, and said as one.
 */
export const LEVEL_WORDS: Record<string, number> = {
	'A1.1': 300,
	'A1.2': 350,
	'A2.1': 300,
	'A2.2': 350,
	'B1.1': 600,
	'B1.2': 600,
	'B2.1': 750,
	'B2.2': 750,
	'C1.1': 1000,
	'C1.2': 1000,
	'C2.1': 1500,
	'C2.2': 1500
};

/** The bank's sub-levels, in order. */
export function bankLevels(bank: WordCheckBank): string[] {
	return bank.levels.map((l) => l.level);
}

function shuffled<T>(list: T[], random: () => number): T[] {
	const out = [...list];
	for (let i = out.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}

function fakeTier(level: string): 'a' | 'b' | 'c' {
	const band = level[0]?.toLowerCase();
	return band === 'b' ? 'b' : band === 'c' ? 'c' : 'a';
}

/**
 * One screen for a level: REAL_PER_SCREEN of its words and FAKES_PER_SCREEN
 * made-up ones of the matching tier, none shown earlier in this check, mixed.
 */
export function buildScreen(
	bank: WordCheckBank,
	level: string,
	shown: Set<string>,
	random: () => number = Math.random
): CheckScreen {
	const words = bank.levels.find((l) => l.level === level)?.words ?? [];
	const real = shuffled(
		words.filter(([de]) => !shown.has(de)),
		random
	)
		.slice(0, REAL_PER_SCREEN)
		.map(([de, en]): CheckItem => ({ de, en, fake: false }));
	const fakes = shuffled(
		bank.fakes[fakeTier(level)].filter((de) => !shown.has(de)),
		random
	)
		.slice(0, FAKES_PER_SCREEN)
		.map((de): CheckItem => ({ de, fake: true }));
	return { level, items: shuffled([...real, ...fakes], random), ticked: [] };
}

/** Every chip shown so far, so the next screen never repeats one. */
export function shownWords(screens: CheckScreen[]): Set<string> {
	return new Set(screens.flatMap((s) => s.items.map((i) => i.de)));
}

/** Fakes ticked and fakes shown, over the whole check. */
export function falseAlarms(screens: CheckScreen[]): { ticked: number; shown: number } {
	let ticked = 0;
	let shown = 0;
	for (const s of screens) {
		const picked = new Set(s.ticked);
		for (const item of s.items) {
			if (!item.fake) continue;
			shown++;
			if (picked.has(item.de)) ticked++;
		}
	}
	return { ticked, shown };
}

function alarmRate(screens: CheckScreen[]): number {
	const { ticked, shown } = falseAlarms(screens);
	return shown ? ticked / shown : 0;
}

/** The raw share of a screen's real words ticked. */
export function hitRate(screen: CheckScreen): number {
	const picked = new Set(screen.ticked);
	const real = screen.items.filter((i) => !i.fake);
	return real.length ? real.filter((i) => picked.has(i.de)).length / real.length : 0;
}

/**
 * A screen's level as known, corrected for guessing: (hits − f) / (1 − f),
 * where f is the false-alarm rate. Someone who ticks every fake has said
 * nothing about any real word, so they score zero.
 */
export function knownShare(screen: CheckScreen, rate: number): number {
	if (rate >= 1) return 0;
	const share = (hitRate(screen) - rate) / (1 - rate);
	return Math.max(0, Math.min(1, share));
}

/**
 * The level of the next screen, or null when the check is over. Goes up two
 * levels when the last was nearly all known, one when it was fairly known,
 * and stops when it was not, first filling in a level it jumped over.
 */
export function nextLevel(levels: string[], screens: CheckScreen[]): string | null {
	if (screens.length === 0) return levels[0] ?? null;
	if (screens.length >= MAX_SCREENS) return null;
	const rate = alarmRate(screens);
	const at = (s: CheckScreen) => levels.indexOf(s.level);
	const last = screens[screens.length - 1];
	const prev = screens.length > 1 ? screens[screens.length - 2] : null;
	const i = at(last);
	const share = knownShare(last, rate);
	const top = levels.length - 1;
	const measured = new Set(screens.map(at));

	// A step back to fill in a skipped level is always the last one.
	if (prev && i < at(prev)) return null;
	if (share >= JUMP) return i >= top ? null : levels[Math.min(top, i + 2)];
	if (share >= GO) return i >= top ? null : levels[i + 1];
	// Too little here. A level skipped on the way gets its own screen first.
	if (prev && at(prev) < i - 1 && !measured.has(i - 1)) return levels[i - 1];
	const prevLow = prev ? knownShare(prev, rate) < GO : false;
	if (share >= EDGE && !prevLow && i < top) return levels[i + 1];
	return null;
}

export interface LevelShare {
	level: string;
	/** 0–1: how much of the level the learner knows. */
	share: number;
	/** False when worked out from the levels around it rather than shown. */
	measured: boolean;
}

/**
 * Every level's share: measured where a screen showed it, filled in between
 * two measured levels, and fading above the last one (halving per level),
 * since the check stopped because the words ran out of reach.
 */
export function levelShares(levels: string[], screens: CheckScreen[]): LevelShare[] {
	const rate = alarmRate(screens);
	const measured = new Map<number, number>();
	for (const s of screens) {
		const i = levels.indexOf(s.level);
		if (i >= 0) measured.set(i, knownShare(s, rate));
	}
	const known = [...measured.keys()].sort((a, b) => a - b);
	return levels.map((level, i): LevelShare => {
		if (measured.has(i)) return { level, share: measured.get(i)!, measured: true };
		const below = known.filter((k) => k < i).at(-1);
		const above = known.find((k) => k > i);
		let share = 0;
		if (below !== undefined && above !== undefined) {
			const t = (i - below) / (above - below);
			share = measured.get(below)! + t * (measured.get(above)! - measured.get(below)!);
		} else if (below !== undefined) {
			share = measured.get(below)! * 0.5 ** (i - below);
		} else if (above !== undefined) {
			// Under the first measured level: at least as well known as it.
			share = Math.max(measured.get(above)!, 0.9);
		}
		return { level, share, measured: false };
	});
}

/** The first level not yet solid: where the learner should be working. */
export function suggestedLevel(shares: LevelShare[]): string | null {
	if (!shares.length) return null;
	return (shares.find((s) => s.share < SOLID) ?? shares[shares.length - 1]).level;
}

/** About how many German words the shares add up to, rounded to sound like an estimate. */
export function vocabularySize(shares: LevelShare[]): number {
	const words = shares.reduce((n, s) => n + s.share * (LEVEL_WORDS[s.level] ?? 0), 0);
	if (words < 1000) return Math.round(words / 10) * 10;
	return Math.round(words / 50) * 50;
}

/**
 * The deck pace the result suggests, from the shape of the bars:
 *   - a careful result (many fakes ticked) → steady, nothing ambitious;
 *   - a hole at the learner's level with clearly better levels above it
 *     → "Polish up", fill the gap first;
 *   - knowledge thinly spread over many levels → "Adventurous";
 *   - the level mostly known and the next already half known → "Fast";
 *   - otherwise a clean step → "Slow & steady".
 */
export function suggestedPace(shares: LevelShare[], level: string | null, careful: boolean): DeckPace {
	if (careful || !level) return 'steady';
	const i = shares.findIndex((s) => s.level === level);
	const here = shares[i]?.share ?? 0;
	const above = shares.slice(i + 1).filter((s) => s.measured);
	if (above.some((s) => s.share >= GO && s.share >= here + 0.2)) return 'review';
	const partial = shares.filter((s) => s.measured && s.share >= 0.25 && s.share < SOLID).length;
	if (partial >= 4) return 'adventurous';
	const next = shares[i + 1];
	if (here >= 0.6 && next && next.share >= 0.45) return 'fast';
	return 'steady';
}

export interface CheckResult {
	/** Epoch ms. */
	at: number;
	level: string | null;
	words: number;
	pace: DeckPace;
	shares: LevelShare[];
	fakes: { ticked: number; shown: number };
	careful: boolean;
	/** Real words not ticked at the learner's level and the one above: what to learn next. */
	toLearn: WordEntry[];
}

/** How many of the words to learn the result lists. */
export const TO_LEARN = 12;

export function checkResult(levels: string[], screens: CheckScreen[], at = Date.now()): CheckResult {
	const shares = levelShares(levels, screens);
	const level = suggestedLevel(shares);
	const fakes = falseAlarms(screens);
	const careful = fakes.shown > 0 && fakes.ticked / fakes.shown >= CAREFUL;
	const i = level ? levels.indexOf(level) : -1;
	const near = new Set([levels[i], levels[i + 1]].filter(Boolean));
	const toLearn = screens
		.filter((s) => near.has(s.level))
		.sort((a, b) => levels.indexOf(a.level) - levels.indexOf(b.level))
		.flatMap((s) => {
			const picked = new Set(s.ticked);
			return s.items.filter((it) => !it.fake && !picked.has(it.de)).map((it) => ({ de: it.de, en: it.en ?? '' }));
		})
		.slice(0, TO_LEARN);
	return {
		at,
		level,
		words: vocabularySize(shares),
		pace: suggestedPace(shares, level, careful),
		shares,
		fakes,
		careful,
		toLearn
	};
}

// -- history ----------------------------------------------------------------

/** Where the checks are kept: synced, merged as a timeline (see sync-merge). */
export const WORD_CHECK_LOG = 'wordcheck_log';
/** How many past checks are kept. */
export const LOG_LIMIT = 30;

export interface CheckLogEntry {
	at: number;
	level: string | null;
	words: number;
	pace: DeckPace;
	/** Known share per level, two decimals; measured levels only. */
	shares: Record<string, number>;
	careful: boolean;
}

export function logEntry(result: CheckResult): CheckLogEntry {
	const shares: Record<string, number> = {};
	for (const s of result.shares) if (s.measured) shares[s.level] = Math.round(s.share * 100) / 100;
	return {
		at: result.at,
		level: result.level,
		words: result.words,
		pace: result.pace,
		shares,
		careful: result.careful
	};
}

/** The stored log, oldest first; anything unreadable is dropped. */
export function parseLog(raw: string | null): CheckLogEntry[] {
	try {
		const list = raw ? JSON.parse(raw) : [];
		if (!Array.isArray(list)) return [];
		return list
			.filter((e) => e && typeof e.at === 'number' && typeof e.words === 'number')
			.sort((a, b) => a.at - b.at);
	} catch {
		return [];
	}
}

export function appendLog(log: CheckLogEntry[], entry: CheckLogEntry): CheckLogEntry[] {
	return [...log.filter((e) => e.at !== entry.at), entry].sort((a, b) => a.at - b.at).slice(-LOG_LIMIT);
}

/** Days after a check before the deck offers another. */
export const RECHECK_DAYS = 30;

/** Whether the deck may offer the check now: never taken, or the last one a month old. */
export function checkDue(log: CheckLogEntry[], now = Date.now()): boolean {
	const last = log.at(-1);
	return !last || now - last.at >= RECHECK_DAYS * 24 * 60 * 60 * 1000;
}

// -- what a level means -------------------------------------------------------

/**
 * What a learner at each sub-level handles, in plain words for the result.
 * Said as what you can do, never as a test you would pass.
 */
export const LEVEL_MEANING: Record<string, string> = {
	'A1.1': 'You are at the very start: greetings, numbers, family and the words around the house. Every new word counts double here.',
	'A1.2': 'You know the first basics. Next come the words for a day: shopping, getting around town, the time, the weather and how you feel.',
	'A2.1': 'Everyday life works in simple sentences. The gaps are in travel, health, clothes and shopping: the words for sorting things out.',
	'A2.2': 'You handle everyday topics well. Words for work, home, plans and opinions are where your gaps are.',
	'B1.1': 'You get by in most daily situations. Next: the words to talk about jobs, relationships, habits and to give reasons.',
	'B1.2': 'You can follow a lot of what is said around you. Forms, offices, news and the words to explain causes and changes come next.',
	'B2.1': 'You can talk about most things. The words for arguing a point, society, research and the environment are your next step.',
	'B2.2': 'You read newspapers with few gaps. Business, the economy and the careful, precise words of a debate are what is left.',
	'C1.1': 'Your German is strong. Academic and professional language is next: the words that structure an argument and weigh evidence.',
	'C1.2': 'Very little stops you. The nuance is next: hints, tone, irony, and the words for how people behave and what they mean.',
	'C2.1': 'You are close to a native vocabulary. Legal, formal and elevated words are what remain.',
	'C2.2': 'You know words most learners never meet: literary, old-fashioned and rare ones. There is not much left to find here.'
};
