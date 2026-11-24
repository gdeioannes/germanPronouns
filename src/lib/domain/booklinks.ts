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
// The /b/[code] route resolves from the registry.

import { SITE_URL } from '$lib/seo';

export type LinkKind = 'quiz' | 'audio' | 'deck' | 'book' | 'level' | 'url' | 'chapter';

export interface BookLink {
	code: string;
	kind: LinkKind;
	/** The quiz id, deck id, book id, level, a URL for `url`, or `<level>/<chapter>/<part>` for `chapter`. */
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
			// The old whole-level book (A1 … C2) is gone: its codes open the shelf.
			return '/books';
		case 'url':
			return link.target;
		case 'chapter': {
			// "<level>/<chapter>/<part>": one page of a Book v2 chapter, opened at
			// that part of the chapter's page in the app (domain/bookStudy).
			const [level, chapter, part] = link.target.split('/');
			return `/course/de_cert_a1/book2/${level}/${chapter}${part ? `#${part}` : ''}`;
		}
	}
}

/**
 * `href` tagged as a visit from the book, so the usage statistics attribute
 * the whole visit to source "book", campaign = the code (services/analytics
 * reads these tags). The tag is added on the site, at /b/<code>, so the
 * printed QR never changes and books already sold are counted too. A scan and
 * a typed code open the same address, so this means "came from the book".
 * Any #part stays at the end, where the browser needs it.
 */
export function fromBookHref(href: string, code: string): string {
	const [path, hash] = href.split('#');
	const sep = path.includes('?') ? '&' : '?';
	const tags = `utm_source=book&utm_medium=code&utm_campaign=${encodeURIComponent(code)}`;
	return `${path}${sep}${tags}${hash ? `#${hash}` : ''}`;
}

export function findLink(registry: BookLinkRegistry, code: string): BookLink | undefined {
	return registry.links.find((l) => l.code === code.toLowerCase());
}
