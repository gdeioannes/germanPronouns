<script lang="ts">
	// The forum's front page: the boards, the newest topics, and — for a
	// signed-in learner — the replies waiting for them.
	//
	// Anyone can read. The page is prerendered as a shell and fills itself from
	// Firestore in the browser, so a visitor who never signed in still sees
	// every topic; only "New topic" asks for an account.
	import { onMount } from 'svelte';
	import { page } from '$app/state';
	import Seo from '$lib/components/Seo.svelte';
	import { breadcrumbLd } from '$lib/seo';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import ThreadRow from '$lib/components/forum/ThreadRow.svelte';
	import { openSignIn } from '$lib/state/signin.svelte';
	import { FORUM_CATEGORIES, isCategory, matchesSearch, type ForumCategory, type ForumThread } from '$lib/domain/forum';
	import { describeForumError, listThreads } from '$lib/services/forum';
	import { cloudConfigured } from '$lib/services/firebase';
	import { account } from '$lib/state/account.svelte';
	import { forum } from '$lib/state/forum.svelte';

	const available = cloudConfigured();

	let category = $state<ForumCategory | null>(null);
	let threads = $state<ForumThread[]>([]);
	let phase = $state<'loading' | 'ready' | 'failed'>('loading');
	let error = $state('');

	// Search is done in the browser over the loaded topics: Firestore has no
	// text search, and a forum this size fits in one query. Typing anything
	// widens the fetch from the newest page to the newest few hundred.
	let search = $state('');
	let deep = $state(false);
	const SEARCH_LIMIT = 300;
	const shown = $derived(search.trim() ? threads.filter((t) => matchesSearch(t, search)) : threads);

	// Fixed topics leave the main list and wait, folded, at the bottom: the
	// list stays about what still needs doing, and what got fixed is one click
	// away. A search shows every match in one list (the badge says "Fixed").
	const active = $derived(search.trim() ? shown : shown.filter((t) => t.status !== 'fixed'));
	const fixed = $derived(search.trim() ? [] : shown.filter((t) => t.status === 'fixed'));
	let fixedOpen = $state(false);
	$effect(() => {
		if (search.trim() && !deep) {
			deep = true;
			void load(category);
		}
	});

	// "?category=report" opens on one board (the quiz's report panel links here);
	// "?fixed=1" opens with the fixed topics unfolded.
	onMount(() => {
		const params = new URLSearchParams(window.location.search);
		const wanted = params.get('category');
		category = isCategory(wanted) ? wanted : null;
		fixedOpen = params.get('fixed') === '1';
	});

	$effect(() => {
		if (!available) return;
		const wanted = category;
		void load(wanted);
	});

	async function load(wanted: ForumCategory | null) {
		phase = 'loading';
		try {
			const got = await listThreads({ category: wanted, limit: deep ? SEARCH_LIMIT : undefined });
			if (wanted !== category) return;
			threads = got;
			phase = 'ready';
		} catch (cause) {
			error = describeForumError(cause);
			phase = 'failed';
		}
	}

	function syncUrl() {
		const params = new URLSearchParams();
		if (category) params.set('category', category);
		if (fixedOpen) params.set('fixed', '1');
		const query = params.toString();
		history.replaceState(history.state, '', query ? `/forum?${query}` : '/forum');
	}

	function pick(next: ForumCategory | null) {
		category = next;
		syncUrl();
	}

	function toggleFixed() {
		fixedOpen = !fixedOpen;
		syncUrl();
	}

	$effect(() => {
		if (account.signedIn) void forum.refresh();
	});

	const newHref = $derived(category ? `/forum/new?category=${category}` : '/forum/new');

</script>

<Seo
	title="German learners' forum: questions and reports | Language Quiz"
	description="Report a problem with an exercise, ask a question about German, or suggest what the course should do next. Anyone can read; sign in to post."
	path="/forum"
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Forum', path: '/forum' }])]}
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} compact />

<main class="page-wide">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>
	<header class="head">
		<div>
			<h1>Forum</h1>
			<p class="lede">
				Found a wrong answer or a typo? Stuck on a rule? Say so here. Everyone
				can read; posting takes a one-email sign-in, so a reply has someone to
				go to.
			</p>
		</div>
		{#if available && account.signedIn}
			<a class="btn new" href={newHref}><Icon name="pen" size="1em" /> New topic</a>
		{:else if available}
			<button type="button" class="btn new" aria-haspopup="dialog" aria-controls="sign-in-sheet" onclick={openSignIn}>
				<Icon name="cloud" size="1em" /> Sign in to post
			</button>
		{/if}
	</header>

	{#if !available}
		<p class="notice">The forum is not switched on for this site yet.</p>
	{:else}
		{#if forum.unread.length}
			<section class="inbox" aria-labelledby="inbox-heading">
				<h2 id="inbox-heading"><Icon name="bell" size="1em" /> Replies to your topics</h2>
				<ul>
					{#each forum.unread as t (t.id)}
						<li>
							<a href="/forum/{t.id}">{t.title}</a>
							<span class="muted">· {t.replyCount} repl{t.replyCount === 1 ? 'y' : 'ies'}{t.lastReplyName ? `, last by ${t.lastReplyName}` : ''}</span>
						</li>
					{/each}
				</ul>
			</section>
		{/if}

		<div class="filters">
		<nav class="boards" aria-label="Boards">
			<button type="button" class="board" aria-pressed={category === null} onclick={() => pick(null)}>All</button>
			{#each FORUM_CATEGORIES as c (c.id)}
				<button type="button" class="board" aria-pressed={category === c.id} title={c.blurb} onclick={() => pick(c.id)}>
					{c.label}
				</button>
			{/each}
		</nav>
		<label class="search">
			<Icon name="search" size="1em" />
			<input type="search" bind:value={search} placeholder="Search topics" aria-label="Search topics" />
		</label>
		</div>

		{#if phase === 'loading'}
			<p class="muted" role="status">Loading topics…</p>
		{:else if phase === 'failed'}
			<p class="notice">{error}</p>
		{:else if threads.length && shown.length === 0}
			<p class="muted">Nothing matches “{search.trim()}”{threads.length >= SEARCH_LIMIT ? ' in the newest topics' : ''}.</p>
		{:else if threads.length === 0}
			<p class="muted">
				Nothing here yet.
				{#if account.signedIn}<a href={newHref}>Start the first topic</a>.{:else}<button type="button" class="link" onclick={openSignIn}>Sign in</button> to start the first topic.{/if}
			</p>
		{:else}
			{#if active.length}
				<ul class="list">
					{#each active as t (t.id)}
						<ThreadRow thread={t} showCategory={category === null} />
					{/each}
				</ul>
			{:else}
				<p class="muted">Nothing open here: every problem reported on this board has been fixed.</p>
			{/if}
			{#if fixed.length}
				<section class="fixed" aria-labelledby="fixed-toggle">
					<button
						type="button"
						id="fixed-toggle"
						class="fixed-toggle"
						aria-expanded={fixedOpen}
						aria-controls="fixed-list"
						onclick={toggleFixed}
					>
						<Icon name="check" size="1em" />
						Fixed ({fixed.length})
						<span class="chev" aria-hidden="true">{fixedOpen ? '▴' : '▾'}</span>
					</button>
					{#if fixedOpen}
						<ul class="list" id="fixed-list">
							{#each fixed as t (t.id)}
								<ThreadRow thread={t} showCategory={category === null} />
							{/each}
						</ul>
					{/if}
				</section>
			{/if}
		{/if}
	{/if}
</main>

<SiteFooter />

<style>
	.head {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 1rem;
		margin-bottom: 1.25rem;
	}

	h1 {
		margin: 0 0 0.4rem;
	}

	.lede {
		margin: 0;
		color: var(--ink-muted);
		max-width: 52ch;
	}

	.new {
		flex: none;
	}

	.inbox {
		margin: 0 0 1.25rem;
		padding: 0.9rem 1.1rem;
		border: 1px solid var(--accent);
		border-radius: var(--radius);
		background: var(--accent-soft);
	}

	.inbox h2 {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0 0 0.5rem;
		font-size: var(--step-0);
		color: var(--accent-ink);
	}

	.inbox ul {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.3rem;
		font-size: var(--step--1);
	}

	.inbox a {
		font-weight: 700;
		color: var(--heading);
	}

	.filters {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.6rem 1rem;
		margin-bottom: 0.5rem;
	}

	.boards {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}

	.search {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		flex: 1 1 14rem;
		max-width: 22rem;
		padding: 0 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink-muted);
	}

	.search input {
		flex: 1;
		min-width: 0;
		padding: 0.45rem 0;
		border: 0;
		background: none;
		color: var(--ink);
		font: inherit;
		font-size: var(--step--1);
		outline: none;
	}

	.search:focus-within {
		border-color: var(--accent);
		box-shadow: 0 0 0 3px var(--accent-soft);
	}

	.board {
		padding: 0.4rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	.board[aria-pressed='true'] {
		border-color: var(--navy);
		background: var(--navy);
		color: #fff;
	}

	.list {
		margin: 0.5rem 0 0;
		padding: 0;
		list-style: none;
	}

	.muted {
		color: var(--ink-muted);
	}

	.fixed {
		margin-top: 1.25rem;
		padding-top: 0.75rem;
		border-top: 1px solid var(--line);
	}

	.fixed-toggle {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.4rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	.fixed-toggle[aria-expanded='true'] {
		border-color: var(--line-strong);
		color: var(--ink);
	}

	.link {
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-weight: 600;
		text-decoration: underline;
		cursor: pointer;
	}

	.notice {
		padding: 0.8rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	@media (max-width: 36rem) {
		.head {
			flex-direction: column;
		}
	}
</style>
