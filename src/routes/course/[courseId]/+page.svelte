<script lang="ts">
	// The course home: the gated CEFR ladder, a progress ring, and the
	// "continue where you left off" jump. Locks are computed from the same rule
	// as the Dart app — a sub-level opens only once every earlier quiz is done.
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { rise } from '$lib/motion';
	import { onMount } from 'svelte';
	import { Tween } from 'svelte/motion';
	import { cubicOut } from 'svelte/easing';
	import { buildLadder, courseProgress, nextQuiz } from '$lib/domain/ladder';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
	import type { Quiz } from '$lib/content/types';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const course = $derived(data.course);

	// Loading runs on mount, not in an $effect: hydrateStats both reads and
	// writes the per-quiz stats state, so inside an effect each quiz it loaded
	// would invalidate the effect and re-enter it — an update-depth crash that
	// takes the whole page down. onMount has no reactive dependencies at all.
	onMount(async () => {
		if (!progress.loaded) await progress.load(course.gating ?? DEFAULT_GATING);
		// The ribbons and the ring read the streaks, which load lazily — pull in
		// this course's, or they all render as zero.
		await progress.hydrateStats(course.quizzes.map((quiz) => quiz.storageKeyPrefix));
	});

	// Before progress loads nothing reads as done, so the page renders an empty
	// ring rather than flashing ribbons on and off.
	const isDone = $derived((quiz: Quiz) =>
		progress.loaded
			? progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix)
			: false
	);

	const ladder = $derived(
		buildLadder(course, isDone)
	);
	const totals = $derived(courseProgress(ladder));
	const resume = $derived(nextQuiz(ladder, isDone));
	const percent = $derived(
		totals.total === 0 ? 0 : Math.round((totals.done / totals.total) * 100)
	);

	// The ring sweeps to its value rather than snapping, so returning to the
	// page after finishing an exercise shows the gain rather than just stating it.
	const sweep = new Tween(0, { duration: 900, easing: cubicOut });
	$effect(() => {
		sweep.target = percent;
	});
</script>

<svelte:head>
	<title>{course.name} — Language Quiz</title>
	<meta name="description" content={course.tagline} />
</svelte:head>

<main class="page-wide">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>

	<header class="head">
		<div>
			<p class="pair">{course.speakFlag} → {course.learnFlag} · {course.level}</p>
			<h1>{course.name}</h1>
			<p class="lede">{course.tagline}</p>
		</div>

		<div class="ring" style="--pct:{sweep.current}" role="img"
			aria-label="{percent}% complete, {totals.done} of {totals.total} exercises">
			<span class="pct tnum">{percent}<span class="sign">%</span></span>
			<span class="count tnum">{totals.done} / {totals.total}</span>
		</div>
	</header>

	{#if resume}
		<a class="resume" href="/course/{course.id}/quiz/{resume.id}" in:rise>
			<span class="resume-icon"><Icon name={QUIZ_TYPE_ICONS[resume.type]} size="1.35em" /></span>
			<span class="resume-body">
				<span class="resume-label">
					{totals.done === 0 ? 'Start here' : 'Continue'}
				</span>
				<span class="resume-title">{resume.title}</span>
				<span class="resume-meta">{resume.level} · {resume.type}</span>
			</span>
			<Icon name="arrowRight" size="1.2em" class="resume-go" />
		</a>
	{:else}
		<p class="finished">
			<Icon name="trophy" size="1.2em" />
			Every exercise in this course is complete.
		</p>
	{/if}

	<!-- Paper practice: the same exercises, printable, with the answers where
	     the learner wants them (the port of the Flutter PDF export). -->
	<a class="worksheet" href="/course/{course.id}/worksheet">
		<Icon name="printer" size="1.2em" />
		<span>
			<strong>Printable worksheet</strong>
			<small>Exercises on paper, with a fold-away answer column</small>
		</span>
		<Icon name="arrowRight" size="1.1em" />
	</a>

	<h2>The ladder</h2>
	<ol class="levels">
		{#each ladder as level (level.id)}
			<li class:complete={level.complete}>
				<header class="level-head">
					<h3>{level.title}</h3>
					<span class="level-meta">
						<span class="tnum">{level.doneCount} / {level.quizzes.length}</span>
						{#if level.complete}<Icon name="check" size="1em" />{/if}
					</span>
				</header>

				<ul class="quizzes">
					{#each level.quizzes as quiz (quiz.id)}
						{@const ribbon = progress.loaded
							? progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix)
							: null}
						<li>
							<a href="/course/{course.id}/quiz/{quiz.id}">
								<span class="kind" data-kind={quiz.type} title={quiz.type}>
									<Icon name={QUIZ_TYPE_ICONS[quiz.type]} size="1em" />
								</span>
								<span class="title">{quiz.title}</span>
								{#if ribbon}<RibbonBadge tier={ribbon} width={13} />{/if}
							</a>
						</li>
					{/each}
				</ul>
			</li>
		{/each}
	</ol>
</main>

<style>
	.worksheet {
		display: flex;
		align-items: center;
		gap: 0.85rem;
		margin: 1.25rem 0 0;
		padding: 0.85rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		transition: border-color var(--fast) var(--ease-out);
	}

	.worksheet:hover {
		border-color: var(--accent);
	}

	.worksheet span {
		flex: 1;
	}

	.worksheet small {
		display: block;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.head {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 2rem;
		flex-wrap: wrap;
	}

	.pair {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.05em;
		color: var(--ink-muted);
	}

	h1 {
		margin: 0.35rem 0 0.5rem;
	}

	.lede {
		margin: 0;
		color: var(--ink-muted);
	}

	/* A conic-gradient ring with the page colour punched out of the middle —
	   no SVG, and the sweep animates by tweening one custom property. */
	.ring {
		flex: none;
		position: relative;
		width: 7.5rem;
		height: 7.5rem;
		display: grid;
		place-content: center;
		text-align: center;
		border-radius: 50%;
		background: conic-gradient(
			var(--accent) calc(var(--pct) * 1%),
			var(--paper-high) 0
		);
	}

	.ring::before {
		content: '';
		position: absolute;
		inset: 0.62rem;
		border-radius: 50%;
		background: var(--bg);
	}

	.pct,
	.count {
		position: relative;
		display: block;
		line-height: 1.1;
	}

	.pct {
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 700;
		color: var(--heading);
	}

	.sign {
		font-size: 0.55em;
		color: var(--ink-muted);
	}

	.count {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.resume {
		display: flex;
		align-items: center;
		gap: 1rem;
		margin: 2rem 0 0;
		padding: 1.15rem 1.3rem;
		border: 1px solid var(--accent);
		border-radius: var(--radius);
		background: var(--accent-soft);
		text-decoration: none;
		color: inherit;
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.resume:hover {
		transform: translateY(-2px);
		box-shadow: 0 6px 20px -10px rgba(31, 58, 95, 0.45);
	}

	.resume-icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.6rem;
		height: 2.6rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface);
		color: var(--accent);
	}

	.resume-body {
		flex: 1;
		min-width: 0;
	}

	.resume-label {
		display: block;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--accent);
	}

	.resume-title {
		display: block;
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	.resume-meta {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* The arrow nudges on hover — a small affordance that the card is a link. */
	.resume :global(.resume-go) {
		color: var(--accent);
		transition: transform var(--medium) var(--ease-out);
	}

	.resume:hover :global(.resume-go) {
		transform: translateX(4px);
	}

	.finished {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		margin: 2rem 0 0;
		padding: 1.1rem 1.3rem;
		border-radius: var(--radius);
		background: var(--right-bg);
		border: 1px solid var(--right);
		color: var(--right);
		font-weight: 700;
	}

	h2 {
		margin: 2.75rem 0 0.5rem;
		font-size: var(--step-1);
	}

	.levels {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.levels > li {
		padding: 1rem 0;
		border-top: 1px solid var(--line);
		transition: opacity var(--medium) var(--ease-out);
	}

	.level-head {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		gap: 1rem;
	}

	.level-head h3 {
		margin: 0;
		font-size: var(--step-0);
		letter-spacing: 0.01em;
	}

	.level-meta {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink-muted);
	}

	.levels > li.complete .level-meta {
		color: var(--right);
	}

	.quizzes {
		margin: 0.7rem 0 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.2rem;
	}

	.quizzes a {
		display: flex;
		align-items: center;
		gap: 0.7rem;
		padding: 0.5rem 0.7rem;
		border-radius: var(--radius-sm);
		color: inherit;
		text-decoration: none;
		transition:
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.quizzes a:hover {
		background: var(--surface-alt);
		transform: translateX(3px);
	}

	.title {
		flex: 1;
		font-size: var(--step--1);
	}

	/* One tinted disc per quiz kind, carrying that kind's icon — the same
	   pairing the quiz header uses, so the two views agree. */
	.kind {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.9rem;
		height: 1.9rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	.kind[data-kind='reading'] {
		background: #e6ecf3;
		color: var(--navy);
	}
	.kind[data-kind='speaking'],
	.kind[data-kind='speakRepeat'] {
		background: var(--accent-soft);
		color: var(--accent);
	}
	.kind[data-kind='listening'] {
		background: #e8efe9;
		color: var(--forest);
	}
	.kind[data-kind='dictation'] {
		background: #f4eddc;
		color: var(--ochre);
	}
</style>
