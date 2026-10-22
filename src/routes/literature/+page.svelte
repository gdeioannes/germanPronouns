<script lang="ts">
	// Literature: classics in the original German, each annotated for English
	// speakers and free as a PDF. The list lives in content/literature.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { LITERATURE, bookRequestHref, bookRequestRule } from '$lib/content/literature';
	import { track } from '$lib/services/analytics';
	import { bookLd, breadcrumbLd, itemListLd } from '$lib/seo';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title="German classics annotated for English speakers, free PDF"
	description="Read German classics in the original, like Kafka's Die Verwandlung, annotated for English speakers: reading stages, glossaries and notes on the language. Free PDF."
	path="/literature"
	jsonLd={[
		...LITERATURE.map(bookLd),
		itemListLd('Literature shelf', LITERATURE.map((b) => ({ name: `${b.author}: ${b.title}`, path: `/literature#${b.id}` }))),
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Literature', path: '/literature' }])
	]}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<header>
		<h1>Literature</h1>
		<p class="lede">
			Real German books, in the words their authors wrote. Each edition splits the
			story into short reading stages, explains the hard words beside the line they are on,
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
					<div class="actions">
						{#if book.read}
							<a class="primary" href={book.read}><Icon name="book" size="1.05em" /> Read it online</a>
						{/if}
						<a
							class={book.read ? 'secondary' : 'primary'}
							href={book.pdf.href}
							download="{book.author} - {book.title}.pdf"
							onclick={() => track('literature_download', { book: book.id })}
						>
							<Icon name="download" size="1.05em" /> Download the free PDF
						</a>
					</div>
					<p class="small">{book.pdf.pages} pages · {book.pdf.megabytes} MB · print it or read it on a tablet</p>
					{#if book.store}
						<p class="store">
							Also as a printed book or on Kindle, on {book.store.name}:
							{#each book.store.editions as e, i (e.format)}{i ? ' · ' : ''}<a
									href={e.href}
									target="_blank"
									rel="noopener"
									onclick={() => track('literature_store', { book: book.id, format: e.format })}>{e.format}</a
								>{/each}
						</p>
					{/if}
				</div>
			</li>
		{/each}
	</ol>

	<!-- Requests go to one forum topic, so readers see and back each other's picks. -->
	<section class="request" aria-labelledby="request-title">
		<h2 id="request-title">Which book next?</h2>
		<p>
			More books are on the way. Ask for the one you would like to read on the forum, or
			back someone else's pick.
		</p>
		<p class="rule">{bookRequestRule()}</p>
		<a class="request-link" href={bookRequestHref()}>
			<Icon name="forum" size="1em" /> Ask for a book on the forum
		</a>
	</section>
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

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem 1.2rem;
		align-items: center;
	}

	.secondary {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	.small {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.store {
		margin: 0.4rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.store a {
		color: var(--accent-ink);
		font-weight: 700;
	}

	.request {
		margin: 2rem 0 0;
		padding: 1.2rem 1.4rem;
		border: 1px dashed var(--line-strong);
		border-radius: 1rem;
	}

	.request h2 {
		font-size: var(--step-1);
	}

	.request p {
		margin: 0.5rem 0 0;
		line-height: 1.6;
	}

	.request .rule {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.request-link {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		margin-top: 0.9rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
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
