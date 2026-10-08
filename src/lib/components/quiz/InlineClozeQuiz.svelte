<script lang="ts">
	import GermanText from '../GermanText.svelte';
	// The "big text" cloze: a whole passage with inline blanks typed in place.
	//
	// These reuse `type: "reading"` in the content bundle rather than having a
	// type of their own — they are told apart by carrying `inlineBlanks` and an
	// `inlineTemplate` instead of `questions`. That's inherited from the Dart
	// app, where the same trick avoided adding a QuizKind.
	//
	// A long text runs as pages that each fit the screen (see Steps), with the
	// check as the last section.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import Sheet from '../Sheet.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import Steps, { type StepMark } from './Steps.svelte';
	import { pop } from '$lib/motion';
	import { matchesAccepted } from '$lib/domain/answers';
	import { paginateCloze, type ClozePart } from '$lib/domain/paginate';
	import { fitOnResize, fitPages, type PageFit } from './fit';
	import { tick, untrack } from 'svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { clearSpot, loadSpot, saveSpot } from '$lib/state/resume';
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
		const out: ClozePart[] = [];
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

	/** Characters per page for a 390×844 phone; measured to fit (see fit.ts). */
	const BASE_BUDGET = 320;
	let fit = $state<PageFit>({ budget: BASE_BUDGET, lineWidth: 0 });
	/** The passage as screen-sized pages; a blank weighs its answer plus hint. */
	const pages = $derived(paginateCloze(parts, fit.budget, 24, fit.lineWidth || undefined));

	let root = $state<HTMLElement>();
	$effect(() => {
		if (!root) return;
		quiz.id;
		const el = root;
		return fitOnResize(() =>
			fitPages(el, '.cloze', (f) => (fit = f))
		);
	});

	// Re-paging (a resize) moves the check section: keep it in view if it was.
	let seenPages = -1;
	$effect(() => {
		const now = pages.length;
		untrack(() => {
			if (seenPages >= 0 && now !== seenPages) {
				index = index >= seenPages ? now : Math.min(index, now - 1);
			}
			seenPages = now;
		});
	});
	/** Which blanks sit on each page. */
	const pageBlanks = $derived(
		pages.map((page) => page.flatMap((part) => ('blank' in part ? [part.blank] : [])))
	);

	let answers = $state<string[]>([]);
	let checked = $state(false);
	let index = $state(0);

	/** False until a saved spot has been looked for, so a fresh start never overwrites it. */
	let restored = false;

	// Reset when the component is reused for a different quiz, then bring back
	// what the learner had typed on a visit they left part-way, on the page
	// with the first empty gap.
	$effect(() => {
		const id = quiz.id;
		retry();
		restored = false;
		void loadSpot<{ answers: string[] }>(quiz.storageKeyPrefix).then((spot) => {
			if (id !== quiz.id) return;
			const saved = spot?.answers;
			if (Array.isArray(saved) && saved.length === quiz.inlineBlanks.length && saved.some((a) => a?.trim())) {
				answers = saved.map((a) => (typeof a === 'string' ? a : ''));
				const firstEmpty = answers.findIndex((a) => !a.trim());
				const page = firstEmpty < 0 ? pages.length : pageBlanks.findIndex((blanks) => blanks.includes(firstEmpty));
				index = Math.max(0, page);
			}
			restored = true;
		});
	});

	// Typed answers are saved as they change, until they are checked.
	$effect(() => {
		const typed = $state.snapshot(answers);
		if (!restored || checked) return;
		if (typed.some((a) => a.trim())) saveSpot(quiz.storageKeyPrefix, { answers: typed });
	});
	let showTranslation = $state(false);

	function accepted(blank: InlineBlank): string[] {
		return [blank.answer, ...(blank.accepted ?? [])];
	}

	const results = $derived(
		quiz.inlineBlanks.map((blank, i) =>
			matchesAccepted(answers[i], accepted(blank), progress.relaxedCorrection, quiz.strictDiacritics === true)
		)
	);
	const correctCount = $derived(results.filter(Boolean).length);
	const total = $derived(quiz.inlineBlanks.length);
	// Same bar as the other passage quizzes: two thirds right.
	const passed = $derived(correctCount / total >= 2 / 3);
	const allFilled = $derived(answers.every((a) => a.trim().length > 0));

	const count = $derived(pages.length + 1);
	const labels = $derived([
		...pages.map((_, i) => (pages.length > 1 ? `Text ${i + 1}` : 'Text')),
		'Check'
	]);
	const marks = $derived<StepMark[]>([
		...pageBlanks.map((blanks): StepMark => {
			if (checked) return blanks.every((b) => results[b]) ? 'right' : 'wrong';
			return blanks.length && blanks.every((b) => answers[b]?.trim()) ? 'done' : null;
		}),
		null
	]);
	const filledCount = $derived(answers.filter((a) => a.trim().length > 0).length);

	/** The result panel: the Check button it replaces held focus. */
	let resultEl = $state<HTMLElement>();

	function check() {
		checked = true;
		clearSpot(quiz.storageKeyPrefix);
		onFinish(passed, correctCount, total);
		announce(
			`${correctCount} of ${total} correct. ${passed ? 'Passed.' : 'Not quite yet: two thirds right passes.'}`
		);
		void tick().then(() => resultEl?.focus({ preventScroll: true }));
	}

	function retry() {
		answers = quiz.inlineBlanks.map(() => '');
		checked = false;
		index = 0;
	}

	/** Enter jumps to the page's next gap, and from its last to the next page. */
	function onKey(event: KeyboardEvent, page: number, blank: number) {
		if (event.key !== 'Enter') return;
		event.preventDefault();
		const at = pageBlanks[page].indexOf(blank);
		const field = (event.currentTarget as HTMLElement)
			.closest('.cloze')
			?.querySelectorAll<HTMLInputElement>('input')[at + 1];
		if (field) field.focus();
		else index = page + 1;
	}
</script>

<div class="reading-fit" bind:this={root}>
<Steps {count} bind:index {labels} {marks}>
	{#snippet step(p)}
		{#if p < pages.length}
			<article class="passage" class:pictured={quiz.image && p === 0}>
				{#if quiz.image && p === 0}
					<!-- The scene sets the stage; the page budget is measured below it. -->
					<img class="scene" src="/img/{quiz.image}.webp" alt="" width="1024" height="768" />
				{/if}
				<header>
					<h2>{quiz.passageTitle}</h2>
					<SpeakButton text={quiz.passage} {locale} label="Play the passage" />
					{#if quiz.passageTranslation}
						<button type="button" class="reading-chip" onclick={() => (showTranslation = true)}>
							Translation
						</button>
					{/if}
				</header>

				<p class="cloze" lang={locale}>
					{#each pages[p] as part, i (i)}
						{#if 'text' in part}<GermanText text={part.text} />{:else}
							{@const blank = quiz.inlineBlanks[part.blank]}
							<span class="slot">
								<input
									bind:value={answers[part.blank]}
									onkeydown={(event) => onKey(event, p, part.blank)}
									enterkeyhint="next"
									disabled={checked}
									class:right={checked && results[part.blank]}
									class:wrong={checked && !results[part.blank]}
									aria-invalid={checked && !results[part.blank] ? 'true' : undefined}
									size={Math.max(blank.answer.length, 4)}
									aria-label="Gap {part.blank + 1} of {total}"
									aria-describedby={blank.hint && !checked ? `${quiz.id}-hint-${part.blank}` : undefined}
									autocomplete="off"
									autocapitalize="off"
									spellcheck="false"
								/>
								{#if checked && !results[part.blank]}
									<span class="fix"><span class="sr-only" lang="en">Correct answer: </span>{blank.answer}</span>
								{/if}
								{#if !checked && blank.hint}
									<span class="hint" id="{quiz.id}-hint-{part.blank}">{blank.hint}</span>
								{/if}
							</span>
						{/if}
					{/each}
				</p>
			</article>
		{:else}
			<div class="reading-check" tabindex="-1" data-focus-target bind:this={resultEl}>
				{#if checked}
					<Burst trigger={passed ? 1 : 0} count={26} />
					<p class="reading-verdict" class:pass={passed} in:pop={{ from: 0.9 }}>
						<Icon name={passed ? 'trophy' : 'close'} size="1.3em" />
						<span class="tnum">{correctCount} of {total} correct</span>
					</p>
					<p class="reading-sub">
						{passed ? 'Passed — well done.' : 'Not quite yet: two thirds right passes.'}
						Go back to see the corrections under each gap.
					</p>
					{#if !passed}
						<button type="button" class="btn" onclick={retry}>
							<Icon name="repeat" size="1em" /> Try again
						</button>
					{/if}
				{:else}
					<p class="reading-verdict neutral tnum">{filledCount} of {total} gaps filled</p>
					<!-- Checkable at any point: an empty gap simply counts as wrong
					     and gets its correction like any other miss. -->
					<button type="button" class="btn" onclick={check}>
						<Icon name="check" size="1em" /> Check the text
					</button>
					{#if !allFilled}
						<p class="reading-sub">Empty gaps count as wrong — you'll see their answers.</p>
					{/if}
				{/if}
			</div>
		{/if}
	{/snippet}
</Steps>
</div>

{#if quiz.passageTranslation}
	<Sheet bind:open={showTranslation} title="Translation" id="translation-{quiz.id}">
		<p class="reading-translation">{quiz.passageTranslation}</p>
	</Sheet>
{/if}

<style>
	.passage {
		flex: 1;
		padding: 1.25rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
	}

	.passage header {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.6rem;
		margin-bottom: 0.75rem;
	}

	.passage h2 {
		margin: 0;
		font-size: var(--step-1);
	}

	/* The first page carries the scene on its own cream (the colour the
	   picture's paper is levelled to), so there is no edge around it. */
	.passage.pictured {
		background: #fbf5e4;
	}

	.scene {
		display: block;
		width: min(100%, 22rem);
		height: auto;
		max-height: min(11rem, 24dvh);
		margin: -0.25rem auto 0.8rem;
		object-fit: cover;
		user-select: none;
		-webkit-user-drag: none;
	}

	/* The cloze is a reading passage with holes in it: serif, and leaded wide
	   enough for a gap and its hint to sit between two lines of prose. */
	.cloze {
		margin: 0;
		max-width: var(--measure);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
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
		/* A heavier, darker underline: the tint alone is too faint to find. */
		border-bottom-color: var(--accent-ink);
		box-shadow: inset 0 -2px 0 var(--accent-ink);
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
		font-family: 'Inter Variable', 'Inter', sans-serif;
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

	@media (max-width: 36rem) {
		.passage {
			padding: 1rem 1.05rem;
		}
		.cloze {
			font-size: var(--step-0);
			line-height: 2.3;
		}
	}
</style>
