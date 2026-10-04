<script lang="ts">
	// The flashcard deck. A real card: English on the front, and whatever the
	// mode — write the German, pick it from four, or flip and rate yourself —
	// the answer is revealed by turning the card over. The back carries the
	// German with its article coloured by gender, the plural, the audio and
	// the verdict. A new card is dealt from a stack behind the current one.
	//
	// Progress is two things: the deck's streak (which completes the quiz and
	// earns the ribbon, as a fill-in does), and a per-word record in the vocab
	// store, from which the "Weak words" toggle draws its cards.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { checkWritten, chooseOptions, fullForm } from '$lib/domain/flashcards';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { forSpeech } from '$lib/domain/spoken';
	import { drawFromShuffleBag } from '$lib/domain/shuffleBag';
	import { react, shakeOn } from '$lib/motion/fx.svelte';
	import StreakTracker from './StreakTracker.svelte';
	import { STREAK_LAP_SIZE, progressionUnlockStreak } from '$lib/domain/progress';
	import { MIN_SHOW, progress, revealPause } from '$lib/state/progress.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { tick } from 'svelte';
	import { vocab } from '$lib/state/vocab.svelte';
	import { untrack } from 'svelte';
	import type { VocabCard, VocabularyQuiz } from '$lib/content/types';

	let {
		quiz,
		courseId,
		locale,
		onGoalReached,
		focusWord = null
	}: {
		quiz: VocabularyQuiz;
		courseId: string;
		locale: string;
		onGoalReached: () => void;
		/** A source quiz id: start the deck on that quiz's words only. */
		focusWord?: string | null;
	} = $props();

	type Mode = 'write' | 'choose' | 'flip';
	const MODES: { id: Mode; label: string; icon: 'gap' | 'check' | 'repeat' }[] = [
		{ id: 'write', label: 'Write it', icon: 'gap' },
		{ id: 'choose', label: 'Choose', icon: 'check' },
		{ id: 'flip', label: 'Flip', icon: 'repeat' }
	];

	const ARTICLE_GENDER: Record<string, 'm' | 'f' | 'n'> = { der: 'm', die: 'f', das: 'n' };

	let mode = $state<Mode>('write');
	let weakOnly = $state(false);
	/** One exercise's words only, or null for the whole deck. */
	let sourceOnly = $state<string | null>(null);

	// The page learns the "?from=" scope after mount; take it when it arrives.
	// The learner can widen the scope again from the card.
	$effect(() => {
		const wanted = focusWord;
		if (wanted && wanted !== untrack(() => sourceOnly)) {
			sourceOnly = wanted;
			if (untrack(() => started)) next();
		}
	});

	const goal = $derived(progressionUnlockStreak(progress.gating));

	/** The cards in play: the whole deck, one quiz's words, or the weak ones. */
	const pool = $derived.by(() => {
		let cards: readonly VocabCard[] = quiz.cards;
		if (sourceOnly) cards = cards.filter((c) => c.sourceQuizId === sourceOnly);
		if (weakOnly) cards = vocab.weakCards(courseId, cards);
		return cards.length ? cards : quiz.cards;
	});
	const weakCount = $derived(vocab.weakCount(courseId, quiz.cards));

	// A bag per pool, so switching pools restarts the cycle cleanly.
	let bag: VocabCard[] = [];
	let poolKey = '';

	// Raw, not deep state: the shuffle bag compares by identity, and a proxy
	// never equals the pool's own object.
	let current = $state.raw<VocabCard | undefined>(untrack(() => quiz.cards[0]));
	/** Bumped on every deal, so the card element is re-created and animates in. */
	let dealt = $state(0);
	let answer = $state('');
	let options = $state<string[]>([]);
	/** Flip mode: the learner turned the card and has yet to rate it. */
	let peeking = $state(false);
	let verdict = $state<'right' | 'wrong' | null>(null);
	/** Set when a noun was right but the article was left off. */
	let missingArticle = $state(false);
	let chosen = $state<string | null>(null);
	let streak = $state(0);
	/** The answer card, for the praise to rise from; `missKey` shakes it. */
	let cardEl = $state<HTMLElement>();
	let missKey = $state(0);
	let misses = $state(0);
	let best = $state(0);
	let burst = $state(0);
	let burstSize = $state(12);
	let inputEl = $state<HTMLInputElement | null>(null);
	/** The back of the card: where focus goes once it turns over. */
	let backEl = $state<HTMLElement | null>(null);
	/** Cards missed this run, replayed before the run moves on. */
	let retry: VocabCard[] = [];
	let sinceRetry = 0;
	let timers: ReturnType<typeof setTimeout>[] = [];

	const locked = $derived(verdict !== null);
	/** The card shows its back: answered, or turned over to peek. */
	const revealed = $derived(locked || peeking);
	const target = $derived(current ? fullForm(current) : '');
	const gender = $derived(current?.article ? ARTICLE_GENDER[current.article] : undefined);

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
		const key = `${sourceOnly ?? ''}|${weakOnly}`;
		if (key !== poolKey) {
			poolKey = key;
			bag = [];
			retry = [];
		}
		// A missed card comes back after three others, so the correction is
		// still fresh but not the very next thing on screen.
		let card: VocabCard;
		// The bag may have just dealt the card that is due; wait one more turn.
		if (retry.length && sinceRetry >= 3 && retry[0] !== current) {
			card = retry.shift()!;
			sinceRetry = 0;
		} else {
			card = drawFromShuffleBag(bag, pool, { avoidRepeat: current });
			sinceRetry++;
		}
		current = card;
		dealt += 1;
		answer = '';
		chosen = null;
		peeking = false;
		verdict = null;
		missingArticle = false;
		options = mode === 'choose' ? chooseOptions(card, quiz.cards) : [];
	}

	// The front goes inert when the card turns; focus that was on it (the
	// field, an option, "Turn the card") follows the card to its back.
	$effect(() => {
		if (!revealed) return;
		void tick().then(() => {
			const active = document.activeElement;
			if (backEl && (!active || active === document.body || !backEl.contains(active))) {
				backEl.focus({ preventScroll: true });
			}
		});
	});

	// Focus lands on the fresh field once the new card element exists.
	$effect(() => {
		dealt;
		if (mode === 'write' && !locked) inputEl?.focus();
	});

	let started = $state(false);
	$effect(() => {
		if (!untrack(() => started)) {
			started = true;
			(async () => {
				await vocab.load(courseId);
				const stats = await progress.statsFor(quiz.storageKeyPrefix);
				streak = stats.streak;
				misses = stats.misses;
				best = stats.bestStreakAbsolute;
				next();
			})();
		}
		return clearTimers;
	});

	function setMode(m: Mode) {
		if (m === mode || locked) return;
		mode = m;
		if (current) options = m === 'choose' ? chooseOptions(current, quiz.cards) : [];
		peeking = false;
		answer = '';
		chosen = null;
	}

	function toggleWeak() {
		if (locked) return;
		weakOnly = !weakOnly;
		next();
	}

	function clearSource() {
		if (locked) return;
		sourceOnly = null;
		next();
	}

	/** Every mode ends here: record, turn the card, then deal the next one. */
	async function settle(correct: boolean) {
		if (!current) return;
		verdict = correct ? 'right' : 'wrong';
		const card = current;
		await vocab.record(courseId, card, correct, mode, quiz.id);
		const stats = await progress.recordAnswer(quiz.storageKeyPrefix, correct, card.kind);
		const lapCompleted = correct && stats.streak > 0 && stats.streak % STREAK_LAP_SIZE === 0;
		streak = stats.streak;
		misses = stats.misses;
		react(correct, cardEl, stats.streak);
		if (!correct) missKey += 1;
		best = stats.bestStreakAbsolute;
		if (correct) {
			burstSize = lapCompleted ? 30 : 12;
			burst += 1;
		} else {
			retry.push(card);
		}
		if (correct && stats.streak >= goal) onGoalReached();
		if (correct) announce('Correct.', target, locale);
		else announce('Not quite. It is:', target, locale);

		// The back stays up long enough to read; a miss earns a longer look.
		// Enter deals the next card straight away — once the card has turned,
		// so a miss is at least seen.
		const moveOn = () => {
			skip = null;
			clearTimers();
			next();
		};
		if (correct) wait(MIN_SHOW).then(() => (skip ??= moveOn));
		else await wait(600).then(() => (skip = moveOn));
		const pause = revealPause(progress.answerRevealMode);
		if (pause === null) {
			skip ??= moveOn;
			return;
		}
		await wait(pause + (correct ? 500 : 800));
		if (skip === moveOn) moveOn();
	}

	/** Set while an answered card is on show: deals the next one now. */
	let skip = $state<(() => void) | null>(null);

	function onWindowKey(event: KeyboardEvent) {
		if (event.key !== 'Enter' || event.repeat || !locked || !skip) return;
		event.preventDefault();
		skip();
	}

	function submitWritten() {
		if (!current || locked || !answer.trim()) return;
		const result = checkWritten(answer, current, progress.relaxedCorrection);
		missingArticle = result.missingArticle;
		settle(result.correct);
	}

	function choose(option: string) {
		if (!current || locked) return;
		chosen = option;
		settle(option === target);
	}

	function rate(knew: boolean) {
		if (!current || locked) return;
		settle(knew);
	}

	function onKey(event: KeyboardEvent) {
		if (event.key === 'Enter') submitWritten();
	}

	const fieldSize = $derived(Math.max(answer.length + 1, target.length, 8));
	const kindLabel = $derived(
		current?.kind === 'noun' ? 'Noun · with article' : current?.kind === 'name' ? 'Name' : 'Word'
	);
	/** The card's picture, and whether it asks the question by itself. */
	const picture = $derived(current?.image ? `/img/${current.image}.webp` : null);
	const pictureAlone = $derived(!!picture && !current?.imageHint);
</script>

<svelte:window onkeydown={onWindowKey} />

<StreakTracker {streak} {misses} {best} {goal} />

<div class="controls">
	<div class="modes" role="group" aria-label="Card mode">
		{#each MODES as m (m.id)}
			<button
				type="button"
				class="mode"
				aria-pressed={mode === m.id}
				disabled={locked}
				onclick={() => setMode(m.id)}
			>
				<Icon name={m.icon} size="0.95em" />
				{m.label}
			</button>
		{/each}
	</div>
	<span class="deck-count tnum">{pool.length} cards</span>
	<button
		type="button"
		class="weak"
		aria-pressed={weakOnly}
		disabled={locked || (weakCount === 0 && !weakOnly)}
		title={weakCount === 0
			? 'No weak words yet — miss one and it lands here'
			: 'Only the words you have missed'}
		onclick={toggleWeak}
	>
		<Icon name="flame" size="1em" />
		Weak words
		<span class="count tnum">{weakCount}</span>
	</button>
</div>

{#if sourceOnly}
	<p class="scope">
		Practising the words of one exercise ({pool.length} cards).
		<button type="button" class="btn-quiet" onclick={clearSource}>Whole level</button>
	</p>
{/if}

{#if current}
	<!-- The stage holds the stack: two decorative cards behind, the live card
	     on top. Re-keying on `dealt` re-creates the live card so it deals in. -->
	<div class="stage" bind:this={cardEl} use:shakeOn={missKey} style="--gender:{gender ? GENDER_COLORS[gender] : 'var(--heading)'}">
		<Burst trigger={burst} count={burstSize} />
		<div class="stack stack-2" aria-hidden="true"></div>
		<div class="stack stack-1" aria-hidden="true"></div>

		{#key dealt}
			<!-- The deal-in animation lives on a wrapper: an animation's final
			     transform would otherwise pin the card and swallow the flip. -->
			<div class="deal">
			<div
				class="flashcard"
				class:pictured={picture}
				class:revealed
				class:right={verdict === 'right'}
				class:wrong={verdict === 'wrong'}
			>
				<!-- Front: the question and the way to answer it. -->
				<div class="face front" aria-hidden={revealed} inert={revealed}>
					<p class="label">{kindLabel}</p>
					{#if picture}
						<!-- An obvious picture asks the question alone; the English
						     stays for screen readers. An ambiguous one keeps it visible. -->
						<img class="picture" src={picture} alt="" width="512" height="512" />
					{/if}
					<p class="prompt" class:hint={picture && !pictureAlone} class:sr-only={pictureAlone}>
						{current.en}
					</p>

					{#if mode === 'write'}
						<p class="answer" lang={locale}>
							<input
								bind:this={inputEl}
								bind:value={answer}
								onkeydown={onKey}
								enterkeyhint="go"
								readonly={locked}
								size={fieldSize}
								lang={locale}
								aria-label="The German word"
								aria-invalid={verdict === 'wrong' ? 'true' : undefined}
								placeholder={current.kind === 'noun' ? 'der / die / das …' : '…'}
								autocomplete="off"
								autocapitalize="off"
								autocorrect="off"
								spellcheck="false"
							/>
							<button type="button" class="go" aria-label="Check" onclick={submitWritten}>
								<Icon name="arrowRight" size="1.1em" />
							</button>
						</p>
						<p class="nudge">
							{current.kind === 'noun' ? 'Type the article too, then Enter.' : 'Type the German, then Enter.'}
						</p>
					{:else if mode === 'choose'}
						<div class="options">
							{#each options as option (option)}
								<button
									type="button"
									class="option"
									disabled={locked}
									lang={locale}
									onclick={() => choose(option)}>{option}</button
								>
							{/each}
						</div>
					{:else}
						<button type="button" class="turn" onclick={() => (peeking = true)}>
							<Icon name="repeat" size="1.1em" />
							Turn the card
						</button>
					{/if}
				</div>

				<!-- Back: the German, big, and how it went. -->
				<div
					class="face back"
					aria-hidden={!revealed}
					inert={!revealed}
					tabindex="-1"
					data-focus-target
					bind:this={backEl}
				>
					<p class="label">{current.en}</p>
					{#if picture}
						<img class="picture thumb" src={picture} alt="" width="512" height="512" />
					{/if}
					<p class="word" lang={locale}>
						{#if current.article}<span class="article">{current.article}</span>{/if}
						<span class="de">{current.de}</span>
						<SpeakButton text={forSpeech(target)} {locale} />
					</p>
					{#if current.plural}
						<p class="plural" lang={locale}>Plural: <strong>{current.plural}</strong></p>
					{/if}
					{#if current.note || current.also?.length}
						<p class="plural" lang={locale}>
							{#if current.note}<strong>{current.note}</strong>{/if}{#if current.note && current.also?.length} · {/if}{#if current.also?.length}also: <strong>{current.also.join(', ')}</strong>{/if}
						</p>
					{/if}

					{#if verdict === 'right'}
						<p class="verdict right"><Icon name="check" size="1.05em" /> Correct</p>
					{:else if verdict === 'wrong'}
						<p class="verdict wrong">
							<Icon name="close" size="1.05em" />
							{#if missingArticle}
								Right word — but a noun is learnt with its article.
							{:else if mode === 'write' && answer.trim()}
								You wrote <s lang={locale}>{answer}</s>
							{:else if mode === 'choose' && chosen}
								You chose <s lang={locale}>{chosen}</s>
							{:else}
								Not yet — it comes back in a moment.
							{/if}
						</p>
					{/if}
					{#if locked && progress.answerRevealMode === 'manual'}
						<button type="button" class="btn next-card" disabled={!skip} onclick={() => skip?.()}>
							Next card <Icon name="arrowRight" size="1em" />
						</button>
					{:else if peeking && !locked}
						<div class="rate">
							<button type="button" class="btn rate-no" onclick={() => rate(false)}>
								<Icon name="close" size="1em" /> Didn't know it
							</button>
							<button type="button" class="btn rate-yes" onclick={() => rate(true)}>
								<Icon name="check" size="1em" /> Knew it
							</button>
						</div>
					{/if}
				</div>
			</div>
			</div>
		{/key}
	</div>
{:else}
	<p class="empty">This deck has no cards yet.</p>
{/if}

<style>
	.controls {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.6rem;
		margin-bottom: 1.1rem;
	}

	.modes {
		display: inline-flex;
		padding: 0.2rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface-alt);
	}

	.mode,
	.weak {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		border: 1px solid transparent;
		border-radius: 999px;
		background: none;
		color: var(--ink-muted);
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.03em;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out);
	}

	.mode {
		padding: 0.38rem 0.85rem;
	}

	.mode[aria-pressed='true'] {
		background: var(--heading);
		color: var(--paper);
		box-shadow: 0 1px 2px rgb(0 0 0 / 0.12);
	}

	.weak {
		padding: 0.38rem 0.8rem;
		border-color: var(--line);
	}

	.weak[aria-pressed='true'] {
		border-color: var(--accent);
		background: var(--accent-soft);
		color: var(--accent-ink);
	}

	.weak:disabled {
		opacity: 0.55;
		cursor: default;
	}

	.count {
		padding: 0 0.4rem;
		border-radius: 999px;
		background: var(--surface);
		font-size: 0.7rem;
	}

	.scope {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin: 0 0 0.9rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* ── The stage and the stack ─────────────────────────────────────────── */

	.stage {
		position: relative;
		padding: 0 0 1.1rem;
		perspective: 1400px;
	}

	/* Two cards peeking out under the live one: the deck still to come. */
	.stack {
		position: absolute;
		inset: 0 0 1.1rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 6px 18px rgb(31 58 95 / 0.06);
		pointer-events: none;
	}

	.stack-1 {
		transform: translateY(0.45rem) scale(0.985);
	}

	.stack-2 {
		transform: translateY(0.9rem) scale(0.97);
		opacity: 0.75;
	}

	/* ── The card ────────────────────────────────────────────────────────── */

	.deal {
		position: relative;
		animation: deal var(--slow) var(--ease-out) backwards;
	}

	.flashcard {
		position: relative;
		display: grid;
		transform-style: preserve-3d;
		transition: transform var(--slow) var(--ease-out);
	}

	.flashcard.revealed {
		transform: rotateY(180deg);
	}

	@keyframes deal {
		from {
			transform: translateY(1.6rem) rotate(-1.5deg) scale(0.96);
			opacity: 0;
		}
		to {
			transform: translateY(0) rotate(0) scale(1);
			opacity: 1;
		}
	}

	/* Both faces sit in the same grid cell, so the card is as tall as the
	   taller face and never jumps when it turns. */
	.face {
		position: relative;
		grid-area: 1 / 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		text-align: center;
		/* Tall enough to feel like a card, never taller than the screen allows. */
		min-height: min(22rem, 48dvh);
		padding: 3rem 1.75rem 2.4rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 14px 34px rgb(31 58 95 / 0.12);
		backface-visibility: hidden;
		-webkit-backface-visibility: hidden;
	}

	/* A coloured edge, like an index card's rule: navy on the front, the
	   noun's gender colour on the back. */
	.front {
		border-top: 6px solid var(--heading);
	}

	.back {
		transform: rotateY(180deg);
		border-top: 6px solid var(--gender);
		background:
			radial-gradient(
				120% 90% at 100% 0%,
				color-mix(in srgb, var(--gender) 9%, transparent),
				transparent 60%
			),
			var(--surface);
	}

	.flashcard.right .back {
		border-top-color: var(--right);
	}

	.flashcard.wrong .back {
		border-top-color: var(--wrong);
	}

	.label {
		position: absolute;
		top: 1.25rem;
		left: 1.5rem;
		right: 1.5rem;
		margin: 0;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.back .label {
		color: var(--ink-muted);
		letter-spacing: 0.02em;
		text-transform: none;
		font-size: var(--step--1);
	}

	.deck-count {
		margin-left: auto;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.prompt {
		margin: 0;
		max-width: none;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-4);
		font-variation-settings: 'opsz' 36;
		font-weight: 600;
		line-height: 1.15;
		color: var(--heading);
	}

	/* ── The picture ─────────────────────────────────────────────────────── */

	/* The generated pictures share the paper background, so they sit on the
	   card without a frame; the corners are rounded in case a theme differs. */
	.picture {
		display: block;
		width: min(17rem, 40dvh, 74vw);
		height: auto;
		margin: 0.4rem 0 0.5rem;
		border-radius: var(--radius-sm);
		user-select: none;
		-webkit-user-drag: none;
	}

	/* The pictures are painted on cream paper (PAPER in tool/gen-images.mjs
	   levels every backdrop to exactly this), so the card takes that colour
	   and the drawing sits on the card instead of in a tile. */
	.pictured .face {
		background: #fbf5e4;
	}

	/* On the back the word is the point; the picture is a reminder. */
	.thumb {
		width: 7rem;
		margin: 0 0 0.2rem;
	}

	/* Under a picture the English is a caption, not the question. */
	.prompt.hint {
		font-size: var(--step-1);
		font-weight: 500;
		color: var(--ink-muted);
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		margin: -1px;
		padding: 0;
		overflow: hidden;
		clip: rect(0 0 0 0);
		white-space: nowrap;
		border: 0;
	}

	/* ── Write mode ──────────────────────────────────────────────────────── */

	.answer {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		width: min(100%, 22rem);
		margin: 1.6rem 0 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 600;
	}

	.answer input {
		flex: 1 1 auto;
		min-width: 0;
		padding: 0.25em 0.5em;
		text-align: center;
		border: 0;
		border-bottom: 2px solid var(--accent);
		border-radius: 6px 6px 0 0;
		background: var(--surface-alt);
		font: inherit;
		font-size: 0.95em;
		color: var(--ink);
		transition: background var(--fast) var(--ease-out);
	}

	.answer input::placeholder {
		color: var(--ink-muted);
		font-weight: 400;
	}

	.answer input:focus {
		outline: none;
		background: var(--accent-soft);
		/* A heavier, darker underline: the tint alone is too faint to find. */
		border-bottom-color: var(--accent-ink);
		box-shadow: inset 0 -2px 0 var(--accent-ink);
	}

	.go {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex: 0 0 auto;
		width: 2.6rem;
		height: 2.6rem;
		border: 0;
		border-radius: 50%;
		background: var(--heading);
		color: var(--paper);
		cursor: pointer;
		transition: transform var(--fast) var(--ease-spring);
	}

	.go:hover {
		transform: scale(1.06);
	}

	.nudge {
		margin: 0.7rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* ── Choose mode ─────────────────────────────────────────────────────── */

	.options {
		display: grid;
		gap: 0.55rem;
		width: 100%;
		max-width: 30rem;
		margin-top: 1.6rem;
	}

	@media (min-width: 560px) {
		.options {
			grid-template-columns: 1fr 1fr;
		}
	}

	.option {
		padding: 0.8rem 1rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 600;
		color: var(--ink);
		text-align: center;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-spring);
	}

	.option:hover:not(:disabled) {
		border-color: var(--heading);
		background: var(--surface-alt);
		transform: translateY(-1px);
	}

	/* ── Flip mode ───────────────────────────────────────────────────────── */

	.turn {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		margin-top: 1.8rem;
		padding: 0.7rem 1.2rem;
		border: 1px dashed var(--line-strong);
		border-radius: 999px;
		background: var(--surface-alt);
		font-weight: 700;
		color: var(--heading);
		cursor: pointer;
		transition: border-color var(--fast) var(--ease-out);
	}

	.turn:hover {
		border-color: var(--heading);
	}

	.next-card {
		margin-top: 1.1rem;
	}

	.rate {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.6rem;
		margin-top: 1.4rem;
	}

	.rate-no {
		background: var(--surface-alt);
		color: var(--ink);
		border: 1px solid var(--line-strong);
	}

	/* ── The back ────────────────────────────────────────────────────────── */

	.word {
		display: flex;
		flex-wrap: wrap;
		align-items: baseline;
		justify-content: center;
		gap: 0.35em;
		margin: 0;
		max-width: none;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-4);
		font-variation-settings: 'opsz' 36;
		font-weight: 700;
		line-height: 1.1;
		color: var(--heading);
	}

	.article {
		color: var(--gender);
		font-weight: 600;
	}

	.plural {
		margin: 0.5rem 0 0;
		font-size: var(--step-0);
		color: var(--ink-muted);
	}

	.plural strong {
		color: var(--ink);
	}

	.verdict {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-wrap: wrap;
		gap: 0.42rem;
		margin: 1.3rem 0 0;
		font-size: var(--step-0);
		font-weight: 700;
	}

	.verdict.right {
		color: var(--right);
	}

	.verdict.wrong {
		color: var(--wrong);
	}

	.verdict s {
		font-weight: 600;
		opacity: 0.8;
	}

	.empty {
		color: var(--ink-muted);
	}

	@media (prefers-reduced-motion: reduce) {
		.deal {
			animation: none;
		}
	}
	@media (max-width: 36rem) {
		.controls {
			margin-bottom: 0.7rem;
		}
		.face {
			padding: 2.6rem 1.1rem 1.6rem;
		}
		.prompt,
		.word {
			font-size: var(--step-3);
		}
		.options,
		.answer,
		.turn {
			margin-top: 1.1rem;
		}
	}
</style>
