// What the course home knows about each exercise: finished or not, its medal,
// and how its answers have gone. Loaded once per visit and shared by the
// swipe deck (to deal from) and the progress panel (to report on).
import type { QuizSummary } from '$lib/content/types';
import type { QuizFacts } from '$lib/domain/recommend';
import { progress } from './progress.svelte';

/** Reads every quiz's facts. Progress and stats must already be loaded. */
export async function loadQuizFacts(quizzes: QuizSummary[]): Promise<Record<string, QuizFacts>> {
	const out: Record<string, QuizFacts> = {};
	for (const quiz of quizzes) {
		const history = await progress.historyFor(quiz.storageKeyPrefix);
		out[quiz.id] = {
			done: progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix),
			tier: progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix),
			mark: progress.markFor(quiz.type, quiz.id, quiz.storageKeyPrefix),
			answered: history.answered,
			mistakeRate: history.mistakeRate,
			recentMistakeRate: history.recentMistakeRate,
			lastPlayedAt: history.lastPlayedAt
		};
	}
	return out;
}
