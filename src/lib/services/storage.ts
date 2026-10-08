// The platform seam for persisted learner progress — scores, streaks, which
// quizzes are done, which levels are unlocked.
//
// Web today   → localStorage.
// Mobile later → Capacitor's Preferences plugin. This one is not optional:
//                WKWebView can evict localStorage under storage pressure, and
//                progress the learner earned must not be collectible garbage.
//
// The interface is deliberately async even though localStorage is synchronous,
// because every native implementation is async. Getting that wrong is what
// makes a storage swap ripple through every caller.

export interface KeyValueStore {
	get(key: string): Promise<string | null>;
	set(key: string, value: string): Promise<void>;
	remove(key: string): Promise<void>;
	keys(): Promise<string[]>;
}

export class LocalStorageStore implements KeyValueStore {
	async get(key: string): Promise<string | null> {
		try {
			return globalThis.localStorage?.getItem(key) ?? null;
		} catch {
			// Private windows and blocked site data throw rather than return null.
			return null;
		}
	}

	async set(key: string, value: string): Promise<void> {
		try {
			globalThis.localStorage?.setItem(key, value);
		} catch {
			// Best-effort: a full or blocked store must never break a quiz.
		}
	}

	async remove(key: string): Promise<void> {
		try {
			globalThis.localStorage?.removeItem(key);
		} catch {
			// Best-effort.
		}
	}

	async keys(): Promise<string[]> {
		try {
			return Object.keys(globalThis.localStorage ?? {});
		} catch {
			return [];
		}
	}
}

/**
 * Anyone who wants to know that something was persisted — today only the cloud
 * sync, which debounces a push off the back of it.
 *
 * A listener exists so sync can be bolted on without every caller learning
 * about it: `progress` still writes to `storage` and knows nothing about
 * accounts. Listeners must not throw and must not themselves write, or the
 * notification recurses.
 */
export type StorageListener = (key: string) => void;

const listeners = new Set<StorageListener>();

/** Subscribes to writes. Returns the unsubscribe. */
export function observeStorage(listener: StorageListener): () => void {
	listeners.add(listener);
	return () => listeners.delete(listener);
}

/** A store that reports every write it makes. */
class ObservedStore implements KeyValueStore {
	constructor(private readonly inner: KeyValueStore) {}

	get(key: string): Promise<string | null> {
		return this.inner.get(key);
	}

	async set(key: string, value: string): Promise<void> {
		await this.inner.set(key, value);
		this.notify(key);
	}

	async remove(key: string): Promise<void> {
		await this.inner.remove(key);
		this.notify(key);
	}

	keys(): Promise<string[]> {
		return this.inner.keys();
	}

	private notify(key: string): void {
		for (const listener of listeners) {
			try {
				listener(key);
			} catch {
				// A broken listener must never fail the write that triggered it.
			}
		}
	}
}

/** Swap the inner store for a Capacitor Preferences one when wrapping for mobile. */
export const storage: KeyValueStore = new ObservedStore(new LocalStorageStore());

/** Everything persisted here and now, as one map — the shape sync speaks. */
export async function readBlob(): Promise<Record<string, string>> {
	const blob: Record<string, string> = {};
	for (const key of await storage.keys()) {
		const value = await storage.get(key);
		if (value !== null) blob[key] = value;
	}
	return blob;
}

/**
 * Writes a merged blob back, leaving keys it doesn't mention alone.
 *
 * Deliberately does *not* delete anything: a key missing from the cloud copy
 * means the other device never had it, not that the learner wants it gone.
 * Deleting progress is `progress.reset()`'s job and nothing else's.
 */
export async function writeBlob(blob: Record<string, string>): Promise<void> {
	for (const [key, value] of Object.entries(blob)) {
		if ((await storage.get(key)) !== value) await storage.set(key, value);
	}
}
