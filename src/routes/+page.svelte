<script lang="ts">
	// The front door. One product, one language pair: English → German. The copy
	// and the numbers come from the course bundle (see +page.ts), so nothing here
	// is a hand-maintained duplicate of the content — and because the route is
	// prerendered, a crawler sees all of it as plain HTML.
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { rise } from '$lib/motion';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const courseHref = $derived(`/course/${data.card.id}`);

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
			a: `From absolute beginner A1 to C2, split into ${data.subLevelCount} sub-levels. Each one opens when you finish the one before it, so there is always a clear next step.`
		},
		{
			q: 'I already speak some German — must I start at A1?',
			a: 'No. The course home lets you set your starting point, so you can open the level that matches you instead of replaying the basics.'
		}
	]);

	const jsonLd = $derived(
		JSON.stringify({
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
		JSON.stringify({
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

<svelte:head>
	<title>Learn German Free — English to German Course & Quizzes (A1–C2)</title>
	<meta
		name="description"
		content="Learn German from English with {data.total} free interactive exercises: grammar, reading, listening, dictation and speaking, every sentence with audio. A1 to C2, no sign-up."
	/>
	<link rel="canonical" href="https://languagequiz.org/" />

	<!-- The social card, carried over from the Flutter build's index.html.
	     og:url and og:image must be absolute: most crawlers reject relative ones. -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://languagequiz.org/" />
	<meta property="og:site_name" content="Language Quiz" />
	<meta
		property="og:title"
		content="Language Quiz - Free German Course for English Speakers"
	/>
	<meta
		property="og:description"
		content="Free interactive German grammar and vocabulary exercises with audio. A step-by-step CEFR A1-C2 path, no sign-up needed."
	/>
	<meta property="og:image" content="https://languagequiz.org/og-image.png" />
	<meta property="og:image:width" content="1200" />
	<meta property="og:image:height" content="630" />
	<meta property="og:image:alt" content="Language Quiz - a free interactive German course" />
	<meta property="og:locale" content="en_GB" />
	<meta property="og:locale:alternate" content="de_DE" />
	<meta name="twitter:card" content="summary_large_image" />
	<meta
		name="twitter:title"
		content="Language Quiz - Free German Course for English Speakers"
	/>
	<meta
		name="twitter:description"
		content="Free interactive German exercises with audio. CEFR A1-C2, no sign-up needed."
	/>
	<meta name="twitter:image" content="https://languagequiz.org/og-image.png" />
	<meta name="twitter:image:alt" content="Language Quiz - a free interactive German course" />
	{@html `<script type="application/ld+json">${jsonLd}<\/script>`}
	{@html `<script type="application/ld+json">${faqLd}<\/script>`}
</svelte:head>

<main>
	<section class="hero">
		<p class="eyebrow">
			<span class="flags">{data.card.speakFlag} → {data.card.learnFlag}</span>
			English to German
		</p>
		<h1>Learn German, one short exercise at a time.</h1>
		<p class="lede">
			A free German course built for English speakers. {data.total} interactive exercises
			take you from your first «Hallo» to C2 — grammar you practise rather than read
			about, every sentence with audio, and drills that make you say it out loud.
		</p>

		<div class="cta">
			<a class="primary" href={courseHref}>
				Start learning German <Icon name="arrowRight" size="1.05em" />
			</a>
			<span class="reassure">Free · no sign-up · runs in your browser</span>
		</div>

		<ul class="levels" aria-label="Levels covered">
			{#each data.levels as level, i (level)}
				<li in:rise={{ delay: 60 + i * 50 }}>{level}</li>
			{/each}
		</ul>
	</section>

	<section>
		<h2>Why this one</h2>
		<ul class="cards">
			<li in:rise={{ delay: 60 }}>
				<span class="badge"><Icon name="volume" size="1.2em" /></span>
				<h3>Hear every sentence</h3>
				<p>
					A speak button sits next to each line — the prompt, the answer, the whole
					passage. You never have to guess how a word sounds.
				</p>
			</li>
			<li in:rise={{ delay: 120 }}>
				<span class="badge"><Icon name="mic" size="1.2em" /></span>
				<h3>You actually speak</h3>
				<p>
					Repeat-aloud phrases and guided conversation prompts, so German leaves the
					page instead of staying a reading exercise.
				</p>
			</li>
			<li in:rise={{ delay: 180 }}>
				<span class="badge"><Icon name="ribbon" size="1.2em" /></span>
				<h3>A path, not a pile</h3>
				<p>
					{data.subLevelCount} sub-levels from A1 to C2. Finish one to open the next, so
					there is always exactly one obvious thing to do.
				</p>
			</li>
			<li in:rise={{ delay: 240 }}>
				<span class="badge"><Icon name="check" size="1.2em" /></span>
				<h3>No account, no cost</h3>
				<p>
					Nothing to sign up for and nothing to pay. Progress is stored in your own
					browser and stays there.
				</p>
			</li>
		</ul>
	</section>

	<section>
		<h2>Six ways to practise</h2>
		<ul class="kinds">
			{#each EXERCISES as ex, i (ex.type)}
				<li in:rise={{ delay: 60 + i * 45 }}>
					<span class="kind-icon">
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

	<section class="faq">
		<h2>Questions</h2>
		<dl>
			{#each FAQ as item (item.q)}
				<div>
					<dt>{item.q}</dt>
					<dd>{item.a}</dd>
				</div>
			{/each}
		</dl>
	</section>

	<section class="closing">
		<h2>Ready when you are</h2>
		<p>The first exercise takes about five minutes.</p>
		<a class="primary" href={courseHref}>
			Start learning German <Icon name="arrowRight" size="1.05em" />
		</a>
	</section>

	<footer>
		<nav class="quick">
			<a href={courseHref}><Icon name="book" size="1.05em" /> The course</a>
			<a href="/words"><Icon name="words" size="1.05em" /> Word library</a>
			<a href="/settings"><Icon name="settings" size="1.05em" /> Settings</a>
		</nav>
		<p>
			Language Quiz is an independent study aid, not affiliated with or endorsed by any
			examination body. Content version {data.card.version}.
		</p>
	</footer>
</main>

<style>
	main {
		max-width: 62rem;
		margin: 0 auto;
		padding: 4.5rem 1.25rem 5rem;
	}

	/* -- hero ------------------------------------------------------------- */

	.hero {
		max-width: 46rem;
	}

	.eyebrow {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		margin: 0 0 0.9rem;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.flags {
		font-size: 1.15rem;
		line-height: 1;
		letter-spacing: 0.06em;
	}

	h1 {
		margin: 0 0 0.75rem;
		font-size: var(--step-4);
		line-height: 1.08;
	}

	.lede {
		margin: 0;
		font-size: var(--step-1);
		line-height: 1.6;
		color: var(--ink-muted);
	}

	.cta {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.9rem 1.1rem;
		margin-top: 2rem;
	}

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.85rem 1.6rem;
		border-radius: 999px;
		background: var(--accent);
		color: #fff;
		font-size: var(--step-0);
		font-weight: 700;
		text-decoration: none;
		box-shadow: 0 12px 28px -16px rgba(31, 58, 95, 0.65);
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.primary:hover {
		transform: translateY(-2px);
		box-shadow: 0 18px 34px -18px rgba(31, 58, 95, 0.75);
	}

	.primary :global(.icon) {
		transition: transform var(--medium) var(--ease-out);
	}

	.primary:hover :global(.icon) {
		transform: translateX(3px);
	}

	.reassure {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.levels {
		display: flex;
		flex-wrap: wrap;
		gap: 0.45rem;
		margin: 2.25rem 0 0;
		padding: 0;
		list-style: none;
	}

	.levels li {
		padding: 0.25rem 0.7rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.09em;
		color: var(--ink-muted);
	}

	/* -- sections --------------------------------------------------------- */

	h2 {
		margin: 4rem 0 1.25rem;
		font-size: var(--step-2);
	}

	h3 {
		margin: 0 0 0.3rem;
		font-size: var(--step-0);
	}

	.cards,
	.kinds {
		display: grid;
		gap: 1rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.cards {
		grid-template-columns: repeat(auto-fit, minmax(15rem, 1fr));
	}

	.cards li {
		padding: 1.4rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.cards p,
	.kinds p {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.55;
	}

	.badge {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.4rem;
		height: 2.4rem;
		margin-bottom: 0.9rem;
		border-radius: 999px;
		background: var(--surface-alt);
		color: var(--accent);
	}

	.kinds {
		grid-template-columns: repeat(auto-fit, minmax(19rem, 1fr));
	}

	.kinds li {
		display: flex;
		gap: 0.85rem;
		padding: 1.1rem 1.2rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.kind-icon {
		flex: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.1rem;
		height: 2.1rem;
		border-radius: 999px;
		background: var(--surface-alt);
		color: var(--accent);
	}

	/* The tally is secondary to the name, so it rides along as a small pill. */
	.count {
		margin-left: 0.35rem;
		padding: 0.1rem 0.45rem;
		border-radius: 999px;
		background: var(--surface-alt);
		font-size: 0.7rem;
		font-weight: 800;
		color: var(--ink-muted);
		vertical-align: 0.12em;
	}

	/* -- faq -------------------------------------------------------------- */

	.faq dl {
		display: grid;
		gap: 1.1rem;
		grid-template-columns: repeat(auto-fit, minmax(19rem, 1fr));
		margin: 0;
	}

	.faq dt {
		margin-bottom: 0.3rem;
		font-weight: 700;
	}

	.faq dd {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.55;
	}

	/* -- closing ---------------------------------------------------------- */

	.closing {
		margin-top: 4rem;
		padding: 2.5rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface-alt);
		text-align: center;
	}

	.closing h2 {
		margin: 0 0 0.4rem;
	}

	.closing p {
		margin: 0 0 1.5rem;
		color: var(--ink-muted);
	}

	footer {
		margin-top: 3.5rem;
		padding-top: 1.25rem;
		border-top: 1px solid var(--line);
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	footer p {
		margin: 1.1rem 0 0;
		max-width: 46rem;
	}

	.quick {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
	}

	.quick a {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.45rem 1rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--ink);
		font-weight: 600;
		text-decoration: none;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.quick a:hover {
		border-color: var(--accent);
		color: var(--accent);
	}
</style>
