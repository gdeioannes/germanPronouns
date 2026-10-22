<script lang="ts">
	// "Prefer it in print, or as a gift?": a literature book's paperback,
	// hardcover and Kindle editions, as a box of its own beside the free PDF so
	// it reads as a choice rather than a footnote. Used on the home page, the
	// literature shelf and the book's page; `from` tells the analytics which.
	import Icon from '$lib/icons/Icon.svelte';
	import type { LiteratureBook } from '$lib/content/literature';
	import { track } from '$lib/services/analytics';

	let { book, from }: { book: LiteratureBook; from: string } = $props();
</script>

{#if book.store}
	<div class="store">
		<span class="mark" aria-hidden="true"><Icon name="gift" size="1.4em" /></span>
		<div class="body">
			<p class="title">Prefer it in print, or as a gift?</p>
			<p class="sub">The same edition as a book, or on your Kindle, from {book.store.name}.</p>
			<ul>
				{#each book.store.editions as e (e.format)}
					<li>
						<a
							href={e.href}
							target="_blank"
							rel="noopener"
							onclick={() => track('literature_store', { book: book.id, format: e.format, from })}
						>
							{e.format}
							<Icon name="external" size="0.9em" />
							<span class="sr-only">(opens {book.store.name} in a new tab)</span>
						</a>
					</li>
				{/each}
			</ul>
		</div>
	</div>
{/if}

<style>
	.store {
		display: flex;
		gap: 0.9rem;
		align-items: flex-start;
		margin: 1.1rem 0 0.9rem;
		padding: 1rem 1.1rem;
		border: 1.5px dashed var(--accent);
		border-radius: 16px;
		background: var(--surface);
		text-align: left;
	}

	.mark {
		display: grid;
		place-items: center;
		flex: none;
		width: 2.6rem;
		height: 2.6rem;
		border-radius: 999px;
		background: var(--accent-soft);
		color: var(--accent-ink);
	}

	.body {
		min-width: 0;
	}

	.title {
		margin: 0;
		color: var(--ink);
		font-weight: 800;
		line-height: 1.3;
	}

	.sub {
		margin: 0.15rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.45;
	}

	ul {
		display: flex;
		flex-wrap: wrap;
		gap: 0.45rem;
		margin: 0.7rem 0 0;
		padding: 0;
		list-style: none;
	}

	a {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.45rem 0.9rem;
		border: 1.5px solid var(--accent-ink);
		border-radius: 999px;
		color: var(--accent-ink);
		font-size: var(--step--1);
		font-weight: 700;
		text-decoration: none;
		transition:
			background var(--fast, 0.15s) ease,
			color var(--fast, 0.15s) ease;
	}

	a:hover,
	a:focus-visible {
		background: var(--accent-ink);
		color: #fff;
		text-decoration: none;
	}
</style>
