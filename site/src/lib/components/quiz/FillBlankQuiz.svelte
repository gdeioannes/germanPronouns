<script lang="ts">
	// The fill-in-the-blank engine — 96 of the course's 214 exercises, and the
	// only kind with no completion set of its own: reaching the goal streak IS
	// completion (see domain/progress.ts).
	//
	// Ported from lib/widgets/quiz_page.dart, minus the coin/room machinery.
	// Questions are drawn with the shuffle bag so the whole pool is seen once
	// per cycle and the same question never repeats back to back.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { pop, rise } from '$lib/motion';
	import { acceptedViaRelaxedOnly, isAcceptedAnswer } from '$lib/domain/answers';
	import { drawFromShuffleBag } from '$lib/domain/shuffleBag';
	import { STREAK_LAP_SIZE, progressionUnlockStreak } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
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
	 * The question pool. An authored bank is used as-is; a template-driven
	 * quiz expands `{subject}` across its categories, which is how the
	 * generated quizzes (numbers, conjugation tables) produce their items.
	 */
	function buildPool(): QuizSentence[] {
		if (quiz.sentences?.length) return quiz.sentences;

		const generated: QuizSentence[] = [];
		for (const category of quiz.categories ?? []) {
			const templates = quiz.sentenceTemplates?.[category.label] ?? ['{subject} = ____'];
			for (const subject of quiz.subjects ?? []) {
				const index = quiz.subjects.indexOf(subject);
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
	let verdict = $state<'none' | 'right' | 'wrong'>('none');
	let revealed = $state('');
	let streak = $state(0);
	let best = $state(0);
	let showRelaxedHint = $state(false);
	let inputEl = $state<HTMLInputElement | null>(null);
	/** Bumped to fire a celebration; bigger when a lap completes. */
	let burst = $state(0);
	let burstSize = $state(14);

	const subjectFor = $derived((sentence: QuizSentence) =>
		quiz.subjects?.find((s) => s.key === sentence.subjectKey)
	);

	/** The sentence with its blank filled, so audio reads a natural sentence. */
	const spokenForm = $derived(
		current
			? current.sentence.replace(/_{4,}/, current.acceptedAnswers[0] ?? '')
			: ''
	);

	function next() {
		if (pool.length === 0) return;
		current = drawFromShuffleBag(bag, pool, { avoidRepeat: current });
		answer = '';
		verdict = 'none';
		revealed = '';
		inputEl?.focus();
	}

	$effect(() => {
		if (!current) next();
	});

	// Load the persisted streak once so a returning learner resumes their run.
	$effect(() => {
		(async () => {
			const stats = await progress.statsFor(quiz.storageKeyPrefix);
			streak = stats.streak;
			best = stats.bestStreakAbsolute;
		})();
	});

	async function submit() {
		if (!current || verdict !== 'none' || !answer.trim()) return;

		const correct = isAcceptedAnswer(
			answer,
			current.acceptedAnswers,
			progress.relaxedCorrection
		);

		// A near miss that only an umlaut separated: offer the setting once,
		// rather than letting the learner think they were simply wrong.
		if (
			!correct &&
			!progress.relaxedCorrection &&
			acceptedViaRelaxedOnly(answer, current.acceptedAnswers)
		) {
			showRelaxedHint = true;
		}

		verdict = correct ? 'right' : 'wrong';
		if (!correct) revealed = current.acceptedAnswers[0] ?? '';

		const stats = await progress.recordAnswer(quiz.storageKeyPrefix, correct);
		const lapCompleted = correct && stats.streak > 0 && stats.streak % STREAK_LAP_SIZE === 0;
		streak = stats.streak;
		best = stats.bestStreakAbsolute;
		onAnswer(correct);

		// Every right answer gets a small spark; completing a lap of five earns
		// a full burst — the same escalation the Flutter app's fireworks had.
		if (correct) {
			burstSize = lapCompleted ? 30 : 12;
			burst += 1;
		}

		// Crossing the goal streak completes the quiz and unlocks the next.
		if (correct && stats.streak === goal) onGoalReached();
	}

	function onKey(event: KeyboardEvent) {
		if (event.key !== 'Enter') return;
		if (verdict === 'none') submit();
		else next();
	}

	const lapProgress = $derived(streak % STREAK_LAP_SIZE);
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
	{@const subject = subjectFor(current)}
	<section class="card">
		<p class="prompt-label">{current.categoryLabel}</p>
		{#if subject && subject.display !== current.sentence}
			<p class="subject">{subject.display}</p>
		{/if}

		<p class="sentence" lang={locale}>
			{current.sentence}
			<SpeakButton text={spokenForm} {locale} />
		</p>

		{#if current.english}
			<p class="english">{current.english}</p>
		{/if}

		<div class="answer-row">
			<Burst trigger={burst} count={burstSize} />
			<!-- svelte-ignore a11y_autofocus -->
			<input
				bind:this={inputEl}
				bind:value={answer}
				onkeydown={onKey}
				disabled={verdict !== 'none'}
				placeholder="Your answer"
				lang={locale}
				autocomplete="off"
				autocapitalize="off"
				spellcheck="false"
				autofocus
			/>
			{#if verdict === 'none'}
				<button class="btn" onclick={submit} disabled={!answer.trim()}>
					<Icon name="check" size="1em" /> Check
				</button>
			{:else}
				<button class="btn" onclick={next}>
					Next <Icon name="arrowRight" size="1em" />
				</button>
			{/if}
		</div>

		{#if progress.showFirstLetterHint && verdict === 'none'}
			<p class="hint">
				Starts with “{(current.acceptedAnswers[0] ?? '').charAt(0)}”
			</p>
		{:else if current.hint && verdict === 'none'}
			<p class="hint">{current.hint}</p>
		{/if}

		{#if verdict === 'right'}
			<p class="feedback right" in:pop={{ from: 0.86 }}>
				<Icon name="check" size="1.05em" /> Correct
			</p>
		{:else if verdict === 'wrong'}
			<p class="feedback wrong" in:rise>
				<Icon name="close" size="1.05em" />
				<span>Not quite — <strong lang={locale}>{revealed}</strong></span>
				<SpeakButton text={revealed} {locale} />
			</p>
		{/if}
	</section>

	{#if showRelaxedHint}
		<aside class="relaxed" in:rise>
			<p>
				That was right apart from an accent or umlaut. Turn on
				<strong>relaxed correction</strong> and answers like that will count.
			</p>
			<div>
				<button
					class="btn"
					onclick={async () => {
						await progress.setRelaxedCorrection(true);
						showRelaxedHint = false;
					}}
				>
					Turn it on
				</button>
				<button class="btn-quiet" onclick={() => (showRelaxedHint = false)}>
					No thanks
				</button>
			</div>
		</aside>
	{/if}
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
		0%, 100% { transform: scale(1) rotate(-1deg); }
		50% { transform: scale(1.09) rotate(1.5deg); }
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
		/* Tabular numerals keep the row from jittering as the count climbs. */
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

	/* The question itself: the largest thing on the card, set in the serif so
	   the German reads as content rather than interface. */
	.sentence {
		margin: 0.5rem 0 0;
		max-width: none;
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-variation-settings: 'opsz' 28;
		font-weight: 600;
		line-height: 1.45;
		color: var(--ink);
		text-wrap: pretty;
	}

	.english {
		margin: 0.45rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.answer-row {
		position: relative;
		display: flex;
		gap: 0.6rem;
		margin-top: 1.4rem;
	}

	input {
		flex: 1;
		min-width: 0;
		padding: 0.68rem 0.9rem;
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

	.hint {
		margin: 0.65rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.feedback {
		display: flex;
		align-items: center;
		gap: 0.45rem;
		margin: 0.9rem 0 0;
		font-weight: 700;
	}

	.feedback.right {
		color: var(--right);
	}

	.feedback.wrong {
		color: var(--wrong);
	}

	.feedback strong {
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 1.08em;
	}

	.relaxed {
		margin-top: 1rem;
		padding: 1.1rem 1.25rem;
		border: 1px solid var(--accent);
		border-radius: var(--radius);
		background: var(--accent-soft);
	}

	.relaxed p {
		margin: 0 0 0.85rem;
	}

	.empty {
		color: var(--ink-muted);
	}
</style>
