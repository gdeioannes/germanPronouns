<script lang="ts">
	// "Schreib mir!" contacts: everyone who liked you back, with what they
	// know about you. A contact stays alive: the Sunday after the chat, at
	// 14:05, they send a new voice note (?sunday=1 shows it early in dev).
	// Below: the people you met without a like, and the ones who deleted you,
	// each with the last thing they said.
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import VoiceNote from '$lib/components/match/VoiceNote.svelte';
	import {
		contactFacts,
		contacts,
		loadChat,
		MATCH_CHATS,
		MATCH_PATH,
		personalise,
		replay,
		saveChat,
		sundayAfter,
		type Contact
	} from '$lib/domain/matchChat';
	import { dev } from '$app/environment';
	import { page } from '$app/state';
	import { onMount } from 'svelte';

	let liked = $state<Contact[]>([]);
	let others = $state<Contact[]>([]);
	let now = $state(0);
	let loaded = $state(false);

	onMount(() => {
		now = dev && page.url.searchParams.has('sunday') ? Date.now() + 8 * 86400000 : Date.now();
		liked = contacts();
		others = MATCH_CHATS.flatMap((chat) => {
			const saved = loadChat(chat.id);
			if (!saved?.ending || saved.ending === 'win' || saved.ending === 'secret') return [];
			return [{ chat, saved, state: replay(chat, saved.log, saved.name) }];
		});
		loaded = true;
	});

	const date = (ms?: number) =>
		ms ? new Date(ms).toLocaleDateString('de-DE', { day: 'numeric', month: 'long' }) : '';

	function usePlay(c: Contact, audio?: string) {
		if (!audio) return;
		const plays = { ...(c.saved.plays ?? {}) };
		plays[audio] = (plays[audio] ?? 0) + 1;
		c.saved = { ...c.saved, plays };
		saveChat(c.chat.id, c.saved);
	}

	function lastLine(c: Contact) {
		const e = c.chat.endings;
		return c.saved.ending === 'deleted'
			? (e.deleted[c.state.cause ?? 'default'] ?? e.deleted.default)
			: e.partial.at(-1);
	}
</script>

<Seo
	title="Schreib mir! Your contacts"
	description="The characters who liked you back in Schreib mir!, what they know about you, and the voice notes they send afterwards."
	path="{MATCH_PATH}/kontakte"
	noindex
/>

<main class="contacts">
	<header class="head">
		<a class="back" href={MATCH_PATH} aria-label="Back to your matches"><Icon name="arrowLeft" size="1.1em" /></a>
		<h1 lang="de">Kontakte</h1>
	</header>

	{#if loaded && !liked.length}
		<p class="empty">No contacts yet. Win a chat and the character saves you, and you them.</p>
		<a class="btn" href={MATCH_PATH}>Find a match</a>
	{/if}

	{#each liked as c (c.chat.id)}
		{@const sunday = c.saved.endedAt ? sundayAfter(c.saved.endedAt) : Infinity}
		<article class="contact">
			<div class="row">
				<img src="/img/story/{c.chat.image}.webp" alt="" />
				<div class="who">
					<strong>{c.chat.emoji} {c.chat.name}</strong>
					<span>{c.chat.tagline}</span>
					<span class="since">❤️ liked you on {date(c.saved.endedAt)} · Dein Deutsch {c.state.average}</span>
				</div>
			</div>
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

	{#if others.length}
		<h2>Met, no like</h2>
		{#each others as c (c.chat.id)}
			{@const line = lastLine(c)}
			<article class="other" class:gone={c.saved.ending === 'deleted'}>
				<img src="/img/story/{c.chat.image}.webp" alt="" />
				<div>
					<strong>{c.chat.name} {c.saved.ending === 'deleted' ? '💔 deleted you' : '🤝 met you, no like'}</strong>
					{#if line?.de}<span lang="de">„{personalise(line.de, c.saved.name)}“</span>{/if}
				</div>
			</article>
		{/each}
	{/if}
</main>

<style>
	.contacts {
		max-width: 32rem;
		margin: 0 auto;
		padding: 0.8rem 1rem 2rem;
		display: grid;
		gap: 0.9rem;
	}
	.head {
		display: flex;
		align-items: center;
		gap: 0.6rem;
	}
	.head h1 {
		margin: 0;
		font-size: var(--step-2);
	}
	.back {
		color: var(--ink);
	}
	.empty {
		color: var(--ink-muted);
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
	.who,
	.other div {
		display: grid;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.who strong,
	.other strong {
		font-size: var(--step-0);
		color: var(--heading);
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
	h2 {
		margin: 0.6rem 0 0;
		font-size: var(--step-1);
	}
	.other {
		display: flex;
		gap: 0.8rem;
		align-items: center;
		padding: 0.7rem;
		border-radius: var(--radius-sm);
		background: var(--paper-mid);
	}
	.other.gone img {
		filter: grayscale(1);
	}
</style>
