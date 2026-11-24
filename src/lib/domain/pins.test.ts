import { describe, expect, it } from 'vitest';
import {
	addPin,
	emptyBook,
	mergeBooks,
	mergePinValues,
	parseBook,
	questionPinId,
	quizPinId,
	removePin,
	type Pin
} from './pins';
import { learnt, practiceQuiz, practiceSentences, practisable } from './pinPractice';
import { mergeProgress } from './sync-merge';
import { SettingsKeys } from './keys';
import { questionKey } from './questionHistory';
import type { FillBlankQuiz, Quiz } from '$lib/content/types';

const quizPin = (quizId: string, at: number): Pin => ({
	id: quizPinId('c', quizId),
	kind: 'quiz',
	courseId: 'c',
	quizId,
	quizTitle: quizId,
	quizType: 'fillBlank',
	at
});

const questionPin = (quizId: string, text: string, at: number, quizType = 'fillBlank'): Pin => ({
	id: questionPinId('c', quizId, text),
	kind: 'question',
	courseId: 'c',
	quizId,
	quizTitle: quizId,
	quizType,
	text,
	key: questionKey(text),
	at
});

describe('pins', () => {
	it('adds newest first, once per id', () => {
		let book = addPin(emptyBook(), quizPin('a', 1));
		book = addPin(book, quizPin('b', 2));
		book = addPin(book, quizPin('a', 3));
		expect(book.items.map((p) => p.quizId)).toEqual(['a', 'b']);
	});

	it('remembers an unpin, and forgets it when pinned again', () => {
		let book = removePin(addPin(emptyBook(), quizPin('a', 1)), quizPinId('c', 'a'), 5);
		expect(book.items).toEqual([]);
		expect(book.removed[quizPinId('c', 'a')]).toBe(5);
		book = addPin(book, quizPin('a', 6));
		expect(book.removed).toEqual({});
	});

	it('merges two devices: both pins survive, an unpin wins over an older pin', () => {
		const phone = addPin(addPin(emptyBook(), quizPin('a', 1)), quizPin('b', 2));
		const laptop = removePin(addPin(phone, quizPin('c', 3)), quizPinId('c', 'a'), 4);
		const merged = mergeBooks(phone, laptop);
		expect(merged.items.map((p) => p.quizId).sort()).toEqual(['b', 'c']);
		// The other way round gives the same answer, and merging again changes nothing.
		expect(mergeBooks(laptop, phone)).toEqual(merged);
		expect(mergeBooks(merged, phone)).toEqual(merged);
	});

	it('keeps a pin made after the other device unpinned it', () => {
		const laptop = removePin(addPin(emptyBook(), quizPin('a', 1)), quizPinId('c', 'a'), 2);
		const phone = addPin(emptyBook(), quizPin('a', 3));
		expect(mergeBooks(laptop, phone).items.map((p) => p.quizId)).toEqual(['a']);
	});

	it('survives junk', () => {
		expect(parseBook('not json')).toEqual(emptyBook());
		expect(parseBook('{"items":[{"id":1}],"removed":{"x":"y"}}')).toEqual(emptyBook());
	});

	it('runs through the account sync with its own merge, not newest-wins', () => {
		const local = JSON.stringify(addPin(emptyBook(), quizPin('a', 1)));
		const remote = JSON.stringify(addPin(emptyBook(), quizPin('b', 2)));
		expect(parseBook(mergePinValues(local, remote)).items).toHaveLength(2);
		const merged = mergeProgress({ [SettingsKeys.pins]: local }, { [SettingsKeys.pins]: remote }, true);
		expect(parseBook(merged[SettingsKeys.pins]).items).toHaveLength(2);
	});
});

describe('pinned practice', () => {
	const drill = {
		id: 'q1',
		type: 'fillBlank',
		title: 'Drill',
		storageKeyPrefix: 'q1_',
		subjects: [],
		categories: [],
		sentences: [
			{ subjectKey: 's', categoryLabel: 'Akk', sentence: 'Ich sehe ____ Mann.', acceptedAnswers: ['den'] },
			{ subjectKey: 's', categoryLabel: 'Dat', sentence: 'Ich helfe ____ Frau.', acceptedAnswers: ['der'] }
		]
	} satisfies FillBlankQuiz;

	it('finds the pinned sentences in today’s content, each once', () => {
		const pinned = [
			questionPin('q1', 'Ich helfe ____ Frau.', 3),
			questionPin('q1', 'Ich sehe ____ Mann.', 2),
			questionPin('q1', 'Gone from the course ____.', 1)
		];
		const found = practiceSentences(pinned, [drill as Quiz]);
		expect(found.map((s) => s.acceptedAnswers[0])).toEqual(['der', 'den']);
		const quiz = practiceQuiz(found, 'Pinned');
		expect(quiz.sentences).toHaveLength(2);
		expect(quiz.storageKeyPrefix).not.toBe(drill.storageKeyPrefix);
	});

	it('leaves other kinds to their own exercise', () => {
		expect(practisable(questionPin('d1', 'Hallo', 1, 'dictation'))).toBe(false);
		expect(practisable(quizPin('q1', 1))).toBe(false);
	});

	it('calls a question learnt after three right in a row', () => {
		expect(learnt([{ c: true }, { c: true }])).toBe(false);
		expect(learnt([{ c: false }, { c: true }, { c: true }, { c: true }])).toBe(true);
		expect(learnt([{ c: true }, { c: true }, { c: false }])).toBe(false);
	});
});
