import type { PageServerLoad } from './$types';
import { POLL_BOOKS } from '$lib/content/bookPoll';
import { creditShort } from '$lib/domain/credits';

/**
 * The poll pictures' short credits, worked out at prerender so the page does
 * not ship the whole Commons register (350 kB). A book with no Commons credit
 * has a picture made with AI (assets/images/literature_manifest.json): null.
 */
export const load: PageServerLoad = () => ({
	pictureCredits: Object.fromEntries(POLL_BOOKS.map((b) => [b.id, creditShort(`lit_${b.id}`)])) as Record<string, string | null>
});
