// What the two-device merge must never do: lose something the learner earned.
//
// The second block is the one that matters most. `reconcile` merges on every
// sign-in and every "sync now", so the merge runs against its own output over
// and over. Any rule that isn't idempotent drifts a little further each time —
// which is how you end up with a mistake count that says the learner has never
// got anything right.

import { describe, expect, it } from 'vitest';
import {
	differInProgress,
	isSyncable,
	mergeProgress,
	summariseProgress,
	syncablePart
} from './sync-merge';
import { quizStatsKeys, SettingsKeys } from './keys';

const keys = quizStatsKeys('zahlen_');

describe('mergeProgress', () => {
	it('takes the higher score and best streak, whichever device holds it', () => {
		const merged = mergeProgress(
			{ [keys.score]: '12', [keys.bestStreakAbsolute]: '4' },
			{ [keys.score]: '7', [keys.bestStreakAbsolute]: '19' },
			false
		);
		expect(merged[keys.score]).toBe('12');
		expect(merged[keys.bestStreakAbsolute]).toBe('19');
	});

	it('unions the completion sets, so neither device un-finishes a quiz', () => {
		const merged = mergeProgress(
			{ [SettingsKeys.completedQuestQuizzes]: '["a","b"]' },
			{ [SettingsKeys.completedQuestQuizzes]: '["b","c"]' },
			false
		);
		expect(JSON.parse(merged[SettingsKeys.completedQuestQuizzes])).toEqual(['a', 'b', 'c']);
	});

	it('interleaves the answer history by time and drops the duplicates', () => {
		const merged = mergeProgress(
			{
				[keys.answerHistory]: '[{"correct":true,"at":1},{"correct":false,"at":3}]'
			},
			{
				[keys.answerHistory]: '[{"correct":false,"at":3},{"correct":true,"at":5}]'
			},
			false
		);
		expect(JSON.parse(merged[keys.answerHistory])).toEqual([
			{ correct: true, at: 1 },
			{ correct: false, at: 3 },
			{ correct: true, at: 5 }
		]);
	});

	it('caps the merged run log rather than growing it without limit', () => {
		const runs = (from: number) =>
			JSON.stringify(
				Array.from({ length: 40 }, (_, i) => ({
					at: from + i,
					right: 8,
					total: 10,
					bestStreak: 5
				}))
			);
		const merged = mergeProgress({ [keys.runLog]: runs(1) }, { [keys.runLog]: runs(100) }, false);
		expect(JSON.parse(merged[keys.runLog])).toHaveLength(50);
	});

	it('keeps a key only one device has ever written', () => {
		const merged = mergeProgress({ [keys.score]: '3' }, { [keys.streak]: '2' }, false);
		expect(merged[keys.score]).toBe('3');
		expect(merged[keys.streak]).toBe('2');
	});

	describe('settings, which are a preference rather than an achievement', () => {
		it('keeps this device’s choice when the cloud copy is older', () => {
			const merged = mergeProgress(
				{ [SettingsKeys.calmEffects]: 'true' },
				{ [SettingsKeys.calmEffects]: 'false' },
				false
			);
			expect(merged[SettingsKeys.calmEffects]).toBe('true');
		});

		it('takes the cloud’s choice when that was written more recently', () => {
			const merged = mergeProgress(
				{ [SettingsKeys.calmEffects]: 'true' },
				{ [SettingsKeys.calmEffects]: 'false' },
				true
			);
			expect(merged[SettingsKeys.calmEffects]).toBe('false');
		});

		it('never lets a newer cloud copy lower a score', () => {
			const merged = mergeProgress({ [keys.score]: '40' }, { [keys.score]: '2' }, true);
			expect(merged[keys.score]).toBe('40');
		});
	});

	describe('device-local keys', () => {
		it('leaves the other device’s open page where it was', () => {
			const merged = mergeProgress(
				{ [SettingsKeys.lastPage]: '/course/a' },
				{ [SettingsKeys.lastPage]: '/course/b' },
				true
			);
			expect(merged[SettingsKeys.lastPage]).toBe('/course/a');
		});

		it('does not import one from the cloud at all', () => {
			const merged = mergeProgress({}, { [SettingsKeys.lastPage]: '/course/b' }, true);
			expect(merged[SettingsKeys.lastPage]).toBeUndefined();
		});

		it('keeps the account bookkeeping out of the synced blob', () => {
			expect(isSyncable(SettingsKeys.accountActive)).toBe(false);
			expect(isSyncable(SettingsKeys.accountLastSync)).toBe(false);
			expect(isSyncable(keys.score)).toBe(true);
			expect(syncablePart({ [SettingsKeys.accountActive]: '1', [keys.score]: '5' })).toEqual({
				[keys.score]: '5'
			});
		});

		it('refuses a key Firestore could not store as a field name', () => {
			expect(isSyncable('some.quiz_score')).toBe(false);
			expect(isSyncable('__proto__')).toBe(false);
		});
	});

	describe('idempotence — the merge runs on its own output every sign-in', () => {
		const local = {
			[keys.score]: '12',
			[keys.streak]: '3',
			[keys.bestStreakAbsolute]: '9',
			[keys.answerHistory]: '[{"correct":true,"at":1},{"correct":false}]',
			[keys.runLog]: '[{"at":10,"right":9,"total":10,"bestStreak":9}]',
			[keys.mistakesByCase]: '{"Dativ":3,"Akkusativ":1}',
			[SettingsKeys.completedQuestQuizzes]: '["a"]',
			[SettingsKeys.calmEffects]: 'true'
		};
		const remote = {
			[keys.score]: '20',
			[keys.streak]: '1',
			[keys.bestStreakAbsolute]: '5',
			[keys.answerHistory]: '[{"correct":true,"at":2},{"correct":false}]',
			[keys.runLog]: '[{"at":20,"right":7,"total":10,"bestStreak":4}]',
			[keys.mistakesByCase]: '{"Dativ":2,"Genitiv":4}',
			[SettingsKeys.completedQuestQuizzes]: '["b"]',
			[SettingsKeys.calmEffects]: 'false'
		};

		it('reaches the same result when re-merged against either side', () => {
			const once = mergeProgress(local, remote, false);
			expect(mergeProgress(once, once, false)).toEqual(once);
			// The cloud now holds `once`, so the next sign-in merges local into it.
			expect(mergeProgress(once, remote, false)).toEqual(once);
		});

		it('maxes rather than sums the mistake counts, so weak spots cannot inflate', () => {
			const once = mergeProgress(local, remote, false);
			expect(JSON.parse(once[keys.mistakesByCase])).toEqual({
				Dativ: 3,
				Akkusativ: 1,
				Genitiv: 4
			});
		});

		it('keeps untimed history entries from doubling on each merge', () => {
			let blob = mergeProgress(local, remote, false);
			const first = JSON.parse(blob[keys.answerHistory]).length;
			for (let i = 0; i < 5; i++) blob = mergeProgress(blob, blob, false);
			expect(JSON.parse(blob[keys.answerHistory])).toHaveLength(first);
		});
	});
});

// What the "you have progress on two devices" panel reads. It only ever
// *describes* the two blobs: the choice it offers is the learner's, and the
// merge behind "keep both" is the one tested above.
describe('summariseProgress', () => {
	const other = quizStatsKeys('artikel_');

	it('counts finished exercises, medals and the best streak anywhere', () => {
		const summary = summariseProgress({
			[SettingsKeys.completedQuestQuizzes]: '["a","b"]',
			[SettingsKeys.completedReadingQuizzes]: '["r"]',
			[keys.bestStreakAbsolute]: '17',
			[other.bestStreakAbsolute]: '9',
			[keys.score]: '12',
			[other.score]: '3'
		});
		expect(summary.done).toBe(3);
		expect(summary.practised).toBe(2);
		expect(summary.bestStreak).toBe(17);
		expect(summary.medals).toEqual({ bronze: 1, silver: 1, gold: 0 });
		expect(summary.empty).toBe(false);
	});

	it('calls a browser with only settings in it empty, so nothing is asked', () => {
		const summary = summariseProgress({ [SettingsKeys.calmEffects]: 'true' });
		expect(summary.empty).toBe(true);
		expect(summary.lastActive).toBeNull();
	});

	it('takes the most recent practice from either the stamp or the history', () => {
		expect(
			summariseProgress({
				[keys.lastPlayed]: '500',
				[other.answerHistory]: '[{"at":900}]'
			}).lastActive
		).toBe(900);
	});
});

describe('differInProgress — whether the question is worth asking', () => {
	it('is false when two devices hold the same progress', () => {
		const blob = {
			[keys.score]: '8',
			[SettingsKeys.completedQuestQuizzes]: '["a"]'
		};
		expect(differInProgress(blob, { ...blob })).toBe(false);
	});

	it('is false for a settings-only difference', () => {
		expect(
			differInProgress(
				{ [keys.score]: '8', [SettingsKeys.calmEffects]: 'true' },
				{ [keys.score]: '8', [SettingsKeys.calmEffects]: 'false' }
			)
		).toBe(false);
	});

	it('is true when one device finished something the other did not', () => {
		expect(
			differInProgress(
				{ [SettingsKeys.completedQuestQuizzes]: '["a"]' },
				{ [SettingsKeys.completedQuestQuizzes]: '["a","b"]' }
			)
		).toBe(true);
	});

	it('is true when the medals differ even though the counts match', () => {
		expect(
			differInProgress({ [keys.bestStreakAbsolute]: '8' }, { [keys.bestStreakAbsolute]: '24' })
		).toBe(true);
	});
});
