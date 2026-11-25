<script lang="ts">
	// A one-line notice at the top of every page after a release that changed
	// the content: the German was reviewed, the app and the books carry the
	// corrections, a downloaded book should be fetched again. It is closed
	// with one tap and stays closed for this version; the next release brings
	// it back. Never on the book pages themselves (they are printed to PDF)
	// or the dev pages.
	import { browser } from '$app/environment';
	import { page } from '$app/state';
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { t } from '$lib/i18n/t';
	import { APP_VERSION } from '$lib/version';
	import { track } from '$lib/services/analytics';

	const KEY = 'releaseBannerSeen';
	let shown = $state(false);

	onMount(() => {
		if (!browser) return;
		try {
			shown = localStorage.getItem(KEY) !== APP_VERSION;
		} catch {
			shown = true;
		}
	});

	const hiddenHere = $derived(/\/book2\/|^\/dev\b/.test(page.url.pathname));

	function close() {
		shown = false;
		try {
			localStorage.setItem(KEY, APP_VERSION);
		} catch {
			// Blocked storage: the banner just comes back next time.
		}
		track('release_banner_close', { version: APP_VERSION });
	}
</script>

{#if shown && !hiddenHere}
	<aside class="release" aria-label={t('News about this release')}>
		<p>
			<strong>{t('Content review')}</strong>
			<span>
				{t(
					'The German in the app and in the books has been checked and corrected. If you downloaded a book, download the new edition.'
				)}
			</span>
			<a href="/changelog" onclick={() => track('release_banner_click', { to: 'changelog' })}>{t('What changed')}</a>
			<a href="/books" onclick={() => track('release_banner_click', { to: 'books' })}>{t('New editions')}</a>
		</p>
		<button type="button" class="close" onclick={close} aria-label={t('Close')}><Icon name="close" size="1em" /></button>
	</aside>
{/if}

<style>
	.release {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 0.55rem 0.9rem 0.55rem 1.1rem;
		background: var(--accent-soft, #fff3c4);
		color: var(--ink, #1f2328);
		border-bottom: 1px solid var(--rule, rgba(0, 0, 0, 0.1));
		font-size: 0.92rem;
		line-height: 1.4;
	}
	p {
		margin: 0 auto;
		flex: 1;
		max-width: 72rem;
		text-align: center;
		text-wrap: balance;
	}
	p > * + * {
		margin-inline-start: 0.6rem;
	}
	strong {
		font-weight: 800;
	}
	a {
		font-weight: 700;
		color: var(--accent-ink, #1f3a5f);
		text-decoration: underline;
		text-underline-offset: 0.15em;
		white-space: nowrap;
	}
	.close {
		flex: none;
		display: inline-grid;
		place-items: center;
		width: 2rem;
		height: 2rem;
		border: 0;
		border-radius: 50%;
		background: transparent;
		color: inherit;
		cursor: pointer;
	}
	.close:hover,
	.close:focus-visible {
		background: rgba(0, 0, 0, 0.08);
	}
	@media print {
		.release {
			display: none;
		}
	}
</style>
