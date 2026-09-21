<script lang="ts">
	// The course home: the gated CEFR ladder, a progress ring, and the
	// "continue where you left off" jump. Locks are computed from the same rule
	// as the Dart app — a sub-level opens only once every earlier quiz is done.
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import { buildLadder, courseProgress, nextQuiz } from '$lib/domain/ladder';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
	import type { Quiz } from '$lib/content/types';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const course = $derived(data.course);

	$effect(() => {
		if (!progress.loaded) progress.load(course.gating ?? DEFAULT_GATING);
	});

	// Before progress loads, nothing reads as done — so the page renders the
	// honest "all locked but the first" state rather than flashing unlocks.
	const isDone = $derived((quiz: Quiz) =>
		progress.loaded
			? progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix)
			: false
	);

	const ladder = $derived(
		buildLadder(course, isDone, (id) => progress.isPlacementUnlocked(id))
	);
	const totals = $derived(courseProgress(ladder));
	const resume = $derived(nextQuiz(ladder, isDone));
	const percent = $derived(
		totals.total === 0 ? 0 : Math.round((totals.done / totals.total) * 100)
	);
</script>

<svelte:head>
	<title>{course.name} — Language Quiz</title>
	<meta name="description" content={course.tagline} />
</svelte:head>

<main class="page-wide">
	<a class="back-link" href="/">← All courses</a>

	<header class="head">
		<div>
			<p class="pair">{course.speakFlag} → {course.learnFlag} · {course.level}</p>
			<h1>{course.name}</h1>
			<p class="lede">{course.tagline}</p>
		</div>

		<div class="ring" style="--pct:{percent}">
			<span class="pct">{percent}%</span>
			<span class="count">{totals.done} / {totals.total}</span>
		</div>
	</header>

	{#if resume}
		<a class="resume" href="/course/{course.id}/quiz/{resume.id}">
			<span class="resume-label"
				>{totals.done === 0 ? 'Start here' : 'Continue'}</span
			>
			<span class="resume-title">{resume.title}</span>
			<span class="resume-meta">{resume.level} · {resume.type}</span>
		</a>
	{:else}
		<p class="finished">Every exercise in this course is complete. 🎉</p>
	{/if}

	<h2>The ladder</h2>
	<ol class="levels">
		{#each ladder as level (level.id)}
			<li class:locked={!level.unlocked} class:complete={level.complete}>
				<header class="level-head">
					<h3>{level.title}</h3>
					<span class="level-meta">
						{#if !level.unlocked}
							🔒 Locked
						{:else}
							{level.doneCount} / {level.quizzes.length}
						{/if}
					</span>
				</header>

				{#if level.unlocked}
					<ul class="quizzes">
						{#each level.quizzes as quiz (quiz.id)}
							{@const ribbon = progress.loaded
								? progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix)
								: null}
							<li>
								<a href="/course/{course.id}/quiz/{quiz.id}">
									<span class="kind" data-kind={quiz.type}>{quiz.type}</span>
									<span class="title">{quiz.title}</span>
									{#if ribbon}<RibbonBadge tier={ribbon} width={14} />{/if}
								</a>
							</li>
						{/each}
					</ul>
				{:else}
					<p class="locked-note">
						Finish the levels above to open this one — or set your starting
						point in <a href="/settings">settings</a>.
					</p>
				{/if}
			</li>
		{/each}
	</ol>
</main>

<style>
	.head {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 2rem;
		flex-wrap: wrap;
	}

	.pair {
		margin: 0;
		font-size: 0.85rem;
		font-weight: 700;
		color: var(--muted);
	}

	h1 {
		margin: 0.3rem 0;
		font-size: clamp(1.8rem, 4vw, 2.5rem);
		line-height: 1.15;
	}

	.lede {
		margin: 0;
		max-width: 34rem;
		color: var(--ink-soft);
	}

	.ring {
		flex: none;
		width: 7rem;
		height: 7rem;
		display: grid;
		place-content: center;
		text-align: center;
		border-radius: 50%;
		background: conic-gradient(
			var(--accent) calc(var(--pct) * 1%),
			var(--line) 0
		);
		position: relative;
	}

	.ring::before {
		content: '';
		position: absolute;
		inset: 0.6rem;
		border-radius: 50%;
		background: var(--bg);
	}

	.pct,
	.count {
		position: relative;
		display: block;
	}

	.pct {
		font-size: 1.4rem;
		font-weight: 800;
		color: var(--ink);
	}

	.count {
		font-size: 0.75rem;
		color: var(--muted);
	}

	.resume {
		display: block;
		margin: 2rem 0 0;
		padding: 1.1rem 1.25rem;
		border: 1px solid var(--accent);
		border-radius: 14px;
		background: var(--accent-soft);
		text-decoration: none;
		color: inherit;
	}

	.resume:hover {
		filter: brightness(0.98);
	}

	.resume-label {
		display: block;
		font-size: 0.75rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent);
	}

	.resume-title {
		display: block;
		font-size: 1.15rem;
		font-weight: 700;
		color: var(--ink);
	}

	.resume-meta {
		font-size: 0.82rem;
		color: var(--muted);
	}

	.finished {
		margin: 2rem 0 0;
		padding: 1rem 1.25rem;
		border-radius: 14px;
		background: #eaf4ec;
		border: 1px solid #a9cfb3;
	}

	h2 {
		margin: 2.5rem 0 0.5rem;
		font-size: 1.2rem;
	}

	.levels {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.levels > li {
		padding: 1rem 0;
		border-top: 1px solid var(--line);
	}

	.levels > li.locked {
		opacity: 0.55;
	}

	.level-head {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		gap: 1rem;
	}

	.level-head h3 {
		margin: 0;
		font-size: 1rem;
	}

	.level-meta {
		font-size: 0.8rem;
		font-weight: 700;
		color: var(--muted);
	}

	.levels > li.complete .level-meta {
		color: #3f7d4e;
	}

	.locked-note {
		margin: 0.4rem 0 0;
		font-size: 0.88rem;
		color: var(--muted);
	}

	.quizzes {
		margin: 0.6rem 0 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.3rem;
	}

	.quizzes a {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		padding: 0.5rem 0.7rem;
		border-radius: 8px;
		color: inherit;
		text-decoration: none;
	}

	.quizzes a:hover {
		background: var(--surface-alt);
	}

	.title {
		flex: 1;
		font-size: 0.93rem;
	}

	.kind {
		flex: none;
		min-width: 5.5rem;
		padding: 0.1rem 0.45rem;
		border-radius: 999px;
		background: var(--surface-alt);
		font-size: 0.7rem;
		font-weight: 700;
		text-align: center;
		color: var(--muted);
	}

	.kind[data-kind='reading'] {
		background: #e3ecf6;
		color: #29537f;
	}
	.kind[data-kind='speaking'],
	.kind[data-kind='speakRepeat'] {
		background: #f7e6dd;
		color: #a9502a;
	}
	.kind[data-kind='listening'] {
		background: #e6f0e7;
		color: #3f5d45;
	}
	.kind[data-kind='dictation'] {
		background: #f2ecf6;
		color: #5e4478;
	}
</style>
