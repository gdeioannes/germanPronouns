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
			'524 words explained in English before you meet them',
			'76 notes on grammar, idioms and Prague German at the foot of the page',
			'A guide to the 1917 spelling, so daß and mußte never stop you'
		],
		pdf: { href: '/books/literature/kafka_die_verwandlung.pdf', pages: 90, megabytes: 1.5 },
		cover: '/img/book-kafka-front.webp'
	}
];
