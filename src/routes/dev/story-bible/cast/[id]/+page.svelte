<script lang="ts">
	// Dev-only (see ../../+page.svelte for the pattern). Keyed by the path
	// param so switching characters re-renders (go_router lesson applies).
	import type { Component } from 'svelte';
	import { page } from '$app/state';
	let Page = $state<Component | null>(null);
	$effect(() => {
		if (import.meta.env.DEV) import('../../CharacterPage.svelte').then((m) => (Page = m.default));
	});
</script>

<svelte:head>
	<title>Character — Story Bible</title>
	<meta name="robots" content="noindex" />
</svelte:head>

{#if Page}
	{#key page.params.id}
		<Page id={page.params.id} />
	{/key}
{:else if !import.meta.env.DEV}
	<main class="page"><p>This page only exists in development.</p></main>
{/if}
