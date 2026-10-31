<script lang="ts">
	// The placement test (domain/placement): words, grammar, reading, listening,
	// then a level and one tap to start there. About ten minutes. Nothing is
	// marked or counted as an exercise; the result sets the deck's level.
	//
	// This is many learners' first screen after /start, so it wears the app's
	// own clothes: each question sits on a deck-style card (the next card
	// peeking out underneath), the progress strip is the twelve-stop level line
	// itself — the marker drifts as the adaptive staircase moves, answering
	// "how far am I?" and "where am I landing?" with one element — the walker
	// and dachshund from /start cross the page as the test advances, and a
	// short interstitial beat separates the parts. "Skip the rest" at any
	// point lands on the result with a best guess and the level picker.
	import Seo from '$lib/components/Seo.svelte';
	import QuizChoices from '$lib/components/quiz/QuizChoices.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { onMount, tick } from 'svelte';
	import { fly, fade } from 'svelte/transition';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { tts } from '$lib/services/speech';
	import { announce } from '$lib/a11y.svelte';
	import { breadcrumbLd } from '$lib/seo';
	import { celebrate, effectsCalm } from '$lib/motion/fx.svelte';
	import { playSound } from '$lib/services/sounds';
	import {
		appendLog,
		bankLevels,
		buildScreen,
		checkResult,
		logEntry,
		nextLevel,
		parseLog,
		shownWords,
		LEVEL_MEANING,
		WORD_CHECK_LOG,
		type CheckScreen
	} from '$lib/domain/wordCheck';
	import {
		grammarLevel,
		nextGrammarLevel,
		parsePlacementLog,
		placementLevel,
		GRAMMAR_ITEMS,
		PLACEMENT_LOG,
		START_CHOSEN,
		type GrammarAnswer,
		type GrammarItem,
		type PassageItem
	} from '$lib/domain/placement';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const courseHref = $derived(page.data.site?.courseHref ?? `/course/${data.courseId}`);
	const levels = $derived(data.bank.levels);
	const wordLevels = $derived(bankLevels(data.words));

	type Phase = 'intro' | 'words' | 'grammar' | 'reading' | 'listening' | 'result';
	let phase = $state<Phase>('intro');
	const PARTS: { id: Phase; label: string; weight: number }[] = [
		{ id: 'words', label: 'Words', weight: 0.3 },
		{ id: 'grammar', label: 'Grammar', weight: 0.4 },
		{ id: 'reading', label: 'Reading', weight: 0.15 },
		{ id: 'listening', label: 'Listening', weight: 0.15 }
	];
	const partIndex = $derived(PARTS.findIndex((p) => p.id === phase));

	/** Motion lasts this long, or not at all under calm effects / reduced motion. */
	const dur = () => (effectsCalm() ? 0 : 280);

	const shuffle = <T,>(list: T[]): T[] => {
		const out = [...list];
		for (let i = out.length - 1; i > 0; i--) {
			const j = Math.floor(Math.random() * (i + 1));
			[out[i], out[j]] = [out[j], out[i]];
		}
		return out;
	};

	let stage = $state<HTMLElement>();
	async function focusTop() {
		await tick();
		window.scrollTo({ top: 0 });
		stage?.querySelector<HTMLElement>('[data-focus]')?.focus();
	}

	// -- the beat between parts -------------------------------------------------
	// A card fills the stage for a moment: the finished part with a check, the
	// next one named. A tap skips it; calm effects skip it entirely.
	let interlude = $state<{ done: string; next: string } | null>(null);
	let onInterludeEnd = () => {};
	function breakThen(done: string, next: string, go: () => void) {
		playSound('msgIn');
		if (effectsCalm()) return go();
		interlude = { done, next };
		let over = false;
		const proceed = () => {
			if (over) return;
			over = true;
			interlude = null;
			go();
		};
		onInterludeEnd = proceed;
		setTimeout(proceed, 1500);
	}

	// -- 1. words ------------------------------------------------------------
	let screens = $state<CheckScreen[]>([]);
	let wordsLevel = $state<string | null>(null);
	const screen = $derived(screens.at(-1));

	function start() {
		const first = nextLevel(wordLevels, []);
		screens = first ? [buildScreen(data.words, first, new Set())] : [];
		skipped = false;
		answers = [];
		reading = [0, 0];
		listening = [0, 0];
		wordsLevel = null;
		hoverLevel = levels[0];
		phase = 'words';
		track('placement_start', {});
		void focusTop();
	}

	function toggle(de: string) {
		if (!screen) return;
		const off = screen.ticked.includes(de);
		screen.ticked = off ? screen.ticked.filter((w) => w !== de) : [...screen.ticked, de];
		playSound(off ? 'down' : 'up');
	}

	async function nextWords() {
		const level = nextLevel(wordLevels, screens);
		if (level) {
			screens = [...screens, buildScreen(data.words, level, shownWords(screens))];
			announce(`${screens.at(-1)!.items.length} new words.`);
			return focusTop();
		}
		const result = checkResult(wordLevels, screens);
		wordsLevel = result.level;
		hoverLevel = result.level ?? hoverLevel;
		// The word part counts as a word check too, so the history shows it.
		const log = appendLog(parseLog(await storage.get(WORD_CHECK_LOG)), logEntry(result));
		await storage.set(WORD_CHECK_LOG, JSON.stringify(log));
		breakThen('Words', 'Grammar', startGrammar);
	}

	// -- 2. grammar ------------------------------------------------------------
	let answers = $state<GrammarAnswer[]>([]);
	let used = new Set<string>();
	let item = $state<(GrammarItem & { level: string; options: string[] }) | null>(null);
	/** The option just tapped, held highlighted for a beat before the next card. */
	let picked = $state<string | null | undefined>(undefined);

	function drawItem() {
		const level = nextGrammarLevel(levels, wordsLevel ?? levels[1], answers);
		const pool = data.bank.grammar[level] ?? [];
		const fresh = pool.filter((i) => !used.has(i.sentence));
		const pick = shuffle(fresh.length ? fresh : pool)[0];
		used.add(pick.sentence);
		item = { ...pick, level, options: shuffle([pick.answer, ...pick.wrong]) };
	}

	function startGrammar() {
		answers = [];
		used = new Set();
		phase = 'grammar';
		drawItem();
		void focusTop();
	}

	function answerGrammar(choice: string | null) {
		if (!item || picked !== undefined) return;
		picked = choice;
		playSound('up');
		// A beat with the choice lit, so the tap visibly landed; no right/wrong
		// is shown — a placement test acknowledges, it does not mark.
		setTimeout(() => {
			if (!item) return;
			answers = [...answers, { level: item.level, right: choice === item.answer }];
			picked = undefined;
			if (answers.length < GRAMMAR_ITEMS) {
				drawItem();
				void focusTop();
				return;
			}
			gLevel = grammarLevel(levels, answers);
			hoverLevel = gLevel;
			breakThen('Grammar', 'Reading', () => startText('reading'));
		}, dur());
	}

	/** The sentence split round its gap, so the gap can be drawn. */
	const parts = (sentence: string) => sentence.split('____');

	// -- 3 & 4. reading and listening -----------------------------------------
	let gLevel = $state<string>('A1.1');
	let text = $state<PassageItem | null>(null);
	let picks = $state<(number | null)[]>([]);
	let reading = $state<[number, number]>([0, 0]);
	let listening = $state<[number, number]>([0, 0]);
	let plays = $state(0);
	let playing = $state(false);
	const MAX_PLAYS = 3;

	function startText(kind: 'reading' | 'listening') {
		text = (kind === 'reading' ? data.bank.reading : data.bank.listening)[gLevel] ?? null;
		picks = text ? text.questions.map(() => null) : [];
		plays = 0;
		phase = kind;
		if (!text) return finishText();
		void focusTop();
	}

	async function play() {
		if (!text || playing || plays >= MAX_PLAYS) return;
		playing = true;
		plays += 1;
		try {
			await tts.speak(text.text, { locale: data.locale });
		} finally {
			playing = false;
		}
	}

	function pick(qi: number, oi: number) {
		picks[qi] = oi;
		playSound('up');
	}

	function finishText() {
		const score: [number, number] = text
			? [text.questions.filter((q, i) => picks[i] === q.correctIndex).length, text.questions.length]
			: [0, 0];
		if (phase === 'reading') {
			reading = score;
			breakThen('Reading', 'Listening', () => startText('listening'));
		} else {
			listening = score;
			void finish();
		}
	}

	// -- progress ----------------------------------------------------------------
	// Grammar, reading and listening have a fixed number of items; the word part
	// is adaptive (typically five or six screens, at most nine), so its share is
	// estimated against six and squeezed, never full and never moving backwards,
	// until the part actually ends.
	const EXPECTED_WORD_SCREENS = 6;
	const partFraction = (id: Phase, index: number): number => {
		if (partIndex > index || phase === 'result') return 1;
		if (partIndex < index) return 0;
		if (id === 'words') {
			const done = screens.length - 1;
			return done / Math.max(EXPECTED_WORD_SCREENS, done + 1);
		}
		if (id === 'grammar') return answers.length / GRAMMAR_ITEMS;
		const answered = picks.filter((p) => p !== null).length;
		return picks.length ? answered / picks.length : 0;
	};
	const fractions = $derived(PARTS.map((p, i) => partFraction(p.id, i)));
	const progress = $derived(PARTS.reduce((sum, p, i) => sum + p.weight * fractions[i], 0));
	const minutesLeft = $derived(Math.max(1, Math.ceil((1 - progress) * 10)));

	/** Where the test places the learner so far: the stop lit on the level
	 *  line. It moves only when a PART ends — a marker drifting after every
	 *  question pulled the eye away from the questions. */
	let hoverLevel = $state('A1.1');
	const hoverIdx = $derived(Math.max(0, levels.indexOf(hoverLevel)));
	/** Band labels (A1, B1 …) sit under the first stop of each band. */
	const band = (lv: string) => (lv.endsWith('.1') ? lv.slice(0, 2) : '');

	// -- skipping out ----------------------------------------------------------
	/** True when the learner bailed out early: the result is a rough guess. */
	let skipped = $state(false);

	/**
	 * "Skip the rest": straight to the result with whatever the finished parts
	 * said. Mid-words uses the screens so far; mid-grammar the staircase so far;
	 * an unfinished text simply counts as not asked ([0, 0] changes nothing).
	 */
	function skipToResult() {
		skipped = true;
		track('placement_skip', { phase, progress: Math.round(progress * 100) });
		if (phase === 'words' && screens.length > 1) wordsLevel = checkResult(wordLevels, screens).level;
		gLevel = answers.length ? grammarLevel(levels, answers) : (wordsLevel ?? levels[0]);
		if (phase !== 'listening') listening = [0, 0];
		if (phase === 'words' || phase === 'grammar') reading = [0, 0];
		void finish();
	}

	// -- result ----------------------------------------------------------------
	let level = $state<string>('A1.1');
	let chosen = $state<string>('A1.1');

	async function finish() {
		level = placementLevel(levels, wordsLevel, gLevel, reading, listening);
		chosen = level;
		phase = 'result';
		if (!skipped) {
			const entry = { at: Date.now(), level, words: wordsLevel, grammar: gLevel, reading, listening };
			const log = [...parsePlacementLog(await storage.get(PLACEMENT_LOG)), entry].slice(-20);
			await storage.set(PLACEMENT_LOG, JSON.stringify(log));
			track('placement_done', { level, words: wordsLevel ?? '', grammar: gLevel, reading: reading[0], listening: listening[0] });
			celebrate(`${level}!`);
		}
		announce(`Your level: ${level}.`);
		void focusTop();
	}

	async function startHere() {
		await storage.set('deck_level', chosen);
		await storage.set(START_CHOSEN, 'test');
		track('placement_apply', { level: chosen, suggested: chosen === level ? 1 : 0, skipped: skipped ? 1 : 0 });
		await goto(courseHref);
	}

	// Leaving mid-test is fine, but a word on the way out avoids losing it by accident.
	onMount(() => {
		const warn = (e: BeforeUnloadEvent) => {
			if (phase !== 'intro' && phase !== 'result') e.preventDefault();
		};
		window.addEventListener('beforeunload', warn);
		return () => window.removeEventListener('beforeunload', warn);
	});
</script>

<Seo
	title="German placement test: find your level | Language Quiz"
	description="A free ten-minute German placement test from A1 to C2: words, grammar, reading and listening, and the level to start learning at."
	path="/level-check/test"
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Your level', path: '/level-check' }, { name: 'Placement test', path: '/level-check/test' }])]}
/>

<SiteNav {courseHref} compact />

<main class="page test" bind:this={stage}>
	{#if partIndex >= 0}
		<!-- The level line: twelve stops, the lit one is where the staircase is
		     hovering right now. The same line the result's picker draws. -->
		<div class="line" aria-hidden="true">
			<div class="track"></div>
			{#each levels as lv, i (lv)}
				<span class="stop" class:passed={i < hoverIdx} class:here={i === hoverIdx} style="left: {(i / (levels.length - 1)) * 100}%">
					{#if i === hoverIdx}
						<span class="lv-now tnum">{lv}</span>
					{:else if band(lv)}
						<span class="lv-band tnum">{band(lv)}</span>
					{/if}
				</span>
			{/each}
		</div>
		<p
			class="line-meta"
			role="progressbar"
			aria-valuenow={Math.round(progress * 100)}
			aria-valuemin="0"
			aria-valuemax="100"
			aria-label="Test progress"
		>
			<span>Hovering around <b class="tnum">{hoverLevel}</b></span>
			<span>{PARTS[partIndex].label} · part {partIndex + 1} of 4 · about {minutesLeft} min left</span>
		</p>
	{/if}

	{#if interlude}
		<button type="button" class="interlude" onclick={() => onInterludeEnd()} in:fade={{ duration: 150 }}>
			<span class="done"><Icon name="check" size="1.1em" /> {interlude.done}</span>
			<span class="up-next">Next: {interlude.next}</span>
			<span class="tap-hint">tap to continue</span>
		</button>
	{:else if phase === 'intro'}
		<div in:fly={{ y: 16, duration: dur() }}>
			<p class="eyebrow">Placement test · about 10 minutes</p>
			<h1 tabindex="-1" data-focus>Find your level</h1>
			<p class="lede">Four short parts, each a little harder when you do well and easier when you don't. At the end you get your level, and the course starts you there.</p>
			<ol class="intro-parts">
				<li><strong>Words</strong> Tap the German words you know. Some are made up: leave those.</li>
				<li><strong>Grammar</strong> Twelve sentences with a gap. Pick the word that fits.</li>
				<li><strong>Reading</strong> One short text and three questions.</li>
				<li><strong>Listening</strong> One recording, up to three plays, three questions.</li>
			</ol>
			<p class="small">Not sure? Choose <em>I don’t know</em> rather than guessing: a lucky guess puts you on a level that is too hard. Nothing is marked, and you can skip out at any point and pick a level yourself.</p>
			<button type="button" class="btn" onclick={start}>Start the test <Icon name="arrowRight" size="1em" /></button>
		</div>
	{:else if phase === 'words' && screen}
		{#key screens.length}
			<div class="qcard" in:fly={{ x: 28, duration: dur() }}>
				<span class="count tnum">screen {screens.length}</span>
				<p class="eyebrow">Tap the words you know</p>
				<p class="small">Only the ones you are sure about. Some of these words do not exist.</p>
				<ul class="chips">
					{#each screen.items as w (w.de)}
						<li>
							<button type="button" class="chip" aria-pressed={screen.ticked.includes(w.de)} lang="de" onclick={() => toggle(w.de)}>{w.de}</button>
						</li>
					{/each}
				</ul>
			</div>
		{/key}
		<div class="actions">
			<button type="button" class="btn" onclick={nextWords}>Next <Icon name="arrowRight" size="1em" /></button>
		</div>
	{:else if phase === 'grammar' && item}
		{#key answers.length}
			<div class="qcard" in:fly={{ x: 28, duration: dur() }}>
				<span class="count tnum">{answers.length + 1} / {GRAMMAR_ITEMS}</span>
				<p class="eyebrow">Fill the gap</p>
				<p class="sentence" lang="de" tabindex="-1" data-focus>
					{parts(item.sentence)[0]}<span class="gap" aria-label="gap">&nbsp;</span>{parts(item.sentence)[1]}
				</p>
				{#if item.english}<p class="english">{item.english}</p>{/if}
				<QuizChoices choices={item.options} locale="de" selected={picked} idk="I don’t know" onpick={answerGrammar} />
			</div>
		{/key}
	{:else if (phase === 'reading' || phase === 'listening') && text}
		{#key phase}
			<div class="qcard" in:fly={{ x: 28, duration: dur() }}>
				<p class="eyebrow">{phase === 'reading' ? 'Read the text' : 'Listen to the recording'}</p>
				<h1 class="q" lang="de" tabindex="-1" data-focus>{text.title}</h1>
				{#if phase === 'reading'}
					<div class="passage" lang="de">
						{#each text.text.split('\n').filter(Boolean) as para, i (i)}<p>{para}</p>{/each}
					</div>
				{:else}
					<div class="player">
						<button type="button" class="btn" onclick={play} disabled={playing || plays >= MAX_PLAYS}>
							{#if playing}
								<span class="eq" aria-hidden="true"><i></i><i></i><i></i><i></i></span> Playing…
							{:else}
								<Icon name="headphones" size="1em" />
								{plays === 0 ? 'Play the recording' : 'Play again'}
							{/if}
						</button>
						<span class="plays" aria-label="{MAX_PLAYS - plays} of {MAX_PLAYS} plays left">
							{#each Array(MAX_PLAYS) as _, i (i)}<i class="dot" class:used={i < plays}></i>{/each}
						</span>
						<p class="small">Listen first, then answer. The text is not shown: that is the test.</p>
					</div>
				{/if}
				<ol class="questions">
					{#each text.questions as q, qi (qi)}
						<li>
							<p class="question" lang="de">{q.question}</p>
							<QuizChoices
								radio
								keys={false}
								choices={q.options}
								locale="de"
								label={q.question}
								selected={picks[qi] === null ? undefined : picks[qi] === -1 ? null : q.options[picks[qi]!]}
								idk="I don’t know"
								onpick={(o) => pick(qi, o === null ? -1 : q.options.indexOf(o))}
							/>
						</li>
					{/each}
				</ol>
			</div>
		{/key}
		<div class="actions">
			<button type="button" class="btn" disabled={picks.some((p) => p === null)} onclick={finishText}>
				{phase === 'reading' ? 'Next: listening' : 'See my level'} <Icon name="arrowRight" size="1em" />
			</button>
		</div>
	{:else if phase === 'result'}
		<div in:fly={{ y: 20, duration: dur() }}>
			<p class="eyebrow">{skipped ? 'Our best guess so far' : 'Your result'}</p>
			<h1 tabindex="-1" data-focus class="reveal">
				{skipped ? 'Maybe' : 'Start at'} <span class="lv">{level}</span>
			</h1>
			<p class="lede">
				{#if skipped}
					You skipped part of the test, so this is rough. Pick the level that feels right: nothing is locked.
				{:else}
					{LEVEL_MEANING[level] ?? ''}
				{/if}
			</p>
			<dl class="parts">
				{#each [{ dt: 'Words', dd: wordsLevel ?? '–' }, { dt: 'Grammar', dd: skipped && !answers.length ? '–' : gLevel }, { dt: 'Reading', dd: reading[1] ? `${reading[0]} of ${reading[1]}` : '–' }, { dt: 'Listening', dd: listening[1] ? `${listening[0]} of ${listening[1]}` : '–' }] as part, i (part.dt)}
				<div in:fly={{ y: 12, duration: dur(), delay: dur() ? 150 + i * 90 : 0 }}>
					<dt>{part.dt}</dt>
					<dd>{part.dd}</dd>
				</div>
				{/each}
			</dl>
			<p class="small">
				{skipped ? 'Each step is one sub-level higher.' : 'Feel it is too easy or too hard? Pick another level: you can change it any time in your deck.'}
			</p>
			<div class="levels" role="radiogroup" aria-label="Level to start at">
				{#each levels as lv, i (lv)}
					<button type="button" class="lv-btn tnum" role="radio" aria-checked={chosen === lv} onclick={() => (chosen = lv)}>
						{lv}
						<span class="stair" style="height: {4 + i * 2}px" aria-hidden="true"></span>
					</button>
				{/each}
			</div>
			<p class="meaning small">{LEVEL_MEANING[chosen] ?? ''}</p>
			<div class="actions">
				<button type="button" class="btn" onclick={startHere}>Start learning at {chosen} <Icon name="arrowRight" size="1em" /></button>
			</div>
			<p class="small"><button type="button" class="btn-quiet" onclick={start}>Take the {skipped ? 'full test' : 'test again'}</button></p>
		</div>
	{/if}

	{#if partIndex >= 0 && !interlude}
		<!-- The walker and dachshund from /start cross the page as the test advances. -->
		<div class="journey" aria-hidden="true">
			<svg class="walker" style="left: calc({progress * 100}% - {progress * 72}px)" width="72" height="42" viewBox="0 0 130 52">
				<circle cx="38" cy="12" r="8" fill="var(--accent)" />
				<path d="M38 20 L38 38 M38 26 L28 33 M38 26 L48 32 M38 38 L31 50 M38 38 L46 49" stroke="var(--heading)" stroke-width="3.6" stroke-linecap="round" fill="none" />
				<ellipse cx="86" cy="42" rx="13" ry="5.5" fill="var(--gold, #a9802a)" />
				<circle cx="100" cy="37" r="4.5" fill="var(--gold, #a9802a)" />
				<path d="M78 46 L78 51 M85 47 L85 52 M92 47 L92 52 M97 46 L97 51" stroke="var(--gold, #a9802a)" stroke-width="2.4" stroke-linecap="round" />
				<rect x="80" y="29" width="9" height="7" rx="1.5" fill="var(--heading)" />
			</svg>
		</div>
		<p class="skip-row small">
			In a hurry?
			<button type="button" class="btn-quiet" onclick={skipToResult}>Skip the rest and pick your level</button>
		</p>
	{/if}
</main>

<style>
	.test {
		/* The quiz screen's column, so the cards sit at the same width. */
		max-width: 46rem;
		padding-bottom: 4rem;
	}

	h1 {
		margin: 0.3rem 0 0.6rem;
	}

	/* -- the result reveal -------------------------------------------------- */

	.lv {
		display: inline-block;
		color: var(--accent-ink);
	}

	.reveal .lv {
		animation: lv-pop 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both;
		animation-delay: 0.15s;
	}

	@keyframes lv-pop {
		from {
			opacity: 0;
			transform: scale(0.4);
		}
		60% {
			transform: scale(1.15);
		}
		to {
			opacity: 1;
			transform: scale(1);
		}
	}

	:global(html[data-effects='calm']) .reveal .lv {
		animation: none;
	}

	@media (prefers-reduced-motion: reduce) {
		.reveal .lv {
			animation: none;
		}
	}

	/* -- the level line ------------------------------------------------------ */

	.line {
		position: relative;
		height: 2.6rem;
		margin: 1.4rem 0 0;
	}

	.track {
		position: absolute;
		top: 50%;
		right: 7px;
		left: 7px;
		height: 3px;
		border-radius: 999px;
		background: var(--line);
	}

	.stop {
		position: absolute;
		top: 50%;
		width: 9px;
		height: 9px;
		border-radius: 50%;
		background: var(--line);
		transform: translate(-50%, -50%);
		transition: background 0.3s ease;
	}

	.stop.passed {
		background: var(--accent);
	}

	.stop.here {
		width: 15px;
		height: 15px;
		background: var(--accent);
		box-shadow: 0 0 0 4px var(--accent-soft, var(--surface-alt));
	}

	.lv-now {
		position: absolute;
		bottom: 100%;
		left: 50%;
		padding-bottom: 0.45rem;
		font-size: var(--step--1);
		font-weight: 800;
		color: var(--accent-ink);
		transform: translateX(-50%);
		white-space: nowrap;
	}

	.lv-band {
		position: absolute;
		top: 100%;
		left: 50%;
		padding-top: 0.45rem;
		font-size: 0.68rem;
		font-weight: 700;
		color: var(--ink-muted);
		transform: translateX(-50%);
	}

	.line-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem 1rem;
		justify-content: space-between;
		margin: 1.1rem 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.line-meta b {
		color: var(--heading);
	}

	/* -- the beat between parts ---------------------------------------------- */

	.interlude {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
		align-items: center;
		justify-content: center;
		width: 100%;
		min-height: 16rem;
		margin: 0.5rem 0;
		padding: 2rem;
		border: 1px solid var(--line);
		border-radius: 1.1rem;
		background: var(--surface);
		font: inherit;
		cursor: pointer;
	}

	.interlude .done {
		display: inline-flex;
		gap: 0.4rem;
		align-items: center;
		font-weight: 700;
		color: var(--accent-ink);
	}

	.interlude .up-next {
		font-family: var(--font-display, serif);
		font-size: var(--step-2);
		font-weight: 700;
		color: var(--heading);
	}

	.interlude .tap-hint {
		margin-top: 0.4rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* -- the question card ----------------------------------------------------- */

	/* The quizzes' card, exactly (see FillBlankQuiz): same padding, same
	   radius, flat on the page — no deck shadow of its own. */
	.qcard {
		position: relative;
		margin: 0.4rem 0 1rem;
		padding: 1.75rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.count {
		position: absolute;
		top: 0.9rem;
		right: 1.1rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink-muted);
	}

	.intro-parts {
		display: grid;
		gap: 0.6rem;
		margin: 1rem 0;
		padding-left: 1.2rem;
	}

	.intro-parts strong {
		display: block;
		color: var(--heading);
	}

	.small {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.q {
		margin-top: 0;
		font-size: var(--step-2);
	}

	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		list-style: none;
		margin: 1rem 0 0.2rem;
		padding: 0;
	}

	.chip,
	.lv-btn {
		padding: 0.55rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: 0.6rem;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		cursor: pointer;
		transition:
			transform 0.12s ease,
			background 0.15s ease,
			border-color 0.15s ease,
			color 0.15s ease;
	}

	.chip:active,
	.lv-btn:active {
		transform: scale(0.94);
	}

	.chip[aria-pressed='true'],
	.lv-btn[aria-checked='true'] {
		border-color: var(--heading);
		background: var(--heading);
		color: var(--surface);
	}

	/* The question card wears the quizzes' type exactly: the terracotta
	   category label and the sentence's serif cut (see FillBlankQuiz). */
	.qcard :global(.eyebrow) {
		color: var(--accent-ink);
	}

	.sentence {
		margin: 0.6rem 0 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-variation-settings: 'opsz' 28;
		font-weight: 600;
		line-height: 2;
		color: var(--ink);
	}

	.gap {
		display: inline-block;
		min-width: 4.5rem;
		margin: 0 0.25rem;
		border-bottom: 2px solid var(--accent);
	}

	.english {
		margin: 0.5rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	/* The answer buttons are QuizChoices — the same component the quizzes use. */

	.chip:hover {
		border-color: var(--heading);
	}

	.passage {
		margin: 0.5rem 0 1.5rem;
		padding: 1rem 1.2rem;
		border-left: 3px solid var(--accent);
		background: var(--surface-alt);
		line-height: 1.6;
	}

	.passage p {
		margin: 0 0 0.6rem;
	}

	/* -- the listening player ------------------------------------------------ */

	.player {
		display: flex;
		flex-wrap: wrap;
		gap: 0.8rem;
		align-items: center;
		margin: 0.5rem 0 1.5rem;
	}

	.player .small {
		flex-basis: 100%;
		margin: 0;
	}

	.eq {
		display: inline-flex;
		gap: 2px;
		align-items: flex-end;
		height: 1em;
	}

	.eq i {
		width: 3px;
		border-radius: 2px;
		background: currentcolor;
		animation: eq-bounce 0.9s ease-in-out infinite;
	}

	.eq i:nth-child(1) {
		animation-delay: 0s;
	}
	.eq i:nth-child(2) {
		animation-delay: 0.22s;
	}
	.eq i:nth-child(3) {
		animation-delay: 0.45s;
	}
	.eq i:nth-child(4) {
		animation-delay: 0.1s;
	}

	@keyframes eq-bounce {
		0%,
		100% {
			height: 30%;
		}
		50% {
			height: 100%;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.eq i {
			height: 60%;
			animation: none;
		}
	}

	.plays {
		display: inline-flex;
		gap: 0.3rem;
	}

	.plays .dot {
		width: 0.5rem;
		height: 0.5rem;
		border-radius: 50%;
		background: var(--accent);
		transition: background 0.3s ease;
	}

	.plays .dot.used {
		background: var(--surface-alt);
	}

	.questions {
		display: grid;
		gap: 1.2rem;
		margin: 0 0 0.4rem;
		padding-left: 1.2rem;
	}

	.question {
		margin: 0 0 0.4rem;
		font-weight: 700;
	}

	.parts {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.6rem;
		margin: 1rem 0;
	}

	.parts div {
		padding: 0.6rem;
		border: 1px solid var(--line);
		border-radius: 0.6rem;
		background: var(--surface);
	}

	.parts dt {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.parts dd {
		margin: 0;
		font-weight: 800;
		color: var(--heading);
	}

	/* -- the level picker as a staircase ------------------------------------- */

	.levels {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		align-items: flex-end;
		margin: 0.6rem 0 0.4rem;
	}

	.lv-btn {
		display: flex;
		flex-direction: column;
		gap: 0.3rem;
		align-items: center;
		padding: 0.4rem 0.55rem 0.35rem;
	}

	.stair {
		width: 100%;
		border-radius: 2px;
		background: var(--surface-alt);
	}

	.lv-btn[aria-checked='true'] .stair {
		background: var(--accent);
	}

	.meaning {
		min-height: 2.4em;
		margin: 0 0 0.6rem;
	}

	/* -- actions that stay reachable ----------------------------------------- */

	.actions {
		position: sticky;
		bottom: 0;
		padding: 0.8rem 0 0.6rem;
		background: linear-gradient(to top, var(--bg) 70%, transparent);
	}

	/* -- the journey strip ----------------------------------------------------- */

	.journey {
		position: relative;
		height: 2.8rem;
		margin-top: 0.6rem;
		border-bottom: 2px dashed var(--line);
	}

	.walker {
		position: absolute;
		bottom: -4px;
		transition: left 0.6s cubic-bezier(0.22, 1, 0.36, 1);
	}

	.skip-row {
		margin-top: 1rem;
	}

	@media (max-width: 40rem) {
		/* The quiz card shrinks the same way on a phone. */
		.qcard {
			padding: 1.1rem 1rem 1rem;
		}
		.sentence {
			font-size: var(--step-1);
			line-height: 1.9;
		}
		.parts {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
		.lv-band {
			font-size: 0.6rem;
		}
	}
</style>
