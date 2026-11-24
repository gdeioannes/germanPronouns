<script lang="ts">
	// Everything the learner pinned: single questions (with one button to
	// practise the fill-in ones together) and whole exercises. Lives in this
	// browser and, when signed in, in the account; nothing here is prerendered
	// but the frame.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { pins } from '$lib/state/pins.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { learnt, practisable, PRACTICE_PREFIX } from '$lib/domain/pinPractice';
	import type { Pin } from '$lib/domain/pins';
	import { announce } from '$lib/a11y.svelte';
	import { t } from '$lib/i18n/t';
	import { onMount } from 'svelte';

	/** Question pins right the last three times in the drill. */
	let learntIds = $state<Set<string>>(new Set());

	onMount(async () => {
		await Promise.all([pins.load(), progress.ensureLoaded()]);
		const done = new Set<string>();
		for (const pin of pins.questions) {
			if (!practisable(pin)) continue;
			if (learnt(await progress.verdictsFor(PRACTICE_PREFIX, pin.key!))) done.add(pin.id);
		}
		learntIds = done;
	});

	const practiceCount = $derived(pins.questions.filter(practisable).length);

	const quizHref = (pin: Pin) => `/course/${pin.courseId}/quiz/${pin.quizId}`;

	/** The last unpin, for "Undo". */
	let undone = $state<Pin | null>(null);

	async function unpin(pin: Pin) {
		await pins.unpin(pin.id);
		undone = pin;
		announce(t('Unpinned.'));
	}

	async function undo() {
		if (!undone) return;
		const pin = undone;
		undone = null;
		if (pin.kind === 'quiz') await pins.pinQuiz(pin);
		else if (pin.text) await pins.pinQuestion(pin, pin.text);
		announce(t('Pinned again.'));
	}
</script>

<Seo
	title="Pinned — Language Quiz"
	description="The exercises and questions you pinned to practise again."
	path="/pinned"
	noindex
/>

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>
	<h1><Icon name="pin" size="0.85em" /> {t('Pinned')}</h1>
	<p class="lede">
		{t('What you saved to come back to. In any exercise, tap Pin at the top to save the whole exercise or the question on screen.')}
	</p>

	{#if undone}
		<p class="undo" role="status">
			<span>{t('Unpinned.')}</span>
			<button type="button" class="btn-quiet" onclick={undo}>{t('Undo')}</button>
		</p>
	{/if}

	{#if pins.loaded && pins.items.length === 0}
		<section class="card empty">
			<Icon name="pin" size="2em" />
			<h2>{t('Nothing pinned yet')}</h2>
			<p>
				{t('Missed a sentence you want to see again, or found an exercise worth repeating? Open it, tap Pin at the top, and it waits for you here.')}
			</p>
		</section>
	{/if}

	{#if pins.questions.length}
		<section class="group" aria-labelledby="pinned-questions">
			<div class="group-head">
				<h2 id="pinned-questions">{t('Questions')} <span class="count">{pins.questions.length}</span></h2>
				{#if practiceCount}
					<a class="btn" href="/pinned/practice">
						<Icon name="play" size="1em" />
						{t('Practise my pinned questions')}
					</a>
				{/if}
			</div>
			<ul class="list">
				{#each pins.questions as pin (pin.id)}
					<li class="item">
						<div class="body">
							<p class="sentence" lang="de">{pin.text}</p>
							<p class="meta">
								<a href={quizHref(pin)}>{pin.quizTitle}</a>
								{#if pin.level}<span class="level">{pin.level}</span>{/if}
								{#if !practisable(pin)}<span class="note">{t('practise it in its exercise')}</span>{/if}
							</p>
							{#if learntIds.has(pin.id)}
								<p class="learnt">
									<Icon name="check" size="1em" />
									{t('Right the last three times. Ready to unpin it?')}
								</p>
							{/if}
						</div>
						<button type="button" class="unpin" aria-label={t('Unpin')} title={t('Unpin')} onclick={() => unpin(pin)}>
							<Icon name="close" size="1em" />
						</button>
					</li>
				{/each}
			</ul>
		</section>
	{/if}

	{#if pins.quizzes.length}
		<section class="group" aria-labelledby="pinned-exercises">
			<div class="group-head">
				<h2 id="pinned-exercises">{t('Exercises')} <span class="count">{pins.quizzes.length}</span></h2>
			</div>
			<ul class="list">
				{#each pins.quizzes as pin (pin.id)}
					<li class="item">
						<a class="body exercise" href={quizHref(pin)}>
							<strong>{pin.quizTitle}</strong>
							{#if pin.level}<span class="level">{pin.level}</span>{/if}
							<Icon name="arrowRight" size="1em" />
						</a>
						<button type="button" class="unpin" aria-label={t('Unpin')} title={t('Unpin')} onclick={() => unpin(pin)}>
							<Icon name="close" size="1em" />
						</button>
					</li>
				{/each}
			</ul>
		</section>
	{/if}
</main>

<style>
	h1 {
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	h1 :global(svg) {
		color: var(--accent-ink);
	}

	.lede {
		color: var(--ink-muted);
		max-width: var(--measure);
	}

	.undo {
		display: flex;
		gap: 0.75rem;
		align-items: center;
		padding: 0.5rem 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font-size: var(--step--1);
	}

	.empty {
		display: grid;
		justify-items: center;
		gap: 0.25rem;
		margin-top: 1.5rem;
		text-align: center;
	}

	.empty :global(svg) {
		color: var(--accent-ink);
	}

	.empty h2 {
		margin: 0.25rem 0 0;
	}

	.empty p {
		margin: 0;
		max-width: 34rem;
		color: var(--ink-muted);
	}

	.group {
		margin-top: 2rem;
	}

	.group-head {
		display: flex;
		flex-wrap: wrap;
		gap: 0.75rem;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 0.75rem;
	}

	.group-head h2 {
		margin: 0;
	}

	.count {
		margin-inline-start: 0.3rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		font-weight: 600;
	}

	.list {
		display: grid;
		gap: 0.5rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.item {
		display: flex;
		gap: 0.5rem;
		align-items: flex-start;
		padding: 0.8rem 0.6rem 0.8rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.body {
		flex: 1;
		min-width: 0;
	}

	.sentence {
		margin: 0;
		font-size: var(--step-1);
		font-weight: 600;
		color: var(--heading);
		overflow-wrap: anywhere;
	}

	.meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		align-items: center;
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.meta a {
		color: var(--accent-ink);
	}

	.level {
		padding: 0.05rem 0.45rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		font-size: 0.75rem;
		font-weight: 700;
		color: var(--ink-muted);
	}

	.note {
		font-style: italic;
	}

	.learnt {
		display: flex;
		gap: 0.35rem;
		align-items: center;
		margin: 0.45rem 0 0;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--right);
	}

	.exercise {
		display: flex;
		gap: 0.6rem;
		align-items: center;
		align-self: center;
		color: var(--heading);
		text-decoration: none;
	}

	.exercise :global(svg) {
		margin-inline-start: auto;
		color: var(--accent-ink);
	}

	.exercise:hover strong {
		color: var(--accent-ink);
	}

	.unpin {
		flex: none;
		display: grid;
		place-items: center;
		width: 2.25rem;
		height: 2.25rem;
		border: 0;
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.unpin:hover {
		background: var(--surface-alt);
		color: var(--accent-ink);
	}
</style>
