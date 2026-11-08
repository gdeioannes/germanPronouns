// The landing page sells one thing: the English → German course. It reads the
// real bundle at build time so every number
// on the page is the content's own — baked into the prerendered HTML, with no
// runtime fetch and nothing hand-maintained that could drift.
//
// A server load rather than a universal one: only the small result below is
// serialised into the page. A universal load would run again in the browser
// and pull the whole course bundle in just to count its quizzes.

import { catalog, courseCard, loadCourse } from '$lib/content';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	const id = catalog.defaultCourseId;
	const card = courseCard(id)!;
	const course = await loadCourse(id);

	const counts: Record<string, number> = {};
	for (const quiz of course.quizzes) counts[quiz.type] = (counts[quiz.type] ?? 0) + 1;

	// Sub-levels as authored in the nav (A1.1, A1.2, …), grouped under the CEFR
	// letters a learner actually recognises.
	const subLevels = course.nav.groups
		.filter((g) => g.type === 'questChain' && g.level)
		.map((g) => g.level as string);
	const letters = [...new Set(subLevels.map((l) => l.split('.')[0]))];

	return {
		card,
		firstQuizId: course.quizzes[0]?.id,
		total: course.quizzes.length,
		counts,
		levels: letters,
		subLevelCount: subLevels.length
	};
};
