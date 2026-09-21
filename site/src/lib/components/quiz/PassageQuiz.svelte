<script lang="ts">
	// Reading and listening share a shape: a passage plus multiple-choice
	// questions. The only difference is whether the passage is shown or heard —
	// so one component takes a `mode`, mirroring how the Dart pages differed
	// only in presentation.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { pop, rise } from '$lib/motion';
	import { slide } from 'svelte/transition';
	import type { ListeningQuiz, ReadingQuiz } from '$lib/content/types';

	let {
		quiz,
		locale,
		mode,
		onFinish
	}: {
		quiz: ReadingQuiz | ListeningQuiz;
		locale: string;
		mode: 'read' | 'listen';
		onFinish: (passed: boolean, correct: number, total: number) => void;
	} = $props();

	/** Answer index chosen per question, or null while unanswered. */
	let chosen = $state<(number | null)[]>([]);
	let checked = $state(false);
	let showTranslation = $state(false);
	/** Listening hides the transcript until the quiz is done. */
	let revealTranscript = $state(false);

	// Reset when the component is reused for a different quiz — the answer
	// array must match the new question count, not the old one's.
	$effect(() => {
		quiz.id;
		retry();
	});

	const answered = $derived(chosen.every((c) => c !== null));
	const correctCount = $derived(
		quiz.questions.reduce(
			(n, question, i) => n + (chosen[i] === question.correctIndex ? 1 : 0),
			0
		)
	);
	// The pass bar the Dart pages used: at least two thirds right.
	const passed = $derived(correctCount / quiz.questions.length >= 2 / 3);

	function choose(questionIndex: number, optionIndex: number) {
		if (checked) return;
		chosen[questionIndex] = optionIndex;
	}

	function check() {
		checked = true;
		revealTranscript = true;
		onFinish(passed, correctCount, quiz.questions.length);
	}

	function retry() {
		chosen = quiz.questions.map(() => null);
		checked = false;
		revealTranscript = mode === 'read';
	}
</script>

<article class="passage">
	<header>
		<h2>{quiz.passageTitle}</h2>
		<SpeakButton text={quiz.passage} {locale} label="Play the passage" />
	</header>

	{#if revealTranscript}
		<p class="text" lang={locale}>{quiz.passage}</p>
		{#if quiz.passageTranslation}
			<button class="btn-quiet" onclick={() => (showTranslation = !showTranslation)}>
				{showTranslation ? 'Hide' : 'Show'} translation
			</button>
			{#if showTranslation}
				<p class="translation" transition:slide={{ duration: 200 }}>
					{quiz.passageTranslation}
				</p>
			{/if}
		{/if}
	{:else}
		<p class="hidden-note">
			Listen as many times as you like — the transcript appears once you check
			your answers.
		</p>
	{/if}
</article>

<ol class="questions">
	{#each quiz.questions as question, qi (question.question)}
		{@const answer = chosen[qi]}
		<li>
			<p class="q" lang={locale}>
				{question.question}
				<SpeakButton text={question.question} {locale} />
			</p>
			{#if question.questionTranslation}
				<p class="q-translation">{question.questionTranslation}</p>
			{/if}

			<div class="options">
				{#each question.options as option, oi (option)}
					{@const isChosen = answer === oi}
					{@const isCorrect = oi === question.correctIndex}
					<button
						class="option"
						class:chosen={isChosen}
						class:correct={checked && isCorrect}
						class:wrong={checked && isChosen && !isCorrect}
						disabled={checked}
						onclick={() => choose(qi, oi)}
					>
						<span class="marker" aria-hidden="true">
							{#if checked && isCorrect}
								<Icon name="check" size="0.95em" />
							{:else if checked && isChosen}
								<Icon name="close" size="0.95em" />
							{:else}
								{String.fromCharCode(65 + oi)}
							{/if}
						</span>
						<span class="option-text">
							<span lang={locale}>{option}</span>
							{#if question.optionsTranslation?.[oi]}
								<small>{question.optionsTranslation[oi]}</small>
							{/if}
						</span>
					</button>
				{/each}
			</div>

			{#if checked && question.explanation}
				<p class="explanation" in:rise={{ delay: 80 }}>
					<Icon name="info" size="1em" />
					<span>{question.explanation}</span>
				</p>
			{/if}
		</li>
	{/each}
</ol>

<footer class="actions">
	{#if checked}
		<Burst trigger={passed ? 1 : 0} count={26} />
		<p class="verdict" class:pass={passed} in:pop={{ from: 0.9 }}>
			<Icon name={passed ? 'trophy' : 'close'} size="1.1em" />
			<span class="tnum">{correctCount} of {quiz.questions.length} correct</span>
			— {passed ? 'passed' : 'not quite yet'}
		</p>
		{#if !passed}
			<button class="btn" onclick={retry}>
				<Icon name="repeat" size="1em" /> Try again
			</button>
		{/if}
	{:else}
		<button class="btn" disabled={!answered} onclick={check}>
			<Icon name="check" size="1em" /> Check answers
		</button>
	{/if}
</footer>

<style>
	.passage {
		padding: 1.5rem 1.75rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.passage header {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin-bottom: 0.85rem;
	}

	.passage h2 {
		margin: 0;
		font-size: var(--step-1);
	}

	/* A reading passage is long-form: serif, generous leading, and a measure
	   capped so the eye can find the next line. */
	.text {
		margin: 0;
		max-width: var(--measure);
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-variation-settings: 'opsz' 16;
		line-height: 1.75;
		color: var(--ink);
		white-space: pre-wrap;
	}

	.hidden-note,
	.translation {
		max-width: var(--measure);
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.q-translation {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.questions {
		margin: 1.75rem 0 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 1.5rem;
	}

	.q {
		margin: 0 0 0.15rem;
		max-width: none;
		font-size: var(--step-0);
		font-weight: 600;
	}

	.q-translation {
		margin: 0 0 0.65rem;
	}

	.options {
		display: grid;
		gap: 0.45rem;
	}

	.option {
		display: flex;
		align-items: flex-start;
		gap: 0.7rem;
		padding: 0.65rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.option:hover:not(:disabled) {
		border-color: var(--accent);
		transform: translateX(2px);
	}

	/* A/B/C in a circle, swapped for a tick or cross once checked — so the
	   verdict lands where the eye already is. */
	.marker {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.55em;
		height: 1.55em;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
		font-size: var(--step--1);
		font-weight: 700;
	}

	.option-text {
		display: flex;
		flex-direction: column;
		gap: 0.08rem;
	}

	.option.chosen {
		border-color: var(--navy);
		background: var(--surface-alt);
	}

	.option.chosen .marker {
		background: var(--navy);
		color: #fff;
	}

	.option.correct {
		border-color: var(--right);
		background: var(--right-bg);
	}

	.option.correct .marker {
		background: var(--right);
		color: #fff;
	}

	.option.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
	}

	.option.wrong .marker {
		background: var(--wrong);
		color: #fff;
	}

	.option small {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.explanation {
		display: flex;
		align-items: flex-start;
		gap: 0.45rem;
		margin: 0.6rem 0 0;
		padding-left: 0.2rem;
		max-width: var(--measure);
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.actions {
		position: relative;
		margin-top: 1.9rem;
		display: flex;
		align-items: center;
		gap: 1rem;
		flex-wrap: wrap;
	}

	.verdict {
		display: flex;
		align-items: center;
		gap: 0.45rem;
		margin: 0;
		font-weight: 700;
		color: var(--wrong);
	}

	.verdict.pass {
		color: var(--right);
	}
</style>
