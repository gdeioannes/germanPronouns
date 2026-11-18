// Book or App: what a page code in the printed book opens.
//
// The first scan asks. "Book" opens the page on the web (the chapter page at
// that part), "App" opens the page's quiz list. The answer is remembered, so
// the next code opens the same side straight away, and both views carry a
// Book | App switch that changes it.
//
// The quiz list the learner opened is kept for the session: a quiz started
// from it offers the list's next quiz when it is finished, instead of the
// course's own "next".

import { storage } from '$lib/services/storage';

export type BookSide = 'book' | 'app';

export const BOOK_SIDE_KEY = 'book_open_side';
const LIST_KEY = 'book_quiz_list';

export async function getSide(): Promise<BookSide | null> {
	const v = await storage.get(BOOK_SIDE_KEY);
	return v === 'book' || v === 'app' ? v : null;
}

export async function setSide(side: BookSide): Promise<void> {
	await storage.set(BOOK_SIDE_KEY, side);
}

/** The app side of one book page: /course/<c>/book2/<level>/<chapter>/app/<part>. */
export function appListHref(courseId: string, level: string, chapter: string, part: string): string {
	return `/course/${courseId}/book2/${level}/${chapter}/app/${part}`;
}

/** The book side of one book page: the chapter page at that part. */
export function bookPageHref(courseId: string, level: string, chapter: string, part: string): string {
	return `/course/${courseId}/book2/${level}/${chapter}#${part}`;
}

export interface QuizList {
	/** "Übungen 1 · Hallo! Das bin ich" */
	label: string;
	/** Back to the list. */
	href: string;
	quizzes: { id: string; title: string }[];
}

export function saveList(list: QuizList): void {
	try {
		sessionStorage.setItem(LIST_KEY, JSON.stringify(list));
	} catch {
		// Private windows: the list simply isn't followed.
	}
}

export function loadList(): QuizList | null {
	try {
		const raw = sessionStorage.getItem(LIST_KEY);
		return raw ? (JSON.parse(raw) as QuizList) : null;
	} catch {
		return null;
	}
}

/**
 * A quiz opened from a page's list carries `?book` in its link, so the same
 * quiz opened from the deck behaves as before.
 */
export const BOOK_PARAM = 'book';

export function listQuizHref(courseId: string, quizId: string): string {
	return `/course/${courseId}/quiz/${quizId}?${BOOK_PARAM}`;
}

export interface ListPlace {
	list: QuizList;
	/** 1-based place in the list. */
	n: number;
	prev: { id: string; title: string } | null;
	next: { id: string; title: string } | null;
}

/** Where a quiz sits in the page's list: its number and its neighbours. Null when it isn't on the list. */
export function placeInList(list: QuizList | null, quizId: string): ListPlace | null {
	if (!list) return null;
	const i = list.quizzes.findIndex((q) => q.id === quizId);
	if (i < 0) return null;
	return { list, n: i + 1, prev: list.quizzes[i - 1] ?? null, next: list.quizzes[i + 1] ?? null };
}
