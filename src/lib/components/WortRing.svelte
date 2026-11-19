<script lang="ts">
	// The marking menu for Wortblöcke (rules in domain/wortRing): opened by a
	// press on a block. Stroke: slide to a meaning (crossing the ring commits
	// it), then on to an article, let go. A release with nothing picked leaves
	// the ring open for plain taps; a tap anywhere else puts it away.
	import { onMount } from 'svelte';
	import { ARTICLE_COLORS } from '$lib/domain/wortbloecke';
	import {
		ART_DIRS,
		ART_R,
		ARTICLES,
		RING_R,
		STAR_ANGLE,
		clampCenter,
		meaningAngles,
		pickSeat,
		polar,
		type Article
	} from '$lib/domain/wortRing';

	interface Option {
		key: string;
		label: string;
	}

	let {
		x,
		y,
		options,
		center = '',
		pressing = true,
		stars = 0,
		onmeaning,
		onstar,
		onarticle,
		ondismiss
	}: {
		/** Where the press landed (client px). */
		x: number;
		y: number;
		/** The meanings, or null to open straight on the article ring. */
		options: Option[] | null;
		/** The label in the middle of the article ring when it opens first. */
		center?: string;
		/** The pointer is still down: a stroke may follow. */
		pressing?: boolean;
		/** Hint stars in hand: with any, a ★ seat sits straight down. */
		stars?: number;
		/** A meaning was chosen. True: a noun, open the article ring here. */
		onmeaning: (key: string) => boolean;
		onarticle: (art: Article) => void;
		/** The ★ seat was chosen: spend a star on this word. */
		onstar?: () => void;
		ondismiss: () => void;
	} = $props();

	// The props seed the ring once; from then on it lives its own gesture.
	/* svelte-ignore state_referenced_locally */
	const start = clampCenter(x, y, window.innerWidth, window.innerHeight);
	/* svelte-ignore state_referenced_locally */
	let stage = $state<'meaning' | 'article'>(options ? 'meaning' : 'article');
	let cx = $state(start[0]);
	let cy = $state(start[1]);
	/* svelte-ignore state_referenced_locally */
	let down = $state(pressing);
	/* svelte-ignore state_referenced_locally */
	let label = $state(center);
	let hot = $state<number | null>(null);
	let moved = false;
	let trail = $state<[number, number][]>([]);

	/* svelte-ignore state_referenced_locally */
	const opts = options ?? [];
	/* svelte-ignore state_referenced_locally */
	const hasStar = stars > 0 && Boolean(onstar);
	const angles = meaningAngles(opts.length, hasStar);
	/** Every seat in the meaning ring; the star, when there is one, is last. */
	const seats = hasStar ? [...angles, STAR_ANGLE] : angles;
	const STAR_SEAT = opts.length;
	const artAngles = ARTICLES.map((a) => ART_DIRS[a]);

	function toArticles(at: [number, number], text: string) {
		const [ax, ay] = clampCenter(at[0], at[1], window.innerWidth, window.innerHeight, ART_R, 40, 24);
		stage = 'article';
		cx = ax;
		cy = ay;
		label = text;
		hot = null;
	}

	function chooseMeaning(i: number) {
		if (i === STAR_SEAT) return onstar?.();
		const o = opts[i];
		const at = polar(cx, cy, angles[i], RING_R);
		if (onmeaning(o.key)) toArticles(at, o.label);
	}

	function move(e: PointerEvent) {
		if (!down) return;
		trail = [...trail.slice(-60), [e.clientX, e.clientY]];
		const dx = e.clientX - cx;
		const dy = e.clientY - cy;
		if (Math.hypot(dx, dy) > 22) moved = true;
		if (stage === 'meaning') {
			hot = pickSeat(dx, dy, seats);
			// Crossing the ring commits the meaning: the stroke flows on.
			if (hot !== null && Math.hypot(dx, dy) > RING_R * 0.8) {
				chooseMeaning(hot);
				moved = false;
			}
		} else {
			hot = pickSeat(dx, dy, artAngles);
		}
	}

	function up() {
		if (!down) return;
		down = false;
		if (stage === 'meaning' && hot !== null && moved) return chooseMeaning(hot);
		if (stage === 'article' && hot !== null) return onarticle(ARTICLES[hot]);
		// A plain press: the ring stays for tapping.
		hot = null;
		trail = [];
	}

	function outside(e: PointerEvent) {
		if (down) return;
		if ((e.target as Element | null)?.closest?.('.wring [data-seat]')) return;
		ondismiss();
	}

	function key(e: KeyboardEvent) {
		if (e.key === 'Escape') ondismiss();
	}

	onMount(() => {
		trail = [[cx, cy]];
		window.addEventListener('pointermove', move);
		window.addEventListener('pointerup', up);
		window.addEventListener('pointercancel', up);
		window.addEventListener('pointerdown', outside, true);
		window.addEventListener('keydown', key);
		return () => {
			window.removeEventListener('pointermove', move);
			window.removeEventListener('pointerup', up);
			window.removeEventListener('pointercancel', up);
			window.removeEventListener('pointerdown', outside, true);
			window.removeEventListener('keydown', key);
		};
	});
</script>

<div class="wring" aria-label="Pick the meaning">
	{#if trail.length > 1}
		<svg class="trail" aria-hidden="true">
			<polyline points={trail.map((p) => p.join(',')).join(' ')} />
		</svg>
	{/if}
	<span class="hub" style="left: {cx}px; top: {cy}px" aria-hidden="true"></span>
	{#if stage === 'meaning'}
		{#each opts as o, i (o.key)}
			{@const p = polar(cx, cy, angles[i], RING_R)}
			<button
				type="button"
				class="seat"
				class:on={hot === i}
				data-seat
				style="left: {p[0]}px; top: {p[1]}px"
				onclick={() => !down && chooseMeaning(i)}
			>{o.label}</button>
		{/each}
		{#if hasStar}
			{@const p = polar(cx, cy, STAR_ANGLE, RING_R)}
			<button
				type="button"
				class="seat star"
				class:on={hot === STAR_SEAT}
				data-seat
				aria-label="Hint star: show this word ({stars} left)"
				style="left: {p[0]}px; top: {p[1]}px"
				onclick={() => !down && onstar?.()}
			>★ {stars}</button>
		{/if}
	{:else}
		<span class="seat mid" style="left: {cx}px; top: {cy}px">{label}</span>
		{#each ARTICLES as a, i (a)}
			{@const p = polar(cx, cy, ART_DIRS[a], ART_R)}
			<button
				type="button"
				class="seat art"
				class:on={hot === i}
				data-seat
				lang="de"
				style="left: {p[0]}px; top: {p[1]}px; --ac: {ARTICLE_COLORS[a]}"
				onclick={() => !down && onarticle(a)}
			>{a}</button>
		{/each}
	{/if}
</div>

<style>
	.wring {
		position: fixed;
		inset: 0;
		z-index: 30;
		pointer-events: none;
	}

	.trail {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		overflow: visible;
	}

	.trail polyline {
		fill: none;
		stroke: var(--accent);
		stroke-width: 3;
		stroke-linecap: round;
		stroke-linejoin: round;
		opacity: 0.6;
	}

	.hub {
		position: absolute;
		width: 14px;
		height: 14px;
		border-radius: 50%;
		background: var(--heading);
		transform: translate(-50%, -50%);
		box-shadow: 0 0 0 5px rgb(31 58 95 / 0.18);
	}

	.seat {
		position: absolute;
		transform: translate(-50%, -50%);
		pointer-events: auto;
		padding: 0.45rem 0.75rem;
		border: none;
		border-radius: var(--radius-sm);
		background: var(--heading);
		color: #fff;
		font: inherit;
		font-weight: 700;
		font-size: 0.95rem;
		white-space: nowrap;
		box-shadow: 0 6px 16px rgb(0 0 0 / 0.22);
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
		animation: seat-in var(--medium) var(--ease-spring);
		touch-action: none;
	}

	.seat.on {
		transform: translate(-50%, -50%) scale(1.14);
		outline: 3px solid var(--accent);
		outline-offset: 1px;
	}

	.seat.art {
		min-width: 3.4em;
		background: var(--ac);
		box-shadow: inset 0 -3px 0 rgb(0 0 0 / 0.2), 0 6px 16px rgb(0 0 0 / 0.22);
	}

	.seat.art.on {
		outline-color: var(--heading);
	}

	.seat.star {
		background: #e2b04a;
		color: #4a3508;
	}

	.seat.mid {
		pointer-events: none;
		background: var(--surface);
		color: var(--heading);
		border: 1.5px solid var(--heading);
	}

	@keyframes seat-in {
		from {
			opacity: 0;
			transform: translate(-50%, -50%) scale(0.6);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.seat {
			animation: none;
			transition: none;
		}
	}
</style>
