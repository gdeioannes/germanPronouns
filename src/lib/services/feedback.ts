// Site and book feedback in Firestore: learners add, only the owner reads.
//
//   feedback/{id}        one answer: stars and optional texts, where it came
//                        from (the site card, the menu, or a printed book's
//                        code). Created with no login; the id is random and
//                        never shown, so the one browser that made it is the
//                        only one that can add the texts to it (once, within
//                        the hour — see firestore.rules).
//   book_audience/{id}   "Who is this book for?" at a PDF download, and the
//                        optional school or course.
//   book_quotes/{id}     quotes the owner chose to publish (the reader agreed);
//                        readable by everyone, shown on /books.
//   site_owners/{uid}    exists ⇒ the site owner, who reads /backoffice.
//                        Created by hand in the Firebase console, never here.
//
// Learner-side calls fail soft: a lost rating must never break a page.

import { cloudConfigured, firebase } from './firebase';
import type { Audience } from '$lib/domain/bookAsk';

const FEEDBACK = 'feedback';
const AUDIENCE = 'book_audience';
const QUOTES = 'book_quotes';
const OWNERS = 'site_owners';

export const TEXT_MAX = 2000;
export const QUOTE_MAX = 400;
export const NAME_MAX = 40;
export const SCHOOL_MAX = 200;

/** Where an answer came from: the timed card, the menu, or a book code visit. */
export type FeedbackSource = 'ask' | 'menu' | 'book';

/** What the reader may write after the stars. */
export interface FeedbackTexts {
	comment: string;
	wish: string;
	/** A mistake found in a book, and where. */
	mistake: string;
	/** A sentence the owner may publish, only with `quoteOk`. */
	quote: string;
	name: string;
	quoteOk: boolean;
}

export const NO_TEXTS: FeedbackTexts = { comment: '', wish: '', mistake: '', quote: '', name: '', quoteOk: false };

export interface FeedbackEntry extends FeedbackTexts {
	id: string;
	rating: number;
	/** The page it was given on, e.g. "/course/de_cert_a1/quiz/…". */
	page: string;
	source: FeedbackSource;
	/** The book level ("A1.1") for book answers, else "". */
	book: string;
	/** The printed code the reader came from, else "". */
	code: string;
	/** The site language at the time: "en", "tr", "ar", "uk". */
	lang: string;
	/** Epoch ms. */
	at: number;
}

export interface AudienceEntry {
	id: string;
	who: Audience;
	school: string;
	book: string;
	lang: string;
	at: number;
}

export interface BookQuote {
	id: string;
	text: string;
	name: string;
	book: string;
	at: number;
}

export function feedbackAvailable(): boolean {
	return cloudConfigured();
}

const clip = (s: string, max: number) => s.trim().slice(0, max);

/** A fresh, unguessable document id, made here so the texts can follow it. */
function newId(): string {
	const bytes = crypto.getRandomValues(new Uint8Array(15));
	return Array.from(bytes, (b) => b.toString(16).padStart(2, '0')).join('');
}

function cleanTexts(t: FeedbackTexts): FeedbackTexts {
	const quote = clip(t.quote, QUOTE_MAX);
	return {
		comment: clip(t.comment, TEXT_MAX),
		wish: clip(t.wish, TEXT_MAX),
		mistake: clip(t.mistake, TEXT_MAX),
		quote,
		name: clip(t.name, NAME_MAX),
		quoteOk: Boolean(quote && t.quoteOk)
	};
}

/**
 * Saves one answer and returns its id (so texts can be added after a star
 * tap), or null when the cloud is unavailable or the write failed.
 */
export async function submitFeedback(
	entry: { rating: number; page: string; source: FeedbackSource; book?: string; code?: string; lang: string },
	texts: FeedbackTexts = NO_TEXTS
): Promise<string | null> {
	if (!cloudConfigured()) return null;
	try {
		const { db, storeApi: s } = await firebase();
		const id = newId();
		await s.setDoc(s.doc(db, FEEDBACK, id), {
			rating: Math.min(5, Math.max(1, Math.round(entry.rating))),
			...cleanTexts(texts),
			page: clip(entry.page, 200) || '/',
			source: entry.source,
			book: clip(entry.book ?? '', 10),
			code: clip(entry.code ?? '', 40),
			lang: clip(entry.lang, 5) || 'en',
			at: Date.now()
		});
		return id;
	} catch (cause) {
		console.error('[feedback] save', cause);
		return null;
	}
}

/** Adds the texts to an answer saved a moment ago by this browser. */
export async function addFeedbackText(id: string, texts: FeedbackTexts): Promise<boolean> {
	if (!cloudConfigured()) return false;
	try {
		const { db, storeApi: s } = await firebase();
		await s.updateDoc(s.doc(db, FEEDBACK, id), { ...cleanTexts(texts) });
		return true;
	} catch (cause) {
		console.error('[feedback] texts', cause);
		return false;
	}
}

/** "Who is this book for?" — returns the id, so a school can follow. */
export async function submitAudience(who: Audience, book: string, lang: string): Promise<string | null> {
	if (!cloudConfigured()) return null;
	try {
		const { db, storeApi: s } = await firebase();
		const id = newId();
		await s.setDoc(s.doc(db, AUDIENCE, id), {
			who,
			school: '',
			book: clip(book, 10),
			lang: clip(lang, 5) || 'en',
			at: Date.now()
		});
		return id;
	} catch (cause) {
		console.error('[feedback] audience', cause);
		return null;
	}
}

/** The optional school or course, added to an audience answer just saved. */
export async function addAudienceSchool(id: string, school: string): Promise<boolean> {
	if (!cloudConfigured() || !school.trim()) return false;
	try {
		const { db, storeApi: s } = await firebase();
		await s.updateDoc(s.doc(db, AUDIENCE, id), { school: clip(school, SCHOOL_MAX) });
		return true;
	} catch (cause) {
		console.error('[feedback] school', cause);
		return false;
	}
}

/** The published quotes, newest first — empty when unavailable. */
export async function listBookQuotes(max = 12): Promise<BookQuote[]> {
	if (!cloudConfigured()) return [];
	try {
		const { db, storeApi: s } = await firebase();
		const snap = await s.getDocs(s.query(s.collection(db, QUOTES), s.orderBy('at', 'desc'), s.limit(max)));
		return snap.docs.map((d) => {
			const x = d.data();
			return { id: d.id, text: String(x.text ?? ''), name: String(x.name ?? ''), book: String(x.book ?? ''), at: Number(x.at) || 0 };
		});
	} catch {
		return [];
	}
}

// -- owner only (the rules refuse anyone else) --------------------------------

/** True when a `site_owners/{uid}` document exists. */
export async function isSiteOwner(uid: string): Promise<boolean> {
	if (!cloudConfigured()) return false;
	try {
		const { db, storeApi: s } = await firebase();
		return (await s.getDoc(s.doc(db, OWNERS, uid))).exists();
	} catch {
		return false;
	}
}

/** Every answer, newest first. */
export async function listFeedback(max = 1000): Promise<FeedbackEntry[]> {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDocs(s.query(s.collection(db, FEEDBACK), s.orderBy('at', 'desc'), s.limit(max)));
	return snap.docs.map((d) => {
		const x = d.data();
		const str = (v: unknown) => String(v ?? '');
		return {
			id: d.id,
			rating: Number(x.rating) || 0,
			comment: str(x.comment),
			wish: str(x.wish),
			mistake: str(x.mistake),
			quote: str(x.quote),
			name: str(x.name),
			quoteOk: x.quoteOk === true,
			page: str(x.page),
			source: x.source === 'menu' || x.source === 'book' ? x.source : 'ask',
			book: str(x.book),
			code: str(x.code),
			lang: str(x.lang),
			at: Number(x.at) || 0
		};
	});
}

/** Every download answer, newest first. */
export async function listAudience(max = 2000): Promise<AudienceEntry[]> {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDocs(s.query(s.collection(db, AUDIENCE), s.orderBy('at', 'desc'), s.limit(max)));
	return snap.docs.map((d) => {
		const x = d.data();
		return {
			id: d.id,
			who: (['me', 'class', 'child', 'other'].includes(x.who) ? x.who : 'other') as Audience,
			school: String(x.school ?? ''),
			book: String(x.book ?? ''),
			lang: String(x.lang ?? ''),
			at: Number(x.at) || 0
		};
	});
}

/** Removes one answer (and its published quote, if any). */
export async function deleteFeedback(id: string): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.deleteDoc(s.doc(db, QUOTES, id)).catch(() => {});
	await s.deleteDoc(s.doc(db, FEEDBACK, id));
}

export async function deleteAudience(id: string): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.deleteDoc(s.doc(db, AUDIENCE, id));
}

/** Ids of the answers whose quote is published. */
export async function publishedQuoteIds(): Promise<Set<string>> {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDocs(s.collection(db, QUOTES));
	return new Set(snap.docs.map((d) => d.id));
}

/** Puts a quote on /books (same id as its answer), or takes it off. */
export async function setQuotePublished(entry: FeedbackEntry, on: boolean): Promise<void> {
	const { db, storeApi: s } = await firebase();
	const ref = s.doc(db, QUOTES, entry.id);
	if (!on) {
		await s.deleteDoc(ref);
		return;
	}
	await s.setDoc(ref, {
		text: clip(entry.quote, QUOTE_MAX),
		name: clip(entry.name, NAME_MAX),
		book: entry.book,
		at: entry.at
	});
}
