<script lang="ts">
	// The fill-in-the-blank engine — 96 of the course's 214 exercises. Played
	// in runs of RUN_LENGTH answers: the bar only fills, finishing a run marks
	// the exercise done, and the streak (with its medals) runs across runs and
	// visits (see domain/progress.ts).
	//
	// Ported from lib/widgets/quiz_page.dart. The interaction is the Dart one:
	//
	//   * the field sits INSIDE the sentence, where the blank is, set in the
	//     same type — you answer in the gap, not in a box underneath it;
	//   * on submit a right answer simply turns green (a relaxed-mode slip is
	//     swapped for the proper spelling, with a note saying what changed);
	//     a wrong one is typed over in red, one letter at a time — the
	//     correction lands exactly where the eye already is;
	//   * then it advances on its own. There is no "next" button, so a run
	//     keeps its rhythm and the keyboard never has to be left.
	//
	// Questions come from the shuffle bag, so the whole pool is seen once per
	// cycle and the same question never repeats back to back. A missed one
	// comes back round a few questions later, inside the same run.
	//
	// An item with `tiles` is a word-order item: the gap is built by tapping
	// tiles into it (tap a placed one to take it back) instead of typed. The
	// built text goes through the very same check, reveal and stats.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import GermanText from '../GermanText.svelte';
	import { BLANK, canonicalGapAnswer, gapCount, matchesGaps } from '$lib/domain/answers';
	import { filledSentence, fillBlankPool, revealedParts } from '$lib/domain/spoken';
	import { joinTiles, tileBank, type Tile } from '$lib/domain/tiles';
	import { tick, untrack } from 'svelte';
	import { drawFromShuffleBag } from '$lib/domain/shuffleBag';
	import {
		medalAnnouncement,
		RUN_LENGTH,
		runPassed,
		STREAK_LAP_SIZE,
		type RibbonTier
	} from '$lib/domain/progress';
	import { MIN_SHOW, progress, revealPause } from '$lib/state/progress.svelte';
	import { clearSpot, loadSpot, saveSpot } from '$lib/state/resume';
	import { announce } from '$lib/a11y.svelte';
	import { freshen, prefersReducedMotion } from '$lib/motion';
	import { celebrateMedal, react, shakeOn } from '$lib/motion/fx.svelte';
	import RunSummary from './RunSummary.svelte';
	import RunTracker from './RunTracker.svelte';
	import type { FillBlankQuiz, QuizSentence } from '$lib/content/types';

	let {
		quiz,
		locale,
		onAnswer,
		onRunFinished
	}: {
		quiz: FillBlankQuiz;
		locale: string;
		onAnswer: (correct: boolean) => void;
		/** A run of RUN_LENGTH answers is over — the exercise counts as done. */
		onRunFinished: (passed: boolean) => void;
	} = $props();

	// Built once: the page is keyed by quiz id, so a new quiz mounts a new component.
	const pool = untrack(() => fillBlankPool(quiz));
	const bag: QuizSentence[] = [];
	/** Sentences missed this run, replayed before the run moves on. */
	let retry: QuizSentence[] = [];
	let sinceRetry = 0;

	/** Where this run saves its place, so leaving mid-run costs nothing. */
	type Spot = { results: ('right' | 'wrong')[]; bestInRun: number };

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
	/** Gaps a relaxed check accepted but spelled differently from the key. */
	let fixes = $state<{ typed: string; proper: string }[]>([]);
	let streak = $state(0);
	/** The answer card, for the praise to rise from; `missKey` shakes it. */
	let cardEl = $state<HTMLElement>();
	let missKey = $state(0);
	let best = $state(0);
	// The run: answers given (the bar), how many were right, the longest
	// streak inside it, the medal it crossed into, and the slips to show.
	let results = $state<('right' | 'wrong')[]>([]);
	const answered = $derived(results.length);
	const right = $derived(results.filter((r) => r === 'right').length);
	let bestInRun = $state(0);
	let earned = $state<RibbonTier | null>(null);
	let missed = $state<string[]>([]);
	let runDone = $state(false);
	let inputEls = $state<HTMLInputElement[]>([]);
	let burst = $state(0);
	let burstSize = $state(12);
	/** Pending reveal/advance timers, cancelled if the component goes away. */
	let timers: ReturnType<typeof setTimeout>[] = [];

	const locked = $derived(verdict !== null);

	/** A word-order item: built from tiles, not typed. */
	const tiled = $derived(!!current?.tiles?.length);
	/** The tiles on offer, in their seeded order (stable from prerender to hydration). */
	let bank = $state.raw<Tile[]>(pool[0] ? tileBank(pool[0]) : []);
	/** Ids of the tiles placed in the gap, in order. */
	let built = $state<number[]>([]);
	let bankEls = $state<HTMLButtonElement[]>([]);
	let checkEl = $state<HTMLButtonElement>();

	const tileText = (id: number) => bank.find((t) => t.id === id)?.text ?? '';

	function setBuilt(ids: number[]) {
		built = ids;
		answers = [joinTiles(ids.map(tileText))];
	}

	/** Places a tile, then hands focus to the next free one (or Check). */
	function place(tile: Tile) {
		if (locked || built.includes(tile.id)) return;
		setBuilt([...built, tile.id]);
		announce('Your sentence:', answers[0], locale);
		const free = bankEls.find((el, i) => el && !built.includes(bank[i].id));
		(free ?? checkEl)?.focus();
	}

	function unplace(id: number) {
		if (locked) return;
		setBuilt(built.filter((b) => b !== id));
		announce(built.length ? 'Your sentence:' : 'Gap empty.', built.length ? answers[0] : '', locale);
	}

	/**
	 * Keys for a tile item, where there is no field to type in: Enter checks
	 * (or moves on), Backspace takes the last tile back, 1–9 place a tile.
	 */
	function onTileKey(event: KeyboardEvent) {
		if (!tiled || event.ctrlKey || event.metaKey || event.altKey) return;
		const target = event.target as HTMLElement | null;
		if (target?.closest('input, textarea, select, [contenteditable="true"], dialog')) return;
		if (event.key === 'Enter') {
			// Enter on a tile places it — the button's own click does that.
			if (!locked && target?.closest('.tile')) return;
			event.preventDefault();
			if (locked) {
				if (!event.repeat) skip?.();
			} else if (filled) submit();
		} else if (event.key === 'Backspace' && !locked && built.length) {
			event.preventDefault();
			unplace(built[built.length - 1]);
		} else if (/^[1-9]$/.test(event.key) && !locked) {
			const tile = bank[Number(event.key) - 1];
			if (tile) {
				event.preventDefault();
				place(tile);
			}
		}
	}

	/**
	 * The subject label above the sentence — shown only when it adds something.
	 * A template-driven quiz already carries the subject inside the sentence,
	 * and repeating it is the duplicate-information problem the Dart app
	 * deliberately avoided.
	 */
	const subject = $derived.by(() => {
		// A word-order item's subject ("weil … bin") would say where the verb goes.
		if (!current || tiled) return null;
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
		if (tiled) return [''];
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
		// A missed sentence comes back after two others, so the correction is
		// still fresh but not the very next thing on screen.
		if (retry.length && sinceRetry >= 2 && retry[0] !== current) {
			current = retry.shift();
			sinceRetry = 0;
		} else {
			current = drawFromShuffleBag(bag, pool, { avoidRepeat: current });
			sinceRetry++;
		}
		bank = current ? tileBank(current) : [];
		built = [];
		// The first-letter hint pre-fills the gap rather than sitting beside it.
		answers = hintFill();
		verdict = null;
		fixes = [];
		// The bank is re-rendered for the new item before its first tile can take focus.
		if (tiled) tick().then(() => bankEls[0]?.focus());
		else inputEls[0]?.focus();
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

	// Load the persisted streak, and the run's saved place, so a returning
	// learner carries on where they were.
	$effect(() => {
		// Untracked for the same reason as the dictation's: `statsFor` reads
		// `progress.stats` before its first await, so without this the effect
		// re-runs on every answer and restores the run from its saved spot.
		untrack(() => {
			(async () => {
				const stats = await progress.statsFor(quiz.storageKeyPrefix);
				streak = stats.streak;
				best = stats.bestStreakAbsolute;
				const spot = await loadSpot<Spot>(quiz.storageKeyPrefix);
				const saved = Array.isArray(spot?.results) ? spot.results : [];
				if (saved.length > 0 && saved.length < RUN_LENGTH) {
					results = saved.filter((r) => r === 'right' || r === 'wrong');
					bestInRun = spot?.bestInRun ?? 0;
				}
			})();
		});
	});

	/** The run is over: log it, mark the exercise done, show the card. */
	function finishRun() {
		runDone = true;
		void progress.recordRun(quiz.storageKeyPrefix, {
			right,
			total: RUN_LENGTH,
			bestStreak: bestInRun
		});
		clearSpot(quiz.storageKeyPrefix);
		const passed = runPassed(right, RUN_LENGTH);
		onRunFinished(passed);
		announce(
			`Run finished: ${right} of ${RUN_LENGTH} right — ${passed ? 'exercise done' : 'not this time'}. Your streak is ${streak}.`
		);
	}


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
		best = stats.bestStreakAbsolute;
		results = [...results, correct ? 'right' : 'wrong'];
		bestInRun = Math.max(bestInRun, stats.streak);
		react(correct, cardEl, stats.streak);
		if (!correct) {
			missKey += 1;
			retry.push(current);
		}
		onAnswer(correct);
		saveSpot<Spot>(quiz.storageKeyPrefix, { results, bestInRun });

		if (correct) {
			burstSize = lapCompleted ? 30 : 12;
			burst += 1;
		}

		// The streak just crossed a medal boundary: the big celebration, now,
		// whatever the run is doing — the medal is the streak's, not the run's.
		if (stats.earned) {
			earned = stats.earned;
			celebrateMedal(stats.earned, stats.streak);
		}

		const canonical = canonicalGapAnswer(typed, accepted, progress.relaxedCorrection, strict);
		if (!correct) missed = [...missed, filledSentence(current.sentence, canonical)];
		// A right answer is never retyped: it just turns green. If relaxed mode let
		// a slip through ("schon" for "schön"), the proper spelling drops straight
		// in and a note under the sentence says what changed.
		// Tiles are spelled right by construction; only a typed slip gets a note.
		fixes = correct && !tiled
			? typed.flatMap((t, i) =>
					t.trim() === canonical[i] ? [] : [{ typed: t.trim(), proper: canonical[i] }]
				)
			: [];

		// Enter moves on without waiting out the reveal: shortly after a right
		// answer, once the correction is written in after a wrong one. Never
		// instantly — a double-tapped Enter would swap the sentence before the
		// green ever showed, which reads as a glitch rather than a result.
		// The run's last answer moves on to the summary card instead.
		const moveOn = () => {
			skip = null;
			clearTimers();
			if (answered >= RUN_LENGTH) finishRun();
			else next();
		};
		if (correct) wait(MIN_SHOW).then(() => (skip ??= moveOn));
		// One announcement per answer: a second call replaces the first, so a
		// medal is said inside it rather than after it.
		const medal = stats.earned ? ` ${medalAnnouncement(stats.earned, stats.streak)}` : '';
		if (correct) announce(`Correct.${medal}`);
		else
			announce([
				{ text: 'Not quite. The answer is:' },
				{ text: filledSentence(current.sentence, canonical), lang: locale },
				...(medal ? [{ text: medal }] : [])
			]);
		if (correct) {
			answers = [...canonical];
		} else {
			answers = new Array(gaps).fill('');
			await typeOut(canonical);
		}
		skip = moveOn;
		const pause = revealPause(progress.answerRevealMode);
		if (pause === null) return;
		// A spelling note needs reading time of its own.
		await wait(fixes.length ? Math.max(pause * 2, 2500) : pause);
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

<svelte:window onkeydown={onTileKey} />

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
		passed={runPassed(right, RUN_LENGTH)}
	/>
{:else if current}
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
				: 'Tap any word for its meaning, and colour the nouns by gender'}
			onclick={() => progress.setWordHelp(!progress.wordHelp)}
		>
			<Icon name="book" size="1em" />
			<span>Word help</span>
		</button>

		<p class="prompt-label">{current.categoryLabel}</p>
		{#if subject}
			<p class="subject">{subject}</p>
		{/if}

		<!-- The sentence, with a field standing in for each blank — or, for a
		     word-order item, the tiles placed so far (tap one to take it back). -->
		<p class="sentence" lang={locale}>
			{#each segments as segment, i (i)}<GermanText text={segment} />{#if i < gaps && tiled}<span
						class="build"
						class:right={verdict === 'right'}
						class:wrong={verdict === 'wrong'}
						class:empty={!locked && !built.length}
						role="group"
						aria-label="Your sentence"
						>{#if locked}{answers[0]}{:else if built.length}{#each built as id (id)}<button
									type="button"
									class="tile placed"
									onclick={() => unplace(id)}
									aria-label="{tileText(id)}, take back">{tileText(id)}</button
								>{/each}{:else}<span class="placeholder">tap the words below</span>{/if}</span
					>{:else if i < gaps}<span
						class="slot"
						><input
							bind:this={inputEls[i]}
							bind:value={answers[i]}
							onkeydown={(event) => onKey(event, i)}
							readonly={locked}
							class:right={verdict === 'right'}
							class:wrong={verdict === 'wrong'}
							aria-invalid={verdict === 'wrong' ? 'true' : undefined}
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

		{#if tiled}
			<!-- The tiles keep their places once used, so the bank never reflows
			     under the thumb. -->
			<div class="bank" role="group" aria-label="Words to place" lang={locale}>
				{#each bank as tile, i (tile.id)}
					<button
						type="button"
						class="tile"
						bind:this={bankEls[i]}
						disabled={locked || built.includes(tile.id)}
						onclick={() => place(tile)}>{tile.text}</button
					>
				{/each}
			</div>
		{/if}

		<!-- One fixed row under the sentence: the hint while answering, the
		     verdict once checked, and the button that does what Enter does —
		     Check, then Next. Same slot, so nothing jumps. -->
		<div class="status-row">
		<p class="status" class:right={verdict === 'right'} class:wrong={verdict === 'wrong'}>
			{#if verdict === 'right' && fixes.length}
				<Icon name="check" size="1.05em" />
				<span>
					Correct — mind the spelling:
					{#each fixes as fix, i (i)}{#if i},
						{/if}<s class="slip">{fix.typed}</s> → <strong lang={locale}>{fix.proper}</strong>{/each}
				</span>
			{:else if verdict === 'right'}
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
			<button type="button" class="act" bind:this={checkEl} disabled={!filled} onpointerdown={holdFocus} onclick={checkTap}>
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
		color: var(--accent-ink);
	}

	.prompt-label {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent-ink);
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
		/* A heavier, darker underline: the tint alone is too faint to find. */
		border-bottom-color: var(--accent-ink);
		box-shadow: inset 0 -2px 0 var(--accent-ink);
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

	/* A word-order gap: the placed tiles sit in the sentence, in its type. */
	.build {
		display: inline-flex;
		flex-wrap: wrap;
		align-items: baseline;
		gap: 0.3em;
		min-width: 6em;
		padding: 0.05em 0.3em;
		border-bottom: 2px solid var(--accent);
		border-radius: 5px 5px 0 0;
		background: var(--surface-alt);
		vertical-align: baseline;
	}

	.build.right {
		border-bottom-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
	}

	.build.wrong {
		border-bottom-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
	}

	.placeholder {
		font-family: Inter, ui-sans-serif, system-ui, sans-serif;
		font-size: var(--step--1);
		font-weight: 500;
		color: var(--ink-muted);
	}

	.bank {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin: 1rem 0 0;
	}

	/* The story's tiles: raised cards that press in. */
	.tile {
		min-height: 2.75rem;
		padding: 0.5rem 0.95rem;
		border: 1.5px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		box-shadow:
			0 2px 0 var(--paper-highest),
			0 4px 10px rgb(31 58 95 / 0.08);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 600;
		color: var(--heading);
		cursor: pointer;
		transition:
			transform 110ms ease,
			border-color 110ms ease,
			box-shadow 110ms ease,
			opacity 110ms ease;
	}

	.tile:hover:not(:disabled) {
		transform: translateY(-2px);
		border-color: var(--accent);
	}

	.tile:active:not(:disabled) {
		transform: translateY(1px);
		box-shadow: none;
	}

	.tile:disabled {
		opacity: 0.3;
		cursor: default;
	}

	/* In the gap a tile reads as part of the sentence, not as a button. */
	.tile.placed {
		min-height: 0;
		padding: 0 0.35em;
		border: 0;
		border-radius: 4px;
		background: var(--accent-soft);
		box-shadow: none;
		font-size: 0.95em;
		color: var(--ink);
		line-height: 1.5;
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

	.slip {
		color: var(--ink-muted);
		font-weight: 500;
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
		background: var(--accent-ink);
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
