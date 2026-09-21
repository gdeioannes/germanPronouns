<script lang="ts">
	// The fill-in-the-blank engine — 96 of the course's 214 exercises, and the
	// only kind with no completion set of its own: reaching the goal streak IS
	// completion (see domain/progress.ts).
	//
	// Ported from lib/widgets/quiz_page.dart, minus the coin/room machinery.
	// Questions are drawn with the shuffle bag so the whole pool is seen once
	// per cycle and the same question never repeats back to back.
	import SpeakButton from '../SpeakButton.svelte';
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
		streak = stats.streak;
		best = stats.bestStreakAbsolute;
		onAnswer(correct);

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
	<div class="streak">
		<span class="label">Streak</span>
		<span class="value">{streak}</span>
		<span class="goal">/ {goal} to finish</span>
	</div>
	<div class="pips" aria-hidden="true">
		{#each { length: STREAK_LAP_SIZE } as _, i (i)}
			<span class="pip" class:lit={i < lapProgress || (streak > 0 && lapProgress === 0)}
			></span>
		{/each}
	</div>
	<span class="best">Best {best}</span>
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
				<button class="primary" onclick={submit} disabled={!answer.trim()}>
					Check
				</button>
			{:else}
				<button class="primary" onclick={next}>Next</button>
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
			<p class="feedback right">Correct</p>
		{:else if verdict === 'wrong'}
			<p class="feedback wrong">
				Not quite — <strong lang={locale}>{revealed}</strong>
				<SpeakButton text={revealed} {locale} />
			</p>
		{/if}
	</section>

	{#if showRelaxedHint}
		<aside class="relaxed">
			<p>
				That was right apart from an accent or umlaut. Turn on
				<strong>relaxed correction</strong> and answers like that will count.
			</p>
			<div>
				<button
					class="primary"
					onclick={async () => {
						await progress.setRelaxedCorrection(true);
						showRelaxedHint = false;
					}}
				>
					Turn it on
				</button>
				<button class="link" onclick={() => (showRelaxedHint = false)}>
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
		gap: 1rem;
		padding: 0.75rem 1rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: 12px;
		background: var(--surface-alt);
	}

	.streak {
		display: flex;
		align-items: baseline;
		gap: 0.4rem;
	}

	.label {
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--muted);
	}

	.value {
		font-size: 1.4rem;
		font-weight: 800;
		color: var(--ink);
	}

	.goal,
	.best {
		font-size: 0.8rem;
		color: var(--muted);
	}

	.best {
		margin-left: auto;
	}

	.pips {
		display: flex;
		gap: 0.25rem;
	}

	.pip {
		width: 0.5rem;
		height: 0.5rem;
		border-radius: 50%;
		background: var(--line);
	}

	.pip.lit {
		background: var(--accent);
	}

	.card {
		padding: 1.5rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
	}

	.prompt-label {
		margin: 0;
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent);
	}

	.subject {
		margin: 0.35rem 0 0;
		font-size: 1.1rem;
		font-weight: 700;
		color: var(--ink);
	}

	.sentence {
		margin: 0.6rem 0 0;
		font-size: 1.3rem;
		line-height: 1.5;
	}

	.english {
		margin: 0.4rem 0 0;
		color: var(--muted);
	}

	.answer-row {
		display: flex;
		gap: 0.6rem;
		margin-top: 1.25rem;
	}

	input {
		flex: 1;
		padding: 0.65rem 0.85rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--bg);
		font: inherit;
		font-size: 1.05rem;
	}

	input:focus {
		outline: 2px solid var(--accent);
		outline-offset: 1px;
	}

	.hint {
		margin: 0.6rem 0 0;
		font-size: 0.88rem;
		color: var(--muted);
	}

	.feedback {
		margin: 0.85rem 0 0;
		font-weight: 700;
	}

	.feedback.right {
		color: #3f7d4e;
	}

	.feedback.wrong {
		color: #b4452f;
	}

	.relaxed {
		margin-top: 1rem;
		padding: 1rem;
		border: 1px solid var(--accent);
		border-radius: 12px;
		background: var(--surface-alt);
	}

	.relaxed p {
		margin: 0 0 0.75rem;
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

	.link {
		margin-left: 0.5rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--muted);
		font: inherit;
		cursor: pointer;
		text-decoration: underline;
	}

	.empty {
		color: var(--muted);
	}
</style>
