<script lang="ts">
	// Review every "Ja oder Nein?" question in one place: the German, the
	// gloss, the share tag, which vibe a Ja and a Nein feed, and whether the
	// bank is balanced. Dev only; production renders the note and nothing else.
	import type { Component } from 'svelte';

	let Review = $state<Component | null>(null);

	$effect(() => {
		if (import.meta.env.DEV) {
			import('./Review.svelte').then((m) => (Review = m.default));
		}
	});
</script>

<svelte:head>
	<title>Ja oder Nein? · question bank</title>
	<meta name="robots" content="noindex" />
</svelte:head>

{#if Review}
	<Review />
{:else if !import.meta.env.DEV}
	<main class="page"><p>This page only exists in development.</p></main>
{/if}
