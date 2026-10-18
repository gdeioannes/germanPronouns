<script lang="ts">
	// The contacts used to have a page of their own; they are now the
	// Schreib mir! page itself. Old links and bookmarks land there.
	import { goto } from '$app/navigation';
	import { MATCH_PATH } from '$lib/domain/matchChat';
	import { onMount } from 'svelte';

	onMount(() => void goto(MATCH_PATH, { replaceState: true }));
</script>

<svelte:head>
	<meta name="robots" content="noindex" />
	<meta http-equiv="refresh" content="0; url={MATCH_PATH}" />
	<link rel="canonical" href={MATCH_PATH} />
</svelte:head>

<p style="padding: 2rem; text-align: center"><a href={MATCH_PATH}>Your contacts are on the Schreib mir! page.</a></p>
