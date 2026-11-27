// Where an exercise is in the printed book: the chapter whose pages list it
// (chapter.appQuizzes, the same lists the book's page codes open). Read at
// build time, so pages carry only the few fields they show.
import { loadBook2 } from '$lib/domain/book2';
import { PART_IDS, type PartId } from '$lib/domain/bookStudy';

export interface BookPlace {
	level: string;
	bookTitle: string;
	chapter: { id: string; n: number; title: string };
	/** The chapter's pages that have an exercise list, and whether this exercise is on each. */
	parts: { id: PartId; here: boolean; /** Where this exercise is in that page's list (its entry names the block on the page it practises). */ at: number }[];
}

/** A page that teaches (words, reading, grammar, everyday) wins over the practice pages, which repeat exercises from other chapters. */
const TEACHING = PART_IDS.filter((p) => !p.startsWith('uebungen'));

export function bookPlaceOf(courseId: string, quiz: { id: string; level?: string | null }): BookPlace | null {
	const book = quiz.level ? loadBook2(courseId, quiz.level) : null;
	if (!book) return null;
	type Chapter = (typeof book.chapters)[number];
	const placeOn = (c: Chapter, part: PartId) => c.appQuizzes?.[part]?.findIndex((p) => p.quiz === quiz.id) ?? -1;
	const onPart = (c: Chapter, part: PartId) => placeOn(c, part) >= 0;
	const home =
		book.chapters.find((c) => TEACHING.some((p) => onPart(c, p))) ?? book.chapters.find((c) => PART_IDS.some((p) => onPart(c, p)));
	if (!home) return null;
	return {
		level: book.level,
		bookTitle: book.title,
		chapter: { id: home.id, n: home.n, title: home.title },
		parts: PART_IDS.filter((p) => home.appQuizzes?.[p]?.length).map((p) => ({ id: p, here: onPart(home, p), at: placeOn(home, p) }))
	};
}

/** For the deck: each exercise's chapter, by exercise id (only the ones in a book). */
export function bookChapters(courseId: string, quizzes: { id: string; level?: string | null }[]): Record<string, { n: number; title: string }> {
	const out: Record<string, { n: number; title: string }> = {};
	for (const q of quizzes) {
		const place = bookPlaceOf(courseId, q);
		if (place) out[q.id] = { n: place.chapter.n, title: place.chapter.title };
	}
	return out;
}
