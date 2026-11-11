<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import Book2 from '$lib/components/book2/Book2.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { page } from '$app/state';
	import type { PageData } from './$types';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	import { inLangBookFront, inLangChapter } from '$lib/i18n/content.svelte';
	import { BOOKS, bookPdf, hasTurkishPdf } from '$lib/content/books';

	import { onMount } from 'svelte';
	let { data }: { data: PageData } = $props();
	// In Turkish the book comes through its level's overlay: the explanations,
	// the word meanings and the translations change; the German stays.
	const book = $derived(
		lang.tr
			? {
					...inLangBookFront(data.book, data.book.level),
					chapters: data.book.chapters.map((c) => inLangChapter(c, data.book.level))
				}
			: data.book
	);
	const entry = $derived(BOOKS.find((b) => b.level === data.book.level));
	// ?cover prints the wraparound cover sheet, ?spine=7.5 its spine width, and
	// ?hd the print originals (tool/gen-book2.mjs). Read in the browser: the
	// page is prerendered, so the query string does not exist at build time.
	let cover = $state(false);
	let spine = $state(7.4);
	let hd = $state(false);
	let ready = $state(false);
	// The way back: the books list when it sent you here (?from=books), else
	// wherever the trip started (home or the deck), like any side trip.
	let fromBooks = $state(false);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const back = $derived(fromBooks ? { href: '/books', label: t('The books') } : { href: returnTo.path, label: returnLabel(returnTo.path) });
	onMount(() => {
		const q = new URLSearchParams(window.location.search);
		fromBooks = q.get('from') === 'books';
		cover = q.has('cover');
		spine = Number(q.get('spine') ?? 7.4);
		hd = q.has('hd');
		ready = true;
	});
</script>

<Seo title="{data.book.title} · {data.book.subtitle} — book preview" description="A preview of the printed book, chapter by chapter." path="/course/{data.book.courseId}/book2/{data.book.level}" noindex />

<svelte:head>
	{@html cover ? `<style>@page { size: ${420 + spine + 6}mm 303mm; margin: 0; }</style>` : '<style>@page { size: A4; margin: 0; }</style>'}
</svelte:head>

{#if !cover}
	<div class="chrome"><SiteNav {courseHref} compact /></div>
{/if}

<main data-ready={ready}>
	{#if !cover}
		<div class="dl-bar">
			<a class="back-link" href={back.href}><Icon name="arrowLeft" size="1em" /> {back.label}</a>
			<span><strong>{book.title}</strong> · {book.subtitle} · {t('{n} chapters', { n: book.chapters.length })}</span>
			<!-- The page is the book, laid out on A4 for print: the browser prints it as it is. -->
			<button type="button" class="btn print" onclick={() => window.print()}>
				<Icon name="printer" size="1em" /> {t('Print')}
			</button>
			<!-- Turkish: the Turkish edition's PDF once it is printed; until then printing the page is the way. -->
			{#if !lang.tr || (entry && hasTurkishPdf(entry))}
				<a class="btn" href={entry ? bookPdf(entry, lang.tr) : `/books/v2/${data.book.courseId}_${data.book.level.toLowerCase().replace('.', '_')}.pdf`} download>
					<Icon name="download" size="1em" /> {t('Download the PDF')}
				</a>
			{/if}
		</div>
	{/if}
	<Book2 {book} credits={data.credits} qr={data.qr} pages={data.pages} siteQr={data.siteQr} {cover} spineMm={spine} {hd} />
</main>

<style>
	/* The bar below stays pinned; the nav scrolls away with the page rather
	   than stacking two sticky bars. */
	.chrome :global(.mini) {
		position: static;
		transform: none;
	}

	.back-link {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		margin-right: auto;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	.dl-bar {
		position: sticky;
		top: 0;
		z-index: 2;
		display: flex;
		flex-wrap: wrap;
		gap: 0.8rem;
		align-items: center;
		justify-content: center;
		padding: 0.7rem 1rem;
		background: var(--surface, #fff);
		border-bottom: 1px solid var(--line, #ddd);
	}

	.btn.print {
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	@media print {
		.chrome,
		.dl-bar {
			display: none;
		}
	}
</style>
