import { courses, loadCourse } from '$lib/content';
import { SITE_URL } from '$lib/seo';
import { coursePaths, lastModified, SHARED_WORD_PATHS } from '$lib/server/lastmod';
import { nouns, verbs } from '$lib/server/words';
import { wordSlug } from '$lib/domain/words';
import type { RequestHandler } from './$types';

export const prerender = true;

/**
 * A real sitemap, generated from the content rather than hand-maintained.
 * Each URL's <lastmod> is the date of the last commit that touched the
 * content it is built from, so a crawler can tell what actually changed
 * rather than seeing every page "updated" on every deploy.
 */
export const GET: RequestHandler = async () => {
	const today = lastModified('src/routes/+page.svelte', 'src/routes/+page.server.ts');
	const wordsDate = lastModified(...SHARED_WORD_PATHS);
	const urls: { loc: string; lastmod: string; priority: string }[] = [
		{ loc: '/', lastmod: today, priority: '1.0' },
		{ loc: '/words', lastmod: wordsDate, priority: '0.6' },
		{ loc: '/words/nouns', lastmod: wordsDate, priority: '0.7' },
		{ loc: '/words/verbs', lastmod: wordsDate, priority: '0.7' }
	];

	for (const card of courses) {
		const lastmod = lastModified(...coursePaths(card.id));
		urls.push({ loc: `/course/${card.id}`, lastmod, priority: '0.9' });
		const course = await loadCourse(card.id);
		// The level syllabus pages: the densest overview text on the site.
		for (const group of course.nav.groups) {
			if (group.type === 'questChain' && group.level) {
				urls.push({ loc: `/course/${card.id}/level/${group.level}`, lastmod, priority: '0.8' });
			}
		}
		for (const quiz of course.quizzes) {
			urls.push({ loc: `/course/${card.id}/quiz/${quiz.id}`, lastmod, priority: '0.7' });
		}
	}

	for (const n of nouns) {
		urls.push({ loc: `/words/nouns/${wordSlug(n.noun)}`, lastmod: wordsDate, priority: '0.5' });
	}
	for (const v of verbs) {
		urls.push({ loc: `/words/verbs/${wordSlug(v.verb)}`, lastmod: wordsDate, priority: '0.5' });
	}

	const entries = urls
		.map(
			(u) =>
				`  <url>\n    <loc>${SITE_URL}${u.loc}</loc>\n    <lastmod>${u.lastmod}</lastmod>\n    <priority>${u.priority}</priority>\n  </url>`
		)
		.join('\n');

	const body =
		'<?xml version="1.0" encoding="UTF-8"?>\n' +
		'<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' +
		entries +
		'\n</urlset>';

	return new Response(body, { headers: { 'Content-Type': 'application/xml' } });
};
