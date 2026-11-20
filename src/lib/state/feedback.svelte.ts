// The feedback card and panel: the timer, the records in this browser, and
// what the card and the panel show. The rules live in domain/feedbackAsk.ts
// (the site) and domain/bookAsk.ts (the books); FeedbackCard.svelte draws it.
//
// The card has three kinds:
//   'site'      "How do you like the site so far?" — asks by itself at a
//               good moment (`moment()`), if the rules allow;
//   'book'      "How is the A1.1 book going?" — on a visit that came from a
//               printed book's code (`noteBookVisit()`), once the reader did
//               something there (`moment(level)`), once per book.
// And the menu's Feedback link opens the panel any time (`openFromMenu()`).
//
// Every PDF button goes through `beforeDownload()`. The FIRST download in
// this browser opens the download panel instead of downloading at once —
// "Who is this book for?" and a "Start the download" button; one tap on an
// answer starts the download too, answering is never required (owner's call,
// 2026-11-19). Every later download starts at once, and the panel shows
// "downloading" with one card about the site, a different one each time
// (domain/downloadPromo, owner's call 2026-11-20). In a second language, or
// without JavaScript, the link just downloads.
//
// The records are device-local (the `feedback_` prefix is never synced) and
// written with plain localStorage, so the timer's tick does not wake the
// cloud sync.

import { browser } from '$app/environment';
import { page } from '$app/state';
import { track } from '$lib/services/analytics';
import {
	NO_TEXTS,
	addAudienceSchool,
	addFeedbackText,
	feedbackAvailable,
	submitAudience,
	submitFeedback,
	type FeedbackSource,
	type FeedbackTexts
} from '$lib/services/feedback';
import { lang } from '$lib/i18n/lang.svelte';
import { LOW_RATING, afterClose, afterRating, mayAsk, parseRecord, type AskRecord } from '$lib/domain/feedbackAsk';
import {
	afterBookClose,
	afterBookRating,
	mayAskBook,
	parseBookRecord,
	type Audience,
	type BookRecord
} from '$lib/domain/bookAsk';
import { nextPromo, type Promo } from '$lib/domain/downloadPromo';

const SITE_KEY = 'feedback_ask';
const BOOK_KEY = 'feedback_books';
/** { asked: the audience question was shown, promo: the card shown last }. */
const DL_KEY = 'feedback_dl';
const TICK_MS = 15_000;
/** Use counts only with a tap, key or scroll within this long. */
const IDLE_MS = 60_000;
/** The card waits this long after a good moment, so the celebration plays first. */
const MOMENT_DELAY_MS = 1800;

function readRaw(key: string): string | null {
	try {
		return localStorage.getItem(key);
	} catch {
		return null;
	}
}

function writeRaw(key: string, value: unknown): void {
	try {
		localStorage.setItem(key, JSON.stringify(value));
	} catch {
		// Blocked storage: the card may simply ask again. Never an error.
	}
}

const readSite = (): AskRecord => parseRecord(readRaw(SITE_KEY));
const writeSite = (r: AskRecord) => writeRaw(SITE_KEY, r);
const readBooks = (): BookRecord => parseBookRecord(readRaw(BOOK_KEY));
const writeBooks = (r: BookRecord) => writeRaw(BOOK_KEY, r);

interface DlRecord {
	asked: boolean;
	promo: number;
}
function readDl(): DlRecord {
	try {
		const r = JSON.parse(readRaw(DL_KEY) ?? '{}') as Partial<DlRecord>;
		return { asked: r.asked === true, promo: typeof r.promo === 'number' ? r.promo : -1 };
	} catch {
		return { asked: false, promo: -1 };
	}
}
const writeDl = (r: DlRecord) => writeRaw(DL_KEY, r);

export type CardKind = 'site' | 'book';

/** A PDF the download panel is about to start. */
export interface DownloadInfo {
	href: string;
	/** The file name to save as, or undefined for the server's. */
	filename?: string;
	/** The book ("A1.1", "Kafka"), saved with the answer. */
	book: string;
}

/**
 * What the panel is for: after a low site rating, a wish after a high one,
 * the menu, after a low book rating, or the "may we quote you?" sentence.
 */
export type PanelMode = 'low' | 'wish' | 'menu' | 'bookLow' | 'quote';

class FeedbackStore {
	/** The small card in the corner. */
	card = $state(false);
	kind = $state<CardKind>('site');
	/** The card's thank-you state (after a 4–5 tap, a send, or an audience answer). */
	thanked = $state(false);
	/** The panel with the text boxes. */
	panel = $state(false);
	mode = $state<PanelMode>('menu');
	/** The stars given (1–5), 0 for none yet. */
	rating = $state(0);
	/** The book the card is about ("A1.1"), for 'book'. */
	book = $state('');
	/** The printed code this visit came from, or "". */
	code = $state('');
	/** The download panel, and the PDF it is about. */
	dlOpen = $state(false);
	dl = $state<DownloadInfo | null>(null);
	/** After the first download: the card about the site this panel shows. */
	dlPromo = $state<Promo | null>(null);
	/** The reader answered "Who is it for?" (the download started with it). */
	dlAnswered = $state(false);
	/** After "My class": the panel shows the optional school line. */
	askSchool = $state(false);
	sending = $state(false);
	failed = $state(false);
	/** Whether texts were sent this time (changes the thank-you line). */
	sent = $state(false);
	/** "Link copied" after the share button, where there is no share sheet. */
	copied = $state(false);

	/** The saved answer the texts get added to, after a star tap on the card. */
	private docId: string | null = null;
	private audienceId: string | null = null;
	private askedThisLoad = false;
	private started = false;
	private lastActive = 0;

	/** Starts counting real use. Once per page load, from the root layout. */
	start(): void {
		if (!browser || this.started) return;
		this.started = true;
		const mark = (e: Event) => {
			if (e.isTrusted) this.lastActive = Date.now();
		};
		for (const type of ['pointerdown', 'keydown', 'scroll', 'touchstart'] as const) {
			window.addEventListener(type, mark, { passive: true, capture: true });
		}
		setInterval(() => {
			if (document.visibilityState !== 'visible') return;
			if (Date.now() - this.lastActive > IDLE_MS) return;
			const r = readSite();
			// Past the threshold the exact count no longer matters; stop writing.
			if (r.activeMs > 60 * 60 * 1000) return;
			writeSite({ ...r, activeMs: r.activeMs + TICK_MS });
		}, TICK_MS);
	}

	/** Whether this build can ask at all. */
	get available(): boolean {
		return browser && feedbackAvailable();
	}

	/**
	 * The card's text is English only: a learner in Turkish, Arabic or
	 * Ukrainian mode is not asked by it (yet).
	 */
	private get mayShowCard(): boolean {
		return this.available && !lang.limited && !this.card && !this.panel;
	}

	/** This page load came from a printed book's code (utm_source=book). */
	noteBookVisit(code: string): void {
		this.code = code.slice(0, 40);
	}

	/**
	 * A good moment: a run finished well, or (on a book code visit) the reader
	 * checked an exercise, played the reading or used the word cards. On a
	 * book visit with a known level, the book question goes first; otherwise
	 * the site question, if the rules allow. At most one per page load.
	 */
	moment(level = ''): void {
		if (!this.mayShowCard || this.askedThisLoad) return;
		const now = Date.now();
		let kind: CardKind | null = null;
		if (this.code && level && mayAskBook(readBooks(), level, now)) kind = 'book';
		else if (mayAsk(readSite(), now)) kind = 'site';
		if (!kind) return;
		this.askedThisLoad = true;
		setTimeout(() => {
			if (this.panel || this.card) return;
			this.reset();
			this.kind = kind;
			this.book = kind === 'book' ? level : '';
			this.card = true;
			track('feedback_asked', { kind, ...(kind === 'book' ? { book: level } : {}) });
		}, MOMENT_DELAY_MS);
	}

	/**
	 * A PDF button was pressed: open the download panel instead of
	 * downloading at once. Left alone (the link downloads by itself) without
	 * Firebase, in a second language, or for a ctrl/cmd/middle click.
	 */
	beforeDownload(event: MouseEvent, info: DownloadInfo): void {
		if (lang.limited) return;
		if (event.button !== 0 || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
		const rec = readDl();
		this.card = false;
		this.panel = false;
		this.dl = info;
		this.askedThisLoad = true;
		if (rec.asked || !this.available) {
			// Not the first book: the link downloads by itself, the panel
			// says so and shows the next card about the site.
			const { promo, index } = nextPromo(rec.promo, info.book);
			writeDl({ ...rec, promo: index });
			this.dlPromo = promo;
			this.dlOpen = true;
			track('download_promo_shown', { card: promo.id, book: info.book });
			return;
		}
		event.preventDefault();
		writeDl({ ...rec, asked: true });
		this.dlPromo = null;
		this.dlAnswered = false;
		this.askSchool = false;
		this.audienceId = null;
		this.dlOpen = true;
		track('feedback_asked', { kind: 'audience', book: info.book });
	}

	/** A tap on the panel's card about the site. */
	promoClicked(): void {
		if (this.dlPromo) track('download_promo_click', { card: this.dlPromo.id, book: this.dl?.book ?? '' });
		this.dlOpen = false;
	}

	/** Starts the PDF the panel is about (the same file the button linked to). */
	startDownload(): void {
		const info = this.dl;
		if (!info) return;
		const a = document.createElement('a');
		a.href = info.href;
		a.download = info.filename ?? '';
		document.body.append(a);
		a.click();
		a.remove();
	}

	/** "Start the download" without answering: the panel's own link did it. */
	skippedQuestion(): void {
		track('book_audience_skipped', { book: this.dl?.book ?? '' });
		this.dlOpen = false;
	}

	/** The menu's Feedback link: the panel, with the stars, any time. */
	openFromMenu(): void {
		this.reset();
		this.card = false;
		this.kind = 'site';
		this.mode = 'menu';
		this.panel = true;
		track('feedback_opened', { source: 'menu' });
	}

	/** One of Me / My class / My child / Someone else. */
	async pickAudience(who: Audience): Promise<void> {
		const book = this.dl?.book ?? '';
		track('book_audience', { who, book });
		this.dlAnswered = true;
		this.askSchool = who === 'class';
		this.startDownload();
		this.audienceId = await submitAudience(who, book, lang.current);
	}

	/** The optional school or course after "My class". */
	async sendSchool(school: string): Promise<void> {
		this.askSchool = false;
		if (!school.trim() || !this.audienceId) return;
		track('book_audience_school');
		await addAudienceSchool(this.audienceId, school);
	}

	/** A star tapped on the card: saved at once; a low one opens the panel. */
	async tapStar(stars: number): Promise<void> {
		this.rating = stars;
		const now = Date.now();
		const isBook = this.kind === 'book';
		if (isBook) writeBooks(afterBookRating(readBooks(), this.book, now));
		else writeSite(afterRating(readSite(), now));
		track('feedback_rated', { stars, source: isBook ? 'book' : 'ask', ...(isBook ? { book: this.book } : {}) });
		if (stars <= LOW_RATING) {
			this.card = false;
			this.mode = isBook ? 'bookLow' : 'low';
			this.panel = true;
		} else {
			this.thanked = true;
		}
		this.docId = await submitFeedback(this.entry(isBook ? 'book' : 'ask'));
	}

	/** "Tell us what you need" under the site thank-you. */
	openWish(): void {
		this.card = false;
		this.mode = 'wish';
		this.panel = true;
	}

	/** "Can we quote you?" under the book thank-you. */
	openQuote(): void {
		this.card = false;
		this.mode = 'quote';
		this.panel = true;
	}

	/** Sends the books page on: the share sheet, or the link copied. */
	async share(): Promise<void> {
		const url = `${location.origin}/books`;
		const text = 'Free German books, A1 to C2, with audio and exercises online.';
		track('book_shared', { book: this.book });
		try {
			if (navigator.share) {
				await navigator.share({ title: 'Language Quiz — the books', text, url });
				return;
			}
		} catch {
			// Cancelled, or the sheet failed: fall back to copying.
		}
		try {
			await navigator.clipboard.writeText(url);
			this.copied = true;
		} catch {
			// No clipboard either: nothing to do.
		}
	}

	/** The card's × — the rating card counts it; the audience one is already spent. */
	dismiss(): void {
		this.card = false;
		if (this.rating || this.thanked) return;
		const now = Date.now();
		if (this.kind === 'site') writeSite(afterClose(readSite(), now));
		else if (this.kind === 'book') writeBooks(afterBookClose(readBooks(), this.book, now));
		track('feedback_closed', { kind: this.kind });
	}

	/** The panel's Send. */
	async send(texts: FeedbackTexts): Promise<boolean> {
		this.sending = true;
		this.failed = false;
		const hasText = Boolean(texts.comment.trim() || texts.wish.trim() || texts.mistake.trim() || texts.quote.trim());
		let ok: boolean;
		if (this.mode === 'menu') {
			if (!this.rating) {
				this.sending = false;
				return false;
			}
			writeSite(afterRating(readSite(), Date.now()));
			ok = (await submitFeedback(this.entry('menu'), texts)) !== null;
		} else if (!hasText) {
			ok = true;
		} else if (this.docId) {
			ok = await addFeedbackText(this.docId, texts);
		} else {
			// The star tap's save failed (offline a moment ago): save it whole.
			ok = (await submitFeedback(this.entry(this.kind === 'book' ? 'book' : 'ask'), texts)) !== null;
		}
		this.sending = false;
		if (!ok) {
			this.failed = true;
			return false;
		}
		track('feedback_sent', {
			source: this.mode === 'menu' ? 'menu' : this.kind === 'book' ? 'book' : 'ask',
			stars: this.rating,
			comment: Boolean(texts.comment.trim()),
			wish: Boolean(texts.wish.trim()),
			mistake: Boolean(texts.mistake.trim()),
			quote: Boolean(texts.quote.trim() && texts.quoteOk)
		});
		this.sent = hasText;
		this.docId = null;
		this.panel = false;
		this.thanked = true;
		this.card = true;
		return true;
	}

	/** For the owner's testing (/backoffice): forget every answer and close in this browser. */
	resetThisBrowser(): void {
		try {
			localStorage.removeItem(SITE_KEY);
			localStorage.removeItem(BOOK_KEY);
			localStorage.removeItem(DL_KEY);
		} catch {
			// Blocked storage: nothing was kept anyway.
		}
		this.askedThisLoad = false;
	}

	/** For testing: count the five minutes of use as already done. */
	skipWaitThisBrowser(): void {
		writeSite({ ...readSite(), activeMs: 60 * 60 * 1000 });
	}

	private entry(source: FeedbackSource) {
		return {
			rating: this.rating,
			page: page.url.pathname,
			source,
			book: source === 'book' ? this.book : '',
			code: source === 'book' ? this.code : '',
			lang: lang.current
		};
	}

	private reset(): void {
		this.thanked = false;
		this.rating = 0;
		this.sent = false;
		this.failed = false;
		this.copied = false;
		this.askSchool = false;
		this.docId = null;
		this.audienceId = null;
	}
}

export const feedback = new FeedbackStore();
export { NO_TEXTS };
