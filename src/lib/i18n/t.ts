// Interface text. Every English string the interface shows goes through t(),
// and the English itself is the key: tr.ts maps it to Turkish, ar.ts to
// Arabic. A string missing there stays English, and the coverage test lists it.
//
//   t('Settings')
//   t('{n} left', { n: 3 })   // placeholders in braces, same in both

import { lang, type LocalLang } from './lang.svelte';
import { TR } from './tr';
import { AR } from './ar';
import { isolateLatin } from './bidi';

/** Interface strings per second language, keyed by the English. */
export const STRINGS: Record<LocalLang, Record<string, string>> = { tr: TR, ar: AR };

/** What is shown: Arabic with its German runs isolated (bidi.ts), made once on first use. */
let shownAr: Record<string, string> | null = null;
const shown = (l: LocalLang) =>
	l === 'ar' ? (shownAr ??= Object.fromEntries(Object.entries(AR).map(([k, v]) => [k, isolateLatin(v)]))) : STRINGS[l];

export type Vars = Record<string, string | number>;

function fill(s: string, vars?: Vars): string {
	if (!vars) return s;
	return s.replace(/\{(\w+)\}/g, (m, k) => (k in vars ? String(vars[k]) : m));
}

/** The interface string in the learner's language. Reactive: re-renders on a switch. */
export function t(en: string, vars?: Vars): string {
	const l = lang.local;
	return fill(l ? (shown(l)[en] ?? en) : en, vars);
}

/** Picks the singular or plural English, then translates it. Turkish and Arabic nouns follow their own number rules, so both forms may share one translation. */
export function tn(n: number, one: string, many: string, vars?: Vars): string {
	return t(n === 1 ? one : many, { n, ...vars });
}

/**
 * Marks an English string kept in a constant (a label table, a list of tips)
 * as interface text. It returns the string unchanged; the place that shows it
 * calls t() on it. The marker is what lets tool/turkish/ui-keys.mjs find it.
 */
export const tk = (en: string): string => en;

/**
 * A translated sentence as HTML with its numbers in bold, for lines whose
 * figures were <strong> in the markup ("Your streak stands at <b>7</b>").
 * The text is escaped first: only the bold tags are HTML.
 */
export function boldNumbers(text: string): string {
	const esc = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
	return esc.replace(/\d+/g, '<strong class="tnum">$&</strong>');
}

/**
 * `lang` for a short label that may be German or in the learner's language.
 * In Turkish mode capitals follow Turkish rules (i → İ), which German words
 * must not get ("ARTİKEL"), so a label without any Turkish-only letter is
 * marked German. In Arabic, a label without Arabic letters is German, and
 * marking it keeps it reading left to right.
 */
export function labelLang(label: string | null | undefined): 'de' | undefined {
	if (!label || !lang.limited) return undefined;
	if (lang.ar) return /[\u0600-\u06FF]/.test(label) ? undefined : 'de';
	return /[çğışÇĞİŞ]/.test(label) ? undefined : 'de';
}
