<script lang="ts">
	// The completion mark: a flat bookmark ribbon whose colour is the tier.
	// Ported from lib/widgets/completion_ribbon.dart — same geometry, drawn as
	// inline SVG instead of a CustomPainter.
	import { TIER_COLORS, type RibbonTier } from '$lib/domain/progress';

	let { tier, width = 18 }: { tier: RibbonTier; width?: number } = $props();

	const height = $derived(width * 1.82);
	const color = $derived(TIER_COLORS[tier]);
</script>

<svg
	{width}
	height={height}
	viewBox="0 0 22 40"
	role="img"
	aria-label="{tier} ribbon"
>
	<!-- Swallowtail bookmark: straight shoulders, notched foot. -->
	<path d="M0 0 H22 V40 L11 31 L0 40 Z" fill={color} />
	<path
		d="M11 9 L12.6 13.2 L17 13.5 L13.6 16.4 L14.7 20.7 L11 18.3 L7.3 20.7 L8.4 16.4 L5 13.5 L9.4 13.2 Z"
		fill="#fff"
		opacity="0.9"
	/>
</svg>

<style>
	svg {
		display: block;
		flex: none;
	}
</style>
