// Runs once per page at build time (every route is prerendered).
//
// Sets the page's language from its address: the Turkish and Arabic pages
// live under /tr/ and /ar/ (see $lib/i18n/paths.ts), the bare paths are the
// English site. app.html carries a `%lang%` placeholder, so `<html lang>`
// (and, for Arabic, dir="rtl") is right for a screen reader and a crawler
// alike without any page having to know.
//
// In a translated page, links to other pages that exist in that language
// are pointed at their prefixed twin, so a crawler finds the whole set and
// a visitor stays in the language's own addresses.

import { catalog, loadCourse } from '$lib/content';
import { serverLang } from '$lib/i18n/lang.svelte';
import { preloadLanguage } from '$lib/i18n/content.svelte';
import { localPages, pathLang, withLang } from '$lib/i18n/paths';
import type { Handle } from '@sveltejs/kit';

/** "/tr/course/…" → "tr"; anything without a known prefix → "en". */
export function langOf(pathname: string): string {
	return pathLang(pathname) ?? 'en';
}

let twins: Promise<Set<string>> | null = null;

/** The bare paths that have a Turkish and an Arabic twin. */
function localSet(): Promise<Set<string>> {
	twins ??= loadCourse(catalog.defaultCourseId).then((course) => new Set(localPages(course.id, course.quizzes)));
	return twins;
}

/** Points every link at a page that exists in `l` at its prefixed address. */
export function localizeLinks(html: string, l: string, pages: Set<string>): string {
	return html.replace(/href="(\/[^"?#]*)([?#][^"]*)?"/g, (whole, path: string, rest = '') =>
		pages.has(path) ? `href="${withLang(l, path)}${rest}"` : whole
	);
}

export const handle: Handle = async ({ event, resolve }) => {
	const l = pathLang(event.url.pathname);
	// Pages are built one at a time, so the shared language state is this page's.
	serverLang(l ?? 'en');
	if (l) await preloadLanguage(l);
	const pages = l ? await localSet() : null;
	return resolve(event, {
		transformPageChunk: ({ html }) => {
			const out = html.replace('<html lang="%lang%"', l === 'ar' ? '<html lang="ar" dir="rtl"' : `<html lang="${l ?? 'en'}"`);
			return l && pages ? localizeLinks(out, l, pages) : out;
		}
	});
};
