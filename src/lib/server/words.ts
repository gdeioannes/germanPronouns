// The word pages' data, resolved once at build time: every noun and verb
// with its slug, and which exercises each noun appears in, so a word page
// can send the reader to practise it.

import nounData from '$content/shared/nouns/de.json';
import verbData from '$content/shared/verbs/de.json';
import { catalog, loadCourse, summarizeQuiz } from '$lib/content';
import type { QuizSummary } from '$lib/content/types';
import { vocabFor } from '$lib/domain/vocab';
import { wordSlug, type SharedNounEntry, type SharedVerbEntry } from '$lib/domain/words';

export const nouns = (nounData as { nouns: SharedNounEntry[] }).nouns;
export const verbs = (verbData as { verbs: SharedVerbEntry[] }).verbs;
export const categoryNames = (nounData as { categoryDisplayNames: Record<string, string> })
	.categoryDisplayNames;

const nounBySlug = new Map(nouns.map((n) => [wordSlug(n.noun), n]));
const verbBySlug = new Map(verbs.map((v) => [wordSlug(v.verb), v]));

export function nounForSlug(slug: string): SharedNounEntry | undefined {
	return nounBySlug.get(slug);
}

export function verbForSlug(slug: string): SharedVerbEntry | undefined {
	return verbBySlug.get(slug);
}

/** Nouns sharing a category with this one, nearest categories first. */
export function relatedNouns(entry: SharedNounEntry, limit = 12): SharedNounEntry[] {
	const out: SharedNounEntry[] = [];
	const seen = new Set([entry.noun]);
	for (const category of entry.categories) {
		for (const other of nouns) {
			if (out.length >= limit) return out;
			if (seen.has(other.noun) || !other.categories.includes(category)) continue;
			seen.add(other.noun);
			out.push(other);
		}
	}
	return out;
}

/** The verbs either side of this one in the collection's order. */
export function neighbourVerbs(entry: SharedVerbEntry, each = 4): SharedVerbEntry[] {
	const at = verbs.indexOf(entry);
	return verbs.slice(Math.max(0, at - each), at).concat(verbs.slice(at + 1, at + 1 + each));
}

/** Which quizzes each noun (by dictionary form) is used in. */
let usage: Promise<Map<string, QuizSummary[]>> | undefined;

/** Strips the article a fill-in grid writes in front of its subject. */
function bare(display: string): string {
	return display.replace(/^(der|die|das)\s+/i, '').trim();
}

async function buildUsage(): Promise<Map<string, QuizSummary[]>> {
	const map = new Map<string, QuizSummary[]>();
	const known = new Set(nouns.map((n) => n.noun));
	const add = (noun: string, quiz: QuizSummary) => {
		if (!known.has(noun)) return;
		const list = map.get(noun) ?? [];
		if (!list.some((q) => q.id === quiz.id)) list.push(quiz);
		map.set(noun, list);
	};
	for (const card of catalog.courses) {
		const course = await loadCourse(card.id);
		for (const quiz of course.quizzes) {
			const summary = summarizeQuiz(quiz);
			for (const v of vocabFor(quiz, nouns)) add(v.noun, summary);
			for (const v of quiz.help?.vocab ?? []) add(bare(v.de), summary);
			if (quiz.type === 'fillBlank') {
				for (const s of quiz.subjects) add(bare(s.display), summary);
			}
		}
	}
	return map;
}

/** The exercises a noun appears in, in course order. */
export async function quizzesUsing(noun: string): Promise<QuizSummary[]> {
	usage ??= buildUsage();
	return (await usage).get(noun) ?? [];
}
