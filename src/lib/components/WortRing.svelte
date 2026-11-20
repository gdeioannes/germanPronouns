<script lang="ts">
	// The marking menu for Wortblöcke (rules and layout in domain/wortRing):
	// opened by a press on a block. Stroke: slide toward a meaning (going far
	// enough commits it), then on toward an article, let go. Picking is by
	// direction from where the finger went down, so the labels may sit a
	// little apart from it (centred on a narrow phone). A release with nothing
	// picked leaves the menu open for plain taps; a tap elsewhere puts it away.
	import { onMount } from 'svelte';
	import { ARTICLE_COLORS } from '$lib/domain/wortbloecke';
	import {
		ARTICLES,
		ART_SLOTS,
		COMMIT_R,
		SLOTS,
		STAR_SLOT,
		meaningSlots,
		pickSeat,
		placeCenter,
		type Article,
		type Slot
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
		/** The meanings, or null to open straight on the articles. */
		options: Option[] | null;
		/** The label in the middle of the articles when they open first. */
		center?: string;
		/** The pointer is still down: a stroke may follow. */
		pressing?: boolean;
		/** Hint stars in hand: with any, a ★ seat sits straight down. */
		stars?: number;
		/** A meaning was chosen. True: a noun, open the articles. */
		onmeaning: (key: string) => boolean;
		onarticle: (art: Article) => void;
		/** The ★ seat was chosen: spend a star on this word. */
		onstar?: () => void;
		ondismiss: () => void;
	} = $props();

	// The props seed the menu once; from then on it lives its own gesture.
	/* svelte-ignore state_referenced_locally */
	const first = placeCenter(x, y, window.innerWidth, window.innerHeight);
	/* svelte-ignore state_referenced_locally */
	let stage = $state<'meaning' | 'article'>(options ? 'meaning' : 'article');
	/** Where the labels are drawn round. */
	let cx = $state(first[0]);
	let cy = $state(first[1]);
	/** Where the stroke is measured from: the press, then the commit point. */
	/* svelte-ignore state_referenced_locally */
	let ox = x;
	/* svelte-ignore state_referenced_locally */
	let oy = y;
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
	const slots = meaningSlots(opts.length).map((k) => SLOTS[k]);
	/** Every seat; the star, when there is one, is last. */
	const seats: Slot[] = hasStar ? [...slots, SLOTS[STAR_SLOT]] : slots;
	const STAR_SEAT = slots.length;
	const artSeats = ARTICLES.map((a) => ART_SLOTS[a]);

	const place = (s: Slot) => `left: ${cx + s.dx}px; top: ${cy + s.dy}px`;

	function toArticles(px: number, py: number, text: string) {
		const [ax, ay] = placeCenter(px, py, window.innerWidth, window.innerHeight, 130, 90);
		stage = 'article';
		cx = ax;
		cy = ay;
		ox = px;
		oy = py;
		label = text;
		hot = null;
	}

	function chooseMeaning(i: number, px: number, py: number) {
		if (i === STAR_SEAT) return onstar?.();
		const o = opts[i];
		if (onmeaning(o.key)) toArticles(px, py, o.label);
	}

	function move(e: PointerEvent) {
		if (!down) return;
		trail = [...trail.slice(-60), [e.clientX, e.clientY]];
		const dx = e.clientX - ox;
		const dy = e.clientY - oy;
		const far = Math.hypot(dx, dy);
		if (far > 22) moved = true;
		if (stage === 'meaning') {
			hot = pickSeat(dx, dy, seats.map((s) => s.angle));
			// Far enough toward a meaning commits it: the stroke flows on.
			if (hot !== null && far > COMMIT_R) {
				chooseMeaning(hot, e.clientX, e.clientY);
				moved = false;
			}
		} else {
			hot = pickSeat(dx, dy, artSeats.map((s) => s.angle));
		}
	}

	function up(e: PointerEvent) {
		if (!down) return;
		down = false;
		if (stage === 'meaning' && hot !== null && moved) return chooseMeaning(hot, e.clientX, e.clientY);
		if (stage === 'article' && hot !== null) return onarticle(ARTICLES[hot]);
		// A plain press: the menu stays for tapping.
		hot = null;
		trail = [];
	}

	/** A tap on a meaning: the articles open round the middle. */
	function tapMeaning(i: number) {
		if (down) return;
		chooseMeaning(i, cx, cy);
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
		trail = [[ox, oy]];
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
			<button
				type="button"
				class="seat {slots[i].anchor}"
				class:on={hot === i}
				data-seat
				style={place(slots[i])}
				onclick={() => tapMeaning(i)}
			>{o.label}</button>
		{/each}
		{#if hasStar}
			<button
				type="button"
				class="seat star center"
				class:on={hot === STAR_SEAT}
				data-seat
				aria-label="Hint star: show this word ({stars} left)"
				style={place(SLOTS[STAR_SLOT])}
				onclick={() => !down && onstar?.()}
			>★ {stars}</button>
		{/if}
	{:else}
		<span class="seat mid center" style="left: {cx}px; top: {cy}px">{label}</span>
		{#each ARTICLES as a, i (a)}
			<button
				type="button"
				class="seat art {ART_SLOTS[a].anchor}"
				class:on={hot === i}
				data-seat
				lang="de"
				style="{place(ART_SLOTS[a])}; --ac: {ARTICLE_COLORS[a]}"
				onclick={() => !down && onarticle(a)}
			>{a}</button>
		{/each}
	{/if}
</div>

<style>
	/* The board dims behind the menu, so the meanings read clearly. */
	.wring {
		position: fixed;
		inset: 0;
		z-index: 30;
		pointer-events: none;
		background: rgb(16 21 31 / 0.38);
		animation: dim var(--fast) var(--ease-out);
	}

	@keyframes dim {
		from {
			background: rgb(16 21 31 / 0);
		}
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
		stroke: #fff;
		stroke-width: 3;
		stroke-linecap: round;
		stroke-linejoin: round;
		opacity: 0.55;
	}

	.hub {
		position: absolute;
		width: 14px;
		height: 14px;
		border-radius: 50%;
		background: #fff;
		transform: translate(-50%, -50%);
		box-shadow: 0 0 0 5px rgb(255 255 255 / 0.25);
	}

	/* A label's anchor edge sits on its slot: centred at top and bottom,
	   growing outward on the right and on the left (Maya's layout). */
	.seat {
		--tx: -50%;
		position: absolute;
		max-width: calc(50vw - 3.2rem);
		overflow: hidden;
		text-overflow: ellipsis;
		transform: translate(var(--tx), -50%);
		pointer-events: auto;
		padding: 0.45rem 0.75rem;
		border: none;
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-weight: 700;
		font-size: 0.92rem;
		white-space: nowrap;
		box-shadow: 0 6px 16px rgb(0 0 0 / 0.28);
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
		animation: seat-in var(--medium) var(--ease-spring);
		touch-action: none;
	}

	.seat.start {
		--tx: 0%;
	}

	.seat.end {
		--tx: -100%;
	}

	.seat.on {
		transform: translate(var(--tx), -50%) scale(1.1);
		outline: 3px solid var(--accent);
		outline-offset: 1px;
	}

	.seat.art {
		min-width: 3.4em;
		background: var(--ac);
		color: #fff;
		text-align: center;
		box-shadow:
			inset 0 -3px 0 rgb(0 0 0 / 0.2),
			0 6px 16px rgb(0 0 0 / 0.28);
	}

	.seat.art.on {
		outline-color: #fff;
	}

	.seat.star {
		background: #e2b04a;
		color: #4a3508;
	}

	.seat.mid {
		pointer-events: none;
		background: var(--heading);
		color: #fff;
	}

	@keyframes seat-in {
		from {
			opacity: 0;
			transform: translate(var(--tx), -50%) scale(0.7);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.wring,
		.seat {
			animation: none;
			transition: none;
		}
	}
</style>
