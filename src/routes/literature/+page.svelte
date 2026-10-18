<script lang="ts">
	// Literature: classics in the original German, each annotated for English
	// speakers and free as a PDF. The list lives in content/literature.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { LITERATURE } from '$lib/content/literature';
	import { track } from '$lib/services/analytics';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title="Literature — Language Quiz"
	description="Read German classics in the original, annotated for English speakers: reading stages, glossaries before each stage and notes on the language. Free PDF."
	path="/literature"
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>

	<header>
		<h1>Literature</h1>
		<p class="lede">
			Real German books, in the words their authors wrote. Each edition splits the
			story into short reading stages, explains the hard words before you meet them,
			and notes the German worth noticing on the way.
		</p>
	</header>

	<ol class="shelf">
		{#each LITERATURE as book (book.id)}
			<li class="book" id={book.id}>
				<img class="cover" src={book.cover} alt="Cover of {book.title}" width="640" height="1024" />
				<div class="text">
					<p class="where">{book.author} · {book.year} · {book.level}</p>
					<h2 lang="de">{book.title}</h2>
					<p class="en"><i>{book.en}</i>, annotated for English speakers</p>
					<p>{book.blurb}</p>
					<ul>
						{#each book.inside as line (line)}<li>{line}</li>{/each}
					</ul>
					<a
						class="primary"
						href={book.pdf.href}
						download="{book.author} - {book.title}.pdf"
						onclick={() => track('literature_download', { book: book.id })}
					>
						<Icon name="download" size="1.05em" /> Download the free PDF
					</a>
					<p class="small">{book.pdf.pages} pages · {book.pdf.megabytes} MB · print it or read it on a tablet</p>
				</div>
			</li>
		{/each}
	</ol>

	<p class="more">More books are on the way. <a href="/contact">Tell us</a> which one you would like to read next.</p>
</main>

<SiteFooter />

<style>
	.shelf {
		list-style: none;
		margin: 1.5rem 0 0;
		padding: 0;
		display: grid;
		gap: 1.2rem;
	}

	.book {
		display: grid;
		grid-template-columns: minmax(0, 12rem) minmax(0, 1fr);
		gap: 1.6rem;
		align-items: start;
		padding: 1.4rem;
		border: 1px solid var(--line);
		border-radius: 1rem;
		background: var(--surface);
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

	h2 {
		margin: 0.2rem 0 0;
		font-size: var(--step-3);
		color: var(--heading);
	}

	.en {
		margin: 0.2rem 0 0.8rem;
		color: var(--ink-muted);
	}

	.text p {
		line-height: 1.6;
	}

	.text ul {
		margin: 0.4rem 0 1.2rem;
		padding-left: 1.2rem;
		line-height: 1.6;
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

	.small {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.more {
		margin: 2rem 0 0;
		color: var(--ink-muted);
	}

	@media (max-width: 40rem) {
		.book {
			grid-template-columns: minmax(0, 1fr);
			padding: 1rem;
		}
		.cover {
			width: min(60%, 11rem);
		}
	}
</style>
