import { error } from '@sveltejs/kit';
import { courseCard, courses, loadCourse, summarizeCourse } from '$lib/content';
import { deckPhotos } from '$lib/server/deckPhotos';
import type { EntryGenerator, PageServerLoad } from './$types';

/** One prerendered page per course in the catalog. */
export const entries: EntryGenerator = () => courses.map((course) => ({ courseId: course.id }));

// The course home lists every exercise but runs none, so it gets the summary:
// nav plus each quiz's title, kind and level. Serialised into the HTML at
// build time — the bundle itself never reaches the browser from here.
export const load: PageServerLoad = async ({ params }) => {
	if (!courseCard(params.courseId)) error(404, 'No such course');
	const course = summarizeCourse(await loadCourse(params.courseId));
	// The deck's card photos, one per exercise (lib/server/deckPhotos).
	return { course, photos: deckPhotos(params.courseId, course.quizzes) };
};
