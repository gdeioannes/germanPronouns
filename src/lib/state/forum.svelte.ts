// The forum inbox: the signed-in learner's own topics, their posting name,
// and which of their topics have replies they have not read yet. That last
// list is the "someone answered you" signal — a dot on the forum link in the
// nav, a banner on the forum page, a tag on the report in the quiz.
//
// It is pull, not push: there is no server to send mail. The next time the
// learner opens the app signed in, the store compares each topic's reply
// count with the count it had when they last opened the topic. Cheap (one
// query), and enough for "did anyone answer my report?".

import { defaultName, unreadThreads, type ForumThread } from '$lib/domain/forum';
import { getProfile, isAdmin, listThreads, markSeen, saveProfile } from '$lib/services/forum';
import { account } from '$lib/state/account.svelte';

class ForumStore {
	/** The learner's topics, newest activity first. */
	mine = $state<ForumThread[]>([]);
	/** The name they post under. */
	name = $state('');
	/** Topics of theirs with replies they have not seen (and notify on). */
	unread = $state<ForumThread[]>([]);
	admin = $state(false);
	loaded = $state(false);
	busy = $state(false);

	private seen: Record<string, number> = {};
	private loadedFor: string | null = null;

	/** Loads once per signed-in account; a no-op signed out. Safe to call often. */
	async refresh(force = false): Promise<void> {
		const uid = account.userId;
		if (!uid) {
			this.reset();
			return;
		}
		if (!force && this.loadedFor === uid) return;
		this.busy = true;
		try {
			const [profile, mine, admin] = await Promise.all([
				getProfile(uid),
				listThreads({ authorUid: uid, limit: 50 }),
				isAdmin(uid)
			]);
			this.seen = profile?.seen ?? {};
			this.name = profile?.name || defaultName(account.email);
			this.mine = mine;
			this.admin = admin;
			this.unread = unreadThreads(mine, this.seen);
			this.loadedFor = uid;
			this.loaded = true;
		} catch (cause) {
			console.error('[forum] inbox', cause);
		} finally {
			this.busy = false;
		}
	}

	/** The learner opened a topic: its replies so far count as read. */
	async read(thread: ForumThread): Promise<void> {
		const uid = account.userId;
		if (!uid || thread.authorUid !== uid) return;
		if ((this.seen[thread.id] ?? 0) >= thread.replyCount) return;
		this.seen = { ...this.seen, [thread.id]: thread.replyCount };
		this.unread = this.unread.filter((t) => t.id !== thread.id);
		try {
			await markSeen(uid, thread.id, thread.replyCount);
		} catch {
			// Offline: the dot comes back next time, which is the safe failure.
		}
	}

	async rename(name: string): Promise<void> {
		const uid = account.userId;
		if (!uid) return;
		this.name = name.trim();
		await saveProfile(uid, { name: this.name });
	}

	/** A topic the learner just filed goes straight into their list. */
	filed(thread: ForumThread): void {
		this.mine = [thread, ...this.mine.filter((t) => t.id !== thread.id)];
	}

	private reset(): void {
		this.mine = [];
		this.unread = [];
		this.name = '';
		this.admin = false;
		this.seen = {};
		this.loadedFor = null;
		this.loaded = false;
	}
}

export const forum = new ForumStore();
