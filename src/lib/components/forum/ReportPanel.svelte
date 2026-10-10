<script lang="ts">
	// "Report a problem", inside the quiz. The exercise and the question are
	// already filled in; the learner picks what is wrong, writes a line if they
	// like, and the report lands as a topic on the forum's reports board.
	//
	// Reading is public, so the reports already filed on this exercise are
	// shown to everyone — often the answer is "yes, known, fixed in the next
	// content version". Filing needs the account, because a reply has to have
	// somebody to go to.
	import Icon from '$lib/icons/Icon.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import PostingAs from '$lib/components/forum/PostingAs.svelte';
	import ThreadRow from '$lib/components/forum/ThreadRow.svelte';
	import { announce } from '$lib/a11y.svelte';
	import {
		LIMITS,
		REPORT_KINDS,
		defaultName,
		reportBody,
		reportTitle,
		type ForumThread,
		type QuestionRef,
		type ReportKind,
		type ReportTarget
	} from '$lib/domain/forum';
	import { createThread, describeForumError, listThreads } from '$lib/services/forum';
	import { track } from '$lib/services/analytics';
	import { account } from '$lib/state/account.svelte';
	import { forum } from '$lib/state/forum.svelte';

	let {
		target,
		/** True while the panel is on screen; the existing reports load then. */
		open
	}: { target: ReportTarget; open: boolean } = $props();

	let kind = $state<ReportKind | ''>('');
	let note = $state('');
	/** The literal checkbox: ticked = "don't tell me about replies". */
	let noNotify = $state(false);
	/** The question number the report names; starts as the one on screen. */
	let questionNumber = $state<number | ''>('');
	let busy = $state(false);
	let error = $state<string | null>(null);
	let filed = $state<ForumThread | null>(null);

	let existing = $state<ForumThread[]>([]);
	let existingState = $state<'idle' | 'loading' | 'ready' | 'failed'>('idle');

	/** The question the quiz is on now, as a sentence. */
	const onScreen = $derived<QuestionRef | null>(target.question ?? null);

	// Each opening starts from the question on screen at that moment; the
	// learner can still change the number before sending.
	let openedFor: QuestionRef | null | undefined = undefined;
	$effect(() => {
		if (!open) return;
		if (openedFor !== onScreen) {
			openedFor = onScreen;
			questionNumber = onScreen?.number ?? '';
		}
	});

	$effect(() => {
		if (!open || !target.quizId || existingState !== 'idle') return;
		void loadExisting(target.quizId);
	});

	async function loadExisting(quizId: string) {
		existingState = 'loading';
		try {
			existing = await listThreads({ quizId, limit: 10 });
			existingState = 'ready';
		} catch {
			existingState = 'failed';
		}
	}

	$effect(() => {
		if (account.signedIn) void forum.refresh();
	});

	const canSend = $derived(
		Boolean(kind) && !busy && (kind !== 'other' || note.trim().length >= 5)
	);

	async function send(event: SubmitEvent) {
		event.preventDefault();
		const uid = account.userId;
		if (!uid || !kind) return;
		busy = true;
		error = null;
		const question: QuestionRef | null =
			typeof questionNumber === 'number' && questionNumber > 0
				? onScreen && onScreen.number === questionNumber
					? onScreen
					: { number: questionNumber, total: onScreen?.total ?? 0, text: '' }
				: null;
		const where: ReportTarget = { ...target, question };
		const name = forum.name || defaultName(account.email);
		try {
			const id = await createThread(uid, name, {
				category: 'report',
				title: reportTitle(kind, where),
				body: reportBody(note, where),
				notify: !noNotify,
				target: where,
				reportKind: kind
			});
			const now = Date.now();
			const thread: ForumThread = {
				id,
				category: 'report',
				title: reportTitle(kind, where),
				body: reportBody(note, where),
				authorUid: uid,
				authorName: name,
				createdAt: now,
				updatedAt: now,
				replyCount: 0,
				lastReplyAt: null,
				lastReplyName: null,
				status: 'open',
				notify: !noNotify,
				likeCount: 0,
				courseId: where.courseId,
				quizId: where.quizId,
				quizTitle: where.quizTitle,
				quizType: where.quizType,
				level: where.level,
				questionNumber: question?.number,
				questionText: question?.text || undefined,
				reportKind: kind
			};
			forum.filed(thread);
			existing = [thread, ...existing];
			filed = thread;
			track('forum_report', { course: target.courseId, quiz: target.quizId ?? '', kind });
			announce('Report sent. Thank you.');
			kind = '';
			note = '';
		} catch (cause) {
			error = describeForumError(cause);
		} finally {
			busy = false;
		}
	}
</script>

<div class="report">
	<!-- Where: filled in by the quiz, so the learner never has to say which
	     exercise or copy a sentence. -->
	<section class="where" aria-label="What you are reporting on">
		<p class="label">Exercise</p>
		<p class="value">
			<strong>{target.quizTitle ?? target.quizId}</strong>{#if target.level}<span class="muted">{` · ${target.level}`}</span>{/if}
		</p>
		{#if onScreen}
			<p class="label">Question on screen</p>
			<p class="value">
				<strong class="tnum">{onScreen.number}</strong><span class="muted tnum">{` of ${onScreen.total}`}</span>
				{#if onScreen.text}<span class="quote">“{onScreen.text}”</span>{/if}
			</p>
		{:else}
			<p class="value muted">No single question is on screen — the report is about the whole exercise.</p>
		{/if}
	</section>

	{#if filed}
		<section class="sent" role="status">
			<p class="ok">
				<Icon name="check" size="1.1em" />
				<span><strong>Report sent.</strong> Thank you — this is how the course gets better.</span>
			</p>
			<p>
				It is now a topic on the forum, where you can add to it and see the
				reply{filed.notify ? '. You will be told here when someone answers' : ''}.
			</p>
			<div class="actions">
				<a class="btn" href="/forum/{filed.id}">Open the topic <Icon name="arrowRight" size="1em" /></a>
				<button type="button" class="btn btn-ghost" onclick={() => (filed = null)}>Report something else</button>
			</div>
		</section>
	{:else if !account.available}
		<p class="muted">Reporting is not switched on for this site yet. You can still write via the contact page.</p>
	{:else if !account.signedIn}
		<section class="gate">
			<p>
				Reports go to the forum, where anyone can read them and the answer is
				kept for the next learner. To send one — and to be told when it is
				answered — sign in first. It takes one email, and no password.
			</p>
			<AccountCard
				heading={false}
				reason="Signing in lets us reply to your report, and shows you the answer the next time you are here."
				returnTo={target.quizId ? `/course/${target.courseId}/quiz/${target.quizId}` : `/course/${target.courseId}`}
			/>
		</section>
	{:else}
		<form class="form" onsubmit={send}>
			<label class="field">
				<span>What is wrong?</span>
				<select bind:value={kind} required>
					<option value="" disabled>Choose one…</option>
					{#each REPORT_KINDS as k (k.id)}
						<option value={k.id}>{k.label}</option>
					{/each}
				</select>
			</label>

			{#if onScreen}
				<label class="field small">
					<span>Question number</span>
					<input type="number" min="1" max={onScreen.total || undefined} bind:value={questionNumber} class="tnum" />
				</label>
			{/if}

			<label class="field">
				<span>Tell us more {kind === 'other' ? '' : '(optional)'}</span>
				<textarea
					bind:value={note}
					rows="4"
					maxlength={LIMITS.body - 600}
					placeholder="What did you type, what did you expect, what happened?"
				></textarea>
			</label>

			<label class="check">
				<input type="checkbox" bind:checked={noNotify} />
				<span>I don't want to be notified about replies</span>
			</label>

			<PostingAs />

			{#if error}
				<p class="bad" role="alert"><Icon name="info" size="1.05em" /><span>{error}</span></p>
			{/if}

			<button type="submit" class="btn send" disabled={!canSend}>
				<Icon name="flag" size="1em" /> {busy ? 'Sending…' : 'Send the report'}
			</button>
		</form>
	{/if}

	{#if target.quizId}
		<section class="existing" aria-labelledby="existing-reports">
			<h3 id="existing-reports">Reports on this exercise</h3>
			{#if existingState === 'loading'}
				<p class="muted">Looking…</p>
			{:else if existingState === 'failed'}
				<p class="muted">Couldn't load them right now.</p>
			{:else if existingState === 'ready' && existing.length === 0}
				<p class="muted">None yet. If something is off, yours would be the first — and welcome.</p>
			{:else if existing.length}
				<ul>
					{#each existing as t (t.id)}
						<ThreadRow thread={t} showCategory={false} showTarget={false} />
					{/each}
				</ul>
			{/if}
			<p class="to-forum"><a href="/forum?category=report">All problem reports <Icon name="arrowRight" size="1em" /></a></p>
		</section>
	{/if}
</div>

<style>
	.report {
		display: flex;
		flex-direction: column;
		gap: 1.25rem;
	}

	.where {
		padding: 0.85rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.label {
		margin: 0;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.label + .value {
		margin: 0.1rem 0 0.6rem;
	}

	.value {
		margin: 0;
		max-width: none;
		font-size: var(--step--1);
	}

	.value:last-child {
		margin-bottom: 0;
	}

	.quote {
		display: block;
		margin-top: 0.2rem;
		font-style: italic;
		color: var(--ink);
	}

	.muted {
		color: var(--ink-muted);
	}

	.form {
		display: flex;
		flex-direction: column;
		gap: 0.9rem;
	}

	.field span {
		display: block;
		margin-bottom: 0.3rem;
		font-size: var(--step--1);
		font-weight: 600;
	}

	.field select,
	.field textarea,
	.field input {
		width: 100%;
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	.field.small input {
		width: 7rem;
	}

	.field textarea {
		resize: vertical;
		min-height: 5.5rem;
	}

	.check {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		font-size: var(--step--1);
		cursor: pointer;
	}

	.send {
		align-self: flex-start;
	}

	.gate p,
	.sent p {
		margin: 0 0 0.9rem;
		max-width: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.ok {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		padding: 0.7rem 0.9rem;
		border: 1px solid var(--right);
		border-radius: var(--radius-sm);
		background: var(--right-bg);
		color: var(--right) !important;
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
		flex-wrap: wrap;
		gap: 0.6rem;
	}

	.existing h3 {
		margin: 0 0 0.25rem;
		font-size: var(--step-0);
	}

	.existing ul {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.existing .muted {
		margin: 0.25rem 0 0;
		font-size: var(--step--1);
	}

	.to-forum {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
	}

	.to-forum a {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		font-weight: 700;
		text-decoration: none;
	}
</style>
