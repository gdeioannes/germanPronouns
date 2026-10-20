<script lang="ts">
	// One reading stage of Die Verwandlung: the glossary first, then Kafka's
	// text with the noted phrases underlined, then the notes. Plain links all
	// the way, so it reads (and is crawled) without any script.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { LITERATURE } from '$lib/content/literature';
	import { absoluteUrl, breadcrumbLd, clip, readingStageLd } from '$lib/seo';
	import { page } from '$app/state';

	let { data } = $props();

	const book = LITERATURE.find((b) => b.id === 'kafka-verwandlung')!;
	const base = '/literature/die-verwandlung';
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const s = $derived(data.stage);
	const path = $derived(`${base}/stage-${s.n}`);
	const prev = $derived(s.n > 1 ? `${base}/stage-${s.n - 1}` : null);
	const next = $derived(s.n < data.count ? `${base}/stage-${s.n + 1}` : null);
	const description = $derived(
		clip(
			`${s.en} Kafka's original German, with ${s.glossary.length} words explained in English and ${s.notes.length} notes on the language.`,
			160
		)
	);

	function plural(pl: string | undefined): string {
		if (!pl || pl === '—') return '';
		return pl === 'pl.' ? '(plural)' : `· ${pl}`;
	}
</script>

<Seo
	title="{s.title} – Kafka, Die Verwandlung ({s.n}/{data.count})"
	{description}
	{path}
	type="article"
	image={absoluteUrl(book.cover)}
	imageAlt="Cover of {book.title}"
	jsonLd={[
		readingStageLd({
			name: s.title,
			description,
			path,
			position: s.n,
			level: book.level,
			words: s.words,
			book: { author: book.author, title: book.title, path: base }
		}),
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Literature', path: '/literature' },
			{ name: book.title, path: base },
			{ name: s.title, path }
		])
	]}
/>

<SiteNav {courseHref} compact />

<main class="page reader">
	<a class="back-link" href={base}><Icon name="arrowLeft" size="1em" /> {book.title}</a>

	<header>
		<p class="kicker">Stage {s.n} of {data.count} · Kapitel {s.chapter} · {s.words.toLocaleString('en')} words</p>
		<h1 lang="de">{s.title}</h1>
		<p class="summary">{s.en}</p>
	</header>

	<details class="gloss" open>
		<summary>Words for this stage <span>({s.glossary.length}, in the order they come up)</span></summary>
		<dl>
			{#each s.glossary as w (w.de)}
				<div>
					<dt lang="de">{w.de} <span class="pl">{plural(w.pl)}</span></dt>
					<dd>{w.en}</dd>
				</div>
			{/each}
		</dl>
	</details>

	<article class="text" lang="de">
		{#each s.paragraphs as runs, i (i)}
			<p>
				{#each runs as run, j (j)}{#if run.note}<span class="mark" id="at-{run.note}">{run.text}</span><sup><a href="#note-{run.note}" aria-label="Note {run.note}">{run.note}</a></sup>{:else}{run.text}{/if}{/each}
			</p>
		{/each}
	</article>

	{#if s.notes.length}
		<section class="notes" aria-labelledby="notes-title">
			<h2 id="notes-title">Notes on the German</h2>
			<ol>
				{#each s.notes as note (note.n)}
					<li id="note-{note.n}">
						<p class="at"><a href="#at-{note.n}" lang="de">„{note.at}"</a></p>
						<p>{@html note.html}</p>
					</li>
				{/each}
			</ol>
		</section>
	{/if}

	<nav class="pager" aria-label="Stages">
		{#if prev}
			<a href={prev}><Icon name="arrowLeft" size="1em" /> Stage {s.n - 1}</a>
		{:else}
			<span></span>
		{/if}
		<a href={base}>All stages</a>
		{#if next}
			<a class="next" href={next}>Stage {s.n + 1} <Icon name="arrowRight" size="1em" /></a>
		{:else}
			<a class="next" href="/literature">The end · back to the shelf</a>
		{/if}
	</nav>
</main>

<SiteFooter />

<style>
	.reader {
		max-width: 42rem;
	}

	.kicker {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	h1 {
		margin: 0.2rem 0 0;
	}

	.summary {
		margin: 0.4rem 0 1.2rem;
		color: var(--ink-muted);
		line-height: 1.6;
	}

	.gloss {
		padding: 0.9rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: 0.8rem;
		background: var(--surface);
	}

	.gloss summary {
		font-weight: 700;
		cursor: pointer;
	}

	.gloss summary span {
		font-weight: 400;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	dl {
		margin: 0.7rem 0 0;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(17rem, 1fr));
		gap: 0.35rem 1.4rem;
	}

	dl div {
		padding: 0.25rem 0;
		border-bottom: 1px solid var(--line);
	}

	dt {
		font-weight: 700;
	}

	.pl {
		font-weight: 400;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	dd {
		margin: 0;
		font-size: var(--step--1);
	}

	.text {
		margin-top: 1.6rem;
		font-family: var(--font-display, serif);
		font-size: 1.12rem;
		line-height: 1.75;
		hyphens: auto;
	}

	.text p {
		margin: 0 0 1rem;
	}

	.mark {
		text-decoration: underline dotted var(--accent);
		text-underline-offset: 0.2em;
	}

	sup a {
		padding: 0 0.1rem;
		color: var(--accent-ink);
		font-family: var(--font-body, sans-serif);
		font-size: 0.7rem;
		font-weight: 700;
		text-decoration: none;
	}

	.notes {
		margin-top: 2rem;
		padding-top: 1rem;
		border-top: 1px solid var(--line-strong);
	}

	.notes h2 {
		font-size: var(--step-1);
	}

	.notes ol {
		padding-left: 1.4rem;
	}

	.notes li {
		margin-bottom: 0.9rem;
		line-height: 1.55;
	}

	.notes li:target {
		background: var(--accent-soft);
		border-radius: 0.4rem;
	}

	.notes p {
		margin: 0;
	}

	.at a {
		color: var(--ink-muted);
		font-style: italic;
		text-decoration: none;
	}

	.pager {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 1rem;
		margin: 2rem 0 1rem;
		padding-top: 1rem;
		border-top: 1px solid var(--line);
	}

	.pager a {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}
</style>
