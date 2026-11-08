<script lang="ts">
	// The site's footer, on every page: the main sections and the disclaimer. It is the one place a reader (or a crawler) on any page
	// can reach every part of the site from, so no page is a dead end.
	import { page } from '$app/state';
	import Logo from '$lib/components/Logo.svelte';
	import Icon from '$lib/icons/Icon.svelte';

	// The course and its version come from the root layout's
	// load (see +layout.server.ts), so every page shows the same footer
	// without having to pass anything down.
	const site = $derived(page.data.site);
	const courseHref = $derived(site?.courseHref ?? '/');
	const version = $derived(site?.version);

	/**
	 * `compact`: one slim row, for pages that must fit a phone screen without
	 * scrolling (the swipe-deck home). The disclaimer shrinks to a line.
	 */
	let { compact = false }: { compact?: boolean } = $props();
</script>

<footer class="foot" class:compact>
	<div class="about">
		<a class="brand" href="/">
			<Logo tile size="1.75rem" />
			<span>Language Quiz</span>
		</a>
		<p class="legal">
			Language Quiz is an independent study aid, not affiliated with or endorsed by any
			examination body. Part of <a href="https://www.100words.org/en/" rel="noopener">100words.org</a>.
			<a href="/legal">Imprint and privacy notice</a>.{#if version}{' '}<span class="version">Content version {version}.</span>{/if}
		</p>
	</div>
	<nav class="quick" aria-label="Footer">
		<div class="group">
			<h2>Learn</h2>
			<a href={courseHref}>The course</a>
			<a href="/level-check">Your level</a>
			<a href="/words">Word library</a>
			<a href="/words/nouns">German nouns</a>
			<a href="/words/verbs">German verbs</a>
		</div>
		<div class="group">
			<h2>Read</h2>
			<a href="/books">The books</a>
			<a href="/literature">Literature</a>
			<a href="/stories">Stories</a>
		</div>
		<div class="group">
			<h2>Play</h2>
			<a href="/play/schreib-mir" lang="de">Schreib mir!</a>
			<a href="/play/ja-nein" lang="de">Ja oder Nein?</a>
			<a href="/play/wortbloecke" lang="de">Wortblöcke</a>
		</div>
		<div class="group">
			<h2>Site</h2>
			<a href="/about">About</a>
			<a href="/about#accessibility">Accessibility</a>
			<a href="/changelog">What's new</a>
			<a href="/forum">Forum</a>
			<a href="/contact">Contact</a>
			<a href="/legal">Legal &amp; privacy</a>
			<a href="/settings" rel="nofollow">Settings</a>
		</div>
	</nav>
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

	.foot:not(.compact) {
		display: grid;
		grid-template-columns: minmax(15rem, 1.3fr) 3.2fr;
		gap: 2rem 3rem;
		align-items: start;
	}

	.about {
		display: flex;
		flex-direction: column;
		gap: 1rem;
	}

	.brand {
		display: inline-flex;
		align-items: center;
		gap: 0.55rem;
		width: fit-content;
		font-weight: 800;
		font-size: var(--step-0);
		color: var(--heading);
		text-decoration: none;
	}

	.quick {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 1.5rem 2rem;
	}

	.group {
		display: flex;
		flex-direction: column;
		gap: 0.45rem;
	}

	.quick h2 {
		margin: 0 0 0.25rem;
		font-family: inherit;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--heading);
	}

	.quick a {
		color: var(--ink-muted);
		text-decoration: none;
		font-weight: 600;
		width: fit-content;
	}

	.quick a:hover {
		color: var(--heading);
	}

	@media (max-width: 48rem) {
		.foot:not(.compact) {
			grid-template-columns: 1fr;
		}
		.about {
			order: 2;
		}
		.quick {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
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

	/* Compact: the top bar already carries the brand; the legal line stays. */
	.foot.compact .about {
		display: contents;
	}

	.foot.compact .brand {
		display: none;
	}

	/* Links first, the legal line after, as in the single-row design. */
	.foot.compact .legal {
		order: 2;
	}

	/* Compact: the groups dissolve into one flat row, headings hidden. */
	.foot.compact .quick {
		display: flex;
		flex-wrap: wrap;
		margin: 0;
		gap: 0.4rem 1rem;
		font-size: 0.78rem;
	}

	.foot.compact .group {
		display: contents;
	}

	.foot.compact .quick h2 {
		display: none;
	}

	/* On a phone the links go: the compact top bar already carries home (the
	   logo), the word library and settings. Only the disclaimer stays. */
	@media (max-width: 36rem) {
		.foot.compact .quick {
			display: none;
		}
		.foot.compact {
			justify-content: center;
			padding: 0.4rem 1.25rem calc(0.6rem + env(safe-area-inset-bottom));
			border-top: 0;
			font-size: 0.66rem;
			text-align: center;
		}
		/* The version is for support questions, not for every phone screen. */
		.foot.compact .version {
			display: none;
		}
	}

	.foot.compact p {
		max-width: none;
		line-height: 1.35;
	}
</style>
