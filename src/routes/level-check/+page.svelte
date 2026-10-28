<script lang="ts">
	// "Your level": where a learner goes to find out where they stand, whenever
	// they want. Today that is the word check (and its history, so a second
	// check shows the growth) and the placement test. Nothing on
	// this page counts as an exercise: no medals, nothing marked done.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { storage } from '$lib/services/storage';
	import { ORGANIZATION, absoluteUrl, breadcrumbLd } from '$lib/seo';
	import { DECK_PACES } from '$lib/domain/deck';
	import { WORD_CHECK_LOG, parseLog, type CheckLogEntry } from '$lib/domain/wordCheck';
	import { onMount } from 'svelte';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	// The history lives in storage, so it shows only after mount.
	let log = $state<CheckLogEntry[]>([]);
	let loaded = $state(false);
	onMount(async () => {
		log = parseLog(await storage.get(WORD_CHECK_LOG));
		loaded = true;
	});

	const latest = $derived(log.at(-1) ?? null);
	/** Newest first, each with the change since the check before it. */
	const rows = $derived(
		log
			.map((entry, i) => ({ entry, diff: i > 0 ? entry.words - log[i - 1].words : null }))
			.reverse()
	);

	const date = (at: number) =>
		new Date(at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
	const number = (n: number) => n.toLocaleString('en-GB');
</script>

<Seo
	title="What is my German level? Free word check | Language Quiz"
	description="Find your German level from A1 to C2 in about two minutes: tap the words you know, see about how many German words you know, and where to start learning."
	path="/level-check"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'WebPage',
			name: 'Your German level',
			url: absoluteUrl('/level-check'),
			inLanguage: ['en', 'de'],
			isAccessibleForFree: true,
			publisher: ORGANIZATION
		},
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Your level', path: '/level-check' }])
	]}
/>

<SiteNav {courseHref} />

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<header>
		<h1>Your level</h1>
		<p class="lede">
			Find out where you stand, whenever you like. Nothing here is marked or
			counted: it tells you your level and sets up your deck to match.
		</p>
	</header>

	<a class="check card" href="/level-check/words">
		<span class="disc" aria-hidden="true"><Icon name="words" size="1.5em" /></span>
		<span class="body">
			<span class="eyebrow">Word check · about 2 minutes</span>
			<strong class="name">How many German words do you know?</strong>
			<span class="what">
				Tap the words you know, screen by screen, as they get harder. You get
				your level, about how many words you know, and a suggestion for your deck.
			</span>
			<span class="go">{latest ? 'Check again' : 'Start the check'} <Icon name="arrowRight" size="1em" /></span>
		</span>
	</a>

	<section class="history" aria-labelledby="history-h">
		<h2 id="history-h">Your checks</h2>
		{#if !loaded}
			<p class="muted">Loading…</p>
		{:else if !latest}
			<p class="muted">No checks yet. Take one now, and again in a month to see how far you have come.</p>
		{:else}
			<div class="latest">
				<p class="eyebrow">Latest · {date(latest.at)}</p>
				<p class="big tnum">{number(latest.words)} <span>words</span></p>
				{#if latest.level}
					<p>Level <strong>{latest.level}</strong> · suggested pace <strong>{DECK_PACES[latest.pace]?.label ?? latest.pace}</strong></p>
				{/if}
			</div>
			{#if rows.length > 1}
				<ol class="rows">
					{#each rows as { entry, diff } (entry.at)}
						<li>
							<span class="when">{date(entry.at)}</span>
							<span class="tnum">{number(entry.words)} words</span>
							<span class="lv">{entry.level ?? '–'}</span>
							<span class="diff tnum" class:up={diff !== null && diff > 0}>
								{#if diff === null}first{:else if diff > 0}+{number(diff)}{:else if diff < 0}−{number(-diff)}{:else}±0{/if}
							</span>
						</li>
					{/each}
				</ol>
			{/if}
		{/if}
	</section>

	<a class="check card" href="/level-check/test">
		<span class="disc" aria-hidden="true"><Icon name="compass" size="1.5em" /></span>
		<span class="body">
			<span class="eyebrow">Placement test · about 10 minutes</span>
			<strong class="name">Which level should I start at?</strong>
			<span class="what">Words, grammar, reading and listening, each part adapting as you go. You get the sub-level to start at, and one tap sets your deck there.</span>
			<span class="go">Take the test <Icon name="arrowRight" size="1em" /></span>
		</span>
	</a>
</main>

<SiteFooter />

<style>
	header {
		margin: 0.5rem 0 1.5rem;
	}

	h1 {
		margin: 0 0 0.4rem;
	}

	.check {
		display: flex;
		gap: 1rem;
		align-items: flex-start;
		color: inherit;
		text-decoration: none;
	}

	.check {
		border-color: var(--accent);
		transition:
			transform var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	.check:hover {
		transform: translateY(-2px);
		box-shadow: 0 14px 30px -18px rgb(20 32 52 / 0.45);
	}

	.disc {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3.2rem;
		height: 3.2rem;
		flex: none;
		border-radius: 50%;
		background: #e8efe9;
		color: var(--forest);
	}

	.body {
		display: grid;
		gap: 0.3rem;
	}

	.name {
		font-size: var(--step-1);
		color: var(--heading);
	}

	.what {
		color: var(--ink-muted);
	}

	.go {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		margin-top: 0.3rem;
		font-weight: 700;
		color: var(--accent-ink);
	}

	.history {
		margin: 2rem 0;
	}

	.history h2 {
		margin: 0 0 0.7rem;
		font-size: var(--step-1);
	}

	.muted {
		color: var(--ink-muted);
	}

	.latest p {
		margin: 0.15rem 0;
	}

	.big {
		font-size: var(--step-3);
		font-weight: 800;
		color: var(--heading);
		line-height: 1.1;
	}

	.big span {
		font-size: var(--step-0);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.rows {
		display: grid;
		gap: 0.2rem;
		margin: 1rem 0 0;
		padding: 0;
		list-style: none;
	}

	.rows li {
		display: grid;
		grid-template-columns: 1fr 1fr 3.5rem 4rem;
		gap: 0.6rem;
		padding: 0.45rem 0;
		border-bottom: 1px solid var(--line);
		font-size: var(--step--1);
	}

	.rows .when {
		color: var(--ink-muted);
	}

	.rows .lv {
		font-weight: 700;
	}

	.rows .diff {
		text-align: right;
		color: var(--ink-muted);
	}

	.rows .diff.up {
		color: var(--right);
		font-weight: 700;
	}

</style>
