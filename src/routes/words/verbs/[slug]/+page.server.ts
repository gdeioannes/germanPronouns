import { error } from '@sveltejs/kit';
import { neighbourVerbs, verbForSlug, verbs } from '$lib/server/words';
import { wordSlug } from '$lib/domain/words';
import type { EntryGenerator, PageServerLoad } from './$types';

/** One prerendered page per verb in the shared collection. */
export const entries: EntryGenerator = () => verbs.map((v) => ({ slug: wordSlug(v.verb) }));

export const load: PageServerLoad = ({ params }) => {
	const entry = verbForSlug(params.slug);
	if (!entry) error(404, 'No such word');
	return {
		entry,
		slug: params.slug,
		related: neighbourVerbs(entry).map((v) => ({
			slug: wordSlug(v.verb),
			verb: v.verb,
			english: v.english
		}))
	};
};
