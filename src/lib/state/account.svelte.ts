// The optional account: one rune store holding whether the learner is signed
// in, and the two-way reconcile between this browser and their cloud copy.
//
// "Optional" is load-bearing. Signed out, nothing here runs, no network call
// is made and the Firebase SDK is never even downloaded — the app behaves
// exactly as it did before accounts existed. Signing in adds a backup and a
// second device; it is never a gate in front of a quiz.
//
// localStorage stays the source of truth while the learner is practising.
// Every write lands there first and synchronously-fast, so a quiz never waits
// on the network, and a push follows on a debounce.

import { SettingsKeys } from '$lib/domain/keys';
import {
	differInProgress,
	isSyncable,
	mergeProgress,
	summariseProgress,
	syncablePart,
	type ProgressBlob,
	type ProgressSummary
} from '$lib/domain/sync-merge';
import { cloudConfigured, fetchRemote, firebase, pushRemote } from '$lib/services/firebase';
import { observeStorage, readBlob, storage, writeBlob } from '$lib/services/storage';
import { progress } from '$lib/state/progress.svelte';

/** How long after the last write to push. One finished run writes a dozen keys. */
const PUSH_DEBOUNCE = 4000;

export type SyncState = 'idle' | 'syncing' | 'synced' | 'error';

/** What the learner picked when asked about two devices' progress. */
export type MergeChoice = 'merge' | 'local' | 'remote';

/**
 * The question held open while the learner answers it.
 *
 * It exists because the first sign-in is the one moment where two real
 * histories meet and the app is about to decide something irreversible-looking
 * on the learner's behalf. The merge itself loses nothing — but "my phone's
 * progress just got mixed into my laptop's" is a surprise, and a surprise about
 * work you earned is worth one dialog. Every later sync merges silently.
 */
export interface MergeDecision {
	uid: string;
	/** This browser's progress, and the cloud's, as they were when asked. */
	here: ProgressSummary;
	cloud: ProgressSummary;
	/** What choosing "keep both" would end up with — the honest preview. */
	both: ProgressSummary;
}

class AccountStore {
	/** False when the build has no Firebase project; the UI then hides itself. */
	readonly available = cloudConfigured();

	/** The signed-in learner's address, or null when signed out. */
	email = $state<string | null>(null);
	/** True while a sign-in link is outstanding on this browser. */
	linkSent = $state(false);
	/** True while signing in, signing out or sending a link. */
	busy = $state(false);
	sync = $state<SyncState>('idle');
	lastSyncedAt = $state<number | null>(null);
	/** Set when something went wrong, phrased for the learner. */
	error = $state<string | null>(null);
	/** Set while the two-device question is on screen; null the rest of the time. */
	pending = $state<MergeDecision | null>(null);
	/** Mirrors `uid`, for the UI; `signedIn` reads this. */
	private active = $state(false);

	private uid: string | null = null;
	private pushTimer: ReturnType<typeof setTimeout> | null = null;
	private pushing: Promise<void> | null = null;
	private dirty = false;
	private started = false;
	private watching = false;
	/** The two blobs behind `pending`, kept off the rune store (they're large). */
	private offered: {
		local: ProgressBlob;
		remote: ProgressBlob;
		remoteNewer: boolean;
	} | null = null;

	get signedIn(): boolean {
		return this.active;
	}

	/**
	 * Called once from the root layout. Loads the auth SDK only when this
	 * browser has a session to restore, so a first-time visitor downloads none
	 * of it.
	 */
	async start(): Promise<void> {
		if (this.started || !this.available || typeof window === 'undefined') return;
		this.started = true;

		const wasSignedIn = (await storage.get(SettingsKeys.accountActive)) === '1';
		this.linkSent = Boolean(await storage.get(SettingsKeys.accountEmailForLink));
		this.lastSyncedAt = Number(await storage.get(SettingsKeys.accountLastSync)) || null;
		if (!wasSignedIn) return;

		try {
			const { auth, authApi } = await firebase();
			authApi.onAuthStateChanged(auth, (user) => {
				void this.onUser(user?.uid ?? null, user?.email ?? null);
			});
		} catch {
			// Offline, or a blocked SDK: the app carries on from localStorage.
			this.sync = 'error';
		}
	}

	/** Sends a one-time sign-in link. No password is ever created or stored. */
	async sendLink(email: string): Promise<boolean> {
		if (!this.available) return false;
		this.busy = true;
		this.error = null;
		try {
			const { auth, authApi } = await firebase();
			await authApi.sendSignInLinkToEmail(auth, email, {
				// Firebase requires an absolute URL, and its host must be listed
				// under Authentication → Settings → Authorized domains.
				url: `${window.location.origin}/signin`,
				handleCodeInApp: true
			});
			// The link may be opened in a different tab, which won't remember who
			// asked for it unless we write the address down.
			await storage.set(SettingsKeys.accountEmailForLink, email);
			this.linkSent = true;
			return true;
		} catch (cause) {
			this.error = describe(cause);
			return false;
		} finally {
			this.busy = false;
		}
	}

	/** Forgets an outstanding link, so the form comes back. */
	async cancelLink(): Promise<void> {
		await storage.remove(SettingsKeys.accountEmailForLink);
		this.linkSent = false;
		this.error = null;
	}

	/**
	 * Finishes sign-in when the emailed link is opened. `fallbackEmail` covers
	 * the link being opened in a browser that never asked for it, where Firebase
	 * insists the address is typed again.
	 */
	async completeLinkSignIn(href: string, fallbackEmail?: string): Promise<boolean> {
		if (!this.available) return false;
		this.busy = true;
		this.error = null;
		try {
			const { auth, authApi } = await firebase();
			if (!authApi.isSignInWithEmailLink(auth, href)) {
				this.error = 'That link is not a sign-in link. Ask for a new one.';
				return false;
			}
			const email = (await storage.get(SettingsKeys.accountEmailForLink)) ?? fallbackEmail;
			if (!email) {
				// The caller turns this one into a "type your address" form rather
				// than showing it as a failure.
				this.error = 'needs-email';
				return false;
			}
			const credential = await authApi.signInWithEmailLink(auth, email, href);
			await storage.remove(SettingsKeys.accountEmailForLink);
			this.linkSent = false;
			await this.onUser(credential.user.uid, credential.user.email);
			return true;
		} catch (cause) {
			this.error = describe(cause);
			return false;
		} finally {
			this.busy = false;
		}
	}

	/**
	 * Signs out, pushing anything outstanding first. Progress stays in this
	 * browser: signing out is not "forget what I did", it is "stop backing it up".
	 */
	async signOut(): Promise<void> {
		this.busy = true;
		try {
			if (this.uid) await this.flush();
			const { auth, authApi } = await firebase();
			await authApi.signOut(auth);
		} catch {
			// Already gone, or offline — the local state below is what matters.
		} finally {
			this.uid = null;
			this.active = false;
			this.email = null;
			this.sync = 'idle';
			// An unanswered question about an account we are no longer in.
			this.pending = null;
			this.offered = null;
			await storage.remove(SettingsKeys.accountActive);
			this.busy = false;
		}
	}

	/** Reconciles now, on the learner's say-so. */
	async syncNow(): Promise<void> {
		if (!this.uid || this.pending) return;
		this.dirty = true;
		await this.reconcile(this.uid);
	}

	// -- the reconcile ------------------------------------------------------

	private async onUser(uid: string | null, email: string | null): Promise<void> {
		if (uid === null) {
			this.uid = null;
			this.active = false;
			this.email = null;
			await storage.remove(SettingsKeys.accountActive);
			return;
		}
		if (this.uid === uid) return;
		this.uid = uid;
		this.active = true;
		this.email = email;
		await storage.set(SettingsKeys.accountActive, '1');
		this.watchWrites();
		// The first time this browser meets this account, the two histories may
		// both be real — that is the one case the learner gets asked about.
		const asked = await storage.get(SettingsKeys.accountMergedUid);
		await this.reconcile(uid, asked !== uid);
	}

	/**
	 * Pulls the cloud copy, merges it with this browser's, writes the result
	 * both ways, and reloads the progress store so the merged scores show
	 * without a refresh.
	 */
	private async reconcile(uid: string, ask = false): Promise<void> {
		this.sync = 'syncing';
		try {
			const remote = await fetchRemote(uid);
			const local = await readBlob();
			const lastSync = Number(await storage.get(SettingsKeys.accountLastSync)) || 0;
			// Only the settings keys turn on this: a score is merged by which is
			// higher, never by which device wrote last.
			const remoteNewer = remote.updatedAt > lastSync;

			if (ask) {
				const here = summariseProgress(local);
				const cloud = summariseProgress(remote.blob);
				// Nothing to choose between when one side is empty, or when both
				// hold the same progress: merging is then the only answer there is,
				// and a dialog would be a question with one button.
				if (!here.empty && !cloud.empty && differInProgress(local, remote.blob)) {
					this.offered = { local, remote: remote.blob, remoteNewer };
					this.pending = {
						uid,
						here,
						cloud,
						both: summariseProgress(mergeProgress(local, remote.blob, remoteNewer))
					};
					// Nothing is written until the learner answers, so until then
					// this browser's progress is exactly as they left it.
					this.sync = 'idle';
					return;
				}
			}

			await this.apply(uid, mergeProgress(local, remote.blob, remoteNewer));
		} catch (cause) {
			this.error = describe(cause);
			this.sync = 'error';
		}
	}

	/**
	 * Settles the two-device question.
	 *
	 * `merge` is the recommended answer and takes the better of every number.
	 * The other two are there because the learner may know something the merge
	 * cannot: that one device was a friend's, or a run they want gone. Those two
	 * do discard, which is why they are never the default and never automatic.
	 */
	async resolveMerge(choice: MergeChoice): Promise<void> {
		const decision = this.pending;
		const offered = this.offered;
		this.pending = null;
		this.offered = null;
		if (!decision || !offered || this.uid !== decision.uid) return;

		this.sync = 'syncing';
		try {
			if (choice === 'remote') {
				// The cloud copy alone: clear the progress keys this browser holds
				// that it doesn't, or the "replace" would quietly be a merge.
				for (const key of Object.keys(offered.local)) {
					if (isSyncable(key) && offered.remote[key] === undefined) await storage.remove(key);
				}
			}
			const resolved =
				choice === 'merge'
					? mergeProgress(offered.local, offered.remote, offered.remoteNewer)
					: choice === 'local'
						? offered.local
						: { ...offered.remote };
			await this.apply(decision.uid, resolved);
		} catch (cause) {
			this.error = describe(cause);
			this.sync = 'error';
		}
	}

	/** Writes a settled blob both ways and refreshes what the UI is showing. */
	private async apply(uid: string, blob: ProgressBlob): Promise<void> {
		await writeBlob(blob);
		const at = await pushRemote(uid, syncablePart(blob));
		await storage.set(SettingsKeys.accountLastSync, String(at));
		await storage.set(SettingsKeys.accountMergedUid, uid);
		this.lastSyncedAt = at;
		this.dirty = false;
		this.sync = 'synced';
		// The merge may have raised scores and added completions under the
		// store's feet; it caches both, so it has to read them again.
		await progress.load();
	}

	/** Pushes on a debounce after writes stop. Attached once, on first sign-in. */
	private watchWrites(): void {
		if (this.watching) return;
		this.watching = true;
		observeStorage((key) => {
			// Our own bookkeeping writes would otherwise retrigger the push forever.
			if (key.startsWith('account_')) return;
			this.dirty = true;
			if (this.pushTimer) clearTimeout(this.pushTimer);
			this.pushTimer = setTimeout(() => void this.flush(), PUSH_DEBOUNCE);
		});
	}

	/** Writes whatever is outstanding, now. Safe to call when nothing is. */
	async flush(): Promise<void> {
		// An unanswered merge question means the cloud copy is still one of the
		// two choices on screen. Pushing over it now would answer it for them.
		if (!this.uid || !this.dirty || this.pending) return;
		// Two pushes at once would race over `updatedAt`; the second waits.
		this.pushing = (this.pushing ?? Promise.resolve()).then(async () => {
			if (!this.uid || !this.dirty) return;
			try {
				const at = await pushRemote(this.uid, syncablePart(await readBlob()));
				await storage.set(SettingsKeys.accountLastSync, String(at));
				this.lastSyncedAt = at;
				this.dirty = false;
				this.sync = 'synced';
			} catch {
				// Offline: stay dirty and try again after the next write or sync.
				this.sync = 'error';
			}
		});
		await this.pushing;
	}
}

/** Firebase's error codes, as something a learner can act on. */
function describe(cause: unknown): string {
	const code = (cause as { code?: string } | null)?.code ?? '';
	// The learner gets a calm sentence; whoever is debugging gets the code.
	// Without this an unmapped failure is indistinguishable from any other.
	console.error('[account]', code || 'no code', cause);
	switch (code) {
		case 'auth/invalid-email':
			return "That doesn't look like an email address.";
		case 'auth/invalid-action-code':
		case 'auth/expired-action-code':
			return 'That link has already been used, or has expired. Ask for a new one.';
		case 'auth/network-request-failed':
		case 'unavailable':
			return 'No connection. Your progress is safe in this browser, and will sync when you are back online.';
		case 'auth/operation-not-allowed':
			// Configuration, not the learner: email-link sign-in is switched off
			// for the Firebase project (Authentication → Sign-in method).
			return 'Signing in is not available right now. Your progress is safe in this browser.';
		case 'auth/unauthorized-continue-uri':
		case 'auth/invalid-continue-uri':
			// This site's domain is missing from Authentication → Settings →
			// Authorized domains.
			return 'Signing in is not available from this address. Your progress is safe in this browser.';
		case 'auth/too-many-requests':
			return 'Too many tries. Wait a minute, then ask for a new link.';
		case 'permission-denied':
			return "Your progress couldn't be saved to the cloud. It is still safe in this browser.";
		default:
			return 'Something went wrong. Your progress is safe in this browser.';
	}
}

export const account = new AccountStore();
