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
