<script lang="ts">
	// The quiz page. Dispatches on `quiz.type` to the right renderer — the
	// Svelte equivalent of the Dart DbQuizLoader's kind switch.
	import HelpMemory from '$lib/components/HelpMemory.svelte';
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import DictationQuiz from '$lib/components/quiz/DictationQuiz.svelte';
	import FillBlankQuiz from '$lib/components/quiz/FillBlankQuiz.svelte';
	import InlineClozeQuiz from '$lib/components/quiz/InlineClozeQuiz.svelte';
	import PassageQuiz from '$lib/components/quiz/PassageQuiz.svelte';
	import SpeakRepeatQuiz from '$lib/components/quiz/SpeakRepeatQuiz.svelte';
	import SpeakingQuiz from '$lib/components/quiz/SpeakingQuiz.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { pop, rise } from '$lib/motion';
	import { isInlineCloze } from '$lib/content/types';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const { course, quiz, next } = $derived(data);

	let finished = $state(false);

	$effect(() => {
		if (!progress.loaded) progress.load(course.gating ?? DEFAULT_GATING);
	});

	const ribbon = $derived(
		progress.loaded
			? progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix)
			: null
	);

	/** Marks the quiz done and unlocks the next rung of the chain. */
	async function complete() {
		await progress.markCompleted(quiz.type, quiz.id);
		await progress.markQuestCompleted(quiz.id);
		finished = true;
	}
</script>

<svelte:head>
	<title>{quiz.title} — {course.name}</title>
	<meta
		name="description"
		content="{quiz.level ?? ''} {quiz.title} — a free German exercise from {course.name}."
	/>
</svelte:head>

<main class="page">
	<a class="back-link" href="/course/{course.id}">
		<Icon name="arrowLeft" size="1em" /> {course.name}
	</a>

	<header class="head">
		<span class="kind" data-kind={quiz.type}>
			<Icon name={QUIZ_TYPE_ICONS[quiz.type]} size="1.3em" />
		</span>
		<div class="head-text">
			<p class="eyebrow">{quiz.level ?? ''} · {quiz.type}</p>
			<h1>{quiz.title}</h1>
		</div>
		{#if ribbon}
			<RibbonBadge tier={ribbon} animate={finished} />
		{/if}
	</header>

	<HelpMemory help={quiz.help} quizId={quiz.id} />

	{#if quiz.type === 'fillBlank'}
		<FillBlankQuiz
			{quiz}
			locale={course.learnLocale}
			onAnswer={() => {}}
			onGoalReached={complete}
		/>
	{:else if quiz.type === 'reading'}
		<!-- Two shapes share this type: a passage with questions, and the "big
		     text" cloze with inline blanks. The presence of inlineBlanks tells
		     them apart. -->
		{#if isInlineCloze(quiz)}
			<InlineClozeQuiz
				{quiz}
				locale={course.learnLocale}
				onFinish={(passed) => passed && complete()}
			/>
		{:else}
			<PassageQuiz
				{quiz}
				locale={course.learnLocale}
				mode="read"
				onFinish={(passed) => passed && complete()}
			/>
		{/if}
	{:else if quiz.type === 'listening'}
		<PassageQuiz
			{quiz}
			locale={course.learnLocale}
			mode="listen"
			onFinish={(passed) => passed && complete()}
		/>
	{:else if quiz.type === 'dictation'}
		<DictationQuiz
			{quiz}
			locale={course.learnLocale}
			onFinish={(passed) => passed && complete()}
		/>
	{:else if quiz.type === 'speakRepeat'}
		<SpeakRepeatQuiz {quiz} locale={course.learnLocale} onFinish={complete} />
	{:else if quiz.type === 'speaking'}
		<SpeakingQuiz
			{quiz}
			courseId={course.id}
			learnLocale={course.learnLocale}
			uiLang={course.uiLang}
			onFinish={(passed) => passed && complete()}
		/>
	{/if}

	{#if finished}
		<aside class="done" in:pop={{ from: 0.95 }}>
			<p class="done-line">
				<Icon name="check" size="1.15em" />
				<span><strong>Finished.</strong> This exercise is marked complete.</span>
			</p>
			{#if next}
				<a class="btn" href="/course/{course.id}/quiz/{next.id}">
					Next: {next.title}
					<Icon name="arrowRight" size="1em" />
				</a>
			{:else}
				<a class="btn" href="/course/{course.id}">
					<Icon name="arrowLeft" size="1em" /> Back to the course
				</a>
			{/if}
		</aside>
	{/if}
</main>

<style>
	.head {
		display: flex;
		align-items: flex-start;
		gap: 0.9rem;
		margin-bottom: 1.6rem;
	}

	/* The same tinted disc the course-home list uses, so a quiz keeps its
	   identity between the two views. */
	.kind {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.5rem;
		height: 2.5rem;
		flex: none;
		margin-top: 0.1rem;
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

	.head-text {
		flex: 1;
		min-width: 0;
	}

	h1 {
		margin: 0.15rem 0 0;
		font-size: var(--step-2);
	}

	.done {
		margin-top: 1.6rem;
		padding: 1.15rem 1.3rem;
		border: 1px solid var(--right);
		border-radius: var(--radius);
		background: var(--right-bg);
	}

	.done-line {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		margin: 0 0 0.95rem;
		max-width: none;
		color: var(--right);
	}
</style>
