// The Help Memory's reference table — the third of the panel's three layers.
//
// The plan (docs/de_certification_a1_c2_plan.md, Rule B) keeps intro, tips and
// table strictly non-overlapping: the intro frames the idea, the tips carry the
// rules and mnemonics, and the table carries the reference data — every form,
// laid out so it can be scanned rather than read.
//
// Nothing stores that table. It is the quiz's own answer key: the subjects are
// its rows, the categories its columns, and `category.values[rowIndex]` the
// cell. Deriving it rather than authoring it is why it can never drift from
// what the exercise actually asks for.

import type { Quiz } from '$lib/content/types';

export interface HelpTable {
	/** Header for the first column — "Nomen", "Pronomen", whatever it drills. */
	subjectHeader: string;
	columns: string[];
	rows: HelpTableRow[];
	/** Tint each row by the noun's gender, as the Word Library does. */
	colorByGender: boolean;
}

export interface HelpTableRow {
	subject: string;
	/** The English meaning, when the content carries one. */
	english?: string;
	gender?: string;
	cells: string[];
}

/**
 * The reference table for a quiz, or null when it has no grid to show —
 * reading, listening, dictation and the speaking kinds have none.
 */
export function helpTableFor(quiz: Quiz): HelpTable | null {
	if (quiz.type !== 'fillBlank') return null;
	const { subjects, categories } = quiz;
	if (!subjects?.length || !categories?.length) return null;

	return {
		subjectHeader: quiz.subjectColumnLabel ?? quiz.subjectsLabel ?? '',
		columns: categories.map((category) => category.label),
		rows: subjects.map((subject, row) => ({
			subject: subject.display,
			english: subject.english,
			gender: subject.gender,
			// A category whose values run short leaves a blank rather than
			// `undefined`: a gap in the data must not become a gap in the markup.
			cells: categories.map((category) => category.values[row] ?? '')
		})),
		colorByGender: quiz.help?.colorByGender === true
	};
}
