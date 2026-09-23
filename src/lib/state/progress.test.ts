// Regression guard for how completion is read back.
//
// The bug this pins down: fill-in quizzes have no completion set, so their
// "done" was read from per-quiz stats that load lazily. The course home never
// loaded them, so finished fill-ins read as unfinished — which back when levels
// were gated meant a finished A1.1 never opened A1.2, and still today means a
// missing ribbon and an undercounted progress ring.

import { beforeEach, describe, expect, it } from 'vitest';
import { progress } from './progress.svelte';
import { buildLadder } from '$lib/domain/ladder';
import { quizStatsKeys, SettingsKeys } from '$lib/domain/keys';
import { DEFAULT_GATING, progressionUnlockStreak } from '$lib/domain/progress';
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

const GOAL = progressionUnlockStreak(DEFAULT_GATING);

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
		await progress.load(DEFAULT_GATING);

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
		await progress.load(DEFAULT_GATING);
		expect(progress.relaxedCorrection).toBe(false);
		expect(progress.wordHelp).toBe(false);
		expect(progress.showFirstLetterHint).toBe(true);
		expect(progress.voiceOfflineOnly).toBe(true);
		expect(progress.answerRevealMode).toBe('slow');
	});

	it('defaults word help and relaxed correction on for a new learner', async () => {
		installStorage();
		await progress.load(DEFAULT_GATING);
		expect(progress.wordHelp).toBe(true);
		expect(progress.relaxedCorrection).toBe(true);
	});
});

describe('reading completion back', () => {
	beforeEach(() => {
		installStorage();
	});

	it('counts nothing as done for a new learner', async () => {
		await progress.load(DEFAULT_GATING);
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
		await progress.load(DEFAULT_GATING);

		expect(ladder()[0].complete).toBe(true);
	});

	it('still accepts a goal streak alone, for progress earned in the Flutter build', async () => {
		installStorage({
			// The old build wrote no quest entry for a fill-in — only the streak.
			[quizStatsKeys('a1_1_fill_').bestStreakAbsolute]: String(GOAL),
			[SettingsKeys.completedReadingQuizzes]: JSON.stringify(['a1_1_read'])
		});
		await progress.load(DEFAULT_GATING);
		await progress.hydrateStats(['a1_1_fill_']);

		expect(ladder()[0].complete).toBe(true);
	});

	it('does not call a level complete when only part of it is done', async () => {
		installStorage({
			[SettingsKeys.completedQuestQuizzes]: JSON.stringify(['a1_1_fill'])
		});
		await progress.load(DEFAULT_GATING);
		expect(ladder()[0].complete).toBe(false);
		expect(ladder()[0].doneCount).toBe(1);
	});
});
