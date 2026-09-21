<script lang="ts">
	// The "big text" cloze: a whole passage with inline blanks typed in place.
	//
	// These reuse `type: "reading"` in the content bundle rather than having a
	// type of their own — they are told apart by carrying `inlineBlanks` and an
	// `inlineTemplate` instead of `questions`. That's inherited from the Dart
	// app, where the same trick avoided adding a QuizKind.
	import SpeakButton from '../SpeakButton.svelte';
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
	<button class="link" onclick={() => (showTranslation = !showTranslation)}>
		{showTranslation ? 'Hide' : 'Show'} translation
	</button>
	{#if showTranslation}
		<p class="translation">{quiz.passageTranslation}</p>
	{/if}
{/if}

<footer class="actions">
	{#if checked}
		<p class="verdict" class:pass={passed}>
			{correctCount} of {total} correct — {passed ? 'passed' : 'not quite yet'}
		</p>
		{#if !passed}<button class="primary" onclick={retry}>Try again</button>{/if}
	{:else}
		<button class="primary" onclick={check} disabled={!allFilled}>
			Check the text
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
		font-size: 1.15rem;
	}

	.cloze {
		margin: 0;
		font-size: 1.08rem;
		line-height: 2.4;
		white-space: pre-wrap;
	}

	.slot {
		position: relative;
		display: inline-block;
		white-space: nowrap;
	}

	.slot input {
		padding: 0.1rem 0.35rem;
		border: 0;
		border-bottom: 2px solid var(--accent);
		border-radius: 4px 4px 0 0;
		background: var(--surface-alt);
		font: inherit;
		font-size: 1rem;
		text-align: center;
	}

	.slot input:focus {
		outline: none;
		background: var(--accent-soft);
	}

	.slot input.right {
		border-bottom-color: #3f7d4e;
		background: #eaf4ec;
	}

	.slot input.wrong {
		border-bottom-color: #b4452f;
		background: #f9ebe7;
	}

	.fix,
	.hint {
		position: absolute;
		left: 50%;
		transform: translateX(-50%);
		white-space: nowrap;
		font-size: 0.68rem;
		line-height: 1.2;
	}

	.fix {
		top: 100%;
		font-weight: 700;
		color: #3f7d4e;
	}

	.hint {
		bottom: 100%;
		color: var(--muted);
	}

	.link {
		margin-top: 1rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent);
		font: inherit;
		font-size: 0.88rem;
		cursor: pointer;
		text-decoration: underline;
	}

	.translation {
		color: var(--muted);
		font-size: 0.9rem;
	}

	.actions {
		margin-top: 1.5rem;
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
