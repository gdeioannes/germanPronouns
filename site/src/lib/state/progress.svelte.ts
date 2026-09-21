// The learner's progress: per-quiz stats and the completion sets that gate the
// course ladder. One module-level rune store, loaded once at startup.
//
// Reads and writes the same keys the Flutter build used (see domain/keys.ts),
// so a learner's existing scores, streaks and unlocked levels carry over.

import { quizStatsKeys, SettingsKeys } from '$lib/domain/keys';
import {
	DEFAULT_GATING,
	isQuizDone,
	lapsForStreak,
	lapsForTier,
	ribbonTierForLaps,
	STREAK_LAP_SIZE,
	type Gating,
	type RibbonTier
} from '$lib/domain/progress';
import { storage } from '$lib/services/storage';
import type { QuizType } from '$lib/content/types';

export interface QuizStats {
	score: number;
	streak: number;
	bestStreakLap: number;
	bestStreakAbsolute: number;
}

const EMPTY_STATS: QuizStats = {
	score: 0,
	streak: 0,
	bestStreakLap: 0,
	bestStreakAbsolute: 0
};

/**
 * Which completion set a quiz kind records into. Fill-in quizzes have none —
 * their streak *is* their completion — which is why this returns null for them.
 */
function completionKeyFor(type: QuizType): string | null {
	switch (type) {
		case 'reading':
			return SettingsKeys.completedReadingQuizzes;
		case 'listening':
			return SettingsKeys.completedListeningQuizzes;
		case 'dictation':
			return SettingsKeys.completedDictationQuizzes;
		case 'speaking':
		case 'speakRepeat':
			return SettingsKeys.completedSpeakQuizzes;
		case 'fillBlank':
			return null;
	}
}

class ProgressStore {
	/** Per-quiz stats, keyed by storageKeyPrefix. */
	private stats = $state<Record<string, QuizStats>>({});
	/** Completion sets, keyed by the settings key that holds them. */
	private completed = $state<Record<string, string[]>>({});
	private placementUnlocked = $state<string[]>([]);

	gating = $state<Gating>(DEFAULT_GATING);
	relaxedCorrection = $state(false);
	showFirstLetterHint = $state(false);
	loaded = $state(false);

	async load(gating: Gating = DEFAULT_GATING): Promise<void> {
		this.gating = gating;
		const sets = [
			SettingsKeys.completedQuestQuizzes,
			SettingsKeys.completedSpeakQuizzes,
			SettingsKeys.completedReadingQuizzes,
			SettingsKeys.completedListeningQuizzes,
			SettingsKeys.completedDictationQuizzes
		];
		const loaded: Record<string, string[]> = {};
		for (const key of sets) loaded[key] = await this.readList(key);
		this.completed = loaded;
		this.placementUnlocked = await this.readList(SettingsKeys.placementUnlockedQuizzes);
		this.relaxedCorrection = (await storage.get(SettingsKeys.relaxedCorrection)) === 'true';
		this.showFirstLetterHint =
			(await storage.get(SettingsKeys.showFirstLetterHint)) === 'true';
		this.loaded = true;
	}

	private async readList(key: string): Promise<string[]> {
		const raw = await storage.get(key);
		if (!raw) return [];
		try {
			const parsed = JSON.parse(raw);
			return Array.isArray(parsed) ? parsed.map(String) : [];
		} catch {
			return [];
		}
	}

	private async writeList(key: string, values: string[]): Promise<void> {
		await storage.set(key, JSON.stringify(values));
	}

	// -- stats ---------------------------------------------------------------

	/** Stats for one quiz, loading them from storage the first time they're asked for. */
	async statsFor(prefix: string): Promise<QuizStats> {
		const cached = this.stats[prefix];
		if (cached) return cached;
		const keys = quizStatsKeys(prefix);
		const read = async (key: string) => Number(await storage.get(key)) || 0;
		const loaded: QuizStats = {
			score: await read(keys.score),
			streak: await read(keys.streak),
			bestStreakLap: await read(keys.bestStreakLap),
			bestStreakAbsolute: await read(keys.bestStreakAbsolute)
		};
		this.stats = { ...this.stats, [prefix]: loaded };
		return loaded;
	}

	/** Synchronous peek — returns zeros until `statsFor` has run for this prefix. */
	peekStats(prefix: string): QuizStats {
		return this.stats[prefix] ?? EMPTY_STATS;
	}

	async saveStats(prefix: string, next: QuizStats): Promise<void> {
		this.stats = { ...this.stats, [prefix]: next };
		const keys = quizStatsKeys(prefix);
		await storage.set(keys.score, String(next.score));
		await storage.set(keys.streak, String(next.streak));
		await storage.set(keys.bestStreakLap, String(next.bestStreakLap));
		await storage.set(keys.bestStreakAbsolute, String(next.bestStreakAbsolute));
	}

	/** Records one answer and returns the updated stats. */
	async recordAnswer(prefix: string, correct: boolean): Promise<QuizStats> {
		const current = await this.statsFor(prefix);
		const streak = correct ? current.streak + 1 : 0;
		const next: QuizStats = {
			score: correct ? current.score + 1 : current.score,
			streak,
			bestStreakLap: Math.max(current.bestStreakLap, streak % STREAK_LAP_SIZE),
			bestStreakAbsolute: Math.max(current.bestStreakAbsolute, streak)
		};
		await this.saveStats(prefix, next);
		return next;
	}

	// -- completion ----------------------------------------------------------

	isCompleted(type: QuizType, id: string, prefix: string): boolean {
		const key = completionKeyFor(type);
		if (key === null) {
			// Fill-in: the goal streak is completion.
			return isQuizDone(this.peekStats(prefix).bestStreakAbsolute, this.gating);
		}
		return (this.completed[key] ?? []).includes(id);
	}

	async markCompleted(type: QuizType, id: string): Promise<void> {
		const key = completionKeyFor(type);
		if (key === null) return;
		const current = this.completed[key] ?? [];
		if (current.includes(id)) return;
		const next = [...current, id];
		this.completed = { ...this.completed, [key]: next };
		await this.writeList(key, next);
	}

	isQuestCompleted(key: string): boolean {
		return (this.completed[SettingsKeys.completedQuestQuizzes] ?? []).includes(key);
	}

	async markQuestCompleted(key: string): Promise<void> {
		const current = this.completed[SettingsKeys.completedQuestQuizzes] ?? [];
		if (current.includes(key)) return;
		const next = [...current, key];
		this.completed = { ...this.completed, [SettingsKeys.completedQuestQuizzes]: next };
		await this.writeList(SettingsKeys.completedQuestQuizzes, next);
	}

	/** The ribbon a finished quiz shows, or null when it isn't finished. */
	ribbonFor(type: QuizType, id: string, prefix: string): RibbonTier | null {
		if (!this.isCompleted(type, id, prefix)) return null;
		const laps = lapsForStreak(this.peekStats(prefix).bestStreakAbsolute);
		// A play-through quiz has no streak of its own; it still earns bronze.
		return ribbonTierForLaps(Math.max(laps, lapsForTier('bronze')));
	}

	// -- placement -----------------------------------------------------------

	isPlacementUnlocked(ref: string): boolean {
		return this.placementUnlocked.includes(ref);
	}

	async setPlacementUnlocked(refs: string[]): Promise<void> {
		this.placementUnlocked = refs;
		await this.writeList(SettingsKeys.placementUnlockedQuizzes, refs);
	}

	// -- settings ------------------------------------------------------------

	async setRelaxedCorrection(value: boolean): Promise<void> {
		this.relaxedCorrection = value;
		await storage.set(SettingsKeys.relaxedCorrection, String(value));
	}

	async setShowFirstLetterHint(value: boolean): Promise<void> {
		this.showFirstLetterHint = value;
		await storage.set(SettingsKeys.showFirstLetterHint, String(value));
	}

	/** Wipes every trace of progress — the "start over" path. */
	async reset(): Promise<void> {
		for (const key of await storage.keys()) {
			if (key.includes('quiz_') || key.endsWith('_completed_quizzes')) {
				await storage.remove(key);
			}
		}
		this.stats = {};
		this.completed = {};
		this.placementUnlocked = [];
	}
}

export const progress = new ProgressStore();
