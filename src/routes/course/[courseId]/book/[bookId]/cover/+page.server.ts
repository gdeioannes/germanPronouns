import { error } from '@sveltejs/kit';
import { readFileSync } from 'node:fs';
import { courses, loadCourse, loadSyllabus } from '$lib/content';
import { BOOKS, buildBook, ISBN, type BookId } from '$lib/domain/book';
import { ean13Svg } from '$lib/domain/ean13';
import type { EntryGenerator, PageServerLoad } from './$types';

// The wrap-around cover (back · spine · front) for print on demand. Its size
// comes from the interior's page count, which tool/gen-books.mjs records in
// static/books/manifest.json; before a first print it guesses 220 pages.

export const entries: EntryGenerator = () => courses.flatMap((c) => BOOKS.map((bookId) => ({ courseId: c.id, bookId })));

export const load: PageServerLoad = async ({ params }) => {
	if (!BOOKS.includes(params.bookId as BookId)) error(404, 'No such book');
	const course = await loadCourse(params.courseId);
	const book = buildBook(course, await loadSyllabus(params.courseId), params.bookId as BookId);
	if (!book) error(404, 'No such book');

	let pages = 220;
	try {
		const manifest = JSON.parse(readFileSync('static/books/manifest.json', 'utf8'));
		pages = manifest[`${course.id}_${book.id.toLowerCase()}.pdf`]?.pages ?? pages;
	} catch {
		// no print yet
	}
	const bleed = 3.175;
	const spine = +(pages * 0.0025 * 25.4).toFixed(2);
	return {
		book: { id: book.id, title: book.title, subtitle: book.subtitle, cover: book.cover, courseName: book.courseName, parts: book.parts.map((p) => ({ level: p.level, title: p.title, canDo: p.canDo })) },
		pages,
		spine,
		bleed,
		width: +(215.9 * 2 + spine + bleed * 2).toFixed(2),
		height: +(279.4 + bleed * 2).toFixed(2),
		isbn: ISBN[book.id],
		barcode: ean13Svg(ISBN[book.id])
	};
};
