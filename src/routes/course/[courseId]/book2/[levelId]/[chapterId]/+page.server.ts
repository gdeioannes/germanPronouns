import { error } from '@sveltejs/kit';
import { courses, loadCourse } from '$lib/content';
import { loadBook2 } from '$lib/domain/book2';
import type { EntryGenerator, PageServerLoad } from './$types';

// One chapter of a Book v2 in the app: what the page codes in the printed
// book open (domain/bookStudy). Prerendered, one page per chapter.
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; levelId: string; chapterId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const level of new Set(course.quizzes.map((q) => q.level ?? ''))) {
			const book = level ? loadBook2(card.id, level) : null;
			for (const c of book?.chapters ?? []) all.push({ courseId: card.id, levelId: level, chapterId: c.id });
		}
	}
	return all;
};

export const load: PageServerLoad = async ({ params }) => {
	const book = loadBook2(params.courseId, params.levelId);
	const chapter = book?.chapters.find((c) => c.id === params.chapterId);
	if (!book || !chapter) error(404, 'No such chapter');
	const i = book.chapters.indexOf(chapter);
	const course = await loadCourse(params.courseId);
	const title = (id?: string) => (id ? (course.quizzes.find((q) => q.id === id)?.title ?? null) : null);
	return {
		courseId: params.courseId,
		level: book.level,
		bookTitle: book.title,
		bookSubtitle: book.subtitle,
		chapter,
		count: book.chapters.length,
		prev: book.chapters[i - 1] ? { id: book.chapters[i - 1].id, title: book.chapters[i - 1].title } : null,
		next: book.chapters[i + 1] ? { id: book.chapters[i + 1].id, title: book.chapters[i + 1].title } : null,
		more: {
			quiz: chapter.quiz ? { id: chapter.quiz, title: title(chapter.quiz) } : null,
			listen: chapter.listenQuiz ? { id: chapter.listenQuiz, title: title(chapter.listenQuiz) } : null,
			speak: chapter.speakQuiz ? { id: chapter.speakQuiz, title: title(chapter.speakQuiz) } : null
		}
	};
};
