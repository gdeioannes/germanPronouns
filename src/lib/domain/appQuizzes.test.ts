import { describe, expect, it } from 'vitest';
import { readdirSync, readFileSync } from 'node:fs';
import { loadBook2 } from './book2';
import { chapterParts } from './bookStudy';

// The app side of every printed page (Chapter.appQuizzes): the quizzes a page
// code's "App" opens, each tied to the thing on the page it practises. The
// list page and the printed page challenge both read it, so it has to be
// whole and true.
const bundle = JSON.parse(readFileSync('assets/content/courses/de_cert_a1.json', 'utf8')) as {
	quizzes: { id: string; level?: string; title: string }[];
};
const quizzes = new Map(bundle.quizzes.map((q) => [q.id, q]));
const levels = readdirSync('assets/content/book2/de_cert_a1')
	.filter((f) => /^[abc]\d_\d\.json$/.test(f))
	.map((f) => f.slice(0, -5).toUpperCase().replace('_', '.'));

for (const level of levels) {
	const book = loadBook2('de_cert_a1', level)!;
	const started = book.chapters.some((c) => c.appQuizzes);
	if (!started) continue;
	describe(`app quiz lists ${level}`, () => {
		it('cover every chapter once a book has them', () => {
			expect(book.chapters.filter((c) => !c.appQuizzes).map((c) => c.id)).toEqual([]);
		});
		for (const c of book.chapters) {
			if (!c.appQuizzes) continue;
			// The pages a list can belong to: the words page and every page with exercises.
			const parts = chapterParts(c).filter((p) => p.id === 'woerter' || p.exercises.length).map((p) => p.id as string);
			it(`${c.n} ${c.title}: every page has a list of 1–4 real quizzes from ${level}`, () => {
				const problems: string[] = [];
				for (const part of parts) if (!c.appQuizzes![part]?.length) problems.push(`${part}: no list`);
				for (const [part, picks] of Object.entries(c.appQuizzes!)) {
					if (!parts.includes(part)) problems.push(`${part}: not a page of this chapter`);
					if (!picks?.length || picks.length > 4) problems.push(`${part}: ${picks?.length ?? 0} quizzes`);
					const seen = new Set<string>();
					for (const p of picks ?? []) {
						const q = quizzes.get(p.quiz);
						if (!q) problems.push(`${part}: no quiz ${p.quiz}`);
						else if (q.level !== level) problems.push(`${part}: ${p.quiz} is ${q.level}`);
						if (seen.has(p.quiz)) problems.push(`${part}: ${p.quiz} twice`);
						seen.add(p.quiz);
						if (!p.for?.trim()) problems.push(`${part} ${p.quiz}: no "for"`);
						if (!p.note?.trim() || p.note.length > 170) problems.push(`${part} ${p.quiz}: note missing or too long`);
					}
				}
				expect(problems).toEqual([]);
			});
		}
	});
}
