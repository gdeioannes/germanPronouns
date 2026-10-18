<script lang="ts">
	// My book: tick what you did on paper, and the app counts it as done —
	// the deck stops dealing it as new and the progress rings include it. There
	// is no check and no score: a tick is a tick. Medals stay with the app,
	// for the runs it actually saw.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { announce } from '$lib/a11y.svelte';
	import type { QuizType } from '$lib/content/types';
	import type { BookUnitRow } from './+page.server';

	let { data } = $props();
	const book = $derived(data.book);

	$effect(() => {
		if (!progress.loaded) void progress.load();
	});

	const done = (u: BookUnitRow) => progress.loaded && progress.isCompleted(u.type as QuizType, u.quizId, u.storageKeyPrefix);

	async function tick(u: BookUnitRow) {
		if (done(u)) return;
		// The drills record into the quest set, the skills into their own; the
		// store knows which, so both calls are safe and one of them is a no-op.
		await progress.markCompleted(u.type as QuizType, u.quizId);
		await progress.markQuestCompleted(u.quizId);
		announce([{ text: `${u.n} ${u.title} marked as done in the book` }]);
	}

	async function tickAll(units: BookUnitRow[]) {
		for (const u of units) await tick(u);
	}

	const total = $derived(book.parts.flatMap((p) => p.chapters.flatMap((c) => c.units)));
	const doneCount = $derived(total.filter(done).length);
</script>

<Seo title="My book · {book.title}" description="Tick what you did in the printed {book.title} book, so the app knows." path="/course/{data.courseId}/book/{book.id}/progress" noindex />

<main class="page">
	<a class="back-link" href="/settings"><Icon name="arrowLeft" size="1em" /> Settings</a>
	<header>
		<p class="eyebrow">My book</p>
		<h1>{book.title} <small>{book.subtitle}</small></h1>
		<p class="lede">
			Did a unit in the printed book? Tick it here and the app counts it as done: the deck stops dealing it as new and your progress includes it. Nobody checks; a tick is a tick. Medals stay with the exercises you do in the app.
		</p>
		{#if data.books.length > 1}
			<p class="switch">Other books: {#each data.books.filter((b) => b !== book.id) as b (b)}<a href="/course/{data.courseId}/book/{b}/progress">{b}</a>{/each}</p>
		{/if}
		<p class="count"><strong class="tnum">{doneCount} / {total.length}</strong> units done</p>
	</header>

	{#each book.parts as part (part.n)}
		<section class="part">
			<h2><span class="tnum">Part {part.n}</span> {part.level} · {part.title}</h2>
			{#each part.chapters as chapter, c (c)}
				<div class="chapter">
					{#if chapter.title}
						<h3>{chapter.title}
							<button type="button" class="all" onclick={() => tickAll(chapter.units)} disabled={chapter.units.every(done)}>
								Tick the whole chapter
							</button>
						</h3>
					{/if}
					<ul class="units">
						{#each chapter.units as u (u.quizId)}
							<li class:done={done(u)}>
								<label>
									<input type="checkbox" checked={done(u)} disabled={done(u)} onchange={() => tick(u)} />
									<span class="n tnum">{u.n}</span>
									<span class="t">{u.title}</span>
									<small>{u.kind}</small>
								</label>
								<a class="open" href="/course/{data.courseId}/quiz/{u.quizId}" aria-label="Open {u.title} in the app"><Icon name="arrowRight" size="1em" /></a>
							</li>
						{/each}
					</ul>
				</div>
			{/each}
		</section>
	{/each}
</main>

<style>
	.page {
		max-width: 44rem;
		margin: 0 auto;
		padding: 1rem 1rem 4rem;
	}
	.back-link {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		color: var(--ink-muted);
		font-weight: 600;
		text-decoration: none;
	}
	.eyebrow {
		margin: 1rem 0 0;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}
	h1 {
		margin: 0.2rem 0 0.6rem;
		font-size: var(--step-3);
		color: var(--heading);
	}
	h1 small {
		display: block;
		font-size: var(--step-0);
		font-weight: 500;
		color: var(--ink-muted);
	}
	.lede {
		margin: 0 0 0.6rem;
		color: var(--ink-muted);
		line-height: 1.55;
	}
	.switch a {
		margin-right: 0.6rem;
		font-weight: 700;
	}
	.count {
		margin: 0.4rem 0 1.4rem;
		color: var(--ink);
	}
	.part h2 {
		margin: 1.4rem 0 0.4rem;
		font-size: var(--step-1);
		color: var(--navy);
	}
	.chapter h3 {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		margin: 1rem 0 0.4rem;
		font-size: var(--step-0);
		color: var(--heading);
	}
	.all {
		padding: 0.35rem 0.7rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
	}
	.all:disabled {
		opacity: 0.5;
		cursor: default;
	}
	.units {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.35rem;
	}
	.units li {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.45rem 0.6rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
	}
	.units li.done {
		background: var(--right-bg);
		border-color: var(--right);
	}
	.units label {
		flex: 1;
		display: flex;
		align-items: center;
		gap: 0.6rem;
		cursor: pointer;
		min-width: 0;
	}
	.units input {
		width: 1.2rem;
		height: 1.2rem;
		accent-color: var(--right);
	}
	.n {
		flex: none;
		width: 2.6rem;
		font-weight: 800;
		color: var(--navy);
	}
	.t {
		flex: 1;
		min-width: 0;
	}
	.units small {
		color: var(--ink-muted);
		font-size: 0.75rem;
	}
	.open {
		display: inline-flex;
		padding: 0.35rem;
		color: var(--ink-muted);
	}
</style>
