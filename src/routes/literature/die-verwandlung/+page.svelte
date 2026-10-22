<script lang="ts">
	// Die Verwandlung read online: the twelve stages, the 1917 spelling guide,
	// and the PDF for those who would rather print it. Same stages as the book.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { LITERATURE } from '$lib/content/literature';
	import { track } from '$lib/services/analytics';
	import { absoluteUrl, breadcrumbLd, readingBookLd } from '$lib/seo';
	import { page } from '$app/state';

	let { data } = $props();

	const book = LITERATURE.find((b) => b.id === 'kafka-verwandlung')!;
	const path = '/literature/die-verwandlung';
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const totalWords = $derived(data.stages.reduce((sum, s) => sum + s.words, 0));
	const minutes = (words: number) => Math.max(5, Math.round(words / 90 / 5) * 5);
</script>

<Seo
	title="Die Verwandlung in German with English notes, free online"
	description="Read Kafka's Die Verwandlung in the original German, in twelve short stages, with the hard words explained in English and notes on the grammar as you read."
	{path}
	type="article"
	image={absoluteUrl(book.cover)}
	imageAlt="Cover of {book.title}"
	jsonLd={[
		readingBookLd(
			book,
			path,
			data.stages.map((s) => ({ name: s.title, path: `${path}/stage-${s.n}` }))
		),
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Literature', path: '/literature' },
			{ name: book.title, path }
		])
	]}
/>

<SiteNav {courseHref} />

<main class="page">
	<a class="back-link" href="/literature"><Icon name="arrowLeft" size="1em" /> Literature</a>

	<header class="head">
		<img class="cover" src={book.cover} alt="Cover of {book.title}" width="640" height="1024" />
		<div>
			<p class="where">{book.author} · {book.year} · {book.level}</p>
			<h1><span lang="de">{book.title}</span></h1>
			<p class="en"><i>{book.en}</i> in the original German, with English notes</p>
			<p>{book.blurb}</p>
			<p>
				The whole story is here, about {totalWords.toLocaleString('en')} words in twelve stages.
				Each stage starts with the words you are unlikely to know, explained in English;
				underlined phrases in the text have a note on the German below it.
			</p>
			<div class="actions">
				<a class="primary" href="{path}/stage-1">Start reading <Icon name="arrowRight" size="1em" /></a>
				<a
					class="ghost"
					href={book.pdf.href}
					download="{book.author} - {book.title}.pdf"
					onclick={() => track('literature_download', { book: book.id, from: 'reader' })}
				>
					<Icon name="download" size="1em" /> PDF to print ({book.pdf.pages} pages)
				</a>
			</div>
			{#if book.store}
				<p class="store">
					Also as a printed book or on Kindle, on {book.store.name}:
					{#each book.store.editions as e, i (e.format)}{i ? ' · ' : ''}<a
							href={e.href}
							target="_blank"
							rel="noopener"
							onclick={() => track('literature_store', { book: book.id, format: e.format, from: 'reader' })}
							>{e.format}</a
						>{/each}
				</p>
			{/if}
		</div>
	</header>

	<section aria-labelledby="stages-title">
		<h2 id="stages-title">The twelve stages</h2>
		<ol class="stages">
			{#each data.stages as s (s.n)}
				<li>
					<a href="{path}/stage-{s.n}">
						<span class="num">{s.n}</span>
						<span class="body">
							<span class="title" lang="de">{s.title}</span>
							<span class="sum">{s.en}</span>
							<span class="meta">Kapitel {s.chapter} · {s.words.toLocaleString('en')} words · about {minutes(s.words)} min</span>
						</span>
					</a>
				</li>
			{/each}
		</ol>
	</section>

	<section class="guide" aria-labelledby="guide-title">
		<h2 id="guide-title">Before you start: the German of 1917</h2>
		<p>
			The text keeps the spelling it was printed in. Most of the difference is <i lang="de">ß</i>
			where today's German writes <i lang="de">ss</i>:
		</p>
		<table>
			<thead><tr><th scope="col">1917</th><th scope="col">Today</th></tr></thead>
			<tbody>
				{#each data.spelling as [then, now] (then)}
					<tr><td lang="de">{then}</td><td lang="de">{now}</td></tr>
				{/each}
			</tbody>
		</table>
		<p>{data.regional}</p>
	</section>

	<p class="credit">
		Kafka's text is in the public domain. It follows the 1917 Kurt Wolff edition, in the
		transcription by Jana Srna, Alexander Bauer and the Online Distributed Proofreading Team.
		The stages, glossaries and notes are Language Quiz's own, prepared with the help of AI
		tools and reviewed by the editor.
	</p>
</main>

<SiteFooter />

<style>
	.head {
		display: grid;
		grid-template-columns: minmax(0, 11rem) minmax(0, 1fr);
		gap: 1.6rem;
		align-items: start;
		margin: 0.5rem 0 2rem;
	}

	.cover {
		width: 100%;
		height: auto;
		border-radius: 4px;
		box-shadow:
			0 20px 36px -22px rgba(31, 58, 95, 0.6),
			0 0 0 1px rgba(31, 58, 95, 0.08);
	}

	.where {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	h1 {
		margin: 0.2rem 0 0;
	}

	.en {
		margin: 0.2rem 0 0.8rem;
		color: var(--ink-muted);
	}

	.head p {
		line-height: 1.6;
	}

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem 1.2rem;
		align-items: center;
		margin-top: 1rem;
	}

	.store {
		margin: 0.8rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.store a {
		color: var(--accent-ink);
		font-weight: 700;
	}

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.8rem 1.4rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-weight: 700;
		text-decoration: none;
	}

	.ghost {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	h2 {
		font-size: var(--step-1);
		color: var(--heading);
	}

	.stages {
		list-style: none;
		margin: 0.8rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.5rem;
	}

	.stages a {
		display: flex;
		gap: 1rem;
		padding: 0.9rem 1rem;
		border: 1px solid var(--line);
		border-radius: 0.8rem;
		background: var(--surface);
		color: inherit;
		text-decoration: none;
	}

	.stages a:hover {
		border-color: var(--accent);
	}

	.num {
		flex: none;
		width: 2rem;
		font-family: var(--font-display, serif);
		font-size: var(--step-2);
		line-height: 1;
		color: var(--accent-ink);
	}

	.body {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
		min-width: 0;
	}

	.title {
		font-weight: 700;
		color: var(--heading);
	}

	.sum {
		line-height: 1.5;
	}

	.meta {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.guide {
		margin-top: 2rem;
	}

	.guide p {
		line-height: 1.6;
	}

	table {
		border-collapse: collapse;
		margin: 0.6rem 0;
	}

	th,
	td {
		padding: 0.35rem 1.2rem 0.35rem 0;
		border-bottom: 1px solid var(--line);
		text-align: left;
	}

	th {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.credit {
		margin-top: 2rem;
		font-size: var(--step--1);
		line-height: 1.6;
		color: var(--ink-muted);
	}

	@media (max-width: 40rem) {
		.head {
			grid-template-columns: minmax(0, 1fr);
		}
		.cover {
			width: min(50%, 9rem);
		}
	}
</style>
