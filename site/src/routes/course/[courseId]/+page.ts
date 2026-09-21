import { error } from '@sveltejs/kit';
import { courseCard, courses, loadCourse } from '$lib/content';
import type { EntryGenerator, PageLoad } from './$types';

/** One prerendered page per course in the catalog. */
export const entries: EntryGenerator = () =>
	courses.map((course) => ({ courseId: course.id }));

export const load: PageLoad = async ({ params }) => {
	if (!courseCard(params.courseId)) error(404, 'No such course');
	return { course: await loadCourse(params.courseId) };
};
