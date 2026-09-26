import { verbs } from '$lib/server/words';
import { wordSlug } from '$lib/domain/words';
import type { PageServerLoad } from './$types';

/** The verb index: every verb as a plain link, with its present-tense "er" form. */
export const load: PageServerLoad = () => ({
	verbs: verbs.map((v) => ({
		slug: wordSlug(v.verb),
		verb: v.verb,
		english: v.english,
		third: v.sets[0]?.forms.find((f) => f.person.startsWith('er'))?.form ?? null
	}))
});
