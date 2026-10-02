<script lang="ts">
	// The story bible is authoring reference material, not app content. It is
	// only reachable (and only bundled) in `npm run dev`; in a production build
	// this page renders the not-available note and pulls in nothing else.
	import type { Component } from 'svelte';

	let Bible = $state<Component | null>(null);

	$effect(() => {
		if (import.meta.env.DEV) {
			import('./StoryBible.svelte').then((m) => (Bible = m.default));
		}
	});
</script>

<svelte:head>
	<title>Story bible</title>
	<meta name="robots" content="noindex" />
</svelte:head>

{#if Bible}
	<Bible />
{:else if !import.meta.env.DEV}
	<main class="page"><p>This page only exists in development.</p></main>
{/if}
