// Moving to an exercise in Turkish mode fetches its level's Turkish first, so
// the page never opens in English and switches under the learner.
import { browser } from '$app/environment';
import { lang } from '$lib/i18n/lang.svelte';
import { loadOverlay } from '$lib/i18n/content.svelte';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ data }) => {
	if (browser && lang.limited) await loadOverlay(data.quiz.level);
	return data;
};
