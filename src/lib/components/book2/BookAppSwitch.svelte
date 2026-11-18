<script lang="ts">
	// Book | App, at the head of both sides of a book page. Tapping a side opens
	// it and makes it the one the next page code opens (state/bookOpen).
	import { goto } from '$app/navigation';
	import Icon from '$lib/icons/Icon.svelte';
	import { t } from '$lib/i18n/t';
	import { setSide, type BookSide } from '$lib/state/bookOpen';

	let {
		current,
		bookHref,
		appHref
	}: {
		current: BookSide;
		/** A string, or a function read at tap time (the chapter page's part comes from the hash). */
		bookHref: string | (() => string);
		appHref: string | (() => string | null) | null;
	} = $props();

	const resolve = (h: string | (() => string | null) | null) => (typeof h === 'function' ? h() : h);

	async function pick(side: BookSide, e: MouseEvent) {
		e.preventDefault();
		await setSide(side);
		if (side === current) return;
		const href = resolve(side === 'book' ? bookHref : appHref);
		if (href) await goto(href);
	}
</script>

<div class="switch" role="group" aria-label={t('Book or app')}>
	<a href={resolve(bookHref) ?? '#'} class:on={current === 'book'} aria-current={current === 'book' ? 'page' : undefined} onclick={(e) => pick('book', e)}>
		<Icon name="book" size="1.05em" /> {t('Book')}
	</a>
	{#if appHref}
		<a href={resolve(appHref) ?? '#'} class:on={current === 'app'} aria-current={current === 'app' ? 'page' : undefined} onclick={(e) => pick('app', e)}>
			<Icon name="cards" size="1.05em" /> App
		</a>
	{/if}
</div>

<style>
	.switch {
		display: inline-flex;
		align-self: flex-start;
		width: max-content;
		padding: 3px;
		gap: 2px;
		border-radius: 999px;
		background: var(--paper-high);
	}
	a {
		display: inline-flex;
		align-items: center;
		gap: 0.4em;
		padding: 0.45em 1.1em;
		border-radius: 999px;
		font-weight: 700;
		font-size: 0.95rem;
		color: var(--ink-muted);
		text-decoration: none;
	}
	a.on {
		background: var(--navy);
		color: #fff;
	}
	a:focus-visible {
		outline: 2px solid var(--accent);
		outline-offset: 2px;
	}
</style>
