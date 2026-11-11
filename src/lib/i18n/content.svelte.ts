// Course content in Turkish. The English content stays the source; each
// Turkish sub-level is an overlay (built by tool/turkish/build.mjs):
//
//   assets/content/tr/de_cert_a1/a1_1.json
//   { quizzes:  { <quiz id>: { <path>: [English, Türkçe] } },
//     chapters: { <chapter id>: { <path>: [English, Türkçe] } },
//     front:    { <path>: [English, Türkçe] },
//     text:     { English: Türkçe } }
//
// An exercise or a book chapter is translated by path, exactly (Turkish can
// need two words where English has one: du/Sie are both "you"). A path only
// applies while the English there is still the English it was translated
// from, so edited content falls back to English rather than to a wrong line.
// Anything else (the placement test's items, word lists) goes through the
// level's text map, keyed by the English itself. German is never a key.

import { lang } from './lang.svelte';
import { levelInTurkish } from './available';

type Pairs = Record<string, [string, string]>;
interface Overlay {
	quizzes: Record<string, Pairs>;
	chapters: Record<string, Pairs>;
	front: Pairs;
	text: Record<string, string>;
}

const files = import.meta.glob<{ default: Overlay }>('$content/tr/de_cert_a1/*.json');

/** Loaded overlays by level id ("a1_1"); absent until fetched. */
const maps = $state<Record<string, Overlay>>({});
const pending = new Set<string>();

export const levelId = (level: string) => level.toLowerCase().replace('.', '_');

async function load(id: string) {
	if (maps[id] || pending.has(id)) return;
	const path = Object.keys(files).find((p) => p.endsWith(`/${id}.json`));
	if (!path) return;
	pending.add(id);
	try {
		maps[id] = (await files[path]()).default;
	} finally {
		pending.delete(id);
	}
}

/** Fetches a level's overlay ahead of time (await it before rendering where a flash matters). */
export function loadTurkish(level: string | null | undefined): Promise<void> {
	if (!level || !levelInTurkish(level)) return Promise.resolve();
	return load(levelId(level));
}

/** True while Turkish is on and this level's overlay is still on its way. */
export function turkishPending(level: string | null | undefined): boolean {
	return lang.tr && !!level && levelInTurkish(level) && !maps[levelId(level)];
}

/** A copy of `value` with every English string the map knows swapped for Turkish. */
export function translateDeep<T>(value: T, map: Record<string, string>): T {
	if (typeof value === 'string') return (map[value] ?? value) as T;
	if (Array.isArray(value)) return value.map((v) => translateDeep(v, map)) as T;
	if (value && typeof value === 'object') {
		const out: Record<string, unknown> = {};
		for (const [k, v] of Object.entries(value)) out[k] = translateDeep(v, map);
		return out as T;
	}
	return value;
}

/**
 * Content in the learner's language. In English, or for a level with no
 * Turkish, it is returned as is. Reactive: call it inside $derived.
 */
export function inLang<T>(value: T, level: string | null | undefined): T {
	if (!lang.tr || !level || !levelInTurkish(level)) return value;
	const overlay = overlayFor(level);
	return overlay ? translateDeep(value, overlay.text) : value;
}

function overlayFor(level: string): Overlay | null {
	const map = maps[levelId(level)];
	if (!map) void load(levelId(level));
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

/** One exercise in the learner's language: exact by path, then the level's text map. */
export function inLangQuiz<T extends { id: string; level?: string | null }>(quiz: T): T {
	const level = quiz.level;
	if (!lang.tr || !level || !levelInTurkish(level)) return quiz;
	const overlay = overlayFor(level);
	if (!overlay) return quiz;
	return translateDeep(applyPairs(quiz, overlay.quizzes[quiz.id]), overlay.text);
}

/** One book chapter (Book v2) in the learner's language. */
export function inLangChapter<T extends { id: string }>(chapter: T, level: string): T {
	if (!lang.tr || !levelInTurkish(level)) return chapter;
	const overlay = overlayFor(level);
	if (!overlay) return chapter;
	return translateDeep(applyPairs(chapter, overlay.chapters[chapter.id]), overlay.text);
}

/** A book's own lines outside its chapters (title page, front matter). */
export function inLangBookFront<T>(book: T, level: string): T {
	if (!lang.tr || !levelInTurkish(level)) return book;
	const overlay = overlayFor(level);
	return overlay ? applyPairs(book, overlay.front) : book;
}

/** One string, for places that hold a single English line (a title, a label). */
export function inLangText(s: string, level: string | null | undefined): string {
	return inLang(s, level);
}

// ── Tap-a-word glosses ────────────────────────────────────
// Turkish meanings of the dictionary words A1–A2 use, keyed "<de>|<pos>"
// (tool/turkish/dict-build.mjs). Word lists drawn from the shared noun
// collection read their meaning from here in Turkish mode.
const glossary = $state<{ map: Record<string, string> | null }>({ map: null });
let glossaryPending = false;

/** The Turkish meaning of a dictionary word, or null (not loaded yet, or none). */
export function trGloss(de: string, pos: string): string | null {
	if (!glossary.map && !glossaryPending) {
		glossaryPending = true;
		void import('$content/tr/dictionary.de.json').then((m) => (glossary.map = m.default as Record<string, string>));
	}
	return glossary.map?.[`${de}|${pos}`] ?? null;
}
