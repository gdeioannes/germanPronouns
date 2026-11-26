import { error } from '@sveltejs/kit';
import { catalog } from '$lib/content';
import { BOOKS, bookSlug } from '$lib/content/books';
import { loadBook2 } from '$lib/domain/book2';
import type { EntryGenerator, PageServerLoad } from './$types';

// One page per book (/books/a1-1 … /books/c2-2): what a search or an AI answer
// for "free German A1 textbook PDF" should land on. The page prints the
// book's own table of contents, so only that summary is sent, not the book.
//
// `cover` and each chapter keep the field names the book file has ("cover.lede",
// "subtitle", "canDo[0]"): the second languages' overlays translate by path
// (i18n/content.svelte.ts), and so translate this summary as they do the book.
export const entries: EntryGenerator = () => BOOKS.map((b) => ({ book: bookSlug(b) }));

export const load: PageServerLoad = ({ params }) => {
	const i = BOOKS.findIndex((b) => bookSlug(b) === params.book);
	if (i < 0) error(404, 'No such book');
	const entry = BOOKS[i];
	const book = loadBook2(catalog.defaultCourseId, entry.level);
	if (!book) error(404, 'No such book');
	return {
		slug: params.book,
		// The layout and <Seo> read this as the page's level (i18n/pageLevel.ts).
		bookLevel: entry.level,
		// A1.1 has no cover wording in its file: the page uses the printed default.
		cover: { badge: book.cover?.badge ?? null, lede: book.cover?.lede ?? null, real: book.cover?.real ?? null },
		words: book.chapters.reduce((n, c) => n + c.words.groups.reduce((m, g) => m + g.items.length, 0), 0),
		extras: book.extras?.length ?? 0,
		chapters: book.chapters.map((c) => ({
			id: c.id,
			n: c.n,
			title: c.title,
			subtitle: c.subtitle,
			world: c.world,
			photo: c.opener.photo,
			grammar: c.grammar.map((g) => g.heading),
			story: c.reading.title,
			canDo: c.canDo
		})),
		prev: i > 0 ? { slug: bookSlug(BOOKS[i - 1]), level: BOOKS[i - 1].level, sub: BOOKS[i - 1].sub } : null,
		next: i < BOOKS.length - 1 ? { slug: bookSlug(BOOKS[i + 1]), level: BOOKS[i + 1].level, sub: BOOKS[i + 1].sub } : null
	};
};
