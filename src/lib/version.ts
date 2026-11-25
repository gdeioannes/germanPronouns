// One version for the app and the books, bumped by hand with every release
// that changes what a learner sees or holds in their hands.
//
//   APP_VERSION  shows in the changelog header, the About page and the
//                release banner; the banner remembers which version it was
//                dismissed for, so a new version shows it again.
//   BOOK_EDITION the printed books' edition, on every book's imprint page and
//                on /books, so a reader can tell whether their PDF is current.
//
// Versions are dates: the release day as year.month.day. A second release on
// one day adds a letter (2026.11.25b).

export const APP_VERSION = '2026.11.25';

export const BOOK_EDITION = {
	/** Counted from the first full set of twelve books (1 = November 2026 originals). */
	n: 2,
	/** Printed on the imprint page. */
	label: '2. Auflage, November 2026',
	/** For the download page and comparisons. */
	date: '2026-11-25'
};
