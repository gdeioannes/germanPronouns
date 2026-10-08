// Looking a German word up in the tap-a-word dictionary.
//
// The collection that `nouns.lookup` reads knows nouns. This one knows every
// word the app puts in front of a learner — verbs in whatever form the sentence
// conjugated them, pronouns, prepositions, the function words that make a
// German sentence hard to read and that no vocabulary list ever covers. It is
// built by tool/build-dictionary.mjs and keyed by surface form, so the common
// case is one map hit.
//
// What is not a single map hit is everything German does to a word after the
// dictionary was written, so the fallbacks below are ordered from certain to
// merely likely, and the lookup stops at the first hit.

import { GENDER_ARTICLES } from '$lib/domain/gender';
import { NOUN_SURFACE_FORMS } from '$lib/domain/noun-surface-forms';

/** One dictionary entry, as the generated file stores it. */
export interface DictEntry {
	/** The dictionary form: the infinitive, the nominative singular, the lemma. */
	de: string;
	/** The English meaning, written to be read by a learner rather than parsed. */
	en: string;
	pos:
		| 'noun'
		| 'verb'
		| 'pronoun'
		| 'article'
		| 'preposition'
		| 'conjunction'
		| 'adverb'
		| 'adjective'
		| 'number'
		| 'particle'
		| 'name';
	/** 'm' | 'f' | 'n', on nouns only — what the gender colours key off. */
	gender?: string;
	/** Plural ending in the collection's notation, e.g. "¨-e". */
	plural?: string;
	/** Slug of the Word Library page for this word, when one exists. */
	slug?: string;
}

/** The generated file: entries, plus every surface form pointing into them. */
export interface DictionaryData {
	entries: DictEntry[];
	surfaces: Record<string, number>;
}

/** A word recognised in a text, with the form the text spelt it in. */
export interface WordInfo {
	entry: DictEntry;
	/** The word as written — "läuft" for the entry "laufen". */
	surface: string;
	/** True when the entry was reached by guessing at an ending. */
	inferred: boolean;
}

/** Labels for the panel. 'noun' is left out: its article says it already. */
export const POS_LABELS: Record<DictEntry['pos'], string> = {
	noun: '',
	verb: 'verb',
	pronoun: 'pronoun',
	article: 'article',
	preposition: 'preposition',
	conjunction: 'conjunction',
	adverb: 'adverb',
	adjective: 'adjective',
	number: 'number',
	particle: 'particle',
	name: 'name'
};

const capitalise = (word: string) => word.charAt(0).toUpperCase() + word.slice(1);

/**
 * German endings a text adds that the generated file does not carry: the
 * genitive -s/-es, the dative -e, the weak-noun -n, and the -en that an
 * adjective or an infinitive can pick up. Stripping one and asking again is a
 * guess, so it is the last thing tried and the result is marked `inferred` —
 * the panel softens its headline rather than claiming "Tages" is a dictionary
 * form.
 */
const ENDINGS = ['es', 'en', 'er', 'em', 'n', 's', 'e'];

/**
 * The word a surface form refers to, or null when nothing in the dictionary
 * does. `data` is the generated file; keeping it a parameter rather than a
 * module global is what lets the tests run without loading 237 KB of JSON.
 */
export function lookupWord(word: string, data: DictionaryData | null): WordInfo | null {
	if (!data || !word) return null;

	const at = (surface: string) => {
		const index = data.surfaces[surface];
		return index === undefined ? null : data.entries[index];
	};

	// Certain: the form is in the file, or the noun map already maps it back.
	const direct = at(word) ?? at(NOUN_SURFACE_FORMS[word] ?? '');
	if (direct) return { entry: direct, surface: word, inferred: false };

	// Near certain: only the capitalisation differs. A sentence capitalises its
	// first word, and German capitalises its nouns, so both directions are worth
	// trying — "Und" for "und", "deutsch" for "Deutsch".
	const folded = at(word.toLowerCase()) ?? at(capitalise(word));
	if (folded) return { entry: folded, surface: word, inferred: false };

	// A guess. Only for words long enough that the stem is still a word.
	if (word.length > 4) {
		for (const ending of ENDINGS) {
			if (!word.endsWith(ending)) continue;
			const stem = word.slice(0, -ending.length);
			const entry = at(stem) ?? at(capitalise(stem)) ?? at(stem.toLowerCase());
			if (entry) return { entry, surface: word, inferred: true };
		}
	}

	return null;
}

/**
 * The bold line at the top of the panel. A noun gets its article and plural
 * ending — "der Hund ¨-e" — because a German noun is learnt with its article or
 * not at all. Everything else is just its dictionary form, and a form the text
 * spelt differently is shown as "läuft · laufen" so the learner can see which
 * word they actually tapped.
 */
export function headlineFor(info: WordInfo): string {
	const { entry, surface } = info;
	if (entry.pos === 'noun' && entry.gender) {
		const article = GENDER_ARTICLES[entry.gender] ?? '';
		// Two notations say nothing to a learner: "—" is a noun with no plural,
		// "-" one whose plural is spelt the same. Both would print as a bare dash.
		const ending = entry.plural;
		const plural = ending && ending !== '—' && ending !== '-' ? ` ${ending}` : '';
		return `${article} ${entry.de}${plural}`.trim();
	}
	return surface.toLowerCase() === entry.de.toLowerCase()
		? entry.de
		: `${surface} · ${entry.de}`;
}

/** The Word Library page for a word, when the generated entry knows of one. */
export function wordHref(entry: DictEntry): string | null {
	if (!entry.slug) return null;
	if (entry.pos === 'noun') return `/words/nouns/${entry.slug}`;
	if (entry.pos === 'verb') return `/words/verbs/${entry.slug}`;
	return null;
}
