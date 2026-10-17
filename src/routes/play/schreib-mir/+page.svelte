<script lang="ts">
	// "Schreib mir!" — the matches. A stack of profile cards, easiest module
	// first: swipe right (or the heart) to match and start the chat, left to
	// put the card at the back. The chips narrow the stack to one level. A
	// character you have already chatted with shows how it ended, because
	// every chat happens once; a hidden character joins the stack only once
	// another chat's secret ending has unlocked them.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { breadcrumbLd } from '$lib/seo';
	import { loadChat, MATCH_CHATS, MATCH_PATH, contacts, type MatchChat, type SavedChat } from '$lib/domain/matchChat';
	import { gameTickets, nextTicketAt } from '$lib/domain/janein';
	import TicketStub from '$lib/components/match/TicketStub.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { playSound } from '$lib/services/sounds';
	import { effectsCalm } from '$lib/motion/fx.svelte';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';

	type Card = { chat: MatchChat; saved: SavedChat | null };
	const LEVELS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'] as const;
	const LEVEL_KEY = 'match_level_filter';

	let all = $state<Card[]>([]);
	let cards = $state<Card[]>([]);
	let level = $state<string>('all');
	let saidContacts = $state(0);
	/** Shared with Ja oder Nein?: a new chat costs one. */
	let tickets = $state(0);
	let refillAt = $state(0);
	/** A heart on a new profile with an empty pocket: the "no ticket" panel. */
	let broke = $state<MatchChat | null>(null);
	let shake = $state(0);
	let matched = $state<MatchChat | null>(null);

	// -- the gesture ---------------------------------------------------------
	let dx = $state(0);
	let dragging = $state(false);
	let leaving = $state<'left' | 'right' | null>(null);
	let startX = 0;
	let pointer: number | null = null;
	const THRESHOLD = 90;
	const lean = $derived(Math.max(-1, Math.min(1, dx / THRESHOLD)));

	onMount(() => {
		const saved = new Map(MATCH_CHATS.map((c) => [c.id, loadChat(c.id)]));
		// A hidden character is in the stack once the chat that unlocks them ended in its secret.
		const unlocked = new Set(
			MATCH_CHATS.filter((c) => c.unlocks && saved.get(c.id)?.ending === 'secret').map((c) => c.unlocks!.id)
		);
		all = MATCH_CHATS.filter((c) => !c.hidden || unlocked.has(c.id)).map((chat) => ({ chat, saved: saved.get(chat.id) ?? null }));
		// Chats not yet played come first, in module order; finished ones after.
		all = [...all.filter((c) => !c.saved?.ending), ...all.filter((c) => c.saved?.ending)];
		try {
			level = localStorage.getItem(LEVEL_KEY) ?? 'all';
		} catch {
			/* no storage: show everything */
		}
		pick(level);
		saidContacts = contacts().length;
		tickets = gameTickets();
		refillAt = nextTicketAt();
	});

	function pick(next: string) {
		level = next;
		cards = all.filter((c) => next === 'all' || c.chat.level.startsWith(next));
		try {
			localStorage.setItem(LEVEL_KEY, next);
		} catch {
			/* remembered for this visit only */
		}
	}

	const count = (lvl: string) => all.filter((c) => c.chat.level.startsWith(lvl)).length;
	const top = $derived(cards[0]);

	function status(saved: SavedChat | null): { label: string; tone: string } | null {
		if (!saved) return null;
		if (saved.ending === 'win' || saved.ending === 'secret') return { label: '❤️ Liked you · in your contacts', tone: 'win' };
		if (saved.ending === 'deleted') return { label: '💔 Deleted you', tone: 'lost' };
		if (saved.ending === 'partial') return { label: '📦 Met · no like', tone: 'mid' };
		return { label: '💬 Chat in progress', tone: 'live' };
	}

	function onDown(e: PointerEvent) {
		if (leaving) return;
		pointer = e.pointerId;
		startX = e.clientX;
		dragging = true;
		(e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
	}
	function onMove(e: PointerEvent) {
		if (!dragging || e.pointerId !== pointer) return;
		dx = e.clientX - startX;
	}
	function onUp(e: PointerEvent) {
		if (!dragging || e.pointerId !== pointer) return;
		dragging = false;
		pointer = null;
		if (dx > THRESHOLD) like();
		else if (dx < -THRESHOLD) pass();
		else dx = 0;
	}

	async function fly(dir: 'left' | 'right') {
		leaving = dir;
		dx = dir === 'right' ? 600 : -600;
		await new Promise((r) => setTimeout(r, effectsCalm() ? 0 : 260));
		leaving = null;
		dx = 0;
	}

	async function pass() {
		if (!top || cards.length < 2) return;
		await fly('left');
		cards = [...cards.slice(1), cards[0]];
	}

	async function like() {
		if (!top) return;
		if (top.saved) {
			void goto(`${MATCH_PATH}/${top.chat.id}`);
			return;
		}
		// No ticket for a new chat: the card stays, shakes, and says how to get one.
		if (tickets <= 0) {
			dx = 0;
			shake++;
			playSound('down');
			broke = top.chat;
			announce('No ticket left. Win one in a run, or wait for the next free one.');
			return;
		}
		await fly('right');
		playSound('up');
		matched = top.chat;
	}

	function onKey(e: KeyboardEvent) {
		if (e.key === 'ArrowRight' || e.key === 'Enter') {
			e.preventDefault();
			void like();
		} else if (e.key === 'ArrowLeft') {
			e.preventDefault();
			void pass();
		}
	}
</script>

<Seo
	title="Schreib mir! Chat your way in, in German"
	description="Swipe a character, match, and chat to reach a goal by building German sentences from word tiles, from A1 to C2. Every chat happens once: get a like and a new contact, or get deleted."
	path={MATCH_PATH}
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Schreib mir!', path: MATCH_PATH }])]}
/>

<main class="deck-page">
	<header class="head">
		<a class="back" href="/course/de_cert_a1" aria-label="Back to your deck"><Icon name="arrowLeft" size="1.1em" /></a>
		<div>
			<h1 lang="de">Schreib mir!</h1>
			<p>Match a character. Chat to reach their goal. Every chat happens once. <span class="pocket">🎟️ {tickets}</span></p>
		</div>
		<a class="contacts-link" href="{MATCH_PATH}/kontakte">
			<Icon name="chat" size="1.05em" /> Contacts{#if saidContacts}<span class="count">{saidContacts}</span>{/if}
		</a>
	</header>

	<div class="chips" role="group" aria-label="Level">
		<button type="button" class="chip" aria-pressed={level === 'all'} onclick={() => pick('all')}>All <span>{all.length}</span></button>
		{#each LEVELS as lvl (lvl)}
			{#if count(lvl)}
				<button type="button" class="chip" aria-pressed={level === lvl} onclick={() => pick(lvl)}>{lvl} <span>{count(lvl)}</span></button>
			{/if}
		{/each}
	</div>

	<section class="stack" aria-label="Profiles">
		{#each cards.slice(0, 3).toReversed() as card, i (card.chat.id)}
			{@const depth = Math.min(cards.length, 3) - 1 - i}
			{@const isTop = depth === 0}
			{@const st = status(card.saved)}
			<!-- svelte-ignore a11y_no_noninteractive_tabindex -->
			<article
				class="profile"
				class:top={isTop}
				class:dragging={isTop && dragging}
				class:locked={!card.saved && tickets <= 0}
				class:leaving={isTop && leaving}
				style:--depth={depth}
				style={isTop ? `transform: translateX(${dx}px) rotate(${dx / 18}deg);` : undefined}
				aria-hidden={isTop ? undefined : 'true'}
				tabindex={isTop ? 0 : -1}
				aria-roledescription="profile card"
				aria-label="{card.chat.name}, {card.chat.age}, level {card.chat.level}. {card.chat.bioEn} Goal: {card.chat.goal}. Right arrow to match, left arrow for later."
				onpointerdown={isTop ? onDown : undefined}
				onpointermove={isTop ? onMove : undefined}
				onpointerup={isTop ? onUp : undefined}
				onpointercancel={isTop ? onUp : undefined}
				onkeydown={isTop ? onKey : undefined}
			>
				<div class="pic">
					<img src="/img/story/{card.chat.image}.webp" alt="" draggable="false" />
					{#if isTop}
						<span class="stamp like" style:opacity={Math.max(0, lean)}>MATCH</span>
						<span class="stamp nope" style:opacity={Math.max(0, -lean)}>LATER</span>
					{/if}
					{#if st}<span class="status" data-tone={st.tone}>{st.label}</span>{/if}
					{#if !card.saved?.ending}
						<span class="stub-pos"><TicketStub free={!!card.saved} pocket={tickets} {refillAt} /></span>
					{/if}
				</div>
				<div class="info">
					<h2>{card.chat.emoji} {card.chat.name}, {card.chat.age} <span class="lvl">{card.chat.level}</span></h2>
					<p class="bio" lang="de">„{card.chat.bio}“</p>
					<p class="bio-en">{card.chat.bioEn}</p>
					<p class="goal"><span aria-hidden="true">🎯</span> {card.chat.goal}</p>
					{#if card.chat.focus}<p class="focus" lang="de">{card.chat.focus}</p>{/if}
				</div>
			</article>
		{:else}
			<p class="empty">No characters at this level yet.</p>
		{/each}
	</section>

	<div class="buttons">
		<button type="button" class="round nope" onclick={pass} aria-label="Later: next card"><Icon name="close" size="1.6em" /></button>
		{#key shake}
			<button
				type="button"
				class="round heart"
				class:no-ticket={!top?.saved && tickets <= 0}
				class:nudge={shake > 0}
				onclick={like}
				aria-label={top?.saved ? 'Open the chat' : tickets <= 0 ? 'Match: needs a ticket' : 'Match: costs 1 ticket'}
			>
				<Icon name="heart" size="1.7em" />
				{#if !top?.saved}<span class="heart-cost">{tickets <= 0 ? '🔒' : '🎟️1'}</span>{/if}
			</button>
		{/key}
	</div>
	<p class="how">Swipe right or tap the heart to match · left for later</p>
</main>

{#if broke}
	<div class="match-scrim broke" role="dialog" aria-modal="true" aria-labelledby="broke-title">
		<div class="match">
			<p class="its" id="broke-title" lang="de">Kein Ticket mehr!</p>
			<div class="pair">
				<img src="/img/story/{broke.image}.webp" alt="" class="sad" />
			</div>
			<p>{broke.name} is waiting, but a new chat costs one ticket and your pocket is empty.</p>
			<p class="rule">
				Next free ticket: {new Date(refillAt).toLocaleString('en-GB', { weekday: 'long', hour: '2-digit', minute: '2-digit' })}. A run of
				8 out of 10 or better can win one sooner. Tickets are shared with <span lang="de">Ja oder Nein?</span>
			</p>
			<a class="btn" href="/course/de_cert_a1"><Icon name="bolt" size="1em" /> Win a ticket in a run</a>
			<button type="button" class="btn-quiet" onclick={() => (broke = null)}>Keep browsing</button>
		</div>
	</div>
{/if}

{#if matched}
	<div class="match-scrim" role="dialog" aria-modal="true" aria-labelledby="match-title">
		<div class="match">
			<p class="its" id="match-title" lang="de">Ihr passt zusammen!</p>
			<div class="pair">
				<span class="me" aria-hidden="true">🙂</span>
				<span class="spark" aria-hidden="true">❤</span>
				<img src="/img/story/{matched.image}.webp" alt="" />
			</div>
			<p>You and {matched.name} matched. Your goal: <strong>{matched.goal}</strong></p>
			<p class="rule">One chat, one chance. Build your answers from the word tiles. Starting costs 🎟️ 1 ({tickets} in your pocket).</p>
			<a class="btn" href="{MATCH_PATH}/{matched.id}"><Icon name="chat" size="1em" /> <span lang="de">Schreib los!</span></a>
			<button type="button" class="btn-quiet" onclick={() => (matched = null)}>Not now</button>
		</div>
	</div>
{/if}

<style>
	.deck-page {
		min-height: 100dvh;
		max-width: 30rem;
		margin: 0 auto;
		padding: 0.8rem 1rem 1.5rem;
		display: grid;
		grid-template-rows: auto auto 1fr auto auto;
		gap: 0.8rem;
		overflow-x: clip;
	}
	.head {
		display: flex;
		align-items: flex-start;
		gap: 0.6rem;
	}
	.head h1 {
		margin: 0;
		font-size: var(--step-2);
		color: var(--terracotta);
	}
	.head p {
		margin: 0.1rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.head > div {
		flex: 1;
	}
	.back {
		padding-top: 0.45rem;
		color: var(--ink);
	}
	.contacts-link {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		padding: 0.35rem 0.7rem;
		border-radius: 999px;
		border: 1.5px solid var(--line-strong);
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--heading);
		text-decoration: none;
		white-space: nowrap;
	}
	.count {
		display: inline-grid;
		place-items: center;
		min-width: 1.2rem;
		height: 1.2rem;
		border-radius: 999px;
		background: #e0475b;
		color: #fff;
		font-size: 0.7rem;
	}
	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
	}
	.chip {
		padding: 0.25rem 0.7rem;
		border-radius: 999px;
		border: 1.5px solid var(--line-strong);
		background: var(--surface);
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--heading);
		cursor: pointer;
	}
	.chip span {
		font-weight: 400;
		color: var(--ink-muted);
	}
	.chip[aria-pressed='true'] {
		background: var(--navy);
		border-color: var(--navy);
		color: #fff;
	}
	.chip[aria-pressed='true'] span {
		color: rgb(255 255 255 / 0.75);
	}
	.focus {
		margin: 0.35rem 0 0;
		font-size: 0.75rem;
		color: var(--terracotta);
		font-weight: 600;
	}
	.empty {
		color: var(--ink-muted);
		text-align: center;
		padding-top: 30%;
	}
	.stack {
		position: relative;
		min-height: min(68dvh, 34rem);
	}
	.profile {
		position: absolute;
		inset: 0;
		display: grid;
		grid-template-rows: 1fr auto;
		border-radius: 1.2rem;
		overflow: hidden;
		background: var(--surface);
		box-shadow: 0 10px 30px rgb(31 58 95 / 0.18);
		transform: translateY(calc(var(--depth) * 10px)) scale(calc(1 - var(--depth) * 0.04));
		transition: transform 260ms var(--ease-out, ease-out);
		touch-action: pan-y;
		user-select: none;
		cursor: grab;
	}
	.profile.top {
		z-index: 2;
	}
	.profile.dragging {
		transition: none;
		cursor: grabbing;
	}
	.profile.leaving {
		transition: transform 260ms ease-in;
	}
	.pic {
		position: relative;
		min-height: 0;
		background: #f0e6d2;
	}
	.pic img {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
		object-position: 50% 30%;
		pointer-events: none;
	}
	.stamp {
		position: absolute;
		top: 1.2rem;
		padding: 0.2rem 0.7rem;
		border: 4px solid;
		border-radius: 0.5rem;
		font-size: 2rem;
		font-weight: 900;
		letter-spacing: 0.08em;
		background: rgb(255 255 255 / 0.7);
	}
	.stamp.like {
		left: 1rem;
		color: #2e8b57;
		transform: rotate(-14deg);
	}
	.stamp.nope {
		right: 1rem;
		color: var(--wrong);
		transform: rotate(14deg);
	}
	.status {
		position: absolute;
		left: 0.8rem;
		bottom: 0.8rem;
		padding: 0.25rem 0.75rem;
		border-radius: 999px;
		background: rgb(255 255 255 / 0.92);
		font-size: var(--step--1);
		font-weight: 700;
	}
	.pocket {
		display: inline-block;
		margin-left: 0.2rem;
		padding: 0 0.45rem;
		border-radius: 999px;
		background: linear-gradient(120deg, #c2364a, #ff6b81);
		color: #fff;
		font-weight: 700;
	}
	.stub-pos {
		position: absolute;
		top: 0.8rem;
		right: 0.8rem;
		z-index: 3;
	}
	.profile.locked .pic img {
		filter: grayscale(0.7) brightness(0.9);
	}
	.round.heart {
		position: relative;
	}
	.round.heart.no-ticket {
		color: #8a8f99;
	}
	.round.heart.nudge {
		animation: no 380ms ease;
	}
	.heart-cost {
		position: absolute;
		bottom: -0.35rem;
		right: -0.5rem;
		padding: 0.05rem 0.35rem;
		border-radius: 999px;
		background: linear-gradient(120deg, #c2364a, #ff6b81);
		color: #fff;
		font-size: 0.65rem;
		font-weight: 800;
		box-shadow: 0 2px 6px rgb(0 0 0 / 0.2);
	}
	.round.heart.no-ticket .heart-cost {
		background: #5c6270;
	}
	.match-scrim.broke {
		background: linear-gradient(160deg, rgb(92 98 112 / 0.95), rgb(31 58 95 / 0.96));
	}
	.pair img.sad {
		filter: grayscale(0.6);
	}
	@keyframes no {
		25% {
			transform: translateX(-6px);
		}
		75% {
			transform: translateX(6px);
		}
	}
	.status[data-tone='lost'] {
		color: var(--wrong);
	}
	.status[data-tone='win'] {
		color: #c2364a;
	}
	.info {
		padding: 0.8rem 1rem 1rem;
	}
	.info h2 {
		margin: 0;
		font-size: var(--step-1);
		color: var(--heading);
	}
	.lvl {
		margin-left: 0.3rem;
		padding: 0.05rem 0.45rem;
		border-radius: 999px;
		background: var(--paper-mid);
		font-size: 0.7rem;
		vertical-align: middle;
	}
	.bio {
		margin: 0.3rem 0 0;
		font-style: italic;
	}
	.bio-en {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.goal {
		margin: 0.5rem 0 0;
		font-size: var(--step--1);
		font-weight: 600;
	}
	.buttons {
		display: flex;
		justify-content: center;
		gap: 2rem;
	}
	.round {
		display: grid;
		place-items: center;
		width: 4rem;
		height: 4rem;
		border-radius: 50%;
		border: none;
		background: var(--surface);
		box-shadow: 0 6px 18px rgb(31 58 95 / 0.2);
		cursor: pointer;
		transition: transform 120ms ease;
	}
	.round:active {
		transform: scale(0.92);
	}
	.round.nope {
		color: var(--wrong);
	}
	.round.heart {
		color: #e0475b;
	}
	.how {
		margin: 0;
		text-align: center;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.match-scrim {
		position: fixed;
		inset: 0;
		z-index: 50;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: linear-gradient(160deg, rgb(201 104 59 / 0.92), rgb(31 58 95 / 0.95));
		animation: fade 300ms ease both;
	}
	.match {
		width: min(24rem, 100%);
		text-align: center;
		color: #fff;
		display: grid;
		gap: 0.7rem;
		justify-items: center;
	}
	.its {
		margin: 0;
		font-family: 'Source Serif 4 Variable', serif;
		font-size: var(--step-3);
		font-style: italic;
		font-weight: 700;
		animation: rise 600ms var(--ease-spring, ease-out) both;
	}
	.pair {
		display: flex;
		align-items: center;
		gap: 0.6rem;
	}
	.pair img,
	.me {
		width: 6rem;
		height: 6rem;
		border-radius: 50%;
		border: 4px solid #fff;
		object-fit: cover;
		object-position: 50% 28%;
	}
	.me {
		display: grid;
		place-items: center;
		background: var(--ochre);
		font-size: 3rem;
		animation: in-left 600ms 150ms var(--ease-spring, ease-out) both;
	}
	.pair img {
		animation: in-right 600ms 150ms var(--ease-spring, ease-out) both;
	}
	.spark {
		font-size: 2rem;
		color: #ff8fa0;
		animation: beat 1s 700ms ease-in-out infinite;
	}
	.match p {
		margin: 0;
	}
	.rule {
		font-size: var(--step--1);
		opacity: 0.85;
	}
	.match .btn-quiet {
		color: #fff;
	}
	@keyframes fade {
		from {
			opacity: 0;
		}
	}
	@keyframes rise {
		from {
			transform: scale(0.6);
			opacity: 0;
		}
	}
	@keyframes in-left {
		from {
			transform: translateX(-80px);
			opacity: 0;
		}
	}
	@keyframes in-right {
		from {
			transform: translateX(80px);
			opacity: 0;
		}
	}
	@keyframes beat {
		50% {
			transform: scale(1.3);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.its,
		.me,
		.pair img,
		.spark,
		.match-scrim {
			animation: none;
		}
	}
</style>
