// Votes for the literature poll (content/bookPoll.ts), no login.
//
//   book_votes/{bookId}   { count, en, es, fr, tr, ar, uk }: the votes for a
//                         book, and how many of them want the notes in each
//                         language. A missing language field means 0.
//
// Everyone reads; anyone moves a counter by exactly one, together with one
// language field by the same one (firestore.rules). Which books this browser
// voted for, and in which language, is kept in localStorage, so a vote can be
// taken back. Without a login a determined person can vote twice: for a
// wish list that is fine, and the counts are a hint, not a ballot.
//
// Calls fail soft: a lost vote never breaks the page.

import { cloudConfigured, firebase } from './firebase';
import { isUiLang, type UiLang } from '$lib/i18n/lang.svelte';

const VOTES = 'book_votes';
const MINE_KEY = 'book_votes_mine';

export interface BookTally {
	count: number;
	langs: Partial<Record<UiLang, number>>;
}

export function votesAvailable(): boolean {
	return cloudConfigured();
}

/** The books this browser voted for, with the language it asked for. */
export function myVotes(): Record<string, UiLang> {
	try {
		const raw = JSON.parse(localStorage.getItem(MINE_KEY) ?? '{}');
		const out: Record<string, UiLang> = {};
		for (const [id, l] of Object.entries(raw ?? {})) if (isUiLang(l)) out[id] = l;
		return out;
	} catch {
		return {};
	}
}

function saveMine(mine: Record<string, UiLang>): void {
	try {
		localStorage.setItem(MINE_KEY, JSON.stringify(mine));
	} catch {
		// Private mode: the vote still counts, it just can't be taken back later.
	}
}

/** Every book's tally, or null when the cloud is unavailable. */
export async function fetchTallies(): Promise<Record<string, BookTally> | null> {
	if (!cloudConfigured()) return null;
	try {
		const { db, storeApi: s } = await firebase();
		const snap = await s.getDocs(s.collection(db, VOTES));
		const out: Record<string, BookTally> = {};
		snap.forEach((d) => {
			const data = d.data();
			const langs: BookTally['langs'] = {};
			for (const [k, v] of Object.entries(data)) if (isUiLang(k) && typeof v === 'number') langs[k] = v;
			out[d.id] = { count: typeof data.count === 'number' ? data.count : 0, langs };
		});
		return out;
	} catch {
		return null;
	}
}

/**
 * Adds (step 1) or takes back (step -1) this browser's vote for a book.
 * Remembers it locally first, so the page reflects the tap even offline.
 * Returns whether the cloud write went through.
 */
export async function castVote(bookId: string, voteLang: UiLang, step: 1 | -1): Promise<boolean> {
	const mine = myVotes();
	if (step === 1) mine[bookId] = voteLang;
	else delete mine[bookId];
	saveMine(mine);
	if (!cloudConfigured()) return false;
	try {
		const { db, storeApi: s } = await firebase();
		// merge + increment: creates the counter on a book's first vote.
		await s.setDoc(
			s.doc(db, VOTES, bookId),
			{ count: s.increment(step), [voteLang]: s.increment(step) },
			{ merge: true }
		);
		return true;
	} catch {
		return false;
	}
}
