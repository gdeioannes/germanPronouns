<script lang="ts">
	// Dictation: hear a line, type what you heard. The text is never shown
	// until the line is answered or given up on — that is the whole exercise.
	import SpeakButton from '../SpeakButton.svelte';
	import { isAcceptedAnswer } from '$lib/domain/answers';
	import { progress } from '$lib/state/progress.svelte';
	import { tts } from '$lib/services/speech';
	import type { DictationQuiz } from '$lib/content/types';

	let {
		quiz,
		locale,
		onFinish
	}: {
		quiz: DictationQuiz;
		locale: string;
		onFinish: (passed: boolean, correct: number, total: number) => void;
	} = $props();

	let index = $state(0);
	let answer = $state('');
	let verdict = $state<'none' | 'right' | 'wrong'>('none');
	let correctCount = $state(0);
	let done = $state(false);

	const item = $derived(quiz.items[index]);
	const total = $derived(quiz.items.length);

	// Navigating between two dictation quizzes reuses this component, so the
	// run has to reset when the quiz prop changes — otherwise the new quiz
	// inherits the old one's index and score.
	$effect(() => {
		quiz.id;
		restart();
	});
	const passed = $derived(correctCount / total >= 2 / 3);

	function play(rate = 1) {
		if (item) tts.speak(item.text, { locale, rate });
	}

	// Each new line plays itself once; the learner can replay at will.
	$effect(() => {
		if (item && !done) play();
	});

	function check() {
		if (!item || verdict !== 'none' || !answer.trim()) return;
		const right = isAcceptedAnswer(answer, [item.text], progress.relaxedCorrection);
		verdict = right ? 'right' : 'wrong';
		if (right) correctCount += 1;
	}

	function next() {
		if (index + 1 >= total) {
			done = true;
			onFinish(passed, correctCount, total);
			return;
		}
		index += 1;
		answer = '';
		verdict = 'none';
	}

	function onKey(event: KeyboardEvent) {
		if (event.key !== 'Enter') return;
		if (verdict === 'none') check();
		else next();
	}

	function restart() {
		index = 0;
		answer = '';
		verdict = 'none';
		correctCount = 0;
		done = false;
	}
</script>

{#if done}
	<section class="card done">
		<p class="verdict" class:pass={passed}>
			{correctCount} of {total} correct — {passed ? 'passed' : 'not quite yet'}
		</p>
		<button class="primary" onclick={restart}>Run it again</button>
	</section>
{:else if item}
	<section class="card">
		<p class="counter">Line {index + 1} of {total}</p>

		<div class="controls">
			<button class="play" onclick={() => play()}>▶ Play</button>
			<button class="play slow" onclick={() => play(0.6)}>🐢 Slower</button>
		</div>

		<input
			bind:value={answer}
			onkeydown={onKey}
			disabled={verdict !== 'none'}
			placeholder="Type what you hear"
			lang={locale}
			autocomplete="off"
			autocapitalize="sentences"
			spellcheck="false"
		/>

		{#if verdict === 'none'}
			<button class="primary" onclick={check} disabled={!answer.trim()}>Check</button>
		{:else}
			<p class="feedback" class:right={verdict === 'right'}>
				{verdict === 'right' ? 'Correct' : 'Not quite'}
			</p>
			<p class="reveal" lang={locale}>
				{item.text}
				<SpeakButton text={item.text} {locale} />
			</p>
			{#if item.translation}
				<p class="translation">{item.translation}</p>
			{/if}
			<button class="primary" onclick={next}>
				{index + 1 >= total ? 'Finish' : 'Next line'}
			</button>
		{/if}
	</section>
{/if}

<style>
	.card {
		padding: 1.5rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
	}

	.counter {
		margin: 0 0 1rem;
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--muted);
	}

	.controls {
		display: flex;
		gap: 0.6rem;
		margin-bottom: 1rem;
	}

	.play {
		padding: 0.55rem 1rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface-alt);
		font: inherit;
		cursor: pointer;
	}

	.play:hover {
		border-color: var(--accent);
	}

	input {
		width: 100%;
		box-sizing: border-box;
		padding: 0.65rem 0.85rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--bg);
		font: inherit;
		font-size: 1.05rem;
	}

	.feedback {
		margin: 0 0 0.5rem;
		font-weight: 700;
		color: #b4452f;
	}

	.feedback.right {
		color: #3f7d4e;
	}

	.reveal {
		margin: 0 0 0.25rem;
		font-size: 1.15rem;
		color: var(--ink);
	}

	.translation {
		margin: 0 0 1rem;
		color: var(--muted);
	}

	.verdict {
		margin: 0 0 1rem;
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
