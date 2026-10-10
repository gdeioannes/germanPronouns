<script lang="ts">
	// One topic in a list: the forum index, the "reports on this exercise"
	// list in the quiz, the learner's own topics.
	import Icon from '$lib/icons/Icon.svelte';
	import { ago, categoryLabel, STATUS_LABELS, type ForumThread } from '$lib/domain/forum';
	import { forum } from '$lib/state/forum.svelte';

	let {
		thread,
		/** Hide the board chip where every row is on the same board. */
		showCategory = true,
		/** Hide the exercise line where every row is about the same exercise. */
		showTarget = true
	}: { thread: ForumThread; showCategory?: boolean; showTarget?: boolean } = $props();

	const unread = $derived(forum.unread.some((t) => t.id === thread.id));
</script>

<li class="row" data-status={thread.status}>
	<a class="title" href="/forum/{thread.id}">
		{thread.title}
		{#if unread}<span class="new">New reply</span>{/if}
	</a>
	<p class="meta">
		{#if showCategory}<span class="chip cat">{categoryLabel(thread.category)}</span>{/if}
		<span class="chip status">{STATUS_LABELS[thread.status] ?? 'Open'}</span>
		<span>{thread.authorName}</span>
		<span aria-hidden="true">·</span>
		<span>{ago(thread.updatedAt)}</span>
		<span aria-hidden="true">·</span>
		<span class="replies"><Icon name="chat" size="1em" /> {thread.replyCount}</span>
		{#if thread.likeCount}<span class="replies"><Icon name="heart" size="1em" /> {thread.likeCount}</span>{/if}
	</p>
	{#if showTarget && thread.quizTitle}
		<p class="target">
			<Icon name="flag" size="0.95em" />
			<span>
				{thread.quizTitle}{#if thread.level}{` (${thread.level})`}{/if}{#if thread.questionNumber}, question {thread.questionNumber}{/if}
			</span>
		</p>
	{/if}
</li>

<style>
	.row {
		padding: 0.8rem 0;
		border-top: 1px solid var(--line);
	}

	.title {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		flex-wrap: wrap;
		color: var(--heading);
		font-weight: 700;
		text-decoration: none;
	}

	.title:hover {
		color: var(--accent-ink);
	}

	.new {
		padding: 0.1rem 0.5rem;
		border-radius: 999px;
		background: var(--accent);
		color: #fff;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.04em;
		text-transform: uppercase;
	}

	.meta,
	.target {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem;
		max-width: none;
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.chip {
		padding: 0.05rem 0.55rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 700;
	}

	.row[data-status='answered'] .status {
		border-color: var(--navy);
		color: var(--navy);
	}

	.row[data-status='fixed'] .status {
		border-color: var(--right);
		color: var(--right);
		background: var(--right-bg);
	}

	.replies {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
	}

	.target {
		gap: 0.35rem;
	}
</style>
