import { describe, expect, it } from 'vitest';
import { existsSync, readdirSync } from 'node:fs';
import { loadBook2, photoCredits, photosOf, practiseOf, chapterExercises } from './book2';
import { answersOf, wordsIn } from './companion';

// Book v2 (docs/book_v2_plan.md): every chapter has its ten pages' worth of
// content, every photo is on disk and credited, every exercise has its answer.
const credits = photoCredits('de_cert_a1');

// Every book file: a1_2.json is A1.2.
const levels = readdirSync('assets/content/book2/de_cert_a1').filter((f) => /^[abc]\d_\d\.json$/.test(f)).map((f) => f.slice(0, -5).toUpperCase().replace('_', '.'));

for (const level of levels)
describe(`book v2 ${level}`, () => {
	const book = loadBook2('de_cert_a1', level)!;
	it('exists, with chapters numbered 1…n in order', () => {
		expect(book).toBeTruthy();
		expect(book.chapters.map((c) => c.n)).toEqual(book.chapters.map((_, i) => i + 1));
	});

	for (const c of book.chapters) {
		describe(`${c.n} ${c.title}`, () => {
			it('has every page', () => {
				expect(c.words.groups.length).toBeGreaterThan(0);
				expect(c.opener.questions.length).toBe(3);
				expect(c.opener.labels?.length ?? 0).toBeGreaterThanOrEqual(6);
				expect(c.reading.lines.length).toBeGreaterThanOrEqual(3);
				expect(c.reading.tasks.length).toBeGreaterThanOrEqual(1);
				expect(c.grammar.length).toBe(2);
				for (const g of c.grammar) expect(g.check, `${g.heading} check`).toBeTruthy();
				expect(c.document.tasks.length).toBeGreaterThanOrEqual(2);
				expect(c.practise.length).toBeGreaterThanOrEqual(5);
				expect(c.canDo.length).toBe(4);
			});

			it('prints only photos on disk, each credited', () => {
				for (const id of photosOf(c)) {
					expect(existsSync(`static/img/photo/web/${id}.jpg`), id).toBe(true);
					expect(credits[id], `credit for ${id}`).toBeTruthy();
				}
			});

			it('prints only word pictures on disk', () => {
				for (const w of [...c.words.groups.flatMap((g) => g.items), ...(c.opener.labels ?? [])])
					if (w.image) expect(existsSync(`static/img/${w.image}.webp`), w.image).toBe(true);
			});

			it('answers every exercise, or marks it as the reader’s own', () => {
				for (const { part, exercises } of chapterExercises(c))
					for (const ex of exercises) {
						const { answers, note } = answersOf(ex);
						expect(answers.length > 0 || !!note, `${part}: ${ex.title}`).toBe(true);
					}
			});

			it('keeps the picture check to twelve nouns with articles', () => {
				const check = practiseOf(c).at(-1)!;
				expect(check.kind).toBe('tags');
				if (check.kind === 'tags') {
					expect(check.items.length).toBeGreaterThanOrEqual(8);
					for (const i of check.items) expect(i.answer).toMatch(/^(der|die|das) /);
				}
			});

			it('asks for nothing in a circle or gaps exercise the chapter never shows', () => {
				const shown = new Set<string>();
				const add = (t?: string) => wordsIn(t ?? '').forEach((w) => shown.add(w));
				c.words.groups.forEach((g) => g.items.forEach((w) => add(w.de)));
				c.words.verbs?.forEach((v) => add(v.de));
				c.opener.labels?.forEach((l) => add(l.de));
				c.reading.lines.forEach((l) => add(l.de));
				c.grammar.forEach((g) => add(JSON.stringify(g.blocks)));
				add(c.opener.caption); add(c.document.caption);
				for (const { exercises } of chapterExercises(c))
					for (const ex of exercises)
						if (ex.kind === 'circle')
							for (const item of ex.items)
								for (const o of item.options) expect(o.length, `${ex.title}: ${o}`).toBeGreaterThan(0);
			});
		});
	}
});
