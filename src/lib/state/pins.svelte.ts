// The learner's pins: exercises and single questions saved to come back to.
// Rules and the merge are in domain/pins; this keeps them in storage, which
// the account sync carries to other devices.

import { SettingsKeys } from '$lib/domain/keys';
import {
	addPin,
	emptyBook,
	parseBook,
	questionPinId,
	quizPinId,
	removePin,
	type Pin,
	type PinBook
} from '$lib/domain/pins';
import { questionKey } from '$lib/domain/questionHistory';
import { storage } from '$lib/services/storage';
import { track } from '$lib/services/analytics';

/** What a pin needs to know about the exercise it is in. */
export interface PinSource {
	courseId: string;
	quizId: string;
	quizTitle: string;
	quizType: string;
	level?: string;
}

class PinStore {
	book = $state.raw<PinBook>(emptyBook());
	loaded = $state(false);

	readonly items = $derived(this.book.items);
	readonly quizzes = $derived(this.book.items.filter((p) => p.kind === 'quiz'));
	readonly questions = $derived(this.book.items.filter((p) => p.kind === 'question'));

	/** Re-read every time: a sync may have merged in pins from another device. */
	async load(): Promise<void> {
		this.book = parseBook(await storage.get(SettingsKeys.pins));
		this.loaded = true;
	}

	has(id: string): boolean {
		return this.book.items.some((p) => p.id === id);
	}

	private async save(book: PinBook): Promise<void> {
		this.book = book;
		await storage.set(SettingsKeys.pins, JSON.stringify(book));
	}

	async pinQuiz(source: PinSource): Promise<void> {
		const pin: Pin = { ...source, id: quizPinId(source.courseId, source.quizId), kind: 'quiz', at: Date.now() };
		await this.save(addPin(this.book, pin));
		track('pin', { kind: 'quiz', quiz: source.quizId });
	}

	async pinQuestion(source: PinSource, text: string): Promise<void> {
		const pin: Pin = {
			...source,
			id: questionPinId(source.courseId, source.quizId, text),
			kind: 'question',
			text,
			key: questionKey(text),
			at: Date.now()
		};
		await this.save(addPin(this.book, pin));
		track('pin', { kind: 'question', quiz: source.quizId });
	}

	async unpin(id: string): Promise<void> {
		await this.save(removePin(this.book, id));
	}
}

export const pins = new PinStore();
