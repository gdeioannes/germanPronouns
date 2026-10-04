<script lang="ts">
	// Tells the learner why the voice just changed: the connection was down or
	// too slow for the recorded / cloud voices, so the device's own voice is
	// speaking instead — usable, but less natural. Shown at most once every
	// few minutes so a patchy connection does not turn it into nagging.
	import { onMount } from 'svelte';
	import { fly } from 'svelte/transition';
	import Icon from '$lib/icons/Icon.svelte';
	import { onConnectionFallback } from '$lib/services/speech';

	/** Minimum gap between two notices. */
	const REPEAT_AFTER_MS = 5 * 60 * 1000;
	/** How long a notice stays unless dismissed. */
	const VISIBLE_MS = 9000;

	let visible = $state(false);
	let lastShown = 0;
	let hideTimer: ReturnType<typeof setTimeout> | undefined;

	function hide() {
		clearTimeout(hideTimer);
		visible = false;
	}

	onMount(() => {
		const unsubscribe = onConnectionFallback(() => {
			const now = Date.now();
			if (visible || now - lastShown < REPEAT_AFTER_MS) return;
			lastShown = now;
			visible = true;
			clearTimeout(hideTimer);
			hideTimer = setTimeout(hide, VISIBLE_MS);
		});
		return () => {
			unsubscribe();
			clearTimeout(hideTimer);
		};
	});
</script>

<div class="slot" role="status" aria-live="polite">
	{#if visible}
		<div class="notice" transition:fly={{ y: 16, duration: 220 }}>
			<span class="icon" aria-hidden="true"><Icon name="volumeOff" size="1.1em" /></span>
			<p>
				<strong>Weak connection.</strong> You're hearing your device's voice, which sounds less
				natural. For the best audio, use a better connection.
			</p>
			<button type="button" class="close" onclick={hide} aria-label="Dismiss">
				<Icon name="close" size="1em" />
			</button>
		</div>
	{/if}
</div>

<style>
	.slot {
		position: fixed;
		inset: auto 0 calc(16px + env(safe-area-inset-bottom)) 0;
		display: flex;
		justify-content: center;
		padding: 0 16px;
		pointer-events: none;
		z-index: 60;
	}

	.notice {
		display: flex;
		align-items: flex-start;
		gap: 0.65rem;
		max-width: 30rem;
		padding: 0.75rem 0.6rem 0.75rem 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink);
		box-shadow: 0 8px 24px rgb(0 0 0 / 0.12);
		pointer-events: auto;
	}

	.icon {
		display: inline-flex;
		margin-top: 0.1rem;
		color: var(--accent-ink);
	}

	p {
		margin: 0;
		font-size: 0.92rem;
		line-height: 1.4;
	}

	strong {
		color: var(--heading);
	}

	.close {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex: none;
		width: 1.9rem;
		height: 1.9rem;
		margin: -0.25rem 0 0;
		padding: 0;
		border: 0;
		border-radius: var(--radius-sm);
		background: transparent;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.close:hover {
		background: var(--surface-alt);
		color: var(--ink);
	}
</style>
