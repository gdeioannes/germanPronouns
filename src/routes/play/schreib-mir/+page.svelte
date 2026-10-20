<script lang="ts">
	// "Schreib mir!" — your contacts: one list of every character, by how far
	// you got with them. Who liked you (with what they know about you, and the
	// Sunday voice note), chats still going, characters met in the deck but not
	// written to yet, and last, everyone not met yet as a blurred portrait. A
	// chat that ended without a like is forgotten (forgetMatch), so that
	// character is back among the not-met, waiting for another chance. Characters are met in the course deck
	// only; the level chips narrow the whole list. A hidden character appears
	// only once another chat's secret ending has unlocked them.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import VoiceNote from '$lib/components/match/VoiceNote.svelte';
	import { breadcrumbLd, gameLd } from '$lib/seo';
	import {
		canOpenChat,
		contactFacts,
		forgetUnliked,
		loadChat,
		MATCH_CHATS,
		MATCH_PATH,
		metChats,
		replay,
		saveChat,
		sundayAfter,
		type Contact,
		type MatchChat
	} from '$lib/domain/matchChat';
	import { dev } from '$app/environment';
	import { page } from '$app/state';
	import { onMount } from 'svelte';

	const LEVELS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'] as const;
	const LEVEL_KEY = 'match_level_filter';

	let liked = $state<Contact[]>([]);
	let going = $state<Contact[]>([]);
	let fresh = $state<MatchChat[]>([]);
	let waiting = $state<MatchChat[]>([]);
	let level = $state('all');
	let now = $state(0);
	let loaded = $state(false);

	onMount(() => {
		forgetUnliked();
		now = dev && page.url.searchParams.has('sunday') ? Date.now() + 8 * 86400000 : Date.now();
		const saved = new Map(MATCH_CHATS.map((c) => [c.id, loadChat(c.id)]));
		const get = (id: string) => saved.get(id) ?? null;
		const unlocked = new Set(
			MATCH_CHATS.filter((c) => c.unlocks && get(c.id)?.ending === 'secret').map((c) => c.unlocks!.id)
		);
		const shown = MATCH_CHATS.filter((c) => !c.hidden || unlocked.has(c.id));
		const met = metChats();
		const contact = (chat: MatchChat): Contact => {
			const s = get(chat.id)!;
			return { chat, saved: s, state: replay(chat, s.log, s.name) };
		};
		for (const chat of shown) {
			const s = get(chat.id);
			if (s?.ending === 'win' || s?.ending === 'secret') liked.push(contact(chat));
			else if (s && !s.ending) going.push(contact(chat));
			else if (canOpenChat(chat.id, get, met)) fresh.push(chat);
			else waiting.push(chat);
		}
		liked.sort((a, b) => (b.saved.endedAt ?? 0) - (a.saved.endedAt ?? 0));
		try {
			const kept = localStorage.getItem(LEVEL_KEY);
			level = kept && (kept === 'all' || (LEVELS as readonly string[]).includes(kept)) ? kept : 'all';
		} catch {
			/* no storage: show everything */
		}
		loaded = true;
	});

	function pick(next: string) {
		level = next;
		try {
			localStorage.setItem(LEVEL_KEY, next);
		} catch {
			/* remembered for this visit only */
		}
	}

	const at = (c: MatchChat) => level === 'all' || c.level.startsWith(level);
	const likedHere = $derived(liked.filter((c) => at(c.chat)));
	const goingHere = $derived(going.filter((c) => at(c.chat)));
	const freshHere = $derived(fresh.filter(at));
	const waitingHere = $derived(waiting.filter(at));
	const everyone = $derived([
		...liked.map((c) => c.chat),
		...going.map((c) => c.chat),
		...fresh,
		...waiting
	]);
	const count = (lvl: string) => everyone.filter((c) => c.level.startsWith(lvl)).length;
	const metCount = $derived(liked.length + going.length + fresh.length);

	const date = (ms?: number) =>
		ms ? new Date(ms).toLocaleDateString('de-DE', { day: 'numeric', month: 'long' }) : '';

	function usePlay(c: Contact, audio?: string) {
		if (!audio) return;
		const plays = { ...(c.saved.plays ?? {}) };
		plays[audio] = (plays[audio] ?? 0) + 1;
		c.saved = { ...c.saved, plays };
		saveChat(c.chat.id, c.saved);
	}

</script>

<Seo
	title="Schreib mir! German chat game, A1 to C2 | Language Quiz"
	description="Chat with absurd characters in German to reach a goal, building every answer from word tiles. One chance per chat, A1 to C2, free and no sign-up."
	path={MATCH_PATH}
	jsonLd={[
		gameLd({
			name: 'Schreib mir!',
			description: 'Chat with characters in German to reach a goal, building every answer from word tiles, A1 to C2.',
			path: MATCH_PATH
		}),
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Schreib mir!', path: MATCH_PATH }])
	]}
/>

<SiteNav courseHref="/course/de_cert_a1" compact />

<main class="contacts">
	<header class="head">
		<a class="back" href="/course/de_cert_a1" aria-label="Back to your deck"><Icon name="arrowLeft" size="1.1em" /></a>
		<div>
			<h1 lang="de">Schreib mir!</h1>
			<p>
				Your contacts. New characters turn up in your deck while you learn. No like? They leave, and may turn up again.
				{#if loaded}<span class="tally tnum">{metCount} of {everyone.length} met</span>{/if}
			</p>
		</div>
	</header>

	<div class="chips" role="group" aria-label="Level">
		<button type="button" class="chip" aria-pressed={level === 'all'} onclick={() => pick('all')}>All <span>{everyone.length}</span></button>
		{#each LEVELS as lvl (lvl)}
			{#if count(lvl)}
				<button type="button" class="chip" aria-pressed={level === lvl} onclick={() => pick(lvl)}>{lvl} <span>{count(lvl)}</span></button>
			{/if}
		{/each}
	</div>

	{#if loaded && !likedHere.length && !goingHere.length && !freshHere.length}
		<div class="empty">
			<p class="empty-head" lang="de">Noch keine Kontakte{level === 'all' ? '' : ` auf ${level}`}.</p>
			<p>Characters turn up in your course deck now and then while you learn. Open one there and they join this list.</p>
			<a class="btn" href="/course/de_cert_a1"><Icon name="swipe" size="1em" /> Back to the deck</a>
		</div>
	{/if}

	{#if likedHere.length}
		<h2>❤️ <span lang="de">Mag dich</span> <span class="n">{likedHere.length}</span></h2>
		{#each likedHere as c (c.chat.id)}
			{@const sunday = c.saved.endedAt ? sundayAfter(c.saved.endedAt) : Infinity}
			<article class="contact">
				<a class="row" href="{MATCH_PATH}/{c.chat.id}">
					<img src="/img/story/{c.chat.image}.webp" alt="" />
					<span class="who">
						<strong>{c.chat.emoji} {c.chat.name} <span class="lvl">{c.chat.level}</span></strong>
						<span>{c.chat.tagline}</span>
						<span class="since">❤️ liked you on {date(c.saved.endedAt)} · Dein Deutsch {c.state.average}</span>
					</span>
					<Icon name="chevronRight" size="1.1em" />
				</a>
				<p class="knows" lang="de">{c.chat.name} weiß über dich:</p>
				<ul class="facts" lang="de">
					{#each contactFacts(c.state) as f (f)}<li>{f}</li>{/each}
				</ul>
				{#if now >= sunday}
					<div class="vn">
						<p class="vn-head"><span class="dot"></span> <span lang="de">Neue Sprachnachricht · Sonntag, 14:05</span></p>
						<VoiceNote message={c.chat.endings.sunday} used={c.saved.plays?.[c.chat.endings.sunday.audio ?? ''] ?? 0} onplay={() => usePlay(c, c.chat.endings.sunday.audio)} />
					</div>
				{:else}
					<p class="later">{c.chat.name} will be in touch. Check back on Sunday afternoon.</p>
				{/if}
				{#if c.saved.ending === 'secret' && c.chat.unlocks}
					<p class="unlock">✨ Unlocked: <a href="{MATCH_PATH}/{c.chat.unlocks.id}">{c.chat.unlocks.emoji} {c.chat.unlocks.name}</a> · <span lang="de">„{c.chat.unlocks.bio}“</span></p>
				{/if}
			</article>
		{/each}
	{/if}

	{#if goingHere.length || freshHere.length}
		<h2>💬 <span lang="de">Offen</span> <span class="n">{goingHere.length + freshHere.length}</span></h2>
		{#each goingHere as c (c.chat.id)}
			<a class="other open" href="{MATCH_PATH}/{c.chat.id}">
				<img src="/img/story/{c.chat.image}.webp" alt="" />
				<span class="who">
					<strong>{c.chat.emoji} {c.chat.name} <span class="lvl">{c.chat.level}</span></strong>
					<span>🎯 {c.chat.goal}</span>
				</span>
				<span class="go">Weiter</span>
			</a>
		{/each}
		{#each freshHere as chat (chat.id)}
			<a class="other open" href="{MATCH_PATH}/{chat.id}">
				<img src="/img/story/{chat.image}.webp" alt="" />
				<span class="who">
					<strong>{chat.emoji} {chat.name}, {chat.age} <span class="lvl">{chat.level}</span></strong>
					<span lang="de">„{chat.bio}“</span>
				</span>
				<span class="go new">Schreib!</span>
			</a>
		{/each}
	{/if}


	{#if waitingHere.length}
		<section class="waiting" aria-labelledby="waiting-title">
			<h2 id="waiting-title"><span lang="de">Noch nicht getroffen</span> <span class="n">{waitingHere.length}</span></h2>
			<p>They turn up in your deck, one at a time, while you learn.</p>
			<ul>
				{#each waitingHere as c (c.id)}
					<li>
						<img src="/img/story/{c.image}.webp" alt="" loading="lazy" draggable="false" />
						<span class="q" aria-hidden="true">?</span>
						<span class="lvl">{c.level}</span>
						<span class="sr-only">A character at {c.level}, not met yet</span>
					</li>
				{/each}
			</ul>
		</section>
	{/if}
</main>

<SiteFooter compact />

<style>
	.contacts {
		max-width: 32rem;
		margin: 0 auto;
		padding: 0.8rem 1rem 2rem;
		display: grid;
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
		margin: 0.15rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}
	.tally {
		display: inline-block;
		margin-left: 0.2rem;
		padding: 0 0.45rem;
		border-radius: 999px;
		background: var(--paper-mid);
		color: var(--ink);
		font-weight: 700;
	}
	.back {
		margin-top: 0.4rem;
		color: var(--ink);
	}
	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}
	.chip {
		padding: 0.3rem 0.75rem;
		border-radius: 999px;
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink);
		font-weight: 700;
		font-size: var(--step--1);
		cursor: pointer;
	}
	.chip span {
		font-weight: 500;
		color: var(--ink-muted);
	}
	.chip[aria-pressed='true'] {
		background: var(--heading);
		border-color: var(--heading);
		color: #fff;
	}
	.chip[aria-pressed='true'] span {
		color: rgb(255 255 255 / 0.8);
	}
	h2 {
		margin: 0.6rem 0 0;
		font-size: var(--step-0);
		color: var(--heading);
	}
	h2 .n {
		margin-left: 0.3rem;
		padding: 0 0.45rem;
		border-radius: 999px;
		background: var(--paper-mid);
		font-size: 0.75rem;
	}
	.empty {
		display: grid;
		justify-items: center;
		gap: 0.6rem;
		padding: 2rem 1rem 0.5rem;
		color: var(--ink-muted);
		text-align: center;
	}
	.empty p {
		margin: 0;
	}
	.empty .empty-head {
		font-family: 'Source Serif 4 Variable', serif;
		font-size: var(--step-1);
		color: var(--heading);
	}
	.contact {
		padding: 1rem;
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 4px 16px rgb(31 58 95 / 0.1);
	}
	.row {
		display: flex;
		gap: 0.8rem;
		align-items: center;
		color: inherit;
		text-decoration: none;
	}
	.row img,
	.other img {
		width: 3.5rem;
		height: 3.5rem;
		border-radius: 50%;
		object-fit: cover;
		object-position: 50% 28%;
		flex: none;
	}
	.who {
		flex: 1;
		min-width: 0;
		display: grid;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.who strong {
		font-size: var(--step-0);
		color: var(--heading);
	}
	.lvl {
		margin-left: 0.2rem;
		padding: 0.05rem 0.4rem;
		border-radius: 999px;
		background: var(--paper-mid);
		color: var(--ink);
		font-size: 0.66rem;
		font-weight: 700;
		vertical-align: middle;
	}
	.since {
		color: #c2364a;
	}
	.knows {
		margin: 0.8rem 0 0.3rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.facts {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}
	.facts li {
		padding: 0.2rem 0.6rem;
		border-radius: 999px;
		background: var(--paper-mid);
		font-size: var(--step--1);
	}
	.vn {
		margin-top: 0.9rem;
		padding: 0.7rem;
		border-radius: var(--radius-sm);
		background: var(--paper-low);
		border: 1.5px solid var(--ochre);
	}
	.vn-head {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0 0 0.5rem;
		font-size: var(--step--1);
		font-weight: 700;
	}
	.dot {
		width: 0.55rem;
		height: 0.55rem;
		border-radius: 50%;
		background: #e0475b;
	}
	.later,
	.unlock {
		margin: 0.8rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.other {
		display: flex;
		gap: 0.8rem;
		align-items: center;
		padding: 0.7rem;
		border-radius: var(--radius-sm);
		background: var(--paper-mid);
		color: inherit;
		text-decoration: none;
	}
	.other.open {
		background: var(--surface);
		border: 1.5px solid #f3c1c9;
	}
	.go {
		flex: none;
		padding: 0.25rem 0.7rem;
		border-radius: 999px;
		background: #3f7d46;
		color: #fff;
		font-size: var(--step--1);
		font-weight: 800;
	}
	.go.new {
		background: linear-gradient(120deg, #c2364a, #ff6b81);
	}
	.waiting > p {
		margin: 0.2rem 0 0.7rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}
	.waiting ul {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(4.6rem, 1fr));
		gap: 0.55rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}
	.waiting li {
		position: relative;
		aspect-ratio: 3 / 4;
		border-radius: 0.7rem;
		overflow: hidden;
		background: #2a2233;
	}
	/* The portrait blurred and faded: a hint of someone, who it is stays a
	   surprise for the deck. Scaled up so the blur has no soft edge. */
	.waiting img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		object-position: 50% 22%;
		filter: blur(7px) saturate(0.6) brightness(0.75);
		transform: scale(1.25);
	}
	.waiting .q {
		position: absolute;
		inset: 0;
		display: grid;
		place-items: center;
		color: #fff;
		font-family: 'Source Serif 4 Variable', serif;
		font-size: 1.6rem;
		font-weight: 800;
		text-shadow: 0 1px 6px rgb(0 0 0 / 0.5);
	}
	.waiting .lvl {
		position: absolute;
		left: 0.3rem;
		bottom: 0.3rem;
		margin: 0;
		background: rgb(255 255 255 / 0.9);
		font-size: 0.62rem;
	}
</style>
