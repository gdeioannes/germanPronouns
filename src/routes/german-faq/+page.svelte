<script lang="ts">
	// German FAQ index: the questions people search about German, grouped,
	// each with its short answer. Content lives in content/germanFaq.
	import { page } from '$app/state';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { FAQ_GROUPS, GERMAN_FAQ, faqRuns, plain, searchFaq } from '$lib/content/germanFaq';
	import { breadcrumbLd, itemListLd } from '$lib/seo';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	// The search filters the list in place; with no query (and before any
	// JavaScript runs) every question shows, grouped, as prerendered.
	let query = $state('');
	const searching = $derived(query.trim().length > 0);
	const results = $derived(searchFaq(query));
</script>

{#snippet rich(text: string)}{#each faqRuns(text) as run, i (i)}{#if run.de}<i lang="de">{run.text}</i>{:else}{run.text}{/if}{/each}{/snippet}

{#snippet card(f: (typeof GERMAN_FAQ)[number])}
	<li>
		<a href="/german-faq/{f.slug}">
			<span class="q">{f.question}</span>
			<span class="a">{@render rich(f.short)}</span>
			<span class="more">Read the answer <Icon name="arrowRight" size="1em" /></span>
		</a>
	</li>
{/snippet}

<Seo
	title="German FAQ: the questions everyone asks about German | Language Quiz"
	description="Why are German nouns capitalized? Der, die or das? Why is the verb at the end? Clear answers to 36 questions learners ask about German, each with free exercises."
	path="/german-faq"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'FAQPage',
			mainEntity: GERMAN_FAQ.map((f) => ({
				'@type': 'Question',
				name: f.question,
				acceptedAnswer: { '@type': 'Answer', text: plain(f.short) }
			}))
		},
		itemListLd('German FAQ', GERMAN_FAQ.map((f) => ({ name: f.question, path: `/german-faq/${f.slug}` }))),
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'German FAQ', path: '/german-faq' }
		])
	]}
/>

<SiteNav {courseHref} />

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<header>
		<h1>German FAQ</h1>
		<p class="lede">
			Capital letters everywhere, three words for “the”, verbs that wait until the end of the
			sentence: German has a few habits that make every learner ask the same questions. Here they
			are, each with a short answer, a full explanation and free exercises to practise it.
		</p>
		<form class="search" role="search" onsubmit={(e) => e.preventDefault()}>
			<label for="faq-search" class="sr-only">Search the German FAQ</label>
			<Icon name="search" size="1.1em" />
			<input
				id="faq-search"
				type="search"
				placeholder="Search: der die das, Perfekt, ß, du or Sie…"
				autocomplete="off"
				spellcheck="false"
				bind:value={query}
			/>
		</form>
		{#if !searching}
			<nav class="jump" aria-label="Question groups">
				{#each FAQ_GROUPS as group (group.id)}
					<a href="#g-{group.id}">{group.title}</a>
				{/each}
			</nav>
		{/if}
	</header>

	<p class="sr-only" role="status" aria-live="polite">
		{#if searching}{results.length === 1 ? '1 question found' : `${results.length} questions found`}{/if}
	</p>

	{#if searching}
		<section aria-label="Search results">
			{#if results.length}
				<p class="count">{results.length === 1 ? '1 question' : `${results.length} questions`}</p>
				<ul class="questions">
					{#each results as f (f.slug)}{@render card(f)}{/each}
				</ul>
			{:else}
				<p class="none">
					No question matches “{query.trim()}”. Try a shorter word, or
					<button type="button" class="clear" onclick={() => (query = '')}>show all questions</button>.
				</p>
			{/if}
		</section>
	{:else}
		{#each FAQ_GROUPS as group (group.id)}
			<section aria-labelledby="g-{group.id}">
				<h2 id="g-{group.id}">{group.title}</h2>
				<ul class="questions">
					{#each GERMAN_FAQ.filter((f) => f.group === group.id) as f (f.slug)}{@render card(f)}{/each}
				</ul>
			</section>
		{/each}
	{/if}

	<section class="ask" aria-labelledby="ask-title">
		<h2 id="ask-title">Your question is not here?</h2>
		<p>Ask it on the forum. The questions people ask most become new pages here.</p>
		<a href="/forum"><Icon name="forum" size="1em" /> Ask on the forum</a>
	</section>
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0;
		font-size: var(--step-4);
		color: var(--heading);
	}

	.lede {
		margin: 0.6rem 0 0;
		line-height: 1.65;
	}

	.search {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin: 1.4rem 0 0;
		padding: 0 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink-muted);
	}

	.search:focus-within {
		border-color: var(--accent);
		box-shadow: 0 0 0 3px var(--accent-soft);
	}

	.search input {
		flex: 1;
		min-width: 0;
		min-height: 2.9rem;
		border: 0;
		outline: none;
		background: transparent;
		color: var(--heading);
		font: inherit;
	}

	.count,
	.none {
		margin: 1.4rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.clear {
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-weight: 700;
		text-decoration: underline;
		cursor: pointer;
	}

	.jump {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin: 1.2rem 0 0;
	}

	.jump a {
		padding: 0.35rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--heading);
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
	}

	.jump a:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	h2 {
		scroll-margin-top: 4.5rem;
		margin: 2.2rem 0 0;
		font-size: var(--step-1);
		color: var(--heading);
	}

	.questions {
		list-style: none;
		margin: 0.8rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.7rem;
	}

	.questions a {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		padding: 1rem 1.2rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		transition: border-color var(--fast) var(--ease-out);
	}

	.questions a:hover {
		border-color: var(--accent);
	}

	.q {
		font-weight: 800;
		font-size: var(--step-0);
		color: var(--heading);
	}

	.a {
		font-size: var(--step--1);
		line-height: 1.55;
		color: var(--ink-muted);
	}

	.more {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	.ask {
		margin: 2.4rem 0 0;
		padding: 1.2rem 1.4rem;
		border: 1px dashed var(--line-strong);
		border-radius: var(--radius);
	}

	.ask h2 {
		margin: 0;
	}

	.ask p {
		margin: 0.4rem 0 0;
		line-height: 1.6;
	}

	.ask a {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		margin-top: 0.8rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}
</style>
