<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { breadcrumbLd, shareImage } from '$lib/seo';
	// The Word Library: a search box over the shared German noun and verb
	// collections. Each hit is a link to the word's own page, where the
	// plural, cases and conjugation tables live; this page only carries the
	// index, so it stays light however many words the collections grow to.
	import Icon from '$lib/icons/Icon.svelte';
	import { GENDER_ARTICLES, GENDER_COLORS } from '$lib/domain/gender';
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
	import { vocab } from '$lib/state/vocab.svelte';
	import { page } from '$app/state';
	import { onMount } from 'svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const { nouns, verbs, decks, courseId } = $derived(data);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	// The decks' ribbons and weak-word counts come from local storage, so
	// they fill in after mount; the prerendered page shows the counts alone.
	let statsReady = $state(false);
	onMount(async () => {
		if (!progress.loaded) await progress.load(DEFAULT_GATING);
		await progress.hydrateStats(
			decks.flatMap((d) => (d.storageKeyPrefix ? [d.storageKeyPrefix] : []))
		);
		await vocab.load(courseId);
		statsReady = true;
	});

	const ribbonOf = $derived((deck: (typeof decks)[number]) =>
		statsReady && deck.quizId && deck.storageKeyPrefix
			? progress.ribbonFor('vocabulary', deck.quizId, deck.storageKeyPrefix)
			: null
	);
	const weakOf = $derived((deck: (typeof decks)[number]) =>
		statsReady && deck.quizId ? vocab.weakCountFor(courseId, deck.quizId) : 0
	);
	const ready = $derived(decks.filter((d) => d.quizId).length);

	let tab = $state<'nouns' | 'verbs'>('nouns');
	let search = $state('');

	const q = $derived(search.trim().toLowerCase());
	const filteredNouns = $derived(
		nouns.filter(
			(n) => !q || n.noun.toLowerCase().includes(q) || n.english.toLowerCase().includes(q)
		)
	);
	const filteredVerbs = $derived(
		verbs.filter(
			(v) => !q || v.verb.toLowerCase().includes(q) || v.english.toLowerCase().includes(q)
		)
	);
</script>

<Seo
	title="German nouns & verbs with gender, plural and conjugation | Language Quiz"
	description="Every German noun and verb in the course: der, die or das, plural forms and full conjugation tables, each with audio. Free, no sign-up."
	path="/words"
	image={shareImage('words', 'nouns')}
	imageAlt="German nouns with their articles and plurals"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Word Library', path: '/words' }
		])
	]}
/>

<SiteNav {courseHref} compact />

<main class="page-wide">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>
	<h1>Word Library</h1>
	<p class="lede">
		Search the course's German words. Or browse <a href="/words/nouns">all {nouns.length} nouns by
		theme</a> and <a href="/words/verbs">all {verbs.length} verbs</a>.
	</p>

	<!-- Flashcards first: the fastest way to actually learn the words below. -->
	<section class="decks" aria-labelledby="decks-head">
		<div class="decks-head">
			<h2 id="decks-head"><Icon name="cards" size="1.1em" /> Flashcards by module</h2>
			<p>
				Every word a module uses, as cards: write the German with its article, choose it from
				four, or flip and rate yourself. Missed words come back as weak words.
			</p>
		</div>
		<ol class="deck-grid">
			{#each decks as deck (deck.level)}
				{@const ribbon = ribbonOf(deck)}
				{@const weak = weakOf(deck)}
				<li>
					{#if deck.quizId}
						<a class="deck" href="/course/{courseId}/quiz/{deck.quizId}">
							<span class="deck-level tnum">{deck.level}</span>
							<span class="deck-title">{deck.title}</span>
							<span class="deck-meta tnum">{deck.cards} cards · {deck.nouns} nouns</span>
							{#if weak > 0}
								<span class="deck-weak tnum"><Icon name="flame" size="0.9em" /> {weak} weak</span>
							{/if}
							{#if ribbon}
								<span class="deck-ribbon"><RibbonBadge tier={ribbon} /></span>
							{/if}
							<Icon name="arrowRight" size="1em" class="deck-go" />
						</a>
					{:else}
						<span class="deck soon">
							<span class="deck-level tnum">{deck.level}</span>
							<span class="deck-title">{deck.title}</span>
							<span class="deck-meta">deck coming</span>
						</span>
					{/if}
				</li>
			{/each}
		</ol>
		{#if ready < decks.length}
			<p class="decks-note">{ready} of {decks.length} module decks are ready; the rest are being built.</p>
		{/if}
	</section>

	<h2 class="library-head">Look a word up</h2>

	<div class="tabs" role="tablist">
		<button role="tab" aria-selected={tab === 'nouns'} onclick={() => (tab = 'nouns')}>
			Nouns ({nouns.length})
		</button>
		<button role="tab" aria-selected={tab === 'verbs'} onclick={() => (tab = 'verbs')}>
			Verbs ({verbs.length})
		</button>
	</div>

	<div class="search">
		<Icon name="search" size="1.05em" />
		<input bind:value={search} placeholder="Search nouns and verbs…" type="search" />
	</div>

	{#if tab === 'nouns'}
		<ul class="grid">
			{#each filteredNouns as noun (noun.slug)}
				<li>
					<a class="word" href="/words/nouns/{noun.slug}">
						{#if noun.image}
							<img class="thumb" src={noun.image} alt="" width="512" height="512" loading="lazy" />
						{/if}
						<span class="article" style="color:{GENDER_COLORS[noun.gender]}">
							{GENDER_ARTICLES[noun.gender] ?? ''}
						</span>
						<span class="term" lang="de">{noun.noun}</span>
						<span class="gloss">{noun.english}</span>
					</a>
				</li>
			{/each}
		</ul>
	{:else}
		<ul class="grid">
			{#each filteredVerbs as verb (verb.slug)}
				<li>
					<a class="word" href="/words/verbs/{verb.slug}">
						<span class="term" lang="de">{verb.verb}</span>
						<span class="gloss">{verb.english}</span>
					</a>
				</li>
			{/each}
		</ul>
	{/if}
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.5rem;
	}

	.lede {
		margin: 0 0 1.25rem;
		color: var(--ink-muted);
	}

	/* -- Flashcard decks ---------------------------------------------------- */

	.decks {
		margin: 0 0 2.25rem;
	}

	.decks-head h2 {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		margin: 0 0 0.35rem;
		font-size: var(--step-1);
	}

	.decks-head p {
		margin: 0 0 1rem;
		max-width: var(--measure);
		color: var(--ink-muted);
	}

	.deck-grid {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.6rem;
		grid-template-columns: repeat(auto-fill, minmax(13.5rem, 1fr));
	}

	.deck {
		position: relative;
		display: grid;
		grid-template-columns: 1fr auto;
		grid-template-areas:
			'level ribbon'
			'title ribbon'
			'meta go'
			'weak go';
		gap: 0.15rem 0.6rem;
		min-height: 6.5rem;
		padding: 0.9rem 1rem 0.9rem 1.1rem;
		border: 1px solid var(--line-strong);
		border-left: 5px solid #a33a63;
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		box-shadow: 0 3px 10px rgb(31 58 95 / 0.05);
		transition:
			transform var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	a.deck:hover {
		transform: translateY(-2px);
		box-shadow: 0 10px 22px rgb(31 58 95 / 0.1);
	}

	.deck.soon {
		border-left-color: var(--outline);
		background: var(--surface-alt);
		color: var(--ink-muted);
		box-shadow: none;
	}

	.deck-level {
		grid-area: level;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.1em;
		color: #a33a63;
	}

	.deck.soon .deck-level {
		color: var(--ink-muted);
	}

	.deck-title {
		grid-area: title;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 700;
		letter-spacing: 0.02em;
		color: var(--heading);
	}

	.deck.soon .deck-title {
		color: var(--ink-muted);
	}

	.deck-meta {
		grid-area: meta;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.deck-weak {
		grid-area: weak;
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent);
	}

	.deck-ribbon {
		grid-area: ribbon;
		align-self: start;
	}

	.deck :global(.deck-go) {
		grid-area: go;
		align-self: end;
		color: var(--outline);
		transition: color var(--fast) var(--ease-out);
	}

	a.deck:hover :global(.deck-go) {
		color: var(--accent);
	}

	.decks-note {
		margin: 0.75rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.library-head {
		margin: 0 0 0.75rem;
		font-size: var(--step-1);
	}

	.tabs {
		display: flex;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}

	.tabs button {
		padding: 0.45rem 1.1rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		font-size: var(--step--1);
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.tabs button[aria-selected='true'] {
		background: var(--navy);
		border-color: var(--navy);
		color: #fff;
	}

	.search {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		padding: 0.15rem 0.9rem;
		margin-bottom: 1.25rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink-muted);
		transition:
			border-color var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	.search:focus-within {
		border-color: var(--accent);
		box-shadow: 0 0 0 3px var(--accent-soft);
	}

	.search input {
		flex: 1;
		min-width: 0;
		padding: 0.55rem 0;
		border: 0;
		background: none;
		font: inherit;
		color: var(--ink);
	}

	.search input:focus {
		outline: none;
	}

	.grid {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.4rem;
		grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
		align-items: start;
	}

	.word {
		display: flex;
		align-items: baseline;
		gap: 0.45rem;
		width: 100%;
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		transition:
			border-color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.word:hover {
		border-color: var(--accent);
		transform: translateY(-1px);
	}

	/* The word's picture, small and round, on its own cream disc. */
	.thumb {
		width: 2.4rem;
		height: 2.4rem;
		flex: none;
		align-self: center;
		margin: -0.25rem 0.1rem -0.25rem -0.2rem;
		border-radius: 50%;
		background: #fbf5e4;
		object-fit: cover;
	}

	.article {
		font-weight: 700;
		font-size: 0.85rem;
	}

	/* The German word is the content; its gloss is interface. */
	.term {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 700;
		color: var(--ink);
	}

	.gloss {
		margin-left: auto;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
</style>
