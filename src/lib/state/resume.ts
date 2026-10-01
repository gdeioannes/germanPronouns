// Leaving an exercise half-way should cost nothing. Two records make that so:
//
//   last opened — the exercise the learner was last in. The swipe deck puts it
//                 back on top, as a "Continue" card, until it is finished.
//   spot        — where inside a question-by-question exercise they stopped
//                 (the line, the answers so far), so opening it again carries
//                 on rather than starting over. Streak quizzes (grammar drills,
//                 flashcards) need none: their streak is already saved.
//
// Both keys contain "quiz_", so "start over" wipes them with the rest.
import { storage } from '$lib/services/storage';

const LAST_OPENED_KEY = 'quiz_last_opened';
/** A spot older than this is stale: the learner has moved on. */
const SPOT_MAX_AGE = 14 * 24 * 60 * 60 * 1000;

const spotKey = (prefix: string) => `${prefix}quiz_resume_spot`;

async function readJson(key: string): Promise<unknown> {
	try {
		const raw = await storage.get(key);
		return raw ? JSON.parse(raw) : null;
	} catch {
		return null;
	}
}

/** Notes the exercise the learner just opened. */
export function markOpened(quizId: string): void {
	void storage.set(LAST_OPENED_KEY, JSON.stringify({ id: quizId, at: Date.now() }));
}

/** The exercise the learner was last in, or null. */
export async function lastOpened(): Promise<string | null> {
	const value = await readJson(LAST_OPENED_KEY);
	const id = (value as { id?: unknown } | null)?.id;
	return typeof id === 'string' ? id : null;
}

/** Forgets the last-opened exercise (finished, or swiped away). */
export function clearOpened(quizId?: string): void {
	void (async () => {
		if (quizId && (await lastOpened()) !== quizId) return;
		await storage.remove(LAST_OPENED_KEY);
	})();
}

/** Saves where in an exercise the learner is. `T` is the quiz's own shape. */
export function saveSpot<T extends object>(prefix: string, spot: T): void {
	void storage.set(spotKey(prefix), JSON.stringify({ ...spot, at: Date.now() }));
}

/** The saved spot, or null when there is none or it has gone stale. */
export async function loadSpot<T extends object>(prefix: string): Promise<T | null> {
	const value = (await readJson(spotKey(prefix))) as (T & { at?: number }) | null;
	if (!value || typeof value !== 'object') return null;
	if (!value.at || Date.now() - value.at > SPOT_MAX_AGE) return null;
	return value;
}

export function clearSpot(prefix: string): void {
	void storage.remove(spotKey(prefix));
}

/**
 * The exercises started but not finished: a saved spot, an answer given, or
 * the one last opened — and not completed. Progress must be loaded (and the
 * streak quizzes' stats hydrated) so completion reads true.
 */
export async function inProgressIds(
	quizzes: { id: string; storageKeyPrefix: string }[],
	isDone: (quizId: string) => boolean
): Promise<Set<string>> {
	const keys = new Set(await storage.keys());
	const opened = await lastOpened();
	const out = new Set<string>();
	for (const quiz of quizzes) {
		if (isDone(quiz.id)) continue;
		const prefix = quiz.storageKeyPrefix;
		if (quiz.id === opened || keys.has(spotKey(prefix)) || keys.has(`${prefix}quiz_answer_history`)) {
			out.add(quiz.id);
		}
	}
	return out;
}
