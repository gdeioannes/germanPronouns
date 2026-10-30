// Wortblöcke: a word puzzle in a Tetris well. German words are rigid blocks
// of letter squares in one of four colors (the color means nothing — the
// grammar you have to know); the learner clears a block by pairing it with
// its English in the tray, naming the article for a noun. A row filled in a
// single color turns the whole connected same-color region golden: an
// all-or-nothing run where every word must be matched, and one miss loses
// the lot. Mistakes drop new blocks in; overflow the board and the game is
// over. Points climb the learner from A1.1 towards C2.2 and the "Meister"
// tier of strange and wonderful words, growing the grid on the way.
//
// This module is the pure logic: the grid, gravity, lines, the golden flood,
// spawning and the level ladder. The page (routes/play/wortbloecke) owns the
// DOM, sounds and timers.

import type { Quiz } from '$lib/content/types';

export const WORT_PATH = '/play/wortbloecke';
/** The deck surprise card's quiz id (also the "skipped" key). */
export const WORT_CARD_ID = 'wortbloecke';

/** The four block colors: the brand palette, carrying no grammar. */
export const WORT_PALETTE = ['#1f3a5f', '#c9683b', '#3f5d45', '#a9802a'] as const;

export interface WortWord {
	/** As written, "Tür" — the board shows it in capitals. */
	de: string;
	en: string;
	/** The article for a noun, null for everything else. */
	art: string | null;
}

export interface WortBlock {
	id: number;
	word: WortWord;
	color: string;
	dir: 'h' | 'v';
	r: number;
	c: number;
	len: number;
}

export interface WortGrid {
	cols: number;
	rows: number;
}

// -- scoring and the tool economy ---------------------------------------------

/** Points for a plain match / a noun earned with its article. */
export const MATCH_POINTS = 10;
export const GOLD_POINTS = 30;
/** Each golden word adds this to the run's pot. */
export const POT_PER_WORD = 30;
/** The jackpot: LINE_BONUS × lines², so a double pays four singles. */
export const LINE_BONUS = 50;
/** Tools at the start, and what a jackpot line pays. */
export const START_MOVES = 1;
export const START_ROTATES = 1;
export const LINE_MOVES = 2;
export const LINE_ROTATES = 1;
/** Blocks falling at once from one clear that earn a bonus move. */
export const LANDSLIDE = 3;
/** Seconds within which matches chain into a combo. */
export const COMBO_WINDOW_MS = 4000;

// -- the level ladder -----------------------------------------------------------

export interface WortLevel {
	name: string;
	/** Points where the level begins. */
	at: number;
	cols: number;
	rows: number;
}

/**
 * The climb: every sub-level of the course, then the Meister tier. The grid
 * grows with the learner, both for room and because the words get longer.
 */
export const WORT_LEVELS: WortLevel[] = [
	{ name: 'A1.1', at: 0, cols: 7, rows: 10 },
	{ name: 'A1.2', at: 250, cols: 7, rows: 10 },
	{ name: 'A2.1', at: 550, cols: 7, rows: 11 },
	{ name: 'A2.2', at: 900, cols: 7, rows: 11 },
	{ name: 'B1.1', at: 1300, cols: 8, rows: 11 },
	{ name: 'B1.2', at: 1750, cols: 8, rows: 11 },
	{ name: 'B2.1', at: 2250, cols: 8, rows: 12 },
	{ name: 'B2.2', at: 2800, cols: 8, rows: 12 },
	{ name: 'C1.1', at: 3400, cols: 8, rows: 12 },
	{ name: 'C1.2', at: 4050, cols: 9, rows: 12 },
	{ name: 'C2.1', at: 4750, cols: 9, rows: 12 },
	{ name: 'C2.2', at: 5500, cols: 9, rows: 12 },
	{ name: 'Meister', at: 6300, cols: 9, rows: 12 }
];

export function levelForPoints(pts: number): number {
	let i = 0;
	while (i + 1 < WORT_LEVELS.length && pts >= WORT_LEVELS[i + 1].at) i++;
	return i;
}

/** Past C2.2: real, rare, wonderful German. The one bank not from the course. */
export const MEISTER_POOL: WortWord[] = [
	{ de: 'Fernweh', en: 'ache for far places', art: 'das' },
	{ de: 'Mumpitz', en: 'nonsense', art: 'der' },
	{ de: 'Klimbim', en: 'odds and ends', art: 'der' },
	{ de: 'Zugzwang', en: 'forced move', art: 'der' },
	{ de: 'Firlefanz', en: 'frippery', art: 'der' },
	{ de: 'Kokolores', en: 'hogwash', art: 'der' },
	{ de: 'Tohuwabohu', en: 'utter chaos', art: 'das' },
	{ de: 'Remmidemmi', en: 'racket', art: 'das' },
	{ de: 'Quatsch', en: 'rubbish', art: 'der' },
	{ de: 'Halligalli', en: 'hullabaloo', art: 'das' },
	{ de: 'Larifari', en: 'wishy-washy talk', art: 'das' },
	{ de: 'Zankapfel', en: 'bone of contention', art: 'der' },
	{ de: 'Hickhack', en: 'squabbling', art: 'das' }
];

// -- word pools from the course ---------------------------------------------------

/** The longest word a block can hold (it must stand on the smallest grid). */
export const MAX_WORD_LEN = 10;
const LETTERS_ONLY = /^[A-Za-zÄÖÜäöüß]+$/;
/** Words per sub-level carried to the page: plenty, but a bounded payload. */
const POOL_CAP = 60;

/**
 * One pool per sub-level, drawn from the course's own flashcard decks: single
 * words of 3–10 letters, nouns with their article, each word once. Deck order
 * is teaching order, so the cap keeps the earliest-taught words.
 */
export function buildPools(quizzes: readonly Quiz[]): Record<string, WortWord[]> {
	const pools: Record<string, WortWord[]> = {};
	for (const quiz of quizzes) {
		if (quiz.type !== 'vocabulary' || !quiz.level || pools[quiz.level]) continue;
		const seen = new Set<string>();
		const list: WortWord[] = [];
		for (const card of quiz.cards) {
			const de = card.de.trim();
			if (de.length < 3 || de.length > MAX_WORD_LEN || !LETTERS_ONLY.test(de)) continue;
			const key = de.toLowerCase();
			if (seen.has(key)) continue;
			seen.add(key);
			list.push({ de, en: card.en, art: card.kind === 'noun' ? (card.article ?? null) : null });
			if (list.length === POOL_CAP) break;
		}
		if (list.length) pools[quiz.level] = list;
	}
	return pools;
}

/** The bank for a level index: the matching sub-level pool, or the Meister tier. */
export function poolFor(pools: Record<string, WortWord[]>, levelIdx: number): WortWord[] {
	const level = WORT_LEVELS[levelIdx];
	if (level.name === 'Meister') return MEISTER_POOL;
	return pools[level.name] ?? [];
}

/**
 * The queue for a refill: the level's words not on the board, topped up from
 * the levels below when the bank runs thin, so the well never starves.
 */
export function refillWords(
	pools: Record<string, WortWord[]>,
	levelIdx: number,
	onBoard: ReadonlySet<string>
): WortWord[] {
	const fresh = (list: WortWord[]) => list.filter((w) => !onBoard.has(w.de));
	let out = fresh(poolFor(pools, levelIdx));
	for (let i = levelIdx - 1; i >= 0 && out.length < 4; i--) out = out.concat(fresh(poolFor(pools, i)));
	return out;
}

// -- the grid --------------------------------------------------------------------

export function cellsOf(b: WortBlock, r = b.r, c = b.c): [number, number][] {
	const cells: [number, number][] = [];
	for (let i = 0; i < b.len; i++) cells.push(b.dir === 'h' ? [r, c + i] : [r + i, c]);
	return cells;
}

export function occupiedMap(blocks: readonly WortBlock[], except?: WortBlock): Map<string, WortBlock> {
	const map = new Map<string, WortBlock>();
	for (const b of blocks) {
		if (b === except) continue;
		for (const [r, c] of cellsOf(b)) map.set(`${r},${c}`, b);
	}
	return map;
}

/** How far a block can fall before resting on another block or the floor. */
export function dropDist(b: WortBlock, occ: Map<string, WortBlock>, rows: number): number {
	let dist = rows;
	for (const [r, c] of cellsOf(b)) {
		if (b.dir === 'v' && r !== b.r + b.len - 1) continue;
		let below = r + 1;
		while (below < rows && !occ.has(`${below},${c}`)) below++;
		dist = Math.min(dist, below - r - 1);
	}
	return Math.max(0, dist);
}

const bottomOf = (b: WortBlock) => (b.dir === 'h' ? b.r : b.r + b.len - 1);

/** Gravity: drops every block as far as it goes. Mutates `r`; returns how many fell. */
export function settleBlocks(blocks: WortBlock[], rows: number): number {
	const fallen = new Set<number>();
	let moved = true;
	while (moved) {
		moved = false;
		const order = [...blocks].sort((a, b) => bottomOf(b) - bottomOf(a));
		for (const b of order) {
			const d = dropDist(b, occupiedMap(blocks, b), rows);
			if (d > 0) {
				b.r += d;
				fallen.add(b.id);
				moved = true;
			}
		}
	}
	return fallen.size;
}

/** The rows with a letter in every cell. */
export function completeRows(blocks: readonly WortBlock[], grid: WortGrid): Set<number> {
	const occ = occupiedMap(blocks);
	const rows = new Set<number>();
	for (let r = 0; r < grid.rows; r++) {
		let full = true;
		for (let c = 0; c < grid.cols; c++) {
			if (!occ.has(`${r},${c}`)) {
				full = false;
				break;
			}
		}
		if (full) rows.add(r);
	}
	return rows;
}

/** Every block color present in a row — a line needs exactly one. */
export function rowColors(blocks: readonly WortBlock[], r: number): Set<string> {
	const colors = new Set<string>();
	for (const b of blocks) if (cellsOf(b).some(([rr]) => rr === r)) colors.add(b.color);
	return colors;
}

/** Whether two blocks share an edge anywhere along their letters. */
export function touchingBlocks(a: WortBlock, b: WortBlock): boolean {
	for (const [r1, c1] of cellsOf(a))
		for (const [r2, c2] of cellsOf(b))
			if (Math.abs(r1 - r2) + Math.abs(c1 - c2) === 1) return true;
	return false;
}

/**
 * The golden region: the blocks in the completed rows, grown through every
 * same-color block touching the set (and chains of them). `taken` holds ids
 * already claimed by another set, which are never stolen.
 */
export function goldenRegion(
	blocks: readonly WortBlock[],
	rows: readonly number[],
	color: string,
	taken: ReadonlySet<number>
): WortBlock[] {
	const inRows = new Set(rows);
	const region = blocks.filter(
		(b) => !taken.has(b.id) && cellsOf(b).some(([r]) => inRows.has(r))
	);
	const ids = new Set(region.map((b) => b.id));
	let grew = true;
	while (grew) {
		grew = false;
		for (const b of blocks) {
			if (ids.has(b.id) || taken.has(b.id) || b.color !== color) continue;
			if (region.some((m) => touchingBlocks(b, m))) {
				region.push(b);
				ids.add(b.id);
				grew = true;
			}
		}
	}
	return region;
}

// -- spawning ----------------------------------------------------------------------

/** How a new word falls: standing when it is wider than the board. */
export function spawnDir(len: number, cols: number, random: () => number = Math.random): 'h' | 'v' {
	if (len > cols) return 'v';
	return len <= 4 && random() < 0.35 ? 'v' : 'h';
}

/**
 * Where a new block lands: the column whose landing spot sits highest up
 * (keeping the board flat), or null when the word no longer fits anywhere —
 * which is the game over.
 */
export function pickSpot(
	blocks: readonly WortBlock[],
	len: number,
	dir: 'h' | 'v',
	grid: WortGrid,
	random: () => number = Math.random
): { c: number; r: number } | null {
	const occ = occupiedMap(blocks);
	const probe: WortBlock = {
		id: -1,
		word: { de: '', en: '', art: null },
		color: '',
		dir,
		len,
		r: dir === 'v' ? -len : -1,
		c: 0
	};
	let best: { c: number; landing: number } | null = null;
	const maxC = dir === 'h' ? grid.cols - len : grid.cols - 1;
	for (let c = 0; c <= maxC; c++) {
		probe.c = c;
		const landing = probe.r + dropDist(probe, occ, grid.rows);
		if (landing < 0) continue; // would stick out of the top
		if (!best || landing > best.landing || (landing === best.landing && random() < 0.4))
			best = { c, landing };
	}
	return best ? { c: best.c, r: dir === 'v' ? -len : -1 } : null;
}

/** Whether a word of this length could still land fully on the board. */
export function canFit(blocks: readonly WortBlock[], len: number, grid: WortGrid): boolean {
	for (const dir of len > grid.cols ? (['v'] as const) : (['h', 'v'] as const)) {
		if (dir === 'v' && len > grid.rows) continue;
		if (pickSpot(blocks, len, dir, grid, () => 0)) return true;
	}
	return false;
}

/** The highest occupied row, or `rows` on an empty board — low numbers mean danger. */
export function stackTop(blocks: readonly WortBlock[], rows: number): number {
	let top = rows;
	for (const b of blocks) for (const [r] of cellsOf(b)) top = Math.min(top, r);
	return top;
}
