import { catalog, loadCourse } from '$lib/content';
import type { WordCheckBank } from '$lib/domain/wordCheck';
import type { PageServerLoad } from './$types';

/**
 * The word check: the whole bank (about 600 words and the made-up ones, a few
 * kilobytes) rides in the prerendered page, so every check draws its own
 * screens in the browser. The level's flashcard deck is looked up here, for
 * the result's "practise these words".
 */
export const load: PageServerLoad = async () => {
	const bank = (await import('$content/wordcheck/de.json')).default as unknown as WordCheckBank;
	const course = await loadCourse(catalog.defaultCourseId);
	const decks: Record<string, string> = {};
	for (const quiz of course.quizzes) {
		if (quiz.type === 'vocabulary' && quiz.level && !decks[quiz.level]) decks[quiz.level] = quiz.id;
	}
	return {
		courseId: course.id,
		bank: { levels: bank.levels, fakes: bank.fakes },
		decks
	};
};
