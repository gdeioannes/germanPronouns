<script lang="ts">
	// Reading and listening share a shape: a passage plus multiple-choice
	// questions. The only difference is whether the passage is shown or heard —
	// so one component takes a `mode`, mirroring how the Dart pages differed
	// only in presentation.
	//
	// It runs as sections that each fit the screen (see Steps): the passage in
	// pages, then one question per section, then the check. Picking an answer
	// moves on by itself, so a run is tap, tap, tap, check.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import Sheet from '../Sheet.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import Steps, { type StepMark } from './Steps.svelte';
	import { pop, rise } from '$lib/motion';
	import { PAGE_BUDGET, paginate } from '$lib/domain/paginate';
	import { fitOnResize, fitPages, type PageFit } from './fit';
	import { untrack } from 'svelte';
	import { tts } from '$lib/services/speech';
	import { spokenPassage } from '$lib/domain/spoken';
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

	/**
	 * The options of each question in the order shown. Authored keys sit at
	 * index 0 or 1 far more often than not, so the order is shuffled — with a
	 * seed from the quiz id and question number, so the prerendered page and
	 * the hydrated one agree, and a learner retrying sees the same order.
	 */
	const shown = $derived(
		quiz.questions.map((question, qi) => {
			const order = question.options.map((_, i) => i);
			let seed = hash(`${quiz.id}#${qi}`);
			for (let i = order.length - 1; i > 0; i--) {
				seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0;
				const j = seed % (i + 1);
				[order[i], order[j]] = [order[j], order[i]];
			}
			return {
				options: order.map((i) => question.options[i]),
				translations: question.optionsTranslation
					? order.map((i) => question.optionsTranslation![i])
					: undefined,
				correct: order.indexOf(question.correctIndex)
			};
		})
	);

	function hash(text: string): number {
		let h = 2166136261;
		for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 16777619);
		return h >>> 0;
	}

	/** What the audio reads: the passage without its speaker labels. */
	const spoken = $derived(spokenPassage(quiz.passage));

	/** Chosen SHOWN option index per question, or null while unanswered. */
	let chosen = $state<(number | null)[]>([]);
	let checked = $state(false);
	let showTranslation = $state(false);
	/**
	 * The English under each question and option. Off by default: it doubles
	 * a question's height, and the point is to read the German. Kept in the
	 * page (hidden by CSS), so it is still in the prerendered HTML.
	 */
	let english = $state(false);
	let index = $state(0);
	let advance: ReturnType<typeof setTimeout> | undefined;

	// Reset when the component is reused for a different quiz — the answer
	// array must match the new question count, not the old one's.
	$effect(() => {
		quiz.id;
		retry();
		return () => clearTimeout(advance);
	});

	/** Characters per text page — measured to fit this screen (see fit.ts). */
	let fit = $state<PageFit>({ budget: PAGE_BUDGET, lineWidth: 0 });
	/** The passage as screen-sized pages. */
	const pages = $derived(paginate(quiz.passage, fit.budget, fit.lineWidth || undefined));
	/** Listening hides the transcript until the answers are checked. */
	const transcript = $derived(mode === 'read' || checked);
	// The order of sections:
	//   reading    text pages · questions · check
	//   listening  listen · questions · check · (once checked) transcript pages
	// The transcript comes after the check, so revealing it moves nothing.
	/** Sections before the first question: the pages, or the one "listen" screen. */
	const lead = $derived(mode === 'read' ? pages.length : 1);
	const questionCount = $derived(quiz.questions.length);
	const checkIndex = $derived(lead + questionCount);
	const tail = $derived(mode === 'listen' && checked ? pages.length : 0);
	const count = $derived(checkIndex + 1 + tail);

	/** The text page section `i` shows, or -1 when it shows none. */
	function pageAt(i: number): number {
		if (mode === 'read') return i < lead ? i : -1;
		return i > checkIndex ? i - checkIndex - 1 : -1;
	}

	const labels = $derived(
		Array.from({ length: count }, (_, i) => {
			const page = pageAt(i);
			if (page >= 0) return pages.length > 1 ? `Text ${page + 1}` : 'Text';
			if (i < lead) return 'Listen';
			if (i < checkIndex) return `Question ${i - lead + 1}`;
			return 'Check';
		})
	);

	const marks = $derived<StepMark[]>(
		Array.from({ length: count }, (_, i) => {
			if (i < lead || i >= checkIndex) return null;
			const qi = i - lead;
			const skipped = chosen[qi] === null || chosen[qi] === undefined;
			if (!checked) return skipped ? null : 'done';
			if (skipped) return 'wrong';
			return chosen[qi] === shown[qi].correct ? 'right' : 'wrong';
		})
	);

	// Re-paging (a resize) changes how many text pages lead the questions;
	// keep the learner on the same question rather than a shifted one.
	let seenLead = -1;
	$effect(() => {
		const now = lead;
		untrack(() => {
			if (seenLead >= 0 && now !== seenLead) {
				if (index >= seenLead) index += now - seenLead;
				else index = Math.min(index, now - 1);
			}
			seenLead = now;
		});
	});

	let root = $state<HTMLElement>();
	$effect(() => {
		if (!root || !transcript) return;
		quiz.id;
		const el = root;
		return fitOnResize(() =>
			fitPages(el, '.text', (f) => (fit = f))
		);
	});

	const answeredCount = $derived(chosen.filter((c) => c !== null).length);
	const answered = $derived(answeredCount === questionCount);
	const correctCount = $derived(
		quiz.questions.reduce(
			(n, _question, i) => n + (chosen[i] === shown[i].correct ? 1 : 0),
			0
		)
	);
	// The pass bar the Dart pages used: at least two thirds right.
	const passed = $derived(correctCount / questionCount >= 2 / 3);

	function choose(questionIndex: number, optionIndex: number) {
		if (checked) return;
		chosen[questionIndex] = optionIndex;
		// Long enough to see the choice land, short enough to keep the rhythm.
		clearTimeout(advance);
		advance = setTimeout(() => {
			if (index === lead + questionIndex) index += 1;
		}, 700);
	}

	function check() {
		checked = true;
		onFinish(passed, correctCount, questionCount);
	}

	function retry() {
		chosen = quiz.questions.map(() => null);
		checked = false;
		index = 0;
	}
</script>

<div class="reading-fit" bind:this={root}>
<Steps {count} bind:index {labels} {marks}>
	{#snippet step(i)}
		{#if pageAt(i) >= 0 || i < lead}
			{@const page = pageAt(i)}
			<article class="passage" class:pictured={quiz.image && (mode !== 'read' ? page < 0 : page === 0)}>
				{#if quiz.image && page === 0 && mode === 'read'}
					<!-- The scene sets the stage for the text; the page budget is
					     measured below it (fit.ts), so the passage still fits. -->
					<img class="scene banner" src="/img/{quiz.image}.webp" alt="" width="1024" height="768" />
				{/if}
				<header>
					<h2>{quiz.passageTitle}</h2>
					<SpeakButton text={spoken} {locale} label="Play the passage" />
					{#if transcript && quiz.passageTranslation}
						<button type="button" class="reading-chip" onclick={() => (showTranslation = true)}>
							Translation
						</button>
					{/if}
				</header>

				{#if page >= 0}
					<p class="text" lang={locale}>{pages[page]}</p>
					{#if page < pages.length - 1}
						<p class="more">Continues on the next page <Icon name="arrowRight" size="0.95em" /></p>
					{/if}
				{:else}
					<div class="listen">
						{#if quiz.image}
							<!-- Listening against a picture, as in a real test: the scene
							     gives the situation, the audio gives the words. -->
							<img class="scene" src="/img/{quiz.image}.webp" alt="" width="1024" height="768" />
						{:else}
							<span class="listen-icon"><Icon name="headphones" size="2em" /></span>
						{/if}
						<div class="transport">
							<button type="button" class="btn" onclick={() => tts.speak(spoken, { locale })}>
								<Icon name="play" size="1em" /> Play
							</button>
							<button type="button" class="btn btn-ghost" onclick={() => tts.speak(spoken, { locale, rate: 0.75 })}>
								<Icon name="slow" size="1em" /> Slower
							</button>
						</div>
						<p class="hidden-note">
							Press play and listen as many times as you like — the transcript appears
							once you check your answers.
						</p>
						<button type="button" class="btn-quiet to-questions" onclick={() => (index = 1)}>
							To the questions <Icon name="arrowRight" size="1em" />
						</button>
					</div>
				{/if}
			</article>
		{:else if i < lead + questionCount}
			{@const qi = i - lead}
			{@const question = quiz.questions[qi]}
			{@const answer = chosen[qi]}
			<div class="question" class:en={english}>
				<div class="q-top">
					<p class="q-count eyebrow tnum">Question {qi + 1} of {questionCount}</p>
					{#if question.questionTranslation || shown[qi].translations}
						<button type="button" class="reading-chip" aria-pressed={english} onclick={() => (english = !english)}>
							{english ? 'Hide English' : 'Show English'}
						</button>
					{/if}
				</div>
				<p class="q" lang={locale}>
					{question.question}
					<SpeakButton text={question.question} {locale} />
				</p>
				{#if question.questionTranslation}
					<p class="q-translation">{question.questionTranslation}</p>
				{/if}

				<div class="options">
					{#each shown[qi].options as option, oi (option)}
						{@const isChosen = answer === oi}
						{@const isCorrect = oi === shown[qi].correct}
						<button
							class="option"
							class:chosen={isChosen}
							class:correct={checked && isCorrect}
							class:wrong={checked && isChosen && !isCorrect}
							class:spent={checked && !isChosen && !isCorrect}
							disabled={checked}
							onclick={() => choose(qi, oi)}
						>
							<span class="marker" aria-hidden="true">
								{#if checked && isCorrect}
									<Icon name="check" size="0.95em" />
								{:else if checked && isChosen}
									<Icon name="close" size="0.95em" />
								{:else}
									{String.fromCharCode(65 + oi)}
								{/if}
							</span>
							<span class="option-text">
								<span lang={locale}>{option}</span>
								{#if shown[qi].translations?.[oi]}
									<small>{shown[qi].translations[oi]}</small>
								{/if}
							</span>
						</button>
					{/each}
				</div>

				{#if checked && question.explanation}
					<p class="explanation" in:rise={{ delay: 80 }}>
						<Icon name="info" size="1em" />
						<span>{question.explanation}</span>
					</p>
				{/if}
			</div>
		{:else}
			<div class="reading-check">
				{#if checked}
					<Burst trigger={passed ? 1 : 0} count={26} />
					<p class="reading-verdict" class:pass={passed} in:pop={{ from: 0.9 }}>
						<Icon name={passed ? 'trophy' : 'close'} size="1.3em" />
						<span class="tnum">{correctCount} of {questionCount} correct</span>
					</p>
					<p class="reading-sub">
						{passed ? 'Passed — well done.' : 'Not quite yet: two thirds right passes.'}
						Go back through the questions to see why each answer is right.
					</p>
					{#if mode === 'listen'}
						<button type="button" class="btn btn-ghost" onclick={() => (index = checkIndex + 1)}>
							<Icon name="book" size="1em" /> Read the transcript
						</button>
					{/if}
					{#if !passed}
						<button class="btn" onclick={retry}>
							<Icon name="repeat" size="1em" /> Try again
						</button>
					{/if}
				{:else}
					<p class="reading-verdict tnum neutral">{answeredCount} of {questionCount} answered</p>
					<div class="jump">
						{#each quiz.questions as _, qi (qi)}
							<button
								type="button"
								class="jump-to tnum"
								class:done={chosen[qi] !== null}
								onclick={() => (index = lead + qi)}
								aria-label="Question {qi + 1}{chosen[qi] === null ? ', unanswered' : ''}"
							>{qi + 1}</button>
						{/each}
					</div>
					<!-- Checkable at any point: a skipped question counts as wrong. -->
					<button class="btn" onclick={check}>
						<Icon name="check" size="1em" /> Check answers
					</button>
					{#if !answered}
						<p class="reading-sub">Unanswered questions count as wrong.</p>
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
		display: flex;
		flex-direction: column;
		padding: 1.25rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.passage header {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.6rem;
		margin-bottom: 0.85rem;
	}

	.passage h2 {
		margin: 0;
		font-size: var(--step-1);
	}

	/* A page that shows the scene takes the scene's own cream, so the picture
	   sits on the card without an edge (its paper is levelled to exactly this
	   colour by tool/gen-images.mjs). */
	.passage.pictured {
		background: #fbf5e4;
	}

	.scene {
		display: block;
		width: min(100%, 26rem);
		height: auto;
		margin: 0 auto 0.6rem;
		object-fit: cover;
		user-select: none;
		-webkit-user-drag: none;
	}

	.scene.banner {
		width: min(100%, 22rem);
		max-height: min(11rem, 24dvh);
		margin: -0.25rem auto 0.8rem;
	}

	.listen .scene {
		max-height: min(16rem, 34dvh);
		margin-bottom: 1rem;
	}

	/* A reading passage is long-form: serif, generous leading, and a measure
	   capped so the eye can find the next line. */
	.text {
		margin: 0;
		max-width: var(--measure);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-variation-settings: 'opsz' 16;
		line-height: 1.7;
		color: var(--ink);
		white-space: pre-wrap;
	}

	.more {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		margin: auto 0 0;
		padding-top: 0.9rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.listen {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 1rem;
		text-align: center;
	}

	.listen-icon {
		display: inline-flex;
		padding: 1rem;
		border-radius: 50%;
		background: #e8efe9;
		color: var(--forest);
	}

	.transport {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.6rem;
	}

	.to-questions {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		font-weight: 700;
	}

	.hidden-note {
		max-width: var(--measure);
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* A question gets the screen to itself, centred when it is short. */
	.question {
		margin: auto 0;
		padding: 0.25rem 0.1rem;
	}

	.q-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.6rem;
		margin: 0 0 0.5rem;
	}

	.q-count {
		margin: 0;
	}

	.question:not(.en) .q-translation,
	.question:not(.en) .option small {
		display: none;
	}

	.question:not(.en) .q {
		margin-bottom: 0;
	}

	.q {
		margin: 0 0 0.15rem;
		max-width: none;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 600;
		line-height: 1.3;
		color: var(--heading);
	}

	.q-translation {
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.options {
		display: grid;
		gap: 0.5rem;
		margin-top: 1rem;
	}

	.option {
		display: flex;
		align-items: flex-start;
		gap: 0.7rem;
		padding: 0.75rem 0.95rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.option:hover:not(:disabled) {
		border-color: var(--accent);
		transform: translateX(2px);
	}

	/* A/B/C in a circle, swapped for a tick or cross once checked — so the
	   verdict lands where the eye already is. */
	.marker {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.55em;
		height: 1.55em;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
		font-size: var(--step--1);
		font-weight: 700;
	}

	.option-text {
		display: flex;
		flex-direction: column;
		gap: 0.08rem;
	}

	.option.chosen {
		border-color: var(--navy);
		background: var(--surface-alt);
	}

	.option.chosen .marker {
		background: var(--navy);
		color: #fff;
	}

	.option.correct {
		border-color: var(--right);
		background: var(--right-bg);
	}

	.option.correct .marker {
		background: var(--right);
		color: #fff;
	}

	.option.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
	}

	.option.wrong .marker {
		background: var(--wrong);
		color: #fff;
	}

	.option small {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	/* Checked answers are locked, not faded: they are what the review reads. */
	.option:disabled {
		color: var(--ink);
		opacity: 1;
		cursor: default;
	}

	/* Once checked, the review needs only what was picked and what was right
	   — the rest steps aside to leave room for the explanation. */
	.option.spent {
		display: none;
	}

	.explanation {
		display: flex;
		align-items: flex-start;
		gap: 0.45rem;
		margin: 0.75rem 0 0;
		padding-left: 0.2rem;
		max-width: var(--measure);
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.jump {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.45rem;
	}

	.jump-to {
		width: 2.4rem;
		height: 2.4rem;
		border: 1px dashed var(--line-strong);
		border-radius: 50%;
		background: var(--surface);
		color: var(--ink-muted);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	.jump-to.done {
		border: 1px solid var(--navy);
		background: var(--navy);
		color: #fff;
	}

	@media (max-width: 36rem) {
		.passage {
			padding: 1rem 1.05rem;
		}
		.text {
			font-size: var(--step-0);
			line-height: 1.65;
		}
		.q {
			font-size: var(--step-1);
		}
		.option {
			padding: 0.6rem 0.75rem;
			line-height: 1.4;
		}
		.options {
			margin-top: 0.8rem;
			gap: 0.4rem;
		}
	}
</style>
