// A printed book: one level (A1 … C2) as two parts, each a sub-level's
// workbook in full, between a front matter that says how the book works and
// a back matter that holds the key, the grammar tables, the word index and
// the list of everything the QR codes play.
//
// Pure, like buildWorkbook: the route adds the QR pictures, the tool adds the
// paper. The same course always builds the same book, page for page.

import type { CourseSyllabus, HelpTable, PopulatedCourse, Quiz, SyllabusModule } from '$lib/content/types';
import { ROUND_ORDER, type JaNeinRound } from './janeinRounds';
import { seededShuffle } from './lesson';
import { buildWorkbook, type PaperOverrides, type Workbook, type WorkbookUnit } from './workbook';

/** The books: a level each, two sub-levels inside. */
export const BOOKS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'] as const;
export type BookId = (typeof BOOKS)[number];

/** The ISBN of each printed book, as registered. */
export const ISBN: Record<BookId, string> = {
	A1: '978-3-911749-30-5',
	A2: '978-3-911749-31-2',
	B1: '978-3-911749-32-9',
	B2: '978-3-911749-33-6',
	C1: '978-3-911749-34-3',
	C2: '978-3-911749-35-0'
};

/** How many hard items the challenge page prints per part. */
export const CHALLENGE_ITEMS = 20;

export interface ChallengeItem {
	n: number;
	sentence: string;
	english?: string;
	answer: string;
	/** Which unit the item drills. */
	unit: number;
}

/** A photograph with its credit, as the credits page prints it. */
export interface Photo {
	id: string;
	title: string;
	author: string;
	license: string;
	source: string;
}

/** The chapter file for a sub-level: the module's themes with a photo and a text each. */
export interface ChapterSpec {
	photo?: string;
	caption?: string;
	de?: string;
	en?: string;
	chapters: { id: string; title: string; subtitle?: string; photo?: string; caption?: string; de: string; en: string; units: string[] }[];
}

export interface BookChapter {
	n: number;
	id: string;
	title: string;
	subtitle?: string;
	photo?: Photo;
	caption?: string;
	de: string;
	en: string;
	units: WorkbookUnit[];
}

export interface BookPart {
	n: 1 | 2;
	level: string;
	title: string;
	subtitle?: string;
	canDo: string[];
	themes: string[];
	workbook: Workbook;
	/** The part opener's photograph and text, when a chapter file gives one. */
	photo?: Photo;
	caption?: string;
	de?: string;
	en?: string;
	/** The units grouped by theme, in book order; empty when the level has no chapter file. */
	chapters: BookChapter[];
	/** The medal-ladder page: the part's hardest items, seeded. */
	challenge: ChallengeItem[];
	/** A light page between the heavy units: eight yes/no questions. */
	round?: JaNeinRound;
}

export interface KeyEntry {
	part: 1 | 2;
	unit: number;
	title: string;
	label: string;
	lines: string[];
}

export interface IndexEntry {
	de: string;
	article?: string;
	plural?: string;
	en: string;
	/** "1.7" — part and unit. */
	where: string;
}

export interface AppendixTable {
	part: 1 | 2;
	unit: number;
	title: string;
	table: HelpTable;
}

export interface Book {
	id: BookId;
	courseId: string;
	courseName: string;
	/** "Deutsch A1" */
	title: string;
	/** The two module names: "Erste Schritte · Im Alltag". */
	subtitle: string;
	cover?: string;
	/** The content version printed on the copyright page. */
	version: string;
	parts: BookPart[];
	key: KeyEntry[];
	appendix: AppendixTable[];
	index: IndexEntry[];
	/** Every photograph in the book, for the credits page. */
	credits: Photo[];
	/** Every unit with audio, in book order, for the audio index. */
	audio: { part: 1 | 2; unit: number; title: string; quizId: string; clips: number }[];
}

export function bookLevels(id: BookId): [string, string] {
	return [`${id}.1`, `${id}.2`];
}

/** The book for a level, or null when the course has neither sub-level. */
export function buildBook(
	course: PopulatedCourse,
	syllabus: CourseSyllabus | null,
	id: BookId,
	chapterFiles: Record<string, ChapterSpec> = {},
	photos: Record<string, Omit<Photo, 'id'>> = {},
	/** The units' paper wording, by level then quiz id (assets/content/book/<course>/<level>.json). */
	paper: Record<string, PaperOverrides> = {}
): Book | null {
	const parts: BookPart[] = [];
	const photo = (pid?: string): Photo | undefined => (pid && photos[pid] ? { id: pid, ...photos[pid] } : undefined);
	bookLevels(id).forEach((level, i) => {
		const workbook = buildWorkbook(course, level, paper[level] ?? {});
		if (!workbook) return;
		const mod = syllabus?.modules.find((m) => m.level === level);
		const spec = chapterFiles[level];
		const chapters = spec ? chaptersFor(spec, workbook, photo) : [];
		parts.push({
			photo: photo(spec?.photo),
			caption: spec?.caption,
			de: spec?.de,
			en: spec?.en,
			chapters,
			n: (i + 1) as 1 | 2,
			level,
			title: workbook.title,
			subtitle: mod?.subtitle,
			canDo: mod?.canDo ?? [],
			themes: mod?.themes ?? [],
			workbook,
			challenge: challengeFor(course.quizzes, level, workbook.units),
			round: roundFor(id, i)
		});
	});
	if (!parts.length) return null;

	return {
		id,
		courseId: course.id,
		courseName: course.name,
		title: `Deutsch ${id}`,
		subtitle: parts.map((p) => p.title).join(' · '),
		cover: parts[0].workbook.cover,
		version: course.version,
		parts,
		credits: parts.flatMap((p) => [p.photo, ...p.chapters.map((c) => c.photo)]).filter((x): x is Photo => !!x),
		key: keyFor(parts),
		appendix: appendixFor(parts),
		index: indexFor(parts),
		audio: parts.flatMap((p) =>
			p.workbook.units
				.filter((u) => u.audio.length)
				.map((u) => ({ part: p.n, unit: u.n, title: u.title, quizId: u.quizId, clips: u.audio.length }))
		)
	};
}

/**
 * The part's units grouped into the chapter file's themes, renumbered in
 * that order so "1.7" is the seventh unit a reader meets. Units the file does
 * not name go into a last chapter, so nothing is lost.
 */
function chaptersFor(spec: ChapterSpec, workbook: Workbook, photo: (id?: string) => Photo | undefined): BookChapter[] {
	const byId = new Map(workbook.units.map((u) => [u.quizId, u]));
	const used = new Set<string>();
	const out: BookChapter[] = [];
	let n = 1;
	for (const c of spec.chapters) {
		const units = c.units.map((id) => byId.get(id)).filter((u): u is WorkbookUnit => !!u && !used.has(u.quizId));
		units.forEach((u) => used.add(u.quizId));
		out.push({ n: out.length + 1, id: c.id, title: c.title, subtitle: c.subtitle, photo: photo(c.photo), caption: c.caption, de: c.de, en: c.en, units });
	}
	const rest = workbook.units.filter((u) => !used.has(u.quizId));
	if (rest.length) out.push({ n: out.length + 1, id: 'more', title: 'Mehr', subtitle: 'More practice', de: '', en: '', units: rest });
	for (const c of out) for (const u of c.units) u.n = n++;
	workbook.units = out.flatMap((c) => c.units);
	return out;
}

/**
 * The challenge page: the part's hard sentences (the medal ladder's "no
 * help" pool), a seeded twenty, each tagged with the unit it belongs to.
 */
function challengeFor(quizzes: Quiz[], level: string, units: WorkbookUnit[]): ChallengeItem[] {
	const unitOf = new Map(units.map((u) => [u.quizId, u.n]));
	const pool: Omit<ChallengeItem, 'n'>[] = [];
	for (const quiz of quizzes) {
		if (quiz.level !== level || quiz.type !== 'fillBlank' || !unitOf.has(quiz.id)) continue;
		for (const s of quiz.sentences ?? []) {
			if (!s.hard) continue;
			const answer = s.acceptedAnswers?.[0];
			if (!answer) continue;
			pool.push({ sentence: s.sentence, english: s.english, answer, unit: unitOf.get(quiz.id)! });
		}
	}
	return seededShuffle(pool, `${level}:challenge`)
		.slice(0, CHALLENGE_ITEMS)
		.sort((a, b) => a.unit - b.unit)
		.map((item, i) => ({ n: i + 1, ...item }));
}

/** One Ja oder Nein? round per part, chosen by position so the books don't repeat one. */
function roundFor(id: BookId, part: number): JaNeinRound | undefined {
	const at = BOOKS.indexOf(id) * 2 + part;
	return ROUND_ORDER[at % ROUND_ORDER.length];
}

function keyFor(parts: BookPart[]): KeyEntry[] {
	return parts.flatMap((p) =>
		p.workbook.units
			.filter((u) => u.key)
			.map((u) => ({ part: p.n, unit: u.n, title: u.title, label: u.key!.label, lines: u.key!.lines }))
	);
}

function appendixFor(parts: BookPart[]): AppendixTable[] {
	return parts.flatMap((p) =>
		p.workbook.units
			.filter((u) => u.table)
			.map((u) => ({ part: p.n, unit: u.n, title: u.title, table: u.table! }))
	);
}

/** Every word the book teaches, A–Z, with where it first appears. */
function indexFor(parts: BookPart[]): IndexEntry[] {
	const seen = new Map<string, IndexEntry>();
	for (const p of parts) {
		for (const u of p.workbook.units) {
			const where = `${p.n}.${u.n}`;
			const add = (de: string, en: string, article?: string, plural?: string) => {
				const key = `${article ?? ''}|${de}`;
				if (!seen.has(key)) seen.set(key, { de, en, article, plural: plural && plural !== '—' ? plural : undefined, where });
			};
			for (const w of u.words) add(w.de, w.en, w.article, w.plural);
			if (u.extra?.kind === 'deck') for (const g of u.extra.groups) for (const c of g.cards) add(c.de, c.en ?? '', c.article, c.plural);
			if (u.extra?.kind === 'hunt') for (const s of u.extra.spots) add(s.de, s.en ?? '', s.article);
		}
	}
	return [...seen.values()].sort((a, b) => a.de.localeCompare(b.de, 'de', { sensitivity: 'base' }));
}

/** The syllabus module for a level, for pages that need only the can-do list. */
export function moduleFor(syllabus: CourseSyllabus | null, level: string): SyllabusModule | undefined {
	return syllabus?.modules.find((m) => m.level === level);
}
