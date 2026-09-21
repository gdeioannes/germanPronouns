<script lang="ts">
	// Dictation: hear a line, type what you heard. The text is never shown
	// until the line is answered or given up on — that is the whole exercise.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { pop, rise } from '$lib/motion';
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
	let burst = $state(0);

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
		if (right) {
			correctCount += 1;
			burst += 1;
		}
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
	<section class="card done" in:pop>
		<Burst trigger={passed ? 1 : 0} count={28} />
		<p class="verdict" class:pass={passed}>
			{correctCount} of {total} correct — {passed ? 'passed' : 'not quite yet'}
		</p>
		<button class="btn" onclick={restart}>
			<Icon name="repeat" size="1em" /> Run it again
		</button>
	</section>
{:else if item}
	<section class="card">
		<p class="eyebrow counter">
			<span class="tnum">Line {index + 1} of {total}</span>
		</p>

		<div class="controls">
			<Burst trigger={burst} count={12} />
			<button class="btn-ghost chip" onclick={() => play()}>
				<Icon name="play" size="0.95em" /> Play
			</button>
			<button class="btn-ghost chip" onclick={() => play(0.6)}>
				<Icon name="slow" size="0.95em" /> Slower
			</button>
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
			<button class="btn" onclick={check} disabled={!answer.trim()}>
				<Icon name="check" size="1em" /> Check
			</button>
		{:else}
			<p class="feedback" class:right={verdict === 'right'} in:pop={{ from: 0.88 }}>
				<Icon name={verdict === 'right' ? 'check' : 'close'} size="1.05em" />
				{verdict === 'right' ? 'Correct' : 'Not quite'}
			</p>
			<p class="reveal" lang={locale} in:rise>
				{item.text}
				<SpeakButton text={item.text} {locale} />
			</p>
			{#if item.translation}
				<p class="translation">{item.translation}</p>
			{/if}
			<button class="btn" onclick={next}>
				{index + 1 >= total ? 'Finish' : 'Next line'}
				<Icon name="arrowRight" size="1em" />
			</button>
		{/if}
	</section>
{/if}

<style>
	.card {
		position: relative;
		padding: 1.75rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.counter {
		margin: 0 0 1.1rem;
	}

	.controls {
		position: relative;
		display: flex;
		gap: 0.6rem;
		margin-bottom: 1.1rem;
	}

	/* A compact pill for the transport controls, sized off the button base. */
	.chip {
		padding: 0.48rem 0.95rem;
		border-radius: 999px;
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.chip:hover {
		border-color: var(--accent);
		color: var(--accent);
		transform: translateY(-1px);
	}

	input {
		width: 100%;
		padding: 0.68rem 0.9rem;
		margin-bottom: 1.1rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--bg);
		font: inherit;
		font-size: var(--step-1);
		transition:
			border-color var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	input:focus {
		outline: none;
		border-color: var(--accent);
		box-shadow: 0 0 0 3px var(--accent-soft);
	}

	.feedback {
		display: flex;
		align-items: center;
		gap: 0.42rem;
		margin: 0 0 0.6rem;
		font-weight: 700;
		color: var(--wrong);
	}

	.feedback.right {
		color: var(--right);
	}

	/* The revealed line is the answer key — set in the serif, like the prompts. */
	.reveal {
		margin: 0 0 0.3rem;
		max-width: none;
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 600;
		color: var(--ink);
	}

	.translation {
		margin: 0 0 1.1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.verdict {
		margin: 0 0 1.1rem;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--wrong);
		font-variant-numeric: tabular-nums;
	}

	.verdict.pass {
		color: var(--right);
	}
</style>
