<script lang="ts">
	// Play / pause / resume, and replay from the start, for one recorded line.
	// Every spoken line in the number tasks gets these two buttons, so nothing
	// a learner hears is ever one-shot.
	import Icon from '$lib/icons/Icon.svelte';
	import { playClip, toggleClip, voice } from '$lib/services/clips.svelte';

	let {
		id,
		text,
		locale,
		label = 'Listen',
		dark = false
	}: {
		/** The clip: static/audio/story/<id>.mp3. */
		id: string;
		/** The line, spoken by the app voice if the clip is missing. */
		text: string;
		locale: string;
		/** What the main button says when nothing is playing. */
		label?: string;
		/** On a dark screen (the call screen). */
		dark?: boolean;
	} = $props();

	const mine = $derived(voice.id === id);
	const state = $derived(mine ? voice.status : 'idle');
</script>

<div class="clip" class:dark role="group" aria-label="Audio">
	<button type="button" class="main" onclick={() => toggleClip(id, { text, locale })}>
		<Icon name={state === 'playing' ? 'pause' : 'play'} size="1em" />
		{state === 'playing' ? 'Pause' : state === 'paused' ? 'Resume' : label}
	</button>
	<button
		type="button"
		class="again"
		aria-label="Replay from the start"
		title="Replay from the start"
		onclick={() => playClip(id, { text, locale })}
	>
		<Icon name="repeat" size="1em" />
	</button>
</div>

<style>
	.clip {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
	}

	button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.4rem;
		border: 0;
		border-radius: 999px;
		font: inherit;
		font-weight: 700;
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
	}

	button:active {
		transform: scale(0.96);
	}

	.main {
		min-width: 7.5rem;
		padding: 0.5rem 0.95rem;
		background: var(--accent);
		color: #fff;
	}

	.again {
		width: 2.3rem;
		height: 2.3rem;
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink-muted);
	}

	.dark .main {
		background: rgb(255 255 255 / 0.16);
	}

	.dark .again {
		border-color: rgb(255 255 255 / 0.25);
		background: none;
		color: rgb(255 255 255 / 0.8);
	}
</style>
