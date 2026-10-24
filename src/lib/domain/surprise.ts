// The deck's surprises: a story episode, a song, Ja oder Nein?, a
// "Schreib mir!" character, or the word check when it is due (never taken, or
// a month since the last). They are treats in the learning, never in its way,
// so a hand holds at most ONE. Each deal rolls once whether a surprise comes
// at all, and only then picks which kind, among the kinds that have something
// to offer right now. A kind with nothing left (every episode finished, every
// character met) simply drops out of the draw. Nothing is paid for: there are
// no tickets, and every surprise card that turns up can be played.

export type SurpriseKind = 'story' | 'song' | 'play' | 'chat' | 'check';

/** The chance a hand holds a surprise. */
export const SURPRISE_CHANCE = 0.3;
/** The chance for the first deal after a passed run: finishing well earns a treat more often. */
export const SURPRISE_BOOST_CHANCE = 0.6;

const BOOST_KEY = 'surprise_boost';
const FIRST_KEY = 'surprise_first_dealt';

export interface SurpriseCandidate<T> {
	kind: SurpriseKind;
	/** The card this kind would deal, or null when it has nothing to offer. */
	card: T | null;
}

export interface Surprise<T> {
	kind: SurpriseKind;
	card: T;
	/** Where it goes in the hand: from the second to the fifth card. */
	slot: number;
}

/**
 * This hand's surprise, or null. `chance` is the roll's odds (1 deals one for
 * sure). The very first surprise prefers the story, so a newcomer meets the
 * prologue first.
 */
export function pickSurprise<T>(
	candidates: SurpriseCandidate<T>[],
	chance: number,
	random: () => number = Math.random,
	first = false
): Surprise<T> | null {
	const open = candidates.filter((c): c is { kind: SurpriseKind; card: T } => c.card !== null);
	if (!open.length) return null;
	if (random() >= chance) return null;
	const story = first ? open.find((c) => c.kind === 'story') : undefined;
	const pick = story ?? open[Math.min(open.length - 1, Math.floor(random() * open.length))];
	return { kind: pick.kind, card: pick.card, slot: 1 + Math.min(3, Math.floor(random() * 4)) };
}

/** The odds for this deal: sure the first time, higher right after a passed run. */
export function surpriseChance(first: boolean, boosted: boolean): number {
	return first ? 1 : boosted ? SURPRISE_BOOST_CHANCE : SURPRISE_CHANCE;
}

function read(key: string): string | null {
	try {
		return localStorage.getItem(key);
	} catch {
		return null;
	}
}

function write(key: string, value: string | null): void {
	try {
		if (value === null) localStorage.removeItem(key);
		else localStorage.setItem(key, value);
	} catch {
		/* no storage: the deck just rolls at the base odds */
	}
}

/** A run just passed: the next deal rolls at the boosted odds. */
export function markGoodRun(): void {
	write(BOOST_KEY, '1');
}

/**
 * The odds for a deal happening now, spending the boost and the first-time
 * certainty. `dealt` says whether this deal did deal a surprise: the first-
 * time certainty is only spent once one actually turned up.
 */
export function takeSurpriseChance(): { chance: number; first: boolean; done: (dealt: boolean) => void } {
	const first = read(FIRST_KEY) !== '1';
	const boosted = read(BOOST_KEY) === '1';
	return {
		chance: surpriseChance(first, boosted),
		first,
		done: (dealt) => {
			if (boosted) write(BOOST_KEY, null);
			if (dealt) write(FIRST_KEY, '1');
		}
	};
}
