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
import { setVoiceOfflineOnly } from '$lib/services/speech';
import { storage } from '$lib/services/storage';
import type { QuizType } from '$lib/content/types';

/**
 * How long a revealed answer stays on screen before the next question.
 * Values match the Dart `AnswerRevealMode` enum, and are persisted under the
 * same key, so the setting carries over.
 */
export type AnswerRevealMode = 'quick' | 'normal' | 'slow';

/** The pause, in ms, for each mode — the Dart durations verbatim. */
export const REVEAL_PAUSE: Record<AnswerRevealMode, number> = {
	quick: 500,
	normal: 1500,
	slow: 3000
};

/** How many answers the per-quiz history keeps; enough to rank weak spots. */
const ANSWER_HISTORY_LIMIT = 200;

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

	gating = $state<Gating>(DEFAULT_GATING);
	/**
	 * On by default: a missing umlaut or full stop is a keyboard problem, not a
	 * German one, and marking it wrong teaches nothing. Only an explicit "false"
	 * in storage turns it off, so a learner who opted out keeps their choice.
	 */
	relaxedCorrection = $state(true);
	showFirstLetterHint = $state(false);
	/** Skip the cloud neural voice and use the on-device one only. */
	voiceOfflineOnly = $state(false);
	/** How long the answer stays revealed before the next question. */
	answerRevealMode = $state<AnswerRevealMode>('normal');
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
		this.relaxedCorrection = (await storage.get(SettingsKeys.relaxedCorrection)) !== 'false';
		this.showFirstLetterHint =
			(await storage.get(SettingsKeys.showFirstLetterHint)) === 'true';
		this.voiceOfflineOnly = (await storage.get(SettingsKeys.voiceOfflineOnly)) === 'true';
		// The TTS chain reads a plain flag rather than this store, so it stays
		// free of framework imports and ports to Capacitor untouched.
		setVoiceOfflineOnly(this.voiceOfflineOnly);
		const mode = await storage.get(SettingsKeys.answerRevealMode);
		if (mode === 'quick' || mode === 'normal' || mode === 'slow') {
			this.answerRevealMode = mode;
		}
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

	/**
	 * One quiz's answer history: how much was answered, how much of it was
	 * wrong, and which categories the mistakes landed on. Only the worksheet's
	 * weak-spot mode reads this, so it goes straight to storage rather than
	 * into the rune state — and it reads the Flutter keys, so history earned
	 * in the old build still ranks the sheet.
	 */
	async historyFor(prefix: string): Promise<{
		answered: number;
		mistakeRate: number;
		mistakesByCategory: Record<string, number>;
	}> {
		const keys = quizStatsKeys(prefix);
		const history = await this.readJson(keys.answerHistory);
		const entries = Array.isArray(history) ? history : [];
		const correct = entries.filter(
			(entry) => (entry as { correct?: unknown })?.correct === true
		).length;
		const mistakes = await this.readJson(keys.mistakesByCase);
		const mistakesByCategory: Record<string, number> = {};
		if (mistakes && typeof mistakes === 'object' && !Array.isArray(mistakes)) {
			for (const [label, count] of Object.entries(mistakes)) {
				mistakesByCategory[label] = Number(count) || 0;
			}
		}
		return {
			answered: entries.length,
			mistakeRate: entries.length === 0 ? 0 : 1 - correct / entries.length,
			mistakesByCategory
		};
	}

	private async readJson(key: string): Promise<unknown> {
		const raw = await storage.get(key);
		if (!raw) return null;
		try {
			return JSON.parse(raw);
		} catch {
			return null;
		}
	}

	/**
	 * Appends to the answer history and, for a wrong answer, to the per-category
	 * mistake counts. The history is capped: it exists to rank weak spots, not
	 * to be a full log, and an uncapped list in localStorage grows forever.
	 */
	private async recordHistory(
		prefix: string,
		correct: boolean,
		categoryLabel?: string
	): Promise<void> {
		const keys = quizStatsKeys(prefix);
		const previous = await this.readJson(keys.answerHistory);
		const entries = Array.isArray(previous) ? previous : [];
		entries.push({ correct });
		await storage.set(
			keys.answerHistory,
			JSON.stringify(entries.slice(-ANSWER_HISTORY_LIMIT))
		);

		if (correct || !categoryLabel) return;
		const stored = await this.readJson(keys.mistakesByCase);
		const mistakes: Record<string, number> =
			stored && typeof stored === 'object' && !Array.isArray(stored)
				? (stored as Record<string, number>)
				: {};
		mistakes[categoryLabel] = (Number(mistakes[categoryLabel]) || 0) + 1;
		await storage.set(keys.mistakesByCase, JSON.stringify(mistakes));
	}

	/** Records one answer and returns the updated stats. */
	async recordAnswer(
		prefix: string,
		correct: boolean,
		categoryLabel?: string
	): Promise<QuizStats> {
		await this.recordHistory(prefix, correct, categoryLabel);
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
			// Fill-in has no set of its own: the goal streak is completion. But the
			// streak lives in per-quiz stats that load lazily, so a page that hasn't
			// called `hydrateStats` would read every fill-in as unfinished and lock
			// the rest of the ladder. The quest set is written for every kind, so
			// check it first: it is the durable record, the streak the fallback for
			// progress earned in the Flutter build, which never wrote that set.
			return (
				this.isQuestCompleted(id) ||
				isQuizDone(this.peekStats(prefix).bestStreakAbsolute, this.gating)
			);
		}
		return (this.completed[key] ?? []).includes(id);
	}

	/**
	 * Loads the stats for many quizzes at once. Any view that reads `peekStats`
	 * for quizzes the learner hasn't just played — the ladder's ribbons, the
	 * progress ring — must await this first, or it renders zeros.
	 */
	async hydrateStats(prefixes: string[]): Promise<void> {
		for (const prefix of prefixes) await this.statsFor(prefix);
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

	// -- settings ------------------------------------------------------------

	async setRelaxedCorrection(value: boolean): Promise<void> {
		this.relaxedCorrection = value;
		await storage.set(SettingsKeys.relaxedCorrection, String(value));
	}

	async setShowFirstLetterHint(value: boolean): Promise<void> {
		this.showFirstLetterHint = value;
		await storage.set(SettingsKeys.showFirstLetterHint, String(value));
	}

	async setVoiceOfflineOnly(value: boolean): Promise<void> {
		this.voiceOfflineOnly = value;
		setVoiceOfflineOnly(value);
		await storage.set(SettingsKeys.voiceOfflineOnly, String(value));
	}

	async setAnswerRevealMode(value: AnswerRevealMode): Promise<void> {
		this.answerRevealMode = value;
		await storage.set(SettingsKeys.answerRevealMode, value);
	}

	/** Wipes every trace of progress — the "start over" path. */
	async reset(): Promise<void> {
		for (const key of await storage.keys()) {
			if (key.includes('quiz_') || key.endsWith('_completed_quizzes')) {
				await storage.remove(key);
			}
		}
		// Nothing reads this any more — levels are never locked — but a learner
		// who used the gated build still has it, and "start over" should leave
		// nothing behind. It matches neither filter above, hence by name.
		await storage.remove(SettingsKeys.placementUnlockedQuizzes);
		this.stats = {};
		this.completed = {};
	}
}

export const progress = new ProgressStore();
