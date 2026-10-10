<script lang="ts">
	// A new topic, by hand. The in-quiz report panel is the fast path for
	// problems; this page is for questions, ideas and anything with a title of
	// its own. "?category=" preselects a board.
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import PostingAs from '$lib/components/forum/PostingAs.svelte';
	import { FORUM_CATEGORIES, LIMITS, defaultName, isCategory, type ForumCategory } from '$lib/domain/forum';
	import { createThread, describeForumError } from '$lib/services/forum';
	import { cloudConfigured } from '$lib/services/firebase';
	import { track } from '$lib/services/analytics';
	import { account } from '$lib/state/account.svelte';
	import { forum } from '$lib/state/forum.svelte';

	const available = cloudConfigured();

	let category = $state<ForumCategory>('question');
	let title = $state('');
	let body = $state('');
	let noNotify = $state(false);
	let busy = $state(false);
	let error = $state<string | null>(null);

	onMount(() => {
		const wanted = new URLSearchParams(window.location.search).get('category');
		if (isCategory(wanted)) category = wanted;
	});

	$effect(() => {
		if (account.signedIn) void forum.refresh();
	});

	const canSend = $derived(title.trim().length >= 4 && body.trim().length >= 10 && !busy);

	async function send(event: SubmitEvent) {
		event.preventDefault();
		const uid = account.userId;
		if (!uid || !canSend) return;
		busy = true;
		error = null;
		try {
			const id = await createThread(uid, forum.name || defaultName(account.email), {
				category,
				title,
				body,
				notify: !noNotify
			});
			track('forum_thread', { category });
			await forum.refresh(true);
			await goto(`/forum/${id}`);
		} catch (cause) {
			error = describeForumError(cause);
		} finally {
			busy = false;
		}
	}
</script>

<Seo title="New topic — Forum — Language Quiz" description="Start a new topic on the Language Quiz forum." path="/forum/new" noindex />

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} compact />

<main class="page">
	<a class="back-link" href="/forum"><Icon name="arrowLeft" size="1em" /> Forum</a>
	<h1>New topic</h1>

	{#if !available}
		<p class="lede">The forum is not switched on for this site yet.</p>
	{:else if !account.signedIn}
		<p class="lede">
			Posting needs an account, so a reply has someone to go to. One email,
			no password — and you come straight back here.
		</p>
		<section class="card">
			<AccountCard heading={false} reason="Sign in to post on the forum and to be told when someone replies." returnTo="/forum/new" />
		</section>
	{:else}
		<form class="form" onsubmit={send}>
			<label class="field">
				<span>Board</span>
				<select bind:value={category}>
					{#each FORUM_CATEGORIES as c (c.id)}
						<option value={c.id}>{c.label}</option>
					{/each}
				</select>
			</label>
			<p class="hint">{FORUM_CATEGORIES.find((c) => c.id === category)?.blurb}</p>

			{#if category === 'report'}
				<p class="tip">
					<Icon name="flag" size="1em" />
					<span>
						Reporting a mistake in an exercise? The <strong>flag button on the
						exercise itself</strong> files it with the question number already
						filled in. This form works too — say which exercise it is.
					</span>
				</p>
			{/if}

			<label class="field">
				<span>Title</span>
				<input type="text" bind:value={title} maxlength={LIMITS.title} required placeholder="One line that says what it is about" />
			</label>

			<label class="field">
				<span>Your post</span>
				<textarea bind:value={body} rows="8" maxlength={LIMITS.body} required></textarea>
			</label>

			<label class="check">
				<input type="checkbox" bind:checked={noNotify} />
				<span>I don't want to be notified about replies</span>
			</label>

			<PostingAs />

			{#if error}
				<p class="bad" role="alert"><Icon name="info" size="1.05em" /><span>{error}</span></p>
			{/if}

			<div class="actions">
				<button type="submit" class="btn" disabled={!canSend}>{busy ? 'Posting…' : 'Post the topic'}</button>
				<a class="btn btn-ghost" href="/forum">Cancel</a>
			</div>
		</form>
	{/if}
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 1rem;
	}

	.lede {
		margin: 0 0 1.25rem;
		color: var(--ink-muted);
	}

	.form {
		display: flex;
		flex-direction: column;
		gap: 0.9rem;
		max-width: 40rem;
	}

	.field span {
		display: block;
		margin-bottom: 0.3rem;
		font-size: var(--step--1);
		font-weight: 600;
	}

	.field select,
	.field input,
	.field textarea {
		width: 100%;
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	.field textarea {
		resize: vertical;
	}

	.hint {
		margin: -0.5rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.tip {
		display: flex;
		gap: 0.5rem;
		align-items: flex-start;
		max-width: none;
		margin: 0;
		padding: 0.7rem 0.9rem;
		border: 1px solid var(--accent);
		border-radius: var(--radius-sm);
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-size: var(--step--1);
	}

	.check {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		font-size: var(--step--1);
		cursor: pointer;
	}

	.bad {
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

	.actions {
		display: flex;
		gap: 0.6rem;
		flex-wrap: wrap;
	}
</style>
