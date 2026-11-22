// What the download panel shows after the first book: the PDF downloads at
// once, and the panel says so, with ONE card about something else the site
// has — a different card each download. (Owner's call, 2026-11-20: ask "Who is
// this book for?" the first time; afterwards advertise the site instead.)

export interface Promo {
	id: string;
	/** The hook: a question or a scene that makes you want to know more. */
	hook: string;
	/** One short line on what you get. */
	line: string;
	href: string;
	/** The button: what you do, in a few words. */
	cta: string;
	/** The picture on top: a photo/cover, or one drawn in code. */
	visual: { img: string; book?: boolean } | 'blocks' | 'chat' | 'ladder';
	/** A download of this book never shows this card (it is the thing itself). */
	skipFor?: string;
}

export const PROMOS: Promo[] = [
	{
		id: 'wortbloecke',
		hook: 'Der, die or das? Learn it without noticing.',
		line: 'Wortblöcke: German words fall, you catch their meaning and their article, and a full row turns gold.',
		href: '/play/wortbloecke',
		cta: 'Play one round',
		visual: 'blocks'
	},
	{
		id: 'kafka',
		hook: 'One morning, a man wakes up as a giant insect.',
		line: 'Read Kafka’s Die Verwandlung in his own German. Every hard word is explained right beside the line.',
		href: '/literature/die-verwandlung',
		cta: 'Read the first page',
		visual: { img: '/img/book-kafka-front.webp', book: true },
		skipFor: 'Kafka'
	},
	{
		id: 'stories',
		hook: 'Maya is lost in Berlin. Can you help her?',
		line: 'A spoken mystery that starts with almost no German. You pick up the words while you follow her.',
		href: '/story/ep0-lost-in-berlin',
		cta: 'Start the story',
		visual: { img: '/img/story/ep0_maya_map.webp' }
	},
	{
		id: 'schreibmir',
		hook: 'Someone just texted you. In German.',
		line: 'Schreib mir!: chat with characters who answer back. Short messages, real situations, no pressure.',
		href: '/play/schreib-mir',
		cta: 'Open the chat',
		visual: 'chat'
	},
	{
		id: 'levelcheck',
		hook: 'Which of the twelve books is really yours?',
		line: 'A short check with words and grammar tells you your level and the book to start with.',
		href: '/level-check',
		cta: 'Find my level',
		visual: 'ladder'
	}
];

/**
 * Where each course book carries on in the app: its first chapter's page,
 * with the recordings, the answer check and the word cards (domain/bookStudy).
 * Kept by hand so the panel needs no book content; the test holds it to the
 * books themselves.
 */
export const FIRST_CHAPTER: Record<string, { id: string; title: string }> = {
	'A1.1': { id: 'hallo', title: 'Hallo! Das bin ich' },
	'A1.2': { id: 'einkaufen', title: 'Einkaufen' },
	'A2.1': { id: 'sonntag', title: 'Was hast du gemacht?' },
	'A2.2': { id: 'umzug', title: 'Der Umzug' },
	'B1.1': { id: 'bewerbung', title: 'Die Bewerbung' },
	'B1.2': { id: 'technik', title: 'Haben Sie es schon versucht?' },
	'B2.1': { id: 'nachrichten', title: 'Er sagt, er sei krank' },
	'B2.2': { id: 'forschung', title: 'Damit fing es an' },
	'C1.1': { id: 'studie', title: 'Die Studie zeigt' },
	'C1.2': { id: 'galerie', title: 'Das ist bemerkenswert' },
	'C2.1': { id: 'gericht', title: 'Ich habe Einspruch eingelegt' },
	'C2.2': { id: 'philosophie', title: 'Ausgerechnet heute' }
};

/** The app page a downloaded course book leads to. */
export interface Companion {
	href: string;
	/** The first chapter's German title. */
	title: string;
}

const COURSE_ID = 'de_cert_a1';

/**
 * The downloaded book's own first chapter in the app, or null for a book
 * without chapter pages (a classic). Most readers took the PDF and left
 * without ever seeing that the book has a spoken, checkable half here; the
 * ones who followed a page code from the book are the ones who stayed.
 */
export function companionFor(book: string): Companion | null {
	const first = FIRST_CHAPTER[book];
	return first ? { href: `/course/${COURSE_ID}/book2/${book}/${first.id}`, title: first.title } : null;
}

/**
 * The card for this download: the one after the last shown, skipping the
 * book being downloaded. `last` is the index shown last time (-1 for none).
 */
export function nextPromo(last: number, book: string, list: readonly Promo[] = PROMOS): { promo: Promo; index: number } {
	for (let step = 1; step <= list.length; step++) {
		const index = (((last + step) % list.length) + list.length) % list.length;
		if (list[index].skipFor !== book) return { promo: list[index], index };
	}
	return { promo: list[0], index: 0 };
}
