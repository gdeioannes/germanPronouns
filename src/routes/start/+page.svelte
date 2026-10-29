<script lang="ts">
	// The first screen of a first session: where do you start? Everyone used to
	// begin at A1.1 because nothing said they could choose. Three ways in: new
	// to German (the first lesson), find my level (the placement test), or I know
	// my level (pick it). Any choice is remembered, so the course stops asking.
	//
	// It is most learners' very first screen, so it opens like the rest of the
	// app: a small scene, cards that arrive one after the other, and a beat of
	// acknowledgment when a way is chosen before the page moves on.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import { goto } from '$app/navigation';
	import { slide } from 'svelte/transition';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { playSound } from '$lib/services/sounds';
	import { effectsCalm } from '$lib/motion/fx.svelte';
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

	const dur = () => (effectsCalm() ? 0 : 300);
	const wait = (ms: number) => new Promise((r) => setTimeout(r, effectsCalm() ? 0 : ms));

	let picking = $state(false);
	/** Which way was just chosen: its card confirms for a beat before the page moves on. */
	let leaving = $state<'new' | 'pick' | 'test' | null>(null);

	async function choose(how: 'new' | 'pick', level: string) {
		if (leaving) return;
		leaving = how;
		playSound('up');
		await storage.set('deck_level', level);
		await storage.set(START_CHOSEN, how);
		track('start_chosen', { how, level });
		await wait(380);
		await goto(how === 'new' && data.firstQuizId ? `${courseHref}/quiz/${data.firstQuizId}` : courseHref);
	}

	async function chooseTest() {
		if (leaving) return;
		leaving = 'test';
		playSound('up');
		track('start_chosen', { how: 'test', level: '' });
		await wait(380);
		await goto('/level-check/test');
	}
</script>

<Seo
	title="Where do you start? | Language Quiz"
	description="New to German, or not? Start at the beginning, take a ten-minute placement test, or pick your level from A1 to C2."
	path="/start"
/>

<SiteNav {courseHref} />

<main class="page start">
	<!-- The path up the levels: a small flat scene in the picture-book style. -->
	<svg class="scene" viewBox="0 0 640 170" role="img" aria-label="A walker and a dachshund with a suitcase set off along stepping stones labelled A1 to C2, up a gentle hill towards the sun.">
		<circle cx="565" cy="42" r="26" fill="#e0a458" />
		<path d="M0 150 Q 160 96 340 112 T 640 66 L 640 170 L 0 170 Z" fill="#3f5d45" opacity="0.22" />
		<path d="M0 160 Q 200 120 400 130 T 640 96 L 640 170 L 0 170 Z" fill="#3f5d45" opacity="0.4" />
		<!-- stepping stones, one per band, climbing to the right -->
		{#each [['A1', 120, 146], ['A2', 215, 139], ['B1', 310, 131], ['B2', 405, 122], ['C1', 500, 112], ['C2', 592, 101]] as [label, x, y] (label)}
			<ellipse cx={+x} cy={+y + 10} rx="26" ry="8" fill="#1f3a5f" />
			<text x={+x} y={+y + 13} text-anchor="middle" font-size="11" font-weight="700" fill="#fff">{label}</text>
		{/each}
		<!-- the walker, mid-stride towards the stones -->
		<g>
			<circle cx="52" cy="92" r="11" fill="#c9683b" />
			<path d="M52 103 L52 130 M52 112 L38 122 M52 112 L66 120 M52 130 L42 148 M52 130 L63 147" stroke="#1f3a5f" stroke-width="5" stroke-linecap="round" fill="none" />
			<path d="M66 120 L80 112" stroke="#1f3a5f" stroke-width="5" stroke-linecap="round" />
			<rect x="76" y="100" width="16" height="12" rx="2" fill="#c9683b" />
		</g>
		<!-- the dachshund, packed and coming along -->
		<g>
			<ellipse cx="20" cy="140" rx="17" ry="7" fill="#a9802a" />
			<circle cx="38" cy="134" r="6" fill="#a9802a" />
			<path d="M10 145 L10 152 M18 146 L18 153 M26 146 L26 153 M33 145 L33 152" stroke="#a9802a" stroke-width="3" stroke-linecap="round" />
			<path d="M4 138 Q -2 132 2 128" stroke="#a9802a" stroke-width="3" stroke-linecap="round" fill="none" />
			<rect x="12" y="124" width="12" height="9" rx="2" fill="#1f3a5f" />
		</g>
		<path d="M430 48 q 5 -8 10 0 q 5 -8 10 0" stroke="#1f3a5f" stroke-width="2" fill="none" stroke-linecap="round" />
		<path d="M470 32 q 5 -8 10 0 q 5 -8 10 0" stroke="#1f3a5f" stroke-width="2" fill="none" stroke-linecap="round" />
	</svg>

	<div class="arrive">
		<p class="eyebrow">Before your first card</p>
		<h1>Where do you start?</h1>
		<p class="lede">The course runs from your first <em lang="de">Hallo</em> to C2. Start where you are, not at the beginning by default.</p>
	</div>

	<div class="ways">
		<button
			type="button"
			class="way arrive"
			class:chosen={leaving === 'new'}
			style="--arrive-delay: 120ms"
			onclick={() => choose('new', levels[0]?.level ?? 'A1.1')}
		>
			<span class="disc" aria-hidden="true"><Icon name={leaving === 'new' ? 'check' : 'star'} size="1.4em" /></span>
			<span class="body">
				<strong>I’m new to German</strong>
				<span>Start with the very first lesson: numbers, hello, your name.</span>
			</span>
			<Icon name="arrowRight" size="1.1em" />
		</button>

		<button
			type="button"
			class="way main arrive"
			class:chosen={leaving === 'test'}
			style="--arrive-delay: 220ms"
			onclick={chooseTest}
		>
			<span class="disc" aria-hidden="true"><Icon name={leaving === 'test' ? 'check' : 'compass'} size="1.4em" /></span>
			<span class="body">
				<strong>I know some German: find my level</strong>
				<span>A ten-minute placement test: words, grammar, reading and listening. You start where it puts you, and you can skip out and pick a level at any point.</span>
			</span>
			<Icon name="arrowRight" size="1.1em" />
		</button>

		<button
			type="button"
			class="way arrive"
			aria-expanded={picking}
			aria-controls="level-pick"
			style="--arrive-delay: 320ms"
			onclick={() => (picking = !picking)}
		>
			<span class="disc" aria-hidden="true"><Icon name="trophy" size="1.4em" /></span>
			<span class="body">
				<strong>I know my level</strong>
				<span>Pick it from the twelve sub-levels, A1.1 to C2.2.</span>
			</span>
			<span class="chev" class:flip={picking}><Icon name="chevronDown" size="1.1em" /></span>
		</button>
	</div>

	{#if picking}
		<ol class="pick" id="level-pick" transition:slide={{ duration: dur() }}>
			{#each levels as l (l.level)}
				<li>
					<button type="button" class:chosen={leaving === 'pick'} onclick={() => choose('pick', l.level)}>
						<span class="code tnum">{l.level}</span>
						<span class="t"><strong lang="de">{name(l.title)}</strong><small>{LEVEL_MEANING[l.level] ?? ''}</small></span>
					</button>
				</li>
			{/each}
		</ol>
	{/if}

	<p class="small arrive" style="--arrive-delay: 420ms">
		Nothing is locked, whatever you choose. You can change the level any time from your deck, or retake the test under <a href="/level-check">Your level</a>.
	</p>
</main>

<style>
	.start {
		max-width: 44rem;
		padding-bottom: 4rem;
	}

	.scene {
		display: block;
		width: 100%;
		height: auto;
		margin: 0.6rem 0 1rem;
		border-radius: 0.9rem;
		background: var(--surface-alt);
	}

	h1 {
		margin: 0.3rem 0 0.5rem;
	}

	/* Everything arrives one beat after the last, on load as well as on
	   navigation (a CSS animation, so hydration cannot swallow it). */
	.arrive {
		animation: arrive 0.45s ease-out both;
		animation-delay: var(--arrive-delay, 0ms);
	}

	@keyframes arrive {
		from {
			opacity: 0;
			transform: translateY(14px);
		}
		to {
			opacity: 1;
			transform: none;
		}
	}

	:global(html[data-effects='calm']) .arrive {
		animation: none;
	}

	@media (prefers-reduced-motion: reduce) {
		.arrive {
			animation: none;
		}
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
		transition:
			transform 0.12s ease,
			border-color 0.15s ease,
			background 0.25s ease,
			box-shadow 0.15s ease;
	}

	.way:hover {
		border-color: var(--heading);
		transform: translateY(-2px);
		box-shadow: 0 3px 10px rgb(0 0 0 / 0.06);
	}

	.way:active {
		transform: scale(0.985);
	}

	.way.main {
		border: 2px solid var(--accent);
	}

	/* The chosen card confirms: fills softly, its icon becomes a check. */
	.way.chosen {
		border-color: var(--accent);
		background: var(--accent-soft, var(--surface-alt));
	}

	.way.chosen .disc {
		animation: disc-pop 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
	}

	@keyframes disc-pop {
		0% {
			transform: scale(1);
		}
		50% {
			transform: scale(1.25);
		}
		100% {
			transform: scale(1);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.way,
		.way.chosen .disc {
			transition: none;
			animation: none;
		}
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

	.chev {
		display: inline-flex;
		transition: transform 0.25s ease;
	}

	.chev.flip {
		transform: rotate(180deg);
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
		transition:
			transform 0.12s ease,
			border-color 0.15s ease,
			background 0.25s ease;
	}

	.pick button:hover {
		border-color: var(--heading);
	}

	.pick button:active {
		transform: scale(0.99);
	}

	.pick button.chosen {
		border-color: var(--accent);
		background: var(--accent-soft, var(--surface-alt));
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
</style>
