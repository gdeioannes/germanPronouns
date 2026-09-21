import { error } from '@sveltejs/kit';
import { courses, loadCourse } from '$lib/content';
import type { EntryGenerator, PageLoad } from './$types';

/**
 * One prerendered page per quiz. 214 static HTML files for the German course —
 * every exercise crawlable and directly linkable, which the canvas-rendered
 * Flutter build could never offer.
 */
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; quizId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const quiz of course.quizzes) {
			all.push({ courseId: card.id, quizId: quiz.id });
		}
	}
	return all;
};

export const load: PageLoad = async ({ params }) => {
	const course = await loadCourse(params.courseId);
	const index = course.quizzes.findIndex((q) => q.id === params.quizId);
	if (index < 0) error(404, 'No such exercise');

	return {
		course,
		quiz: course.quizzes[index],
		// The chain is ordered, so "next" is simply the following entry.
		next: course.quizzes[index + 1] ?? null
	};
};
