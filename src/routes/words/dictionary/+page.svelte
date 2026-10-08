<script lang="ts">
	// The function words, A–Z: the pronouns, prepositions, conjunctions and
	// particles that hold a German sentence together.
	//
	// These are the words the app now lets you tap in any exercise, and they are
	// the ones no vocabulary list teaches — "doch" and "sich" are not in anyone's
	// deck, and they are in every sentence. Listing them in the prerendered HTML
	// also means the meanings are in the page a crawler reads, not only in a
	// panel that opens on a tap.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import { breadcrumbLd, shareImage } from '$lib/seo';
	import { page } from '$app/state';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	let query = $state('');

	// Filtering on both sides: a learner looks a German word up, and also asks
	// "which word means 'although'?".
	const groups = $derived.by(() => {
		const needle = query.trim().toLowerCase();
		if (!needle) return data.groups;
		return data.groups
			.map((group) => ({
				...group,
				words: group.words.filter(
					(w) => w.de.toLowerCase().includes(needle) || w.en.toLowerCase().includes(needle)
				)
			}))
			.filter((group) => group.words.length);
	});

	const hits = $derived(groups.reduce((sum, group) => sum + group.words.length, 0));
</script>

<Seo
	title="German function words A–Z: {data.total} pronouns, prepositions and particles | Language Quiz"
	description="Every German function word in the course with its English meaning: pronouns, articles, prepositions, conjunctions, adverbs and the particles like doch and mal that no vocabulary list teaches. Free, no sign-up."
	path="/words/dictionary"
	image={shareImage('words', 'dictionary')}
	imageAlt="German function words with their English meanings"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Word Library', path: '/words' },
			{ name: 'Dictionary', path: '/words/dictionary' }
		])
	]}
/>

<SiteNav {courseHref} compact />

<main class="page-wide">
	<a class="back-link" href="/words"><Icon name="arrowLeft" size="1em" /> Word Library</a>
	<h1>The small words, A–Z</h1>
	<p class="lede">
		{data.total} German words that are not nouns or verbs — the pronouns, prepositions,
		conjunctions and particles that hold a sentence together. These are the words that make
		German hard to read and that no vocabulary deck teaches, so each one is glossed the way a
		learner needs it rather than the way a translator would: <strong>doch</strong> is not a word
		English has, and <strong>der</strong> is four different cases wearing one spelling. You can
		tap any of them inside an exercise too — turn on <a href="/settings">Word help</a>.
		For nouns and verbs, with their plurals, cases and conjugations, see
		<a href="/words/nouns">the nouns</a> and <a href="/words/verbs">the verbs</a>.
	</p>

	<label class="search">
		<Icon name="search" size="1em" />
		<input
			type="search"
			bind:value={query}
			placeholder="Search German or English — doch, although, dative…"
			aria-label="Search the dictionary"
		/>
	</label>

	{#if query.trim()}
		<p class="count" aria-live="polite">{hits} {hits === 1 ? 'word' : 'words'}</p>
	{:else}
		<nav class="letters" aria-label="Letters">
			{#each data.groups as group (group.letter)}
				<a href="#letter-{group.letter}">{group.letter}</a>
			{/each}
		</nav>
	{/if}

	{#each groups as group (group.letter)}
		<section id="letter-{group.letter}">
			<h2>{group.letter}</h2>
			<dl>
				{#each group.words as word (word.de)}
					<div class="entry">
						<dt lang="de">
							{word.de}
							<SpeakButton text={word.de} locale="de-DE" label="Listen to {word.de}" />
							<span class="pos" lang="en">{word.pos}</span>
						</dt>
						<dd lang="en">{word.en}</dd>
					</div>
				{/each}
			</dl>
		</section>
	{/each}

	{#if !groups.length}
		<p class="empty">Nothing matches “{query}”. The nouns and verbs live on their own pages: <a
				href="/words/nouns">nouns</a
			>, <a href="/words/verbs">verbs</a>.</p>
	{/if}
</main>

<SiteFooter />

<style>
	.lede {
		max-width: 60ch;
		color: var(--ink-muted);
	}

	.search {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		max-width: 32rem;
		margin: 1.5rem 0 0.5rem;
		padding: 0.6rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: 12px;
		background: var(--surface);
		color: var(--ink-muted);
	}

	.search input {
		flex: 1;
		min-width: 0;
		border: 0;
		background: none;
		font: inherit;
		color: var(--ink);
	}

	.search input:focus {
		outline: none;
	}

	.search:focus-within {
		border-color: var(--accent-ink);
	}

	.count {
		color: var(--ink-muted);
		font-size: 0.85rem;
	}

	.letters {
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem;
		margin: 0.5rem 0 1.5rem;
	}

	.letters a {
		min-width: 2rem;
		padding: 0.25rem 0.4rem;
		border: 1px solid var(--line);
		border-radius: 8px;
		text-align: center;
		text-decoration: none;
		font-weight: 700;
	}

	section {
		margin-top: 2rem;
		scroll-margin-top: 1rem;
	}

	h2 {
		margin: 0 0 0.5rem;
		padding-bottom: 0.3rem;
		border-bottom: 2px solid var(--line);
	}

	dl {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(min(100%, 20rem), 1fr));
		gap: 0.1rem 2rem;
		margin: 0;
	}

	.entry {
		padding: 0.45rem 0;
		border-bottom: 1px solid var(--line);
	}

	dt {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		font-weight: 800;
	}

	.pos {
		font-size: 0.7rem;
		font-weight: 400;
		font-variant: all-small-caps;
		letter-spacing: 0.06em;
		color: var(--ink-muted);
	}

	dd {
		margin: 0.1rem 0 0;
		color: var(--ink-muted);
		font-size: 0.92rem;
	}

	.empty {
		margin-top: 2rem;
		color: var(--ink-muted);
	}
</style>
