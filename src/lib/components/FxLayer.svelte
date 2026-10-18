<script lang="ts">
	// Draws the screen-level effects fired through motion/fx: confetti, the
	// finished-quiz stamp, floating praise and the answer edge glow. Mounted
	// once in the root layout; pointer-transparent, so it never takes a tap.
	import { fx, land } from '$lib/motion/fx.svelte';
	import { TIER_COLORS, type RibbonTier } from '$lib/domain/progress';
	import RibbonBadge from './RibbonBadge.svelte';
	import { unlockAudio } from '$lib/services/sounds';

	// Browsers only start audio from a gesture: unlock it on the first one.
	$effect(() => unlockAudio());

	/** The stamp's medal, at full size; it shrinks to the slot's on the way. */
	const MEDAL_WIDTH = 64;

	/**
	 * Flies a medal from the stamp to its slot on an arc — up and over, then
	 * down into place, shrinking to the slot's size and turning once.
	 */
	function flyTo(node: HTMLElement, flight: { tier: RibbonTier; to: { x: number; y: number } }) {
		// Take off from the medal hung in the stamp, wherever it sits.
		const hung = document.querySelector('.fx .hung')?.getBoundingClientRect();
		const from = hung?.width
			? { x: hung.left + hung.width / 2, y: hung.top + hung.height / 2 }
			: { x: window.innerWidth / 2, y: window.innerHeight / 2 - 70 };
		const dx = flight.to.x - from.x;
		const dy = flight.to.y - from.y;
		const end = 11 / MEDAL_WIDTH;
		const at = (x: number, y: number, scale: number, turn: number) =>
			`translate(${x}px, ${y}px) translate(-50%, -50%) scale(${scale}) rotate(${turn}deg)`;
		node.style.left = `${from.x}px`;
		node.style.top = `${from.y}px`;
		const animation = node.animate(
			[
				{ transform: at(0, 0, 1, -4), offset: 0 },
				{ transform: at(dx * 0.35, dy * 0.2 - 90, 0.75, 120), offset: 0.4 },
				{ transform: at(dx * 0.85, dy * 0.85 - 30, end * 1.6, 300), offset: 0.8 },
				{ transform: at(dx, dy, end, 360), offset: 1 }
			],
			{ duration: 950, easing: 'cubic-bezier(0.45, 0, 0.25, 1)', fill: 'forwards' }
		);
		animation.onfinish = () => land(flight.tier);
		return { destroy: () => animation.cancel() };
	}
</script>

<div class="fx" aria-hidden="true">
	{#if fx.glow}
		{#key fx.glowKey}
			<div class="glow {fx.glow}"></div>
		{/key}
	{/if}

	{#each fx.confetti as c (c.id)}
		<span
			class="confetto"
			class:round={c.round}
			style:left="{c.x}%"
			style:--drift="{c.drift}px"
			style:--size="{c.size}px"
			style:--spin="{c.spin}deg"
			style:--color={c.color}
			style:animation-delay="{c.delay}ms"
			style:animation-duration="{c.duration}ms"
		></span>
	{/each}

	{#if fx.stamp}
		{#key fx.stamp.id}
			<div class="stamp" class:medal={fx.stamp.medal} style:--metal={fx.stamp.medal ? TIER_COLORS[fx.stamp.medal] : null}>
				<span>
					{#if fx.stamp.medal}
						<!-- The medal itself, hung above its name. Once it sets off
						     for its slot the stamp's own copy goes: one medal. -->
						<i class="hung" class:gone={fx.flight !== null}>
							<RibbonBadge tier={fx.stamp.medal} width={MEDAL_WIDTH} animate />
						</i>
					{/if}
					{fx.stamp.text}
					{#if fx.stamp.sub}<small>{fx.stamp.sub}</small>{/if}
				</span>
			</div>
		{/key}
	{/if}

	{#if fx.flight}
		{#key fx.flight.id}
			<span class="flyer" use:flyTo={fx.flight} style:--metal={TIER_COLORS[fx.flight.tier]}>
				<RibbonBadge tier={fx.flight.tier} width={MEDAL_WIDTH} />
			</span>
		{/key}
	{/if}

	{#each fx.praises as p (p.id)}
		<span class="praise" class:big={p.big} style:left="{p.x}px" style:top="{p.y}px">
			{p.text}
			{#if p.streak}<small class="tnum">×{p.streak}</small>{/if}
		</span>
	{/each}
</div>

<style>
	.fx {
		position: fixed;
		inset: 0;
		z-index: 1000;
		pointer-events: none;
		overflow: hidden;
	}

	/* A soft coloured vignette from the screen edges, gone in half a second. */
	.glow {
		position: absolute;
		inset: 0;
		animation: glow 620ms ease-out forwards;
	}

	.glow.right {
		box-shadow: inset 0 0 90px 10px color-mix(in srgb, var(--right) 45%, transparent);
	}

	.glow.wrong {
		box-shadow: inset 0 0 80px 6px color-mix(in srgb, var(--wrong) 35%, transparent);
	}

	@keyframes glow {
		from {
			opacity: 1;
		}
		to {
			opacity: 0;
		}
	}

	.confetto {
		position: absolute;
		top: -24px;
		width: var(--size);
		height: calc(var(--size) * 0.55);
		background: var(--color);
		border-radius: 2px;
		opacity: 0;
		animation-name: fall;
		animation-timing-function: cubic-bezier(0.25, 0.46, 0.45, 0.94);
		animation-fill-mode: forwards;
	}

	.confetto.round {
		height: var(--size);
		border-radius: 50%;
	}

	@keyframes fall {
		0% {
			opacity: 1;
			transform: translate(0, 0) rotate(0deg);
		}
		85% {
			opacity: 1;
		}
		100% {
			opacity: 0;
			transform: translate(var(--drift), 105vh) rotate(var(--spin));
		}
	}

	/* The finished-quiz stamp: slams in slightly rotated, holds, fades. */
	.stamp {
		position: absolute;
		inset: 0;
		display: grid;
		place-items: center;
	}

	.stamp span {
		padding: 0.35em 0.8em;
		border: 4px solid var(--accent);
		border-radius: var(--radius);
		background: color-mix(in srgb, var(--surface) 88%, transparent);
		color: var(--accent-ink);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-4);
		font-weight: 800;
		letter-spacing: 0.01em;
		box-shadow: 0 18px 40px -20px var(--navy);
		animation: stamp 1600ms cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
	}

	@keyframes stamp {
		0% {
			opacity: 0;
			transform: scale(2.2) rotate(-14deg);
		}
		18% {
			opacity: 1;
			transform: scale(1) rotate(-6deg);
		}
		75% {
			opacity: 1;
			transform: scale(1) rotate(-6deg);
		}
		100% {
			opacity: 0;
			transform: scale(0.92) rotate(-6deg);
		}
	}

	/* The medal stamp: bigger, in the medal's metal, and it holds longer —
	   the one moment that is allowed to stop the show. */
	.stamp.medal span {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.15em;
		padding: 0.45em 1.1em 0.55em;
		border-width: 6px;
		border-color: var(--metal);
		color: var(--metal);
		font-size: calc(var(--step-4) * 1.25);
		box-shadow:
			0 0 0 10px color-mix(in srgb, var(--metal) 22%, transparent),
			0 24px 60px -20px var(--navy);
		animation: medal 2600ms cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
	}

	.stamp.medal small {
		font-family: 'Inter Variable', 'Inter', sans-serif;
		font-size: 0.3em;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink);
	}

	@keyframes medal {
		0% {
			opacity: 0;
			transform: scale(2.6) rotate(-16deg);
		}
		14% {
			opacity: 1;
			transform: scale(1) rotate(-4deg);
		}
		22% {
			transform: scale(1.06) rotate(-4deg);
		}
		30% {
			transform: scale(1) rotate(-4deg);
		}
		82% {
			opacity: 1;
			transform: scale(1) rotate(-4deg);
		}
		100% {
			opacity: 0;
			transform: scale(0.9) rotate(-4deg);
		}
	}

	/* The medal hung in the stamp, with a slow swing like a real ribbon. */
	.hung {
		display: block;
		margin-bottom: 0.1em;
		transform-origin: 50% 0;
		animation: swing 1800ms ease-in-out 300ms both;
		filter: drop-shadow(0 6px 10px color-mix(in srgb, var(--metal) 45%, transparent));
	}

	.hung.gone {
		visibility: hidden;
	}

	@keyframes swing {
		0% {
			transform: rotate(0);
		}
		25% {
			transform: rotate(9deg);
		}
		50% {
			transform: rotate(-6deg);
		}
		75% {
			transform: rotate(3deg);
		}
		100% {
			transform: rotate(0);
		}
	}

	/* The medal in flight to its slot, trailing a little light. */
	.flyer {
		position: absolute;
		display: block;
		filter: drop-shadow(0 0 12px color-mix(in srgb, var(--metal) 70%, transparent))
			drop-shadow(0 8px 14px rgb(0 0 0 / 0.18));
	}

	/* A word of praise that pops up from the answer and floats away. */
	.praise {
		position: absolute;
		display: inline-flex;
		align-items: baseline;
		gap: 0.3em;
		translate: -50% -50%;
		color: var(--right);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 800;
		white-space: nowrap;
		text-shadow:
			0 2px 0 var(--surface),
			0 0 18px var(--surface);
		animation: praise 1300ms cubic-bezier(0.22, 0.61, 0.36, 1) forwards;
	}

	.praise.big {
		color: var(--accent-ink);
		font-size: var(--step-3);
	}

	.praise small {
		padding: 0.1em 0.45em;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-family: 'Inter Variable', 'Inter', sans-serif;
		font-size: 0.45em;
		font-weight: 800;
		text-shadow: none;
	}

	@keyframes praise {
		0% {
			opacity: 0;
			transform: translateY(10px) scale(0.6);
		}
		18% {
			opacity: 1;
			transform: translateY(-6px) scale(1.08);
		}
		30% {
			transform: translateY(-10px) scale(1);
		}
		100% {
			opacity: 0;
			transform: translateY(-70px) scale(1);
		}
	}

	/* Belt and braces: the fire functions already stay quiet in these cases. */
	:global(html[data-effects='calm']) .fx {
		display: none;
	}

	@media (prefers-reduced-motion: reduce) {
		.fx {
			display: none;
		}
	}
</style>
