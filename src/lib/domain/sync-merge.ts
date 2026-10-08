// Merging two devices' progress into one.
//
// A learner practises on a laptop, signs in on a phone, and now two histories
// exist. The rule here is never "the last device wins": that silently eats a
// streak somebody earned. Every rule below takes the *better* of the two, or
// the union, and so is **idempotent** — merging the same pair twice, which
// happens on every app start, changes nothing after the first time.
//
// Idempotence is why mistake counts are maxed rather than summed. Summing
// would inflate a weak spot a little more with each start-up until the
// worksheet thought the learner could do nothing right.

import { quizStatsKeys } from './keys';
import { medalForStreak, type RibbonTier } from './progress';

/** The whole persisted map: storage keys to their raw string values. */
export type ProgressBlob = Record<string, string>;

/** How many entries the merged answer history and run log keep, per quiz. */
const ANSWER_HISTORY_LIMIT = 200;
const RUN_LOG_LIMIT = 50;

/**
 * Keys that describe *this device* rather than what the learner has learnt, and
 * so are never carried across. Navigation crumbs ("where was I?") would yank a
 * learner on their phone back to whatever the laptop had open, and the
 * analytics first-seen date is deliberately per-device.
 */
const DEVICE_LOCAL = new Set(['last_page', 'last_content_id', 'last_noun_progression_key']);

/** Prefixes of device-local keys (analytics, service-worker bookkeeping). */
const DEVICE_LOCAL_PREFIXES = ['aptabase', 'analytics_', 'sveltekit:', 'account_'];

/**
 * Characters Firestore refuses in a map field name. A storage key is only ever
 * built from quiz ids, so this should never fire — but a key that did contain
 * one would fail the whole write, taking every other key down with it.
 */
const FIRESTORE_UNSAFE = /[.~*/[\]]|^__/;

/** Whether a key belongs in the synced blob at all. */
export function isSyncable(key: string): boolean {
	if (DEVICE_LOCAL.has(key)) return false;
	if (FIRESTORE_UNSAFE.test(key)) return false;
	return !DEVICE_LOCAL_PREFIXES.some((prefix) => key.startsWith(prefix));
}

/** The suffixes whose values are numbers where the higher one is the truer one. */
const MAX_NUMBER_SUFFIXES = (() => {
	const k = quizStatsKeys('');
	return [k.score, k.streak, k.bestStreakLap, k.bestStreakAbsolute, k.lastPlayed, k.streakMisses];
})();

const SUFFIX = (() => {
	const k = quizStatsKeys('');
	return {
		answerHistory: k.answerHistory,
		runLog: k.runLog,
		mistakes: k.mistakesByCase,
		score: k.score,
		bestStreakAbsolute: k.bestStreakAbsolute,
		lastPlayed: k.lastPlayed
	};
})();

function parseJson(raw: string | undefined): unknown {
	if (!raw) return null;
	try {
		return JSON.parse(raw);
	} catch {
		return null;
	}
}

function asArray(raw: string | undefined): unknown[] {
	const parsed = parseJson(raw);
	return Array.isArray(parsed) ? parsed : [];
}

function asRecord(raw: string | undefined): Record<string, unknown> {
	const parsed = parseJson(raw);
	return parsed && typeof parsed === 'object' && !Array.isArray(parsed)
		? (parsed as Record<string, unknown>)
		: {};
}

/** The larger of two numeric strings, keeping whichever side actually had one. */
function maxNumber(a: string | undefined, b: string | undefined): string {
	const left = Number(a);
	const right = Number(b);
	return String(Math.max(Number.isFinite(left) ? left : 0, Number.isFinite(right) ? right : 0));
}

/** Union of two string lists, order preserved, first appearance winning. */
function unionList(a: string | undefined, b: string | undefined): string {
	const seen = new Set<string>();
	for (const entry of [...asArray(a), ...asArray(b)]) seen.add(String(entry));
	return JSON.stringify([...seen]);
}

/**
 * Two logs of timestamped entries into one, in time order and capped. Entries
 * sharing a timestamp are the same event seen twice (the push that saved it and
 * the pull that read it back), so one of them is dropped.
 */
function mergeTimeline(a: string | undefined, b: string | undefined, limit: number): string {
	const byTime = new Map<number, unknown>();
	let untimed: unknown[] = [];
	for (const entry of [...asArray(a), ...asArray(b)]) {
		const at = Number((entry as { at?: unknown })?.at);
		// Entries written before timestamps existed can't be deduped or ordered;
		// they're kept as a block at the front so they aren't silently lost.
		if (at) byTime.set(at, entry);
		else untimed.push(entry);
	}
	// The same untimed entry on both sides would otherwise double on every
	// merge, which would break idempotence. Keep only as many as the longer side had.
	const untimedCap = Math.max(
		asArray(a).filter((e) => !Number((e as { at?: unknown })?.at)).length,
		asArray(b).filter((e) => !Number((e as { at?: unknown })?.at)).length
	);
	untimed = untimed.slice(0, untimedCap);
	const timed = [...byTime.entries()].sort(([x], [y]) => x - y).map(([, entry]) => entry);
	return JSON.stringify([...untimed, ...timed].slice(-limit));
}

/** Per-category mistake counts, taking the higher count for each category. */
function mergeMistakes(a: string | undefined, b: string | undefined): string {
	const left = asRecord(a);
	const right = asRecord(b);
	const merged: Record<string, number> = {};
	for (const key of new Set([...Object.keys(left), ...Object.keys(right)])) {
		merged[key] = Math.max(Number(left[key]) || 0, Number(right[key]) || 0);
	}
	return JSON.stringify(merged);
}

function endsWithAny(key: string, suffixes: string[]): boolean {
	return suffixes.some((suffix) => suffix && key.endsWith(suffix));
}

/**
 * One key's two values into one.
 *
 * `preferRemote` settles the keys that have no "better" — a setting is a
 * preference, not an achievement, so the most recently *written* side wins and
 * the caller decides which that is from the two blobs' timestamps.
 */
function mergeValue(
	key: string,
	local: string | undefined,
	remote: string | undefined,
	preferRemote: boolean
): string {
	if (local === undefined) return remote!;
	if (remote === undefined) return local;
	if (local === remote) return local;

	if (endsWithAny(key, MAX_NUMBER_SUFFIXES)) return maxNumber(local, remote);
	if (key.endsWith('_completed_quizzes')) return unionList(local, remote);
	if (key.endsWith(SUFFIX.answerHistory)) {
		return mergeTimeline(local, remote, ANSWER_HISTORY_LIMIT);
	}
	if (key.endsWith(SUFFIX.runLog)) return mergeTimeline(local, remote, RUN_LOG_LIMIT);
	if (key.endsWith(SUFFIX.mistakes)) return mergeMistakes(local, remote);

	// Settings and saved selections: a preference, so newest write wins.
	return preferRemote ? remote : local;
}

/**
 * Merges the blob saved in the cloud into the one in this browser.
 *
 * `remoteNewer` says whether the cloud copy was written after this browser last
 * synced; it only decides the settings keys, never a score.
 */
export function mergeProgress(
	local: ProgressBlob,
	remote: ProgressBlob,
	remoteNewer: boolean
): ProgressBlob {
	const merged: ProgressBlob = {};
	for (const key of new Set([...Object.keys(local), ...Object.keys(remote)])) {
		if (!isSyncable(key)) {
			// A device-local key keeps this device's value and is never pushed.
			if (local[key] !== undefined) merged[key] = local[key];
			continue;
		}
		merged[key] = mergeValue(key, local[key], remote[key], remoteNewer);
	}
	return merged;
}

// -- describing a blob, so the learner can choose between two of them ---------

/**
 * What one device's progress amounts to, in the four things a learner would
 * actually weigh up when asked "which of these do you want?".
 *
 * It is a *description*, never an input to the merge: the merge takes the
 * better of every key regardless of which summary looks bigger. A device can
 * hold fewer finished exercises and still be the one with the gold medal.
 */
export interface ProgressSummary {
	/** Exercises marked finished, across every completion set. */
	done: number;
	/** Exercises with any practice recorded — finished or not. */
	practised: number;
	medals: Record<RibbonTier, number>;
	/** The highest streak anywhere, which is the headline number. */
	bestStreak: number;
	/** Epoch ms of the most recent practice, or null if there is none. */
	lastActive: number | null;
	/** True when there is nothing here worth asking about. */
	empty: boolean;
}

const COMPLETION_SUFFIX = '_completed_quizzes';

export function summariseProgress(blob: ProgressBlob): ProgressSummary {
	const medals: Record<RibbonTier, number> = { bronze: 0, silver: 0, gold: 0 };
	const done = new Set<string>();
	const practised = new Set<string>();
	let bestStreak = 0;
	let lastActive = 0;

	for (const [key, value] of Object.entries(blob)) {
		if (key.endsWith(COMPLETION_SUFFIX)) {
			// A quiz id is scoped to the set that holds it, so the same id in the
			// reading and the quest set can't collapse into one.
			for (const id of asArray(value)) done.add(`${key}:${id}`);
			continue;
		}
		if (key.endsWith(SUFFIX.bestStreakAbsolute)) {
			const streak = Number(value) || 0;
			bestStreak = Math.max(bestStreak, streak);
			const tier = medalForStreak(streak);
			if (tier) medals[tier]++;
			continue;
		}
		if (key.endsWith(SUFFIX.score)) {
			if ((Number(value) || 0) > 0) practised.add(key.slice(0, -SUFFIX.score.length));
			continue;
		}
		if (key.endsWith(SUFFIX.lastPlayed)) {
			const at = Number(value) || 0;
			lastActive = Math.max(lastActive, at);
			if (at) practised.add(key.slice(0, -SUFFIX.lastPlayed.length));
			continue;
		}
		if (key.endsWith(SUFFIX.answerHistory)) {
			for (const entry of asArray(value)) {
				lastActive = Math.max(lastActive, Number((entry as { at?: unknown })?.at) || 0);
			}
		}
	}

	return {
		done: done.size,
		practised: practised.size,
		medals,
		bestStreak,
		lastActive: lastActive || null,
		empty: done.size === 0 && practised.size === 0 && bestStreak === 0
	};
}

/**
 * Whether two blobs differ in anything the learner would notice — the test for
 * whether the merge is worth interrupting them over.
 *
 * Settings-only differences don't count: nobody needs a dialog to be told that
 * one device had calm effects on.
 */
export function differInProgress(a: ProgressBlob, b: ProgressBlob): boolean {
	const left = summariseProgress(a);
	const right = summariseProgress(b);
	if (left.done !== right.done || left.practised !== right.practised) return true;
	if (left.bestStreak !== right.bestStreak) return true;
	return (['bronze', 'silver', 'gold'] as const).some((t) => left.medals[t] !== right.medals[t]);
}

/** The syncable subset of a blob — what actually gets written to the cloud. */
export function syncablePart(blob: ProgressBlob): ProgressBlob {
	const out: ProgressBlob = {};
	for (const [key, value] of Object.entries(blob)) {
		if (isSyncable(key)) out[key] = value;
	}
	return out;
}
