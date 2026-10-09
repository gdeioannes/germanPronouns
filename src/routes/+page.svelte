<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { courseLd, websiteLd } from '$lib/seo';
	// The front door. One product, one language pair: English → German. The
	// hero shows the benefits and one key visual — a learner with the course's
	// cards swirling out of her phone — which is itself the way into the deck.
	// The numbers come from the course bundle (see +page.server.ts), so nothing
	// here is a hand-maintained duplicate of the content, and because the route
	// is prerendered a crawler sees all of it as plain HTML.
	import Icon from '$lib/icons/Icon.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { STORY_EPISODES } from '$lib/domain/stories';
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
	onMount(async () => {
		returning = await progress.hasAnyProgress();
	});
	const startHref = $derived(returning ? courseHref : firstHref);

	// The first episode needs no German at all — the right on-ramp for someone
	// who just landed here.
	const episodes = STORY_EPISODES.filter((e) => e.courseId === data.card.id);
	const firstEpisode = episodes[0];

	// The cards floating above the learner: the landing scenes, each a real
	// moment from the course. Position and tilt as a share of the picture.
	const CARDS = [
		{ img: 'hero-goat', x: 7, y: 30, r: -14, d: 0 },
		{ img: 'hero-currywurst', x: 22, y: 11, r: -7, d: 1.1 },
		{ img: 'hero-skydive', x: 42, y: 2, r: -1, d: 2.3 },
		{ img: 'hero-sauna', x: 62, y: 9, r: 6, d: 0.6 },
		{ img: 'hero-bouncer', x: 78, y: 27, r: 14, d: 1.7 }
	];

	// How it works, in the order you meet it: swipe, learn or play, come back.
	const HOW = [
		{
			img: 'how-swipe',
			zoom: 1.5,
			focus: '50% 52%',
			title: 'Swipe until something catches you',
			try: { id: 'quest_a1_1_zahlen', name: 'Zahlen 0–10', note: 'pick a mission' },
			text: 'The deck deals one card at a time. Not in the mood? Swipe left. Curious? Swipe right.'
		},
		{
			img: 'how-learn',
			zoom: 1.08,
			focus: '50% 50%',
			title: 'Read the rule, or jump straight in',
			try: { id: 'quest_a1_1_artikel', name: 'Artikel im Nominativ', note: 'lesson + quiz' },
			text: 'Every card has a short lesson and a quiz. Hear any sentence spoken, as often as you like.'
		},
		{
			img: 'how-repeat',
			zoom: 1.45,
			focus: '50% 52%',
			title: 'Move on, and come back when you want',
			try: { id: 'quest_a1_1_sprechen_vorstellung', name: 'Sprechen: Vorstellung', note: 'repeat aloud' },
			text: 'Nothing is locked and nothing is lost. Repeat what feels shaky, skip what you already know, collect medals on the way.'
		}
	];

	const FAQ = $derived([
		{
			q: 'Is it really free?',
			a: 'Yes. Every exercise is open — no paywall, no trial, no account. Your progress is saved in your own browser.'
		},
		{
			q: 'Do I need an account?',
			a: 'No. If you want your progress on more than one device, sign in with just your email address — no password, nothing else asked.'
		},
		{
			q: 'I already speak some German — must I start at A1?',
			a: `No. Nothing is locked: pick the level that matches you from the ${data.subLevelCount} sub-levels and start there instead of replaying the basics.`
		},
		{
			q: 'Does it work on my phone?',
			a: 'Yes. It is a website, so it runs in any browser on a phone, tablet or computer, with nothing to install.'
		},
		{
			q: 'Does it prepare me for an exam?',
			a: 'The levels follow the CEFR scale from A1 to C2 and the skills exams test: reading, listening, writing and speaking. Language Quiz is an independent study aid and is not affiliated with any examination body.'
		},
		{
			q: 'How is AI used?',
			a: 'Illustrations and the audio voices are generated; the lessons and exercises are written and checked by a person. Nothing you do is sent to an AI. More on the About page.'
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
	title="Learn German Free — Swipe-Through Course, A1 to C2 | Language Quiz"
	description="Learn German from English with {data.total} free five-minute cards: lessons, quizzes, picture hunts and story episodes, every sentence spoken. A1 to C2, no sign-up."
	path="/"
	ogTitle="Language Quiz — Swipe your way to German, free"
	ogDescription="A free German course for English speakers: swipe through five-minute cards with lessons, quizzes, picture hunts and Maya's Berlin mysteries. Every sentence spoken, A1 to C2, no account."
	jsonLd={[websiteLd(), jsonLd, faqLd]}
/>

<!-- A warm wash behind the top of the page, so the hero sits on colour
     rather than on bare paper. -->
<div class="backdrop" aria-hidden="true"></div>

<SiteNav {courseHref} />

<main>
	<section class="hero">
		<div class="hero-head">
			<p class="kicker">Free German course · A1 to C2</p>
			<h1>
				<span class="swipe-word"
					>Swipe <span class="swipe-glyph" aria-hidden="true"><Icon name="swipe" size="0.8em" /></span></span
				>
				your way to German.
			</h1>
		</div>
		<div class="hero-copy">
			<p class="lede">
				Swipe right on what you want to learn, left on what you don't. Five-minute cards,
				every sentence spoken, from your first <em lang="de">Hallo</em> to C2.
			</p>
			<ul class="benefits">
				<li>
					<span class="b-icon"><Icon name="bolt" size="1.55em" stroke={2} /></span>
					<div><strong>Open to you, no locks</strong><span>Every level from day one. Sign in with your email to sync — or don't.</span></div>
				</li>
				<li>
					<span class="b-icon"><Icon name="trophy" size="1.55em" stroke={2} /></span>
					<div><strong>Learn while having fun</strong><span>Quizzes, picture hunts, streaks and medals.</span></div>
				</li>
				<li>
					<span class="b-icon"><Icon name="repeat" size="1.55em" stroke={2} /></span>
					<div><strong>Practise, repeat, take your time</strong><span>Learning isn't linear. Come back as often as you like.</span></div>
				</li>
				<li>
					<span class="b-icon"><Icon name="compass" size="1.55em" stroke={2} /></span>
					<div><strong>Solve mysteries in German</strong><span>Story episodes with Maya in Berlin. The first needs zero German.</span></div>
				</li>
			</ul>
		</div>

		<!-- The picture and the one button under it are the way in. A newcomer
		     lands in the first lesson, not on the deck's tutorial; a returning
		     learner goes back to the deck, which deals their next card. -->
		<div class="key">
			<a class="key-pic" href={startHref} tabindex="-1" aria-hidden="true">
				<img
					class="sitter"
					src="/img/landing-sitter.webp"
					alt=""
					width="1024"
					height="747"
					fetchpriority="high"
				/>
				{#each CARDS as card (card.img)}
					<span
						class="float-card"
						style:left="{card.x}%"
						style:--y="{card.y}%"
						style:--r="{card.r}deg"
						style:--d="{card.d}s"
					>
						<img src="/img/{card.img}.webp" alt="" width="512" height="374" loading="eager" />
					</span>
				{/each}
			</a>
			<a class="deal" href={startHref}>
				<span class="deal-main">
					{returning ? 'Keep learning' : 'Start learning German'}
					<Icon name="arrowRight" size="1.1em" />
				</span>
				<span class="deal-sub">{returning ? 'Your next card is ready' : 'Free · no account · 5 minutes'}</span>
			</a>
		</div>
	</section>

	<section id="how" class="block">
		<header class="block-head">
			<p class="kicker">How it works</p>
			<h2>Your course, your order</h2>
		</header>
		<ol class="how">
			{#each HOW as step, i (step.img)}
				<li>
					<span class="how-pic">
						<img
							src="/img/{step.img}.webp"
							alt=""
							width="512"
							height="512"
							loading="lazy"
							style:transform="scale({step.zoom})"
							style:transform-origin={step.focus}
						/>
					</span>
					<span class="num">{i + 1}</span>
					<h3>{step.title}</h3>
					<p>{step.text}</p>
					<a class="try" href="/course/{data.card.id}/quiz/{step.try.id}">
						<span class="try-label">Try it</span>
						<span class="try-text"
							><span class="try-name" lang="de">{step.try.name}</span>
							<span class="try-note">· {step.try.note}</span></span
						>
						<Icon name="arrowRight" size="1em" />
					</a>
				</li>
			{/each}
		</ol>
	</section>

	{#if firstEpisode}
		<section class="story">
			<img src="/img/{firstEpisode.image}.webp" alt="" width="1024" height="768" loading="lazy" />
			<div class="story-copy">
				<p class="kicker light">Story mode</p>
				<h2>Solve a mystery in German.</h2>
				<p>
					Maya lands in Berlin with a dead phone and not one word of German. {episodes.length}
					episodes so far — and the first one needs zero German, so you can play it tonight.
				</p>
				<a class="primary light" href={firstEpisode.href}>
					Play “{firstEpisode.title}” <Icon name="arrowRight" size="1.05em" />
				</a>
			</div>
		</section>
	{/if}

	<section id="levels" class="block">
		<header class="block-head">
			<p class="kicker">Already know some German?</p>
			<h2>Start where you are</h2>
			<p class="block-lede">
				Every level is open. Pick the one that fits and the deck deals from there.
			</p>
		</header>

		<ol class="levels">
			{#each data.bands as band (band.letter)}
				<li>
					<a
						class="level"
						data-band={band.letter.charAt(0)}
						href="/course/{data.card.id}/level/{band.modules[0]?.level ?? band.letter}"
					>
						<span class="level-art">
							<img
								src="/img/level-{band.letter.toLowerCase()}.webp"
								alt=""
								width="512"
								height="512"
								loading="lazy"
							/>
						</span>
						<span class="level-text">
							<span class="level-top"
								><span class="letter">{band.letter}</span>
								<span class="level-name">{band.name}</span></span
							>
							<span class="level-count tnum">{band.count} exercises</span>
						</span>
					</a>
				</li>
			{/each}
		</ol>

	</section>

	<section class="block faq-block">
		<header class="block-head">
			<p class="kicker">FAQ</p>
			<h2>Good to know</h2>
		</header>
		<dl class="faq">
			{#each FAQ as item (item.q)}
				<div>
					<dt>{item.q}</dt>
					<dd>
						{#if item.q.startsWith('How is AI')}
							{item.a.replace(' More on the About page.', '')} <a href="/about#ai">More on the About page.</a>
						{:else}
							{item.a}
						{/if}
					</dd>
				</div>
			{/each}
		</dl>
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

	/* Wide: the words on the left, the picture and its button on the right.
	   The headline and the rest of the copy are separate blocks so a phone can
	   slip the picture between them. */
	.hero {
		display: grid;
		grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
		grid-template-areas:
			'head key'
			'copy key';
		align-items: center;
		column-gap: 2rem;
		padding: 1.5rem 0 3.5rem;
	}

	.hero-head {
		grid-area: head;
		align-self: end;
	}

	.hero-copy {
		grid-area: copy;
		align-self: start;
	}

	.key {
		grid-area: key;
	}

	.hero .kicker {
		margin-bottom: 0.9rem;
	}

	.swipe-word {
		white-space: nowrap;
	}

	/* The swipe glyph rides beside the word at letter height and nudges left
	   and right, the way the deck's cards go. */
	.swipe-glyph {
		display: inline-flex;
		vertical-align: -0.08em;
		margin-left: 0.1em;
		color: var(--accent-ink);
		animation: nudge 2.4s ease-in-out infinite;
	}

	@keyframes nudge {
		0%,
		100% {
			transform: translateX(0);
		}
		30% {
			transform: translateX(5px) rotate(6deg);
		}
		70% {
			transform: translateX(-5px) rotate(-6deg);
		}
	}

	h1 {
		margin: 0 0 1rem;
		font-size: clamp(2.4rem, 1.4rem + 3.4vw, 4rem);
		line-height: 1.02;
		letter-spacing: -0.02em;
		color: var(--heading);
	}

	.lede {
		margin: 0.4rem 0 0;
		max-width: 30rem;
		font-size: var(--step-0);
		line-height: 1.6;
		color: var(--ink-muted);
		/* No one-word last line. */
		text-wrap: pretty;
	}

	.lede em {
		font-style: italic;
		color: var(--accent-ink);
	}

	.benefits {
		display: grid;
		gap: 1rem;
		margin: 1.6rem 0 0;
		padding: 0;
		list-style: none;
	}

	.benefits li {
		display: flex;
		gap: 0.85rem;
		align-items: center;
	}

	.benefits strong {
		display: block;
		line-height: 1.25;
		color: var(--heading);
	}

	.benefits span:not(.b-icon) {
		display: block;
		margin-top: 0.1rem;
		font-size: var(--step--1);
		line-height: 1.45;
		color: var(--ink-muted);
	}

	/* The glyph carries the colour, ringed by a thin line of the same colour.
	   Terracotta, navy, ochre, forest. */
	.b-icon {
		--tint: var(--accent-ink);
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.6rem;
		height: 2.6rem;
		flex: none;
		border: 1.5px solid var(--tint);
		border-radius: 50%;
		color: var(--tint);
	}

	.benefits li:nth-child(2) .b-icon {
		--tint: var(--navy);
	}

	.benefits li:nth-child(3) .b-icon {
		--tint: var(--ochre-ink);
	}

	.benefits li:nth-child(4) .b-icon {
		--tint: var(--forest);
	}

	/* -- the key visual and the button ------------------------------------- */

	.key {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0;
	}

	.key .deal {
		margin-top: 0.5rem;
	}

	/* The learner is drawn on the page's own cream with wide margins; the box
	   clips the sides so she fills the column. The cards are real elements
	   laid over her in an arc, so each can drift on its own. */
	.key-pic {
		position: relative;
		display: block;
		width: 100%;
		aspect-ratio: 1024 / 860;
		overflow: hidden;
	}

	.sitter {
		--zoom: 1.2;
		position: absolute;
		left: 50%;
		bottom: -4%;
		width: calc(100% * var(--zoom));
		height: auto;
		transform: translateX(-50%);
		transform-origin: 50% 100%;
		animation: breathe 6s ease-in-out infinite;
	}

	@keyframes breathe {
		0%,
		100% {
			transform: translateX(-50%) scale(1);
		}
		50% {
			transform: translateX(-50%) scale(1.012);
		}
	}

	.float-card {
		position: absolute;
		/* --lift lowers the whole arc where the box is tighter (phones). */
		top: calc(var(--y) + var(--lift, 0%));
		width: 13%;
		aspect-ratio: 3 / 4;
		border: 2px solid var(--navy);
		border-radius: 10%/7.5%;
		background: #fff;
		box-shadow: 0 14px 28px -16px rgba(31, 58, 95, 0.55);
		overflow: hidden;
		rotate: var(--r);
		animation: drift 5.5s ease-in-out infinite;
		animation-delay: calc(var(--d) * -1);
	}

	/* The scenes have wide paper margins: zoom in so the subject fills the card. */
	.float-card img {
		position: absolute;
		inset: -30%;
		width: 160%;
		height: 160%;
		object-fit: cover;
	}

	@keyframes drift {
		0%,
		100% {
			translate: 0 0;
		}
		50% {
			translate: 0 -7px;
		}
	}

	.key:hover .float-card {
		animation-duration: 2.2s;
	}

	/* The button: big, terracotta, with its promise written underneath. */
	.deal {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.15rem;
		padding: 0.9rem 2.4rem 0.8rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		text-decoration: none;
		box-shadow: 0 16px 32px -16px rgba(201, 104, 59, 0.85);
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.deal:hover {
		transform: translateY(-3px);
		box-shadow: 0 22px 40px -18px rgba(201, 104, 59, 1);
	}

	.deal-main {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 700;
		line-height: 1.1;
	}

	.deal-main :global(.icon) {
		transition: transform var(--medium) var(--ease-out);
	}

	.deal:hover .deal-main :global(.icon) {
		transform: translateX(4px);
	}

	.deal-sub {
		font-size: var(--step--1);
		font-weight: 600;
		color: rgba(255, 255, 255, 0.82);
	}

	@media (prefers-reduced-motion: reduce) {
		.sitter,
		.float-card,
		.swipe-glyph {
			animation: none;
		}
	}

	/* On a phone: headline, then the picture and its button, then the rest. */
	@media (max-width: 56rem) {
		.hero {
			grid-template-columns: minmax(0, 1fr);
			grid-template-areas:
				'head'
				'key'
				'copy';
			row-gap: 0.75rem;
			padding-top: 0.25rem;
		}
		.hero-head {
			text-align: center;
		}
		/* The first screen must hold the headline, the picture and the button. */
		.hero .kicker {
			margin-bottom: 0.4rem;
			font-size: 0.68rem;
		}
		h1 {
			margin-bottom: 0;
			font-size: clamp(1.9rem, 1.2rem + 3.6vw, 2.4rem);
		}
		.sitter {
			--zoom: 1.3;
		}
		.key-pic {
			--lift: 7%;
			aspect-ratio: 1024 / 900;
		}

		.key {
			max-width: 22rem;
			margin: 0 auto;
		}
		.key .deal {
			margin-top: 0.25rem;
		}
		.deal {
			padding: 0.7rem 1.6rem 0.6rem;
		}
		.deal-main {
			font-size: var(--step-1);
			white-space: nowrap;
		}
	}

	/* -- how it works: three equal cards --------------------------------- */

	.how {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(min(16rem, 100%), 1fr));
		gap: 1.25rem;
		margin: 0;
		padding: 0;
		list-style: none;
		counter-reset: how;
	}

	/* One cream card: the picture bleeds to the top edge, the words sit right
	   under it on the same paper. */
	.how li {
		position: relative;
		display: flex;
		flex-direction: column;
		padding: 0 1.4rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: 20px;
		background: #fbf5e4;
		overflow: hidden;
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.how li:hover {
		transform: translateY(-3px);
		box-shadow: 0 20px 40px -30px rgba(31, 58, 95, 0.45);
	}

	/* The pictures are drawn small on wide paper: a square window, each one
	   zoomed just enough that its subject fills it without losing a foot. */
	.how-pic {
		display: block;
		margin: 0 -1.4rem 0.8rem;
		aspect-ratio: 1;
		overflow: hidden;
	}

	.how-pic img {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.how .num {
		position: absolute;
		top: 1rem;
		left: 1rem;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-size: 0.95rem;
		font-weight: 800;
		box-shadow: 0 0 0 3px #fbf5e4;
	}

	.how h3 {
		margin: 0 0 0.4rem;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		line-height: 1.2;
	}

	.how p {
		margin: 0 0 0.25rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.55;
	}

	/* A real exercise to try, pinned to the card's foot. */
	.try {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		align-items: center;
		gap: 0.5rem;
		margin-top: auto;
		padding-top: 1rem;
		font-size: var(--step--1);
		color: var(--heading);
		text-decoration: none;
	}

	.try-label {
		padding: 0.15rem 0.55rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}

	.try-name {
		font-weight: 700;
	}

	.try-note {
		color: var(--ink-muted);
	}

	.try-text {
		line-height: 1.35;
	}

	.try :global(.icon) {
		color: var(--accent-ink);
		transition: transform var(--fast) var(--ease-out);
	}

	.try:hover .try-name {
		color: var(--accent-ink);
	}

	.try:hover :global(.icon) {
		transform: translateX(3px);
	}

	/* Phone: one card per row, laid sideways — the picture on the left, the
	   words beside it — so three cards fit in a screen and a half. */
	@media (max-width: 40rem) {
		.how {
			gap: 0.75rem;
		}
		.how li {
			display: grid;
			grid-template-columns: 38% minmax(0, 1fr);
			column-gap: 0.9rem;
			align-items: center;
			padding: 0 0.9rem 0 0;
			border-radius: 16px;
		}
		.how-pic {
			grid-row: 1 / 4;
			align-self: stretch;
			margin: 0;
			aspect-ratio: auto;
			min-height: 11rem;
		}
		.how .num {
			top: 0.5rem;
			left: 0.5rem;
			width: 1.5rem;
			height: 1.5rem;
			font-size: 0.75rem;
		}
		.how h3 {
			margin: 0.9rem 0 0.25rem;
			font-size: var(--step-0);
		}
		.how p {
			margin: 0;
			font-size: 0.8rem;
			line-height: 1.45;
		}
		.try {
			grid-template-columns: auto minmax(0, 1fr) auto;
			margin: 0;
			padding: 0.5rem 0 0.9rem;
			font-size: 0.78rem;
		}
		.try-label {
			font-size: 0.58rem;
			padding: 0.1rem 0.4rem;
		}
		.try-note {
			display: none;
		}
	}

	/* -- the pill button, used on the story band and the closing band ----- */

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		padding: 0.95rem 1.8rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-size: var(--step-0);
		font-weight: 700;
		text-decoration: none;
		box-shadow: 0 14px 30px -16px rgba(201, 104, 59, 0.8);
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out),
			background var(--medium) var(--ease-out);
	}

	.primary:hover {
		transform: translateY(-2px);
		color: #fff;
		text-decoration: none;
		box-shadow: 0 20px 36px -18px rgba(201, 104, 59, 0.9);
	}

	.primary :global(.icon) {
		transition: transform var(--medium) var(--ease-out);
	}

	.primary:hover :global(.icon) {
		transform: translateX(3px);
	}

	/* On navy the terracotta reads a step brighter, with a warm glow. */
	.primary.light {
		background: var(--accent);
		box-shadow: 0 16px 36px -14px rgba(201, 104, 59, 1);
	}

	.primary.light:hover {
		background: #d9754a;
	}

	/* -- story ------------------------------------------------------------ */

	.story {
		display: grid;
		grid-template-columns: 1fr 1fr;
		align-items: center;
		gap: 2.5rem;
		margin-top: 5rem;
		padding: 2rem;
		border-radius: 24px;
		background:
			radial-gradient(circle at 10% 90%, rgba(201, 104, 59, 0.35), transparent 45%),
			var(--navy);
		color: #fff;
	}

	.story img {
		width: 100%;
		height: auto;
		border-radius: 16px;
		box-shadow: 0 30px 60px -30px rgba(0, 0, 0, 0.6);
	}

	.story h2 {
		color: #fff;
		margin-bottom: 0.7rem;
	}

	.story-copy p {
		margin: 0 0 1.6rem;
		color: rgba(255, 255, 255, 0.8);
		line-height: 1.6;
	}

	.kicker.light {
		color: #f3c3a9;
	}

	@media (max-width: 56rem) {
		.story {
			grid-template-columns: minmax(0, 1fr);
			padding: 1.25rem;
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
		color: var(--accent-ink);
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

	/* -- faq: two columns, each read top to bottom ----------------------- */

	.faq {
		columns: 2;
		column-gap: 3.5rem;
		margin: 0;
	}

	.faq > div {
		break-inside: avoid;
		padding: 0 0 1.1rem;
		margin-bottom: 1.1rem;
		border-bottom: 1px solid var(--line);
	}

	.faq dt {
		font-weight: 700;
		color: var(--heading);
	}

	.faq dd {
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
		line-height: 1.55;
	}

	@media (max-width: 48rem) {
		.faq {
			columns: 1;
		}
	}

	.faq dd a {
		color: var(--accent-ink);
	}

	/* -- levels: six compact chips ---------------------------------------- */

	.levels {
		display: grid;
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 0.75rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.level {
		--band: var(--navy);
		display: flex;
		align-items: center;
		gap: 0.85rem;
		height: 100%;
		padding: 0.6rem 1rem 0.6rem 0.6rem;
		border: 1px solid var(--line);
		border-left: 4px solid var(--band);
		border-radius: 14px;
		background: var(--surface);
		text-decoration: none;
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out),
			border-color var(--medium) var(--ease-out);
	}

	.level:hover {
		transform: translateY(-2px);
		border-color: var(--band);
		box-shadow: 0 16px 32px -24px rgba(31, 58, 95, 0.45);
	}

	.level[data-band='A'] {
		--band: var(--forest);
	}
	.level[data-band='B'] {
		--band: var(--ochre);
	}
	.level[data-band='C'] {
		--band: var(--terracotta);
	}

	/* The vignette, cropped to a round on its own cream. */
	.level-art {
		flex: none;
		width: 3.6rem;
		height: 3.6rem;
		border-radius: 50%;
		background: #fbf5e4;
		overflow: hidden;
	}

	.level-art img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transform: scale(1.35);
		transform-origin: 50% 55%;
	}

	.level-text {
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
		min-width: 0;
	}

	.level-top {
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	.letter {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		padding: 0.05rem 0.5rem;
		border-radius: 999px;
		background: var(--band);
		color: #fff;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 0.9rem;
		font-weight: 700;
	}

	.level-name {
		font-weight: 700;
		line-height: 1.2;
		color: var(--heading);
	}

	.level-count {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	@media (max-width: 64rem) {
		.levels {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
	}

	/* Phone: one chip per row, name and count on a single line. */
	@media (max-width: 40rem) {
		.levels {
			grid-template-columns: minmax(0, 1fr);
			gap: 0.5rem;
		}
		.level {
			padding: 0.45rem 0.8rem 0.45rem 0.45rem;
		}
		.level-art {
			width: 2.8rem;
			height: 2.8rem;
		}
		.level-text {
			flex-direction: row;
			align-items: center;
			justify-content: space-between;
			flex: 1;
			gap: 0.6rem;
		}
		.level-count {
			font-size: 0.78rem;
			white-space: nowrap;
		}
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
