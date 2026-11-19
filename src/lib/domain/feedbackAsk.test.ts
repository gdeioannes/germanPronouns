import { describe, expect, it } from 'vitest';
import {
	ACTIVE_NEEDED_MS,
	AFTER_RATING_MS,
	EMPTY_RECORD,
	PAUSE_MS,
	afterClose,
	afterRating,
	mayAsk,
	parseRecord,
	type AskRecord
} from './feedbackAsk';

const DAY = 24 * 60 * 60 * 1000;
// Noon local time, so "the next day" is never a few minutes away.
const NOON = new Date(2026, 10, 19, 12, 0, 0).getTime();
const ready: AskRecord = { ...EMPTY_RECORD, activeMs: ACTIVE_NEEDED_MS };

describe('feedback ask rules', () => {
	it('waits for five minutes of real use', () => {
		expect(mayAsk({ ...EMPTY_RECORD, activeMs: ACTIVE_NEEDED_MS - 1 }, NOON)).toBe(false);
		expect(mayAsk(ready, NOON)).toBe(true);
	});

	it('stays quiet for a week after a rating', () => {
		const r = afterRating(ready, NOON);
		expect(mayAsk(r, NOON + AFTER_RATING_MS - 1)).toBe(false);
		expect(mayAsk(r, NOON + AFTER_RATING_MS)).toBe(true);
	});

	it('asks again the next day after a close, not the same day', () => {
		const r = afterClose(ready, NOON);
		expect(mayAsk(r, NOON + 11 * 60 * 60 * 1000)).toBe(false);
		expect(mayAsk(r, NOON + DAY)).toBe(true);
	});

	it('pauses 30 days after three closes in a row', () => {
		let r = afterClose(ready, NOON);
		r = afterClose(r, NOON + DAY);
		r = afterClose(r, NOON + 2 * DAY);
		expect(mayAsk(r, NOON + 3 * DAY)).toBe(false);
		expect(mayAsk(r, NOON + 2 * DAY + PAUSE_MS)).toBe(true);
		expect(r.closeStreak).toBe(0);
	});

	it('a rating between closes starts the count over', () => {
		let r = afterClose(ready, NOON);
		r = afterClose(r, NOON + DAY);
		r = afterRating(r, NOON + 2 * DAY);
		r = afterClose(r, NOON + 2 * DAY + AFTER_RATING_MS);
		expect(r.pausedUntil).toBe(0);
		expect(r.closeStreak).toBe(1);
	});

	it('reads a broken record as a fresh one', () => {
		expect(parseRecord(null)).toEqual(EMPTY_RECORD);
		expect(parseRecord('{nope')).toEqual(EMPTY_RECORD);
		expect(parseRecord('{"activeMs":"x","ratedAt":-5,"closeStreak":2}')).toEqual({ ...EMPTY_RECORD, closeStreak: 2 });
	});
});
