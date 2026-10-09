<script lang="ts">
	// The picture hunt (Suchbild), the flashcard deck's twin: one room, and a
	// run of "Wo ist der Heizkörper?" — tap it in the picture. Every find
	// shows its label while the answer is on screen, then leaves a small tick
	// in its gender's colour, so the room records the run without labels
	// covering it. Two modes, as the deck has three:
	//
	//   find   — the prompt is the German with its article; find the thing.
	//   name   — the prompt hides the article ("Wo ist ___ Brille?"); find it,
	//            then pick der/die/das. No audio until it is answered: the
	//            voice would say the article.
	//
	// The first runs are `find`; once a run has been passed the hunt opens on
	// `name`, the harder half. The learner can switch either way.
	//
	// A tap on another object names what you hit and the hunt goes on — the
	// answer is not given away. Only after MAX_MISSES misses in a row does the
	// right one glow. Found on the first tap counts as right; found after a
	// miss, or shown, counts as a miss. A tap on bare wall is nothing —
	// imprecise fingers are not wrong answers. Progress is the deck's: runs of RUN_LENGTH, the streak
	// across runs, medals by streak.
	import { dev } from '$app/environment';
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { celebrateMedal, react, shakeOn } from '$lib/motion/fx.svelte';
	import RunSummary from './RunSummary.svelte';
	import RunTracker from './RunTracker.svelte';
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
	import { onMount, untrack } from 'svelte';
	import type { SuchbildQuiz, SuchbildSpot } from '$lib/content/types';

	let {
		quiz,
		locale,
		onRunFinished
	}: {
		quiz: SuchbildQuiz;
		locale: string;
		/** A run of RUN_LENGTH finds is over — the hunt counts as done. */
		onRunFinished: (passed: boolean) => void;
	} = $props();

	type Mode = 'find' | 'name';
	const MODES: { id: Mode; label: string; icon: 'search' | 'words' }[] = [
		{ id: 'find', label: 'Find it', icon: 'search' },
		{ id: 'name', label: 'Find + article', icon: 'words' }
	];
	const ARTICLES = ['der', 'die', 'das'] as const;
	/** Misses on one question before the right object is shown. */
	const MAX_MISSES = 3;
	const GENDER: Record<string, 'm' | 'f' | 'n'> = { der: 'm', die: 'f', das: 'n' };
	const full = (s: SuchbildSpot) => `${s.article} ${s.de}`;
	const colour = (s: SuchbildSpot) => GENDER_COLORS[GENDER[s.article]];

	let mode = $state<Mode>('find');

	// Raw, not deep state: spots are compared by identity.
	let current = $state.raw<SuchbildSpot | undefined>(undefined);
	/** `tap` while hunting; `article` once a `name` find wants its der/die/das. */
	let phase = $state<'tap' | 'article'>('tap');
	let verdict = $state<'right' | 'wrong' | null>(null);
	/** The object tapped by mistake, named on the picture. */
	let tappedWrong = $state.raw<SuchbildSpot | null>(null);
	let chosenArticle = $state<string | null>(null);
	/** Wrong objects tapped on this question. */
	let misses = $state(0);
	/** MAX_MISSES reached: the right object glows and the question is lost. */
	let shown = $state(false);
	/** Bare wall was tapped: a nudge, not a miss. */
	let blank = $state(0);
	/** Objects found this run: each keeps a tick on the picture. */
	let found = $state<string[]>([]);

	let streak = $state(0);
	let best = $state(0);
	let results = $state<('right' | 'wrong')[]>([]);
	const answered = $derived(results.length);
	const right = $derived(results.filter((r) => r === 'right').length);
	let bestInRun = $state(0);
	let earned = $state<RibbonTier | null>(null);
	let missed = $state<string[]>([]);
	let runDone = $state(false);
	/** Objects already asked this run: none is asked twice in one run. */
	let asked = $state<string[]>([]);
	type Spot = { results: ('right' | 'wrong')[]; bestInRun: number; found: string[]; asked: string[] };

	let roomEl = $state<HTMLElement>();
	let missKey = $state(0);
	let burst = $state(0);
	let burstSize = $state(12);
	let timers: ReturnType<typeof setTimeout>[] = [];
	/** Set while an answer is on show: moves on now (Enter, or the button). */
	let skip = $state<(() => void) | null>(null);

	const locked = $derived(verdict !== null);
	/** Dev aid for placing the boxes: `?spots` outlines and names every one. */
	let showSpots = $state(false);

	function wait(ms: number) {
		return new Promise<void>((resolve) => timers.push(setTimeout(resolve, ms)));
	}

	function clearTimers() {
		for (const t of timers) clearTimeout(t);
		timers = [];
	}

	function next() {
		// A run never asks the same object twice, missed or not: the room has
		// more objects than a run has questions. Only a room smaller than a run
		// would start over, and then never on the object just asked.
		let fresh = quiz.spots.filter((s) => !asked.includes(s.de));
		if (!fresh.length) {
			asked = [];
			fresh = quiz.spots.filter((s) => s !== current);
		}
		const spot = fresh[Math.floor(Math.random() * fresh.length)];
		asked = [...asked, spot.de];
		current = spot;
		phase = 'tap';
		verdict = null;
		tappedWrong = null;
		chosenArticle = null;
		misses = 0;
		shown = false;
		sayPrompt(spot);
	}

	/** The question, for screen readers; in `name` without the article. */
	function sayPrompt(spot: SuchbildSpot) {
		announce(
			mode === 'find'
				? [{ text: `Wo ist ${full(spot)}?`, lang: locale }]
				: [{ text: 'Find' }, { text: spot.de, lang: locale }, { text: ', then choose its article.' }]
		);
	}

	onMount(() => {
		showSpots = dev && new URLSearchParams(window.location.search).has('spots');
		(async () => {
			const stats = await progress.statsFor(quiz.storageKeyPrefix);
			streak = stats.streak;
			best = stats.bestStreakAbsolute;
			const runs = await progress.runsFor(quiz.storageKeyPrefix);
			if (runs.some((r) => runPassed(r.right, r.total))) mode = 'name';
			const spot = await loadSpot<Spot>(quiz.storageKeyPrefix);
			const saved = Array.isArray(spot?.results) ? spot.results : [];
			if (saved.length > 0 && saved.length < RUN_LENGTH) {
				results = saved.filter((r) => r === 'right' || r === 'wrong');
				bestInRun = spot?.bestInRun ?? 0;
				found = Array.isArray(spot?.found) ? spot.found : [];
				asked = Array.isArray(spot?.asked) ? spot.asked : [];
			}
			untrack(next);
		})();
		return clearTimers;
	});

	function setMode(m: Mode) {
		if (m === mode || locked) return;
		mode = m;
		if (current) {
			phase = 'tap';
			sayPrompt(current);
		}
	}

	function finishRun() {
		runDone = true;
		void progress.recordRun(quiz.storageKeyPrefix, { right, total: RUN_LENGTH, bestStreak: bestInRun });
		clearSpot(quiz.storageKeyPrefix);
		const passed = runPassed(right, RUN_LENGTH);
		onRunFinished(passed);
		announce(
			`Run finished: ${right} of ${RUN_LENGTH} right — ${passed ? 'exercise done' : 'not this time'}. Your streak is ${streak}.`
		);
	}

	function tap(spot: SuchbildSpot) {
		if (!current || locked || phase !== 'tap') return;
		if (spot !== current) {
			misses += 1;
			missKey += 1;
			tappedWrong = null;
			queueMicrotask(() => (tappedWrong = spot));
			if (misses >= MAX_MISSES) {
				shown = true;
				void settle(false);
				return;
			}
			const left = MAX_MISSES - misses;
			announce([
				{ text: 'Not that one. That is' },
				{ text: full(spot), lang: locale },
				{ text: `— keep looking, ${left} ${left === 1 ? 'try' : 'tries'} left.` }
			]);
		} else if (mode === 'name') {
			tappedWrong = null;
			phase = 'article';
			announce('Found it. Now the article: der, die or das?');
		} else {
			tappedWrong = null;
			void settle(misses === 0);
		}
	}

	/**
	 * A tap this close to the asked object, in screen pixels, finds it even
	 * when it lands on a neighbour or bare wall: a fingertip is wider than the
	 * small things (a mouse, a piece of chalk), and the miss it would cost is
	 * almost always a near one.
	 */
	const NEAR_PX = 15;
	/**
	 * Where the finger actually came down. Phone browsers snap a tap to the
	 * nearest tappable thing and report the click there, so a tap on bare
	 * wall beside the asked object arrives as a tap on its neighbour; the
	 * pointerdown keeps the true spot.
	 */
	let downAt: { x: number; y: number } | null = null;
	function nearTarget(event: MouseEvent): boolean {
		if (!current || !canvasEl) return false;
		const at = downAt ?? { x: event.clientX, y: event.clientY };
		const r = canvasEl.getBoundingClientRect();
		return [current, ...(current.also ?? [])].some((b) => {
			const left = r.left + (r.width * b.x) / 100;
			const top = r.top + (r.height * b.y) / 100;
			const right = left + (r.width * b.w) / 100;
			const bottom = top + (r.height * b.h) / 100;
			const dx = Math.max(left - at.x, 0, at.x - right);
			const dy = Math.max(top - at.y, 0, at.y - bottom);
			return Math.hypot(dx, dy) <= NEAR_PX;
		});
	}

	function tapSpot(event: MouseEvent, spot: SuchbildSpot) {
		const near = !!current && nearTarget(event);
		// Used once: a later key press on a spot has no finger behind it.
		downAt = null;
		tap(near && current ? current : spot);
	}

	function tapBlank(event: MouseEvent) {
		if (locked || phase !== 'tap') return;
		if ((event.target as Element).closest('.spot, .zoom')) return;
		const near = !!current && nearTarget(event);
		downAt = null;
		if (near && current) tap(current);
		else blank += 1;
	}

	// -- Zoom ------------------------------------------------------------------
	// Pinch (or the +/- buttons) zooms the room up to MAX_ZOOM; one finger
	// drags it around while zoomed. A drag is never a tap: the click that
	// ends it is swallowed. Pan is the canvas's top-left, in room pixels.
	const MAX_ZOOM = 3;
	let canvasEl = $state<HTMLElement>();
	let zoom = $state(1);
	let panX = $state(0);
	let panY = $state(0);
	const pointers = new Map<number, { x: number; y: number }>();
	let pinch: { dist: number; zoom: number; cx: number; cy: number } | null = null;
	let drag: { x: number; y: number; panX: number; panY: number } | null = null;
	let moved = false;

	function local(e: PointerEvent) {
		const r = roomEl!.getBoundingClientRect();
		return { x: e.clientX - r.left, y: e.clientY - r.top };
	}

	function clampPan() {
		if (!roomEl) return;
		panX = Math.min(0, Math.max(roomEl.clientWidth * (1 - zoom), panX));
		panY = Math.min(0, Math.max(roomEl.clientHeight * (1 - zoom), panY));
	}

	/** Zooms to `z`, keeping the room point under (x, y) where it is. */
	function zoomTo(z: number, x: number, y: number) {
		const next = Math.min(MAX_ZOOM, Math.max(1, z));
		const k = next / zoom;
		panX = x - (x - panX) * k;
		panY = y - (y - panY) * k;
		zoom = next;
		clampPan();
	}

	/** +/- by `step`, or back to the whole picture with 0. */
	function zoomButton(step: number) {
		if (!roomEl) return;
		zoomTo(step ? zoom + step : 1, roomEl.clientWidth / 2, roomEl.clientHeight / 2);
	}

	function onPointerDown(e: PointerEvent) {
		downAt = { x: e.clientX, y: e.clientY };
		pointers.set(e.pointerId, local(e));
		if (pointers.size === 1) {
			drag = { ...local(e), panX, panY };
			moved = false;
		} else if (pointers.size === 2) {
			const [a, b] = [...pointers.values()];
			const mx = (a.x + b.x) / 2;
			const my = (a.y + b.y) / 2;
			// The canvas point under the fingers' midpoint, in unzoomed pixels.
			pinch = {
				dist: Math.hypot(a.x - b.x, a.y - b.y) || 1,
				zoom,
				cx: (mx - panX) / zoom,
				cy: (my - panY) / zoom
			};
			moved = true;
		}
	}

	function onPointerMove(e: PointerEvent) {
		if (!pointers.has(e.pointerId)) return;
		pointers.set(e.pointerId, local(e));
		if (pinch && pointers.size >= 2) {
			const [a, b] = [...pointers.values()];
			const ratio = Math.hypot(a.x - b.x, a.y - b.y) / pinch.dist;
			zoom = Math.min(MAX_ZOOM, Math.max(1, pinch.zoom * ratio));
			panX = (a.x + b.x) / 2 - pinch.cx * zoom;
			panY = (a.y + b.y) / 2 - pinch.cy * zoom;
			clampPan();
		} else if (drag && zoom > 1) {
			const p = local(e);
			const dx = p.x - drag.x;
			const dy = p.y - drag.y;
			if (!moved && Math.hypot(dx, dy) > 6) moved = true;
			if (moved) {
				panX = drag.panX + dx;
				panY = drag.panY + dy;
				clampPan();
			}
		}
	}

	function onPointerUp(e: PointerEvent) {
		pointers.delete(e.pointerId);
		if (pointers.size < 2) pinch = null;
		if (pointers.size === 0) drag = null;
	}

	/** The click that ends a drag or a pinch is not a tap. */
	function swallowDrag(e: MouseEvent) {
		if (!moved) return;
		moved = false;
		e.stopPropagation();
		e.preventDefault();
	}

	function pickArticle(article: string) {
		if (!current || locked) return;
		chosenArticle = article;
		// A find after a miss is already a miss, whatever the article.
		void settle(misses === 0 && article === current.article);
	}

	async function settle(correct: boolean) {
		if (!current) return;
		const spot = current;
		verdict = correct ? 'right' : 'wrong';
		const stats = await progress.recordAnswer(quiz.storageKeyPrefix, correct, mode);
		const lapCompleted = correct && stats.streak > 0 && stats.streak % STREAK_LAP_SIZE === 0;
		streak = stats.streak;
		best = stats.bestStreakAbsolute;
		results = [...results, correct ? 'right' : 'wrong'];
		bestInRun = Math.max(bestInRun, stats.streak);
		react(correct, roomEl, stats.streak);
		// A find keeps its tick on the room even after a wrong article: the
		// thing was found, and its label shows the article it should have had.
		if (!shown && !found.includes(spot.de)) found = [...found, spot.de];
		if (correct) {
			burstSize = lapCompleted ? 30 : 12;
			burst += 1;
		} else {
			if (shown || chosenArticle) missKey += 1;
			missed = [...missed, full(spot)];
		}
		saveSpot<Spot>(quiz.storageKeyPrefix, { results, bestInRun, found, asked });
		if (stats.earned) {
			earned = stats.earned;
			celebrateMedal(stats.earned, stats.streak);
		}
		const medal = stats.earned ? medalAnnouncement(stats.earned, stats.streak) : '';
		announce([
			{
				text: correct
					? 'Correct.'
					: shown
						? `Three misses. It is shown now:`
						: misses > 0 && !chosenArticle
							? 'Found, but not on the first try. It is:'
							: 'Not quite. It is:'
			},
			{ text: full(spot), lang: locale },
			...(medal ? [{ text: medal }] : [])
		]);

		const moveOn = () => {
			skip = null;
			clearTimers();
			if (answered >= RUN_LENGTH) finishRun();
			else next();
		};
		if (correct) wait(MIN_SHOW).then(() => (skip ??= moveOn));
		else await wait(600).then(() => (skip = moveOn));
		const pause = revealPause(progress.answerRevealMode);
		if (pause === null) {
			skip ??= moveOn;
			return;
		}
		// A miss needs time to see where the thing actually is.
		await wait(pause + (correct ? 700 : 1600));
		if (skip === moveOn) moveOn();
	}

	function onWindowKey(event: KeyboardEvent) {
		if (event.key !== 'Enter' || event.repeat || !locked || !skip) return;
		event.preventDefault();
		skip();
	}

	/**
	 * Where a found object's label sits: centred over it, but tucked inside the
	 * picture near an edge — over the box's own edge on the sides, under it at
	 * the very top — so the room never clips a label.
	 */
	function tagPlace(s: SuchbildSpot) {
		const cx = s.x + s.w / 2;
		const left = cx > 78 ? s.x + s.w : cx < 22 ? s.x : cx;
		const tx = cx > 78 ? '-100%' : cx < 22 ? '0' : '-50%';
		const below = s.y < 8;
		return { left, top: below ? s.y + s.h : s.y, transform: `translate(${tx}, ${below ? '15%' : '-70%'})` };
	}

	/** Screen-reader names for the objects: never the answer itself. */
	const spotName = (s: SuchbildSpot) => (mode === 'find' ? s.en : s.de);
	const [sceneW, sceneH] = $derived(quiz.sceneSize);
	// The room always takes the card's full width (edge to edge on a phone):
	// the picture is the exercise, so a short window scrolls rather than
	// shrinking it. The box keeps the picture's own ratio, so the spots (in
	// percent of the box) always sit on the image.
</script>

<svelte:window onkeydown={onWindowKey} />

<RunTracker {results} total={RUN_LENGTH} {streak} {best} />

{#snippet modes()}
	<!-- One switch, not two pills: a click anywhere on it flips the mode, and
	     the navy thumb slides to the icon in play. -->
	<button
		type="button"
		class="modes"
		role="switch"
		aria-checked={mode === 'name'}
		aria-label="Ask for the article too"
		title={mode === 'find' ? 'Find it — click for Find + article' : 'Find + article — click for Find it'}
		disabled={locked}
		onclick={() => setMode(mode === 'find' ? 'name' : 'find')}
	>
		{#each MODES as m (m.id)}
			<span class="mode" class:on={mode === m.id}><Icon name={m.icon} size="1.1em" /></span>
		{/each}
	</button>
{/snippet}

<!-- The modes live in the card: beside the question on a wide screen, in the
     card's top row on a phone (the pressed pill then says what the eyebrow
     would), so nothing sits between the bar and the picture. -->

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
	<!-- One card, like the fill-in's: the question on top, the room under it.
	     The room sits on the card's own paper panel, so the picture has no edge. -->
	<div class="space">
	<section class="card" style="--gender:{colour(current)}">
	<div class="ask">
		<div class="ask-top">
			<p class="prompt-label">{mode === 'find' ? 'Tap it in the picture' : 'Tap it, then its article'}</p>
			<div class="modes-inline">{@render modes()}</div>
			<span class="count tnum">{found.length} / {quiz.spots.length} found</span>
		</div>
		<div class="q-row">
		<div class="modes-wide">{@render modes()}</div>
		{#if locked}
			<p class="q" lang={locale}>
				<span class="article">{current.article}</span>
				{current.de}
				<SpeakButton text={full(current)} {locale} />
				<span class="en" lang="en">{current.en}</span>
			</p>
		{:else if mode === 'find'}
			<p class="q" lang={locale}>
				Wo ist <span class="article">{current.article}</span>
				{current.de}?
				<SpeakButton text={`Wo ist ${full(current)}?`} {locale} />
			</p>
		{:else}
			<!-- The article is the question: a gap, and no speak button, which
			     would say it. -->
			<p class="q" lang={locale}>
				Wo ist <span class="gap" class:asking={phase === 'article'} aria-label="which article?">___</span>
				{current.de}?
			</p>
		{/if}
		</div>

	</div>

	<!-- The room. Spots are invisible buttons over the picture; a found one
	     keeps a tick from then on. -->
	<div class="bleed">
	<!-- The status floats over the top of the room, so it takes no row of
	     its own: nudges, the verdict, the der/die/das buttons. -->
		<div class="status">
		{#if phase === 'article' && !locked}
			<div class="articles" role="group" aria-label="Article">
				{#each ARTICLES as a (a)}
					<button type="button" class="art art-{GENDER[a]}" lang={locale} onclick={() => pickArticle(a)}>{a}</button>
				{/each}
			</div>
		{:else if verdict === 'right'}
			<p class="verdict right"><Icon name="check" size="1em" /> Richtig!</p>
		{:else if verdict === 'wrong'}
			<p class="verdict wrong">
				<Icon name="close" size="1em" />
				{#if shown}
					Three misses — there it is, glowing.
				{:else if chosenArticle && chosenArticle !== current.article}
					Found it — but it's <strong lang={locale}>{current.article}</strong>, not <s lang={locale}>{chosenArticle}</s>.
				{:else}
					Found — but not on the first try, so it counts as a miss.
				{/if}
			</p>
		{:else if tappedWrong}
			<p class="nudge miss">
				Not that one — that's <span lang={locale}>{full(tappedWrong)}</span>. Keep looking
				({MAX_MISSES - misses} {MAX_MISSES - misses === 1 ? 'try' : 'tries'} left).
			</p>
		{:else if blank}
			{#key blank}<p class="nudge">Nothing to find there — try another spot.</p>{/key}
		{/if}
		{#if locked && progress.answerRevealMode === 'manual'}
			<button type="button" class="btn next" disabled={!skip} onclick={() => skip?.()}>
				Next <Icon name="arrowRight" size="1em" />
			</button>
		{/if}
		</div>
	<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_static_element_interactions -->
	<div
		class="room"
		class:debug={showSpots}
		class:zoomed={zoom > 1}
		bind:this={roomEl}
		use:shakeOn={missKey}
		style:aspect-ratio="{sceneW} / {sceneH}"
		onclick={tapBlank}
		onclickcapture={swallowDrag}
		onpointerdown={onPointerDown}
		onpointermove={onPointerMove}
		onpointerup={onPointerUp}
		onpointercancel={onPointerUp}
	>
		<Burst trigger={burst} count={burstSize} />
		<div
			class="canvas"
			bind:this={canvasEl}
			style:transform="translate({panX}px, {panY}px) scale({zoom})"
			style:--z={zoom}
		>
		<img src="/img/{quiz.scene}.webp" alt={quiz.sceneAlt} width={sceneW} height={sceneH} draggable="false" />
		{#each quiz.spots as s (s.de)}
			{@const isFound = found.includes(s.de)}
			{@const isTarget = s === current}
			{#each [s, ...(s.also ?? [])] as box, i (i)}
			<button
				type="button"
				class="spot"
				class:target-right={isTarget && locked && !shown}
				class:target-show={isTarget && shown}
				class:tapped-wrong={tappedWrong === s}
				class:picked={isTarget && phase === 'article'}
				style:left="{box.x}%"
				style:top="{box.y}%"
				style:width="{box.w}%"
				style:height="{box.h}%"
				style:--gender={colour(s)}
				aria-label={spotName(s)}
				tabindex={i ? -1 : undefined}
				aria-hidden={i ? 'true' : undefined}
				disabled={locked || phase !== 'tap'}
				onclick={(e) => tapSpot(e, s)}
			></button>
			{/each}
			{#if (isTarget && locked) || tappedWrong === s || showSpots}
				{@const place = tagPlace(s)}
				<span
					class="tag"
					class:fresh={isTarget && locked}
					style:left="{place.left}%"
					style:top="{place.top}%"
					style:transform={place.transform}
					style:--gender={colour(s)}
					lang={locale}
					aria-hidden="true"
				>
					<b>{s.article}</b> {s.de}
				</span>
			{:else if isFound}
				<!-- Found earlier this run: a small tick at the box's corner, not a
				     label — labels on every find piled up and hid the objects. -->
				<span
					class="pin"
					style:left="{s.x + s.w}%"
					style:top="{s.y}%"
					style:--gender={colour(s)}
					aria-hidden="true"
				><Icon name="check" size="0.8em" /></span>
			{/if}
		{/each}
		</div>
		<div class="zoom">
			{#if zoom > 1}
				<button type="button" onclick={() => zoomButton(0)} aria-label="Show the whole picture" title="Show the whole picture">1×</button>
			{/if}
			<button type="button" onclick={() => zoomButton(-0.75)} disabled={zoom <= 1} aria-label="Zoom out" title="Zoom out">−</button>
			<button type="button" onclick={() => zoomButton(0.75)} disabled={zoom >= MAX_ZOOM} aria-label="Zoom in" title="Zoom in (or pinch)">+</button>
		</div>
	</div>
	</div>
	</section>
	</div>
{/if}

<style>
	.modes {
		position: relative;
		display: inline-flex;
		padding: 0.2rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface-alt);
		cursor: pointer;
	}

	.modes:disabled {
		cursor: default;
		opacity: 0.7;
	}

	.modes:focus-visible {
		outline: 2px solid var(--accent);
		outline-offset: 2px;
	}

	/* The thumb sits under the first icon and slides to the second. */
	.modes::before {
		content: '';
		position: absolute;
		top: 0.2rem;
		left: 0.2rem;
		width: 2.1rem;
		height: 1.9rem;
		border-radius: 999px;
		background: var(--heading);
		box-shadow: 0 1px 2px rgb(0 0 0 / 0.12);
		transition: translate var(--fast) var(--ease-out);
	}

	.modes[aria-checked='true']::before {
		translate: 2.1rem 0;
	}

	/* Icon-only: a magnifier for `find`, the word mark for `name`; the label
	   is the title and the screen-reader name. */
	.mode {
		position: relative;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.1rem;
		height: 1.9rem;
		color: var(--ink-muted);
		transition: color var(--fast) var(--ease-out);
	}

	.mode.on {
		color: var(--paper);
	}

	/* ── The card ────────────────────────────────────────────────────────── */

	/* Below the bar and the modes; taller than a short window, the stage scrolls. */
	.space {
		flex: none;
	}

	/* The fill-in's card: question on top, room below, as tall as they are. */
	.card {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		padding: 1rem 1.25rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.ask {
		flex: none;
	}

	.ask-top {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		gap: 0.6rem;
	}

	.prompt-label {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	/* Question on the left, the modes on the right of the same row. */
	.q-row {
		display: flex;
		flex-direction: row-reverse;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.4rem 1rem;
	}

	.q-row .q {
		flex: 1 1 auto;
	}

	.modes-wide {
		flex: none;
		margin-top: 0.45rem;
	}

	/* The phone seat, in the card's top row (see the media query). */
	.modes-inline {
		display: none;
	}

	.count {
		font-size: 0.78rem;
		font-weight: 700;
		color: var(--ink-muted);
	}

	/* Over the room's top edge, centred; empty, it is nothing at all. */
	.status {
		position: absolute;
		top: 0.5rem;
		left: 50%;
		z-index: 3;
		translate: -50% 0;
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: center;
		gap: 0.4rem 0.9rem;
		max-width: calc(100% - 1rem);
		pointer-events: none;
	}

	.status > * {
		pointer-events: auto;
	}

	.status .nudge,
	.status .verdict {
		padding: 0.25rem 0.7rem;
		border-radius: 999px;
		background: rgb(255 250 240 / 0.94);
		box-shadow: 0 1px 4px rgb(31 58 95 / 0.18);
		text-align: center;
	}

	.q {
		margin: 0.25rem 0 0;
		max-width: none;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-variation-settings: 'opsz' 28;
		font-weight: 600;
		line-height: 1.3;
		color: var(--ink);
	}

	.q .article {
		color: var(--gender);
	}

	.q .gap {
		display: inline-block;
		min-width: 2.6em;
		color: transparent;
		border-bottom: 2.5px solid var(--line-strong);
		line-height: 1;
	}

	.q .gap.asking {
		border-bottom-color: var(--accent);
	}

	.q .en {
		margin-left: 0.4rem;
		font-family: Inter, sans-serif;
		font-size: var(--step--1);
		font-weight: 500;
		color: var(--ink-muted);
	}

	.nudge {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.articles {
		display: inline-flex;
		gap: 0.5rem;
	}

	.art {
		min-width: 4.2rem;
		padding: 0.5rem 0.9rem;
		border: 2px solid var(--c);
		border-radius: 999px;
		background: var(--surface);
		color: var(--c);
		font-size: 1.05rem;
		font-weight: 800;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.art:hover,
	.art:focus-visible {
		background: var(--c);
		color: var(--paper);
	}

	.art-m {
		--c: #2e6fb7;
	}
	.art-f {
		--c: #c0446a;
	}
	.art-n {
		--c: #3f7d4e;
	}

	.verdict {
		margin: 0;
		font-weight: 700;
	}

	.verdict :global(svg) {
		vertical-align: -0.15em;
	}

	.verdict.right {
		color: var(--right, #3f7d4f);
	}

	.verdict.wrong {
		color: var(--wrong);
	}

	.next {
		padding: 0.4rem 0.9rem;
	}

	/* ── The room ────────────────────────────────────────────────────────── */

	/* The rest of the screen; never so small the objects stop being tappable
	   (the stage scrolls instead). */
	/* The card's full width; the height follows the picture's ratio. */
	.room {
		position: relative;
		flex: none;
		width: 100%;
		margin-inline: auto;
		background: #fbf5e4;
		border-radius: var(--radius-sm);
		overflow: hidden;
		/* labels scale with the picture, not the screen */
		container-type: inline-size;
		user-select: none;
		-webkit-tap-highlight-color: transparent;
	}

	/* Phone: the room runs to the card's edges (see the media query). */
	.bleed {
		position: relative;
		display: flex;
		justify-content: center;
	}

	/* Unzoomed, a vertical swipe still scrolls the page; zoomed, every
	   gesture is the room's. */
	.room {
		touch-action: pan-y;
	}

	.room.zoomed {
		touch-action: none;
		cursor: grab;
	}

	/* Everything that zooms: the picture and what sits on it. */
	.canvas {
		position: absolute;
		inset: 0;
		transform-origin: 0 0;
	}

	.canvas img {
		display: block;
		width: 100%;
		height: 100%;
		pointer-events: none;
	}

	/* Labels and ticks keep their size while the picture grows. */
	.canvas .tag,
	.canvas .pin {
		scale: calc(1 / var(--z, 1));
	}

	.zoom {
		position: absolute;
		right: 0.5rem;
		bottom: 0.5rem;
		z-index: 2;
		display: flex;
		gap: 0.35rem;
	}

	.zoom button {
		display: grid;
		place-items: center;
		min-width: 2.25rem;
		height: 2.25rem;
		padding: 0 0.5rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: rgb(255 250 240 / 0.92);
		color: var(--heading);
		font-size: 1.15rem;
		font-weight: 700;
		line-height: 1;
		cursor: pointer;
		box-shadow: 0 1px 4px rgb(31 58 95 / 0.18);
	}

	.zoom button:disabled {
		opacity: 0.45;
		cursor: default;
	}

	.spot {
		position: absolute;
		padding: 0;
		border: 2px solid transparent;
		border-radius: 8px;
		background: transparent;
		cursor: pointer;
		transition: box-shadow 160ms ease;
	}

	.spot:disabled {
		cursor: default;
	}

	@media (hover: hover) {
		.spot:not(:disabled):hover {
			box-shadow: 0 0 0 3px rgb(201 104 59 / 0.45);
		}
	}

	.spot:focus-visible {
		outline: none;
		box-shadow: 0 0 0 3px var(--accent);
	}

	/* Neutral while the article is still being asked: the gender colour
	   would answer it. */
	.spot.picked {
		box-shadow: 0 0 0 4px var(--heading);
		animation: pop 500ms ease;
	}

	.spot.target-right {
		box-shadow: 0 0 0 4px var(--gender);
		animation: pop 500ms ease;
	}

	.spot.tapped-wrong {
		box-shadow: 0 0 0 3px var(--wrong);
		animation: shake 360ms ease;
	}

	.spot.target-show {
		animation: glow 1.1s ease-in-out infinite;
	}

	.debug .spot {
		border-color: rgb(201 104 59 / 0.9);
		background: rgb(201 104 59 / 0.12);
	}

	/* A found object's tick: a small disc in its gender's colour at the box's
	   top-right corner, pulled inside so it never leaves the picture. */
	.pin {
		position: absolute;
		z-index: 1;
		display: grid;
		place-items: center;
		width: clamp(0.9rem, 3.2cqw, 1.35rem);
		height: clamp(0.9rem, 3.2cqw, 1.35rem);
		transform: translate(-85%, -15%);
		border: 1.5px solid #fffaf0;
		border-radius: 50%;
		background: var(--gender);
		color: #fffaf0;
		pointer-events: none;
		box-shadow: 0 1px 3px rgb(31 58 95 / 0.3);
	}

	/* The answer's label: a little paper tag in its gender's colour. */
	.tag {
		position: absolute;
		z-index: 1;
		padding: 0.15em 0.5em;
		border: 1.5px solid var(--gender);
		border-radius: 999px;
		background: #fffaf0;
		color: #1f3a5f;
		font-family: Inter, sans-serif;
		font-size: clamp(0.62rem, 1.9cqw, 0.95rem);
		font-weight: 600;
		white-space: nowrap;
		pointer-events: none;
		box-shadow: 0 2px 6px rgb(31 58 95 / 0.18);
	}

	.tag b {
		color: var(--gender);
		font-weight: 800;
	}

	.tag.fresh {
		animation: stick 420ms var(--ease-out, ease-out);
	}

	@keyframes pop {
		40% {
			transform: scale(1.06);
		}
	}

	@keyframes shake {
		25% {
			transform: translateX(-4px);
		}
		75% {
			transform: translateX(4px);
		}
	}

	@keyframes glow {
		50% {
			box-shadow: 0 0 0 5px rgba(217, 164, 65, 0.9);
		}
	}

	@keyframes stick {
		from {
			scale: 0.6;
			opacity: 0;
		}
	}

	@media (max-width: 36rem) {
		/* Every row above the picture costs a strip of the room, so the modes
		   move into the card's top row, the eyebrow goes (the pressed pill says
		   it), the question shrinks a step and the status line only takes the
		   height it needs. */
		.modes-wide {
			display: none;
		}
		.modes-inline {
			display: block;
		}
		.ask-top {
			align-items: center;
		}
		.modes {
			padding: 0.15rem;
		}
		.modes::before {
			top: 0.15rem;
			left: 0.15rem;
			width: 1.9rem;
			height: 1.7rem;
		}
		.modes[aria-checked='true']::before {
			translate: 1.9rem 0;
		}
		.mode {
			width: 1.9rem;
			height: 1.7rem;
		}
		.q {
			margin-top: 0.4rem;
			line-height: 1.2;
		}
		.card {
			padding: 0.6rem 0.85rem 0.7rem;
			gap: 0.3rem;
		}
		/* Every pixel counts on a phone: the room runs edge to edge. */
		.bleed {
			margin-inline: -0.85rem;
		}
		.room {
			border-radius: 0;
		}
		.q {
			font-size: var(--step-0);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.spot,
		.tag.fresh {
			animation: none !important;
		}
	}
</style>
