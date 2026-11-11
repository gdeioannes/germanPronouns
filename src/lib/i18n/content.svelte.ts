// Course content in a second language (Turkish, Arabic). The English content
// stays the source; each translated sub-level is an overlay (built by
// tool/turkish/build.mjs --lang <tr|ar>):
//
//   assets/content/<tr|ar>/de_cert_a1/a1_1.json
//   { quizzes:  { <quiz id>: { <path>: [English, translation] } },
//     chapters: { <chapter id>: { <path>: [English, translation] } },
//     front:    { <path>: [English, translation] },
//     text:     { English: translation } }
//
// An exercise or a book chapter is translated by path, exactly (Turkish can
// need two words where English has one: du/Sie are both "you"). A path only
// applies while the English there is still the English it was translated
// from, so edited content falls back to English rather than to a wrong line.
// Anything else (the placement test's items, word lists) goes through the
// level's text map, keyed by the English itself. German is never a key.

import { lang, type LocalLang } from './lang.svelte';
import { levelTranslated } from './available';
import { isolateLatin } from './bidi';

type Pairs = Record<string, [string, string]>;
interface Overlay {
	quizzes: Record<string, Pairs>;
	chapters: Record<string, Pairs>;
	front: Pairs;
	text: Record<string, string>;
}

const files = import.meta.glob<{ default: Overlay }>(['$content/tr/de_cert_a1/*.json', '$content/ar/de_cert_a1/*.json']);

/** Loaded overlays by "<lang>/<level id>" ("ar/a1_1"); absent until fetched. */
const maps = $state<Record<string, Overlay>>({});
const pending = new Set<string>();

export const levelId = (level: string) => level.toLowerCase().replace('.', '_');

const key = (l: LocalLang, level: string) => `${l}/${levelId(level)}`;

async function load(l: LocalLang, level: string) {
	const k = key(l, level);
	if (maps[k] || pending.has(k)) return;
	const path = Object.keys(files).find((p) => p.endsWith(`/${l}/de_cert_a1/${levelId(level)}.json`));
	if (!path) return;
	pending.add(k);
	try {
		const overlay = (await files[path]()).default;
		maps[k] = l === 'ar' ? isolated(overlay) : overlay;
	} finally {
		pending.delete(k);
	}
}

/** Arabic: every translation with its German runs isolated (bidi.ts), done once on load. */
function isolated(o: Overlay): Overlay {
	const pairs = (p: Pairs): Pairs => Object.fromEntries(Object.entries(p).map(([path, [en, ar]]) => [path, [en, isolateLatin(ar)]]));
	const each = (m: Record<string, Pairs>) => Object.fromEntries(Object.entries(m).map(([id, p]) => [id, pairs(p)]));
	return {
		quizzes: each(o.quizzes),
		chapters: each(o.chapters),
		front: pairs(o.front),
		text: Object.fromEntries(Object.entries(o.text).map(([en, ar]) => [en, isolateLatin(ar)]))
	};
}

/** Fetches a level's overlay ahead of time (await it before rendering where a flash matters). */
export function loadOverlay(level: string | null | undefined): Promise<void> {
	const l = lang.local;
	if (!l || !level || !levelTranslated(level)) return Promise.resolve();
	return load(l, level);
}

/** True while a second language is on and this level's overlay is still on its way. */
export function overlayPending(level: string | null | undefined): boolean {
	const l = lang.local;
	return !!l && !!level && levelTranslated(level) && !maps[key(l, level)];
}

/**
 * Fields that hold codes the components switch on ("kind": "table", "spot":
 * "on", "image": "sofa"), never shown text. The text map must not touch them:
 * a translated code breaks the page (a lesson picture crashed on "على").
 */
const CODE_KEYS = new Set(['id', 'key', 'subjectKey', 'kind', 'type', 'spot', 'mode', 'image', 'slug', 'tone', 'accent', 'pos', 'role', 'flag', 'flags']);

/**
 * Inside an exercise or a chapter, the paths already carry every translated
 * line; the text map only fills in short labels the extractor cannot tell
 * from German ("I", "morning"). Everywhere else in them (answers, options,
 * tiles …) a string may be German that looks English: "hat", "bin", "in".
 */
const LABEL_KEYS = new Set(['display', 'persons', 'label', 'promptLabel', 'columns', 'low', 'high', 'tag']);

/**
 * A copy of `value` with every English string the map knows swapped for its
 * translation, except in code fields; with `only`, just in those fields.
 */
export function translateDeep<T>(value: T, map: Record<string, string>, only?: Set<string>, field?: string): T {
	if (typeof value === 'string') {
		if (field && CODE_KEYS.has(field)) return value;
		if (only && !(field && only.has(field))) return value;
		return (map[value] ?? value) as T;
	}
	if (Array.isArray(value)) return value.map((v) => translateDeep(v, map, only, field)) as T;
	if (value && typeof value === 'object') {
		const out: Record<string, unknown> = {};
		for (const [k, v] of Object.entries(value)) out[k] = translateDeep(v, map, only, k);
		return out as T;
	}
	return value;
}

/**
 * Content in the learner's language. In English, or for a level with no
 * Turkish, it is returned as is. Reactive: call it inside $derived.
 */
export function inLang<T>(value: T, level: string | null | undefined): T {
	if (!lang.limited || !level || !levelTranslated(level)) return value;
	const overlay = overlayFor(level);
	return overlay ? translateDeep(value, overlay.text) : value;
}

function overlayFor(level: string): Overlay | null {
	const l = lang.local;
	if (!l) return null;
	const map = maps[key(l, level)];
	if (!map) void load(l, level);
	return map ?? null;
}

/**
 * "help.tips[0].title" → ["help", "tips", 0, "title"]. A key holding a dot or
 * a bracket is written `["mein (my, Nom.)"]` (tool/turkish/lib.mjs join).
 */
export function parsePath(path: string): (string | number)[] {
	const keys: (string | number)[] = [];
	for (const m of path.matchAll(/\[("(?:[^"\\]|\\.)*")\]|\[(\d+)\]|([^.[\]]+)/g)) {
		if (m[1]) keys.push(JSON.parse(m[1]) as string);
		else if (m[2]) keys.push(Number(m[2]));
		else keys.push(/^\d+$/.test(m[3]) ? Number(m[3]) : m[3]);
	}
	return keys;
}

/** Sets each path whose English is unchanged; returns a copy. */
export function applyPairs<T>(value: T, pairs: Pairs | undefined): T {
	if (!pairs) return value;
	const out = structuredClone(value) as Record<string | number, unknown>;
	for (const [path, [en, tr]] of Object.entries(pairs)) {
		const keys = parsePath(path);
		let at: Record<string | number, unknown> | undefined = out;
		for (const k of keys.slice(0, -1)) at = at?.[k] as Record<string | number, unknown> | undefined;
		const last = keys.at(-1)!;
		if (at && at[last] === en) at[last] = tr;
	}
	return out as T;
}

/** An exercise or a chapter: its paths, then the text map on labels only. Pure (tested). */
export function localize<T>(value: T, pairs: Pairs | undefined, text: Record<string, string>): T {
	return translateDeep(applyPairs(value, pairs), text, LABEL_KEYS);
}

/** One exercise in the learner's language: exact by path, then the level's text map. */
export function inLangQuiz<T extends { id: string; level?: string | null }>(quiz: T): T {
	const level = quiz.level;
	if (!lang.limited || !level || !levelTranslated(level)) return quiz;
	const overlay = overlayFor(level);
	if (!overlay) return quiz;
	return localize(quiz, overlay.quizzes[quiz.id], overlay.text);
}

/** One book chapter (Book v2) in the learner's language. */
export function inLangChapter<T extends { id: string }>(chapter: T, level: string): T {
	if (!lang.limited || !levelTranslated(level)) return chapter;
	const overlay = overlayFor(level);
	if (!overlay) return chapter;
	return localize(chapter, overlay.chapters[chapter.id], overlay.text);
}

/** A book's own lines outside its chapters (title page, front matter). */
export function inLangBookFront<T>(book: T, level: string): T {
	if (!lang.limited || !levelTranslated(level)) return book;
	const overlay = overlayFor(level);
	return overlay ? applyPairs(book, overlay.front) : book;
}

/** One string, for places that hold a single English line (a title, a label). */
export function inLangText(s: string, level: string | null | undefined): string {
	return inLang(s, level);
}

// ── Tap-a-word glosses ────────────────────────────────────
// Meanings of the dictionary words A1–A2 use in each second language, keyed
// "<de>|<pos>" (tool/turkish/dict-build.mjs). Word lists drawn from the shared
// noun collection read their meaning from here in a second language.
const glossFiles = import.meta.glob<{ default: Record<string, string> }>([
	'$content/tr/dictionary.de.json',
	'$content/ar/dictionary.de.json'
]);
const glossaries = $state<Partial<Record<LocalLang, Record<string, string>>>>({});
const glossaryPending = new Set<LocalLang>();

/** Loads a second language's tap-a-word meanings (once). */
export function loadGlossary(l: LocalLang): Promise<Record<string, string> | null> {
	if (glossaries[l]) return Promise.resolve(glossaries[l]!);
	const path = Object.keys(glossFiles).find((p) => p.endsWith(`/${l}/dictionary.de.json`));
	if (!path) return Promise.resolve(null);
	glossaryPending.add(l);
	return glossFiles[path]().then(
		(m) =>
			(glossaries[l] =
				l === 'ar' ? Object.fromEntries(Object.entries(m.default).map(([k, v]) => [k, isolateLatin(v)])) : m.default)
	);
}

/** The learner's-language meaning of a dictionary word, or null (not loaded yet, or none). */
export function localGloss(de: string, pos: string): string | null {
	const l = lang.local;
	if (!l) return null;
	if (!glossaries[l] && !glossaryPending.has(l)) void loadGlossary(l);
	return glossaries[l]?.[`${de}|${pos}`] ?? null;
}
