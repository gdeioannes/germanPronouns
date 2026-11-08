import { describe, expect, it } from 'vitest';
import { hidesEnglish } from './germanFirst';
import bundle from '../../../assets/content/courses/de_cert_a1.json';
import type { Quiz } from '$lib/content/types';

describe('hidesEnglish', () => {
	it('leaves A1 and A2 alone', () => {
		for (const level of ['A1.1', 'A1.2', 'A2.1', 'A2.2']) expect(hidesEnglish(level)).toBe(false);
	});
	it('hides from B1 up', () => {
		for (const level of ['B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2']) {
			expect(hidesEnglish(level)).toBe(true);
		}
	});
	it('shows English when the level is unknown', () => {
		expect(hidesEnglish(undefined)).toBe(false);
		expect(hidesEnglish(null)).toBe(false);
		expect(hidesEnglish('')).toBe(false);
	});
});

describe('notes written in German', () => {
	const german = (bundle as unknown as { quizzes: Quiz[] }).quizzes.filter((q) => q.help?.german);

	it('cover every quiz from B1 up', () => {
		const fromB1 = (bundle as unknown as { quizzes: Quiz[] }).quizzes.filter((q) => hidesEnglish(q.level) && q.help);
		expect(fromB1.filter((q) => !q.help?.german).map((q) => q.id)).toEqual([]);
	});

	it('keep their English one tap away', () => {
		for (const { id, help } of german) {
			expect(help!.hookEn, id).toBeTruthy();
			expect(help!.introEn, id).toBeTruthy();
			for (const tip of help!.tips ?? []) {
				expect(tip.en?.text, `${id}: ${tip.title}`).toBeTruthy();
				if (tip.check?.why) expect(tip.check.whyEn, `${id}: ${tip.title}`).toBeTruthy();
			}
			for (const m of help!.mistakes ?? []) expect(m.whyEn, `${id}: ${m.wrong}`).toBeTruthy();
		}
	});
});
