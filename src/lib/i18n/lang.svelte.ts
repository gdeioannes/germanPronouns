// The language the site speaks to the learner: English (the default) or
// Turkish. German is what is being learnt and never changes.
//
// Pages are prerendered in English. In the browser the language is known as
// soon as this module loads, before hydration: Svelte 5 patches dynamic text
// that differs from the prerendered HTML while it hydrates (set_text compares
// with the node's value), so everything said through t() comes up Turkish.
// Static template text and {@html} are not patched, which is why interface
// text always goes through t(). The script in app.html keeps a Turkish
// visitor's page hidden until the root layout has mounted (startLang), so the
// prerendered English never flashes.
//
// In Turkish mode only what exists in Turkish is shown (see available.ts).

import { browser } from '$app/environment';
import { tick } from 'svelte';

export type UiLang = 'en' | 'tr';
export const UI_LANGS: UiLang[] = ['en', 'tr'];
/** Also read verbatim by the script in app.html. Device-local: never synced. */
export const UI_LANG_KEY = 'ui_lang';

class Lang {
	current = $state<UiLang>('en');
	/** True once the stored choice has been applied (always true in English). */
	ready = $state(false);
	get tr() {
		return this.current === 'tr';
	}
}

export const lang = new Lang();

function stored(): UiLang | null {
	try {
		const v = localStorage.getItem(UI_LANG_KEY);
		return v === 'en' || v === 'tr' ? v : null;
	} catch {
		return null;
	}
}

/** The language for this visit: ?lang= in the address, a saved choice, then the browser's. */
export function pickLang(search: string, saved: UiLang | null, browserLangs: readonly string[]): UiLang {
	const asked = new URLSearchParams(search).get('lang');
	if (asked === 'tr' || asked === 'en') return asked;
	if (saved) return saved;
	return browserLangs.some((l) => l.toLowerCase().startsWith('tr')) ? 'tr' : 'en';
}

async function applyToDocument(l: UiLang) {
	const html = document.documentElement;
	html.dataset.uiLang = l;
	html.lang = l;
	// Shown only once the page has re-rendered in that language.
	await tick();
	html.dataset.langReady = '1';
}

/**
 * Finishes the visit's start. Called once, from the root layout's onMount:
 * remembers the language and, for Turkish, waits for `prepare` (the page's
 * content overlay) before showing the page.
 */
export async function startLang(prepare?: () => Promise<void>) {
	if (!browser) return;
	const l = lang.current;
	// An explicit ?lang= is a choice; the browser's language is only a guess
	// until the learner picks one in Settings, but it is kept so the next visit
	// does not flip if the browser changes.
	if (new URLSearchParams(location.search).get('lang') || !stored()) save(l);
	if (l === 'tr' && prepare) {
		try {
			await prepare();
		} catch {
			/* the page shows English where the overlay did not come */
		}
	}
	lang.ready = true;
	void applyToDocument(l);
}

function save(l: UiLang) {
	try {
		localStorage.setItem(UI_LANG_KEY, l);
	} catch {
		/* private window: the choice lasts for this visit */
	}
}

/** The learner picked a language in Settings. */
export function setLang(l: UiLang) {
	save(l);
	lang.current = l;
	lang.ready = true;
	if (browser) void applyToDocument(l);
}

// The language is decided before anything renders (see the top of the file).
if (browser) {
	lang.current = pickLang(location.search, stored(), navigator.languages ?? [navigator.language]);
}
