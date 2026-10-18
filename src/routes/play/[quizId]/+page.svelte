<script lang="ts">
	// The book's audio player. Big buttons, one per clip, the number the page
	// printed beside each; "play all" for a listening passage or a dictation
	// read through. The recorded clips play from static/audio; a clip that was
	// never recorded falls back to the app's voice.
	import Icon from '$lib/icons/Icon.svelte';
	import { tts } from '$lib/services/speech';

	let { data } = $props();
	let playing = $state<number | null>(null);
	let audio: HTMLAudioElement | null = null;

	async function play(i: number) {
		stop();
		const clip = data.clips[i];
		playing = i;
		if (clip.file) {
			audio = new Audio(`/audio/${clip.file}`);
			audio.onended = () => (playing = null);
			await audio.play().catch(() => (playing = null));
		} else {
			await tts.speak(clip.text, { locale: 'de-DE' });
			playing = null;
		}
	}

	function stop() {
		audio?.pause();
		audio = null;
		playing = null;
	}

	async function playAll() {
		for (let i = 0; i < data.clips.length; i++) {
			await new Promise<void>((resolve) => {
				stop();
				const clip = data.clips[i];
				playing = i;
				if (clip.file) {
					audio = new Audio(`/audio/${clip.file}`);
					audio.onended = () => resolve();
					audio.onerror = () => resolve();
					audio.play().catch(() => resolve());
				} else {
					tts.speak(clip.text, { locale: 'de-DE' }).then(() => resolve());
				}
			});
			await new Promise((r) => setTimeout(r, 700));
		}
		playing = null;
	}
</script>

<svelte:head>
	<title>{data.title} · audio</title>
	<meta name="robots" content="noindex" />
</svelte:head>

<main class="player">
	<p class="eyebrow">{data.level} · {data.kind}</p>
	<h1>{data.title}</h1>
	<div class="actions">
		<button type="button" class="btn" onclick={playAll}><Icon name="volume" size="1.1em" /> Play all</button>
		<a class="btn-quiet" href={data.quizHref}>Open the exercise</a>
	</div>
	<ol class="clips">
		{#each data.clips as clip, i (i)}
			<li class:on={playing === i}>
				<button type="button" onclick={() => (playing === i ? stop() : play(i))} aria-label="Play {clip.n}">
					<span class="n">{clip.n}</span>
					<Icon name={playing === i ? 'close' : 'volume'} size="1.2em" />
				</button>
				<div>
					<p class="de" lang="de">{clip.text}</p>
					{#if clip.en}<p class="en">{clip.en}</p>{/if}
				</div>
			</li>
		{/each}
	</ol>
</main>

<style>
	.player {
		max-width: 36rem;
		margin: 0 auto;
		padding: 1.5rem 1rem 4rem;
	}
	.eyebrow {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}
	h1 {
		margin: 0.2rem 0 1rem;
		font-size: var(--step-2);
		color: var(--heading);
	}
	.actions {
		display: flex;
		gap: 0.8rem;
		align-items: center;
		flex-wrap: wrap;
		margin-bottom: 1.2rem;
	}
	.clips {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.6rem;
	}
	.clips li {
		display: grid;
		grid-template-columns: auto 1fr;
		gap: 0.8rem;
		align-items: center;
		padding: 0.6rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
	}
	.clips li.on {
		border-color: var(--accent);
		background: var(--accent-soft);
	}
	.clips button {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.5rem 0.7rem;
		border: 1px solid var(--navy);
		border-radius: 999px;
		background: var(--navy);
		color: var(--paper);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}
	.n {
		font-variant-numeric: tabular-nums;
	}
	.de {
		margin: 0;
		font-family: var(--serif, inherit);
		font-size: var(--step-0);
		color: var(--ink);
	}
	.en {
		margin: 0.1rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
</style>
