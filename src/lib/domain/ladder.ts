// The CEFR ladder: the sub-levels, and how far through each one the learner is.
//
// Every sub-level is open. The Flutter build gated them — a sub-level opened
// only once every quiz in every earlier one was complete — but with twenty
// exercises to a sub-level that asked a beginner to finish all of A1.1 before
// seeing a single A1.2 sentence, and someone who already speaks some German had
// to grind past what they knew. Completion is still tracked and still shown, as
// ribbons and the progress ring; it just no longer stands in anyone's way.

import type { NavGroup, PopulatedCourse, Quiz } from '$lib/content/types';

export interface LadderLevel {
	id: string;
	title: string;
	level: string;
	quizzes: Quiz[];
	/** Every quiz in it is finished. */
	complete: boolean;
	doneCount: number;
}

export interface IsDone {
	(quiz: Quiz): boolean;
}

/** Groups a course's quizzes into its ordered quest-chain sub-levels. */
export function levelGroups(course: PopulatedCourse): { group: NavGroup; quizzes: Quiz[] }[] {
	return course.nav.groups
		.filter((group) => group.type === 'questChain')
		.map((group) => ({
			group,
			quizzes: course.quizzes.filter((quiz) => quiz.level === group.level)
		}));
}

/** The ladder, with each sub-level's completion counted. */
export function buildLadder(course: PopulatedCourse, isDone: IsDone): LadderLevel[] {
	return levelGroups(course).map(({ group, quizzes }) => {
		const doneCount = quizzes.filter(isDone).length;
		return {
			id: group.id,
			title: group.title,
			level: group.level ?? '',
			quizzes,
			complete: quizzes.length > 0 && doneCount === quizzes.length,
			doneCount
		};
	});
}

/** The sub-level the learner should be sent to — the first unfinished one. */
export function currentLevel(ladder: LadderLevel[]): LadderLevel | undefined {
	return ladder.find((level) => !level.complete) ?? ladder.at(-1);
}

/** The next quiz to do, or undefined when the course is finished. */
export function nextQuiz(ladder: LadderLevel[], isDone: IsDone): Quiz | undefined {
	for (const level of ladder) {
		const next = level.quizzes.find((quiz) => !isDone(quiz));
		if (next) return next;
	}
	return undefined;
}

/** Overall completion, for the course-home progress ring. */
export function courseProgress(ladder: LadderLevel[]): { done: number; total: number } {
	let done = 0;
	let total = 0;
	for (const level of ladder) {
		done += level.doneCount;
		total += level.quizzes.length;
	}
	return { done, total };
}
