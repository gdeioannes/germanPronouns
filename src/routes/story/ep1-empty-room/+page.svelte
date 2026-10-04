<script lang="ts">
	// The story player: runs a story episode (assets/content/stories/*.json)
	// as a playable mystery — panels with Maya's narration, evidence quizzes
	// as case actions, a clue notebook, a three-lead hub, credibility and
	// per-playthrough randomization. Design: docs/story_module_schema.md and
	// the dev story bible (/dev/story-bible).
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { celebrate, react } from '$lib/motion/fx.svelte';
	import { isMuted } from '$lib/services/mute';
	import ep from '$content/stories/ep1_empty_room.json';

	type Opt = { text: string; correct: boolean; reply?: string };
	type Beat = Record<string, unknown> & { id: string; type: string };
	type Chapter = (typeof ep.chapters)[number];

	const STORE = `story_${ep.id}`;

	// ---- randomization ------------------------------------------------------
	const poolNames = Object.keys(ep.pools) as (keyof typeof ep.pools)[];
	function freshDraw(): Record<string, number> {
		const draw: Record<string, number> = {};
		// Linked pools (roomNumber / roomNumberDigits …) must draw the same
		// index, so one index is drawn per variant-count group.
		for (const name of poolNames) {
			const len = ep.pools[name].length;
			draw[name] = draw[`len${len}`] ?? Math.floor(Math.random() * len);
			draw[`len${len}`] = draw[name];
		}
		return draw;
	}

	/**
	 * All-zero draw for the server/prerender pass: the page is prerendered
	 * once at build time, so a random draw there would bake one variant into
	 * the HTML while the browser draws another — hydration then shows text
	 * that disagrees with the game's answers. The real draw happens in
	 * load(), client-side only.
	 */
	function zeroDraw(): Record<string, number> {
		return Object.fromEntries(poolNames.map((n) => [n, 0]));
	}

	// ---- persisted state ----------------------------------------------------
	let draw = $state<Record<string, number>>(zeroDraw());
	let doneChapters = $state<string[]>([]);
	let clues = $state<string[]>([]);
	let notebook = $state<{ de: string; en: string }[]>([]);
	let credibility = $state(ep.credibility);
	let finished = $state(false);

	// ---- session state ------------------------------------------------------
	let current = $state<string | null>(null); // chapter id being played
	let beatIndex = $state(0);
	let micro = $state<(typeof ep.microChecks)[number] | null>(null);
	let notebookOpen = $state(false);
	let started = $state(false);

	function save() {
		try {
			localStorage.setItem(
				STORE,
				JSON.stringify({ draw, doneChapters, clues, notebook, finished })
			);
		} catch {
			/* private mode */
		}
	}
	function load() {
		try {
			const raw = localStorage.getItem(STORE);
			if (!raw) {
				draw = freshDraw();
				return;
			}
			const s = JSON.parse(raw);
			draw = s.draw ?? freshDraw();
			doneChapters = s.doneChapters ?? [];
			clues = s.clues ?? [];
			notebook = s.notebook ?? [];
			finished = s.finished ?? false;
		} catch {
			/* ignore */
		}
	}
	$effect(() => load());

	// Starting over wipes everything, so it asks twice: the first tap arms
	// the button for a few seconds, the second one resets.
	let confirmingReset = $state(false);
	let confirmTimer = 0;
	function resetTap() {
		if (!confirmingReset) {
			confirmingReset = true;
			clearTimeout(confirmTimer);
			confirmTimer = window.setTimeout(() => (confirmingReset = false), 3500);
			return;
		}
		clearTimeout(confirmTimer);
		confirmingReset = false;
		restartEpisode();
	}
	function restartEpisode() {
		// Silence everything first — a reset mid-scene left audio running.
		voicePlayer?.pause();
		voicePlayer = null;
		voiceSrc = null;
		voicePlaying = false;
		stopLoop();
		draw = freshDraw();
		doneChapters = [];
		clues = [];
		notebook = [];
		credibility = ep.credibility;
		finished = false;
		current = null;
		beatIndex = 0;
		started = false;
		save();
	}

	// ---- text & asset resolution -------------------------------------------
	function resolve(text: string): string {
		return text
			.replaceAll('{user}', 'partner')
			.replace(/\{pool:([a-zA-Z]+)(?::other(\d))?\}/g, (_, name, other) => {
				const values = ep.pools[name as keyof typeof ep.pools] as string[];
				const i = draw[name] ?? 0;
				const idx = other ? (i + Number(other)) % values.length : i;
				return values[idx];
			});
	}
	const sceneImg = (key: string) => `/${key.replace('story/', 'img/story/')}.webp`;
	function clipFile(key: string): string {
		const m = key.match(/\{pool:([a-zA-Z]+)\}/);
		const base = key.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');
		return `/audio/story/${base}${m ? `_${draw[m[1]]}` : ''}.mp3`;
	}
	function narrationFile(b: Beat): string {
		// Pooled narration was recorded per variant of the FIRST pool in the
		// text (gen-story-audio.mjs does the same), suffixed by its index.
		const m = `${b.text ?? ''}`.match(/\{pool:([a-zA-Z]+)\}/);
		return `/audio/story/ep1_narr_${b.id}${m ? `_${draw[m[1]] ?? 0}` : ''}.mp3`;
	}

	// ---- audio --------------------------------------------------------------
	// The learner owns the mix: music and sound effects each have a toggle in
	// the top bar (persisted), the voice has its own play/pause/replay. Calm
	// effects and the app mute still silence everything.
	const PREFS = `story_prefs`;
	let musicOn = $state(true);
	let soundsOn = $state(true);
	$effect(() => {
		try {
			const p = JSON.parse(localStorage.getItem(PREFS) ?? '{}');
			if (typeof p.music === 'boolean') musicOn = p.music;
			if (typeof p.sounds === 'boolean') soundsOn = p.sounds;
		} catch {
			/* ignore */
		}
	});
	function savePrefs() {
		try {
			localStorage.setItem(PREFS, JSON.stringify({ music: musicOn, sounds: soundsOn }));
		} catch {
			/* ignore */
		}
	}
	function toggleMusic() {
		musicOn = !musicOn;
		savePrefs();
		if (!musicOn) stopLoop();
		else if (current) startLoop(current === ep.hub.unlocks ? 'loop_tension' : 'loop_investigation');
	}
	function toggleSounds() {
		soundsOn = !soundsOn;
		savePrefs();
	}

	const calm = () =>
		typeof document !== 'undefined' && document.documentElement.dataset.effects === 'calm';
	let voicePlayer: HTMLAudioElement | null = null;
	let loopPlayer: HTMLAudioElement | null = null;
	/** What the voice player is holding, and whether it is running. */
	let voiceSrc = $state<string | null>(null);
	let voicePlaying = $state(false);
	function playVoice(src: string) {
		if ((beat as Beat | null)?.kind === 'listening') listened = true;
		if (isMuted()) return;
		voicePlayer?.pause();
		voicePlayer = new Audio(src);
		voiceSrc = src;
		voicePlayer.onended = () => (voicePlaying = false);
		voicePlayer.onpause = () => (voicePlaying = false);
		voicePlayer.onplay = () => (voicePlaying = true);
		voicePlayer.play().catch(() => (voicePlaying = false));
	}
	/** The bar under each spoken line: pause, resume or start over. */
	function voiceToggle(src: string) {
		if (voicePlayer && voiceSrc === src) {
			if (voicePlaying) voicePlayer.pause();
			else voicePlayer.play().catch(() => {});
			return;
		}
		playVoice(src);
	}
	function voiceReplay(src: string) {
		playVoice(src);
	}
	function sfx(name: string, gain = 1) {
		if (isMuted() || calm() || !soundsOn) return;
		const a = new Audio(`/audio/story/sfx/${name}.mp3`);
		a.volume = Math.min(1, 0.8 * gain);
		a.play().catch(() => {});
	}
	function stopLoop() {
		loopPlayer?.pause();
		loopPlayer = null;
	}
	function startLoop(name: string) {
		stopLoop();
		if (isMuted() || calm() || !musicOn) return;
		loopPlayer = new Audio(`/audio/story/sfx/${name}.mp3`);
		loopPlayer.loop = true;
		loopPlayer.volume = 0.18;
		loopPlayer.play().catch(() => {});
	}
	function ambience(name: string | null) {
		if (!name) stopLoop();
		else startLoop(name);
	}
	$effect(() => () => {
		voicePlayer?.pause();
		loopPlayer?.pause();
	});

	// ---- flow ---------------------------------------------------------------
	const chapterById = (id: string) => ep.chapters.find((c) => c.id === id) as Chapter;
	const hubOpen = $derived(doneChapters.includes(ep.hub.afterChapter));
	const finaleUnlocked = $derived(ep.hub.requiredClues.every((c) => clues.includes(c)));
	const linearNext = $derived.by(() => {
		// Chapters before the hub run in order; after the hub the player picks.
		for (const ch of ep.chapters) {
			if (doneChapters.includes(ch.id)) continue;
			if (ep.hub.leads.includes(ch.id) || ch.id === ep.hub.unlocks) return null;
			return ch.id;
		}
		return null;
	});

	function startChapter(id: string) {
		current = id;
		maxReached = 0;
		credibility = ep.credibility;
		started = true;
		resetBeatState();
		ambience(id === ep.hub.unlocks ? 'loop_tension' : 'loop_investigation');
		enterBeat(0, true);
	}
	const chapter = $derived(current ? chapterById(current) : null);
	const beat = $derived(chapter ? (chapter.beats[beatIndex] as Beat) : null);

	/** The furthest beat reached in this chapter — the forward-nav limit. */
	let maxReached = $state(0);
	function enterBeat(index: number, fresh: boolean) {
		beatIndex = index;
		maxReached = Math.max(maxReached, index);
		const b = chapter?.beats[index] as Beat | undefined;
		if (!b) return;
		prepareBeat(b);
		if (b.type === 'narrative') playVoice(b.audio ? clipFile(b.audio as string) : narrationFile(b));
		if (fresh && b.type === 'clue') collectClueCard(b);
	}
	function advance() {
		if (!chapter) return;
		resetBeatState();
		if (beatIndex + 1 < chapter.beats.length) {
			enterBeat(beatIndex + 1, true);
			return;
		}
		finishChapter();
	}
	/** Step back through the chapter to re-read or re-listen. */
	function navBack() {
		if (!chapter || beatIndex === 0) return;
		resetBeatState();
		enterBeat(beatIndex - 1, false);
	}
	/** Step forward again — only through beats already played. */
	function navForward() {
		if (!chapter || beatIndex >= maxReached) return;
		resetBeatState();
		enterBeat(beatIndex + 1, false);
	}
	function collectClueCard(b: Beat) {
		sfx('notebook');
		const entries = b.entries as { de: string; en: string }[];
		for (const e of entries) if (!notebook.some((n) => n.de === e.de)) notebook = [...notebook, e];
		save();
	}
	function finishChapter() {
		if (!chapter) return;
		const id = chapter.id;
		if (!doneChapters.includes(id)) doneChapters = [...doneChapters, id];
		voicePlayer?.pause();
		const clue = (chapter as unknown as Beat).clue as string | undefined;
		if (clue && !clues.includes(clue)) {
			clues = [...clues, clue];
			celebrate('Clue secured!');
			showMayaMoment(
				`Clue ${clue} secured!`,
				clues.length === ep.hub.requiredClues.length
					? '“THAT’S ALL THREE. Get your coat, partner — we’re going to the Pension.”'
					: '“One step closer. The board is FILLING UP, people.”'
			);
		} else {
			sfx('chapter_sting', 0.8);
		}
		current = null;
		ambience(null);
		micro = ep.microChecks.find((m) => m.after === id) ?? null;
		microOpts = micro ? shuffleOpts(micro.options as Opt[]) : [];
		if (id === ep.hub.unlocks) {
			finished = true;
			celebrate('Case closed!');
			showMayaMoment('Case closed!', '“We actually DID it. Best assistant a podcast ever had.”');
		}
		save();
		// No title screen between chapters: when there is no micro-text to
		// show, the next linear chapter starts straight away. The flow only
		// pauses on the hub (the learner picks a lead) and on the end screen.
		if (!micro) proceed();
	}
	/** Carries straight on after a chapter (or its micro-text). */
	function proceed() {
		if (finished) return;
		const next = linearNext;
		if (next) startChapter(next);
	}
	function loseCredibility() {
		credibility -= 1;
		if (credibility === 0) sfx('credibility_lost');
		if (credibility <= 0 && chapter) {
			// The chapter restarts, re-randomized — Maya's reputation can only
			// take so much, and memorized answers die here.
			const id = chapter.id;
			draw = freshDraw();
			save();
			setTimeout(() => startChapter(id), 900);
		}
	}

	// ---- per-beat interaction state ----------------------------------------
	let picked = $state<number | null>(null);
	let clozeAnswers = $state<Record<number, string>>({});
	let clozeChecked = $state(false);
	let dialed = $state<string[]>([]);
	let built = $state<string[]>([]);
	let listened = $state(false);
	let qIndex = $state(0);
	let shuffled = $state<Opt[]>([]);
	function resetBeatState() {
		voicePlayer?.pause();
		picked = null;
		clozeAnswers = {};
		clozeChecked = false;
		dialed = [];
		built = [];
		listened = false;
		qIndex = 0;
		shuffled = [];
		tileOpts = [];
	}
	/** Resolved + shuffled copy of an option list (pure — no state writes). */
	function shuffleOpts(list: Opt[]): Opt[] {
		return list.map((o) => ({ ...o, text: resolve(o.text) })).sort(() => Math.random() - 0.5);
	}
	/**
	 * Shuffles are prepared when a beat is ENTERED, never during render:
	 * writing state from a template expression is forbidden in Svelte 5 and
	 * crashed the whole player (the "Continue does nothing" bug).
	 */
	function prepareBeat(b: Beat | undefined) {
		if (!b || b.type !== 'quiz') return;
		if ((b.kind === 'select' || b.kind === 'recall' || b.kind === 'banter') && Array.isArray(b.options))
			shuffled = shuffleOpts(b.options as Opt[]);
		else if (b.kind === 'listening') shuffled = shuffleOpts(listeningQuestions(b)[0].options);
		else if (b.kind === 'orderedPick' && b.layout !== 'keypad') {
			const base = ((b.options as string[] | undefined) ?? sequenceOf(b)).map((t) => resolve(t));
			tileOpts = [...base].sort(() => Math.random() - 0.5);
		}
	}
	let tileOpts = $state<string[]>([]);
	// ---- celebration --------------------------------------------------------
	// Right answers get the app's full juice (praise word, glow, confetti via
	// FxLayer) plus Maya's own reaction; clues get a "Maya moment" overlay.
	let streak = $state(0);
	const MAYA_CHEERS = [
		'“YES! That’s going in the episode!”',
		'“Ha! My assistant, everyone.”',
		'“Exactly what I would have said. Eventually.”',
		'“The notebook LOVES you.”',
		'“Case brain: activated.”',
		'“Okay that was genuinely impressive.”'
	];
	let mayaMoment = $state<{ img: string; title: string; line: string } | null>(null);
	let mayaTimer = 0;
	function showMayaMoment(title: string, line: string, img = 'maya_pose_clue') {
		mayaMoment = { img, title, line };
		clearTimeout(mayaTimer);
		mayaTimer = window.setTimeout(() => (mayaMoment = null), 2600);
	}
	function cheer(anchor: Element | null) {
		streak += 1;
		react(true, anchor, streak);
		// Every few in a row, Maya herself chimes in.
		if (streak > 0 && streak % 3 === 0)
			showMayaMoment('On a roll!', MAYA_CHEERS[Math.floor(Math.random() * MAYA_CHEERS.length)]);
	}
	function miss(anchor: Element | null) {
		streak = 0;
		react(false, anchor);
	}

	function pick(e: MouseEvent, i: number, critical: boolean) {
		if (picked !== null && shuffled[picked]?.correct) return;
		picked = i;
		const el = e.currentTarget as Element;
		if (shuffled[i].correct) cheer(el);
		else {
			miss(el);
			if (critical) loseCredibility();
		}
	}
	const pickedRight = $derived(picked !== null && shuffled[picked]?.correct);

	// listening beats hold several questions
	function listeningQuestions(b: Beat): { question: string; options: Opt[] }[] {
		return (b.questions as { question: string; options: Opt[] }[]) ?? [];
	}
	function nextQuestion() {
		qIndex += 1;
		picked = null;
		if (beat) shuffled = shuffleOpts(listeningQuestions(beat)[qIndex].options);
	}

	// cloze (inlineCloze + bigText share a shape)
	function clozeOf(b: Beat): { passage: string; blanks: { n: number; options: string[]; answer: string }[] } {
		const q = (b.quiz ?? b) as Beat;
		return { passage: q.passage as string, blanks: q.blanks as { n: number; options: string[]; answer: string }[] };
	}
	const clozeRight = (b: Beat) => clozeOf(b).blanks.every((bl) => clozeAnswers[bl.n] === bl.answer);

	// orderedPick
	function sequenceOf(b: Beat): string[] {
		const s = b.sequence as string | string[];
		const r = Array.isArray(s) ? s : resolve(s).replace(/\s+/g, '').split('');
		return r;
	}
	function keypadPress(d: string, b: Beat) {
		sfx(`dial_${d}`, 0.7);
		dialed = [...dialed, d];
		const seq = sequenceOf(b);
		if (dialed.length === seq.length) {
			if (dialed.join('') === seq.join('')) {
				cheer(null);
				setTimeout(advance, 900);
			} else {
				sfx('busy');
				streak = 0;
				loseCredibility();
				dialed = [];
				if (b.audio) setTimeout(() => playVoice(clipFile(b.audio as string)), 1600);
			}
		}
	}
	function tileTap(t: string, b: Beat) {
		if (built.includes(t)) return;
		built = [...built, t];
		sfx('notebook', 0.6);
		const seq = sequenceOf(b);
		if (built.length === seq.length) {
			if (seq.every((w, i) => built[i] === w)) {
				cheer(null);
				setTimeout(advance, 700);
			} else {
				miss(null);
				if (b.critical) loseCredibility();
				setTimeout(() => (built = []), 600);
			}
		}
	}

	// micro-check interstitial
	let microPicked = $state<number | null>(null);
	let microOpts = $state<Opt[]>([]);
	function microPick(e: MouseEvent, i: number) {
		microPicked = i;
		if (microOpts[i].correct) cheer(e.currentTarget as Element);
		else miss(e.currentTarget as Element);
	}
	function closeMicro() {
		micro = null;
		microPicked = null;
		microOpts = [];
		proceed();
	}

	const progress = $derived(doneChapters.length / ep.chapters.length);
</script>

<Seo title="The Empty Room — Story" description="An interactive German mystery: help Maya find her missing flatmate." path="/story/ep1-empty-room" noindex />

{#snippet voiceBar(src: string, caption: string, big: boolean)}
	{@const active = voiceSrc === src && voicePlaying}
	<div class="voice-bar" class:playing={active} class:big>
		<button class="vb-play" onclick={() => voiceToggle(src)} aria-label={active ? 'Pause' : 'Play'}>
			{#if active}
				<span class="pause-bars" aria-hidden="true"><span></span><span></span></span>
			{:else}
				<Icon name="play" size="1.05em" />
			{/if}
		</button>
		<button class="vb-again" onclick={() => voiceReplay(src)} aria-label="Play again" title="Play again">
			<Icon name="repeat" size="0.95em" />
		</button>
		<span class="vb-eq" class:live={active} aria-hidden="true"><i></i><i></i><i></i><i></i></span>
		<span class="vb-caption">{caption}</span>
	</div>
{/snippet}

<main class="story">
	<!-- top bar: progress, credibility, notebook -->
	<header class="bar">
		<a class="back" href="/course/{ep.course}" aria-label="Back to the course">
			<Icon name="arrowLeft" size="1.15em" />
		</a>
		<div class="bar-title">{ep.title}</div>
		<div class="mics" title="Maya's credibility">
			{#each Array(ep.credibility) as _, i}
				<span class="mic" class:lost={current !== null && i >= credibility}>
					<Icon name="mic" size="0.95em" />
				</span>
			{/each}
		</div>
		<button
			class="mix-btn"
			class:off={!musicOn}
			onclick={toggleMusic}
			title={musicOn ? 'Music on — tap to turn off' : 'Music off — tap to turn on'}
			aria-pressed={musicOn}>
			<Icon name="headphones" size="1.05em" />
		</button>
		<button
			class="mix-btn"
			class:off={!soundsOn}
			onclick={toggleSounds}
			title={soundsOn ? 'Sound effects on — tap to turn off' : 'Sound effects off — tap to turn on'}
			aria-pressed={soundsOn}>
			<Icon name={soundsOn ? 'volume' : 'volumeOff'} size="1.05em" />
		</button>
		<button class="nb-btn" onclick={() => (notebookOpen = !notebookOpen)} aria-expanded={notebookOpen}>
			<Icon name="book" size="1em" />
			<span class="nb-label">Notebook</span>
			{#if notebook.length}<span class="nb-count tnum">{notebook.length}</span>{/if}
		</button>
		<button
			class="mix-btn reset"
			class:arming={confirmingReset}
			onclick={resetTap}
			title={confirmingReset ? 'Tap again to erase all progress and start over' : 'Start the episode from scratch'}
			aria-label={confirmingReset ? 'Tap again to confirm starting over' : 'Start over'}>
			<Icon name={confirmingReset ? 'trash' : 'repeat'} size="1.05em" />
		</button>
	</header>
	<div class="progress"><div class="fill" style:width={`${progress * 100}%`}></div></div>

	{#if mayaMoment}
		<!-- Maya bursts in to celebrate: a toast with her pose and a line. -->
		<aside class="maya-moment" aria-live="polite">
			<img src="/img/story/{mayaMoment.img}.webp" alt="" />
			<div class="mm-text">
				<strong>{mayaMoment.title}</strong>
				<span>{mayaMoment.line}</span>
			</div>
		</aside>
	{/if}

	{#if notebookOpen}
		<aside class="notebook">
			<h2>Maya's notebook</h2>
			{#if !notebook.length}
				<p class="muted">Empty. Clues you find go in here — German words included.</p>
			{:else}
				<ul>
					{#each notebook as e (e.de)}
						<li><strong>{e.de}</strong> — {e.en}</li>
					{/each}
				</ul>
			{/if}
			<button class="btn" onclick={() => (notebookOpen = false)}>Close</button>
		</aside>
	{/if}

	{#if micro}
		<!-- Maya texts between chapters: recall, no scrolling back -->
		<section class="panel micro-panel">
			<p class="from">Maya 💬</p>
			<p class="maya">“{resolve(micro.text)}”</p>
			<p class="q">{resolve(micro.question)}</p>
			<div class="opts">
				{#each microOpts as o, i}
					<button
						class="opt"
						class:right={microPicked === i && o.correct}
						class:wrong={microPicked === i && !o.correct}
						onclick={(e) => microPick(e, i)}>{o.text}</button>
				{/each}
			</div>
			{#if microPicked !== null && microOpts[microPicked].correct}
				<button class="btn" onclick={closeMicro}>Back to the case</button>
			{/if}
		</section>
	{:else if finished && current === null}
		<!-- end screen -->
		<section class="panel end">
			<img class="scene" src={sceneImg('story/ep1_reveal')} alt="The reveal" />
			<h1>Case closed… and wide open</h1>
			<p>
				Jonas: found. Lena: still a mystery. Whatever they're building behind that door — that's
				Episode 2. Maya's notebook keeps {notebook.length} German clues from this case.
			</p>
			<div class="row">
				<button class="btn" onclick={restartEpisode}>Play again (new clues)</button>
				<a class="btn alt" href="/course/{ep.course}">Back to the course</a>
			</div>
		</section>
	{:else if current === null}
		<!-- episode map: linear next, or the hub -->
		<section class="panel">
			{#if !hubOpen}
				<img class="scene" src={sceneImg('story/ep1_room_wide')} alt="The empty room" />
				<h1>{ep.title}</h1>
				<p>{ep.tagline}</p>
				<button class="btn" onclick={() => startChapter(linearNext ?? ep.chapters[0].id)}>
					{doneChapters.length ? 'Continue' : 'Start the episode'}
				</button>
			{:else}
				<h1>Three leads. Your call, partner.</h1>
				<div class="leads">
					{#each ep.hub.leads as id (id)}
						{@const ch = chapterById(id)}
						{@const done = doneChapters.includes(id)}
						<button class="lead" class:done onclick={() => !done && startChapter(id)}>
							<img src={sceneImg((ch.beats.find((b) => (b as Beat).image) as Beat).image as string)} alt={ch.title} />
							<span>{resolve(ch.title)} {done ? `✔ clue ${(ch as unknown as Beat).clue}` : ''}</span>
						</button>
					{/each}
				</div>
				{#if finaleUnlocked && !doneChapters.includes(ep.hub.unlocks)}
					<button class="btn finale" onclick={() => startChapter(ep.hub.unlocks)}>
						All clues collected → Pension Sonnenschein
					</button>
				{:else if !finaleUnlocked}
					<p class="muted">Collect all three clues to find Jonas.</p>
				{/if}
			{/if}
		</section>
	{:else if beat}
		<section class="panel">
			{#if beat.image}
				<img class="scene" src={sceneImg(beat.image as string)} alt="" />
			{/if}

			{#if beat.type === 'narrative'}
				{@const src = beat.audio ? clipFile(beat.audio as string) : narrationFile(beat)}
				{@render voiceBar(src, beat.transcript ? resolve(beat.transcript as string) : 'Maya', false)}
				<p class="maya">“{resolve(beat.text as string)}”</p>
				<button class="btn" onclick={advance}>Continue</button>
			{:else if beat.type === 'clue'}
				{#if beat.intro}<p class="maya">“{resolve(beat.intro as string)}”</p>{/if}
				{@const entries = beat.entries as { de: string; en: string }[]}
				<div class="cluecard">
					<p class="cluetitle">→ into the notebook</p>
					<ul>
						{#each entries as e (e.de)}
							<li><strong>{e.de}</strong> — {e.en}</li>
						{/each}
					</ul>
				</div>
				<button class="btn" onclick={advance}>Noted</button>
			{:else if beat.kind === 'banter'}
				<p class="q">{resolve(beat.question as string)}</p>
				<div class="opts">
					{#each shuffled as o, i}
						<button
							class="opt"
							class:right={picked === i && o.correct}
							class:wrong={picked === i && !o.correct}
							onclick={(e) => pick(e, i, false)}>{o.text}</button>
					{/each}
				</div>
				{#if picked !== null && shuffled[picked].reply}
					<p class="maya banter-reply">MAYA: {shuffled[picked].reply}</p>
				{/if}
				{#if pickedRight}<button class="btn" onclick={advance}>Continue</button>{/if}
			{:else if beat.kind === 'select' || beat.kind === 'recall'}
				{#if beat.audio && beat.transcript}
					{@const src = clipFile(beat.audio as string)}
					<button class="chip" onclick={() => { voiceToggle(src); listened = true; }}>
						{voiceSrc === src && voicePlaying ? '⏸ Pause' : '🔊 Play what she says'}
					</button>
				{/if}
				<p class="q">{resolve(beat.question as string)}</p>
				<div class="opts">
					{#each shuffled as o, i}
						<button
							class="opt"
							class:right={picked === i && o.correct}
							class:wrong={picked === i && !o.correct}
							onclick={(e) => pick(e, i, beat.critical === true)}>{o.text}</button>
					{/each}
				</div>
				{#if pickedRight}<button class="btn" onclick={advance}>Continue</button>{/if}
			{:else if beat.kind === 'listening'}
				{@const recSrc = clipFile(beat.audio as string)}
				{@render voiceBar(recSrc, listened ? 'The recording — replay as often as you like' : 'The recording', true)}
				{#if true}
					{@const qs = listeningQuestions(beat)}
					{@const q = qs[qIndex]}
					<p class="q">{resolve(q.question)}</p>
					<div class="opts">
						{#each shuffled as o, i}
							<button
								class="opt"
								class:right={picked === i && o.correct}
								class:wrong={picked === i && !o.correct}
								onclick={(e) => pick(e, i, beat.critical === true)}>{o.text}</button>
						{/each}
					</div>
					{#if pickedRight}
						{#if qIndex + 1 < qs.length}
							<button class="btn" onclick={nextQuestion}>Next</button>
						{:else}
							<button class="btn" onclick={advance}>Continue</button>
						{/if}
					{/if}
				{/if}
			{:else if beat.kind === 'inlineCloze' || beat.kind === 'bigText'}
				{@const c = clozeOf(beat)}
				{#if beat.prompt}<p class="q">{resolve(beat.prompt as string)}</p>{/if}
				<p class="passage">
					{#each resolve(c.passage).split(/\{(\d)\}/) as part, i}
						{#if i % 2 === 1}
							{@const blank = c.blanks.find((bl) => bl.n === Number(part))}
							<select
								aria-label="Gap {part}"
								aria-invalid={clozeChecked && clozeAnswers[Number(part)] !== blank?.answer ? 'true' : undefined}
								class:right={clozeChecked && clozeAnswers[Number(part)] === blank?.answer}
								class:wrong={clozeChecked && clozeAnswers[Number(part)] !== blank?.answer}
								onchange={(e) => { clozeAnswers[Number(part)] = e.currentTarget.value; clozeChecked = false; }}>
								<option value="">…</option>
								{#each blank?.options ?? [] as o}
									<option value={o}>{o}</option>
								{/each}
							</select>
						{:else}{part}{/if}
					{/each}
				</p>
				{#if clozeChecked && clozeRight(beat)}
					<button class="btn" onclick={advance}>Continue</button>
				{:else}
					<button
						class="btn"
						onclick={(e) => {
							clozeChecked = true;
							if (clozeRight(beat)) cheer(e.currentTarget as Element);
							else {
								miss(e.currentTarget as Element);
								if (beat.critical) loseCredibility();
							}
						}}>Check</button>
				{/if}
			{:else if beat.kind === 'orderedPick' && beat.layout === 'keypad'}
				{#if beat.prompt}<p class="q">{resolve(beat.prompt as string)}</p>{/if}
				<button class="chip" onclick={() => playVoice(clipFile(beat.audio as string))}>🔊 Play the number</button>
				<p class="dial-display">{dialed.join(' ') || '…'}</p>
				<div class="keypad">
					{#each ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] as d}
						<button class="key" onclick={() => keypadPress(d, beat)}>{d}</button>
					{/each}
					<button class="key clear" onclick={() => (dialed = [])}>⌫</button>
				</div>
			{:else if beat.kind === 'orderedPick'}
				{#if beat.prompt}<p class="q">{resolve(beat.prompt as string)}</p>{/if}
				<p class="built">{built.join(' ') || '…'}</p>
				<div class="tiles" class:bubbles={beat.layout === 'bubbles'}>
					{#each tileOpts as t (t)}
						<button class="tile" class:used={built.includes(t)} onclick={() => tileTap(t, beat)}>{t}</button>
					{/each}
				</div>
				<button class="chip" onclick={() => (built = [])}>Start over</button>
			{/if}

			<!-- Step back to re-read or re-listen; forward only through beats
			     already played, so nothing can be skipped unanswered. -->
			<nav class="beat-nav" aria-label="Story navigation">
				<button class="nav-arrow" onclick={navBack} disabled={beatIndex === 0} aria-label="Previous scene">‹</button>
				<span class="nav-count tnum">{beatIndex + 1} / {chapter?.beats.length}</span>
				<button class="nav-arrow" onclick={navForward} disabled={beatIndex >= maxReached} aria-label="Next scene (already seen)">›</button>
			</nav>
		</section>
	{/if}
</main>

<style>
	/* The full-bleed scenes measure 100vw, which includes the scrollbar; the
	   page clips the sliver so no horizontal scroll appears. */
	:global(html:has(.story)) {
		overflow-x: clip;
	}
	.story {
		max-width: 46rem;
		margin: 0 auto;
		padding: 0.75rem 1rem 4rem;
		min-height: 100dvh;
	}
	.bar {
		display: flex;
		align-items: center;
		gap: 0.75rem;
	}
	.back {
		text-decoration: none;
		color: var(--heading);
		width: 2.2rem;
		height: 2.2rem;
		display: grid;
		place-items: center;
		border-radius: 50%;
		transition: background 120ms ease;
	}
	.back:hover {
		background: var(--surface-alt);
	}
	.bar-title {
		font-weight: 600;
		color: var(--heading);
		font-family: 'Source Serif 4 Variable', Georgia, serif;
		font-size: var(--step-1);
		flex: 1;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.mics {
		display: flex;
		gap: 0.2rem;
		color: var(--accent-ink);
		margin-right: 0.25rem;
	}
	.mic {
		display: grid;
		place-items: center;
		transition: opacity 200ms ease;
	}
	.mic.lost {
		opacity: 0.22;
		color: var(--ink-muted);
	}
	.mix-btn {
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--heading);
		border-radius: 50%;
		width: 2.2rem;
		height: 2.2rem;
		cursor: pointer;
		display: grid;
		place-items: center;
		padding: 0;
		transition: border-color 120ms ease, color 120ms ease, opacity 120ms ease;
	}
	.mix-btn:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}
	.mix-btn.reset.arming {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		animation: reset-pulse 0.9s ease-in-out infinite;
	}
	@keyframes reset-pulse {
		50% {
			transform: scale(1.12);
		}
	}
	.mix-btn.off {
		opacity: 0.45;
		color: var(--ink-muted);
	}
	.voice-bar {
		display: inline-flex;
		align-items: center;
		gap: 0.55rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 999px;
		padding: 0.3rem 1.1rem 0.3rem 0.3rem;
		max-width: 100%;
		box-shadow: 0 2px 8px rgb(31 58 95 / 0.08);
		transition: border-color 150ms ease, box-shadow 150ms ease;
	}
	.voice-bar.playing {
		border-color: var(--accent);
		box-shadow: 0 2px 12px rgb(201 104 59 / 0.25);
	}
	.vb-play {
		width: 2.4rem;
		height: 2.4rem;
		border-radius: 50%;
		border: none;
		background: var(--accent-ink);
		color: #fff;
		cursor: pointer;
		display: grid;
		place-items: center;
		flex-shrink: 0;
		box-shadow: 0 2px 0 #a9512c;
		transition: transform 100ms ease, box-shadow 100ms ease;
	}
	.vb-play:hover {
		transform: scale(1.06);
	}
	.vb-play:active {
		transform: translateY(1px);
		box-shadow: 0 0 0 #a9512c;
	}
	.pause-bars {
		display: flex;
		gap: 0.22rem;
	}
	.pause-bars span {
		width: 0.26rem;
		height: 0.85rem;
		background: #fff;
		border-radius: 2px;
	}
	.vb-again {
		width: 1.9rem;
		height: 1.9rem;
		border-radius: 50%;
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink-muted);
		cursor: pointer;
		display: grid;
		place-items: center;
		flex-shrink: 0;
		transition: color 120ms ease, border-color 120ms ease, transform 300ms ease;
	}
	.vb-again:hover {
		color: var(--accent-ink);
		border-color: var(--accent);
		transform: rotate(-180deg);
	}
	/* The little equalizer: still bars at rest, dancing while the voice runs. */
	.vb-eq {
		display: flex;
		align-items: flex-end;
		gap: 0.14rem;
		height: 0.9rem;
		flex-shrink: 0;
	}
	.vb-eq i {
		width: 0.18rem;
		height: 0.25rem;
		border-radius: 2px;
		background: var(--line-strong);
		transition: background 200ms ease;
	}
	.vb-eq.live i {
		background: var(--accent);
		animation: eq-dance 900ms ease-in-out infinite;
	}
	.vb-eq.live i:nth-child(1) { animation-delay: 0ms; }
	.vb-eq.live i:nth-child(2) { animation-delay: 150ms; }
	.vb-eq.live i:nth-child(3) { animation-delay: 300ms; }
	.vb-eq.live i:nth-child(4) { animation-delay: 450ms; }
	@keyframes eq-dance {
		0%, 100% { height: 0.25rem; }
		50% { height: 0.9rem; }
	}
	@media (prefers-reduced-motion: reduce) {
		.vb-eq.live i { animation: none; height: 0.6rem; }
		.vb-again:hover { transform: none; }
	}
	.vb-caption {
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--heading);
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.voice-bar.big .vb-caption {
		font-size: var(--step-0);
	}
	.nb-btn {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--heading);
		border-radius: 999px;
		height: 2.2rem;
		padding: 0 0.9rem;
		cursor: pointer;
		font-size: var(--step--1);
		font-weight: 600;
		transition: border-color 120ms ease;
	}
	.nb-btn:hover {
		border-color: var(--accent);
	}
	.nb-count {
		background: var(--accent-ink);
		color: #fff;
		border-radius: 999px;
		min-width: 1.25rem;
		height: 1.25rem;
		display: grid;
		place-items: center;
		font-size: 0.72rem;
		padding: 0 0.3rem;
	}
	@media (max-width: 30rem) {
		.nb-label {
			display: none;
		}
	}
	.progress {
		height: 4px;
		background: var(--paper-high);
		border-radius: 2px;
		margin: 0.6rem 0 1rem;
	}
	.fill {
		height: 100%;
		background: var(--accent);
		border-radius: 2px;
		transition: width 300ms ease;
	}
	.panel {
		display: grid;
		gap: 0.9rem;
		justify-items: start;
	}
	/* The scene is cinema: it breaks out of the text column to the full
	   viewport width, capped in height so the words stay on screen. */
	.panel img.scene {
		width: 100vw;
		max-width: 100vw;
		margin-inline: calc(50% - 50vw);
		margin-top: -0.25rem;
		border: none;
		border-radius: 0;
		max-height: 52vh;
		object-fit: cover;
		object-position: center 38%;
		box-shadow: 0 8px 24px rgb(31 58 95 / 0.12);
	}
	@media (min-width: 60rem) {
		/* On wide screens full-bleed would be a mural: cap it, keep it grand. */
		.panel img.scene {
			width: min(100vw, 58rem);
			margin-inline: calc(50% - min(50vw, 29rem));
			border-radius: var(--radius);
			max-height: 56vh;
		}
	}
	h1 {
		font-size: var(--step-3);
		color: var(--heading);
		margin: 0;
	}
	.maya {
		font-style: italic;
		font-size: var(--step-0);
		margin: 0;
	}
	.banter-reply {
		background: var(--accent-soft);
		border-left: 3px solid var(--accent);
		border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
		padding: 0.6rem 0.9rem;
		max-width: 100%;
		animation: reply-in 250ms ease;
	}
	@keyframes reply-in {
		from {
			opacity: 0;
			transform: translateY(6px);
		}
	}
	.from {
		font-weight: 700;
		color: var(--accent-ink);
		margin: 0;
	}
	.q {
		font-weight: 600;
		margin: 0;
	}
	.muted {
		color: var(--ink-muted);
	}
	.btn {
		background: var(--accent-ink);
		color: #fff;
		border: none;
		border-radius: 999px;
		padding: 0.7rem 1.8rem;
		font-size: var(--step-0);
		font-weight: 700;
		letter-spacing: 0.01em;
		cursor: pointer;
		box-shadow:
			0 3px 0 #a9512c,
			0 6px 14px rgb(201 104 59 / 0.35);
		transition: transform 120ms ease, box-shadow 120ms ease;
	}
	.btn:hover {
		transform: translateY(-1px);
		box-shadow:
			0 4px 0 #a9512c,
			0 8px 18px rgb(201 104 59 / 0.4);
	}
	.btn:active {
		transform: translateY(2px);
		box-shadow:
			0 1px 0 #a9512c,
			0 3px 8px rgb(201 104 59 / 0.3);
	}
	.btn.alt {
		background: var(--surface);
		color: var(--heading);
		border: 1px solid var(--line-strong);
		text-decoration: none;
	}
	.btn.finale {
		background: var(--navy);
	}
	.chip {
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		padding: 0.45rem 1rem;
		cursor: pointer;
		text-align: left;
	}
	.opts {
		display: grid;
		gap: 0.5rem;
		width: 100%;
	}
	.opts {
		counter-reset: opt;
	}
	.opt {
		counter-increment: opt;
		display: flex;
		align-items: center;
		gap: 0.75rem;
		text-align: left;
		background: var(--surface);
		border: 1.5px solid var(--line-strong);
		border-left: 4px solid var(--line-strong);
		border-radius: var(--radius-sm);
		padding: 0.7rem 1rem 0.7rem 0.8rem;
		cursor: pointer;
		font-size: var(--step-0);
		box-shadow: 0 2px 6px rgb(31 58 95 / 0.06);
		transition: transform 120ms ease, border-color 120ms ease, box-shadow 120ms ease;
	}
	.opt::before {
		content: counter(opt, upper-alpha);
		flex-shrink: 0;
		width: 1.7rem;
		height: 1.7rem;
		display: grid;
		place-items: center;
		border-radius: 50%;
		background: var(--paper-mid);
		color: var(--heading);
		font-weight: 700;
		font-size: var(--step--1);
	}
	.opt:hover {
		transform: translateX(3px);
		border-color: var(--accent);
		border-left-color: var(--accent);
		box-shadow: 0 4px 12px rgb(31 58 95 / 0.12);
	}
	.opt.right {
		border-color: var(--right);
		border-left-color: var(--right);
		background: var(--right-bg);
	}
	.opt.right::before {
		content: '✓';
		background: var(--right);
		color: #fff;
	}
	.opt.wrong {
		border-color: var(--wrong);
		border-left-color: var(--wrong);
		background: var(--wrong-bg);
		animation: opt-shake 300ms ease;
	}
	.opt.wrong::before {
		content: '✗';
		background: var(--wrong);
		color: #fff;
	}
	@keyframes opt-shake {
		25% {
			transform: translateX(-4px);
		}
		75% {
			transform: translateX(4px);
		}
	}
	.passage {
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		padding: 0.9rem 1rem;
		line-height: 2;
		white-space: pre-line;
		width: 100%;
	}
	.passage select {
		font: inherit;
		border-radius: 6px;
		border: 1px solid var(--line-strong);
		margin: 0 0.15rem;
	}
	.passage select.right {
		border-color: var(--right);
		background: var(--right-bg);
	}
	.passage select.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
	}
	.dial-display,
	.built {
		font-size: var(--step-2);
		font-variant-numeric: tabular-nums;
		min-height: 1.5em;
		margin: 0;
		color: var(--heading);
	}
	.keypad {
		display: grid;
		grid-template-columns: repeat(3, 4rem);
		gap: 0.5rem;
	}
	.key {
		font-size: var(--step-1);
		font-weight: 700;
		width: 4rem;
		height: 4rem;
		border-radius: 50%;
		border: 1.5px solid var(--line-strong);
		background: var(--surface);
		color: var(--heading);
		cursor: pointer;
		box-shadow:
			0 3px 0 var(--paper-highest),
			0 5px 10px rgb(31 58 95 / 0.1);
		transition: transform 90ms ease, box-shadow 90ms ease;
	}
	.key:hover {
		border-color: var(--accent);
	}
	.key:active {
		transform: translateY(3px);
		box-shadow:
			0 0 0 var(--paper-highest),
			0 2px 4px rgb(31 58 95 / 0.1);
	}
	.key.clear {
		grid-column: 2;
	}
	.tiles {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}
	.tile {
		background: var(--surface);
		border: 1.5px solid var(--line-strong);
		border-radius: var(--radius-sm);
		padding: 0.6rem 1rem;
		cursor: pointer;
		font-size: var(--step-0);
		font-weight: 600;
		color: var(--heading);
		box-shadow: 0 2px 0 var(--paper-highest), 0 4px 10px rgb(31 58 95 / 0.08);
		transition: transform 110ms ease, border-color 110ms ease, box-shadow 110ms ease;
	}
	.tile:hover {
		transform: translateY(-2px);
		border-color: var(--accent);
	}
	.tile:active {
		transform: translateY(1px);
		box-shadow: 0 0 0 var(--paper-highest), 0 2px 4px rgb(31 58 95 / 0.08);
	}
	.tiles.bubbles .tile {
		border-radius: 999px;
	}
	.tile.used {
		opacity: 0.35;
		pointer-events: none;
	}
	.cluecard {
		background: var(--right-bg);
		border-left: 3px solid var(--right);
		border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
		padding: 0.75rem 1rem;
	}
	.cluetitle {
		font-weight: 700;
		color: var(--right);
		margin: 0 0 0.3rem;
		font-size: var(--step--1);
		text-transform: uppercase;
		letter-spacing: 0.06em;
	}
	.cluecard ul {
		margin: 0;
		padding-left: 1.1rem;
	}
	.leads {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(12rem, 1fr));
		gap: 0.75rem;
		width: 100%;
	}
	.lead {
		display: grid;
		gap: 0;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		overflow: hidden;
		background: var(--surface);
		cursor: pointer;
		padding: 0;
	}
	.lead img {
		width: 100%;
		display: block;
	}
	.lead span {
		padding: 0.5rem 0.7rem;
		font-weight: 600;
		text-align: left;
	}
	.lead.done {
		opacity: 0.6;
		cursor: default;
	}
	.micro-panel {
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: var(--radius);
		padding: 1.25rem;
	}
	.maya-moment {
		position: fixed;
		left: 50%;
		bottom: 1.5rem;
		transform: translateX(-50%);
		z-index: 30;
		display: flex;
		align-items: center;
		gap: 0.9rem;
		background: var(--navy);
		color: var(--paper-low);
		border: 2px solid var(--ochre);
		border-radius: 999px;
		padding: 0.4rem 1.5rem 0.4rem 0.4rem;
		box-shadow:
			0 10px 30px rgb(0 0 0 / 0.3),
			0 0 24px rgb(217 164 65 / 0.4);
		max-width: min(92vw, 30rem);
		animation: mm-in 420ms cubic-bezier(0.34, 1.56, 0.64, 1);
		pointer-events: none;
	}
	@keyframes mm-in {
		from {
			transform: translateX(-50%) translateY(120%) scale(0.8);
			opacity: 0;
		}
	}
	.maya-moment img {
		width: 3.6rem;
		height: 3.6rem;
		border-radius: 50%;
		object-fit: cover;
		object-position: center 20%;
		border: 2px solid var(--ochre);
		background: #fbf5e4;
		flex-shrink: 0;
	}
	.mm-text {
		display: grid;
		gap: 0.1rem;
		min-width: 0;
	}
	.mm-text strong {
		color: var(--ochre-ink);
		font-size: var(--step--1);
		text-transform: uppercase;
		letter-spacing: 0.08em;
	}
	.mm-text span {
		font-style: italic;
		font-size: var(--step--1);
	}
	@media (prefers-reduced-motion: reduce) {
		.maya-moment {
			animation: none;
		}
	}
	.notebook {
		position: fixed;
		right: 1rem;
		top: 4rem;
		z-index: 10;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		padding: 1rem 1.25rem;
		box-shadow: 0 10px 30px rgb(0 0 0 / 0.15);
		max-width: 20rem;
		display: grid;
		gap: 0.6rem;
	}
	.notebook h2 {
		margin: 0;
		font-size: var(--step-0);
		color: var(--heading);
	}
	.notebook ul {
		margin: 0;
		padding-left: 1.1rem;
		max-height: 14rem;
		overflow: auto;
	}
	.beat-nav {
		display: flex;
		align-items: center;
		gap: 0.9rem;
		margin-top: 1.25rem;
		align-self: center;
	}
	.nav-arrow {
		width: 2.6rem;
		height: 2.6rem;
		border-radius: 50%;
		border: 1.5px solid var(--line-strong);
		background: var(--surface);
		color: var(--heading);
		font-size: 1.4rem;
		line-height: 1;
		cursor: pointer;
		display: grid;
		place-items: center;
		box-shadow: 0 2px 6px rgb(31 58 95 / 0.08);
		transition: transform 110ms ease, border-color 110ms ease;
	}
	.nav-arrow:hover:not(:disabled) {
		border-color: var(--accent);
		transform: scale(1.08);
	}
	.nav-arrow:disabled {
		opacity: 0.3;
		cursor: default;
	}
	.nav-count {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.end .row {
		display: flex;
		gap: 0.75rem;
		flex-wrap: wrap;
	}
</style>
