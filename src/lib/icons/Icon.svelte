<script lang="ts">
	// One icon component over the shared path registry.
	//
	// Sizes in `em` so an icon always matches the type it sits beside, and
	// inherits `currentColor` so it takes the colour of its context rather than
	// carrying its own. `vector-effect: non-scaling-stroke` keeps the stroke a
	// consistent optical weight at every size.
	import { icons, type IconName } from './paths';

	let {
		name,
		size = '1.15em',
		stroke = 1.75,
		label,
		class: klass = ''
	}: {
		name: IconName;
		/** Any CSS length. `em` keeps the icon locked to the local font size. */
		size?: string;
		stroke?: number;
		/** Give a label only when the icon is the sole meaning; else it's decorative. */
		label?: string;
		class?: string;
	} = $props();

	const spec = $derived(icons[name]);
</script>

<svg
	class="icon {klass}"
	width={size}
	height={size}
	viewBox="0 0 24 24"
	fill="none"
	stroke="currentColor"
	stroke-width={spec.width ?? stroke}
	stroke-linecap="round"
	stroke-linejoin="round"
	role={label ? 'img' : 'presentation'}
	aria-label={label}
	aria-hidden={label ? undefined : 'true'}
	focusable="false"
>
	<path d={spec.d} />
	{#if spec.fill}
		<path d={spec.fill} fill="currentColor" stroke="none" />
	{/if}
</svg>

<style>
	.icon {
		display: inline-block;
		flex: none;
		/* Sits on the text baseline instead of the line box bottom. */
		vertical-align: -0.145em;
	}

	.icon :global(path) {
		vector-effect: non-scaling-stroke;
	}
</style>
