// What exists in Turkish. In Turkish mode everything else is hidden: menus
// drop it, and opening it directly shows a short "not in Turkish yet" note.

/** The sub-levels whose lessons, exercises and books are in Turkish. */
export const TR_LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2'] as const;

/** Level ids as routes and file names use them ("a1_1"). */
export const TR_LEVEL_IDS = TR_LEVELS.map((l) => l.toLowerCase().replace('.', '_'));

export function levelInTurkish(level: string | null | undefined): boolean {
	if (!level) return false;
	const norm = level.toUpperCase().replace('_', '.');
	return (TR_LEVELS as readonly string[]).includes(norm);
}

/**
 * Route ids (SvelteKit's `page.route.id`) that are in Turkish. A route not
 * here is hidden in Turkish mode. Level-bound routes also check their level.
 */
export const TR_ROUTES = new Set<string>([
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

export function routeInTurkish(routeId: string | null | undefined): boolean {
	return !!routeId && TR_ROUTES.has(routeId);
}
