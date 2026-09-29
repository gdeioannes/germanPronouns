<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { courseLd, websiteLd } from '$lib/seo';
	// The front door. One product, one language pair: English → German. The copy
	// and the numbers come from the course bundle (see +page.ts), so nothing here
	// is a hand-maintained duplicate of the content — and because the route is
	// prerendered, a crawler sees all of it as plain HTML.
	import Icon from '$lib/icons/Icon.svelte';
	import TryExercise from '$lib/components/TryExercise.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { progress } from '$lib/state/progress.svelte';
	import { onMount } from 'svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const courseHref = $derived(`/course/${data.card.id}`);
	const firstHref = $derived(
		data.firstQuizId ? `/course/${data.card.id}/quiz/${data.firstQuizId}` : courseHref
	);

	// A learner coming back must not be dropped into A1.1 again: once the page
	// is live and finds progress, the start buttons lead to the course home,
	// whose deck deals the next exercise from what they have done. The
	// prerendered HTML keeps the A1 link for first visits and crawlers.
	let returning = $state(false);

	// Five moments where you suddenly need German, one per visit. The scene is
	// drawn without words (the image model cannot spell), so the line is real
	// text laid over it, pinned near the speaker as a share of the picture.
	const SCENES = [
		{
			id: 'skydive',
			alt: 'Two people tandem skydiving above tiny fields',
			line: 'Alles klar?!',
			at: { top: '5%', left: '18%' }
		},
		{
			id: 'currywurst',
			alt: 'A vendor handing a tray of sausage and fries to a customer under an umbrella at night',
			line: 'Einmal mit Pommes, bitte!',
			at: { top: '6%', right: '6%' }
		},
		{
			id: 'goat',
			alt: 'A hiker tipping a hat to a goat blocking a mountain path',
			line: 'Darf ich vorbei?',
			at: { top: '8%', left: '12%' }
		},
		{
			id: 'sauna',
			alt: 'An attendant swinging a towel over a sauna stove while bathers fan their faces',
			line: 'Aufguss!',
			at: { top: '4%', right: '10%' }
		},
		{
			id: 'bouncer',
			alt: 'A bouncer with folded arms in front of a club door and a hopeful guest holding up an ID',
			line: 'Heute leider nicht.',
			at: { top: '4%', right: '4%' }
		}
	];
	// The prerendered page shows the first; a visitor gets one at random.
	let scene = $state(SCENES[0]);

	onMount(async () => {
		scene = SCENES[Math.floor(Math.random() * SCENES.length)];
		returning = await progress.hasAnyProgress();
	});
	const startHref = $derived(returning ? courseHref : firstHref);

	// In the order a learner meets them.
	const EXERCISES: { type: keyof typeof QUIZ_TYPE_ICONS; name: string; blurb: string }[] = [
		{
			type: 'fillBlank',
			name: 'Fill in the blank',
			blurb: 'Articles, cases and endings, drilled one sentence at a time.'
		},
		{
			type: 'reading',
			name: 'Reading',
			blurb: 'Short German texts with comprehension questions and an English version.'
		},
		{
			type: 'listening',
			name: 'Listening',
			blurb: 'Hear a passage read aloud, then answer without looking at the text.'
		},
		{
			type: 'dictation',
			name: 'Dictation',
			blurb: 'Type what you hear — the fastest way to fix spelling and endings.'
		},
		{
			type: 'speakRepeat',
			name: 'Repeat aloud',
			blurb: 'Copy native-sounding phrases until the rhythm stops feeling foreign.'
		},
		{
			type: 'speaking',
			name: 'Speaking',
			blurb: 'A guided conversation prompt you run in your own AI voice chat.'
		}
	];

	const FAQ = $derived([
		{
			q: 'Is it really free?',
			a: 'Yes. Every exercise is open — no paywall, no trial, no account. Your progress is saved in your own browser.'
		},
		{
			q: 'Do I need to sign up?',
			a: 'No. Open an exercise and start. Nothing is uploaded, so there is nothing to log in to.'
		},
		{
			q: 'Which German level does it cover?',
			a: `From absolute beginner A1 to C2, split into ${data.subLevelCount} sub-levels. Every one is open from the start, and your progress is tracked as you go, so there is always a clear next step without anything standing in your way.`
		},
		{
			q: 'I already speak some German — must I start at A1?',
			a: 'No. Nothing is locked — open the level that matches you and start there instead of replaying the basics.'
		}
	]);

	const jsonLd = $derived(
		courseLd(
			{ id: data.card.id, name: 'German for English speakers (A1–C2)', tagline: data.card.tagline },
			{ numberOfLessons: data.total }
		)
	);

	const faqLd = $derived(
		({
			'@context': 'https://schema.org',
			'@type': 'FAQPage',
			mainEntity: FAQ.map((item) => ({
				'@type': 'Question',
				name: item.q,
				acceptedAnswer: { '@type': 'Answer', text: item.a }
			}))
		})
	);
</script>

<Seo
	title="Learn German Free — English to German Course & Quizzes (A1–C2)"
	description="Learn German from English with {data.total} free interactive exercises: grammar, reading, listening, dictation and speaking, every sentence with audio. A1 to C2, no sign-up."
	path="/"
	ogTitle="Language Quiz - Free German Course for English Speakers"
	ogDescription="Free interactive German grammar and vocabulary exercises with audio. A step-by-step CEFR A1-C2 path, no sign-up needed."
	jsonLd={[websiteLd(), jsonLd, faqLd]}
/>

<!-- A warm wash behind the top of the page, so the hero sits on colour
     rather than on bare paper. -->
<div class="backdrop" aria-hidden="true"></div>

<SiteNav {courseHref} />

<main>
	<section class="hero">
		<div class="hero-copy">
			<h1>
				From your first <em>Hallo</em> to your first
				<em class="long"
					><span class="de" lang="de"
						>Donau&shy;dampf&shy;schiff&shy;fahrts&shy;gesellschafts&shy;kapitän</span
					><span class="en" lang="en" aria-hidden="true">Danube steamship company captain&nbsp;;)</span
					></em
				>
			</h1>
			<p class="lede">
				Picture flashcards, gap-fills and audio for every sentence. Each lesson explains
				the rule first, then makes it stick, from A1 all the way to C2.
			</p>

			<div class="cta">
				<a class="primary" href={startHref}>
					{returning ? 'Continue learning' : 'Start at A1'}
					<Icon name="arrowRight" size="1.05em" />
				</a>
				{#if !returning}
					<a class="secondary" href="#levels">I already know some German</a>
				{/if}
			</div>

			<ul class="trust">
				<li><Icon name="check" size="1em" /> No sign-up, no payment</li>
				<li><Icon name="check" size="1em" /> Audio for every sentence</li>
				<li><Icon name="check" size="1em" /> Progress saved in your browser</li>
			</ul>
		</div>

		{#key scene.id}
			<figure class="hero-scene">
				<img
					src="/img/hero-{scene.id}.webp"
					alt={scene.alt}
					width="1024"
					height="768"
					fetchpriority="high"
				/>
				<span
					class="bubble"
					lang="de"
					class:tail-left={!!scene.at.left}
					style:top={scene.at.top}
					style:left={scene.at.left}
					style:right={scene.at.right}>{scene.line}</span
				>
			</figure>
		{/key}
		<div class="card-slot"><TryExercise href={startHref} /></div>
	</section>

	<section class="stats" aria-label="The course in numbers">
		<div><strong class="tnum">{data.total}</strong><span>exercises</span></div>
		<div><strong class="tnum">{data.subLevelCount}</strong><span>levels, A1 to C2</span></div>
		<div><strong class="tnum">7</strong><span>ways to practise</span></div>
	</section>

	<section id="levels" class="block">
		<header class="block-head">
			<p class="kicker">Choose your level</p>
			<h2>Start where you are, not at the beginning</h2>
			<p class="block-lede">
				Every level is open. Beginners start at A1; if you already speak some German, jump
				straight to the level that fits and pick up from there.
			</p>
		</header>

		<ol class="bands">
			{#each data.bands as band (band.letter)}
				<li class="band" data-band={band.letter.charAt(0)}>
					<div class="band-top">
						<span class="letter">{band.letter}</span>
						<div>
							<h3>{band.name}</h3>
							<p class="band-count tnum">{band.count} exercises</p>
						</div>
						<img
							class="band-art"
							src="/img/level-{band.letter.toLowerCase()}.webp"
							alt=""
							width="512"
							height="512"
							loading="lazy"
						/>
					</div>
					{#if band.canDo.length}
						<ul class="can-do">
							{#each band.canDo as item (item)}<li>{item}</li>{/each}
						</ul>
					{/if}
					<div class="band-links">
						{#each band.modules as m (m.level)}
							<a href="/course/{data.card.id}/level/{m.level}">
								<span class="tnum">{m.level}</span> {m.title}
							</a>
						{/each}
					</div>
					{#if band.firstQuizId}
						<a class="band-start" href="/course/{data.card.id}/quiz/{band.firstQuizId}">
							Start {band.letter} <Icon name="arrowRight" size="1em" />
						</a>
					{/if}
				</li>
			{/each}
		</ol>
	</section>

	<section id="how" class="block">
		<header class="block-head">
			<p class="kicker">How it works</p>
			<h2>Understand it, practise it, say it</h2>
		</header>
		<ol class="steps">
			<li>
				<span class="num">1</span>
				<h3>Read the rule</h3>
				<p>
					Each exercise opens with a short explanation: the rule, examples with
					translations, a table, the words you need and the mistakes English speakers
					typically make.
				</p>
			</li>
			<li>
				<span class="num">2</span>
				<h3>Practise until it sticks</h3>
				<p>
					Answer sentence by sentence and see the correction instantly, right where the
					gap is. A streak tells you when you have really got it.
				</p>
			</li>
			<li>
				<span class="num">3</span>
				<h3>Hear it and say it</h3>
				<p>
					Every sentence has audio. Listening, dictation and speaking exercises make sure
					German leaves the page and ends up in your ears and your mouth.
				</p>
			</li>
		</ol>
	</section>

	<section class="block">
		<header class="block-head">
			<p class="kicker">Exercise types</p>
			<h2>Six ways to practise</h2>
		</header>
		<ul class="kinds">
			{#each EXERCISES as ex (ex.type)}
				<li>
					<span class="kind-icon" data-kind={ex.type}>
						<Icon name={QUIZ_TYPE_ICONS[ex.type]} size="1.15em" />
					</span>
					<div>
						<h3>{ex.name} <span class="count tnum">{data.counts[ex.type] ?? 0}</span></h3>
						<p>{ex.blurb}</p>
					</div>
				</li>
			{/each}
		</ul>
	</section>

	<section class="block faq">
		<header class="block-head">
			<p class="kicker">Questions</p>
			<h2>Good to know</h2>
		</header>
		<div class="faq-list">
			{#each FAQ as item (item.q)}
				<details>
					<summary>{item.q}<Icon name="chevronDown" size="1em" /></summary>
					<p>{item.a}</p>
				</details>
			{/each}
		</div>
	</section>

	<section class="closing">
		<h2>Your first German lesson takes five minutes.</h2>
		<p>No account, no download, nothing to pay. Just open it and start.</p>
		<a class="primary light" href={startHref}>
			{returning ? 'Continue learning' : 'Start learning German'}
			<Icon name="arrowRight" size="1.05em" />
		</a>
	</section>
</main>

<SiteFooter />

<style>
	/* -- backdrop --------------------------------------------------------- */

	.backdrop {
		position: absolute;
		inset: 0 0 auto 0;
		z-index: -1;
		height: 64rem;
		/* The same cream the scenes are painted on (PAPER in tool/gen-images.mjs),
		   flat across the hero, so the picture has no edge; it fades to the page
		   below the fold. */
		background: linear-gradient(180deg, #fbf5e4 0%, #fbf5e4 42rem, var(--bg) 100%);
		pointer-events: none;
	}

	main {
		max-width: 72rem;
		margin: 0 auto;
		padding: 2rem 1.25rem 0;
	}

	/* -- hero ------------------------------------------------------------- */

	.hero {
		display: grid;
		grid-template-columns: 1.1fr 1fr;
		grid-template-areas:
			'copy scene'
			'copy card';
		column-gap: 3rem;
		align-items: center;
		padding: 1.5rem 0 3.5rem;
	}

	.hero-copy {
		grid-area: copy;
	}

	/* On a phone the picture is the first thing, then the words, then the card:
	   the scene must not wait below the fold. */
	@media (max-width: 56rem) {
		.hero {
			grid-template-columns: minmax(0, 1fr);
			grid-template-areas:
				'scene'
				'copy'
				'card';
			row-gap: 1.5rem;
			padding-top: 0;
		}
	}

	h1 {
		margin: 0 0 1.1rem;
		font-size: clamp(2.3rem, 1.6rem + 2.6vw, 3.6rem);
		line-height: 1.05;
		letter-spacing: -0.015em;
		color: var(--heading);
	}

	h1 em {
		font-style: italic;
		color: var(--accent);
	}

	/* The long word is the joke; let it wrap at its soft hyphens and shrink a
	   step so one absurd noun does not blow the column open. */
	h1 .long {
		font-size: 0.78em;
		hyphens: manual;
		overflow-wrap: anywhere;
		/* Both spellings share one grid cell, so hovering swaps the words
		   without the heading reflowing. */
		display: inline-grid;
		cursor: help;
	}

	/* Staggered swap: the outgoing word fades out before the incoming one
	   fades in, so the two never sit on top of each other half-visible. */
	h1 .long > span {
		grid-area: 1 / 1;
		transition: opacity 0.15s ease 0.15s;
	}

	h1 .long .en,
	h1 .long:hover .de {
		opacity: 0;
		transition-delay: 0s;
	}

	h1 .long:hover .en {
		opacity: 1;
		transition-delay: 0.15s;
	}

	@media (prefers-reduced-motion: reduce) {
		h1 .long > span {
			transition: none;
		}
	}

	/* The second read: quieter and narrower than the headline, with air above. */
	.lede {
		margin: 1.4rem 0 0;
		max-width: 30rem;
		font-size: var(--step-0);
		line-height: 1.6;
		color: var(--ink-muted);
	}

	.cta {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.8rem 1rem;
		margin-top: 2rem;
	}

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.9rem 1.7rem;
		border-radius: 999px;
		background: var(--accent);
		color: #fff;
		font-size: var(--step-0);
		font-weight: 700;
		text-decoration: none;
		box-shadow: 0 14px 30px -16px rgba(201, 104, 59, 0.8);
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.primary:hover {
		transform: translateY(-2px);
		box-shadow: 0 20px 36px -18px rgba(201, 104, 59, 0.9);
	}

	.primary :global(.icon) {
		transition: transform var(--medium) var(--ease-out);
	}

	.primary:hover :global(.icon) {
		transform: translateX(3px);
	}

	.secondary {
		padding: 0.9rem 1.2rem;
		border-radius: 999px;
		color: var(--heading);
		font-weight: 700;
		text-decoration: none;
	}

	.secondary:hover {
		background: var(--surface-alt);
	}

	.trust {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem 1.4rem;
		margin: 1.8rem 0 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.trust li {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
	}

	.trust :global(.icon) {
		color: var(--right);
	}

	/* The scenes are drawn with wide paper margins so their backdrop can be
	   levelled; here the picture is scaled past the figure and the excess is
	   clipped, invisibly, since the paper is the page's own cream. */
	.hero-scene {
		--zoom: 1.2;
		grid-area: scene;
		position: relative;
		width: 100%;
		margin: 0;
		overflow: hidden;
		animation: settle var(--slow) var(--ease-out) backwards;
	}

	.hero-scene img {
		display: block;
		width: calc(100% * var(--zoom));
		height: auto;
		margin: calc((1 - var(--zoom)) * 42%) calc((1 - var(--zoom)) * 50%) calc((1 - var(--zoom)) * 40%);
		user-select: none;
		-webkit-user-drag: none;
	}

	@keyframes settle {
		from {
			transform: translateY(0.6rem);
			opacity: 0;
		}
		to {
			transform: none;
			opacity: 1;
		}
	}

	/* The line, in the display serif, pinned near whoever says it. */
	.bubble {
		position: absolute;
		padding: 0.3em 0.8em;
		border-radius: 999px;
		background: var(--surface);
		box-shadow: 0 8px 22px -10px rgba(31, 58, 95, 0.5);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: clamp(1.05rem, 0.75rem + 1.4vw, 1.6rem);
		font-weight: 700;
		color: var(--heading);
		white-space: nowrap;
		animation: bob 6s ease-in-out infinite;
	}

	.bubble::after {
		content: '';
		position: absolute;
		right: 1.1em;
		bottom: -0.45em;
		width: 0.9em;
		height: 0.9em;
		background: inherit;
		clip-path: polygon(0 0, 100% 0, 50% 100%);
	}

	.bubble.tail-left::after {
		right: auto;
		left: 1.1em;
	}

	@keyframes bob {
		0%,
		100% {
			transform: translateY(0);
		}
		50% {
			transform: translateY(-5px);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.bubble,
		.hero-scene {
			animation: none;
		}
	}

	/* The card tucks under the scene's foot, so scene and exercise read as one. */
	.card-slot {
		grid-area: card;
		position: relative;
		justify-self: center;
		width: min(100%, 27rem);
		margin-top: -3rem;
	}

	@media (max-width: 56rem) {
		.hero-scene {
			--zoom: 1.45;
			justify-self: center;
			width: min(100%, 30rem);
			margin-top: -0.5rem;
		}
		.card-slot {
			margin-top: 0;
		}
	}

	/* -- stats ------------------------------------------------------------ */

	.stats {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		border: 1px solid var(--line);
		border-radius: 18px;
		background: var(--surface);
		overflow: hidden;
	}

	.stats div {
		display: grid;
		gap: 0.15rem;
		padding: 1.4rem 1.2rem;
		text-align: center;
	}

	.stats div + div {
		border-left: 1px solid var(--line);
	}

	.stats strong {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-3);
		color: var(--heading);
		line-height: 1.1;
	}

	.stats span {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	@media (max-width: 40rem) {
		.stats {
			grid-template-columns: 1fr;
		}
		.stats div + div {
			border-left: 0;
			border-top: 1px solid var(--line);
		}
	}

	/* -- sections --------------------------------------------------------- */

	.block {
		padding-top: 5rem;
	}

	.block-head {
		max-width: 40rem;
		margin-bottom: 2rem;
	}

	.kicker {
		margin: 0 0 0.5rem;
		font-size: 0.75rem;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent);
	}

	h2 {
		margin: 0;
		font-size: var(--step-3);
		line-height: 1.15;
		color: var(--heading);
	}

	.block-lede {
		margin: 0.8rem 0 0;
		color: var(--ink-muted);
		line-height: 1.6;
	}

	h3 {
		margin: 0 0 0.3rem;
		font-size: var(--step-0);
		color: var(--heading);
	}

	/* -- levels ----------------------------------------------------------- */

	.bands {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(min(20rem, 100%), 1fr));
		gap: 1rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.band {
		--band: var(--navy);
		display: flex;
		flex-direction: column;
		gap: 0.9rem;
		padding: 1.4rem;
		border: 1px solid var(--line);
		border-top: 4px solid var(--band);
		border-radius: var(--radius);
		background: var(--surface);
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.band:hover {
		transform: translateY(-3px);
		box-shadow: 0 20px 40px -30px rgba(31, 58, 95, 0.45);
	}

	.band[data-band='A'] {
		--band: var(--forest);
	}
	.band[data-band='B'] {
		--band: var(--ochre);
	}
	.band[data-band='C'] {
		--band: var(--terracotta);
	}

	.band-top {
		display: flex;
		align-items: center;
		gap: 0.9rem;
	}

	.letter {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3rem;
		height: 3rem;
		flex: none;
		border-radius: 12px;
		background: var(--band);
		color: #fff;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 1.35rem;
		font-weight: 700;
	}

	.band h3 {
		margin: 0;
	}

	/* The level's vignette, faded at the edges so its cream sits on the card. */
	.band-art {
		width: 7rem;
		height: 7rem;
		flex: none;
		margin: -1.4rem -1rem -1.4rem auto;
		-webkit-mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, #000 55%, transparent 100%);
		mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, #000 55%, transparent 100%);
	}

	.band-count {
		margin: 0.1rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.can-do {
		margin: 0;
		padding: 0 0 0 1.1rem;
		font-size: var(--step--1);
		line-height: 1.5;
		color: var(--ink);
	}

	.can-do li + li {
		margin-top: 0.3rem;
	}

	.band-links {
		display: grid;
		gap: 0.3rem;
		margin-top: auto;
		padding-top: 0.8rem;
		border-top: 1px solid var(--line);
	}

	.band-links a {
		font-size: var(--step--1);
		color: var(--ink-muted);
		text-decoration: none;
	}

	.band-links a span {
		display: inline-block;
		min-width: 2.4rem;
		font-weight: 800;
		color: var(--band);
	}

	.band-links a:hover {
		color: var(--heading);
	}

	.band-start {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		align-self: flex-start;
		font-weight: 700;
		color: var(--band);
		text-decoration: none;
	}

	.band-start:hover :global(.icon) {
		transform: translateX(3px);
	}

	/* -- steps ------------------------------------------------------------ */

	.steps {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(min(16rem, 100%), 1fr));
		gap: 2rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.num {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		margin-bottom: 0.9rem;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-weight: 800;
	}

	.steps p,
	.kinds p {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.6;
	}

	/* -- exercise kinds --------------------------------------------------- */

	.kinds {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(min(19rem, 100%), 1fr));
		gap: 1rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.kinds li {
		display: flex;
		gap: 1rem;
		padding: 1.2rem 1.3rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.kind-icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.5rem;
		height: 2.5rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	.kind-icon[data-kind='reading'] {
		background: #e6ecf3;
		color: var(--navy);
	}
	.kind-icon[data-kind='fillBlank'] {
		background: #ebe7f4;
		color: #55478a;
	}
	.kind-icon[data-kind='vocabulary'] {
		background: #f9e7ee;
		color: #a33a63;
	}
	.kind-icon[data-kind='speakRepeat'] {
		background: #fbe9e2;
		color: #b5522a;
	}
	.kind-icon[data-kind='speaking'] {
		background: var(--accent-soft);
		color: var(--accent);
	}
	.kind-icon[data-kind='listening'] {
		background: #e8efe9;
		color: var(--forest);
	}
	.kind-icon[data-kind='dictation'] {
		background: #f4eddc;
		color: var(--ochre);
	}

	.count {
		margin-left: 0.3rem;
		padding: 0.05rem 0.45rem;
		border-radius: 999px;
		background: var(--surface-alt);
		font-size: 0.72rem;
		font-weight: 800;
		color: var(--ink-muted);
		vertical-align: middle;
	}

	/* -- faq -------------------------------------------------------------- */

	.faq-list {
		max-width: 46rem;
		border-top: 1px solid var(--line);
	}

	details {
		border-bottom: 1px solid var(--line);
	}

	summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		padding: 1.1rem 0;
		font-weight: 700;
		color: var(--heading);
		cursor: pointer;
		list-style: none;
	}

	summary::-webkit-details-marker {
		display: none;
	}

	summary :global(.icon) {
		flex: none;
		color: var(--ink-muted);
		transition: transform var(--medium) var(--ease-out);
	}

	details[open] summary :global(.icon) {
		transform: rotate(180deg);
	}

	details p {
		margin: 0 0 1.2rem;
		max-width: var(--measure);
		color: var(--ink-muted);
		line-height: 1.6;
	}

	/* -- closing ---------------------------------------------------------- */

	.closing {
		margin: 5rem 0 0;
		padding: 3.5rem 2rem;
		border-radius: 24px;
		background:
			radial-gradient(circle at 85% 20%, rgba(201, 104, 59, 0.35), transparent 45%),
			var(--navy);
		color: #fff;
		text-align: center;
	}

	.closing h2 {
		max-width: 28ch;
		margin: 0 auto 0.7rem;
		color: #fff;
	}

	.closing p {
		margin: 0 0 1.8rem;
		color: rgba(255, 255, 255, 0.78);
	}

	/* -- footer ----------------------------------------------------------- */

</style>
