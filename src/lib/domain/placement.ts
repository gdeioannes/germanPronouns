// The placement test: four short parts that put a learner on the right
// sub-level before their first exercise.
//
//   1. Words: the word check's screens (domain/wordCheck), which give a first
//      estimate and so the starting point of everything after it.
//   2. Grammar: twelve multiple-choice gaps from the course's own drills, on a
//      staircase: right moves up a sub-level, wrong (or "I don't know") moves
//      down. A staircase settles where the learner gets about half right,
//      which is exactly the level to work at.
//   3. Reading: one short text at the grammar level, three questions.
//   4. Listening: one recording at the same level, three questions.
//
// Reading and listening confirm or move the grammar level by one; the word
// level pulls the result a third of the way towards it. Nothing here earns a
// medal or marks anything done: the result is a level for the deck.

import type { PopulatedCourse as Course, PassageQuestion, Quiz } from '$lib/content/types';
import { spokenPassage } from './spoken';

export interface GrammarItem {
	/** The sentence with `____` for the gap. */
	sentence: string;
	english?: string;
	answer: string;
	/** Three wrong answers. */
	wrong: string[];
	quizId: string;
}

export interface PassageItem {
	quizId: string;
	title: string;
	/** As printed (reading) or as spoken (listening, labels dropped). */
	text: string;
	questions: PassageQuestion[];
}

export interface PlacementBank {
	levels: string[];
	grammar: Record<string, GrammarItem[]>;
	reading: Record<string, PassageItem>;
	listening: Record<string, PassageItem>;
}

/** Grammar items asked in the test. */
export const GRAMMAR_ITEMS = 12;
/** The staircase moves two sub-levels per answer for this many items, then one. */
export const BIG_STEPS = 4;
/** Items per sub-level kept in the bank: enough that two tests rarely repeat. */
const BANK_PER_LEVEL = 24;
/** Questions asked per text. */
export const QUESTIONS_PER_TEXT = 3;

const levelsOf = (quizzes: Quiz[]) => [...new Set(quizzes.map((q) => q.level).filter((l): l is string => !!l))];

/**
 * The bank, built from the course at prerender time: per sub-level up to 24
 * single-gap multiple-choice sentences (spread over the drills, not one drill's
 * worth), the shortest reading text and the shortest listening text.
 */
export function buildPlacementBank(course: Course): PlacementBank {
	const levels = levelsOf(course.quizzes);
	const grammar: Record<string, GrammarItem[]> = {};
	const reading: Record<string, PassageItem> = {};
	const listening: Record<string, PassageItem> = {};
	for (const level of levels) {
		const quizzes = course.quizzes.filter((q) => q.level === level);
		// Round-robin over the drills so the bank covers the level's grammar.
		const perQuiz = quizzes.flatMap((q) =>
			q.type === 'fillBlank'
				? [
						(q.sentences ?? [])
							.filter(
								(s) =>
									s.options?.length === 3 &&
									!s.tiles &&
									s.acceptedAnswers[0] &&
									(s.sentence.match(/____/g) ?? []).length === 1 &&
									!s.options.includes(s.acceptedAnswers[0])
							)
							.map(
								(s): GrammarItem => ({
									sentence: s.sentence,
									english: s.english,
									answer: s.acceptedAnswers[0],
									wrong: s.options!,
									quizId: q.id
								})
							)
					]
				: []
		);
		const items: GrammarItem[] = [];
		for (let round = 0; items.length < BANK_PER_LEVEL && perQuiz.some((l) => l.length > round); round++)
			for (const list of perQuiz) if (list[round] && items.length < BANK_PER_LEVEL) items.push(list[round]);
		grammar[level] = items;

		const passages = (type: 'reading' | 'listening') =>
			quizzes
				.filter((q) => q.type === type && !('inlineBlanks' in q) && (q as { questions?: unknown[] }).questions?.length)
				.map((q) => q as Extract<Quiz, { type: 'reading' | 'listening' }> & { questions: PassageQuestion[] })
				.sort((a, b) => a.passage.length - b.passage.length);
		const r = passages('reading')[0];
		if (r) reading[level] = { quizId: r.id, title: r.passageTitle, text: r.passage, questions: r.questions.slice(0, QUESTIONS_PER_TEXT) };
		const l = passages('listening')[0];
		if (l) listening[level] = { quizId: l.id, title: l.passageTitle, text: spokenPassage(l.passage), questions: l.questions.slice(0, QUESTIONS_PER_TEXT) };
	}
	return { levels, grammar, reading, listening };
}

/** One answered grammar item: the level it was asked at and whether it was right. */
export interface GrammarAnswer {
	level: string;
	right: boolean;
}

/** The sub-level of the next grammar item, from the start level and the answers so far. */
export function nextGrammarLevel(levels: string[], start: string, answers: GrammarAnswer[]): string {
	let i = Math.max(0, levels.indexOf(start));
	answers.forEach((a, n) => {
		const step = n < BIG_STEPS ? 2 : 1;
		i = Math.max(0, Math.min(levels.length - 1, i + (a.right ? step : -step)));
	});
	return levels[i];
}

/**
 * Where the staircase settled: the mean index of the levels asked once the
 * steps got small, rounded, nudged down when those answers were all wrong.
 */
export function grammarLevel(levels: string[], answers: GrammarAnswer[]): string {
	if (!answers.length) return levels[0];
	const tail = answers.slice(Math.min(BIG_STEPS, answers.length - 1));
	// All right since the steps got small: the learner is still climbing, so
	// the level is where the next item would have been, not the mean.
	if (tail.every((a) => a.right)) return nextGrammarLevel(levels, answers[0].level, answers);
	const mean = tail.reduce((n, a) => n + levels.indexOf(a.level), 0) / tail.length;
	let i = Math.round(mean);
	if (!tail.some((a) => a.right)) i -= 1;
	return levels[Math.max(0, Math.min(levels.length - 1, i))];
}

export interface PlacementResult {
	level: string;
	words: string | null;
	grammar: string;
	/** Right answers out of asked, for the reading and listening texts. */
	reading: [number, number];
	listening: [number, number];
}

/**
 * The level to start at. Reading and listening at the grammar level: five or
 * six right of six moves it up one, two or fewer moves it down one. The word
 * level then pulls a third of the way.
 */
export function placementLevel(
	levels: string[],
	words: string | null,
	grammar: string,
	reading: [number, number],
	listening: [number, number]
): string {
	const clamp = (i: number) => Math.max(0, Math.min(levels.length - 1, i));
	let core = levels.indexOf(grammar);
	const asked = reading[1] + listening[1];
	if (asked) {
		const share = (reading[0] + listening[0]) / asked;
		if (share >= 5 / 6) core += 1;
		else if (share <= 1 / 3) core -= 1;
	}
	core = clamp(core);
	const w = words ? levels.indexOf(words) : -1;
	return levels[clamp(w < 0 ? core : Math.round((2 * core + w) / 3))];
}

/** Where the test results live, newest last (a small history, like the word check's). */
export const PLACEMENT_LOG = 'placement_log';
/** Set once the learner has chosen where to start (on /start), so the course stops asking. */
export const START_CHOSEN = 'start_chosen';

export interface PlacementLogEntry extends PlacementResult {
	at: number;
}

export function parsePlacementLog(raw: string | null): PlacementLogEntry[] {
	try {
		const list = JSON.parse(raw ?? '[]');
		return Array.isArray(list) ? list.filter((e) => e && typeof e.level === 'string') : [];
	} catch {
		return [];
	}
}
