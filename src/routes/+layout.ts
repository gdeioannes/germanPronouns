// Every route is prerendered to static HTML at build time, and there is no
// server at runtime — GitHub Pages just serves files.
//
// The site data below is a universal load, not a +layout.server.ts, on
// purpose: a server load makes every client-side page fetch its
// `__data.json`, and the one page that is not prerendered (a forum topic,
// /forum/[id]) has none — refreshing it showed "Page not found".

import { catalog, courseCard } from '$lib/content';
import type { LayoutLoad } from './$types';

export const prerender = true;
export const ssr = true;

/** What every page's furniture needs: the default course and its sub-levels. */
export const load: LayoutLoad = () => {
	const id = catalog.defaultCourseId;
	const card = courseCard(id)!;
	return {
		site: { courseId: id, courseHref: `/course/${id}`, version: card.version, levels: card.levels }
	};
};
