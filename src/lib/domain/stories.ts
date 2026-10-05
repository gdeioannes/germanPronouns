// Story episodes as deck citizens: each episode is a playable mystery
// (src/routes/story/) that the swipe deck deals like an exercise card. The
// registry is tiny on purpose — an episode's content lives in its JSON; this
// is only what the deck and lists need to deal and link it.

import type { QuizSummary } from '$lib/content/types';
import type { DeckCard } from './deck';

export interface StoryEpisode {
	id: string;
	courseId: string;
	/** The sub-level whose learners get the card (the episode's material). */
	level: string;
	title: string;
	tagline: string;
	href: string;
	/** static/img key, like a quiz scene. */
	image: string;
	/**
	 * Where the episode sits in its sub-level: after this quiz (its material
	 * comes first). Absent = at the start of the level. The deck holds the
	 * episode back until the learner reached that point; the course page lists
	 * it there.
	 */
	after?: string;
}

/** In play order: within a sub-level the deck deals the earliest unfinished. */
export const STORY_EPISODES: StoryEpisode[] = [
	{
		id: 'ep0_lost_in_berlin',
		courseId: 'de_cert_a1',
		level: 'A1.1',
		title: 'Lost in Berlin',
		tagline: 'Day one, zero German, a dead phone. Get Maya to her new flat.',
		href: '/story/ep0-lost-in-berlin',
		image: 'story/ep0_arrivals'
	},
	{
		id: 'ep1_empty_room',
		courseId: 'de_cert_a1',
		level: 'A1.1',
		title: 'The Empty Room',
		tagline: "Maya's flatmate vanished overnight. Help her find him.",
		href: '/story/ep1-empty-room',
		image: 'story/ep1_room_wide',
		// Its material is A1.1's first half: numbers 0–20 … the Steckbrief.
		after: 'quest_a1_1_diktat_steckbrief'
	}
];

const ID_PREFIX = 'story:';

/**
 * Reached = the quiz itself is done, or as many quizzes of its level are done
 * as come before it — learners skip around, and that still counts.
 */
export function reachedQuiz(
	quizzes: { id: string; level?: string }[],
	done: (id: string) => boolean,
	quizId: string
): boolean {
	if (done(quizId)) return true;
	const target = quizzes.find((q) => q.id === quizId);
	if (!target) return true;
	const atLevel = quizzes.filter((q) => q.level === target.level);
	const before = atLevel.findIndex((q) => q.id === quizId);
	return atLevel.filter((q) => done(q.id)).length >= before + 1;
}

/** The player's own completion flag (the player persists under story_<id>). */
export function storyFinished(id: string): boolean {
	try {
		return JSON.parse(localStorage.getItem(`story_${id}`) ?? '{}').finished === true;
	} catch {
		return false;
	}
}

export function isStoryCard(card: DeckCard): boolean {
	return card.quiz.id.startsWith(ID_PREFIX);
}

export function storyCardHref(card: DeckCard): string | null {
	const episode = STORY_EPISODES.find((e) => `${ID_PREFIX}${e.id}` === card.quiz.id);
	return episode?.href ?? null;
}

/**
 * The story card to shuffle into a dealt deck, or null: the course's next
 * episode for the deck's sub-level — the first in registry order that the
 * learner hasn't finished or skipped. One per deal — stories are a treat,
 * not a quota.
 */
export function storyDeckCard(
	courseId: string,
	level: string | null,
	skipped: Set<string>,
	/** Whether the learner reached an episode's `after` quiz. */
	reached: (quizId: string) => boolean = () => true
): DeckCard | null {
	const episode = STORY_EPISODES.find(
		(e) =>
			e.courseId === courseId &&
			e.level === level &&
			(!e.after || reached(e.after)) &&
			!skipped.has(`${ID_PREFIX}${e.id}`) &&
			!storyFinished(e.id)
	);
	if (!episode) return null;
	const id = `${ID_PREFIX}${episode.id}`;
	const quiz: QuizSummary = {
		id,
		type: 'reading',
		title: episode.title,
		storageKeyPrefix: 'story',
		level: episode.level,
		status: 'live',
		covers: [],
		image: episode.image
	};
	return { kind: 'story', quiz, reason: episode.tagline };
}
