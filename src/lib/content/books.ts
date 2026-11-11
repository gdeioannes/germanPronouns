// The twelve books (Book v2): one free PDF per sub-level, A1.1 to C2.2. The
// home page shows A1.1 big and the rest as a shelf; /books lists them all.
// `mb` is the PDF's size on disk, rounded; update it when a book is reprinted
// (`node tool/gen-book2.mjs <Level> --web`). `trMb` is the Turkish edition (A1–A2):
// `node tool/gen-book2.mjs <Level> --web --tr`, cover via tool/turkish/covers.mjs.

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
	/** The Turkish edition's size in megabytes, once it is printed (…_<file>_tr.pdf). */
	trMb?: number;
}

export const BOOKS: BookEntry[] = [
	{ level: 'A1.1', file: 'a1_1', cover: 'a1-1', sub: 'Erste Schritte', mb: 37, trMb: 36 },
	{ level: 'A1.2', file: 'a1_2', cover: 'a1-2', sub: 'Im Alltag', mb: 34, trMb: 33 },
	{ level: 'A2.1', file: 'a2_1', cover: 'a2-1', sub: 'Erlebnisse', mb: 31, trMb: 30 },
	{ level: 'A2.2', file: 'a2_2', cover: 'a2-2', sub: 'Beschreiben & Planen', mb: 34, trMb: 32 },
	{ level: 'B1.1', file: 'b1_1', cover: 'b1-1', sub: 'Meinungen & Wünsche', mb: 30 },
	{ level: 'B1.2', file: 'b1_2', cover: 'b1-2', sub: 'Erzählen & Begründen', mb: 31 },
	{ level: 'B2.1', file: 'b2_1', cover: 'b2-1', sub: 'Berichten & Argumentieren', mb: 28 },
	{ level: 'B2.2', file: 'b2_2', cover: 'b2-2', sub: 'Was wäre, wenn?', mb: 29 },
	{ level: 'C1.1', file: 'c1_1', cover: 'c1-1', sub: 'Verdichten & Verbinden', mb: 28 },
	{ level: 'C1.2', file: 'c1_2', cover: 'c1-2', sub: 'Andeuten & Formulieren', mb: 28 },
	{ level: 'C2.1', file: 'c2_1', cover: 'c2-1', sub: 'Stil & Register', mb: 25 },
	{ level: 'C2.2', file: 'c2_2', cover: 'c2-2', sub: 'Zwischen den Zeilen', mb: 24 }
];

/** Every book is the same length. */
export const BOOK_PAGES = 131;

/** The PDF; `tr` asks for the Turkish edition, which exists only where `trMb` is set. */
export const bookPdf = (book: BookEntry, tr = false) =>
	`/books/v2/de_cert_a1_${book.file}${tr && book.trMb ? '_tr' : ''}.pdf`;
/** The size of the PDF bookPdf() gives. */
export const bookMb = (book: BookEntry, tr = false) => (tr && book.trMb ? book.trMb : book.mb);
/** The front cover picture: the Turkish edition's when asked for and printed (tool/turkish/covers.mjs). */
export const bookCover = (book: BookEntry, tr = false) =>
	`/img/book-${book.cover}-front${tr && book.trMb ? '-tr' : ''}.webp`;
/** Has this book a Turkish edition to download? */
export const hasTurkishPdf = (book: BookEntry) => book.trMb !== undefined;
/** The reader; `from` tells its back link where to return (the books list). */
export const bookReadHref = (courseHref: string, book: BookEntry, from?: 'books') =>
	`${courseHref}/book2/${book.level}${from ? `?from=${from}` : ''}`;
