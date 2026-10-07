// The progression rules. Pure functions with no framework or platform
// dependency, so they are directly unit-testable and survive a Capacitor wrap
// untouched.
//
// A drill (fill-in, flashcards) is played in RUNS and scored by STREAK, and
// the two never fight each other:
//
//   * A run is RUN_LENGTH answers, right or wrong. Its bar only ever moves
//     forward, and finishing a run marks the exercise whatever the score: a
//     done tick at RUN_PASS_MARK or better, a "try again" mark below that.
//     A missed item comes back round inside the same run, so the run ends on
//     the fix.
//   * The streak is right answers in a row, carried across runs and visits.
//     A miss simply starts it again at zero — no lives, no penalty beyond
//     that. Crossing 8, 16 and 24 in a row earns bronze, silver and gold,
//     whenever it happens: mid-run, at the end, or three runs later. The
//     medal is the exercise's mark from then on.
//
// The old rule — hold a goal streak or the exercise never ends, and a fourth
// slip wipes the count — turned a late mistake into losing everything.

/** The medal tier a finished quiz's ribbon shows. */
export type RibbonTier = 'bronze' | 'silver' | 'gold';

/** Answers in one run of a drill. Every drill pool holds at least this many. */
export const RUN_LENGTH = 10;

/** Right answers a run needs for the done tick rather than the retry mark. */
export const RUN_PASS_MARK = 8;

/** What a finished exercise carries: its medal, a done tick, or "try again". */
export type QuizMark = RibbonTier | 'done' | 'retry';

export function runPassed(right: number, total = RUN_LENGTH): boolean {
	return total > 0 && right / total >= RUN_PASS_MARK / RUN_LENGTH;
}

/** Correct answers per streak "lap" — the unit the medals are counted in. */
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

/** The streak that earns each medal. */
export const TIER_STREAKS: Record<RibbonTier, number> = {
	bronze: 8,
	silver: 16,
	gold: 24
};

/** The streak that earns `tier`: 8, 16, 24. */
export function streakForTier(tier: RibbonTier): number {
	return TIER_STREAKS[tier];
}

export const TIER_COLORS: Record<RibbonTier, string> = {
	gold: '#D7A93A',
	silver: '#AAB2BE',
	bronze: '#C07F49'
};

export const TIER_LABELS: Record<RibbonTier, string> = {
	gold: 'Gold',
	silver: 'Silver',
	bronze: 'Bronze'
};

/**
 * The medal, in words. The celebration is a stamp, confetti and a fanfare —
 * all of which the effects layer hides from a screen reader — so the medal
 * has to be said in the same announcement that reports the answer.
 */
export function medalAnnouncement(tier: RibbonTier, streak: number): string {
	return `${TIER_LABELS[tier]} medal! ${streak} in a row.`;
}

/** How many laps a best streak represents. */
export function lapsForStreak(bestStreakAbsolute: number): number {
	return Math.floor(bestStreakAbsolute / STREAK_LAP_SIZE);
}

/** The medal a streak has earned, or null below the first one. */
export function medalForStreak(streak: number): RibbonTier | null {
	for (const tier of ['gold', 'silver', 'bronze'] as const) {
		if (streak >= TIER_STREAKS[tier]) return tier;
	}
	return null;
}

/**
 * The medal an answer just crossed into: the streak landed exactly on a
 * medal's boundary. Null for every other answer, so the celebration fires on
 * the crossing and only then.
 */
export function medalCrossed(streak: number): RibbonTier | null {
	for (const tier of ['gold', 'silver', 'bronze'] as const) {
		if (streak === streakForTier(tier)) return tier;
	}
	return null;
}

/** The next medal up from `streak`, and the streak it needs; null past gold. */
export function nextMedal(streak: number): { tier: RibbonTier; at: number } | null {
	for (const tier of ['bronze', 'silver', 'gold'] as const) {
		const at = streakForTier(tier);
		if (streak < at) return { tier, at };
	}
	return null;
}

/**
 * The Flutter build's completion rule for a drill: hold a streak of ten.
 * It wrote no completion set, so progress earned there is read from the
 * best streak alone. Every finish since writes the quest set.
 */
export const LEGACY_GOAL_STREAK = 10;

export function legacyStreakDone(bestStreakAbsolute: number): boolean {
	return bestStreakAbsolute >= LEGACY_GOAL_STREAK;
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
	/** The level of the exercise that produced it, so it is only replayed at or above it. */
	level?: string;
}

const SCORE_LINE = /SCORE\s*=\s*(\d{1,3})/i;
const FIX_LINE = /^\s*-?\s*FIX:\s*(.+?)\s*(?:->|→)\s*(.+?)\s*$/gim;
// An AI that ignores "no explanation" tends to append one in brackets:
// "ich bin gegangen (sein for movement)". The trainer wants only the sentence.
const TRAILING_NOTE = /\s*[(\[（][^()\[\]（）]*[)\]）]\s*$/;

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
		const said = match[1].replace(TRAILING_NOTE, '').replace(/^["„“]|["“”]$/g, '').trim();
		const correct = match[2].replace(TRAILING_NOTE, '').replace(/^["„“]|["“”]$/g, '').trim();
		if (said && correct) fixes.push({ said, correct });
	}
	return fixes;
}
