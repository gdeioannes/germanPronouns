// The content contract: the shape of the JSON in `assets/content/**`, which
// is where every exercise lives. Authored content that does not match these
// types fails the build, because every route is prerendered.
//
// `type` is the discriminator on a quiz. The names are the ones the Flutter
// build wrote, and the bundles still carry them, so they are not free to
// rename.

export type QuizType =
	| 'fillBlank'
	| 'reading'
	| 'listening'
	| 'dictation'
	| 'speakRepeat'
	| 'speaking';

export type NavGroupType = 'quizzes' | 'questChain' | 'nounChain' | 'links';

/** A course as listed on the catalog page — card data only, no quizzes. */
export interface CourseCard {
	id: string;
	name: string;
	tagline: string;
	/** Emoji flag of the language the learner already speaks. */
	speakFlag: string;
	/** Emoji flag of the language being learned. */
	learnFlag: string;
	uiLang: string;
	/** BCP-47 tag of the learned language, e.g. `de-DE` — also the TTS voice. */
	learnLocale: string;
	goal: string;
	level: string;
	version: string;
}

export interface Catalog {
	version: string;
	defaultCourseId: string;
	courses: CourseCard[];
}

export interface NavItem {
	ref: string;
	titleOverride?: string;
	hidden?: boolean;
}

export interface NavGroup {
	id: string;
	title: string;
	type: NavGroupType;
	/** CEFR sub-level for a quest chain group, e.g. `A1.1`. */
	level?: string;
	gated?: boolean;
	items?: NavItem[];
}

export interface NavLayout {
	groups: NavGroup[];
}

/** A German sentence with its English underneath. */
export interface Example {
	de: string;
	en: string;
}

/** One rule card in a quiz's Help Memory panel. */
export interface HelpTip {
	title?: string;
	text: string;
	/** 'rule' | 'mnemonic' | 'warning' | 'exam' — colours the card. */
	kind?: string;
	/** Two or three examples; the rule is not learnt from the statement alone. */
	examples?: Example[];
	/** The trap for English speakers — an E# id from the contrastive spine, or plain text. */
	trap?: string;
}

/** An authored reference table, for quizzes with no grid to derive one from. */
export interface HelpTable {
	caption?: string;
	columns: string[];
	rows: { cells: string[]; gender?: string }[];
}

export interface HelpVocab {
	de: string;
	article?: string;
	plural?: string;
	en: string;
}

export interface HelpMistake {
	wrong: string;
	right: string;
	why: string;
}

/**
 * The Help Memory — the "How it works" panel — in the seven layers the content
 * plan (docs/content_master_plan.md §4) defines. Every field is optional in the
 * type so older content still validates; the content gate test decides how
 * much a given module's quizzes must carry.
 */
export interface QuizHelp {
	/** Layer 1: the idea, in plain English. */
	intro?: string;
	/** Layer 2: rule cards. */
	tips?: HelpTip[];
	/** Layer 3: an authored table; grid quizzes derive theirs instead. */
	table?: HelpTable;
	/** Layer 4: the words this exercise needs. */
	vocab?: HelpVocab[];
	/** Layer 5: how to remember it. */
	remember?: string[];
	/** Layer 6: a short text using the structure, read aloud. */
	context?: Example;
	/** Layer 7: which exam task this feeds. */
	exam?: string;
	/** The errors English speakers make on this item. */
	mistakes?: HelpMistake[];
	/** Tint the reference table's rows by noun gender. */
	colorByGender?: boolean;
}

/**
 * A placeholder quiz has its Help Memory authored in full and a minimal
 * exercise behind it — the content is real, the drill is still to be built.
 */
export type QuizStatus = 'live' | 'placeholder';

/** Fields every quiz carries, whatever its `type`. */
export interface QuizBase {
	id: string;
	type: QuizType;
	title: string;
	/**
	 * Prefix for this quiz's saved progress keys. Immutable once shipped —
	 * changing it orphans a learner's scores and streaks.
	 */
	storageKeyPrefix: string;
	level?: string;
	category?: string;
	promptLabel?: string;
	subjectsLabel?: string;
	subjectColumnLabel?: string;
	help?: QuizHelp;
	/** Absent means live. */
	status?: QuizStatus;
	/** Syllabus structure ids this quiz teaches — what the coverage gate counts. */
	covers?: string[];
}

// -- fillBlank --------------------------------------------------------------

export interface QuizSubject {
	key: string;
	display: string;
	/** The English meaning, shown in the Help Memory's reference table. */
	english?: string;
	/** 'm' | 'f' | 'n' for nouns; absent for everything else. */
	gender?: string;
}

export interface QuizCategory {
	label: string;
	group: string;
	values: string[];
}

export interface QuizSentence {
	subjectKey: string;
	categoryLabel: string;
	/** The prompt, with `____` marking the blank(s). */
	sentence: string;
	acceptedAnswers: string[];
	hint?: string;
	english?: string;
}

export interface FillBlankQuiz extends QuizBase {
	type: 'fillBlank';
	subjects: QuizSubject[];
	categories: QuizCategory[];
	/** Authored sentence bank. Empty when the quiz is template-driven. */
	sentences?: QuizSentence[];
	/** Generator templates, keyed by category label, using `{subject}`. */
	sentenceTemplates?: Record<string, string[]>;
}

// -- reading / listening (same question shape) ------------------------------

export interface PassageQuestion {
	question: string;
	options: string[];
	correctIndex: number;
	explanation?: string;
	questionTranslation?: string;
	optionsTranslation?: string[];
}

export interface ReadingQuiz extends QuizBase {
	type: 'reading';
	passageTitle: string;
	passage: string;
	passageTranslation?: string;
	questions: PassageQuestion[];
}

/** One typed gap inside a big-text passage. */
export interface InlineBlank {
	kind: 'input' | 'select';
	answer: string;
	/** Extra spellings that also count (e.g. "heisse" for "heiße"). */
	accepted?: string[];
	hint?: string;
	/** Choices, when `kind` is 'select'. */
	options?: string[];
}

/**
 * The "big text" cloze. It reuses `type: 'reading'` in the bundle rather than
 * having a type of its own, and is told apart by carrying `inlineBlanks` and
 * an `inlineTemplate` (with `{{n}}` markers) instead of `questions`.
 */
export interface InlineClozeQuiz extends QuizBase {
	type: 'reading';
	passageTitle: string;
	passage: string;
	passageTranslation?: string;
	inlineTemplate: string;
	inlineBlanks: InlineBlank[];
}

/** Narrows a reading-typed quiz to the inline-cloze variant. */
export function isInlineCloze(
	quiz: ReadingQuiz | InlineClozeQuiz
): quiz is InlineClozeQuiz {
	return Array.isArray((quiz as InlineClozeQuiz).inlineBlanks);
}

export interface ListeningQuiz extends QuizBase {
	type: 'listening';
	passageTitle: string;
	passage: string;
	passageTranslation?: string;
	questions: PassageQuestion[];
	voiceGender?: string;
}

// -- dictation / speakRepeat ------------------------------------------------

export interface SpokenLine {
	id: string;
	text: string;
	translation?: string;
}

export interface DictationQuiz extends QuizBase {
	type: 'dictation';
	items: SpokenLine[];
}

export interface SpeakRepeatQuiz extends QuizBase {
	type: 'speakRepeat';
	phrases: SpokenLine[];
}

// -- speaking ---------------------------------------------------------------

export interface SpeakingExercise {
	topic: string;
	practisePoints: string[];
	scoringCriteria: string[];
	targetVocabulary?: string[];
	priorKnowledge?: string[];
	mode?: string;
	durationMinutes?: number;
	minExchanges?: number;
	passScore?: number;
	material?: unknown;
}

export interface SpeakingQuiz extends QuizBase {
	type: 'speaking';
	speaking: SpeakingExercise;
}

export type Quiz =
	| FillBlankQuiz
	| ReadingQuiz
	| InlineClozeQuiz
	| ListeningQuiz
	| DictationQuiz
	| SpeakRepeatQuiz
	| SpeakingQuiz;

/** One course with its nav and every quiz — the per-course bundle. */
export interface PopulatedCourse extends CourseCard {
	gating?: { progressionUnlockLaps: number; questUnlockLaps: number };
	nav: NavLayout;
	quizzes: Quiz[];
}

// -- syllabus ---------------------------------------------------------------

/** One structure a module must teach, as the official sources list it. */
export interface SyllabusStructure {
	id: string;
	label: string;
	/** Where the official sources put it, e.g. "A1 (Goethe/telc inventory)". */
	official?: string;
	/** Free text: what a learner can do with it. */
	note?: string;
}

/** One sub-level's syllabus — the learner-facing master table for a module. */
export interface SyllabusModule {
	level: string;
	title: string;
	subtitle?: string;
	canDo: string[];
	themes: string[];
	structures: SyllabusStructure[];
	/** The exam facts a learner should know for this module. */
	exam?: string[];
	/**
	 * When true, the coverage gate test fails the build unless every structure
	 * is covered by at least one quiz at this level and every quiz meets the
	 * full Help Memory standard. Flipped module by module as authoring lands.
	 */
	complete: boolean;
}

export interface CourseSyllabus {
	courseId: string;
	modules: SyllabusModule[];
}
