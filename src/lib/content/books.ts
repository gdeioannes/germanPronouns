// The twelve books (Book v2): one free PDF per sub-level, A1.1 to C2.2. The
// home page shows A1.1 big and the rest as a shelf; /books lists them all.
// `mb` is the PDF's size on disk, rounded; update it when a book is reprinted
// (`node tool/gen-book2.mjs <Level> --web`). `local` holds the second-language
// editions (A1–A2) by language, each its PDF's size:
// `node tool/gen-book2.mjs <Level> --web --lang <tr|ar|uk|fr|es>`, cover via tool/turkish/covers.mjs.

import type { UiLang, LocalLang } from '$lib/i18n/lang.svelte';
import { levelTranslated } from '$lib/i18n/available';

export interface BookEntry {
	/** The level as printed on the cover, e.g. "B1.1". */
	level: string;
	/** The PDF's file stem under static/books/v2/de_cert_a1_<file>.pdf. */
	file: string;
	/** The cover image stem: /img/book-<cover>-front.webp. */
	cover: string;
	/** The German subtitle on the cover. */
	sub: string;
	/** PDF size in megabytes. */
	mb: number;
	/** Second-language editions' sizes in megabytes, once printed (…_<file>_<lang>.pdf). */
	local?: Partial<Record<LocalLang, number>>;
}

export const BOOKS: BookEntry[] = [
	{ level: 'A1.1', file: 'a1_1', cover: 'a1-1', sub: 'Erste Schritte', mb: 39, local: { tr: 40, ar: 42, uk: 41, fr: 40, es: 40 } },
	{ level: 'A1.2', file: 'a1_2', cover: 'a1-2', sub: 'Im Alltag', mb: 37, local: { tr: 37, ar: 39, uk: 38, fr: 37, es: 37 } },
	{ level: 'A2.1', file: 'a2_1', cover: 'a2-1', sub: 'Erlebnisse', mb: 33, local: { tr: 33, ar: 36, uk: 34, fr: 33, es: 33 } },
	{ level: 'A2.2', file: 'a2_2', cover: 'a2-2', sub: 'Beschreiben & Planen', mb: 35, local: { tr: 35, ar: 38, uk: 36, fr: 36, es: 35 } },
	{ level: 'B1.1', file: 'b1_1', cover: 'b1-1', sub: 'Meinungen & Wünsche', mb: 32 },
	{ level: 'B1.2', file: 'b1_2', cover: 'b1-2', sub: 'Erzählen & Begründen', mb: 33 },
	{ level: 'B2.1', file: 'b2_1', cover: 'b2-1', sub: 'Berichten & Argumentieren', mb: 30 },
	{ level: 'B2.2', file: 'b2_2', cover: 'b2-2', sub: 'Was wäre, wenn?', mb: 34 },
	{ level: 'C1.1', file: 'c1_1', cover: 'c1-1', sub: 'Verdichten & Verbinden', mb: 31 },
	{ level: 'C1.2', file: 'c1_2', cover: 'c1-2', sub: 'Andeuten & Formulieren', mb: 31 },
	{ level: 'C2.1', file: 'c2_1', cover: 'c2-1', sub: 'Stil & Register', mb: 27 },
	{ level: 'C2.2', file: 'c2_2', cover: 'c2-2', sub: 'Zwischen den Zeilen', mb: 27 }
];

/** Every book is the same length. */
export const BOOK_PAGES = 131;

/** The edition in `l`, when it is printed; else null (English). */
const edition = (book: BookEntry, l: UiLang): LocalLang | null =>
	l !== 'en' && book.local?.[l] !== undefined ? l : null;
/** The PDF in `l` (English when that edition is not printed). */
export const bookPdf = (book: BookEntry, l: UiLang = 'en') => {
	const e = edition(book, l);
	return `/books/v2/de_cert_a1_${book.file}${e ? `_${e}` : ''}.pdf`;
};
/** The size of the PDF bookPdf() gives. */
export const bookMb = (book: BookEntry, l: UiLang = 'en') => {
	const e = edition(book, l);
	return e ? book.local![e]! : book.mb;
};
/** The front cover picture, of the `l` edition when printed (tool/turkish/covers.mjs). */
export const bookCover = (book: BookEntry, l: UiLang = 'en') => {
	const e = edition(book, l);
	return `/img/book-${book.cover}-front${e ? `-${e}` : ''}.webp`;
};
/** Has this book an edition in `l` to download? */
export const hasLocalPdf = (book: BookEntry, l: UiLang) => edition(book, l) !== null;
/**
 * Is there a PDF to offer in `l`? English always; a second language its own
 * edition for A1–A2, and for B1–C2 (never translated) the book as it is.
 */
export const pdfOffered = (book: BookEntry, l: UiLang) =>
	l === 'en' || hasLocalPdf(book, l) || !levelTranslated(book.level);
/** The reader; `from` tells its back link where to return (the books list). */
export const bookReadHref = (courseHref: string, book: BookEntry, from?: 'books') =>
	`${courseHref}/book2/${book.level}${from ? `?from=${from}` : ''}`;
