// Pinned material: whole exercises, or one question inside one, saved to come
// back to. Pure data and rules here; the store is state/pins.svelte.ts.
//
// Saved as one JSON value: the pins plus a note of every unpin and when. The
// note is what lets two devices merge: a pin made on the phone and another on
// the laptop both survive, while one unpinned on either stays gone — unless
// it was pinned again after that.

import { questionKey } from './questionHistory';

export interface Pin {
	/** `quiz:<course>/<quiz>` or `q:<course>/<quiz>/<question key>`. */
	id: string;
	kind: 'quiz' | 'question';
	courseId: string;
	quizId: string;
	/** The exercise's title when pinned (topic only, in the learner's language then). */
	quizTitle: string;
	quizType: string;
	level?: string;
	/** A question pin: the sentence or prompt as it was on screen. */
	text?: string;
	/** A question pin: questionKey(text), the same key the per-question dots use. */
	key?: string;
	/** Epoch ms. */
	at: number;
}

export interface PinBook {
	items: Pin[];
	/** id → epoch ms of the latest unpin. */
	removed: Record<string, number>;
}

/** How many unpins are remembered; the oldest go first. */
const REMOVED_LIMIT = 500;

export const emptyBook = (): PinBook => ({ items: [], removed: {} });

export function quizPinId(courseId: string, quizId: string): string {
	return `quiz:${courseId}/${quizId}`;
}

export function questionPinId(courseId: string, quizId: string, text: string): string {
	return `q:${courseId}/${quizId}/${questionKey(text)}`;
}

export function parseBook(raw: string | null | undefined): PinBook {
	if (!raw) return emptyBook();
	try {
		const data = JSON.parse(raw);
		const items = Array.isArray(data?.items)
			? data.items.filter(
					(p: Partial<Pin>) =>
						p &&
						typeof p.id === 'string' &&
						(p.kind === 'quiz' || p.kind === 'question') &&
						typeof p.courseId === 'string' &&
						typeof p.quizId === 'string' &&
						typeof p.at === 'number'
				)
			: [];
		const removed: Record<string, number> = {};
		if (data?.removed && typeof data.removed === 'object') {
			for (const [id, at] of Object.entries(data.removed)) if (typeof at === 'number') removed[id] = at;
		}
		return { items, removed };
	} catch {
		return emptyBook();
	}
}

/** Newest first: what was pinned last is on top. */
function sorted(items: Pin[]): Pin[] {
	return [...items].sort((a, b) => b.at - a.at);
}

function trimRemoved(removed: Record<string, number>): Record<string, number> {
	const entries = Object.entries(removed);
	if (entries.length <= REMOVED_LIMIT) return removed;
	return Object.fromEntries(entries.sort((a, b) => b[1] - a[1]).slice(0, REMOVED_LIMIT));
}

export function addPin(book: PinBook, pin: Pin): PinBook {
	const items = book.items.filter((p) => p.id !== pin.id);
	const { [pin.id]: _gone, ...removed } = book.removed;
	return { items: sorted([...items, pin]), removed };
}

export function removePin(book: PinBook, id: string, at = Date.now()): PinBook {
	return {
		items: book.items.filter((p) => p.id !== id),
		removed: trimRemoved({ ...book.removed, [id]: Math.max(at, book.removed[id] ?? 0) })
	};
}

/**
 * Two devices' books into one: every pin either side has, unless it was
 * unpinned (on either side) after it was pinned.
 */
export function mergeBooks(a: PinBook, b: PinBook): PinBook {
	const removed: Record<string, number> = { ...a.removed };
	for (const [id, at] of Object.entries(b.removed)) removed[id] = Math.max(at, removed[id] ?? 0);
	const byId = new Map<string, Pin>();
	for (const pin of [...a.items, ...b.items]) {
		const had = byId.get(pin.id);
		if (!had || pin.at > had.at) byId.set(pin.id, pin);
	}
	const items = [...byId.values()].filter((p) => !(removed[p.id] >= p.at));
	// A pin that outlived its unpin no longer needs the note.
	for (const p of items) if (removed[p.id] !== undefined) delete removed[p.id];
	return { items: sorted(items), removed: trimRemoved(removed) };
}

/** The sync's entry point: two raw values in, one out. */
export function mergePinValues(local: string, remote: string): string {
	return JSON.stringify(mergeBooks(parseBook(local), parseBook(remote)));
}
