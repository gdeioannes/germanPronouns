// Sending a page on to someone: the phone's share sheet where there is one
// (WhatsApp, Telegram and the rest are one tap away in it), the link copied
// to the clipboard everywhere else.
//
// Every shared link carries ?ref=share-<where>. The analytics read that tag on
// arrival (services/analytics resolveAttribution), so the visit a share brings
// is counted under the place it was shared from, with no extra event.
//
// The address shared is the one in the address bar, language prefix and all:
// a link sent from /ar/… opens in Arabic for whoever receives it.

import { track } from '$lib/services/analytics';
import { stripLang } from '$lib/i18n/paths';

/** Where a share was started. Kept short: it becomes the visit's source name. */
export type ShareWhere =
	| 'nav' // the top bar's button, or the Menu's "Share this page"
	| 'footer' // the band above the footer links
	| 'books' // the ask at the top of the books page
	| 'home' // the ask on the home page's book shelf
	| 'reader' // the book reader's toolbar
	| 'quiz' // an exercise's header or its More panel
	| 'quiz_done' // an exercise's finished bar (carries the score)
	| 'download' // the download panel, after a book started downloading
	| 'book_thanks' // the book's thank-you card
	| 'level' // a placement test or word check result
	| 'game' // a game's own screen
	| 'poll' // the literature poll's thank-you, after a vote
	| 'chart'; // a grammar chart's page, or the charts page ('print' = the QR code in the printed book)

/** The query parameter a score rides in: "9-10" = nine of ten. */
export const SCORE_PARAM = 'score';

export type SharedScore = { right: number; total: number };

/** "?score=9-10" → { right: 9, total: 10 }; anything else → null. */
export function readScore(search: string): SharedScore | null {
	const m = /^(\d{1,3})-(\d{1,3})$/.exec(new URLSearchParams(search).get(SCORE_PARAM) ?? '');
	if (!m) return null;
	const right = Number(m[1]);
	const total = Number(m[2]);
	return total > 0 && right <= total ? { right, total } : null;
}

/**
 * The link to hand on: this site, the given path (this page when none is
 * given), tagged with where it was shared from. Any query the page carried
 * (a book list flag, someone else's score, campaign tags) is left behind.
 */
export function shareLink(where: ShareWhere, path?: string, score?: SharedScore | null): string {
	const url = new URL(path ?? location.pathname, location.origin);
	url.search = '';
	url.hash = '';
	url.searchParams.set('ref', `share-${where}`);
	if (score) url.searchParams.set(SCORE_PARAM, `${score.right}-${score.total}`);
	return url.toString();
}

/** A WhatsApp link that opens the chat picker with the text and link written in. */
export function whatsappLink(text: string, url: string): string {
	return `https://wa.me/?text=${encodeURIComponent(`${text}\n${url}`)}`;
}

/** A Telegram link: the chat picker, with the link and the words under it. */
export function telegramLink(text: string, url: string): string {
	return `https://t.me/share/url?url=${encodeURIComponent(url)}&text=${encodeURIComponent(text)}`;
}

/** An email, ready to address: the words and the link in its body. */
export function mailLink(subject: string, text: string, url: string): string {
	return `mailto:?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(`${text}\n\n${url}`)}`;
}

/** The ways out of the share panel (`sheet` = the device's own share sheet). */
export type ShareHow = 'sheet' | 'copy' | 'whatsapp' | 'telegram' | 'email' | 'qr';

/** One share tap, by any way out. `route` is the page without its language prefix. */
export function trackShare(where: ShareWhere, how: ShareHow, props: Record<string, string | number> = {}): void {
	track('share_tap', { where, how, route: stripLang(location.pathname), ...props });
}

export type ShareOutcome = 'shared' | 'copied' | 'cancelled' | 'failed';

/**
 * Hands the link on. The share sheet when the browser has one; a learner who
 * closes the sheet has not shared, so that is not counted. Otherwise the link
 * (under its line of text, when there is one) goes to the clipboard.
 */
export async function share(opts: {
	where: ShareWhere;
	url: string;
	/** A line to send with the link. Without one, the page's own title. */
	text?: string;
	title?: string;
	props?: Record<string, string | number>;
}): Promise<ShareOutcome> {
	const title = opts.title ?? document.title;
	if (typeof navigator.share === 'function') {
		try {
			await navigator.share({ title, text: opts.text ?? title, url: opts.url });
			trackShare(opts.where, 'sheet', opts.props);
			return 'shared';
		} catch (error) {
			// AbortError: the sheet was closed. Anything else: fall through to copying.
			if ((error as DOMException)?.name === 'AbortError') return 'cancelled';
		}
	}
	try {
		await navigator.clipboard.writeText(opts.text ? `${opts.text}\n${opts.url}` : opts.url);
		trackShare(opts.where, 'copy', opts.props);
		return 'copied';
	} catch {
		return 'failed';
	}
}
