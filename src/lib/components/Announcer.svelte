<script lang="ts">
	// The app's one polite live region. Anything can speak through it with
	// `announce()` from $lib/a11y.svelte.
	import { live } from '$lib/a11y.svelte';
</script>

<div class="sr-only" role="status" aria-live="polite" aria-atomic="true">
	{#each live.parts as part, i (i)}{#if i > 0}{' '}{/if}<span lang={part.lang}>{part.text}</span>{/each}
</div>
