import { error } from '@sveltejs/kit';
import { courseInfo, courses, loadCourse, summarizeQuiz } from '$lib/content';
import { helpTableFor } from '$lib/domain/help-table';
import { vocabFor, type SharedNoun, type VocabEntry } from '$lib/domain/vocab';
import type { EntryGenerator, PageServerLoad } from './$types';

/**
 * One prerendered page per quiz: every exercise crawlable and directly
 * linkable. A server load, so the page carries exactly this one quiz and the
 * few summaries around it; the whole course bundle stays on the build machine.
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

/** How many sibling exercises the "More at this level" list shows. */
const RELATED = 6;

export const load: PageServerLoad = async ({ params }) => {
	const course = await loadCourse(params.courseId);
	const index = course.quizzes.findIndex((q) => q.id === params.quizId);
	if (index < 0) error(404, 'No such exercise');

	const quiz = course.quizzes[index];

	// Text-based exercises list the nouns they use. Looked up here, at build
	// time, so the list is in the prerendered page, and only this quiz's few
	// entries are serialised, not the whole 759-noun collection.
	let vocab: VocabEntry[] | undefined;
	if (!quiz.help?.vocab?.length && !helpTableFor(quiz)) {
		const nouns = (await import('$content/shared/nouns/de.json')).default.nouns as SharedNoun[];
		vocab = vocabFor(quiz, nouns);
	}

	const levelQuizzes = course.quizzes.filter((q) => q.level === quiz.level);
	const position = levelQuizzes.findIndex((q) => q.id === quiz.id);

	// The nearest neighbours in the same level, kept in ladder order, so the
	// page links sideways as well as forward and back.
	const distance = (q: (typeof levelQuizzes)[number]) =>
		Math.abs(levelQuizzes.indexOf(q) - position);
	const related = levelQuizzes
		.filter((q) => q.id !== quiz.id)
		.sort((a, b) => distance(a) - distance(b))
		.slice(0, RELATED)
		.sort((a, b) => levelQuizzes.indexOf(a) - levelQuizzes.indexOf(b))
		.map(summarizeQuiz);

	const previous = course.quizzes[index - 1];
	// The chain is ordered, so "next" is simply the following entry.
	const next = course.quizzes[index + 1];

	return {
		course: courseInfo(course),
		quiz,
		vocab,
		previous: previous ? summarizeQuiz(previous) : null,
		next: next ? summarizeQuiz(next) : null,
		related,
		// Where this exercise sits in its level, for the breadcrumb line.
		position: position + 1,
		levelCount: levelQuizzes.length,
		levelTitle:
			course.nav.groups.find((g) => g.type === 'questChain' && g.level === quiz.level)?.title ??
			null
	};
};
