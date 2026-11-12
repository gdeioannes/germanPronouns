// The second languages' own addresses. Every page that exists in Turkish or
// Arabic is also published under its language prefix, already in that
// language, so a search engine can find it:
//
//   /course/de_cert_a1/quiz/x       English (and, in the browser, whatever the visitor picked)
//   /tr/course/de_cert_a1/quiz/x    Turkish, prerendered in Turkish
//   /ar/course/de_cert_a1/quiz/x    Arabic, prerendered in Arabic, right to left
//
// The prefixed addresses are the same routes (src/hooks.ts reroutes them),
// so nothing is copied. Kept free of $lib and $app imports: vite.config.ts
// reads localPages() to list the pages to prerender.

import { LOCAL_LEVELS } from './available';

export const PREFIX_LANGS = ['tr', 'ar'] as const;
export type PrefixLang = (typeof PREFIX_LANGS)[number];

/** "/tr/about" → "tr"; a path with no language prefix → null. */
export function pathLang(pathname: string): PrefixLang | null {
	const m = pathname.match(/^\/(tr|ar)(?=\/|$)/);
	return m ? (m[1] as PrefixLang) : null;
}

/** "/tr/about" → "/about", "/tr" → "/"; a bare path comes back as it is. */
export function stripLang(pathname: string): string {
	const l = pathLang(pathname);
	if (!l) return pathname;
	return pathname.slice(l.length + 1) || '/';
}

/** "/about" in Turkish → "/tr/about"; English (or no language) leaves it bare. */
export function withLang(l: string | null | undefined, path: string): string {
	if (!l || !(PREFIX_LANGS as readonly string[]).includes(l)) return path;
	return path === '/' ? `/${l}` : `/${l}${path}`;
}

/**
 * Route ids whose pages have Turkish and Arabic twins under the prefix.
 * A level-bound route (a level, an exercise) has them only for A1–A2.
 * Narrower than LOCAL_ROUTES: /legal stays English, and the book previews,
 * book links and sign-in are not search pages.
 */
export const PREFIX_ROUTES = new Set<string>([
	'/',
	'/about',
	'/contact',
	'/start',
	'/settings',
	'/level-check',
	'/level-check/test',
	'/books',
	'/course/[courseId]',
	'/course/[courseId]/level/[levelId]',
	'/course/[courseId]/quiz/[quizId]'
]);

/**
 * Every bare path that has prefixed twins, in the order the sitemap lists
 * them. `/settings` is among them (the language picker leads there) but is
 * noindex, so the sitemap leaves it out.
 */
export function localPages(courseId: string, quizzes: { id: string; level?: string | null }[]): string[] {
	const levels = LOCAL_LEVELS as readonly string[];
	return [
		'/',
		'/about',
		'/contact',
		'/start',
		'/settings',
		'/level-check',
		'/level-check/test',
		'/books',
		`/course/${courseId}`,
		...levels.map((l) => `/course/${courseId}/level/${l}`),
		...quizzes.filter((q) => q.level && levels.includes(q.level)).map((q) => `/course/${courseId}/quiz/${q.id}`)
	];
}

/** Where the same page lives in another language: "/tr/about" in Arabic → "/ar/about", in English → "/about". */
export function addressIn(l: string, pathname: string): string {
	return withLang(l === 'en' ? null : l, stripLang(pathname));
}

const LEVEL_IN_ID = /(^|_)a[12]_[12](_|$)/;
const STATIC_TWINS = new Set(['/', '/about', '/contact', '/start', '/settings', '/level-check', '/level-check/test', '/books']);

/**
 * Whether a bare path has Turkish and Arabic twins, from the path alone (the
 * browser has no course list to look in). An exercise's id names its
 * sub-level ("quest_a1_2_…"); paths.test.ts checks this agrees with
 * localPages() for every exercise.
 */
export function hasTwin(path: string): boolean {
	if (STATIC_TWINS.has(path)) return true;
	const m = path.match(/^\/course\/[^/]+(?:\/(level|quiz)\/([^/]+))?$/);
	if (!m) return false;
	if (!m[1]) return true;
	if (m[1] === 'level') return (LOCAL_LEVELS as readonly string[]).includes(decodeURIComponent(m[2]));
	return LEVEL_IN_ID.test(m[2]);
}
