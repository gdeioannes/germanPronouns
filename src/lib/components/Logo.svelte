<script lang="ts">
	// The brand mark, inline, so the nav draws vector instead of scaling a PNG
	// down to 28px. The geometry hand-mirrors tool/logo.mjs — change it in both
	// places, then run `npm run logo` to re-render the icons.
	//
	// `tile` is the navy-square form (the app icon); without it the mark sits
	// bare on the page in ink-navy and terracotta.

	let {
		size = '1.75rem',
		tile = false,
		title = ''
	}: { size?: string; tile?: boolean; title?: string } = $props();

	// A tile needs padding around the mark; bare, the mark fills its box.
	const box = $derived(tile ? 76 : 64);
	const offset = $derived((box - 64) / 2);
</script>

<svg
	class="logo"
	class:tile
	width={size}
	height={size}
	viewBox="0 0 {box} {box}"
	role={title ? 'img' : 'presentation'}
	aria-label={title || undefined}
	aria-hidden={title ? undefined : 'true'}
>
	{#if tile}
		<rect width={box} height={box} rx={box * 0.22} class="plate" />
	{/if}
	<g transform="translate({offset} {offset})">
		<circle cx="32" cy="32" r="23.5" fill="none" class="ring" stroke-width="9" />
		<path d="M37.5 37.5L54 54" class="tail" stroke-width="8" stroke-linecap="butt" />
	</g>
</svg>

<style>
	.logo {
		display: block;
		flex: none;
	}

	.plate {
		fill: var(--navy);
	}

	.ring {
		stroke: var(--navy);
	}

	/* Reversed out of the navy plate, the ring has to become the paper. */
	.tile .ring {
		stroke: var(--paper);
	}

	.tail {
		stroke: var(--accent);
	}
</style>
