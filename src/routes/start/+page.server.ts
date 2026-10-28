import { catalog, loadCourse } from '$lib/content';
import type { PageServerLoad } from './$types';

/** Where a newcomer starts: the first exercise of the course, and each level's title. */
export const load: PageServerLoad = async () => {
	const course = await loadCourse(catalog.defaultCourseId);
	return { courseId: course.id, firstQuizId: course.quizzes[0]?.id ?? null };
};
