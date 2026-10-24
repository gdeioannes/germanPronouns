<script lang="ts">
	// The word check: "Which of these words do you know?" It runs in the same
	// one-screen frame as an exercise (the header, the stage, the finished
	// feel), but it is not one of the course's exercises: nothing is marked
	// done, there is no medal, no run and no streak. It ends in an assessment:
	// about how many words, the level to work at, how each level went, and a
	// suggested deck level and pace that one tap puts in place.
	//
	// The rules (how a screen is drawn, when the check climbs or stops, how the
	// made-up words correct the score) are in domain/wordCheck.
	import Seo from '$lib/components/Seo.svelte';
	import PageHelp from '$lib/components/PageHelp.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { onMount, tick } from 'svelte';
	import { announce } from '$lib/a11y.svelte';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { playSound } from '$lib/services/sounds';
	import { breadcrumbLd } from '$lib/seo';
	import { DECK_PACES, DECK_PACE_ORDER, isDeckPace, type DeckPace } from '$lib/domain/deck';
	import {
		LEVEL_MEANING,
		WORD_CHECK_LOG,
		appendLog,
		bankLevels,
		buildScreen,
		checkResult,
		logEntry,
		nextLevel,
		parseLog,
		shownWords,
		type CheckLogEntry,
		type CheckResult,
		type CheckScreen
	} from '$lib/domain/wordCheck';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const levels = $derived(bankLevels(data.bank));
	const courseHref = $derived(`/course/${data.courseId}`);

	/** The deck's own keys (see SwipeDeck): the result writes them to set the deck up. */
	const LEVEL_KEY = 'deck_level';
	const PACE_KEY = 'deck_pace';

	let phase = $state<'intro' | 'screen' | 'result'>('intro');
	let screens = $state<CheckScreen[]>([]);
	const current = $derived(screens.at(-1) ?? null);
	const ticked = $derived(new Set(current?.ticked ?? []));
	let result = $state<CheckResult | null>(null);

	let log = $state<CheckLogEntry[]>([]);
	/** What the deck is set to now: a picked level (null = it works it out) and the pace. */
	let deckLevel = $state<string | null>(null);
	let deckPace = $state<DeckPace>('steady');

	onMount(async () => {
		log = parseLog(await storage.get(WORD_CHECK_LOG));
		deckLevel = await storage.get(LEVEL_KEY);
		const pace = await storage.get(PACE_KEY);
		deckPace = isDeckPace(pace) ? pace : 'steady';
		// "?start" (the deck's card) skips the intro: the card already said it.
		if (new URLSearchParams(window.location.search).has('start')) start();
	});

	const lastCheck = $derived(log.at(-1) ?? null);
	/** The check before this one, for "since last time". */
	const previous = $derived(result ? (log.filter((e) => e.at < result!.at).at(-1) ?? null) : null);

	let stageEl = $state<HTMLElement>();

	async function focusStage() {
		await tick();
		stageEl?.scrollTo({ top: 0 });
		stageEl?.querySelector<HTMLElement>('[data-focus]')?.focus();
	}

	function start() {
		const first = nextLevel(levels, []);
		if (!first) return;
		screens = [buildScreen(data.bank, first, new Set())];
		result = null;
		choosing = false;
		phase = 'screen';
		track('wordcheck_start', {});
		void focusStage();
	}

	function toggle(de: string) {
		const screen = screens.at(-1);
		if (!screen) return;
		screen.ticked = screen.ticked.includes(de) ? screen.ticked.filter((w) => w !== de) : [...screen.ticked, de];
	}

	function next() {
		const level = nextLevel(levels, screens);
		if (level) {
			screens = [...screens, buildScreen(data.bank, level, shownWords(screens))];
			announce(`Screen ${screens.length}. ${screens.at(-1)!.items.length} new words.`);
			void focusStage();
		} else void finish();
	}

	async function finish() {
		const done = checkResult(levels, screens);
		result = done;
		pickLevel = done.level;
		pickPace = done.pace;
		phase = 'result';
		log = appendLog(log, logEntry(done));
		await storage.set(WORD_CHECK_LOG, JSON.stringify(log));
		playSound('complete');
		announce(`Done. About ${done.words} words. Your level: ${done.level}.`);
		track('wordcheck_done', {
			level: done.level ?? '',
			words: done.words,
			pace: done.pace,
			screens: screens.length,
			careful: done.careful ? 1 : 0
		});
		void focusStage();
	}

	// -- the suggestion ------------------------------------------------------
	let choosing = $state(false);
	let pickLevel = $state<string | null>(null);
	let pickPace = $state<DeckPace>('steady');
	let applied = $state(false);

	async function applyToDeck() {
		if (!pickLevel) return;
		await storage.set(LEVEL_KEY, pickLevel);
		await storage.set(PACE_KEY, pickPace);
		track('wordcheck_apply', {
			level: pickLevel,
			pace: pickPace,
			suggested: pickLevel === result?.level && pickPace === result?.pace ? 1 : 0
		});
		applied = true;
		await goto(courseHref);
	}

	const percent = (share: number) => Math.round(share * 100);
	const date = (at: number) => new Date(at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' });
	const number = (n: number) => n.toLocaleString('en-GB');
	/** The article of a noun chip, set apart so the word itself leads. */
	const split = (de: string) => {
		const m = /^(der|die|das) (.+)$/.exec(de);
		return m ? { article: m[1], word: m[2] } : { article: '', word: de };
	};

	const title = 'How many German words do you know?';
	const description =
		'A free two-minute German vocabulary check: tap the words you know, and get your level from A1 to C2, about how many words you know, and where to start.';
</script>

<Seo
	{title}
	{description}
	path="/level-check/words"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Your level', path: '/level-check' },
			{ name: 'Word check', path: '/level-check/words' }
		])
	]}
/>

<div class="screen">
	<header class="top">
		<a class="back" href="/level-check" aria-label="Back to Your level" title="Back to Your level">
			<Icon name="arrowLeft" size="1.15em" />
		</a>
		<span class="kind" aria-hidden="true"><Icon name="words" size="1.1em" /></span>
		<div class="title">
			<p class="where tnum">
				{#if phase === 'screen'}Word check · screen {screens.length}{:else if phase === 'result'}Word check · your result{:else}Word check · no marks{/if}
			</p>
			<h1 lang="de">Wie viele Wörter kennst du?</h1>
		</div>
		<div class="tools">
			<PageHelp topic={page.route.id} />
		</div>
	</header>

	{#if phase === 'screen' && current}
		<!-- How far up the levels the check has climbed: it fills as it goes up,
		     not as screens pass, since the number of screens depends on you. -->
		<div class="climb" aria-hidden="true">
			<span style="width: {((levels.indexOf(current.level) + 1) / levels.length) * 100}%"></span>
		</div>
	{/if}

	<main class="stage" bind:this={stageEl}>
		{#if phase === 'intro'}
			<section class="intro">
				<h2 tabindex="-1" data-focus>{title}</h2>
				<ul class="rules">
					<li><span class="dot" aria-hidden="true">1</span> <span>Tap every word you know: you would understand it if you read it.</span></li>
					<li><span class="dot" aria-hidden="true">2</span> <span><strong>Some words are made up.</strong> Only tap the ones you are sure about.</span></li>
					<li><span class="dot" aria-hidden="true">3</span> <span>The words get harder as you go. It stops when they are out of reach.</span></li>
				</ul>
				<p class="small">About two minutes. No marks, no medals: you get your level, about how many words you know, and a suggestion for your deck.</p>
				{#if lastCheck}
					<p class="last">
						<Icon name="calendar" size="1em" /> Last check, {date(lastCheck.at)}: about <strong class="tnum">{number(lastCheck.words)}</strong> words{#if lastCheck.level}, level <strong>{lastCheck.level}</strong>{/if}.
					</p>
				{/if}
				<button type="button" class="btn start" onclick={start}>
					Start the check <Icon name="arrowRight" size="1em" />
				</button>
			</section>
		{:else if phase === 'screen' && current}
			<section class="check" aria-labelledby="check-q">
				<h2 id="check-q" tabindex="-1" data-focus>Tap the words you know.</h2>
				<ul class="chips">
					{#each current.items as item (item.de)}
						{@const parts = split(item.de)}
						<li>
							<button
								type="button"
								class="chip"
								aria-pressed={ticked.has(item.de)}
								lang="de"
								onclick={() => toggle(item.de)}
							>
								<span class="tick" aria-hidden="true"><Icon name="check" size="0.9em" /></span>
								{#if parts.article}<span class="article">{parts.article}</span>{/if}
								<span class="word">{parts.word}</span>
							</button>
						</li>
					{/each}
				</ul>
			</section>
		{:else if phase === 'result' && result}
			{@const here = result.level}
			<section class="result">
				<p class="eyebrow" tabindex="-1" data-focus>Your result</p>
				<h2 class="headline">
					You know about <span class="big tnum">{number(result.words)}</span> German words
				</h2>
				{#if here}<p class="your-level">Your level: <strong>{here}</strong></p>{/if}
				{#if previous}
					{@const diff = result.words - previous.words}
					<p class="growth" class:up={diff > 0}>
						{diff > 0 ? `+${number(diff)}` : diff < 0 ? `−${number(-diff)}` : 'The same'} words since {date(previous.at)}{#if previous.level && previous.level !== here}&nbsp;({previous.level} → {here}){/if}.
					</p>
				{/if}

				{#if result.careful}
					<p class="careful">
						<Icon name="info" size="1em" />
						<span>You tapped {result.fakes.ticked} of {result.fakes.shown} made-up words, so the result has been lowered to match. Try again and tap only the words you are sure about.</span>
					</p>
				{/if}

				<!-- One bar per level. A level the check showed is solid; one it
				     skipped or never reached is worked out from its neighbours, and
				     drawn lighter with "≈". -->
				<ol class="bars" aria-label="How much of each level you know">
					{#each result.shares as s (s.level)}
						<li class:here={s.level === here} class:estimated={!s.measured}>
							<span class="lv tnum">{s.level}</span>
							<span class="track"><span class="fill" style="width: {percent(s.share)}%"></span></span>
							<span class="pct tnum">{s.measured ? '' : '≈'}{percent(s.share)}%</span>
							{#if s.level === here}<span class="marker">↑ you are here: start learning at this level</span>{/if}
						</li>
					{/each}
				</ol>
				<p class="small legend"><span class="key solid"></span> words shown <span class="key light"></span> worked out from the levels around it</p>

				<p class="fakes" class:ok={!result.careful}>
					Made-up words tapped: <strong class="tnum">{result.fakes.ticked} of {result.fakes.shown}</strong>
					{#if !result.careful}<span class="ok-tag"><Icon name="check" size="0.9em" /> honest</span>{/if}
				</p>

				{#if here}
					<h3>What this means</h3>
					<p>{LEVEL_MEANING[here]}</p>
				{/if}

				{#if result.toLearn.length}
					<h3>Words to learn next</h3>
					<ul class="to-learn">
						{#each result.toLearn as w (w.de)}
							<li><span lang="de">{w.de}</span> <span class="en">{w.en}</span></li>
						{/each}
					</ul>
					{#if here && data.decks[here]}
						<p><a class="inline-link" href="/course/{data.courseId}/quiz/{data.decks[here]}">Practise the {here} words as flashcards <Icon name="arrowRight" size="1em" /></a></p>
					{/if}
				{/if}

				<!-- The suggestion: a level and a pace for the deck, one tap away. -->
				<div class="suggest">
					<p class="eyebrow">Our suggestion</p>
					<p class="pick">
						Level <strong>{pickLevel ?? '–'}</strong> · <strong>{DECK_PACES[pickPace].label}</strong>
					</p>
					<p class="small">{DECK_PACES[pickPace].blurb}
						{#if deckLevel && deckLevel !== pickLevel}Your deck is set to {deckLevel} now.{:else if !deckLevel}Right now your deck works out its level from what you have done.{/if}
					</p>

					{#if choosing}
						<div class="chooser">
							<p class="small strong" id="pick-level">Level</p>
							<div class="lv-grid" role="group" aria-labelledby="pick-level">
								{#each levels as lv (lv)}
									<button type="button" class="lv-btn tnum" aria-pressed={pickLevel === lv} onclick={() => (pickLevel = lv)}>{lv}</button>
								{/each}
							</div>
							<p class="small strong" id="pick-pace">Pace</p>
							<div class="pace-list" role="group" aria-labelledby="pick-pace">
								{#each DECK_PACE_ORDER as p (p)}
									<button type="button" class="pace-btn" aria-pressed={pickPace === p} onclick={() => (pickPace = p)}>
										<strong>{DECK_PACES[p].label}</strong>
										<small>{DECK_PACES[p].blurb}</small>
									</button>
								{/each}
							</div>
						</div>
					{/if}

					<div class="actions">
						<button type="button" class="btn" disabled={!pickLevel || applied} onclick={applyToDeck}>
							<Icon name="cards" size="1em" /> Set up my deck this way
						</button>
						{#if !choosing}
							<button type="button" class="btn btn-ghost" onclick={() => (choosing = true)}>Choose differently</button>
						{/if}
					</div>
				</div>

				<div class="after">
					<button type="button" class="btn btn-ghost" onclick={start}><Icon name="repeat" size="1em" /> Check again</button>
					<a class="btn btn-ghost" href="/level-check"><Icon name="calendar" size="1em" /> Your history</a>
				</div>
			</section>
		{/if}
	</main>

	{#if phase === 'screen' && current}
		<footer class="foot">
			<span class="count tnum" aria-live="polite">{current.ticked.length} tapped</span>
			<button type="button" class="btn" onclick={next}>
				Next <Icon name="arrowRight" size="1em" />
			</button>
		</footer>
	{/if}
</div>

<style>
	/* The exercise frame (see the quiz page): one screen, header, stage. */
	.screen {
		display: flex;
		flex-direction: column;
		height: 100dvh;
		max-width: 46rem;
		margin: 0 auto;
		padding: 0.6rem 1.25rem calc(0.75rem + env(safe-area-inset-bottom));
	}

	.top {
		display: flex;
		align-items: center;
		gap: 0.65rem;
		flex: none;
		padding-bottom: 0.6rem;
		margin-bottom: 0.75rem;
		border-bottom: 1px solid var(--line);
	}

	.back {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.4rem;
		height: 2.4rem;
		flex: none;
		margin-left: -0.4rem;
		border-radius: 50%;
		color: var(--ink-muted);
	}

	.back:hover {
		background: var(--surface-alt);
		color: var(--accent-ink);
	}

	.kind {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		flex: none;
		border-radius: 50%;
		background: #e8efe9;
		color: var(--forest);
	}

	.title {
		flex: 1;
		min-width: 0;
	}

	.where {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	h1 {
		margin: 0.05rem 0 0;
		font-size: var(--step-1);
		line-height: 1.2;
	}

	.tools {
		display: flex;
		flex: none;
	}

	/* How high the check has climbed. */
	.climb {
		flex: none;
		height: 0.4rem;
		margin: -0.35rem 0 0.75rem;
		border-radius: 999px;
		background: var(--surface-alt);
		overflow: hidden;
	}

	.climb span {
		display: block;
		height: 100%;
		border-radius: inherit;
		background: var(--forest);
		transition: width var(--medium, 0.3s) var(--ease-out, ease-out);
	}

	.stage {
		flex: 1;
		min-height: 0;
		overflow-y: auto;
		padding-top: 0.25rem;
	}

	h2 {
		margin: 0 0 0.9rem;
		font-size: var(--step-2);
		line-height: 1.2;
	}

	h2:focus,
	[data-focus]:focus {
		outline: none;
	}

	h3 {
		margin: 1.4rem 0 0.4rem;
		font-size: var(--step-0);
	}

	.small {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.strong {
		font-weight: 700;
		color: var(--heading);
		margin: 0.9rem 0 0.4rem;
	}

	/* -- intro ---------------------------------------------------------------- */

	.rules {
		display: grid;
		gap: 0.7rem;
		margin: 0 0 1rem;
		padding: 0;
		list-style: none;
	}

	.rules li {
		display: flex;
		gap: 0.7rem;
		align-items: flex-start;
	}

	.rules .dot {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.6rem;
		height: 1.6rem;
		flex: none;
		border-radius: 50%;
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-weight: 800;
		font-size: var(--step--1);
	}

	.last {
		display: flex;
		align-items: center;
		gap: 0.45rem;
		padding: 0.6rem 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font-size: var(--step--1);
	}

	.start {
		margin-top: 0.6rem;
	}

	/* -- a screen of chips ---------------------------------------------------- */

	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.chip {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		min-height: 2.75rem;
		padding: 0.45rem 0.95rem;
		border: 1.5px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step-0);
		font-weight: 600;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.chip:hover {
		border-color: var(--forest);
	}

	.chip:active {
		transform: scale(0.97);
	}

	.chip .article {
		font-weight: 500;
		color: var(--ink-muted);
	}

	/* The tick takes no room until the chip is tapped, so chips don't jump. */
	.chip .tick {
		display: none;
	}

	.chip[aria-pressed='true'] {
		border-color: var(--forest);
		background: var(--forest);
		color: #fff;
	}

	.chip[aria-pressed='true'] .article {
		color: rgb(255 255 255 / 0.8);
	}

	.chip[aria-pressed='true'] .tick {
		display: inline-flex;
	}

	.foot {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		flex: none;
		padding-top: 0.75rem;
		border-top: 1px solid var(--line);
	}

	.count {
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink-muted);
	}

	/* -- the result ----------------------------------------------------------- */

	.headline {
		margin: 0.3rem 0 0.2rem;
		font-size: var(--step-1);
		font-weight: 600;
	}

	.big {
		display: block;
		font-family: var(--font-display, inherit);
		font-size: var(--step-4);
		font-weight: 800;
		line-height: 1.05;
		color: var(--heading);
	}

	.your-level {
		margin: 0.2rem 0;
		font-size: var(--step-1);
	}

	.growth {
		margin: 0.2rem 0 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink-muted);
	}

	.growth.up {
		color: var(--right);
	}

	.careful {
		display: flex;
		gap: 0.5rem;
		margin: 1rem 0 0;
		padding: 0.7rem 0.9rem;
		border-radius: var(--radius-sm);
		background: var(--wrong-bg);
		color: var(--wrong);
		font-size: var(--step--1);
	}

	.bars {
		display: grid;
		gap: 0.3rem;
		margin: 1.2rem 0 0.3rem;
		padding: 0;
		list-style: none;
	}

	.bars li {
		display: grid;
		grid-template-columns: 2.6rem 1fr 3.2rem;
		align-items: center;
		gap: 0.6rem;
		font-size: var(--step--1);
	}

	.bars .lv {
		font-weight: 700;
		color: var(--ink-muted);
	}

	.bars .track {
		height: 0.75rem;
		border-radius: 999px;
		background: var(--surface-alt);
		overflow: hidden;
	}

	.bars .fill {
		display: block;
		height: 100%;
		border-radius: inherit;
		background: var(--forest);
	}

	.bars .estimated .fill {
		background: color-mix(in srgb, var(--forest) 35%, var(--surface));
	}

	.bars .pct {
		text-align: right;
		color: var(--ink-muted);
	}

	.bars .here .lv,
	.bars .here .pct {
		color: var(--accent-ink);
	}

	.bars .here .fill {
		background: var(--accent);
	}

	.bars .marker {
		grid-column: 2 / -1;
		margin-top: -0.15rem;
		font-size: 0.72rem;
		font-weight: 700;
		color: var(--accent-ink);
	}

	.legend {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.35rem;
		margin: 0.3rem 0 0;
		font-size: 0.75rem;
	}

	.legend .key {
		display: inline-block;
		width: 1.2rem;
		height: 0.5rem;
		border-radius: 999px;
		background: var(--forest);
	}

	.legend .key.light {
		margin-left: 0.6rem;
		background: color-mix(in srgb, var(--forest) 35%, var(--surface));
	}

	.fakes {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin: 1rem 0 0;
		font-size: var(--step--1);
	}

	.ok-tag {
		display: inline-flex;
		align-items: center;
		gap: 0.2rem;
		padding: 0.1rem 0.55rem;
		border-radius: 999px;
		background: var(--right-bg);
		color: var(--right);
		font-weight: 700;
	}

	.to-learn {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin: 0 0 0.6rem;
		padding: 0;
		list-style: none;
	}

	.to-learn li {
		padding: 0.3rem 0.7rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		font-size: var(--step--1);
	}

	.to-learn [lang='de'] {
		font-weight: 700;
	}

	.to-learn .en {
		color: var(--ink-muted);
	}

	.inline-link {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		font-weight: 700;
		font-size: var(--step--1);
		text-decoration: none;
	}

	.suggest {
		margin: 1.6rem 0 0;
		padding: 1rem 1.1rem 1.1rem;
		border: 1.5px solid var(--accent);
		border-radius: var(--radius);
		background: color-mix(in srgb, var(--accent-soft) 55%, var(--surface));
	}

	.pick {
		margin: 0.25rem 0;
		font-size: var(--step-1);
	}

	.lv-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(3.6rem, 1fr));
		gap: 0.35rem;
	}

	.lv-btn,
	.pace-btn {
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		cursor: pointer;
	}

	.lv-btn {
		padding: 0.45rem 0;
		font-size: var(--step--1);
		font-weight: 700;
	}

	.pace-list {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(12rem, 1fr));
		gap: 0.4rem;
	}

	.pace-btn {
		display: grid;
		gap: 0.1rem;
		padding: 0.55rem 0.75rem;
		text-align: left;
	}

	.pace-btn small {
		color: var(--ink-muted);
	}

	.lv-btn[aria-pressed='true'],
	.pace-btn[aria-pressed='true'] {
		border-color: var(--navy);
		background: var(--navy);
		color: #fff;
	}

	.pace-btn[aria-pressed='true'] small {
		color: rgb(255 255 255 / 0.8);
	}

	.actions,
	.after {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
		margin-top: 1rem;
	}

	.after {
		margin: 1.2rem 0 0.5rem;
	}

	@media (max-width: 36rem) {
		.screen {
			padding: 0.4rem 0.85rem calc(0.6rem + env(safe-area-inset-bottom));
		}
		.top > .kind {
			display: none;
		}
		h1 {
			font-size: var(--step-0);
		}
		.chip {
			min-height: 2.6rem;
			padding: 0.4rem 0.8rem;
		}
	}
</style>
