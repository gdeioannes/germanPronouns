<script lang="ts">
	// The English of a German explanation, once it has been asked for.
	let { lines }: { lines: string[] } = $props();
</script>

<div class="panel" lang="en">
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
