<script lang="ts">
	// Where a printed QR code lands. The code is permanent; this page sends the
	// reader to wherever the code points today, and says so, so a reader whose
	// phone blocked the redirect still has a link to tap.
	import { onMount } from 'svelte';
	let { data } = $props();

	onMount(() => {
		if (data.target) location.replace(data.target);
	});
</script>

<svelte:head>
	<title>From the book</title>
	<meta name="robots" content="noindex" />
	{#if data.target}<meta http-equiv="refresh" content="0;url={data.target}" />{/if}
</svelte:head>

<main class="land">
	{#if data.target}
		<p class="eyebrow">From the book · {data.code}</p>
		<h1>One moment …</h1>
		<p>If nothing happens, <a href={data.target}>tap here</a>.</p>
	{:else}
		<p class="eyebrow">From the book · {data.code}</p>
		<h1>This code is not in use yet</h1>
		<p>It may be from a newer printing than this site knows. <a href="/">Go to the start page</a> and pick your level there.</p>
	{/if}
</main>

<style>
	.land {
		max-width: 32rem;
		margin: 4rem auto;
		padding: 0 1rem;
		text-align: center;
	}
	.eyebrow {
		font-size: 0.75rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}
</style>
