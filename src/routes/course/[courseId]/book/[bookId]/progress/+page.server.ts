import { error } from '@sveltejs/kit';
import { courses, loadCourse, loadSyllabus } from '$lib/content';
import { BOOKS, buildBook, type BookId } from '$lib/domain/book';
import { bookFilesOf } from '$lib/server/book-files';
import type { EntryGenerator, PageServerLoad } from './$types';

// "My book": the printed book's contents as a checklist, so a learner can tell
// the app what they did on paper. Prerendered from the same builder as the
// book, so the numbering always matches the printed contents page.

export const entries: EntryGenerator = () => courses.flatMap((c) => BOOKS.map((bookId) => ({ courseId: c.id, bookId })));

export interface BookUnitRow {
	n: string;
	quizId: string;
	type: string;
	title: string;
	kind: string;
	storageKeyPrefix: string;
}

export const load: PageServerLoad = async ({ params }) => {
	if (!BOOKS.includes(params.bookId as BookId)) error(404, 'No such book');
	const course = await loadCourse(params.courseId);
	const { files, photos, paper } = bookFilesOf(params.courseId);
	const book = buildBook(course, await loadSyllabus(params.courseId), params.bookId as BookId, files, photos, paper);
	if (!book) error(404, 'No such book');
	const prefixOf = new Map(course.quizzes.map((q) => [q.id, q.storageKeyPrefix]));
	const row = (part: number, u: { n: number; quizId: string; type: string; title: string; kindLabel: string }): BookUnitRow => ({
		n: `${part}.${u.n}`,
		quizId: u.quizId,
		type: u.type === 'inlineCloze' ? 'reading' : u.type,
		title: u.title,
		kind: u.kindLabel,
		storageKeyPrefix: prefixOf.get(u.quizId) ?? ''
	});
	return {
		courseId: course.id,
		book: {
			id: book.id,
			title: book.title,
			subtitle: book.subtitle,
			parts: book.parts.map((p) => ({
				n: p.n,
				level: p.level,
				title: p.title,
				chapters: p.chapters.length
					? p.chapters.map((c) => ({ title: `Chapter ${c.n} · ${c.title}`, units: c.units.map((u) => row(p.n, u)) }))
					: [{ title: '', units: p.workbook.units.map((u) => row(p.n, u)) }]
			}))
		},
		books: BOOKS.filter((b) => course.quizzes.some((q) => q.level === `${b}.1`))
	};
};
