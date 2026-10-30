import { catalog, loadCourse } from '$lib/content';
import { buildPools } from '$lib/domain/wortbloecke';
import type { PageServerLoad } from './$types';

/**
 * Wortblöcke draws its words from the course's own flashcard decks: one pool
 * per sub-level, extracted at prerender time so the page carries a few
 * kilobytes of words instead of the whole course bundle.
 */
export const load: PageServerLoad = async () => {
	const course = await loadCourse(catalog.defaultCourseId);
	return {
		courseId: course.id,
		pools: buildPools(course.quizzes)
	};
};
