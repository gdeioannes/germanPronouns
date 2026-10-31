import { describe, expect, it } from 'vitest';
import {
	buildPools,
	canFit,
	completeRows,
	regionFromAnchors,
	insertScore,
	mergeWordBank,
	orderByFreshness,
	parseScores,
	parseWordBook,
	recordClean,
	recordMiss,
	weaveLearning,
	sanitizeName,
	scoreRank,
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
	it('long words always lie; only short ones sometimes stand', () => {
		expect(spawnDir(9, 7, () => 0.9)).toBe('h');
		expect(spawnDir(5, 7, () => 0.1)).toBe('h');
		expect(spawnDir(3, 7, () => 0.1)).toBe('v');
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

describe('word variety', () => {
	const w = (de: string) => ({ de, en: de.toLowerCase(), art: null });

	it('deals never-played words first, then the longest-unseen', () => {
		const words = [w('Alt'), w('Neu'), w('Rot'), w('Gut')];
		// Rot was played long ago, Gut just now; Alt and Neu never.
		const out = orderByFreshness(words, ['Rot', 'Gut'], () => 0);
		expect(out.slice(0, 2).map((x) => x.de).sort()).toEqual(['Alt', 'Neu']);
		expect(out.slice(2).map((x) => x.de)).toEqual(['Rot', 'Gut']);
	});

	it('shuffles the fresh words between games', () => {
		const words = [w('Eins'), w('Zwei'), w('Drei')];
		const a = orderByFreshness(words, [], () => 0.1).map((x) => x.de);
		const b = orderByFreshness(words, [], () => 0.9).map((x) => x.de);
		expect(a).not.toEqual(b);
	});
});

describe('the high-score table', () => {
	const score = (pts: number, at = 0, name = 'GDI') => ({ name, pts, level: 'A1.1', at });

	it('ranks a score below earlier equal ones, like the cabinets', () => {
		const list = [score(300, 1), score(200, 2), score(100, 3)];
		expect(scoreRank(list, 250)).toBe(2);
		expect(scoreRank(list, 200)).toBe(3);
		expect(scoreRank([], 10)).toBe(1);
		expect(scoreRank([], 0)).toBeNull();
	});

	it('misses the table when a hundred better scores stand', () => {
		const full = Array.from({ length: 100 }, (_, i) => score(1000 - i, i));
		expect(scoreRank(full, 5)).toBeNull();
		// 950 is already on the table: the newcomer ranks just below it.
		expect(scoreRank(full, 950)).toBe(52);
		expect(scoreRank(full, 950.5)).toBe(51);
		expect(insertScore(full, score(950, 999))).toHaveLength(100);
	});

	it('writes the entry in sorted, and keeps names arcade-shaped', () => {
		const list = insertScore([score(100, 1)], score(300, 2));
		expect(list[0].pts).toBe(300);
		expect(sanitizeName('güni!')).toBe('GÜNI');
		expect(sanitizeName('averylongname')).toBe('AVERY');
		expect(sanitizeName('  ')).toBe('ANON');
	});

	it('survives broken storage', () => {
		expect(parseScores('nonsense{')).toEqual([]);
		expect(parseScores(null)).toEqual([]);
		expect(parseScores(JSON.stringify([score(10, 1), { bad: true }]))).toHaveLength(1);
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

	it('merges every deck of a level and tops up from the word-check bank', () => {
		const deck = (id: string, level: string, cards: unknown[]) =>
			({ id, type: 'vocabulary', title: 't', storageKeyPrefix: id, level, status: 'live', covers: [], cards }) as unknown as Quiz;
		const pools = buildPools([
			deck('a', 'A1.1', [{ de: 'Tür', en: 'door', kind: 'noun', article: 'die', sourceQuizId: 'q' }]),
			deck('b', 'A1.1', [
				{ de: 'Tür', en: 'door again', kind: 'noun', article: 'die', sourceQuizId: 'q' },
				{ de: 'Haus', en: 'house', kind: 'noun', article: 'das', sourceQuizId: 'q' }
			])
		]);
		expect(pools['A1.1'].map((w) => w.de)).toEqual(['Tür', 'Haus']);
		const merged = mergeWordBank(pools, {
			levels: [
				{ level: 'A1.1', words: [['der Topf', 'pot'], ['die Tür', 'door'], ['zu Hause', 'at home']] },
				{ level: 'A1.2', words: [['morgen', 'tomorrow']] }
			]
		});
		expect(merged['A1.1'].map((w) => w.de)).toEqual(['Tür', 'Haus', 'Topf']);
		expect(merged['A1.1'][2].art).toBe('der');
		expect(merged['A1.2'].map((w) => w.de)).toEqual(['morgen']);
	});

	it('refills from the levels below when a bank runs thin', () => {
		const pools = { 'A1.1': [{ de: 'Tür', en: 'door', art: 'die' }] };
		const words = refillWords(pools, 1, new Set());
		expect(words.some((w) => w.de === 'Tür')).toBe(true);
	});

	it('holds back a word whose English is already on the board', () => {
		// lila and violett both read "purple" in the tray: two identical chips
		// would make the right meaning count as wrong.
		const pools = {
			'A1.1': [
				{ de: 'lila', en: 'purple', art: null },
				{ de: 'violett', en: 'Purple', art: null },
				{ de: 'rot', en: 'red', art: null }
			]
		};
		const words = refillWords(pools, 0, new Set(['lila']), new Set(['purple']));
		expect(words.map((w) => w.de)).toEqual(['rot']);
	});
});

describe('the word book', () => {
	const w = (de: string) => ({ de, en: de.toLowerCase(), art: null });

	it('parses only well-formed entries, and survives junk', () => {
		expect(parseWordBook(null)).toEqual({});
		expect(parseWordBook('not json')).toEqual({});
		expect(parseWordBook('[1,2]')).toEqual({});
		expect(parseWordBook('{"Uhr":{"miss":2,"streak":1},"bad":{"miss":"x"}}')).toEqual({
			Uhr: { miss: 2, streak: 1 }
		});
	});

	it('a miss enters the book and resets the streak; clean twice graduates', () => {
		const book = {} as ReturnType<typeof parseWordBook>;
		recordMiss(book, 'Uhr');
		expect(book.Uhr).toEqual({ miss: 1, streak: 0 });
		expect(recordClean(book, 'Uhr')).toBe(false);
		recordMiss(book, 'Uhr');
		expect(book.Uhr).toEqual({ miss: 2, streak: 0 });
		expect(recordClean(book, 'Uhr')).toBe(false);
		expect(recordClean(book, 'Uhr')).toBe(true);
		expect(book.Uhr).toBeUndefined();
		// words never missed are not tracked
		expect(recordClean(book, 'Haus')).toBe(false);
		expect(book.Haus).toBeUndefined();
	});

	it('weaves a learning word into every fourth seat', () => {
		const words = [w('a'), w('b'), w('c'), w('d'), w('e'), w('f'), w('L1'), w('L2')];
		const woven = weaveLearning(words, new Set(['L1', 'L2']));
		expect(woven.map((x) => x.de)).toEqual(['a', 'b', 'c', 'L1', 'd', 'e', 'f', 'L2']);
		// nothing due: untouched
		expect(weaveLearning(words.slice(0, 3), new Set()).map((x) => x.de)).toEqual(['a', 'b', 'c']);
		// only learning words left: they still all come out
		expect(weaveLearning([w('L1'), w('L2')], new Set(['L1', 'L2'])).map((x) => x.de)).toEqual(['L1', 'L2']);
	});
});

describe('the set follows the board: the flood from the anchors', () => {
	it('keeps the chain, drops the drifted, and lets a newcomer join', () => {
		const anchor = block('KALT', 'g', 'h', 9, 0);
		const bridge = block('ROT', 'g', 'h', 8, 0); // on the line
		const newcomer = block('NEU', 'g', 'h', 7, 0); // landed on the bridge later
		const faraway = block('TAG', 'g', 'h', 5, 4); // drifted off
		const other = block('EIS', 'n', 'h', 8, 2); // wrong color, touching
		const now = regionFromAnchors(
			[anchor, bridge, newcomer, faraway, other],
			new Set([anchor.id]),
			'g',
			new Set()
		);
		expect(now).toEqual(new Set([anchor.id, bridge.id, newcomer.id]));
	});

	it('never grows through or into another set\'s blocks', () => {
		const anchor = block('KALT', 'g', 'h', 9, 0);
		const claimed = block('ROT', 'g', 'h', 8, 0); // another set's word
		const beyond = block('NEU', 'g', 'h', 7, 0);
		const now = regionFromAnchors(
			[anchor, claimed, beyond],
			new Set([anchor.id]),
			'g',
			new Set([claimed.id])
		);
		expect(now).toEqual(new Set([anchor.id]));
	});
});
