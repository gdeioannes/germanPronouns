<script lang="ts">
	// One topic and its replies. Reading is public; replying asks for the
	// account. The author (and a moderator) can mark it answered or fixed,
	// switch reply notifications off, or delete it.
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import PostingAs from '$lib/components/forum/PostingAs.svelte';
	import { announce } from '$lib/a11y.svelte';
	import {
		LIMITS,
		STATUS_LABELS,
		ago,
		categoryLabel,
		defaultName,
		reportKindLabel,
		type ForumPost,
		type ForumThread,
		type ThreadStatus
	} from '$lib/domain/forum';
	import {
		addPost,
		deletePost,
		deleteThread,
		describeForumError,
		getThread,
		listPosts,
		myLikes,
		setLike,
		setNotify,
		setStatus
	} from '$lib/services/forum';
	import { cloudConfigured } from '$lib/services/firebase';
	import { track } from '$lib/services/analytics';
	import { account } from '$lib/state/account.svelte';
	import { forum } from '$lib/state/forum.svelte';

	const available = cloudConfigured();
	const id = $derived(page.params.id ?? '');

	let thread = $state<ForumThread | null>(null);
	let posts = $state<ForumPost[]>([]);
	let phase = $state<'loading' | 'ready' | 'missing' | 'failed'>('loading');
	let error = $state('');

	let reply = $state('');
	let busy = $state(false);
	let replyError = $state<string | null>(null);
	let confirmingDelete = $state(false);

	/** What this learner has liked here: 'thread' or a post id. */
	let liked = $state<Set<string>>(new Set());
	let liking = false;

	$effect(() => {
		if (!available || !id) return;
		void load(id);
	});

	async function load(which: string) {
		phase = 'loading';
		try {
			const [t, p] = await Promise.all([getThread(which), listPosts(which)]);
			if (which !== id) return;
			if (!t) {
				phase = 'missing';
				return;
			}
			thread = t;
			posts = p;
			phase = 'ready';
			const uid = account.userId;
			if (uid) liked = await myLikes(which, p.map((x) => x.id), uid).catch(() => new Set<string>());
		} catch (cause) {
			error = describeForumError(cause);
			phase = 'failed';
		}
	}

	// Opening the topic reads its replies: the "new reply" mark goes away.
	$effect(() => {
		if (account.signedIn) void forum.refresh();
		if (thread && account.signedIn) void forum.read(thread);
	});

	/** A tap on a heart: optimistic, undone if the write is refused. */
	async function toggleLike(postId: string | null) {
		const uid = account.userId;
		if (!uid || !thread || liking) return;
		const key = postId ?? 'thread';
		const on = !liked.has(key);
		const delta = on ? 1 : -1;
		const next = new Set(liked);
		if (on) next.add(key);
		else next.delete(key);
		liked = next;
		if (postId) posts = posts.map((p) => (p.id === postId ? { ...p, likeCount: p.likeCount + delta } : p));
		else thread = { ...thread, likeCount: thread.likeCount + delta };
		liking = true;
		try {
			await setLike(thread.id, postId, uid, on);
		} catch (cause) {
			const back = new Set(liked);
			if (on) back.delete(key);
			else back.add(key);
			liked = back;
			if (postId) posts = posts.map((p) => (p.id === postId ? { ...p, likeCount: p.likeCount - delta } : p));
			else thread = { ...thread, likeCount: thread.likeCount - delta };
			replyError = describeForumError(cause);
		} finally {
			liking = false;
		}
	}

	const mine = $derived(Boolean(thread && account.userId && thread.authorUid === account.userId));
	const canModerate = $derived(mine || forum.admin);
	const STATUSES: ThreadStatus[] = ['open', 'answered', 'fixed'];

	async function send(event: SubmitEvent) {
		event.preventDefault();
		const uid = account.userId;
		if (!uid || !thread || reply.trim().length < 2) return;
		busy = true;
		replyError = null;
		try {
			const post = await addPost(thread.id, uid, forum.name || defaultName(account.email), reply);
			posts = [...posts, post];
			thread = {
				...thread,
				replyCount: thread.replyCount + 1,
				lastReplyAt: post.createdAt,
				lastReplyName: post.authorName,
				updatedAt: post.createdAt
			};
			if (mine) void forum.read(thread);
			reply = '';
			track('forum_reply', { category: thread.category });
			announce('Reply posted.');
		} catch (cause) {
			replyError = describeForumError(cause);
		} finally {
			busy = false;
		}
	}

	async function mark(status: ThreadStatus) {
		if (!thread || thread.status === status) return;
		const was = thread.status;
		thread = { ...thread, status };
		try {
			await setStatus(thread.id, status);
			announce(`Marked ${STATUS_LABELS[status].toLowerCase()}.`);
		} catch (cause) {
			thread = { ...thread, status: was };
			replyError = describeForumError(cause);
		}
	}

	async function toggleNotify() {
		if (!thread) return;
		const next = !thread.notify;
		thread = { ...thread, notify: next };
		try {
			await setNotify(thread.id, next);
		} catch (cause) {
			thread = { ...thread, notify: !next };
			replyError = describeForumError(cause);
		}
	}

	async function remove() {
		if (!thread) return;
		try {
			await deleteThread(thread.id);
			await forum.refresh(true);
			await goto('/forum');
		} catch (cause) {
			replyError = describeForumError(cause);
		}
	}

	async function removePost(post: ForumPost) {
		if (!thread) return;
		try {
			await deletePost(thread.id, post.id);
			posts = posts.filter((p) => p.id !== post.id);
		} catch (cause) {
			replyError = describeForumError(cause);
		}
	}

	const quizHref = $derived(
		thread?.courseId && thread.quizId ? `/course/${thread.courseId}/quiz/${thread.quizId}` : null
	);

	/**
	 * "Report": a new topic on the problem-reports board, with the post's address
	 * and a quote already filled in, so a reader needs no moderator's email.
	 */
	function reportHref(post: ForumPost | null): string {
		if (!thread) return '/forum/new?category=report';
		const where = post ? `a reply by ${post.authorName}` : `the topic by ${thread.authorName}`;
		const quote = (post ? post.body : thread.body).slice(0, 200);
		const params = new URLSearchParams({
			category: 'report',
			title: `Report a forum post: ${thread.title}`.slice(0, 140),
			body: `Reporting ${where} in /forum/${thread.id}${post ? `#post-${post.id}` : ''}.

“${quote}”

Why it should be looked at: `
		});
		return `/forum/new?${params}`;
	}
</script>

<Seo
	title="{thread?.title ?? 'Topic'} — Forum — Language Quiz"
	description={thread ? thread.body.slice(0, 160) : 'A topic on the Language Quiz forum.'}
	path="/forum/{id}"
	noindex
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} compact />

<!-- A heart with its count. Signed out it still shows the count, and says
     why it does nothing. -->
{#snippet likeButton(postId: string | null, count: number)}
	{@const on = liked.has(postId ?? 'thread')}
	<button
		type="button"
		class="like"
		class:on
		aria-pressed={on}
		aria-label={on ? 'Unlike' : 'Like'}
		title={account.signedIn ? (on ? 'Unlike' : 'Like') : 'Sign in to like'}
		disabled={!account.signedIn}
		onclick={() => toggleLike(postId)}
	>
		<Icon name="heart" size="1em" />
		<span class="tnum">{count}</span>
	</button>
{/snippet}

<main class="page-wide">
	<a class="back-link" href="/forum"><Icon name="arrowLeft" size="1em" /> Forum</a>

	{#if !available}
		<p class="lede">The forum is not switched on for this site yet.</p>
	{:else if phase === 'loading'}
		<p class="lede" role="status">Loading…</p>
	{:else if phase === 'missing'}
		<h1>Not here</h1>
		<p class="lede">That topic does not exist, or was deleted.</p>
		<a class="btn" href="/forum">Back to the forum</a>
	{:else if phase === 'failed'}
		<p class="notice">{error}</p>
	{:else if thread}
		<article class="topic" data-status={thread.status}>
			<p class="crumbs">
				<a href="/forum?category={thread.category}">{categoryLabel(thread.category)}</a>
				<span class="chip status">{STATUS_LABELS[thread.status] ?? 'Open'}</span>
			</p>
			<h1>{thread.title}</h1>
			<p class="meta">
				<strong>{thread.authorName}</strong> · {ago(thread.createdAt)}
				{#if thread.replyCount}· {thread.replyCount} repl{thread.replyCount === 1 ? 'y' : 'ies'}{/if}
				· <a class="report" href={reportHref(null)}>Report</a>
			</p>

			{#if thread.quizTitle || thread.reportKind}
				<aside class="about">
					<p class="label">About</p>
					{#if thread.reportKind}<p class="kind">{reportKindLabel(thread.reportKind)}</p>{/if}
					{#if thread.quizTitle}
						<p>
							{#if quizHref}<a href={quizHref}>{thread.quizTitle}</a>{:else}{thread.quizTitle}{/if}
							{#if thread.level}<span class="muted">{` · ${thread.level}`}</span>{/if}
							{#if thread.questionNumber}<span class="muted">{` · question ${thread.questionNumber}`}</span>{/if}
						</p>
					{/if}
					{#if thread.questionText}<p class="quote">“{thread.questionText}”</p>{/if}
				</aside>
			{/if}

			<div class="body">{thread.body}</div>

			{@render likeButton(null, thread.likeCount)}

			{#if canModerate}
				<div class="tools">
					<span class="muted">Mark as</span>
					{#each STATUSES as s (s)}
						<button type="button" class="pill" aria-pressed={thread.status === s} onclick={() => mark(s)}>{STATUS_LABELS[s]}</button>
					{/each}
					{#if mine}
						<button type="button" class="pill" aria-pressed={!thread.notify} onclick={toggleNotify}>
							<Icon name="bell" size="1em" /> {thread.notify ? 'Notify me about replies' : "Don't notify me"}
						</button>
					{/if}
					{#if confirmingDelete}
						<button type="button" class="pill danger" onclick={remove}><Icon name="trash" size="1em" /> Yes, delete the topic</button>
						<button type="button" class="btn-quiet" onclick={() => (confirmingDelete = false)}>Cancel</button>
					{:else}
						<button type="button" class="pill" onclick={() => (confirmingDelete = true)}><Icon name="trash" size="1em" /> Delete</button>
					{/if}
				</div>
			{/if}
		</article>

		<section class="replies" aria-labelledby="replies-heading">
			<h2 id="replies-heading">{posts.length ? `${posts.length} repl${posts.length === 1 ? 'y' : 'ies'}` : 'No replies yet'}</h2>
			{#each posts as p (p.id)}
				<article class="post" id="post-{p.id}" class:author={p.authorUid === thread.authorUid}>
					<p class="meta">
						<strong>{p.authorName}</strong>
						{#if p.authorUid === thread.authorUid}<span class="chip">author</span>{/if}
						· {ago(p.createdAt)}
						{#if (account.userId && p.authorUid === account.userId) || forum.admin}
							<button type="button" class="btn-quiet x" onclick={() => removePost(p)}>Delete</button>
						{/if}
						· <a class="report" href={reportHref(p)}>Report</a>
					</p>
					<div class="body">{p.body}</div>
					{@render likeButton(p.id, p.likeCount)}
				</article>
			{/each}
		</section>

		<section class="write">
			{#if account.signedIn}
				<form onsubmit={send}>
					<label class="field">
						<span>Your reply</span>
						<textarea bind:value={reply} rows="5" maxlength={LIMITS.body} required></textarea>
					</label>
					<PostingAs />
					{#if replyError}
						<p class="bad" role="alert"><Icon name="info" size="1.05em" /><span>{replyError}</span></p>
					{/if}
					<button type="submit" class="btn" disabled={busy || reply.trim().length < 2}>{busy ? 'Posting…' : 'Post reply'}</button>
				</form>
			{:else}
				<p class="lede">Sign in to reply. One email, no password — and you come straight back here.</p>
				<div class="card">
					<AccountCard heading={false} reason="Sign in to reply on the forum." returnTo="/forum/{id}" />
				</div>
			{/if}
		</section>
	{/if}
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.4rem;
		font-size: var(--step-2);
	}

	.lede {
		margin: 0 0 1rem;
		color: var(--ink-muted);
	}

	.crumbs {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin: 0 0 0.4rem;
		font-size: var(--step--1);
		font-weight: 700;
	}

	.crumbs a {
		color: var(--ink-muted);
		text-decoration: none;
	}

	.chip {
		padding: 0.05rem 0.55rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
	}

	.topic[data-status='answered'] .status {
		border-color: var(--navy);
		color: var(--navy);
	}

	.topic[data-status='fixed'] .status {
		border-color: var(--right);
		color: var(--right);
		background: var(--right-bg);
	}

	.meta .report {
		color: inherit;
		text-decoration: underline;
		text-underline-offset: 0.15em;
	}

	.meta {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.35rem;
		max-width: none;
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.about {
		margin: 0 0 1rem;
		padding: 0.8rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font-size: var(--step--1);
	}

	.about p {
		margin: 0;
		max-width: none;
	}

	.about .label {
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		margin-bottom: 0.2rem;
	}

	.about .kind {
		font-weight: 700;
		color: var(--heading);
	}

	.quote {
		margin-top: 0.3rem !important;
		font-style: italic;
	}

	.muted {
		color: var(--ink-muted);
	}

	.body {
		white-space: pre-wrap;
		overflow-wrap: anywhere;
		line-height: 1.6;
	}

	.tools {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.45rem;
		margin-top: 1rem;
		padding-top: 0.8rem;
		border-top: 1px dashed var(--line);
		font-size: var(--step--1);
	}

	.pill {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		padding: 0.3rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	.pill[aria-pressed='true'] {
		border-color: var(--navy);
		background: var(--navy);
		color: #fff;
	}

	.pill.danger {
		border-color: var(--wrong);
		background: var(--wrong);
		color: #fff;
	}

	.like {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		margin-top: 0.6rem;
		padding: 0.25rem 0.7rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.like:hover:not(:disabled) {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	.like.on {
		border-color: var(--accent);
		background: var(--accent-soft);
		color: var(--accent-ink);
	}

	.like.on :global(svg) {
		fill: currentColor;
	}

	.like:disabled {
		cursor: default;
		opacity: 0.7;
	}

	.replies {
		margin-top: 2rem;
	}

	.replies h2 {
		margin: 0 0 0.5rem;
		font-size: var(--step-0);
	}

	.post {
		padding: 0.9rem 0;
		border-top: 1px solid var(--line);
	}

	.post .meta {
		margin-bottom: 0.4rem;
	}

	.post .x {
		margin-left: auto;
	}

	.write {
		margin-top: 2rem;
		padding-top: 1.25rem;
		border-top: 1px solid var(--line);
	}

	.write form {
		display: flex;
		flex-direction: column;
		gap: 0.9rem;
		align-items: flex-start;
	}

	.field {
		width: 100%;
	}

	.field span {
		display: block;
		margin-bottom: 0.3rem;
		font-size: var(--step--1);
		font-weight: 600;
	}

	.field textarea {
		width: 100%;
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		resize: vertical;
	}

	.bad,
	.notice {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		max-width: none;
		margin: 0;
		padding: 0.6rem 0.9rem;
		border: 1px solid var(--wrong);
		border-radius: var(--radius-sm);
		background: var(--wrong-bg);
		color: var(--wrong);
		font-size: var(--step--1);
	}

	.notice {
		border-color: var(--line);
		background: var(--surface-alt);
		color: var(--ink-muted);
	}
</style>
