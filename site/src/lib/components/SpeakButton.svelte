<script lang="ts">
	// The inline per-sentence audio button beside every piece of target-language
	// text. Always speaks through the TtsProvider interface, never the platform
	// API directly.
	import Icon from '$lib/icons/Icon.svelte';
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

<button class="speak" class:busy onclick={play} title={label} aria-label={label}>
	<!-- The ring animates only while speaking, so the button reads as "live"
	     without needing a separate spinner. -->
	<span class="ring" aria-hidden="true"></span>
	<Icon name={busy ? 'volumeOff' : 'volume'} size="0.95em" />
</button>

<style>
	.speak {
		position: relative;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.85em;
		height: 1.85em;
		padding: 0;
		border: 1px solid var(--line-strong);
		border-radius: 50%;
		background: var(--surface);
		color: var(--ink-muted);
		cursor: pointer;
		vertical-align: -0.35em;
		transition:
			color var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.speak:hover {
		border-color: var(--accent);
		color: var(--accent);
		transform: scale(1.06);
	}

	.speak:active {
		transform: scale(0.95);
	}

	.speak.busy {
		border-color: var(--accent);
		color: var(--accent);
	}

	.ring {
		position: absolute;
		inset: -1px;
		border-radius: 50%;
		border: 1.5px solid var(--accent);
		opacity: 0;
	}

	.speak.busy .ring {
		animation: pulse 1.1s var(--ease-out) infinite;
	}

	@keyframes pulse {
		0% {
			opacity: 0.55;
			transform: scale(1);
		}
		100% {
			opacity: 0;
			transform: scale(1.7);
		}
	}
</style>
