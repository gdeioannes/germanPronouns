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
}

export const STORY_EPISODES: StoryEpisode[] = [
	{
		id: 'ep1_empty_room',
		courseId: 'de_cert_a1',
		level: 'A1.1',
		title: 'The Empty Room',
		tagline: "Maya's flatmate vanished overnight. Help her find him.",
		href: '/story/ep1-empty-room',
		image: 'story/ep1_room_wide'
	}
];

const ID_PREFIX = 'story:';

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
 * The story card to shuffle into a dealt deck, or null: the course's episode
 * for the deck's sub-level, unless the learner finished or skipped it. One
 * per deal — stories are a treat, not a quota.
 */
export function storyDeckCard(
	courseId: string,
	level: string | null,
	skipped: Set<string>
): DeckCard | null {
	const episode = STORY_EPISODES.find((e) => e.courseId === courseId && e.level === level);
	if (!episode) return null;
	const id = `${ID_PREFIX}${episode.id}`;
	if (skipped.has(id) || storyFinished(episode.id)) return null;
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
