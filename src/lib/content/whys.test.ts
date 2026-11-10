// The home page promises "you see the right one and why". For fill-in
// drills the why is authored per sentence (assets/content/whys, folded in
// by tool/apply-whys.mjs). This gate keeps a level honest once it is
// authored: list it here and every one of its sentences must carry a why —
// coverage can never silently regress.
import { describe, expect, it } from 'vitest';
import course from '../../../assets/content/courses/de_cert_a1.json';

/** Levels whose fill-in sentences are fully authored. Extend as levels land. */
const ENFORCED = ['A1.1'];

type Sentence = { sentence: string; why?: string; whyEn?: string };
type Quiz = {
	id: string;
	level?: string;
	type: string;
	sentences?: Sentence[];
	help?: { german?: boolean };
};

const quizzes = (course as { quizzes: Quiz[] }).quizzes.filter(
	(q) => q.type === 'fillBlank' && q.sentences?.length
);

describe('fill-in whys', () => {
	for (const level of ENFORCED) {
		it(`${level}: every sentence explains its answer`, () => {
			const missing = quizzes
				.filter((q) => q.level === level)
				.flatMap((q) =>
					q.sentences!.filter((s) => !s.why?.trim()).map((s) => `${q.id}: ${s.sentence}`)
				);
			expect(missing).toEqual([]);
		});
	}

	it('a German-help quiz gives the English of every authored why', () => {
		const missing = quizzes
			.filter((q) => q.help?.german === true)
			.flatMap((q) =>
				q.sentences!.filter((s) => s.why && !s.whyEn?.trim()).map((s) => `${q.id}: ${s.sentence}`)
			);
		expect(missing).toEqual([]);
	});

	it('a why is one short line, never a bare restating of the answer', () => {
		const bad = quizzes.flatMap((q) =>
			q.sentences!
				.filter((s) => s.why && (s.why.length > 180 || /\n/.test(s.why)))
				.map((s) => `${q.id}: ${s.sentence}`)
		);
		expect(bad).toEqual([]);
	});
});
