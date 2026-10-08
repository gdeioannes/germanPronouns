// The Firebase seam: config, lazy SDK loading, and the two cloud operations
// the app actually needs (read my blob, write my blob).
//
// Three things are deliberate here.
//
// 1. The config is read from `import.meta.env`, not `$env/static/public`, so a
//    build with no Firebase keys configured still succeeds — the feature simply
//    reports itself unavailable and the app stays exactly as it was. Logging in
//    is optional for the learner; it must also be optional for the build.
// 2. The SDK is `import()`ed, never imported at the top level. Firebase auth
//    plus Firestore is a few hundred kilobytes, and a visitor who never signs
//    in should not pay for it on the landing page.
// 3. The web config (apiKey and friends) is public by design — it identifies
//    the project, it does not authorise anything. The Firestore security rule
//    is what protects the data:
//
//      match /databases/{db}/documents {
//        match /users/{uid} {
//          allow read, write: if request.auth != null && request.auth.uid == uid;
//        }
//      }

import type { ProgressBlob } from '$lib/domain/sync-merge';

const env = import.meta.env as Record<string, string | undefined>;

const config = {
	apiKey: env.PUBLIC_FIREBASE_API_KEY,
	authDomain: env.PUBLIC_FIREBASE_AUTH_DOMAIN,
	projectId: env.PUBLIC_FIREBASE_PROJECT_ID,
	appId: env.PUBLIC_FIREBASE_APP_ID
};

/** Whether this build was given a Firebase project to talk to. */
export function cloudConfigured(): boolean {
	return Boolean(config.apiKey && config.authDomain && config.projectId && config.appId);
}

type Loaded = {
	auth: import('firebase/auth').Auth;
	authApi: typeof import('firebase/auth');
	db: import('firebase/firestore').Firestore;
	storeApi: typeof import('firebase/firestore');
};

let loading: Promise<Loaded> | null = null;

/** Loads and initialises Firebase once; later calls share the same promise. */
export function firebase(): Promise<Loaded> {
	if (!cloudConfigured()) {
		return Promise.reject(new Error('Firebase is not configured for this build.'));
	}
	loading ??= (async () => {
		const [{ initializeApp, getApps }, authApi, storeApi] = await Promise.all([
			import('firebase/app'),
			import('firebase/auth'),
			import('firebase/firestore')
		]);
		const app = getApps()[0] ?? initializeApp(config as Required<typeof config>);
		const auth = authApi.getAuth(app);
		// The learner stays signed in across visits; without this the session
		// would live only as long as the tab, which defeats the point.
		await authApi.setPersistence(auth, authApi.browserLocalPersistence).catch(() => {});
		return { auth, authApi, db: storeApi.getFirestore(app), storeApi };
	})();
	return loading;
}

/** Where one learner's progress lives: a single document, one field. */
function docFor(uid: string, loaded: Loaded) {
	return loaded.storeApi.doc(loaded.db, 'users', uid);
}

export interface RemoteProgress {
	blob: ProgressBlob;
	/** Epoch ms of the last cloud write, or 0 when the document is new. */
	updatedAt: number;
}

/** Reads the learner's stored progress, or an empty blob when they have none yet. */
export async function fetchRemote(uid: string): Promise<RemoteProgress> {
	const loaded = await firebase();
	const snapshot = await loaded.storeApi.getDoc(docFor(uid, loaded));
	if (!snapshot.exists()) return { blob: {}, updatedAt: 0 };
	const raw = snapshot.data() as { data?: unknown; updatedAt?: unknown };
	const blob: ProgressBlob = {};
	if (raw.data && typeof raw.data === 'object') {
		for (const [key, value] of Object.entries(raw.data as Record<string, unknown>)) {
			if (typeof value === 'string') blob[key] = value;
		}
	}
	return { blob, updatedAt: Number(raw.updatedAt) || 0 };
}

/**
 * Writes the whole blob back as one document. One write per sync rather than
 * one per key: Firestore bills per document write, and a quiz can touch a
 * dozen keys in a single answer.
 */
export async function pushRemote(uid: string, blob: ProgressBlob): Promise<number> {
	const loaded = await firebase();
	const updatedAt = Date.now();
	await loaded.storeApi.setDoc(docFor(uid, loaded), { data: blob, updatedAt });
	return updatedAt;
}
