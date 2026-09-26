// Runs once per page at build time (every route is prerendered).
//
// Sets the document's language from the URL: a translated set of routes
// lives under its language prefix (/es/…, /zh/…), and the bare paths are the
// English site. app.html carries a `%lang%` placeholder for it, so `<html
// lang>` is right for a screen reader and a crawler alike without any page
// having to know.

import { DEFAULT_LANG, LOCALES } from '$lib/seo';
import type { Handle } from '@sveltejs/kit';

/** "/es/course/…" → "es"; anything without a known prefix → the default. */
export function langOf(pathname: string): string {
	const prefix = pathname.match(/^\/([a-z]{2})(?:\/|$)/)?.[1];
	return prefix && prefix !== DEFAULT_LANG && LOCALES[prefix] ? prefix : DEFAULT_LANG;
}

export const handle: Handle = async ({ event, resolve }) => {
	const lang = langOf(event.url.pathname);
	return resolve(event, {
		transformPageChunk: ({ html }) => html.replace('%lang%', lang)
	});
};
