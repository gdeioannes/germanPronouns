<script lang="ts">
	// The fill-in-the-blank engine — 96 of the course's 214 exercises, and the
	// only kind with no completion set of its own: reaching the goal streak IS
	// completion (see domain/progress.ts).
	//
	// Ported from lib/widgets/quiz_page.dart. The interaction is the Dart one:
	//
	//   * the field sits INSIDE the sentence, where the blank is, set in the
	//     same type — you answer in the gap, not in a box underneath it;
	//   * on submit the correct answer is typed into that same field, one
	//     letter at a time, green when you were right and red when you were
	//     not — the correction lands exactly where the eye already is;
	//   * then it advances on its own. There is no "next" button, so a run
	//     keeps its rhythm and the keyboard never has to be left.
	//
	// Questions come from the shuffle bag, so the whole pool is seen once per
	// cycle and the same question never repeats back to back.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import GermanText from '../GermanText.svelte';
	import { BLANK, canonicalGapAnswer, gapCount, matchesGaps } from '$lib/domain/answers';
	import { filledSentence, fillBlankPool, revealedParts } from '$lib/domain/spoken';
	import { untrack } from 'svelte';
	import { drawFromShuffleBag } from '$lib/domain/shuffleBag';
	import { STREAK_LAP_SIZE, progressionUnlockStreak } from '$lib/domain/progress';
	import { MIN_SHOW, REVEAL_PAUSE, progress } from '$lib/state/progress.svelte';
	import { freshen, prefersReducedMotion } from '$lib/motion';
	import { react, shakeOn } from '$lib/motion/fx.svelte';
	import StreakTracker from './StreakTracker.svelte';
	import type { FillBlankQuiz, QuizSentence } from '$lib/content/types';

	let {
		quiz,
		locale,
		onAnswer,
		onGoalReached
	}: {
		quiz: FillBlankQuiz;
		locale: string;
		onAnswer: (correct: boolean) => void;
		onGoalReached: () => void;
	} = $props();

	// Built once: the page is keyed by quiz id, so a new quiz mounts a new component.
	const pool = untrack(() => fillBlankPool(quiz));
	const bag: QuizSentence[] = [];
	const goal = $derived(progressionUnlockStreak(progress.gating));

	// The first question is chosen up front rather than in an effect, so the
	// prerendered page already shows a real sentence instead of an empty card.
	// Raw, not deep state: the shuffle bag compares by identity, and a proxy
	// never equals the pool's own object.
	let current = $state.raw<QuizSentence | undefined>(pool[0]);
	let started = false;
	/**
	 * What the learner has typed, one entry per gap. Most sentences have one
	 * gap; "je … desto" or "hatte … verlassen" have two, and the key for those
	 * is split on its ellipsis so each gap is checked against its own part.
	 */
	let answers = $state<string[]>(['']);
	/** null while answering; then how it went, which colours the field. */
	let verdict = $state<'right' | 'wrong' | null>(null);
	let streak = $state(0);
	/** The answer card, for the praise to rise from; `missKey` shakes it. */
	let cardEl = $state<HTMLElement>();
	let missKey = $state(0);
	let misses = $state(0);
	let best = $state(0);
	let inputEls = $state<HTMLInputElement[]>([]);
	let burst = $state(0);
	let burstSize = $state(12);
	/** Pending reveal/advance timers, cancelled if the component goes away. */
	let timers: ReturnType<typeof setTimeout>[] = [];

	const locked = $derived(verdict !== null);

	/**
	 * The subject label above the sentence — shown only when it adds something.
	 * A template-driven quiz already carries the subject inside the sentence,
	 * and repeating it is the duplicate-information problem the Dart app
	 * deliberately avoided.
	 */
	const subject = $derived.by(() => {
		if (!current) return null;
		const found = quiz.subjects?.find((s) => s.key === current!.subjectKey);
		if (!found) return null;
		return current.sentence.includes(found.display) ? null : found.display;
	});

	/** How many gaps the current sentence has. */
	const gaps = $derived(current ? Math.max(1, gapCount(current.sentence)) : 1);

	/**
	 * The sentence split around its blanks: `segments[i]` is the text before
	 * gap i, and the last segment is what follows the final gap. A field sits in
	 * each gap so the answer is typed where the word belongs.
	 */
	const segments = $derived.by(() => {
		const text = current?.sentence ?? '';
		const split = text.split(BLANK);
		return split.length > 1 ? split : [text, ''];
	});

	/** Umlaut-strict quizzes never fold ä→a, whatever the learner's setting. */
	const strict = $derived(quiz.strictDiacritics === true);

	/** The first usable key, split per gap — what a reveal writes in. */
	const canonicalParts = $derived(current ? revealedParts(current, strict) : ['']);

	/** The sentence with its blanks filled, so audio reads a natural sentence. */
	const spokenForm = $derived(current ? filledSentence(current.sentence, canonicalParts) : '');

	/** Grows a field to fit either the typing or the answer being revealed. */
	function fieldSize(gap: number): number {
		return Math.max((answers[gap] ?? '').length + 1, (canonicalParts[gap] ?? '').length, 6);
	}

	/** The first-letter hint, pre-filled into every gap. */
	function hintFill(): string[] {
		return canonicalParts.map((part) => (progress.showFirstLetterHint ? part.charAt(0) : ''));
	}

	function clearTimers() {
		for (const t of timers) clearTimeout(t);
		timers = [];
	}

	function wait(ms: number) {
		return new Promise<void>((resolve) => {
			timers.push(setTimeout(resolve, ms));
		});
	}

	function next() {
		if (pool.length === 0) return;
		current = drawFromShuffleBag(bag, pool, { avoidRepeat: current });
		// The first-letter hint pre-fills the gap rather than sitting beside it.
		answers = hintFill();
		verdict = null;
		inputEls[0]?.focus();
	}

	$effect(() => {
		if (!started) {
			started = true;
			// Apply the first-letter hint now that settings are readable. The
			// next draw avoids this question, so it never repeats back to back.
			if (current) answers = hintFill();
			else next();
		}
		return clearTimers;
	});

	// Load the persisted streak so a returning learner resumes their run.
	$effect(() => {
		(async () => {
			const stats = await progress.statsFor(quiz.storageKeyPrefix);
			streak = stats.streak;
			misses = stats.misses;
			best = stats.bestStreakAbsolute;
		})();
	});

	/**
	 * Types `text` into the field one letter at a time, as the Dart page did —
	 * 70ms a character. Slow enough to read as a correction being written,
	 * fast enough not to be a wait.
	 */
	async function typeOut(parts: string[]) {
		if (prefersReducedMotion()) {
			answers = [...parts];
			return;
		}
		for (let gap = 0; gap < parts.length; gap++) {
			const text = parts[gap];
			for (let i = 1; i <= text.length; i++) {
				await wait(70);
				answers[gap] = text.slice(0, i);
			}
		}
	}

	async function submit() {
		if (!current || locked || answers.some((a) => !a.trim())) return;

		const accepted = current.acceptedAnswers;
		const typed = [...answers];
		const correct = matchesGaps(typed, accepted, progress.relaxedCorrection, strict);

		verdict = correct ? 'right' : 'wrong';

		// The category travels with the answer so a wrong one lands in the
		// per-category mistake counts the worksheet's weak-spot sheet ranks by.
		const stats = await progress.recordAnswer(
			quiz.storageKeyPrefix,
			correct,
			current.categoryLabel
		);
		const lapCompleted = correct && stats.streak > 0 && stats.streak % STREAK_LAP_SIZE === 0;
		streak = stats.streak;
		misses = stats.misses;
		react(correct, cardEl, stats.streak);
		if (!correct) missKey += 1;
		best = stats.bestStreakAbsolute;
		onAnswer(correct);

		if (correct) {
			burstSize = lapCompleted ? 30 : 12;
			burst += 1;
		}

		// Crossing the goal streak completes the quiz and unlocks the next.
		// `>=`, not `===`: if the goal-crossing answer ever fails to record the
		// completion, the next correct answer must still be able to. Marking it is
		// idempotent, so re-firing costs nothing.
		if (correct && stats.streak >= goal) onGoalReached();

		// Write the canonical spelling in. Even a correct answer is rewritten,
		// so a relaxed-mode "schon" visibly becomes "schön".
		const canonical = canonicalGapAnswer(typed, accepted, progress.relaxedCorrection, strict);

		// Enter moves on without waiting out the reveal: shortly after a right
		// answer, once the correction is written in after a wrong one. Never
		// instantly — a double-tapped Enter would swap the sentence before the
		// green ever showed, which reads as a glitch rather than a result.
		const moveOn = () => {
			skip = null;
			clearTimers();
			next();
		};
		if (correct) wait(MIN_SHOW).then(() => (skip ??= moveOn));
		answers = new Array(gaps).fill('');
		await typeOut(canonical);
		skip = moveOn;
		await wait(REVEAL_PAUSE[progress.answerRevealMode]);
		if (skip === moveOn) moveOn();
	}

	/** Set while an answer is on show: skips straight to the next question. */
	let skip = $state<(() => void) | null>(null);

	/** Every gap has something in it, so the answer can be checked. */
	const filled = $derived(answers.every((a) => a.trim().length > 0));

	/**
	 * The Check button. A tap closes the phone keyboard first, so the verdict
	 * and the written-in answer are not hidden behind it.
	 */
	function checkTap() {
		(document.activeElement as HTMLElement | null)?.blur();
		submit();
	}

	/**
	 * Keeps a tap on the buttons from blurring the field before the click
	 * lands: the keyboard folding away would shift the layout and the tap
	 * would miss.
	 */
	function holdFocus(event: PointerEvent) {
		event.preventDefault();
	}

	/**
	 * Enter moves to the next empty gap, submits from the last one, and —
	 * with the answer on show — goes straight on to the next question.
	 */
	function onKey(event: KeyboardEvent, gap: number) {
		if (event.key !== 'Enter') return;
		if (locked) {
			event.preventDefault();
			if (!event.repeat) skip?.();
			return;
		}
		const nextEmpty = answers.findIndex((a, i) => i !== gap && !a.trim());
		if (nextEmpty >= 0) {
			event.preventDefault();
			inputEls[nextEmpty]?.focus();
			return;
		}
		submit();
	}
</script>

<StreakTracker {streak} {misses} {best} {goal} />

{#if current}
	<section class="card" bind:this={cardEl} use:freshen={current} use:shakeOn={missKey}>
		<Burst trigger={burst} count={burstSize} />

		<!-- The word-help switch sits with the sentence it changes, not away in
		     settings where the Dart build hid it. -->
		<button
			type="button"
			class="word-help"
			aria-pressed={progress.wordHelp}
			title={progress.wordHelp
				? 'Turn word help off'
				: 'Colour the nouns by gender and tap one for its article'}
			onclick={() => progress.setWordHelp(!progress.wordHelp)}
		>
			<Icon name="book" size="1em" />
			<span>Word help</span>
		</button>

		<p class="prompt-label">{current.categoryLabel}</p>
		{#if subject}
			<p class="subject">{subject}</p>
		{/if}

		<!-- The sentence, with a field standing in for each blank. -->
		<p class="sentence" lang={locale}>
			{#each segments as segment, i (i)}<GermanText text={segment} />{#if i < gaps}<span
						class="slot"
						><input
							bind:this={inputEls[i]}
							bind:value={answers[i]}
							onkeydown={(event) => onKey(event, i)}
							readonly={locked}
							class:right={verdict === 'right'}
							class:wrong={verdict === 'wrong'}
							size={fieldSize(i)}
							lang={locale}
							aria-label={gaps > 1 ? `Your answer, gap ${i + 1}` : 'Your answer'}
							enterkeyhint={i < gaps - 1 ? 'next' : 'go'}
							autocomplete="off"
							autocapitalize="off"
							autocorrect="off"
							spellcheck="false"
						/></span
					>{/if}{/each}
			<SpeakButton text={spokenForm} {locale} />
		</p>

		{#if current.english}
			<p class="english">{current.english}</p>
		{/if}

		<!-- One fixed row under the sentence: the hint while answering, the
		     verdict once checked, and the button that does what Enter does —
		     Check, then Next. Same slot, so nothing jumps. -->
		<div class="status-row">
		<p class="status" class:right={verdict === 'right'} class:wrong={verdict === 'wrong'}>
			{#if verdict === 'right'}
				<Icon name="check" size="1.05em" /> Correct
			{:else if verdict === 'wrong'}
				<Icon name="close" size="1.05em" /> The answer is written in
			{:else if current.hint}
				{current.hint}
			{:else}
				&nbsp;
			{/if}
		</p>
		{#if locked}
			<button type="button" class="act next" disabled={!skip} onpointerdown={holdFocus} onclick={() => skip?.()}>
				Next <Icon name="arrowRight" size="1em" />
			</button>
		{:else}
			<button type="button" class="act" disabled={!filled} onpointerdown={holdFocus} onclick={checkTap}>
				Check
			</button>
		{/if}
		</div>
	</section>

{:else}
	<p class="empty">This quiz has no questions yet.</p>
{/if}

<style>
	.card {
		position: relative;
		padding: 1.75rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	/* Quiet until wanted: it is a preference, not part of the exercise. */
	.word-help {
		float: right;
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.25rem 0.6rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: none;
		color: var(--ink-muted);
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.03em;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.word-help[aria-pressed='true'] {
		border-color: var(--accent);
		background: var(--accent-soft);
		color: var(--accent);
	}

	.prompt-label {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent);
	}

	.subject {
		margin: 0.4rem 0 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	/* The sentence is the whole exercise. Leaded wide enough that the inline
	   field never collides with the line above it. */
	.sentence {
		margin: 0.6rem 0 0;
		max-width: none;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-variation-settings: 'opsz' 28;
		font-weight: 600;
		line-height: 2;
		color: var(--ink);
	}

	.slot {
		display: inline-block;
		white-space: nowrap;
	}

	/* The field inherits the sentence's type, so what you write looks like part
	   of the sentence rather than data entered about it. */
	.slot input {
		width: auto;
		padding: 0.05em 0.3em;
		border: 0;
		border-bottom: 2px solid var(--accent);
		border-radius: 5px 5px 0 0;
		background: var(--surface-alt);
		font: inherit;
		font-size: 0.95em;
		color: var(--ink);
		text-align: center;
		transition:
			background var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.slot input:focus {
		outline: none;
		background: var(--accent-soft);
	}

	/* The verdict colours the answer itself. Green is the brand forest, which
	   is the Dart page's kSectionAccentColors[2]. */
	.slot input.right {
		border-bottom-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
		font-weight: 700;
	}

	.slot input.wrong {
		border-bottom-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
		font-weight: 700;
	}

	.english {
		margin: 0.5rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* One fixed row: hint while answering, verdict after. Reserving the space
	   stops the card resizing between the two states. */
	.status-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		margin: 0.9rem 0 0;
	}

	.status {
		display: flex;
		align-items: center;
		gap: 0.42rem;
		min-height: 1.6em;
		margin: 0;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.status.right {
		color: var(--right);
	}

	.status.wrong {
		color: var(--wrong);
	}

	/* Check / Next: what Enter does, for thumbs. Faint until there is
	   something to check, so it never looks like the next step too early. */
	.act {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		flex: none;
		min-height: 2.6rem;
		padding: 0.5rem 1.2rem;
		border: 0;
		border-radius: 999px;
		background: var(--heading);
		color: var(--surface);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 800;
		cursor: pointer;
		transition:
			opacity var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.act:hover:not(:disabled) {
		background: var(--accent);
	}

	.act:disabled {
		opacity: 0.3;
		cursor: default;
	}

	.act.next {
		background: var(--right);
	}

	.empty {
		color: var(--ink-muted);
	}
	@media (max-width: 36rem) {
		.card {
			padding: 1.1rem 1rem 1rem;
		}
		.sentence {
			font-size: var(--step-1);
			line-height: 1.9;
		}
	}
</style>
