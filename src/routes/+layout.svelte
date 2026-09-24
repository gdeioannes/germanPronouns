<script lang="ts">
	import { page } from '$app/state';
	import { cubicOut } from 'svelte/easing';
	import { fade } from 'svelte/transition';
	import { trackScreenView } from '$lib/services/analytics';
	// Self-hosted fonts: no third-party request blocks the first paint, and the
	// files ship from the same origin as the page.
	import '@fontsource-variable/inter';
	import '@fontsource-variable/source-serif-4';
	import '../app.css';

	let { children } = $props();

	// One screen_view per navigation, the same signal the Flutter router
	// reported. Cookieless and no-op when no ingestion key is configured, which
	// is why there is no consent banner to show.
	$effect(() => {
		trackScreenView(page.url.pathname);
	});
</script>

<svelte:head>
	<link rel="icon" type="image/png" href="/favicon.png" />
	<link rel="apple-touch-icon" href="/icons/Icon-192.png" />
	<link rel="manifest" href="/manifest.json" />
	<meta name="theme-color" content="#1F3A5F" />
</svelte:head>

<!-- Fades between pages so a client-side navigation reads as a change of
     content rather than a flash. Keyed on the pathname, and cheap enough not
     to delay the incoming page. -->
{#key page.url.pathname}
	<div in:fade={{ duration: 160, easing: cubicOut }}>
		{@render children()}
	</div>
{/key}
