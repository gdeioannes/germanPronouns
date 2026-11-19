// When the "How do you like the site?" card may ask. Pure rules, no browser:
// the state store (state/feedback.svelte.ts) keeps the record in this
// browser and calls these.
//
// The rules, as agreed with the owner (2026-11-19):
//   - only after 5 minutes of real use in total (counted across visits:
//     time with the page in front of the learner and a tap, key or scroll in
//     the last minute), and only at a good moment — a run just finished well;
//   - a star tap (any rating) → quiet for a week;
//   - the × → gone until the next calendar day;
//   - three × in a row with no rating between → quiet for 30 days, so a
//     learner who keeps saying no is not asked every single day;
//   - at most once per page load.

export const ACTIVE_NEEDED_MS = 5 * 60 * 1000;
export const AFTER_RATING_MS = 7 * 24 * 60 * 60 * 1000;
export const CLOSES_BEFORE_PAUSE = 3;
export const PAUSE_MS = 30 * 24 * 60 * 60 * 1000;
/** A rating at or under this opens "what could be better?". */
export const LOW_RATING = 3;

export interface AskRecord {
	/** Real use so far, in ms, summed over visits. */
	activeMs: number;
	/** Epoch ms of the last star tap, or 0. */
	ratedAt: number;
	/** Epoch ms of the last ×, or 0. */
	closedAt: number;
	/** × taps since the last rating. */
	closeStreak: number;
	/** No asking before this epoch ms (the 30-day pause), or 0. */
	pausedUntil: number;
}

export const EMPTY_RECORD: AskRecord = { activeMs: 0, ratedAt: 0, closedAt: 0, closeStreak: 0, pausedUntil: 0 };

/** A stored record, made safe: anything missing or broken reads as zero. */
export function parseRecord(raw: string | null): AskRecord {
	if (!raw) return { ...EMPTY_RECORD };
	try {
		const x = JSON.parse(raw) as Partial<Record<keyof AskRecord, unknown>>;
		const num = (v: unknown) => (typeof v === 'number' && Number.isFinite(v) && v > 0 ? v : 0);
		return {
			activeMs: num(x.activeMs),
			ratedAt: num(x.ratedAt),
			closedAt: num(x.closedAt),
			closeStreak: Math.floor(num(x.closeStreak)),
			pausedUntil: num(x.pausedUntil)
		};
	} catch {
		return { ...EMPTY_RECORD };
	}
}

/** The local calendar day of an epoch ms, as "YYYY-MM-DD". */
function day(ms: number): string {
	const d = new Date(ms);
	return `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;
}

/** Whether the card may show now. */
export function mayAsk(r: AskRecord, now: number): boolean {
	if (r.activeMs < ACTIVE_NEEDED_MS) return false;
	if (r.pausedUntil && now < r.pausedUntil) return false;
	if (r.ratedAt && now - r.ratedAt < AFTER_RATING_MS) return false;
	if (r.closedAt && day(r.closedAt) === day(now)) return false;
	return true;
}

/** A star was tapped: quiet for a week, and the × count starts over. */
export function afterRating(r: AskRecord, now: number): AskRecord {
	return { ...r, ratedAt: now, closeStreak: 0, pausedUntil: 0 };
}

/** The × was tapped: tomorrow again, or a 30-day pause after the third in a row. */
export function afterClose(r: AskRecord, now: number): AskRecord {
	const streak = r.closeStreak + 1;
	if (streak >= CLOSES_BEFORE_PAUSE) {
		return { ...r, closedAt: now, closeStreak: 0, pausedUntil: now + PAUSE_MS };
	}
	return { ...r, closedAt: now, closeStreak: streak };
}
