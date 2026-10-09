<script lang="ts">
	// The site's top bar: brand + main links. The landing page shows it in
	// full. The course pages pass `compact`: a slim sticky bar — logo on the
	// left, a Menu button on the right that drops the links down — which slips
	// away while you scroll into an exercise and comes back the moment you
	// scroll up. The way out is always one tap away without crowding the quiz.
	//
	// The links come in three groups, each a dropdown in the full bar and a
	// headed list under Menu on a phone: Levels (the twelve modules), Library
	// (the word library, the printable workbooks, the stories and songs) and
	// About (about, what's new, contact). About carries the "something new"
	// dot only while there is an unseen release. Settings only matters once
	// you practise, so it is a gear in the compact bar and stays out of the
	// full one (the footer still links it everywhere).
	import { page } from '$app/state';
	import { fly, slide } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import Logo from '$lib/components/Logo.svelte';
	import { whatsNew, initWhatsNew } from '$lib/state/whatsNew.svelte';
	import { SONGS } from '$lib/domain/songs';

	onMount(initWhatsNew);

	let { courseHref, compact = false }: { courseHref: string; compact?: boolean } = $props();

	// The modules come from the root layout's load (see +layout.server.ts),
	// the same list the footer prints.
	// The nav titles come as "A1.1 · ERSTE SCHRITTE"; the menu shows the code
	// on its own and the name in normal case.
	const levels = $derived<{ level: string; title: string }[]>(
		(page.data.site?.levels ?? []).map((l: { level: string; title: string }) => ({
			level: l.level,
			title: l.title
				.replace(/^[A-C]\d(?:\.\d)?\s*[·-]\s*/, '')
				.toLowerCase()
				.replace(/(^|[\s-])(\p{L})/gu, (m: string) => m.toUpperCase())
		}))
	);
	const bands = $derived(['A', 'B', 'C'].map((b) => levels.filter((l) => l.level.startsWith(b))));

	// Inside the course "Open the course" would point at where you already are.
	const inCourse = $derived(
		page.url.pathname === courseHref || page.url.pathname.startsWith(`${courseHref}/`)
	);

	// Stories has its own shelf page; Songs is one link, the song page lists
	// the other songs itself.
	const firstSong = SONGS[0]?.href ?? '/song/ich-bin-max';

	type Menu = 'levels' | 'library' | 'about';

	let open = $state(false);
	/** Which dropdown in the full bar is down, if any. */
	let dropdown = $state<Menu | null>(null);
	let root: HTMLElement | undefined = $state();

	// Close on navigation, so the next page does not open with a menu down.
	$effect(() => {
		page.url.pathname;
		open = false;
		dropdown = null;
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
	const dropButtons: Partial<Record<Menu, HTMLButtonElement>> = {};

	function onWindowKey(event: KeyboardEvent) {
		if (event.key !== 'Escape' || !(open || dropdown)) return;
		// Closing removes the links; focus goes back to the button that
		// opened them rather than falling to the top of the page.
		const inside = !!root?.contains(document.activeElement);
		const button = dropdown ? dropButtons[dropdown] : menuButton;
		open = false;
		dropdown = null;
		if (inside) button?.focus();
	}

	// A click elsewhere closes them.
	function onWindowPointer(event: PointerEvent) {
		if ((open || dropdown) && root && !root.contains(event.target as Node)) {
			open = false;
			dropdown = null;
		}
	}

	// Focus leaving a dropdown (tabbing past its last link) folds it.
	function onDropFocusOut(event: FocusEvent) {
		const next = event.relatedTarget as Node | null;
		if (next && !(event.currentTarget as HTMLElement).contains(next)) dropdown = null;
	}

	function toggle(menu: Menu) {
		dropdown = dropdown === menu ? null : menu;
	}
</script>

<svelte:window onkeydown={onWindowKey} onpointerdown={onWindowPointer} onscroll={compact ? onScroll : undefined} />

{#snippet brand()}
	<a class="brand" href="/">
		<Logo tile size="1.75rem" />
		<span>Language Quiz</span>
	</a>
{/snippet}

<!-- The three groups' links. `wide` adds the sub-heads the dropdown panels
     use; the phone list gets its own headings instead. -->
{#snippet levelLinks()}
	{#each bands as band, i (i)}
		{#if band.length}
			<div class="col">
				{#each band as l (l.level)}
					<a href="{courseHref}/level/{l.level}"><span class="tnum code">{l.level}</span> <span class="name">{l.title}</span></a>
				{/each}
			</div>
		{/if}
	{/each}
{/snippet}

{#snippet libraryLinks()}
	<a href="/words"><Icon name="words" size="1em" /> Word library</a>
	<a href="{courseHref}/worksheet"><Icon name="printer" size="1em" /> Workbooks (PDF)</a>
	<a href="/stories"><Icon name="compass" size="1em" /> Stories</a>
	<a href={firstSong}><Icon name="headphones" size="1em" /> Songs</a>
{/snippet}

<!-- In the About dropdown the first link names the site, so it does not just
     repeat the button it hangs from. -->
{#snippet aboutLinks(aboutLabel = 'About')}
	<a href="/about">{aboutLabel}</a>
	<a
		class="news-row"
		href="/changelog"
		aria-label={whatsNew.unseen ? "What's new — new updates" : undefined}
	>
		What's new
		{#if whatsNew.unseen}<span class="dot inline" aria-hidden="true"></span>{/if}
	</a>
	<a href="/contact">Contact</a>
{/snippet}

{#snippet cta()}
	{#if !inCourse}
		<a class="bar-cta" href={courseHref}>Open the course</a>
	{/if}
{/snippet}

<!-- One dropdown in the full bar: a button and, when down, a panel. -->
{#snippet drop(menu: Menu, label: string, body: import('svelte').Snippet, wide = false, dotted = false)}
	<div class="drop" onfocusout={onDropFocusOut}>
		<button
			type="button"
			class="drop-btn"
			bind:this={dropButtons[menu]}
			aria-expanded={dropdown === menu}
			aria-controls="{menu}-menu"
			aria-label={dotted ? `${label} — new updates` : undefined}
			onclick={() => toggle(menu)}
		>
			{label}
			<Icon name="chevronDown" size="0.9em" class={dropdown === menu ? 'flip' : ''} />
			{#if dotted && dropdown !== menu}<span class="dot" aria-hidden="true"></span>{/if}
		</button>
		{#if dropdown === menu}
			<div
				id="{menu}-menu"
				class="drop-panel"
				class:wide
				transition:fly={{ y: -6, duration: 140, easing: cubicOut }}
			>
				{@render body()}
			</div>
		{/if}
	</div>
{/snippet}

<!-- The phone list: the same three groups, each under a small heading. The
     library leads, since those are the links people tap most; the twelve
     levels sit under it as a tight three-column grid (one per band) so the
     whole menu fits on a phone screen without scrolling. -->
{#snippet menuList()}
	<div class="menu-links">
		<p class="group-head">Library</p>
		{@render libraryLinks()}
		<p class="group-head">Levels</p>
		<div class="level-grid">{@render levelLinks()}</div>
		<p class="group-head">About</p>
		{@render aboutLinks()}
		{@render cta()}
	</div>
{/snippet}

<!-- The button that drops the links down. Both bars use it. -->
{#snippet menuButtonSnippet()}
	<button
		type="button"
		class="menu"
		aria-label={whatsNew.unseen ? 'Menu — new updates' : 'Menu'}
		bind:this={menuButton}
		aria-expanded={open}
		aria-controls="site-menu"
		onclick={() => (open = !open)}
	>
		<Icon name={open ? 'close' : 'menu'} size="1.1em" />
		<span>Menu</span>
		{#if whatsNew.unseen && !open}<span class="dot" aria-hidden="true"></span>{/if}
	</button>
{/snippet}

{#if compact}
	<header class="mini" class:tucked class:open bind:this={root}>
		<div class="mini-row">
			{@render brand()}
			<!-- The places people jump to most sit in the bar as icons; the
			     rest are one tap away under Menu. -->
			<a class="icon-link" href="/words" aria-label="Word library" title="Word library">
				<Icon name="words" size="1.15em" />
			</a>
			<a class="icon-link" href="/settings" rel="nofollow" aria-label="Settings" title="Settings">
				<Icon name="settings" size="1.15em" />
			</a>
			{@render menuButtonSnippet()}
		</div>
		{#if open}
			<nav id="site-menu" aria-label="Main" transition:slide={{ duration: 180, easing: cubicOut }}>
				{@render menuList()}
			</nav>
		{/if}
	</header>
{:else}
	<header class="bar" class:open bind:this={root}>
		<div class="bar-row">
			{@render brand()}
			<!-- Wide: the three dropdowns in the bar. Narrow: the way into the
			     course always stays in the bar; the rest drop down under Menu,
			     which shrinks to its icon so nothing has to wrap. -->
			<nav class="wide" aria-label="Main">
				{@render drop('levels', 'Levels', levelLinks, true)}
				{@render drop('library', 'Library', libraryLinks)}
				{@render drop('about', 'About', aboutLinks, false, whatsNew.unseen)}
				{@render cta()}
			</nav>
			<div class="narrow">
				{@render cta()}
				{@render menuButtonSnippet()}
			</div>
		</div>
		{#if open}
			<nav id="site-menu" aria-label="Main" transition:slide={{ duration: 180, easing: cubicOut }}>
				{@render menuList()}
			</nav>
		{/if}
	</header>
{/if}

<style>
	.bar-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		max-width: 72rem;
		margin: 0 auto;
		padding: 1.1rem 1.25rem;
	}

	/* The links that only show up once the bar is too narrow for them. */
	.narrow {
		display: none;
		align-items: center;
		gap: 0.35rem;
	}

	.brand {
		display: inline-flex;
		align-items: center;
		gap: 0.55rem;
		font-weight: 800;
		color: var(--heading);
		text-decoration: none;
	}

	.bar .wide {
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

	/* On a phone the bar is brand + course button + Menu; the links drop down. */
	@media (max-width: 40rem) {
		.bar .wide {
			display: none;
		}
		.narrow {
			display: flex;
		}
		.bar-row {
			gap: 0.5rem;
			padding: 0.8rem 1rem;
		}
		/* The brand holds one line; the Menu button drops to its icon, which
		   leaves the course button room to sit beside them. */
		.bar .brand {
			font-size: var(--step--1);
			white-space: nowrap;
		}
		.narrow .menu span {
			display: none;
		}
		.narrow .menu {
			gap: 0;
			padding: 0.45rem 0.6rem;
		}
		.narrow .bar-cta {
			padding: 0.4rem 0.75rem;
			font-size: var(--step--1);
			white-space: nowrap;
		}
	}

	/* Tightest phones: the wordmark goes, the mark alone carries the brand. */
	@media (max-width: 24rem) {
		.bar .brand span {
			display: none;
		}
	}

	/* -- dropdowns in the wide bar ----------------------------------------- */

	.drop {
		position: relative;
	}

	.drop-btn {
		position: relative;
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.drop-btn:hover,
	.drop-btn[aria-expanded='true'] {
		color: var(--heading);
	}

	.drop-btn :global(.flip) {
		transform: rotate(180deg);
	}

	.drop-btn .dot {
		top: -0.15rem;
		right: -0.6rem;
	}

	.drop-panel {
		position: absolute;
		top: calc(100% + 0.7rem);
		left: -0.75rem;
		z-index: 60;
		display: flex;
		flex-direction: column;
		min-width: 12rem;
		padding: 0.35rem;
		border: 1px solid var(--line);
		border-radius: 0.75rem;
		background: var(--surface);
		box-shadow: 0 18px 36px -24px rgba(31, 58, 95, 0.55);
	}

	.drop-panel a {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		white-space: nowrap;
		padding: 0.5rem 0.75rem;
		border-radius: 0.5rem;
	}

	.drop-panel a:hover {
		background: var(--surface-alt);
	}

	.drop-panel a :global(.icon) {
		color: var(--accent-ink);
	}

	/* Levels: the twelve modules in three columns, one per band. It is the
	   widest panel, so it hangs from its right edge to stay on the page. */
	.drop-panel.wide {
		flex-direction: row;
		gap: 0.25rem;
		left: auto;
		right: -0.75rem;
	}

	.col {
		display: flex;
		flex-direction: column;
	}

	.drop-panel .col + .col {
		border-left: 1px solid var(--line);
		padding-left: 0.25rem;
		margin-left: 0.25rem;
	}

	.code {
		min-width: 2.4rem;
		font-weight: 800;
		color: var(--heading);
	}

	/* In the dropdown the mark rides beside the words instead of on an icon. */
	.news-row {
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	.dot.inline {
		position: static;
		box-shadow: none;
	}

	/* The "something new" dot: terracotta, ringed in the page colour so it
	   reads as a separate mark on the button it sits on. */
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
		margin-right: auto;
	}

	/* The slim bar runs the mark a size down, so the brand does not out-weigh
	   the exercise it sits above. */
	.mini .brand :global(svg) {
		width: 24px;
		height: 24px;
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
		position: relative;
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		margin-left: 0.25rem;
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

	.menu .dot {
		top: -0.1rem;
		right: -0.1rem;
	}

	.menu:hover {
		border-color: var(--line-strong);
	}

	/* -- the dropped list (under Menu) ------------------------------------- */

	.menu-links {
		display: grid;
		grid-template-columns: repeat(3, auto);
		gap: 0.3rem 2.5rem;
		justify-content: start;
		max-width: 72rem;
		margin: 0 auto;
		padding: 0.4rem 1.25rem 1.2rem;
		font-size: var(--step--1);
	}

	.menu-links a {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.3rem 0;
	}

	.menu-links a :global(.icon) {
		color: var(--accent-ink);
	}

	.group-head {
		grid-column: 1 / -1;
		margin: 0.9rem 0 0.2rem;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.group-head:first-child {
		margin-top: 0.3rem;
	}

	.level-grid {
		grid-column: 1 / -1;
		display: grid;
		grid-template-columns: repeat(3, auto);
		gap: 0 2.5rem;
		justify-content: start;
	}

	.menu-links .bar-cta {
		grid-column: 1 / -1;
		justify-self: start;
		margin-top: 1rem;
	}

	/* On phones the links stack as full-width rows, except the levels: those
	   stay three columns (A, B, C band) of small tiles, the code on top and
	   the name beneath, so twelve modules take a few lines, not a screen. */
	@media (max-width: 40rem) {
		.menu-links {
			grid-template-columns: minmax(0, 1fr);
			gap: 0;
		}
		.menu-links a {
			padding: 0.7rem 0;
			border-top: 1px solid var(--line);
			font-size: var(--step-0);
		}
		.group-head {
			margin-top: 1.1rem;
		}
		.level-grid {
			grid-template-columns: repeat(3, minmax(0, 1fr));
			gap: 0.4rem;
			justify-content: stretch;
			margin-top: 0.3rem;
		}
		.level-grid .col {
			gap: 0.4rem;
		}
		.level-grid a {
			flex-direction: column;
			align-items: flex-start;
			gap: 0.1rem;
			padding: 0.5rem 0.6rem;
			border: 1px solid var(--line);
			border-radius: 0.6rem;
			background: var(--surface);
			font-size: var(--step--1);
			line-height: 1.2;
		}
		.level-grid .code {
			min-width: 0;
		}
		.level-grid .name {
			font-size: 0.72rem;
			font-weight: 500;
			color: var(--ink-muted);
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			max-width: 100%;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.mini {
			transition: none;
		}
	}
</style>
