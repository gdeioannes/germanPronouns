<script lang="ts">
	// The brag shelf: every persona "Ja oder Nein?" can hand out, ten shelves
	// of five, the ones this device has earned in colour and the rest as a
	// question mark. Each shelf lists its rounds, so a round can be played by
	// choice here as well as dealt by the deck; one share sends the whole
	// collection as a grid of squares.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { absoluteUrl, breadcrumbLd } from '$lib/seo';
	import { JA_NEIN_PATH, whatsappHref } from '$lib/domain/janein';
	import {
		collection,
		collectionCount,
		collectionShareText,
		JA_NEIN_CATEGORIES,
		personaKey,
		playedRounds,
		type Collection
	} from '$lib/domain/janeinRounds';
	import { announce } from '$lib/a11y.svelte';
	import { track } from '$lib/services/analytics';
	import { onMount } from 'svelte';
	import { page } from '$app/state';

	const PATH = `${JA_NEIN_PATH}/personas`;
	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	let have = $state<Collection>({});
	let played = $state<Set<string>>(new Set());
	onMount(() => {
		have = collection();
		played = new Set(playedRounds());
	});

	const count = $derived(collectionCount(have));
	const text = $derived(collectionShareText(absoluteUrl(PATH), have));
	let copied = $state(false);
	const canShare = $derived(typeof navigator !== 'undefined' && typeof navigator.share === 'function');

	async function share() {
		track('janein', { step: 'share_collection', via: 'native', earned: count.earned });
		try {
			await navigator.share({ text });
		} catch {
			/* dismissed */
		}
	}

	async function copy() {
		track('janein', { step: 'share_collection', via: 'copy', earned: count.earned });
		try {
			await navigator.clipboard.writeText(text);
			copied = true;
			announce('Copied.');
			setTimeout(() => (copied = false), 1800);
		} catch {
			/* no clipboard */
		}
	}

	const shelfCount = (c: (typeof JA_NEIN_CATEGORIES)[number]) => c.personas.filter((p) => have[personaKey(c.id, p.id)]).length;
</script>

<Seo
	title="Your Ja oder Nein? personas"
	description="Every persona the Ja oder Nein? swipe game can make you, ten shelves of five, and which ones you have collected."
	path={PATH}
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Ja oder Nein?', path: JA_NEIN_PATH }, { name: 'Personas', path: PATH }])]}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href={courseHref}><Icon name="arrowLeft" size="1em" /> Your deck</a>

	<header class="head">
		<p class="eyebrow">Ja oder Nein?</p>
		<h1>Your personas</h1>
		<p class="lede">
			Every round of Ja oder Nein? ends on one of five personas from its shelf. Play a round again and
			you may land on another one. Collect them all, then send the grid to someone who thinks they know you.
		</p>
		<p class="tally">
			<strong class="tnum">{count.earned}</strong> <span class="of">of {count.total}</span>
			<span class="bar" aria-hidden="true"><span class="fill" style:width="{count.total ? (100 * count.earned) / count.total : 0}%"></span></span>
		</p>
		<div class="share">
			<a class="btn wa" href={whatsappHref(text)} target="_blank" rel="noopener" onclick={() => track('janein', { step: 'share_collection', via: 'whatsapp', earned: count.earned })}>
				Send on WhatsApp
			</a>
			{#if canShare}
				<button type="button" class="btn btn-ghost" onclick={share}><Icon name="external" size="1em" /> Share…</button>
			{/if}
			<button type="button" class="btn btn-ghost" onclick={copy}><Icon name={copied ? 'check' : 'copy'} size="1em" /> {copied ? 'Copied' : 'Copy'}</button>
		</div>
		<pre class="preview" lang="de" aria-label="What you will send">{text}</pre>
	</header>

	{#each JA_NEIN_CATEGORIES as c (c.id)}
		<section class="shelf" aria-labelledby="shelf-{c.id}">
			<h2 id="shelf-{c.id}"><span class="emoji" aria-hidden="true">{c.emoji}</span> <span lang="de">{c.title}</span> <small>{c.en} · {shelfCount(c)} of {c.personas.length}</small></h2>
			<ol class="personas">
				{#each c.personas as p (p.id)}
					{@const got = have[personaKey(c.id, p.id)]}
					<li class="persona" class:got>
						{#if got}
							<span class="big" aria-hidden="true">{p.emoji}</span>
							<strong lang="de">{p.title}</strong>
							<span class="line">{p.line}</span>
							<span class="word">Your word: <span lang="de">{p.word.de}</span> · {p.word.en}</span>
							<time datetime={got}>since {got}</time>
						{:else}
							<span class="big" aria-hidden="true">?</span>
							<strong>Not yet</strong>
							<span class="line">Play a round of this shelf and see who you turn out to be.</span>
						{/if}
					</li>
				{/each}
			</ol>
			<ul class="rounds" aria-label="Rounds on this shelf">
				{#each c.rounds as r (r.key)}
					<li>
						<a class="round" class:played={played.has(r.key)} href="{JA_NEIN_PATH}?round={r.key}" title={r.hook}>
							{#if played.has(r.key)}<Icon name="check" size="0.9em" />{/if}
							<span lang="de">{r.title}</span>
						</a>
					</li>
				{/each}
			</ul>
		</section>
	{/each}
</main>

<SiteFooter />

<style>
	.head {
		max-width: 44rem;
		margin-bottom: 2rem;
	}
	.eyebrow {
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
		margin: 0;
	}
	h1 {
		margin: 0.1em 0 0.4em;
	}
	.lede {
		color: var(--ink-soft);
		margin: 0 0 1rem;
	}
	.tally {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin: 0 0 1rem;
		font-family: var(--font-display);
	}
	.tally strong {
		font-size: var(--step-3);
		line-height: 1;
	}
	.tally .of {
		color: var(--ink-soft);
	}
	.bar {
		flex: 1;
		height: 0.6rem;
		border-radius: 999px;
		background: var(--line);
		overflow: hidden;
	}
	.fill {
		display: block;
		height: 100%;
		background: linear-gradient(90deg, #7c3aed, #ff4d6d, #ffb347);
		transition: width 600ms var(--ease-out);
	}
	.share {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin-bottom: 0.75rem;
	}
	.wa {
		background: #25d366;
		color: #fff;
		border-color: #25d366;
	}
	.preview {
		font-size: var(--step--1);
		white-space: pre-wrap;
		margin: 0;
		padding: 0.75rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink-soft);
	}

	.shelf {
		margin: 0 0 2.25rem;
		padding-top: 1.25rem;
		border-top: 1px solid var(--line);
	}
	.shelf h2 {
		display: flex;
		align-items: baseline;
		flex-wrap: wrap;
		gap: 0.4em;
		margin: 0 0 0.75rem;
		font-size: var(--step-1);
	}
	.shelf h2 small {
		font-family: var(--font-body);
		font-size: var(--step--1);
		font-weight: 500;
		color: var(--ink-soft);
	}
	.personas {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(11rem, 1fr));
		gap: 0.75rem;
	}
	.persona {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		padding: 0.9rem 0.9rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink-soft);
		min-height: 11rem;
	}
	.persona .big {
		font-size: 2rem;
		line-height: 1.1;
	}
	.persona:not(.got) .big {
		width: 2.4rem;
		height: 2.4rem;
		display: grid;
		place-items: center;
		border-radius: 50%;
		background: var(--line);
		color: var(--ink-soft);
		font-family: var(--font-display);
		font-weight: 800;
	}
	.persona.got {
		color: var(--ink);
		border-color: color-mix(in srgb, #7c3aed 45%, var(--line));
		box-shadow: 0 10px 24px -18px #7c3aed;
	}
	.persona strong {
		font-family: var(--font-display);
		font-size: var(--step-0);
		line-height: 1.2;
	}
	.persona .line {
		font-size: var(--step--1);
	}
	.persona .word,
	.persona time {
		font-size: var(--step--2);
		color: var(--ink-soft);
	}
	.persona time {
		margin-top: auto;
	}
	.rounds {
		list-style: none;
		margin: 0.75rem 0 0;
		padding: 0;
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}
	.round {
		display: inline-flex;
		align-items: center;
		gap: 0.3em;
		padding: 0.3em 0.75em;
		border: 1px solid var(--line);
		border-radius: 999px;
		font-size: var(--step--1);
		text-decoration: none;
		color: var(--ink);
		background: var(--surface);
	}
	.round:hover {
		border-color: var(--accent);
	}
	.round.played {
		color: var(--ink-soft);
	}
</style>
