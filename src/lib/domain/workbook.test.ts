// The level workbooks, built from the real course: every level prints, every
// unit's answer strip matches its exercises, and the booklet is the same each
// time it is built (the committed PDFs depend on that).
import { describe, expect, it } from 'vitest';

import { loadCourse } from '$lib/content';
import {
	buildWorkbook,
	moduleTitle,
	PICTURES_PER_LEVEL,
	PRACTICE_PER_UNIT,
	workbookCards,
	workbookFile,
	workbookLevels
} from './workbook';

const course = await loadCourse('de_cert_a1');
const levels = workbookLevels(course);

describe('moduleTitle', () => {
	it('drops the level code and the shouting', () => {
		expect(moduleTitle('A1.1 · ERSTE SCHRITTE', 'A1.1')).toBe('Erste Schritte');
		expect(moduleTitle('B1.1 · MEINUNGEN & WÜNSCHE', 'B1.1')).toBe('Meinungen & Wünsche');
	});

	it('keeps a title that is already in mixed case', () => {
		expect(moduleTitle('A2.2 · Beschreiben & Planen', 'A2.2')).toBe('Beschreiben & Planen');
	});
});

describe('workbookFile', () => {
	it('names one PDF per level', () => {
		expect(workbookFile('de_cert_a1', 'C2.2')).toBe('de_cert_a1_c2_2.pdf');
	});
});

describe('buildWorkbook', () => {
	it('covers every sub-level, A1.1 to C2.2', () => {
		expect(levels.map((l) => l.level)).toEqual([
			'A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2',
			'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'
		]);
	});

	it('returns null for a level the course does not have', () => {
		expect(buildWorkbook(course, 'Z9.9')).toBeNull();
	});

	for (const { level } of levels) {
		describe(level, () => {
			const wb = buildWorkbook(course, level)!;

			it('has a cover, units and a picture page', () => {
				expect(wb.cover).toBeTruthy();
				expect(wb.units.length).toBeGreaterThan(10);
				expect(wb.pictures.length).toBe(PICTURES_PER_LEVEL);
			});

			it('teaches before it tests: every unit has a hook, rules and practice', () => {
				for (const unit of wb.units) {
					expect(unit.hook, unit.quizId).toBeTruthy();
					expect(unit.rules.length, unit.quizId).toBeGreaterThan(0);
					expect(unit.practice?.items.length, unit.quizId).toBeGreaterThan(0);
				}
			});

			it('numbers each unit 1…n and keys every exercise exactly once', () => {
				for (const unit of wb.units) {
					const count = unit.checks.length + (unit.practice?.items.length ?? 0);
					expect(unit.answers.map((a) => a.n), unit.quizId).toEqual(
						Array.from({ length: count }, (_, i) => i + 1)
					);
					expect(unit.answers.every((a) => a.text.trim().length > 0), unit.quizId).toBe(true);
				}
			});

			it('keys each tick-box question to one of its own letters', () => {
				for (const unit of wb.units) {
					for (const check of unit.checks) {
						expect(check.options, unit.quizId).toContain(check.answer);
					}
				}
			});

			it('trims sentence banks and keeps a text whole', () => {
				for (const unit of wb.units) {
					const practice = unit.practice!;
					if (practice.kind === 'cloze') {
						expect(practice.items.length).toBeLessThanOrEqual(PRACTICE_PER_UNIT);
					}
					if (practice.kind === 'inlineCloze') {
						const gaps = practice.passage?.match(/\{\{\d+\}\}/g) ?? [];
						expect(gaps.length, unit.quizId).toBe(practice.items.length);
					}
				}
			});

			it('never repeats the shared card art as a unit picture', () => {
				for (const unit of wb.units) {
					expect(unit.image ?? '', unit.quizId).not.toMatch(/^card_/);
				}
			});
		});
	}

	it('builds the same booklet every time', () => {
		expect(buildWorkbook(course, 'B1.2')).toEqual(buildWorkbook(course, 'B1.2'));
	});
});

describe('workbookCards', () => {
	it('lists one card per level with the unit count the booklet prints', () => {
		const cards = workbookCards(course);
		expect(cards.map((c) => c.level)).toEqual(levels.map((l) => l.level));
		for (const card of cards) {
			expect(card.units).toBe(buildWorkbook(course, card.level)!.units.length);
		}
	});
});
