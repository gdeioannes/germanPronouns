<script lang="ts">
	// The correction report of the November 2026 content review: every text
	// fix, grouped by where it lives, with the old and the new wording. The
	// data is src/lib/content/reviewReport.json, written by the review run;
	// this page only lays it out.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import report from '$lib/content/reviewReport.json';
	import { APP_VERSION, BOOK_EDITION } from '$lib/version';

	const CATEGORY: Record<string, string> = {
		'false-claim': 'wrong rule',
		'answer-key': 'answer key',
		spelling: 'spelling',
		grammar: 'grammar',
		unidiomatic: 'wording',
		gloss: 'English meaning',
		punctuation: 'punctuation',
		wordlist: 'word list',
		content: 'content',
		label: 'label',
		notes: 'notes'
	};
</script>

<Seo
	title="Content review, November 2026 — Language Quiz"
	description="Every correction of the November 2026 review of the German in the Language Quiz app and books, with the old and the new wording."
	path="/changelog/review-2026-11"
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page">
	<a class="back-link" href="/changelog"><Icon name="arrowLeft" size="1em" /> What's new</a>
	<h1>Content review, November 2026</h1>
	<p class="version">Version {APP_VERSION} · books: {BOOK_EDITION.label}</p>
	<p class="lede">
		The German in the whole course was read line by line: all twelve levels of the app, the twelve books, the chats,
		the games, the grammar charts and the word library. This is the list of what was changed: {report.total} corrections,
		each with the old wording, the new one and the reason. Many are small (a comma, a capital letter); some are rules
		that were stated wrongly or answer keys that accepted a wrong form. The books carry every fix in their
		{BOOK_EDITION.n}nd edition, so if you downloaded a book earlier, download it again.
	</p>

	<nav class="toc" aria-label="Sections">
		{#each report.groups as g (g.title)}
			<a href="#{g.title.replace(/[^a-z0-9]+/gi, '-').toLowerCase()}">{g.title} <small>{g.fixes.length}</small></a>
		{/each}
	</nav>

	{#each report.groups as g (g.title)}
		<section id={g.title.replace(/[^a-z0-9]+/gi, '-').toLowerCase()}>
			<h2>{g.title} <small>{g.fixes.length}</small></h2>
			<ol>
				{#each g.fixes as f, i (i)}
					<li>
						<p class="where">{f.unit} <span class="cat">{CATEGORY[f.category] ?? f.category}</span></p>
						<p class="diff">
							<del lang="de">{f.from}</del>
							{#if f.to}<ins lang="de">{f.to}</ins>{/if}
						</p>
						<p class="why">{f.reason}</p>
					</li>
				{/each}
			</ol>
		</section>
	{/each}
</main>

<SiteFooter />

<style>
	.page {
		max-width: 52rem;
		margin: 0 auto;
		padding: 1.5rem 1.25rem 4rem;
	}
	.back-link {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		font-weight: 700;
		color: var(--accent-ink);
		text-decoration: none;
	}
	h1 {
		font-family: var(--font-serif);
		font-size: clamp(1.8rem, 4vw, 2.6rem);
		margin: 1rem 0 0.25rem;
	}
	.version {
		margin: 0 0 1rem;
		font-size: 0.85rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	.lede {
		font-size: 1.05rem;
		line-height: 1.55;
		color: var(--ink-soft, var(--ink));
	}
	.toc {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin: 1.5rem 0 2rem;
	}
	.toc a {
		padding: 0.3rem 0.65rem;
		border: 1px solid var(--rule, rgba(0, 0, 0, 0.12));
		border-radius: 999px;
		font-size: 0.85rem;
		text-decoration: none;
		color: var(--ink);
	}
	.toc small,
	h2 small {
		color: var(--ink-muted);
		font-weight: 600;
		margin-left: 0.25rem;
	}
	section {
		margin-top: 2.5rem;
	}
	h2 {
		font-family: var(--font-serif);
		font-size: 1.4rem;
		border-bottom: 2px solid var(--rule, rgba(0, 0, 0, 0.12));
		padding-bottom: 0.3rem;
	}
	ol {
		list-style: none;
		padding: 0;
		margin: 0;
	}
	li {
		padding: 0.9rem 0;
		border-bottom: 1px solid var(--rule, rgba(0, 0, 0, 0.08));
	}
	li p {
		margin: 0.2rem 0;
	}
	.where {
		font-size: 0.85rem;
		font-weight: 700;
		color: var(--ink-muted);
	}
	.cat {
		margin-left: 0.5rem;
		padding: 0.05rem 0.45rem;
		border-radius: 999px;
		background: var(--surface-2, rgba(0, 0, 0, 0.05));
		font-weight: 600;
		text-transform: lowercase;
	}
	.diff {
		display: grid;
		gap: 0.25rem;
		line-height: 1.45;
	}
	del {
		color: #8a2f2f;
		text-decoration: line-through;
		text-decoration-color: rgba(138, 47, 47, 0.5);
	}
	ins {
		color: #1f6b3a;
		text-decoration: none;
		font-weight: 600;
	}
	ins::before {
		content: '→ ';
		font-weight: 400;
		color: var(--ink-muted);
	}
	.why {
		font-size: 0.92rem;
		color: var(--ink-soft, var(--ink));
	}
</style>
