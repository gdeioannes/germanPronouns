<script lang="ts">
	// Songs: the shelf of sing-alongs. The menu's "Songs" lands here, so the
	// learner picks a song instead of being dropped into the first one. Each
	// row plays its song in place (one shared player, one song at a time) and
	// links to the song's page with the lyrics. The list comes from the
	// registry, like the deck's song cards.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { markSongHeard, SONGS, songHeard, type Song } from '$lib/domain/songs';
	import { announce } from '$lib/a11y.svelte';
	import { ORGANIZATION, absoluteUrl, breadcrumbLd } from '$lib/seo';
	import { onMount } from 'svelte';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	// "Heard" lives in localStorage, so it shows only after mount.
	let heard = $state<Set<string>>(new Set());
	onMount(() => {
		heard = new Set(SONGS.filter((s) => songHeard(s.id)).map((s) => s.id));
	});

	let audio: HTMLAudioElement | undefined = $state();
	let current = $state<Song | null>(null);
	let playing = $state(false);

	function toggle(song: Song) {
		if (!audio) return;
		if (current?.id === song.id) {
			if (audio.paused) void audio.play();
			else audio.pause();
			return;
		}
		current = song;
		audio.src = song.audio;
		void audio.play().catch(() => {});
		announce(`Playing ${song.title}`);
	}

	// Played to the end counts as heard, like on the song's own page.
	function onEnded() {
		playing = false;
		if (!current) return;
		markSongHeard(current.id, true);
		heard = new Set([...heard, current.id]);
	}
</script>

<Seo
	title="German songs for beginners: sing-alongs | Language Quiz"
	description="Funny German sing-along raps with lyrics and translations: say who you are, learn der, die, das, and ask when you don't understand. Free, with audio."
	path="/songs"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'CollectionPage',
			name: 'German sing-alongs',
			url: absoluteUrl('/songs'),
			inLanguage: ['en', 'de'],
			isAccessibleForFree: true,
			publisher: ORGANIZATION
		},
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Songs', path: '/songs' }])
	]}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<header>
		<h1>Songs</h1>
		<p class="lede">
			Max lands in Berlin with almost no German and sings his way through it.
			Each song has the recording, the lyrics and the English for every German
			line: no score, no medal, just sing along.
		</p>
	</header>

	<audio
		bind:this={audio}
		preload="none"
		onplay={() => (playing = true)}
		onpause={() => (playing = false)}
		onended={onEnded}
	></audio>

	<ol class="shelf">
		{#each SONGS as song (song.id)}
			{@const on = current?.id === song.id && playing}
			<li class="card" class:on>
				<button
					type="button"
					class="disc"
					onclick={() => toggle(song)}
					aria-label="{on ? 'Pause' : 'Play'} {song.title}"
					aria-pressed={on}
				>
					<Icon name={on ? 'pause' : 'play'} size="1.6em" />
				</button>
				<a class="text" href={song.href}>
					<span class="where tnum">
						{song.level} · Sing-along{#if heard.has(song.id)}<span class="heard"> · Heard</span>{/if}
					</span>
					<strong lang="de">{song.title}</strong>
					<span class="tag">{song.tagline}</span>
					<span class="lyrics">Lyrics and translation →</span>
				</a>
			</li>
		{/each}
	</ol>
</main>

<SiteFooter />

<style>
	.shelf {
		list-style: none;
		margin: 1.5rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.9rem;
	}

	.card {
		display: grid;
		grid-template-columns: 5rem 1fr;
		align-items: center;
		gap: 1rem;
		padding: 0.8rem 1rem;
		border: 1px solid var(--line);
		border-radius: 1rem;
		background: var(--surface);
		transition: border-color var(--fast) var(--ease-out);
	}

	.card:hover,
	.card.on {
		border-color: var(--line-strong);
	}

	.disc {
		display: grid;
		place-items: center;
		aspect-ratio: 1;
		width: 100%;
		border: 0;
		border-radius: 50%;
		background: var(--accent);
		color: var(--surface);
		cursor: pointer;
	}

	.text {
		display: grid;
		gap: 0.15rem;
		color: inherit;
		text-decoration: none;
	}

	.lyrics {
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--accent-ink);
	}

	.text:hover .lyrics {
		text-decoration: underline;
	}

	.where {
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	.heard {
		color: var(--ink-muted);
	}

	.text strong {
		font-size: var(--step-1);
		color: var(--heading);
	}

	.tag {
		color: var(--ink-muted);
	}

	@media (max-width: 40rem) {
		.card {
			grid-template-columns: 3.5rem 1fr;
			gap: 0.7rem;
		}
		.text strong {
			font-size: var(--step-0);
		}
	}
</style>
