// The content contract, mirrored from the Dart models that generate it
// (`tool/generate_content.dart` → `assets/content/**`). These types are the
// seam between the two apps: both read the same JSON, so content authored for
// the Flutter build works here unchanged.
//
// `type` is the discriminator on a quiz. Keep these in sync with
// `lib/models/content/quiz.dart` until the Dart side is retired.

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

/** One card in a quiz's Help Memory panel. */
export interface HelpTip {
	title?: string;
	text: string;
	kind?: string;
}

export interface QuizHelp {
	intro?: string;
	tips?: HelpTip[];
}

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
}

// -- fillBlank --------------------------------------------------------------

export interface QuizSubject {
	key: string;
	display: string;
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
