// When a page's content last changed, for the sitemap's <lastmod>.
//
// Every route is prerendered on each deploy, so "the build date" would say
// every page changed every time — which teaches a crawler to ignore the
// field. The honest date is the last commit that touched the content a page
// is built from: the course bundle for course, level and quiz pages, the
// shared collections for the word pages, the route itself for the home page.
// Read from git at build time; a checkout without history (a shallow clone,
// a tarball) falls back to today rather than failing the build.

import { execFileSync } from 'node:child_process';

const cache = new Map<string, string>();

/** ISO date (YYYY-MM-DD) of the last commit touching any of the paths. */
export function lastModified(...paths: string[]): string {
	const key = paths.join('\0');
	const hit = cache.get(key);
	if (hit) return hit;
	let date = '';
	try {
		date = execFileSync('git', ['log', '-1', '--format=%cI', '--', ...paths], {
			encoding: 'utf8',
			stdio: ['ignore', 'pipe', 'ignore']
		}).trim();
	} catch {
		date = '';
	}
	const day = (date || new Date().toISOString()).slice(0, 10);
	cache.set(key, day);
	return day;
}

/** The content a course's pages are built from. */
export function coursePaths(courseId: string): string[] {
	return [`assets/content/courses/${courseId}.json`, `assets/content/syllabus/${courseId}.json`];
}

/** The shared collections the word pages are built from. */
export const SHARED_WORD_PATHS = [
	'assets/content/shared/nouns/de.json',
	'assets/content/shared/verbs/de.json'
];
