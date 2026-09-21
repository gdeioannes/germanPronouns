<script lang="ts">
	// Reading and listening share a shape: a passage plus multiple-choice
	// questions. The only difference is whether the passage is shown or heard —
	// so one component takes a `mode`, mirroring how the Dart pages differed
	// only in presentation.
	import SpeakButton from '../SpeakButton.svelte';
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
			<button class="link" onclick={() => (showTranslation = !showTranslation)}>
				{showTranslation ? 'Hide' : 'Show'} translation
			</button>
			{#if showTranslation}
				<p class="translation">{quiz.passageTranslation}</p>
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
						<span lang={locale}>{option}</span>
						{#if question.optionsTranslation?.[oi]}
							<small>{question.optionsTranslation[oi]}</small>
						{/if}
					</button>
				{/each}
			</div>

			{#if checked && question.explanation}
				<p class="explanation">{question.explanation}</p>
			{/if}
		</li>
	{/each}
</ol>

<footer class="actions">
	{#if checked}
		<p class="verdict" class:pass={passed}>
			{correctCount} of {quiz.questions.length} correct —
			{passed ? 'passed' : 'not quite yet'}
		</p>
		{#if !passed}
			<button class="primary" onclick={retry}>Try again</button>
		{/if}
	{:else}
		<button class="primary" disabled={!answered} onclick={check}>
			Check answers
		</button>
	{/if}
</footer>

<style>
	.passage {
		padding: 1.25rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
	}

	.passage header {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin-bottom: 0.75rem;
	}

	.passage h2 {
		margin: 0;
		font-size: 1.15rem;
		color: var(--ink);
	}

	.text {
		margin: 0;
		font-size: 1.05rem;
		line-height: 1.7;
		white-space: pre-wrap;
	}

	.hidden-note,
	.translation,
	.q-translation {
		color: var(--muted);
		font-size: 0.9rem;
	}

	.link {
		margin-top: 0.75rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent);
		font: inherit;
		font-size: 0.88rem;
		cursor: pointer;
		text-decoration: underline;
	}

	.questions {
		margin: 1.5rem 0 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 1.25rem;
	}

	.q {
		margin: 0 0 0.15rem;
		font-weight: 600;
	}

	.q-translation {
		margin: 0 0 0.6rem;
	}

	.options {
		display: grid;
		gap: 0.45rem;
	}

	.option {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.1rem;
		padding: 0.6rem 0.85rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface);
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			border-color 0.12s,
			background 0.12s;
	}

	.option:hover:not(:disabled) {
		border-color: var(--accent);
	}

	.option.chosen {
		border-color: var(--ink);
		background: var(--surface-alt);
	}

	.option.correct {
		border-color: #3f7d4e;
		background: #eaf4ec;
	}

	.option.wrong {
		border-color: #b4452f;
		background: #f9ebe7;
	}

	.option small {
		color: var(--muted);
		font-size: 0.8rem;
	}

	.explanation {
		margin: 0.5rem 0 0;
		padding-left: 0.75rem;
		border-left: 3px solid var(--line);
		color: var(--ink-soft);
		font-size: 0.9rem;
	}

	.actions {
		margin-top: 1.75rem;
		display: flex;
		align-items: center;
		gap: 1rem;
	}

	.verdict {
		margin: 0;
		font-weight: 700;
		color: #b4452f;
	}

	.verdict.pass {
		color: #3f7d4e;
	}

	.primary {
		padding: 0.6rem 1.25rem;
		border: 0;
		border-radius: 999px;
		background: var(--ink);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.primary:disabled {
		opacity: 0.45;
		cursor: default;
	}
</style>
