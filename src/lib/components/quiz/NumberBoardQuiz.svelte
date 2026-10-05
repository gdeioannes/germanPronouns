<script lang="ts">
	// The number board — the first quiz's game, played instead of its typed
	// drill. Hear a number, tap it, watch it pop off the board; then read
	// them; then write three. Easy first, every answer answered with sound
	// and a burst, and no streak: a miss never costs progress, the item just
	// waits (see domain/numberBoard).
	//
	// Taps are not recorded into the drill's streak stats: ten right in a row
	// there counts as the drill finished, which would mark the quiz complete
	// halfway through the game. Completion comes from the page, at the end.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { BOARD_STAGES, boardNumbers, planLength, stagePlan, type BoardNumber } from '$lib/domain/numberBoard';
	import { matchesAccepted } from '$lib/domain/answers';
	import { progress } from '$lib/state/progress.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { react, shakeOn } from '$lib/motion/fx.svelte';
	import { tts } from '$lib/services/speech';
	import { isMuted } from '$lib/services/mute';
	import { track } from '$lib/services/analytics';
	import { tick, untrack } from 'svelte';
	import type { FillBlankQuiz } from '$lib/content/types';

	let {
		quiz,
		locale,
		onFinish
	}: {
		quiz: FillBlankQuiz;
		locale: string;
		onFinish: () => void;
	} = $props();

	const numbers = untrack(() => boardNumbers(quiz));
	/** Laid out like a phone keypad: 1–9, then 0 and a wide 10 underneath. */
	const keypad = [
		...numbers.filter((n) => n.digit !== '0' && n.digit !== '10'),
		...numbers.filter((n) => n.digit === '0' || n.digit === '10')
	];

	let plan = $state.raw(stagePlan(numbers));
	const total = $derived(planLength(plan));

	let phase = $state<'intro' | 'play' | 'break' | 'done'>('intro');
	let stageIndex = $state(0);
	let itemIndex = $state(0);
	/** Answered items across every stage — what fills the bar. */
	let answered = $state(0);
	/** Digits already popped off the board in this stage. */
	let gone = $state<string[]>([]);
	/** Misses on the current item; the second one lights the right button. */
	let misses = $state(0);
	/** Right answers in a row, for the praise's milestone words. */
	let run = $state(0);
	/** True from an answer until the next item is up. */
	let locked = $state(false);
	/** The word, written — the hear stage's fallback when the sound is off. */
	let showWord = $state(false);
	/** Misses per button, so only the one tapped shakes. */
	let shakes = $state<Record<string, number>>({});
	/** The cell a burst fires from. */
	let burstAt = $state<{ digit: string; key: number }>({ digit: '', key: 0 });

	// The write stage.
	let typed = $state('');
	let verdict = $state<'right' | 'wrong' | null>(null);
	let inputEl = $state<HTMLInputElement>();
	let writeEl = $state<HTMLElement>();
	let writeBurst = $state(0);
	let writeMiss = $state(0);

	const stage = $derived(BOARD_STAGES[stageIndex]);
	const target = $derived<BoardNumber | undefined>(plan[stage][itemIndex]);
	const percent = $derived(total ? Math.round((answered / total) * 100) : 0);

	let timers: ReturnType<typeof setTimeout>[] = [];
	function later(ms: number, fn: () => void) {
		timers.push(setTimeout(fn, ms));
	}
	$effect(() => () => timers.forEach(clearTimeout));

	function say(word: string) {
		void tts.speak(word, { locale });
	}

	function begin() {
		phase = 'play';
		showWord = stage === 'hear' && isMuted();
		track('number_board_stage', { quiz: quiz.id, stage });
		if (stage === 'write') tick().then(() => inputEl?.focus());
		else if (target && stage === 'hear') say(target.word);
	}

	function advance() {
		misses = 0;
		typed = '';
		verdict = null;
		if (itemIndex + 1 < plan[stage].length) {
			itemIndex += 1;
			locked = false;
			if (stage === 'hear' && target) say(target.word);
			if (stage === 'write') tick().then(() => inputEl?.focus());
			return;
		}
		if (stageIndex + 1 < BOARD_STAGES.length) {
			phase = 'break';
			return;
		}
		phase = 'done';
		track('number_board_stage', { quiz: quiz.id, stage: 'done' });
		onFinish();
	}

	function nextStage() {
		stageIndex += 1;
		itemIndex = 0;
		gone = [];
		locked = false;
		begin();
	}

	function tap(n: BoardNumber, cell: HTMLElement) {
		if (locked || phase !== 'play' || !target || gone.includes(n.digit)) return;
		if (n.digit === target.digit) {
			locked = true;
			run += 1;
			answered += 1;
			gone = [...gone, n.digit];
			burstAt = { digit: n.digit, key: burstAt.key + 1 };
			react(true, cell, run);
			// Reading: the sound joins the spelling the moment it is got right.
			if (stage === 'read') say(n.word);
			announce('Right:', n.word, locale);
			later(stage === 'read' ? 900 : 650, advance);
		} else {
			run = 0;
			misses += 1;
			shakes[n.digit] = (shakes[n.digit] ?? 0) + 1;
			react(false, cell);
			if (stage === 'hear') {
				announce('Not that one. Listen again.');
				later(450, () => say(target!.word));
			} else {
				announce(`Not ${n.digit}. Try again.`);
			}
		}
	}

	function submit(event: SubmitEvent) {
		event.preventDefault();
		if (locked || !target || !typed.trim()) return;
		locked = true;
		answered += 1;
		const correct = matchesAccepted(typed, [target.word], progress.relaxedCorrection);
		verdict = correct ? 'right' : 'wrong';
		react(correct, writeEl, correct ? ++run : 0);
		if (correct) {
			writeBurst += 1;
			announce('Right:', target.word, locale);
		} else {
			run = 0;
			writeMiss += 1;
			typed = target.word;
			announce('Almost. It is spelt:', target.word, locale);
		}
		say(target.word);
		later(correct ? 1100 : 2000, advance);
	}

	function playAgain() {
		plan = stagePlan(numbers);
		stageIndex = 0;
		itemIndex = 0;
		answered = 0;
		run = 0;
		gone = [];
		locked = false;
		begin();
	}

	const STAGE_COPY = {
		hear: { step: 'Hear it', ask: 'Which number did you hear?' },
		read: { step: 'Read it', ask: 'Tap this number' },
		write: { step: 'Write it', ask: 'Type the word' }
	} as const;
</script>

<div class="board-quiz">
	{#if phase === 'intro'}
		<section class="card intro">
			<p class="eyebrow">Your first German</p>
			<h2>Hear it. Tap it.</h2>
			<p class="lead">
				You'll hear a German number — tap it on the board. Then read a few, then write three.
			</p>
			<p class="meta"><Icon name="volume" size="1em" /> Sound on · 20 quick taps · about 2 minutes</p>
			<button type="button" class="btn start" onclick={begin}>
				Start <Icon name="arrowRight" size="1em" />
			</button>
		</section>
	{:else if phase === 'done'}
		<section class="card finale">
			<p class="eyebrow">Geschafft!</p>
			<h2>You can count to ten in German.</h2>
			<ul class="words" lang={locale}>
				{#each numbers as n (n.digit)}
					<li>
						<button type="button" onclick={() => say(n.word)} aria-label="{n.digit}: {n.word}, listen">
							<span class="d tnum">{n.digit}</span>
							<span class="w">{n.word}</span>
						</button>
					</li>
				{/each}
			</ul>
			<p class="meta">Tap any number to hear it again.</p>
			<button type="button" class="btn btn-ghost" onclick={playAgain}>Play again</button>
		</section>
	{:else}
		<!-- The way through: three steps and one bar that only ever fills. -->
		<div class="track">
			<ol class="steps">
				{#each BOARD_STAGES as s, i (s)}
					<li class:now={i === stageIndex} class:past={i < stageIndex}>
						{#if i < stageIndex}<Icon name="check" size="0.9em" />{:else}<span class="n">{i + 1}</span>{/if}
						{STAGE_COPY[s].step}
					</li>
				{/each}
			</ol>
			<div
				class="bar"
				role="progressbar"
				aria-label="Progress"
				aria-valuemin={0}
				aria-valuemax={total}
				aria-valuenow={answered}
			>
				<span style:width="{percent}%"></span>
			</div>
		</div>

		{#if phase === 'break'}
			<section class="card break">
				{#if stage === 'hear'}
					<p class="big" aria-hidden="true">🎉</p>
					<h2>Board cleared!</h2>
					<p class="lead">You understood all eleven numbers by ear. Now let's read them.</p>
					<button type="button" class="btn" onclick={nextStage}>
						Read them <Icon name="arrowRight" size="1em" />
					</button>
				{:else}
					<p class="big" aria-hidden="true">⭐</p>
					<h2>Six for six!</h2>
					<p class="lead">Last step: write three numbers. They're shown — just copy them.</p>
					<button type="button" class="btn" onclick={nextStage}>
						Write three <Icon name="arrowRight" size="1em" />
					</button>
				{/if}
			</section>
		{:else if target && stage === 'write'}
			<form class="card write" bind:this={writeEl} use:shakeOn={writeMiss} onsubmit={submit}>
				<Burst trigger={writeBurst} count={16} />
				<p class="ask">{STAGE_COPY.write.ask}</p>
				<p class="digit tnum" aria-hidden="true">{target.digit}</p>
				<p class="model" lang={locale}>
					{target.word}
					<SpeakButton text={target.word} {locale} />
				</p>
				<label class="field" class:right={verdict === 'right'} class:wrong={verdict === 'wrong'}>
					<span class="sr-only">Type {target.word}</span>
					<input
						bind:this={inputEl}
						bind:value={typed}
						lang={locale}
						readonly={locked}
						autocomplete="off"
						autocapitalize="off"
						spellcheck="false"
						enterkeyhint="go"
						placeholder="type it here"
					/>
				</label>
				<p class="verdict" aria-hidden="true">
					{#if verdict === 'right'}Perfekt!{:else if verdict === 'wrong'}Almost — this is how it's spelt.{/if}
				</p>
				<button type="submit" class="btn" disabled={locked || !typed.trim()}>Check</button>
			</form>
		{:else if target}
			<section class="play">
				<div class="cue">
					<p class="ask">{STAGE_COPY[stage].ask}</p>
					{#if stage === 'hear'}
						<button type="button" class="listen" onclick={() => say(target!.word)} aria-label="Listen again">
							<Icon name="volume" size="1.6em" />
						</button>
						{#if showWord}
							<p class="word" lang={locale}>{target.word}</p>
						{:else}
							<button type="button" class="reveal" onclick={() => (showWord = true)}>
								Can't hear it? Show the word
							</button>
						{/if}
					{:else}
						<p class="word" lang={locale}>{target.word}</p>
					{/if}
				</div>

				<div class="board" role="group" aria-label="Number board">
					{#each keypad as n (n.digit)}
						{@const isGone = gone.includes(n.digit)}
						<div class="cell" class:wide={n.digit === '10'}>
							{#if burstAt.digit === n.digit}<Burst trigger={burstAt.key} count={14} />{/if}
							<button
								type="button"
								class="num tnum"
								class:gone={isGone}
								class:hint={misses >= 2 && n.digit === target.digit}
								disabled={isGone}
								aria-hidden={isGone}
								use:shakeOn={shakes[n.digit] ?? 0}
								onclick={(e) => tap(n, e.currentTarget)}
							>
								{n.digit}
							</button>
						</div>
					{/each}
				</div>
			</section>
		{/if}
	{/if}
</div>

<style>
	.board-quiz {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		width: 100%;
		max-width: 32rem;
		margin: 0 auto;
	}

	.card {
		position: relative;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.6rem;
		padding: 1.6rem 1.25rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		text-align: center;
	}

	.card h2 {
		margin: 0;
		font-size: var(--step-3);
		line-height: 1.15;
	}

	.eyebrow {
		margin: 0;
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.lead {
		margin: 0;
		max-width: 26rem;
		color: var(--ink);
	}

	.meta {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.start {
		margin-top: 0.6rem;
		padding: 0.85rem 2.2rem;
		font-size: var(--step-1);
	}

	.big {
		margin: 0;
		font-size: 2.6rem;
		line-height: 1;
	}

	/* -- progress ------------------------------------------------------------ */

	.track {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.steps {
		display: flex;
		justify-content: space-between;
		gap: 0.5rem;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.steps li {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
	}

	.steps .n {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.35rem;
		height: 1.35rem;
		border: 1px solid var(--line-strong);
		border-radius: 50%;
		font-size: 0.75rem;
	}

	.steps .now {
		color: var(--heading);
	}

	.steps .now .n {
		border-color: var(--navy);
		background: var(--navy);
		color: var(--paper);
	}

	.steps .past {
		color: var(--right);
	}

	.bar {
		height: 0.55rem;
		border-radius: 999px;
		background: var(--surface-alt);
		overflow: hidden;
	}

	.bar span {
		display: block;
		height: 100%;
		border-radius: inherit;
		background: var(--right);
		transition: width 420ms var(--ease-spring);
	}

	/* -- the board ----------------------------------------------------------- */

	.play {
		display: flex;
		flex-direction: column;
		gap: 1.1rem;
	}

	.cue {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.55rem;
		min-height: 9.5rem;
		justify-content: center;
	}

	.ask {
		margin: 0;
		font-weight: 600;
		color: var(--ink-muted);
	}

	.listen {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 4.6rem;
		height: 4.6rem;
		border: 0;
		border-radius: 50%;
		background: var(--accent);
		color: #fff;
		cursor: pointer;
		box-shadow: 0 10px 24px -12px rgb(162 76 38 / 0.7);
		transition: transform var(--fast) var(--ease-out);
	}

	.listen:hover {
		transform: scale(1.05);
	}

	.listen:active {
		transform: scale(0.96);
	}

	.word {
		margin: 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-4);
		font-weight: 700;
		line-height: 1.1;
		color: var(--heading);
	}

	.reveal {
		padding: 0.2rem 0.4rem;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		text-decoration: underline;
		cursor: pointer;
	}

	.board {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 0.6rem;
	}

	.cell.wide {
		grid-column: span 2;
	}

	.cell {
		position: relative;
		display: flex;
	}

	.num {
		flex: 1;
		min-height: 4rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-size: var(--step-3);
		font-weight: 700;
		cursor: pointer;
		box-shadow: 0 3px 0 var(--line-strong);
		transition:
			transform 260ms var(--ease-spring),
			opacity 260ms var(--ease-out),
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.num:hover:not(:disabled) {
		border-color: var(--accent);
		background: var(--accent-soft);
	}

	.num:active:not(:disabled) {
		transform: translateY(2px);
		box-shadow: 0 1px 0 var(--line-strong);
	}

	/* Right: it pops and leaves its place empty, so the board never reflows. */
	.num.gone {
		transform: scale(0.2);
		opacity: 0;
		cursor: default;
		pointer-events: none;
	}

	/* Two misses: the answer lights up, so nobody is ever stuck. */
	.num.hint {
		border-color: var(--right);
		background: var(--right-bg);
		animation: hint 1s var(--ease-out) infinite;
	}

	@keyframes hint {
		50% {
			transform: scale(1.06);
		}
	}

	/* -- write --------------------------------------------------------------- */

	.digit {
		margin: 0;
		font-size: 4rem;
		font-weight: 700;
		line-height: 1;
		color: var(--heading);
	}

	.model {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		margin: 0;
		font-size: var(--step-2);
		font-weight: 600;
		color: var(--accent-ink);
	}

	.field input {
		width: min(16rem, 70vw);
		padding: 0.7rem 1rem;
		border: 2px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step-2);
		text-align: center;
	}

	.field input:focus {
		outline: none;
		border-color: var(--navy);
	}

	.field.right input {
		border-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
	}

	.field.wrong input {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
	}

	.verdict {
		min-height: 1.4em;
		margin: 0;
		font-weight: 600;
		color: var(--ink-muted);
	}

	/* -- finale -------------------------------------------------------------- */

	.words {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(5.2rem, 1fr));
		gap: 0.45rem;
		width: 100%;
		margin: 0.4rem 0 0;
		padding: 0;
		list-style: none;
	}

	.words button {
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 100%;
		padding: 0.45rem 0.3rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font: inherit;
		cursor: pointer;
	}

	.words button:hover {
		border-color: var(--accent);
	}

	.words .d {
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	.words .w {
		font-size: var(--step--1);
		color: var(--accent-ink);
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
		white-space: nowrap;
	}

	@media (max-width: 36rem) {
		.card {
			padding: 1.2rem 1rem;
		}
		.cue {
			min-height: 8rem;
		}
		.num {
			min-height: 3.6rem;
		}
	}
</style>
