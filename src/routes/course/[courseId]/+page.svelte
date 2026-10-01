<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { breadcrumbLd, clip, courseLd } from '$lib/seo';
	// The course home: a swipe deck of exercises dealt from the learner's level
	// and progress (the main event), a progress ring, and — folded away below —
	// the full CEFR ladder for anyone who wants to browse rather than be dealt.
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SwipeDeck from '$lib/components/SwipeDeck.svelte';
	import ProgressPanel from '$lib/components/ProgressPanel.svelte';
	import Sheet from '$lib/components/Sheet.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { onMount } from 'svelte';
	import { Tween } from 'svelte/motion';
	import { cubicOut } from 'svelte/easing';
	import { buildLadder, courseProgress, nextQuiz } from '$lib/domain/ladder';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { deckLevel, typeLabel } from '$lib/domain/deck';
	import { levelLine, percentOf, progressStats } from '$lib/domain/stats';
	import type { QuizFacts } from '$lib/domain/recommend';
	import { progress } from '$lib/state/progress.svelte';
	import { loadQuizFacts } from '$lib/state/facts';
	import type { QuizSummary } from '$lib/content/types';
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
		facts = await loadQuizFacts(course.quizzes);
	});

	/** Every quiz's facts once loaded; the deck and the progress panel share them. */
	let facts = $state<Record<string, QuizFacts> | null>(null);
	/** The level the learner picked in the deck chooser (null = auto). */
	let pickedLevel = $state<string | null>(null);
	let panelOpen = $state(false);
	let browseOpen = $state(false);

	// Before progress loads nothing reads as done, so the page renders an empty
	// ring rather than flashing ribbons on and off.
	const isDone = $derived((quiz: QuizSummary) =>
		progress.loaded
			? progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix)
			: false
	);

	const ladder = $derived(
		buildLadder(course, isDone)
	);
	const totals = $derived(courseProgress(ladder));
	const resume = $derived(nextQuiz(ladder, isDone));
	const finished = $derived(progress.loaded && !resume);
	const levelTitles = $derived(
		Object.fromEntries(ladder.map((level) => [level.level, level.title]))
	);
	const stats = $derived(progressStats(course.quizzes, facts ?? {}, levelTitles));
	/** The sub-level the deck deals from — the ring reports on that one. */
	const current = $derived.by(() => {
		const level = deckLevel(course.quizzes, facts ?? {}, pickedLevel);
		return stats.levels.find((l) => l.level === level) ?? stats.levels[0];
	});
	const percent = $derived(current ? percentOf(current) : 0);

	// The ring sweeps to its value rather than snapping, so returning to the
	// page after finishing an exercise shows the gain rather than just stating it.
	const sweep = new Tween(0, { duration: 900, easing: cubicOut });
	const RING_R = 16;
	const RING_C = 2 * Math.PI * RING_R;
	$effect(() => {
		sweep.target = percent;
	});
</script>

<Seo
	title="{course.name}: {course.quizzes.length} free exercises with audio | Language Quiz"
	description={clip(`${course.tagline}. ${course.quizzes.length} free interactive German exercises — grammar, reading, listening, dictation and speaking, with audio. No sign-up.`)}
	path="/course/{course.id}"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: course.name, path: `/course/${course.id}` }
		]),
		courseLd(course, { numberOfLessons: course.quizzes.length })
	]}
/>

<!-- The whole page is a column the height of the screen: nav, header, deck
     and a one-line footer. The deck's stage takes whatever is left, so on a
     phone the card, its buttons and the footer all fit without scrolling. -->
<div class="shell">
<SiteNav courseHref="/course/{course.id}" compact />

<main class="page-wide home">
	<!-- The page is about the cards: the heading is a small label, the ring
	     sits beside the deck chip, and everything else lives in the top bar. -->
	{#snippet heading()}
		<h1>{course.name}</h1>
	{/snippet}

	{#snippet ring()}
		<!-- Progress through the sub-level the deck is dealing from: a level is
		     ~30 exercises, so every one moves the arc visibly. Tapping it opens
		     the full picture. -->
		<button type="button" class="progress" class:started={(current?.done ?? 0) > 0}
			aria-haspopup="dialog" aria-controls="progress-panel" onclick={() => (panelOpen = true)}
			aria-label="{current?.level ?? ''}: {percent}% complete, {current?.done ?? 0} of {current?.total ?? 0}. Open your progress"
			title="Your progress">
			<svg class="ring" viewBox="0 0 40 40" aria-hidden="true">
				<circle class="track" cx="20" cy="20" r={RING_R} />
				<circle class="arc" cx="20" cy="20" r={RING_R}
					stroke-dasharray="{(sweep.current / 100) * RING_C} {RING_C}" />
			</svg>
			<span class="nums">
				<span class="pct tnum">{(current?.done ?? 0) > 0 && percent === 0 ? '<1' : percent}<span class="sign">%</span></span>
				<span class="done tnum">{current ? levelLine(current) : ''}</span>
			</span>
		</button>
	{/snippet}

	{#if finished}
		<header class="head">
			{@render heading()}
			{@render ring()}
		</header>
		<p class="finished">
			<Icon name="trophy" size="1.2em" />
			Every exercise in this course is complete.
		</p>
		<button type="button" class="browse-btn" onclick={() => (browseOpen = true)}>
			<Icon name="menu" size="1em" /> All {totals.total} exercises
		</button>
	{:else}
		<SwipeDeck {course} {facts} bind:level={pickedLevel} title={heading} aside={ring}
			onbrowse={() => (browseOpen = true)} />
	{/if}
</main>

<SiteFooter compact />

<!-- Browsing is the second way in: the whole ladder in a panel, so the deck
     keeps the screen. The panel stays in the DOM while closed, so the
     prerendered page still links every exercise. -->
<Sheet bind:open={browseOpen} title="All exercises" id="all-exercises">
		{#if resume}
			<a class="resume" href="/course/{course.id}/quiz/{resume.id}">
				<span class="resume-icon"><Icon name={QUIZ_TYPE_ICONS[resume.type]} size="1.35em" /></span>
				<span class="resume-body">
					<span class="resume-label">
						{totals.done === 0 ? 'First in order' : 'Next in order'}
					</span>
					<span class="resume-title">{resume.title}</span>
					<span class="resume-meta">{resume.level} · {typeLabel(resume.type)}</span>
				</span>
				<Icon name="arrowRight" size="1.2em" class="resume-go" />
			</a>
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

	<h2 class="by-level">By level</h2>
	<ol class="levels">
		{#each ladder as level (level.id)}
			<li class:complete={level.complete}>
				<header class="level-head">
					<h3><a class="level-link" href="/course/{course.id}/level/{level.level}">{level.title}</a></h3>
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
</Sheet>
<ProgressPanel bind:open={panelOpen} {stats} {current} />
</div>

<style>
	.shell {
		display: flex;
		flex-direction: column;
		min-height: 100dvh;
	}

	.home {
		flex: 1;
		display: flex;
		flex-direction: column;
		width: 100%;
		padding-bottom: 0.5rem;
	}

	.browse-btn {
		display: inline-flex;
		align-items: center;
		align-self: center;
		gap: 0.4rem;
		margin-top: 1rem;
		padding: 0.45rem 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
	}

	.worksheet {
		display: flex;
		align-items: center;
		gap: 0.85rem;
		margin: 0.75rem 0 0;
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
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
	}

	/* A label, not a headline: the cards are the headline. */
	h1 {
		margin: 0;
		font-size: var(--step-0);
		line-height: 1.25;
		letter-spacing: 0.01em;
		color: var(--ink-muted);
	}

	/* Progress: an arc and two numbers, right-aligned in the header row. */
	.progress {
		flex: none;
		display: flex;
		align-items: center;
		gap: 0.55rem;
		margin: -0.35rem -0.5rem -0.35rem 0;
		padding: 0.35rem 0.5rem;
		border: 1px solid transparent;
		border-radius: var(--radius);
		background: none;
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.progress:hover {
		border-color: var(--line);
		background: var(--surface);
	}

	.ring {
		width: 2.6rem;
		height: 2.6rem;
		transform: rotate(-90deg);
	}

	.ring circle {
		fill: none;
		stroke-width: 5.5;
	}

	.track {
		stroke: var(--paper-high);
	}

	/* Round caps: a zero-length dash still draws the starting dot once
	   anything is done; before that the arc stays hidden. */
	.arc {
		stroke: var(--accent);
		stroke-linecap: round;
		opacity: 0;
		transition: opacity var(--medium) var(--ease-out);
	}

	.started .arc {
		opacity: 1;
	}

	.nums {
		display: flex;
		flex-direction: column;
		line-height: 1.05;
	}

	.pct {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	.sign {
		margin-left: 0.05em;
		font-size: 0.6em;
		color: var(--ink-muted);
	}

	.done {
		margin-top: 0.15rem;
		font-size: 0.72rem;
		font-weight: 600;
		color: var(--ink-muted);
	}

	.resume {
		display: flex;
		align-items: center;
		gap: 1rem;
		margin: 0.5rem 0 0;
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
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
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

	/* A small label: the panel's own title already says what this is. */
	.by-level {
		margin: 1.5rem 0 0.25rem;
		font-family: inherit;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
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

	/* The level title is the way into its syllabus — a link, but one that
	   looks like the heading it is until hovered. */
	.level-link {
		color: inherit;
		text-decoration: none;
		border-bottom: 1px dotted var(--line-strong);
	}

	.level-link:hover {
		color: var(--accent);
		border-bottom-color: var(--accent);
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
	.kind[data-kind='fillBlank'] {
		background: #ebe7f4;
		color: #55478a;
	}
	.kind[data-kind='vocabulary'] {
		background: #f9e7ee;
		color: #a33a63;
	}
	.kind[data-kind='speakRepeat'] {
		background: #fbe9e2;
		color: #b5522a;
	}
	.kind[data-kind='speaking'] {
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
	@media (max-width: 36rem) {
		.home {
			padding-top: 0.75rem;
		}
	}
</style>
