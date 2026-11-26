<script lang="ts">
	import { stripLang } from '$lib/i18n/paths';
	// The site's top bar: brand + main links. The landing page shows it in
	// full. The course pages pass `compact`: a slim sticky bar — logo on the
	// left, a Menu button on the right that drops the links down — which slips
	// away while you scroll into an exercise and comes back the moment you
	// scroll up. The way out is always one tap away without crowding the quiz.
	//
	// The links come in three groups, each a dropdown in the full bar and a
	// headed list under Menu on a phone: Library
	// (the word library, the books, the games) and
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
	import { forum } from '$lib/state/forum.svelte';
	import { account } from '$lib/state/account.svelte';
	import { openSignIn } from '$lib/state/signin.svelte';
	import { feedback } from '$lib/state/feedback.svelte';
	import { pins } from '$lib/state/pins.svelte';
	import PageHelp from '$lib/components/PageHelp.svelte';
	import LangSwitch from '$lib/components/LangSwitch.svelte';
	import ShareButton from '$lib/components/ShareButton.svelte';
	import { openShare } from '$lib/state/sharePanel.svelte';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';

	onMount(() => {
		initWhatsNew();
		// For the pin square beside the course button (pinnedSquare).
		void pins.load();
	});

	// `level`: inside the course, the sub-level on screen, for the language
	// button's question (LangSwitch).
	let {
		courseHref,
		compact = false,
		level = null
	}: { courseHref: string; compact?: boolean; level?: string | null } = $props();

	// Inside the course "Open the course" would point at where you already are.
	// (A /tr/ or /ar/ address is the same page.)
	const bare = $derived(stripLang(page.url.pathname));
	const inCourse = $derived(bare === courseHref || bare.startsWith(`${courseHref}/`));

	// The twelve levels used to be a menu here too; learners tapped them instead
	// of starting the course, so they live in the footer and on /start now.
	type Menu = 'library' | 'about';

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

	// A click elsewhere closes them. Not one inside a panel a menu line opened
	// (the help sheet, the language question): those live at the end of <body>,
	// and closing the menu would take the line, and its panel, away.
	function onWindowPointer(event: PointerEvent) {
		const target = event.target as Element | null;
		if (target?.closest?.('.sheet, .backdrop')) return;
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

	function openFeedback() {
		open = false;
		dropdown = null;
		feedback.openFromMenu();
	}

	function toggle(menu: Menu) {
		dropdown = dropdown === menu ? null : menu;
	}

	// "Share this page": an icon in the bar where there is room, a line under
	// Menu on a phone. Not on pages that are about the visitor (settings, a
	// post being written) or that nobody would send on.
	const NO_SHARE = new Set(['/settings', '/backoffice', '/backoffice/analytics', '/backoffice/analytics/analysis', '/legal', '/contact', '/credits', '/forum/new']);
	const canShare = $derived(!NO_SHARE.has(page.route.id ?? ''));

	// "You are here": the link, or the dropdown holding the page, is marked.
	const GROUP_PATHS: Record<Menu, string[]> = {
		library: ['/words', '/books', '/literature', '/charts', '/german-faq', '/stories', '/play'],
		about: ['/about', '/changelog', '/forum', '/contact']
	};
	const under = (path: string) => bare === path || bare.startsWith(`${path}/`);
	const here = $derived<Record<Menu, boolean>>({
		library: GROUP_PATHS.library.some(under),
		about: GROUP_PATHS.about.some(under)
	});

	/** Signed in, the account button shows the address's first letter. */
	const initial = $derived(account.email?.trim().charAt(0).toUpperCase() ?? '');

	function shareFromMenu() {
		open = false;
		openShare({ where: 'nav' });
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
{#snippet libraryLinks()}
	<!-- Three kinds of thing, three short groups: what you read on screen,
	     what you print, what you play. A limited language lists only what
	     exists in it (i18n/available), which is the books, so no heads. -->
	{#if !lang.limited}
		<a href="/words"><Icon name="words" size="1em" /> Word library</a>
		<a href="/literature"><Icon name="feather" size="1em" /> Literature</a>
		<a href="/german-faq"><Icon name="help" size="1em" /> German FAQ</a>
		<p class="group-head">Print</p>
	{/if}
	<a href="/books"><Icon name="book" size="1em" /> {t('The books')}</a>
	{#if !lang.limited}
		<a href="{courseHref}/worksheet"><Icon name="printer" size="1em" /> Printable sheets</a>
		<a href="/charts"><Icon name="cards" size="1em" /> Grammar charts</a>
		<!-- The games, story mode among them: there for whoever wants to play,
		     never dealt into the deck or shown on the front page. -->
		<p class="group-head">Games</p>
		<a href="/stories"><Icon name="compass" size="1em" /> Stories</a>
		<a href="/play/schreib-mir"><Icon name="chat" size="1em" /> <span lang="de">Schreib mir!</span></a>
		<a href="/play/wortbloecke"><Icon name="blank" size="1em" /> <span lang="de">Wortblöcke</span></a>
	{/if}
{/snippet}

<!-- The learner's pins, in the full bar: a square in the course button's
     colour, on its left, with how many are saved. It is the learner's own
     list, so it is not a Library link, and it only shows once there is a pin
     (under Menu it is a line of the top row, always). -->
{#snippet pinnedSquare()}
	{#if pins.items.length}
		<a
			class="pin-sq"
			href="/pinned"
			aria-label="{t('Pinned')} ({pins.items.length})"
			title={t('Pinned')}
			aria-current={under('/pinned') ? 'page' : undefined}
		>
			<Icon name="pin" size="1.15em" />
			<span class="count" aria-hidden="true">{pins.items.length}</span>
		</a>
	{/if}
{/snippet}

<!-- "Your level": the word check (and later the placement test). A root link
     beside the levels, since it is how a learner finds which level is theirs. -->
{#snippet levelCheckLink(icon = true)}
	<a class="level-link" href="/level-check" aria-current={under('/level-check') ? 'page' : undefined}>
		{#if icon}<Icon name="star" size="1em" />{/if}
		{t('Your level')}
	</a>
{/snippet}

<!-- The forum lives under About; its dot (a reply to your topic) also shows
     on the About button, so a learner still sees they were answered. -->
{#snippet forumLink()}
	{#if !lang.limited}
	<a class="forum-link" href="/forum" aria-label={forum.unread.length ? 'Forum — new replies to your topics' : undefined}>
		<Icon name="forum" size="1em" /> Forum
		{#if forum.unread.length}<span class="dot inline" aria-hidden="true"></span>{/if}
	</a>
	{/if}
{/snippet}

<!-- In the About dropdown the first link names the site, so it does not just
     repeat the button it hangs from. -->
{#snippet aboutLinks(aboutLabel = t('About'))}
	<a href="/about">{aboutLabel}</a>
	{#if !lang.limited}
	<a
		class="news-row"
		href="/changelog"
		aria-label={whatsNew.unseen ? "What's new — new updates" : undefined}
	>
		What's new
		{#if whatsNew.unseen}<span class="dot inline" aria-hidden="true"></span>{/if}
	</a>
	{/if}
	{@render forumLink()}
	<a href="/contact">{t('Contact')}</a>
{/snippet}

<!-- The About dropdown in the full bar: its links, then Feedback as a row of
     the same panel (the full bar has no Feedback button of its own). -->
{#snippet aboutDrop()}
	{@render aboutLinks()}
	{#if feedback.available && !lang.limited}
		<button type="button" class="panel-row" aria-haspopup="dialog" aria-controls="feedback-panel" onclick={openFeedback}>
			<Icon name="star" size="1em" /> Feedback
		</button>
	{/if}
{/snippet}

<!-- Rate the site, any time: opens the feedback panel (FeedbackCard). A star and
     a word under Menu; the full bar keeps it in the About dropdown
     (aboutDrop). -->
{#snippet feedbackLink()}
	{#if feedback.available && !lang.limited}
		<button type="button" class="sign-in" aria-haspopup="dialog" aria-controls="feedback-panel" onclick={openFeedback}>
			<Icon name="star" size="1em" />
			<span class="sign-in-label">Feedback</span>
		</button>
	{/if}
{/snippet}

<!-- Sign in, in plain sight: the course needs no account, and saying so is
     part of the link's job, but a learner who has one should not have to
     hunt for it in settings. Signed in, it becomes the account itself. -->
<!-- In the full bar it is the icon alone: a person, or once signed in a
     filled disc with the address's first letter. Under Menu (the slim bar's
     only place for it) it keeps its words. -->
{#snippet signIn(labelled = false)}
	{#if account.available && !lang.limited}
		{@const label = account.signedIn ? t('Account') : t('Sign in')}
		{#if labelled}
			<button type="button" class="sign-in" aria-haspopup="dialog" aria-controls="sign-in-sheet" onclick={openSignIn}>
				<Icon name="user" size="1em" />
				<span class="sign-in-label">{label}</span>
			</button>
		{:else}
			<button
				type="button"
				class="account"
				aria-haspopup="dialog"
				aria-controls="sign-in-sheet"
				aria-label={label}
				title={label}
				onclick={openSignIn}
			>
				{#if account.signedIn && initial}
					<span class="initial" aria-hidden="true">{initial}</span>
				{:else}
					<Icon name="user" size="1.15em" />
				{/if}
			</button>
		{/if}
	{/if}
{/snippet}

<!-- The full bar has room to say it is an app, and for the books beside it:
     most visitors come for the free books. On a phone the books button drops
     its icon, and on the tightest ones it is the icon alone. -->
{#snippet cta(books = false)}
	{#if books && bare !== '/books'}
		<a class="bar-cta books" href="/books" aria-label={t('Books')}><Icon name="book" size="1em" /> <span>{t('Books')}</span></a>
	{/if}
	{#if !inCourse}
		<a class="bar-cta" href={courseHref}>{t('Open course app')}</a>
	{/if}
{/snippet}

<!-- One dropdown in the full bar: a button and, when down, a panel. -->
{#snippet drop(menu: Menu, label: string, body: import('svelte').Snippet, wide = false, dotted = false)}
	<div class="drop" onfocusout={onDropFocusOut}>
		<button
			type="button"
			class="drop-btn"
			class:here={here[menu]}
			bind:this={dropButtons[menu]}
			aria-expanded={dropdown === menu}
			aria-controls="{menu}-menu"
			aria-label={dotted ? `${label} — ${t('new updates')}` : undefined}
			onclick={() => toggle(menu)}
		>
			{label}
			{#if dotted && dropdown !== menu}<span class="dot inline" aria-hidden="true"></span>{/if}
			<Icon name="chevronDown" size="0.9em" class={dropdown === menu ? 'flip' : ''} />
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
		<div class="root-row">
			{@render levelCheckLink()}
			<!-- The slim bar shows the pins and the account itself. -->
			{#if !compact || !pins.items.length}
				<a href="/pinned">
					<Icon name="pin" size="1em" />
					{t('Pinned')}{#if pins.items.length}&nbsp;<span class="pin-count">{pins.items.length}</span>{/if}
				</a>
			{/if}
			<a href="/settings" rel="nofollow"><Icon name="settings" size="1em" /> {t('Settings')}</a>
			{#if !compact}{@render signIn(true)}{/if}
			<!-- The slim bar has feedback, help and the language in it, except on
			     a phone, where they are lines of this row (`phone`). -->
			{#if compact}
				<span class="phone">{@render feedbackLink()}</span>
			{:else}
				{@render feedbackLink()}
			{/if}
			{#if canShare}
				<button type="button" class="menu-share" onclick={shareFromMenu}>
					<Icon name="share" size="1em" />
					<span>{t('Share this page')}</span>
				</button>
			{/if}
			{#if compact}
				<span class="phone">
					<PageHelp topic={page.route.id} tone="row" />
					<LangSwitch bar where="course" {level} />
				</span>
			{/if}
		</div>
		<p class="group-head">{t('Library')}</p>
		{@render libraryLinks()}
		<p class="group-head">{t('About')}</p>
		{@render aboutLinks()}
		<!-- The full bar already shows the course button beside Menu; only the
		     slim bar, which has none, gets it at the end of the list. -->
		{#if compact}{@render cta()}{/if}
	</div>
{/snippet}

<!-- The button that drops the links down. Both bars use it. -->
{#snippet menuButtonSnippet()}
	<button
		type="button"
		class="menu"
		aria-label={!lang.limited && (whatsNew.unseen || forum.unread.length) ? `${t('Menu')} — ${t('new updates')}` : t('Menu')}
		bind:this={menuButton}
		aria-expanded={open}
		aria-controls="site-menu"
		onclick={() => (open = !open)}
	>
		<Icon name={open ? 'close' : 'menu'} size="1.1em" />
		<span>{t('Menu')}</span>
		{#if !lang.limited && (whatsNew.unseen || forum.unread.length) && !open}<span class="dot" aria-hidden="true"></span>{/if}
	</button>
{/snippet}

{#if compact}
	<header class="mini" class:tucked class:open bind:this={root}>
		<div class="mini-row">
			{@render brand()}
			<!-- The same order as the full bar: Share first, the one coloured
			     button; then the grey tools, every one the same round size
			     (word library, help for this screen, feedback, language); a
			     hairline; then the learner's own places (pins once there are
			     any, the account) and Menu. On a phone only the last group
			     stays in the bar: the rest is in the menu's top row. -->
			{#if canShare}<span class="share-slot"><ShareButton where="nav" look="tag" label={t('Share')} /></span>{/if}
			<div class="tools">
				{#if !lang.limited}
					<a class="icon-link" href="/words" aria-label="Word library" title="Word library">
						<Icon name="words" size="1.15em" />
					</a>
				{/if}
				<!-- "?": how this screen works (content/pageHelp), on pages that have an entry. -->
				<PageHelp topic={page.route.id} />
				{#if feedback.available && !lang.limited}
					<button
						type="button"
						class="icon-link"
						aria-haspopup="dialog"
						aria-controls="feedback-panel"
						aria-label="Feedback"
						title="Feedback"
						onclick={openFeedback}
					>
						<Icon name="star" size="1.15em" />
					</button>
				{/if}
				<!-- The language, inside the course too: switching to one that does
				     not explain this level asks first (LangSwitch). -->
				<LangSwitch bar where="course" {level} />
				<span class="hair" aria-hidden="true"></span>
			</div>
			{#if pins.items.length}
				<a class="icon-link pin" href="/pinned" aria-label="{t('Pinned')} ({pins.items.length})" title={t('Pinned')}>
					<Icon name="pin" size="1.15em" />
					<span class="count" aria-hidden="true">{pins.items.length}</span>
				</a>
			{/if}
			{@render signIn()}
			{@render menuButtonSnippet()}
		</div>
		{#if open}
			<nav id="site-menu" aria-label={t('Main')} transition:slide={{ duration: 180, easing: cubicOut }}>
				{@render menuList()}
			</nav>
		{/if}
	</header>
{:else}
	<header class="bar" class:open bind:this={root}>
		<div class="bar-row">
			{@render brand()}
			<!-- Wide, three parts: the brand; in the middle the links, with Share
			     as the one coloured thing among them; at the end the quiet
			     utilities (help, language), then the way into the course and the
			     account. Narrow: the course button always stays in the bar; the
			     rest drop down under Menu, which shrinks to its icon on a phone. -->
			<nav class="wide" aria-label={t('Main')}>
				{@render levelCheckLink(false)}
				{@render drop('library', t('Library'), libraryLinks)}
				{@render drop('about', t('About'), aboutDrop, false, (whatsNew.unseen || forum.unread.length > 0) && !lang.limited)}
				{#if canShare}<span class="share-slot"><ShareButton where="nav" look="tag" label={t('Share')} /></span>{/if}
			</nav>
			<div class="bar-end">
				<PageHelp topic={page.route.id} />
				<!-- The language, from every page (the same picker as on the home
				     photo, so not repeated there). -->
				{#if bare !== '/'}<LangSwitch bar where="nav" />{/if}
				<div class="wide-end">
					{@render pinnedSquare()}
					{@render cta(true)}
					{@render signIn()}
				</div>
				<div class="narrow">
					{@render cta(true)}
					{@render menuButtonSnippet()}
				</div>
			</div>
		</div>
		{#if open}
			<nav id="site-menu" aria-label={t('Main')} transition:slide={{ duration: 180, easing: cubicOut }}>
				{@render menuList()}
			</nav>
		{/if}
	</header>
{/if}

<style>
	/* The language list hangs from the whole bar on a phone (LangSwitch). */
	header.bar {
		position: relative;
	}

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
	.bar-end {
		display: flex;
		align-items: center;
		gap: 0.6rem;
	}

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

	/* A link is as tall as a finger, not as tall as its letters. */
	.bar .wide > a,
	.drop-btn {
		padding-block: 0.5rem;
	}

	/* The course button and the account, behind a hairline that sets them
	   apart from the help and language icons. */
	.wide-end {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin-inline-start: 0.4rem;
		padding-inline-start: 1rem;
		border-inline-start: 1px solid var(--line-strong);
	}

	/* The pins: a square as tall as the course button beside it. */
	.pin-sq {
		position: relative;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.35rem;
		height: 2.35rem;
		border-radius: 6px;
		background: var(--heading);
		color: #fff;
		transition: background var(--fast) var(--ease-out);
	}

	.pin-sq:hover {
		background: color-mix(in srgb, var(--heading) 86%, #000);
	}

	.pin-sq .count {
		position: absolute;
		top: -0.4rem;
		inset-inline-end: -0.4rem;
		display: grid;
		place-items: center;
		min-width: 1.1rem;
		height: 1.1rem;
		padding: 0 0.25rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-size: 0.68rem;
		font-weight: 700;
		line-height: 1;
		box-shadow: 0 0 0 2px var(--bg);
	}

	/* You are here. */
	.bar .wide > a[aria-current='page'],
	.drop-btn.here {
		color: var(--heading);
		box-shadow: inset 0 -2px 0 var(--accent);
	}

	nav a {
		color: var(--ink-muted);
		text-decoration: none;
		font-weight: 600;
	}

	nav a:hover {
		color: var(--heading);
	}

	/* The filled buttons in the bar: the way into the course, and the books. */
	a.bar-cta {
		padding: 0.5rem 1rem;
		border: 1px solid var(--heading);
		border-radius: 6px;
		background: var(--heading);
		color: #fff;
		font-size: var(--step--1);
		font-weight: 700;
		text-decoration: none;
		white-space: nowrap;
		transition: background var(--fast) var(--ease-out);
	}

	a.bar-cta:hover {
		background: color-mix(in srgb, var(--heading) 86%, #000);
		color: #fff;
	}

	/* The books beside it: the same filled button, with its icon. */
	a.bar-cta.books {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
	}

	/* Below a laptop's width the links no longer fit on one line: the bar is
	   brand + help + language + course button + Menu, and the links drop down. */
	@media (max-width: 64rem) {
		.bar .wide,
		.wide-end {
			display: none;
		}
		.narrow {
			display: flex;
		}
	}

	@media (max-width: 40rem) {
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
	@media (max-width: 30rem) {
		.bar .brand span {
			display: none;
		}
	}

	/* Two buttons and the Menu on the smallest phones: the books button keeps its icon. */
	@media (max-width: 26rem) {
		.narrow .bar-cta.books :global(svg) {
			display: none;
		}
		.narrow .bar-cta {
			padding-inline: 0.6rem;
		}
	}

	@media (max-width: 21rem) {
		.narrow .bar-cta.books :global(svg) {
			display: inline;
		}
		.narrow .bar-cta.books span {
			display: none;
		}
		.narrow .bar-cta.books {
			padding-inline: 0.6rem;
		}
	}

	.forum-link,
	.level-link {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
	}

	.level-link :global(.icon) {
		color: var(--accent-ink);
	}

	.sign-in {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	.sign-in:hover {
		color: var(--heading);
	}

	.sign-in :global(.icon) {
		color: var(--accent-ink);
	}

	/* The account in the bars: a round icon button like help beside it. */
	.account {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		padding: 0;
		border: 0;
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		cursor: pointer;
		transition:
			color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.account:hover {
		color: var(--heading);
		background: var(--surface-alt);
	}

	.account .initial {
		display: grid;
		place-items: center;
		width: 1.85rem;
		height: 1.85rem;
		border-radius: 50%;
		background: var(--heading);
		color: #fff;
		font-size: var(--step--1);
		font-weight: 700;
		line-height: 1;
	}

	.menu-links .root-row {
		/* The language list hangs from this row on a phone (LangSwitch). */
		position: relative;
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem 1.5rem;
		align-items: center;
	}

	.pin-count {
		color: var(--accent-ink);
	}

	/* The language list hangs from the row, at its end, so it can never run
	   off either side wherever the button wraps to; the menu grows to hold
	   it, so its last language is not cut off at the menu's edge. */
	.menu-links :global(.lang-picker.bar) {
		position: static;
	}

	.menu-links :global(.lang-picker .menu) {
		top: calc(100% + 0.4rem);
		inset-inline: auto 0;
	}

	.menu-links:has(:global(.lang-picker .menu)) {
		min-height: 31rem;
	}

	@media (max-width: 40rem) {
		.menu-links :global(.lang-picker .menu) {
			inset-inline: 0;
		}
	}

	/* Under Menu the share link keeps its words in both bars: on a phone it is
	   the only one there is. */
	.menu-share {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
	}

	.menu-share :global(.icon) {
		color: var(--accent-ink);
	}

	/* The bar's share icon: only where the bar has room for one more. */
	.share-slot {
		display: inline-flex;
	}

	/* In the bars Share takes the corners of the buttons around it. */
	.share-slot :global(.tag) {
		border-radius: 6px;
	}

	@media (max-width: 40rem) {
		.share-slot {
			display: none;
		}
	}

	.forum-link :global(.icon) {
		color: var(--accent-ink);
	}

	.menu-links .root-row {
		grid-column: 1 / -1;
		margin-top: 0.3rem;
	}

	.menu-links .root-row a {
		font-weight: 700;
		color: var(--heading);
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

	.drop-panel {
		position: absolute;
		top: calc(100% + 0.7rem);
		inset-inline-start: -0.75rem;
		z-index: 60;
		display: flex;
		flex-direction: column;
		min-width: 12rem;
		padding: 0.35rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 18px 36px -24px rgba(31, 58, 95, 0.55);
	}

	.drop-panel a {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		white-space: nowrap;
		padding: 0.5rem 0.75rem;
		border-radius: var(--radius-sm);
	}

	.drop-panel a:hover,
	.panel-row:hover {
		background: var(--surface-alt);
		color: var(--heading);
	}

	.drop-panel a :global(.icon),
	.panel-row :global(.icon) {
		color: var(--accent-ink);
	}

	/* A group's head starts where the rows' icons do. */
	.drop-panel .group-head {
		padding-inline: 0.75rem;
	}

	/* A button that is a row of the panel (Feedback opens a dialog). */
	.panel-row {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		white-space: nowrap;
		padding: 0.5rem 0.75rem;
		border: 0;
		border-radius: var(--radius-sm);
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-weight: 600;
		text-align: start;
		cursor: pointer;
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
		inset-inline-end: 0.3rem;
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

	/* A sticky bar taller than the screen keeps its top pinned, so the end of
	   the menu would only show once the page under it ran out. The menu gets
	   the screen below the bar and scrolls on its own instead. */
	.mini > nav {
		max-height: calc(100dvh - 3.4rem);
		overflow-y: auto;
		overscroll-behavior: contain;
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
		margin-inline-end: auto;
	}

	/* The slim bar runs the mark a size down, so the brand does not out-weigh
	   the exercise it sits above. */
	.mini .brand :global(svg) {
		width: 24px;
		height: 24px;
	}

	.menu {
		position: relative;
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		margin-inline-start: 0.25rem;
		padding: 0.4rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: 6px;
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	/* The slim bar: one size for everything in it. Each grey tool is a 2.2rem
	   round target with the same icon size; Share and Menu are 2.2rem tall;
	   all of it sits on one centre line. */
	.tools {
		display: flex;
		align-items: center;
		gap: 0.15rem;
	}

	/* Every icon in the row is drawn at one size, whatever the font size of
	   the button it sits in (those differ: a bare button, a link, the
	   language picker), and the language button is as tall as the rest and
	   as grey. */
	.mini .mini-row :global(.icon) {
		width: 1.15rem;
		height: 1.15rem;
	}

	.mini .mini-row :global(.lang-picker .trigger) {
		height: 2.2rem;
		padding-block: 0;
	}

	.mini .mini-row :global(.lang-picker .trigger .icon) {
		color: inherit;
	}

	.icon-link {
		position: relative;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		padding: 0;
		border: 0;
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		cursor: pointer;
		transition:
			color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.icon-link:hover {
		color: var(--heading);
		background: var(--surface-alt);
	}

	/* How many pins, on the icon's corner. */
	.icon-link .count {
		position: absolute;
		top: 0;
		inset-inline-end: -0.1rem;
		display: grid;
		place-items: center;
		min-width: 1rem;
		height: 1rem;
		padding: 0 0.2rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-size: 0.62rem;
		font-weight: 700;
		line-height: 1;
		box-shadow: 0 0 0 2px var(--bg);
	}

	/* The hairline between the tools and the learner's own places. */
	.hair {
		width: 1px;
		height: 1.4rem;
		margin-inline: 0.45rem 0.3rem;
		background: var(--line-strong);
	}

	.mini .menu {
		height: 2.2rem;
		margin-inline-start: 0.3rem;
		padding-block: 0;
	}

	/* The lines of the menu's top row that only a phone needs. */
	.menu-links .phone {
		display: none;
	}

	@media (max-width: 40rem) {
		.tools {
			display: none;
		}
		.menu-links .phone {
			display: contents;
		}
	}

	.menu .dot {
		top: -0.1rem;
		inset-inline-end: -0.1rem;
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

	/* A button, not a row of the list: it keeps its own padding and takes no
	   row line on a phone. */
	.menu-links a.bar-cta {
		grid-column: 1 / -1;
		justify-self: start;
		margin-top: 1rem;
		padding: 0.5rem 1rem;
		border: 1px solid var(--heading);
		font-size: var(--step--1);
	}

	/* On phones the links stack as full-width rows. */
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
	}

	@media (prefers-reduced-motion: reduce) {
		.mini {
			transition: none;
		}
	}
</style>
