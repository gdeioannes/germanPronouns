<script lang="ts">
	// The completion mark: a flat bookmark ribbon whose colour is the tier.
	// Ported from lib/widgets/completion_ribbon.dart — same swallowtail
	// geometry, drawn as inline SVG instead of a CustomPainter.
	import { TIER_COLORS, type RibbonTier } from '$lib/domain/progress';

	let {
		tier,
		width = 18,
		/** Plays the hoist-in animation — for a ribbon that was just earned. */
		animate = false
	}: { tier: RibbonTier; width?: number; animate?: boolean } = $props();

	const color = $derived(TIER_COLORS[tier]);
	const label = $derived(`${tier} ribbon`);
</script>

<svg
	class="ribbon"
	class:animate
	{width}
	height={width * 1.82}
	viewBox="0 0 22 40"
	role="img"
	aria-label={label}
>
	<path class="cloth" d="M0 0 H22 V40 L11 31 L0 40 Z" fill={color} />
	<path
		class="star"
		d="M11 9 L12.6 13.2 L17 13.5 L13.6 16.4 L14.7 20.7 L11 18.3 L7.3 20.7 L8.4 16.4 L5 13.5 L9.4 13.2 Z"
		fill="#fff"
		opacity="0.92"
	/>
</svg>

<style>
	.ribbon {
		display: block;
		flex: none;
		/* Hangs from its top edge, like a real bookmark. */
		transform-origin: 50% 0;
	}

	/* Drops in, overshoots, settles — then the star catches a brief shine. */
	.ribbon.animate .cloth {
		animation: hoist 520ms cubic-bezier(0.34, 1.56, 0.64, 1) both;
		transform-origin: 50% 0;
	}

	.ribbon.animate .star {
		animation: shine 520ms 180ms ease-out both;
		transform-origin: 50% 40%;
	}

	@keyframes hoist {
		0% {
			transform: scaleY(0.2) translateY(-6px);
			opacity: 0;
		}
		100% {
			transform: scaleY(1) translateY(0);
			opacity: 1;
		}
	}

	@keyframes shine {
		0% {
			transform: scale(0.2) rotate(-40deg);
			opacity: 0;
		}
		100% {
			transform: scale(1) rotate(0);
			opacity: 0.92;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.ribbon.animate .cloth,
		.ribbon.animate .star {
			animation: none;
		}
	}
</style>
