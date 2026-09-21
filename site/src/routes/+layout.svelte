<script lang="ts">
	import favicon from '$lib/assets/favicon.svg';
	import { page } from '$app/state';
	import { cubicOut } from 'svelte/easing';
	import { fade } from 'svelte/transition';
	import '../app.css';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
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
