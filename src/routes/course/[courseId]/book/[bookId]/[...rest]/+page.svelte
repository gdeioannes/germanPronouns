<script lang="ts">
	// A retired book address (see +page.server.ts): off to the shelf.
	import { onMount } from 'svelte';
	import { t } from '$lib/i18n/t';

	onMount(() => location.replace('/books'));
</script>

<svelte:head>
	<title>{t('The books')}</title>
	<meta name="robots" content="noindex" />
	<link rel="canonical" href="/books" />
</svelte:head>

<p style="padding: 2rem; text-align: center;"><a href="/books">{t('The books')}</a></p>
