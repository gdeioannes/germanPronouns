// Where the learner is, worked out from everything they have done — not just
// the highest thing they ever finished.
//
// One finished C2.2 exercise after a month of A1 does not make someone a C2
// learner; it was a peek. So a sub-level only counts as "held" once there is
// real evidence at it, and finished work that went badly counts for little.
// The deck, the recommendation pools, the story/song cards and the level chip
// all centre on the level this returns, so they agree with each other.

import type { QuizSummary as Quiz } from '$lib/content/types';
import type { QuizFacts } from './recommend';

/** A mistake rate at or above this makes a finished quiz shaky / worth redoing. */
export const WEAK_MISTAKE_RATE = 0.2;

/** Solid finishes needed before a sub-level counts as held (or all of it, if smaller). */
export const HOLD_EVIDENCE = 3;
/** A held level must also carry at least this share of all the learner's evidence. */
export const HOLD_SHARE = 0.15;
/** Answers needed before a mistake rate says anything. */
const MIN_ANSWERS = 5;
/** What a shaky finish is worth next to a solid one. */
const WEAK_WEIGHT = 0.25;

export interface LevelEvidence {
	level: string;
	total: number;
	done: number;
	/** Finishes that went well, or whose quiz keeps no answer history. */
	solid: number;
	/** Finishes with a mistake rate at or above the weak threshold. */
	weak: number;
	/** Weighted evidence: solid + weak × WEAK_WEIGHT. */
	score: number;
}

/** The distinct sub-levels of a course, in ladder order. */
export function levelsOf(quizzes: Quiz[]): string[] {
	return [...new Set(quizzes.map((quiz) => quiz.level ?? '').filter(Boolean))];
}

/** Per-sub-level tally of what the learner has finished and how it went. */
export function levelEvidence(quizzes: Quiz[], facts: Record<string, QuizFacts>): LevelEvidence[] {
	const rows = levelsOf(quizzes).map(
		(level): LevelEvidence => ({ level, total: 0, done: 0, solid: 0, weak: 0, score: 0 })
	);
	for (const quiz of quizzes) {
		const row = rows.find((r) => r.level === quiz.level);
		if (!row || quiz.status === 'placeholder') continue;
		row.total++;
		const f = facts[quiz.id];
		if (!f?.done) continue;
		row.done++;
		const rate = f.recentMistakeRate ?? f.mistakeRate;
		const shaky = f.answered >= MIN_ANSWERS && rate >= WEAK_MISTAKE_RATE;
		if (shaky) row.weak++;
		else row.solid++;
	}
	for (const row of rows) row.score = row.solid + row.weak * WEAK_WEIGHT;
	return rows;
}

/**
 * The learner's overall sub-level, or null for a course with no levels.
 *
 *   1. A level is *held* when its evidence reaches HOLD_EVIDENCE (or the whole
 *      level, when it is smaller), is at least HOLD_SHARE of everything the
 *      learner has done, and sits on a held level below it — or is most of
 *      the learner's work, as after a placement straight into B1. The
 *      highest held level is the base.
 *   2. With nothing held yet, the level with the most evidence is the base
 *      (ties go to the higher one); a newcomer starts at the first level.
 *   3. A base where most finishes went badly steps down one, so the deck eases
 *      off; a base finished through steps up one, unless the level above is
 *      already going badly.
 */
export function estimateLevel(quizzes: Quiz[], facts: Record<string, QuizFacts>): string | null {
	const rows = levelEvidence(quizzes, facts);
	if (rows.length === 0) return null;
	const totalScore = rows.reduce((n, r) => n + r.score, 0);
	const enough = (r: LevelEvidence) =>
		r.score > 0 && r.score >= Math.min(HOLD_EVIDENCE, r.total) && r.score >= totalScore * HOLD_SHARE;
	// A level is held when it has enough evidence and is not an island: the
	// level below is held too, or this level is most of what the learner has
	// done (someone placed straight into B1 has nothing below it).
	const held: boolean[] = [];
	rows.forEach((r, i) => {
		held[i] = enough(r) && (i === 0 || held[i - 1] || r.score >= totalScore * 0.5);
	});

	let index = held.lastIndexOf(true);
	if (index < 0) {
		let best = 0;
		rows.forEach((r, i) => {
			if (r.score > 0 && r.score >= rows[best].score) best = i;
		});
		index = best;
	}

	// Most finishes at a level going badly means it is too hard for now.
	const struggling = (r: LevelEvidence) => r.done >= HOLD_EVIDENCE && r.weak > r.solid;
	const base = rows[index];
	const above = rows[index + 1];
	if (struggling(base) && index > 0) index--;
	else if (base.done >= Math.max(HOLD_EVIDENCE, base.total) && above && !struggling(above)) index++;
	return rows[index].level;
}
