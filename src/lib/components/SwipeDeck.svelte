<script lang="ts">
	// The swipe deck — the course home's main event. A stack of exercise cards
	// dealt from what the learner has done and the level they say they are at:
	// drag (or arrow) right to open the exercise, left to drop it. Drops
	// persist, so a card swiped away stays away on the next visit until the
	// whole deck has been turned down, when the memory is wiped and it starts
	// again.
	//
	// Gestures are plain Pointer Events. The card follows the finger with a
	// little rotation; past the threshold a stamp ("Skip" / "Let's go") turns
	// solid and letting go flings the card off. Under the threshold it springs
	// back. Everything the gesture does is also on two buttons and the arrow
	// keys, so the deck works without a touch screen and without a mouse.
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import { DURATION, prefersReducedMotion } from '$lib/motion';
	import { progress } from '$lib/state/progress.svelte';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { goto } from '$app/navigation';
	import {
		DECK_KIND_LABELS,
		buildDeck,
		courseLevels,
		deckLevel,
		typeLabel,
		type DeckCard
	} from '$lib/domain/deck';
	import type { QuizFacts } from '$lib/domain/recommend';
	import type { CourseSummary } from '$lib/content/types';
	import { untrack } from 'svelte';

	let {
		course,
		ready
	}: {
		course: CourseSummary;
		/** True once the page has loaded progress and the per-quiz stats. */
		ready: boolean;
	} = $props();

	// "quiz_" in the key puts the skips in the set that "start over" wipes.
	// The level pick is a preference, not progress, so it survives a reset.
	const SKIPPED_KEY = 'quiz_recommend_skipped';
	const LEVEL_KEY = 'deck_level';
	const SKIPPED_LIMIT = 80;
	/** How many cards of the stack are drawn behind the top one. */
	const VISIBLE = 3;

	let facts = $state<Record<string, QuizFacts>>({});
	let skipped = $state<string[]>([]);
	let level = $state<string | null>(null);
	let deck = $state<DeckCard[]>([]);
	let loaded = $state(false);

	const levels = $derived(courseLevels(course.quizzes));
	const centre = $derived(deckLevel(course.quizzes, facts, level));
	const levelTitle = $derived(
		(lv: string) => course.nav.groups.find((g) => g.type === 'questChain' && g.level === lv)?.title ?? lv
	);

	$effect(() => {
		if (!ready) return;
		// Reads rune state it must not subscribe to — a stat written while
		// loading would re-run this and start the load again.
		untrack(() => void load());
	});

	async function load() {
		const next: Record<string, QuizFacts> = {};
		for (const quiz of course.quizzes) {
			const history = await progress.historyFor(quiz.storageKeyPrefix);
			next[quiz.id] = {
				done: progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix),
				tier: progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix),
				answered: history.answered,
				mistakeRate: history.mistakeRate
			};
		}
		facts = next;
		try {
			const raw = await storage.get(SKIPPED_KEY);
			const parsed = raw ? JSON.parse(raw) : [];
			skipped = Array.isArray(parsed) ? parsed.map(String) : [];
		} catch {
			skipped = [];
		}
		const picked = await storage.get(LEVEL_KEY);
		level = picked && levels.includes(picked) ? picked : null;
		deal();
		loaded = true;
	}

	/** Rebuilds the stack; forgets the skips first if they have eaten everything. */
	function deal() {
		deck = buildDeck(course.quizzes, facts, { level, skipped: new Set(skipped) });
		if (deck.length === 0 && skipped.length > 0) {
			skipped = [];
			void storage.set(SKIPPED_KEY, '[]');
			deck = buildDeck(course.quizzes, facts, { level });
		}
	}

	async function pickLevel(event: Event) {
		const value = (event.currentTarget as HTMLSelectElement).value;
		level = value || null;
		if (level) await storage.set(LEVEL_KEY, level);
		else await storage.remove(LEVEL_KEY);
		track('deck_level_picked', { course: course.id, level: level ?? 'auto' });
		deal();
	}

	// ---- the gesture -------------------------------------------------------

	/** Drag distance that counts as a decision, in px. */
	const THRESHOLD = 110;
	/** How far the card flies when released past the threshold. */
	const FLING = 900;

	let dx = $state(0);
	let dy = $state(0);
	let dragging = $state(false);
	/** Set while the top card is flying off; the deck is inert until it lands. */
	let leaving = $state<'left' | 'right' | null>(null);
	let startX = 0;
	let startY = 0;
	let pointerId: number | null = null;

	const top = $derived(deck[0] ?? null);
	const lean = $derived(Math.max(-1, Math.min(1, dx / THRESHOLD)));
	const decided = $derived(Math.abs(dx) >= THRESHOLD);

	function href(card: DeckCard) {
		return `/course/${course.id}/quiz/${card.quiz.id}`;
	}

	function onDown(event: PointerEvent) {
		if (leaving || !top) return;
		// A click on the ribbon or a nested link is still a drag start; only
		// the buttons below the stack are outside the gesture.
		pointerId = event.pointerId;
		startX = event.clientX;
		startY = event.clientY;
		dragging = true;
		(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId);
	}

	function onMove(event: PointerEvent) {
		if (!dragging || event.pointerId !== pointerId) return;
		dx = event.clientX - startX;
		dy = (event.clientY - startY) * 0.4;
	}

	function onUp(event: PointerEvent) {
		if (!dragging || event.pointerId !== pointerId) return;
		dragging = false;
		pointerId = null;
		if (dx >= THRESHOLD) fling('right');
		else if (dx <= -THRESHOLD) fling('left');
		else {
			dx = 0;
			dy = 0;
		}
	}

	/** Sends the top card off and acts once it has gone. */
	function fling(direction: 'left' | 'right') {
		if (!top || leaving) return;
		const card = top;
		leaving = direction;
		dx = direction === 'right' ? FLING : -FLING;
		const wait = prefersReducedMotion() ? 0 : DURATION.slow;
		window.setTimeout(() => {
			if (direction === 'left') {
				skipped = [...skipped.filter((id) => id !== card.quiz.id), card.quiz.id].slice(-SKIPPED_LIMIT);
				void storage.set(SKIPPED_KEY, JSON.stringify(skipped));
				track('deck_swipe', { course: course.id, quiz: card.quiz.id, kind: card.kind, choice: 'skip' });
				deck = deck.slice(1);
				if (deck.length === 0) deal();
			} else {
				track('deck_swipe', { course: course.id, quiz: card.quiz.id, kind: card.kind, choice: 'go' });
				void goto(href(card));
			}
			dx = 0;
			dy = 0;
			leaving = null;
		}, wait);
	}

	function onKey(event: KeyboardEvent) {
		if (event.key === 'ArrowRight' || event.key === 'Enter') {
			event.preventDefault();
			fling('right');
		} else if (event.key === 'ArrowLeft' || event.key === 'Backspace') {
			event.preventDefault();
			fling('left');
		}
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
		<div>
			<p class="eyebrow">Your deck</p>
			<p class="deck-lede">
				Swipe right to start an exercise, left to pass. The cards come from your level and what you have done so far.
			</p>
		</div>
		<label class="level-pick">
			<span>I'm at</span>
			<select value={level ?? ''} onchange={pickLevel} aria-label="Your German level">
				<option value="">auto ({centre ?? '–'})</option>
				{#each levels as lv (lv)}
					<option value={lv}>{lv}</option>
				{/each}
			</select>
			<Icon name="chevronDown" size="0.9em" />
		</label>
	</header>

	<div class="stage">
		{#if !loaded}
			<div class="card ghost" aria-hidden="true"></div>
		{:else if !top}
			<div class="card empty">
				<Icon name="trophy" size="1.6em" />
				<p><strong>Nothing left to deal.</strong></p>
				<p>Every exercise around {centre} is done. Pick a higher level above to keep going.</p>
			</div>
		{:else}
			<!-- Bottom of the stack first, so the top card paints last. -->
			{#each deck.slice(0, VISIBLE + 1).reverse() as card, i (card.quiz.id)}
				{@const depth = Math.min(VISIBLE, deck.length - 1) - i}
				{@const isTop = depth === 0}
				{@const ribbon = facts[card.quiz.id]?.tier ?? null}
				<div
					class="card"
					class:top={isTop}
					class:dragging={isTop && dragging}
					class:leaving={isTop && leaving}
					data-kind={card.kind}
					style={isTop
						? `transform: translate(${dx}px, ${dy}px) rotate(${dx / 18}deg);`
						: stackStyle(depth)}
					tabindex={isTop ? 0 : -1}
					role="button"
					aria-label={isTop ? `${card.quiz.title}. ${card.reason}` : undefined}
					aria-hidden={isTop ? undefined : 'true'}
					onpointerdown={isTop ? onDown : undefined}
					onpointermove={isTop ? onMove : undefined}
					onpointerup={isTop ? onUp : undefined}
					onpointercancel={isTop ? onUp : undefined}
					onkeydown={isTop ? onKey : undefined}
				>
					{#if isTop}
						<span class="stamp no" style="opacity:{Math.max(0, -lean)}" class:firm={decided && dx < 0}>Skip</span>
						<span class="stamp yes" style="opacity:{Math.max(0, lean)}" class:firm={decided && dx > 0}>Let's go</span>
					{/if}

					{#if card.quiz.image}
						<!-- The quiz's scene as a cream band across the top of the card; it
						     stands in for the type disc. -->
						<div class="art-band">
							<img class="art" src="/img/{card.quiz.image}.webp" alt="" width="1024" height="768" loading="lazy" draggable="false" />
						</div>
					{/if}

					<p class="kind-label">For you · <strong>{DECK_KIND_LABELS[card.kind]}</strong></p>

					{#if !card.quiz.image}
						<span class="type-disc" data-type={card.quiz.type}>
							<Icon name={QUIZ_TYPE_ICONS[card.quiz.type]} size="1.6em" />
						</span>
					{/if}

					<h3 class="title">{card.quiz.title}</h3>
					<p class="reason">{card.reason}</p>

					<p class="meta">
						<span class="chip">{card.quiz.level}</span>
						<span class="chip">{typeLabel(card.quiz.type)}</span>
						{#if ribbon}<RibbonBadge tier={ribbon} width={14} />{/if}
					</p>
					<p class="level-name">{levelTitle(card.quiz.level ?? '')}</p>
				</div>
			{/each}
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
			<Icon name="close" size="1.4em" stroke={2.25} />
		</button>
		<span class="count tnum">{deck.length} in the deck</span>
		<button
			type="button"
			class="ctl yes"
			onclick={() => fling('right')}
			disabled={!top || !!leaving}
			aria-label="Start this exercise"
			title="Let's go (→)"
		>
			<Icon name="check" size="1.4em" stroke={2.25} />
		</button>
	</div>
</section>

<style>
	.deck {
		flex: 1;
		display: flex;
		flex-direction: column;
		margin: 1.75rem 0 0;
	}

	.deck-head {
		display: flex;
		align-items: flex-end;
		justify-content: space-between;
		gap: 1rem 2rem;
		flex-wrap: wrap;
	}

	.deck-lede {
		margin: 0.15rem 0 0;
		max-width: 38rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	/* The level picker looks like a chip; the native select hides inside it so
	   phones get their own picker for free. */
	.level-pick {
		position: relative;
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.4rem 0.85rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--heading);
		cursor: pointer;
	}

	.level-pick span {
		color: var(--ink-muted);
		font-weight: 600;
	}

	.level-pick select {
		appearance: none;
		border: 0;
		background: none;
		font: inherit;
		font-weight: 800;
		color: inherit;
		padding: 0 0.1rem;
		cursor: pointer;
	}

	.level-pick select:focus-visible {
		outline: 2px solid var(--accent);
		outline-offset: 2px;
		border-radius: 4px;
	}

	/* The stage: a fixed-height box the cards are absolutely stacked in. Height
	   is generous so the reason line never pushes the meta off the card. */
	.stage {
		position: relative;
		flex: 1;
		width: 100%;
		min-height: 20rem;
		max-height: 24rem;
		margin: 1.25rem auto 0;
		max-width: 26rem;
		touch-action: pan-y;
		perspective: 1000px;
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
	.card[data-kind='next'] {
		--kind: var(--forest);
	}
	.card[data-kind='fresh'] {
		--kind: var(--terracotta);
	}

	.card.top {
		cursor: grab;
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
	.art-band {
		flex: none;
		align-self: stretch;
		height: 42%;
		margin: -1.4rem -1.5rem 0.2rem;
		background: #fbf5e4;
		overflow: hidden;
	}

	.art {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
		object-position: center 42%;
		pointer-events: none;
	}

	.kind-label {
		margin: 0;
		font-size: 0.7rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.kind-label strong {
		color: var(--kind);
	}

	.type-disc {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3.4rem;
		height: 3.4rem;
		margin-top: 0.4rem;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	.type-disc[data-type='reading'] { background: #e6ecf3; color: var(--navy); }
	.type-disc[data-type='fillBlank'] { background: #ebe7f4; color: #55478a; }
	.type-disc[data-type='vocabulary'] { background: #f9e7ee; color: #a33a63; }
	.type-disc[data-type='speakRepeat'] { background: #fbe9e2; color: #b5522a; }
	.type-disc[data-type='speaking'] { background: var(--accent-soft); color: var(--accent); }
	.type-disc[data-type='listening'] { background: #e8efe9; color: var(--forest); }
	.type-disc[data-type='dictation'] { background: #f4eddc; color: var(--ochre); }

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

	.level-name {
		margin: 0;
		font-size: 0.7rem;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	/* Below the stack: the two round buttons Tinder taught everyone. */
	.controls {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 1.5rem;
		margin: 1.25rem 0 0;
	}

	.ctl {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3.6rem;
		height: 3.6rem;
		border: 2px solid currentColor;
		border-radius: 50%;
		background: var(--surface);
		cursor: pointer;
		transition:
			transform var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.ctl.no {
		color: var(--wrong);
	}

	.ctl.yes {
		color: var(--right);
		box-shadow: 0 10px 22px -14px var(--right);
	}

	.ctl:hover:not(:disabled) {
		transform: translateY(-2px) scale(1.06);
	}

	.ctl.yes:hover:not(:disabled) {
		background: var(--right);
		color: #fff;
	}

	.ctl.no:hover:not(:disabled) {
		background: var(--wrong);
		color: #fff;
	}

	.ctl:active:not(:disabled) {
		transform: scale(0.95);
	}

	.ctl:disabled {
		opacity: 0.35;
		cursor: default;
	}

	.count {
		min-width: 7rem;
		text-align: center;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	@media (max-width: 36rem) {
		.deck {
			margin-top: 0.9rem;
		}
		/* One row: the label left, the level chip right; the how-to goes. */
		.deck-head {
			align-items: center;
			flex-wrap: nowrap;
		}
		.deck-lede {
			display: none;
		}
		.level-pick {
			padding: 0.3rem 0.7rem;
		}
		.stage {
			margin-top: 0.75rem;
			min-height: 15rem;
		}
		.card {
			padding: 1rem 1.1rem 0.9rem;
			gap: 0.4rem;
		}
		.type-disc {
			width: 2.6rem;
			height: 2.6rem;
			margin-top: 0.1rem;
		}
		.title {
			font-size: var(--step-1);
		}
		.reason {
			font-size: var(--step--1);
		}
		.level-name {
			display: none;
		}
		.stamp {
			top: 1rem;
			font-size: var(--step-0);
		}
		.controls {
			margin-top: 0.8rem;
			gap: 1.1rem;
		}
		.ctl {
			width: 3.1rem;
			height: 3.1rem;
		}
	}
</style>
