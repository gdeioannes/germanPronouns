<script lang="ts">
	// The placement test (domain/placement): words, grammar, reading, listening,
	// then a level and one tap to start there. About ten minutes. Nothing is
	// marked or counted as an exercise; the result sets the deck's level.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { onMount, tick } from 'svelte';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { tts } from '$lib/services/speech';
	import { announce } from '$lib/a11y.svelte';
	import { breadcrumbLd } from '$lib/seo';
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
	const PARTS: { id: Phase; label: string }[] = [
		{ id: 'words', label: 'Words' },
		{ id: 'grammar', label: 'Grammar' },
		{ id: 'reading', label: 'Reading' },
		{ id: 'listening', label: 'Listening' }
	];
	const partIndex = $derived(PARTS.findIndex((p) => p.id === phase));

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

	// -- 1. words ------------------------------------------------------------
	let screens = $state<CheckScreen[]>([]);
	let wordsLevel = $state<string | null>(null);
	const screen = $derived(screens.at(-1));

	function start() {
		const first = nextLevel(wordLevels, []);
		screens = first ? [buildScreen(data.words, first, new Set())] : [];
		phase = 'words';
		track('placement_start', {});
		void focusTop();
	}

	function toggle(de: string) {
		if (!screen) return;
		screen.ticked = screen.ticked.includes(de) ? screen.ticked.filter((w) => w !== de) : [...screen.ticked, de];
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
		// The word part counts as a word check too, so the history shows it.
		const log = appendLog(parseLog(await storage.get(WORD_CHECK_LOG)), logEntry(result));
		await storage.set(WORD_CHECK_LOG, JSON.stringify(log));
		startGrammar();
	}

	// -- 2. grammar ------------------------------------------------------------
	let answers = $state<GrammarAnswer[]>([]);
	let used = new Set<string>();
	let item = $state<(GrammarItem & { level: string; options: string[] }) | null>(null);

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
		if (!item) return;
		answers = [...answers, { level: item.level, right: choice === item.answer }];
		if (answers.length < GRAMMAR_ITEMS) {
			drawItem();
			void focusTop();
			return;
		}
		gLevel = grammarLevel(levels, answers);
		startText('reading');
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

	function finishText() {
		const score: [number, number] = text
			? [text.questions.filter((q, i) => picks[i] === q.correctIndex).length, text.questions.length]
			: [0, 0];
		if (phase === 'reading') {
			reading = score;
			startText('listening');
		} else {
			listening = score;
			void finish();
		}
	}

	// -- result ----------------------------------------------------------------
	let level = $state<string>('A1.1');
	let chosen = $state<string>('A1.1');

	async function finish() {
		level = placementLevel(levels, wordsLevel, gLevel, reading, listening);
		chosen = level;
		phase = 'result';
		const entry = { at: Date.now(), level, words: wordsLevel, grammar: gLevel, reading, listening };
		const log = [...parsePlacementLog(await storage.get(PLACEMENT_LOG)), entry].slice(-20);
		await storage.set(PLACEMENT_LOG, JSON.stringify(log));
		track('placement_done', { level, words: wordsLevel ?? '', grammar: gLevel, reading: reading[0], listening: listening[0] });
		announce(`Your level: ${level}.`);
		void focusTop();
	}

	async function startHere() {
		await storage.set('deck_level', chosen);
		await storage.set(START_CHOSEN, 'test');
		track('placement_apply', { level: chosen, suggested: chosen === level ? 1 : 0 });
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
		<ol class="steps" aria-label="Parts of the test">
			{#each PARTS as p, i (p.id)}
				<li class:done={i < partIndex} class:now={i === partIndex}><span class="n">{i + 1}</span> {p.label}</li>
			{/each}
		</ol>
	{/if}

	{#if phase === 'intro'}
		<p class="eyebrow">Placement test · about 10 minutes</p>
		<h1 tabindex="-1" data-focus>Find your level</h1>
		<p class="lede">Four short parts, each a little harder when you do well and easier when you don't. At the end you get your level, and the course starts you there.</p>
		<ol class="intro-parts">
			<li><strong>Words</strong> Tap the German words you know. Some are made up: leave those.</li>
			<li><strong>Grammar</strong> Twelve sentences with a gap. Pick the word that fits.</li>
			<li><strong>Reading</strong> One short text and three questions.</li>
			<li><strong>Listening</strong> One recording, up to three plays, three questions.</li>
		</ol>
		<p class="small">Not sure? Choose <em>I don’t know</em> rather than guessing: a lucky guess puts you on a level that is too hard. Nothing is marked, and you can change the level afterwards.</p>
		<button type="button" class="btn" onclick={start}>Start the test <Icon name="arrowRight" size="1em" /></button>
	{:else if phase === 'words' && screen}
		<h1 class="q" tabindex="-1" data-focus>Tap the words you know.</h1>
		<p class="small">Only the ones you are sure about. Some of these words do not exist.</p>
		<ul class="chips">
			{#each screen.items as w (w.de)}
				<li>
					<button type="button" class="chip" aria-pressed={screen.ticked.includes(w.de)} lang="de" onclick={() => toggle(w.de)}>{w.de}</button>
				</li>
			{/each}
		</ul>
		<button type="button" class="btn" onclick={nextWords}>Next <Icon name="arrowRight" size="1em" /></button>
	{:else if phase === 'grammar' && item}
		<p class="eyebrow">Sentence {answers.length + 1} of {GRAMMAR_ITEMS}</p>
		<p class="sentence" lang="de" tabindex="-1" data-focus>
			{parts(item.sentence)[0]}<span class="gap" aria-label="gap">&nbsp;</span>{parts(item.sentence)[1]}
		</p>
		{#if item.english}<p class="english">{item.english}</p>{/if}
		<div class="options">
			{#each item.options as o (o)}
				<button type="button" class="opt" lang="de" onclick={() => answerGrammar(o)}>{o}</button>
			{/each}
			<button type="button" class="opt idk" onclick={() => answerGrammar(null)}>I don’t know</button>
		</div>
	{:else if (phase === 'reading' || phase === 'listening') && text}
		<p class="eyebrow">{phase === 'reading' ? 'Read the text' : 'Listen to the recording'}</p>
		<h1 class="q" lang="de" tabindex="-1" data-focus>{text.title}</h1>
		{#if phase === 'reading'}
			<div class="passage" lang="de">
				{#each text.text.split('\n').filter(Boolean) as para, i (i)}<p>{para}</p>{/each}
			</div>
		{:else}
			<div class="player">
				<button type="button" class="btn" onclick={play} disabled={playing || plays >= MAX_PLAYS}>
					<Icon name="headphones" size="1em" />
					{playing ? 'Playing…' : plays === 0 ? 'Play the recording' : `Play again (${MAX_PLAYS - plays} left)`}
				</button>
				<p class="small">Listen first, then answer. The text is not shown: that is the test.</p>
			</div>
		{/if}
		<ol class="questions">
			{#each text.questions as q, qi (qi)}
				<li>
					<p class="question" lang="de">{q.question}</p>
					<div class="choices" role="radiogroup" aria-label={q.question}>
						{#each q.options as o, oi (oi)}
							<button type="button" class="choice" role="radio" aria-checked={picks[qi] === oi} lang="de" onclick={() => (picks[qi] = oi)}>{o}</button>
						{/each}
						<button type="button" class="choice idk" role="radio" aria-checked={picks[qi] === -1} onclick={() => (picks[qi] = -1)}>I don’t know</button>
					</div>
				</li>
			{/each}
		</ol>
		<button type="button" class="btn" disabled={picks.some((p) => p === null)} onclick={finishText}>
			{phase === 'reading' ? 'Next: listening' : 'See my level'} <Icon name="arrowRight" size="1em" />
		</button>
	{:else if phase === 'result'}
		<p class="eyebrow">Your result</p>
		<h1 tabindex="-1" data-focus>Start at <span class="lv">{level}</span></h1>
		<p class="lede">{LEVEL_MEANING[level] ?? ''}</p>
		<dl class="parts">
			<div><dt>Words</dt><dd>{wordsLevel ?? '–'}</dd></div>
			<div><dt>Grammar</dt><dd>{gLevel}</dd></div>
			<div><dt>Reading</dt><dd>{reading[0]} of {reading[1]}</dd></div>
			<div><dt>Listening</dt><dd>{listening[0]} of {listening[1]}</dd></div>
		</dl>
		<p class="small">Feel it is too easy or too hard? Pick another level: nothing is locked, and you can change it any time in your deck.</p>
		<div class="levels" role="radiogroup" aria-label="Level to start at">
			{#each levels as lv (lv)}
				<button type="button" class="lv-btn tnum" role="radio" aria-checked={chosen === lv} onclick={() => (chosen = lv)}>{lv}</button>
			{/each}
		</div>
		<button type="button" class="btn" onclick={startHere}>Start learning at {chosen} <Icon name="arrowRight" size="1em" /></button>
		<p class="small"><button type="button" class="btn-quiet" onclick={start}>Take the test again</button></p>
	{/if}
</main>

<style>
	.test {
		max-width: 44rem;
		padding-bottom: 4rem;
	}

	h1 {
		margin: 0.3rem 0 0.6rem;
	}

	.lv {
		color: var(--accent-ink);
	}

	.steps {
		display: flex;
		gap: 0.4rem;
		list-style: none;
		margin: 0.5rem 0 1.5rem;
		padding: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.steps li {
		flex: 1;
		padding: 0.35rem 0.5rem;
		border-bottom: 3px solid var(--line);
	}

	.steps li.done {
		border-color: var(--accent);
	}

	.steps li.now {
		border-color: var(--heading);
		color: var(--heading);
		font-weight: 700;
	}

	.steps .n {
		font-weight: 800;
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
		font-size: var(--step-2);
	}

	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		list-style: none;
		margin: 1rem 0 1.5rem;
		padding: 0;
	}

	.chip,
	.opt,
	.choice,
	.lv-btn {
		padding: 0.55rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: 0.6rem;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		cursor: pointer;
	}

	.chip[aria-pressed='true'],
	.choice[aria-checked='true'],
	.lv-btn[aria-checked='true'] {
		border-color: var(--heading);
		background: var(--heading);
		color: var(--surface);
	}

	.sentence {
		margin: 1rem 0 0.3rem;
		font-family: var(--font-display, serif);
		font-size: var(--step-2);
		line-height: 1.4;
	}

	.gap {
		display: inline-block;
		min-width: 4.5rem;
		margin: 0 0.25rem;
		border-bottom: 2px solid var(--accent);
	}

	.english {
		margin: 0 0 1.2rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.options {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 0.6rem;
	}

	.opt {
		padding: 0.9rem;
		font-size: var(--step-0);
		text-align: center;
	}

	.opt:hover,
	.choice:hover,
	.chip:hover {
		border-color: var(--heading);
	}

	.idk {
		color: var(--ink-muted);
	}

	.options .idk {
		grid-column: 1 / -1;
	}

	.passage {
		margin: 0.5rem 0 1.5rem;
		padding: 1rem 1.2rem;
		border-left: 3px solid var(--accent);
		background: var(--surface);
		line-height: 1.6;
	}

	.passage p {
		margin: 0 0 0.6rem;
	}

	.player {
		margin: 0.5rem 0 1.5rem;
	}

	.questions {
		display: grid;
		gap: 1.2rem;
		margin: 0 0 1.5rem;
		padding-left: 1.2rem;
	}

	.question {
		margin: 0 0 0.4rem;
		font-weight: 700;
	}

	.choices {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
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

	.levels {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin: 0.6rem 0 1.2rem;
	}

	.lv-btn {
		padding: 0.4rem 0.7rem;
	}

	@media (max-width: 40rem) {
		.options {
			grid-template-columns: minmax(0, 1fr);
		}
		.parts {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
		.steps {
			font-size: 0.7rem;
		}
	}
</style>
