import { describe, expect, it } from 'vitest';
import bankJson from '$content/wordcheck/de.json';
import dictionary from '$content/shared/dictionary/de.json';
import nounsJson from '$content/shared/nouns/de.json';
import verbsJson from '$content/shared/verbs/de.json';
import {
	FAKES_PER_SCREEN,
	MAX_SCREENS,
	REAL_PER_SCREEN,
	appendLog,
	bankLevels,
	buildScreen,
	checkDue,
	checkResult,
	knownShare,
	levelShares,
	logEntry,
	nextLevel,
	parseLog,
	shownWords,
	suggestedLevel,
	suggestedPace,
	vocabularySize,
	LEVEL_MEANING,
	LEVEL_WORDS,
	type CheckScreen,
	type LevelShare,
	type WordCheckBank
} from './wordCheck';

const bank = bankJson as unknown as WordCheckBank;
const LEVELS = bankLevels(bank);

/** A seeded random, so a screen is the same every run. */
function seeded(seed = 1) {
	let s = seed;
	return () => {
		s = (s * 16807) % 2147483647;
		return (s - 1) / 2147483646;
	};
}

const bare = (de: string) => de.replace(/^(der|die|das) /, '');

describe('the word bank', () => {
	it('has the course sub-levels in order, each with its meaning and word count', () => {
		expect(LEVELS).toEqual([
			'A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2',
			'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'
		]);
		for (const level of LEVELS) {
			expect(LEVEL_MEANING[level], level).toBeTruthy();
			expect(LEVEL_WORDS[level], level).toBeGreaterThan(0);
		}
	});

	it('gives each level enough single words with English, never repeated', () => {
		const seen = new Map<string, string>();
		for (const { level, words } of bank.levels) {
			expect(words.length, level).toBeGreaterThanOrEqual(40);
			for (const [de, en] of words) {
				expect(en, de).toBeTruthy();
				// One word per chip: a noun may carry its article, nothing else.
				expect(bare(de), `${level}: ${de}`).toMatch(/^[\p{L}-]+$/u);
				expect(bare(de), `${level}: ${de} is a phrase`).not.toBe('sich');
				const key = bare(de).toLowerCase();
				expect(seen.get(key), `${de} in ${level} and ${seen.get(key)}`).toBeUndefined();
				seen.set(key, level);
			}
		}
	});

	it('has enough made-up words per tier, all different', () => {
		const all = [...bank.fakes.a, ...bank.fakes.b, ...bank.fakes.c];
		for (const tier of ['a', 'b', 'c'] as const) {
			expect(bank.fakes[tier].length, tier).toBeGreaterThanOrEqual(15);
		}
		expect(new Set(all).size).toBe(all.length);
	});

	it('never uses a real word as a fake', () => {
		const real = new Set<string>();
		const add = (w: string) => real.add(w.toLowerCase());
		for (const e of (dictionary as { entries: { de: string }[] }).entries) add(e.de);
		for (const surface of Object.keys((dictionary as { surfaces: Record<string, number> }).surfaces)) add(surface);
		for (const n of (nounsJson as { nouns: { noun: string }[] }).nouns) add(n.noun);
		for (const v of (verbsJson as { verbs: { verb: string }[] }).verbs) add(v.verb);
		for (const { words } of bank.levels) for (const [de] of words) add(bare(de));
		for (const fake of [...bank.fakes.a, ...bank.fakes.b, ...bank.fakes.c]) {
			expect(real.has(bare(fake).toLowerCase()), `${fake} is a real word`).toBe(false);
		}
	});
});

/** A screen for `level` with `share` of its real words ticked and `fakes` of its fakes. */
function answered(level: string, share: number, fakes = 0, shown = new Set<string>()): CheckScreen {
	const screen = buildScreen(bank, level, shown, seeded(levelSeed(level)));
	const real = screen.items.filter((i) => !i.fake);
	const fake = screen.items.filter((i) => i.fake);
	screen.ticked = [
		...real.slice(0, Math.round(share * real.length)).map((i) => i.de),
		...fake.slice(0, fakes).map((i) => i.de)
	];
	return screen;
}
const levelSeed = (level: string) => LEVELS.indexOf(level) + 7;

/** Runs a whole check for a learner who knows `known(level)` of each level. */
function run(known: (level: string) => number, fakes = 0): CheckScreen[] {
	const screens: CheckScreen[] = [];
	for (let level = nextLevel(LEVELS, screens); level; level = nextLevel(LEVELS, screens)) {
		screens.push(answered(level, known(level), fakes, shownWords(screens)));
	}
	return screens;
}

describe('a screen', () => {
	it('mixes 15 real words with 5 made-up ones of the level’s tier', () => {
		const screen = buildScreen(bank, 'B2.1', new Set(), seeded());
		expect(screen.items.filter((i) => !i.fake)).toHaveLength(REAL_PER_SCREEN);
		const fakes = screen.items.filter((i) => i.fake);
		expect(fakes).toHaveLength(FAKES_PER_SCREEN);
		for (const f of fakes) expect(bank.fakes.b).toContain(f.de);
		for (const r of screen.items.filter((i) => !i.fake)) expect(r.en).toBeTruthy();
	});

	it('never repeats a chip already shown', () => {
		const first = buildScreen(bank, 'A1.1', new Set(), seeded(3));
		const second = buildScreen(bank, 'A1.2', shownWords([first]), seeded(4));
		const seen = shownWords([first]);
		for (const item of second.items) expect(seen.has(item.de)).toBe(false);
	});
});

describe('scoring', () => {
	it('takes the false alarms off the hit rate', () => {
		const screen = answered('A1.1', 0.8);
		expect(knownShare(screen, 0)).toBeCloseTo(0.8, 1);
		// (0.8 − 0.2) / 0.8
		expect(knownShare(screen, 0.2)).toBeCloseTo(0.75, 1);
		expect(knownShare(screen, 1)).toBe(0);
	});

	it('gives nothing to someone who ticks everything', () => {
		const screens = run(() => 1, FAKES_PER_SCREEN);
		const result = checkResult(LEVELS, screens);
		expect(result.careful).toBe(true);
		expect(result.words).toBe(0);
		expect(result.level).toBe('A1.1');
	});
});

describe('the climb', () => {
	it('starts at the first level', () => {
		expect(nextLevel(LEVELS, [])).toBe('A1.1');
	});

	it('skips a level that is nearly all known, steps one on a fair share', () => {
		expect(nextLevel(LEVELS, [answered('A1.1', 1)])).toBe('A2.1');
		expect(nextLevel(LEVELS, [answered('A1.1', 0.6)])).toBe('A1.2');
	});

	it('stops a beginner after one screen', () => {
		expect(run(() => 0.1).map((s) => s.level)).toEqual(['A1.1']);
	});

	it('fills in a skipped level before stopping', () => {
		const known: Record<string, number> = { 'A1.1': 1, 'A1.2': 0.7, 'A2.1': 0.2 };
		const path = run((l) => known[l] ?? 0).map((s) => s.level);
		expect(path).toEqual(['A1.1', 'A2.1', 'A1.2']);
	});

	it('takes one more look past a borderline level, then stops', () => {
		const known: Record<string, number> = { 'A1.1': 0.7, 'A1.2': 0.4, 'A2.1': 0.1 };
		expect(run((l) => known[l] ?? 0).map((s) => s.level)).toEqual(['A1.1', 'A1.2', 'A2.1']);
	});

	it('gets a near-native learner to the top in a few screens', () => {
		const path = run(() => 1).map((s) => s.level);
		expect(path.length).toBeLessThanOrEqual(7);
		expect(path.at(-1)).toBe('C2.2');
	});

	it('never runs past the screen limit', () => {
		expect(run(() => 0.6).length).toBeLessThanOrEqual(MAX_SCREENS);
	});
});

describe('the result', () => {
	const shares = (values: number[], measured = values.map(() => true)): LevelShare[] =>
		values.map((share, i) => ({ level: LEVELS[i], share, measured: measured[i] }));

	it('puts the learner at the first level not yet solid', () => {
		expect(suggestedLevel(shares([0.96, 0.91, 0.78, 0.55, 0.24, 0.08]))).toBe('A2.2');
		expect(suggestedLevel(shares(LEVELS.map(() => 1)))).toBe('C2.2');
	});

	it('fills skipped levels in between and fades above the last', () => {
		const out = levelShares(LEVELS, [answered('A1.1', 1), answered('A2.1', 0.6)]);
		expect(out[1].measured).toBe(false);
		expect(out[1].share).toBeCloseTo(0.8, 1);
		expect(out[3].share).toBeCloseTo(out[2].share / 2, 5);
	});

	it('adds the levels up to an estimate in round numbers', () => {
		expect(vocabularySize(shares([1, 1, 1, 1]))).toBe(1300);
		expect(vocabularySize(shares([0.5]))).toBe(150);
	});

	it('reads the pace from the shape of the bars', () => {
		// A clean step down.
		expect(suggestedPace(shares([1, 0.9, 0.5, 0.1]), 'A2.1', false)).toBe('steady');
		// The level mostly known, the next one half.
		expect(suggestedPace(shares([1, 0.9, 0.7, 0.5, 0.1]), 'A2.1', false)).toBe('fast');
		// A hole here, better above.
		expect(suggestedPace(shares([1, 0.4, 0.7, 0.2]), 'A1.2', false)).toBe('review');
		// Thinly spread.
		expect(suggestedPace(shares([0.7, 0.6, 0.5, 0.45, 0.4, 0.3, 0.1]), 'A1.1', false)).toBe('adventurous');
		// Too many fakes ticked: nothing ambitious.
		expect(suggestedPace(shares([1, 0.9, 0.7, 0.5]), 'A2.1', true)).toBe('steady');
	});

	it('lists unticked words at the learner’s level to learn next', () => {
		const screens = run((l) => ({ 'A1.1': 1, 'A1.2': 0.6, 'A2.1': 0.3 })[l] ?? 0);
		const result = checkResult(LEVELS, screens);
		expect(result.level).toBe('A1.2');
		expect(result.toLearn.length).toBeGreaterThan(0);
		for (const w of result.toLearn) expect(w.en).toBeTruthy();
	});
});

describe('the history', () => {
	it('keeps the measured levels and survives a bad store', () => {
		const result = checkResult(LEVELS, run(() => 0.9), 1000);
		const entry = logEntry(result);
		expect(Object.keys(entry.shares).length).toBe(result.shares.filter((s) => s.measured).length);
		const log = appendLog(parseLog('not json'), entry);
		expect(parseLog(JSON.stringify(log))).toEqual([entry]);
		expect(appendLog(log, entry)).toHaveLength(1);
	});

	it('is due when never taken or a month old', () => {
		const day = 24 * 60 * 60 * 1000;
		const entry = logEntry(checkResult(LEVELS, run(() => 0.9), 0));
		expect(checkDue([])).toBe(true);
		expect(checkDue([entry], 10 * day)).toBe(false);
		expect(checkDue([entry], 31 * day)).toBe(true);
	});
});
