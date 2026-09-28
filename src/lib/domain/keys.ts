// Every persisted key, mirrored verbatim from lib/models/settings_keys.dart
// and lib/models/quiz_stats_keys.dart.
//
// These strings are a compatibility contract, not an implementation detail: a
// learner who used the Flutter build has progress saved under them in the same
// browser origin. Keeping them identical means the port inherits that progress
// instead of resetting it. Never rename one.

export const SettingsKeys = {
	disabledNouns: 'global_disabled_nouns',
	showEnglishPrefix: 'show_english_',
	colorNouns: 'color_nouns',
	lastPage: 'last_page',
	lastContentId: 'last_content_id',
	lastNounProgressionKey: 'last_noun_progression_key',
	answerRevealMode: 'answer_reveal_mode',
	progressionUnlockLaps: 'progression_unlock_laps',
	showFirstLetterHint: 'show_first_letter_hint',
	relaxedCorrection: 'relaxed_correction',
	speakingFixLogPrefix: 'speaking_fix_log_',
	questUnlockLaps: 'quest_unlock_laps',
	completedQuestQuizzes: 'quest_completed_quizzes',
	lastQuestQuizKey: 'last_quest_quiz_key',
	completedSpeakQuizzes: 'speak_completed_quizzes',
	completedReadingQuizzes: 'reading_completed_quizzes',
	completedListeningQuizzes: 'listening_completed_quizzes',
	completedDictationQuizzes: 'dictation_completed_quizzes',
	placementUnlockedQuizzes: 'placement_unlocked_quizzes',
	seenHelpMemory: 'seen_help_memory',
	voiceOfflineOnly: 'voice_offline_only',
	/** Web-only (no Flutter twin). Also read verbatim by the script in app.html. */
	calmEffects: 'calm_effects',
	/** Web-only. Only an explicit "false" mutes: sound is on by default. */
	soundEffects: 'sound_effects',
	/** Web-only. Silences sound effects and the read-aloud voice alike. */
	muted: 'app_muted'
} as const;

/**
 * The per-quiz stat keys, derived from a quiz's `storageKeyPrefix`.
 *
 * The `_pronouns` / `_cases` names are legacy and kept verbatim even for
 * quizzes that have nothing to do with pronouns — renaming them would orphan
 * saved subject/category selections.
 */
export function quizStatsKeys(prefix: string) {
	return {
		answerHistory: `${prefix}quiz_answer_history`,
		mistakesByCase: `${prefix}quiz_mistakes_by_case`,
		score: `${prefix}quiz_score`,
		streak: `${prefix}quiz_streak`,
		streakMisses: `${prefix}quiz_streak_misses`,
		bestStreakLap: `${prefix}quiz_best_streak_lap`,
		bestStreakAbsolute: `${prefix}quiz_best_streak_absolute`,
		enabledSubjects: `${prefix}quiz_enabled_pronouns`,
		enabledCategories: `${prefix}quiz_enabled_cases`
	};
}
