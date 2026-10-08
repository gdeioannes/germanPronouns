// The learner's progress: per-quiz stats and the completion sets behind the
// deck's done ticks. One module-level rune store, loaded once at startup.
//
// Reads and writes the same keys the Flutter build used (see domain/keys.ts),
// so a learner's existing scores, streaks and unlocked levels carry over.

import { quizStatsKeys, SettingsKeys } from '$lib/domain/keys';
import {
	legacyStreakDone,
	medalCrossed,
	medalForStreak,
	runPassed,
	STREAK_LAP_SIZE,
	type QuizMark,
	type RibbonTier
} from '$lib/domain/progress';
import { applyCalmEffects } from '$lib/motion/fx.svelte';
import { setMuted } from '$lib/services/mute';
import { setSoundEffects } from '$lib/services/sounds';
import { setVoiceOfflineOnly, tts } from '$lib/services/speech';
import { storage } from '$lib/services/storage';
import type { QuizType } from '$lib/content/types';

/**
 * How long a revealed answer stays on screen before the next question.
 * Values match the Dart `AnswerRevealMode` enum, and are persisted under the
 * same key, so the setting carries over.
 */
export type AnswerRevealMode = 'quick' | 'normal' | 'slow' | 'manual';

/** The pause, in ms, for each mode — the Dart durations verbatim. */
/**
 * The shortest time an answered question stays on screen, even when Enter
 * asks to skip ahead — long enough for the verdict to register.
 */
export const MIN_SHOW = 450;

export const REVEAL_PAUSE: Record<Exclude<AnswerRevealMode, 'manual'>, number> = {
	quick: 500,
	normal: 1500,
	slow: 3000
};

/**
 * The pause before moving on by itself, or null in 'manual' mode — web-only,
 * for anyone who needs as long as it takes (a screen reader finishing the
 * verdict, a slow reader): the answer stays until Next or Enter.
 */
export function revealPause(mode: AnswerRevealMode): number | null {
	return mode === 'manual' ? null : REVEAL_PAUSE[mode];
}

/** How many answers the per-quiz history keeps; enough to rank weak spots. */
const ANSWER_HISTORY_LIMIT = 200;
/** How many of the latest answers say how the learner is doing *now*. */
const RECENT_WINDOW = 20;
/** How many finished runs the per-quiz run log keeps. */
const RUN_LOG_LIMIT = 50;

export interface QuizStats {
	score: number;
	/** Right answers in a row, carried across runs and visits; a miss zeroes it. */
	streak: number;
	bestStreakLap: number;
	bestStreakAbsolute: number;
}

/** What one answer did to the stats, and the medal it crossed into, if any. */
export interface AnswerResult extends QuizStats {
	earned: RibbonTier | null;
}

/** One finished run of a drill, as the run log records it. */
export interface RunRecord {
	at: number;
	right: number;
	total: number;
	bestStreak: number;
}

const EMPTY_STATS: QuizStats = {
	score: 0,
	streak: 0,
	bestStreakLap: 0,
	bestStreakAbsolute: 0
};

/**
 * Which completion set a quiz kind records into. The drills (fill-in,
 * flashcards) have none of their own: a finished run writes the quest set,
 * which is what this returning null means.
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
		case 'vocabulary':
		case 'suchbild':
			// Run-driven: finishing a run marks the quest set, nothing else.
			return null;
	}
}

/**
 * The kinds played in runs of ten and scored by streak — so their mark is
 * the streak's medal, not a bronze for turning up. Dictation keeps a
 * completion set of its own (the Flutter build wrote one) but is otherwise
 * a drill like the fill-in.
 */
function isDrill(type: QuizType): boolean {
	return type === 'fillBlank' || type === 'vocabulary' || type === 'suchbild' || type === 'dictation';
}

class ProgressStore {
	/** Per-quiz stats, keyed by storageKeyPrefix. */
	private stats = $state<Record<string, QuizStats>>({});
	/** Completion sets, keyed by the settings key that holds them. */
	private completed = $state<Record<string, string[]>>({});
	/** Each drill's finished runs, loaded with its stats so the mark reads synchronously. */
	private runs = $state<Record<string, RunRecord[]>>({});

	/**
	 * On by default: a missing umlaut or full stop is a keyboard problem, not a
	 * German one, and marking it wrong teaches nothing. Only an explicit "false"
	 * in storage turns it off, so a learner who opted out keeps their choice.
	 */
	relaxedCorrection = $state(true);
	showFirstLetterHint = $state(false);
	/**
	 * Word help: recognised nouns coloured by gender and tappable for their
	 * article and meaning. The Dart build defaulted this off and hid it in
	 * settings; on is the point of the feature, so only an explicit "false"
	 * turns it off — and it keeps the Dart key, so a learner who switched it on
	 * there still has it on.
	 */
	wordHelp = $state(true);
	/** Skip the cloud neural voice and use the on-device one only. */
	voiceOfflineOnly = $state(false);
	/** Calm effects: no confetti, praise, glows, shakes or flicker. */
	calmEffects = $state(false);
	/** Chimes on right, wrong, streak milestones and a finished quiz. */
	soundEffects = $state(true);
	/** Mute the app: no sound effects and no read-aloud voice. */
	muted = $state(false);
	/**
	 * Listening exercises (dictation, listen-and-answer) offer a "Show the
	 * text" button, for a learner who can't hear the audio. Off by default:
	 * for everyone else the hidden text is the exercise.
	 */
	showTranscripts = $state(false);
	/** How long the answer stays revealed before the next question. */
	answerRevealMode = $state<AnswerRevealMode>('normal');
	loaded = $state(false);

	async load(): Promise<void> {
		// A fresh read of storage: any stats cached from before are stale.
		this.stats = {};
		this.runs = {};
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
		this.wordHelp = (await storage.get(SettingsKeys.colorNouns)) !== 'false';
		this.voiceOfflineOnly = (await storage.get(SettingsKeys.voiceOfflineOnly)) === 'true';
		// The TTS chain reads a plain flag rather than this store, so it stays
		// free of framework imports and ports to Capacitor untouched.
		setVoiceOfflineOnly(this.voiceOfflineOnly);
		this.calmEffects = (await storage.get(SettingsKeys.calmEffects)) === 'true';
		applyCalmEffects(this.calmEffects);
		this.soundEffects = (await storage.get(SettingsKeys.soundEffects)) !== 'false';
		setSoundEffects(this.soundEffects);
		this.muted = (await storage.get(SettingsKeys.muted)) === 'true';
		setMuted(this.muted);
		this.showTranscripts = (await storage.get(SettingsKeys.showTranscripts)) === 'true';
		const mode = await storage.get(SettingsKeys.answerRevealMode);
		if (mode === 'quick' || mode === 'normal' || mode === 'slow' || mode === 'manual') {
			this.answerRevealMode = mode;
		}
		this.loaded = true;
	}

	/**
	 * Whether this browser holds any progress at all — an answer given or an
	 * exercise finished. Reads keys only, so the landing page can ask without
	 * loading the course.
	 */
	async hasAnyProgress(): Promise<boolean> {
		for (const key of await storage.keys()) {
			if (key.endsWith('quiz_answer_history')) return true;
			if (key.endsWith('_completed_quizzes') && (await this.readList(key)).length > 0) return true;
		}
		return false;
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
		this.runs = { ...this.runs, [prefix]: await this.readRuns(prefix) };
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
		/** Mistake share over the last RECENT_WINDOW answers only. */
		recentMistakeRate: number;
		/** Epoch ms of the last answer or finish; null when never played or before timestamps existed. */
		lastPlayedAt: number | null;
		mistakesByCategory: Record<string, number>;
		/** Finished runs of a drill (zero for the other kinds). */
		runs: number;
	}> {
		const keys = quizStatsKeys(prefix);
		const history = await this.readJson(keys.answerHistory);
		const entries = Array.isArray(history) ? history : [];
		const isCorrect = (entry: unknown) => (entry as { correct?: unknown })?.correct === true;
		const correct = entries.filter(isCorrect).length;
		const recent = entries.slice(-RECENT_WINDOW);
		const recentCorrect = recent.filter(isCorrect).length;
		// Entries written before timestamps existed have no `at`; the play-through
		// kinds write only the lastPlayed key. Take whichever is latest.
		let lastPlayedAt = Number(await storage.get(keys.lastPlayed)) || null;
		for (const entry of entries) {
			const at = Number((entry as { at?: unknown })?.at);
			if (at && (!lastPlayedAt || at > lastPlayedAt)) lastPlayedAt = at;
		}
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
			recentMistakeRate: recent.length === 0 ? 0 : 1 - recentCorrect / recent.length,
			lastPlayedAt,
			mistakesByCategory,
			runs: (await this.runsFor(prefix)).length
		};
	}

	/** The finished runs of one drill, oldest first. */
	async runsFor(prefix: string): Promise<RunRecord[]> {
		return this.runs[prefix] ?? (await this.readRuns(prefix));
	}

	private async readRuns(prefix: string): Promise<RunRecord[]> {
		const raw = await this.readJson(quizStatsKeys(prefix).runLog);
		if (!Array.isArray(raw)) return [];
		return raw.flatMap((entry) => {
			const r = entry as Partial<RunRecord> | null;
			return r && typeof r.at === 'number' && typeof r.right === 'number' && typeof r.total === 'number'
				? [{ at: r.at, right: r.right, total: r.total, bestStreak: Number(r.bestStreak) || 0 }]
				: [];
		});
	}

	/**
	 * Logs a finished run — how many of its answers were right and the best
	 * streak inside it — so the deck can tell a drill that needs more
	 * repetitions from one that is held. Capped like the answer history.
	 */
	async recordRun(prefix: string, run: Omit<RunRecord, 'at'>): Promise<void> {
		const runs = [...(await this.runsFor(prefix)), { ...run, at: Date.now() }].slice(-RUN_LOG_LIMIT);
		this.runs = { ...this.runs, [prefix]: runs };
		await storage.set(quizStatsKeys(prefix).runLog, JSON.stringify(runs));
	}

	/**
	 * Whether the last finished run passed. True with no run on record: an
	 * exercise finished under the old rules, or a kind without runs, is not
	 * sent back for a retry.
	 */
	lastRunPassed(prefix: string): boolean {
		const runs = this.runs[prefix] ?? [];
		const last = runs[runs.length - 1];
		return !last || runPassed(last.right, last.total);
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
		entries.push({ correct, at: Date.now() });
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

	/**
	 * Records one answer and returns the updated stats. A right answer grows
	 * the streak; a miss starts it again at zero — it costs nothing else. The
	 * answer that lands the streak exactly on a medal boundary reports the
	 * medal in `earned`, so the quiz can celebrate the crossing.
	 */
	async recordAnswer(
		prefix: string,
		correct: boolean,
		categoryLabel?: string
	): Promise<AnswerResult> {
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
		return { ...next, earned: correct ? medalCrossed(streak) : null };
	}

	/**
	 * Stamps "played now" on a quiz. Answered kinds get it with every answer;
	 * the play-through kinds (reading, speaking) call it on finish, since they
	 * keep no answer history for the deck's spaced review to date from.
	 */
	async markPlayed(prefix: string): Promise<void> {
		await storage.set(quizStatsKeys(prefix).lastPlayed, String(Date.now()));
	}

	// -- completion ----------------------------------------------------------

	isCompleted(type: QuizType, id: string, prefix: string): boolean {
		const key = completionKeyFor(type);
		if (key === null) {
			// A drill has no set of its own: a finished run writes the quest set,
			// and that is the durable record. The streak fallback is for progress
			// earned in the Flutter build, which never wrote that set — it lives in
			// per-quiz stats that load lazily, so a page that hasn't called
			// `hydrateStats` only sees the quest set.
			return this.isQuestCompleted(id) || legacyStreakDone(this.peekStats(prefix).bestStreakAbsolute);
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

	/**
	 * The ribbon a finished quiz shows, or null when it isn't finished or has
	 * no medal. A drill's tier is its streak's medal, nothing less; a
	 * play-through kind has no streak and shows bronze for the finish.
	 */
	ribbonFor(type: QuizType, id: string, prefix: string): RibbonTier | null {
		if (!this.isCompleted(type, id, prefix)) return null;
		if (isDrill(type)) return this.medalFor(prefix);
		return 'bronze';
	}

	/**
	 * The mark a finished quiz carries, or null when it isn't finished: its
	 * medal if the streak has earned one, else a done tick when the last run
	 * passed, else "try again".
	 */
	markFor(type: QuizType, id: string, prefix: string): QuizMark | null {
		if (!this.isCompleted(type, id, prefix)) return null;
		const ribbon = this.ribbonFor(type, id, prefix);
		if (ribbon) return ribbon;
		return this.lastRunPassed(prefix) ? 'done' : 'retry';
	}

	/** The medal the streak has earned so far, finished or not. */
	medalFor(prefix: string): RibbonTier | null {
		return medalForStreak(this.peekStats(prefix).bestStreakAbsolute);
	}

	// -- settings ------------------------------------------------------------

	async setRelaxedCorrection(value: boolean): Promise<void> {
		this.relaxedCorrection = value;
		await storage.set(SettingsKeys.relaxedCorrection, String(value));
	}

	async setWordHelp(value: boolean): Promise<void> {
		this.wordHelp = value;
		await storage.set(SettingsKeys.colorNouns, String(value));
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

	async setCalmEffects(value: boolean): Promise<void> {
		this.calmEffects = value;
		applyCalmEffects(value);
		await storage.set(SettingsKeys.calmEffects, String(value));
	}

	async setShowTranscripts(value: boolean): Promise<void> {
		this.showTranscripts = value;
		await storage.set(SettingsKeys.showTranscripts, String(value));
	}

	async setSoundEffects(value: boolean): Promise<void> {
		this.soundEffects = value;
		setSoundEffects(value);
		await storage.set(SettingsKeys.soundEffects, String(value));
	}

	async setMuted(value: boolean): Promise<void> {
		this.muted = value;
		setMuted(value);
		// Cut off a sentence that is already being read.
		if (value) void tts.stop();
		await storage.set(SettingsKeys.muted, String(value));
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
