<script lang="ts">
	import PageHelp from '$lib/components/PageHelp.svelte';
	// "Schreib mir!" — one match chat (domain/matchChat, docs/match_chat_helga.md).
	//
	// The character writes; the learner answers by building sentences from the
	// word bank (with a full stop tile for a second sentence). Each sent
	// sentence gets a score badge, the character answers in her own words (and
	// quotes the sentence back, fixed, when it had a small mistake), and the
	// interest meter in the header moves when she does.
	//
	// Every chat happens once. The log is saved after every sentence and the
	// whole chat is rebuilt from it on load, so leaving and coming back lands on
	// the same turn, and a finished chat only ever shows its ending.
	import Seo from '$lib/components/Seo.svelte';
	import GermanText from '$lib/components/GermanText.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import VoiceNote from '$lib/components/match/VoiceNote.svelte';
	import EndingCard from '$lib/components/match/EndingCard.svelte';
	import OverlayText from '$lib/components/match/OverlayText.svelte';
	import {
		buildFeed,
		canOpenChat,
		changedWords,
		cleanName,
		clearChat,
		findChat,
		loadChat,
		loadName,
		MATCH_PATH,
		MAX_INTEREST,
		NAME_TILE,
		personalise,
		playTurn,
		render,
		replay,
		saveChat,
		saveName,
		startState,
		QUESTION,
		STOP,
		wordFixes,
		type ChatMessage,
		type ChatState,
		type FeedItem,
		type SavedChat
	} from '$lib/domain/matchChat';
	import { playSound } from '$lib/services/sounds';
	import { toggleClip, voice as clipVoice } from '$lib/services/clips.svelte';
	import { tts } from '$lib/services/speech';
	import { storage } from '$lib/services/storage';
	import { SettingsKeys } from '$lib/domain/keys';
	import { effectsCalm } from '$lib/motion/fx.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { track } from '$lib/services/analytics';
	import { dev } from '$app/environment';
	import { page } from '$app/state';
	import { onMount, tick } from 'svelte';

	let { data } = $props();
	const chat = $derived(findChat(data.id)!);

	let name = $state('');
	let nameDraft = $state('');
	let askName = $state(false);
	/** Not met in the deck yet: the chat stays shut. */
	let locked = $state(false);
	/** A dev replay (?reset): the saved chat is wiped first. */
	let free = $state(false);
	let saved = $state<SavedChat | null>(null);
	let game = $state.raw<ChatState | null>(null);
	const feed = $derived<FeedItem[]>(game ? buildFeed(chat, game) : []);
	/** How much of the feed is on screen; the rest is still being "typed". */
	let visible = $state(0);
	let typing = $state(false);
	let revealing = false;
	/** The meter follows her answers, not the send button. */
	let shownInterest = $state(5);
	let meterKick = $state(0);
	let showEnd = $state(false);
	/** Placed tiles: indices into the bank, -1 for a full stop, -2 for a question mark. */
	let built = $state<number[]>([]);
	let openScore = $state<string | null>(null);
	let english = $state<Record<string, boolean>>({});
	let zoom = $state<{ image: string; alt: string; overlay?: string[] } | null>(null);
	let log: HTMLElement | undefined = $state();
	/** Each photo's height / width once loaded, so overlay text can size itself. */
	let ratios = $state<Record<string, number>>({});
	const measure = (image: string) => (e: Event) => {
		const img = e.currentTarget as HTMLImageElement;
		if (img.naturalWidth) ratios = { ...ratios, [image]: img.naturalHeight / img.naturalWidth };
	};

	const turn = $derived(game?.current ?? null);
	const bank = $derived(turn?.tiles ?? []);
	const tokens = $derived(built.map((i) => (i === -1 ? STOP : i === -2 ? QUESTION : bank[i])));
	const preview = $derived(tokens.some((t) => t !== STOP && t !== QUESTION) ? render(tokens, name, chat.lexicon) : '');
	const busy = $derived(visible < feed.length || typing);
	const over = $derived(Boolean(game?.ending));
	const deleted = $derived(game?.ending === 'deleted' && visible >= feed.length);

	onMount(() => {
		free = dev && page.url.searchParams.has('reset');
		if (free) clearChat(chat.id);
		saved = loadChat(chat.id);
		if (saved) {
			name = saved.name;
			game = replay(chat, saved.log, name);
			visible = buildFeed(chat, game).length;
			shownInterest = game.interest;
			if (game.ending) showEnd = true;
			void scrollDown(false);
			return;
		}
		// Characters are met in the course deck only; a link alone does not open them.
		if (!free && !canOpenChat(chat.id)) {
			locked = true;
			return;
		}
		// A new chat always opens on the start card: the name, and the one-chance rule.
		name = loadName();
		nameDraft = name;
		askName = true;
	});

	function begin() {
		saved = { name, log: [], startedAt: Date.now(), plays: {} };
		// Starting is already the one chance: the empty log is saved now.
		saveChat(chat.id, saved);
		game = startState(chat);
		shownInterest = game.interest;
		track('match_start', { chat: chat.id });
		void reveal();
	}

	function confirmName(e: SubmitEvent) {
		e.preventDefault();
		const clean = cleanName(nameDraft);
		if (!clean) return;
		name = clean;
		saveName(clean);
		askName = false;
		begin();
	}

	const wait = (ms: number) => new Promise((r) => setTimeout(r, ms));

	/** How long she "types" before a message lands. */
	function delayFor(msg: ChatMessage): number {
		if (effectsCalm()) return 250;
		if (msg.type === 'voice') return 1500;
		if (msg.type === 'photo') return 1000;
		return Math.min(1900, 550 + (msg.de?.length ?? 10) * 22);
	}

	async function scrollDown(smooth = true) {
		await tick();
		log?.scrollTo({ top: log.scrollHeight, behavior: smooth && !effectsCalm() ? 'smooth' : 'auto' });
	}

	async function reveal() {
		if (revealing) return;
		revealing = true;
		while (game && visible < feed.length) {
			const item = feed[visible];
			if (item.kind === 'in' || item.kind === 'recast') {
				typing = true;
				await scrollDown();
				await wait(item.kind === 'in' ? delayFor(item.msg) : 900);
				typing = false;
				playSound('msgIn');
				if (item.kind === 'in' && item.msg.de) announce(`${chat.name}: ${personalise(item.msg.de, name)}`);
			} else if (item.kind === 'system') {
				await wait(600);
			} else if (item.kind === 'outPhoto') {
				await wait(300);
			}
			visible++;
			const m = /^t(\d+)-r0$/.exec(item.key);
			if (m) {
				const r = game.results[Number(m[1])];
				shownInterest = r.interestAfter;
				meterKick++;
				if (r.delta > 0) playSound('up');
				else if (r.delta < 0) playSound('down');
			}
			await scrollDown();
		}
		revealing = false;
		if (game?.ending) {
			await wait(effectsCalm() ? 300 : 1100);
			playSound(game.ending === 'deleted' ? 'unmatch' : game.ending === 'partial' ? 'down' : 'like');
			showEnd = true;
		}
	}

	function place(i: number) {
		if (busy || over) return;
		if (i >= 0 && built.includes(i)) return;
		built = [...built, i];
	}
	function takeBack(pos: number) {
		built = built.filter((_, p) => p !== pos);
	}

	async function send() {
		if (!game || !saved || !turn || busy || !preview) return;
		// Leading and doubled end marks are tidied away, and a trailing full stop (a final "?" stays).
		const isEnd = (t: string) => t === STOP || t === QUESTION;
		const clean = tokens.filter((t, i) => !isEnd(t) || (i > 0 && !isEnd(tokens[i - 1])));
		while (clean.at(-1) === STOP) clean.pop();
		const next = playTurn(chat, game, clean, name);
		saved = { ...saved, log: [...saved.log, { turn: turn.id, tokens: clean }] };
		if (next.ending) {
			saved = { ...saved, ending: next.ending, endedAt: Date.now() };
			track('match_end', { chat: chat.id, ending: next.ending, average: next.average });
			void bankFixes(next);
		}
		saveChat(chat.id, saved);
		built = [];
		game = next;
		playSound('msgOut');
		visible++; // the learner's own bubble lands at once
		await scrollDown();
		void reveal();
	}

	/** The corrections go to the same fix log the speaking and writing tasks feed. */
	async function bankFixes(state: ChatState) {
		const fixes = wordFixes(state.results).map((f) => ({ ...f, level: chat.level }));
		if (!fixes.length) return;
		const key = `${SettingsKeys.speakingFixLogPrefix}de_cert_a1`;
		const raw = await storage.get(key);
		const existing = raw ? JSON.parse(raw) : [];
		await storage.set(key, JSON.stringify([...fixes, ...existing].slice(0, 40)));
	}

	function onKey(e: KeyboardEvent) {
		if (e.key === 'Enter' && preview) {
			e.preventDefault();
			void send();
		} else if (e.key === 'Backspace' && built.length) {
			e.preventDefault();
			takeBack(built.length - 1);
		}
	}

	function usePlay(audio: string | undefined) {
		if (!audio || !saved) return;
		const plays = { ...(saved.plays ?? {}) };
		plays[audio] = (plays[audio] ?? 0) + 1;
		saved = { ...saved, plays };
		saveChat(chat.id, saved);
	}

	function speak(msg: ChatMessage) {
		const text = personalise(msg.de, name);
		if (msg.audio) toggleClip(msg.audio, { text, locale: 'de-DE' });
		else void tts.speak(text, { locale: 'de-DE' });
	}

	const tileLabel = (t: string) => (t === NAME_TILE ? name : t);
	const tier = (score: number) => (score === 100 ? 'top' : score >= 60 ? 'mid' : 'low');
	const hearts = $derived(Array.from({ length: MAX_INTEREST }, (_, i) => i < shownInterest));
</script>

<Seo
	title="Schreib mir! Chat with {chat.name}, {chat.age}"
	description="{chat.level} German chat game. {chat.bioEn} Your goal: {chat.goal} Build every answer from word tiles. Every chat happens once."
	path="{MATCH_PATH}/{chat.id}"
/>

<main class="chat" class:deleted>
	<header class="top">
		<a class="back" href={MATCH_PATH} aria-label="Back to your matches"><Icon name="arrowLeft" size="1.2em" /></a>
		<img class="ava" src="/img/story/{chat.image}.webp" alt="" />
		<div class="who">
			<strong>{chat.name}</strong>
			<span class="status" class:typing>
				{#if typing}tippt…{:else if deleted}hat das Match gelöscht{:else if over}Chat beendet{:else}online{/if}
			</span>
		</div>
		<div class="meter" role="meter" aria-label="Interest" aria-valuemin="0" aria-valuemax={MAX_INTEREST} aria-valuenow={shownInterest}>
			{#key meterKick}
				<span class="hearts" class:kick={meterKick > 0}>
					{#each hearts as on, i (i)}<span class:on>{on ? '❤' : '♡'}</span>{/each}
				</span>
			{/key}
			<span class="meter-label">Interest {shownInterest}/{MAX_INTEREST}</span>
		</div>
		<PageHelp topic="/play/schreib-mir/[id]" tone="light" />
	</header>
	<p class="goal"><span aria-hidden="true">🎯</span> <strong>Goal:</strong> {chat.goal} <span class="once">· one chance</span></p>

	<section class="log" bind:this={log} aria-label="Chat with {chat.name}" aria-live="off">
		<p class="day">Heute</p>
		{#each feed.slice(0, visible) as item (item.key)}
			{#if item.kind === 'in'}
				{@const msg = item.msg}
				<div class="row in">
					<div class="bubble" class:media={msg.type !== 'text'}>
						{#if msg.type === 'text'}
							<p class="de" lang="de"><GermanText text={personalise(msg.de, name)} />{#if msg.emoji}<span class="emoji"> {msg.emoji}</span>{/if}</p>
							{#if english[item.key]}<p class="en">{personalise(msg.en, name)}</p>{/if}
							<span class="tools">
								<button type="button" class="tool" onclick={() => speak(msg)} aria-label="Listen" class:on={clipVoice.id === msg.audio && clipVoice.status === 'playing'}>
									<Icon name="volume" size="0.95em" />
								</button>
								{#if msg.en}
									<button type="button" class="tool en-btn" onclick={() => (english = { ...english, [item.key]: !english[item.key] })} aria-pressed={!!english[item.key]}>EN</button>
								{/if}
							</span>
						{:else if msg.type === 'photo'}
							<button type="button" class="photo" class:wide={msg.wide} onclick={() => (zoom = { image: msg.image!, alt: msg.alt ?? '', overlay: msg.overlay })} aria-label="Open the photo. {msg.alt}">
								<img src="/img/story/{msg.image}.webp" alt={msg.alt ?? ''} onload={measure(msg.image!)} />
								{#if msg.overlay}
									<OverlayText image={msg.image!} lines={msg.overlay} ratio={ratios[msg.image!]} />
								{/if}
							</button>
						{:else}
							<VoiceNote message={msg} used={saved?.plays?.[msg.audio ?? ''] ?? 0} reveal={over && !!showEnd} onplay={() => usePlay(msg.audio)} />
						{/if}
					</div>
				</div>
			{:else if item.kind === 'out'}
				{@const r = item.result}
				<div class="row out">
					<div class="bubble mine">
						<p lang="de">{r.grade.text}</p>
						<button type="button" class="score" data-tier={tier(r.grade.score)} onclick={() => (openScore = openScore === item.key ? null : item.key)} aria-expanded={openScore === item.key} aria-label="Sentence score {r.grade.score} of 100: details">
							{r.grade.score === 100 ? '✓' : r.grade.score >= 60 ? '~' : '✗'} {r.grade.score}
						</button>
						{#if openScore === item.key}
							<ul class="deductions">
								{#if !r.grade.corrections.length}<li>Perfect sentence. +1 interest.</li>{/if}
								{#each r.grade.corrections as c, k (k)}
									<li>
										−{c.points}
										{#if c.kind === 'order'}word order: the verb goes in second place
										{:else if c.kind === 'noVerb'}this sentence needs a verb
										{:else}<span lang="de"><s>{c.from}</s> → <b>{c.to}</b></span> ({c.kind === 'verb' ? 'verb ending' : c.kind === 'article' ? 'article' : 'adjective ending'})
										{/if}
									</li>
								{/each}
							</ul>
						{/if}
					</div>
				</div>
			{:else if item.kind === 'outPhoto'}
				<div class="row out">
					<button type="button" class="bubble mine media photo sent" onclick={() => (zoom = { image: item.image, alt: 'Your outfit' })} aria-label="Your photo">
						<img src="/img/story/{item.image}.webp" alt="Your outfit" />
					</button>
				</div>
			{:else if item.kind === 'recast'}
				{@const parts = changedWords(item.result.grade.text, item.result.grade.fixed)}
				<div class="row in">
					<div class="bubble quote">
						<span class="quote-head" lang="de">Ah, du meinst:</span>
						<p lang="de">„{#each parts as p, i (i)}{i ? ' ' : ''}{#if p.changed}<mark>{p.word}</mark>{:else}{p.word}{/if}{/each}“</p>
					</div>
				</div>
			{:else}
				<p class="system" lang="de">{item.text}</p>
			{/if}
		{/each}
		{#if typing}
			<div class="row in" aria-hidden="true"><div class="bubble dots"><span></span><span></span><span></span></div></div>
		{/if}
	</section>

	{#if !over && turn}
		<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
		<div class="composer" onkeydown={onKey} role="group" aria-label="Your answer">
			<div class="line" aria-live="polite">
				<div class="placed">
					{#if !built.length}
						<span class="hint">{busy ? `${chat.name} schreibt…` : 'Tap words to build your answer'}</span>
					{/if}
					{#each built as i, pos (pos)}
						<button type="button" class="tile placed-tile" class:stop={i < 0} onclick={() => takeBack(pos)} aria-label="{i === -1 ? 'full stop' : i === -2 ? 'question mark' : tileLabel(bank[i])}, take back" lang="de">
							{i === -1 ? '.' : i === -2 ? '?' : tileLabel(bank[i])}
						</button>
					{/each}
				</div>
				<button type="button" class="send" onclick={send} disabled={!preview || busy} aria-label="Send">
					<Icon name="arrowRight" size="1.2em" />
				</button>
			</div>
			{#if preview}<p class="preview" lang="de">{preview}</p>{/if}
			<div class="bank" role="group" aria-label="Word tiles">
				{#each bank as t, i (i)}
					<button type="button" class="tile" lang="de" disabled={busy || built.includes(i)} onclick={() => place(i)}>{tileLabel(t)}</button>
				{/each}
				<button type="button" class="tile stop" disabled={busy} onclick={() => place(-1)} aria-label="Full stop: start a new sentence">.</button>
				<button type="button" class="tile stop" disabled={busy} onclick={() => place(-2)} aria-label="Question mark: end a question">?</button>
			</div>
		</div>
	{:else if over && !showEnd}
		<footer class="composer ended"><p>…</p></footer>
	{:else if over}
		<footer class="composer ended">
			<button type="button" class="btn" onclick={() => (showEnd = true)}>See the ending</button>
		</footer>
	{/if}
</main>

{#if locked}
	<div class="scrim solid">
		<div class="name-card locked-card">
			<img class="shadow" src="/img/story/{chat.image}.webp" alt="" />
			<h1 lang="de">Noch nicht getroffen</h1>
			<p>Someone at {chat.level} is waiting to chat, but you meet characters in your course deck. They turn up there now and then while you learn. Open their card in the deck and this chat opens.</p>
			<a class="btn" href="/course/de_cert_a1">Back to the deck</a>
			<a class="btn-quiet" href={MATCH_PATH}>Your matches</a>
		</div>
	</div>
{/if}

{#if askName}
	<div class="scrim">
		<form class="name-card" onsubmit={confirmName}>
			<img src="/img/story/{chat.image}.webp" alt="" />
			<h1>{chat.name}, {chat.age}</h1>
			<p lang="de" class="bio">„{chat.bio}“</p>
			<p>Your goal: {chat.goal}</p>
			<label class="name-label" for="chat-name">Your name in the chat</label>
			<!-- svelte-ignore a11y_autofocus -->
			<input id="chat-name" bind:value={nameDraft} maxlength="14" autocomplete="given-name" placeholder="Your name" autofocus />
			<p class="rule">Every chat happens once. Choose your words.</p>
			<button class="btn" type="submit" disabled={!cleanName(nameDraft)}>Start the chat</button>
		</form>
	</div>
{/if}

{#if zoom}
	<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_static_element_interactions -->
	<div class="zoom" onclick={() => (zoom = null)}>
		<div class="zoom-inner">
			<img src="/img/story/{zoom.image}.webp" alt={zoom.alt} onload={measure(zoom.image)} />
			{#if zoom.overlay}
				<OverlayText image={zoom.image} lines={zoom.overlay} ratio={ratios[zoom.image]} />
			{/if}
		</div>
		<button type="button" class="close" aria-label="Close the photo" onclick={() => (zoom = null)}><Icon name="close" size="1.3em" /></button>
	</div>
{/if}

{#if showEnd && game?.ending}
	<EndingCard {chat} {game} {name} onclose={() => (showEnd = false)} />
{/if}

<style>
	.chat {
		display: grid;
		grid-template-rows: auto auto 1fr auto;
		height: 100dvh;
		max-width: 44rem;
		margin: 0 auto;
		background: var(--paper);
		transition: filter 600ms ease;
	}
	.chat.deleted .log {
		filter: grayscale(0.85);
		opacity: 0.75;
	}
	.top {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		padding: 0.55rem 0.8rem;
		background: var(--navy);
		color: #fff;
	}
	.back {
		display: grid;
		place-items: center;
		color: #fff;
		padding: 0.2rem;
	}
	.ava {
		width: 2.6rem;
		height: 2.6rem;
		border-radius: 50%;
		object-fit: cover;
		object-position: 50% 28%;
		border: 2px solid rgb(255 255 255 / 0.6);
	}
	.deleted .ava {
		filter: grayscale(1);
	}
	.who {
		display: grid;
		flex: 1;
		min-width: 0;
		line-height: 1.2;
	}
	.status {
		font-size: var(--step--1);
		opacity: 0.8;
	}
	.status.typing {
		color: var(--ochre);
		opacity: 1;
	}
	.meter {
		display: grid;
		justify-items: end;
		line-height: 1.1;
	}
	.hearts {
		display: flex;
		gap: 1px;
		font-size: 0.78rem;
		color: rgb(255 255 255 / 0.45);
	}
	.hearts .on {
		color: #ff6b81;
	}
	.hearts.kick {
		animation: kick 450ms ease;
	}
	.meter-label {
		font-size: 0.68rem;
		opacity: 0.75;
	}
	.goal {
		margin: 0;
		padding: 0.4rem 0.9rem;
		font-size: var(--step--1);
		background: var(--paper-mid);
		border-bottom: 1px solid var(--line);
	}
	.once {
		color: var(--terracotta);
		font-weight: 600;
	}
	.log {
		overflow-y: auto;
		padding: 0.8rem 0.8rem 1.2rem;
		display: flex;
		flex-direction: column;
		gap: 0.45rem;
		background:
			radial-gradient(circle at 20% 10%, rgb(201 104 59 / 0.05), transparent 40%),
			radial-gradient(circle at 80% 60%, rgb(31 58 95 / 0.05), transparent 45%),
			var(--paper-low);
		transition: filter 800ms ease, opacity 800ms ease;
	}
	.day {
		align-self: center;
		margin: 0 0 0.3rem;
		padding: 0.15rem 0.7rem;
		border-radius: 999px;
		background: var(--paper-mid);
		font-size: 0.72rem;
		color: var(--ink-muted);
	}
	.row {
		display: flex;
		animation: land 260ms var(--ease-out, ease-out) both;
	}
	.row.out {
		justify-content: flex-end;
	}
	.bubble {
		position: relative;
		max-width: min(80%, 26rem);
		padding: 0.5rem 0.7rem;
		border-radius: 1rem 1rem 1rem 0.3rem;
		background: var(--surface);
		box-shadow: 0 1px 2px rgb(31 58 95 / 0.12);
	}
	.bubble p {
		margin: 0;
	}
	.bubble.mine {
		border-radius: 1rem 1rem 0.3rem 1rem;
		background: #dcebd9;
		padding-bottom: 1.4rem;
		min-width: 6rem;
	}
	.bubble.media {
		padding: 0.35rem;
	}
	.bubble.mine.media {
		padding: 0.3rem;
	}
	.emoji {
		white-space: nowrap;
	}
	.en {
		margin-top: 0.25rem !important;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.tools {
		display: flex;
		gap: 0.3rem;
		margin-top: 0.25rem;
	}
	.tool {
		display: grid;
		place-items: center;
		min-width: 1.7rem;
		height: 1.5rem;
		padding: 0 0.3rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: transparent;
		color: var(--ink-muted);
		font-size: 0.66rem;
		font-weight: 700;
		cursor: pointer;
	}
	.tool.on,
	.tool[aria-pressed='true'] {
		background: var(--navy);
		border-color: var(--navy);
		color: #fff;
	}
	.photo {
		position: relative;
		display: block;
		padding: 0;
		border: none;
		background: none;
		cursor: zoom-in;
		container-type: inline-size;
		width: 14rem;
		max-width: 100%;
	}
	.photo.wide {
		width: 22rem;
	}
	.photo.sent {
		width: 10rem;
	}
	.photo img {
		display: block;
		width: 100%;
		border-radius: 0.75rem;
	}
	.score {
		position: absolute;
		right: 0.45rem;
		bottom: 0.25rem;
		padding: 0 0.4rem;
		border: none;
		border-radius: 999px;
		font-size: 0.7rem;
		font-weight: 700;
		color: #fff;
		background: var(--right);
		cursor: pointer;
		animation: pop 380ms 120ms var(--ease-spring, ease-out) both;
	}
	.score[data-tier='mid'] {
		background: var(--ochre);
	}
	.score[data-tier='low'] {
		background: var(--wrong);
	}
	.deductions {
		margin: 0.4rem 0 0;
		padding-left: 1rem;
		font-size: var(--step--1);
		color: var(--ink);
	}
	.deductions b {
		color: var(--right);
	}
	.quote {
		background: #fbf1dc;
		border-left: 3px solid var(--ochre);
	}
	.quote-head {
		display: block;
		font-size: 0.72rem;
		font-weight: 700;
		color: var(--ochre-ink);
	}
	mark {
		background: rgb(63 125 70 / 0.18);
		color: var(--right);
		font-weight: 700;
		border-radius: 3px;
		padding: 0 2px;
	}
	.system {
		align-self: center;
		margin: 0.4rem 0;
		padding: 0.3rem 0.9rem;
		border-radius: 999px;
		background: var(--wrong-bg);
		color: var(--wrong);
		font-size: var(--step--1);
		font-weight: 600;
	}
	.dots {
		display: flex;
		gap: 4px;
		padding: 0.75rem 0.85rem;
	}
	.dots span {
		width: 7px;
		height: 7px;
		border-radius: 50%;
		background: var(--ink-muted);
		animation: dot 1s ease-in-out infinite;
	}
	.dots span:nth-child(2) {
		animation-delay: 0.15s;
	}
	.dots span:nth-child(3) {
		animation-delay: 0.3s;
	}
	.composer {
		padding: 0.55rem 0.7rem calc(0.6rem + env(safe-area-inset-bottom));
		border-top: 1px solid var(--line);
		background: var(--surface);
		display: grid;
		gap: 0.4rem;
	}
	.composer.ended {
		place-items: center;
		color: var(--ink-muted);
	}
	.line {
		display: flex;
		align-items: flex-end;
		gap: 0.5rem;
	}
	.placed {
		flex: 1;
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem;
		min-height: 2.6rem;
		align-items: center;
		padding: 0.3rem 0.5rem;
		border-radius: 1.3rem;
		border: 1.5px solid var(--line-strong);
		background: var(--paper);
	}
	.hint {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}
	.send {
		flex: none;
		display: grid;
		place-items: center;
		width: 2.8rem;
		height: 2.8rem;
		border-radius: 50%;
		border: none;
		background: var(--terracotta);
		color: #fff;
		cursor: pointer;
		transition: transform 120ms ease, opacity 120ms;
	}
	.send:disabled {
		opacity: 0.35;
		cursor: default;
	}
	.send:not(:disabled):active {
		transform: scale(0.92);
	}
	.preview {
		margin: 0;
		padding-left: 0.6rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.bank {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
		max-height: 34dvh;
		overflow-y: auto;
	}
	.tile {
		padding: 0.42rem 0.75rem;
		border-radius: 999px;
		border: 1.5px solid var(--line-strong);
		background: var(--paper);
		color: var(--heading);
		font-weight: 600;
		font-size: var(--step-0);
		cursor: pointer;
		box-shadow: 0 2px 0 var(--paper-highest);
		transition: transform 100ms ease, opacity 100ms;
	}
	.tile:hover:not(:disabled) {
		border-color: var(--accent);
		transform: translateY(-1px);
	}
	.tile:disabled {
		opacity: 0.28;
		cursor: default;
		box-shadow: none;
	}
	.tile.stop {
		min-width: 2.3rem;
		font-weight: 900;
		background: var(--paper-mid);
	}
	.placed-tile {
		padding: 0.28rem 0.6rem;
		background: #fbf1dc;
		border-color: #d9a441;
		box-shadow: none;
		animation: pop 180ms ease-out both;
	}
	.scrim {
		position: fixed;
		inset: 0;
		z-index: 50;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: rgb(20 30 48 / 0.55);
	}
	.name-card {
		width: min(24rem, 100%);
		padding: 1.4rem;
		border-radius: var(--radius);
		background: var(--paper);
		text-align: center;
		display: grid;
		gap: 0.6rem;
	}
	.name-card img {
		width: 5rem;
		height: 5rem;
		margin: 0 auto;
		border-radius: 50%;
		object-fit: cover;
		object-position: 50% 28%;
	}
	.scrim.solid {
		background: var(--paper-mid);
	}
	.name-card img.shadow {
		filter: blur(6px) saturate(0.6) brightness(0.8);
	}
	.name-card h1 {
		margin: 0;
		font-size: var(--step-1);
	}
	.name-card p {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}
	.name-card .bio {
		font-style: italic;
		color: var(--ink);
	}
	.name-label {
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--heading);
	}
	.name-card .rule {
		color: var(--terracotta);
		font-weight: 600;
	}
	.name-card input {
		padding: 0.6rem 0.8rem;
		border-radius: var(--radius-sm);
		border: 1.5px solid var(--line-strong);
		font-size: var(--step-1);
		text-align: center;
	}
	.zoom {
		position: fixed;
		inset: 0;
		z-index: 55;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: rgb(10 15 25 / 0.85);
		cursor: zoom-out;
	}
	.zoom-inner {
		position: relative;
		container-type: inline-size;
		width: min(92vw, 70dvh * var(--ar, 1), 60rem);
	}
	.zoom-inner img {
		display: block;
		width: 100%;
		max-height: 88dvh;
		object-fit: contain;
		border-radius: 0.6rem;
	}
	.close {
		position: fixed;
		top: 0.8rem;
		right: 0.8rem;
		display: grid;
		place-items: center;
		width: 2.6rem;
		height: 2.6rem;
		border-radius: 50%;
		border: none;
		background: rgb(255 255 255 / 0.15);
		color: #fff;
		cursor: pointer;
	}
	@keyframes land {
		from {
			opacity: 0;
			transform: translateY(8px) scale(0.98);
		}
	}
	@keyframes pop {
		from {
			transform: scale(0.6);
			opacity: 0;
		}
	}
	@keyframes dot {
		50% {
			transform: translateY(-4px);
			opacity: 0.5;
		}
	}
	@keyframes kick {
		50% {
			transform: scale(1.18);
		}
	}
	:global(html[data-effects='calm']) .row,
	:global(html[data-effects='calm']) .score,
	:global(html[data-effects='calm']) .placed-tile {
		animation: none;
	}
	@media (prefers-reduced-motion: reduce) {
		.row,
		.score,
		.placed-tile,
		.hearts.kick,
		.dots span {
			animation: none;
		}
	}
</style>
