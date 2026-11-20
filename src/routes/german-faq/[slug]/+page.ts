import { error } from '@sveltejs/kit';
import { findFaq, GERMAN_FAQ } from '$lib/content/germanFaq';
import type { EntryGenerator, PageLoad } from './$types';

export const entries: EntryGenerator = () => GERMAN_FAQ.map((f) => ({ slug: f.slug }));

export const load: PageLoad = ({ params }) => {
	if (!findFaq(params.slug)) error(404, 'No such question');
	return { slug: params.slug };
};
