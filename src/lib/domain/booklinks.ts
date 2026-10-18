// Permanent links for printed books.
//
// A QR code in a book is printed once and read for years, so it never points
// at a page. It encodes a short code — https://languagequiz.org/b/a1-07 —
// and the registry in assets/content/booklinks.json says what that code means
// today: an exercise, its audio, a deck, a book. The site can be reorganised,
// an exercise renamed or merged, and the code is re-pointed; the paper does
// not change. Rules the registry keeps:
//
//   - a code is assigned once and never deleted or reused;
//   - the code says nothing about the target (no quiz id in it), so a target
//     can move without the code lying;
//   - a code whose target has gone resolves to a "this moved" page that
//     offers the nearest thing, never a 404.
//
// tool/gen-books.mjs calls `register` for every QR a book needs and writes
// the registry back; the /b/[code] route resolves from it.

import { SITE_URL } from '$lib/seo';

export type LinkKind = 'quiz' | 'audio' | 'deck' | 'book' | 'level' | 'url';

export interface BookLink {
	code: string;
	kind: LinkKind;
	/** The quiz id, deck id, book id, level, or a URL for `url`. */
	target: string;
	/** What it was for, for whoever edits the registry by hand. */
	note?: string;
	/** ISO date the code was first printed. */
	since: string;
}

export interface BookLinkRegistry {
	links: BookLink[];
}

/** The URL a code encodes — short, stable, typeable. */
export function codeUrl(code: string): string {
	return `${SITE_URL}/b/${code}`;
}

/** Where a link goes today, as a site path. */
export function resolveLink(link: BookLink): string {
	switch (link.kind) {
		case 'quiz':
			return `/course/de_cert_a1/quiz/${link.target}`;
		case 'audio':
			return `/play/${link.target}`;
		case 'deck':
			return `/course/de_cert_a1/quiz/${link.target}`;
		case 'level':
			return `/course/de_cert_a1/level/${link.target}`;
		case 'book':
			return `/course/de_cert_a1/book/${link.target}/progress`;
		case 'url':
			return link.target;
	}
}

/**
 * The code for a (kind, target), minting one when none exists. Codes are
 * `<book>-<n>`: the book they were first printed in and a running number,
 * so a code reads as "A1 book, link 7" and tells nothing else.
 */
export function register(registry: BookLinkRegistry, kind: LinkKind, target: string, book: string, note?: string): string {
	const found = registry.links.find((l) => l.kind === kind && l.target === target);
	if (found) return found.code;
	const prefix = book.toLowerCase();
	const used = registry.links.filter((l) => l.code.startsWith(prefix + '-')).length;
	const code = `${prefix}-${String(used + 1).padStart(2, '0')}`;
	registry.links.push({ code, kind, target, note, since: new Date().toISOString().slice(0, 10) });
	return code;
}

export function findLink(registry: BookLinkRegistry, code: string): BookLink | undefined {
	return registry.links.find((l) => l.code === code.toLowerCase());
}
