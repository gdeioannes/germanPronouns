<script lang="ts">
	// "Order the round" — friends shout a number over the music, you show it to
	// the bartender on your fingers, German style (see domain/barTask). The
	// bartender says back what you showed, so a wrong order is heard as well
	// as seen; only the order is redone, nothing is lost. After two wrong
	// orders the finger to stop at lights up.
	import Burst from '../Burst.svelte';
	import Hands from './Hands.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { imageGuard } from './imageGuard';
	import { wrongOrderLine, type BarTaskContent } from '$lib/domain/barTask';
	import type { CallLine } from '$lib/domain/callTask';
	import { announce } from '$lib/a11y.svelte';
	import { react, shakeOn } from '$lib/motion/fx.svelte';
	import ClipControls from './ClipControls.svelte';
	import { playClip, stopClip } from '$lib/services/clips.svelte';
	import { isMuted } from '$lib/services/mute';
	import { track } from '$lib/services/analytics';
	import { untrack } from 'svelte';

	let {
		task,
		locale,
		quizId,
		onFinish,
		onBack
	}: {
		task: BarTaskContent;
		locale: string;
		quizId: string;
		onFinish: () => void;
		onBack: () => void;
	} = $props();

	const rounds = untrack(() => task.rounds);

	let phase = $state<'intro' | 'order' | 'served' | 'done'>('intro');
	let r = $state(0);
	const round = $derived(rounds[r]);

	let count = $state(0);
	let fails = $state(0);
	let run = $state(0);
	let outcome = $state<'right' | 'wrong' | null>(null);
	/** What arrived on the counter, and the bartender's line for it. */
	let served = $state(0);
	let reply = $state<CallLine | null>(null);
	let caption = $state('');
	let heard = $state(false);
	let jokes = 0;

	let showText = $state(false);
	let noScene = $state(false);
	let stageEl = $state<HTMLElement>();
	let burst = $state(0);
	let missKey = $state(0);

	let alive = true;
	$effect(() => () => {
		alive = false;
		stopClip();
	});

	const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

	function listen() {
		void playClip(round.clip.audio, { text: round.clip.de, locale });
	}

	function start() {
		phase = 'order';
		showText = isMuted();
		track('number_task', { quiz: quizId, task: task.id, step: 'open' });
		listen();
	}

	async function order() {
		if (phase !== 'order' || count === 0) return;
		stopClip();
		served = count;
		reply = task.bartender.find((b) => b.count === count) ?? null;
		const right = count === round.answer;
		outcome = right ? 'right' : 'wrong';
		heard = false;
		phase = 'served';
		if (right) {
			run += 1;
			burst += 1;
			caption = '';
			react(true, stageEl, run);
			track('number_task', { quiz: quizId, task: task.id, step: 'round_ok', round: r + 1 });
		} else {
			run = 0;
			missKey += 1;
			caption = wrongOrderLine(task, count, round.answer, jokes++);
			react(false, stageEl);
			track('number_task', { quiz: quizId, task: task.id, step: 'wrong_order', round: r + 1 });
		}
		announce([
			{ text: 'The bartender:' },
			{ text: reply?.de ?? '', lang: locale },
			...(caption ? [{ text: caption }] : [])
		]);
		if (reply) await Promise.all([playClip(reply.audio, { text: reply.de, locale }), sleep(900)]);
		if (!alive) return;
		if (right && r === rounds.length - 1) {
			reply = task.ending;
			announce(task.ending.en);
			await Promise.all([playClip(task.ending.audio, { text: task.ending.de, locale }), sleep(1200)]);
			if (!alive) return;
			phase = 'done';
			track('number_task', { quiz: quizId, task: task.id, step: 'finish' });
			onFinish();
			return;
		}
		heard = true;
	}

	function tryAgain() {
		fails += 1;
		phase = 'order';
		listen();
	}

	function nextRound() {
		r += 1;
		count = 0;
		fails = 0;
		phase = 'order';
		listen();
	}
</script>

<div class="bar">
	{#if phase === 'intro'}
		<section class="card intro">
			{#if noScene}
				<p class="big" aria-hidden="true">🍺🎶</p>
			{:else}
				<img class="scene" src="/img/story/task_bar_round.webp" alt="A crowded bar; the bartender cups a hand to his ear over the music." use:imageGuard={() => (noScene = true)} />
			{/if}
			<p class="story">{task.intro}</p>
			<div class="culture">
				<p class="tip-title">How Germans count</p>
				<p>{task.culture}</p>
				<div class="demo"><Hands count={2} onChange={() => {}} disabled /></div>
				<p class="small">This is two.</p>
			</div>
			<button type="button" class="btn start" onclick={start}>
				<Icon name="volume" size="1.05em" /> To the bar
			</button>
		</section>
	{:else if phase === 'done'}
		<section class="card finale">
			<p class="big" aria-hidden="true">🍻</p>
			<h2>Prost!</h2>
			<p class="lead">Ten beers, ordered without a word of English. You count like a German now.</p>
			<button type="button" class="btn btn-ghost" onclick={onBack}>Back to the tasks</button>
		</section>
	{:else}
		<div class="status">
			<span>Round {r + 1} of {rounds.length}</span>
			<span>{round.clip.name} shout:</span>
		</div>

		<div class="listen">
			<ClipControls id={round.clip.audio} text={round.clip.de} {locale} label="Hear them again" />
			<button type="button" class="toggle" aria-pressed={showText} onclick={() => (showText = !showText)}>
				{showText ? 'Hide' : 'Show'} what they say
			</button>
		</div>
		{#if showText}
			<p class="transcript"><span lang={locale}>{round.clip.de}</span><small>{round.clip.en}</small></p>
		{/if}

		<div class="stage" bind:this={stageEl} use:shakeOn={missKey}>
			<Burst trigger={burst} count={20} />
			<Hands
				{count}
				onChange={(c) => (count = c)}
				hint={fails >= 2 ? round.answer : null}
				disabled={phase !== 'order'}
			/>
			<p class="showing tnum" aria-live="off">You're showing <strong>{count}</strong></p>
		</div>

		{#if phase === 'order'}
			<button type="button" class="btn order" disabled={count === 0} onclick={order}>
				🍺 Show the bartender
			</button>
		{:else}
			<section class="card served" class:wrong={outcome === 'wrong'}>
				<p class="beers" aria-label="{served} beers on the counter">{'🍺'.repeat(served)}</p>
				{#if reply}
					<p class="who">{reply.name}</p>
					<p class="bubble" lang={locale}>{reply.de}</p>
					<p class="en">{reply.en}</p>
					<ClipControls id={reply.audio} text={reply.de} {locale} label="Listen" />
				{/if}
				{#if caption}<p class="caption">{caption}</p>{/if}
				{#if heard}
					{#if outcome === 'wrong'}
						<button type="button" class="btn" onclick={tryAgain}>Try again</button>
					{:else}
						<button type="button" class="btn" onclick={nextRound}>Next round <Icon name="arrowRight" size="1em" /></button>
					{/if}
				{/if}
			</section>
		{/if}
	{/if}
</div>

<style>
	.bar {
		display: flex;
		flex-direction: column;
		gap: 0.8rem;
		width: 100%;
		max-width: 26rem;
		margin: 0 auto;
	}

	.card {
		position: relative;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.6rem;
		padding: 1.25rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		text-align: center;
	}

	.card h2 {
		margin: 0;
		font-size: var(--step-3);
	}

	.big {
		margin: 0;
		font-size: 2.4rem;
		line-height: 1;
	}

	.intro {
		padding-top: 0;
		overflow: hidden;
	}

	.scene {
		width: calc(100% + 2.5rem);
		max-width: none;
		aspect-ratio: 16 / 9;
		object-fit: cover;
		background: var(--surface-alt);
	}

	.story,
	.lead {
		margin: 0;
	}

	.culture {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.4rem;
		width: 100%;
		padding: 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.culture p {
		margin: 0;
		font-size: var(--step--1);
	}

	.tip-title {
		font-weight: 700;
		color: var(--accent-ink);
		text-transform: uppercase;
		letter-spacing: 0.06em;
		font-size: 0.75rem !important;
	}

	.small {
		color: var(--ink-muted);
	}

	/* The example hands, at a size that keeps the intro on one screen. */
	.demo {
		zoom: 0.6;
	}

	.start {
		padding: 0.8rem 1.6rem;
		font-size: var(--step-1);
	}

	.status {
		display: flex;
		justify-content: space-between;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.listen {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 0.5rem;
	}


	.toggle {
		padding: 0.3rem 0.4rem;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		text-decoration: underline;
		cursor: pointer;
	}

	.transcript {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		margin: 0;
		padding: 0.6rem 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font-size: var(--step--1);
	}

	.transcript small,
	.en {
		color: var(--ink-muted);
	}

	.stage {
		position: relative;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.3rem;
		padding: 0.8rem 0 0.5rem;
	}

	.showing {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.showing strong {
		color: var(--heading);
		font-size: var(--step-1);
	}

	.order {
		align-self: center;
		padding: 0.8rem 1.6rem;
		font-size: var(--step-1);
	}

	.beers {
		margin: 0;
		font-size: 1.6rem;
		letter-spacing: 0.05em;
		line-height: 1.3;
	}

	.who {
		margin: 0;
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--right);
	}

	.served.wrong .who {
		color: var(--wrong);
	}

	.bubble {
		margin: 0;
		padding: 0.6rem 0.9rem;
		border-radius: 1rem 1rem 1rem 0.3rem;
		background: var(--surface-alt);
		font-size: var(--step-1);
		font-weight: 600;
		color: var(--heading);
	}

	.en {
		margin: 0;
		font-size: var(--step--1);
	}

	.caption {
		margin: 0.2rem 0 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-2);
		font-weight: 700;
		line-height: 1.2;
		color: var(--wrong);
	}
</style>
