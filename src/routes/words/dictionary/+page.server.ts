import dictionary from '$content/shared/dictionary/de.json';
import type { DictEntry } from '$lib/domain/dictionary';
import type { PageServerLoad } from './$types';

/**
 * The whole dictionary as A–Z groups, prerendered.
 *
 * The nouns and verbs already have index pages of their own, with plurals,
 * cases and conjugations. This page is for everything else — the pronouns,
 * prepositions and function words a learner meets in every sentence and that
 * no word list ever covers — so those are what it lists. A noun or a verb
 * would only be a worse copy of its own page.
 */
export const load: PageServerLoad = () => {
	const entries = (dictionary.entries as DictEntry[]).filter(
		(entry) => entry.pos !== 'noun' && entry.pos !== 'verb' && entry.pos !== 'name'
	);

	const byLetter = new Map<string, DictEntry[]>();
	for (const entry of entries) {
		// Umlauts file under their base letter, the way a German dictionary does.
		const letter = entry.de[0]
			.toUpperCase()
			.replace(/Ä/, 'A')
			.replace(/Ö/, 'O')
			.replace(/Ü/, 'U');
		(byLetter.get(letter) ?? byLetter.set(letter, []).get(letter)!).push(entry);
	}

	const groups = [...byLetter.entries()]
		.sort(([a], [b]) => a.localeCompare(b, 'de'))
		.map(([letter, words]) => ({
			letter,
			words: words
				.sort((a, b) => a.de.localeCompare(b.de, 'de'))
				.map(({ de, en, pos }) => ({ de, en, pos }))
		}));

	return { total: entries.length, groups };
};
