import { categoryNames, nouns, pictureFor } from '$lib/server/words';
import { pluralForm, wordSlug } from '$lib/domain/words';
import type { PageServerLoad } from './$types';

/**
 * The noun index: every noun as a plain link, grouped by category, so a
 * crawler reaches all 700-odd noun pages from one place and a reader can
 * browse by theme.
 */
export const load: PageServerLoad = () => {
	const groups = Object.entries(categoryNames).map(([id, name]) => ({
		id,
		name,
		nouns: nouns
			.filter((n) => n.categories.includes(id))
			.map((n) => {
				const slug = wordSlug(n.noun);
				return {
					slug,
					noun: n.noun,
					gender: n.gender,
					english: n.english,
					plural: pluralForm(n.noun, n.plural),
					image: pictureFor(slug)
				};
			})
	}));
	return { total: nouns.length, groups: groups.filter((g) => g.nouns.length) };
};
