import { error } from '@sveltejs/kit';
import { categoryNames, nounForSlug, nouns, quizzesUsing, relatedNouns } from '$lib/server/words';
import { caseTable, exampleSentence, pluralForm, wordSlug } from '$lib/domain/words';
import type { EntryGenerator, PageServerLoad } from './$types';

/** One prerendered page per noun in the shared collection. */
export const entries: EntryGenerator = () => nouns.map((n) => ({ slug: wordSlug(n.noun) }));

export const load: PageServerLoad = async ({ params }) => {
	const entry = nounForSlug(params.slug);
	if (!entry) error(404, 'No such word');
	return {
		entry,
		slug: params.slug,
		plural: pluralForm(entry.noun, entry.plural),
		example: exampleSentence(entry),
		cases: caseTable(entry),
		categories: entry.categories.map((id) => ({ id, name: categoryNames[id] ?? id })),
		quizzes: await quizzesUsing(entry.noun),
		related: relatedNouns(entry).map((n) => ({
			slug: wordSlug(n.noun),
			noun: n.noun,
			gender: n.gender,
			english: n.english
		}))
	};
};
