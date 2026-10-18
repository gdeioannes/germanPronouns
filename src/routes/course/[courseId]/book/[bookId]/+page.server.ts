import { error } from '@sveltejs/kit';
import registry from '$content/booklinks.json';
import { courses, loadCourse, loadSyllabus } from '$lib/content';
import { BOOKS, buildBook, ISBN, type BookId } from '$lib/domain/book';
import { codeUrl, register, type BookLinkRegistry } from '$lib/domain/booklinks';
import { clipFor } from '$lib/server/audio-clips';
import { bookFilesOf } from '$lib/server/book-files';
import { qrSvg } from '$lib/server/qr';
import { readFileSync } from 'node:fs';
import type { EntryGenerator, PageServerLoad } from './$types';

// The printed book, one page per level: tool/gen-books.mjs prints this route.
// Prerendered like the workbooks, so the free PDF and the KDP file are the
// same page; the tool only changes the paper (margins, bleed, picture size).

export const entries: EntryGenerator = () => courses.flatMap((c) => BOOKS.map((bookId) => ({ courseId: c.id, bookId })));

const links = registry as unknown as BookLinkRegistry;

export interface QrCode {
	svg: string;
	code: string;
	label: string;
}

export const load: PageServerLoad = async ({ params }) => {
	if (!BOOKS.includes(params.bookId as BookId)) error(404, 'No such book');
	const course = await loadCourse(params.courseId);
	const syllabus = await loadSyllabus(params.courseId);
	const { files, photos, paper } = bookFilesOf(params.courseId);
	const book = buildBook(course, syllabus, params.bookId as BookId, files, photos, paper);
	if (!book) error(404, 'No such book');

	// The codes: minted in a fixed order (book, then every unit in page order),
	// so a run of the tool and a prerender agree on them. The tool writes the
	// registry back; the page only reads it.
	const qr = async (kind: Parameters<typeof register>[1], target: string, label: string, note: string): Promise<QrCode> => {
		const code = register(links, kind, target, book.id, note);
		return { svg: await qrSvg(codeUrl(code)), code, label };
	};
	const bookQr = await qr('book', book.id, 'This book online', `Book ${book.id}`);
	const unitQr: Record<string, QrCode[]> = {};
	for (const part of book.parts) {
		for (const unit of part.workbook.units) {
			const codes: QrCode[] = [await qr('quiz', unit.quizId, 'Do it in the app', `${book.id} ${part.n}.${unit.n} ${unit.title}`)];
			if (unit.audio.length && unit.audio.some((t) => clipFor(t)))
				codes.push(await qr('audio', unit.quizId, 'Listen', `${book.id} ${part.n}.${unit.n} audio`));
			unitQr[unit.quizId] = codes;
		}
	}

	// The running head's mark, inline: Chrome's margin boxes take a data URL but not always a path.
	const mark = `data:image/png;base64,${readFileSync('static/book-mark.png').toString('base64')}`;
	return { book, bookQr, unitQr, siteHost: 'languagequiz.org', isbn: ISBN[book.id], mark };
};
