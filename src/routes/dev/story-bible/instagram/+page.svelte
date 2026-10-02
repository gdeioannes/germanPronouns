<script lang="ts">
	// Dev-only (see ../+page.svelte for the pattern).
	import type { Component } from 'svelte';
	let Page = $state<Component | null>(null);
	$effect(() => {
		if (import.meta.env.DEV) import('../InstagramAd.svelte').then((m) => (Page = m.default));
	});
</script>

<svelte:head>
	<title>Instagram Ad — Story Bible</title>
	<meta name="robots" content="noindex" />
</svelte:head>

{#if Page}
	<Page />
{:else if !import.meta.env.DEV}
	<main class="page"><p>This page only exists in development.</p></main>
{/if}
