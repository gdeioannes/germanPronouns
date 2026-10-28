import { catalog, loadCourse } from '$lib/content';
import type { WordCheckBank } from '$lib/domain/wordCheck';
import { buildPlacementBank } from '$lib/domain/placement';
import type { PageServerLoad } from './$types';

/**
 * The placement test rides whole in the prerendered page: the word bank (a few
 * kilobytes) and the placement bank (24 gaps, one reading and one listening
 * text per sub-level), so each test draws its own items in the browser.
 */
export const load: PageServerLoad = async () => {
	const words = (await import('$content/wordcheck/de.json')).default as unknown as WordCheckBank;
	const course = await loadCourse(catalog.defaultCourseId);
	return {
		courseId: course.id,
		locale: course.learnLocale ?? 'de-DE',
		words: { levels: words.levels, fakes: words.fakes },
		bank: buildPlacementBank(course)
	};
};
