<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { breadcrumbLd, clip, courseLd } from '$lib/seo';
	// The course home: a swipe deck of exercises dealt from the learner's level
	// and progress (the main event), a progress ring, and — folded away below —
	// the full CEFR ladder for anyone who wants to browse rather than be dealt.
	import DoneMark from '$lib/components/DoneMark.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SwipeDeck from '$lib/components/SwipeDeck.svelte';
	import ProgressPanel from '$lib/components/ProgressPanel.svelte';
	import AccountStrip from '$lib/components/AccountStrip.svelte';
	import BookStrip from '$lib/components/BookStrip.svelte';
	import Sheet from '$lib/components/Sheet.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { storage } from '$lib/services/storage';
	import { START_CHOSEN } from '$lib/domain/placement';
	import { Tween } from 'svelte/motion';
	import { cubicOut } from 'svelte/easing';
	import { buildLadder, courseProgress, nextQuiz } from '$lib/domain/ladder';
	import { deckLevel, typeLabel } from '$lib/domain/deck';
	import { levelLine, percentOf, progressStats } from '$lib/domain/stats';
	import type { QuizFacts } from '$lib/domain/recommend';
	import { progress } from '$lib/state/progress.svelte';
	import { loadQuizFacts } from '$lib/state/facts';
	import { inProgressIds } from '$lib/state/resume';
	import InProgressBadge from '$lib/components/InProgressBadge.svelte';
	import type { QuizSummary } from '$lib/content/types';
	import type { PageData } from './$types';
	import { track } from '$lib/services/analytics';
	import { BOOKS } from '$lib/content/books';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	import { levelTranslated } from '$lib/i18n/available';

	// Each level's book (Book v2): opens the book to read, with download and print there.
	const levelBook = (level: string) => BOOKS.find((b) => b.level === level) ?? null;

	let { data }: { data: PageData } = $props();
	// Turkish mode deals and lists only the levels that exist in Turkish (A1–A2).
	const course = $derived(
		lang.limited ? { ...data.course, quizzes: data.course.quizzes.filter((q) => levelTranslated(q.level)) } : data.course
	);

	// Loading runs on mount, not in an $effect: hydrateStats both reads and
	// writes the per-quiz stats state, so inside an effect each quiz it loaded
	// would invalidate the effect and re-enter it — an update-depth crash that
	// takes the whole page down. onMount has no reactive dependencies at all.
	onMount(async () => {
		// First session, nothing chosen: ask where to start before dealing A1.1.
		if (
			!(await storage.get(START_CHOSEN)) &&
			!(await storage.get('deck_level')) &&
			!(await progress.hasAnyProgress())
		) {
			void goto('/start', { replaceState: true });
			return;
		}
		if (!progress.loaded) await progress.load();
		// The ribbons and the ring read the streaks, which load lazily — pull in
		// this course's, or they all render as zero.
		await progress.hydrateStats(course.quizzes.map((quiz) => quiz.storageKeyPrefix));
		facts = await loadQuizFacts(course.quizzes);
		const known = facts;
		inProgress = await inProgressIds(course.quizzes, (id) => known[id]?.done ?? false);
	});

	/** Exercises started but not finished: marked in the deck and the list. */
	let inProgress = $state<Set<string>>(new Set());

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
	$effect(() => {
		sweep.target = percent;
	});
</script>

<Seo
	title={lang.limited
		? t('German A1–A2: {n} free exercises with audio | Language Quiz', { n: course.quizzes.length })
		: `${course.name}: ${course.quizzes.length} free exercises with audio | Language Quiz`}
	description={lang.limited
		? t('Free German exercises A1 to A2 with audio: grammar, reading, listening, dictation and speaking, {n} in all. No sign-up.', { n: course.quizzes.length })
		: clip(`${course.tagline}. ${course.quizzes.length} free interactive German exercises — grammar, reading, listening, dictation and speaking, with audio. No sign-up.`)}
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
		<!-- Kept for screen readers and search, not shown: the deck needs no title. -->
		<h1 class="sr-only">{t(course.name)}</h1>
	{/snippet}

	{#snippet ring()}
		<!-- Progress through the sub-level the deck is dealing from: a level is
		     ~30 exercises, so every one moves the arc visibly. Tapping it opens
		     the full picture. -->
		<button type="button" class="progress" class:started={(current?.done ?? 0) > 0}
			aria-haspopup="dialog" aria-controls="progress-panel" onclick={() => (panelOpen = true)}
			aria-label={t('{line}. {percent}% complete, {done} of {total}. Open your progress', { line: current ? levelLine(current) : '', percent, done: current?.done ?? 0, total: current?.total ?? 0 })}
			title={t('Your progress')}>
			<span class="pbar" aria-hidden="true"><span style="width:{sweep.current}%"></span></span>
			<span class="done tnum">{current ? levelLine(current) : ''}</span>
		</button>
	{/snippet}

	{#if finished}
		<header class="head">
			{@render heading()}
			{@render ring()}
		</header>
		<p class="finished">
			<Icon name="trophy" size="1.2em" />
			{lang.limited ? t('Every exercise in your language is complete.') : 'Every exercise in this course is complete.'}
		</p>
		<button type="button" class="browse-btn" onclick={() => (browseOpen = true)}>
			<Icon name="menu" size="1em" /> {t('All {n} exercises', { n: totals.total })}
		</button>
	{:else}
		<SwipeDeck {course} {facts} photos={data.photos} bind:level={pickedLevel} title={heading} aside={ring}
			onbrowse={() => (browseOpen = true)} {inProgress} />
	{/if}

	<!-- One quiet line, and only for a learner who is signed out and hasn't
	     waved it away. It carries its own sign-in sheet. -->
	<AccountStrip />
	<!-- Where the reader is in the printed book, once a page code has been opened. -->
	<BookStrip courseHref="/course/{course.id}" />
</main>

<SiteFooter compact />

<!-- Browsing is the second way in: the whole ladder in a panel, so the deck
     keeps the screen. The panel stays in the DOM while closed, so the
     prerendered page still links every exercise. -->
<Sheet bind:open={browseOpen} title={t('Exercise library')} id="all-exercises">
		{#if resume}
			<a class="resume" href="/course/{course.id}/quiz/{resume.id}">
				<span class="resume-icon"><Icon name={QUIZ_TYPE_ICONS[resume.type]} size="1.35em" /></span>
				<span class="resume-body">
					<span class="resume-label">
						{totals.done === 0 ? t('First in order') : t('Next in order')}
					</span>
					<span class="resume-title" lang={course.learnLocale}>{resume.title}</span>
					<span class="resume-meta">{resume.level} · {t(typeLabel(resume.type))}</span>
				</span>
				<Icon name="arrowRight" size="1.2em" class="resume-go" />
			</a>
		{/if}

		<!-- Paper practice: a sheet of chosen exercises (the whole course, what is
		     finished, or the weak spots). The books are the printed course. -->
		{#if !lang.limited}
		<a class="worksheet" href="/course/{course.id}/worksheet">
			<Icon name="printer" size="1.2em" />
			<span>
				<strong>Print a practice sheet</strong>
				<small>The whole course, what you have finished, or your weak spots</small>
			</span>
			<Icon name="arrowRight" size="1.1em" />
		</a>
		{/if}

	<h2 class="by-level">{t('By level')}</h2>
	<ol class="levels">
		{#each ladder as level (level.id)}
			<li class:complete={level.complete}>
				<header class="level-head">
					<h3><a class="level-link" href="/course/{course.id}/level/{level.level}">{level.title}</a></h3>
					<span class="level-meta">
						{#if levelBook(level.level)}
							{@const book = levelBook(level.level)!}
							<a
								class="level-pdf"
								href="/course/{course.id}/book2/{book.level}"
								aria-label={t('Read the {level} book online', { level: book.level })}
							>
								<Icon name="book" size="0.95em" /> {t('Book')}
							</a>
						{/if}
						<span class="tnum">{level.doneCount} / {level.quizzes.length}</span>
						{#if level.complete}<Icon name="check" size="1em" />{/if}
					</span>
				</header>

				<ul class="quizzes">
					{#each level.quizzes as quiz (quiz.id)}
						{@const ribbon = progress.loaded
							? progress.markFor(quiz.type, quiz.id, quiz.storageKeyPrefix)
							: null}
						<li>
							<a href="/course/{course.id}/quiz/{quiz.id}">
								<span class="kind" data-kind={quiz.type} title={quiz.type}>
									<Icon name={QUIZ_TYPE_ICONS[quiz.type]} size="1em" />
								</span>
								<span class="title" lang={course.learnLocale}>{quiz.title}</span>
								{#if ribbon}<DoneMark mark={ribbon} width={13} />
								{:else if inProgress.has(quiz.id)}<InProgressBadge />{/if}
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
		border-radius: 6px;
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
		gap: 0.7rem;
		margin: 0.5rem 0 0;
		padding: 0.5rem 0.8rem;
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

	.worksheet strong {
		font-size: var(--step--1);
	}

	.worksheet small {
		display: block;
		color: var(--ink-muted);
		font-size: 0.78rem;
		line-height: 1.3;
	}

	.head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
	}

	/* Progress: a thin bar and one line, right-aligned in the header row. */
	.progress {
		flex: none;
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		gap: 0.35rem;
		margin: -0.35rem -0.5rem -0.35rem 0;
		padding: 0.35rem 0.5rem;
		border: 1px solid transparent;
		border-radius: 6px;
		background: none;
		font: inherit;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.progress:hover {
		border-color: var(--line);
		background: var(--surface);
	}

	.pbar {
		width: 8rem;
		height: 6px;
		border-radius: 3px;
		background: var(--paper-high);
	}

	.pbar span {
		display: block;
		height: 100%;
		border-radius: 3px;
		background: var(--right);
	}

	.done {
		font-size: 0.8rem;
		font-weight: 600;
		color: var(--ink-muted);
	}

	/* Both cards above the ladder are shortcuts, not the content: kept to
	   roughly 60% of their old height so the levels start higher up the panel. */
	.resume {
		display: flex;
		align-items: center;
		gap: 0.7rem;
		margin: 0.5rem 0 0;
		padding: 0.6rem 0.8rem;
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
		width: 1.8rem;
		height: 1.8rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface);
		color: var(--accent-ink);
	}

	.resume-body {
		flex: 1;
		min-width: 0;
	}

	.resume-label {
		display: block;
		font-size: 0.6rem;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.resume-title {
		display: block;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		line-height: 1.25;
		font-weight: 700;
		color: var(--heading);
	}

	.resume-meta {
		font-size: 0.78rem;
		color: var(--ink-muted);
	}

	/* The arrow nudges on hover — a small affordance that the card is a link. */
	.resume :global(.resume-go) {
		color: var(--accent-ink);
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
		color: var(--accent-ink);
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

	/* The level's workbook as PDF: a small pill before the count. */
	.level-pdf {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		margin-inline-end: 0.5rem;
		padding: 0.15rem 0.55rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		color: var(--navy);
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.04em;
		text-decoration: none;
		transition: border-color var(--fast) var(--ease-out);
	}

	.level-pdf:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
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
	.kind[data-kind='vocabulary'],
	.kind[data-kind='suchbild'] {
		background: #f9e7ee;
		color: #a33a63;
	}
	.kind[data-kind='speakRepeat'] {
		background: #fbe9e2;
		color: #b5522a;
	}
	.kind[data-kind='speaking'] {
		background: var(--accent-soft);
		color: var(--accent-ink);
	}
	.kind[data-kind='listening'] {
		background: #e8efe9;
		color: var(--forest);
	}
	.kind[data-kind='dictation'] {
		background: #f4eddc;
		color: var(--ochre-ink);
	}
	@media (max-width: 36rem) {
		.home {
			padding-top: 0.75rem;
		}
	}
</style>
