<script lang="ts">
	// One German FAQ question: the plain answer first (what a search result
	// quotes), then the full explanation, then the course exercises that
	// drill it and other material that helps. Content lives in content/germanFaq.
	import { page } from '$app/state';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { faqHref, findFaq, faqRuns, plain, quizLevel } from '$lib/content/germanFaq';
	import { ORGANIZATION, absoluteUrl, breadcrumbLd, clip, titleWithSite } from '$lib/seo';

	let { data } = $props();

	const faq = $derived(findFaq(data.slug)!);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const path = $derived(`/german-faq/${faq.slug}`);
	const related = $derived(faq.related.map((s) => findFaq(s)).filter((f) => !!f));
</script>

{#snippet rich(text: string)}{#each faqRuns(text) as run, i (i)}{#if run.de}<i lang="de">{run.text}</i>{:else}{run.text}{/if}{/each}{/snippet}

<Seo
	title={titleWithSite(faq.title ?? faq.question)}
	description={clip(plain(faq.short))}
	{path}
	type="article"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'Article',
			headline: faq.question,
			description: plain(faq.short),
			url: absoluteUrl(path),
			inLanguage: 'en',
			about: { '@type': 'Thing', name: 'German language' },
			isAccessibleForFree: true,
			author: ORGANIZATION,
			publisher: ORGANIZATION
		},
		{
			'@context': 'https://schema.org',
			'@type': 'FAQPage',
			mainEntity: [
				{
					'@type': 'Question',
					name: faq.question,
					acceptedAnswer: { '@type': 'Answer', text: plain(faq.short) }
				}
			]
		},
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'German FAQ', path: '/german-faq' },
			{ name: faq.question, path }
		])
	]}
/>

<SiteNav {courseHref} />

<main class="page">
	<a class="back-link" href="/german-faq"><Icon name="arrowLeft" size="1em" /> German FAQ</a>

	<article>
		<h1>{faq.question}</h1>

		<section class="short" aria-labelledby="short-title">
			<h2 id="short-title">Short answer</h2>
			<p>{@render rich(faq.short)}</p>
		</section>

		<div class="body">
			{#each faq.body as block, b (b)}
				{#if block.h}<h2>{block.h}</h2>{/if}
				{#each block.p ?? [] as para, i (i)}<p>{@render rich(para)}</p>{/each}
				{#if block.table}
					<div class="table-wrap">
						<table>
							<thead>
								<tr>{#each block.table.head as cell, i (i)}<th scope="col">{cell}</th>{/each}</tr>
							</thead>
							<tbody>
								{#each block.table.rows as row, r (r)}
									<tr>
										{#each row as cell, i (i)}
											{#if i === 0}<th scope="row">{@render rich(cell)}</th>{:else}<td>{@render rich(cell)}</td>{/if}
										{/each}
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				{/if}
				{#if block.examples}
					<ul class="examples">
						{#each block.examples as ex, i (i)}
							<li><span lang="de">{ex.de}</span><span class="en">{ex.en}</span></li>
						{/each}
					</ul>
				{/if}
				{#if block.list}
					<ul class="rules">
						{#each block.list as item, i (i)}<li>{@render rich(item)}</li>{/each}
					</ul>
				{/if}
			{/each}
		</div>
	</article>

	<section class="practice" aria-labelledby="practice-title">
		<h2 id="practice-title">Practise it</h2>
		<p>Free exercises from the course, with audio and an explanation for every mistake.</p>
		<ul>
			{#each faq.practice as p (p.quiz)}
				<li>
					<a href="{courseHref}/quiz/{p.quiz}">
						<span class="level">{quizLevel(p.quiz)}</span>
						<span>{p.label}</span>
						<Icon name="arrowRight" size="1em" />
					</a>
				</li>
			{/each}
		</ul>
	</section>

	{#if faq.more.length}
		<section class="more" aria-labelledby="more-title">
			<h2 id="more-title">More help on this site</h2>
			<ul>
				{#each faq.more as m (m.href)}
					<li>
						<a href={faqHref(m.href, courseHref)}>{m.label}</a>
						<span class="note">{m.note}</span>
					</li>
				{/each}
			</ul>
		</section>
	{/if}

	{#if related.length}
		<section class="related" aria-labelledby="related-title">
			<h2 id="related-title">More questions people ask</h2>
			<ul>
				{#each related as r (r.slug)}
					<li><a href="/german-faq/{r.slug}">{r.question}</a></li>
				{/each}
			</ul>
			<a class="all" href="/german-faq">All German FAQ questions</a>
		</section>
	{/if}
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 1.2rem;
		font-size: var(--step-4);
		line-height: 1.15;
		color: var(--heading);
	}

	h2 {
		font-size: var(--step-1);
		color: var(--heading);
	}

	p,
	li {
		line-height: 1.65;
	}

	.short {
		padding: 1.1rem 1.3rem;
		border-inline-start: 4px solid var(--accent);
		border-radius: var(--radius-sm);
		background: var(--surface);
	}

	.short h2 {
		margin: 0 0 0.3rem;
		font-size: var(--step--1);
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.short p {
		margin: 0;
		font-size: var(--step-1);
		line-height: 1.55;
		color: var(--heading);
	}

	.body {
		margin: 1.6rem 0 0;
	}

	.body h2 {
		margin: 1.8rem 0 0.3rem;
		font-size: var(--step-1);
	}

	.body p {
		margin: 0.5rem 0 0;
	}

	.table-wrap {
		margin: 0.8rem 0 0;
		overflow-x: auto;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		font-size: var(--step--1);
	}

	th,
	td {
		padding: 0.5rem 0.65rem;
		border-bottom: 1px solid var(--line);
		text-align: start;
		vertical-align: top;
		line-height: 1.5;
	}

	thead th {
		color: var(--ink-muted);
		font-weight: 700;
		border-bottom-color: var(--line-strong);
	}

	tbody th {
		font-weight: 700;
		color: var(--heading);
	}

	.examples {
		list-style: none;
		margin: 0.8rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.5rem;
	}

	.examples li {
		display: flex;
		flex-direction: column;
		padding: 0.55rem 0.85rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.examples [lang='de'] {
		font-weight: 700;
		color: var(--heading);
	}

	.examples .en {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.rules {
		margin: 0.6rem 0 0;
		padding-inline-start: 1.2rem;
	}

	.practice,
	.more,
	.related {
		margin: 2.4rem 0 0;
		padding: 1.2rem 1.4rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.practice h2,
	.more h2,
	.related h2 {
		margin: 0;
	}

	.more {
		margin-top: 1rem;
	}

	.more ul {
		list-style: none;
		margin: 0.7rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.6rem;
	}

	.more li {
		display: flex;
		flex-direction: column;
	}

	.more a {
		color: var(--accent-ink);
		font-weight: 700;
	}

	.more .note {
		font-size: var(--step--1);
		color: var(--ink-muted);
		line-height: 1.5;
	}

	.level {
		flex: none;
		min-width: 2.6rem;
		padding: 0.1rem 0.4rem;
		border-radius: 4px;
		background: var(--accent-soft);
		font-size: 0.75rem;
		font-weight: 800;
		text-align: center;
	}

	.practice > p {
		margin: 0.3rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.practice ul,
	.related ul {
		list-style: none;
		margin: 0.7rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.35rem;
	}

	.practice a {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	.related a {
		color: var(--accent-ink);
		font-weight: 600;
	}

	.related .all {
		display: inline-block;
		margin-top: 0.9rem;
		font-size: var(--step--1);
	}

	@media (max-width: 40rem) {
		h1 {
			font-size: var(--step-3);
		}
		.short p {
			font-size: var(--step-0);
		}
	}
</style>
