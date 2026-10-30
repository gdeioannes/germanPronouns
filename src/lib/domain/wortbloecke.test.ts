import { describe, expect, it } from 'vitest';
import {
	buildPools,
	canFit,
	completeRows,
	dropDist,
	goldenRegion,
	levelForPoints,
	occupiedMap,
	pickSpot,
	refillWords,
	rowColors,
	settleBlocks,
	spawnDir,
	stackTop,
	touchingBlocks,
	MAX_WORD_LEN,
	MEISTER_POOL,
	WORT_LEVELS,
	type WortBlock
} from './wortbloecke';
import type { Quiz } from '$lib/content/types';

let nextId = 1;
const block = (
	de: string,
	color: string,
	dir: 'h' | 'v',
	r: number,
	c: number
): WortBlock => ({
	id: nextId++,
	word: { de, en: de.toLowerCase(), art: null },
	color,
	dir,
	len: de.length,
	r,
	c
});

const GRID = { cols: 7, rows: 10 };

describe('gravity', () => {
	it('drops a floating block onto the floor', () => {
		const b = block('HAUS', 'navy', 'h', 2, 0);
		const fell = settleBlocks([b], GRID.rows);
		expect(fell).toBe(1);
		expect(b.r).toBe(GRID.rows - 1);
	});

	it('rests a block on the one below and cascades after a clear', () => {
		const floor = block('KALT', 'navy', 'h', GRID.rows - 1, 0);
		const above = block('ROT', 'green', 'h', 0, 0);
		const blocks = [floor, above];
		settleBlocks(blocks, GRID.rows);
		expect(above.r).toBe(GRID.rows - 2);
		// the floor word clears: the one above falls to the floor
		settleBlocks([above], GRID.rows);
		expect(above.r).toBe(GRID.rows - 1);
	});

	it('supports a vertical block by its bottom cell only', () => {
		const post = block('TAG', 'navy', 'v', 0, 3);
		expect(dropDist(post, occupiedMap([]), GRID.rows)).toBe(GRID.rows - post.len);
		settleBlocks([post], GRID.rows);
		expect(post.r).toBe(GRID.rows - post.len);
	});
});

describe('lines and the golden region', () => {
	it('sees a full row and its colours', () => {
		const a = block('KALT', 'g', 'h', 9, 0);
		const b = block('TAG', 'g', 'h', 9, 4);
		expect([...completeRows([a, b], GRID)]).toEqual([9]);
		expect(rowColors([a, b], 9)).toEqual(new Set(['g']));
		const mixed = block('TAG', 'n', 'h', 9, 4);
		expect(rowColors([a, mixed], 9).size).toBe(2);
	});

	it('floods the connected same-colour region, leaving other colours out', () => {
		const lineA = block('KALT', 'g', 'h', 9, 0);
		const lineB = block('TAG', 'g', 'h', 9, 4);
		const touchGreen = block('ROT', 'g', 'h', 8, 0); // on top of KALT
		const chained = block('NEU', 'g', 'h', 7, 0); // on top of ROT
		const navy = block('HAUS', 'n', 'h', 8, 3); // touching, wrong colour
		const region = goldenRegion([lineA, lineB, touchGreen, chained, navy], [9], 'g', new Set());
		expect(region.map((b) => b.word.de).sort()).toEqual(['KALT', 'NEU', 'ROT', 'TAG']);
	});

	it('never steals a block from another set', () => {
		const lineA = block('KALT', 'g', 'h', 9, 0);
		const other = block('ROT', 'g', 'h', 8, 0);
		const region = goldenRegion([lineA, other], [9], 'g', new Set([other.id]));
		expect(region.map((b) => b.word.de)).toEqual(['KALT']);
	});

	it('knows when blocks touch', () => {
		expect(touchingBlocks(block('AB', 'g', 'h', 9, 0), block('CD', 'g', 'h', 8, 1))).toBe(true);
		expect(touchingBlocks(block('AB', 'g', 'h', 9, 0), block('CD', 'g', 'h', 7, 0))).toBe(false);
	});
});

describe('spawning and the end', () => {
	it('stands words wider than the board', () => {
		expect(spawnDir(9, 7, () => 0.9)).toBe('v');
		expect(spawnDir(5, 7, () => 0.9)).toBe('h');
	});

	it('lands on the flattest column, and reports game over when nothing fits', () => {
		const spot = pickSpot([], 4, 'h', GRID, () => 0);
		expect(spot).not.toBeNull();
		// a board stacked to the brim in every column
		const wall: WortBlock[] = [];
		for (let c = 0; c < GRID.cols; c++) wall.push(block('ABCDEFGHIJ', 'n', 'v', 0, c));
		expect(pickSpot(wall, 4, 'h', GRID)).toBeNull();
		expect(canFit(wall, 3, GRID)).toBe(false);
		expect(stackTop(wall, GRID.rows)).toBe(0);
	});
});

describe('the ladder and the pools', () => {
	it('climbs levels on points and grows the grid', () => {
		expect(WORT_LEVELS[levelForPoints(0)].name).toBe('A1.1');
		expect(WORT_LEVELS[levelForPoints(260)].name).toBe('A1.2');
		expect(WORT_LEVELS[levelForPoints(99999)].name).toBe('Meister');
		const first = WORT_LEVELS[0];
		const last = WORT_LEVELS[WORT_LEVELS.length - 1];
		expect(last.cols).toBeGreaterThan(first.cols);
		expect(last.rows).toBeGreaterThan(first.rows);
	});

	it('keeps the Meister words block-sized', () => {
		for (const w of MEISTER_POOL) expect(w.de.length).toBeLessThanOrEqual(MAX_WORD_LEN);
	});

	it('builds pools from vocabulary decks: single clean words, nouns with articles', () => {
		const quiz = {
			id: 'v1',
			type: 'vocabulary',
			title: 't',
			storageKeyPrefix: 'v1',
			level: 'A1.1',
			status: 'live',
			covers: [],
			cards: [
				{ de: 'Tür', en: 'door', kind: 'noun', article: 'die', sourceQuizId: 'q' },
				{ de: 'zu Hause', en: 'at home', kind: 'word', sourceQuizId: 'q' },
				{ de: 'gut', en: 'good', kind: 'word', sourceQuizId: 'q' },
				{ de: 'gut', en: 'well', kind: 'word', sourceQuizId: 'q' },
				{ de: 'Unverständlichkeit', en: 'too long', kind: 'noun', article: 'die', sourceQuizId: 'q' }
			]
		} as unknown as Quiz;
		const pools = buildPools([quiz]);
		expect(pools['A1.1'].map((w) => w.de)).toEqual(['Tür', 'gut']);
		expect(pools['A1.1'][0].art).toBe('die');
		expect(pools['A1.1'][1].art).toBeNull();
		for (const w of pools['A1.1']) expect(w.de.length).toBeLessThanOrEqual(MAX_WORD_LEN);
	});

	it('refills from the levels below when a bank runs thin', () => {
		const pools = { 'A1.1': [{ de: 'Tür', en: 'door', art: 'die' }] };
		const words = refillWords(pools, 1, new Set());
		expect(words.some((w) => w.de === 'Tür')).toBe(true);
	});
});
