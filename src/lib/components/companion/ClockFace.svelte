<script lang="ts">
	// A printed clock face: twelve ticks, and the hands for `time` (HH:MM).
	// Without a time it is blank — for the reader to draw the hands in.
	let { time = null, mark = false }: { time?: string | null; mark?: boolean } = $props();

	// In a 100 × 100 box centred on 50,50; positions in minutes round the face.
	const at = (minute: number, r: number) => {
		const a = (minute / 60) * 2 * Math.PI;
		return `${(50 + r * Math.sin(a)).toFixed(2)} ${(50 - r * Math.cos(a)).toFixed(2)}`;
	};
	const hands = $derived.by(() => {
		if (!time) return null;
		const [h, m] = time.split(':').map(Number);
		return { hour: ((h % 12) + m / 60) * 5, minute: m };
	});
</script>

<svg viewBox="0 0 100 100" role="img" aria-label={time ?? 'a clock without hands'} class:mark>
	<circle cx="50" cy="50" r="44" class="face" />
	{#each { length: 12 } as _, i (i)}<path d="M{at(i * 5, 44)} L{at(i * 5, i % 3 ? 39 : 35)}" class="tick" />{/each}
	{#if hands}
		<path d="M50 50 L{at(hands.hour, 24)}" class="hand hour" />
		<path d="M50 50 L{at(hands.minute, 36)}" class="hand minute" />
	{/if}
	<circle cx="50" cy="50" r="3" class="pin" />
</svg>

<style>
	svg {
		display: block;
		width: 100%;
		height: auto;
	}

	.face {
		fill: #fff;
		stroke: var(--navy);
		stroke-width: 2.4;
	}

	.mark .face {
		stroke: var(--accent);
		stroke-width: 3.4;
	}

	.tick {
		stroke: var(--navy);
		stroke-width: 2;
	}

	.hand {
		stroke: var(--navy);
		stroke-linecap: round;
	}

	.hour {
		stroke-width: 6;
	}

	.minute {
		stroke: var(--accent);
		stroke-width: 3.4;
	}

	.pin {
		fill: var(--navy);
	}
</style>
