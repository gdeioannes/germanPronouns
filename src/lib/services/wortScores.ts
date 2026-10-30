// The world Bestenliste for Wortblöcke: an append-only Firestore collection,
// readable by everyone and written the arcade way — five letters, no login.
// A build without Firebase keys simply has no world board; the local table
// keeps working, same as every other optional cloud feature here.

import { cloudConfigured, firebase } from './firebase';
import { sanitizeName, SCORE_CAP, type WortScore } from '$lib/domain/wortbloecke';

const COLLECTION = 'wort_scores';

/** Whether this build can show the world board at all. */
export function worldBoardAvailable(): boolean {
	return cloudConfigured();
}

/**
 * Writes one score to the world board, fire-and-forget: making the table
 * locally is what triggers it, and a lost write loses nothing but glory.
 */
export async function submitWorldScore(score: WortScore): Promise<boolean> {
	if (!cloudConfigured()) return false;
	try {
		const { db, storeApi } = await firebase();
		await storeApi.addDoc(storeApi.collection(db, COLLECTION), {
			name: sanitizeName(score.name),
			pts: Math.round(score.pts),
			level: score.level,
			at: score.at
		});
		return true;
	} catch {
		return false;
	}
}

/** The world's best hundred, highest first — null when offline or unavailable. */
export async function fetchWorldScores(): Promise<WortScore[] | null> {
	if (!cloudConfigured()) return null;
	try {
		const { db, storeApi } = await firebase();
		const snap = await storeApi.getDocs(
			storeApi.query(
				storeApi.collection(db, COLLECTION),
				storeApi.orderBy('pts', 'desc'),
				storeApi.limit(SCORE_CAP)
			)
		);
		return snap.docs.map((d) => {
			const x = d.data();
			return {
				name: sanitizeName(String(x.name ?? '')),
				pts: Number(x.pts) || 0,
				level: String(x.level ?? ''),
				at: Number(x.at) || 0
			};
		});
	} catch {
		return null;
	}
}
