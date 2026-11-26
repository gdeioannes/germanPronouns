<script lang="ts">
	// The way between the back office's two analytics pages, and back out.
	import Icon from '$lib/icons/Icon.svelte';

	let { current }: { current: 'report' | 'analysis' } = $props();
</script>

<nav class="tabs-row" aria-label="Analytics">
	<a class="back" href="/backoffice"><Icon name="arrowLeft" size="1em" /> Back office</a>
	<div class="tabs">
		<a href="/backoffice/analytics/analysis" aria-current={current === 'analysis' ? 'page' : undefined}>Analysis</a>
		<a href="/backoffice/analytics" aria-current={current === 'report' ? 'page' : undefined}>Live report</a>
	</div>
</nav>

<style>
	.tabs-row {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem 1rem;
	}

	.back {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		color: var(--ink-muted);
	}

	.tabs {
		display: inline-flex;
		gap: 0.25rem;
		padding: 0.25rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
	}

	.tabs a {
		display: inline-flex;
		align-items: center;
		min-height: 2.5rem;
		padding: 0 1rem;
		border-radius: 999px;
		color: var(--ink-muted);
		font-weight: 600;
		text-decoration: none;
	}

	.tabs a[aria-current='page'] {
		background: var(--heading);
		color: #fff;
	}
</style>
