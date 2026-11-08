<script lang="ts">
	// A chapter's words as flashcards, spaced over days (domain/bookStudy):
	// the picture and the English first, then the German with its article and
	// plural, spoken. "I knew it" sends a word further away each time; "not
	// yet" brings it back today. The schedule is one per book, so a word met
	// again in a later chapter keeps its place.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import { storage } from '$lib/services/storage';
	import { tts } from '$lib/services/speech';
	import { dueWords, learntCount, parseBoxes, review, wordsKey, type WordBoxes } from '$lib/domain/bookStudy';

	interface Word {
		de: string;
		en: string;
		pl?: string;
		image?: string;
	}

	let { words, level, german = false }: { words: Word[]; level: string; german?: boolean } = $props();

	/** A sitting is short: a handful of cards is what a phone break holds. */
	const SITTING = 15;

	let boxes = $state<WordBoxes>({});
	let queue = $state<Word[]>([]);
	let shown = $state(false);
	let loaded = $state(false);
	let doneToday = $state(0);

	const card = $derived(queue[0] ?? null);
	const learnt = $derived(learntCount(words, boxes));
	const article = (de: string) => /^(der|die|das) /.exec(de)?.[1] ?? '';
	const bare = (de: string) => de.replace(/^(der|die|das) /, '');
	const plural = (pl?: string) => (!pl ? '' : pl === '–' ? 'no plural' : pl);

	onMount(async () => {
		boxes = parseBoxes(await storage.get(wordsKey(level)));
		queue = dueWords(words, boxes, Date.now()).slice(0, SITTING);
		loaded = true;
	});

	function show() {
		shown = true;
		if (card) void tts.speak(card.de, { locale: 'de-DE' });
	}

	async function answer(known: boolean) {
		if (!card) return;
		boxes = review(boxes, card.de, known, Date.now());
		await storage.set(wordsKey(level), JSON.stringify(boxes));
		const [first, ...rest] = queue;
		// Not yet: the card comes back at the end of this sitting.
		queue = known ? rest : [...rest, first];
		if (known) doneToday++;
		shown = false;
	}

	function allAgain() {
		queue = [...words].sort(() => Math.random() - 0.5).slice(0, SITTING);
		shown = false;
	}
</script>

<div class="cards">
	<p class="meta">
		{words.length} {german ? 'Wörter' : 'words'} · {learnt} {german ? 'sitzen schon' : 'learnt'}
	</p>
	{#if !loaded}
		<div class="card"></div>
	{:else if card}
		<div class="card" aria-live="polite">
			{#if card.image}<img src="/img/{card.image}.webp" alt="" />{/if}
			<p class="en">{card.en}</p>
			{#if shown}
				<p class="de" lang="de">
					{#if article(card.de)}<b class="art {article(card.de)}">{article(card.de)}</b>{/if}
					{bare(card.de)}
					<SpeakButton text={card.de} locale="de-DE" label="Listen to {card.de}" />
				</p>
				{#if plural(card.pl)}<p class="pl" lang="de">{plural(card.pl)}</p>{/if}
			{/if}
		</div>
		<div class="actions">
			{#if !shown}
				<button type="button" class="btn" onclick={show}>{german ? 'Zeigen' : 'Show the German'}</button>
			{:else}
				<button type="button" class="btn ghost" onclick={() => answer(false)}>{german ? 'Noch nicht' : 'Not yet'}</button>
				<button type="button" class="btn" onclick={() => answer(true)}><Icon name="check" size="1em" stroke={2.5} /> {german ? 'Wusste ich' : 'I knew it'}</button>
			{/if}
		</div>
		<p class="left">{queue.length} {german ? 'Karten noch' : 'cards to go'}</p>
	{:else}
		<div class="card done">
			<p class="en">{doneToday ? (german ? `${doneToday} Wörter für heute. Gut gemacht.` : `${doneToday} words for today. Well done.`) : german ? 'Heute ist kein Wort fällig.' : 'No words are due today.'}</p>
			<p class="pl">{german ? 'Die Karten kommen wieder, wenn du sie fast vergessen hast.' : 'The cards come back just before you would forget them.'}</p>
		</div>
		<div class="actions">
			<button type="button" class="btn ghost" onclick={allAgain}>{german ? 'Trotzdem üben' : 'Practise anyway'}</button>
		</div>
	{/if}
</div>

<style>
	.cards {
		max-width: 26rem;
	}

	.meta,
	.left {
		margin: 0 0 0.6rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.left {
		margin-top: 0.6rem;
	}

	.card {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 0.35rem;
		min-height: 15rem;
		padding: 1.25rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface);
		text-align: center;
	}

	.card img {
		width: 7rem;
		height: 7rem;
		object-fit: contain;
	}

	.en {
		margin: 0;
		font-size: 1.1rem;
		color: var(--ink-muted);
	}

	.de {
		display: flex;
		gap: 0.4rem;
		align-items: center;
		margin: 0.3rem 0 0;
		font-size: 1.6rem;
		font-weight: 800;
		color: var(--heading);
	}

	.art.der {
		color: #1f5fa8;
	}

	.art.die {
		color: #b4452f;
	}

	.art.das {
		color: #3f7d4a;
	}

	.pl {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.actions {
		display: flex;
		gap: 0.6rem;
		margin-top: 0.8rem;
	}

	.btn {
		display: inline-flex;
		flex: 1;
		align-items: center;
		justify-content: center;
		gap: 0.4rem;
		min-height: 2.9rem;
		border: 2px solid var(--accent-ink);
		border-radius: 8px;
		background: var(--accent-ink);
		color: #fff;
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	.btn.ghost {
		background: transparent;
		color: var(--accent-ink);
	}
</style>
