<script lang="ts">
	import { t } from '$lib/i18n/t';
	// Shown for unknown addresses (GitHub Pages serves the 404.html fallback,
	// which renders this). Never indexed: a missing page must not rank.
	import { page } from '$app/state';
</script>

<svelte:head>
	<title>{t('Page not found — Language Quiz')}</title>
	<meta name="robots" content="noindex" />
</svelte:head>

<main class="page">
	<h1>{page.status === 404 ? t('Page not found') : t('Something went wrong')}</h1>
	<p>{page.status === 404 ? t('This address does not lead to an exercise.') : page.error?.message}</p>
	<p><a href="/">{t('Back to the start')}</a></p>
</main>
