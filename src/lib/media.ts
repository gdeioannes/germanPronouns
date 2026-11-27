// Where the heavy files are served from. The recordings (.mp3) and the PDFs
// (books, charts, classics, workbooks) live in a Cloudflare R2 bucket in
// production, so the GitHub Pages site stays under its 1 GB limit; the pages,
// pictures and the small audio manifests stay on Pages.
//
// PUBLIC_MEDIA_BASE is the bucket's public address, e.g.
// https://media.languagequiz.org. Unset (dev server, tests, or before the
// bucket exists) every path stays a same-origin path served from static/, so
// the site works exactly as it did. tool/media-sync.mjs uploads the files and
// tool/strip-media.mjs drops them from build/ — both use the same rule.

import { isRemoteMedia } from '../../tool/media-rule.mjs';

const env = import.meta.env as Record<string, string | undefined>;

/** The bucket's public origin, no trailing slash; '' = serve from the site. */
export const MEDIA_BASE = (env.PUBLIC_MEDIA_BASE ?? '').trim().replace(/\/+$/, '');

/** The URL to load a static file from: "/audio/x.mp3" → the bucket's copy when there is one. */
export function mediaUrl(path: string): string {
	if (!MEDIA_BASE || !path.startsWith('/') || !isRemoteMedia(path.slice(1))) return path;
	return MEDIA_BASE + path;
}
