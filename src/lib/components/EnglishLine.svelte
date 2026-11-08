<script lang="ts">
	// A translation that, from B1, waits behind a tap (domain/germanFirst.ts).
	//
	// The text stays in the page, invisible rather than absent: its height is
	// held so tapping never moves the answers under the thumb, and prerendered
	// pages keep their content. Tapping opens this text only; the next sentence
	// starts closed again. Inherits its look from whatever wraps it.
	import { hidesEnglish } from '$lib/domain/germanFirst';
	import { progress } from '$lib/state/progress.svelte';

	let {
		text,
		level,
		shown = false
	}: {
		text: string;
		level: string | undefined | null;
		/** The caller needs it visible regardless: the question depends on it, or it is answered. */
		shown?: boolean;
	} = $props();

	let openedFor = $state<string | null>(null);
	const waits = $derived(hidesEnglish(level) && !progress.alwaysEnglish);
	const closed = $derived(waits && !shown && openedFor !== text);
</script>

{#if waits}
	<span class="line">
		<span class="text" class:closed lang="en">{text}</span>
		{#if closed}
			<button type="button" class="reveal" onclick={() => (openedFor = text)}>English</button>
		{/if}
	</span>
{:else}{text}{/if}

<style>
	.line {
		display: grid;
	}
	.text,
	.reveal {
		grid-area: 1 / 1;
	}
	.closed {
		visibility: hidden;
	}
	.reveal {
		justify-self: start;
		align-self: start;
		/* No taller than one line of the text it covers: tapping must not move anything. */
		padding: 0 0.6rem;
		line-height: 1.3;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: transparent;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		cursor: pointer;
	}
	.reveal:hover {
		color: var(--ink);
		border-color: var(--ink-muted);
	}
</style>
