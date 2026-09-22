<script lang="ts">
	// The "big text" cloze: a whole passage with inline blanks typed in place.
	//
	// These reuse `type: "reading"` in the content bundle rather than having a
	// type of their own — they are told apart by carrying `inlineBlanks` and an
	// `inlineTemplate` instead of `questions`. That's inherited from the Dart
	// app, where the same trick avoided adding a QuizKind.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { pop } from '$lib/motion';
	import { slide } from 'svelte/transition';
	import { isAcceptedAnswer } from '$lib/domain/answers';
	import { progress } from '$lib/state/progress.svelte';
	import type { InlineBlank, InlineClozeQuiz } from '$lib/content/types';

	let {
		quiz,
		locale,
		onFinish
	}: {
		quiz: InlineClozeQuiz;
		locale: string;
		onFinish: (passed: boolean, correct: number, total: number) => void;
	} = $props();

	/**
	 * Splits the template on its `{{n}}` markers into alternating literal text
	 * and blank indices, so the passage renders as one flowing paragraph with
	 * inputs sitting inside it.
	 */
	const parts = $derived.by(() => {
		const out: ({ text: string } | { blank: number })[] = [];
		const pattern = /\{\{(\d+)\}\}/g;
		let last = 0;
		let match: RegExpExecArray | null;
		while ((match = pattern.exec(quiz.inlineTemplate)) !== null) {
			if (match.index > last) {
				out.push({ text: quiz.inlineTemplate.slice(last, match.index) });
			}
			out.push({ blank: Number(match[1]) });
			last = match.index + match[0].length;
		}
		if (last < quiz.inlineTemplate.length) {
			out.push({ text: quiz.inlineTemplate.slice(last) });
		}
		return out;
	});

	let answers = $state<string[]>([]);
	let checked = $state(false);

	// Reset when the component is reused for a different quiz.
	$effect(() => {
		quiz.id;
		retry();
	});
	let showTranslation = $state(false);

	function accepted(blank: InlineBlank): string[] {
		return [blank.answer, ...(blank.accepted ?? [])];
	}

	const results = $derived(
		quiz.inlineBlanks.map((blank, i) =>
			isAcceptedAnswer(answers[i], accepted(blank), progress.relaxedCorrection)
		)
	);
	const correctCount = $derived(results.filter(Boolean).length);
	const total = $derived(quiz.inlineBlanks.length);
	// Same bar as the other passage quizzes: two thirds right.
	const passed = $derived(correctCount / total >= 2 / 3);
	const allFilled = $derived(answers.every((a) => a.trim().length > 0));

	function check() {
		checked = true;
		onFinish(passed, correctCount, total);
	}

	function retry() {
		answers = quiz.inlineBlanks.map(() => '');
		checked = false;
	}
</script>

<article class="passage">
	<header>
		<h2>{quiz.passageTitle}</h2>
		<SpeakButton text={quiz.passage} {locale} label="Play the passage" />
	</header>

	<p class="cloze" lang={locale}>
		{#each parts as part, i (i)}
			{#if 'text' in part}{part.text}{:else}
				{@const blank = quiz.inlineBlanks[part.blank]}
				<span class="slot">
					<input
						bind:value={answers[part.blank]}
						disabled={checked}
						class:right={checked && results[part.blank]}
						class:wrong={checked && !results[part.blank]}
						size={Math.max(blank.answer.length, 4)}
						aria-label={blank.hint ?? `Blank ${part.blank + 1}`}
						autocomplete="off"
						autocapitalize="off"
						spellcheck="false"
					/>
					{#if checked && !results[part.blank]}
						<span class="fix">{blank.answer}</span>
					{/if}
					{#if !checked && blank.hint}
						<span class="hint">{blank.hint}</span>
					{/if}
				</span>
			{/if}
		{/each}
	</p>
</article>

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

<footer class="actions">
	{#if checked}
		<Burst trigger={passed ? 1 : 0} count={26} />
		<p class="verdict" class:pass={passed} in:pop={{ from: 0.9 }}>
			<Icon name={passed ? 'trophy' : 'close'} size="1.1em" />
			<span class="tnum">{correctCount} of {total} correct</span>
			— {passed ? 'passed' : 'not quite yet'}
		</p>
		{#if !passed}
			<button class="btn" onclick={retry}>
				<Icon name="repeat" size="1em" /> Try again
			</button>
		{/if}
	{:else}
		<button class="btn" onclick={check} disabled={!allFilled}>
			<Icon name="check" size="1em" /> Check the text
		</button>
	{/if}
</footer>

<style>
	.passage {
		padding: 1.25rem 1.5rem;
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
		font-size: var(--step-1);
	}

	/* The cloze is a reading passage with holes in it: serif, and leaded wide
	   enough for a gap and its hint to sit between two lines of prose. */
	.cloze {
		margin: 0;
		max-width: var(--measure);
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-variation-settings: 'opsz' 16;
		line-height: 2.4;
		white-space: pre-wrap;
		color: var(--ink);
	}

	/* A column: the gap, then its hint underneath. Both are in normal flow, so
	   a long hint makes its own slot taller instead of being absolutely
	   positioned and landing on top of the line above. `vertical-align:
	   baseline` on an inline-flex box takes the baseline of its FIRST item —
	   the input — so the gap still sits on the sentence's baseline while the
	   hint hangs below it. */
	.slot {
		display: inline-flex;
		flex-direction: column;
		align-items: center;
		vertical-align: baseline;
		white-space: normal;
	}

	.slot input {
		min-width: 4ch;
		padding: 0.1rem 0.4rem;
		border: 0;
		border-bottom: 2px solid var(--accent);
		border-radius: 4px 4px 0 0;
		background: var(--surface-alt);
		font: inherit;
		font-size: 0.94em;
		text-align: center;
		transition:
			background var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out);
	}

	.slot input:focus {
		outline: none;
		background: var(--accent-soft);
	}

	.slot input.right {
		border-bottom-color: var(--right);
		background: var(--right-bg);
	}

	.slot input.wrong {
		border-bottom-color: var(--wrong);
		background: var(--wrong-bg);
	}

	/* Hints run long — "nett · ... Nachbarn (Akk, Plural, kein Artikel)" — so
	   they wrap within a sane measure rather than running under the neighbouring
	   words. Sans-serif and small, to read as an annotation on the prose. */
	.fix,
	.hint {
		max-width: 18ch;
		font-family: 'Inter', sans-serif;
		font-size: 0.66rem;
		line-height: 1.25;
		text-align: center;
		text-wrap: balance;
	}

	.fix {
		font-weight: 700;
		color: var(--right);
		animation: reveal 260ms var(--ease-out) both;
	}

	@keyframes reveal {
		from {
			opacity: 0;
			transform: translateY(-3px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}

	.hint {
		color: var(--ink-muted);
	}

	.translation {
		max-width: var(--measure);
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.actions {
		position: relative;
		margin-top: 1.75rem;
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
