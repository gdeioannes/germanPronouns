// The literature shelf: classics in the original German, annotated for
// English-speaking learners. Each entry is a book built by its own tool
// (tool/kafka-pdf.py for the first) whose free PDF is served from
// static/books/literature/. The /literature page and the home page's offer
// both read this list, so a new book is one entry here.

export interface LiteratureBook {
	id: string;
	author: string;
	title: string;
	/** The English title, as readers know it. */
	en: string;
	year: number;
	level: string;
	/** One paragraph on the story, for someone who has not read it. */
	blurb: string;
	/** What this edition adds, one line each. */
	inside: string[];
	pdf: { href: string; pages: number; megabytes: number };
	cover: string;
	/** The book read online, stage by stage, when it has web pages. */
	read?: string;
}

export const LITERATURE: LiteratureBook[] = [
	{
		id: 'kafka-verwandlung',
		author: 'Franz Kafka',
		title: 'Die Verwandlung',
		en: 'The Metamorphosis',
		year: 1915,
		level: 'B1–B2',
		blurb:
			'One morning a travelling salesman wakes up as a giant insect, and his first worry is the train he has missed. Short, gripping and darkly funny: the classic first novella for learners of German.',
		inside: [
			'The complete original text, in twelve reading stages of about 20 minutes',
			'855 words explained in the margin, beside the line they are on',
			'76 notes on grammar, idioms and Prague German at the foot of the page',
			'A guide to the 1917 spelling, so daß and mußte never stop you',
			'A dictionary at the back, A to Z, with the page that explains each word'
		],
		pdf: { href: '/books/literature/kafka_die_verwandlung.pdf', pages: 113, megabytes: 2.9 },
		cover: '/img/book-kafka-front.webp',
		read: '/literature/die-verwandlung'
	}
];

/**
 * The forum topic where readers ask for the next book. It needs one fixed
 * thread: post it on the live forum (board "Ideas and requests", the title
 * below, the rule from bookRequestRule() in the post) and paste its id
 * here. Until then the links open the new-topic form, title started.
 */
export const BOOK_REQUESTS = {
	threadId: '',
	title: 'Which German book should the literature shelf annotate next?'
};

/**
 * Only public-domain books go on the shelf. In Germany and the EU a book is
 * free 70 years after the end of the year its author died, so the cut-off
 * moves on by itself each New Year.
 */
export function publicDomainCutoff(now = new Date()): number {
	return now.getFullYear() - 71;
}

export function bookRequestRule(now = new Date()): string {
	return `Only books in the public domain: the author died in ${publicDomainCutoff(now)} or earlier, and it is the German original, not a modern translation or edition.`;
}

/** The title the request links start, so the new-topic form knows to show the rule. */
export const BOOK_REQUEST_TITLE = 'Book request: ';

export function bookRequestHref(): string {
	if (BOOK_REQUESTS.threadId) return `/forum/${BOOK_REQUESTS.threadId}`;
	return `/forum/new?${new URLSearchParams({ category: 'idea', title: BOOK_REQUEST_TITLE })}`;
}
