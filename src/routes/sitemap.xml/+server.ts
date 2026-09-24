import { courses, loadCourse } from '$lib/content';
import type { RequestHandler } from './$types';

export const prerender = true;

/**
 * A real sitemap, generated from the content rather than hand-maintained.
 * The Flutter build could only ever list the root URL — the app was one canvas
 * behind a hash route, so there was nothing else to point a crawler at.
 */
export const GET: RequestHandler = async () => {
	const base = 'https://languagequiz.org';
	// Stamped at build time: every page is regenerated on each deploy.
	const lastmod = new Date().toISOString().slice(0, 10);
	const urls: { loc: string; priority: string }[] = [
		{ loc: base + '/', priority: '1.0' },
		{ loc: base + '/words', priority: '0.6' }
	];

	for (const card of courses) {
		urls.push({ loc: base + '/course/' + card.id, priority: '0.9' });
		const course = await loadCourse(card.id);
		// The level syllabus pages: the densest overview text on the site.
		for (const group of course.nav.groups) {
			if (group.type === 'questChain' && group.level) {
				urls.push({ loc: base + '/course/' + card.id + '/level/' + group.level, priority: '0.8' });
			}
		}
		for (const quiz of course.quizzes) {
			urls.push({
				loc: base + '/course/' + card.id + '/quiz/' + quiz.id,
				priority: '0.7'
			});
		}
	}

	const entries = urls
		.map((u) => '  <url>\n    <loc>' + u.loc + '</loc>\n    <lastmod>' + lastmod + '</lastmod>\n    <priority>' + u.priority + '</priority>\n  </url>')
		.join('\n');

	const body =
		'<?xml version="1.0" encoding="UTF-8"?>\n' +
		'<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' +
		entries +
		'\n</urlset>';

	return new Response(body, { headers: { 'Content-Type': 'application/xml' } });
};
