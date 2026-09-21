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
	<a class="back-link" href="/course/{course.id}">← {course.name}</a>

	<header class="head">
		<div>
			<p class="level">{quiz.level ?? ''} · {quiz.type}</p>
			<h1>{quiz.title}</h1>
		</div>
		{#if ribbon}
			<RibbonBadge tier={ribbon} />
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
		<aside class="done">
			<p><strong>Finished.</strong> This exercise is marked complete.</p>
			{#if next}
				<a class="primary" href="/course/{course.id}/quiz/{next.id}">
					Next: {next.title} →
				</a>
			{:else}
				<a class="primary" href="/course/{course.id}">Back to the course</a>
			{/if}
		</aside>
	{/if}
</main>

<style>
	.head {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 1rem;
		margin-bottom: 1.5rem;
	}

	.level {
		margin: 0;
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--muted);
	}

	h1 {
		margin: 0.2rem 0 0;
		font-size: clamp(1.4rem, 3.5vw, 1.9rem);
		line-height: 1.2;
	}

	.done {
		margin-top: 1.5rem;
		padding: 1.1rem 1.25rem;
		border: 1px solid #a9cfb3;
		border-radius: 14px;
		background: #eaf4ec;
	}

	.done p {
		margin: 0 0 0.85rem;
	}

	.primary {
		display: inline-block;
		padding: 0.6rem 1.25rem;
		border-radius: 999px;
		background: var(--ink);
		color: #fff;
		font-weight: 600;
		text-decoration: none;
	}
</style>
