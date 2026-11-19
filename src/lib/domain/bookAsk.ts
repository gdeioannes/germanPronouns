// The two book questions, and when they may ask. Pure rules; the store
// (state/feedback.svelte.ts) keeps the records in this browser.
//
//   "Who is this book for?"  at every PDF download (owner's call, 2026-11-19:
//                            the PDF is free, and each answer is about that
//                            book) — so it needs no record here.
//   "How is the book going?" on a visit that came from a printed book's
//                            code, after the reader did something there —
//                            once per book: a rating ends it; a close waits
//                            for another day; three closes end it too.

export const AUDIENCES = ['me', 'class', 'child', 'other'] as const;
export type Audience = (typeof AUDIENCES)[number];

export const BOOK_CLOSES_MAX = 3;

export interface BookRecord {
	/** Per book level ("A1.1"): epoch ms it was rated, or 0. */
	rated: Record<string, number>;
	/** Per book level: epoch ms of the last close, or 0. */
	closedAt: Record<string, number>;
	/** Per book level: how many times the reader closed it. */
	closes: Record<string, number>;
}

export const EMPTY_BOOK_RECORD: BookRecord = { rated: {}, closedAt: {}, closes: {} };

function numbers(x: unknown): Record<string, number> {
	const out: Record<string, number> = {};
	if (!x || typeof x !== 'object') return out;
	for (const [k, v] of Object.entries(x as Record<string, unknown>)) {
		if (typeof v === 'number' && Number.isFinite(v) && v > 0 && k.length <= 10) out[k] = v;
	}
	return out;
}

/** A stored record, made safe. */
export function parseBookRecord(raw: string | null): BookRecord {
	if (!raw) return structuredClone(EMPTY_BOOK_RECORD);
	try {
		const x = JSON.parse(raw) as Partial<Record<keyof BookRecord, unknown>>;
		return {
			rated: numbers(x.rated),
			closedAt: numbers(x.closedAt),
			closes: numbers(x.closes)
		};
	} catch {
		return structuredClone(EMPTY_BOOK_RECORD);
	}
}

const day = (ms: number) => {
	const d = new Date(ms);
	return `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;
};

/** Whether "How is the book going?" may ask about `book` now. */
export function mayAskBook(r: BookRecord, book: string, now: number): boolean {
	if (!book) return false;
	if (r.rated[book]) return false;
	if ((r.closes[book] ?? 0) >= BOOK_CLOSES_MAX) return false;
	const closed = r.closedAt[book];
	if (closed && day(closed) === day(now)) return false;
	return true;
}

export function afterBookRating(r: BookRecord, book: string, now: number): BookRecord {
	return { ...r, rated: { ...r.rated, [book]: now } };
}

export function afterBookClose(r: BookRecord, book: string, now: number): BookRecord {
	return {
		...r,
		closedAt: { ...r.closedAt, [book]: now },
		closes: { ...r.closes, [book]: (r.closes[book] ?? 0) + 1 }
	};
}
