// The printed book talks about the page, not the screen: no taps, runs,
// replays or keyboards in a unit's prose. The paper wording in
// assets/content/book/<course>/ replaces the app's lesson text where the two
// differ, and this test is what keeps the replacement complete for the books
// that are printed.
import { describe, expect, it } from 'vitest';

import { loadCourse } from '$lib/content';
import { buildWorkbook, type PaperOverrides } from './workbook';

import a1_1 from '$content/book/de_cert_a1/a1_1.json';
import a1_2 from '$content/book/de_cert_a1/a1_2.json';

const course = await loadCourse('de_cert_a1');
const paper: Record<string, PaperOverrides> = { 'A1.1': strip(a1_1), 'A1.2': strip(a1_2) };

function strip(file: Record<string, unknown>): PaperOverrides {
	const { _comment: _, ...units } = file;
	return units as PaperOverrides;
}

/** Wording that only makes sense with a screen in front of you. */
const SCREEN =
	/\b(tap|taps|tapping|this quiz|the app('s)? (colours|tables|builds)|press play|checked (strictly|leniently)|your keyboard|umlaut keys|in the same run|weak (words|list)|paste it|voice mode|write mode|flashcards|type (it|only|both|the|them|ae|ss)|typing|here in the box|the prompt (asks|hides))\b/i;

describe('the A1 book on paper', () => {
	for (const level of ['A1.1', 'A1.2']) {
		it(`${level}: every paper override names a unit of the level`, () => {
			const ids = new Set(course.quizzes.filter((q) => q.level === level).map((q) => q.id));
			for (const id of Object.keys(paper[level])) expect(ids.has(id), id).toBe(true);
		});

		it(`${level}: a tip override points at a tip that exists`, () => {
			for (const [id, unit] of Object.entries(paper[level])) {
				const tips = course.quizzes.find((q) => q.id === id)?.help?.tips ?? [];
				for (const index of Object.keys(unit.tips ?? {})) expect(Number(index), `${id} tip ${index}`).toBeLessThan(tips.length);
			}
		});

		it(`${level}: no unit's prose talks about the screen`, () => {
			const wb = buildWorkbook(course, level, paper[level])!;
			for (const unit of wb.units) {
				const texts = [unit.hook, unit.intro ?? '', ...unit.remember, ...unit.rules.flatMap((r) => [r.title ?? '', r.text, r.trap ?? ''])];
				for (const text of texts) expect(text, `${unit.quizId}: ${text.slice(0, 80)}`).not.toMatch(SCREEN);
			}
		});
	}

	it('applies an override to the unit and leaves the rest alone', () => {
		const plain = buildWorkbook(course, 'A1.1')!.units.find((u) => u.quizId === 'quest_a1_1_suchbild_wohnzimmer')!;
		const onPaper = buildWorkbook(course, 'A1.1', paper['A1.1'])!.units.find((u) => u.quizId === 'quest_a1_1_suchbild_wohnzimmer')!;
		expect(plain.hook).toMatch(/tap/);
		expect(onPaper.hook).not.toMatch(/tap/);
		expect(onPaper.rules.map((r) => r.text)).toEqual(plain.rules.map((r) => r.text));
		expect(onPaper.answers).toEqual(plain.answers);
	});
});
