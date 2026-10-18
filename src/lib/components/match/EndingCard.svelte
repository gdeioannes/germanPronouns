<script lang="ts">
	// The end of a match chat, laid over the conversation.
	//
	//   win / secret → the like: a heartbeat, hearts, "… hat dich geliked!",
	//                  and the contact card that is now saved, with what the
	//                  character knows about you. The secret ending also
	//                  unlocks the next match.
	//   partial      → no like and no contact.
	//   deleted      → the match is gone, with the line that ended it.
	//   Without a like the character leaves the contacts (forgetMatch) and may
	//   turn up in the deck again for another chance.
	//
	// Every ending shows "Dein Deutsch" (the average sentence score: the
	// German and the story are graded apart on purpose), what went wrong, and
	// a recap of every sentence with its corrections and both voice notes.
	import Icon from '$lib/icons/Icon.svelte';
	import VoiceNote from './VoiceNote.svelte';
	import { effectsCalm } from '$lib/motion/fx.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { absoluteUrl } from '$lib/seo';
	import {
		contactFacts,
		lowPoints,
		MATCH_PATH,
		personalise,
		turnById,
		type ChatMessage,
		type ChatState,
		type MatchChat
	} from '$lib/domain/matchChat';
	import { onMount } from 'svelte';

	let {
		chat,
		game,
		name,
		onclose
	}: { chat: MatchChat; game: ChatState; name: string; onclose: () => void } = $props();

	const ending = $derived(game.ending!);
	const liked = $derived(ending === 'win' || ending === 'secret');
	const facts = $derived(contactFacts(game));
	const lows = $derived(lowPoints(game));
	const lastLine = $derived(
		ending === 'deleted'
			? (chat.endings.deleted[game.cause ?? 'default'] ?? chat.endings.deleted.default)
			: chat.endings[ending].at(-1)
	);
	const voiceNotes = $derived.by(() => {
		const seen: ChatMessage[] = [];
		for (const r of game.results)
			for (const m of turnById(chat, r.turn)?.before ?? []) if (m.type === 'voice') seen.push(m);
		if (ending === 'secret') seen.push(...chat.endings.secret.filter((m) => m.type === 'voice'));
		return seen;
	});
	const stars = $derived(game.average >= 90 ? 3 : game.average >= 75 ? 2 : game.average >= 60 ? 1 : 0);

	const hearts = Array.from({ length: 22 }, (_, i) => ({
		x: Math.random() * 100,
		delay: Math.random() * 900,
		size: 0.9 + Math.random() * 1.6,
		drift: (Math.random() - 0.5) * 120,
		i
	}));
	let calm = $state(true);
	let copied = $state(false);
	let card: HTMLElement | undefined = $state();

	onMount(() => {
		calm = effectsCalm();
		card?.focus({ preventScroll: true });
		announce(
			liked
				? `${chat.name} hat dich geliked. Neuer Kontakt gespeichert.`
				: ending === 'deleted'
					? `${chat.name} hat das Match gelöscht.`
					: `Du bist auf der Liste, aber ohne Like.`
		);
	});

	function shareText(): string {
		const url = absoluteUrl(MATCH_PATH);
		const fill = (t: string) => personalise(t, name).replaceAll('{score}', String(game.average)).replaceAll('{url}', url);
		const own = ending === 'secret' ? (chat.share?.secret ?? chat.share?.win) : chat.share?.[ending];
		if (own) return fill(own);
		const verdict = liked ? 'hat mich geliked ❤️' : ending === 'deleted' ? 'hat mich gelöscht 💔' : 'hat mich fast geliked';
		return `${chat.name} ${verdict} Mein Deutsch: ${game.average}/100. Schaffst du das? ${url}`;
	}

	async function share() {
		const text = shareText();
		try {
			if (navigator.share) {
				await navigator.share({ text });
				return;
			}
		} catch {
			/* cancelled, or not allowed: fall through to copying */
		}
		try {
			await navigator.clipboard.writeText(text);
			copied = true;
			announce('Copied.');
			setTimeout(() => (copied = false), 1800);
		} catch {
			/* no clipboard either */
		}
	}
</script>

<div class="scrim" data-ending={ending}>
	{#if liked && !calm}
		<div class="hearts" aria-hidden="true">
			{#each hearts as h (h.i)}
				<span style:left="{h.x}%" style:animation-delay="{h.delay}ms" style:font-size="{h.size}rem" style:--drift="{h.drift}px">❤</span>
			{/each}
		</div>
	{/if}

	<div class="card" bind:this={card} tabindex="-1" role="dialog" aria-modal="true" aria-labelledby="end-title">
		<div class="avatar-wrap">
			<img class="avatar" src="/img/story/{chat.image}.webp" alt="" />
			<span class="badge" aria-hidden="true">
				{#if liked}❤️{:else if ending === 'deleted'}💔{:else}📦{/if}
			</span>
		</div>

		{#if liked}
			<p class="eyebrow">It's a like</p>
			<h2 id="end-title" lang="de">{chat.name} hat dich geliked!</h2>
		{:else if ending === 'deleted'}
			<p class="eyebrow">Match deleted</p>
			<h2 id="end-title" lang="de">{chat.name} hat das Match gelöscht.</h2>
		{:else}
			<p class="eyebrow">Almost: no like</p>
			<h2 id="end-title" lang="de">{chat.partialTitle ?? 'Fast geschafft.'}</h2>
		{/if}

		{#if lastLine?.type === 'voice'}
			<div class="vn last"><VoiceNote message={lastLine} reveal /></div>
		{:else if lastLine?.de}
			<blockquote lang="de">„{personalise(lastLine.de, name)}“{#if lastLine.en}<span lang="en">{personalise(lastLine.en, name)}</span>{/if}</blockquote>
		{/if}

		<div class="deutsch" aria-label="Your German: {game.average} out of 100">
			<span class="label" lang="de">Dein Deutsch</span>
			<span class="num">{game.average}</span>
			<span class="stars" aria-hidden="true">{'★'.repeat(stars)}{'☆'.repeat(3 - stars)}</span>
		</div>

		{#if liked}
			<div class="contact">
				<p class="contact-head"><Icon name="check" size="1em" /> <span lang="de">Neuer Kontakt gespeichert</span></p>
				<div class="contact-row">
					<img src="/img/story/{chat.image}.webp" alt="" />
					<div>
						<strong>{chat.emoji} {chat.name}</strong>
						<span class="tag">{chat.tagline}</span>
					</div>
				</div>
				{#if facts.length}
					<p class="knows" lang="de">{chat.name} weiß über dich:</p>
					<ul class="facts" lang="de">
						{#each facts as f (f)}<li>{f}</li>{/each}
					</ul>
				{/if}
			</div>
			{#if ending === 'secret' && chat.unlocks}
				<a class="unlock" href="{MATCH_PATH}/{chat.unlocks.id}">
					<span class="spark" aria-hidden="true">✨</span>
					<div>
						<p class="eyebrow">New match unlocked</p>
						<strong>{chat.unlocks.emoji} {chat.unlocks.name}</strong>
						<span class="tag" lang="de">„{chat.unlocks.bio}“</span>
					</div>
				</a>
			{/if}
		{:else if ending === 'partial'}
			<p class="note">No like and no contact. {chat.name} leaves your contacts, but may turn up in your deck again for another chance.</p>
		{:else}
			<p class="note">{chat.name} is gone from your contacts. Maybe they turn up in your deck again, and you get another chance.</p>
		{/if}

		{#if lows.length}
			<details class="lows" open={ending === 'deleted'}>
				<summary>What went wrong ({lows.length})</summary>
				<ul>
					{#each lows as l, i (i)}
						<li><span lang="de">„{l.said}“</span> <span class="why">{l.why}</span></li>
					{/each}
				</ul>
			</details>
		{/if}

		<details class="recap">
			<summary>Recap: every sentence</summary>
			<ol>
				{#each game.results as r, i (i)}
					<li>
						<span class="sent" lang="de">{r.grade.text}</span>
						<span class="pill" data-tier={r.grade.score === 100 ? 'top' : r.grade.score >= 60 ? 'mid' : 'low'}>{r.grade.score}</span>
						{#if r.grade.fixed !== r.grade.text}
							<span class="fixed" lang="de">→ {r.grade.fixed}</span>
						{/if}
						{#each r.grade.corrections.filter((c) => !c.from) as c, k (k)}
							<span class="fixed">{c.kind === 'order' ? 'Word order: the verb goes second.' : 'A sentence needs a verb.'}</span>
						{/each}
					</li>
				{/each}
			</ol>
			{#each voiceNotes as v (v.audio)}
				<div class="vn"><VoiceNote message={v} reveal /></div>
			{/each}
		</details>

		<div class="actions">
			<button type="button" class="btn" onclick={share}>
				<Icon name="external" size="1em" /> {copied ? 'Copied!' : 'Share'}
			</button>
			<a class="btn btn-ghost" href={MATCH_PATH}>Contacts</a>
			<a class="btn btn-ghost" href="/course/de_cert_a1">Back to the deck</a>
			<button type="button" class="btn-quiet" onclick={onclose}>See the chat</button>
		</div>
	</div>
</div>

<style>
	.scrim {
		position: fixed;
		inset: 0;
		z-index: 60;
		display: grid;
		/* No place-items: a card taller than the screen must start at the top
		   and scroll, not overflow upwards out of reach. margin:auto centres
		   it whenever it fits. */
		padding: 3.8rem 1rem 1rem;
		overflow-y: auto;
		background: rgb(20 30 48 / 0.55);
		backdrop-filter: blur(3px);
		animation: fade 300ms ease both;
	}
	.scrim[data-ending='deleted'] {
		background: rgb(60 20 20 / 0.6);
	}
	.card {
		position: relative;
		width: min(28rem, 100%);
		margin: auto;
		padding: 1.4rem 1.3rem 1.2rem;
		border-radius: var(--radius);
		background: var(--paper);
		box-shadow: 0 20px 60px rgb(0 0 0 / 0.35);
		text-align: center;
		animation: rise 520ms var(--ease-spring, cubic-bezier(0.34, 1.56, 0.64, 1)) both;
		outline: none;
	}
	.avatar-wrap {
		position: relative;
		width: 6.5rem;
		margin: -3.4rem auto 0.5rem;
	}
	.avatar {
		width: 6.5rem;
		height: 6.5rem;
		border-radius: 50%;
		object-fit: cover;
		object-position: 50% 30%;
		border: 4px solid var(--paper);
		box-shadow: 0 6px 18px rgb(0 0 0 / 0.25);
	}
	[data-ending='deleted'] .avatar {
		filter: grayscale(1) contrast(0.9);
	}
	.badge {
		position: absolute;
		right: -0.3rem;
		bottom: -0.1rem;
		font-size: 2rem;
		animation: pop 700ms 350ms var(--ease-spring, cubic-bezier(0.34, 1.56, 0.64, 1)) both;
	}
	[data-ending='win'] .badge,
	[data-ending='secret'] .badge {
		animation: pop 700ms 350ms both, beat 1.1s 1.1s ease-in-out 3;
	}
	.eyebrow {
		margin: 0;
		font-size: var(--step--1);
		text-transform: uppercase;
		letter-spacing: 0.08em;
		color: var(--ink-muted);
	}
	h2 {
		margin: 0.15rem 0 0.6rem;
		font-size: var(--step-2);
		color: var(--heading);
	}
	[data-ending='deleted'] h2 {
		color: var(--wrong);
	}
	blockquote {
		margin: 0 0 0.9rem;
		padding: 0.6rem 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--paper-mid);
		font-style: italic;
	}
	blockquote span {
		display: block;
		margin-top: 0.2rem;
		font-size: var(--step--1);
		font-style: normal;
		color: var(--ink-muted);
	}
	.deutsch {
		display: inline-flex;
		align-items: baseline;
		gap: 0.5rem;
		margin-bottom: 0.9rem;
		padding: 0.35rem 0.9rem;
		border-radius: 999px;
		background: var(--navy);
		color: #fff;
	}
	.deutsch .label {
		font-size: var(--step--1);
		opacity: 0.85;
	}
	.deutsch .num {
		font-size: var(--step-2);
		font-weight: 700;
	}
	.stars {
		color: var(--ochre);
		letter-spacing: 0.1em;
	}
	.contact,
	.unlock {
		text-align: left;
		margin: 0 0 0.8rem;
		padding: 0.8rem 0.9rem;
		border-radius: var(--radius-sm);
		border: 1.5px solid var(--line);
		background: var(--surface);
		animation: slide 500ms 600ms ease both;
	}
	.contact-head {
		display: flex;
		align-items: center;
		gap: 0.35rem;
		margin: 0 0 0.6rem;
		color: var(--right);
		font-weight: 600;
	}
	.contact-row {
		display: flex;
		align-items: center;
		gap: 0.7rem;
	}
	.contact-row img {
		width: 2.8rem;
		height: 2.8rem;
		border-radius: 50%;
		object-fit: cover;
		object-position: 50% 30%;
	}
	.contact-row div,
	.unlock div {
		display: grid;
	}
	.tag {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.knows {
		margin: 0.7rem 0 0.3rem;
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
	.unlock {
		color: inherit;
		text-decoration: none;
		display: flex;
		gap: 0.7rem;
		align-items: center;
		border-color: var(--ochre);
		background: #fbf1dc;
		animation-delay: 900ms;
	}
	.spark {
		font-size: 1.8rem;
	}
	.note {
		margin: 0 0 0.8rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}
	details {
		text-align: left;
		margin: 0 0 0.6rem;
		font-size: var(--step--1);
	}
	summary {
		cursor: pointer;
		font-weight: 600;
		color: var(--heading);
		padding: 0.3rem 0;
	}
	.lows ul,
	.recap ol {
		margin: 0.3rem 0 0;
		padding-left: 1.2rem;
		display: grid;
		gap: 0.45rem;
	}
	.why,
	.fixed {
		display: block;
		color: var(--ink-muted);
	}
	.fixed {
		color: var(--right);
	}
	.pill {
		display: inline-block;
		margin-left: 0.3rem;
		padding: 0 0.45rem;
		border-radius: 999px;
		font-size: 0.75rem;
		font-weight: 700;
		color: #fff;
		background: var(--right);
	}
	.pill[data-tier='mid'] {
		background: var(--ochre);
	}
	.pill[data-tier='low'] {
		background: var(--wrong);
	}
	.vn.last {
		margin: 0 0 0.9rem;
		text-align: left;
	}
	.vn {
		margin-top: 0.7rem;
		padding: 0.6rem;
		border-radius: var(--radius-sm);
		background: var(--paper-mid);
	}
	.actions {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.5rem;
		margin-top: 0.8rem;
	}
	.hearts {
		position: fixed;
		inset: 0;
		pointer-events: none;
		overflow: hidden;
	}
	.hearts span {
		position: absolute;
		bottom: -2rem;
		color: #e0475b;
		animation: float 2.8s ease-out both;
	}
	@keyframes float {
		0% {
			transform: translate(0, 0) scale(0.6);
			opacity: 0;
		}
		15% {
			opacity: 1;
		}
		100% {
			transform: translate(var(--drift), -105vh) scale(1.1);
			opacity: 0;
		}
	}
	@keyframes fade {
		from {
			opacity: 0;
		}
	}
	@keyframes rise {
		from {
			transform: translateY(40px) scale(0.92);
			opacity: 0;
		}
	}
	@keyframes slide {
		from {
			transform: translateY(12px);
			opacity: 0;
		}
	}
	@keyframes pop {
		from {
			transform: scale(0) rotate(-30deg);
		}
	}
	@keyframes beat {
		50% {
			transform: scale(1.25);
		}
	}
	:global(html[data-effects='calm']) .card,
	:global(html[data-effects='calm']) .badge,
	:global(html[data-effects='calm']) .contact,
	:global(html[data-effects='calm']) .unlock {
		animation: none;
	}
	@media (prefers-reduced-motion: reduce) {
		.card,
		.badge,
		.contact,
		.unlock,
		.scrim {
			animation: none;
		}
	}
</style>
