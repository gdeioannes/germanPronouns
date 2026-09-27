// Per-word progress for the flashcard decks: how often each word was seen and
// missed, so the deck can serve the learner's weak words back to them. One
// JSON record per course, keyed by the word's full form ("die Stelle").
//
// Kept apart from the quiz progress store: that one tracks quizzes, this one
// tracks words, and a word's history outlives any single deck run.

import { storage } from '$lib/services/storage';
import {
	EMPTY_WORD,
	isWeak,
	recordOutcome,
	wordKey,
	type WordRecord
} from '$lib/domain/flashcards';
import type { VocabCard } from '$lib/content/types';

const KEY_PREFIX = 'vocab_words_';

class VocabStore {
	private records = $state<Record<string, Record<string, WordRecord>>>({});
	private loaded = new Set<string>();

	private key(courseId: string): string {
		return `${KEY_PREFIX}${courseId}`;
	}

	/** Loads a course's word records once; later calls are free. */
	async load(courseId: string): Promise<void> {
		if (this.loaded.has(courseId)) return;
		this.loaded.add(courseId);
		const raw = await storage.get(this.key(courseId));
		let parsed: Record<string, WordRecord> = {};
		if (raw) {
			try {
				const value = JSON.parse(raw);
				if (value && typeof value === 'object' && !Array.isArray(value)) parsed = value;
			} catch {
				// A corrupt record is not worth failing the deck over.
			}
		}
		this.records = { ...this.records, [courseId]: parsed };
	}

	recordFor(courseId: string, card: VocabCard): WordRecord {
		return this.records[courseId]?.[wordKey(card)] ?? EMPTY_WORD;
	}

	/** Records one outcome and persists the course's records. */
	async record(
		courseId: string,
		card: VocabCard,
		correct: boolean,
		mode: WordRecord['mode'],
		deck?: string
	): Promise<WordRecord> {
		await this.load(courseId);
		const next = { ...recordOutcome(this.recordFor(courseId, card), correct, mode), deck };
		const course = { ...(this.records[courseId] ?? {}), [wordKey(card)]: next };
		this.records = { ...this.records, [courseId]: course };
		await storage.set(this.key(courseId), JSON.stringify(course));
		return next;
	}

	/** The cards of `deck` the learner is still getting wrong, latest miss first. */
	weakCards(courseId: string, deck: readonly VocabCard[]): VocabCard[] {
		const course = this.records[courseId] ?? {};
		return deck
			.filter((card) => isWeak(course[wordKey(card)] ?? EMPTY_WORD))
			.sort((a, b) =>
				(course[wordKey(b)]?.lastWrong ?? '').localeCompare(course[wordKey(a)]?.lastWrong ?? '')
			);
	}

	/**
	 * Weak words among the cards last practised in `quizId`'s deck. The
	 * library strip has each deck's summary but not its cards, so the record
	 * remembers which deck a word belongs to.
	 */
	weakCountFor(courseId: string, quizId: string): number {
		const course = this.records[courseId] ?? {};
		return Object.values(course).filter((r) => r.deck === quizId && isWeak(r)).length;
	}

	/** How many of `deck` are weak — for the toggle's badge. */
	weakCount(courseId: string, deck: readonly VocabCard[]): number {
		return this.weakCards(courseId, deck).length;
	}
}

export const vocab = new VocabStore();
