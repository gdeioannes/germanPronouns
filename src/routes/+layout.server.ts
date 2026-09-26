// What every page's furniture needs to know about the site: the default
// course, its sub-levels and its content version. Loaded once at build time
// and serialised alongside each page, so the footer can link to every level
// from anywhere without each route fetching the course for it.

import { catalog, courseCard, loadCourse } from '$lib/content';
import type { LayoutServerLoad } from './$types';

export const load: LayoutServerLoad = async () => {
	const id = catalog.defaultCourseId;
	const card = courseCard(id)!;
	const course = await loadCourse(id);
	const levels = course.nav.groups
		.filter((g) => g.type === 'questChain' && g.level)
		.map((g) => ({ level: g.level as string, title: g.title }));
	return {
		site: { courseId: id, courseHref: `/course/${id}`, version: card.version, levels }
	};
};
