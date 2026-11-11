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

export const LANG_OPTIONS: LangOption[] = [
	{ code: 'en', name: 'English', note: 'German explained in English · A1–C2', dir: 'ltr' },
	{ code: 'tr', name: 'Türkçe', note: 'Türkçe açıklamalı Almanca · A1–A2', dir: 'ltr' },
	{ code: 'ar', name: 'العربية', note: 'الألمانية بشرح عربي · A1–A2', dir: 'rtl' }
];

/** "Language" in every offered language, for the pickers' labels. */
export const LANGUAGE_LABEL = 'Language / Dil / اللغة';
