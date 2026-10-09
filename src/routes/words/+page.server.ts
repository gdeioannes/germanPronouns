import { nouns, pictureFor, verbs } from '$lib/server/words';
import dictionary from '$content/shared/dictionary/de.json';
import { wordSlug } from '$lib/domain/words';
import { catalog, loadCourse } from '$lib/content';
import type { PageServerLoad } from './$types';

/** One flashcard deck per sub-level, for the library's "by module" strip. */
export interface DeckTile {
	level: string;
	/** The sub-level's name, e.g. "ERSTE SCHRITTE". */
	title: string;
	/** The deck's quiz id, or null while that level has no deck yet. */
	quizId: string | null;
	storageKeyPrefix: string | null;
	cards: number;
	nouns: number;
}

/**
 * The library's search index: a line per word, not the collections
 * themselves. The tables and examples live on each word's own page, so this
 * page carries a few kilobytes rather than the whole 200KB of both files.
 */
export const load: PageServerLoad = async () => {
	const courseId = catalog.defaultCourseId;
	const course = await loadCourse(courseId);
	const decks: DeckTile[] = course.nav.groups
		.filter((g) => g.type === 'questChain' && g.level)
		.map((g) => {
			const deck = course.quizzes.find((q) => q.type === 'vocabulary' && q.level === g.level);
			const cards = deck && deck.type === 'vocabulary' ? deck.cards : [];
			return {
				level: g.level!,
				title: g.title.replace(/^[A-C][12]\.[12]\s*·\s*/, ''),
				quizId: deck?.id ?? null,
				storageKeyPrefix: deck?.storageKeyPrefix ?? null,
				cards: cards.length,
				nouns: cards.filter((c) => c.kind === 'noun').length
			};
		});

	// The small words the dictionary page lists: everything that is not a
	// noun, verb or name — for the browse card's count.
	const smallWords = (dictionary.entries as { pos?: string }[]).filter(
		(e) => e.pos !== 'noun' && e.pos !== 'verb' && e.pos !== 'name'
	).length;

	return {
	courseId,
	decks,
	smallWords,
	nouns: nouns.map((n) => {
		const slug = wordSlug(n.noun);
		return {
			slug,
			noun: n.noun,
			gender: n.gender,
			english: n.english,
			image: pictureFor(slug)
		};
	}),
	verbs: verbs.map((v) => ({ slug: wordSlug(v.verb), verb: v.verb, english: v.english }))
	};
};
