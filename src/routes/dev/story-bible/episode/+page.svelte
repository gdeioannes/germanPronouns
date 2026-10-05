<script lang="ts">
	// Dev-only (see ../+page.svelte for the pattern). ?ep=<episode id> picks
	// the script; the default is the first episode.
	import type { Component } from 'svelte';
	import { page } from '$app/state';
	let Page = $state<Component<{ id: string }> | null>(null);
	$effect(() => {
		if (import.meta.env.DEV) import('../EpisodeScript.svelte').then((m) => (Page = m.default));
	});
	const id = $derived(page.url.searchParams.get('ep') ?? 'ep0_lost_in_berlin');
</script>

<svelte:head>
	<title>Episode Script — Story Bible</title>
	<meta name="robots" content="noindex" />
</svelte:head>

{#if Page}
	{#key id}<Page {id} />{/key}
{:else if !import.meta.env.DEV}
	<main class="page"><p>This page only exists in development.</p></main>
{/if}
