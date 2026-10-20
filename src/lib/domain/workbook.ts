// A level's printable workbook: every exercise of one sub-level (A1.1 … C2.2)
// as a unit on paper — the lesson first, then the practice — with the answers
// upside down at the foot of each unit, as a printed workbook does it.
//
// It reads the lesson through buildLesson, so the paper and the screen teach
// the same rules with the same checks in the same order. Pure and seeded: the
// same course always prints the same booklet, which is what lets
// tool/gen-workbooks.mjs keep a stable PDF per level.
//
// Every exercise type has a paper form. What paper cannot do — play a voice,
// run the speaking tutor, deal a deck — the unit hands to the app through a
// QR code (`unit.app`, `unit.audio`), drawn by the book route.

import type {
	Example,
	HelpTable,
	LessonVisual,
	PopulatedCourse,
	Quiz,
	VocabularyQuiz
} from '$lib/content/types';
import type { HelpTable as DerivedTable } from './help-table';
import { buildLesson, seededRandom, seededShuffle, type LessonWord } from './lesson';
import { spokenPassage } from './spoken';
import { sectionFor, type ExerciseSection } from './worksheet';

/**
 * The levels whose workbook is good enough to offer. The generated workbooks
 * fell short on paper, so none is offered until its level has been redone
 * (the study companion, domain/companion): a level left out shows "work in
 * progress" wherever its PDF would be. Add a level here to offer it again.
 */
export const READY_WORKBOOKS: ReadonlySet<string> = new Set<string>(['A1.1']);

export function workbookReady(level: string): boolean {
	return READY_WORKBOOKS.has(level);
}

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
	/** The rule's diagram, drawn by LessonVisual. */
	visual?: LessonVisual;
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

/** A numbered line of German with its English, for phrases and dictations. */
export interface WorkbookLine {
	n: number;
	de: string;
	en?: string;
}

/**
 * The part of a unit that is not the lesson: what the exercise itself puts
 * on the page. A grammar or reading unit has none — its exercise is the
 * `practice` section.
 */
export type UnitExtra =
	| {
			kind: 'listening';
			title?: string;
			questions: { n: number; q: string; options: string[] }[];
			/** Printed in the answer key, never on the unit page. */
			transcript: string;
			translation?: string;
	  }
	| { kind: 'dictation'; lines: WorkbookLine[] }
	| { kind: 'phrases'; lines: WorkbookLine[] }
	| {
			kind: 'speaking';
			topic: string;
			material?: string;
			points: string[];
			criteria: string[];
			vocabulary: string[];
			minutes?: number;
	  }
	| { kind: 'writing'; topic: string; points: string[]; criteria: string[]; vocabulary: string[]; charMax?: number }
	| { kind: 'hunt'; scene: string; spots: { n: number; de: string; article?: string; en?: string }[] }
	| { kind: 'deck'; groups: { title: string; cards: WorkbookPicture[] }[] };

export interface WorkbookUnit {
	/** The unit number inside the level. */
	n: number;
	quizId: string;
	/** The exercise type, for the page layout. */
	type: Quiz['type'] | 'inlineCloze';
	title: string;
	/** What the unit practises, for the eyebrow. */
	kindLabel: string;
	/** A picture of the unit's own — never the level's shared card art. */
	image?: string;
	hook: string;
	intro?: string;
	/** For a topic met before: what carries over, and what is new. */
	recall?: { known: string; today: string };
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
	/** The exercise's own page content, when it is not a practice section. */
	extra?: UnitExtra;
	/**
	 * The German the app can read aloud for this unit, in page order — what
	 * the unit's audio QR plays. Empty when there is nothing to hear.
	 */
	audio: string[];
	/** Longer answers that belong in the book's key rather than under the unit. */
	key?: { label: string; lines: string[] };
}

/**
 * What a unit says differently on paper. The app's lesson talks about taps,
 * runs and replays; the book has lines, a key at the back and a QR code. Each
 * entry replaces the authored text for that unit only; everything it leaves
 * out stays as the app has it. Authored in assets/content/book/<course>/.
 */
export interface PaperUnit {
	hook?: string;
	intro?: string;
	/** By the tip's index in the authored `tips` list. */
	tips?: Record<string, { title?: string; text?: string; trap?: string }>;
	/** Replaces the whole "remember" list. */
	remember?: string[];
}

export type PaperOverrides = Record<string, PaperUnit>;

export interface WorkbookPicture {
	n: number;
	image?: string;
	de: string;
	article?: string;
	plural?: string;
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

/** Which quizzes become units: every live exercise has a paper form. */
function printable(quiz: Quiz): boolean {
	return quiz.status !== 'placeholder';
}

const KIND_LABEL: Record<string, string> = {
	fillBlank: 'Grammar & words',
	reading: 'Reading',
	inlineCloze: 'Text work',
	listening: 'Listening',
	dictation: 'Dictation',
	speakRepeat: 'Speaking · repeat',
	speaking: 'Speaking · conversation',
	writing: 'Writing',
	vocabulary: 'Vocabulary',
	suchbild: 'Picture hunt'
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
export function buildWorkbook(course: PopulatedCourse, level: string, paper: PaperOverrides = {}): Workbook | null {
	const group = course.nav.groups.find((g) => g.type === 'questChain' && g.level === level);
	if (!group) return null;

	const quizzes = course.quizzes.filter((q) => q.level === level);
	const pictures = pictureLookup(course.quizzes);
	const titles = new Map(course.quizzes.map((q) => [q.id, q.title]));

	const units: WorkbookUnit[] = [];
	for (const quiz of quizzes) {
		if (!printable(quiz)) continue;
		const unit = unitFor(quiz, units.length + 1, pictures, titles, paper[quiz.id]);
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
function unitFor(
	quiz: Quiz,
	n: number,
	pictures: Map<string, string>,
	titles: Map<string, string>,
	paper?: PaperUnit
): WorkbookUnit | null {
	const steps = buildLesson(quiz);
	const inline = quiz.type === 'reading' && 'inlineBlanks' in quiz;
	const type = inline ? 'inlineCloze' : quiz.type;
	const unit: WorkbookUnit = {
		n,
		quizId: quiz.id,
		type,
		title: quiz.type === 'reading' && quiz.passageTitle ? quiz.passageTitle : quiz.title,
		kindLabel: KIND_LABEL[type] ?? 'Exercise',
		image: ownImage(quiz),
		hook: quiz.title,
		rules: [],
		words: [],
		checks: [],
		remember: [],
		practice: null,
		practiceFrom: 1,
		answers: [],
		audio: []
	};

	let next = 1;
	for (const step of steps) {
		switch (step.kind) {
			case 'hook':
				unit.hook = step.hook;
				unit.intro = step.more;
				unit.recall = step.recall;
				break;
			case 'rule':
				unit.rules.push({
					number: step.number,
					kind: step.tip.kind ?? 'rule',
					title: step.tip.title,
					text: step.tip.text,
					examples: step.tip.examples ?? [],
					trap: step.tip.trap?.replace(/^E\d+\s*[—-]\s*/, ''),
					visual: step.tip.visual
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

	if (paper) onPaper(unit, paper);

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
	next += unit.practice?.items.length ?? 0;

	addExtra(quiz, unit, next, pictures, titles);

	if (!unit.rules.length && !unit.practice?.items.length && !unit.extra) return null;
	return unit;
}

/** The unit's prose as the book says it: taps become lines, runs become the key at the back. */
function onPaper(unit: WorkbookUnit, paper: PaperUnit) {
	if (paper.hook) unit.hook = paper.hook;
	if (paper.intro) unit.intro = paper.intro;
	if (paper.remember) unit.remember = paper.remember;
	for (const [index, tip] of Object.entries(paper.tips ?? {})) {
		const rule = unit.rules[Number(index)];
		if (!rule) continue;
		if (tip.title) rule.title = tip.title;
		if (tip.text) rule.text = tip.text;
		if (tip.trap) rule.trap = tip.trap;
	}
}

/** The exercise's own page content for the types that have no practice section. */
function addExtra(quiz: Quiz, unit: WorkbookUnit, next: number, pictures: Map<string, string>, titles: Map<string, string>) {
	switch (quiz.type) {
		case 'reading':
			if (!('inlineBlanks' in quiz)) unit.audio = [spokenPassage(quiz.passage)];
			return;
		case 'listening': {
			const questions = quiz.questions.map((q, i) => ({ n: next + i, q: q.question, options: q.options }));
			quiz.questions.forEach((q, i) => {
				unit.answers.push({ n: next + i, text: String.fromCharCode(0x61 + q.correctIndex) });
			});
			unit.extra = {
				kind: 'listening',
				title: quiz.passageTitle,
				questions,
				transcript: quiz.passage,
				translation: quiz.passageTranslation
			};
			unit.audio = [spokenPassage(quiz.passage)];
			unit.key = { label: 'Transcript', lines: quiz.passage.split(/\n+/) };
			return;
		}
		case 'dictation': {
			const lines = quiz.items.map((item, i) => ({ n: next + i, de: item.text, en: item.translation }));
			unit.extra = { kind: 'dictation', lines };
			unit.audio = lines.map((l) => l.de);
			unit.key = { label: 'The sentences', lines: lines.map((l) => `${l.n}  ${l.de}`) };
			return;
		}
		case 'speakRepeat': {
			const lines = quiz.phrases.map((p, i) => ({ n: next + i, de: p.text, en: p.translation }));
			unit.extra = { kind: 'phrases', lines };
			unit.audio = lines.map((l) => l.de);
			return;
		}
		case 'speaking': {
			const s = quiz.speaking;
			unit.extra = {
				kind: 'speaking',
				topic: s.topic,
				material: typeof s.material === 'string' ? s.material : undefined,
				points: s.practisePoints ?? [],
				criteria: s.scoringCriteria ?? [],
				vocabulary: s.targetVocabulary ?? [],
				minutes: s.durationMinutes
			};
			return;
		}
		case 'writing': {
			const w = quiz.writing;
			unit.extra = {
				kind: 'writing',
				topic: w.topic,
				points: w.practisePoints ?? [],
				criteria: w.scoringCriteria ?? [],
				vocabulary: w.targetVocabulary ?? [],
				charMax: w.charMax
			};
			return;
		}
		case 'suchbild': {
			const spots = quiz.spots.map((s, i) => ({ n: next + i, de: s.de, article: s.article, en: s.en }));
			unit.extra = { kind: 'hunt', scene: quiz.scene, spots };
			unit.audio = quiz.spots.map((s) => `${s.article} ${s.de}`);
			unit.key = { label: 'The objects', lines: spots.map((s) => `${s.n}  ${s.article ? s.article + ' ' : ''}${s.de}`) };
			return;
		}
		case 'vocabulary': {
			unit.extra = { kind: 'deck', groups: deckGroups(quiz, titles) };
			return;
		}
	}
}

/** The deck's cards grouped by the unit they came from, in unit order. */
function deckGroups(deck: VocabularyQuiz, titles: Map<string, string>): { title: string; cards: WorkbookPicture[] }[] {
	const groups = new Map<string, WorkbookPicture[]>();
	let n = 1;
	for (const card of deck.cards) {
		const title = titles.get(card.sourceQuizId ?? '') ?? 'More words';
		const list = groups.get(title) ?? [];
		list.push({ n: n++, image: card.image, de: card.de, article: card.article, plural: card.plural, en: card.en });
		groups.set(title, list);
	}
	return [...groups].map(([title, cards]) => ({ title, cards }));
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
