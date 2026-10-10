// The forum's vocabulary: what a topic is, what kinds there are, and the
// small pure rules the UI and the Firestore seam share. Nothing here touches
// the network, so all of it is unit-testable (see forum.test.ts).
//
// The forum exists for one reason first: a learner mid-quiz who meets a wrong
// answer key, a typo or a broken clip can say so in two taps, with the
// exercise and the question already filled in. Everything else — questions
// about German, ideas — hangs off the same structure.

/** The boards. `report` is the one the in-quiz button posts to. */
export type ForumCategory = 'report' | 'question' | 'idea' | 'general';

export const FORUM_CATEGORIES: { id: ForumCategory; label: string; blurb: string }[] = [
	{ id: 'report', label: 'Problem reports', blurb: 'A wrong answer, a typo, a clip that will not play.' },
	{ id: 'question', label: 'Questions about German', blurb: 'Why is it "dem" here? Ask, and help others.' },
	{ id: 'idea', label: 'Ideas and requests', blurb: 'What should the course do next?' },
	{ id: 'general', label: 'General', blurb: 'Everything else.' }
];

export function categoryLabel(id: string | null | undefined): string {
	return FORUM_CATEGORIES.find((c) => c.id === id)?.label ?? 'General';
}

export function isCategory(value: unknown): value is ForumCategory {
	return FORUM_CATEGORIES.some((c) => c.id === value);
}

/**
 * What exactly is wrong — the subject the report form asks for. Short ids go
 * in the document; the labels are what the learner picks from.
 */
export type ReportKind =
	| 'wrong_answer'
	| 'bad_key'
	| 'typo'
	| 'unclear'
	| 'notes'
	| 'audio'
	| 'picture'
	| 'translation'
	| 'broken'
	| 'other';

export const REPORT_KINDS: { id: ReportKind; label: string }[] = [
	{ id: 'wrong_answer', label: 'My answer was right but marked wrong' },
	{ id: 'bad_key', label: 'The expected answer is wrong' },
	{ id: 'typo', label: 'Typo or grammar mistake in the text' },
	{ id: 'unclear', label: 'The question is unclear or ambiguous' },
	{ id: 'notes', label: 'The study notes or explanation are wrong or confusing' },
	{ id: 'audio', label: 'Audio problem (missing, wrong, mispronounced)' },
	{ id: 'picture', label: 'Picture problem' },
	{ id: 'translation', label: 'Translation or word help is wrong' },
	{ id: 'broken', label: "Something doesn't work (technical)" },
	{ id: 'other', label: 'Something else' }
];

export function reportKindLabel(id: string | null | undefined): string {
	return REPORT_KINDS.find((k) => k.id === id)?.label ?? 'Problem';
}

export function isReportKind(value: unknown): value is ReportKind {
	return REPORT_KINDS.some((k) => k.id === value);
}

/** Open until someone answers; `fixed` once the content has been corrected. */
export type ThreadStatus = 'open' | 'answered' | 'fixed';

export const STATUS_LABELS: Record<ThreadStatus, string> = {
	open: 'Open',
	answered: 'Answered',
	fixed: 'Fixed'
};

/**
 * Which question the learner was on when they pressed "Report a problem".
 * Every quiz component reports it as it moves; for a shuffled drill the number
 * is the item's place in the authored list, so it points at one line of
 * content rather than at "the seventh thing I happened to be dealt".
 */
export interface QuestionRef {
	/** 1-based. */
	number: number;
	total: number;
	/** The prompt, sentence or word, trimmed for the report. */
	text: string;
}

/** Where a report points. Everything but the course is optional. */
export interface ReportTarget {
	courseId: string;
	courseName?: string;
	quizId?: string;
	quizTitle?: string;
	quizType?: string;
	level?: string;
	question?: QuestionRef | null;
}

export interface ForumThread {
	id: string;
	category: ForumCategory;
	title: string;
	body: string;
	authorUid: string;
	authorName: string;
	/** Epoch ms, written by the client (the same clock the progress sync uses). */
	createdAt: number;
	/** Bumped by every reply, so "latest activity" is one field to sort on. */
	updatedAt: number;
	replyCount: number;
	lastReplyAt: number | null;
	lastReplyName: string | null;
	status: ThreadStatus;
	/** The author wants to hear about replies. Off = "don't notify me". */
	notify: boolean;
	likeCount: number;
	// -- the report's target, when it is one --
	courseId?: string;
	quizId?: string;
	quizTitle?: string;
	quizType?: string;
	level?: string;
	questionNumber?: number;
	questionText?: string;
	reportKind?: ReportKind;
}

export interface ForumPost {
	id: string;
	threadId: string;
	body: string;
	authorUid: string;
	authorName: string;
	createdAt: number;
	likeCount: number;
}

/** The learner's forum profile: a name to post under, and what they have read. */
export interface ForumProfile {
	name: string;
	/** threadId → the replyCount the learner had seen when they last opened it. */
	seen: Record<string, number>;
	updatedAt: number;
}

export const LIMITS = {
	title: 140,
	body: 4000,
	name: 40
} as const;

/** Trims and bounds a piece of text; empty when nothing usable is left. */
export function clip(text: string, max: number): string {
	return text.replace(/\s+/g, ' ').trim().slice(0, max);
}

/**
 * The thread title a report gets, so the list reads "Expected answer is wrong
 * — Dativ oder Akkusativ? (Q 7)" without the learner typing a headline.
 */
export function reportTitle(kind: ReportKind, target: ReportTarget): string {
	const where = target.quizTitle ?? target.quizId ?? target.courseName ?? 'the course';
	const q = target.question ? ` (Q ${target.question.number})` : '';
	return clip(`${shortKind(kind)} — ${where}${q}`, LIMITS.title);
}

/** The subject, short enough to lead a title. */
function shortKind(kind: ReportKind): string {
	switch (kind) {
		case 'wrong_answer':
			return 'Right answer marked wrong';
		case 'bad_key':
			return 'Expected answer is wrong';
		case 'typo':
			return 'Typo in the text';
		case 'unclear':
			return 'Unclear question';
		case 'notes':
			return 'Study notes';
		case 'audio':
			return 'Audio problem';
		case 'picture':
			return 'Picture problem';
		case 'translation':
			return 'Translation';
		case 'broken':
			return 'Something is broken';
		default:
			return 'Problem';
	}
}

/**
 * The body a report is filed with: what the learner wrote, then the place the
 * app knows about — kept in the text as well as in the fields so a reader of
 * the thread sees it without the UI having to rebuild it.
 */
export function reportBody(note: string, target: ReportTarget): string {
	const lines: string[] = [];
	const text = clip(note, LIMITS.body - 600);
	if (text) lines.push(text, '');
	lines.push('—');
	if (target.quizTitle) lines.push(`Exercise: ${target.quizTitle}${target.level ? ` (${target.level})` : ''}`);
	if (target.quizId) lines.push(`Link: /course/${target.courseId}/quiz/${target.quizId}`);
	if (target.question) {
		lines.push(`Question ${target.question.number} of ${target.question.total}`);
		if (target.question.text) lines.push(`“${clip(target.question.text, 200)}”`);
	}
	return lines.join('\n').slice(0, LIMITS.body);
}

/**
 * A name to post under before the learner picks one: the part of the address
 * before the @, which is what they would type anyway. Never the whole address
 * — the forum is public, their inbox is not.
 */
export function defaultName(email: string | null | undefined): string {
	const local = (email ?? '').split('@')[0] ?? '';
	const cleaned = local.replace(/[^\p{L}\p{N}._-]/gu, '').slice(0, LIMITS.name);
	return cleaned || 'Learner';
}

/** `true` when the name is something another learner can read. */
export function validName(name: string): boolean {
	const n = name.trim();
	return n.length >= 2 && n.length <= LIMITS.name && !n.includes('@');
}

/**
 * The threads the author has not seen the latest reply on. A thread with
 * `notify` off never counts — that is what the checkbox means.
 */
export function unreadThreads(mine: ForumThread[], seen: Record<string, number>): ForumThread[] {
	return mine.filter((t) => t.notify && t.replyCount > 0 && t.replyCount > (seen[t.id] ?? 0));
}

/** "just now", "5 min ago", "3 days ago", then a date. */
export function ago(at: number | null | undefined, now = Date.now()): string {
	if (!at) return '';
	const s = Math.max(0, Math.round((now - at) / 1000));
	if (s < 45) return 'just now';
	const m = Math.round(s / 60);
	if (m < 60) return `${m} min ago`;
	const h = Math.round(m / 60);
	if (h < 24) return `${h} hour${h === 1 ? '' : 's'} ago`;
	const d = Math.round(h / 24);
	if (d < 14) return `${d} day${d === 1 ? '' : 's'} ago`;
	return new Date(at).toLocaleDateString(undefined, { day: 'numeric', month: 'short', year: 'numeric' });
}

/** Case-insensitive match on the title, body, exercise name and author. */
export function matchesSearch(thread: ForumThread, query: string): boolean {
	const q = query.trim().toLowerCase();
	if (!q) return true;
	const words = q.split(/\s+/);
	const hay = `${thread.title} ${thread.body} ${thread.quizTitle ?? ''} ${thread.authorName}`.toLowerCase();
	return words.every((w) => hay.includes(w));
}

/** Removes `undefined` values: Firestore rejects them, and reports leave many fields empty. */
export function compact<T extends Record<string, unknown>>(data: T): T {
	const out: Record<string, unknown> = {};
	for (const [k, v] of Object.entries(data)) if (v !== undefined) out[k] = v;
	return out as T;
}
