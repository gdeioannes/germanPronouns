import { describe, expect, it } from 'vitest';
import data from '$content/shared/dictionary/de.json';
import nounCollection from '$content/shared/nouns/de.json';
import verbCollection from '$content/shared/verbs/de.json';
import {
	headlineFor,
	lookupWord,
	wordHref,
	type DictionaryData,
	type DictEntry
} from './dictionary';
import { pluralForm, dativePlural, wordSlug, type SharedNounEntry } from './words';

const dict = data as DictionaryData;
const nouns = nounCollection.nouns as SharedNounEntry[];
const look = (word: string) => lookupWord(word, dict);
const meaning = (word: string) => look(word)?.entry.en;
const lemma = (word: string) => look(word)?.entry.de;

describe('the generated dictionary', () => {
	it('points every surface form at a real entry', () => {
		for (const [surface, index] of Object.entries(dict.surfaces)) {
			expect(dict.entries[index], surface).toBeDefined();
		}
	});

	it('gives every entry a meaning and a part of speech', () => {
		for (const entry of dict.entries) {
			expect(entry.de, JSON.stringify(entry)).toBeTruthy();
			expect(entry.en, entry.de).toBeTruthy();
			expect(entry.pos, entry.de).toBeTruthy();
		}
	});

	it('gives every noun a gender, so the colouring never has to guess', () => {
		for (const entry of dict.entries) {
			if (entry.pos !== 'noun') continue;
			expect(['m', 'f', 'n'], entry.de).toContain(entry.gender);
		}
	});

	it('carries the whole shared noun collection', () => {
		for (const noun of nouns) {
			expect(lemma(noun.noun), noun.noun).toBe(noun.noun);
			expect(meaning(noun.noun), noun.noun).toBe(noun.english);
		}
	});

	it('carries the whole shared verb collection, conjugations included', () => {
		for (const verb of verbCollection.verbs) {
			expect(lemma(verb.verb), verb.verb).toBe(verb.verb);
			for (const set of verb.sets ?? []) {
				for (const { form } of set.forms ?? []) {
					// A form can be two words ("bin gegangen"); each word resolves.
					for (const word of String(form).split(/[\s/]+/)) {
						if (word) expect(look(word), `${verb.verb} → ${word}`).not.toBeNull();
					}
				}
			}
		}
	});

	// tool/build-dictionary.mjs cannot import these TypeScript helpers, so it
	// has its own copies. If the two ever drift, the generated plurals and slugs
	// would stop matching the Word Library, and this is where that shows up.
	it('derives plurals the way the Word Library does', () => {
		// A plural spelling can be a word in its own right that the core wordlist
		// glosses deliberately: German "Daten" means data, not "dates", so that
		// entry is meant to win over Datum's plural. A lemma always beats another
		// word's inflection, so such a spelling resolving to itself is correct.
		const coreLemmas = new Set(
			dict.entries.filter((entry) => !entry.slug).map((entry) => entry.de)
		);
		for (const noun of nouns) {
			const plural = pluralForm(noun.noun, noun.plural);
			if (!plural) continue;
			for (const form of [plural, dativePlural(plural)]) {
				if (coreLemmas.has(form)) continue;
				expect(lemma(form), form).toBe(noun.noun);
			}
		}
	});

	it('slugs words the way the Word Library routes them', () => {
		for (const entry of dict.entries) {
			if (!entry.slug) continue;
			expect(entry.slug, entry.de).toBe(wordSlug(entry.de));
		}
	});
});

describe('lookupWord', () => {
	it('finds a word spelt exactly as the dictionary has it', () => {
		expect(meaning('und')).toBe('and');
		expect(look('und')?.inferred).toBe(false);
	});

	it('finds a word the sentence capitalised', () => {
		expect(lemma('Und')).toBe('und');
		expect(lemma('Wenn')).toBe('wenn');
		expect(look('Und')?.inferred).toBe(false);
	});

	it('resolves an inflected noun through the surface-form map', () => {
		expect(lemma('Nachbarn')).toBe('Nachbar');
		expect(lemma('Bücher')).toBe('Buch');
	});

	it('resolves a conjugated verb to its infinitive', () => {
		expect(lemma('bist')).toBe('sein');
		expect(lemma('warst')).toBe('sein');
		expect(lemma('geplant')).toBe('planen');
		expect(lemma('prüft')).toBe('prüfen');
	});

	it('resolves an inflected adjective and determiner', () => {
		expect(lemma('kleinen')).toBe('klein');
		expect(lemma('einem')).toBe('ein');
		expect(lemma('meiner')).toBe('mein');
	});

	it('puts a separable prefix before the ge- of the participle', () => {
		expect(lemma('aufgemacht')).toBe('aufmachen');
		// An unstressed prefix takes no ge- at all.
		expect(lemma('verpasst')).toBe('verpassen');
	});

	it('falls back to stripping an ending, and says that it guessed', () => {
		const info = look('Projekts');
		expect(info?.entry.de).toBe('Projekt');
		expect(info?.inferred).toBe(true);
	});

	it('does not guess at a short word', () => {
		// "ins" is its own entry; "abs" is nothing, and stripping to "ab" would
		// be a worse answer than none.
		expect(look('abs')).toBeNull();
	});

	it('returns null for a word it does not know', () => {
		expect(look('Donaudampfschifffahrtsgesellschaft')).toBeNull();
		expect(look('')).toBeNull();
	});

	it('returns null rather than throwing before the dictionary has loaded', () => {
		expect(lookupWord('und', null)).toBeNull();
	});
});

describe('headlineFor', () => {
	const info = (entry: DictEntry, surface = entry.de) => ({ entry, surface, inferred: false });

	it('gives a noun its article and plural ending', () => {
		expect(headlineFor(info({ de: 'Hund', en: 'dog', pos: 'noun', gender: 'm', plural: '¨-e' })))
			.toBe('der Hund ¨-e');
	});

	it('leaves out a plural notation that says nothing', () => {
		expect(headlineFor(info({ de: 'Geld', en: 'money', pos: 'noun', gender: 'n', plural: '—' })))
			.toBe('das Geld');
		expect(headlineFor(info({ de: 'Lehrer', en: 'teacher', pos: 'noun', gender: 'm', plural: '-' })))
			.toBe('der Lehrer');
	});

	it('shows the tapped form next to the lemma when they differ', () => {
		expect(headlineFor(info({ de: 'laufen', en: 'to run', pos: 'verb' }, 'läuft')))
			.toBe('läuft · laufen');
	});

	it('shows the lemma alone when only the capitalisation differed', () => {
		expect(headlineFor(info({ de: 'und', en: 'and', pos: 'conjunction' }, 'Und'))).toBe('und');
	});
});

describe('wordHref', () => {
	it('links a noun and a verb to their Word Library pages', () => {
		expect(wordHref({ de: 'Hund', en: 'dog', pos: 'noun', gender: 'm', slug: 'hund' }))
			.toBe('/words/nouns/hund');
		expect(wordHref({ de: 'gehen', en: 'to go', pos: 'verb', slug: 'gehen' }))
			.toBe('/words/verbs/gehen');
	});

	it('links nothing for a word with no page of its own', () => {
		expect(wordHref({ de: 'und', en: 'and', pos: 'conjunction' })).toBeNull();
		expect(wordHref({ de: 'Berlin', en: 'Berlin', pos: 'name', slug: 'berlin' })).toBeNull();
	});
});
