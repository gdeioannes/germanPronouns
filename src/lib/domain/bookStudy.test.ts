import { describe, expect, it } from 'vitest';
import { readFileSync, readdirSync } from 'node:fs';
import type { Book2, Chapter } from './book2';
import { acceptedForms, chapterParts, dueWords, markExercise, markTyped, review, scoreOf } from './bookStudy';

const DIR = 'assets/content/book2/de_cert_a1/';
const books: Book2[] = readdirSync(DIR)
	.filter((f) => /^[abc]\d_\d\.json$/.test(f))
	.map((f) => JSON.parse(readFileSync(DIR + f, 'utf8')));

describe('markTyped', () => {
	it('ignores spacing, closing punctuation and the euro sign', () => {
		expect(markTyped(' 2,90€ ', '2,90 €')).toBe('right');
		expect(markTyped('Ich heiße Maya', 'Ich heiße Maya.')).toBe('right');
		expect(markTyped('1 €', '1,00 €')).toBe('right');
		expect(markTyped('2.90', '2,90 €')).toBe('right');
		expect(markTyped('2,80', '2,90 €')).toBe('wrong');
	});
	it('says when only the capitals are wrong', () => {
		expect(markTyped('der apfel', 'der Apfel')).toBe('capitals');
	});
	it('takes the alternative in brackets', () => {
		expect(markTyped('zwo', 'zwei (or zwo)')).toBe('right');
		expect(markTyped('null – acht – neun – zwo', 'null – acht – neun – zwei (or zwo)')).toBe('right');
		expect(markTyped('Sohn', 'Sohn (Raimond)')).toBe('right');
	});
	it('takes either side of a spaced slash, not of a name with a slash', () => {
		expect(markTyped('seit 2025', 'seit einem Jahr / seit 2025')).toBe('right');
		expect(acceptedForms('Köln/Bonn Flughafen')).not.toContain('Köln');
	});
	it('lets the reader finish a sentence the key only starts', () => {
		expect(markTyped('Beim Waschen der Wäsche ist es passiert.', 'Beim Waschen …')).toBe('right');
		expect(markTyped('Wegen dem Waschen', 'Beim Waschen …')).toBe('wrong');
	});
	it('reads a split gap with or without the dots', () => {
		expect(markTyped('ist worden', 'ist … worden')).toBe('right');
		expect(markTyped('ist ... worden', 'ist … worden')).toBe('right');
	});
	it('marks wrong and empty answers wrong, and the reader’s own as open', () => {
		expect(markTyped('die Apfel', 'der Apfel')).toBe('wrong');
		expect(markTyped('', 'der Apfel')).toBe('wrong');
		expect(markTyped('anything', undefined)).toBe('open');
	});
});

describe('every key answer in every book', () => {
	it('is marked right when typed or picked as printed', () => {
		const misses: string[] = [];
		for (const book of books)
			for (const c of book.chapters as Chapter[])
				for (const part of chapterParts(c))
					for (const { ex, key } of part.exercises) {
						const answers: Record<number, string> = {};
						switch (ex.kind) {
							case 'write':
							case 'tags':
								ex.items.forEach((it, i) => (answers[i] = it.answer));
								break;
							case 'gaps':
								ex.items.forEach((it, i) => (answers[i] = it.answer ?? ''));
								break;
							case 'clocks':
								ex.items.forEach((it, i) => (answers[i] = ex.draw ? it.time : it.de));
								break;
							case 'circle':
								ex.items.forEach((it, i) => (answers[i] = it.answer));
								break;
							case 'match':
							case 'sort':
								ex.answers.forEach((a, i) => (answers[i] = String(a)));
								break;
						}
						const results = markExercise(ex, answers);
						const s = scoreOf(results);
						if (s.right !== s.total) misses.push(`${book.title} ${c.id} ${key}`);
					}
		expect(misses).toEqual([]);
	});
});

describe('chapterParts', () => {
	it('numbers the practice pages on from each other, as printed', () => {
		const parts = chapterParts(books[0].chapters[0] as Chapter);
		const p1 = parts.find((p) => p.id === 'uebungen-1')!.exercises;
		const p2 = parts.find((p) => p.id === 'uebungen-2')!.exercises;
		expect(p2[0].n).toBe(p1.length + 1);
	});
});

describe('flashcard schedule', () => {
	it('sends a known word further away each time and a missed one back to now', () => {
		const now = 1_000_000;
		let boxes = review({}, 'der Apfel', true, now);
		expect(boxes['der Apfel'].box).toBe(1);
		expect(dueWords([{ de: 'der Apfel' }], boxes, now)).toEqual([]);
		boxes = review(boxes, 'der Apfel', false, now);
		expect(boxes['der Apfel'].box).toBe(0);
		expect(dueWords([{ de: 'der Apfel' }], boxes, now)).toHaveLength(1);
	});
});
