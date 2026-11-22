// What exists in the second languages (Turkish, Arabic). In one of them
// everything else is hidden: menus drop it, and opening it directly shows a
// short "not in your language yet" note. Every second language covers the
// same part of the site.

/** The sub-levels whose lessons, exercises and books are in the second languages. */
export const LOCAL_LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2'] as const;

/** Level ids as routes and file names use them ("a1_1"). */
export const LOCAL_LEVEL_IDS = LOCAL_LEVELS.map((l) => l.toLowerCase().replace('.', '_'));

export function levelTranslated(level: string | null | undefined): boolean {
	if (!level) return false;
	const norm = level.toUpperCase().replace('_', '.');
	return (LOCAL_LEVELS as readonly string[]).includes(norm);
}

/**
 * Route ids (SvelteKit's `page.route.id`) that are translated. A route not
 * here is hidden in a second language. Level-bound routes also check their level.
 */
export const LOCAL_ROUTES = new Set<string>([
	'/',
	'/start',
	'/settings',
	'/about',
	'/legal',
	'/credits',
	'/contact',
	// Not /signin: the sign-in emails and panels are English-only, so Turkish
	// mode hides signing in (a signed-in learner keeps syncing in the background).
	'/level-check',
	'/level-check/test',
	'/course/[courseId]',
	'/course/[courseId]/level/[levelId]',
	'/course/[courseId]/quiz/[quizId]',
	'/course/[courseId]/book2/[levelId]',
	'/course/[courseId]/book2/[levelId]/[chapterId]',
	// A book page's quiz list (the App side of a page code).
	'/course/[courseId]/book2/[levelId]/[chapterId]/app/[part]',
	'/books',
	'/b/[code]',
	// The audio player a book's QR code opens: the translated books print these codes too.
	'/play/[quizId]'
]);

export function routeTranslated(routeId: string | null | undefined): boolean {
	return !!routeId && LOCAL_ROUTES.has(routeId);
}

/**
 * Pages that are not translated but still open in a second language, as they
 * are (English): someone who arrives by a link (a search, a chat, a shared
 * address) gets the page, not a dead end. They stay out of that language's
 * menus, which list only what is translated. Sign-in, the forum and the
 * owner's tools stay hidden: they need an account, and that flow is English-only.
 */
export const OPEN_ROUTES = new Set<string>([
	'/changelog',
	'/level-check/words',
	'/words',
	'/words/dictionary',
	'/words/nouns',
	'/words/nouns/[slug]',
	'/words/verbs',
	'/words/verbs/[slug]',
	'/literature',
	'/charts',
	'/german-faq',
	'/german-faq/[slug]',
	'/literature/die-verwandlung',
	'/literature/die-verwandlung/[stage]',
	'/stories',
	'/story/ep0-lost-in-berlin',
	'/story/ep1-empty-room',
	'/story/ep2-secret-room',
	'/play/wortbloecke',
	'/play/ja-nein',
	'/play/ja-nein/personas',
	'/play/schreib-mir',
	'/play/schreib-mir/[id]',
	'/play/schreib-mir/kontakte'
]);

/** Open, untranslated: shown in English inside a second language. */
export function routeOpenAsIs(routeId: string | null | undefined): boolean {
	return !!routeId && OPEN_ROUTES.has(routeId);
}
