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

/** Swap this line for a Capacitor Preferences store when wrapping for mobile. */
export const storage: KeyValueStore = new LocalStorageStore();
