<script lang="ts">
	// Dictation: hear a line, type what you heard. The text is never shown
	// until the line is answered or given up on — that is the whole exercise.
	//
	// Played in runs of RUN_LENGTH lines, like the fill-in and the flashcards:
	// the same chevron bar above, the same streak and medals across runs and
	// visits, the same end-of-run card. Lines come from the shuffle bag, so a
	// quiz with more lines than a run hands out a different ten each time, and
	// a line that went wrong comes back round inside the same run.
	//
	// The check is graded, not pass/fail: the typed line is aligned against
	// the real one word by word (see domain/dictation.ts). Word for word is
	// perfect; a dropped umlaut or a typo is "nearly" and still counts right;
	// half the words is "half of it" and counts as a miss, with the words to
	// listen for again marked in the line. One missing comma no longer wipes
	// out an otherwise heard sentence.
	import Burst from '../Burst.svelte';
	import { inDialog } from './keys';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import GermanText from '../GermanText.svelte';
	import RunSummary from './RunSummary.svelte';
	import RunTracker from './RunTracker.svelte';
	import { freshen, pop, rise } from '$lib/motion';
	import { celebrateMedal, react, shakeOn } from '$lib/motion/fx.svelte';
	import { BAND_LABELS, bandNote, gradeDictation, type DictationGrade } from '$lib/domain/dictation';
	import {
		medalAnnouncement,
		RUN_LENGTH,
		runPassed,
		STREAK_LAP_SIZE,
		type RibbonTier
	} from '$lib/domain/progress';
	import { drawFromShuffleBag } from '$lib/domain/shuffleBag';
	import { progress } from '$lib/state/progress.svelte';
	import { clearSpot, loadSpot, saveSpot } from '$lib/state/resume';
	import { tts } from '$lib/services/speech';
	import { announce } from '$lib/a11y.svelte';
	import { untrack } from 'svelte';
	import type { DictationQuiz, SpokenLine } from '$lib/content/types';

	let {
		quiz,
		locale,
		onRunFinished
	}: {
		quiz: DictationQuiz;
		locale: string;
		/** A run of RUN_LENGTH lines is over — the exercise counts as done. */
		onRunFinished: (passed: boolean) => void;
	} = $props();

	/** Where this run saves its place, so leaving mid-run costs nothing. */
	type Spot = { results: ('right' | 'wrong')[]; bestInRun: number };

	let pool: readonly SpokenLine[] = untrack(() => quiz.items);
	/** The bag the run draws from, and the lines to come back to. */
	let bag: SpokenLine[] = [];
	let retry: SpokenLine[] = [];
	let sinceRetry = 0;

	// Raw, not deep state: the shuffle bag compares by identity, and a proxy
	// never equals the item the pool holds.
	let item = $state.raw<SpokenLine | undefined>(untrack(() => quiz.items[0]));
	let answer = $state('');
	/** null while typing; then how the line was graded. */
	let grade = $state<DictationGrade | null>(null);
	let streak = $state(0);
	let best = $state(0);
	// The run: lines answered (the bar), the longest streak inside it, the
	// medal it crossed into, and the lines that went wrong.
	let results = $state<('right' | 'wrong')[]>([]);
	const answered = $derived(results.length);
	const right = $derived(results.filter((r) => r === 'right').length);
	let bestInRun = $state(0);
	let earned = $state<RibbonTier | null>(null);
	let missed = $state<string[]>([]);
	let runDone = $state(false);
	let burst = $state(0);
	let burstSize = $state(12);
	/** The line's card, for the praise to rise from; `missKey` shakes it. */
	let cardEl = $state<HTMLElement>();
	let missKey = $state(0);
	let inputEl = $state<HTMLInputElement>();
	/** The line shown before answering — only offered with "Show transcripts" on. */
	let peek = $state(false);
	/** Bumped per line so the card freshens even when a line comes back round. */
	let dealt = $state(0);

	const passed = $derived(runPassed(right, RUN_LENGTH));

	// Navigating between two dictation quizzes reuses this component, so the
	// run has to reset when the quiz prop changes — otherwise the new quiz
	// inherits the old one's bar and score. Then, if the learner left this one
	// part-way through a run, it picks the run up where they stopped.
	$effect(() => {
		const id = quiz.id;
		// Everything below runs untracked, and the quiz id above is the only
		// dependency. Without this the effect also subscribes to `progress.stats`:
		// `statsFor` reads that state synchronously, before its first await, so
		// the read lands inside this effect's tracking scope. Every answer then
		// writes those stats, re-runs this effect, and `restart()` puts the run
		// back to its first line — the bar kept climbing (the saved spot restored
		// it) while the audio replayed line one forever.
		untrack(() => {
			restart();
			(async () => {
				const stats = await progress.statsFor(quiz.storageKeyPrefix);
				if (id !== quiz.id) return;
				streak = stats.streak;
				best = stats.bestStreakAbsolute;
				const spot = await loadSpot<Spot>(quiz.storageKeyPrefix);
				if (id !== quiz.id || answered > 0) return;
				const saved = Array.isArray(spot?.results) ? spot.results : [];
				if (saved.length > 0 && saved.length < RUN_LENGTH) {
					results = saved.filter((r) => r === 'right' || r === 'wrong');
					bestInRun = spot?.bestInRun ?? 0;
				}
			})();
		});
	});

	function play(rate = 1) {
		if (item) tts.speak(item.text, { locale, rate });
	}

	// Each new line plays itself once; the learner can replay at will.
	$effect(() => {
		dealt;
		if (item && !runDone) play();
	});

	async function check() {
		// An empty check is a skip: the line is shown and counts as wrong.
		if (!item || grade !== null) return;
		const result = gradeDictation(
			answer,
			item.text,
			progress.relaxedCorrection,
			quiz.strictDiacritics === true
		);
		grade = result;

		const stats = await progress.recordAnswer(quiz.storageKeyPrefix, result.right);
		const lapCompleted = result.right && stats.streak > 0 && stats.streak % STREAK_LAP_SIZE === 0;
		streak = stats.streak;
		best = stats.bestStreakAbsolute;
		results = [...results, result.right ? 'right' : 'wrong'];
		bestInRun = Math.max(bestInRun, stats.streak);
		react(result.right, cardEl, stats.streak);
		if (!result.right) {
			missKey += 1;
			missed = [...missed, item.text];
			// A missed line comes back after two others, so the correction is
			// still fresh but not the very next thing on screen.
			retry.push(item);
		} else {
			burstSize = lapCompleted ? 30 : 12;
			burst += 1;
		}
		saveSpot<Spot>(quiz.storageKeyPrefix, { results, bestInRun });

		// The medal is the streak's, not the run's: it is celebrated on the
		// line that crossed it, whenever in the run that happens.
		if (stats.earned) {
			earned = stats.earned;
			celebrateMedal(stats.earned, stats.streak);
		}

		// Back in the field (a click on Check took focus away), where Enter
		// moves on. Not on a touch screen: there the keyboard would spring back
		// over the line just revealed, so it is put away instead.
		if (window.matchMedia('(pointer: coarse)').matches) inputEl?.blur();
		else inputEl?.focus();

		const medal = stats.earned ? ` ${medalAnnouncement(stats.earned, stats.streak)}` : '';
		announce([
			{ text: `${BAND_LABELS[result.band]}, ${result.score} percent. The line was:` },
			{ text: item.text, lang: locale },
			...(medal ? [{ text: medal }] : [])
		]);
	}

	function next() {
		if (answered >= RUN_LENGTH) {
			finishRun();
			return;
		}
		if (retry.length && sinceRetry >= 2 && retry[0] !== item) {
			item = retry.shift();
			sinceRetry = 0;
		} else {
			item = drawFromShuffleBag(bag, pool, { avoidRepeat: item });
			sinceRetry++;
		}
		answer = '';
		grade = null;
		peek = false;
		dealt += 1;
		inputEl?.focus();
	}

	/** The run is over: log it, mark the exercise, show the card. */
	function finishRun() {
		runDone = true;
		void progress.recordRun(quiz.storageKeyPrefix, {
			right,
			total: RUN_LENGTH,
			bestStreak: bestInRun
		});
		clearSpot(quiz.storageKeyPrefix);
		onRunFinished(passed);
		announce(
			`Run finished: ${right} of ${RUN_LENGTH} right — ${passed ? 'exercise done' : 'not this time'}. Your streak is ${streak}.`
		);
	}

	function onKey(event: KeyboardEvent) {
		if (event.key !== 'Enter') return;
		// Handled here, so the window listener below leaves this one alone.
		event.preventDefault();
		// Enter needs something typed, so a stray keypress never skips a line.
		if (grade === null) {
			if (answer.trim()) void check();
		} else next();
	}

	/**
	 * Enter goes on to the next line from anywhere once the answer is shown —
	 * after a click on Check, focus is no longer in the field. A focused
	 * button keeps its own Enter.
	 */
	function onWindowKey(event: KeyboardEvent) {
		if (event.key !== 'Enter' || event.repeat || event.defaultPrevented) return;
		if (runDone || grade === null || inDialog(event.target)) return;
		const target = event.target as HTMLElement | null;
		if (target?.closest('button, a, input, textarea, select')) return;
		event.preventDefault();
		next();
		inputEl?.focus();
	}

	function restart() {
		bag = [];
		retry = [];
		sinceRetry = 0;
		pool = quiz.items;
		item = quiz.items[0];
		answer = '';
		grade = null;
		results = [];
		bestInRun = 0;
		earned = null;
		missed = [];
		runDone = false;
		peek = false;
		dealt = 0;
	}

	/** The words of the line, marked up — only the ones worth marking are. */
	const marks = $derived(grade?.marks ?? []);
	const isLast = $derived(answered >= RUN_LENGTH);
</script>

<svelte:window onkeydown={onWindowKey} />

<RunTracker {results} total={RUN_LENGTH} {streak} {best} />

{#if runDone}
	<RunSummary
		{right}
		total={RUN_LENGTH}
		{bestInRun}
		{streak}
		{earned}
		medal={progress.medalFor(quiz.storageKeyPrefix)}
		{missed}
		{locale}
		{passed}
	/>
{:else if item}
	<section class="card" bind:this={cardEl} use:freshen={dealt} use:shakeOn={missKey} in:rise>
		<div class="controls">
			<Burst trigger={burst} count={burstSize} />
			<button type="button" class="btn-ghost chip" onclick={() => play()}>
				<Icon name="play" size="0.95em" /> Play
			</button>
			<button type="button" class="btn-ghost chip" onclick={() => play(0.6)}>
				<Icon name="slow" size="0.95em" /> Slower
			</button>
			{#if progress.showTranscripts && grade === null}
				<button
					type="button"
					class="btn-ghost chip"
					aria-expanded={peek}
					aria-controls="dictation-transcript"
					onclick={() => (peek = !peek)}
				>
					<Icon name="book" size="0.95em" /> {peek ? 'Hide the text' : 'Show the text'}
				</button>
			{/if}
		</div>

		{#if peek && grade === null}
			<p class="reveal" id="dictation-transcript" lang={locale}><GermanText text={item.text} /></p>
		{/if}

		<!-- Read-only rather than disabled once answered: a disabled field
		     drops focus, and Enter would then have nowhere to go. -->
		<input
			bind:this={inputEl}
			bind:value={answer}
			onkeydown={onKey}
			enterkeyhint="go"
			readonly={grade !== null}
			aria-invalid={grade && !grade.right ? 'true' : undefined}
			aria-label="Type what you hear, line {Math.min(answered + 1, RUN_LENGTH)} of {RUN_LENGTH}"
			placeholder="Type what you hear"
			lang={locale}
			autocomplete="off"
			autocapitalize="sentences"
			spellcheck="false"
		/>

		{#if grade === null}
			<button type="button" class="btn" class:btn-ghost={!answer.trim()} onclick={check}>
				{#if answer.trim()}
					<Icon name="check" size="1em" /> Check
				{:else}
					Skip this line <Icon name="arrowRight" size="1em" />
				{/if}
			</button>
		{:else}
			<!-- The verdict is a grade, with the score beside it: how much of
			     the line landed, not merely whether all of it did. -->
			<p class="feedback" data-band={grade.band} in:pop={{ from: 0.88 }}>
				<Icon name={grade.right ? 'check' : 'close'} size="1.05em" />
				<span class="band">{BAND_LABELS[grade.band]}</span>
				<span class="score tnum">{grade.score}%</span>
			</p>

			<!-- The line itself is the correction: each word carries how it
			     came out, so the eye lands straight on what to fix. -->
			<p class="reveal marked" lang={locale} in:rise>
				{#each marks as mark, i (i)}
					{#if mark.state === 'extra'}
						<span class="word extra" title="Not in the line">{mark.typed}</span>
					{:else}
						<span class="word {mark.state}">
							{mark.target}
							{#if mark.state === 'slip' && mark.typed}
								<span class="was">you wrote {mark.typed}</span>
							{/if}
						</span>
					{/if}
				{/each}
				<SpeakButton text={item.text} {locale} />
			</p>
			<p class="note">{bandNote(grade.band)}</p>
			{#if item.translation}
				<p class="translation">{item.translation}</p>
			{/if}
			<button type="button" class="btn" onclick={next}>
				{isLast ? 'Finish the run' : 'Next line'}
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
		color: var(--accent-ink);
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
		margin: 0 0 0.7rem;
		font-weight: 700;
		color: var(--wrong);
	}

	/* Word for word and "nearly" are both right answers, so both read green;
	   half of it is amber — heard, not written — and the rest is a miss. */
	.feedback[data-band='perfect'],
	.feedback[data-band='close'] {
		color: var(--right);
	}

	.feedback[data-band='partial'] {
		color: var(--accent-ink);
	}

	.score {
		margin-left: auto;
		font-size: var(--step--1);
		font-weight: 800;
		font-variant-numeric: tabular-nums;
	}

	/* The revealed line is the answer key — set in the serif, like the prompts. */
	.reveal {
		margin: 0 0 0.45rem;
		max-width: none;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 600;
		color: var(--ink);
	}

	.marked {
		display: flex;
		flex-wrap: wrap;
		align-items: baseline;
		gap: 0.1rem 0.42rem;
	}

	.word {
		border-radius: var(--radius-sm);
		padding: 0 0.12rem;
	}

	/* A word that landed stays plain: only what needs attention is marked. */
	.word.slip {
		background: var(--accent-soft);
		color: var(--accent-ink);
		text-decoration: underline dotted;
		text-underline-offset: 0.2em;
	}

	.word.wrong,
	.word.miss {
		color: var(--wrong);
		text-decoration: underline wavy;
		text-underline-offset: 0.2em;
	}

	.word.extra {
		color: var(--ink-muted);
		text-decoration: line-through;
	}

	/* What they actually typed, small, right where the slip is. */
	.was {
		margin-left: 0.2rem;
		font-family: inherit;
		font-size: 0.68em;
		font-weight: 600;
		font-style: italic;
		white-space: nowrap;
		opacity: 0.85;
	}

	.note,
	.translation {
		margin: 0 0 1.1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.note {
		margin-bottom: 0.4rem;
	}
</style>
