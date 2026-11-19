// Wortblöcke's marking menu ("ring" controls), modelled on Maya's: press on a
// block, the possible meanings open in a ring around the finger; slide to one
// and, for a noun, a second ring of der / die / das opens right there. Let go
// to answer: meaning and article in one stroke. Tapping works too.
//
// The meanings move every time (a fixed spot would teach the position, not the
// word); the articles never move, so "der" becomes a flick up from memory.
// This module is the pure geometry and the choice of meanings.

import type { WortBlock, WortMedal } from './wortbloecke';

export type Article = 'der' | 'die' | 'das';

/** Fixed article directions, in screen degrees (0 = right, -90 = up). */
export const ART_DIRS: Record<Article, number> = { der: -90, das: 30, die: 150 };
export const ARTICLES = Object.keys(ART_DIRS) as Article[];

/** How many meanings the ring offers: bronze is kinder. */
export const RING_SIZE: Record<WortMedal, number> = { bronze: 6, silver: 8, gold: 8 };

/** Radii in px: the meaning ring, the article ring, and the dead zone in the
 *  middle where nothing is picked. */
export const RING_R = 92;
export const ART_R = 64;
export const DEAD_R = 22;

/** The angle of seat `i` of `n`, starting straight up, clockwise. */
export const seatAngle = (i: number, n: number): number => -90 + (360 / n) * i;

/** The hint star's seat: always straight down, so "I don't know" is a flick down. */
export const STAR_ANGLE = 90;

/**
 * The meaning seats' angles. Without a star they share the whole circle from
 * the top; with one, the star takes the bottom seat and the meanings the rest,
 * all evenly spaced.
 */
export function meaningAngles(n: number, star: boolean): number[] {
	if (!star) return Array.from({ length: n }, (_, i) => seatAngle(i, n));
	const step = 360 / (n + 1);
	return Array.from({ length: n }, (_, i) => STAR_ANGLE + step * (i + 1));
}

export function polar(cx: number, cy: number, deg: number, r: number): [number, number] {
	const a = (deg * Math.PI) / 180;
	return [cx + Math.cos(a) * r, cy + Math.sin(a) * r];
}

/** The seat a pointer offset points at (nearest angle), or null inside the dead zone. */
export function pickSeat(dx: number, dy: number, angles: readonly number[], dead = DEAD_R): number | null {
	if (!angles.length || Math.hypot(dx, dy) < dead) return null;
	const a = (Math.atan2(dy, dx) * 180) / Math.PI;
	let best = 0;
	let bestD = Infinity;
	angles.forEach((t, i) => {
		const d = Math.abs((((a - t) % 360) + 540) % 360 - 180);
		if (d < bestD) {
			bestD = d;
			best = i;
		}
	});
	return best;
}

const centerOf = (b: WortBlock): [number, number] =>
	b.dir === 'h' ? [b.r + 0.5, b.c + b.len / 2] : [b.r + b.len / 2, b.c + 0.5];

/**
 * The ring's meanings for `target`: its own, plus the words lying nearest to it
 * on the board (the ones the eye would confuse), `size` at most, in random seats.
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
		.sort((x, y) => x.d - y.d)
		.slice(0, Math.max(0, size - 1))
		.map((x) => x.b);
	const out = [target, ...near];
	for (let i = out.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}

/** Keeps a ring of radius `r` (plus label room) inside the viewport. */
export function clampCenter(
	x: number,
	y: number,
	w: number,
	h: number,
	r = RING_R,
	padX = 56,
	padY = 26
): [number, number] {
	const cx = Math.min(Math.max(x, r + padX), Math.max(r + padX, w - r - padX));
	const cy = Math.min(Math.max(y, r + padY), Math.max(r + padY, h - r - padY));
	return [cx, cy];
}
