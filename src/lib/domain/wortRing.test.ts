import { describe, expect, it } from 'vitest';
import {
	ART_DIRS,
	ARTICLES,
	STAR_ANGLE,
	clampCenter,
	meaningAngles,
	pickSeat,
	ringChoices,
	seatAngle
} from './wortRing';
import type { WortBlock } from './wortbloecke';

const blk = (id: number, r: number, c: number, len = 3, dir: 'h' | 'v' = 'h'): WortBlock => ({
	id,
	word: { de: `W${id}`, en: `w${id}`, art: null },
	color: '#000',
	dir,
	r,
	c,
	len
});

describe('wortRing geometry', () => {
	it('seats start straight up and go clockwise', () => {
		expect(seatAngle(0, 4)).toBe(-90);
		expect(seatAngle(1, 4)).toBe(0);
		expect(seatAngle(2, 4)).toBe(90);
	});

	it('picks nothing inside the dead zone', () => {
		expect(pickSeat(5, -5, [-90, 0, 90, 180])).toBeNull();
	});

	it('picks the nearest seat by direction, wrapping round', () => {
		const angles = [-90, 0, 90, 180];
		expect(pickSeat(0, -50, angles)).toBe(0);
		expect(pickSeat(50, 5, angles)).toBe(1);
		expect(pickSeat(-50, -3, angles)).toBe(3);
		expect(pickSeat(-50, 3, angles)).toBe(3);
	});

	it('articles keep fixed, distinct directions: der is up', () => {
		const angles = ARTICLES.map((a) => ART_DIRS[a]);
		expect(ARTICLES[pickSeat(0, -40, angles)!]).toBe('der');
		expect(ARTICLES[pickSeat(40, 25, angles)!]).toBe('das');
		expect(ARTICLES[pickSeat(-40, 25, angles)!]).toBe('die');
	});

	it('with a star, the star sits straight down and no meaning shares its seat', () => {
		const angles = meaningAngles(6, true);
		expect(angles).toHaveLength(6);
		const all = [...angles, STAR_ANGLE];
		expect(all[pickSeat(0, 50, all)!]).toBe(STAR_ANGLE);
		for (const a of angles) expect(Math.abs((((a - STAR_ANGLE) % 360) + 360) % 360)).toBeGreaterThan(40);
	});

	it('without a star, the meanings start at the top', () => {
		expect(meaningAngles(4, false)).toEqual([-90, 0, 90, 180]);
	});

	it('keeps the ring on screen', () => {
		const [x, y] = clampCenter(0, 0, 400, 800, 92);
		expect(x).toBeGreaterThanOrEqual(92);
		expect(y).toBeGreaterThanOrEqual(92);
		const [x2, y2] = clampCenter(400, 800, 400, 800, 92);
		expect(x2).toBeLessThanOrEqual(400 - 92);
		expect(y2).toBeLessThanOrEqual(800 - 92);
	});
});

describe('ringChoices', () => {
	const target = blk(1, 10, 0);
	const near = blk(2, 9, 0);
	const mid = blk(3, 6, 0);
	const far = blk(4, 0, 0);

	it('always holds the target, plus the nearest words up to the size', () => {
		const out = ringChoices(target, [target, far, mid, near], 3, () => 0);
		expect(out).toHaveLength(3);
		expect(out.map((b) => b.id).sort()).toEqual([1, 2, 3]);
	});

	it('is smaller when the board holds fewer words', () => {
		expect(ringChoices(target, [target, near], 6)).toHaveLength(2);
	});

	it('never lists a word twice', () => {
		const out = ringChoices(target, [target, near, mid, far], 8);
		expect(new Set(out.map((b) => b.id)).size).toBe(out.length);
	});
});
