<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	// The front door. One product, one language pair: English → German. The copy
	// and the numbers come from the course bundle (see +page.ts), so nothing here
	// is a hand-maintained duplicate of the content — and because the route is
	// prerendered, a crawler sees all of it as plain HTML.
	import Icon from '$lib/icons/Icon.svelte';
	import TryExercise from '$lib/components/TryExercise.svelte';
	import HeroArt from '$lib/components/HeroArt.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const courseHref = $derived(`/course/${data.card.id}`);
	const firstHref = $derived(
		data.firstQuizId ? `/course/${data.card.id}/quiz/${data.firstQuizId}` : courseHref
	);

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
		({
			'@context': 'https://schema.org',
			'@type': 'Course',
			name: 'German for English speakers (A1–C2)',
			description: data.card.tagline,
			educationalLevel: 'CEFR A1–C2',
			inLanguage: 'en',
			teaches: 'German',
			isAccessibleForFree: true,
			provider: {
				'@type': 'Organization',
				name: 'Language Quiz',
				url: 'https://languagequiz.org'
			},
			hasCourseInstance: {
				'@type': 'CourseInstance',
				courseMode: 'online',
				courseWorkload: 'PT10M'
			}
		})
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
	jsonLd={[jsonLd, faqLd]}
/>

<!-- A warm wash behind the top of the page, so the hero sits on colour
     rather than on bare paper. -->
<div class="backdrop" aria-hidden="true"></div>

<SiteNav {courseHref} />

<main>
	<section class="hero">
		<div class="hero-copy">
			<p class="eyebrow">
				Free German course for English speakers
			</p>
			<h1>Learn German properly — from your first <em>Hallo</em> to C2.</h1>
			<p class="lede">
				{data.total} short, interactive exercises that follow the official A1–C2 syllabus.
				Every lesson starts with a clear explanation, every sentence has audio, and you
				practise until it sticks.
			</p>

			<div class="cta">
				<a class="primary" href={firstHref}>
					Start at A1 <Icon name="arrowRight" size="1.05em" />
				</a>
				<a class="secondary" href="#levels">I already know some German</a>
			</div>

			<ul class="trust">
				<li><Icon name="check" size="1em" /> No sign-up, no payment</li>
				<li><Icon name="check" size="1em" /> Audio for every sentence</li>
				<li><Icon name="check" size="1em" /> Progress saved in your browser</li>
			</ul>
		</div>

		<div class="hero-try">
			<div class="hero-art"><HeroArt /></div>
			<div class="card-slot"><TryExercise href={firstHref} /></div>
		</div>
	</section>

	<section class="stats" aria-label="The course in numbers">
		<div><strong class="tnum">{data.total}</strong><span>exercises</span></div>
		<div><strong class="tnum">{data.subLevelCount}</strong><span>levels, A1 to C2</span></div>
		<div><strong class="tnum">6</strong><span>ways to practise</span></div>
		<div><strong>0 €</strong><span>now and always</span></div>
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
		<a class="primary light" href={firstHref}>
			Start learning German <Icon name="arrowRight" size="1.05em" />
		</a>
	</section>
</main>

<footer class="foot">
	<nav class="quick" aria-label="Footer">
		<a href={courseHref}><Icon name="book" size="1.05em" /> The course</a>
		<a href="/words"><Icon name="words" size="1.05em" /> Word library</a>
		<a href="/settings"><Icon name="settings" size="1.05em" /> Settings</a>
	</nav>
	<p>
		Language Quiz is an independent study aid, not affiliated with or endorsed by any
		examination body. Content version {data.card.version}.
	</p>
</footer>

<style>
	/* -- backdrop --------------------------------------------------------- */

	.backdrop {
		position: absolute;
		inset: 0 0 auto 0;
		z-index: -1;
		height: 58rem;
		background:
			radial-gradient(ellipse 60% 55% at 85% 20%, rgba(201, 104, 59, 0.16), transparent 70%),
			radial-gradient(ellipse 55% 60% at 10% 10%, rgba(31, 58, 95, 0.1), transparent 70%),
			linear-gradient(180deg, #f6efe6 0%, var(--bg) 100%);
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
		grid-template-columns: 1.15fr 1fr;
		gap: 3.5rem;
		align-items: center;
		padding: 2.5rem 0 3.5rem;
	}

	@media (max-width: 56rem) {
		.hero {
			grid-template-columns: minmax(0, 1fr);
			gap: 2.5rem;
			padding-top: 1rem;
		}
	}

	.eyebrow {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		margin: 0 0 1rem;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent);
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

	.lede {
		margin: 0;
		max-width: 36rem;
		font-size: var(--step-1);
		line-height: 1.55;
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

	.hero-try {
		position: relative;
		display: grid;
		place-items: center;
		min-height: 30rem;
	}

	/* The dot field: well beyond the illustration, fading out towards its
	   edges so it has no border — it just thins into the page. */
	.hero-try::before {
		content: '';
		position: absolute;
		inset: -9rem -14rem -8rem -10rem;
		background-image: radial-gradient(circle, rgba(31, 58, 95, 0.32) 1.6px, transparent 1.9px);
		background-size: 18px 18px;
		-webkit-mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, #000 40%, transparent 100%);
		mask-image: radial-gradient(ellipse 50% 50% at 50% 50%, #000 40%, transparent 100%);
		pointer-events: none;
	}

	/* The dots reach past the page's edge on narrow screens; clip them rather
	   than let the page scroll sideways. */
	:global(body) {
		overflow-x: clip;
	}

	.hero-art {
		position: absolute;
		inset: -2rem -3rem -2rem -1rem;
		display: grid;
		place-items: center;
	}

	.card-slot {
		position: relative;
		width: min(100%, 27rem);
	}

	@media (max-width: 56rem) {
		.hero-try {
			min-height: 26rem;
		}
		/* No negative side inset on phones: it would make the page scroll
		   sideways. */
		.hero-art {
			inset: -1rem 0;
		}
	}

	/* -- stats ------------------------------------------------------------ */

	.stats {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
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
			grid-template-columns: repeat(2, 1fr);
		}
		.stats div:nth-child(3) {
			border-left: 0;
		}
		.stats div:nth-child(n + 3) {
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
	.kind-icon[data-kind='speaking'],
	.kind-icon[data-kind='speakRepeat'] {
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

	.foot {
		max-width: 72rem;
		margin: 0 auto;
		padding: 2.5rem 1.25rem 3rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.quick {
		display: flex;
		flex-wrap: wrap;
		gap: 1.4rem;
		margin-bottom: 1rem;
	}

	.quick a {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		color: var(--ink-muted);
		text-decoration: none;
		font-weight: 600;
	}

	.quick a:hover {
		color: var(--heading);
	}

	.foot p {
		margin: 0;
		max-width: 60ch;
		line-height: 1.55;
	}
</style>
