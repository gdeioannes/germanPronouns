<script lang="ts">
	// Wortblöcke: the word puzzle in a Tetris well (rules in domain/wortbloecke).
	// Pair German blocks with their English chips, name the article for nouns,
	// fill a one-color row to gild its connected region, then clear the whole
	// golden set in a row for the jackpot. Mistakes drop new blocks; overflow
	// ends the game. Points climb the learner A1.1 → C2.2 → Meister, growing
	// the grid on the way. Nothing here is marked or counted as an exercise.
	import Seo from '$lib/components/Seo.svelte';
	import PageHelp from '$lib/components/PageHelp.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { celebrate, effectsCalm } from '$lib/motion/fx.svelte';
	import { playSound } from '$lib/services/sounds';
	import { tts } from '$lib/services/speech';
	import { track } from '$lib/services/analytics';
	import { breadcrumbLd } from '$lib/seo';
	import {
		canFit,
		cellsOf,
		completeRows,
		goldenRegion,
		levelForPoints,
		pickSpot,
		refillWords,
		rowColors,
		settleBlocks,
		spawnDir,
		stackTop,
		COMBO_WINDOW_MS,
		GOLD_POINTS,
		LANDSLIDE,
		LINE_BONUS,
		LINE_MOVES,
		LINE_ROTATES,
		MATCH_POINTS,
		POT_PER_WORD,
		START_MOVES,
		START_ROTATES,
		WORT_LEVELS,
		WORT_PALETTE,
		type WortBlock,
		type WortWord
	} from '$lib/domain/wortbloecke';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const DECK = $derived(`/course/${data.courseId}`);
	const LOCALE = 'de-DE';
	const BEST_KEY = 'wortbloecke_best';

	// -- the board model ---------------------------------------------------------
	/** A block plus its screen states; $state makes mutations repaint. */
	interface Block extends WortBlock {
		gilded: boolean;
		done: boolean;
		runset: boolean;
		clearing: boolean;
		fizzle: boolean;
		featured: boolean;
		/** The article was missed once: the block now wears it, and only pays silver. */
		learned: boolean;
	}
	interface GoldenSet {
		color: string;
		ids: Set<number>;
		des: Set<string>;
		doneIds: Set<number>;
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
	let danger = $state(false);
	let lineFx = $state<{ id: number; r: number; mixed: boolean }[]>([]);
	let floats = $state<{ id: number; x: number; y: number; text: string; cls: string }[]>([]);

	let selected = $state<string | null>(null);
	let grabbedId = $state<number | null>(null);
	const grabbed = $derived(blocks.find((b) => b.id === grabbedId) ?? null);
	/** The Move/Rotate pad shows only for a free block. */
	const padOpen = $derived(grabbed !== null && !setOf(grabbed as Block));
	let pending = $state<Block | null>(null);
	let pendingRun: GoldenSet | null = null;
	/** English chips in the tray, in their own stable shuffled order. */
	let chips = $state<string[]>([]);
	let sayOn = $state(true);

	// -- sizing: the board fills whatever is left, no page scroll ever ------------
	let zoneW = $state(0);
	let zoneH = $state(0);
	const cs = $derived(
		Math.max(20, Math.min(Math.floor((zoneW - 2) / grid.cols), Math.floor((zoneH - 2) / grid.rows)) || 20)
	);

	const upper = (w: WortWord) => w.de.toUpperCase();
	const spoken = (w: WortWord) => (w.art ? `${w.art} ${w.de}` : w.de);
	const dur = () => (effectsCalm() ? 0 : 1);

	function sayDe(text: string) {
		if (!sayOn) return;
		void tts.speak(text, { locale: LOCALE }).catch(() => {});
	}

	function float(text: string, x: number, y: number, cls = '') {
		const id = nextId++;
		floats = [...floats.slice(-4), { id, x, y, text, cls }];
		setTimeout(() => (floats = floats.filter((f) => f.id !== id)), 1300);
	}
	const floatAt = (b: Block, text: string, cls = '', dy = -0.9) =>
		float(text, Math.min(b.c, Math.max(0, grid.cols - 5)) * cs, (b.r + dy) * cs, cls);

	// -- spawning ------------------------------------------------------------------
	/** A word suits the CURRENT grid: it lies flat, or stands with headroom.
	 *  Longer words wait until the grid has grown with the level. */
	const suitsGrid = (w: WortWord) => w.de.length <= grid.cols || w.de.length <= grid.rows - 4;

	function refillQueue() {
		if (queue.length) return;
		const onBoard = new Set(blocks.map((b) => b.word.de));
		queue = refillWords(data.pools, levelIdx, onBoard)
			.filter(suitsGrid)
			.map((word) => ({
				word,
				color: WORT_PALETTE[Math.floor(Math.random() * WORT_PALETTE.length)]
			}));
		queue.sort(() => Math.random() - 0.5);
	}

	function showNext() {
		refillQueue();
		preview = queue.slice(0, 3).map((q) => ({ de: upper(q.word), color: q.color }));
	}

	function spawn(animate = true) {
		if (phase === 'over') return;
		const onBoard = (w: WortWord) => blocks.some((b) => b.word.de === w.de);
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
			learned: false
		};
		blocks.push(b);
		if (animate) requestAnimationFrame(() => requestAnimationFrame(settle));
		else settle();
		syncChips();
		showNext();
	}

	function settle() {
		const fell = settleBlocks(blocks, grid.rows);
		if (fell) setTimeout(() => playSound('land'), 260);
		checkLines();
		updateDanger();
		return fell;
	}

	// -- lines, sets, runs ------------------------------------------------------------
	function checkLines() {
		if (activeCh || dealing) return;
		const now = completeRows(blocks, grid);
		const fresh = [...now].filter((r) => !fullRows.has(r));
		fullRows = now;
		const byColor = new Map<string, number[]>();
		for (const r of fresh) {
			const colors = rowColors(blocks, r);
			if (colors.size !== 1) {
				lineFlash(r, true);
				continue;
			}
			const color = [...colors][0];
			byColor.set(color, [...(byColor.get(color) ?? []), r]);
		}
		for (const [color, rows] of byColor) gild(rows, color);
	}

	function lineFlash(r: number, mixed: boolean) {
		const id = nextId++;
		lineFx = [...lineFx, { id, r, mixed }];
		setTimeout(() => (lineFx = lineFx.filter((x) => x.id !== id)), 900);
		if (mixed) float('Gemischt! One color makes gold', cs, Math.max(0, r - 1) * cs, 'muted');
	}

	function gild(rows: number[], color: string) {
		let ch = challenges.find((x) => x.color === color && !x.active);
		const merging = Boolean(ch);
		if (!ch) {
			ch = { color, ids: new Set(), des: new Set(), doneIds: new Set(), active: false, pot: 0, lines: 0 };
			challenges.push(ch);
		}
		ch.lines += rows.length;
		for (const r of rows) lineFlash(r, false);
		playSound('msgIn');
		const taken = new Set<number>(
			challenges.filter((x) => x !== ch).flatMap((x) => [...x.ids, ...x.doneIds])
		);
		for (const b of goldenRegion(blocks, rows, color, taken) as Block[]) {
			ch.ids.add(b.id);
			ch.des.add(b.word.de);
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
				? `⭐ ${challenges.length} golden sets (${total} words). Match a word to start ITS set — then finish that whole set.`
				: `⭐ Golden line: ${total} words. Match any of them to start the run — then it is all or nothing.`;
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
			? `⭐ ${b.word.en} ✓ — noch ${ch.ids.size}! Pot: ${ch.pot}`
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
				settle();
				syncChips();
				// A finished line feeds exactly ONE new word — none in danger.
				if (!danger) spawn();
				else showNext();
			},
			doneBlocks.length * 110 * dur() + 380
		);
	}

	function failRun(b: Block, ch: GoldenSet) {
		if (!ch || b.fizzle) return;
		playSound('wrong');
		const name = spoken(b.word);
		sayDe(name);
		floatAt(b, `✗ ${name} = ${b.word.en}`, 'big', -1.1);
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
			announce('Careful: the board is nearly full. While it is, earned words stop refilling — dig yourself out.');
		}
	}

	function gameOver() {
		if (phase === 'over') return;
		phase = 'over';
		danger = false;
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

	function tapBlock(b: Block) {
		if (pending || phase !== 'play') return;
		if (b.clearing || b.fizzle) return;
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
			return;
		}
		if (ch) {
			if (selected !== b.word.de) return failRun(b, ch);
			if (b.word.art && !b.learned) return askArticle(b, ch);
			return markGilded(b, ch);
		}
		if (selected !== b.word.de) {
			playSound('wrong');
			shake(b);
			combo = 1;
			spawn(); // a wrong pair costs board space
			return;
		}
		if (b.word.art && !b.learned) return askArticle(b, null);
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
				spawn(); // a wrong pair costs board space
				return;
			}
			if (gch) {
				if (g.word.art && !g.learned) return askArticle(g, gch);
				return markGilded(g, gch);
			}
			if (g.word.art && !g.learned) return askArticle(g, null);
			return clearBlock(g, MATCH_POINTS, false);
		}
		selected = selected === de ? null : de;
	}

	// -- the article strip ----------------------------------------------------------
	function askArticle(b: Block, ch: GoldenSet | null) {
		pending = b;
		pendingRun = ch;
		b.featured = true;
	}

	function answerArticle(art: string) {
		const b = pending;
		if (!b) return;
		pending = null;
		b.featured = false;
		const ch = pendingRun;
		pendingRun = null;
		const right = art === b.word.art;
		floatAt(b, right ? `✓ ${spoken(b.word)}` : `✗ ${art}? → ${spoken(b.word)}`, 'big ' + artClass(b.word.art!), -1.1);
		if (ch) {
			if (right) return markGilded(b, ch);
			return failRun(b, ch);
		}
		if (right) return clearBlock(b, GOLD_POINTS, true);
		// Wrong article: the word stays, now WEARING its article as the lesson —
		// it will match for silver only, since the answer has been shown. The
		// mistake still drops a new block.
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
		const gained = base * combo;
		gain(gained);
		playSound('right', combo);
		sayDe(spoken(b.word));
		floatAt(b, `${gold ? '★ ' : ''}+${gained}`, gold ? 'gold' : '', -0.6);
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
			const fell = settle();
			if (fell >= LANDSLIDE) earn('move', 'Landslide!');
			syncChips();
			// Only an earned word feeds the well — and while the board is in
			// danger, nothing does: earning words is how you dig yourself out.
			if (!danger) spawn();
			else showNext();
		}, 380 * dur() + 20);
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

	function doRotate() {
		const b = grabbed as Block | null;
		if (!b || rotUses === 0 || b.len === 1 || phase !== 'play') return;
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
		const cand = cands.find((x) => fits(b, x));
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
		let next = chips.filter((de) => want.has(de));
		for (const de of want) {
			if (next.includes(de)) continue;
			const at = Math.floor(Math.random() * (next.length + 1));
			next = [...next.slice(0, at), de, ...next.slice(at)];
		}
		chips = next;
	}
	const chipWord = (de: string) => blocks.find((b) => b.word.de === de)?.word ?? null;
	const chipDone = (de: string) => blocks.some((b) => b.word.de === de && b.done);

	// -- boot ----------------------------------------------------------------------------
	$effect(() => {
		try {
			best = Number(localStorage.getItem(BEST_KEY) ?? 0) || 0;
		} catch {
			best = 0;
		}
	});

	function start() {
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
		golds = 0;
		wordsDone = 0;
		linesWon = 0;
		levelIdx = 0;
		goldBar = null;
		danger = false;
		pending = null;
		pendingRun = null;
		shaken = null;
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
		<a class="back" href={DECK} aria-label="Back to your deck"><Icon name="arrowLeft" size="1em" /> Back</a>
		<span class="brand"><span class="t" lang="de">Wortblöcke</span>{#key levelIdx}<span class="lvl tnum pop">{WORT_LEVELS[levelIdx].name}</span>{/key}</span>
		{#if combo > 1}{#key combo}<span class="combo pop">×{combo}!</span>{/key}{/if}
		<span class="next" aria-hidden="true">
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
		<span class="score"><small>Punkte</small> <b class="tnum">{pts}</b></span>
		<button type="button" class="say" aria-pressed={sayOn} title="Speak the words" onclick={() => (sayOn = !sayOn)}>
			<Icon name={sayOn ? 'volume' : 'volumeOff'} size="1.05em" />
		</button>
		<PageHelp topic="/play/wortbloecke" />
	</header>

	<div class="zone" bind:clientWidth={zoneW} bind:clientHeight={zoneH}>
		<div
			class="board"
			class:danger
			class:golden={runOn}
			style="width: {grid.cols * cs}px; height: {grid.rows * cs}px; --cs: {cs}px"
		>
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
					lang="de"
					aria-label={spoken(b.word)}
					onclick={() => tapBlock(b)}
				>
					{#each b.word.de as ch, i (i)}<span class="sq">{ch}</span>{/each}
					{#if b.word.art}<span class="badge" class:learned={b.learned} aria-hidden="true">{b.learned ? b.word.art : '?'}</span>{/if}
				</button>
			{/each}

			{#each floats as f (f.id)}
				<span class="float {f.cls}" style="left: {f.x}px; top: {f.y}px">{f.text}</span>
			{/each}

			{#if goldBar}
				<p class="goldbar">{goldBar}</p>
			{/if}

			{#if padOpen}
				<div class="pad">
					<button type="button" class="tool" disabled={movUses === 0} onclick={() => doMove(-1)}>◀ Move <span class="uses tnum">{movUses}</span></button>
					<button type="button" class="tool" disabled={movUses === 0} onclick={() => doMove(1)}>Move ▶ <span class="uses tnum">{movUses}</span></button>
					<button type="button" class="tool" disabled={rotUses === 0} onclick={doRotate}>⟳ 90° <span class="uses tnum">{rotUses}</span></button>
					<button type="button" class="tool" onclick={() => (grabbedId = null)} aria-label="Done">✓</button>
				</div>
			{/if}

			{#if pending}
				<div class="art-ask">
					<p lang="de"><b>{pending.word.de}</b>:</p>
					<div class="arts">
						<button type="button" class="art-btn der" onclick={() => answerArticle('der')}>der</button>
						<button type="button" class="art-btn die" onclick={() => answerArticle('die')}>die</button>
						<button type="button" class="art-btn das" onclick={() => answerArticle('das')}>das</button>
					</div>
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
						{#if best > 0}<p class="bestline">{pts >= best ? '★ New best!' : `Best: ${best}`}</p>{/if}
						<button type="button" class="btn" onclick={again}>Nochmal <Icon name="repeat" size="1em" /></button>
					</div>
				</div>
			{/if}
		</div>
	</div>

	<div class="tray-zone">
		<p class="tray-label">Find the German for…</p>
		<div class="tray">
			{#each chips as de (de)}
				{@const w = chipWord(de)}
				{#if w}
					<button
						type="button"
						class="en"
						class:sel={selected === de}
						class:donechip={chipDone(de)}
						disabled={chipDone(de)}
						onclick={() => tapChip(de)}
					>{w.en}</button>
				{/if}
			{/each}
		</div>
	</div>

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
					Pair the German blocks with their English. Fill a row in <strong>one color</strong> and
					everything connected to it turns golden — clear the whole set, articles and all, for the
					jackpot. Mistakes drop new blocks; overflow the board and the game is over.
				</p>
				<button type="button" class="btn" onclick={start}>Los geht’s <Icon name="arrowRight" size="1em" /></button>
				<p class="meta">
					Points climb you from A1 towards C2 — and beyond, where the words get weird.
					{#if best > 0}<br />Your best: <b class="tnum">{best}</b>{/if}
				</p>
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
		align-items: center;
		gap: 0.55rem;
		min-width: 0;
		margin-bottom: 0.45rem;
		padding: 0.35rem 0.6rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
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
		flex: 1;
		gap: 5px;
		align-items: center;
		justify-content: center;
		min-width: 0;
		overflow: hidden;
	}

	.minigroup {
		display: inline-flex;
		gap: 1px;
		align-items: center;
	}

	.mini {
		display: grid;
		place-items: center;
		width: 13px;
		height: 15px;
		border-radius: 3px;
		color: #fff;
		font-size: 8px;
		font-weight: 700;
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
		overflow: hidden;
		border: 1px solid var(--line);
		border-radius: calc(var(--radius) + 6px);
		background:
			repeating-linear-gradient(to right, transparent 0, transparent calc(var(--cs) - 1px), var(--surface-alt) calc(var(--cs) - 1px), var(--surface-alt) var(--cs)),
			repeating-linear-gradient(to bottom, transparent 0, transparent calc(var(--cs) - 1px), var(--surface-alt) calc(var(--cs) - 1px), var(--surface-alt) var(--cs)),
			var(--surface);
		box-shadow: 0 18px 40px -24px rgba(31, 58, 95, 0.45);
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
		border-radius: 8px 0 0 8px;
	}

	.block .sq:last-child {
		border-radius: 0 8px 8px 0;
	}

	.block.v .sq:first-child {
		border-radius: 8px 8px 0 0;
	}

	.block.v .sq:last-child {
		border-radius: 0 0 8px 8px;
	}

	.block .sq:only-child {
		border-radius: 8px;
	}

	.badge {
		position: absolute;
		top: -6px;
		right: -6px;
		z-index: 2;
		display: grid;
		place-items: center;
		min-width: 16px;
		height: 16px;
		border-radius: 999px;
		background: #fff;
		color: var(--c);
		font-size: 10px;
		font-weight: 800;
		box-shadow: 0 1px 3px rgb(0 0 0 / 0.25);
	}

	/* A missed article is worn from then on: the answer, read again and
	   again — and the word only pays silver, since it has been shown. */
	.badge.learned {
		padding: 0 4px;
		background: var(--heading);
		color: #fff;
		font-size: 9px;
	}

	.block.gilded .sq {
		box-shadow:
			inset 0 calc(var(--cs) * -0.09) 0 rgb(0 0 0 / 0.18),
			inset 0 0 0 2px var(--ochre, #a9802a);
	}

	.block.gilded {
		animation: gild-pulse 1.6s ease-in-out infinite;
	}

	@keyframes gild-pulse {
		0%,
		100% {
			filter: brightness(1);
		}
		50% {
			filter: brightness(1.22) drop-shadow(0 0 6px rgb(169 128 42 / 0.55));
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.block.gilded {
			animation: none;
			filter: brightness(1.12);
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

	.block.grabbed,
	.block.featured {
		z-index: 3;
		transform: translateY(-2px) scale(1.04);
		outline: 3px solid var(--accent);
		outline-offset: 2px;
		border-radius: 8px;
	}

	.block.featured {
		outline-color: var(--ochre, #a9802a);
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

	.float.big {
		font-size: calc(var(--cs) * 0.64);
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

	.goldbar {
		position: absolute;
		top: 8px;
		right: 8px;
		left: 8px;
		z-index: 9;
		margin: 0;
		padding: 0.4rem 0.7rem;
		border: 1.5px solid var(--ochre, #a9802a);
		border-radius: var(--radius-sm);
		background: rgb(255 255 255 / 0.95);
		color: var(--ochre-ink, #836215);
		font-weight: 700;
		font-size: 0.76rem;
		line-height: 1.3;
		text-align: center;
		pointer-events: none;
	}

	.pad {
		position: absolute;
		right: 8px;
		bottom: 8px;
		left: 8px;
		z-index: 9;
		display: flex;
		gap: 0.4rem;
		justify-content: center;
	}

	.tool {
		display: inline-flex;
		gap: 0.35rem;
		align-items: center;
		min-height: 2.5rem;
		padding: 0.42rem 0.85rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-weight: 700;
		font-size: 0.84rem;
		box-shadow: 0 4px 12px rgb(31 58 95 / 0.18);
		cursor: pointer;
	}

	.tool:disabled {
		opacity: 0.45;
		cursor: default;
	}

	.tool .uses {
		padding: 0.05rem 0.45rem;
		border-radius: 999px;
		background: var(--surface-alt);
		color: var(--ink-muted);
		font-size: 0.72rem;
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

	.tray {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
		align-content: flex-start;
		height: 5rem;
		overflow-y: auto;
		overscroll-behavior: contain;
		scrollbar-width: thin;
	}

	@media (max-height: 760px) {
		.tray {
			height: 4.4rem;
		}
	}

	.en {
		padding: 0.38rem 0.75rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--bg);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		font-size: 0.82rem;
		cursor: pointer;
		transition: all 0.15s ease;
	}

	.en.sel {
		border-color: var(--heading);
		background: var(--heading);
		color: #fff;
	}

	.en.donechip {
		opacity: 0.35;
		text-decoration: line-through;
	}

	.en:active {
		transform: scale(0.94);
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
</style>
