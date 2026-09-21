<script lang="ts">
	// The inline per-sentence audio button that appears beside every piece of
	// target-language text (the Flutter app's SpeakIconButton). Always speaks
	// through the TtsProvider interface, never the platform API directly.
	import { tts } from '$lib/services/speech';

	let {
		text,
		locale,
		rate = 1,
		label = 'Listen'
	}: { text: string; locale: string; rate?: number; label?: string } = $props();

	let busy = $state(false);

	async function play() {
		if (busy) return;
		busy = true;
		await tts.speak(text, { locale, rate });
		busy = false;
	}
</script>

<button class="speak" class:busy onclick={play} aria-label={label} title={label}>
	{#if busy}
		<span aria-hidden="true">◼</span>
	{:else}
		<span aria-hidden="true">🔊</span>
	{/if}
</button>

<style>
	.speak {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.9rem;
		height: 1.9rem;
		padding: 0;
		border: 1px solid var(--line);
		border-radius: 50%;
		background: var(--surface);
		font-size: 0.85rem;
		line-height: 1;
		cursor: pointer;
		vertical-align: middle;
		transition: border-color 0.15s;
	}

	.speak:hover {
		border-color: var(--accent);
	}

	.speak.busy {
		border-color: var(--accent);
		color: var(--accent);
	}
</style>
