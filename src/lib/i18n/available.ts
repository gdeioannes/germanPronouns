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
	'/books',
	'/b/[code]'
]);

export function routeTranslated(routeId: string | null | undefined): boolean {
	return !!routeId && LOCAL_ROUTES.has(routeId);
}
