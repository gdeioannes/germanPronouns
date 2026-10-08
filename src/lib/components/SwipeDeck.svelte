<script lang="ts">
	// The swipe deck — the course home's main event. A stack of exercise cards
	// dealt from what the learner has done, the pace they want and the level
	// they say they are at: drag (or arrow) right to open the exercise, left to
	// drop it. Drops persist, so a card swiped away stays away on the next
	// visit until the whole deck has been turned down, when the memory is wiped
	// and it starts again.
	//
	// Gestures are plain Pointer Events. The card follows the finger with a
	// little rotation; past the threshold — or on a quick flick — a stamp
	// ("Skip" / "Let's go") turns solid and letting go flings the card off.
	// Under it the card springs back, and a plain tap opens the exercise. The
	// card claims every touch (touch-action: none) so the browser never steals
	// a slightly diagonal swipe as a scroll. Everything the gesture does is
	// also on two buttons and the arrow keys.
	//
	// The chip above the stack opens the deck chooser: how to learn (the pace)
	// and where the learner is (the level). Both redeal the stack at once.
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS, type IconName } from '$lib/icons/paths';
	import DoneMark from '$lib/components/DoneMark.svelte';
	import InProgressBadge from '$lib/components/InProgressBadge.svelte';
	import Sheet from '$lib/components/Sheet.svelte';
	import { announce, radioKeys } from '$lib/a11y.svelte';
	import { tick } from 'svelte';
	import { DURATION, prefersReducedMotion } from '$lib/motion';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { clearOpened, lastOpened } from '$lib/state/resume';
	import { goto } from '$app/navigation';
	import {
		DECK_KIND_LABELS,
		DECK_PACES,
		DECK_PACE_ORDER,
		DEFAULT_SIZE,
		buildDeck,
		continueCard,
		courseLevels,
		deckLevel,
		isDeckPace,
		typeLabel,
		type DeckCard,
		type DeckPace
	} from '$lib/domain/deck';
	import { isStoryCard, reachedQuiz, storyCardHref, storyDeckCard } from '$lib/domain/stories';
	import { isSongCard, songCardHref, songDeckCard } from '$lib/domain/songs';
	import type { QuizFacts } from '$lib/domain/recommend';
	import type { CourseSummary } from '$lib/content/types';
	import { untrack, type Snippet } from 'svelte';

	let {
		course,
		facts,
		level = $bindable(null),
		title,
		aside,
		onbrowse,
		inProgress = new Set()
	}: {
		course: CourseSummary;
		/** Every quiz's facts, or null while the page is still loading them. */
		facts: Record<string, QuizFacts> | null;
		/** The sub-level the learner picked (null = auto); the page reads it for the ring. */
		level?: string | null;
		/** The page's heading, set above the deck chip. */
		title?: Snippet;
		/** Drawn at the right of the header row (the progress ring). */
		aside?: Snippet;
		/** Opens the full exercise list; shown between the two buttons. */
		onbrowse?: () => void;
		/** Exercises started but not finished — their cards wear the marker. */
		inProgress?: Set<string>;
	} = $props();

	// "quiz_" in the key puts the skips in the set that "start over" wipes.
	// The level and pace are preferences, not progress, so they survive a reset.
	const SKIPPED_KEY = 'quiz_recommend_skipped';
	const LEVEL_KEY = 'deck_level';
	const PACE_KEY = 'deck_pace';
	/** "1" once the learner has swiped (or pressed) once: the coach never returns. */
	const COACH_KEY = 'deck_swipe_coached';
	const SKIPPED_LIMIT = 80;
	/** How many cards of the stack are drawn behind the top one. */
	const VISIBLE = 3;

	const PACE_ICONS: Record<DeckPace, IconName> = {
		steady: 'leaf',
		fast: 'bolt',
		adventurous: 'compass',
		review: 'repeat'
	};

	let skipped = $state<string[]>([]);
	/** The exercise the learner left part-way, dealt back on top until finished. */
	let openId = $state<string | null>(null);
	let pace = $state<DeckPace>('steady');
	let deck = $state<DeckCard[]>([]);
	let loaded = $state(false);
	/** Bumped on every deal, so the stack replays its deal-in animation. */
	let dealt = $state(0);
	/** How many cards the last deal held, for the "Card 3 of 12" line. */
	let handSize = $state(0);
	let chooserOpen = $state(false);

	const levels = $derived(courseLevels(course.quizzes));
	const centre = $derived(deckLevel(course.quizzes, facts ?? {}, level));
	/** Where the deck would sit with no level picked: the furthest finished. */
	const autoLevel = $derived(deckLevel(course.quizzes, facts ?? {}, null));
	/** The sub-levels grouped by CEFR band (A1, A2, …) for the chooser. */
	const bands = $derived.by(() => {
		const out: { name: string; levels: string[] }[] = [];
		for (const lv of levels) {
			const name = lv.split('.')[0];
			const band = out.at(-1);
			if (band?.name === name) band.levels.push(lv);
			else out.push({ name, levels: [lv] });
		}
		return out;
	});

	$effect(() => {
		if (!facts) return;
		// Reads rune state it must not subscribe to — the deal writes the deck,
		// and a pick would otherwise re-run the load.
		untrack(() => void load());
	});

	async function load() {
		try {
			const raw = await storage.get(SKIPPED_KEY);
			const parsed = raw ? JSON.parse(raw) : [];
			skipped = Array.isArray(parsed) ? parsed.map(String) : [];
		} catch {
			skipped = [];
		}
		const picked = await storage.get(LEVEL_KEY);
		level = picked && levels.includes(picked) ? picked : null;
		openId = await lastOpened();
		const savedPace = await storage.get(PACE_KEY);
		pace = isDeckPace(savedPace) ? savedPace : 'steady';
		coach = (await storage.get(COACH_KEY)) !== '1';
		deal();
		loaded = true;
	}

	/** Rebuilds the stack; forgets the skips first if they have eaten everything. */
	function deal() {
		const known = facts ?? {};
		const resume = continueCard(course.quizzes, known, openId);
		if (!resume && openId) {
			// Finished since, or gone: nothing to come back to.
			clearOpened(openId);
			openId = null;
		}
		const exclude = new Set(resume ? [resume.quiz.id] : []);
		const size = DEFAULT_SIZE - (resume ? 1 : 0);
		deck = buildDeck(course.quizzes, known, { level, pace, size, exclude, skipped: new Set(skipped) });
		if (deck.length === 0 && skipped.length > 0) {
			skipped = [];
			void storage.set(SKIPPED_KEY, '[]');
			deck = buildDeck(course.quizzes, known, { level, pace, size, exclude });
		}
		// The level's story episode joins the hand near the top: a treat, not
		// a quota, and gone once played (or swiped away like any card).
		const story = storyDeckCard(course.id, deckLevel(course.quizzes, known, level), new Set(skipped), (id) =>
			reachedQuiz(course.quizzes, (q) => known[q]?.done === true, id)
		);
		if (story) deck = [...deck.slice(0, Math.min(2, deck.length)), story, ...deck.slice(Math.min(2, deck.length))];
		// The level's song, a few cards further down: two treats in a hand,
		// never side by side.
		const song = songDeckCard(course.id, deckLevel(course.quizzes, known, level), new Set(skipped), (id) =>
			reachedQuiz(course.quizzes, (q) => known[q]?.done === true, id)
		);
		if (song) deck = [...deck.slice(0, Math.min(5, deck.length)), song, ...deck.slice(Math.min(5, deck.length))];
		if (resume) deck = [resume, ...deck];
		handSize = deck.length;
		dealt++;
	}

	async function pickLevel(value: string | null) {
		if (value === level) return;
		level = value;
		if (level) await storage.set(LEVEL_KEY, level);
		else await storage.remove(LEVEL_KEY);
		track('deck_level_picked', { course: course.id, level: level ?? 'auto' });
		deal();
	}

	async function pickPace(value: DeckPace) {
		if (value === pace) return;
		pace = value;
		await storage.set(PACE_KEY, pace);
		track('deck_pace_picked', { course: course.id, pace });
		deal();
	}

	// ---- the gesture -------------------------------------------------------

	/** Drag distance that counts as a decision, in px — less on a narrow card. */
	let threshold = $state(110);
	/** How far the card flies when released past the threshold. */
	const FLING = 900;
	/** A release faster than this (px/ms) past FLICK_MIN px counts as a swipe. */
	const FLICK_SPEED = 0.5;
	const FLICK_MIN = 36;
	/** Movement under this many px is a tap, not a drag. */
	const TAP_SLOP = 8;

	let dx = $state(0);
	let dy = $state(0);
	let dragging = $state(false);
	/** The first-visit swipe hint over the top card. */
	let coach = $state(false);
	/** Set while the top card is flying off; the deck is inert until it lands. */
	let leaving = $state<'left' | 'right' | null>(null);
	let startX = 0;
	let startY = 0;
	let lastX = 0;
	let lastT = 0;
	/** Smoothed horizontal speed, px/ms. */
	let vx = 0;
	let moved = false;
	let pointerId: number | null = null;

	const top = $derived(deck[0] ?? null);
	const lean = $derived(Math.max(-1, Math.min(1, dx / threshold)));
	const decided = $derived(Math.abs(dx) >= threshold);

	function href(card: DeckCard) {
		return storyCardHref(card) ?? songCardHref(card) ?? `/course/${course.id}/quiz/${card.quiz.id}`;
	}

	function onDown(event: PointerEvent) {
		if (leaving || !top || pointerId !== null) return;
		if (event.pointerType === 'mouse' && event.button !== 0) return;
		const el = event.currentTarget as HTMLElement;
		threshold = Math.min(110, Math.max(64, el.offsetWidth * 0.28));
		pointerId = event.pointerId;
		startX = lastX = event.clientX;
		startY = event.clientY;
		lastT = event.timeStamp;
		vx = 0;
		moved = false;
		coached();
		dragging = true;
		el.setPointerCapture(event.pointerId);
	}

	function onMove(event: PointerEvent) {
		if (!dragging || event.pointerId !== pointerId) return;
		const dt = event.timeStamp - lastT;
		if (dt > 0) vx = 0.7 * ((event.clientX - lastX) / dt) + 0.3 * vx;
		lastX = event.clientX;
		lastT = event.timeStamp;
		dx = event.clientX - startX;
		dy = (event.clientY - startY) * 0.4;
		if (!moved && Math.hypot(event.clientX - startX, event.clientY - startY) > TAP_SLOP) moved = true;
	}

	function onUp(event: PointerEvent) {
		if (!dragging || event.pointerId !== pointerId) return;
		dragging = false;
		pointerId = null;
		// A finger that stopped before lifting has no speed left.
		const speed = event.timeStamp - lastT > 80 ? 0 : vx;
		const flick = Math.abs(dx) >= FLICK_MIN && Math.abs(speed) >= FLICK_SPEED && Math.sign(speed) === Math.sign(dx);
		if (dx >= threshold || (flick && dx > 0)) fling('right');
		else if (dx <= -threshold || (flick && dx < 0)) fling('left');
		else if (!moved) {
			reset();
			fling('right');
		} else reset();
	}

	/** The browser took the pointer away (a system gesture): just spring back. */
	function onCancel(event: PointerEvent) {
		if (event.pointerId !== pointerId) return;
		dragging = false;
		pointerId = null;
		reset();
	}

	function reset() {
		dx = 0;
		dy = 0;
	}

	let stageEl = $state<HTMLElement>();

	/** The hint has done its job the moment the learner acts — by any means. */
	function coached() {
		if (!coach) return;
		coach = false;
		void storage.set(COACH_KEY, '1');
	}

	/** Sends the top card off and acts once it has gone. */
	function fling(direction: 'left' | 'right') {
		if (!top || leaving) return;
		coached();
		const card = top;
		// The card is about to be removed; if it held focus, the next one takes it.
		const cardHadFocus = !!stageEl?.contains(document.activeElement);
		leaving = direction;
		dx = direction === 'right' ? FLING : -FLING;
		const wait = prefersReducedMotion() ? 0 : DURATION.slow;
		window.setTimeout(() => {
			if (direction === 'left') {
				// Passing on the half-done one means it stops coming back on top.
				if (card.kind === 'continue') {
					clearOpened(card.quiz.id);
					openId = null;
				}
				skipped = [...skipped.filter((id) => id !== card.quiz.id), card.quiz.id].slice(-SKIPPED_LIMIT);
				void storage.set(SKIPPED_KEY, JSON.stringify(skipped));
				track('deck_swipe', { course: course.id, quiz: card.quiz.id, kind: card.kind, choice: 'skip', pace });
				deck = deck.slice(1);
				if (deck.length === 0) deal();
				const nextCard = deck[0];
				announce(
					nextCard
						? `Skipped. Next: ${nextCard.quiz.title}, card ${handSize - deck.length + 1} of ${handSize}.`
						: 'Skipped. Nothing left to deal.'
				);
				if (cardHadFocus) {
					void tick().then(() => stageEl?.querySelector<HTMLElement>('.card.top, .card.empty button')?.focus());
				}
			} else {
				track('deck_swipe', { course: course.id, quiz: card.quiz.id, kind: card.kind, choice: 'go', pace });
				void goto(href(card));
			}
			reset();
			leaving = null;
		}, wait);
	}

	function onKey(event: KeyboardEvent) {
		if (event.key === 'ArrowRight' || event.key === 'Enter' || event.key === ' ') {
			event.preventDefault();
			fling('right');
		} else if (event.key === 'ArrowLeft') {
			event.preventDefault();
			fling('left');
		}
	}

	// Exercises of one kind share a scene, so two cards in a row could look
	// like the same card dealt twice. Each exercise gets its own variation
	// instead, picked from its id so it always looks the same itself: a layer
	// laid over the whole band (a tint and a faint pattern, multiplied, so the
	// drawing's lines stay crisp while its paper changes), and the scene
	// sometimes mirrored and framed a little differently underneath.
	const ART_TINTS = ['#fffaf0', '#f9d9c6', '#d3e3f0', '#d8e8cc', '#e4d8f0', '#f6e1a8', '#f3d0d8'];
	const INK = 'rgb(31 58 95 / 0.09)';
	const ART_PATTERNS = [
		'none',
		`radial-gradient(${INK} 1.3px, transparent 1.8px) 0 0 / 14px 14px`,
		`repeating-linear-gradient(45deg, ${INK} 0 2px, transparent 2px 13px)`,
		`repeating-linear-gradient(-45deg, ${INK} 0 2px, transparent 2px 13px)`,
		`linear-gradient(${INK} 1px, transparent 1px) 0 0 / 18px 18px, linear-gradient(90deg, ${INK} 1px, transparent 1px) 0 0 / 18px 18px`,
		`radial-gradient(circle at 85% 15%, rgb(255 255 255 / 0.9), transparent 55%)`,
		`repeating-radial-gradient(circle at 0 100%, ${INK} 0 2px, transparent 2px 16px)`
	];

	function hash(text: string): number {
		let h = 2166136261;
		for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 16777619);
		return h >>> 0;
	}

	function artStyle(quizId: string): string {
		const h = hash(quizId);
		const tint = ART_TINTS[h % ART_TINTS.length];
		const pattern = ART_PATTERNS[(h >>> 8) % ART_PATTERNS.length];
		const flip = (h >>> 3) & 1 ? -1 : 1;
		const zoom = 1.04 + ((h >>> 4) % 4) * 0.07;
		const x = 40 + ((h >>> 13) % 21);
		const y = 35 + ((h >>> 18) % 21);
		return `--art-tint:${tint}; --art-pattern:${pattern}; --art-flip:${flip}; --art-zoom:${zoom}; --art-pos:${x}% ${y}%;`;
	}

	/** Transform for a card `depth` places into the stack (0 = top). */
	function stackStyle(depth: number): string {
		const scale = 1 - depth * 0.04;
		const y = depth * 10;
		return `transform: translateY(${y}px) scale(${scale}); opacity: ${depth >= VISIBLE ? 0 : 1};`;
	}
</script>

<section class="deck" aria-label="Your next exercise">
	<header class="deck-head">
		<div class="head-main">
			{@render title?.()}
			<button
				type="button"
				class="deck-chip"
				data-pace={pace}
				aria-haspopup="dialog"
				aria-controls="deck-chooser"
				onclick={() => (chooserOpen = true)}
			>
				<Icon name={PACE_ICONS[pace]} size="1.05em" />
				<span class="chip-pace">{DECK_PACES[pace].label}</span>
				<span class="chip-level tnum">{centre ?? '–'}</span>
				<Icon name="chevronDown" size="0.9em" />
			</button>
		</div>
		{@render aside?.()}
	</header>

	<div class="stage" bind:this={stageEl}>
		{#if !loaded}
			<div class="card ghost" aria-hidden="true"></div>
		{:else if !top}
			<div class="card empty">
				<Icon name="trophy" size="1.6em" />
				<p><strong>Nothing left to deal.</strong></p>
				<p>Every exercise around {centre} is done.</p>
				<button type="button" class="empty-cta" onclick={() => (chooserOpen = true)}>Change your deck</button>
			</div>
		{:else}
			{#key dealt}
				<!-- Bottom of the stack first, so the top card paints last. -->
				{#each deck.slice(0, VISIBLE + 1).reverse() as card, i (card.quiz.id)}
					{@const depth = Math.min(VISIBLE, deck.length - 1) - i}
					{@const isTop = depth === 0}
					{@const ribbon = facts?.[card.quiz.id]?.mark ?? null}
					{@const started = card.kind === 'continue' || inProgress.has(card.quiz.id)}
					<div
						class="card"
						class:top={isTop}
						class:dragging={isTop && dragging}
						class:leaving={isTop && leaving}
						class:started
						data-kind={card.kind}
						style="{isTop
							? `transform: translate(${dx}px, ${dy}px) rotate(${dx / 18}deg);`
							: stackStyle(depth)} animation-delay: {i * 70}ms;"
						tabindex={isTop ? 0 : -1}
						role="button"
						aria-label={isTop
							? `${card.quiz.title}. ${DECK_KIND_LABELS[card.kind]}, card ${handSize - deck.length + 1} of ${handSize}, ${card.quiz.level}, ${isStoryCard(card) ? 'interactive mystery' : isSongCard(card) ? 'sing-along' : typeLabel(card.quiz.type)}${started ? ', in progress' : ''}. ${card.reason} Press Enter to start, or the left arrow to skip.`
							: undefined}
						aria-hidden={isTop ? undefined : 'true'}
						onpointerdown={isTop ? onDown : undefined}
						onpointermove={isTop ? onMove : undefined}
						onpointerup={isTop ? onUp : undefined}
						onpointercancel={isTop ? onCancel : undefined}
						onkeydown={isTop ? onKey : undefined}
					>
						{#if isTop}
							<span class="stamp no" style="opacity:{Math.max(0, -lean)}" class:firm={decided && dx < 0}>Skip</span>
							<span class="stamp yes" style="opacity:{Math.max(0, lean)}" class:firm={decided && dx > 0}>Let's go</span>
						{/if}

						{#if started}
							<span class="started-badge"><InProgressBadge float /></span>
						{/if}

						{#if card.quiz.image}
							<!-- The quiz's scene as a cream band across the top of the card; it
							     stands in for the type disc. -->
							<div class="art-band" style={artStyle(card.quiz.id)}>
								<img class="art" src="/img/{card.quiz.image}.webp" alt="" width="1024" height="768" loading="lazy" draggable="false" />
							</div>
						{:else}
							<span class="type-disc" data-type={card.quiz.type} style={artStyle(card.quiz.id)}>
								<Icon name={isSongCard(card) ? 'headphones' : QUIZ_TYPE_ICONS[card.quiz.type]} size="1.6em" />
							</span>
						{/if}

						<!-- Why this card, and where it sits in this hand. "Card 3 of 12"
						     rather than "10 left": a count of what is left reads as the
						     whole course running out. -->
						<p class="kind-row">
							<span class="kind-label">{DECK_KIND_LABELS[card.kind]}</span>
							<span class="left tnum">{isTop ? `Card ${handSize - deck.length + 1} of ${handSize}` : ''}</span>
						</p>
						<h3 class="title">{card.quiz.title}</h3>
						<p class="reason">{card.reason}</p>

						<p class="meta">
							<span class="chip">{card.quiz.level}</span>
							<span class="chip">{isStoryCard(card) ? 'interactive mystery' : isSongCard(card) ? 'sing-along' : typeLabel(card.quiz.type)}</span>
							{#if ribbon}<DoneMark mark={ribbon} width={14} />{/if}
						</p>
					</div>
				{/each}
			{/key}
			{#if coach}
				<!-- First visit only: the gesture is invisible until someone says it
				     is there. A scrim over the top card, a hand that sweeps the arc
				     the finger would take, and the two directions named. Decorative
				     — the buttons below carry the same actions — so it never takes
				     a tap: the first drag goes straight through to the card. -->
				<div class="coach" aria-hidden="true">
					<div class="coach-inner">
						<div class="coach-stage">
							<svg class="coach-arc" viewBox="0 0 160 40" fill="none" aria-hidden="true">
								<path d="M12 28 Q80 2 148 28" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-dasharray="3 7" />
							</svg>
							<svg class="coach-hand" viewBox="0 0 24 24" fill="none" aria-hidden="true">
								<g
									stroke="currentColor"
									stroke-width="1.6"
									stroke-linecap="round"
									stroke-linejoin="round"
									fill="var(--paper, #fff)"
								>
									<path
										d="M9.2 13.4V4.6a1.6 1.6 0 0 1 3.2 0V11m0-.6a1.5 1.5 0 0 1 3 0V12m0-.8a1.5 1.5 0 0 1 3 0v1.2m0-.4a1.5 1.5 0 0 1 3 0V16a6 6 0 0 1-6 6h-1.6a7 7 0 0 1-5-2.1l-3.2-3.3a1.65 1.65 0 0 1 2.4-2.3l1.4 1.5"
									/>
								</g>
							</svg>
						</div>
						<p class="coach-title">Swipe the card</p>
						<p class="coach-ways">
							<span class="coach-way skip"><Icon name="arrowLeft" size="1em" stroke={2.25} /> Skip it</span>
							<span class="coach-way go">Start it <Icon name="arrowRight" size="1em" stroke={2.25} /></span>
						</p>
						<p class="coach-foot">… or use the buttons below</p>
					</div>
				</div>
			{/if}
		{/if}
	</div>

	<div class="controls" aria-hidden={!top}>
		<button
			type="button"
			class="ctl no"
			onclick={() => fling('left')}
			disabled={!top || !!leaving}
			aria-label="Skip this exercise"
			title="Skip (←)"
		>
			<Icon name="close" size="1.2em" stroke={2.25} />
			<span>Skip</span>
		</button>
		{#if onbrowse}
			<button type="button" class="browse" onclick={onbrowse} aria-haspopup="dialog" aria-controls="all-exercises">
				<Icon name="cards" size="1.15em" />
				<span>Exercise library</span>
			</button>
		{/if}
		<button
			type="button"
			class="ctl yes"
			onclick={() => fling('right')}
			disabled={!top || !!leaving}
			aria-label="Start this exercise"
			title="Let's go (→)"
		>
			<Icon name="check" size="1.2em" stroke={2.25} />
			<span>Let's go</span>
		</button>
	</div>
</section>

<Sheet bind:open={chooserOpen} title="Your deck" id="deck-chooser">
	<p class="q">How do you want to learn?</p>
	<div class="paces" role="radiogroup" aria-label="Pace" use:radioKeys>
		{#each DECK_PACE_ORDER as p (p)}
			<button
				type="button"
				class="pace"
				data-pace={p}
				role="radio"
				aria-checked={pace === p}
				tabindex={pace === p ? 0 : -1}
				onclick={() => pickPace(p)}
			>
				<span class="pace-icon"><Icon name={PACE_ICONS[p]} size="1.25em" /></span>
				<strong>{DECK_PACES[p].label}</strong>
				<small>{DECK_PACES[p].blurb}</small>
			</button>
		{/each}
	</div>

	<p class="q">Where are you?</p>
	<button type="button" class="lv auto" aria-pressed={level === null} onclick={() => pickLevel(null)}>
		Work it out from my progress <span class="tnum">({autoLevel ?? '–'})</span>
	</button>
	<div class="bands">
		{#each bands as band (band.name)}
			<div class="band">
				<span class="band-name">{band.name}</span>
				{#each band.levels as lv (lv)}
					<button type="button" class="lv tnum" aria-pressed={level === lv} onclick={() => pickLevel(lv)}>{lv}</button>
				{/each}
			</div>
		{/each}
	</div>
	<p class="note">Pick a level and the deck centres there. "Work it out" uses the furthest level you have finished anything in.</p>

	{#snippet footer()}
		<button type="button" class="deal" onclick={() => (chooserOpen = false)}>
			Deal {deck.length} cards
		</button>
	{/snippet}
</Sheet>

<style>
	.deck {
		flex: 1;
		display: flex;
		flex-direction: column;
		width: 100%;
		max-width: 28rem;
		margin: 0 auto;
	}

	/* One row: the heading with the deck chip under it, the ring on the right. */
	.deck-head {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
	}

	.head-main {
		min-width: 0;
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.35rem;
	}

	/* The deck chip: the current pace and level, and the way into the chooser.
	   Tinted by pace so the choice reads at a glance. */
	.deck-chip {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		max-width: 100%;
		padding: 0.35rem 0.75rem 0.35rem 0.6rem;
		border: 1px solid color-mix(in srgb, var(--pace) 35%, var(--line));
		border-radius: 999px;
		background: color-mix(in srgb, var(--pace) 8%, var(--surface));
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
		transition: border-color var(--fast) var(--ease-out);
	}

	.deck-chip:hover {
		border-color: var(--pace);
	}

	.deck-chip > :global(.icon:first-child) {
		color: var(--pace);
	}

	.chip-pace {
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.chip-level {
		padding-left: 0.45rem;
		border-left: 1px solid var(--line-strong);
		font-weight: 800;
	}

	/* Each pace has a colour; the chip and the chooser tiles both use it. */
	[data-pace] {
		--pace: var(--forest);
	}
	[data-pace='fast'] {
		--pace: var(--terracotta);
	}
	[data-pace='adventurous'] {
		--pace: var(--navy);
	}
	[data-pace='review'] {
		--pace: var(--ochre);
	}

	/* The stage: the box the cards are absolutely stacked in. It takes the
	   height the page leaves; the cap only stops a very tall monitor from
	   stretching the card into a strip. The
	   cards claim every touch (see .card.top), so a swipe never turns into a
	   scroll halfway through. */
	.stage {
		position: relative;
		flex: 1;
		width: 100%;
		min-height: 20rem;
		max-height: 44rem;
		margin: 1.1rem auto 0;
	}

	/* A fresh deal: the cards drop onto the table one after another. Uses the
	   separate `translate` property so it composes with the stack transform. */
	.stage .card:not(.ghost):not(.empty) {
		animation: deal-in var(--slow) var(--ease-out) backwards;
	}

	@keyframes deal-in {
		from {
			translate: 0 2.5rem;
			opacity: 0;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.stage .card:not(.ghost):not(.empty) {
			animation: none;
		}
	}

	.empty-cta {
		margin-top: 0.5rem;
		padding: 0.5rem 1rem;
		border: 1px solid var(--accent);
		border-radius: 999px;
		background: var(--surface);
		color: var(--accent-ink);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	/* -- the chooser sheet ---------------------------------------------------- */

	.q {
		margin: 0.25rem 0 0.6rem;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.q + .paces,
	.q + .lv {
		margin-bottom: 0.5rem;
	}

	.paces {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.6rem;
		margin-bottom: 1.4rem;
	}

	/* Icon and name on one line, the blurb under them. */
	.pace {
		display: grid;
		grid-template-columns: auto 1fr;
		align-items: center;
		gap: 0.25rem 0.55rem;
		padding: 0.7rem 0.8rem;
		border: 2px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.pace:hover {
		border-color: color-mix(in srgb, var(--pace) 50%, var(--line));
	}

	.pace:active {
		transform: scale(0.98);
	}

	.pace[aria-checked='true'] {
		border-color: var(--pace);
		background: color-mix(in srgb, var(--pace) 9%, var(--surface));
	}

	.pace-icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		border-radius: 50%;
		background: color-mix(in srgb, var(--pace) 14%, var(--surface));
		color: var(--pace);
	}

	.pace strong {
		color: var(--heading);
		font-size: var(--step-0);
	}

	.pace small {
		grid-column: 1 / -1;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.35;
	}

	.lv {
		padding: 0.4rem 0.75rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.lv:hover {
		border-color: var(--heading);
	}

	.lv[aria-pressed='true'] {
		border-color: var(--heading);
		background: var(--heading);
		color: var(--surface);
	}

	.lv.auto {
		display: block;
		width: 100%;
		text-align: left;
		border-radius: var(--radius-sm);
		padding: 0.6rem 0.9rem;
	}

	.lv.auto span {
		opacity: 0.75;
	}

	.bands {
		display: grid;
		gap: 0.45rem;
	}

	.band {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.4rem;
	}

	.band-name {
		width: 2rem;
		font-weight: 800;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.note {
		margin: 1rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.45;
	}

	.deal {
		display: block;
		width: 100%;
		padding: 0.8rem 1rem;
		border: 0;
		border-radius: 999px;
		background: var(--heading);
		color: var(--surface);
		font: inherit;
		font-weight: 800;
		cursor: pointer;
	}

	.deal:hover {
		background: var(--accent-ink);
	}

	.card {
		--kind: var(--navy);
		position: absolute;
		inset: 0;
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.55rem;
		padding: 1.4rem 1.5rem 1.25rem;
		border: 1px solid var(--line);
		border-top: 6px solid var(--kind);
		border-radius: calc(var(--radius) + 6px);
		background: var(--surface);
		box-shadow: 0 18px 40px -24px rgba(31, 58, 95, 0.45);
		overflow: hidden;
		user-select: none;
		-webkit-user-select: none;
		will-change: transform;
		transition:
			transform var(--slow) var(--ease-out),
			opacity var(--slow) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.card[data-kind='practise'] {
		--kind: var(--ochre);
	}
	.card[data-kind='review'] {
		--kind: var(--ochre);
	}
	.card[data-kind='next'] {
		--kind: var(--forest);
	}
	.card[data-kind='continue'] {
		--kind: var(--accent);
	}

	/* Started, not finished: an accent outline round the whole card and the
	   badge pinned over its picture, so it stands out of the stack. */
	.card.started {
		border-color: var(--accent);
		box-shadow:
			0 0 0 2px var(--accent),
			0 18px 40px -24px rgba(31, 58, 95, 0.45);
	}

	.started-badge {
		position: absolute;
		top: 1rem;
		left: 1rem;
		z-index: 1;
		pointer-events: none;
	}
	.card[data-kind='fresh'] {
		--kind: var(--terracotta);
	}

	/* The top card owns the touch: no browser scroll or pan to cancel the
	   pointer mid-swipe, and no long-press callout on iOS. */
	.card.top {
		cursor: grab;
		touch-action: none;
		-webkit-touch-callout: none;
	}

	.card.top:focus-visible {
		outline: 3px solid var(--accent);
		outline-offset: 3px;
	}

	/* While the finger is down the card must track it, not ease after it. */
	.card.dragging {
		cursor: grabbing;
		transition: box-shadow var(--medium) var(--ease-out);
		box-shadow: 0 28px 50px -24px rgba(31, 58, 95, 0.55);
	}

	.card.leaving {
		transition: transform var(--slow) cubic-bezier(0.3, 0.6, 0.5, 1), opacity var(--slow) var(--ease-out);
		opacity: 0;
	}

	.card.ghost {
		border-top-color: var(--line);
		background: var(--surface-alt);
	}

	.card.empty {
		align-items: center;
		justify-content: center;
		text-align: center;
		color: var(--ink-muted);
		border-top-color: var(--right);
	}

	.card.empty p {
		margin: 0;
	}

	.card.empty strong {
		color: var(--heading);
	}

	/* The two stamps sit in the top corners, tilted like a rubber stamp, and
	   fade in with the drag; past the threshold they go solid. */
	.stamp {
		position: absolute;
		top: 1.4rem;
		padding: 0.25rem 0.7rem;
		border: 3px solid currentColor;
		border-radius: 8px;
		font-size: var(--step-1);
		font-weight: 900;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		line-height: 1.1;
		pointer-events: none;
		transition: transform var(--fast) var(--ease-out);
	}

	.stamp.no {
		right: 1.4rem;
		color: var(--wrong);
		transform: rotate(12deg);
	}

	.stamp.yes {
		left: 1.4rem;
		color: var(--right);
		transform: rotate(-12deg);
	}

	.stamp.firm {
		transform: rotate(0deg) scale(1.08);
	}

	/* The scene's own cream (its paper is levelled to this colour), bleeding
	   to the card's edges; the scene's wide margins absorb the crop. */
	.art-band,
	.type-disc {
		flex: 1 1 0;
		align-self: stretch;
		min-height: 6rem;
		position: relative;
		margin: -1.4rem -1.5rem 0.2rem;
		background: #fbf5e4;
		overflow: hidden;
	}

	/* The card's own layer over everything in the band: its tint and pattern,
	   multiplied, so white paper takes the colour and dark lines stay dark. */
	.art-band::after,
	.type-disc::after {
		content: '';
		position: absolute;
		inset: 0;
		background: var(--art-pattern, none), var(--art-tint, transparent);
		mix-blend-mode: multiply;
		pointer-events: none;
	}

	/* The mirror and the framing come from artStyle(). */
	.art {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
		object-position: var(--art-pos, center 42%);
		/* Scaled about the centre and never below 1, so the scene always
		   covers the whole band whichever way it is flipped. */
		transform: scale(calc(var(--art-zoom, 1) * var(--art-flip, 1)), var(--art-zoom, 1));
		transform-origin: center;
		pointer-events: none;
	}

	.kind-row {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		gap: 0.5rem;
		align-self: stretch;
		margin: 0;
	}

	.left {
		font-size: 0.72rem;
		font-weight: 600;
		color: var(--ink-muted);
	}

	.kind-label {
		margin: 0;
		font-size: 0.7rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--kind);
	}

	/* Without a scene, the band is the exercise type's own tint and icon. */
	.type-disc {
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 2rem;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	.type-disc[data-type='reading'] { background: #e6ecf3; color: var(--navy); }
	.type-disc[data-type='fillBlank'] { background: #ebe7f4; color: #55478a; }
	.type-disc[data-type='vocabulary'] { background: #f9e7ee; color: #a33a63; }
	.type-disc[data-type='speakRepeat'] { background: #fbe9e2; color: #b5522a; }
	.type-disc[data-type='speaking'] { background: var(--accent-soft); color: var(--accent-ink); }
	.type-disc[data-type='listening'] { background: #e8efe9; color: var(--forest); }
	.type-disc[data-type='dictation'] { background: #f4eddc; color: var(--ochre-ink); }

	.title {
		margin: 0.35rem 0 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 700;
		line-height: 1.15;
		color: var(--heading);
		text-wrap: balance;
	}

	.reason {
		margin: 0;
		color: var(--ink-muted);
		line-height: 1.45;
	}

	.meta {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		flex-wrap: wrap;
		margin: auto 0 0;
	}

	.chip {
		padding: 0.15rem 0.6rem;
		border-radius: 999px;
		background: var(--surface-alt);
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink);
	}

	/* Below the stack: one row the width of the card — skip, the library,
	   and the start button, all on the same square-ish footprint so they read
	   as one control bar rather than three loose shapes. */
	.controls {
		display: flex;
		align-items: stretch;
		gap: 0.5rem;
		margin: 1.1rem auto 0;
		width: 100%;
	}

	.ctl {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.45rem;
		min-height: 3.25rem;
		padding: 0 1rem;
		border: 2px solid currentColor;
		border-radius: var(--radius);
		background: var(--surface);
		font: inherit;
		font-size: var(--step-0);
		font-weight: 700;
		cursor: pointer;
		transition:
			transform var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.ctl {
		flex: 0 0 auto;
	}

	.ctl.no {
		color: var(--wrong);
	}

	.ctl.yes {
		border-color: var(--right);
		background: var(--right);
		color: #fff;
		box-shadow: 0 10px 22px -14px var(--right);
	}

	.ctl:hover:not(:disabled) {
		transform: translateY(-2px);
	}

	.ctl.no:hover:not(:disabled) {
		background: var(--wrong);
		color: #fff;
	}

	.ctl:active:not(:disabled) {
		transform: scale(0.98);
	}

	.ctl:disabled {
		opacity: 0.35;
		cursor: default;
	}

	/* The way to the full list: the widest button of the three, because
	   picking your own exercise is a first-class way to use the course. */
	.browse {
		flex: 1;
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		min-height: 3.25rem;
		padding: 0 0.9rem;
		font-size: var(--step-0);
		font-weight: 700;
		border: 1px solid var(--accent);
		border-radius: var(--radius);
		background: var(--accent-soft);
		color: var(--accent-ink);
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.browse:hover {
		background: #f1d9cd;
		transform: translateY(-1px);
	}

	.browse:active {
		transform: scale(0.99);
	}

	/* A laptop or desktop: a slightly wider deck, so the taller card keeps a
	   card's proportions. */
	@media (min-width: 48rem) {
		.deck {
			max-width: 32rem;
		}
	}

	@media (max-width: 36rem) {
		.stage {
			margin-top: 0.8rem;
			min-height: 16rem;
		}
		.card {
			padding: 1rem 1.1rem 0.9rem;
			gap: 0.4rem;
		}
		.art-band,
		.type-disc {
			margin: -1rem -1.1rem 0.2rem;
		}
		.title {
			font-size: var(--step-1);
		}
		.reason {
			font-size: var(--step--1);
		}
		.stamp {
			top: 1rem;
			font-size: var(--step-0);
		}
		.controls {
			margin-top: 0.8rem;
			gap: 0.5rem;
		}
		.ctl,
		.browse {
			min-height: 2.9rem;
			font-size: var(--step--1);
			padding: 0 0.7rem;
		}
		.ctl span {
			display: none;
		}
	}
	/* ---- the first-visit swipe coach -----------------------------------
	   A scrim over the top card with a hand sweeping the arc a finger would
	   take. Pointer-transparent, so the very first drag reaches the card
	   underneath and dismisses it. */
	.coach {
		position: absolute;
		inset: 0;
		display: grid;
		place-items: center;
		padding: 1rem;
		border-radius: var(--radius);
		background: rgb(27 42 61 / 0.62);
		backdrop-filter: blur(2px);
		pointer-events: none;
		z-index: 5;
		animation: coach-in var(--slow) var(--ease-out) backwards;
	}

	.coach-inner {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.55rem;
		max-width: 18rem;
		padding: 1.1rem 1.3rem 0.95rem;
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 22px 44px -24px rgb(0 0 0 / 0.75);
		text-align: center;
	}

	.coach-stage {
		position: relative;
		width: 10rem;
		height: 3.4rem;
	}

	.coach-arc {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		color: var(--line-strong, var(--line));
	}

	.coach-hand {
		position: absolute;
		left: 50%;
		top: 0.45rem;
		width: 2.4rem;
		height: 2.4rem;
		margin-left: -1.2rem;
		color: var(--heading);
		filter: drop-shadow(0 4px 8px rgb(0 0 0 / 0.2));
		animation: coach-sweep 3s ease-in-out infinite;
	}

	.coach-title {
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	.coach-ways {
		display: flex;
		gap: 0.4rem;
		margin: 0;
		flex-wrap: wrap;
		justify-content: center;
	}

	.coach-way {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		padding: 0.25rem 0.6rem;
		border-radius: 999px;
		font-size: var(--step--1);
		font-weight: 700;
	}

	.coach-way.skip {
		background: rgb(180 69 47 / 0.12);
		color: var(--wrong);
	}

	.coach-way.go {
		background: rgb(45 90 61 / 0.12);
		color: var(--right);
	}

	.coach-foot {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink);
		opacity: 0.7;
	}

	@keyframes coach-in {
		from {
			opacity: 0;
		}
	}

	/* The arc: out to the right, back across to the left, home again — with a
	   tilt, so it reads as a hand rather than a sliding sticker. */
	@keyframes coach-sweep {
		0%,
		100% {
			transform: translate(0, 0) rotate(0deg);
			opacity: 1;
		}
		8% {
			transform: translate(0, 0.15rem) rotate(0deg);
		}
		28% {
			transform: translate(2.6rem, -0.5rem) rotate(14deg);
			opacity: 1;
		}
		38% {
			transform: translate(3rem, -0.3rem) rotate(14deg);
			opacity: 0;
		}
		48% {
			transform: translate(0, 0) rotate(0deg);
			opacity: 0;
		}
		56% {
			opacity: 1;
		}
		76% {
			transform: translate(-2.6rem, -0.5rem) rotate(-14deg);
			opacity: 1;
		}
		86% {
			transform: translate(-3rem, -0.3rem) rotate(-14deg);
			opacity: 0;
		}
		94% {
			transform: translate(0, 0) rotate(0deg);
			opacity: 0;
		}
	}

	/* Calm effects and reduced motion: the same words, standing still. */
	:global(html[data-effects='calm']) .coach,
	:global(html[data-effects='calm']) .coach-hand {
		animation: none;
	}

	@media (prefers-reduced-motion: reduce) {
		.coach,
		.coach-hand {
			animation: none;
		}
	}

	/* ---- the story card: the one card in the hand that is an EVENT -------
	   A night card: ink-navy, a breathing golden glow, and a slow torch beam
	   sweeping the scene — the episode's own flashlight. All motion is
	   switched off for calm effects and reduced motion. */
	.card[data-kind='story'] {
		background: linear-gradient(170deg, #24415f 0%, var(--navy) 55%, #16293f 100%);
		border-color: var(--ochre);
		animation: story-glow 3.2s ease-in-out infinite;
	}
	@keyframes story-glow {
		0%,
		100% {
			box-shadow:
				0 10px 28px rgb(0 0 0 / 0.28),
				0 0 0 1px rgb(217 164 65 / 0.55),
				0 0 18px rgb(217 164 65 / 0.3);
		}
		50% {
			box-shadow:
				0 10px 28px rgb(0 0 0 / 0.28),
				0 0 0 1px rgb(217 164 65 / 0.9),
				0 0 34px rgb(217 164 65 / 0.55);
		}
	}
	/* The torch beam: a soft diagonal bar of warm light crossing the scene. */
	.card[data-kind='story'] .art-band::before {
		content: '';
		position: absolute;
		inset: -20%;
		background: linear-gradient(
			105deg,
			transparent 38%,
			rgb(255 232 170 / 0.5) 48%,
			rgb(255 244 210 / 0.75) 50%,
			rgb(255 232 170 / 0.5) 52%,
			transparent 62%
		);
		mix-blend-mode: soft-light;
		transform: translateX(-70%);
		animation: story-torch 5.5s ease-in-out infinite;
		pointer-events: none;
		z-index: 1;
	}
	@keyframes story-torch {
		0%,
		12% {
			transform: translateX(-70%);
		}
		55%,
		68% {
			transform: translateX(70%);
		}
		100% {
			transform: translateX(-70%);
		}
	}
	/* Night typography: warm light on dark paper. */
	.card[data-kind='story'] .kind-label {
		color: var(--ochre-ink);
		letter-spacing: 0.1em;
	}
	.card[data-kind='story'] .kind-label::before {
		content: '✦ ';
	}
	.card[data-kind='story'] .kind-row .left,
	.card[data-kind='story'] .reason {
		color: #c6d2e0;
	}
	.card[data-kind='story'] .title {
		color: #fbf8f3;
	}
	.card[data-kind='story'] .meta .chip {
		color: #fbf8f3;
		border-color: rgb(251 248 243 / 0.35);
		background: rgb(251 248 243 / 0.08);
	}
	.card[data-kind='story'] .stamp.yes {
		color: var(--ochre-ink);
		border-color: var(--ochre);
	}
	/* Calm effects / reduced motion: the night card stays, the motion goes. */
	:global(html[data-effects='calm']) .card[data-kind='story'],
	:global(html[data-effects='calm']) .card[data-kind='story'] .art-band::before {
		animation: none;
	}
	@media (prefers-reduced-motion: reduce) {
		.card[data-kind='story'],
		.card[data-kind='story'] .art-band::before {
			animation: none;
		}
	}
	/* ---- the song card: the other EVENT in the hand -----------------------
	   A daylight card next to the story's night one: warm paper, a terracotta
	   frame, and a bouncing music mark — loud, not glowing. */
	.card[data-kind='song'] {
		background: linear-gradient(170deg, #fff4e6 0%, #ffe6cc 60%, #ffdcb8 100%);
		border-color: var(--accent);
		box-shadow:
			0 10px 28px rgb(0 0 0 / 0.14),
			0 0 0 1px rgb(200 90 50 / 0.45);
	}
	.card[data-kind='song'] .kind-label {
		color: var(--accent-ink);
		letter-spacing: 0.1em;
	}
	.card[data-kind='song'] .kind-label::before {
		content: '♪ ';
		display: inline-block;
		animation: song-bounce 1.1s ease-in-out infinite;
	}
	@keyframes song-bounce {
		0%,
		100% {
			transform: translateY(0);
		}
		50% {
			transform: translateY(-0.18em);
		}
	}
	.card[data-kind='song'] .type-disc {
		background: var(--accent);
		color: #fff;
	}
	.card[data-kind='song'] .stamp.yes {
		color: var(--accent-ink);
		border-color: var(--accent);
	}
	:global(html[data-effects='calm']) .card[data-kind='song'] .kind-label::before {
		animation: none;
	}
	@media (prefers-reduced-motion: reduce) {
		.card[data-kind='song'] .kind-label::before {
			animation: none;
		}
	}
</style>
