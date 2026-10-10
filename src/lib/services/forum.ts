// The forum's Firestore seam. Reads are public (no account needed to browse);
// every write needs the signed-in learner, and the security rules in
// firestore.rules are what enforce that — this file only makes the calls.
//
// Collections:
//   forum_threads/{id}            one topic (a report, a question, an idea)
//   forum_threads/{id}/posts/{id} its replies, oldest first
//   forum_profiles/{uid}          the learner's posting name + what they've read
//   forum_admins/{uid}            exists ⇒ moderator (created by hand in the console)
//
// Like the progress sync, the SDK is loaded lazily through `firebase()`, so a
// visitor who never opens the forum downloads none of it.

import {
	compact,
	LIMITS,
	clip,
	type ForumCategory,
	type ForumPost,
	type ForumProfile,
	type ForumThread,
	type ReportKind,
	type ReportTarget,
	type ThreadStatus
} from '$lib/domain/forum';
import { firebase } from '$lib/services/firebase';

type Loaded = Awaited<ReturnType<typeof firebase>>;

const THREADS = 'forum_threads';
const POSTS = 'posts';
const PROFILES = 'forum_profiles';
const ADMINS = 'forum_admins';

/** How many topics a list page shows. */
export const PAGE = 30;

type Snap = { id: string; data(): Record<string, unknown> | undefined };

function toThread(snap: Snap): ForumThread {
	const d = snap.data() ?? {};
	const str = (k: string) => (typeof d[k] === 'string' ? (d[k] as string) : undefined);
	const num = (k: string) => (typeof d[k] === 'number' ? (d[k] as number) : undefined);
	return {
		id: snap.id,
		category: (str('category') as ForumCategory) ?? 'general',
		title: str('title') ?? '',
		body: str('body') ?? '',
		authorUid: str('authorUid') ?? '',
		authorName: str('authorName') ?? 'Learner',
		createdAt: num('createdAt') ?? 0,
		updatedAt: num('updatedAt') ?? 0,
		replyCount: num('replyCount') ?? 0,
		lastReplyAt: num('lastReplyAt') ?? null,
		lastReplyName: str('lastReplyName') ?? null,
		status: (str('status') as ThreadStatus) ?? 'open',
		notify: d.notify !== false,
		likeCount: num('likeCount') ?? 0,
		courseId: str('courseId'),
		quizId: str('quizId'),
		quizTitle: str('quizTitle'),
		quizType: str('quizType'),
		level: str('level'),
		questionNumber: num('questionNumber'),
		questionText: str('questionText'),
		reportKind: str('reportKind') as ReportKind | undefined
	};
}

function toPost(threadId: string, snap: Snap): ForumPost {
	const d = snap.data() ?? {};
	return {
		id: snap.id,
		threadId,
		body: typeof d.body === 'string' ? d.body : '',
		authorUid: typeof d.authorUid === 'string' ? d.authorUid : '',
		authorName: typeof d.authorName === 'string' ? d.authorName : 'Learner',
		createdAt: typeof d.createdAt === 'number' ? d.createdAt : 0,
		likeCount: typeof d.likeCount === 'number' ? d.likeCount : 0
	};
}

// -- reading (public) ---------------------------------------------------------

export interface ListFilter {
	category?: ForumCategory | null;
	quizId?: string;
	authorUid?: string;
	limit?: number;
}

/** The newest-activity-first list, optionally one board, one quiz or one author. */
export async function listThreads(filter: ListFilter = {}): Promise<ForumThread[]> {
	const { db, storeApi: s } = await firebase();
	const parts = [];
	if (filter.category) parts.push(s.where('category', '==', filter.category));
	if (filter.quizId) parts.push(s.where('quizId', '==', filter.quizId));
	if (filter.authorUid) parts.push(s.where('authorUid', '==', filter.authorUid));
	parts.push(s.orderBy('updatedAt', 'desc'), s.limit(filter.limit ?? PAGE));
	const result = await s.getDocs(s.query(s.collection(db, THREADS), ...parts));
	return result.docs.map(toThread);
}

export async function getThread(id: string): Promise<ForumThread | null> {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDoc(s.doc(db, THREADS, id));
	return snap.exists() ? toThread(snap) : null;
}

export async function listPosts(threadId: string): Promise<ForumPost[]> {
	const { db, storeApi: s } = await firebase();
	const result = await s.getDocs(
		s.query(s.collection(db, THREADS, threadId, POSTS), s.orderBy('createdAt', 'asc'), s.limit(200))
	);
	return result.docs.map((d) => toPost(threadId, d));
}

// -- writing (signed in) ------------------------------------------------------

export interface NewThread {
	category: ForumCategory;
	title: string;
	body: string;
	notify: boolean;
	/** Set for a report filed from an exercise. */
	target?: ReportTarget;
	reportKind?: ReportKind;
}

/** Files a topic. Returns its id, for the link to it. */
export async function createThread(uid: string, name: string, input: NewThread): Promise<string> {
	const { db, storeApi: s } = await firebase();
	const now = Date.now();
	const t = input.target;
	const data = compact({
		category: input.category,
		title: clip(input.title, LIMITS.title),
		body: input.body.trim().slice(0, LIMITS.body),
		authorUid: uid,
		authorName: clip(name, LIMITS.name),
		createdAt: now,
		updatedAt: now,
		replyCount: 0,
		lastReplyAt: null,
		lastReplyName: null,
		status: 'open' as ThreadStatus,
		notify: input.notify,
		likeCount: 0,
		courseId: t?.courseId,
		quizId: t?.quizId,
		quizTitle: t?.quizTitle,
		quizType: t?.quizType,
		level: t?.level,
		questionNumber: t?.question?.number,
		questionText: t?.question?.text ? clip(t.question.text, 200) : undefined,
		reportKind: input.reportKind
	});
	const ref = await s.addDoc(s.collection(db, THREADS), data);
	return ref.id;
}

/**
 * A reply: the post, plus the thread's counters, in one batch so a list never
 * shows a count the posts don't match. The rules only let the counter move by
 * exactly one, and only when the post's author is the one bumping it.
 */
export async function addPost(threadId: string, uid: string, name: string, body: string): Promise<ForumPost> {
	const { db, storeApi: s } = await firebase();
	const now = Date.now();
	const text = body.trim().slice(0, LIMITS.body);
	const postRef = s.doc(s.collection(db, THREADS, threadId, POSTS));
	const batch = s.writeBatch(db);
	batch.set(postRef, { body: text, authorUid: uid, authorName: clip(name, LIMITS.name), createdAt: now, likeCount: 0 });
	batch.update(s.doc(db, THREADS, threadId), {
		replyCount: s.increment(1),
		lastReplyAt: now,
		lastReplyBy: uid,
		lastReplyName: clip(name, LIMITS.name),
		updatedAt: now
	});
	await batch.commit();
	return { id: postRef.id, threadId, body: text, authorUid: uid, authorName: name, createdAt: now, likeCount: 0 };
}

// -- likes --------------------------------------------------------------------
// One `likes/{uid}` document under the topic or the reply, so a learner can
// like a thing once; the counter on the parent moves with it in the same
// batch, and the rules only let it move by one in step with that document.

const LIKES = 'likes';

/** `postId` null = the topic itself. */
function likeRefs(s: Loaded['storeApi'], db: Loaded['db'], threadId: string, postId: string | null, uid: string) {
	const parent = postId ? s.doc(db, THREADS, threadId, POSTS, postId) : s.doc(db, THREADS, threadId);
	return { parent, like: s.doc(parent, LIKES, uid) };
}

export async function setLike(threadId: string, postId: string | null, uid: string, liked: boolean): Promise<void> {
	const { db, storeApi: s } = await firebase();
	const { parent, like } = likeRefs(s, db, threadId, postId, uid);
	const batch = s.writeBatch(db);
	if (liked) batch.set(like, { at: Date.now() });
	else batch.delete(like);
	batch.update(parent, { likeCount: s.increment(liked ? 1 : -1) });
	await batch.commit();
}

/** Which of the topic and its replies this learner has liked: 'thread' or a post id. */
export async function myLikes(threadId: string, postIds: string[], uid: string): Promise<Set<string>> {
	const { db, storeApi: s } = await firebase();
	const checks = [null, ...postIds].map(async (postId) => {
		const { like } = likeRefs(s, db, threadId, postId, uid);
		const snap = await s.getDoc(like);
		return snap.exists() ? (postId ?? 'thread') : null;
	});
	return new Set((await Promise.all(checks)).filter((x): x is string => x !== null));
}

/** The author (or a moderator) moves a topic between open, answered and fixed. */
export async function setStatus(threadId: string, status: ThreadStatus): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.updateDoc(s.doc(db, THREADS, threadId), { status, updatedAt: Date.now() });
}

/** The author turns replies-notification on or off for one topic. */
export async function setNotify(threadId: string, notify: boolean): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.updateDoc(s.doc(db, THREADS, threadId), { notify });
}

export async function deleteThread(threadId: string): Promise<void> {
	const { db, storeApi: s } = await firebase();
	// The posts stay as orphans — a client cannot delete a subcollection in one
	// go, and nothing lists them without the thread. A cleanup job can follow.
	await s.deleteDoc(s.doc(db, THREADS, threadId));
}

export async function deletePost(threadId: string, postId: string): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.deleteDoc(s.doc(db, THREADS, threadId, POSTS, postId));
}

// -- the learner's profile ----------------------------------------------------

export async function getProfile(uid: string): Promise<ForumProfile | null> {
	const { db, storeApi: s } = await firebase();
	const snap = await s.getDoc(s.doc(db, PROFILES, uid));
	if (!snap.exists()) return null;
	const d = snap.data() as Partial<ForumProfile>;
	const seen: Record<string, number> = {};
	if (d.seen && typeof d.seen === 'object') {
		for (const [k, v] of Object.entries(d.seen)) if (typeof v === 'number') seen[k] = v;
	}
	return { name: typeof d.name === 'string' ? d.name : '', seen, updatedAt: Number(d.updatedAt) || 0 };
}

export async function saveProfile(uid: string, profile: Partial<ForumProfile>): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.setDoc(s.doc(db, PROFILES, uid), compact({ ...profile, updatedAt: Date.now() }), { merge: true });
}

/** Records that the learner has read a topic up to `replyCount` replies. */
export async function markSeen(uid: string, threadId: string, replyCount: number): Promise<void> {
	const { db, storeApi: s } = await firebase();
	await s.setDoc(
		s.doc(db, PROFILES, uid),
		{ seen: { [threadId]: replyCount }, updatedAt: Date.now() },
		{ merge: true }
	);
}

/** True when a `forum_admins/{uid}` document exists — the console creates those. */
export async function isAdmin(uid: string): Promise<boolean> {
	try {
		const { db, storeApi: s } = await firebase();
		const snap = await s.getDoc(s.doc(db, ADMINS, uid));
		return snap.exists();
	} catch {
		return false;
	}
}

/** Firestore's failures, phrased for the learner. */
export function describeForumError(cause: unknown): string {
	const code = (cause as { code?: string } | null)?.code ?? '';
	console.error('[forum]', code || 'no code', cause);
	switch (code) {
		case 'permission-denied':
			return 'That was not allowed. Are you still signed in?';
		case 'unavailable':
			return 'No connection. Try again when you are back online.';
		case 'failed-precondition':
			// A missing composite index: the console error carries a link that
			// creates it. See firestore.indexes.json for the ones the app needs.
			return 'The forum is not fully set up yet (a database index is missing).';
		default:
			return 'Something went wrong. Please try again.';
	}
}
