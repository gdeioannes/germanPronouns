// Wortblöcke's marking menu ("ring" controls), modelled on Maya's: press on a
// block, the possible meanings open around the finger; slide toward one and,
// for a noun, der / die / das open right there. Let go to answer: meaning and
// article in one stroke. Tapping works too.
//
// Layout, as Maya does it: eight fixed compass slots, not a circle of centred
// labels. Top and bottom labels are centred; a label on the right STARTS at
// its slot and grows rightwards, one on the left ENDS at its slot and grows
// leftwards; the rows sit a full label height apart. Long and short meanings
// therefore never overlap. The star keeps the bottom slot.
//
// The arrangement for a word is shuffled once (seeded by the block) and stays
// the same while that word is on the board; the articles never move, so "der"
// becomes a flick up from memory. Picking is by DIRECTION from where the finger
// went down, so the ring may sit elsewhere (centred on a narrow phone).

import type { WortBlock, WortMedal } from './wortbloecke';

export type Article = 'der' | 'die' | 'das';
export type Anchor = 'center' | 'start' | 'end';

export interface Slot {
	/** The direction that picks it, in screen degrees (0 = right, -90 = up). */
	angle: number;
	/** Where the label sits, from the ring's centre (px). */
	dx: number;
	dy: number;
	/** Which edge of the label sits on the point. */
	anchor: Anchor;
}

export type SlotKey = 'N' | 'NE' | 'E' | 'SE' | 'S' | 'SW' | 'W' | 'NW';

/** The eight slots. Rows at -100 / -62 / 0 / 62 / 100: a label is ~36 px high. */
export const SLOTS: Record<SlotKey, Slot> = {
	N: { angle: -90, dx: 0, dy: -100, anchor: 'center' },
	NE: { angle: -45, dx: 34, dy: -62, anchor: 'start' },
	E: { angle: 0, dx: 46, dy: 0, anchor: 'start' },
	SE: { angle: 45, dx: 34, dy: 62, anchor: 'start' },
	S: { angle: 90, dx: 0, dy: 100, anchor: 'center' },
	SW: { angle: 135, dx: -34, dy: 62, anchor: 'end' },
	W: { angle: 180, dx: -46, dy: 0, anchor: 'end' },
	NW: { angle: -135, dx: -34, dy: -62, anchor: 'end' }
};

/** The hint star's slot: straight down, so "I don't know" is a flick down. */
export const STAR_SLOT: SlotKey = 'S';

/** The order meanings fill the slots in: spread round the dial first. */
const FILL: SlotKey[] = ['N', 'SE', 'NW', 'NE', 'SW', 'E', 'W'];

/** How many meanings a press offers (the star's slot is never one of them). */
export const RING_SIZE: Record<WortMedal, number> = { bronze: 5, silver: 7, gold: 7 };

/** The slots for `n` meanings, in seat order. */
export function meaningSlots(n: number): SlotKey[] {
	return FILL.slice(0, Math.max(0, Math.min(n, FILL.length)));
}

/** The article seats: der up, das lower right, die lower left — fixed. */
export const ART_SLOTS: Record<Article, Slot> = {
	der: { angle: -90, dx: 0, dy: -62, anchor: 'center' },
	das: { angle: 30, dx: 30, dy: 44, anchor: 'start' },
	die: { angle: 150, dx: -30, dy: 44, anchor: 'end' }
};
export const ARTICLES = Object.keys(ART_SLOTS) as Article[];

/** The dead zone round the press point, where nothing is picked (px). */
export const DEAD_R = 22;
/** Sliding this far toward a meaning commits it: the stroke flows on. */
export const COMMIT_R = 66;

/** The seat a pointer offset points at (nearest angle), or null inside the dead zone. */
export function pickSeat(dx: number, dy: number, angles: readonly number[], dead = DEAD_R): number | null {
	if (!angles.length || Math.hypot(dx, dy) < dead) return null;
	const a = (Math.atan2(dy, dx) * 180) / Math.PI;
	let best = 0;
	let bestD = Infinity;
	angles.forEach((t, i) => {
		const d = Math.abs(((((a - t) % 360) + 540) % 360) - 180);
		if (d < bestD) {
			bestD = d;
			best = i;
		}
	});
	return best;
}

/** A small seeded random (mulberry32): the same block shuffles the same way. */
export function seededRandom(seed: number): () => number {
	let t = seed >>> 0;
	return () => {
		t = (t + 0x6d2b79f5) >>> 0;
		let r = Math.imul(t ^ (t >>> 15), 1 | t);
		r = (r + Math.imul(r ^ (r >>> 7), 61 | r)) ^ r;
		return ((r ^ (r >>> 14)) >>> 0) / 4294967296;
	};
}

const centerOf = (b: WortBlock): [number, number] =>
	b.dir === 'h' ? [b.r + 0.5, b.c + b.len / 2] : [b.r + b.len / 2, b.c + 0.5];

/**
 * The meanings for `target`: its own, plus the words lying nearest to it on
 * the board (the ones the eye would confuse), `size` at most, in random seats.
 */
export function ringChoices<B extends WortBlock>(
	target: B,
	others: readonly B[],
	size: number,
	random: () => number = Math.random
): B[] {
	const [tr, tc] = centerOf(target);
	const near = others
		.filter((b) => b.id !== target.id)
		.map((b) => {
			const [r, c] = centerOf(b);
			return { b, d: Math.hypot(r - tr, c - tc) };
		})
		.sort((x, y) => x.d - y.d || x.b.id - y.b.id)
		.slice(0, Math.max(0, size - 1))
		.map((x) => x.b);
	const out = [target, ...near];
	for (let i = out.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}

/**
 * Where the ring's centre may sit: close to the press, but with room for the
 * labels on every side — on a screen too narrow for that, the middle.
 */
export function placeCenter(x: number, y: number, w: number, h: number, padX = 190, padY = 130): [number, number] {
	const cx = w < padX * 2 ? w / 2 : Math.min(Math.max(x, padX), w - padX);
	const cy = h < padY * 2 ? h / 2 : Math.min(Math.max(y, padY), h - padY);
	return [cx, cy];
}
