<script lang="ts">
	// The site's top bar: brand + main links. The landing page shows it in
	// full. The course pages pass `compact`: a slim sticky bar — logo on the
	// left, a Menu button on the right that drops the links down — which slips
	// away while you scroll into an exercise and comes back the moment you
	// scroll up. The way out is always one tap away without crowding the quiz.
	import { page } from '$app/state';
	import { slide } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { whatsNew, initWhatsNew } from '$lib/state/whatsNew.svelte';

	onMount(initWhatsNew);

	let { courseHref, compact = false }: { courseHref: string; compact?: boolean } = $props();

	// On the landing page the section links are in-page anchors; everywhere
	// else they lead back to those sections of the landing page.
	const home = $derived(page.url.pathname === '/' ? '' : '/');

	// Inside the course "Open the course" would point at where you already are.
	const inCourse = $derived(
		page.url.pathname === courseHref || page.url.pathname.startsWith(`${courseHref}/`)
	);

	let open = $state(false);
	let root: HTMLElement | undefined = $state();

	// Close on navigation, so the next page does not open with the menu down.
	$effect(() => {
		page.url.pathname;
		open = false;
	});

	// Hide on scroll down, reveal on scroll up. The small dead zone keeps a
	// trackpad's jitter from flickering it, and it never hides near the top
	// or while the menu is open.
	let tucked = $state(false);
	let lastY = 0;

	function onScroll() {
		const y = window.scrollY;
		if (Math.abs(y - lastY) < 6) return;
		tucked = !open && y > 80 && y > lastY;
		lastY = y;
	}

	let menuButton: HTMLButtonElement | undefined = $state();

	function onWindowKey(event: KeyboardEvent) {
		if (open && event.key === 'Escape') {
			// Closing removes the links; focus goes back to the button that
			// opened them rather than falling to the top of the page.
			const inside = !!root?.contains(document.activeElement);
			open = false;
			if (inside) menuButton?.focus();
		}
	}

	// A click elsewhere closes it.
	function onWindowPointer(event: PointerEvent) {
		if (open && root && !root.contains(event.target as Node)) open = false;
	}
</script>

<svelte:window onkeydown={onWindowKey} onpointerdown={onWindowPointer} onscroll={compact ? onScroll : undefined} />

{#snippet brand()}
	<a class="brand" href="/">
		<img src="/icons/Icon-192.png" alt="" width="28" height="28" />
		<span>Language Quiz</span>
	</a>
{/snippet}

<!-- What's new is an icon rather than a text link: it matters most to returning
     learners, and the dot is what tells them there is something to see. -->
{#snippet news()}
	<a
		class="icon-link news"
		href="/changelog"
		aria-label={whatsNew.unseen ? "What's new — new updates" : "What's new"}
		title="What's new"
	>
		<Icon name="star" size="1.15em" />
		{#if whatsNew.unseen}<span class="dot" aria-hidden="true"></span>{/if}
	</a>
{/snippet}

{#snippet links(withNews: boolean)}
	<a href="{home}#levels">Levels</a>
	<a href="{home}#how">How it works</a>
	<a href="/words">Word library</a>
	<a href="/about">About</a>
	{#if withNews}{@render news()}{/if}
	{#if !inCourse}
		<a class="bar-cta" href={courseHref}>Open the course</a>
	{/if}
{/snippet}

{#if compact}
	<header class="mini" class:tucked class:open bind:this={root}>
		<div class="mini-row">
			{@render brand()}
			<!-- The places people jump to most sit in the bar as icons; the
			     rest are one tap away under Menu. -->
			{@render news()}
			<a class="icon-link" href="/words" aria-label="Word library" title="Word library">
				<Icon name="words" size="1.15em" />
			</a>
			<a class="icon-link" href="/settings" rel="nofollow" aria-label="Settings" title="Settings">
				<Icon name="settings" size="1.15em" />
			</a>
			<button
				type="button"
				class="menu"
				bind:this={menuButton}
				aria-expanded={open}
				aria-controls="site-menu"
				onclick={() => (open = !open)}
			>
				<Icon name={open ? 'close' : 'menu'} size="1.1em" />
				<span>Menu</span>
			</button>
		</div>
		{#if open}
			<nav id="site-menu" aria-label="Main" transition:slide={{ duration: 180, easing: cubicOut }}>
				<div class="menu-links">{@render links(false)}</div>
			</nav>
		{/if}
	</header>
{:else}
	<header class="bar">
		{@render brand()}
		<nav aria-label="Main">{@render links(true)}</nav>
	</header>
{/if}

<style>
	.bar {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		max-width: 72rem;
		margin: 0 auto;
		padding: 1.1rem 1.25rem;
	}

	.brand {
		display: inline-flex;
		align-items: center;
		gap: 0.55rem;
		font-weight: 800;
		color: var(--heading);
		text-decoration: none;
	}

	.brand img {
		border-radius: 7px;
	}

	.bar nav {
		display: flex;
		align-items: center;
		gap: 1.4rem;
		font-size: var(--step--1);
	}

	nav a {
		color: var(--ink-muted);
		text-decoration: none;
		font-weight: 600;
	}

	nav a:hover {
		color: var(--heading);
	}

	.bar-cta {
		padding: 0.45rem 0.95rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--heading);
	}

	/* On a phone the text links go; the What's new icon and the button stay. */
	@media (max-width: 40rem) {
		.bar nav a:not(.bar-cta):not(.icon-link) {
			display: none;
		}
	}

	/* In the full bar the icon sits among text links: pull it in so the gaps
	   read evenly. */
	.bar .news {
		margin-inline: -0.5rem;
	}

	.news {
		position: relative;
	}

	/* The "something new" dot: terracotta, ringed in the page colour so it
	   reads as a separate mark on top of the star. */
	.dot {
		position: absolute;
		top: 0.3rem;
		right: 0.3rem;
		width: 0.55rem;
		height: 0.55rem;
		border-radius: 50%;
		background: var(--accent);
		box-shadow: 0 0 0 2px var(--bg);
	}

	/* -- compact: slim sticky bar with a Menu button ----------------------- */

	.mini {
		position: sticky;
		top: 0;
		z-index: 50;
		background: color-mix(in srgb, var(--bg) 88%, transparent);
		backdrop-filter: blur(10px);
		border-bottom: 1px solid var(--line);
		/* Held still across page transitions instead of sliding with the page. */
		view-transition-name: site-nav;
		transition: transform 220ms var(--ease-out, ease-out);
	}

	/* While a page transition runs the bar is a snapshot image, which drops
	   the backdrop blur: the sliding page would smear through the see-through
	   background. Solid for those few hundred milliseconds instead. */
	:global(:root[data-nav]) .mini {
		background: var(--bg);
		backdrop-filter: none;
	}

	/* Tabbing into a tucked bar brings it back down, so the focused link is
	   never hidden off the top of the screen. */
	.mini.tucked:not(:focus-within) {
		transform: translateY(-100%);
	}

	.mini.open {
		box-shadow: 0 18px 36px -28px rgba(31, 58, 95, 0.55);
	}

	.mini-row {
		display: flex;
		align-items: center;
		gap: 0.35rem;
		max-width: 72rem;
		margin: 0 auto;
		padding: 0.55rem 1.25rem;
	}

	.mini .brand {
		gap: 0.45rem;
		font-size: var(--step--1);
	}

	.mini .brand img {
		width: 24px;
		height: 24px;
		border-radius: 6px;
	}

	.mini .brand {
		margin-right: auto;
	}

	.icon-link {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		border-radius: 50%;
		color: var(--ink-muted);
		transition:
			color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.icon-link:hover {
		color: var(--heading);
		background: var(--surface-alt);
	}

	.menu {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.4rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	.menu {
		margin-left: 0.25rem;
	}

	.menu:hover {
		border-color: var(--line-strong);
	}

	.menu-links {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem 1.6rem;
		max-width: 72rem;
		margin: 0 auto;
		padding: 0.4rem 1.25rem 1rem;
		font-size: var(--step--1);
	}

	/* On phones the links stack as full-width rows: easy thumb targets. */
	@media (max-width: 40rem) {
		.menu-links {
			flex-direction: column;
			align-items: stretch;
			gap: 0;
			padding-bottom: 0.6rem;
		}
		.menu-links a {
			padding: 0.75rem 0;
			font-size: var(--step-0);
		}
		.menu-links a + a {
			border-top: 1px solid var(--line);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.mini {
			transition: none;
		}
	}
</style>
