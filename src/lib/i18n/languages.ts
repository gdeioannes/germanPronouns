// The languages the site explains German in, as the language pickers show
// them (home picker, Settings): each name and note in its own language, so
// whoever is lost in the current one still finds theirs.
import type { UiLang } from './lang.svelte';

export interface LangOption {
	code: UiLang;
	/** The language's own name for itself. */
	name: string;
	/** What it offers, in that language. */
	note: string;
	dir: 'ltr' | 'rtl';
}

// After English: French, Spanish, Turkish, Ukrainian, then Arabic.
// Each note ends with the levels explained in that language: A1–A2 fully,
// above that through the explanation button (an overlay per level). The range
// must follow assets/content/<lang>/de_cert_a1/: i18n.test.ts checks it.
export const LANG_OPTIONS: LangOption[] = [
	{ code: 'en', name: 'English', note: 'German explained in English · A1–C2', dir: 'ltr' },
	{ code: 'fr', name: 'Français', note: "L'allemand expliqué en français · A1–C2", dir: 'ltr' },
	{ code: 'es', name: 'Español', note: 'El alemán explicado en español · A1–C2', dir: 'ltr' },
	{ code: 'tr', name: 'Türkçe', note: 'Türkçe açıklamalı Almanca · A1–A2', dir: 'ltr' },
	{ code: 'uk', name: 'Українська', note: 'Німецька з поясненнями українською · A1–C2', dir: 'ltr' },
	{ code: 'ar', name: 'العربية', note: 'الألمانية بشرح عربي · A1–A2', dir: 'rtl' }
];

/** "Language" in every offered language, for the pickers' labels. */
export const LANGUAGE_LABEL = 'Language / Langue / Idioma / Dil / Мова / اللغة';
