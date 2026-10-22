<script lang="ts">
	// The picture hunt's walkthrough: a few cards in front of the room, shown
	// the first time a hunt opens and again from its "?" button. Each card
	// shows the move it explains — the room itself with one thing ringed, the
	// same thing zoomed, the three colours a find can earn, the three medals.
	import Icon from '$lib/icons/Icon.svelte';
	import RibbonBadge from '../RibbonBadge.svelte';
	import { modal } from '$lib/a11y.svelte';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import type { SuchbildSpot } from '$lib/content/types';

	let {
		scene,
		sceneSize,
		spot,
		locale,
		onclose
	}: {
		/** The room, an id in static/img/. */
		scene: string;
		sceneSize: [number, number];
		/** The thing the pictures point at: the first card's example. */
		spot: SuchbildSpot;
		locale: string;
		onclose: () => void;
	} = $props();

	type Card = { id: 'find' | 'zoom' | 'tries' | 'medals' | 'cards'; title: string; text: string };
	const CARDS: Card[] = [
		{
			id: 'find',
			title: 'Find it in the picture',
			text: 'The question names one thing in the room. Tap it in the picture.'
		},
		{
			id: 'zoom',
			title: 'Look closer',
			text: 'Small things hide well. Pinch the picture, or use + and −, and drag to look around.'
		},
		{
			id: 'tries',
			title: 'Three tries',
			text: 'Tap the wrong thing and you see what it is: keep looking. After three misses the right one glows.'
		},
		{
			id: 'medals',
			title: 'Three medals',
			text: 'Eight points in a run of ten wins the medal for that step. Pick the step at the top.'
		},
		{
			id: 'cards',
			title: 'Learn the words first',
			text: 'Not sure of the words yet? "Cards" turns this room into flip cards. Come back to the picture when you know them.'
		}
	];

	let at = $state(0);
	const card = $derived(CARDS[at]);
	const last = $derived(at === CARDS.length - 1);
	const [w, h] = $derived(sceneSize);
	/** The spot's centre, in percent of the room: where the zoomed view looks. */
	const cx = $derived(spot.x + spot.w / 2);
	const cy = $derived(spot.y + spot.h / 2);
	const gender = $derived(GENDER_COLORS[({ der: 'm', die: 'f', das: 'n' } as const)[spot.article]]);
</script>

<div class="backdrop">
	<div
		class="tour"
		role="dialog"
		aria-modal="true"
		aria-labelledby="tour-title"
		tabindex="-1"
		use:modal={onclose}
	>
		<p class="eyebrow tnum">How to play · {at + 1} of {CARDS.length}</p>

		<div class="show" aria-hidden="true">
			{#if card.id === 'find' || card.id === 'zoom'}
				<div class="mini" style:aspect-ratio="{w} / {h}">
					<div
						class="mini-canvas"
						class:zoomed={card.id === 'zoom'}
						style:transform-origin="{cx}% {cy}%"
					>
						<img src="/img/{scene}.webp" alt="" width={w} height={h} draggable="false" />
						<span
							class="ring"
							style:left="{spot.x}%"
							style:top="{spot.y}%"
							style:width="{spot.w}%"
							style:height="{spot.h}%"
						></span>
					</div>
					{#if card.id === 'find'}
						<p class="bubble" lang={locale}>Wo ist <b>{spot.article}</b> {spot.de}?</p>
					{:else}
						<span class="chips"><span>−</span><span>+</span></span>
					{/if}
				</div>
			{:else if card.id === 'tries'}
				<ul class="marks">
					<li><span class="mark right">1st try</span> a full point</li>
					<li><span class="mark half">2nd or 3rd try</span> half a point</li>
					<li><span class="mark wrong">3 misses</span> no point</li>
				</ul>
			{:else if card.id === 'medals'}
				<ul class="medals">
					<li><RibbonBadge tier="bronze" width={14} /><span><b>Read</b> — the question shows the word.</span></li>
					<li><RibbonBadge tier="silver" width={14} /><span><b>Article</b> — find it, then pick der, die or das.</span></li>
					<li><RibbonBadge tier="gold" width={14} /><span><b>Listen</b> — you only hear the word. Find it, then write it with der, die or das.</span></li>
				</ul>
			{:else}
				<div class="flip">
					<span class="face front">{spot.en}</span>
					<Icon name="repeat" size="1.2em" />
					<span class="face back" lang={locale}><b style:color={gender}>{spot.article}</b> {spot.de}</span>
				</div>
			{/if}
		</div>

		<h2 id="tour-title">{card.title}</h2>
		<p class="text">{card.text}</p>

		<div class="dots" aria-hidden="true">
			{#each CARDS as c, i (c.id)}
				<span class:on={i === at}></span>
			{/each}
		</div>

		<div class="actions">
			{#if last}
				<span></span>
			{:else}
				<button type="button" class="btn btn-ghost" onclick={onclose}>Skip</button>
			{/if}
			<div class="nav">
				{#if at > 0}
					<button type="button" class="btn btn-ghost" aria-label="Back" onclick={() => (at -= 1)}>
						<Icon name="arrowLeft" size="1em" />
					</button>
				{/if}
				{#if last}
					<button type="button" class="btn" onclick={onclose}>Start hunting</button>
				{:else}
					<button type="button" class="btn" onclick={() => (at += 1)}>
						Next <Icon name="arrowRight" size="1em" />
					</button>
				{/if}
			</div>
		</div>
	</div>
</div>

<style>
	.backdrop {
		position: fixed;
		inset: 0;
		z-index: 70;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: rgb(20 32 52 / 0.45);
	}

	.tour {
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
		width: min(26rem, 100%);
		max-height: calc(100dvh - 2rem);
		overflow-y: auto;
		padding: 1.1rem 1.2rem 1rem;
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 24px 60px -20px rgb(20 32 52 / 0.55);
		animation: rise 260ms var(--ease-out, ease-out);
	}

	.tour:focus {
		outline: none;
	}

	.eyebrow {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	h2 {
		margin: 0.2rem 0 0;
		font-size: var(--step-1);
	}

	.text {
		margin: 0;
		color: var(--ink);
	}

	/* -- the pictures ------------------------------------------------------- */

	.show {
		display: grid;
		place-items: center;
		min-height: 9rem;
		padding: 0.6rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.mini {
		position: relative;
		width: min(15rem, 100%);
		overflow: hidden;
		border-radius: var(--radius-sm);
		background: #fbf5e4;
	}

	.mini-canvas {
		position: absolute;
		inset: 0;
		transition: transform 600ms var(--ease-out, ease-out);
	}

	.mini-canvas.zoomed {
		transform: scale(2.2);
	}

	.mini img {
		display: block;
		width: 100%;
		height: 100%;
	}

	.ring {
		position: absolute;
		border-radius: 8px;
		box-shadow: 0 0 0 3px var(--accent);
		animation: pulse 1.3s ease-in-out infinite;
	}

	.mini-canvas.zoomed .ring {
		box-shadow: 0 0 0 1.5px var(--accent);
	}

	.bubble {
		position: absolute;
		left: 50%;
		top: 0.4rem;
		translate: -50% 0;
		margin: 0;
		padding: 0.15rem 0.6rem;
		border-radius: 999px;
		background: rgb(255 250 240 / 0.95);
		box-shadow: 0 1px 4px rgb(31 58 95 / 0.2);
		font-size: 0.8rem;
		font-weight: 600;
		white-space: nowrap;
		color: #1f3a5f;
	}

	.chips {
		position: absolute;
		right: 0.4rem;
		bottom: 0.4rem;
		display: flex;
		gap: 0.25rem;
	}

	.chips span {
		display: grid;
		place-items: center;
		width: 1.5rem;
		height: 1.5rem;
		border: 1px solid var(--line-strong);
		border-radius: 50%;
		background: rgb(255 250 240 / 0.95);
		color: #1f3a5f;
		font-weight: 800;
	}

	.marks,
	.medals {
		display: grid;
		gap: 0.5rem;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
	}

	.marks li {
		display: flex;
		align-items: center;
		gap: 0.6rem;
	}

	.mark {
		min-width: 7.5rem;
		padding: 0.2rem 0.6rem;
		border-radius: 999px;
		font-weight: 800;
		text-align: center;
		color: #fff;
	}

	.mark.right {
		background: var(--right);
	}

	.mark.half {
		background: #e2b23c;
		color: #3b2a06;
	}

	.mark.wrong {
		background: var(--wrong);
	}

	.medals li {
		display: flex;
		align-items: flex-start;
		gap: 0.6rem;
	}

	.flip {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		color: var(--ink-muted);
	}

	.face {
		display: grid;
		place-items: center;
		width: 6.5rem;
		height: 4.5rem;
		padding: 0.3rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		box-shadow: 0 4px 10px -6px rgb(20 32 52 / 0.4);
		font-size: var(--step--1);
		text-align: center;
		color: var(--ink);
	}

	/* -- the way through ---------------------------------------------------- */

	.dots {
		display: flex;
		justify-content: center;
		gap: 0.35rem;
	}

	.dots span {
		width: 0.45rem;
		height: 0.45rem;
		border-radius: 50%;
		background: var(--line-strong);
		transition: background var(--fast) var(--ease-out);
	}

	.dots span.on {
		background: var(--accent);
	}

	.actions {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.5rem;
	}

	.nav {
		display: flex;
		gap: 0.4rem;
	}

	@keyframes pulse {
		50% {
			box-shadow: 0 0 0 6px rgb(201 104 59 / 0.35);
		}
	}

	@keyframes rise {
		from {
			opacity: 0;
			transform: translateY(12px);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.tour,
		.ring {
			animation: none;
		}
		.mini-canvas {
			transition: none;
		}
	}
</style>
