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
/** Emptying the whole board — the rarest feat — pays this, plus a tool each. */
export const PERFECT_CLEAR_BONUS = 150;
/** Words this long pay a little extra: harder to read, harder to place. */
export const LONG_WORD_LEN = 7;
export const LONG_WORD_BONUS = 10;
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
	{ name: 'A1.1', at: 0, cols: 8, rows: 12 },
	{ name: 'A1.2', at: 250, cols: 8, rows: 12 },
	{ name: 'A2.1', at: 550, cols: 9, rows: 12 },
	{ name: 'A2.2', at: 900, cols: 9, rows: 12 },
	{ name: 'B1.1', at: 1300, cols: 9, rows: 13 },
	{ name: 'B1.2', at: 1750, cols: 9, rows: 13 },
	{ name: 'B2.1', at: 2250, cols: 10, rows: 13 },
	{ name: 'B2.2', at: 2800, cols: 10, rows: 13 },
	{ name: 'C1.1', at: 3400, cols: 10, rows: 14 },
	{ name: 'C1.2', at: 4050, cols: 10, rows: 14 },
	{ name: 'C2.1', at: 4750, cols: 10, rows: 14 },
	{ name: 'C2.2', at: 5500, cols: 10, rows: 14 },
	{ name: 'Meister', at: 6300, cols: 10, rows: 14 }
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
	{ de: 'Quatsch', en: 'rubbish', art: 'der' },
	{ de: 'Larifari', en: 'wishy-washy talk', art: 'das' },
	{ de: 'Zankapfel', en: 'bone of contention', art: 'der' },
	{ de: 'Hickhack', en: 'squabbling', art: 'das' },
	{ de: 'Schmarrn', en: 'twaddle', art: 'der' },
	{ de: 'Klamauk', en: 'slapstick', art: 'der' },
	{ de: 'Radau', en: 'ruckus', art: 'der' }
];

// -- word pools from the course ---------------------------------------------------

/** The longest word a block can hold: it must LIE on the widest grid with a
 *  cell to spare — tall standing pillars wreck the board, so long words
 *  never stand (see spawnDir) and never exceed the biggest width. */
export const MAX_WORD_LEN = 9;
const LETTERS_ONLY = /^[A-Za-zÄÖÜäöüß]+$/;
/** Words per sub-level carried to the page: deck plus word-check bank,
 *  within a bounded payload — variety is the point of a learning game. */
const POOL_CAP = 220;

/**
 * One pool per sub-level, drawn from the course's own flashcard decks: single
 * words of 3–10 letters, nouns with their article, each word once. Deck order
 * is teaching order, so the cap keeps the earliest-taught words.
 */
/** Whether a word belongs on the board, and its tray chip stays chip-sized:
 *  grammar-table meanings like "she / it (die-noun); they" have no place. */
function gameWorthy(de: string, en: string): boolean {
	if (de.length < 3 || de.length > MAX_WORD_LEN || !LETTERS_ONLY.test(de)) return false;
	return en.length <= 18 && !/[/;()]/.test(en);
}

export function buildPools(quizzes: readonly Quiz[]): Record<string, WortWord[]> {
	const pools: Record<string, WortWord[]> = {};
	const seen: Record<string, Set<string>> = {};
	for (const quiz of quizzes) {
		if (quiz.type !== 'vocabulary' || !quiz.level) continue;
		const list = (pools[quiz.level] ??= []);
		const keys = (seen[quiz.level] ??= new Set());
		for (const card of quiz.cards) {
			if (list.length >= POOL_CAP) break;
			const de = card.de.trim();
			if (!gameWorthy(de, card.en)) continue;
			const key = de.toLowerCase();
			if (keys.has(key)) continue;
			keys.add(key);
			list.push({ de, en: card.en, art: card.kind === 'noun' ? (card.article ?? null) : null });
		}
	}
	return pools;
}

/** The word-check bank's shape, as far as this game reads it. */
export interface WortBankSource {
	levels: { level: string; words: [string, string][] }[];
}

/**
 * Tops the pools up from the word check's hand-picked bank: entries come as
 * ["der Topf", "pot"], the article folded into the German. Words the decks
 * already carry are skipped, so each pool only grows.
 */
export function mergeWordBank(
	pools: Record<string, WortWord[]>,
	bank: WortBankSource
): Record<string, WortWord[]> {
	const out: Record<string, WortWord[]> = { ...pools };
	for (const { level, words } of bank.levels) {
		const list = [...(out[level] ?? [])];
		const keys = new Set(list.map((w) => w.de.toLowerCase()));
		for (const [full, en] of words) {
			if (list.length >= POOL_CAP) break;
			const m = /^(der|die|das)\s+(.+)$/.exec(full.trim());
			const de = (m ? m[2] : full).trim();
			const art = m ? m[1] : null;
			if (!gameWorthy(de, en)) continue;
			const key = de.toLowerCase();
			if (keys.has(key)) continue;
			keys.add(key);
			list.push({ de, en, art });
		}
		if (list.length) out[level] = list;
	}
	return out;
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
	onBoard: ReadonlySet<string>,
	onBoardEn: ReadonlySet<string> = new Set()
): WortWord[] {
	// Distinct German words can share one English (lila/violett = "purple"):
	// two identical-looking chips would make the right meaning "wrong", so a
	// word whose English is already on the board waits its turn.
	const fresh = (list: WortWord[]) =>
		list.filter((w) => !onBoard.has(w.de) && !onBoardEn.has(w.en.toLowerCase()));
	let out = fresh(poolFor(pools, levelIdx));
	for (let i = levelIdx - 1; i >= 0 && out.length < 4; i--) out = out.concat(fresh(poolFor(pools, i)));
	return out;
}

// -- the high-score table ---------------------------------------------------------
// An arcade Bestenliste, kept on the device: a hundred places, five-letter
// names. Make the table, write your name — like the cabinets had it.

export interface WortScore {
	/** Up to five characters, written in capitals like an arcade would. */
	name: string;
	pts: number;
	level: string;
	at: number;
}

export const SCORE_CAP = 100;
export const NAME_LEN = 5;
const NAME_CHARS = /[^A-Z0-9ÄÖÜß]/g;

/** An arcade name: capitals, umlauts and digits, five characters at most. */
export function sanitizeName(raw: string): string {
	const name = raw.toUpperCase().replace(NAME_CHARS, '').slice(0, NAME_LEN);
	return name || 'ANON';
}

/** The 1-based place a score would take, or null when it misses the table.
 *  Ties rank below the earlier equal scores, as the cabinets did it. */
export function scoreRank(list: readonly WortScore[], pts: number): number | null {
	if (pts <= 0) return null;
	let rank = 1;
	for (const s of list) if (s.pts >= pts) rank++;
	return rank <= SCORE_CAP ? rank : null;
}

/** The table with the entry written in: sorted, capped at a hundred places. */
export function insertScore(list: readonly WortScore[], entry: WortScore): WortScore[] {
	return [...list, entry]
		.sort((a, b) => b.pts - a.pts || a.at - b.at)
		.slice(0, SCORE_CAP);
}

/** The stored table, oldest meanings dropped; anything unreadable is empty. */
export function parseScores(raw: string | null): WortScore[] {
	try {
		const list = JSON.parse(raw ?? '[]');
		if (!Array.isArray(list)) return [];
		return list
			.filter(
				(s) =>
					s &&
					typeof s.name === 'string' &&
					typeof s.pts === 'number' &&
					typeof s.level === 'string' &&
					typeof s.at === 'number'
			)
			.slice(0, SCORE_CAP);
	} catch {
		return [];
	}
}

/** How many played words the page remembers across games. */
export const SEEN_CAP = 300;

/**
 * The queue order a learning game wants: words never played come first (in
 * random order), then the played ones, the longest-unseen first — so every
 * game teaches something new before it repeats anything.
 * `seen` is oldest-first, newest last.
 */
// -- the learning loop -------------------------------------------------------
// Words the player has missed live in a little book until they are answered
// clean (first try, no hint) twice. The game deals them back deliberately, so
// a miss reliably returns until it sticks — this is a learning app.

export interface WordStats {
	/** How often this word was missed, ever. */
	miss: number;
	/** Clean answers in a row since the last miss. */
	streak: number;
}
export type WordBook = Record<string, WordStats>;

/** Clean answers in a row that graduate a word out of the book. */
export const GRADUATE_STREAK = 2;
/** The book holds this many words at most; the oldest entries make room. */
export const BOOK_CAP = 200;

export function parseWordBook(raw: string | null): WordBook {
	try {
		const parsed = JSON.parse(raw ?? '{}') as unknown;
		if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) return {};
		const book: WordBook = {};
		for (const [de, v] of Object.entries(parsed as Record<string, unknown>)) {
			const s = v as Partial<WordStats> | null;
			if (s && typeof s.miss === 'number' && typeof s.streak === 'number')
				book[de] = { miss: s.miss, streak: s.streak };
		}
		return book;
	} catch {
		return {};
	}
}

/** A miss puts the word in the book (or resets its streak). Mutates. */
export function recordMiss(book: WordBook, de: string): void {
	const prior = book[de];
	// Re-inserting keeps the book in miss order, so the cap drops the oldest.
	delete book[de];
	book[de] = { miss: (prior?.miss ?? 0) + 1, streak: 0 };
	const over = Object.keys(book).length - BOOK_CAP;
	for (const key of Object.keys(book).slice(0, Math.max(0, over))) delete book[key];
}

/** A clean answer (first try, no hint) moves a book word towards graduating.
 *  Returns true the moment it graduates. Words not in the book are no-ops. */
export function recordClean(book: WordBook, de: string): boolean {
	const stats = book[de];
	if (!stats) return false;
	stats.streak += 1;
	if (stats.streak < GRADUATE_STREAK) return false;
	delete book[de];
	return true;
}

/**
 * Deals the book's words back deliberately: every `every`-th queue seat is a
 * learning word (keeping their given order), the rest keep theirs. With
 * nothing in the book the queue is untouched.
 */
export function weaveLearning(
	words: readonly WortWord[],
	learning: ReadonlySet<string>,
	every = 4
): WortWord[] {
	const due = words.filter((w) => learning.has(w.de));
	if (!due.length) return [...words];
	const rest = words.filter((w) => !learning.has(w.de));
	const out: WortWord[] = [];
	let d = 0;
	let r = 0;
	while (d < due.length || r < rest.length) {
		const dueSeat = (out.length + 1) % every === 0;
		if ((dueSeat && d < due.length) || r >= rest.length) out.push(due[d++]);
		else out.push(rest[r++]);
	}
	return out;
}

export function orderByFreshness(
	words: readonly WortWord[],
	seen: readonly string[],
	random: () => number = Math.random
): WortWord[] {
	const recency = new Map<string, number>();
	seen.forEach((de, i) => recency.set(de, i));
	const fresh = words.filter((w) => !recency.has(w.de));
	const played = words.filter((w) => recency.has(w.de));
	for (let i = fresh.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[fresh[i], fresh[j]] = [fresh[j], fresh[i]];
	}
	played.sort((a, b) => recency.get(a.de)! - recency.get(b.de)!);
	return [...fresh, ...played];
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

/**
 * A pending set's TRUE region right now: the flood from its anchors (the
 * blocks that made the completed rows) through every touching same-color
 * block. Membership is dynamic in both directions — a member the board's
 * shuffling cut off drops out, and a same-color block that comes to touch
 * the gold joins it. `taken` holds other sets' blocks, never stolen.
 */
export function regionFromAnchors(
	blocks: readonly WortBlock[],
	anchorIds: ReadonlySet<number>,
	color: string,
	taken: ReadonlySet<number>
): Set<number> {
	const region = blocks.filter((b) => anchorIds.has(b.id) && !taken.has(b.id));
	const reached = new Set(region.map((b) => b.id));
	let grew = true;
	while (grew) {
		grew = false;
		for (const b of blocks) {
			if (reached.has(b.id) || taken.has(b.id) || b.color !== color) continue;
			if (region.some((m) => touchingBlocks(b, m))) {
				region.push(b);
				reached.add(b.id);
				grew = true;
			}
		}
	}
	return reached;
}

// -- spawning ----------------------------------------------------------------------

/** How a new word falls: lying, with only SHORT words sometimes standing.
 *  Tall pillars fragment the floor and invite one-cell bridges, so a long
 *  word never stands — a word too wide for the grid waits for a bigger one. */
export function spawnDir(len: number, cols: number, random: () => number = Math.random): 'h' | 'v' {
	void cols;
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
	let solid: { c: number; landing: number } | null = null;
	const maxC = dir === 'h' ? grid.cols - len : grid.cols - 1;
	for (let c = 0; c <= maxC; c++) {
		probe.c = c;
		const landing = probe.r + dropDist(probe, occ, grid.rows);
		if (landing < 0) continue; // would stick out of the top
		const pick = (prev: { c: number; landing: number } | null) =>
			!prev || landing > prev.landing || (landing === prev.landing && random() < 0.4);
		if (pick(best)) best = { c, landing };
		if (dir === 'h') {
			// How much of the word would rest on something: a word balanced on
			// one cell looks broken, so a majority-supported landing wins.
			let support = 0;
			for (let i = 0; i < len; i++)
				if (landing + 1 >= grid.rows || occ.has(`${landing + 1},${c + i}`)) support++;
			if (support * 2 >= len && pick(solid)) solid = { c, landing };
		}
	}
	const spot = dir === 'h' ? (solid ?? best) : best;
	return spot ? { c: spot.c, r: dir === 'v' ? -len : -1 } : null;
}

/** Whether a word of this length could still land fully on the board —
 *  lying, or standing only when it is short enough to stand (see spawnDir). */
export function canFit(blocks: readonly WortBlock[], len: number, grid: WortGrid): boolean {
	if (len >= grid.cols) return false;
	for (const dir of len <= 4 ? (['h', 'v'] as const) : (['h'] as const)) {
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
