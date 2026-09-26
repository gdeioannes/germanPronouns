import { nouns, verbs } from '$lib/server/words';
import { wordSlug } from '$lib/domain/words';
import type { PageServerLoad } from './$types';

/**
 * The library's search index: a line per word, not the collections
 * themselves. The tables and examples live on each word's own page, so this
 * page carries a few kilobytes rather than the whole 200KB of both files.
 */
export const load: PageServerLoad = () => ({
	nouns: nouns.map((n) => ({
		slug: wordSlug(n.noun),
		noun: n.noun,
		gender: n.gender,
		english: n.english
	})),
	verbs: verbs.map((v) => ({ slug: wordSlug(v.verb), verb: v.verb, english: v.english }))
});
