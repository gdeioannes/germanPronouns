<script lang="ts">
	// Shown in Turkish mode instead of a page (or a level) that has no Turkish
	// yet. Turkish mode shows only what exists in Turkish; this is the way back.
	import { setLang } from '$lib/i18n/lang.svelte';
	import { t } from '$lib/i18n/t';
	import SiteNav from '$lib/components/SiteNav.svelte';

	let { courseHref = '/' }: { courseHref?: string } = $props();
</script>

<SiteNav {courseHref} compact />

<main class="not-tr">
	<h1>{t('This page is not in your language yet')}</h1>
	<p>{t('In your language, the course covers levels A1 and A2. This part of the site is only in English for now.')}</p>
	<div class="actions">
		<a class="primary" href={courseHref}>{t('Back to the course')}</a>
		<button type="button" onclick={() => setLang('en')}>{t('Show it in English')}</button>
	</div>
</main>

<style>
	.not-tr {
		max-width: 34rem;
		margin: 0 auto;
		padding: 4rem 1rem;
		text-align: center;
	}
	h1 {
		font-family: var(--font-display, "Source Serif 4 Variable", serif);
		font-size: 1.6rem;
		margin: 0 0 0.75rem;
	}
	p {
		color: var(--ink-muted);
		margin: 0 0 1.5rem;
	}
	.actions {
		display: flex;
		gap: 0.75rem;
		justify-content: center;
		flex-wrap: wrap;
	}
	.actions a,
	.actions button {
		font: inherit;
		padding: 0.6rem 1.1rem;
		border-radius: 999px;
		border: 1px solid currentColor;
		background: none;
		color: inherit;
		text-decoration: none;
		cursor: pointer;
	}
	.actions .primary {
		background: var(--accent);
		border-color: var(--accent);
		color: #fff;
	}
</style>
