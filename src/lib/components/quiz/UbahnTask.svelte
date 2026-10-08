<script lang="ts">
	// "Last U-Bahn home" — 2 a.m., an announcement names the platform, you run
	// to the right sign. The signs pair the answer with its sound-alikes
	// (zwei/drei, sechs/sieben, vier/fünf), and the platform keeps changing,
	// as it does at night. A wrong platform gets a joke and the announcement
	// again; after two misses the right sign lights up.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { imageGuard } from './imageGuard';
	import type { UbahnTaskContent } from '$lib/domain/ubahnTask';
	import { announce } from '$lib/a11y.svelte';
	import { react, shakeOn } from '$lib/motion/fx.svelte';
	import ClipControls from './ClipControls.svelte';
	import EmojiText from './EmojiText.svelte';
	import { NUMBER_WORDS } from '$lib/domain/emojiText';
	import { playClip, playSfx, stopClip } from '$lib/services/clips.svelte';
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
		task: UbahnTaskContent;
		locale: string;
		quizId: string;
		onFinish: () => void;
		onBack: () => void;
	} = $props();

	const rounds = untrack(() => task.rounds);

	let phase = $state<'intro' | 'pick' | 'made' | 'missed' | 'leaving' | 'done'>('intro');
	let r = $state(0);
	/** How many trains show the number word on their signs. */
	const SPELLED_ROUNDS = 2;
	const spelled = $derived(r < SPELLED_ROUNDS);
	const round = $derived(rounds[r]);
	let fails = $state(0);
	let run = $state(0);
	let caption = $state('');
	let picked = $state<string | null>(null);
	let jokes = 0;

	let showText = $state(false);
	let noScene = $state(false);
	let burst = $state(0);
	let shakes = $state<Record<string, number>>({});
	let signsEl = $state<HTMLElement>();

	/** The station clock: two minutes to go, a little less each platform. */
	const clock = $derived(`02:0${4 + r}`);

	let alive = true;
	$effect(() => () => {
		alive = false;
		stopClip();
	});

	const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

	async function listen() {
		stopClip();
		await playSfx('ubahn_chime', 0.6);
		if (!alive) return;
		await playClip(round.clip.audio, { text: round.clip.de, locale });
	}

	function start() {
		phase = 'pick';
		showText = isMuted();
		track('number_task', { quiz: quizId, task: task.id, step: 'open' });
		void listen();
	}

	async function pick(platform: string, sign: HTMLElement) {
		if (phase !== 'pick') return;
		picked = platform;
		if (platform === round.answer) {
			stopClip();
			run += 1;
			burst += 1;
			react(true, sign, run);
			phase = 'made';
			announce(`Platform ${platform}. You made it.`);
			track('number_task', { quiz: quizId, task: task.id, step: 'round_ok', round: r + 1 });
			await sleep(1100);
			if (!alive) return;
			if (r === rounds.length - 1) {
				phase = 'leaving';
				await Promise.all([playClip(task.ending.audio, { text: task.ending.de, locale }), sleep(1600)]);
				if (!alive) return;
				phase = 'done';
				track('number_task', { quiz: quizId, task: task.id, step: 'finish' });
				onFinish();
				return;
			}
			r += 1;
			fails = 0;
			picked = null;
			phase = 'pick';
			void listen();
		} else {
			run = 0;
			fails += 1;
			shakes[platform] = (shakes[platform] ?? 0) + 1;
			react(false, sign);
			caption = task.wrong[jokes++ % task.wrong.length];
			phase = 'missed';
			announce(`Wrong platform. ${caption}`);
			track('number_task', { quiz: quizId, task: task.id, step: 'wrong_platform', round: r + 1 });
		}
	}

	function tryAgain() {
		picked = null;
		phase = 'pick';
		void listen();
	}
</script>

<div class="ubahn">
	{#if phase === 'intro'}
		<section class="card intro">
			{#if noScene}
				<p class="big" aria-hidden="true">🚇🌙</p>
			{:else}
				<img class="scene" src="/img/story/task_ubahn_night.webp" alt="An empty U-Bahn platform at night, a train's headlights in the tunnel." use:imageGuard={() => (noScene = true)} />
			{/if}
			<p class="story">{task.intro}</p>
			<button type="button" class="btn start" onclick={start}>
				<Icon name="volume" size="1.05em" /> Listen to the announcement
			</button>
		</section>
	{:else if phase === 'done'}
		<section class="card finale">
			<p class="big" aria-hidden="true">🚇🏠</p>
			<h2>Zurückbleiben, bitte!</h2>
			<p class="lead">The doors close behind you. Four platform changes, all caught by ear. You're going home.</p>
			<button type="button" class="btn btn-ghost" onclick={onBack}>Back to the tasks</button>
		</section>
	{:else}
		<div class="status">
			<span>Train {r + 1} of {rounds.length} · to Pankow</span>
			<span class="clock tnum">{clock}</span>
		</div>

		<div class="listen">
			<ClipControls id={round.clip.audio} text={round.clip.de} {locale} label="Announcement" />
			<button type="button" class="toggle" aria-pressed={showText} onclick={() => (showText = !showText)}>
				{showText ? 'Hide' : 'Show'} what it says
			</button>
		</div>
		{#if showText}
			<p class="transcript"><EmojiText text={round.clip.de} lang={locale} /><small>{round.clip.en}</small></p>
		{/if}

		<!-- The first trains' signs spell the number out, to match against what
		     you hear; the last ones are by ear alone. -->
		<p class="ask">{spelled ? 'Which platform? Run!' : 'No help now: by ear only. Run!'}</p>
		<div class="signs" bind:this={signsEl} role="group" aria-label="Platforms">
			{#each round.options as platform (r + ':' + platform)}
				<div class="cell">
					{#if phase === 'made' && platform === round.answer}<Burst trigger={burst} count={18} />{/if}
					<button
						type="button"
						class="sign"
						class:right={phase !== 'pick' && phase !== 'missed' && platform === round.answer}
						class:wrong={phase === 'missed' && platform === picked}
						class:hint={fails >= 2 && phase === 'pick' && platform === round.answer}
						disabled={phase !== 'pick'}
						aria-label="Gleis {platform}"
						use:shakeOn={shakes[platform] ?? 0}
						onclick={(e) => pick(platform, e.currentTarget)}
					>
						<span class="u" aria-hidden="true">U</span>
						<span class="gleis" aria-hidden="true">Gleis</span>
						<span class="num tnum" aria-hidden="true">{platform}</span>
						{#if spelled}<span class="word" lang={locale} aria-hidden="true">{NUMBER_WORDS[Number(platform)]}</span>{/if}
					</button>
				</div>
			{/each}
		</div>

		{#if phase === 'missed'}
			<section class="card missed">
				<p class="caption">{caption}</p>
				<button type="button" class="btn" onclick={tryAgain}>Listen again</button>
			</section>
		{:else if phase === 'made' || phase === 'leaving'}
			<p class="made">
				{phase === 'leaving' ? 'The train is in! 🚇' : `Gleis ${round.answer}! ✓`}
			</p>
		{/if}
	{/if}
</div>

<style>
	.ubahn {
		display: flex;
		flex-direction: column;
		gap: 0.8rem;
		width: 100%;
		max-width: 26rem;
		margin: 0 auto;
	}

	.card {
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

	.start {
		padding: 0.8rem 1.4rem;
		font-size: var(--step-0);
	}

	.status {
		display: flex;
		justify-content: space-between;
		align-items: center;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	/* The platform clock: an orange dot-matrix glow on black. */
	.clock {
		padding: 0.15rem 0.55rem;
		border-radius: 0.35rem;
		background: #111;
		color: #ffb020;
		font-family: ui-monospace, monospace;
		font-weight: 700;
		letter-spacing: 0.08em;
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

	.transcript small {
		color: var(--ink-muted);
	}

	.ask {
		margin: 0.3rem 0 0;
		text-align: center;
		font-weight: 700;
		color: var(--heading);
	}

	.signs {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 0.6rem;
	}

	.cell {
		position: relative;
		display: flex;
	}

	/* A Berlin platform sign: the blue U, then the platform number. */
	.sign {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.15rem;
		padding: 0.7rem 0.3rem 0.8rem;
		border: 3px solid #1d4f91;
		border-radius: var(--radius-sm);
		background: #fff;
		color: #1d4f91;
		font: inherit;
		cursor: pointer;
		box-shadow: 0 4px 0 #1d4f91;
		transition:
			transform var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.sign:hover:not(:disabled) {
		transform: translateY(-2px);
	}

	.sign:active:not(:disabled) {
		transform: translateY(3px);
		box-shadow: 0 1px 0 #1d4f91;
	}

	.sign:disabled {
		cursor: default;
	}

	.u {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.6rem;
		height: 1.6rem;
		border-radius: 0.25rem;
		background: #1d4f91;
		color: #fff;
		font-weight: 800;
	}

	.gleis {
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}

	.num {
		font-size: var(--step-4);
		font-weight: 800;
		line-height: 1;
	}

	.word {
		font-size: 0.85rem;
		font-weight: 700;
	}

	.sign.right {
		border-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
		box-shadow: 0 4px 0 var(--right);
	}

	.sign.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
		box-shadow: 0 4px 0 var(--wrong);
	}

	.sign.hint {
		border-color: var(--right);
		box-shadow:
			0 4px 0 var(--right),
			0 0 0 5px var(--right-bg);
	}

	.caption {
		margin: 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-2);
		font-weight: 700;
		line-height: 1.2;
		color: var(--wrong);
	}

	.made {
		margin: 0;
		text-align: center;
		font-size: var(--step-2);
		font-weight: 700;
		color: var(--right);
	}
</style>
