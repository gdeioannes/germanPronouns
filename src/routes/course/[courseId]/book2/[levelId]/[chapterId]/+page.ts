// In Turkish mode the level's Turkish is fetched before the page shows, so the
// book never opens in English and switches under the reader.
import { browser } from '$app/environment';
import { lang } from '$lib/i18n/lang.svelte';
import { loadOverlay } from '$lib/i18n/content.svelte';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ data, params }) => {
	if (browser && lang.limited) await loadOverlay(params.levelId);
	return data;
};
