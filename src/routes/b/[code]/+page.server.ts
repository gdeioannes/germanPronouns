import registry from '$content/booklinks.json';
import { findLink, resolveLink, type BookLinkRegistry } from '$lib/domain/booklinks';
import { redirect } from '@sveltejs/kit';
import type { EntryGenerator, PageServerLoad } from './$types';

// One prerendered page per printed code, so the static site answers every QR
// in every book ever printed. A code is never removed from the registry.
const links = registry as unknown as BookLinkRegistry;

export const entries: EntryGenerator = () => links.links.map((l) => ({ code: l.code }));

export const load: PageServerLoad = ({ params }) => {
	const link = findLink(links, params.code);
	if (!link) return { code: params.code, target: null };
	// A page redirect, not a server one: the site is static, so the HTML itself
	// sends the reader on. The page also shows the link, for a slow phone.
	const target = resolveLink(link);
	if (link.kind === 'url') redirect(302, target);
	return { code: params.code, target, kind: link.kind };
};
