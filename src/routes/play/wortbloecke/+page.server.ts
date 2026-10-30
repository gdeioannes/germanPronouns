import { catalog, loadCourse } from '$lib/content';
import { buildPools, mergeWordBank, type WortBankSource } from '$lib/domain/wortbloecke';
import type { PageServerLoad } from './$types';

/**
 * Wortblöcke draws its words from the course's own flashcard decks, topped up
 * from the word check's hand-picked bank — one pool per sub-level, extracted
 * at prerender time so the page carries kilobytes of words, not the course.
 */
export const load: PageServerLoad = async () => {
	const course = await loadCourse(catalog.defaultCourseId);
	const bank = (await import('$content/wordcheck/de.json')).default as unknown as WortBankSource;
	return {
		courseId: course.id,
		pools: mergeWordBank(buildPools(course.quizzes), bank)
	};
};
