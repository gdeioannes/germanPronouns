import { error } from '@sveltejs/kit';
import { courses, loadCourse } from '$lib/content';
import { helpTableFor } from '$lib/domain/help-table';
import { vocabFor, type SharedNoun, type VocabEntry } from '$lib/domain/vocab';
import type { EntryGenerator, PageLoad } from './$types';

/**
 * One prerendered page per quiz. 214 static HTML files for the German course —
 * every exercise crawlable and directly linkable, which the canvas-rendered
 * Flutter build could never offer.
 */
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; quizId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const quiz of course.quizzes) {
			all.push({ courseId: card.id, quizId: quiz.id });
		}
	}
	return all;
};

export const load: PageLoad = async ({ params }) => {
	const course = await loadCourse(params.courseId);
	const index = course.quizzes.findIndex((q) => q.id === params.quizId);
	if (index < 0) error(404, 'No such exercise');

	const quiz = course.quizzes[index];

	// Text-based exercises list the nouns they use. Looked up here, at build
	// time, so the list is in the prerendered page — and only this quiz's few
	// entries are serialised, not the whole 759-noun collection.
	let vocab: VocabEntry[] | undefined;
	if (!quiz.help?.vocab?.length && !helpTableFor(quiz)) {
		const nouns = (await import('$content/shared/nouns/de.json')).default.nouns as SharedNoun[];
		vocab = vocabFor(quiz, nouns);
	}

	const levelQuizzes = course.quizzes.filter((q) => q.level === quiz.level);

	return {
		course,
		quiz,
		vocab,
		previous: course.quizzes[index - 1] ?? null,
		// Where this exercise sits in its level, for the breadcrumb line.
		position: levelQuizzes.findIndex((q) => q.id === quiz.id) + 1,
		levelCount: levelQuizzes.length,
		levelTitle:
			course.nav.groups.find((g) => g.type === 'questChain' && g.level === quiz.level)?.title ?? null,
		// The chain is ordered, so "next" is simply the following entry.
		next: course.quizzes[index + 1] ?? null
	};
};
