<script lang="ts">
	import favicon from '$lib/assets/favicon.svg';
	import { page } from '$app/state';
	import { cubicOut } from 'svelte/easing';
	import { fade } from 'svelte/transition';
	import { trackScreenView } from '$lib/services/analytics';
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
	<link rel="icon" href={favicon} />
	<!-- The PNG icon and the manifest are what an installed home-screen app
	     uses; the SVG above is what a browser tab prefers. -->
	<link rel="icon" type="image/png" href="/favicon.png" />
	<link rel="apple-touch-icon" href="/icons/Icon-192.png" />
	<link rel="manifest" href="/manifest.json" />
	<meta name="theme-color" content="#1F3A5F" />
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
	<link
		rel="stylesheet"
		href="https://fonts.googleapis.com/css2?family=Inter:wght@400..800&family=Source+Serif+4:opsz,wght@8..60,400..700&display=swap"
	/>
</svelte:head>

<!-- Fades between pages so a client-side navigation reads as a change of
     content rather than a flash. Keyed on the pathname, and cheap enough not
     to delay the incoming page. -->
{#key page.url.pathname}
	<div in:fade={{ duration: 160, easing: cubicOut }}>
		{@render children()}
	</div>
{/key}
