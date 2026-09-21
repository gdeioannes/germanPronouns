// The gated CEFR ladder: which sub-levels are open, and where the learner is.
//
// Ported from lib/data/course_progress.dart. The rule: a quest chain sub-level
// opens only once every quiz in every preceding sub-level is complete — the
// chain is globally continuous, so progress can't be skipped. A placement can
// open levels directly without marking anything complete, which is why the
// unlocked check consults the placement set too.

import type { NavGroup, PopulatedCourse, Quiz } from '$lib/content/types';

export interface LadderLevel {
	id: string;
	title: string;
	level: string;
	quizzes: Quiz[];
	/** Open to the learner — either earned or opened by a placement. */
	unlocked: boolean;
	/** Every quiz in it is finished. */
	complete: boolean;
	doneCount: number;
}

export interface IsDone {
	(quiz: Quiz): boolean;
}

export interface IsPlaced {
	(quizId: string): boolean;
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

/**
 * The ladder with its locks resolved. The first sub-level is always open;
 * each later one opens when every earlier quiz is done, or when a placement
 * opened it.
 */
export function buildLadder(
	course: PopulatedCourse,
	isDone: IsDone,
	isPlaced: IsPlaced = () => false
): LadderLevel[] {
	const groups = levelGroups(course);
	const ladder: LadderLevel[] = [];
	let everythingBeforeIsDone = true;

	for (const { group, quizzes } of groups) {
		const doneCount = quizzes.filter(isDone).length;
		const complete = quizzes.length > 0 && doneCount === quizzes.length;
		const placed = quizzes.some((quiz) => isPlaced(quiz.id));

		ladder.push({
			id: group.id,
			title: group.title,
			level: group.level ?? '',
			quizzes,
			unlocked: everythingBeforeIsDone || placed,
			complete,
			doneCount
		});

		everythingBeforeIsDone = everythingBeforeIsDone && complete;
	}

	return ladder;
}

/** The sub-level the learner should be sent to — the first unfinished open one. */
export function currentLevel(ladder: LadderLevel[]): LadderLevel | undefined {
	return ladder.find((level) => level.unlocked && !level.complete) ?? ladder.at(-1);
}

/** The next quiz to do, or undefined when the course is finished. */
export function nextQuiz(ladder: LadderLevel[], isDone: IsDone): Quiz | undefined {
	for (const level of ladder) {
		if (!level.unlocked) break;
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
