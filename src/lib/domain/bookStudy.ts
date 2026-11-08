// The printed book (Book v2) working with the app.
//
// Every page of a chapter that has exercises carries a small code
// (domain/booklinks, kind 'chapter'). It opens the chapter's page in the app at
// that part, which
//   * checks the page's exercises: the reader types or taps what they wrote
//     on paper and the app marks it against the book's own key;
//   * turns the chapter's words into flashcards, spaced over days;
//   * reads every line of the chapter's text aloud;
//   * remembers where in the book the reader is, so the course home can say
//     "your book: A1.1, chapter 3" and lead back to it.
// This module is the pure part: the marking, the parts of a chapter as
// printed, the flashcard schedule and the storage keys.

import type { Exercise } from './companion';
import { plain } from './companion';
import { practiseOf, type Chapter } from './book2';

// ---- the parts of a chapter, as printed ------------------------------------

/** The pages of a chapter that carry a code, in page order. */
export type PartId = 'woerter' | 'lesen' | 'grammatik-1' | 'grammatik-2' | 'alltag' | 'uebungen-1' | 'uebungen-2';

export const PART_IDS: PartId[] = ['woerter', 'lesen', 'grammatik-1', 'grammatik-2', 'alltag', 'uebungen-1', 'uebungen-2'];

export interface PartExercise {
	/** The number printed beside the exercise. */
	n: number;
	ex: Exercise;
	/** Stable id within the chapter, for the saved results. */
	key: string;
}

export interface ChapterPart {
	id: PartId;
	/** The page's label as printed (German). */
	label: string;
	exercises: PartExercise[];
}

/** The two practice pages split the exercises as the book does: first half on the first page. */
export function practisePages(c: Chapter): [Exercise[], Exercise[]] {
	const all = practiseOf(c);
	const half = Math.ceil(all.length / 2);
	return [all.slice(0, half), all.slice(half)];
}

/** Every part of a chapter with its exercises, numbered exactly as the printed page numbers them. */
export function chapterParts(c: Chapter): ChapterPart[] {
	const [p1, p2] = practisePages(c);
	const list = (id: PartId, exs: Exercise[], first = 1): PartExercise[] =>
		exs.map((ex, i) => ({ n: first + i, ex, key: `${id}-${first + i}` }));
	const parts: ChapterPart[] = [
		{ id: 'woerter', label: 'Wörter zuerst', exercises: [] },
		{ id: 'lesen', label: 'Lesen', exercises: list('lesen', c.reading.tasks) }
	];
	c.grammar.slice(0, 2).forEach((g, gi) => {
		const id = `grammatik-${gi + 1}` as PartId;
		parts.push({ id, label: `Grammatik · ${g.heading}`, exercises: g.check ? [{ n: gi + 1, ex: g.check, key: `${id}-${gi + 1}` }] : [] });
	});
	parts.push({ id: 'alltag', label: 'Lesen im Alltag', exercises: list('alltag', c.document.tasks) });
	parts.push({ id: 'uebungen-1', label: 'Übungen · 1', exercises: list('uebungen-1', p1) });
	parts.push({ id: 'uebungen-2', label: 'Übungen · 2', exercises: list('uebungen-2', p2, p1.length + 1) });
	return parts;
}

// ---- marking typed answers ---------------------------------------------------

/** Lower-case, one kind of quote and dash, no currency sign, no closing punctuation, single spaces. */
export function normalise(s: string, keepCase = false): string {
	const t = plain(s).normalize('NFC');
	return (keepCase ? t : t.toLowerCase())
		.replace(/[’‘`´]/g, "'")
		.replace(/[“”„«»]/g, '"')
		.replace(/[–—]/g, '-')
		.replace(/€/g, '')
		.replace(/\.\.\.|…/g, ' … ')
		.replace(/\s+/g, ' ')
		.replace(/\s+([,.!?;:])/g, '$1')
		.trim()
		.replace(/^["']+|["']+$/g, '')
		.replace(/[.!?;:,]+$/g, '')
		.trim();
}

/** The forms of a key answer the reader may have written. */
export function acceptedForms(answer: string): string[] {
	const forms = new Set<string>([answer]);
	// "zwei (or zwo)": the main answer, and the alternative in its place.
	const or = /^(.*?)\s*\((?:or|oder)\s+([^)]+)\)\s*(.*)$/i.exec(answer);
	if (or) {
		const [, main, alt, rest] = or;
		forms.add(`${main} ${rest}`);
		const words = main.trim().split(/\s+/);
		if (words.length === 1) forms.add(`${alt} ${rest}`);
		else forms.add([...words.slice(0, -1), alt].join(' ') + ` ${rest}`);
	}
	// "Sohn (Raimond)": a note in brackets is not part of the answer.
	const bare = answer.replace(/\s*\([^)]*\)/g, '').trim();
	if (bare) forms.add(bare);
	// "seit einem Jahr / seit 2025": either one.
	if (answer.includes(' / ')) for (const part of answer.split(' / ')) forms.add(part);
	return [...forms].map((f) => f.trim()).filter(Boolean);
}

export type Mark = 'right' | 'capitals' | 'wrong' | 'open';

/**
 * One typed answer against the key. `capitals`: right apart from capital
 * letters, which in German is worth saying. A key answer that ends in "…" is
 * the start of a sentence the reader finishes: their answer must begin with it.
 */
export function markTyped(input: string, answer: string | undefined): Mark {
	if (!answer) return 'open';
	const typed = normalise(input);
	if (!typed) return 'wrong';
	const dropEllipsis = (s: string) => s.replace(/ ?… ?/g, ' ').replace(/\s+/g, ' ').trim();
	// Prices and amounts: "1 €" is "1,00 €", "2.90" is "2,90".
	const amount = (s: string) => (/^\d+([.,]\d+)?$/.test(s) ? Number(s.replace(',', '.')) : null);
	for (const form of acceptedForms(answer)) {
		const want = normalise(form);
		if (amount(typed) !== null && amount(typed) === amount(want)) return 'right';
		if (/…$/.test(want)) {
			const start = dropEllipsis(want);
			if (typed.startsWith(start) || dropEllipsis(typed).startsWith(start)) return 'right';
			continue;
		}
		if (dropEllipsis(typed) === dropEllipsis(want)) {
			// German capitals carry meaning: right apart from them is worth saying.
			const a = dropEllipsis(normalise(input, true));
			const b = dropEllipsis(normalise(form, true));
			return a === b ? 'right' : 'capitals';
		}
	}
	return 'wrong';
}

/** What the reader answered, per exercise kind: typed text, a picked option, or a picked index. */
export type Answers = Record<number, string>;

export interface ItemResult {
	/** What the item showed, for the corrections list. */
	q?: string;
	mark: Mark;
	/** The book's answer. */
	expected: string;
	given: string;
}

/** Marks a whole exercise. Items with no key answer (the reader's own) are 'open' and not counted. */
export function markExercise(ex: Exercise, answers: Answers): ItemResult[] {
	const given = (i: number) => answers[i] ?? '';
	switch (ex.kind) {
		case 'write':
			return ex.items.map((it, i) => ({ q: plain(it.prompt), mark: markTyped(given(i), it.answer), expected: it.answer, given: given(i) }));
		case 'gaps':
			return ex.items.map((it, i) => ({ q: `${plain(it.before)} ___ ${plain(it.after ?? '')}`.trim(), mark: markTyped(given(i), it.answer), expected: it.answer ?? '', given: given(i) }));
		case 'tags':
			return ex.items.map((it, i) => ({ q: it.label || undefined, mark: markTyped(given(i), it.answer), expected: it.answer, given: given(i) }));
		case 'clocks':
			return ex.items.map((it, i) => {
				const expected = ex.draw ? it.time : it.de;
				return { q: ex.draw ? it.de : it.time, mark: markTyped(given(i).replace(/^(\d):/, '0$1:'), expected.replace(/^(\d):/, '0$1:')), expected, given: given(i) };
			});
		case 'circle':
			return ex.items.map((it, i) => ({ q: `${plain(it.before)} ___ ${plain(it.after ?? '')}`.trim(), mark: given(i) === '' ? 'wrong' : given(i) === it.answer ? 'right' : 'wrong', expected: it.answer, given: given(i) }));
		case 'match':
			return ex.left.map((l, i) => ({ q: l, mark: given(i) !== '' && Number(given(i)) === ex.answers[i] ? 'right' : 'wrong', expected: ex.right[ex.answers[i]], given: given(i) === '' ? '' : ex.right[Number(given(i))] }));
		case 'sort':
			return ex.words.map((w, i) => ({ q: w, mark: given(i) !== '' && Number(given(i)) === ex.answers[i] ? 'right' : 'wrong', expected: ex.columns[ex.answers[i]], given: given(i) === '' ? '' : ex.columns[Number(given(i))] }));
		case 'colour':
			return [];
	}
}

/** Right answers out of those that can be marked. Capitals count as right. */
export function scoreOf(results: ItemResult[]): { right: number; total: number } {
	const marked = results.filter((r) => r.mark !== 'open');
	return { right: marked.filter((r) => r.mark === 'right' || r.mark === 'capitals').length, total: marked.length };
}

// ---- storage -----------------------------------------------------------------

/** Where in the book the reader last was. Synced: it is about the learner, not the device. */
export const BOOK_PLACE_KEY = 'book2_place';

export interface BookPlace {
	level: string;
	chapter: string;
	/** Chapter number and title, so the course home needs no book file to say it. */
	n: number;
	title: string;
	part: PartId | null;
	at: number;
}

export function parsePlace(raw: string | null): BookPlace | null {
	try {
		const p = JSON.parse(raw ?? 'null');
		return p && typeof p.level === 'string' && typeof p.chapter === 'string' ? (p as BookPlace) : null;
	} catch {
		return null;
	}
}

const stem = (level: string) => level.toLowerCase().replace(/\./g, '_');

/** The checked exercises of one chapter: { "<part>-<n>": { right, total, at } }. */
export const checksKey = (level: string, chapter: string) => `book2_checks_${stem(level)}_${chapter}`;

export type ChapterChecks = Record<string, { right: number; total: number; at: number }>;

export function parseChecks(raw: string | null): ChapterChecks {
	try {
		const c = JSON.parse(raw ?? '{}');
		return c && typeof c === 'object' ? c : {};
	} catch {
		return {};
	}
}

// ---- flashcards ----------------------------------------------------------------

/** The flashcard boxes of one book: { "<German>": { box, due } }. */
export const wordsKey = (level: string) => `book2_words_${stem(level)}`;

export type WordBoxes = Record<string, { box: number; due: number }>;

/** Days until a word comes back, by box: a word known again and again waits longer each time. */
export const BOX_DAYS = [0, 1, 3, 7, 16, 35];
const DAY = 24 * 60 * 60 * 1000;

export function parseBoxes(raw: string | null): WordBoxes {
	try {
		const b = JSON.parse(raw ?? '{}');
		return b && typeof b === 'object' ? b : {};
	} catch {
		return {};
	}
}

/** The words due now: new ones and those whose day has come, longest waiting first. */
export function dueWords<T extends { de: string }>(words: T[], boxes: WordBoxes, now: number): T[] {
	return words
		.filter((w) => !boxes[w.de] || boxes[w.de].due <= now)
		.sort((a, b) => (boxes[a.de]?.due ?? 0) - (boxes[b.de]?.due ?? 0));
}

/** After an answer: known moves the word up a box (later), not yet sends it back to the first. */
export function review(boxes: WordBoxes, de: string, known: boolean, now: number): WordBoxes {
	const box = known ? Math.min((boxes[de]?.box ?? 0) + 1, BOX_DAYS.length - 1) : 0;
	return { ...boxes, [de]: { box, due: known ? now + BOX_DAYS[box] * DAY : now } };
}

/** Words that have reached the last two boxes: learnt, for the chapter's summary. */
export const learntCount = (words: { de: string }[], boxes: WordBoxes) =>
	words.filter((w) => (boxes[w.de]?.box ?? 0) >= BOX_DAYS.length - 2).length;
