import { error } from '@sveltejs/kit';
import { courseInfo, courses, loadCourse, loadSyllabus, summarizeQuiz } from '$lib/content';
import type { EntryGenerator, PageServerLoad } from './$types';

/** One prerendered syllabus page per quest-chain sub-level. */
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; levelId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const group of course.nav.groups) {
			if (group.type === 'questChain' && group.level) {
				all.push({ courseId: card.id, levelId: group.level });
			}
		}
	}
	return all;
};

// A server load: the page carries this level's module and its quizzes'
// summaries, serialised at build time, and never fetches the course bundle.
export const load: PageServerLoad = async ({ params }) => {
	const course = await loadCourse(params.courseId);
	const syllabus = await loadSyllabus(params.courseId);
	const module = syllabus?.modules.find((m) => m.level === params.levelId);
	const group = course.nav.groups.find(
		(g) => g.type === 'questChain' && g.level === params.levelId
	);
	if (!group) error(404, 'No such level');

	const levels = course.nav.groups.filter((g) => g.type === 'questChain');
	const at = levels.findIndex((g) => g.level === params.levelId);

	return {
		course: courseInfo(course),
		level: params.levelId,
		title: group.title,
		module: module ?? null,
		quizzes: course.quizzes.filter((q) => q.level === params.levelId).map(summarizeQuiz),
		previous: levels[at - 1]?.level ?? null,
		next: levels[at + 1]?.level ?? null
	};
};
