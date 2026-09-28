<script lang="ts">
	// Draws the screen-level effects fired through motion/fx: confetti, the
	// finished-quiz stamp, floating praise and the answer edge glow. Mounted
	// once in the root layout; pointer-transparent, so it never takes a tap.
	import { fx } from '$lib/motion/fx.svelte';
	import { unlockAudio } from '$lib/services/sounds';

	// Browsers only start audio from a gesture: unlock it on the first one.
	$effect(() => unlockAudio());
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
			<div class="stamp"><span>{fx.stamp.text}</span></div>
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
		color: var(--accent);
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
		color: var(--accent);
		font-size: var(--step-3);
	}

	.praise small {
		padding: 0.1em 0.45em;
		border-radius: 999px;
		background: var(--accent);
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
