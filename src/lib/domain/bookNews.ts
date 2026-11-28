// The newsletter's band: at the end of every book chapter, on the book's
// cover, and around the sign-up form on the site. Several wordings take
// turns, each with its own figure (static/img/news/news_<id>.webp, made by
// tool/cutout-news.mjs). Every link and code says where it was and which
// wording it carried (?from=pdf-a1-1-ch03-weekly), so the sign-up statistics
// show what works. In a book the turn starts one further per level, so no
// wording always has the first chapter.

import { tk } from '$lib/i18n/t';

/** The band's second door. */
export const INSTAGRAM = 'https://www.instagram.com/language.quiz/';

export const NEWS_IDS = ['weekly', 'books', 'edition', 'engaged'] as const;
export type NewsId = (typeof NEWS_IDS)[number];

/**
 * The wordings. `en` is the key the interface languages translate (t());
 * `de` prints in the books that explain in German (B1 and up); `site` is
 * the wording on the site, where there is no book in the reader's hand.
 */
export const NEWS_TEXT: Record<NewsId, { en: string; de: string; site?: string }> = {
	weekly: { en: tk('New books and exercises every week. Never miss one.'), de: 'Jede Woche neue Bücher und Übungen. Verpass nichts.' },
	books: { en: tk('Every new book, straight to your inbox.'), de: 'Jedes neue Buch direkt in dein Postfach.' },
	edition: { en: tk('This book keeps getting better. Get the new version.'), de: 'Dieses Buch wird immer besser. Hol dir die neue Ausgabe.', site: tk('The books keep getting better. Get every new version.') },
	engaged: { en: tk("Learners who keep going learn more. We'll keep you going."), de: 'Wer dranbleibt, lernt mehr. Wir helfen dir dabei.' }
};
/** Under every wording: how often, in which language, and the way out. */
export const NEWS_TERMS = { en: tk('One email a week, in English. Unsubscribe anytime.'), de: 'Eine E-Mail pro Woche, auf Englisch. Abmelden jederzeit.' };

const LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];

/** A book's spots: its chapters by number (0-based), its cover, and the page after the last one. */
export type NewsSpot = number | 'cover' | 'end';

/** The wording at a spot of a book. The cover takes the one two turns on from chapter 1. */
export function newsIdAt(level: string, spot: NewsSpot): NewsId {
	const n = spot === 'cover' ? 2 : spot === 'end' ? 0 : spot;
	return NEWS_IDS[(Math.max(0, LEVELS.indexOf(level)) + n) % NEWS_IDS.length];
}

/**
 * The sign-up address a spot's band leads to. `via`: pdf (a link in the
 * download), reader (the book read on the site), qr (the code, scanned).
 */
export function newsUrl(via: 'pdf' | 'reader' | 'qr', level: string, spot: NewsSpot): string {
	const slug = level.toLowerCase().replace('.', '-');
	// The last page carries all four wordings at once.
	if (spot === 'end') return `https://languagequiz.org/newsletter?from=${via}-${slug}-end-all`;
	const where = spot === 'cover' ? 'cover' : `ch${String(spot + 1).padStart(2, '0')}`;
	return `https://languagequiz.org/newsletter?from=${via}-${slug}-${where}-${newsIdAt(level, spot)}`;
}
