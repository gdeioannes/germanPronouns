<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import Book2 from '$lib/components/book2/Book2.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import type { PageData } from './$types';

	import { onMount } from 'svelte';
	let { data }: { data: PageData } = $props();
	// ?cover prints the wraparound cover sheet, ?spine=7.5 its spine width, and
	// ?hd the print originals (tool/gen-book2.mjs). Read in the browser: the
	// page is prerendered, so the query string does not exist at build time.
	let cover = $state(false);
	let spine = $state(7.4);
	let hd = $state(false);
	let ready = $state(false);
	onMount(() => {
		const q = new URLSearchParams(window.location.search);
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

<main data-ready={ready}>
	{#if !cover}
		<div class="dl-bar">
			<span><strong>{data.book.title}</strong> · {data.book.subtitle} · {data.book.chapters.length} chapters</span>
			<a class="btn" href="/books/v2/{data.book.courseId}_{data.book.level.toLowerCase().replace('.', '_')}.pdf" download>
				<Icon name="download" size="1em" /> Download the PDF
			</a>
		</div>
	{/if}
	<Book2 book={data.book} credits={data.credits} qr={data.qr} {cover} spineMm={spine} {hd} />
</main>

<style>
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

	@media print {
		.dl-bar {
			display: none;
		}
	}
</style>
