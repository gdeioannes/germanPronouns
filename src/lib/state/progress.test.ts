// Regression guard for the ladder's locks.
//
// The bug this pins down: fill-in quizzes have no completion set, so their
// "done" was read from per-quiz stats that load lazily. The course home never
// loaded them, so a learner who finished all of A1.1 — eleven of its twenty
// exercises are fill-in — still saw A1.2 locked.

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
	return buildLadder(
		TEST_COURSE,
		(q) => progress.isCompleted(q.type, q.id, q.storageKeyPrefix),
		(id) => progress.isPlacementUnlocked(id)
	);
}

describe('ladder unlocking', () => {
	beforeEach(() => {
		installStorage();
	});

	it('locks the second sub-level until the first is finished', async () => {
		await progress.load(DEFAULT_GATING);
		const [first, second] = ladder();
		expect(first.unlocked).toBe(true);
		expect(second.unlocked).toBe(false);
	});

	it('opens A1.2 once every A1.1 exercise is done, without stats being hydrated', async () => {
		installStorage({
			// What finishing A1.1 actually writes: the quest set for every kind,
			// plus the type set for the kinds that have one.
			[SettingsKeys.completedQuestQuizzes]: JSON.stringify(['a1_1_fill', 'a1_1_read']),
			[SettingsKeys.completedReadingQuizzes]: JSON.stringify(['a1_1_read'])
		});
		await progress.load(DEFAULT_GATING);

		const [first, second] = ladder();
		expect(first.complete).toBe(true);
		expect(second.unlocked).toBe(true);
	});

	it('still accepts a goal streak alone, for progress earned in the Flutter build', async () => {
		installStorage({
			// The old build wrote no quest entry for a fill-in — only the streak.
			[quizStatsKeys('a1_1_fill_').bestStreakAbsolute]: String(GOAL),
			[SettingsKeys.completedReadingQuizzes]: JSON.stringify(['a1_1_read'])
		});
		await progress.load(DEFAULT_GATING);
		await progress.hydrateStats(['a1_1_fill_']);

		expect(ladder()[1].unlocked).toBe(true);
	});

	it('does not open A1.2 when only part of A1.1 is done', async () => {
		installStorage({
			[SettingsKeys.completedQuestQuizzes]: JSON.stringify(['a1_1_fill'])
		});
		await progress.load(DEFAULT_GATING);
		expect(ladder()[1].unlocked).toBe(false);
	});
});
