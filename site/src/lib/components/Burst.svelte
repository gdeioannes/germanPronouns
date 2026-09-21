<script lang="ts">
	// A one-shot celebration burst, thrown from the centre of whatever it is
	// placed inside. Purely decorative and pointer-transparent, so it can sit
	// over a live control without ever intercepting a tap.
	import { makeBurst, type Spark } from '$lib/motion';

	let {
		/** Bump this to fire a new burst. */
		trigger = 0,
		count = 18
	}: { trigger?: number; count?: number } = $props();

	let sparks = $state<Spark[]>([]);

	$effect(() => {
		if (trigger <= 0) return;
		sparks = makeBurst(count);
		// Clear once the longest particle has finished, so the DOM doesn't
		// accumulate spent nodes over a long quiz run.
		const timer = setTimeout(() => (sparks = []), 1100);
		return () => clearTimeout(timer);
	});
</script>

{#if sparks.length}
	<div class="burst" aria-hidden="true">
		{#each sparks as spark (spark.id)}
			<span
				class="spark"
				style:--angle="{spark.angle}deg"
				style:--distance="{spark.distance}px"
				style:--size="{spark.size}px"
				style:--delay="{spark.delay}ms"
				style:--color={spark.color}
				style:--spin="{spark.spin}deg"
			></span>
		{/each}
	</div>
{/if}

<style>
	.burst {
		position: absolute;
		inset: 0;
		pointer-events: none;
		overflow: visible;
		z-index: 2;
	}

	.spark {
		position: absolute;
		top: 50%;
		left: 50%;
		width: var(--size);
		height: var(--size);
		margin: calc(var(--size) / -2);
		border-radius: 2px;
		background: var(--color);
		opacity: 0;
		animation: throw 900ms var(--delay) cubic-bezier(0.16, 0.84, 0.44, 1) forwards;
	}

	/* Rotate to the particle's angle first, travel along that axis, then let
	   it fall back slightly — so the burst has a little weight to it. */
	@keyframes throw {
		0% {
			opacity: 1;
			transform: rotate(var(--angle)) translateY(0) rotate(0deg) scale(0.4);
		}
		55% {
			opacity: 1;
			transform: rotate(var(--angle)) translateY(calc(var(--distance) * -1))
				rotate(var(--spin)) scale(1);
		}
		100% {
			opacity: 0;
			transform: rotate(var(--angle)) translateY(calc(var(--distance) * -0.8))
				rotate(var(--spin)) scale(0.75);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.burst {
			display: none;
		}
	}
</style>
