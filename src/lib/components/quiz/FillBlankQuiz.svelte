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
	import { isAcceptedAnswer, normalizeAnswer } from '$lib/domain/answers';
	import { drawFromShuffleBag } from '$lib/domain/shuffleBag';
	import { STREAK_LAP_SIZE, progressionUnlockStreak } from '$lib/domain/progress';
	import { REVEAL_PAUSE, progress } from '$lib/state/progress.svelte';
	import { prefersReducedMotion } from '$lib/motion';
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

	/**
	 * The question pool. An authored bank is used as-is; a template-driven quiz
	 * expands `{subject}` across its categories, which is how the generated
	 * quizzes (numbers, conjugation tables) produce their items.
	 */
	function buildPool(): QuizSentence[] {
		if (quiz.sentences?.length) return quiz.sentences;

		const generated: QuizSentence[] = [];
		for (const category of quiz.categories ?? []) {
			const templates = quiz.sentenceTemplates?.[category.label] ?? ['{subject} = ____'];
			for (const [index, subject] of (quiz.subjects ?? []).entries()) {
				const answer = category.values[index];
				if (answer === undefined) continue;
				for (const template of templates) {
					generated.push({
						subjectKey: subject.key,
						categoryLabel: category.label,
						sentence: template.replace('{subject}', subject.display),
						acceptedAnswers: [answer]
					});
				}
			}
		}
		return generated;
	}

	const pool = buildPool();
	const bag: QuizSentence[] = [];
	const goal = $derived(progressionUnlockStreak(progress.gating));

	let current = $state<QuizSentence | undefined>(undefined);
	let answer = $state('');
	/** null while answering; then how it went, which colours the field. */
	let verdict = $state<'right' | 'wrong' | null>(null);
	let streak = $state(0);
	let best = $state(0);
	let inputEl = $state<HTMLInputElement | null>(null);
	let burst = $state(0);
	let burstSize = $state(12);
	/** Pending reveal/advance timers, cancelled if the component goes away. */
	let timers: ReturnType<typeof setTimeout>[] = [];

	const locked = $derived(verdict !== null);
	const lapProgress = $derived(streak % STREAK_LAP_SIZE);

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

	/** The sentence split around its blank, so the field can sit in the gap. */
	const parts = $derived.by(() => {
		const text = current?.sentence ?? '';
		const match = /_{4,}/.exec(text);
		if (!match) return { before: text, after: '' };
		return {
			before: text.slice(0, match.index),
			after: text.slice(match.index + match[0].length)
		};
	});

	/** The sentence with its blank filled, so audio reads a natural sentence. */
	const spokenForm = $derived(
		current ? current.sentence.replace(/_{4,}/, current.acceptedAnswers[0] ?? '') : ''
	);

	/** Grows the field to fit either the typing or the answer being revealed. */
	const fieldSize = $derived(
		Math.max(answer.length + 1, (current?.acceptedAnswers[0] ?? '').length, 6)
	);

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
		answer = progress.showFirstLetterHint
			? (current.acceptedAnswers[0] ?? '').charAt(0)
			: '';
		verdict = null;
		inputEl?.focus();
	}

	$effect(() => {
		if (!current) next();
		return clearTimers;
	});

	// Load the persisted streak so a returning learner resumes their run.
	$effect(() => {
		(async () => {
			const stats = await progress.statsFor(quiz.storageKeyPrefix);
			streak = stats.streak;
			best = stats.bestStreakAbsolute;
		})();
	});

	/**
	 * Types `text` into the field one letter at a time, as the Dart page did —
	 * 70ms a character. Slow enough to read as a correction being written,
	 * fast enough not to be a wait.
	 */
	async function typeOut(text: string) {
		if (prefersReducedMotion()) {
			answer = text;
			return;
		}
		for (let i = 1; i <= text.length; i++) {
			await wait(70);
			answer = text.slice(0, i);
		}
	}

	async function submit() {
		if (!current || locked || !answer.trim()) return;

		const accepted = current.acceptedAnswers;
		const typed = answer;
		const correct = isAcceptedAnswer(typed, accepted, progress.relaxedCorrection);

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
		const canonical =
			accepted.find(
				(a) =>
					normalizeAnswer(a, progress.relaxedCorrection) ===
					normalizeAnswer(typed, progress.relaxedCorrection)
			) ??
			accepted[0] ??
			'';

		answer = '';
		await typeOut(canonical);
		await wait(REVEAL_PAUSE[progress.answerRevealMode]);
		next();
	}

	function onKey(event: KeyboardEvent) {
		if (event.key === 'Enter') submit();
	}
</script>

<section class="tracker">
	<span class="flame" class:hot={streak > 0}><Icon name="flame" size="1.1em" /></span>
	<div class="streak">
		<span class="eyebrow">Streak</span>
		<span class="value tnum">{streak}</span>
		<span class="goal tnum">/ {goal}</span>
	</div>
	<div class="pips" aria-hidden="true">
		{#each { length: STREAK_LAP_SIZE } as _, i (i)}
			<span class="pip" class:lit={i < lapProgress || (streak > 0 && lapProgress === 0)}
			></span>
		{/each}
	</div>
	<span class="best tnum">Best {best}</span>
</section>

{#if current}
	<section class="card">
		<Burst trigger={burst} count={burstSize} />

		<p class="prompt-label">{current.categoryLabel}</p>
		{#if subject}
			<p class="subject">{subject}</p>
		{/if}

		<!-- The sentence, with the field standing in for its blank. -->
		<p class="sentence" lang={locale}>
			{parts.before}<span class="slot"
				><input
					bind:this={inputEl}
					bind:value={answer}
					onkeydown={onKey}
					readonly={locked}
					class:right={verdict === 'right'}
					class:wrong={verdict === 'wrong'}
					size={fieldSize}
					lang={locale}
					aria-label="Your answer"
					autocomplete="off"
					autocapitalize="off"
					autocorrect="off"
					spellcheck="false"
				/></span
			>{parts.after}
			<SpeakButton text={spokenForm} {locale} />
		</p>

		{#if current.english}
			<p class="english">{current.english}</p>
		{/if}

		<!-- One fixed row under the sentence: the hint while answering, the
		     verdict once checked. Same slot, so nothing jumps. -->
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
	</section>

{:else}
	<p class="empty">This quiz has no questions yet.</p>
{/if}

<style>
	.tracker {
		display: flex;
		align-items: center;
		gap: 0.85rem;
		padding: 0.7rem 1rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.flame {
		display: inline-flex;
		color: var(--outline);
		transition: color var(--medium) var(--ease-out);
	}

	.flame.hot {
		color: var(--accent);
		animation: flicker 2.4s ease-in-out infinite;
	}

	@keyframes flicker {
		0%,
		100% {
			transform: scale(1) rotate(-1deg);
		}
		50% {
			transform: scale(1.09) rotate(1.5deg);
		}
	}

	.streak {
		display: flex;
		align-items: baseline;
		gap: 0.35rem;
	}

	.streak .eyebrow {
		font-size: 0.66rem;
	}

	.value {
		font-size: var(--step-2);
		font-weight: 800;
		line-height: 1;
		color: var(--heading);
		font-variant-numeric: tabular-nums;
	}

	.goal,
	.best {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.best {
		margin-left: auto;
	}

	.pips {
		display: flex;
		gap: 0.28rem;
	}

	.pip {
		width: 0.46rem;
		height: 0.46rem;
		border-radius: 50%;
		background: var(--outline);
		transition:
			background var(--medium) var(--ease-spring),
			transform var(--medium) var(--ease-spring);
	}

	.pip.lit {
		background: var(--accent);
		transform: scale(1.25);
	}

	.card {
		position: relative;
		padding: 1.75rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
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
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	/* The sentence is the whole exercise. Leaded wide enough that the inline
	   field never collides with the line above it. */
	.sentence {
		margin: 0.6rem 0 0;
		max-width: none;
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
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
	.status {
		display: flex;
		align-items: center;
		gap: 0.42rem;
		min-height: 1.6em;
		margin: 0.9rem 0 0;
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

	.empty {
		color: var(--ink-muted);
	}
</style>
