<script lang="ts">
	// A voice note in a match chat. It is part of the challenge, so it plays at
	// most `limit` times; the transcript stays hidden until the chat is over
	// (`reveal`). A learner who cannot hear it can open the transcript, which
	// spends one play, so the rule stays the same for everyone.
	//
	// The club is under the voice: a techno loop, or a record scratch first.
	// The recording is a file under /audio/story/; if it is missing (offline,
	// not recorded yet) the app voice reads the transcript instead.
	import Icon from '$lib/icons/Icon.svelte';
	import { isMuted } from '$lib/services/mute';
	import { tts } from '$lib/services/speech';
	import { stopClip } from '$lib/services/clips.svelte';
	import { onDestroy } from 'svelte';
	import type { ChatMessage } from '$lib/domain/matchChat';

	let {
		message,
		used = 0,
		limit = 2,
		reveal = false,
		onplay
	}: {
		message: ChatMessage;
		/** Plays already spent (saved with the chat). */
		used?: number;
		limit?: number;
		/** The chat is over: show the transcript, no limit. */
		reveal?: boolean;
		onplay?: () => void;
	} = $props();

	let playing = $state(false);
	let progress = $state(0);
	let seconds = $state(0);
	let showText = $state(false);
	let voice: HTMLAudioElement | null = null;
	let bg: HTMLAudioElement | null = null;
	let raf = 0;

	const left = $derived(reveal ? Infinity : Math.max(0, limit - used));
	const spent = $derived(left <= 0 && !playing);

	/** A fixed waveform per clip, so the same note always looks the same. */
	const bars = $derived.by(() => {
		let seed = [...(message.audio ?? message.de ?? 'x')].reduce((s, c) => (s * 31 + c.charCodeAt(0)) >>> 0, 7);
		return Array.from({ length: 28 }, () => {
			seed = (seed * 1103515245 + 12345) >>> 0;
			return 0.25 + ((seed >>> 16) % 1000) / 1333;
		});
	});

	function stopAll() {
		cancelAnimationFrame(raf);
		voice?.pause();
		bg?.pause();
		voice = null;
		bg = null;
		playing = false;
	}

	function tick() {
		if (voice && voice.duration) {
			progress = voice.currentTime / voice.duration;
			seconds = voice.duration;
		}
		if (playing) raf = requestAnimationFrame(tick);
	}

	async function play() {
		if (playing) {
			stopAll();
			return;
		}
		if (left <= 0) return;
		stopClip();
		onplay?.();
		playing = true;
		progress = 0;
		if (isMuted() || typeof Audio === 'undefined') {
			// Muted: the note still "plays" (and counts), silently.
			setTimeout(() => (playing = false), 1200);
			return;
		}
		if (message.bg === 'scratch') {
			await new Promise<void>((resolve) => {
				const s = new Audio('/audio/story/sfx/record_scratch.mp3');
				s.volume = 0.7;
				s.onended = () => resolve();
				s.onerror = () => resolve();
				s.play().catch(() => resolve());
			});
		}
		if (message.bg === 'techno') {
			bg = new Audio('/audio/story/sfx/techno_loop.mp3');
			bg.loop = true;
			bg.volume = 0.32;
			bg.play().catch(() => {});
		}
		const v = new Audio(`/audio/story/${message.audio}.mp3`);
		voice = v;
		v.onended = () => {
			progress = 1;
			stopAll();
		};
		v.onerror = async () => {
			if (voice !== v) return;
			await tts.speak(message.de ?? '', { locale: 'de-DE' });
			stopAll();
		};
		v.play()
			.then(() => (raf = requestAnimationFrame(tick)))
			.catch(() => stopAll());
	}

	function openText() {
		if (!reveal && !showText) {
			if (left <= 0) return;
			onplay?.();
		}
		showText = !showText;
	}

	const fmt = (s: number) => (s ? `0:${String(Math.round(s)).padStart(2, '0')}` : 'replay');

	onDestroy(stopAll);
</script>

<div class="note" class:playing class:spent>
	<button
		type="button"
		class="play"
		onclick={play}
		disabled={spent}
		aria-label={playing ? 'Stop the voice message' : spent ? 'Voice message: no plays left' : 'Play the voice message'}
	>
		<Icon name={playing ? 'stop' : 'play'} size="1.1em" />
	</button>
	<div class="wave" aria-hidden="true">
		{#each bars as h, i (i)}
			<span style:height="{h * 100}%" class:done={i / bars.length < progress}></span>
		{/each}
	</div>
	<span class="meta">
		{#if reveal}
			{fmt(seconds)}
		{:else if spent}
			played
		{:else}
			{left}× left
		{/if}
	</span>
</div>
{#if reveal || showText}
	<p class="transcript" lang="de">„{message.de}“{#if reveal && message.en}<span lang="en"> · {message.en}</span>{/if}</p>
{/if}
{#if !reveal && !showText && left > 0}
	<button type="button" class="text-btn" onclick={openText}>Can't listen? Read it (uses 1 play)</button>
{/if}

<style>
	.note {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		min-width: 13rem;
	}
	.play {
		flex: none;
		display: grid;
		place-items: center;
		width: 2.5rem;
		height: 2.5rem;
		border-radius: 50%;
		border: none;
		background: var(--navy);
		color: #fff;
		cursor: pointer;
	}
	.play:disabled {
		background: var(--line-strong);
		cursor: default;
	}
	.playing .play {
		background: var(--terracotta);
	}
	.wave {
		flex: 1;
		display: flex;
		align-items: center;
		gap: 2px;
		height: 1.9rem;
	}
	.wave span {
		flex: 1;
		min-width: 2px;
		border-radius: 2px;
		background: var(--line-strong);
		transition: background 120ms;
	}
	.wave span.done {
		background: var(--terracotta);
	}
	.playing .wave span:not(.done) {
		animation: bob 600ms ease-in-out infinite alternate;
	}
	.wave span:nth-child(3n) {
		animation-delay: -200ms;
	}
	.wave span:nth-child(3n + 1) {
		animation-delay: -400ms;
	}
	.meta {
		flex: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
		font-variant-numeric: tabular-nums;
	}
	.spent {
		opacity: 0.7;
	}
	.transcript {
		margin: 0.4rem 0 0;
		font-size: var(--step--1);
		color: var(--ink);
	}
	.transcript span {
		color: var(--ink-muted);
	}
	.text-btn {
		margin-top: 0.3rem;
		padding: 0;
		border: none;
		background: none;
		color: var(--ink-muted);
		font-size: var(--step--1);
		text-decoration: underline;
		cursor: pointer;
	}
	@keyframes bob {
		to {
			transform: scaleY(0.55);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.playing .wave span:not(.done) {
			animation: none;
		}
	}
</style>
