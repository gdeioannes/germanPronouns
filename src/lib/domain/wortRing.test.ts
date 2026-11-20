import { describe, expect, it } from 'vitest';
import {
	ARTICLES,
	ART_SLOTS,
	RING_SIZE,
	SLOTS,
	STAR_SLOT,
	meaningSlots,
	pickSeat,
	placeCenter,
	ringChoices,
	seededRandom,
	type Slot
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

/** A label's box for a slot, at a given width (36 px high). */
function box(s: Slot, w: number) {
	const left = s.anchor === 'center' ? s.dx - w / 2 : s.anchor === 'start' ? s.dx : s.dx - w;
	return { left, right: left + w, top: s.dy - 18, bottom: s.dy + 18 };
}
const overlap = (a: ReturnType<typeof box>, b: ReturnType<typeof box>) =>
	a.left < b.right && b.left < a.right && a.top < b.bottom && b.top < a.bottom;

describe('wortRing layout', () => {
	it('never overlaps, even with every label at the longest width', () => {
		const keys = [...meaningSlots(7), STAR_SLOT];
		for (const w of [40, 90, 150]) {
			for (let i = 0; i < keys.length; i++)
				for (let j = i + 1; j < keys.length; j++)
					expect(overlap(box(SLOTS[keys[i]], w), box(SLOTS[keys[j]], w)), `${keys[i]}/${keys[j]} at ${w}px`).toBe(false);
		}
	});

	it('the article seats do not overlap either', () => {
		const boxes = ARTICLES.map((a) => box(ART_SLOTS[a], 70));
		for (let i = 0; i < boxes.length; i++)
			for (let j = i + 1; j < boxes.length; j++) expect(overlap(boxes[i], boxes[j])).toBe(false);
	});

	it('the star keeps the bottom slot and meanings never take it', () => {
		expect(SLOTS[STAR_SLOT].angle).toBe(90);
		expect(meaningSlots(7)).not.toContain(STAR_SLOT);
	});

	it('offers at most the slots there are', () => {
		expect(meaningSlots(RING_SIZE.bronze)).toHaveLength(5);
		expect(meaningSlots(99)).toHaveLength(7);
	});

	it('right-side labels grow right, left-side labels grow left', () => {
		for (const s of Object.values(SLOTS)) {
			if (s.dx > 0) expect(s.anchor).toBe('start');
			if (s.dx < 0) expect(s.anchor).toBe('end');
		}
	});
});

describe('wortRing picking', () => {
	it('picks nothing inside the dead zone', () => {
		expect(pickSeat(5, -5, [-90, 0, 90, 180])).toBeNull();
	});

	it('picks the nearest direction, wrapping round', () => {
		const angles = [-90, 0, 90, 180];
		expect(pickSeat(0, -50, angles)).toBe(0);
		expect(pickSeat(50, 5, angles)).toBe(1);
		expect(pickSeat(-50, -3, angles)).toBe(3);
	});

	it('articles keep fixed directions: der is up', () => {
		const angles = ARTICLES.map((a) => ART_SLOTS[a].angle);
		expect(ARTICLES[pickSeat(0, -40, angles)!]).toBe('der');
		expect(ARTICLES[pickSeat(40, 25, angles)!]).toBe('das');
		expect(ARTICLES[pickSeat(-40, 25, angles)!]).toBe('die');
	});

	it('centres the ring on a screen too narrow for its labels', () => {
		expect(placeCenter(20, 400, 360, 800)[0]).toBe(180);
		const [x, y] = placeCenter(20, 10, 1200, 800);
		expect(x).toBeGreaterThanOrEqual(190);
		expect(y).toBeGreaterThanOrEqual(130);
	});
});

describe('ringChoices', () => {
	const target = blk(1, 10, 0);
	const near = blk(2, 9, 0);
	const mid = blk(3, 6, 0);
	const far = blk(4, 0, 0);

	it('always holds the target, plus the nearest words up to the size', () => {
		const out = ringChoices(target, [target, far, mid, near], 3, () => 0);
		expect(out.map((b) => b.id).sort()).toEqual([1, 2, 3]);
	});

	it('is smaller when the board holds fewer words', () => {
		expect(ringChoices(target, [target, near], 6)).toHaveLength(2);
	});

	it('the same block gets the same arrangement every press', () => {
		const a = ringChoices(target, [target, near, mid, far], 4, seededRandom(1)).map((b) => b.id);
		const b = ringChoices(target, [target, near, mid, far], 4, seededRandom(1)).map((b) => b.id);
		expect(a).toEqual(b);
	});
});
