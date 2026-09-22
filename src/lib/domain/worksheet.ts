// The printable exercise worksheet: which quizzes are in scope, which of their
// exercises to print, and — for the weak-spot mode — how weak each one is.
//
// Ported from lib/data/exercise_sheet_builder.dart. Pure: it takes the course
// bundle plus a stats lookup and returns sections, so it unit-tests without a
// browser and the page only has to lay it out.
//
// The Flutter build rendered these sections into a PDF with the `pdf` package.
// Here the same sections are laid out with a print stylesheet and handed to the
// browser's own "Save as PDF" — the same sheet, without a PDF writer in the
// bundle.

import type {
	FillBlankQuiz,
	InlineClozeQuiz,
	PopulatedCourse,
	Quiz,
	QuizHelp,
	ReadingQuiz,
	SpeakingQuiz
} from '$lib/content/types';
import { isInlineCloze } from '$lib/content/types';
import { helpTableFor, type HelpTable } from '$lib/domain/help-table';

/** Which quizzes feed the worksheet. */
export type ExerciseScope = 'fullCourse' | 'achieved' | 'weakSpots';

/** How a worksheet section is laid out on paper. */
export type ExerciseSectionKind = 'cloze' | 'reading' | 'inlineCloze';

/** Where the answers print. */
export type AnswerPlacement = 'side' | 'pageEnd' | 'documentEnd';

/** One printable exercise: the prompt, and what goes in the answer column. */
export interface ExerciseItem {
	/** The sentence with its `____`, the question stem, or the blank's hint. */
	prompt: string;
	answer: string;
	/** Context line printed above the prompt (the on-screen contextual prompt). */
	secondary?: string;
	/** Multiple-choice options, or the choices of an inline select blank. */
	options: string[];
	/** The grammar category this item tests; feeds the weak-spot weighting. */
	categoryLabel?: string;
	/** 0..1; higher prints first in the weak-spot scope. */
	weakness: number;
}

/** A titled group of exercises from one quiz. */
export interface ExerciseSection {
	quizTitle: string;
	kind: ExerciseSectionKind;
	/** The reading passage, or the inline template still carrying `{{n}}`. */
	passage?: string;
	items: ExerciseItem[];
	/**
	 * The quiz's Help Memory, printed above its exercises. On screen a learner
	 * can open the panel whenever they want it; on paper there is nothing to
	 * open, so the rules have to travel with the questions or the sheet is
	 * unusable away from the app.
	 */
	help?: QuizHelp;
	table?: HelpTable | null;
}

/** Hard cap for "all exercises", so a big course still prints a usable book. */
export const MAX_SHEET_ITEMS = 500;

// Weak-spot blend: the quiz's overall mistake rate versus how concentrated its
// mistakes are on one category.
const QUIZ_ACCURACY_WEIGHT = 0.6;
const CATEGORY_MISTAKE_WEIGHT = 0.4;

/** What the builder needs to know about one quiz's saved history. */
export interface QuizHistory {
	/** How many answers were recorded. */
	answered: number;
	/** Share of them that were wrong, 0..1. */
	mistakeRate: number;
	/** Mistake counts per category label. */
	mistakesByCategory: Record<string, number>;
	/** Whether the course home counts this quiz as finished. */
	done: boolean;
}

export const NO_HISTORY: QuizHistory = {
	answered: 0,
	mistakeRate: 0,
	mistakesByCategory: {},
	done: false
};

export interface SheetOptions {
	scope: ExerciseScope;
	/** Null/undefined = everything, still capped at [MAX_SHEET_ITEMS]. */
	maxItems?: number | null;
	/** Injected in tests; defaults to Math.random. */
	random?: () => number;
}

/**
 * The worksheet sections for [course]: every printable quiz, filtered by scope
 * and sampled down to the requested size. Empty when nothing is in scope.
 */
export function buildWorksheet(
	course: PopulatedCourse,
	history: (quiz: Quiz) => QuizHistory,
	{ scope, maxItems, random = Math.random }: SheetOptions
): ExerciseSection[] {
	const sections: ExerciseSection[] = [];

	for (const quiz of course.quizzes) {
		const stats = history(quiz);
		if (scope === 'achieved' && !stats.done) continue;
		if (scope === 'weakSpots' && stats.answered === 0) continue;
		const section = sectionFor(quiz, stats, random);
		if (section && section.items.length > 0) {
			sections.push({ ...section, help: quiz.help, table: helpTableFor(quiz) });
		}
	}

	const cap = maxItems == null ? MAX_SHEET_ITEMS : Math.min(maxItems, MAX_SHEET_ITEMS);
	return selectSections(sections, { cap, scope, random });
}

/**
 * One quiz's section, or null when it has no paper form. Audio-only kinds
 * (listen-and-repeat, listening, dictation) can't be answered on paper; a
 * speaking exercise prints only when its MATERIAL carries `item = meaning`
 * pairs — the conversation itself has no printed form, its word list does.
 */
export function sectionFor(
	quiz: Quiz,
	stats: QuizHistory = NO_HISTORY,
	random: () => number = Math.random
): ExerciseSection | null {
	switch (quiz.type) {
		case 'reading':
			return isInlineCloze(quiz)
				? inlineClozeSection(quiz, stats)
				: readingSection(quiz, stats);
		case 'fillBlank':
			return fillBlankSection(quiz, stats, random);
		case 'speaking':
			return speakingVocabSection(quiz, stats);
		case 'listening':
		case 'dictation':
		case 'speakRepeat':
			return null;
	}
}

// ── Weak-spot scoring ───────────────────────────────────────────────────────

/**
 * How weak an item testing [categoryLabel] is: the quiz's overall mistake rate
 * blended with how concentrated its mistakes are on that category.
 */
function weakness(stats: QuizHistory, categoryLabel?: string): number {
	const mistakes = Object.values(stats.mistakesByCategory);
	let categoryShare = 0;
	if (categoryLabel && mistakes.length > 0) {
		const worst = Math.max(...mistakes);
		if (worst > 0) categoryShare = (stats.mistakesByCategory[categoryLabel] ?? 0) / worst;
	}
	return QUIZ_ACCURACY_WEIGHT * stats.mistakeRate + CATEGORY_MISTAKE_WEIGHT * categoryShare;
}

// ── Extraction, one per printable kind ──────────────────────────────────────

/** Fill-in: the authored sentence bank, or generated from the templates. */
function fillBlankSection(
	quiz: FillBlankQuiz,
	stats: QuizHistory,
	random: () => number
): ExerciseSection | null {
	if (quiz.sentences && quiz.sentences.length > 0) {
		return sentenceClozeSection(quiz, stats);
	}
	if (quiz.sentenceTemplates && Object.keys(quiz.sentenceTemplates).length > 0) {
		return templateClozeSection(quiz, stats, random);
	}
	return null;
}

/**
 * Cloze items from an authored bank: the answer is the stored one, or the
 * category value for the sentence's subject (article/noun quizzes store none).
 */
function sentenceClozeSection(quiz: FillBlankQuiz, stats: QuizHistory): ExerciseSection {
	const subjectIndex = new Map(quiz.subjects.map((s, i) => [s.key, i]));
	const byLabel = new Map(quiz.categories.map((c) => [c.label, c]));

	const items: ExerciseItem[] = [];
	for (const sentence of quiz.sentences ?? []) {
		if (!sentence.sentence.includes('____')) continue;
		let answer = sentence.acceptedAnswers[0];
		if (!answer) {
			const index = subjectIndex.get(sentence.subjectKey);
			const category = byLabel.get(sentence.categoryLabel);
			if (index !== undefined && category && index < category.values.length) {
				answer = category.values[index];
			}
		}
		if (!answer) continue;
		items.push({
			prompt: sentence.sentence,
			answer,
			secondary: sentence.english,
			options: [],
			categoryLabel: sentence.categoryLabel,
			weakness: weakness(stats, sentence.categoryLabel)
		});
	}
	return { quizTitle: quiz.title, kind: 'cloze', items };
}

/**
 * Cloze items generated from templates: one per subject, testing one randomly
 * chosen category that has both a template and a value for that subject.
 */
function templateClozeSection(
	quiz: FillBlankQuiz,
	stats: QuizHistory,
	random: () => number
): ExerciseSection {
	const pick = <T,>(list: T[]): T => list[Math.floor(random() * list.length)];
	const items: ExerciseItem[] = [];

	for (let i = 0; i < quiz.subjects.length; i++) {
		const subject = quiz.subjects[i];
		const candidates: { value: string; label: string; template: string }[] = [];
		for (const category of quiz.categories) {
			const templates = quiz.sentenceTemplates?.[category.label];
			if (!templates || templates.length === 0) continue;
			const value = category.values[i];
			if (!value) continue;
			candidates.push({ value, label: category.label, template: pick(templates) });
		}
		if (candidates.length === 0) continue;
		const chosen = pick(candidates);
		items.push({
			prompt: chosen.template.replaceAll('{subject}', subject.key),
			answer: chosen.value,
			secondary: subject.display === subject.key ? undefined : subject.display,
			options: [],
			categoryLabel: chosen.label,
			weakness: weakness(stats, chosen.label)
		});
	}
	return { quizTitle: quiz.title, kind: 'cloze', items };
}

/** Reading comprehension: the passage plus its multiple-choice questions. */
function readingSection(quiz: ReadingQuiz, stats: QuizHistory): ExerciseSection {
	const score = weakness(stats, quiz.category);
	const items: ExerciseItem[] = [];
	for (const question of quiz.questions) {
		if (question.correctIndex < 0 || question.correctIndex >= question.options.length) {
			continue;
		}
		const letter = String.fromCharCode(0x61 + question.correctIndex);
		items.push({
			prompt: question.question,
			answer: `${letter})  ${question.options[question.correctIndex]}`,
			options: question.options,
			categoryLabel: quiz.category,
			weakness: score
		});
	}
	return {
		quizTitle: quiz.passageTitle || quiz.title,
		kind: 'reading',
		passage: quiz.passage,
		items
	};
}

/**
 * A big-text passage: one item per inline blank. The layout numbers the `{{n}}`
 * markers in the template, so the passage travels with its items.
 */
function inlineClozeSection(quiz: InlineClozeQuiz, stats: QuizHistory): ExerciseSection {
	const score = weakness(stats);
	return {
		quizTitle: quiz.title,
		kind: 'inlineCloze',
		passage: quiz.inlineTemplate,
		items: quiz.inlineBlanks.map((blank) => ({
			prompt: blank.hint ?? '',
			answer: blank.answer,
			options: blank.options ?? [],
			weakness: score
		}))
	};
}

/**
 * The `item = meaning` pairs in a speaking exercise's MATERIAL — the Dart
 * `speakingMaterialPairsOf`, verbatim. A trailing colon marks a label line.
 */
export function speakingMaterialPairs(material: unknown): [string, string][] {
	if (typeof material !== 'string' || material.length === 0) return [];
	const pairs: [string, string][] = [];
	for (const line of material.split('\n')) {
		for (const segment of line.split(' · ')) {
			if (segment.trim().endsWith(':')) continue;
			const eq = segment.indexOf(' = ');
			if (eq <= 0) continue;
			const left = segment.slice(0, eq).trim();
			const right = segment.slice(eq + 3).trim();
			if (!left || !right || left.includes(':')) continue;
			pairs.push([left, right]);
		}
	}
	return pairs;
}

/** A speaking exercise's printable form: its MATERIAL pairs as a word list. */
function speakingVocabSection(quiz: SpeakingQuiz, stats: QuizHistory): ExerciseSection | null {
	const pairs = speakingMaterialPairs(quiz.speaking?.material);
	if (pairs.length === 0) return null;
	const score = weakness(stats);
	return {
		quizTitle: quiz.title,
		kind: 'cloze',
		items: pairs.map(([chunk, meaning]) => ({
			prompt: chunk,
			answer: meaning,
			options: [],
			weakness: score
		}))
	};
}

// ── Selection / sampling ────────────────────────────────────────────────────

/** One selectable unit: an item, or a whole inline-cloze section. */
interface Unit {
	sectionIndex: number;
	/** Index into the section's items, or null for a whole-section unit. */
	itemIndex: number | null;
	size: number;
	weakness: number;
}

/**
 * Trims [sections] to at most `cap` exercises: the weak-spot scope keeps the
 * weakest units, the others sample randomly. Both spread across the course
 * because units keep their section identity, and print order is preserved.
 */
export function selectSections(
	sections: ExerciseSection[],
	{
		cap,
		scope,
		random = Math.random
	}: { cap: number; scope: ExerciseScope; random?: () => number }
): ExerciseSection[] {
	const total = sections.reduce((n, s) => n + s.items.length, 0);
	if (total <= cap) return sections;

	const units: Unit[] = [];
	sections.forEach((section, s) => {
		if (section.kind === 'inlineCloze') {
			// A passage's blanks belong together: they can't be sampled apart.
			const average =
				section.items.reduce((sum, i) => sum + i.weakness, 0) / section.items.length;
			units.push({
				sectionIndex: s,
				itemIndex: null,
				size: section.items.length,
				weakness: average
			});
		} else {
			section.items.forEach((item, i) => {
				units.push({ sectionIndex: s, itemIndex: i, size: 1, weakness: item.weakness });
			});
		}
	});

	// Shuffled first so equal-weakness units tie-break randomly.
	shuffle(units, random);
	if (scope === 'weakSpots') units.sort((a, b) => b.weakness - a.weakness);

	let remaining = cap;
	const pickedBySection = new Map<number, Set<number>>();
	const wholeSections = new Set<number>();
	for (const unit of units) {
		if (unit.size > remaining) continue;
		remaining -= unit.size;
		if (unit.itemIndex === null) {
			wholeSections.add(unit.sectionIndex);
		} else {
			const picked = pickedBySection.get(unit.sectionIndex) ?? new Set<number>();
			picked.add(unit.itemIndex);
			pickedBySection.set(unit.sectionIndex, picked);
		}
		if (remaining === 0) break;
	}

	const result: ExerciseSection[] = [];
	sections.forEach((section, s) => {
		if (wholeSections.has(s)) {
			result.push(section);
			return;
		}
		const picked = pickedBySection.get(s);
		if (!picked || picked.size === 0) return;
		result.push({ ...section, items: section.items.filter((_, i) => picked.has(i)) });
	});
	return result;
}

/** Fisher-Yates with an injectable source, so tests are deterministic. */
function shuffle<T>(list: T[], random: () => number): void {
	for (let i = list.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[list[i], list[j]] = [list[j], list[i]];
	}
}

/** Total printable exercises across [sections]. */
export function countItems(sections: ExerciseSection[]): number {
	return sections.reduce((n, s) => n + s.items.length, 0);
}
