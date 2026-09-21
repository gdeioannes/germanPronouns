// The progression rules, ported from the Flutter app. Pure functions with no
// framework or platform dependency, so they are directly unit-testable and
// survive a Capacitor wrap untouched.
//
// Source of truth in the Dart app:
//   lib/widgets/completion_ribbon.dart  (tiers by streak laps)
//   lib/models/noun_settings.dart       (lap size, unlock streaks, isQuizDone)

/** The medal tier a finished quiz's ribbon shows. */
export type RibbonTier = 'bronze' | 'silver' | 'gold';

/** Correct answers per streak "lap". */
export const STREAK_LAP_SIZE = 5;

/**
 * Tier by streak laps: bronze from the first lap, silver at 3, gold at 5+.
 * Single source of the boundaries — every ribbon display reads this.
 */
export function ribbonTierForLaps(laps: number): RibbonTier {
	if (laps >= 5) return 'gold';
	if (laps >= 3) return 'silver';
	return 'bronze';
}

/** The lowest lap count that reaches `tier` — the inverse of the above. */
export function lapsForTier(tier: RibbonTier): number {
	return tier === 'gold' ? 5 : tier === 'silver' ? 3 : 1;
}

export const TIER_COLORS: Record<RibbonTier, string> = {
	gold: '#D7A93A',
	silver: '#AAB2BE',
	bronze: '#C07F49'
};

/** How many laps a best streak represents. */
export function lapsForStreak(bestStreakAbsolute: number): number {
	return Math.floor(bestStreakAbsolute / STREAK_LAP_SIZE);
}

/** Gating config, carried per course in the bundle's `gating` block. */
export interface Gating {
	progressionUnlockLaps: number;
	questUnlockLaps: number;
}

export const DEFAULT_GATING: Gating = {
	progressionUnlockLaps: 2,
	questUnlockLaps: 2
};

export function questUnlockStreak(gating: Gating): number {
	return gating.questUnlockLaps * STREAK_LAP_SIZE;
}

export function progressionUnlockStreak(gating: Gating): number {
	return gating.progressionUnlockLaps * STREAK_LAP_SIZE;
}

/**
 * Whether a streak-driven quiz counts as done. Fill-in quizzes have no
 * completion set of their own — reaching the goal streak *is* completion.
 */
export function isQuizDone(bestStreakAbsolute: number, gating: Gating): boolean {
	return bestStreakAbsolute >= progressionUnlockStreak(gating);
}

// ---------------------------------------------------------------------------
// Speaking scores
// ---------------------------------------------------------------------------

export type SpeakingMedal = 'bronze' | 'silver' | 'gold';

/** The learner-facing 1–10 grade for a 0–100 score. */
export function speakingGrade(score: number): number {
	return Math.min(10, Math.max(1, Math.round(score / 10)));
}

/**
 * The medal a score earns: gold at grade 9–10, silver at 7–8, bronze at 5–6,
 * and null below that — a "try again", not a failure.
 */
export function speakingMedal(score: number): SpeakingMedal | null {
	const grade = speakingGrade(score);
	if (grade >= 9) return 'gold';
	if (grade >= 7) return 'silver';
	if (grade >= 5) return 'bronze';
	return null;
}

/** A correction the AI reported, banked for the mistake trainer. */
export interface SpeakingFix {
	said: string;
	correct: string;
}

const SCORE_LINE = /SCORE\s*=\s*(\d{1,3})/i;
const FIX_LINE = /^\s*-?\s*FIX:\s*(.+?)\s*(?:->|→)\s*(.+?)\s*$/gim;

/**
 * Reads the score out of what the learner typed or pasted. The `SCORE=` line
 * wins over a bare number, so pasting a report that also says
 * "FINAL SCORE: 84 / 100" can't pick up the 100.
 */
export function parseSpeakingScore(input: string): number | null {
	const text = input.trim();
	if (!text) return null;
	const tagged = SCORE_LINE.exec(text);
	if (tagged) {
		const value = Number.parseInt(tagged[1], 10);
		return Number.isFinite(value) && value >= 0 && value <= 100 ? value : null;
	}
	if (!/^\d{1,3}$/.test(text)) return null;
	const bare = Number.parseInt(text, 10);
	return bare >= 0 && bare <= 100 ? bare : null;
}

/** Every `FIX:` correction in a pasted report. */
export function parseSpeakingFixes(input: string): SpeakingFix[] {
	const fixes: SpeakingFix[] = [];
	FIX_LINE.lastIndex = 0;
	let match: RegExpExecArray | null;
	while ((match = FIX_LINE.exec(input)) !== null) {
		fixes.push({ said: match[1], correct: match[2] });
	}
	return fixes;
}
