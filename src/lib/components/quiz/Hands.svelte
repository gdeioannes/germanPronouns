<script lang="ts">
	// Two hands held up to the bartender, counting the German way: the first
	// hand fills from the thumb, then the second. Every finger is a button —
	// tapping one shows the count it stands for (see domain/barTask).
	import { FINGERS, countAfterTap, handsFor } from '$lib/domain/barTask';

	let {
		count,
		onChange,
		hint = null,
		disabled = false
	}: {
		count: number;
		onChange: (count: number) => void;
		/** A count to light up the finger for — the give-away after two misses. */
		hint?: number | null;
		disabled?: boolean;
	} = $props();

	const hands = $derived(handsFor(count));
	const HAND_NAMES = ['first hand', 'second hand'];

	function tap(hand: 0 | 1, finger: number) {
		if (disabled) return;
		onChange(countAfterTap(count, hand, finger));
	}
</script>

<div class="hands" role="group" aria-label="Your hands: {count} {count === 1 ? 'finger' : 'fingers'} up">
	{#each [0, 1] as const as hand (hand)}
		<div class="hand" class:second={hand === 1}>
			<span class="palm" aria-hidden="true"></span>
			{#each FINGERS as name, finger (name)}
				{@const value = hand * 5 + finger + 1}
				<button
					type="button"
					class="finger f{finger}"
					class:up={hands[hand][finger]}
					class:hint={hint === value}
					aria-pressed={hands[hand][finger]}
					aria-label="{name}, {HAND_NAMES[hand]} ({value})"
					{disabled}
					onclick={() => tap(hand, finger)}
				></button>
			{/each}
		</div>
	{/each}
</div>

<style>
	.hands {
		display: flex;
		justify-content: center;
		gap: 0.6rem;
	}

	.hand {
		position: relative;
		width: 8.4rem;
		height: 10.6rem;
	}

	.palm {
		position: absolute;
		bottom: 0;
		left: 0.5rem;
		width: 6.6rem;
		height: 4.8rem;
		border: 2px solid var(--navy);
		border-radius: 1.4rem 1.4rem 2.4rem 2.4rem;
		background: var(--accent-soft);
	}

	.finger {
		--h: 5.2rem;
		position: absolute;
		bottom: 4.2rem;
		width: 1.45rem;
		height: 1.35rem;
		padding: 0;
		border: 2px solid var(--navy);
		border-radius: 999px 999px 0.4rem 0.4rem;
		background: var(--surface-alt);
		cursor: pointer;
		transform-origin: bottom center;
		transition:
			height 220ms var(--ease-spring),
			background var(--fast) var(--ease-out);
	}

	.finger.up {
		height: var(--h);
		background: var(--accent-soft);
	}

	.finger:hover:not(:disabled) {
		background: #f3d3c2;
	}

	.finger:disabled {
		cursor: default;
	}

	/* Two misses: the finger to stop at pulses green. */
	.finger.hint {
		border-color: var(--right);
		box-shadow: 0 0 0 4px var(--right-bg);
		animation: hint 1s var(--ease-out) infinite;
	}

	@keyframes hint {
		50% {
			box-shadow: 0 0 0 7px var(--right-bg);
		}
	}

	/* First hand, palm to the bartender: little finger on the left, thumb on
	   the right. The second hand mirrors it, so the thumbs meet in the middle. */
	.f1 { left: 4.95rem; --h: 5.3rem; }
	.f2 { left: 3.45rem; --h: 5.8rem; }
	.f3 { left: 1.95rem; --h: 5.2rem; }
	.f4 { left: 0.6rem; --h: 4.1rem; }
	.f0 {
		left: 6.5rem;
		bottom: 1.6rem;
		--h: 4rem;
		transform: rotate(32deg);
	}

	.second .palm { left: auto; right: 0.5rem; }
	.second .f1 { left: auto; right: 4.95rem; }
	.second .f2 { left: auto; right: 3.45rem; }
	.second .f3 { left: auto; right: 1.95rem; }
	.second .f4 { left: auto; right: 0.6rem; }
	.second .f0 {
		left: auto;
		right: 6.5rem;
		transform: rotate(-32deg);
	}

	@media (max-width: 24rem) {
		.hands {
			gap: 0.2rem;
		}
	}
</style>
