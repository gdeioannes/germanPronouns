// Regression guard for how completion is read back, and for the run-and-
// streak rules a drill is scored by.
//
// The bug the first block pins down: fill-in quizzes have no completion set,
// so their "done" was read from per-quiz stats that load lazily. The course
// home never loaded them, so finished fill-ins read as unfinished — a missing
// ribbon and an undercounted progress ring.

import { beforeEach, describe, expect, it } from 'vitest';
import { progress, revealPause } from './progress.svelte';
import { buildLadder } from '$lib/domain/ladder';
import { quizStatsKeys, SettingsKeys } from '$lib/domain/keys';
import { LEGACY_GOAL_STREAK } from '$lib/domain/progress';
import type { PopulatedCourse, Quiz } from '$lib/content/types';

/** A Map-backed localStorage, so the store's real persistence path is exercised. */
function installStorage(seed: Record<string, string> = {}) {
	const map = new Map(Object.entries(seed));
	Object.defineProperty(globalThis, 'localStorage', {
		configurable: true,
		value: {
			getItem: (k: string) => map.get(k) ?? null,
			setItem: (k: string, v: string) => void map.set(k, v),
			removeItem: (k: string) => void map.delete(k),
			key: (i: number) => [...map.keys()][i] ?? null,
			get length() {
				return map.size;
			}
		}
	});
	return map;
}

function quiz(id: string, type: Quiz['type'], level: string): Quiz {
	return {
		id,
		title: id,
		type,
		level,
		storageKeyPrefix: `${id}_`
	} as Quiz;
}

function course(quizzes: Quiz[]): PopulatedCourse {
	const levels = [...new Set(quizzes.map((q) => q.level!))];
	return {
		id: 'test',
		quizzes,
		nav: {
			groups: levels.map((level) => ({
				id: `g_${level}`,
				title: level,
				type: 'questChain',
				level
			}))
		}
	} as unknown as PopulatedCourse;
}

const A1_1 = [quiz('a1_1_fill', 'fillBlank', 'A1.1'), quiz('a1_1_read', 'reading', 'A1.1')];
const A1_2 = [quiz('a1_2_fill', 'fillBlank', 'A1.2')];
const TEST_COURSE = course([...A1_1, ...A1_2]);

function ladder() {
	return buildLadder(TEST_COURSE, (q) =>
		progress.isCompleted(q.type, q.id, q.storageKeyPrefix)
	);
}

describe('settings survive a reload', () => {
	// Every setting is written to localStorage on change and read back on load.
	// This drives the real store, so a setting added without a load() line — the
	// easy mistake — fails here rather than silently resetting on refresh.
	it('round-trips each setting through storage', async () => {
		const map = installStorage();
		await progress.load();

		await progress.setRelaxedCorrection(false);
		await progress.setWordHelp(false);
		await progress.setShowFirstLetterHint(true);
		await progress.setVoiceOfflineOnly(true);
		await progress.setAnswerRevealMode('slow');

		// Nothing is held only in memory: the values are in the store itself.
		expect(map.get(SettingsKeys.relaxedCorrection)).toBe('false');
		expect(map.get(SettingsKeys.colorNouns)).toBe('false');
		expect(map.get(SettingsKeys.showFirstLetterHint)).toBe('true');
		expect(map.get(SettingsKeys.voiceOfflineOnly)).toBe('true');
		expect(map.get(SettingsKeys.answerRevealMode)).toBe('slow');

		// A fresh visit reads them back rather than falling to the defaults.
		await progress.load();
		expect(progress.relaxedCorrection).toBe(false);
		expect(progress.wordHelp).toBe(false);
		expect(progress.showFirstLetterHint).toBe(true);
		expect(progress.voiceOfflineOnly).toBe(true);
		expect(progress.answerRevealMode).toBe('slow');
	});

	it('keeps "wait for me" reveal and transcripts across a reload', async () => {
		const map = installStorage();
		await progress.load();
		await progress.setAnswerRevealMode('manual');
		await progress.setShowTranscripts(true);
		expect(map.get(SettingsKeys.showTranscripts)).toBe('true');

		await progress.load();
		expect(progress.answerRevealMode).toBe('manual');
		expect(progress.showTranscripts).toBe(true);
	});

	it('defaults word help and relaxed correction on for a new learner', async () => {
		installStorage();
		await progress.load();
		expect(progress.wordHelp).toBe(true);
		expect(progress.relaxedCorrection).toBe(true);
	});
});

describe('reading completion back', () => {
	beforeEach(() => {
		installStorage();
	});

	it('counts nothing as done for a new learner', async () => {
		await progress.load();
		const [first, second] = ladder();
		expect(first.doneCount).toBe(0);
		expect(second.complete).toBe(false);
	});

	it('counts a finished fill-in without its stats being hydrated', async () => {
		installStorage({
			// What finishing A1.1 actually writes: the quest set for every kind,
			// plus the type set for the kinds that have one.
			[SettingsKeys.completedQuestQuizzes]: JSON.stringify(['a1_1_fill', 'a1_1_read']),
			[SettingsKeys.completedReadingQuizzes]: JSON.stringify(['a1_1_read'])
		});
		await progress.load();

		expect(ladder()[0].complete).toBe(true);
	});

	it('still accepts a goal streak alone, for progress earned in the Flutter build', async () => {
		installStorage({
			// The old build wrote no quest entry for a fill-in — only the streak.
			[quizStatsKeys('a1_1_fill_').bestStreakAbsolute]: String(LEGACY_GOAL_STREAK),
			[SettingsKeys.completedReadingQuizzes]: JSON.stringify(['a1_1_read'])
		});
		await progress.load();
		await progress.hydrateStats(['a1_1_fill_']);

		expect(ladder()[0].complete).toBe(true);
	});

	it('does not call a level complete when only part of it is done', async () => {
		installStorage({
			[SettingsKeys.completedQuestQuizzes]: JSON.stringify(['a1_1_fill'])
		});
		await progress.load();
		expect(ladder()[0].complete).toBe(false);
		expect(ladder()[0].doneCount).toBe(1);
	});
});

describe('the streak and its medals', () => {
	const prefix = 'a1_1_fill_';

	it('grows on a right answer, starts again at zero on a miss, keeps the best', async () => {
		installStorage();
		await progress.load();
		for (let i = 0; i < 4; i++) await progress.recordAnswer(prefix, true);

		let stats = await progress.recordAnswer(prefix, false);
		expect(stats).toMatchObject({ streak: 0, bestStreakAbsolute: 4, earned: null });

		// The miss cost nothing but the count: the next right answer is a fresh run.
		stats = await progress.recordAnswer(prefix, true);
		expect(stats).toMatchObject({ streak: 1, bestStreakAbsolute: 4 });
	});

	it('reports the medal on the crossing answer and only then', async () => {
		installStorage();
		await progress.load();
		const earned: (string | null)[] = [];
		for (let i = 0; i < 17; i++) earned.push((await progress.recordAnswer(prefix, true)).earned);
		expect(earned[7]).toBe('bronze');
		expect(earned[15]).toBe('silver');
		expect(earned.filter(Boolean)).toEqual(['bronze', 'silver']);
	});

	it('survives a reload: a returning learner picks the streak back up', async () => {
		const map = installStorage();
		await progress.load();
		for (let i = 0; i < 7; i++) await progress.recordAnswer(prefix, true);
		expect(map.get(quizStatsKeys(prefix).streak)).toBe('7');

		await progress.load();
		expect((await progress.statsFor(prefix)).streak).toBe(7);
	});
});

describe('finishing a run', () => {
	it('marks a weak run as finished with a retry mark, and a passed one as done', async () => {
		installStorage();
		await progress.load();
		const q = A1_1[0];
		for (let i = 0; i < 10; i++) await progress.recordAnswer(q.storageKeyPrefix, i % 2 === 0);
		expect(progress.isCompleted(q.type, q.id, q.storageKeyPrefix)).toBe(false);

		await progress.recordRun(q.storageKeyPrefix, { right: 5, total: 10, bestStreak: 1 });
		await progress.markQuestCompleted(q.id);
		expect(progress.isCompleted(q.type, q.id, q.storageKeyPrefix)).toBe(true);
		// No eight in a row, so no medal; and five of ten sends it back for a retry.
		expect(progress.medalFor(q.storageKeyPrefix)).toBeNull();
		expect(progress.ribbonFor(q.type, q.id, q.storageKeyPrefix)).toBeNull();
		expect(progress.markFor(q.type, q.id, q.storageKeyPrefix)).toBe('retry');
		expect((await progress.historyFor(q.storageKeyPrefix)).runs).toBe(1);

		await progress.recordRun(q.storageKeyPrefix, { right: 9, total: 10, bestStreak: 6 });
		expect(progress.markFor(q.type, q.id, q.storageKeyPrefix)).toBe('done');

		for (let i = 0; i < 8; i++) await progress.recordAnswer(q.storageKeyPrefix, true);
		expect(progress.markFor(q.type, q.id, q.storageKeyPrefix)).toBe('bronze');
	});

	it('shows a play-through finish as bronze, and a legacy drill finish as done', async () => {
		installStorage({
			[SettingsKeys.completedQuestQuizzes]: JSON.stringify(['a1_1_fill']),
			[SettingsKeys.completedReadingQuizzes]: JSON.stringify(['a1_1_read'])
		});
		await progress.load();
		await progress.hydrateStats(['a1_1_fill_']);
		expect(progress.markFor('reading', 'a1_1_read', 'a1_1_read_')).toBe('bronze');
		expect(progress.markFor('fillBlank', 'a1_1_fill', 'a1_1_fill_')).toBe('done');
	});

	it('keeps a log of every run, so a shaky drill can be told from a held one', async () => {
		installStorage();
		await progress.load();
		await progress.recordRun('x_', { right: 4, total: 10, bestStreak: 2 });
		await progress.recordRun('x_', { right: 9, total: 10, bestStreak: 9 });
		const runs = await progress.runsFor('x_');
		expect(runs.map((r) => r.right)).toEqual([4, 9]);
		expect(runs.every((r) => r.at > 0)).toBe(true);
	});
});

describe('revealPause', () => {
	it('times the timed modes and never advances in "wait for me"', () => {
		expect(revealPause('quick')).toBe(500);
		expect(revealPause('normal')).toBe(1500);
		expect(revealPause('slow')).toBe(3000);
		expect(revealPause('manual')).toBeNull();
	});
});
