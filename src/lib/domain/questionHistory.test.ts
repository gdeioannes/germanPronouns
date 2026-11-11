// The per-question verdict record behind the dots on a quiz card.
import { describe, expect, it } from 'vitest';
import {
	mergeQuestionHistory,
	parseQuestionHistory,
	QUESTION_HISTORY_LIMIT,
	questionKey,
	type QuestionHistory,
	withVerdict
} from './questionHistory';
import { mergeProgress } from './sync-merge';
import { quizStatsKeys } from './keys';

describe('questionKey', () => {
	it('is stable, short and tells sentences apart', () => {
		expect(questionKey('Ich sehe ____ Hund.')).toBe(questionKey('Ich sehe ____ Hund.'));
		expect(questionKey('Ich sehe ____ Hund.')).not.toBe(questionKey('Ich sehe ____ Katze.'));
		expect(questionKey('Ich sehe ____ Hund.').length).toBeLessThanOrEqual(7);
	});
});

describe('withVerdict', () => {
	it('appends oldest-first and keeps only the last few', () => {
		let h: QuestionHistory = {};
		for (let i = 0; i < QUESTION_HISTORY_LIMIT + 2; i++) h = withVerdict(h, 'q', i % 2 === 0, i + 1);
		expect(h.q).toHaveLength(QUESTION_HISTORY_LIMIT);
		expect(h.q[0].at).toBe(3);
		expect(h.q.at(-1)).toEqual({ c: false, at: QUESTION_HISTORY_LIMIT + 2 });
	});
});

describe('parseQuestionHistory', () => {
	it('drops garbage and never throws', () => {
		expect(parseQuestionHistory(null)).toEqual({});
		expect(parseQuestionHistory([1])).toEqual({});
		expect(parseQuestionHistory({ q: 'no', r: [{ c: true, at: 5 }, 'x', { c: 'yes' }] })).toEqual({
			r: [{ c: true, at: 5 }]
		});
	});
});

describe('merging two devices', () => {
	it('unions by timestamp, newest kept, and is idempotent', () => {
		const a = { q: [{ c: true, at: 1 }, { c: false, at: 2 }] };
		const b = { q: [{ c: false, at: 2 }, { c: true, at: 3 }], r: [{ c: true, at: 9 }] };
		const merged = mergeQuestionHistory(a, b);
		expect(merged.q.map((v) => v.at)).toEqual([1, 2, 3]);
		expect(merged.r).toEqual(b.r);
		expect(mergeQuestionHistory(merged, b)).toEqual(merged);
	});

	it('is wired into the progress merge by key suffix', () => {
		const key = quizStatsKeys('a1_1_fill_').questionHistory;
		const local = { [key]: JSON.stringify({ q: [{ c: true, at: 1 }] }) };
		const remote = { [key]: JSON.stringify({ q: [{ c: false, at: 2 }] }) };
		const out = mergeProgress(local, remote, false);
		expect(JSON.parse(out[key])).toEqual({ q: [{ c: true, at: 1 }, { c: false, at: 2 }] });
	});
});
