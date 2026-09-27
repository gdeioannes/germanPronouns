<script lang="ts">
	// The site's footer, on every page: the main sections, the level list and
	// the disclaimer. It is the one place a reader (or a crawler) on any page
	// can reach every part of the site from, so no page is a dead end.
	import { page } from '$app/state';
	import Icon from '$lib/icons/Icon.svelte';

	// The course, its levels and its version come from the root layout's
	// load (see +layout.server.ts), so every page shows the same footer
	// without having to pass anything down.
	const site = $derived(page.data.site);
	const courseHref = $derived(site?.courseHref ?? '/');
	const levels = $derived(site?.levels ?? []);
	const version = $derived(site?.version);

	/**
	 * `compact`: one slim row, for pages that must fit a phone screen without
	 * scrolling (the swipe-deck home). The level list is dropped — the page
	 * itself links every level — and the disclaimer shrinks to a line.
	 */
	let { compact = false }: { compact?: boolean } = $props();
</script>

<footer class="foot" class:compact>
	<nav class="quick" aria-label="Footer">
		<a href="/"><Icon name="arrowLeft" size="1.05em" /> Home</a>
		<a href={courseHref}><Icon name="book" size="1.05em" /> The course</a>
		<a href="/words"><Icon name="words" size="1.05em" /> Word library</a>
		<a href="/words/nouns"><Icon name="pen" size="1.05em" /> German nouns</a>
		<a href="/words/verbs"><Icon name="repeat" size="1.05em" /> German verbs</a>
		<a href="/settings" rel="nofollow"><Icon name="settings" size="1.05em" /> Settings</a>
	</nav>
	{#if levels.length && !compact}
		<nav class="levels" aria-label="Levels">
			{#each levels as l (l.level)}
				<a href="{courseHref}/level/{l.level}"><span class="tnum">{l.level}</span> {l.title}</a>
			{/each}
		</nav>
	{/if}
	<p>
		Language Quiz is an independent study aid, not affiliated with or endorsed by any
		examination body.{#if version} Content version {version}.{/if}
	</p>
</footer>

<style>
	.foot {
		max-width: 72rem;
		margin: 3rem auto 0;
		padding: 2.5rem 1.25rem 3rem;
		border-top: 1px solid var(--line);
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.quick {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem 1.4rem;
		margin-bottom: 1rem;
	}

	.quick a {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		color: var(--ink-muted);
		text-decoration: none;
		font-weight: 600;
	}

	.quick a:hover,
	.levels a:hover {
		color: var(--heading);
	}

	.levels {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem 1.1rem;
		margin-bottom: 1.25rem;
		font-size: 0.8rem;
	}

	.levels a {
		color: var(--ink-muted);
		text-decoration: none;
	}

	.levels .tnum {
		font-weight: 700;
	}

	.foot p {
		margin: 0;
		max-width: 60ch;
		line-height: 1.55;
	}

	/* -- compact: a single slim row ---------------------------------------- */
	.foot.compact {
		margin-top: 0;
		padding: 0.75rem 1.25rem 0.9rem;
		font-size: 0.74rem;
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.4rem 1.5rem;
	}

	.foot.compact .quick {
		margin: 0;
		gap: 0.4rem 1rem;
		font-size: 0.78rem;
	}

	/* On a phone only the three links that are not already on the page. */
	@media (max-width: 36rem) {
		.foot.compact .quick a:nth-child(2),
		.foot.compact .quick a:nth-child(4),
		.foot.compact .quick a:nth-child(5) {
			display: none;
		}
	}

	.foot.compact p {
		max-width: none;
		line-height: 1.35;
	}
</style>
