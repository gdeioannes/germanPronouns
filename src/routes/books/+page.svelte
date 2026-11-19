<script lang="ts">
	import { feedback } from '$lib/state/feedback.svelte';
	import { t } from '$lib/i18n/t';
	// The books: all twelve levels in one list, each with "Read online" and the
	// free PDF. The list itself lives in content/books, shared with the home
	// page's shelf.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { BOOKS, BOOK_PAGES, bookCover, bookMb, bookPdf, bookReadHref, hasLocalPdf } from '$lib/content/books';
	import { lang } from '$lib/i18n/lang.svelte';
	import { levelTranslated } from '$lib/i18n/available';
	import { track } from '$lib/services/analytics';
	import { breadcrumbLd, itemListLd } from '$lib/seo';
	import { page } from '$app/state';
	import { onMount } from 'svelte';
	import { listBookQuotes, type BookQuote } from '$lib/services/feedback';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	// Turkish mode: the four A-level books, in their Turkish edition.
	const shelf = $derived(lang.limited ? BOOKS.filter((b) => levelTranslated(b.level)) : BOOKS);

	// What readers say: quotes they allowed and the owner published from
	// /backoffice. Loaded in the browser; with none, the section is not there.
	let quotes = $state<BookQuote[]>([]);
	onMount(() => {
		if (!lang.limited) void listBookQuotes(6).then((q) => (quotes = q.filter((x) => x.text)));
	});
</script>

<Seo
	title={t('German textbooks A1 to C2, free PDF')}
	description={t('Twelve German books, one per level from A1.1 to C2.2: real places, stories, real documents and practice, 131 pages each. Read them online or download the free PDF.')}
	path="/books"
	jsonLd={[
		itemListLd(t('The books'), BOOKS.map((b) => ({ name: `Deutsch ${b.level} · ${b.sub}`, path: `/books#${b.file}` }))),
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: t('Books'), path: '/books' }])
	]}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<header>
		<h1>{t('The books')}</h1>
		<p class="lede">
			{#if lang.limited}
				{t('One book per level, four in your language (A1.1 to A2.2). Each has twelve chapters, each chapter a real place in Germany: words first, a photo, a story, two rules, a real document, and the practice. The audio is a QR code away. All free, {pages} pages each.', { pages: BOOK_PAGES })}
			{:else}
			One book per level, twelve in all. Each has twelve chapters, each chapter a real place in
			Germany: words first, a photo, a story, two rules, a real document, and the practice. The
			audio is a QR code away. All free, {BOOK_PAGES} pages each.
			{/if}
		</p>
	</header>

	<ol class="shelf">
		{#each shelf as book (book.level)}
			<li class="book" id={book.file}>
				<a class="cover-link" href={bookReadHref(courseHref, book, 'books')} tabindex="-1" aria-hidden="true">
					<img class="cover" src={bookCover(book, lang.current)} alt="" width="640" height="905" loading="lazy" />
				</a>
				<div class="text">
					<p class="where">{book.level}</p>
					<h2 lang="de">Deutsch {book.level} · {book.sub}</h2>
					<div class="actions">
						<a class="primary" href={bookReadHref(courseHref, book, 'books')}><Icon name="book" size="1.05em" /> {t('Read online')}</a>
						{#if !lang.limited || hasLocalPdf(book, lang.current)}
							<a
								class="secondary"
								href={bookPdf(book, lang.current)}
								download
								onclick={(e) => {
									track('book_download', { book: book.level, from: 'books' });
									feedback.beforeDownload(e, { href: bookPdf(book, lang.current), book: book.level });
								}}
							>
								<Icon name="download" size="1.05em" /> PDF · {bookMb(book, lang.current)} MB
							</a>
						{/if}
					</div>
				</div>
			</li>
		{/each}
	</ol>

	{#if quotes.length}
		<section class="quotes" aria-labelledby="quotes-head">
			<h2 id="quotes-head">What readers say</h2>
			<ul>
				{#each quotes as q (q.id)}
					<li>
						<blockquote>{q.text}</blockquote>
						<p class="by">— {q.name || 'a reader'}{q.book ? `, book ${q.book}` : ''}</p>
					</li>
				{/each}
			</ul>
		</section>
	{/if}
</main>

<SiteFooter />

<style>
	.quotes {
		margin-top: 2.5rem;
	}

	.quotes h2 {
		margin: 0 0 1rem;
		font-size: var(--step-2);
	}

	.quotes ul {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(min(100%, 18rem), 1fr));
		gap: 1rem;
	}

	.quotes li {
		padding: 1rem 1.2rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.quotes blockquote {
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		line-height: 1.4;
		color: var(--heading);
		overflow-wrap: anywhere;
	}

	.quotes .by {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.shelf {
		list-style: none;
		margin: 1.5rem 0 0;
		padding: 0;
		display: grid;
		gap: 1rem;
	}

	.book {
		display: grid;
		grid-template-columns: minmax(0, 6.5rem) minmax(0, 1fr);
		gap: 1.2rem;
		align-items: center;
		padding: 1rem 1.2rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.cover-link {
		display: block;
	}

	.cover {
		width: 100%;
		height: auto;
		border-radius: 3px;
		box-shadow:
			0 16px 28px -20px rgba(31, 58, 95, 0.6),
			0 0 0 1px rgba(31, 58, 95, 0.08);
	}

	.where {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	h2 {
		margin: 0.1rem 0 0.7rem;
		font-size: var(--step-1);
		color: var(--heading);
	}

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem 1.2rem;
		align-items: center;
	}

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		padding: 0.6rem 1.1rem;
		border-radius: 6px;
		background: var(--accent-ink);
		color: #fff;
		font-weight: 700;
		text-decoration: none;
	}

	.secondary {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}
</style>
