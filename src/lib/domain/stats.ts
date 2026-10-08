// The learner's progress, summarised for the course home: the ring beside the
// deck chip (the current sub-level) and the progress panel it opens.
//
// Pure over QuizFacts; `now` is a parameter so tests are stable.

import type { QuizSummary as Quiz, QuizType } from '$lib/content/types';
import type { RibbonTier } from './progress';
import type { QuizFacts } from './recommend';
import { reviewDue, topicLabel, topicMastery } from './review';

const DAY = 24 * 60 * 60 * 1000;

/** A sub-level counts as "almost through" from this share done. */
export const ALMOST_THROUGH = 0.8;
/** Answers on a topic before it is reported as a strength or weak spot. */
export const TOPIC_MIN_ANSWERS = 10;
/** A topic with at least this mistake rate is a weak spot. */
export const WEAK_TOPIC_RATE = 0.25;
/** A topic with at most this mistake rate is a strength. */
export const STRONG_TOPIC_RATE = 0.15;

export interface Tally {
	done: number;
	total: number;
}

export interface LevelProgress extends Tally {
	level: string;
	title: string;
}

export interface TypeProgress extends Tally {
	type: QuizType;
	/** Share of right answers across the type's exercises; null when none given. */
	accuracy: number | null;
}

export interface TopicStat {
	topic: string;
	label: string;
	accuracy: number;
	answered: number;
}

export interface ProgressStats {
	course: Tally;
	levels: LevelProgress[];
	types: TypeProgress[];
	medals: Record<RibbonTier, number>;
	answers: number;
	/** Share of right answers over all history; null before any answer. */
	accuracy: number | null;
	/** The same over each exercise's latest answers — how it is going now. */
	recentAccuracy: number | null;
	/** Exercises played in the last seven days. */
	playedThisWeek: number;
	/** Days since anything was last played; null if never (or undated). */
	daysSincePlayed: number | null;
	reviewsDue: number;
	strengths: TopicStat[];
	weakSpots: TopicStat[];
}

/** The order the type rows appear in — the order exercises are met in. */
const TYPE_ORDER: QuizType[] = [
	'fillBlank',
	'vocabulary',
	'suchbild',
	'reading',
	'listening',
	'dictation',
	'speakRepeat',
	'speaking'
];

export function progressStats(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	levelTitles: Record<string, string>,
	now: number = Date.now()
): ProgressStats {
	const live = quizzes.filter((quiz) => quiz.status !== 'placeholder');
	const factsOf = (quiz: Quiz) => facts[quiz.id];
	const isDone = (quiz: Quiz) => factsOf(quiz)?.done ?? false;

	const levels: LevelProgress[] = [];
	for (const quiz of live) {
		const level = quiz.level ?? '';
		if (!level) continue;
		let row = levels.find((l) => l.level === level);
		if (!row) {
			row = { level, title: levelTitles[level] ?? level, done: 0, total: 0 };
			levels.push(row);
		}
		row.total++;
		if (isDone(quiz)) row.done++;
	}

	const types: TypeProgress[] = [];
	for (const type of TYPE_ORDER) {
		const ofType = live.filter((quiz) => quiz.type === type);
		if (ofType.length === 0) continue;
		const { right, given } = answerTotals(ofType, facts);
		types.push({
			type,
			done: ofType.filter(isDone).length,
			total: ofType.length,
			accuracy: given ? right / given : null
		});
	}

	const medals: Record<RibbonTier, number> = { bronze: 0, silver: 0, gold: 0 };
	let playedThisWeek = 0;
	let lastPlayed: number | null = null;
	let recentRight = 0;
	let recentGiven = 0;
	for (const quiz of live) {
		const f = factsOf(quiz);
		if (!f) continue;
		if (f.done && f.tier) medals[f.tier]++;
		const at = f.lastPlayedAt ?? null;
		if (at) {
			if (now - at < 7 * DAY) playedThisWeek++;
			if (lastPlayed === null || at > lastPlayed) lastPlayed = at;
		}
		// The recent rate covers at most the last 20 answers of each exercise.
		const window = Math.min(f.answered, 20);
		recentGiven += window;
		recentRight += window * (1 - (f.recentMistakeRate ?? f.mistakeRate));
	}

	const { right, given } = answerTotals(live, facts);
	const mastery = [...topicMastery(live, facts)]
		.filter(([, m]) => m.answered >= TOPIC_MIN_ANSWERS)
		.map(
			([topic, m]): TopicStat => ({
				topic,
				label: topicLabel(topic),
				accuracy: 1 - m.mistakeRate,
				answered: m.answered
			})
		);

	return {
		course: { done: live.filter(isDone).length, total: live.length },
		levels,
		types,
		medals,
		answers: given,
		accuracy: given ? right / given : null,
		recentAccuracy: recentGiven ? recentRight / recentGiven : null,
		playedThisWeek,
		daysSincePlayed: lastPlayed === null ? null : Math.max(0, Math.floor((now - lastPlayed) / DAY)),
		reviewsDue: reviewDue(live, facts, () => true, now).length,
		strengths: mastery
			.filter((t) => 1 - t.accuracy <= STRONG_TOPIC_RATE)
			.sort((a, b) => b.accuracy - a.accuracy || b.answered - a.answered)
			.slice(0, 3),
		weakSpots: mastery
			.filter((t) => 1 - t.accuracy >= WEAK_TOPIC_RATE)
			.sort((a, b) => a.accuracy - b.accuracy || b.answered - a.answered)
			.slice(0, 3)
	};
}

function answerTotals(quizzes: Quiz[], facts: Record<string, QuizFacts>) {
	let right = 0;
	let given = 0;
	for (const quiz of quizzes) {
		const f = facts[quiz.id];
		if (!f?.answered) continue;
		given += f.answered;
		right += f.answered * (1 - f.mistakeRate);
	}
	return { right: Math.round(right), given };
}

/** Whole-number percent of a tally; 0 for an empty one. */
export function percentOf({ done, total }: Tally): number {
	return total === 0 ? 0 : Math.round((done / total) * 100);
}

/**
 * The short line under the ring's number: how far through the sub-level,
 * turning into a countdown near the end. "A1.1 · 4 / 30", "A1.1 · 3 to go",
 * "A1.1 · done".
 */
export function levelLine(level: LevelProgress): string {
	const left = level.total - level.done;
	if (level.total > 0 && left === 0) return `${level.level} · done`;
	if (level.total > 0 && level.done / level.total >= ALMOST_THROUGH) return `${level.level} · ${left} to go`;
	return `${level.level} · ${level.done} / ${level.total}`;
}
