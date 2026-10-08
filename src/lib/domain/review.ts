// Spaced review and "build on your strengths": the two deck pools that read
// *when* and *how well* rather than just *whether* something was done.
//
//   review   — finished exercises whose refresh is due. The interval grows with
//              how well the learner holds it (medal tier, recent mistakes), the
//              way a Leitner box does: shaky ones come back tomorrow, gold ones
//              in a fortnight. Ranked most-overdue first.
//   strength — untouched exercises that share a topic the learner has shown
//              they are good at, so the next thing offered stands on solid
//              ground rather than on whatever the ladder lists next.
//
// Pure functions over QuizFacts; `now` is a parameter so tests are stable.

import type { QuizSummary as Quiz } from '$lib/content/types';
import { WEAK_MISTAKE_RATE, type QuizFacts } from './recommend';

const DAY = 24 * 60 * 60 * 1000;

/** Days before a finished exercise comes round again, by how well it is held. */
export const REVIEW_INTERVAL_DAYS = {
	/** Recent mistakes at or above WEAK_MISTAKE_RATE: back tomorrow. */
	shaky: 1,
	bronze: 3,
	silver: 7,
	gold: 14,
	/** Play-through kinds (reading, speaking) have no streak to judge by. */
	playThrough: 7
} as const;

/** Answers on a topic before its mistake rate is trusted. */
export const STRONG_MIN_ANSWERS = 10;
/** A topic mistake rate at or below this counts as a strength. */
export const STRONG_MISTAKE_RATE = 0.15;

export interface ReviewPick {
	quiz: Quiz;
	/** Days since last played, or null when the date is unknown. */
	daysAgo: number | null;
	/** The interval that made it due, in days. */
	intervalDays: number;
	reason: string;
}

export interface StrengthPick {
	quiz: Quiz;
	/** The strong topic it builds on (raw slug). */
	topic: string;
	/** Share of right answers on that topic, 0–1. */
	accuracy: number;
	reason: string;
}

export interface TopicMastery {
	answered: number;
	mistakeRate: number;
}

const EMPTY: QuizFacts = { done: false, tier: null, answered: 0, mistakeRate: 0 };

function recentRate(f: QuizFacts): number {
	return f.recentMistakeRate ?? f.mistakeRate;
}

/** The review interval one finished exercise has earned, in days. */
export function reviewIntervalDays(quiz: Quiz, f: QuizFacts): number {
	if (f.answered === 0) return REVIEW_INTERVAL_DAYS.playThrough;
	if (recentRate(f) >= WEAK_MISTAKE_RATE) return REVIEW_INTERVAL_DAYS.shaky;
	if (quiz.type !== 'fillBlank' && quiz.type !== 'vocabulary' && quiz.type !== 'suchbild') {
		return REVIEW_INTERVAL_DAYS.playThrough;
	}
	return REVIEW_INTERVAL_DAYS[f.tier ?? 'bronze'];
}

/**
 * Finished exercises due for a refresh, most overdue first. An exercise with
 * no date on record (finished before timestamps existed) is treated as just
 * due: it belongs in the pool, but behind anything known to be overdue.
 */
export function reviewDue(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	open: (quiz: Quiz) => boolean,
	now: number
): ReviewPick[] {
	const ranked: { pick: ReviewPick; overdue: number }[] = [];
	for (const quiz of quizzes) {
		const f = facts[quiz.id] ?? EMPTY;
		if (!f.done || !open(quiz)) continue;
		const intervalDays = reviewIntervalDays(quiz, f);
		const at = f.lastPlayedAt ?? null;
		const daysAgo = at ? Math.floor((now - at) / DAY) : null;
		// Unknown age ranks as exactly "just due"; a known one strictly above it.
		const overdue = daysAgo === null ? 1 : daysAgo / intervalDays + 0.001;
		if (overdue < 1) continue;
		ranked.push({
			pick: { quiz, daysAgo, intervalDays, reason: reviewReason(daysAgo, f) },
			overdue
		});
	}
	return ranked.sort((a, b) => b.overdue - a.overdue).map((r) => r.pick);
}

function reviewReason(daysAgo: number | null, f: QuizFacts): string {
	const shaky = f.answered > 0 && recentRate(f) >= WEAK_MISTAKE_RATE;
	if (daysAgo === null) return 'Done a while back — a quick pass keeps it from fading.';
	const when =
		daysAgo === 0 ? 'earlier today' : daysAgo === 1 ? 'yesterday' : `${daysAgo} days ago`;
	if (shaky) return `Last seen ${when}, and it was wobbly — a short run now will settle it.`;
	if (f.tier === 'gold') return `Gold ${when}. Nothing to prove — one lap keeps it that way.`;
	return `Last done ${when} — a refresh now is worth two later.`;
}

/**
 * How well each syllabus topic is held, pooled across every exercise that
 * covers it and weighted by answers given. A play-through finish counts as a
 * handful of right answers, so a read passage still says "seen".
 */
export function topicMastery(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>
): Map<string, TopicMastery> {
	const acc = new Map<string, { answered: number; wrong: number }>();
	for (const quiz of quizzes) {
		const f = facts[quiz.id];
		if (!f || (f.answered === 0 && !f.done)) continue;
		const answered = f.answered > 0 ? f.answered : 5;
		const wrong = f.answered > 0 ? f.answered * f.mistakeRate : 0;
		for (const topic of quiz.covers ?? []) {
			const t = acc.get(topic) ?? { answered: 0, wrong: 0 };
			t.answered += answered;
			t.wrong += wrong;
			acc.set(topic, t);
		}
	}
	const out = new Map<string, TopicMastery>();
	for (const [topic, t] of acc) {
		out.set(topic, {
			answered: t.answered,
			mistakeRate: t.answered ? t.wrong / t.answered : 0
		});
	}
	return out;
}

/** The topics the learner is demonstrably good at, best first. */
export function strongTopics(mastery: Map<string, TopicMastery>): string[] {
	return [...mastery]
		.filter(([, m]) => m.answered >= STRONG_MIN_ANSWERS && m.mistakeRate <= STRONG_MISTAKE_RATE)
		.sort((a, b) => a[1].mistakeRate - b[1].mistakeRate || b[1].answered - a[1].answered)
		.map(([topic]) => topic);
}

/**
 * Untouched, in-reach exercises that extend a strong topic. Ranked by how
 * strong the topic is, then by how much *new* ground the exercise adds — a
 * step forward, not a rerun of the same drill under a new title.
 */
export function strengths(
	quizzes: Quiz[],
	facts: Record<string, QuizFacts>,
	open: (quiz: Quiz) => boolean,
	inReach: (quiz: Quiz) => boolean
): StrengthPick[] {
	const mastery = topicMastery(quizzes, facts);
	const strong = strongTopics(mastery);
	if (strong.length === 0) return [];
	const rank = new Map(strong.map((topic, i) => [topic, i]));

	const ranked: { pick: StrengthPick; weight: number }[] = [];
	quizzes.forEach((quiz, order) => {
		const f = facts[quiz.id] ?? EMPTY;
		if (!open(quiz) || f.done || f.answered > 0 || !inReach(quiz)) return;
		const covers = quiz.covers ?? [];
		const shared = covers
			.filter((topic) => rank.has(topic))
			.sort((a, b) => rank.get(a)! - rank.get(b)!);
		if (shared.length === 0) return;
		const topic = shared[0];
		const m = mastery.get(topic)!;
		const fresh = covers.length - shared.length;
		const weight =
			(strong.length - rank.get(topic)!) * 2 + Math.min(fresh, 2) - order / 10_000;
		ranked.push({
			weight,
			pick: {
				quiz,
				topic,
				accuracy: 1 - m.mistakeRate,
				reason: strengthReason(topic, m, fresh)
			}
		});
	});
	return ranked.sort((a, b) => b.weight - a.weight).map((r) => r.pick);
}

function strengthReason(topic: string, m: TopicMastery, fresh: number): string {
	const percent = Math.round((1 - m.mistakeRate) * 100);
	const name = topicLabel(topic);
	return fresh > 0
		? `You're ${percent}% right on ${name} — this takes it somewhere new.`
		: `You're ${percent}% right on ${name}. Ride that: it makes this one easy to start.`;
}

/** "a1.accusative-articles" → "accusative articles". */
export function topicLabel(topic: string): string {
	return (
		topic
			.replace(/^[a-z]\d(?:\.\d)?\./i, '')
			.replace(/[-_]+/g, ' ')
			.trim() || topic
	);
}
