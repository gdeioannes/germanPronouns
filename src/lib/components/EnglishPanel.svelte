<script lang="ts">
	// The English of a German explanation, once it has been asked for.
	import { explainedInLang } from '$lib/i18n/content.svelte';
	import { lang } from '$lib/i18n/lang.svelte';
	import { pageLevel } from '$lib/i18n/pageLevel';
	let { lines }: { lines: string[] } = $props();
	// In French from B1, the lines are the French overlay (content.svelte.ts).
	const own = $derived(explainedInLang(pageLevel()));
</script>

<div class="panel" lang={own ? lang.current : 'en'}>
	{#each lines as line, i (i)}<p>{line}</p>{/each}
</div>

<style>
	.panel {
		margin: 0.6rem 0;
		padding: 0.6rem 0.8rem;
		border-inline-start: 3px solid var(--line-strong);
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.5;
	}
	p {
		margin: 0;
	}
	p + p {
		margin-top: 0.4rem;
	}
</style>
