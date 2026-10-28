<script lang="ts">
	// The first screen of a first session: where do you start? Everyone used to
	// begin at A1.1 because nothing said they could choose. Three ways in: new
	// to German (the first lesson), find my level (the placement test), or I know
	// my level (pick it). Any choice is remembered, so the course stops asking.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { LEVEL_MEANING } from '$lib/domain/wordCheck';
	import { START_CHOSEN } from '$lib/domain/placement';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const courseHref = $derived(page.data.site?.courseHref ?? `/course/${data.courseId}`);
	const levels = $derived<{ level: string; title: string }[]>(page.data.site?.levels ?? []);
	const name = (title: string) =>
		title
			.replace(/^[A-C]\d(?:\.\d)?\s*[·-]\s*/, '')
			.toLowerCase()
			.replace(/(^|[\s&-])(\p{L})/gu, (m: string) => m.toUpperCase());

	let picking = $state(false);

	async function choose(how: 'new' | 'pick', level: string) {
		await storage.set('deck_level', level);
		await storage.set(START_CHOSEN, how);
		track('start_chosen', { how, level });
		await goto(how === 'new' && data.firstQuizId ? `${courseHref}/quiz/${data.firstQuizId}` : courseHref);
	}
</script>

<Seo
	title="Where do you start? | Language Quiz"
	description="New to German, or not? Start at the beginning, take a ten-minute placement test, or pick your level from A1 to C2."
	path="/start"
/>

<SiteNav {courseHref} />

<main class="page start">
	<p class="eyebrow">Before your first card</p>
	<h1>Where do you start?</h1>
	<p class="lede">The course runs from your first <em lang="de">Hallo</em> to C2. Start where you are, not at the beginning by default.</p>

	<div class="ways">
		<button type="button" class="way" onclick={() => choose('new', levels[0]?.level ?? 'A1.1')}>
			<span class="disc" aria-hidden="true"><Icon name="star" size="1.4em" /></span>
			<span class="body">
				<strong>I’m new to German</strong>
				<span>Start with the very first lesson: numbers, hello, your name.</span>
			</span>
			<Icon name="arrowRight" size="1.1em" />
		</button>

		<a class="way main" href="/level-check/test" onclick={() => track('start_chosen', { how: 'test', level: '' })}>
			<span class="disc" aria-hidden="true"><Icon name="compass" size="1.4em" /></span>
			<span class="body">
				<strong>I know some German: find my level</strong>
				<span>A ten-minute placement test: words, grammar, reading and listening. You start where it puts you.</span>
			</span>
			<Icon name="arrowRight" size="1.1em" />
		</a>

		<button type="button" class="way" aria-expanded={picking} aria-controls="level-pick" onclick={() => (picking = !picking)}>
			<span class="disc" aria-hidden="true"><Icon name="trophy" size="1.4em" /></span>
			<span class="body">
				<strong>I know my level</strong>
				<span>Pick it from the twelve sub-levels, A1.1 to C2.2.</span>
			</span>
			<Icon name="chevronDown" size="1.1em" class={picking ? 'flip' : ''} />
		</button>
	</div>

	{#if picking}
		<ol class="pick" id="level-pick">
			{#each levels as l (l.level)}
				<li>
					<button type="button" onclick={() => choose('pick', l.level)}>
						<span class="code tnum">{l.level}</span>
						<span class="t"><strong lang="de">{name(l.title)}</strong><small>{LEVEL_MEANING[l.level] ?? ''}</small></span>
					</button>
				</li>
			{/each}
		</ol>
	{/if}

	<p class="small">Nothing is locked, whatever you choose. You can change the level any time from your deck, or retake the test under <a href="/level-check">Your level</a>.</p>
</main>

<style>
	.start {
		max-width: 44rem;
		padding-bottom: 4rem;
	}

	h1 {
		margin: 0.3rem 0 0.5rem;
	}

	.ways {
		display: grid;
		gap: 0.8rem;
		margin: 1.5rem 0;
	}

	.way {
		display: flex;
		align-items: center;
		gap: 1rem;
		width: 100%;
		padding: 1rem 1.2rem;
		border: 1px solid var(--line);
		border-radius: 0.9rem;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		text-align: left;
		text-decoration: none;
		cursor: pointer;
	}

	.way:hover {
		border-color: var(--heading);
	}

	.way.main {
		border: 2px solid var(--accent);
	}

	.disc {
		display: grid;
		place-items: center;
		flex: none;
		width: 2.8rem;
		height: 2.8rem;
		border-radius: 50%;
		background: var(--accent);
		color: var(--surface);
	}

	.body {
		display: flex;
		flex: 1;
		flex-direction: column;
		gap: 0.2rem;
	}

	.body strong {
		color: var(--heading);
		font-size: var(--step-1);
	}

	.body span {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.pick {
		display: grid;
		gap: 0.4rem;
		list-style: none;
		margin: 0 0 1.5rem;
		padding: 0;
	}

	.pick button {
		display: flex;
		gap: 0.9rem;
		align-items: baseline;
		width: 100%;
		padding: 0.7rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: 0.6rem;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		text-align: left;
		cursor: pointer;
	}

	.pick button:hover {
		border-color: var(--heading);
	}

	.code {
		flex: none;
		min-width: 2.8rem;
		font-weight: 800;
		color: var(--accent-ink);
	}

	.t {
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
	}

	.t small {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.small {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	:global(.flip) {
		transform: rotate(180deg);
	}
</style>
