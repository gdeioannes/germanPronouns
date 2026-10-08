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
	| 'speaking'
	| 'vocabulary'
	| 'suchbild';

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
	/** The words in `de` the example exists to show — highlighted in the lesson. */
	focus?: string[];
}

/** A one-question check the lesson asks straight after a rule card. */
export interface HelpCheck {
	/** The question, in English; a `____` marks a gap in a German sentence. */
	q: string;
	/** Two to four answers, the right one among them; shown in a fixed shuffle. */
	options: string[];
	/** The right answer, exactly as it appears in `options`. */
	answer: string;
	/** Why — shown once the learner has answered, right or wrong. */
	why?: string;
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
	/** The lesson's check on this rule. */
	check?: HelpCheck;
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
	/** The idea in one sentence — the lesson's opening line; `intro` sits behind it. */
	hook?: string;
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
	/** Layer 7: a one-line exam note — skill exercises only, no task numbers. */
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
	/**
	 * Never fold umlauts/ß when checking, even in relaxed mode. Set on quizzes
	 * whose target IS the umlaut (Konjunktiv II, comparatives, umlaut plurals,
	 * vowel-change verbs), where "hatte" for "hätte" is the error being drilled.
	 */
	strictDiacritics?: boolean;
	/**
	 * A scene for the quiz: an id in static/img/, stamped by
	 * tool/gen-images.mjs. A passage quiz gets its own scene; a speaking
	 * exercise borrows one from its level, to be described to the tutor.
	 */
	image?: string;
	/** What the scene shows, in words, for a tutor who cannot see it. */
	imageDescription?: string;
	/**
	 * A one-off game played instead of the type's usual exercise. The quiz
	 * keeps its type, so its saved progress, worksheets and workbook carry on
	 * unchanged. Only `numberTasks` exists: the first quiz's task menu
	 * (quiz/NumberTasks — the call task and the number board).
	 */
	game?: 'numberTasks';
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
	/**
	 * Word tiles: the learner builds the gap from these instead of typing it,
	 * for items whose point is WHERE the words go (verb second, verb last,
	 * TeKaMoLo). Every accepted answer must be buildable from them; any tile
	 * no answer uses is a distractor. The sentence has exactly one gap.
	 */
	tiles?: string[];
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
	/** An unscored teach-first pass before the scored part (beginners). */
	scaffolded?: boolean;
}

export interface SpeakingQuiz extends QuizBase {
	type: 'speaking';
	speaking: SpeakingExercise;
}

// -- vocabulary (flip cards) -------------------------------------------------

/**
 * One flip card. A `noun` is always learnt with its article, so the write
 * mode demands it; a `name` (country, city, letter) is capitalised but takes
 * none; a `word` is anything else — verbs, adjectives, numbers, phrases.
 */
export interface VocabCard {
	de: string;
	en: string;
	kind: 'noun' | 'name' | 'word';
	article?: string;
	plural?: string;
	/** A note shown on the back, never demanded: "fährt", "+ Akk", "gehen". */
	note?: string;
	/** Synonyms the write mode also accepts, in their full form ("ungehalten", "die Position"). */
	also?: string[];
	/** The quiz whose Help Memory this word came from. */
	sourceQuizId: string;
	/**
	 * A picture of the word: an id in static/img/, stamped by
	 * tool/gen-images.mjs from assets/images/manifest.json.
	 */
	image?: string;
	/**
	 * The picture needs the English beside it: a man with a boy is "father"
	 * or "son" depending on which one is asked about, and an hourglass is
	 * "time" only with a nudge. An obvious picture (apple, dog) stands alone.
	 */
	imageHint?: boolean;
}

/**
 * A sub-level's vocabulary deck, built by tool/build-vocabulary.mjs from the
 * words its quizzes carry. Progress is the streak, as for fill-blanks; the
 * per-word record lives in the vocab store, not here.
 */
export interface VocabularyQuiz extends QuizBase {
	type: 'vocabulary';
	cards: VocabCard[];
}

// -- suchbild (find it in the picture) ---------------------------------------

/**
 * One thing to find in a Suchbild room: a noun and where it is drawn, as a
 * box in percent of the picture. Boxes may overlap (a jar on a window sill):
 * the later spot is on top, so small things go after the big ones they sit on.
 */
export interface SuchbildSpot {
	de: string;
	article: 'der' | 'die' | 'das';
	en: string;
	plural?: string;
	x: number;
	y: number;
	w: number;
	h: number;
	/** More places the same thing is drawn (blinds on two floors): any one counts. */
	also?: { x: number; y: number; w: number; h: number }[];
}

/**
 * A picture hunt, the flashcard deck's twin: one room picture, and a run of
 * "Wo ist der Heizkörper?" — tap it. Once a run is passed the prompts turn
 * English-only and a find is followed by der / die / das. Progress is the
 * streak, as for the deck.
 */
export interface SuchbildQuiz extends QuizBase {
	type: 'suchbild';
	/** The room: an id in static/img/, shipped at 1024px for tapping. */
	scene: string;
	/** The picture's width and height, so the frame keeps its shape before it loads. */
	sceneSize: [number, number];
	/** What the room shows, for screen readers. */
	sceneAlt: string;
	spots: SuchbildSpot[];
}

export type Quiz =
	| FillBlankQuiz
	| VocabularyQuiz
	| SuchbildQuiz
	| ReadingQuiz
	| InlineClozeQuiz
	| ListeningQuiz
	| DictationQuiz
	| SpeakRepeatQuiz
	| SpeakingQuiz;

export interface Gating {
	progressionUnlockLaps: number;
	questUnlockLaps: number;
}

/** One course with its nav and every quiz — the per-course bundle. */
export interface PopulatedCourse extends CourseCard {
	gating?: Gating;
	nav: NavLayout;
	quizzes: Quiz[];
}

/**
 * What a listing needs to know about a quiz — its identity, kind and place in
 * the ladder — without the exercise itself. Every full `Quiz` is one of these
 * too, so anything written against the summary takes a bundle unchanged.
 */
export type QuizSummary = Pick<
	QuizBase,
	'id' | 'type' | 'title' | 'storageKeyPrefix' | 'level' | 'status' | 'covers' | 'image'
>;

/** A course's card plus how it gates progress: what a single quiz page needs. */
export interface CourseInfo extends CourseCard {
	gating?: Gating;
}

/**
 * The course with its nav and every quiz's summary — a few kilobytes rather
 * than the whole bundle — for the pages that list exercises. Serialised into
 * the prerendered HTML by the server loads, so the browser never fetches the
 * bundle to draw a list.
 */
export interface CourseSummary extends CourseInfo {
	nav: NavLayout;
	quizzes: QuizSummary[];
}

// -- syllabus ---------------------------------------------------------------

/** One structure a module must teach, as the official sources list it. */
export interface SyllabusStructure {
	id: string;
	label: string;
	/** Where the official sources put it, e.g. "A1 (official structure inventory)". */
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
