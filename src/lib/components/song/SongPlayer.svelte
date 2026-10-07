<script lang="ts">
	// The sing-along page: the recording with a big play button, the lyrics
	// section by section with the German lines set bold, and a
	// "Heard it" switch that stops the deck dealing the song again. No score,
	// no medal: a song is a treat, not a test.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { markSongHeard, songHeard, type Song } from '$lib/domain/songs';
	import { breadcrumbLd, shareImage, songDescription, songLd, songTitle } from '$lib/seo';
	import { announce } from '$lib/a11y.svelte';
	import { onMount } from 'svelte';

	let { song, courseName }: { song: Song; courseName: string } = $props();

	let audio: HTMLAudioElement | undefined = $state();
	let playing = $state(false);
	let heard = $state(false);
	let time = $state(0);
	let duration = $state(0);

	onMount(() => {
		heard = songHeard(song.id);
	});

	function toggle() {
		if (!audio) return;
		if (audio.paused) void audio.play();
		else audio.pause();
	}

	// While the learner drags the slider we show the slider's value, not the
	// audio clock, so the thumb doesn't fight the timeupdate events.
	let scrubbing = $state(false);
	let scrubTime = $state(0);
	const shown = $derived(scrubbing ? scrubTime : time);

	function seekTo(seconds: number) {
		if (!audio) return;
		const t = Math.min(Math.max(seconds, 0), duration || audio.duration || 0);
		audio.currentTime = t;
		time = t;
	}

	function onScrubInput(e: Event) {
		scrubbing = true;
		scrubTime = Number((e.currentTarget as HTMLInputElement).value);
	}

	function onScrubChange(e: Event) {
		seekTo(Number((e.currentTarget as HTMLInputElement).value));
		scrubbing = false;
	}

	function onEnded() {
		playing = false;
		setHeard(true);
	}

	function setHeard(value: boolean) {
		heard = value;
		markSongHeard(song.id, value);
		announce(value ? 'Marked as heard. The deck will not deal this song again.' : 'Unmarked. The song can come round again.');
	}

	function clock(seconds: number): string {
		const m = Math.floor(seconds / 60);
		const s = Math.floor(seconds % 60);
		return `${m}:${s.toString().padStart(2, '0')}`;
	}
</script>

<Seo
	title={songTitle(song)}
	description={songDescription(song)}
	path={song.href}
	type="article"
	image={shareImage('level', song.level)}
	imageAlt="German {song.level} sing-along: {song.title}"
	jsonLd={[
		songLd(song, courseName),
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: courseName, path: `/course/${song.courseId}` },
			{ name: song.level, path: `/course/${song.courseId}/level/${song.level}` },
			{ name: song.title, path: song.href }
		])
	]}
/>

<main class="song">
	<header class="top">
		<a class="back" href="/course/{song.courseId}" aria-label="Back to your deck" title="Back to your deck">
			<Icon name="arrowLeft" size="1.15em" />
		</a>
		<span class="kind" aria-hidden="true"><Icon name="headphones" size="1em" /></span>
		<div class="title">
			<p class="where tnum">{song.level} · Sing-along</p>
			<h1>{song.title}</h1>
		</div>
	</header>

	<p class="tagline">{song.tagline}</p>

	<!-- On a phone the player docks to the bottom of the screen, so the lyrics
	     scroll past while the song stays one thumb away; on a desk it sits
	     under the title as a card. -->
	<section class="player" aria-label="Recording">
		<audio
			bind:this={audio}
			src={song.audio}
			preload="metadata"
			onplay={() => (playing = true)}
			onpause={() => (playing = false)}
			onended={onEnded}
			ontimeupdate={() => (time = audio?.currentTime ?? 0)}
			onloadedmetadata={() => (duration = audio?.duration ?? 0)}
		></audio>
		<button type="button" class="play" onclick={toggle} aria-label={playing ? 'Pause' : 'Play the song'}>
			<Icon name={playing ? 'pause' : 'play'} size="1.5em" />
		</button>
		<div class="track">
			<input
				class="scrub"
				type="range"
				min="0"
				max={duration || 1}
				step="0.1"
				value={shown}
				disabled={!duration}
				aria-label="Position in the song"
				aria-valuetext="{clock(shown)} of {clock(duration)}"
				oninput={onScrubInput}
				onchange={onScrubChange}
				style="--fill: {duration ? (shown / duration) * 100 : 0}%"
			/>
			<div class="times tnum" aria-hidden="true">
				<span>{clock(shown)}</span>
				<span>−{clock(Math.max(duration - shown, 0))}</span>
			</div>
		</div>
	</section>

	<section class="teaches">
		<h2>What you’ll be shouting</h2>
		<ul role="list">
			{#each song.teaches as item}
				<li>{item}</li>
			{/each}
		</ul>
	</section>

	<section class="lyrics" aria-label="Lyrics">
		{#each song.sections as section, i (i)}
			<h2>{section.title}</h2>
			{#if section.note}<p class="note">({section.note})</p>{/if}
			<ol class="lines" role="list">
				{#each section.lines as line, j (j)}
					<li class:de={line.lang === 'de'}>
						<span class="text" lang={line.lang}>{line.text}</span>
						{#if line.gloss}
							<!-- The translation follows the lyric inline after a slash, in a quieter face. -->
							<span class="gloss"> / {line.gloss}</span>
						{/if}
					</li>
				{/each}
			</ol>
		{/each}
	</section>

	<section class="done">
		<label>
			<input type="checkbox" checked={heard} onchange={(e) => setHeard(e.currentTarget.checked)} />
			I’ve heard it through — don’t deal this card again
		</label>
		<a class="back-link" href="/course/{song.courseId}">Back to the course</a>
	</section>
</main>

<style>
	/* Same frame as the quiz page: one column, the quiz header, then the
	   content. */
	.song {
		max-width: 46rem;
		margin: 0 auto;
		min-height: 100dvh;
		padding: 0.6rem 1.25rem calc(1.5rem + env(safe-area-inset-bottom));
	}
	.top {
		display: flex;
		align-items: center;
		gap: 0.65rem;
		padding-bottom: 0.6rem;
		margin-bottom: 0.75rem;
		border-bottom: 1px solid var(--line);
	}
	.back {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.4rem;
		height: 2.4rem;
		flex: none;
		margin-left: -0.4rem;
		border-radius: 50%;
		color: var(--ink-muted);
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}
	.back:hover {
		background: var(--surface-alt);
		color: var(--accent-ink);
	}
	.kind {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}
	.title {
		flex: 1;
		min-width: 0;
	}
	.where {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	h1 {
		margin: 0.05rem 0 0;
		font-size: var(--step-1);
		line-height: 1.2;
	}
	.tagline {
		color: var(--ink-muted);
		margin: 0 0 1rem;
	}

	/* The player: a surface card in the quiz palette, play button filled
	   like .btn, the track in the accent. */
	.player {
		display: flex;
		align-items: center;
		gap: 0.9rem;
		padding: 0.75rem 1rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		margin-bottom: 1.5rem;
	}
	.play {
		flex: none;
		width: 3.2rem;
		height: 3.2rem;
		border-radius: 50%;
		border: 0;
		background: var(--accent);
		color: #fff;
		display: grid;
		place-items: center;
		cursor: pointer;
		-webkit-tap-highlight-color: transparent;
		transition:
			transform var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}
	.play:hover {
		background: var(--accent-ink);
	}
	.play:active {
		transform: scale(0.94);
	}
	.track {
		flex: 1;
		min-width: 0;
		display: flex;
		flex-direction: column;
	}
	.scrub {
		--fill: 0%;
		width: 100%;
		margin: 0;
		height: 2.25rem; /* thumb-sized hit area; the visible track is thin */
		appearance: none;
		-webkit-appearance: none;
		background: transparent;
		cursor: pointer;
		touch-action: pan-y;
	}
	.scrub:disabled {
		cursor: default;
		opacity: 0.6;
	}
	.scrub::-webkit-slider-runnable-track {
		height: 0.4rem;
		border-radius: 999px;
		background: linear-gradient(to right, var(--accent) var(--fill), var(--surface-alt) var(--fill));
	}
	.scrub::-moz-range-track {
		height: 0.4rem;
		border-radius: 999px;
		background: var(--surface-alt);
	}
	.scrub::-moz-range-progress {
		height: 0.4rem;
		border-radius: 999px;
		background: var(--accent);
	}
	.scrub::-webkit-slider-thumb {
		-webkit-appearance: none;
		width: 1.25rem;
		height: 1.25rem;
		margin-top: -0.425rem;
		border-radius: 50%;
		background: var(--surface);
		border: 2px solid var(--accent);
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
	}
	.scrub::-moz-range-thumb {
		width: 1.25rem;
		height: 1.25rem;
		border-radius: 50%;
		background: var(--surface);
		border: 2px solid var(--accent);
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
	}
	.scrub:focus-visible {
		outline: 2px solid var(--accent-ink);
		outline-offset: 2px;
	}
	.times {
		display: flex;
		justify-content: space-between;
		margin-top: -0.2rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* A phone: the quiz header shrinks to one line, and the player docks to
	   the bottom edge above the home indicator. */
	@media (max-width: 36rem) {
		.song {
			padding: 0.4rem 0.85rem calc(6.5rem + env(safe-area-inset-bottom));
		}
		.top {
			gap: 0.45rem;
			padding-bottom: 0.45rem;
			margin-bottom: 0.55rem;
		}
		.top > .kind {
			display: none;
		}
		h1 {
			font-size: var(--step-0);
		}
		.player {
			position: fixed;
			left: 0.6rem;
			right: 0.6rem;
			bottom: calc(0.6rem + env(safe-area-inset-bottom));
			z-index: 5;
			margin: 0;
			padding: 0.6rem 0.9rem;
			box-shadow: 0 6px 24px rgba(0, 0, 0, 0.14);
		}
		.play {
			width: 3rem;
			height: 3rem;
		}
	}
	.teaches ul {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		padding: 0;
		margin: 0 0 1.5rem;
		list-style: none;
	}
	.teaches li {
		padding: 0.25rem 0.7rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		font-size: 0.9rem;
	}
	.lyrics h2 {
		font-size: 1.05rem;
		margin: 1.5rem 0 0.2rem;
	}
	.note {
		color: var(--ink-muted);
		font-style: italic;
		margin: 0 0 0.5rem;
		font-size: 0.9rem;
	}
	.lines {
		list-style: none;
		padding: 0;
		margin: 0;
	}
	.lines li {
		padding: 0.15rem 0;
		line-height: 1.5;
	}
	.lines li.de .text {
		font-weight: 600;
	}
	.gloss {
		font-weight: 400;
		font-style: italic;
		color: var(--ink-muted);
	}
	.done {
		margin-top: 2rem;
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}
	.done label {
		display: flex;
		gap: 0.6rem;
		align-items: center;
	}
	.back-link {
		align-self: flex-start;
	}
</style>
