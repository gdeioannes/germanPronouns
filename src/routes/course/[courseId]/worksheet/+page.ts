import { error } from '@sveltejs/kit';
import { courseCard, courses, loadCourse } from '$lib/content';
import type { EntryGenerator, PageLoad } from './$types';

/** One prerendered worksheet page per course; the options are chosen on it. */
export const entries: EntryGenerator = () =>
	courses.map((course) => ({ courseId: course.id }));

export const load: PageLoad = async ({ params }) => {
	if (!courseCard(params.courseId)) error(404, 'No such course');
	return { course: await loadCourse(params.courseId) };
};
