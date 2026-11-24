// "Practise my pinned questions": the pinned fill-in sentences, found again in
// today's content and put together as one drill. Only fill-ins can be lifted
// out of their exercise like that; any other pinned question opens its
// exercise instead.
//
// Found by key, not kept as a copy: a sentence fixed since it was pinned is
// practised in its fixed form, and one taken out of the course drops out here
// too (the pin stays on the list, marked as no longer found).

import type { FillBlankQuiz, Quiz, QuizSentence } from '$lib/content/types';
import { questionKey } from './questionHistory';
import { fillBlankPool } from './spoken';
import type { Pin } from './pins';

/** Where the practice drill keeps its scores, apart from every real exercise. */
export const PRACTICE_PREFIX = 'pinned_practice_';

/** Whether a pinned question can be practised in the drill (by its exercise's kind). */
export function practisable(pin: Pin): boolean {
	return pin.kind === 'question' && pin.quizType === 'fillBlank' && !!pin.key;
}

/** The pinned sentences still in the course, newest pin first, each once. */
export function practiceSentences(pins: readonly Pin[], quizzes: readonly Quiz[]): QuizSentence[] {
	const byId = new Map(quizzes.map((q) => [q.id, q]));
	const pools = new Map<string, QuizSentence[]>();
	const out: QuizSentence[] = [];
	const seen = new Set<string>();
	for (const pin of pins) {
		if (!practisable(pin) || seen.has(pin.key!)) continue;
		const quiz = byId.get(pin.quizId);
		if (quiz?.type !== 'fillBlank' || quiz.game) continue;
		if (!pools.has(quiz.id)) pools.set(quiz.id, fillBlankPool(quiz));
		const sentence = pools.get(quiz.id)!.find((s) => questionKey(s.sentence) === pin.key);
		if (!sentence) continue;
		seen.add(pin.key!);
		out.push(sentence);
	}
	return out;
}

/** The drill itself: an exercise of its own, built from the found sentences. */
export function practiceQuiz(sentences: QuizSentence[], title: string): FillBlankQuiz {
	return {
		id: 'pinned-practice',
		type: 'fillBlank',
		title,
		storageKeyPrefix: PRACTICE_PREFIX,
		subjects: [],
		categories: [],
		sentences
	};
}

/** Right the last three times in the drill: the pin may have done its job. */
export function learnt(verdicts: readonly { c: boolean }[]): boolean {
	return verdicts.length >= 3 && verdicts.slice(-3).every((v) => v.c);
}
