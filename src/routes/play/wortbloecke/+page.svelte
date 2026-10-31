<script lang="ts">
	// Wortblöcke: the word puzzle in a Tetris well (rules in domain/wortbloecke).
	// Pair German blocks with their English chips, name the article for nouns,
	// fill a one-color row to gild its connected region, then clear the whole
	// golden set in a row for the jackpot. Mistakes drop new blocks; overflow
	// ends the game. Points climb the learner A1.1 → C2.2 → Meister, growing
	// the grid on the way. Nothing here is marked or counted as an exercise.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { onMount } from 'svelte';
	import { announce } from '$lib/a11y.svelte';
	import { celebrate, effectsCalm } from '$lib/motion/fx.svelte';
	import { playSound } from '$lib/services/sounds';
	import { tts } from '$lib/services/speech';
	import { track } from '$lib/services/analytics';
	import { fetchWorldScores, submitWorldScore, worldBoardAvailable } from '$lib/services/wortScores';
	import { breadcrumbLd } from '$lib/seo';
	import {
		canFit,
		cellsOf,
		completeRows,
		connectedToAnchors,
		goldenRegion,
		insertScore,
		levelForPoints,
		orderByFreshness,
		parseScores,
		pickSpot,
		refillWords,
		rowColors,
		sanitizeName,
		scoreRank,
		settleBlocks,
		spawnDir,
		stackTop,
		NAME_LEN,
		SCORE_CAP,
		SEEN_CAP,
		COMBO_WINDOW_MS,
		GOLD_POINTS,
		LANDSLIDE,
		LINE_BONUS,
		LINE_MOVES,
		LINE_ROTATES,
		LONG_WORD_BONUS,
		LONG_WORD_LEN,
		MATCH_POINTS,
		PERFECT_CLEAR_BONUS,
		POT_PER_WORD,
		START_MOVES,
		START_ROTATES,
		WORT_LEVELS,
		WORT_PALETTE,
		type WortBlock,
		type WortScore,
		type WortWord
	} from '$lib/domain/wortbloecke';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const DECK = $derived(`/course/${data.courseId}`);
	const LOCALE = 'de-DE';
	const BEST_KEY = 'wortbloecke_best';
	const SCORES_KEY = 'wortbloecke_scores';
	const NAME_KEY = 'wortbloecke_name';
	const SEEN_KEY = 'wortbloecke_seen';

	/** Words already played, oldest first — this is a learning app, so new
	 *  words come before any repeat, across games too. */
	let seen: string[] = [];

	function markSeen(de: string) {
		seen = [...seen.filter((x) => x !== de), de].slice(-SEEN_CAP);
		try {
			localStorage.setItem(SEEN_KEY, JSON.stringify(seen));
		} catch {
			/* no storage: variety holds within this session */
		}
	}

	// -- the board model ---------------------------------------------------------
	/** A block plus its screen states; $state makes mutations repaint. */
	interface Block extends WortBlock {
		gilded: boolean;
		done: boolean;
		runset: boolean;
		clearing: boolean;
		fizzle: boolean;
		featured: boolean;
		/** The article was missed or revealed: the block wears it, silver only. */
		learned: boolean;
		/** A hint star revealed this word's meaning. */
		hinted: boolean;
	}
	interface GoldenSet {
		color: string;
		ids: Set<number>;
		des: Set<string>;
		doneIds: Set<number>;
		/** The blocks that stood IN the completed row(s): the line itself.
		 *  Members the board's shuffling cuts off from these drop out again. */
		anchorIds: Set<number>;
		active: boolean;
		pot: number;
		lines: number;
	}

	let phase = $state<'intro' | 'play' | 'over'>('intro');
	let blocks = $state<Block[]>([]);
	let pts = $state(0);
	let best = $state(0);
	let combo = $state(1);
	let lastMatch = 0;
	let movUses = $state(START_MOVES);
	let rotUses = $state(START_ROTATES);
	/** The star is armed: the next block tapped is revealed, not matched. */
	let hintMode = $state(false);
	/** The hint star turns up IN the tray like a word — one at a time. */
	const STAR = '__star__';
	const STAR_CHANCE = 0.08;
	let golds = 0;
	let levelIdx = $state(0);
	const grid = $derived({ cols: WORT_LEVELS[levelIdx].cols, rows: WORT_LEVELS[levelIdx].rows });
	let nextId = 1;
	/** True while the opening hand is dealt, so lines don't fire per spawn. */
	let dealing = false;
	/** This game's story, for the game-over card. */
	let wordsDone = $state(0);
	let linesWon = $state(0);

	// Golden sets live outside $state (Sets are not proxied); every visible
	// consequence is written onto the reactive blocks and the banner string.
	let challenges: GoldenSet[] = [];
	let activeCh = $state.raw<GoldenSet | null>(null);
	/** Reactive mirror of "a run is underway", for the board's focus dim. */
	let runOn = $state(false);
	let fullRows = new Set<number>();
	const setOf = (b: Block) => challenges.find((ch) => ch.ids.has(b.id)) ?? null;
	const doneOf = (b: Block) => challenges.find((ch) => ch.doneIds.has(b.id)) ?? null;

	let queue: { word: WortWord; color: string }[] = [];
	let preview = $state<{ de: string; color: string }[]>([]);
	let goldBar = $state<string | null>(null);
	/** The lesson line: after any miss, the right article + translation sits
	 *  readable under the board for a moment — this is a learning app. */
	let lesson = $state<string | null>(null);
	let lessonTimer: ReturnType<typeof setTimeout> | undefined;
	function teach(w: WortWord) {
		lesson = `${w.art ? `${w.art} ${w.de}` : w.de} = ${w.en}`;
		clearTimeout(lessonTimer);
		lessonTimer = setTimeout(() => (lesson = null), 4500);
	}
	let danger = $state(false);
	let lineFx = $state<{ id: number; r: number; mixed: boolean }[]>([]);
	let floats = $state<{ id: number; x: number; y: number; text: string; cls: string }[]>([]);

	let selected = $state<string | null>(null);
	let grabbedId = $state<number | null>(null);
	const grabbed = $derived(blocks.find((b) => b.id === grabbedId) ?? null);
	const clamp = (v: number, lo: number, hi: number) => Math.max(lo, Math.min(hi, v));
	/** The grabbed block's handles, fused to the word itself: an arrow cap on
	 *  each end in a darker shade of its own color, the rotate as a tab on its
	 *  top edge (under its bottom edge when the word touches the ceiling).
	 *  At a wall a cap slides inward over the end letter rather than clipping. */
	const ctl = $derived.by(() => {
		const b = grabbed;
		if (!b || setOf(b as Block) || doneOf(b as Block)) return null;
		// A handle only exists when its move is actually possible right now.
		const canLeft = movUses > 0 && fits(b as Block, { dir: b.dir, r: b.r, c: b.c - 1 });
		const canRight = movUses > 0 && fits(b as Block, { dir: b.dir, r: b.r, c: b.c + 1 });
		const canRot = rotUses > 0 && b.len > 1 && rotateCandidate(b as Block) !== null;
		if (!canLeft && !canRight && !canRot) return null;
		const w = grid.cols * cs;
		const h = grid.rows * cs;
		const capW = Math.max(22, Math.round(cs * 0.72));
		const capH = cs;
		const rotW = Math.max(28, Math.round(cs * 0.95));
		const rotH = Math.max(20, Math.round(cs * 0.55));
		// Arrows ride the block's own row: the middle letter for a standing word.
		const rowY = b.dir === 'h' ? b.r * cs : (b.r + Math.floor(b.len / 2)) * cs;
		const cy = clamp(rowY, 0, h - capH);
		const leftEdge = b.c * cs;
		const rightEdge = (b.dir === 'h' ? b.c + b.len : b.c + 1) * cs;
		// A cap sits just outside its end; with no room there it snaps flush
		// ONTO the end letter, grid-aligned, never to a halfway overlap.
		const leftX = leftEdge - capW >= -EXT ? leftEdge - capW : leftEdge;
		const rightX = rightEdge <= w - capW + EXT ? rightEdge : rightEdge - capW;
		const centerX = (b.dir === 'h' ? b.c * cs + (b.len * cs) / 2 : b.c * cs + cs / 2) - rotW / 2;
		const above = b.r * cs - rotH + 1;
		const under = above < -EXT;
		const rotY = under ? (b.dir === 'h' ? (b.r + 1) * cs : (b.r + b.len) * cs) - 1 : above;
		return {
			color: b.color,
			capW,
			capH,
			rotW,
			rotH,
			under,
			canLeft,
			canRight,
			canRot,
			left: { x: leftX, y: cy },
			right: { x: rightX, y: cy },
			rot: { x: clamp(centerX, -EXT, w - rotW + EXT), y: clamp(rotY, -EXT, h - rotH + EXT) }
		};
	});
	let pending = $state<Block | null>(null);
	let pendingRun = $state<GoldenSet | null>(null);
	/** The open question is a free look (direct tap on a badge), not a wager. */
	let pendingFree = $state(false);
	/** English chips in the tray, in their own stable shuffled order. */
	let chips = $state<string[]>([]);
	let sayOn = $state(true);

	// -- the arcade Bestenliste ---------------------------------------------------
	let scores = $state<WortScore[]>([]);
	/** The place this game earned, or null; set at game over. */
	let overRank = $state<number | null>(null);
	let nameDraft = $state('');
	let entered = $state(false);
	let enteredAt = $state(0);
	let showBoard = $state(false);
	/** The world board: fetched on first open, refreshed after a new entry. */
	let boardTab = $state<'local' | 'world'>('local');
	let world = $state<WortScore[]>([]);
	let worldState = $state<'idle' | 'loading' | 'error' | 'ready'>('idle');

	function openBoard() {
		showBoard = true;
		if (worldBoardAvailable() && worldState === 'idle') void loadWorld();
	}

	async function loadWorld() {
		worldState = 'loading';
		const list = await fetchWorldScores();
		if (list) {
			world = list;
			worldState = 'ready';
		} else {
			worldState = 'error';
		}
	}

	function saveScores() {
		try {
			localStorage.setItem(SCORES_KEY, JSON.stringify(scores));
			localStorage.setItem(NAME_KEY, nameDraft);
		} catch {
			/* no storage: the table is this session's */
		}
	}

	/** Live keystroke cleanup: capitals, umlauts and digits, five at most. */
	const tidyName = (v: string) => v.toUpperCase().replace(/[^A-Z0-9ÄÖÜß]/g, '').slice(0, NAME_LEN);

	/** Action: the keyboard is ready the moment the slots appear. */
	const focusNow = (el: HTMLInputElement) => {
		el.focus();
		el.setSelectionRange(el.value.length, el.value.length);
	};

	function submitName() {
		if (!overRank || entered) return;
		const name = sanitizeName(nameDraft);
		nameDraft = name;
		const entry: WortScore = { name, pts, level: WORT_LEVELS[levelIdx].name, at: Date.now() };
		enteredAt = entry.at;
		scores = insertScore(scores, entry);
		entered = true;
		saveScores();
		// Your five letters go to the world board too, fire-and-forget.
		void submitWorldScore(entry).then((ok) => {
			if (ok) worldState = 'idle'; // refetch next time the board opens
		});
		playSound('milestone');
		announce(`Place ${overRank}: ${name}, ${pts} points.`);
	}

	// -- sizing: the board fills whatever is left, no page scroll ever ------------
	/** The mat around the grid: room for handles and badges to breathe. */
	const PAD = 12;
	/** How far a handle may reach into the mat before it slides inward. */
	const EXT = 8;
	let zoneW = $state(0);
	let zoneH = $state(0);
	const cs = $derived(
		Math.max(
			20,
			Math.min(
				Math.floor((zoneW - 2 - PAD * 2) / grid.cols),
				Math.floor((zoneH - 2 - PAD * 2) / grid.rows)
			) || 20
		)
	);

	const upper = (w: WortWord) => w.de.toUpperCase();
	const spoken = (w: WortWord) => (w.art ? `${w.art} ${w.de}` : w.de);
	const dur = () => (effectsCalm() ? 0 : 1);

	function sayDe(text: string) {
		if (!sayOn) return;
		// skipCloud: the game speaks on every tap — a recording if one exists,
		// else the device voice at once, never a cloud round-trip per word.
		void tts.speak(text, { locale: LOCALE, skipCloud: true }).catch(() => {});
	}

	function float(text: string, x: number, y: number, cls = '') {
		const id = nextId++;
		floats = [...floats.slice(-4), { id, x, y, text, cls }];
		// Teaching floats (the big ones) linger long enough to be read.
		setTimeout(() => (floats = floats.filter((f) => f.id !== id)), cls.includes('big') ? 2600 : 1300);
	}
	const floatAt = (b: Block, text: string, cls = '', dy = -0.9) =>
		float(text, Math.min(b.c, Math.max(0, grid.cols - 5)) * cs, (b.r + dy) * cs, cls);

	// -- spawning ------------------------------------------------------------------
	/** A word suits the CURRENT grid when it lies flat with at least one cell
	 *  to spare — long words never stand (pillars wreck the board), and a
	 *  full-width word would be a free line. Longer words wait for a bigger
	 *  grid. */
	const suitsGrid = (w: WortWord) => w.de.length < grid.cols;

	function refillQueue() {
		if (queue.length) return;
		const onBoard = new Set(blocks.map((b) => b.word.de));
		const onBoardEn = new Set(blocks.map((b) => b.word.en.toLowerCase()));
		const words = refillWords(data.pools, levelIdx, onBoard, onBoardEn).filter(suitsGrid);
		// Never-played words first, then the longest-unseen: fresh learning
		// every game, repeats only when the bank is truly exhausted.
		queue = orderByFreshness(words, seen).map((word) => ({
			word,
			color: WORT_PALETTE[Math.floor(Math.random() * WORT_PALETTE.length)]
		}));
	}

	function showNext() {
		refillQueue();
		preview = queue.slice(0, 3).map((q) => ({ de: upper(q.word), color: q.color }));
	}

	function spawn(animate = true) {
		if (phase === 'over') return;
		// Neither the word nor its English may already be on the board: two
		// chips reading the same translation would make the right answer wrong.
		const onBoard = (w: WortWord) =>
			blocks.some((b) => b.word.de === w.de || b.word.en.toLowerCase() === w.en.toLowerCase());
		const usable = (q: { word: WortWord }) =>
			!onBoard(q.word) && canFit(blocks, q.word.de.length, grid);
		// The first queued word that actually FITS: a long word never ends the
		// game while a shorter one is waiting behind it.
		refillQueue();
		let at = queue.findIndex(usable);
		if (at < 0) {
			queue = [];
			refillQueue();
			at = queue.findIndex(usable);
		}
		if (at < 0) {
			// Nothing in the whole bank lands: over only when the board is
			// truly full — even a three-letter word has nowhere to go.
			if (!canFit(blocks, 3, grid)) gameOver();
			return;
		}
		const next = queue.splice(at, 1)[0];
		markSeen(next.word.de);
		const len = next.word.de.length;
		// The preferred orientation, falling back to the other when only that
		// one has room.
		let dir = spawnDir(len, grid.cols);
		let spot = pickSpot(blocks, len, dir, grid);
		if (!spot) {
			const alt = dir === 'h' ? ('v' as const) : ('h' as const);
			if (!(alt === 'v' && len > grid.rows) && !(alt === 'h' && len > grid.cols)) {
				const altSpot = pickSpot(blocks, len, alt, grid);
				if (altSpot) {
					dir = alt;
					spot = altSpot;
				}
			}
		}
		if (!spot) return gameOver();
		const b: Block = {
			id: nextId++,
			word: next.word,
			color: next.color,
			dir,
			len,
			r: spot.r,
			c: spot.c,
			gilded: false,
			done: false,
			runset: false,
			clearing: false,
			fizzle: false,
			featured: false,
			learned: false,
			hinted: false
		};
		blocks.push(b);
		if (animate) requestAnimationFrame(() => requestAnimationFrame(settle));
		else settle();
		syncChips();
		if (animate) maybeDealStar();
		showNext();
	}

	function settle() {
		const fell = settleBlocks(blocks, grid.rows);
		if (fell) setTimeout(() => playSound('land'), 260);
		pruneSets();
		checkLines();
		updateDanger();
		return fell;
	}

	// -- lines, sets, runs ------------------------------------------------------------
	/** Rule three: when the board's shuffling cuts a pending set's member off
	 *  from its line, the gold comes off it — it is no longer part of the set.
	 *  The active run is left alone: its board cannot change under it. */
	function pruneSets() {
		if (activeCh || dealing) return;
		let changed = false;
		for (const ch of [...challenges]) {
			const kept = connectedToAnchors(blocks, ch.ids, ch.anchorIds);
			if (kept.size === ch.ids.size) continue;
			changed = true;
			for (const b of blocks) {
				if (ch.ids.has(b.id) && !kept.has(b.id)) {
					b.gilded = false;
					ch.ids.delete(b.id);
					ch.des.delete(b.word.de);
				}
			}
			if (!ch.ids.size) challenges = challenges.filter((x) => x !== ch);
		}
		if (changed) updateGoldBar();
	}

	function checkLines() {
		if (activeCh || dealing) return;
		const now = completeRows(blocks, grid);
		const fresh = [...now].filter((r) => !fullRows.has(r));
		fullRows = now;
		for (const r of fresh) {
			const colors = rowColors(blocks, r);
			if (colors.size !== 1) {
				lineFlash(r, true);
				continue;
			}
			gildRow(r, [...colors][0]);
		}
	}

	function lineFlash(r: number, mixed: boolean) {
		const id = nextId++;
		lineFx = [...lineFx, { id, r, mixed }];
		setTimeout(() => (lineFx = lineFx.filter((x) => x.id !== id)), 900);
		if (mixed) float('Gemischt! One color makes gold', cs, Math.max(0, r - 1) * cs, 'muted');
	}

	/** One line, one CONNECTED region. The flood from this row may run into a
	 *  pending same-color set — only then do the sets merge. A same-color
	 *  line elsewhere on the board stays its own set. */
	function gildRow(row: number, color: string) {
		// Other colors' sets are walls the flood never crosses; same-color
		// pending sets are left open, so touching them is detectable below.
		const taken = new Set<number>(
			challenges.filter((x) => x.color !== color).flatMap((x) => [...x.ids, ...x.doneIds])
		);
		const region = goldenRegion(blocks, [row], color, taken) as Block[];
		const ids = new Set(region.map((b) => b.id));
		const touched = challenges.filter(
			(x) => x.color === color && !x.active && [...x.ids].some((id) => ids.has(id))
		);
		let ch = touched[0];
		const merging = Boolean(ch);
		if (!ch) {
			ch = { color, ids: new Set(), des: new Set(), doneIds: new Set(), anchorIds: new Set(), active: false, pot: 0, lines: 0 };
			challenges.push(ch);
		}
		// The region bridged several pending sets of its color: they become one.
		for (const other of touched.slice(1)) {
			for (const id of other.ids) ch.ids.add(id);
			for (const de of other.des) ch.des.add(de);
			for (const id of other.anchorIds) ch.anchorIds.add(id);
			ch.lines += other.lines;
			challenges = challenges.filter((x) => x !== other);
		}
		ch.lines += 1;
		lineFlash(row, false);
		playSound('msgIn');
		for (const b of region) {
			ch.ids.add(b.id);
			ch.des.add(b.word.de);
			if (cellsOf(b).some(([r]) => r === row)) ch.anchorIds.add(b.id);
			b.gilded = true;
		}
		announce(merging ? 'Another golden line.' : `Golden line: ${ch.ids.size} words.`);
		updateGoldBar();
	}

	function updateGoldBar() {
		if (activeCh) return;
		if (!challenges.length) {
			goldBar = null;
			return;
		}
		const total = challenges.reduce((n, c) => n + c.ids.size, 0);
		goldBar =
			challenges.length > 1
				? `⭐ ${challenges.length} golden sets (${total} words) — start one, finish THAT set`
				: `⭐ Goldene Zeile: ${total} words — match one to start, then ALL in a row`;
	}

	function markGilded(b: Block, ch: GoldenSet) {
		if (!ch.active) {
			ch.active = true;
			activeCh = ch;
			runOn = true;
			for (const x of blocks) if (ch.ids.has(x.id)) x.runset = true;
		}
		ch.ids.delete(b.id);
		ch.doneIds.add(b.id);
		ch.pot += POT_PER_WORD;
		goldBar = ch.ids.size
			? `⭐ ${b.word.en} ✓ · noch ${ch.ids.size} · Pot ${ch.pot}`
			: '⭐ The last one…';
		playSound('right', combo);
		sayDe(spoken(b.word));
		clearSelection();
		b.gilded = false;
		b.done = true;
		wordsDone++;
		floatAt(b, `✨ ${b.word.en}`, 'gold', -0.6);
		if (ch.ids.size === 0) winRun(ch);
	}

	function winRun(ch: GoldenSet) {
		const doneBlocks = blocks.filter((x) => ch.doneIds.has(x.id));
		gain(ch.pot);
		challenges = challenges.filter((x) => x !== ch);
		activeCh = null;
		runOn = false;
		goldBar = null;
		updateGoldBar();
		doneBlocks.forEach((x, i) =>
			setTimeout(() => {
				x.clearing = true;
			}, i * 110 * dur())
		);
		setTimeout(
			() => {
				blocks = blocks.filter((x) => !doneBlocks.includes(x));
				const bonus = LINE_BONUS * ch.lines * ch.lines;
				gain(bonus);
				movUses += LINE_MOVES * ch.lines;
				rotUses += LINE_ROTATES * ch.lines;
				linesWon += ch.lines;
				celebrate(ch.lines >= 3 ? 'Dreifach-Zeile!' : ch.lines === 2 ? 'Doppel-Zeile!' : 'Zeile!');
				announce(`Line cleared. ${bonus} bonus points.`);
				if (!blocks.length) return perfectClear();
				settle();
				syncChips();
				spawn(); // a finished line feeds exactly ONE new word
			},
			doneBlocks.length * 110 * dur() + 380
		);
	}

	function failRun(b: Block, ch: GoldenSet) {
		if (!ch || b.fizzle) return;
		playSound('wrong');
		const name = spoken(b.word);
		sayDe(name);
		floatAt(b, `✗ ${name} = ${b.word.en}`, 'big ' + (b.word.art ? artClass(b.word.art) : ''), -1.1);
		teach(b.word);
		announce(`Wrong: ${name}, ${b.word.en}. The golden set is lost.`);
		// The whole set goes down with the miss, and the board is refilled
		// like for like: as many fresh words as were lost. No points.
		const members = blocks.filter((x) => ch.ids.has(x.id) || ch.doneIds.has(x.id));
		challenges = challenges.filter((x) => x !== ch);
		if (activeCh === ch) activeCh = null;
		runOn = false;
		goldBar = null;
		updateGoldBar();
		combo = 1;
		clearSelection();
		for (const x of members) x.fizzle = true;
		setTimeout(() => {
			blocks = blocks.filter((x) => !members.includes(x));
			float('Verloren — keine Punkte', cs * 1.5, Math.round(grid.rows * 0.4) * cs, 'muted');
			syncChips();
			settle();
			for (let i = 0; i < members.length; i++) spawn();
		}, 600 * dur() + 50);
	}

	// -- points, levels, danger, the end ------------------------------------------
	function gain(n: number) {
		pts += n;
		let next = levelForPoints(pts);
		if (next === levelIdx) return;
		levelIdx = next;
		queue = [];
		showNext();
		celebrate(`${WORT_LEVELS[levelIdx].name}!`);
		announce(`Level up: ${WORT_LEVELS[levelIdx].name}. New words.`);
	}

	function updateDanger() {
		if (phase === 'over') return;
		refillQueue();
		const tight = stackTop(blocks, grid.rows) <= 2;
		// Critical when none of the next few words could land any more.
		const blocked = queue.length
			? !queue.slice(0, 5).some((q) => canFit(blocks, q.word.de.length, grid))
			: false;
		const was = danger;
		danger = tight || blocked;
		if (danger && !was) {
			playSound('down');
			float('⚠ Achtung — wenig Platz!', cs, cs, 'big accent');
			announce('Careful: the board is nearly full.');
		}
	}

	function gameOver() {
		if (phase === 'over') return;
		phase = 'over';
		danger = false;
		overRank = scoreRank(scores, pts);
		entered = false;
		playSound('unmatch');
		if (pts > best) {
			best = pts;
			try {
				localStorage.setItem(BEST_KEY, String(best));
			} catch {
				/* no storage: the best is this session's */
			}
		}
		track('wortbloecke_over', { pts, level: WORT_LEVELS[levelIdx].name, words: wordsDone, lines: linesWon });
		announce(`The board is full. ${pts} points, level ${WORT_LEVELS[levelIdx].name}.`);
	}

	// -- matching ----------------------------------------------------------------------
	function clearSelection() {
		selected = null;
		grabbedId = null;
	}

	function buzz(b: Block) {
		playSound('wrong');
		shake(b);
		float('Erst die goldene Zeile!', cs * 2, cs, 'muted');
	}

	let shaken = $state<number | null>(null);
	function shake(b: Block) {
		shaken = null;
		requestAnimationFrame(() => (shaken = b.id));
	}

	/** The star spent on a word: say and show what it means — and for a noun,
	 *  the article. Shown is shown: the word pays silver from here on. */
	function useHint(b: Block) {
		hintMode = false;
		chips = chips.filter((de) => de !== STAR); // the star is spent
		b.hinted = true;
		if (b.word.art) b.learned = true;
		playSound('msgIn');
		sayDe(spoken(b.word));
		floatAt(b, `${spoken(b.word)} = ${b.word.en}`, 'big ' + (b.word.art ? artClass(b.word.art) : 'muted'), -1.1);
		announce(`${spoken(b.word)}: ${b.word.en}.`);
	}

	function tapBlock(b: Block) {
		if (pending || phase !== 'play') return;
		if (b.clearing || b.fizzle) return;
		// An armed star reveals any word — even a golden one mid-run.
		if (hintMode) return useHint(b);
		const ch = setOf(b);
		if (activeCh && ch !== activeCh) return buzz(b);
		if (doneOf(b)) return buzz(b);
		if (!selected) {
			// Select the block; a golden word offers no Move/Rotate. Selecting
			// speaks the bare word — pronunciation without giving the article away.
			const picking = grabbedId !== b.id;
			playSound(picking ? 'up' : 'down');
			grabbedId = picking ? b.id : null;
			if (picking) sayDe(b.word.de);
			// A word already wearing its article: picking it asks the article
			// straight away — the meaning is in view, no need to pair it again.
			// On a golden word this IS the golden move: a right article starts
			// (or continues) the run, a wrong one loses the set.
			if (picking && b.learned && b.word.art) askArticle(b, ch, true);
			return;
		}
		if (ch) {
			if (selected !== b.word.de) return failRun(b, ch);
			if (b.word.art) return askArticle(b, ch);
			return markGilded(b, ch);
		}
		if (selected !== b.word.de) {
			playSound('wrong');
			shake(b);
			combo = 1;
			// The lesson: what this block really means.
			sayDe(spoken(b.word));
			floatAt(b, `✗ ${spoken(b.word)} = ${b.word.en}`, 'big ' + (b.word.art ? artClass(b.word.art) : ''), -1.1);
			teach(b.word);
			announce(`Wrong. ${spoken(b.word)}: ${b.word.en}.`);
			spawn(); // a wrong pair costs board space
			return;
		}
		if (b.word.art) return askArticle(b, null);
		clearBlock(b, MATCH_POINTS, false);
	}

	function tapChip(de: string) {
		if (phase !== 'play' || pending) return;
		const g = grabbed as Block | null;
		playSound('up');
		if (g) {
			const gch = setOf(g);
			if (doneOf(g)) return buzz(g);
			if (g.word.de !== de) {
				if (gch) return failRun(g, gch);
				playSound('wrong');
				combo = 1;
				sayDe(spoken(g.word));
				floatAt(g, `✗ ${spoken(g.word)} = ${g.word.en}`, 'big ' + (g.word.art ? artClass(g.word.art) : ''), -1.1);
				teach(g.word);
				announce(`Wrong. ${spoken(g.word)}: ${g.word.en}.`);
				spawn(); // a wrong pair costs board space
				return;
			}
			if (gch) {
				if (g.word.art) return askArticle(g, gch);
				return markGilded(g, gch);
			}
			if (g.word.art) return askArticle(g, null);
			return clearBlock(g, MATCH_POINTS, false);
		}
		selected = selected === de ? null : de;
	}

	// -- the article strip ----------------------------------------------------------
	/** `free`: the question was opened by just tapping a badge-wearing word —
	 *  nothing is wagered until an article is chosen, so it may be put away.
	 *  A question reached by PAIRING is committed and must be answered. */
	function askArticle(b: Block, ch: GoldenSet | null, free = false) {
		pending = b;
		pendingRun = ch;
		pendingFree = free;
		b.featured = true;
	}

	/** Put the question away (only while nothing is wagered): the word stays. */
	function cancelArticle() {
		if (!pending || (pendingRun && !pendingFree)) return;
		pending.featured = false;
		pending = null;
		pendingRun = null;
		pendingFree = false;
		grabbedId = null;
		playSound('down');
	}

	function answerArticle(art: string) {
		const b = pending;
		if (!b) return;
		pending = null;
		b.featured = false;
		const ch = pendingRun;
		pendingRun = null;
		pendingFree = false;
		const right = art === b.word.art;
		floatAt(
			b,
			right ? `✓ ${spoken(b.word)}` : `✗ ${art}? → ${spoken(b.word)} = ${b.word.en}`,
			'big ' + artClass(b.word.art!),
			-1.1
		);
		if (!right) teach(b.word);
		if (ch) {
			if (right) return markGilded(b, ch);
			return failRun(b, ch);
		}
		// A learned word still has to be answered — the badge shows the
		// article, reading it off IS the rep — but it pays silver, since the
		// answer is in view. First-try knowledge pays gold.
		if (right) return clearBlock(b, b.learned ? MATCH_POINTS : GOLD_POINTS, !b.learned);
		// Wrong article: the word stays, now WEARING its article as the lesson.
		// The mistake still drops a new block.
		playSound('wrong');
		sayDe(spoken(b.word));
		shake(b);
		b.learned = true;
		clearSelection();
		spawn();
	}

	const artClass = (art: string) => (art === 'der' ? 'der' : art === 'die' ? 'die' : 'das');

	// -- clearing a free block ---------------------------------------------------------
	function clearBlock(b: Block, base: number, gold: boolean) {
		if (b.clearing) return;
		const now = Date.now();
		combo = now - lastMatch < COMBO_WINDOW_MS ? combo + 1 : 1;
		lastMatch = now;
		// A long word is harder to read and harder to place: it pays extra.
		const long = b.len >= LONG_WORD_LEN;
		const gained = (base + (long ? LONG_WORD_BONUS : 0)) * combo;
		gain(gained);
		playSound('right', combo);
		sayDe(spoken(b.word));
		floatAt(b, `${gold ? '★ ' : ''}+${gained}${long ? ' · langes Wort!' : ''}`, gold ? 'gold' : '', -0.6);
		clearSelection();
		b.clearing = true;
		if (gold) {
			golds++;
			earn('move', 'Artikel!');
			if (golds % 2 === 0) earn('rotate', 'Artikel!');
		}
		wordsDone++;
		setTimeout(() => {
			blocks = blocks.filter((x) => x !== b);
			if (!blocks.length) return perfectClear();
			const fell = settle();
			if (fell >= LANDSLIDE) earn('move', 'Landslide!');
			syncChips();
			spawn(); // an earned word ALWAYS brings the next one
		}, 380 * dur() + 20);
	}

	/** The board swept completely empty: the rarest feat in the game. */
	function perfectClear() {
		gain(PERFECT_CLEAR_BONUS);
		movUses++;
		rotUses++;
		celebrate('Alles weg!');
		announce(`Perfect clear! ${PERFECT_CLEAR_BONUS} bonus points.`);
		syncChips();
		danger = false;
		// A fresh little hand, so the triumph flows straight into play.
		for (let i = 0; i < 3; i++) spawn();
	}

	function earn(what: 'move' | 'rotate', why: string) {
		if (what === 'move') movUses++;
		else rotUses++;
		playSound('up');
		float(`+1 ${what === 'move' ? '◀▶' : '⟳'} · ${why}`, cs * 2, cs * 2, 'accent');
	}

	// -- move and rotate ------------------------------------------------------------------
	function fits(b: Block, cand: { dir: 'h' | 'v'; r: number; c: number }): boolean {
		const occ = new Map<string, true>();
		for (const x of blocks) {
			if (x === b) continue;
			for (const [r, c] of cellsOf(x)) occ.set(`${r},${c}`, true);
		}
		return cellsOf({ ...b, ...cand }, cand.r, cand.c).every(
			([r, c]) => r >= 0 && r < grid.rows && c >= 0 && c < grid.cols && !occ.has(`${r},${c}`)
		);
	}

	function doMove(dc: number) {
		const b = grabbed as Block | null;
		if (!b || movUses === 0 || phase !== 'play') return;
		const cand = { dir: b.dir, r: b.r, c: b.c + dc };
		if (!fits(b, cand)) {
			playSound('wrong');
			shake(b);
			return;
		}
		b.c = cand.c;
		movUses--;
		playSound('land');
		setTimeout(settle, 180);
	}

	/** The spot a rotation would land in, nearest pivot first, or null. */
	function rotateCandidate(b: Block): { dir: 'h' | 'v'; r: number; c: number } | null {
		const cands =
			b.dir === 'h'
				? [
						{ dir: 'v' as const, r: b.r - b.len + 1, c: b.c },
						{ dir: 'v' as const, r: b.r - b.len + 1, c: b.c + b.len - 1 },
						{ dir: 'v' as const, r: b.r, c: b.c },
						{ dir: 'v' as const, r: b.r, c: b.c + b.len - 1 }
					]
				: [
						{ dir: 'h' as const, r: b.r + b.len - 1, c: b.c },
						{ dir: 'h' as const, r: b.r + b.len - 1, c: b.c - b.len + 1 },
						{ dir: 'h' as const, r: b.r, c: b.c },
						{ dir: 'h' as const, r: b.r, c: b.c - b.len + 1 }
					];
		return cands.find((x) => fits(b, x)) ?? null;
	}

	function doRotate() {
		const b = grabbed as Block | null;
		if (!b || rotUses === 0 || b.len === 1 || phase !== 'play') return;
		const cand = rotateCandidate(b);
		if (!cand) {
			playSound('wrong');
			shake(b);
			return;
		}
		Object.assign(b, cand);
		rotUses--;
		playSound('msgOut');
		setTimeout(settle, 220);
	}

	// -- the tray -----------------------------------------------------------------------
	function syncChips() {
		const want = new Set(blocks.map((b) => b.word.de));
		let next = chips.filter((de) => de === STAR || want.has(de));
		for (const de of want) {
			if (next.includes(de)) continue;
			const at = Math.floor(Math.random() * (next.length + 1));
			next = [...next.slice(0, at), de, ...next.slice(at)];
		}
		chips = next;
	}

	/** Now and then a star is dealt into the tray like a word: one at a
	 *  time, in a random seat. */
	function maybeDealStar() {
		if (chips.includes(STAR) || Math.random() >= STAR_CHANCE) return;
		const at = Math.floor(Math.random() * (chips.length + 1));
		chips = [...chips.slice(0, at), STAR, ...chips.slice(at)];
		playSound('msgIn');
		announce('A hint star turned up in the tray.');
	}
	const chipWord = (de: string) => blocks.find((b) => b.word.de === de)?.word ?? null;
	const chipDone = (de: string) => blocks.some((b) => b.word.de === de && b.done);

	// -- drag a chip onto a block -----------------------------------------------
	// Pointer-based so it works with a thumb: past a small threshold the chip
	// lifts into a ghost, the block underneath lights up, and dropping runs
	// the very same match logic as tapping. A short press stays a tap.
	let drag = $state<{ de: string; x: number; y: number } | null>(null);
	let dragTarget = $state<number | null>(null);
	let dragStart: { x: number; y: number; de: string } | null = null;
	let suppressClick = false;

	function chipDown(e: PointerEvent, de: string) {
		if (phase !== 'play' || pending || chipDone(de)) return;
		dragStart = { x: e.clientX, y: e.clientY, de };
		(e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
	}

	function chipMove(e: PointerEvent) {
		if (!dragStart) return;
		if (!drag) {
			if (Math.hypot(e.clientX - dragStart.x, e.clientY - dragStart.y) < 8) return;
			drag = { de: dragStart.de, x: e.clientX, y: e.clientY };
			playSound('up');
		} else {
			drag = { de: drag.de, x: e.clientX, y: e.clientY };
		}
		const el = document.elementFromPoint(e.clientX, e.clientY)?.closest('[data-block]');
		dragTarget = el ? Number((el as HTMLElement).dataset.block) : null;
	}

	function chipUp() {
		dragStart = null;
		if (!drag) return; // it stayed a tap: the click handler takes it
		suppressClick = true;
		setTimeout(() => (suppressClick = false), 0);
		const de = drag.de;
		drag = null;
		const id = dragTarget;
		dragTarget = null;
		const b = id !== null ? blocks.find((x) => x.id === id) : undefined;
		if (!b) {
			playSound('down');
			return;
		}
		selected = de;
		tapBlock(b);
		if (selected === de) selected = null; // a miss leaves the selection set
	}

	function chipCancel() {
		dragStart = null;
		drag = null;
		dragTarget = null;
	}

	// -- boot ----------------------------------------------------------------------------
	// Boot reads run ONCE. (As an $effect this read its own freshly written
	// `scores`, which re-triggers the effect forever in Svelte 5.)
	onMount(() => {
		try {
			rulesSeen = localStorage.getItem(RULES_KEY) === '1';
			const rawSeen = JSON.parse(localStorage.getItem(SEEN_KEY) ?? '[]');
			seen = Array.isArray(rawSeen) ? rawSeen.filter((x) => typeof x === 'string').slice(-SEEN_CAP) : [];
			const list = parseScores(localStorage.getItem(SCORES_KEY));
			scores = list;
			const name = sanitizeName(localStorage.getItem(NAME_KEY) ?? '');
			nameDraft = name === 'ANON' ? '' : name;
			best = Math.max(Number(localStorage.getItem(BEST_KEY) ?? 0) || 0, list[0]?.pts ?? 0);
		} catch {
			best = 0;
		}
	});

	// -- how to play ---------------------------------------------------------------
	const RULES_KEY = 'wortbloecke_rules_seen';
	let showRules = $state(false);
	let rulesSeen = $state(false);

	function start() {
		// The first game opens on the rules; after that, straight in.
		if (!rulesSeen) {
			showRules = true;
			return;
		}
		beginGame();
	}

	function closeRules() {
		showRules = false;
		if (!rulesSeen) {
			rulesSeen = true;
			try {
				localStorage.setItem(RULES_KEY, '1');
			} catch {
				/* no storage: shown again next visit */
			}
			if (phase === 'intro') beginGame();
		}
	}

	function beginGame() {
		phase = 'play';
		track('wortbloecke_start', {});
		// Deal quietly, then check once: a line on the opening board counts,
		// but only as one line, not once per card dealt.
		dealing = true;
		for (let i = 0; i < 7; i++) spawn(false);
		dealing = false;
		fullRows = new Set();
		checkLines();
		updateDanger();
	}

	function again() {
		blocks = [];
		challenges = [];
		activeCh = null;
		runOn = false;
		fullRows = new Set();
		queue = [];
		chips = [];
		preview = [];
		floats = [];
		lineFx = [];
		pts = 0;
		combo = 1;
		lastMatch = 0;
		movUses = START_MOVES;
		rotUses = START_ROTATES;
		hintMode = false;
		golds = 0;
		wordsDone = 0;
		linesWon = 0;
		levelIdx = 0;
		goldBar = null;
		danger = false;
		pending = null;
		pendingRun = null;
		shaken = null;
		overRank = null;
		entered = false;
		showBoard = false;
		clearSelection();
		phase = 'intro';
	}
</script>

<Seo
	title="Wortblöcke: the German word puzzle | Language Quiz"
	description="A free word puzzle for learning German: pair falling word blocks with their English, name the articles, and clear golden lines — from A1 all the way past C2."
	path="/play/wortbloecke"
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Wortblöcke', path: '/play/wortbloecke' }])]}
/>

<main class="wort">
	<header class="top">
		<div class="row">
			<a class="back" href={DECK} aria-label="Back to your deck"><Icon name="arrowLeft" size="1em" /> <span class="bt">Back</span></a>
			<span class="brand"><span class="t" lang="de">Wortblöcke</span>{#key levelIdx}<span class="lvl tnum pop">{WORT_LEVELS[levelIdx].name}</span>{/key}</span>
			<span class="grow"></span>
			{#if combo > 1}{#key combo}<span class="combo pop">×{combo}!</span>{/key}{/if}
			<span class="score"><small class="st">Punkte</small> <b class="tnum">{pts}</b></span>
			<button type="button" class="say" aria-pressed={sayOn} title="Speak the words" onclick={() => (sayOn = !sayOn)}>
				<Icon name={sayOn ? 'volume' : 'volumeOff'} size="1.05em" />
			</button>
			<button type="button" class="say" title="Bestenliste" aria-label="Bestenliste" onclick={openBoard}>
				<Icon name="trophy" size="1.05em" />
			</button>
			<button type="button" class="say" title="How to play" aria-label="How to play" onclick={() => (showRules = true)}>
				<Icon name="help" size="1.05em" />
			</button>
		</div>
		<!-- The queue gets a whole line: a nine-letter word fits with room over. -->
		<div class="row sub" aria-hidden="true">
			<span class="nextlabel">Next</span>
			<span class="next">
				{#each preview as p, i (p.de + i)}
					<span class="minigroup">
						{#if i === 0}
							{#each p.de as ch, j (j)}<span class="mini" style="background: {p.color}">{ch}</span>{/each}
						{:else}
							<span class="dotq" style="background: {p.color}"></span>
						{/if}
					</span>
				{/each}
			</span>
		</div>
	</header>

	<div class="zone" bind:clientWidth={zoneW} bind:clientHeight={zoneH}>
		<div
			class="board"
			class:danger
			class:golden={runOn}
			style="width: {grid.cols * cs + PAD * 2}px; height: {grid.rows * cs + PAD * 2}px; --cs: {cs}px"
		>
			<!-- The grid sits on a mat: handles and badges reach into the
			     padding instead of being cut off at the board's edge. -->
			<div class="grid" style="width: {grid.cols * cs}px; height: {grid.rows * cs}px">
			{#each lineFx as fx (fx.id)}
				<div class="linefx" class:mixed={fx.mixed} style="top: {fx.r * cs}px; height: {cs}px"></div>
			{/each}

			{#each blocks as b (b.id)}
				<button
					type="button"
					class="block"
					class:v={b.dir === 'v'}
					class:gilded={b.gilded}
					class:done={b.done}
					class:runset={b.runset}
					class:clearing={b.clearing}
					class:fizzle={b.fizzle}
					class:featured={b.featured}
					class:grabbed={grabbedId === b.id}
					class:shake={shaken === b.id}
					style="left: {b.c * cs}px; top: {b.r * cs}px; --c: {b.color}"
					class:droptarget={dragTarget === b.id}
					data-block={b.id}
					lang="de"
					aria-label={spoken(b.word)}
					onclick={() => tapBlock(b)}
				>
					{#each b.word.de as ch, i (i)}<span class="sq">{ch}</span>{/each}
					{#if b.word.art}
						<span class="badge" class:learned={b.learned} aria-hidden="true">{b.learned ? b.word.art : '?'}</span>
					{:else if b.hinted}
						<span class="badge learned" aria-hidden="true">★</span>
					{/if}
				</button>
			{/each}

			{#each floats as f (f.id)}
				<span class="float {f.cls}" style="left: {f.x}px; top: {f.y}px">{f.text}</span>
			{/each}

			{#if ctl}
				<!-- The grabbed word grows its own handles: nudge from its end
				     caps, rotate from the tab on its edge. A handle only shows
				     when its move is possible. Keyed by the block, so handles
				     never glide from one word to another — each grab puts them
				     up fresh, arriving from the direction they push. -->
				{#key grabbedId}
				{#if ctl.canLeft}
					<button
						type="button"
						class="bctl lcap"
						style="left: {ctl.left.x}px; top: {ctl.left.y}px; width: {ctl.capW}px; height: {ctl.capH}px; --bc: {ctl.color}"
						onclick={() => doMove(-1)}
						aria-label="Move left ({movUses} left)"
					>
						<Icon name="arrowLeft" size="1em" />
						<span class="uses tnum" aria-hidden="true">{movUses}</span>
					</button>
				{/if}
				{#if ctl.canRight}
					<button
						type="button"
						class="bctl rcap"
						style="left: {ctl.right.x}px; top: {ctl.right.y}px; width: {ctl.capW}px; height: {ctl.capH}px; --bc: {ctl.color}"
						onclick={() => doMove(1)}
						aria-label="Move right ({movUses} left)"
					>
						<Icon name="arrowRight" size="1em" />
						<span class="uses tnum" aria-hidden="true">{movUses}</span>
					</button>
				{/if}
				{#if ctl.canRot}
					<button
						type="button"
						class="bctl rot"
						class:under={ctl.under}
						style="left: {ctl.rot.x}px; top: {ctl.rot.y}px; width: {ctl.rotW}px; height: {ctl.rotH}px; --bc: {ctl.color}"
						onclick={doRotate}
						aria-label="Rotate ({rotUses} left)"
					>
						<Icon name="repeat" size="0.9em" />
						<span class="uses tnum" aria-hidden="true">{rotUses}</span>
					</button>
				{/if}
				{/key}
			{/if}
			</div>


			{#if pending}
				<div class="art-ask">
					<p lang="de"><b>{pending.word.de}</b>:</p>
					<div class="arts">
						<button type="button" class="art-btn der" onclick={() => answerArticle('der')}>der</button>
						<button type="button" class="art-btn die" onclick={() => answerArticle('die')}>die</button>
						<button type="button" class="art-btn das" onclick={() => answerArticle('das')}>das</button>
					</div>
					{#if !pendingRun || pendingFree}
						<!-- While nothing is wagered the question may wait: back to the board. -->
						<button type="button" class="art-x" onclick={cancelArticle} aria-label="Not now">
							<Icon name="close" size="1em" />
						</button>
					{/if}
				</div>
			{/if}

			{#if phase === 'over'}
				<div class="gameover">
					<div class="over-card">
						<strong lang="de">Das Brett ist voll!</strong>
						<dl class="over-stats">
							<div><dt>Score</dt><dd class="tnum">{pts}</dd></div>
							<div><dt>Level</dt><dd>{WORT_LEVELS[levelIdx].name}</dd></div>
							<div><dt>Words</dt><dd class="tnum">{wordsDone}</dd></div>
							<div><dt>Lines</dt><dd class="tnum">{linesWon}</dd></div>
						</dl>
						{#if overRank && !entered}
							<!-- Made the table: write your name, arcade style. -->
							<p class="bestline">★ Platz {overRank}! Dein Name:</p>
							<form
								class="entry"
								onsubmit={(e) => {
									e.preventDefault();
									submitName();
								}}
							>
								<!-- One REAL input, drawn as five letter cells: ordinary typing,
								     visible caret, edit anywhere — the decoration is background only. -->
								<input
									class="slotline"
									type="text"
									maxlength={NAME_LEN}
									autocapitalize="characters"
									autocomplete="off"
									spellcheck="false"
									aria-label="Your name, up to five letters"
									bind:value={nameDraft}
									oninput={() => (nameDraft = tidyName(nameDraft))}
									use:focusNow
								/>
								<button type="submit" class="btn" disabled={!nameDraft.length}>
									Eintragen <Icon name="check" size="1em" />
								</button>
							</form>
						{:else}
							{#if entered}
								<ol class="minilist" aria-label="Best scores">
									{#each scores.slice(0, 5) as s, i (s.at)}
										<li class:me={s.at === enteredAt}>
											<span class="rk tnum">{i + 1}</span>
											<span class="nm">{s.name}</span>
											<span class="sc tnum">{s.pts}</span>
										</li>
									{/each}
									{#if overRank && overRank > 5}
										<li class="me gap-row">
											<span class="rk tnum">{overRank}</span>
											<span class="nm">{nameDraft}</span>
											<span class="sc tnum">{pts}</span>
										</li>
									{/if}
								</ol>
							{:else if best > 0}
								<p class="bestline">{pts >= best ? '★ New best!' : `Best: ${best}`}</p>
							{/if}
							<div class="over-actions">
								<button type="button" class="btn" onclick={again}>Nochmal <Icon name="repeat" size="1em" /></button>
								<button type="button" class="btn-ghost" onclick={openBoard}>Bestenliste</button>
							</div>
						{/if}
					</div>
				</div>
			{/if}
		</div>
	</div>

	<div class="tray-zone">
		<!-- The one line of standing advice. Gold business borrows it, so the
		     board itself is never covered by a message. -->
		{#if lesson}
			<p class="tray-label lesson"><span lang="de">{lesson.split(' = ')[0]}</span> = {lesson.split(' = ')[1]}</p>
		{:else if goldBar}
			<p class="tray-label gold">{goldBar}</p>
		{:else}
			<p class="tray-label">Find the German for…</p>
		{/if}
		<div class="tray" class:dense={chips.length > 8} class:packed={chips.length > 12}>
			{#each chips as de (de)}
				{#if de === STAR}
					<button
						type="button"
						class="en star"
						class:armed={hintMode}
						onclick={() => {
							hintMode = !hintMode;
							playSound(hintMode ? 'up' : 'down');
						}}
						aria-pressed={hintMode}
						aria-label="Hint star: reveal a word's meaning"
					>★</button>
				{:else}
				{@const w = chipWord(de)}
				{#if w}
					<button
						type="button"
						class="en"
						class:sel={selected === de}
						class:donechip={chipDone(de)}
						class:lifted={drag?.de === de}
						disabled={chipDone(de)}
						onclick={() => {
							if (!suppressClick) tapChip(de);
						}}
						onpointerdown={(e) => chipDown(e, de)}
						onpointermove={chipMove}
						onpointerup={chipUp}
						onpointercancel={chipCancel}
					>{w.en}</button>
				{/if}
				{/if}
			{/each}
		</div>
	</div>

	{#if drag}
		{@const gw = chipWord(drag.de)}
		{#if gw}
			<div class="dragghost" style="left: {drag.x}px; top: {drag.y}px">{gw.en}</div>
		{/if}
	{/if}

	{#if showRules}
		<!-- How to play: shown by itself before the very first game. -->
		<div class="board-sheet" role="dialog" aria-label="How to play">
			<div class="sheet-card">
				<header class="sheet-head">
					<h2 lang="de">So spielst du</h2>
					<button type="button" class="linkish" onclick={closeRules} aria-label="Close">
						<Icon name="close" size="1.1em" />
					</button>
				</header>
				<ul class="rules">
					<li>
						<span class="demo" aria-hidden="true">
							<span class="d-block"><i>T</i><i>ü</i><i>r</i></span>
							<span class="d-sep">⇄</span>
							<span class="d-chip">door</span>
							<span class="d-gap"></span>
							<span class="d-chip tilt">door</span>
							<span class="d-sep">⤵</span>
							<span class="d-block dim"><i>T</i><i>ü</i><i>r</i></span>
						</span>
						<span>Pair a German block with its English chip — tap one then the other, either order, or <strong>drag</strong> the chip onto the block. Every word is spoken.</span>
					</li>
					<li>
						<span class="demo" aria-hidden="true">
							<span class="d-art der">der</span>
							<span class="d-art die on">die</span>
							<span class="d-art das">das</span>
							<span class="d-sep">→</span>
							<span class="d-spark">★</span>
							<span class="d-gap"></span>
							<span class="d-sep">✗ →</span>
							<span class="d-block badged"><i>U</i><i>h</i><i>r</i><b>die</b></span>
						</span>
						<span>A noun asks for its <strong>article</strong>. Right first try pays gold and earns tools; miss it and the word wears the article on its badge — silver from then on.</span>
					</li>
					<li>
						<span class="demo" aria-hidden="true">
							<span class="d-grid">
								<i></i><i></i><i></i><i></i>
								<i class="au"></i><i class="nv"></i><i></i><i></i>
								<i class="au"></i><i class="au"></i><i class="au"></i><i class="au"></i>
							</span>
							<span class="d-sep">→</span>
							<span class="d-block gold"><i>G</i><i>o</i><i>l</i><i>d</i></span>
							<span class="d-spark">✨</span>
						</span>
						<span>Fill a row in <strong>one color</strong>: the row AND everything connected in that color turns golden (the odd color out stays plain). Match one golden word to start the run — then clear them ALL in a row. One miss loses the whole set; all right pays the jackpot. If the board shifts and a golden word loses touch with its line before you start, its gold comes off again.</span>
					</li>
					<li>
						<span class="demo" aria-hidden="true">
							<span class="d-cap l"><Icon name="arrowLeft" size="0.8em" /></span>
							<span class="d-block"><i>W</i><i>o</i><i>r</i><i>t</i></span>
							<span class="d-cap r"><Icon name="arrowRight" size="0.8em" /></span>
							<span class="d-cap t"><Icon name="repeat" size="0.8em" /></span>
						</span>
						<span>Tap a free block to <strong>grab</strong> it: arrows nudge it, the tab stands it up. One move and one rotate to start — right articles, landslides and lines earn more.</span>
					</li>
					<li>
						<span class="demo" aria-hidden="true">
							<span class="d-star">★</span>
							<Icon name="arrowRight" size="0.85em" />
							<span class="d-chip">die Lampe · lamp</span>
						</span>
						<span>Now and then a <strong>star</strong> turns up in the tray. Spend it on any word to see and hear what it means.</span>
					</li>
					<li>
						<span class="demo" aria-hidden="true">
							<span class="d-sep">✗ →</span>
							<span class="d-block dim sm"><i>n</i><i>e</i><i>u</i></span>
							<span class="d-sep">↓</span>
							<span class="d-board"><i></i><i></i><i></i></span>
							<span class="d-warn">⚠</span>
						</span>
						<span>Mistakes drop <strong>extra</strong> blocks. When the board pulses, space is short — overflow the top and it is over. Points climb you from A1 past C2 into the Meister words, and the best hundred games go on the <strong>Bestenliste</strong>.</span>
					</li>
				</ul>
				<button type="button" class="btn rules-go" onclick={closeRules}>
					{rulesSeen ? 'Weiter' : 'Los geht’s'} <Icon name="arrowRight" size="1em" />
				</button>
			</div>
		</div>
	{/if}

	{#if showBoard}
		<!-- The arcade table: a hundred places, five letters each. -->
		<div class="board-sheet" role="dialog" aria-label="Bestenliste">
			<div class="sheet-card">
				<header class="sheet-head">
					<h2><span class="cup" aria-hidden="true"><Icon name="trophy" size="0.95em" /></span> Bestenliste</h2>
					<button type="button" class="sheet-x" onclick={() => (showBoard = false)} aria-label="Close">
						<Icon name="close" size="1em" />
					</button>
				</header>
				{#if worldBoardAvailable()}
					<div class="seg" role="tablist">
						<button type="button" role="tab" class="tab" class:on={boardTab === 'local'} aria-selected={boardTab === 'local'} onclick={() => (boardTab = 'local')}>This device</button>
						<button type="button" role="tab" class="tab" class:on={boardTab === 'world'} aria-selected={boardTab === 'world'} onclick={() => (boardTab = 'world')}>World</button>
					</div>
				{/if}
				{#if boardTab === 'world' && worldBoardAvailable()}
					{#if worldState === 'loading' || worldState === 'idle'}
						<div class="empty"><p>Fetching the world's best…</p></div>
					{:else if worldState === 'error'}
						<div class="empty"><p>The world board is out of reach right now — try again online.</p></div>
					{:else if world.length}
						<ol class="scorelist">
							{#each world as s, i (s.at + '-' + i)}
								<li class:me={s.at === enteredAt}>
									<span class="rk tnum">{i + 1}</span>
									<span class="nm">{s.name}</span>
									<span class="lv-s tnum">{s.level}</span>
									<span class="sc tnum">{s.pts}</span>
								</li>
							{/each}
						</ol>
						<p class="sheet-foot">The best {world.length} games anywhere. Make the table and your five letters join them.</p>
					{:else}
						<div class="empty">
							<span class="podium" aria-hidden="true"><i class="p2"></i><i class="p1"></i><i class="p3"></i></span>
							<p>Nobody yet. The world's first champion could have your five letters.</p>
						</div>
					{/if}
				{:else if scores.length}
					<ol class="scorelist">
						{#each scores as s, i (s.at)}
							<li class:me={s.at === enteredAt}>
								<span class="rk tnum">{i + 1}</span>
								<span class="nm">{s.name}</span>
								<span class="lv-s tnum">{s.level}</span>
								<span class="sc tnum">{s.pts}</span>
							</li>
						{/each}
					</ol>
					<p class="sheet-foot">{scores.length} of {SCORE_CAP} places taken — on this device.</p>
				{:else}
					<div class="empty">
						<span class="podium" aria-hidden="true"><i class="p2"></i><i class="p1"></i><i class="p3"></i></span>
						<p>No scores yet — the first game writes history.</p>
					</div>
				{/if}
			</div>
		</div>
	{/if}

	{#if phase === 'intro'}
		<div class="intro">
			<section class="intro-card">
				<div class="intro-art" aria-hidden="true">
					<span class="irow"><span class="isq" style="background: {WORT_PALETTE[0]}">H</span><span class="isq" style="background: {WORT_PALETTE[0]}">a</span><span class="isq" style="background: {WORT_PALETTE[0]}">u</span><span class="isq" style="background: {WORT_PALETTE[0]}">s</span><span class="isq" style="background: {WORT_PALETTE[2]}">r</span><span class="isq" style="background: {WORT_PALETTE[2]}">o</span><span class="isq" style="background: {WORT_PALETTE[2]}">t</span></span>
					<span class="irow"><span class="isq" style="background: {WORT_PALETTE[1]}">Z</span><span class="isq" style="background: {WORT_PALETTE[1]}">e</span><span class="isq" style="background: {WORT_PALETTE[1]}">i</span><span class="isq" style="background: {WORT_PALETTE[1]}">t</span><span class="isq gold">g</span><span class="isq gold">u</span><span class="isq gold">t</span></span>
				</div>
				<p class="eyebrow" lang="de">Wortblöcke · ein Wort-Puzzle</p>
				<h1>Stack the words.<br />Know the words.</h1>
				<p class="lead">
					Pair the German blocks with their English, name the articles, and build
					<strong>one-color rows</strong> into golden jackpot runs — before the board fills up.
				</p>
				<button type="button" class="btn" onclick={start}>Los geht’s <Icon name="arrowRight" size="1em" /></button>
				<p class="meta">
					Points climb you from A1 towards C2 — and beyond, where the words get weird.
					<br /><button type="button" class="linkish" onclick={() => (showRules = true)}>How to play</button>
					· <button type="button" class="linkish" onclick={openBoard}>Bestenliste</button>
				</p>
				{#if scores.length}
					<!-- The attract screen: the cabinet shows off its champions. -->
					<ol class="minilist attract" aria-label="Best scores">
						{#each scores.slice(0, 5) as s, i (s.at)}
							<li>
								<span class="rk tnum">{i + 1}</span>
								<span class="nm">{s.name}</span>
								<span class="lv-s tnum">{s.level}</span>
								<span class="sc tnum">{s.pts}</span>
							</li>
						{/each}
					</ol>
				{/if}
			</section>
		</div>
	{/if}
</main>

<style>
	.wort {
		display: flex;
		flex-direction: column;
		height: 100dvh;
		max-width: 480px;
		margin: 0 auto;
		padding: 0.5rem 1rem 0.6rem;
		position: relative;
		overflow: hidden;
	}

	/* -- top bar ------------------------------------------------------------- */
	.top {
		display: flex;
		flex: none;
		flex-direction: column;
		gap: 0.3rem;
		min-width: 0;
		margin-bottom: 0.45rem;
		padding: 0.35rem 0.6rem 0.45rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.row {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		min-width: 0;
	}

	.row .grow {
		flex: 1;
	}

	/* The queue's dock: an inset slot across the header's bottom, so the
	   next word visibly WAITS somewhere instead of floating in air. */
	.row.sub {
		gap: 0.5rem;
		min-height: 17px;
		padding: 0.3rem 0.55rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		box-shadow: inset 0 1px 2px rgb(42 42 40 / 0.07);
	}

	.nextlabel {
		color: var(--ink-muted);
		font-size: 0.6rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
	}

	.row.sub .dotq:first-of-type {
		margin-left: 2px;
	}

	.back {
		display: inline-flex;
		gap: 0.25rem;
		align-items: center;
		color: var(--ink-muted);
		font-size: var(--step--1);
		text-decoration: none;
		white-space: nowrap;
	}

	.brand {
		display: inline-flex;
		gap: 0.4rem;
		align-items: center;
		white-space: nowrap;
	}

	.brand .t {
		font-family: var(--font-display, serif);
		font-size: 1rem;
		font-weight: 700;
		color: var(--heading);
	}

	.lvl {
		padding: 0.12rem 0.45rem;
		border-radius: 999px;
		background: var(--heading);
		color: #fff;
		font-weight: 800;
		font-size: 0.68rem;
	}

	.combo {
		font-weight: 800;
		font-size: 0.85rem;
		color: var(--accent-ink);
	}

	/* A change worth noticing pops in: the level pill, the combo. */
	.pop {
		animation: pop-in 0.35s var(--ease-spring, ease);
	}

	@keyframes pop-in {
		0% {
			transform: scale(0.6);
		}
		60% {
			transform: scale(1.18);
		}
		100% {
			transform: scale(1);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.pop {
			animation: none;
		}
	}

	.next {
		display: flex;
		gap: 5px;
		align-items: center;
		min-width: 0;
	}

	.minigroup {
		display: inline-flex;
		gap: 1px;
		align-items: center;
	}

	.mini {
		display: grid;
		place-items: center;
		width: 15px;
		height: 17px;
		border-radius: 3px;
		color: #fff;
		font-size: 9px;
		font-weight: 700;
		box-shadow: inset 0 -2px 0 rgb(0 0 0 / 0.18);
	}

	.dotq {
		width: 9px;
		height: 9px;
		border-radius: 3px;
	}

	.score {
		font-size: 0.95rem;
		color: var(--heading);
		white-space: nowrap;
	}

	.score small {
		font-size: 0.62rem;
		font-weight: 700;
		letter-spacing: 0.05em;
		color: var(--ink-muted);
		text-transform: uppercase;
	}

	.say {
		display: inline-flex;
		padding: 0.15rem;
		border: none;
		background: none;
		color: var(--heading);
		cursor: pointer;
	}

	.say[aria-pressed='false'] {
		opacity: 0.35;
	}

	/* On a narrow phone the labels yield before the information does: the
	   Next queue always stays on screen. */
	@media (max-width: 460px) {
		.back .bt,
		.brand .t,
		.score .st {
			display: none;
		}

		.row {
			gap: 0.45rem;
		}
	}

	/* -- the well -------------------------------------------------------------- */
	.zone {
		position: relative;
		display: grid;
		flex: 1;
		place-items: center;
		min-height: 0;
	}

	.board {
		position: relative;
		display: grid;
		place-items: center;
		overflow: hidden;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 18px 40px -24px rgba(31, 58, 95, 0.45);
	}

	.grid {
		position: relative;
		background:
			repeating-linear-gradient(to right, transparent 0, transparent calc(var(--cs) - 1px), var(--surface-alt) calc(var(--cs) - 1px), var(--surface-alt) var(--cs)),
			repeating-linear-gradient(to bottom, transparent 0, transparent calc(var(--cs) - 1px), var(--surface-alt) calc(var(--cs) - 1px), var(--surface-alt) var(--cs)),
			var(--surface);
	}

	.board.danger {
		outline: 3px solid var(--accent);
		animation: danger-pulse 0.9s ease-in-out infinite;
	}

	@keyframes danger-pulse {
		0%,
		100% {
			outline-color: var(--accent);
		}
		50% {
			outline-color: rgb(201 104 59 / 0.25);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.board.danger {
			animation: none;
		}
	}

	/* -- blocks ------------------------------------------------------------------ */
	.block {
		position: absolute;
		z-index: 1;
		display: flex;
		padding: 0;
		border: none;
		background: none;
		font: inherit;
		cursor: pointer;
		transition:
			top 0.3s cubic-bezier(0.3, 0.9, 0.4, 1.15),
			left 0.3s var(--ease-out, ease),
			opacity 0.3s,
			filter 0.2s;
	}

	.block.v {
		flex-direction: column;
	}

	.block:active {
		transform: scale(0.96);
	}

	.block .sq {
		display: grid;
		place-items: center;
		width: var(--cs);
		height: var(--cs);
		background: var(--c);
		color: #fff;
		font-weight: 700;
		font-size: calc(var(--cs) * 0.46);
		box-shadow:
			inset 0 calc(var(--cs) * -0.09) 0 rgb(0 0 0 / 0.18),
			inset 0 0 0 1px rgb(255 255 255 / 0.12);
	}

	.block .sq:first-child {
		border-radius: 5px 0 0 5px;
	}

	.block .sq:last-child {
		border-radius: 0 5px 5px 0;
	}

	.block.v .sq:first-child {
		border-radius: 5px 5px 0 0;
	}

	.block.v .sq:last-child {
		border-radius: 0 0 5px 5px;
	}

	.block .sq:only-child {
		border-radius: 5px;
	}

	/* The article badge sits INSIDE the block's corner: a block is its own
	   stacking context, so anything poking outside gets painted over by a
	   neighboring block — inside its own bounds it is always on top. */
	.badge {
		position: absolute;
		top: 2px;
		right: 2px;
		z-index: 2;
		display: grid;
		place-items: center;
		min-width: 13px;
		height: 13px;
		border-radius: 999px;
		background: #fff;
		color: var(--c);
		font-size: 9px;
		font-weight: 800;
		box-shadow: 0 1px 3px rgb(0 0 0 / 0.3);
	}

	/* A missed article is worn from then on: the answer, read again and
	   again — and the word only pays silver, since it has been shown. */
	.badge.learned {
		padding: 0 3px;
		background: var(--heading);
		color: #fff;
		font-size: 8px;
	}

	.block.gilded .sq {
		box-shadow:
			inset 0 calc(var(--cs) * -0.09) 0 rgb(0 0 0 / 0.18),
			inset 0 0 0 2px var(--ochre, #a9802a);
	}

	/* The golden shimmer is an opacity pulse on an overlay glow: opacity is
	   composited on the GPU, while the old animated brightness/drop-shadow
	   filter forced a repaint of every gilded block on every frame. */
	.block.gilded::after {
		content: '';
		position: absolute;
		inset: -2px;
		border-radius: 7px;
		box-shadow: 0 0 9px 3px rgb(169 128 42 / 0.55);
		animation: gild-glow 1.6s ease-in-out infinite;
		pointer-events: none;
	}

	@keyframes gild-glow {
		0%,
		100% {
			opacity: 0.25;
		}
		50% {
			opacity: 1;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.block.gilded::after {
			animation: none;
			opacity: 0.7;
		}
	}

	.board.golden .block:not(.runset):not(.done) {
		opacity: 0.32;
		filter: saturate(0.35);
	}

	.block.done {
		animation: done-pop 0.35s var(--ease-spring, ease);
	}

	.block.done .sq {
		background: var(--ochre, #a9802a);
	}

	@keyframes done-pop {
		50% {
			transform: scale(1.1);
		}
	}

	/* While grabbed, the article badge yields to the handles. */
	.block.grabbed .badge {
		opacity: 0;
	}

	/* The grabbed block stays EXACTLY on its grid cells — any lift or scale
	   here would shear it against its own handles, which are positioned
	   from the untransformed grid. The outline and handles mark it plenty. */
	.block.grabbed {
		z-index: 3;
		outline: 3px solid var(--accent);
		outline-offset: 1px;
		border-radius: 6px;
	}

	.block.featured {
		z-index: 3;
		outline: 3px solid var(--ochre, #a9802a);
		outline-offset: 1px;
		border-radius: 6px;
	}

	.block.clearing {
		animation: clear-pop 0.4s ease forwards;
	}

	@keyframes clear-pop {
		30% {
			transform: scale(1.1);
			filter: brightness(1.4);
		}
		100% {
			transform: scale(0.15);
			opacity: 0;
		}
	}

	.block.fizzle {
		animation: fizzle 0.55s ease forwards;
	}

	@keyframes fizzle {
		to {
			opacity: 0;
			transform: scale(0.82);
			filter: grayscale(1) brightness(0.85);
		}
	}

	.block.shake {
		animation: shake-x 0.35s ease;
	}

	@keyframes shake-x {
		25% {
			transform: translateX(-5px);
		}
		50% {
			transform: translateX(4px);
		}
		75% {
			transform: translateX(-2px);
		}
	}

	/* -- overlays ------------------------------------------------------------------ */
	.linefx {
		position: absolute;
		right: 0;
		left: 0;
		z-index: 5;
		background: linear-gradient(90deg, transparent, rgb(169 128 42 / 0.6), rgb(224 164 88 / 0.7), rgb(169 128 42 / 0.6), transparent);
		animation: line-flash 0.85s ease forwards;
		pointer-events: none;
	}

	.linefx.mixed {
		background: linear-gradient(90deg, transparent, rgb(110 100 88 / 0.35), rgb(110 100 88 / 0.45), rgb(110 100 88 / 0.35), transparent);
	}

	@keyframes line-flash {
		from {
			opacity: 0;
			transform: scaleX(0.15);
		}
		30% {
			opacity: 1;
			transform: scaleX(1);
		}
		to {
			opacity: 0;
		}
	}

	.float {
		position: absolute;
		z-index: 6;
		font-family: var(--font-display, serif);
		font-weight: 700;
		font-size: calc(var(--cs) * 0.5);
		color: var(--heading);
		white-space: nowrap;
		pointer-events: none;
		animation: floatup 1.2s ease forwards;
	}

	/* The teaching floats sit on a solid pill: colored serif over colored
	   blocks was unreadable exactly when it mattered. They also linger. */
	.float.big {
		padding: 0.14em 0.5em;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		box-shadow: 0 6px 16px -8px rgb(42 42 40 / 0.4);
		font-size: calc(var(--cs) * 0.52);
		animation: floatup 2.5s ease forwards;
	}

	.float.gold {
		color: var(--ochre-ink, #836215);
	}

	.float.muted {
		color: var(--ink-muted);
	}

	.float.accent {
		color: var(--accent-ink);
	}

	.float.der {
		color: var(--navy, #1f3a5f);
	}

	.float.die {
		color: var(--accent-ink);
	}

	.float.das {
		color: var(--forest, #3f5d45);
	}

	@keyframes floatup {
		from {
			opacity: 0;
			transform: translateY(5px) scale(0.8);
		}
		20% {
			opacity: 1;
			transform: translateY(0) scale(1.05);
		}
		to {
			opacity: 0;
			transform: translateY(-30px);
		}
	}

	/* The gold message in the tray's label line: always visible, never over
	   the board. */
	.tray-label.gold {
		overflow: hidden;
		color: var(--ochre-ink, #836215);
		font-size: 0.72rem;
		letter-spacing: 0;
		text-overflow: ellipsis;
		text-transform: none;
		white-space: nowrap;
	}

	/* The grabbed word's handles, one piece with the block: end caps and a
	   rotate tab in a darker shade of the word's own color, sharing the
	   letters' bevel so block and handles read as one object. */
	.bctl {
		position: absolute;
		z-index: 4;
		display: grid;
		place-items: center;
		padding: 0;
		border: none;
		background: color-mix(in srgb, var(--bc) 68%, #16160f);
		color: #fff;
		font: inherit;
		box-shadow:
			inset 0 calc(var(--cs) * -0.09) 0 rgb(0 0 0 / 0.2),
			inset 0 0 0 1px rgb(255 255 255 / 0.14);
		cursor: pointer;
		transition:
			left 0.3s var(--ease-out, ease),
			top 0.3s var(--ease-out, ease),
			transform 0.1s ease;
	}

	.bctl.lcap {
		border-radius: 6px 0 0 6px;
		animation: cap-left 0.18s var(--ease-out, ease);
	}

	.bctl.rcap {
		border-radius: 0 6px 6px 0;
		animation: cap-right 0.18s var(--ease-out, ease);
	}

	.bctl.rot {
		border-radius: 6px 6px 0 0;
		box-shadow: inset 0 0 0 1px rgb(255 255 255 / 0.14);
		animation: cap-up 0.18s var(--ease-out, ease);
	}

	.bctl.rot.under {
		border-radius: 0 0 6px 6px;
		animation: cap-down 0.18s var(--ease-out, ease);
	}

	/* Each handle arrives FROM the direction it pushes the word. */
	@keyframes cap-left {
		from {
			opacity: 0;
			transform: translateX(8px);
		}
	}

	@keyframes cap-right {
		from {
			opacity: 0;
			transform: translateX(-8px);
		}
	}

	@keyframes cap-up {
		from {
			opacity: 0;
			transform: translateY(8px);
		}
	}

	@keyframes cap-down {
		from {
			opacity: 0;
			transform: translateY(-8px);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.bctl.lcap,
		.bctl.rcap,
		.bctl.rot,
		.bctl.rot.under {
			animation: none;
		}
	}

	.bctl:active:not(:disabled) {
		transform: scale(0.92);
	}

	.bctl:disabled {
		opacity: 0.4;
		cursor: default;
	}

	/* The count lives INSIDE the cap's corner: a handle is its own stacking
	   context, so anything poking outside gets painted over by neighbors. */
	.bctl .uses {
		position: absolute;
		top: 1px;
		right: 1px;
		display: grid;
		place-items: center;
		min-width: 0.8rem;
		height: 0.8rem;
		padding: 0 0.12rem;
		border-radius: 999px;
		background: var(--ochre, #a9802a);
		color: #fff;
		font-size: 0.52rem;
		font-weight: 800;
		box-shadow: 0 1px 2px rgb(0 0 0 / 0.3);
	}

	.art-ask {
		position: absolute;
		right: 0;
		bottom: 0;
		left: 0;
		z-index: 10;
		display: flex;
		gap: 0.5rem;
		align-items: center;
		padding: 0.55rem 0.7rem;
		border-top: 1.5px solid var(--ochre, #a9802a);
		background: rgb(255 255 255 / 0.96);
		box-shadow: 0 -8px 20px rgb(31 58 95 / 0.12);
		animation: ask-up 0.18s ease;
	}

	@keyframes ask-up {
		from {
			transform: translateY(100%);
		}
		to {
			transform: none;
		}
	}

	.art-ask p {
		margin: 0;
		font-family: var(--font-display, serif);
		font-size: 1.05rem;
		color: var(--heading);
		white-space: nowrap;
	}

	.art-ask b {
		color: var(--accent-ink);
	}

	.arts {
		display: flex;
		flex: 1;
		gap: 0.45rem;
	}

	.art-btn {
		flex: 1;
		padding: 0.6rem 0;
		border: none;
		border-radius: var(--radius-sm);
		color: #fff;
		font: inherit;
		font-weight: 800;
		font-size: 1rem;
		box-shadow: inset 0 -3px 0 rgb(0 0 0 / 0.2);
		cursor: pointer;
	}

	.art-btn:active {
		transform: scale(0.95);
	}

	.art-x {
		flex: none;
		display: grid;
		place-items: center;
		width: 1.9rem;
		height: 1.9rem;
		border: 1px solid var(--line);
		border-radius: 50%;
		background: var(--surface);
		color: var(--ink-muted);
		cursor: pointer;
	}

	.art-btn.der {
		background: var(--navy, #1f3a5f);
	}

	.art-btn.die {
		background: var(--accent);
	}

	.art-btn.das {
		background: var(--forest, #3f5d45);
	}

	.gameover {
		position: absolute;
		inset: 0;
		z-index: 30;
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
		align-items: center;
		justify-content: center;
		background: rgb(255 255 255 / 0.95);
	}

	.over-card {
		display: flex;
		flex-direction: column;
		gap: 0.7rem;
		align-items: center;
		max-width: 18rem;
		padding: 1.3rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: calc(var(--radius) + 6px);
		background: var(--surface);
		box-shadow: 0 18px 40px -24px rgba(31, 58, 95, 0.45);
	}

	.over-card strong {
		font-family: var(--font-display, serif);
		font-size: 1.4rem;
		color: var(--heading);
		text-align: center;
	}

	.over-stats {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.45rem;
		width: 100%;
		margin: 0;
	}

	.over-stats div {
		padding: 0.4rem 0.2rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		text-align: center;
	}

	.over-stats dt {
		color: var(--ink-muted);
		font-size: 0.62rem;
		font-weight: 700;
		letter-spacing: 0.05em;
		text-transform: uppercase;
	}

	.over-stats dd {
		margin: 0;
		color: var(--heading);
		font-weight: 800;
	}

	.bestline {
		margin: 0;
		color: var(--ochre-ink, #836215);
		font-size: var(--step--1);
		font-weight: 700;
	}

	/* -- the arcade table ------------------------------------------------------ */
	.entry {
		display: flex;
		flex-direction: column;
		gap: 0.8rem;
		align-items: center;
	}

	/* One ordinary input drawn as five letter cells: the cells are painted
	   into the background on a fixed pitch, and a monospace face with
	   letter-spacing drops exactly one glyph in each. Typing, caret and
	   selection are the browser's own — nothing to break on a phone. */
	.slotline {
		--pitch: 2.6rem; /* one cell incl. its gap */
		--gap: 0.25rem;
		--pad: calc((var(--pitch) - var(--gap) - 1ch) / 2); /* centers a glyph in its cell */
		/* Each glyph occupies 1ch + its trailing letter-spacing = one full
		   pitch, so five letters need pad + 5 pitches — a hair less and the
		   input scrolls, hiding the fifth letter. */
		width: calc(var(--pad) + var(--pitch) * 5);
		padding: 0.55rem 0 0.55rem var(--pad);
		border: none;
		outline: none;
		background:
			repeating-linear-gradient(
					to right,
					var(--surface-alt) 0,
					var(--surface-alt) calc(var(--pitch) - var(--gap)),
					transparent calc(var(--pitch) - var(--gap)),
					transparent var(--pitch)
				)
				left / calc(var(--pitch) * 5 - var(--gap)) 100% no-repeat;
		border-radius: 7px;
		box-shadow: inset 0 -3px 0 rgb(42 42 40 / 0.09);
		color: var(--heading);
		font-family: ui-monospace, 'Cascadia Mono', Consolas, Menlo, monospace;
		font-size: 1.35rem;
		font-weight: 800;
		letter-spacing: calc(var(--pitch) - 1ch);
		text-transform: uppercase;
		caret-color: var(--accent);
	}

	.slotline:focus {
		box-shadow:
			inset 0 -3px 0 rgb(42 42 40 / 0.09),
			0 0 0 2px var(--accent-soft),
			0 0 10px rgb(169 128 42 / 0.3);
	}

	.minilist,
	.scorelist {
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
		width: 100%;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.minilist li,
	.scorelist li {
		display: flex;
		gap: 0.6rem;
		align-items: baseline;
		padding: 0.22rem 0.5rem;
		border-radius: 6px;
		font-size: 0.85rem;
	}

	.minilist li.me,
	.scorelist li.me {
		background: var(--accent-soft);
		font-weight: 800;
	}

	.minilist .gap-row {
		border-top: 1px dashed var(--line);
	}

	.rk {
		width: 2.2ch;
		color: var(--ink-muted);
		font-weight: 700;
		text-align: right;
	}

	.nm {
		flex: 1;
		font-weight: 800;
		letter-spacing: 0.18em;
		color: var(--heading);
	}

	.lv-s {
		color: var(--ink-muted);
		font-size: 0.72rem;
	}

	.sc {
		font-weight: 800;
		color: var(--heading);
	}

	.over-actions {
		display: flex;
		gap: 0.6rem;
		align-items: center;
	}

	.btn-ghost,
	.linkish {
		padding: 0.3rem 0.5rem;
		border: none;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		text-decoration: underline;
		text-underline-offset: 3px;
		cursor: pointer;
	}

	.board-sheet {
		position: absolute;
		inset: 0;
		z-index: 60;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: rgb(42 42 40 / 0.35);
	}

	.sheet-card {
		display: flex;
		flex-direction: column;
		width: min(22rem, 100%);
		/* Viewport-based, not 100%: a centered grid item's percentage resolves
		   against its auto row (= content height), so 100% never constrained
		   the card and on phones the rules could not scroll. */
		max-height: calc(100dvh - 2rem);
		min-height: 0;
		padding: 1rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 18px 40px -24px rgba(31, 58, 95, 0.45);
	}

	.sheet-head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 0.5rem;
	}

	.sheet-head h2 {
		margin: 0;
		font-family: var(--font-display, serif);
		font-size: 1.2rem;
		color: var(--heading);
	}

	.scorelist {
		overflow-y: auto;
	}

	/* Device/World as one segmented control: a track with a raised thumb. */
	.seg {
		display: flex;
		flex: none;
		gap: 3px;
		margin-bottom: 0.6rem;
		padding: 3px;
		border-radius: 999px;
		background: var(--surface-alt);
	}

	.tab {
		flex: 1;
		padding: 0.4rem 0.5rem;
		border: none;
		border-radius: 999px;
		background: transparent;
		color: var(--ink-muted);
		font: inherit;
		font-weight: 700;
		font-size: 0.8rem;
		cursor: pointer;
		transition: all 0.15s ease;
	}

	.tab.on {
		background: var(--surface);
		color: var(--heading);
		box-shadow: 0 1px 3px rgb(42 42 40 / 0.14);
	}

	.sheet-head .cup {
		display: inline-grid;
		place-items: center;
		width: 1.6rem;
		height: 1.6rem;
		margin-right: 0.15rem;
		border-radius: 50%;
		background: rgb(169 128 42 / 0.15);
		color: var(--ochre-ink, #836215);
		vertical-align: -0.35rem;
	}

	.sheet-x {
		display: grid;
		place-items: center;
		width: 1.9rem;
		height: 1.9rem;
		padding: 0;
		border: 1px solid var(--line);
		border-radius: 50%;
		background: var(--surface);
		color: var(--ink-muted);
		cursor: pointer;
	}

	/* An empty board still looks like a stage: the podium waits. */
	.empty {
		display: flex;
		flex-direction: column;
		gap: 0.7rem;
		align-items: center;
		padding: 1.3rem 0.5rem 0.9rem;
		text-align: center;
	}

	.empty p {
		margin: 0;
		color: var(--ink-muted);
		font-size: 0.82rem;
		max-width: 16rem;
	}

	.podium {
		display: inline-flex;
		gap: 3px;
		align-items: flex-end;
	}

	.podium i {
		width: 1.3rem;
		border-radius: 3px 3px 0 0;
		box-shadow: inset 0 -3px 0 rgb(0 0 0 / 0.15);
	}

	.podium .p1 {
		height: 2.2rem;
		background: var(--ochre, #a9802a);
	}

	.podium .p2 {
		height: 1.5rem;
		background: var(--paper-highest, #e0e0e0);
	}

	.podium .p3 {
		height: 1.1rem;
		background: var(--accent);
	}

	.sheet-foot {
		margin: 0.6rem 0 0;
		color: var(--ink-muted);
		font-size: 0.74rem;
	}

	/* -- how to play: every rule opens with a little picture of itself ------- */
	.rules {
		display: flex;
		flex: 1;
		flex-direction: column;
		gap: 0.8rem;
		margin: 0;
		min-height: 0;
		padding: 0 2px 0 0;
		overflow-y: auto;
		touch-action: pan-y;
		-webkit-overflow-scrolling: touch;
		overscroll-behavior: contain;
		list-style: none;
		font-size: 0.8rem;
		line-height: 1.45;
	}

	.rules li {
		display: flex;
		flex-direction: column;
		gap: 0.3rem;
		padding-bottom: 0.7rem;
		border-bottom: 1px solid var(--line);
	}

	.rules li:last-child {
		border-bottom: none;
		padding-bottom: 0;
	}

	.rules strong {
		color: var(--heading);
	}

	.demo {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		align-items: center;
		color: var(--ink-muted);
	}

	.d-sep {
		font-size: 0.78rem;
		font-weight: 700;
		color: var(--ink-muted);
	}

	.d-gap {
		width: 0.5rem;
	}

	.d-chip.tilt {
		transform: rotate(-5deg);
		border-color: var(--heading);
		box-shadow: 0 3px 6px -2px rgb(31 58 95 / 0.35);
	}

	.d-block.dim {
		opacity: 0.75;
		outline: 2px dashed var(--accent);
		outline-offset: 1px;
		border-radius: 4px;
	}

	.d-block.sm i {
		width: 0.95rem;
		height: 1.05rem;
		font-size: 0.62rem;
	}

	.d-block.badged {
		position: relative;
	}

	.d-block.badged b {
		position: absolute;
		top: -6px;
		right: -8px;
		padding: 0 3px;
		border-radius: 999px;
		background: var(--heading);
		color: #fff;
		font-size: 0.5rem;
		font-weight: 800;
	}

	/* The golden-line diagram: a mini board, the line plus its connected
	   color lit, the odd color out left plain. */
	.d-grid {
		display: grid;
		grid-template-columns: repeat(4, 0.8rem);
		gap: 1px;
		padding: 2px;
		border: 1px solid var(--line);
		border-radius: 4px;
		background: var(--surface);
	}

	.d-grid i {
		height: 0.8rem;
		border-radius: 2px;
		background: var(--surface-alt);
	}

	.d-grid i.au {
		background: var(--ochre, #a9802a);
		box-shadow: inset 0 0 0 1px #f3e3bd;
	}

	.d-grid i.nv {
		background: var(--navy, #1f3a5f);
	}

	.d-block {
		display: inline-flex;
		gap: 1px;
	}

	.d-block i {
		display: grid;
		place-items: center;
		width: 1.1rem;
		height: 1.2rem;
		background: var(--navy, #1f3a5f);
		color: #fff;
		font-style: normal;
		font-weight: 700;
		font-size: 0.7rem;
		box-shadow: inset 0 -2px 0 rgb(0 0 0 / 0.18);
	}

	.d-block i:first-child {
		border-radius: 4px 0 0 4px;
	}

	.d-block i:last-child {
		border-radius: 0 4px 4px 0;
	}

	.d-block.gold i {
		background: var(--ochre, #a9802a);
		box-shadow:
			inset 0 -2px 0 rgb(0 0 0 / 0.18),
			inset 0 0 0 1px #f3e3bd;
	}

	.d-chip {
		padding: 0.15rem 0.5rem;
		border: 1px solid var(--line);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font-weight: 650;
		font-size: 0.72rem;
		box-shadow: 0 1.5px 0 rgb(42 42 40 / 0.08);
	}

	.d-art {
		padding: 0.18rem 0.5rem;
		border-radius: 6px;
		color: #fff;
		font-weight: 800;
		font-size: 0.7rem;
		opacity: 0.55;
		box-shadow: inset 0 -2px 0 rgb(0 0 0 / 0.2);
	}

	.d-art.der {
		background: var(--navy, #1f3a5f);
	}

	.d-art.die {
		background: var(--accent);
	}

	.d-art.das {
		background: var(--forest, #3f5d45);
	}

	.d-art.on {
		opacity: 1;
		outline: 2px solid var(--ochre, #a9802a);
		outline-offset: 1px;
	}

	.d-cap {
		display: grid;
		place-items: center;
		width: 1rem;
		height: 1.2rem;
		background: color-mix(in srgb, var(--navy, #1f3a5f) 68%, #16160f);
		color: #fff;
		box-shadow: inset 0 -2px 0 rgb(0 0 0 / 0.2);
	}

	.d-cap.l {
		border-radius: 4px 0 0 4px;
	}

	.d-cap.r {
		border-radius: 0 4px 4px 0;
	}

	.d-cap.t {
		margin-left: 0.4rem;
		width: 1.4rem;
		border-radius: 4px 4px 0 0;
		background: var(--accent);
	}

	.d-star {
		display: grid;
		place-items: center;
		width: 1.5rem;
		height: 1.4rem;
		border: 1px solid var(--ochre, #a9802a);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ochre-ink, #836215);
		font-size: 0.9rem;
	}

	.d-spark {
		font-size: 0.85rem;
	}

	.d-board {
		display: inline-flex;
		gap: 2px;
		align-items: flex-end;
		height: 1.4rem;
		padding: 2px 3px;
		border: 1.5px solid var(--accent);
		border-radius: 4px;
	}

	.d-board i {
		width: 0.45rem;
		background: var(--surface-alt);
	}

	.d-board i:nth-child(1) {
		height: 100%;
		background: var(--navy, #1f3a5f);
	}

	.d-board i:nth-child(2) {
		height: 70%;
		background: var(--forest, #3f5d45);
	}

	.d-board i:nth-child(3) {
		height: 45%;
		background: var(--ochre, #a9802a);
	}

	.d-warn {
		color: var(--accent-ink);
		font-size: 0.95rem;
	}

	.rules-go {
		margin-top: 0.9rem;
		align-self: center;
	}

	/* -- the tray ------------------------------------------------------------------- */
	.tray-zone {
		flex: none;
		margin-top: 0.45rem;
		padding: 0.45rem 0.7rem 0.55rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.tray-label {
		margin: 0 0 0.25rem;
		color: var(--accent-ink);
		font-size: 0.6rem;
		font-weight: 700;
		letter-spacing: 0.07em;
		text-transform: uppercase;
	}

	/* The lesson after a miss: full size, full contrast — it IS the point. */
	.tray-label.lesson {
		color: var(--heading);
		font-size: 0.85rem;
		letter-spacing: normal;
		text-transform: none;
	}

	/* Every chip is always visible and tappable: no scroll, no clipping.
	   The strip takes the rows it needs — with many words the chips shrink,
	   and the BOARD gives up the height (its cells resize automatically). */
	.tray {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		align-content: flex-start;
		min-height: 2.4rem;
		padding-bottom: 2px; /* room for the tiles' bevel */
	}

	.tray.dense {
		gap: 0.3rem;
	}

	.tray.dense .en {
		min-width: 2.5rem;
		padding: 0.3rem 0.6rem;
		font-size: 0.74rem;
	}

	.tray.packed {
		gap: 0.24rem;
	}

	.tray.packed .en {
		min-width: 2.1rem;
		padding: 0.22rem 0.5rem;
		font-size: 0.67rem;
	}


	/* Answer tiles in the blocks' own language: paper tiles with a soft
	   bottom bevel, evenly sized so "40" and "first name" sit as equals. */
	.en {
		min-width: 3rem;
		padding: 0.42rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 650;
		font-size: 0.82rem;
		text-align: center;
		box-shadow:
			0 2px 0 rgb(42 42 40 / 0.07),
			0 1px 2px rgb(31 58 95 / 0.06);
		cursor: pointer;
		transition:
			background 0.15s ease,
			border-color 0.15s ease,
			color 0.15s ease,
			transform 0.1s ease,
			box-shadow 0.1s ease;
	}

	.en:hover {
		border-color: var(--heading);
	}

	.en.sel {
		border-color: var(--heading);
		background: var(--heading);
		color: #fff;
		transform: translateY(1px);
		box-shadow: 0 1px 0 rgb(42 42 40 / 0.15);
	}

	.en.donechip {
		opacity: 0.35;
		text-decoration: line-through;
		box-shadow: none;
	}

	.en:active {
		transform: translateY(1px) scale(0.97);
		box-shadow: 0 1px 0 rgb(42 42 40 / 0.1);
	}

	/* The hint star: a golden tile at the head of the tray. Armed, it glows;
	   the next block tapped is revealed instead of matched. */
	.en.star {
		position: relative;
		min-width: 2.4rem;
		border-color: var(--ochre, #a9802a);
		color: var(--ochre-ink, #836215);
		font-size: 1rem;
		line-height: 1;
	}

	.en.star.armed {
		background: var(--ochre, #a9802a);
		color: #fff;
		box-shadow: 0 0 0 3px rgb(169 128 42 / 0.25);
	}

	.en.star:disabled {
		opacity: 0.35;
		cursor: default;
	}

	/* Dragging: the chip's home seat empties while its ghost travels. */
	.en {
		touch-action: none;
		user-select: none;
		-webkit-user-select: none;
	}

	.en.lifted {
		opacity: 0.3;
	}

	.dragghost {
		position: fixed;
		z-index: 70;
		padding: 0.42rem 0.8rem;
		border: 1px solid var(--heading);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--heading);
		font-weight: 700;
		font-size: 0.85rem;
		box-shadow: 0 10px 24px -8px rgb(31 58 95 / 0.5);
		transform: translate(-50%, -130%) scale(1.06) rotate(-2deg);
		pointer-events: none;
	}

	/* The block under the ghost says "drop here". */
	.block.droptarget {
		z-index: 3;
		outline: 3px dashed var(--accent);
		outline-offset: 2px;
		border-radius: 8px;
		filter: brightness(1.1);
	}

	/* -- the title card ---------------------------------------------------------------- */
	.intro {
		position: absolute;
		inset: 0;
		z-index: 50;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: var(--bg);
	}

	.intro-card {
		max-width: 23rem;
		padding: 1.5rem 1.5rem 1.3rem;
		border: 1px solid var(--line);
		border-radius: calc(var(--radius) + 6px);
		background: var(--surface);
		box-shadow: 0 18px 40px -24px rgba(31, 58, 95, 0.45);
	}

	.intro-art {
		display: flex;
		flex-direction: column;
		gap: 3px;
		margin-bottom: 0.9rem;
	}

	.irow {
		display: flex;
		gap: 2px;
	}

	.isq {
		display: grid;
		place-items: center;
		width: 1.55rem;
		height: 1.65rem;
		border-radius: 5px;
		color: #fff;
		font-weight: 700;
		font-size: 0.8rem;
		box-shadow: inset 0 -2px 0 rgb(0 0 0 / 0.18);
	}

	.isq.gold {
		background: var(--ochre, #a9802a);
		box-shadow:
			inset 0 -2px 0 rgb(0 0 0 / 0.18),
			0 0 0 1.5px #f3e3bd;
	}

	.intro-card h1 {
		margin: 0 0 0.6rem;
		font-size: var(--step-2);
		line-height: 1.15;
	}

	.lead {
		margin: 0 0 1.1rem;
		font-size: var(--step--1);
		line-height: 1.55;
	}

	.lead strong {
		color: var(--heading);
	}

	.meta {
		margin: 0.9rem 0 0;
		color: var(--ink-muted);
		font-size: 0.78rem;
	}

	.attract {
		margin-top: 0.7rem;
		padding-top: 0.6rem;
		border-top: 1px solid var(--line);
	}
</style>
