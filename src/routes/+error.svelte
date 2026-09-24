<script lang="ts">
	// Shown for unknown addresses (GitHub Pages serves the 404.html fallback,
	// which renders this). Never indexed: a missing page must not rank.
	import { page } from '$app/state';
</script>

<svelte:head>
	<title>Page not found — Language Quiz</title>
	<meta name="robots" content="noindex" />
</svelte:head>

<main class="page">
	<h1>{page.status === 404 ? 'Page not found' : 'Something went wrong'}</h1>
	<p>{page.status === 404 ? 'This address does not lead to an exercise.' : page.error?.message}</p>
	<p><a href="/">Back to the start</a></p>
</main>
