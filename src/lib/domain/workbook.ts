// A level's printable workbook: every exercise of one sub-level (A1.1 … C2.2)
// as a unit on paper — the lesson first, then the practice — with the answers
// upside down at the foot of each unit, as a printed workbook does it.
//
// It reads the lesson through buildLesson, so the paper and the screen teach
// the same rules with the same checks in the same order. Pure and seeded: the
// same course always prints the same booklet, which is what lets
// tool/gen-workbooks.mjs keep a stable PDF per level.

import type { Example, HelpTable, PopulatedCourse, Quiz, VocabularyQuiz } from '$lib/content/types';
import type { HelpTable as DerivedTable } from './help-table';
import { buildLesson, seededRandom, seededShuffle, type LessonWord } from './lesson';
import { sectionFor, type ExerciseSection } from './worksheet';

/** Practice items printed per grammar unit — enough to drill, few enough to fit. */
export const PRACTICE_PER_UNIT = 8;

/** Pictures on the level's "words in pictures" page: a four-by-four grid. */
export const PICTURES_PER_LEVEL = 16;

export interface WorkbookWord extends LessonWord {
	/** An id in static/img/, when the word has a picture. */
	image?: string;
}

export interface WorkbookRule {
	number: number;
	/** 'rule' | 'warning' | 'mnemonic' | 'exam'. */
	kind: string;
	title?: string;
	text: string;
	examples: Example[];
	trap?: string;
}

/** A multiple-choice question: a rule's check, or "which one is right?". */
export interface WorkbookCheck {
	/** The exercise number inside the unit. */
	n: number;
	eyebrow: string;
	question: string;
	options: string[];
	answer: string;
}

export interface WorkbookUnit {
	/** The unit number inside the level. */
	n: number;
	quizId: string;
	title: string;
	/** What the unit practises, for the eyebrow. */
	kindLabel: string;
	/** A picture of the unit's own — never the level's shared card art. */
	image?: string;
	hook: string;
	intro?: string;
	rules: WorkbookRule[];
	words: WorkbookWord[];
	context?: Example;
	checks: WorkbookCheck[];
	remember: string[];
	table?: HelpTable;
	derived?: DerivedTable;
	/** The exercise, already trimmed; numbered on from the last check. */
	practice: ExerciseSection | null;
	/** Where the practice numbering starts. */
	practiceFrom: number;
	/** Every answer in the unit, by exercise number. */
	answers: { n: number; text: string }[];
}

export interface WorkbookPicture {
	n: number;
	image: string;
	de: string;
	article?: string;
	/** Shown under the picture when it cannot stand alone. */
	en?: string;
}

export interface Workbook {
	courseId: string;
	courseName: string;
	level: string;
	/** The module name: "Erste Schritte". */
	title: string;
	/** The cover picture. */
	cover?: string;
	units: WorkbookUnit[];
	pictures: WorkbookPicture[];
}

/** The sub-levels that have a workbook, in course order. */
export function workbookLevels(course: PopulatedCourse): { level: string; title: string }[] {
	return course.nav.groups
		.filter((g) => g.type === 'questChain' && g.level)
		.map((g) => ({ level: g.level!, title: moduleTitle(g.title, g.level!) }));
}

/** "A1.1 · ERSTE SCHRITTE" → "Erste Schritte": no level code, no shouting. */
export function moduleTitle(groupTitle: string, level: string): string {
	const bare = groupTitle.replace(level, '').replace(/^[\s·:–-]+/, '').trim();
	if (bare !== bare.toUpperCase()) return bare;
	return bare.toLowerCase().replace(/(^|[\s/-])(\p{L})/gu, (_, sep: string, ch: string) => sep + ch.toUpperCase());
}

/** The PDF file name for a level, under static/workbooks/. */
export function workbookFile(courseId: string, level: string): string {
	return `${courseId}_${level.toLowerCase().replace(/\./g, '_')}.pdf`;
}

/** Which quizzes become units: the ones with a paper form. */
function printable(quiz: Quiz): boolean {
	if (quiz.status === 'placeholder') return false;
	return quiz.type === 'fillBlank' || quiz.type === 'reading';
}

const KIND_LABEL: Record<string, string> = {
	fillBlank: 'Grammar & words',
	reading: 'Reading',
	inlineCloze: 'Text work'
};

/** Shared card art (`card_grammar_a1_1`) repeats across a level; a unit shows only its own. */
function ownImage(quiz: Quiz): string | undefined {
	return quiz.image && !quiz.image.startsWith('card_') ? quiz.image : undefined;
}

/** A level's cover: its first reading scene, else any picture it has. */
function coverOf(quizzes: Quiz[]): string | undefined {
	return quizzes.find((q) => q.type === 'reading' && ownImage(q))?.image ?? quizzes.find((q) => q.image)?.image;
}

/** The workbook for one sub-level, or null when the course has no such level. */
export function buildWorkbook(course: PopulatedCourse, level: string): Workbook | null {
	const group = course.nav.groups.find((g) => g.type === 'questChain' && g.level === level);
	if (!group) return null;

	const quizzes = course.quizzes.filter((q) => q.level === level);
	const pictures = pictureLookup(course.quizzes);

	const units: WorkbookUnit[] = [];
	for (const quiz of quizzes) {
		if (!printable(quiz)) continue;
		const unit = unitFor(quiz, units.length + 1, pictures);
		if (unit) units.push(unit);
	}

	const deck = quizzes.find((q): q is VocabularyQuiz => q.type === 'vocabulary');

	return {
		courseId: course.id,
		courseName: course.name,
		level,
		title: moduleTitle(group.title, level),
		cover: coverOf(quizzes),
		units,
		pictures: picturePage(deck)
	};
}

/** One quiz as a unit: its lesson, its practice, its answers. */
function unitFor(quiz: Quiz, n: number, pictures: Map<string, string>): WorkbookUnit | null {
	const steps = buildLesson(quiz);
	const unit: WorkbookUnit = {
		n,
		quizId: quiz.id,
		title: quiz.type === 'reading' && quiz.passageTitle ? quiz.passageTitle : quiz.title,
		kindLabel: KIND_LABEL[quiz.type === 'reading' && 'inlineBlanks' in quiz ? 'inlineCloze' : quiz.type],
		image: ownImage(quiz),
		hook: quiz.title,
		rules: [],
		words: [],
		checks: [],
		remember: [],
		practice: null,
		practiceFrom: 1,
		answers: []
	};

	let next = 1;
	for (const step of steps) {
		switch (step.kind) {
			case 'hook':
				unit.hook = step.hook;
				unit.intro = step.more;
				break;
			case 'rule':
				unit.rules.push({
					number: step.number,
					kind: step.tip.kind ?? 'rule',
					title: step.tip.title,
					text: step.tip.text,
					examples: step.tip.examples ?? [],
					trap: step.tip.trap?.replace(/^E\d+\s*[—-]\s*/, '')
				});
				break;
			case 'check':
				// A listening check needs a voice; paper can't play one.
				if (step.check.listen) break;
				unit.checks.push({
					n: next++,
					eyebrow: step.check.eyebrow,
					question: step.check.question,
					options: step.check.options,
					answer: step.check.answer
				});
				break;
			case 'words':
				unit.words = step.words.map((w) => ({ ...w, image: pictureOf(pictures, w) }));
				break;
			case 'context':
				unit.context = step.context;
				break;
			case 'recap':
				unit.remember = step.remember;
				unit.table = step.table;
				unit.derived = step.derived;
				break;
		}
	}

	unit.practice = practiceFor(quiz);
	unit.practiceFrom = next;

	for (const check of unit.checks) {
		const letter = String.fromCharCode(0x61 + check.options.indexOf(check.answer));
		unit.answers.push({ n: check.n, text: letter });
	}
	unit.practice?.items.forEach((item, i) => {
		// A reading answer is "b)  the option"; the key needs only the letter.
		unit.answers.push({ n: next + i, text: unit.practice!.kind === 'reading' ? item.answer.slice(0, 1) : item.answer });
	});

	if (!unit.rules.length && !unit.practice?.items.length) return null;
	return unit;
}

/**
 * The unit's practice: a reading or a text keeps every question (they belong
 * to one passage); a sentence bank is trimmed to a seeded sample, kept in its
 * authored order so related sentences still sit together.
 */
function practiceFor(quiz: Quiz): ExerciseSection | null {
	const section = sectionFor(quiz, undefined, seededRandom(`${quiz.id}:sheet`));
	if (!section || !section.items.length) return null;
	if (section.kind !== 'cloze' || section.items.length <= PRACTICE_PER_UNIT) return section;
	const keep = new Set(seededShuffle(section.items.map((_, i) => i), `${quiz.id}:practice`).slice(0, PRACTICE_PER_UNIT));
	return { ...section, items: section.items.filter((_, i) => keep.has(i)) };
}

// ── Pictures ────────────────────────────────────────────────────────────────

const pictureKey = (de: string, article?: string) => `${article ?? ''}|${de}`;

/** Every pictured word in the course, from the vocabulary decks' cards. */
function pictureLookup(quizzes: Quiz[]): Map<string, string> {
	const map = new Map<string, string>();
	for (const quiz of quizzes) {
		if (quiz.type !== 'vocabulary') continue;
		for (const card of quiz.cards) {
			if (!card.image) continue;
			map.set(pictureKey(card.de, card.article), card.image);
			if (!map.has(pictureKey(card.de))) map.set(pictureKey(card.de), card.image);
		}
	}
	return map;
}

function pictureOf(pictures: Map<string, string>, word: LessonWord): string | undefined {
	return pictures.get(pictureKey(word.de, word.article)) ?? (word.article ? undefined : pictures.get(pictureKey(word.de)));
}

/**
 * The "words in pictures" page: nouns first (the article is half the
 * exercise), pictures that stand alone before the ones that need a nudge.
 */
function picturePage(deck: VocabularyQuiz | undefined): WorkbookPicture[] {
	if (!deck) return [];
	const seen = new Set<string>();
	const pictured = deck.cards.filter((card) => {
		if (!card.image || seen.has(card.image)) return false;
		seen.add(card.image);
		return true;
	});
	const rank = (c: (typeof pictured)[number]) => (c.imageHint ? 2 : 0) + (c.kind === 'noun' ? 0 : 1);
	return [...pictured]
		.sort((a, b) => rank(a) - rank(b))
		.slice(0, PICTURES_PER_LEVEL)
		.map((card, i) => ({
			n: i + 1,
			image: card.image!,
			de: card.de,
			article: card.article,
			en: card.imageHint ? card.en : undefined
		}));
}

/** What a level's card in the workbook list shows — cheap, no lesson building. */
export interface WorkbookCard {
	level: string;
	title: string;
	cover?: string;
	units: number;
}

export function workbookCards(course: PopulatedCourse): WorkbookCard[] {
	return workbookLevels(course).map(({ level, title }) => {
		const quizzes = course.quizzes.filter((q) => q.level === level);
		return {
			level,
			title,
			cover: coverOf(quizzes),
			units: quizzes.filter(printable).length
		};
	});
}
