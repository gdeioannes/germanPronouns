// "Everything you hold about me": the export (GDPR Art. 15/20) and the erase
// (Art. 17) behind Settings → Your data.
//
// Both walk the same map of where a learner's data lives:
//
//   this browser       every localStorage key the site wrote
//   users/{uid}        the synced progress blob
//   forum_profiles/{uid}  posting name + which replies were read
//   forum_threads where authorUid == uid       their topics
//   collectionGroup posts where authorUid == uid  their replies anywhere
//   collectionGroup likes where uid == uid     their likes (likes written
//                                              before 2026-11-11 carry no uid
//                                              field and can't be found this way)
//   Firebase Authentication                    email, uid, sign-in times
//
// Aptabase holds nothing that identifies anyone, and the Wortblöcke board
// stores a five-letter name with no uid, so neither is part of this.

import { firebase } from '$lib/services/firebase';
import { getProfile, listThreads, listPosts } from '$lib/services/forum';
import { readBlob } from '$lib/services/storage';

const THREADS = 'forum_threads';

export interface MyDataExport {
	exportedAt: string;
	site: string;
	note: string;
	thisBrowser: Record<string, unknown>;
	account?: {
		uid: string;
		email: string | null;
		createdAt?: string;
		lastSignInAt?: string;
	};
	cloudProgress?: { updatedAt: number; data: Record<string, unknown> } | null;
	forum?: {
		profile: unknown;
		topics: unknown[];
		replies: unknown[];
		likes: string[];
	};
}

/** Stored values are strings; most are JSON. Show them as data where we can. */
function parsed(blob: Record<string, unknown>): Record<string, unknown> {
	const out: Record<string, unknown> = {};
	for (const [key, value] of Object.entries(blob)) {
		if (typeof value !== 'string') {
			out[key] = value;
			continue;
		}
		try {
			out[key] = JSON.parse(value);
		} catch {
			out[key] = value;
		}
	}
	return out;
}

/** The learner's replies anywhere in the forum, with the topic each sits under. */
async function myReplyRefs(uid: string) {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDocs(s.query(s.collectionGroup(db, 'posts'), s.where('authorUid', '==', uid)));
	return snap.docs.map((d) => ({ ref: d.ref, threadId: d.ref.parent.parent?.id ?? '', data: d.data() }));
}

/** The learner's likes, as {threadId, postId|null}. */
async function myLikeRefs(uid: string) {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDocs(s.query(s.collectionGroup(db, 'likes'), s.where('uid', '==', uid)));
	return snap.docs.map((d) => {
		// forum_threads/T/likes/U  or  forum_threads/T/posts/P/likes/U
		const parts = d.ref.path.split('/');
		return parts.length === 6
			? { ref: d.ref, threadId: parts[1], postId: parts[3] }
			: { ref: d.ref, threadId: parts[1], postId: null as string | null };
	});
}

/** Every topic the learner started, however many. */
async function myThreadIds(uid: string): Promise<string[]> {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDocs(s.query(s.collection(db, THREADS), s.where('authorUid', '==', uid)));
	return snap.docs.map((d) => d.id);
}

/**
 * Collects everything into one object. `uid` null = signed out, and then this
 * browser is all there is.
 */
export async function collectMyData(uid: string | null): Promise<MyDataExport> {
	const out: MyDataExport = {
		exportedAt: new Date().toISOString(),
		site: typeof window !== 'undefined' ? window.location.origin : '',
		note: uid
			? 'Everything this site stores about you: this browser, your account, your synced progress and your forum activity.'
			: 'Everything this site stores about you. You are not signed in, so all of it lives in this browser.',
		thisBrowser: parsed(await readBlob())
	};
	if (!uid) return out;

	const { auth, db, storeApi: s } = await firebase();
	const user = auth.currentUser;
	out.account = {
		uid,
		email: user?.email ?? null,
		createdAt: user?.metadata.creationTime,
		lastSignInAt: user?.metadata.lastSignInTime
	};

	const progressSnap = await s.getDoc(s.doc(db, 'users', uid));
	if (progressSnap.exists()) {
		const raw = progressSnap.data() as { data?: Record<string, unknown>; updatedAt?: number };
		out.cloudProgress = { updatedAt: Number(raw.updatedAt) || 0, data: parsed(raw.data ?? {}) };
	} else {
		out.cloudProgress = null;
	}

	const [profile, topics, replies, likes] = await Promise.all([
		getProfile(uid),
		listThreads({ authorUid: uid, limit: 500 }),
		myReplyRefs(uid),
		myLikeRefs(uid).catch(() => [])
	]);
	out.forum = {
		profile,
		topics,
		replies: replies.map((r) => ({ threadId: r.threadId, postId: r.ref.id, ...r.data })),
		likes: likes.map((l) => (l.postId ? `${l.threadId}/${l.postId}` : l.threadId))
	};
	return out;
}

/** Hands the export to the browser as a .json download. */
export function downloadJson(data: unknown, filename: string): void {
	const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
	const url = URL.createObjectURL(blob);
	const a = document.createElement('a');
	a.href = url;
	a.download = filename;
	document.body.appendChild(a);
	a.click();
	a.remove();
	setTimeout(() => URL.revokeObjectURL(url), 1000);
}

/**
 * Deletes every cloud document that belongs to the learner. Runs while still
 * signed in — the rules need the uid. Each step is independent, so one that
 * fails (a topic someone else's moderator already removed) doesn't stop the
 * rest; the first failure is rethrown at the end so the caller can say so.
 */
export async function eraseCloudData(uid: string): Promise<void> {
	const { db, storeApi: s } = await firebase();
	let firstError: unknown = null;
	const attempt = async (step: () => Promise<unknown>) => {
		try {
			await step();
		} catch (cause) {
			firstError ??= cause;
		}
	};

	// 1. Likes on other people's topics and replies: take each back the normal
	// way, so the counter on the parent drops with it.
	const likes = await myLikeRefs(uid).catch(() => []);
	for (const like of likes) {
		await attempt(async () => {
			const parent = like.postId
				? s.doc(db, THREADS, like.threadId, 'posts', like.postId)
				: s.doc(db, THREADS, like.threadId);
			const batch = s.writeBatch(db);
			batch.delete(like.ref);
			batch.update(parent, { likeCount: s.increment(-1) });
			await batch.commit();
		});
	}

	// 2. Their own topics, with every reply and like under them (the rules let a
	// topic's author clear it out). Children first: once the topic is gone the
	// rule can no longer check who started it.
	for (const threadId of await myThreadIds(uid)) {
		await attempt(async () => {
			const posts = await listPosts(threadId);
			for (const post of posts) {
				const postRef = s.doc(db, THREADS, threadId, 'posts', post.id);
				const postLikes = await s.getDocs(s.collection(postRef, 'likes'));
				for (const l of postLikes.docs) await s.deleteDoc(l.ref);
				await s.deleteDoc(postRef);
			}
			const threadRef = s.doc(db, THREADS, threadId);
			const threadLikes = await s.getDocs(s.collection(threadRef, 'likes'));
			for (const l of threadLikes.docs) await s.deleteDoc(l.ref);
			await s.deleteDoc(threadRef);
		});
	}

	// 3. Their replies under other people's topics. If theirs was the last
	// reply, the topic's "last reply by" line goes too.
	const replies = await myReplyRefs(uid).catch((cause) => {
		firstError ??= cause;
		return [];
	});
	for (const reply of replies) {
		await attempt(async () => {
			const postLikes = await s.getDocs(s.collection(reply.ref, 'likes'));
			for (const l of postLikes.docs) await s.deleteDoc(l.ref);
			await s.deleteDoc(reply.ref);
		});
	}
	const touched = new Set(replies.map((r) => r.threadId).filter(Boolean));
	for (const threadId of touched) {
		await attempt(async () => {
			const threadRef = s.doc(db, THREADS, threadId);
			const snap = await s.getDoc(threadRef);
			if (snap.exists() && snap.data().lastReplyBy === uid) {
				await s.updateDoc(threadRef, { lastReplyBy: null, lastReplyName: null });
			}
		});
	}

	// 4. The profile and the synced progress.
	await attempt(() => s.deleteDoc(s.doc(db, 'forum_profiles', uid)));
	await attempt(() => s.deleteDoc(s.doc(db, 'users', uid)));

	if (firstError) throw firstError;
}
