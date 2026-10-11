// "Last U-Bahn home": a station announcement names the platform (Gleis), the
// learner runs to it. The options pair the answer with the numbers it is
// easiest to mishear (zwei/drei, sechs/sieben, vier/fünf), and one round
// mentions a second number (zwei Minuten) to listen past.

import type { CallLine } from './callTask';

export interface UbahnRound {
	/** The platform, as a digit string. */
	answer: string;
	/** The platform signs on screen, in display order. */
	options: string[];
	clip: CallLine;
}

export type AnnouncementKind = 'plain' | 'change' | 'last';

/** One recorded announcement for one platform. */
export interface UbahnAnnouncement {
	platform: string;
	kind: AnnouncementKind;
	clip: CallLine;
}

export interface UbahnTaskContent {
	id: string;
	title: string;
	intro: string;
	/** Every platform 1–10 in every kind; a game draws its rounds from these. */
	announcements: UbahnAnnouncement[];
	/** Jokes for the wrong platform. */
	wrong: string[];
	ending: CallLine;
}

/** The night's shape: a platform, a change, another, a change, the last call. */
export const UBAHN_KINDS: AnnouncementKind[] = ['plain', 'change', 'plain', 'change', 'last'];

/** The numbers easiest to mishear for each other; the other two signs come from here. */
const SOUND_ALIKES: Record<string, string[]> = {
	'1': ['9', '2'],
	'2': ['3', '1'],
	'3': ['2', '4'],
	'4': ['5', '3'],
	'5': ['4', '6'],
	'6': ['7', '5'],
	'7': ['6', '8'],
	'8': ['9', '7'],
	'9': ['1', '8'],
	'10': ['9', '6']
};

function shuffled<T>(items: readonly T[], random: () => number): T[] {
	const out = [...items];
	for (let i = out.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}

/** The three signs for a platform: the answer and its two sound-alikes, numerically ordered. */
export function signsFor(answer: string): string[] {
	const others = SOUND_ALIKES[answer] ?? ['1', '2'];
	return [answer, ...others].sort((a, b) => Number(a) - Number(b));
}

/**
 * Tonight's trains: one announcement per kind in UBAHN_KINDS, each on a
 * different platform, drawn afresh every play.
 */
export function planUbahnRounds(content: UbahnTaskContent, random: () => number = Math.random): UbahnRound[] {
	const platforms = shuffled([...new Set(content.announcements.map((a) => a.platform))], random);
	const rounds: UbahnRound[] = [];
	for (const kind of UBAHN_KINDS) {
		const platform = platforms.find((p) => content.announcements.some((a) => a.platform === p && a.kind === kind));
		if (!platform) continue;
		platforms.splice(platforms.indexOf(platform), 1);
		const clip = content.announcements.find((a) => a.platform === platform && a.kind === kind)!.clip;
		rounds.push({ answer: platform, options: signsFor(platform), clip });
	}
	return rounds;
}
