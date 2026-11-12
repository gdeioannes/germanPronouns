// The language the site speaks to the learner: English (the default), or one
// of the second languages (Turkish, Arabic) that cover A1–A2. German is what
// is being learnt and never changes.
//
// Pages are prerendered in English, and the translated ones again under
// their language's prefix (/tr/…, /ar/…, see paths.ts). In the browser the language is known as
// soon as this module loads, before hydration: Svelte 5 patches dynamic text
// that differs from the prerendered HTML while it hydrates (set_text compares
// with the node's value), so everything said through t() comes up translated.
// Static template text and {@html} are not patched, which is why interface
// text always goes through t(). The script in app.html keeps such a visitor's
// page hidden until the root layout has mounted (startLang), so the
// prerendered English never flashes.
//
// In a second language only what exists in it is shown (see available.ts).
// Arabic is written right to left: the document gets dir="rtl".

import { browser } from '$app/environment';
import { tick } from 'svelte';
import { pathLang } from './paths';

export type UiLang = 'en' | 'tr' | 'ar';
/** A second language: part of the site, A1–A2, translated by overlay. */
export type LocalLang = Exclude<UiLang, 'en'>;
export const UI_LANGS: UiLang[] = ['en', 'tr', 'ar'];
export const LOCAL_LANGS: LocalLang[] = ['tr', 'ar'];
/** Languages written right to left. */
export const RTL_LANGS: readonly UiLang[] = ['ar'];
/** Also read verbatim by the script in app.html. Device-local: never synced. */
export const UI_LANG_KEY = 'ui_lang';

export const isUiLang = (v: unknown): v is UiLang => (UI_LANGS as unknown[]).includes(v);

class Lang {
	current = $state<UiLang>('en');
	/** True once the stored choice has been applied (always true in English). */
	ready = $state(false);
	get tr() {
		return this.current === 'tr';
	}
	get ar() {
		return this.current === 'ar';
	}
	/** A second language is on: only the translated part of the site shows. */
	get limited() {
		return this.current !== 'en';
	}
	/** The second language in use, or null in English. */
	get local(): LocalLang | null {
		return this.current === 'en' ? null : this.current;
	}
	get rtl() {
		return RTL_LANGS.includes(this.current);
	}
	get dir(): 'rtl' | 'ltr' {
		return this.rtl ? 'rtl' : 'ltr';
	}
	/** For Intl and toLocale…: Arabic keeps Western digits (0–9), as the German does. */
	get locale(): string {
		return this.current === 'ar' ? 'ar-u-nu-latn' : this.current;
	}
}

export const lang = new Lang();

function stored(): UiLang | null {
	try {
		const v = localStorage.getItem(UI_LANG_KEY);
		return isUiLang(v) ? v : null;
	} catch {
		return null;
	}
}

/**
 * The language for this visit: the address's prefix (/tr/…, /ar/…), ?lang=,
 * a saved choice, then the first of the browser's languages the site speaks.
 */
export function pickLang(search: string, saved: UiLang | null, browserLangs: readonly string[], pathname = '/'): UiLang {
	const prefixed = pathLang(pathname);
	if (prefixed) return prefixed;
	const asked = new URLSearchParams(search).get('lang');
	if (isUiLang(asked)) return asked;
	if (saved) return saved;
	for (const l of browserLangs) {
		const code = l.toLowerCase().slice(0, 2);
		if (code === 'en') return 'en';
		if ((LOCAL_LANGS as string[]).includes(code)) return code as LocalLang;
	}
	return 'en';
}

async function applyToDocument(l: UiLang) {
	const html = document.documentElement;
	html.dataset.uiLang = l;
	html.lang = l;
	html.dir = RTL_LANGS.includes(l) ? 'rtl' : 'ltr';
	// Shown only once the page has re-rendered in that language.
	await tick();
	html.dataset.langReady = '1';
}

/**
 * Finishes the visit's start. Called once, from the root layout's onMount:
 * remembers the language and, for a second language, waits for `prepare`
 * (the page's content overlay) before showing the page.
 */
export async function startLang(prepare?: () => Promise<void>) {
	if (!browser) return;
	const l = lang.current;
	// An explicit ?lang= is a choice; the browser's language is only a guess
	// until the learner picks one, but it is kept so the next visit does not
	// flip if the browser changes.
	if (pathLang(location.pathname) || new URLSearchParams(location.search).get('lang') || !stored()) save(l);
	if (l !== 'en' && prepare) {
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

/** The learner picked a language (Settings, the home picker). */
export function setLang(l: UiLang) {
	save(l);
	lang.current = l;
	lang.ready = true;
	if (browser) void applyToDocument(l);
}

/**
 * Prerendering: each page is built in the language of its address. Called by
 * hooks.server.ts before every page (pages are built one at a time).
 */
export function serverLang(l: UiLang) {
	lang.current = l;
	lang.ready = true;
}

// The language is decided before anything renders (see the top of the file).
if (browser) {
	lang.current = pickLang(location.search, stored(), navigator.languages ?? [navigator.language], location.pathname);
}
