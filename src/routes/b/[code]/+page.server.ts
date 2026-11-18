import registry from '$content/booklinks.json';
import { findLink, resolveLink, type BookLinkRegistry } from '$lib/domain/booklinks';
import { loadBook2 } from '$lib/domain/book2';
import { appListHref } from '$lib/state/bookOpen';
import { redirect } from '@sveltejs/kit';
import type { EntryGenerator, PageServerLoad } from './$types';

// One prerendered page per printed code, so the static site answers every QR
// in every book ever printed. A code is never removed from the registry.
const links = registry as unknown as BookLinkRegistry;

export const entries: EntryGenerator = () => links.links.map((l) => ({ code: l.code }));

export const load: PageServerLoad = ({ params }) => {
	const link = findLink(links, params.code);
	if (!link) return { code: params.code, target: null, app: null, german: false };
	// A page redirect, not a server one: the site is static, so the HTML itself
	// sends the reader on. The page also shows the link, for a slow phone.
	const target = resolveLink(link);
	if (link.kind === 'url') redirect(302, target);
	// A book page whose chapter lists app quizzes for it: the code offers Book
	// or App (state/bookOpen), and remembers the answer.
	let app: string | null = null;
	let german = false;
	if (link.kind === 'chapter') {
		const [level, chapter, part] = link.target.split('/');
		const c = loadBook2('de_cert_a1', level)?.chapters.find((x) => x.id === chapter);
		if (part && c?.appQuizzes?.[part]?.length) app = appListHref('de_cert_a1', level, chapter, part);
		german = !!c?.german;
	}
	return { code: params.code, target, kind: link.kind, app, german };
};
