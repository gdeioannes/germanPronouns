<script lang="ts">
	// Where a chart's printed QR code lands: the app quizzes that practise this
	// chart, easiest first, each tied to the part of the chart it trains. Like the
	// book's App side: start anywhere; inside a quiz, back / previous / next stay
	// in this list (state/bookOpen), and what the learner has done shows here.
	import { onMount } from 'svelte';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import ChartFeedback from '$lib/components/ChartFeedback.svelte';
	import DoneMark from '$lib/components/DoneMark.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { progress } from '$lib/state/progress.svelte';
	import { listQuizHref, saveList } from '$lib/state/bookOpen';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const KIND: Record<string, string> = {
		fillBlank: 'Practise',
		listening: 'Listen',
		reading: 'Read',
		dictation: 'Dictation',
		writing: 'Write',
		speaking: 'Speak',
		speakRepeat: 'Say it',
		vocabulary: 'Word cards',
		suchbild: 'Picture hunt'
	};
	const here = $derived(`/charts/${data.chart.slug}`);

	onMount(() => {
		void (async () => {
			await progress.ensureLoaded();
			await progress.hydrateStats(data.quizzes.map((q) => q.storageKeyPrefix));
		})();
	});
	// This list is the learner's deck while they work through the chart.
	$effect(() => {
		saveList({ label: `Chart ${data.chart.n} · ${data.chart.title}`, href: here, quizzes: data.quizzes.map((q) => ({ id: q.id, title: q.title })) });
	});

	const marks = $derived(data.quizzes.map((q) => (progress.loaded ? progress.markFor(q.type, q.id, q.storageKeyPrefix) : null)));
	/** Done = finished and passed; "retry" is finished but marked for another go. */
	const isDone = (m: (typeof marks)[number]) => !!m && m !== 'retry';
	const doneCount = $derived(marks.filter(isDone).length);
	const started = $derived(marks.some((m) => !!m));
	/** The first quiz not done yet: where "Start" points. */
	const firstOpen = $derived(marks.findIndex((m) => !isDone(m)));
	const all = $derived(data.quizzes.length > 0 && doneCount === data.quizzes.length);
</script>

<Seo title="Chart {data.chart.n}: {data.chart.title} · practise in the app" description="The app's quizzes for this grammar chart: {data.chart.topic}." path={here} noindex />

<SiteNav courseHref="/course/{data.courseId}" />

<main>
	<header class="top">
		<a class="thumb" href={data.chart.img} target="_blank" rel="noopener" aria-label="Open chart {data.chart.n} in a new tab">
			<img src={data.chart.img} alt="" width="1100" height="778" />
		</a>
		<div class="head">
			<p class="eyebrow">Grammar charts · Chart {data.chart.n} of {data.total} · <span class="lvl">Level {data.chart.level}</span></p>
			<h1 lang="de">{data.chart.title}</h1>
			<p class="sub">{data.chart.topic}. Each quiz below trains one part of the chart. Start with any of them; inside, previous and next stay on this list.</p>
			<div class="progress" class:all aria-label="{doneCount} of {data.quizzes.length} done">
				<span class="bar" class:hidden={!started}><span style:width="{(doneCount / Math.max(1, data.quizzes.length)) * 100}%"></span></span>
				<span class="tnum">
					{#if all}All {data.quizzes.length} done{:else if started}{doneCount} of {data.quizzes.length} done{:else}{data.quizzes.length} {data.quizzes.length === 1 ? 'quiz' : 'quizzes'} · your progress shows here once you play{/if}
				</span>
			</div>
		</div>
	</header>

	<ol class="cards">
		{#each data.quizzes as quiz, i (quiz.id)}
			{@const mark = marks[i]}
			<li class:next={i === firstOpen} class:done={isDone(mark)} class:retry={mark === 'retry'}>
				<a href={listQuizHref(data.courseId, quiz.id)}>
					<span class="pic">
						{#if quiz.image}<img src={quiz.image} alt="" loading={i < 2 ? 'eager' : 'lazy'} />{/if}
						{#if isDone(mark)}<span class="n ok" aria-hidden="true"><Icon name="check" size="1em" /></span>{:else}<span class="n">{i + 1}</span>{/if}
					</span>
					<span class="body">
						<span class="for"><Icon name="image" size="0.95em" /> <span>{quiz.for}</span></span>
						<span class="title" lang={data.learnLocale}>{quiz.title}</span>
						<span class="note">{quiz.note}</span>
						<span class="meta">
							<span class="kind"><Icon name={QUIZ_TYPE_ICONS[quiz.type as keyof typeof QUIZ_TYPE_ICONS]} size="1em" /> {KIND[quiz.type] ?? quiz.type}</span>
							{#if quiz.size}<span>{quiz.size}</span>{/if}
							{#if quiz.level}<span>{quiz.level}</span>{/if}
						</span>
					</span>
					<span class="go">
						{#if isDone(mark)}
							<span class="status"><DoneMark mark={mark!} width={11} /> Done</span>
							<span class="again"><Icon name="repeat" size="0.95em" /> Again</span>
						{:else if mark === 'retry'}
							<span class="status try"><DoneMark mark="retry" width={16} /> Try again</span>
						{:else}<span class="start">{i === firstOpen ? 'Start' : 'Open'} <Icon name="arrowRight" size="1em" /></span>{/if}
					</span>
				</a>
			</li>
		{/each}
	</ol>

	<ChartFeedback path={here} code="chart-{data.chart.slug}" title="How is this chart?" shareText="A free German grammar wall chart: {data.chart.title}" />

	<p class="more"><a href="/charts#chart-{data.chart.n}"><Icon name="arrowLeft" size="0.95em" /> All the charts</a></p>
</main>

<style>
	main {
		max-width: 46rem;
		margin: 0 auto;
		padding: 1.25rem 1rem 4rem;
	}
	.top {
		display: grid;
		grid-template-columns: 11rem 1fr;
		gap: 1.1rem;
		align-items: start;
		margin-bottom: 1.4rem;
	}
	.thumb img {
		display: block;
		width: 100%;
		height: auto;
		border-radius: 8px;
		border: 1px solid var(--line-strong);
		box-shadow: 0 6px 18px rgb(31 58 95 / 0.12);
	}
	.head {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		min-width: 0;
	}
	.eyebrow {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}
	.lvl {
		white-space: nowrap;
	}
	h1 {
		margin: 0;
		font-size: var(--step-4);
		line-height: 1.05;
		color: var(--heading);
	}
	.sub {
		margin: 0.2rem 0 0;
		color: var(--ink-muted);
		max-width: 60ch;
	}
	.progress {
		display: flex;
		align-items: center;
		gap: 0.7rem;
		margin-top: 0.5rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--navy);
	}
	.progress.all {
		color: var(--right);
	}
	.bar {
		flex: 0 0 9rem;
		height: 8px;
		border-radius: 999px;
		background: var(--paper-high);
		overflow: hidden;
	}
	.bar.hidden {
		display: none;
	}
	.bar span {
		display: block;
		height: 100%;
		background: var(--right);
		border-radius: inherit;
		transition: width 0.4s;
	}
	.cards {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.85rem;
	}
	.cards a {
		display: grid;
		grid-template-columns: 8rem 1fr auto;
		align-items: stretch;
		border: 1px solid var(--line-strong);
		border-radius: 16px;
		background: var(--surface);
		color: var(--ink);
		text-decoration: none;
		overflow: hidden;
		transition: border-color 0.15s, box-shadow 0.15s, transform 0.15s;
	}
	.cards a:hover {
		border-color: var(--navy);
		box-shadow: 0 6px 18px rgb(31 58 95 / 0.12);
		transform: translateY(-1px);
	}
	.cards a:focus-visible {
		outline: 3px solid var(--accent);
		outline-offset: 2px;
	}
	.cards li.next a {
		border-color: var(--navy);
		border-width: 2px;
	}
	.pic {
		position: relative;
		background: var(--paper-high);
		min-height: 7rem;
	}
	.pic img {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.n {
		position: absolute;
		top: 0.5rem;
		left: 0.5rem;
		width: 1.7rem;
		height: 1.7rem;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		display: grid;
		place-items: center;
		font-weight: 800;
		font-size: 0.85rem;
		box-shadow: 0 1px 4px rgb(0 0 0 / 0.3);
	}
	.body {
		min-width: 0;
		padding: 0.85rem 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}
	.for {
		align-self: flex-start;
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		padding: 0.15em 0.6em;
		border-radius: 6px;
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-size: 0.8rem;
		font-weight: 700;
	}
	.title {
		font-size: var(--step-1);
		font-weight: 800;
		line-height: 1.2;
		color: var(--heading);
	}
	.note {
		color: var(--ink);
		font-size: var(--step--1);
		line-height: 1.45;
	}
	.meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem 0.9rem;
		margin-top: 0.15rem;
		font-size: 0.8rem;
		font-weight: 600;
		color: var(--ink-muted);
	}
	.kind {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
	}
	.go {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: flex-end;
		gap: 0.4rem;
		padding-block: 0;
		padding-inline: 0.25rem 1rem;
	}
	.start {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		font-weight: 700;
		font-size: var(--step--1);
		color: var(--navy);
		white-space: nowrap;
	}
	li.next .start {
		background: var(--navy);
		color: #fff;
		padding: 0.45em 0.9em;
		border-radius: 999px;
	}
	/* A done quiz reads as done at a glance: green edge and tint, a check
	   instead of its number, the picture quietened, "Done" with its medal. */
	li.done a {
		border-color: var(--right);
		border-width: 2px;
		background: var(--right-bg);
	}
	li.done .pic img {
		filter: saturate(0.35) brightness(1.08);
		opacity: 0.75;
	}
	.n.ok {
		z-index: 1;
		background: var(--right);
		width: 2rem;
		height: 2rem;
		font-size: 1.05rem;
	}
	li.done .title {
		color: var(--right);
	}
	li.retry a {
		border-color: var(--wrong);
		border-width: 2px;
	}
	.status {
		display: inline-flex;
		align-items: center;
		gap: 0.55em;
		min-height: 2.6rem;
		box-sizing: border-box;
		padding-block: 0.5em;
		padding-inline: 1.05em 1.25em;
		border-radius: 999px;
		line-height: 1;
		background: var(--right);
		color: #fff;
		font-weight: 800;
		font-size: var(--step--1);
		white-space: nowrap;
	}
	.status.try {
		background: var(--wrong-bg);
		color: var(--wrong);
	}
	.again {
		display: inline-flex;
		align-items: center;
		gap: 0.3em;
		font-size: 0.8rem;
		font-weight: 700;
		color: var(--ink-muted);
	}
	.more {
		margin: 1.6rem 0 0;
	}
	.more a {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		font-weight: 700;
		color: var(--navy);
		text-decoration: none;
	}
	@media (max-width: 34rem) {
		.top {
			grid-template-columns: 1fr;
		}
		.thumb {
			max-width: 18rem;
		}
		.cards a {
			grid-template-columns: 6.5rem 1fr;
		}
		.go {
			grid-column: 1 / -1;
			flex-direction: row;
			justify-content: flex-end;
			align-items: center;
			gap: 0.8rem;
			padding: 0 0.9rem 0.8rem;
		}
		.pic {
			grid-row: 1 / 3;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.cards a,
		.bar span {
			transition: none;
		}
	}
</style>
