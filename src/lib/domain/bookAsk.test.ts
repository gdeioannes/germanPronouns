import { describe, expect, it } from 'vitest';
import {
	BOOK_CLOSES_MAX,
	EMPTY_BOOK_RECORD,
	afterBookClose,
	afterBookRating,
	mayAskBook,
	parseBookRecord
} from './bookAsk';

const DAY = 24 * 60 * 60 * 1000;
const NOON = new Date(2026, 10, 19, 12, 0, 0).getTime();
const fresh = () => structuredClone(EMPTY_BOOK_RECORD);

describe('book questions', () => {
	it('asks about each book until it is rated', () => {
		const r = afterBookRating(fresh(), 'A1.1', NOON);
		expect(mayAskBook(r, 'A1.1', NOON + 30 * DAY)).toBe(false);
		expect(mayAskBook(r, 'A1.2', NOON)).toBe(true);
	});

	it('after a close waits for another day, and stops after three', () => {
		let r = afterBookClose(fresh(), 'A1.1', NOON);
		expect(mayAskBook(r, 'A1.1', NOON + 60 * 60 * 1000)).toBe(false);
		expect(mayAskBook(r, 'A1.1', NOON + DAY)).toBe(true);
		for (let i = 1; i < BOOK_CLOSES_MAX; i++) r = afterBookClose(r, 'A1.1', NOON + (i + 1) * DAY);
		expect(mayAskBook(r, 'A1.1', NOON + 30 * DAY)).toBe(false);
	});

	it('never asks without a book', () => {
		expect(mayAskBook(fresh(), '', NOON)).toBe(false);
	});

	it('reads a broken record as a fresh one', () => {
		expect(parseBookRecord('{x')).toEqual(EMPTY_BOOK_RECORD);
		expect(parseBookRecord('{"rated":{"A1.1":5,"bad":"x"}}')).toEqual({
			...EMPTY_BOOK_RECORD,
			rated: { 'A1.1': 5 }
		});
	});
});
