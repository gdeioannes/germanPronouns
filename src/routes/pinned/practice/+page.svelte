<script lang="ts">
	// "Practise my pinned questions": the pinned fill-in sentences as one drill,
	// on the same exercise screen as any other (runs of ten, the three steps,
	// the why under a miss). Scores go under their own prefix, so practising
	// here never moves a real exercise's streak or medals.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import FillBlankQuiz from '$lib/components/quiz/FillBlankQuiz.svelte';
	import { loadCourse } from '$lib/content';
	import type { Quiz, QuizSentence } from '$lib/content/types';
	import { practiceQuiz, practiceSentences, practisable } from '$lib/domain/pinPractice';
	import { pins } from '$lib/state/pins.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { inLangQuiz, loadOverlay } from '$lib/i18n/content.svelte';
	import { playSound } from '$lib/services/sounds';
	import { celebrate } from '$lib/motion/fx.svelte';
	import { track } from '$lib/services/analytics';
	import { t } from '$lib/i18n/t';
	import { onMount } from 'svelte';

	let ready = $state(false);
	let sentences = $state.raw<QuizSentence[]>([]);
	/** Pinned fill-ins no longer in the course (edited away since). */
	let missing = $state(0);
	let locale = $state('de-DE');
	let attempt = $state(0);

	onMount(async () => {
		await Promise.all([pins.load(), progress.ensureLoaded()]);
		const wanted = pins.questions.filter(practisable);
		const quizIds = new Set(wanted.map((p) => p.quizId));
		const quizzes: Quiz[] = [];
		for (const courseId of new Set(wanted.map((p) => p.courseId))) {
			try {
				const course = await loadCourse(courseId);
				locale = course.learnLocale;
				quizzes.push(...course.quizzes.filter((q) => quizIds.has(q.id)));
			} catch (cause) {
				console.error('[pinned practice]', cause);
			}
		}
		// In a second language, the hints and English lines come through the
		// level's overlay, as on the exercise itself.
		await Promise.all([...new Set(quizzes.map((q) => q.level))].map((level) => loadOverlay(level)));
		sentences = practiceSentences(wanted, quizzes.map(inLangQuiz));
		missing = wanted.length - sentences.length;
		ready = true;
		track('pinned_practice', { questions: sentences.length });
	});

	const quiz = $derived(practiceQuiz(sentences, t('Your pinned questions')));

	function runFinished(passed: boolean) {
		if (passed) celebrate();
		else playSound('complete');
	}
</script>

<Seo
	title="Practise pinned questions — Language Quiz"
	description="The questions you pinned, practised together."
	path="/pinned/practice"
	noindex
/>

<div class="screen">
	<header class="top">
		<a class="back-link" href="/pinned"><Icon name="arrowLeft" size="1em" /> {t('Pinned')}</a>
		<h1><Icon name="pin" size="0.85em" /> {t('Your pinned questions')}</h1>
		{#if ready && sentences.length}
			<p class="sub">
				{sentences.length === 1
					? t('1 question. A run is ten answers, so it comes back until the run is over.')
					: t('{n} questions, mixed into runs of ten.', { n: sentences.length })}
			</p>
		{/if}
		{#if missing > 0}
			<p class="sub note">
				{t('{n} pinned questions are no longer in the course in that form and are left out.', { n: missing })}
			</p>
		{/if}
	</header>

	<main class="stage">
		{#if !ready}
			<p class="status">{t('Loading…')}</p>
		{:else if !sentences.length}
			<section class="card empty">
				<p>{t('No fill-in questions pinned yet. Pin one from an exercise and practise it here.')}</p>
				<a class="btn btn-ghost" href="/pinned">{t('Back to Pinned')}</a>
			</section>
		{:else}
			{#key attempt}
				<FillBlankQuiz
					{quiz}
					{locale}
					onAnswer={() => {}}
					onRunFinished={runFinished}
					onTryAgain={() => (attempt += 1)}
				/>
			{/key}
		{/if}
	</main>
</div>

<style>
	/* One screen, as on an exercise: the header, then the drill taking the rest. */
	.screen {
		display: flex;
		flex-direction: column;
		height: 100dvh;
		max-width: 46rem;
		margin: 0 auto;
		padding: 0.6rem 1.25rem calc(0.75rem + env(safe-area-inset-bottom));
	}

	.top {
		flex: none;
	}

	.top .back-link {
		margin-bottom: 0.4rem;
	}

	h1 {
		display: flex;
		align-items: center;
		gap: 0.45rem;
		margin: 0;
		font-size: var(--step-2);
	}

	h1 :global(svg) {
		color: var(--accent-ink);
	}

	.sub {
		margin: 0.25rem 0 0.5rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.note {
		font-style: italic;
	}

	.stage {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
		padding-top: 0.25rem;
		overflow-y: auto;
	}

	.status {
		color: var(--ink-muted);
	}

	.empty {
		display: grid;
		justify-items: start;
		gap: 0.75rem;
	}

	.empty p {
		margin: 0;
	}
</style>
