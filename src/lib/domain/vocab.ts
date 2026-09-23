// The nouns a quiz uses, each with its article and meaning.
//
// The grid quizzes carry their own vocabulary — the subjects ARE the nouns, so
// helpTableFor already names them. Everything built on a text does not: a
// reading passage, a cloze, a dictation or a spoken line is just German, and
// the Help Memory had nothing to say about the words in it. A German noun is
// learnt with its article or not at all, so this pulls every noun the text uses
// out of the shared collection and hands back "der Apfel · apple".
//
// The collection is the same one the Word Library reads, so the two agree by
// construction rather than by a comment promising they do.

import { GENDER_ARTICLES } from '$lib/domain/gender';
import { NOUN_SURFACE_FORMS } from '$lib/domain/noun-surface-forms';
import { isInlineCloze, type Quiz } from '$lib/content/types';

/** One entry in the shared noun collection. */
export interface SharedNoun {
	noun: string;
	gender: string;
	english: string;
	/** Plural ending in the dictionary notation the collection stores, e.g. "¨-e". */
	plural?: string;
}

/** A noun recognised in a text, with the article for its dictionary form. */
export interface NounInfo {
	noun: SharedNoun;
	article: string;
	/** The word as the text spelt it — "Nachbarn" for "der Nachbar". */
	surface: string;
}

/**
 * Looks a word up in the collection, directly or through the inflected-form
 * map, exactly as the Dart `lookupNoun` did. Returns null when it isn't a noun
 * the collection knows.
 */
export function lookupNoun(
	word: string,
	byNoun: Map<string, SharedNoun>
): NounInfo | null {
	const entry = byNoun.get(word) ?? byNoun.get(NOUN_SURFACE_FORMS[word]);
	if (!entry) return null;
	return {
		noun: entry,
		article: GENDER_ARTICLES[entry.gender] ?? 'das',
		surface: word
	};
}

export interface VocabEntry {
	noun: string;
	article: string;
	english: string;
	gender: string;
}

/**
 * Every German word in the text, in the order it first appears. Only
 * capitalised words are considered: German capitalises its nouns and almost
 * nothing else, which makes the filter both cheap and accurate. A word that
 * isn't in the collection is simply skipped — a partial list beats a wrong one.
 */
export function vocabFor(quiz: Quiz, nouns: SharedNoun[]): VocabEntry[] {
	const text = textOf(quiz);
	if (!text) return [];

	const byNoun = new Map(nouns.map((entry) => [entry.noun, entry]));
	const seen = new Set<string>();
	const found: VocabEntry[] = [];

	for (const word of text.match(/[A-ZÄÖÜ][a-zäöüß]+/g) ?? []) {
		if (seen.has(word)) continue;
		seen.add(word);
		const entry = byNoun.get(word);
		if (!entry) continue;
		found.push({
			noun: entry.noun,
			article: GENDER_ARTICLES[entry.gender] ?? '',
			english: entry.english,
			gender: entry.gender
		});
	}

	return found;
}

/** All the German a quiz puts in front of the learner, as one string. */
function textOf(quiz: Quiz): string {
	switch (quiz.type) {
		case 'reading':
			// The cloze's template still carries its `{{n}}` markers; harmless,
			// since a marker can't look like a capitalised German word.
			return isInlineCloze(quiz)
				? `${quiz.passage} ${quiz.inlineTemplate}`
				: `${quiz.passage} ${quiz.questions.map((q) => q.question).join(' ')}`;
		case 'listening':
			return `${quiz.passage} ${quiz.questions.map((q) => q.question).join(' ')}`;
		case 'dictation':
			return quiz.items.map((item) => item.text).join(' ');
		case 'speakRepeat':
			return quiz.phrases.map((phrase) => phrase.text).join(' ');
		case 'fillBlank':
		case 'speaking':
			// The grid quizzes name their nouns already; a speaking exercise is a
			// prompt for the learner's own AI, not a German text.
			return '';
	}
}
