<script lang="ts">
	// About: the project's story and the person behind it. Prose lives right
	// here — it changes rarely and has no reason to be data.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { absoluteUrl } from '$lib/seo';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title="About — Language Quiz"
	description="The story behind Language Quiz: a free, accessible German course from A1 to C2, built by a learner in Germany for people who struggle with linear courses. No account, no ads."
	path="/about"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'AboutPage',
			name: 'About Language Quiz',
			url: absoluteUrl('/about'),
			description:
				'The story and mission of Language Quiz: a free, privacy-first and accessible German course from A1 to C2 that adapts to different styles of learning.',
			about: {
				'@type': 'Course',
				name: 'German Course A1–C2',
				url: absoluteUrl('/course/de_cert_a1'),
				isAccessibleForFree: true,
				accessibilitySummary:
					'Aims at WCAG 2.2 AA: works with a keyboard and screen readers, has no time limits, offers text for listening exercises and reduced motion on request.'
			},
			hasPart: [
				{ '@type': 'WebPageElement', name: 'How AI is used', url: absoluteUrl('/about#ai') },
				{ '@type': 'WebPageElement', name: 'Accessibility', url: absoluteUrl('/about#accessibility') }
			],
			mainEntity: {
				'@type': 'Person',
				name: 'GDI',
				description:
					'Creator of Language Quiz. A German learner living in Germany since 2019, building the course they needed: non-linear, free, and tested on themself first.',
				knowsLanguage: ['de', 'en', 'es'],
				jobTitle: 'Independent developer and course author'
			}
		}
	]}
/>

<SiteNav {courseHref} compact />

<main class="page-wide">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>

	<header>
		<h1>About Language Quiz</h1>
		<p class="lede">
			A free German course from A1 to C2 that respects your time and your
			privacy: no account, no ads, no paywall, and nothing about you leaves
			your browser.
		</p>
	</header>

	<section class="split">
		<div class="lead">
			<h2>The project</h2>
			<p>
				Language Quiz started in June 2026 as a small quiz for the hardest
				habit in German — <em>der, die, das</em> — and <strong class="key">grew, release by
				release, into a complete course</strong>: stepped lessons with audio at every
				level, fill-in exercises, dictation, flashcards, a word library of
				nouns and verbs, printable workbooks, and the beginnings of an
				illustrated story mode. The <a href="/changelog">changelog</a> tells
				that story in full.
			</p>
		</div>
		<figure>
			<img
				src="/img/about_journey.webp"
				alt="A traveller with a suitcase on a hill, looking down a long winding road toward a distant city"
				width="512"
				height="384"
				fetchpriority="high"
			/>
		</figure>
		<p>
			A few convictions shape every decision. <strong class="key">Learning beats testing</strong>, so
			nothing is locked and every level is open from the first visit.
			Small slips — a missing umlaut, a forgotten full stop — don't sink
			an answer, because that is how real practice works. And <strong class="key">the whole
			thing stays free</strong>: your progress lives in your own browser, the
			audio is pre-recorded rather than metered, and there is no account
			to create because none is needed.
		</p>
		<p>
			<strong class="key">Privacy is not a feature here, it is the architecture.</strong> No cookies,
			no identifiers, no consent banner — only anonymous, aggregate
			statistics, as the <a href="/settings">settings page</a> explains in
			plain words.
		</p>
		<div class="disclosure" id="ai">
			<h3>How AI is used</h3>
			<p>
				In the spirit of saying plainly how things work: <strong class="key">this course is made
				with the help of AI tools</strong>, and you should know where.
			</p>
			<ul>
				<li>
					<strong>Pictures</strong> — every illustration is generated with
					Google's Gemini image model, from prompts and a style I write and choose.
				</li>
				<li>
					<strong>Audio</strong> — the German you hear is spoken by Google Cloud
					Text-to-Speech neural voices, not by recorded human speakers.
				</li>
				<li>
					<strong>Lessons and exercises</strong> — Anthropic's Claude helps me draft
					explanations, example sentences and questions; I decide what goes
					in, and check and correct it.
				</li>
				<li>
					<strong>Code</strong> — I write the app with Claude Code, an AI coding assistant.
				</li>
			</ul>
			<p>
				<strong class="key">None of it runs on you</strong>: no AI reads your answers or your progress,
				and the speaking exercise hands off to an assistant <em>you</em>
				choose. AI still gets things wrong, and some slips will get past me
				— if you spot one, please tell me.
			</p>
		</div>
	</section>

	<section class="split">
		<div class="lead">
			<h2>The mission</h2>
			<p>
				Most language courses assume one kind of learner: start at page
				one, proceed in a straight line, pass the test, turn the page.
				Plenty of people don't learn that way — and too many of them
				conclude the problem is them. <strong class="key">It isn't.</strong> Part of my mission with
				Language Quiz is to <strong class="key">open German up to exactly those people</strong>.
			</p>
		</div>
		<figure>
			<img
				src="/img/about_paths.webp"
				alt="A learner stepping off a rigid straight path of identical stones onto one of several colourful winding paths that all lead to the same town"
				width="512"
				height="384"
				loading="lazy"
			/>
		</figure>
		<p>
			That is why the course refuses to be a single straight line. You
			can read a lesson, listen to it, drill it as flashcards, type it,
			speak it, follow it as an illustrated story, or print it and work
			on paper — the same German, offered in as many shapes as there are
			ways of learning. Jump levels, circle back, skip what bores you:
			<strong class="key">the course adapts to how you learn, not the other way round.</strong>
		</p>
		<p>
			And it runs on free, open technology end to end, so it can stay
			free for every learner. <strong class="key">Access to a language should not depend on
			a subscription.</strong>
		</p>
		<div class="disclosure" id="accessibility">
			<h3>Accessibility</h3>
			<p>
				Opening German up has to include people who use a screen reader, a
				keyboard instead of a mouse, or who can't rely on colour, sound or
				fast reading. <strong class="key">The course is built to work for them too</strong>, aiming
				at the WCAG 2.2 AA guidelines:
			</p>
			<ul>
				<li>
					<strong>Screen readers</strong> — right and wrong answers, corrections
					and results are read out, and German is marked as German, so a
					corrected sentence is spoken in a German voice rather than an
					English one.
				</li>
				<li>
					<strong>Keyboard</strong> — every exercise, the card deck and every
					panel work without a mouse, with a "skip to content" link and focus
					that never gets lost when the screen changes.
				</li>
				<li>
					<strong>Your own pace</strong> — in <a href="/settings">settings</a>,
					"Wait for me" stops the exercises moving on by themselves; nothing
					is timed.
				</li>
				<li>
					<strong>Hearing</strong> — a setting adds a "Show the text" button to
					dictations and listening exercises, for anyone who can't hear the
					audio.
				</li>
				<li>
					<strong>Seeing</strong> — text meets the contrast guidelines, and
					noun genders are told apart by their underline as well as their
					colour.
				</li>
				<li>
					<strong>Motion</strong> — "Calm effects" in settings, or your
					device's "reduce motion" setting, turns off the confetti, shakes
					and pulses.
				</li>
			</ul>
			<p>
				I test this myself, but not with every assistive technology. If
				something gets in your way, <strong class="key">please tell me</strong>; I treat that
				as a bug, not a wish.
			</p>
		</div>
	</section>

	<section class="split">
		<div class="lead">
			<h2>About me</h2>
			<p>
				Hi — I'm GDI. I moved to Germany in 2019, and I've been learning
				German the hard way ever since: every classroom course from A1 to
				B1.2, most of them more than once, plus the big language apps and a
				long list of other online resources. <strong class="key">And still I
				struggle.</strong> Every one of those tools lost me the same way — the
				rigid forward march, one page after the next, until the interest
				drained away and I stopped. But stopping isn't an option when you
				live here. I need to keep learning.
			</p>
		</div>
		<figure>
			<img
				src="/img/about_builder.webp"
				alt="A person at a small desk, writing in an exercise book with one hand while stacking building blocks with the other"
				width="512"
				height="384"
				loading="lazy"
			/>
		</figure>
		<p>
			<strong class="key">So I'm building the course I needed</strong>: something that works on its
			own and alongside a classroom course, for keeping the language
			alive between lessons. <strong class="key">I'm also its first test subject</strong> — nearly
			every interaction in the app gets tried on me first, kept when it
			works and rebuilt when it doesn't, so the app gets better while I
			learn. I hope it helps more people in my situation, and in
			situations I haven't imagined yet.
		</p>
		<p>
			I build this on my own — the code, the course content, the
			drawings and the audio, with the AI tools
			<a href="#ai">described above</a>. If something is wrong, confusing or
			missing, <strong class="key">I genuinely want to know</strong>: the app has grown out of
			exactly that kind of feedback. <a href="/contact">Write to me</a> —
			every message gets read.
		</p>
	</section>
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.5rem;
	}

	/* Tighter than the stock page-wide: the full-width paragraphs set the
	   measure here, and past ~95ch they stop being comfortable to read. */
	main {
		max-width: 56rem;
	}

	header {
		margin-bottom: 3rem;
	}

	.lede {
		margin: 0;
		max-width: 62ch;
		color: var(--ink-muted);
	}

	section h2 {
		margin: 0 0 0.75rem;
		font-size: 1.25rem;
	}

	section p {
		margin: 0 0 1rem;
		line-height: 1.65;
	}

	/* The line each paragraph turns on: a touch heavier, in the heading ink,
	   over a soft terracotta highlighter stroke along the lower half — enough
	   for a skimming eye to catch, quiet enough to keep it prose. */
	.key {
		font-weight: 600;
		color: var(--heading);
		background: linear-gradient(transparent 58%, var(--accent-soft) 58%);
		box-decoration-break: clone;
		-webkit-box-decoration-break: clone;
		padding-inline: 0.1em;
	}

	/* -- each section: heading + opening paragraph beside the picture, ------
	   -- then the rest of the prose across the full width ------------------ */
	/* The cream panel is the illustration's own paper; rounded like every
	   other card, it reads as a deliberate plate next to the lead text. */
	.split {
		display: grid;
		grid-template-columns: minmax(0, 1fr) minmax(16rem, 22rem);
		column-gap: 3rem;
		row-gap: 0.25rem;
		align-items: center;
		margin-bottom: 3.5rem;
	}

	.split .lead {
		grid-column: 1;
	}

	.split figure {
		grid-column: 2;
		grid-row: 1;
		margin: 0;
	}

	/* The paragraphs after the lead span both columns, ending flush with the
	   picture's right edge so the whole section shares one text block. */
	.split > p {
		grid-column: 1 / -1;
		/* The global p measure would stop short of the picture's edge. */
		max-width: none;
	}

	.split > p:last-child {
		margin-bottom: 0;
	}

	/* The AI disclosure: a quiet ruled-off note across the full width. */
	.disclosure {
		grid-column: 1 / -1;
		margin-top: 0.75rem;
		padding-top: 1.25rem;
		border-top: 1px solid var(--line);
	}

	.disclosure h3 {
		margin: 0 0 0.5rem;
		font-size: 1.05rem;
	}

	.disclosure p,
	.disclosure ul {
		max-width: none;
	}

	.disclosure ul {
		margin: 0 0 1rem;
		padding-left: 1.25rem;
		line-height: 1.65;
	}

	.disclosure li + li {
		margin-top: 0.35rem;
	}

	.disclosure p:last-child {
		margin-bottom: 0;
	}

	.split img {
		display: block;
		width: 100%;
		height: auto;
		border-radius: var(--radius);
	}

	/* On a phone everything stacks: heading, lead, picture, rest. The plate
	   shrinks and centres — the illustration carries generous drawn-in
	   margins, so at full width it would swallow a whole screen. */
	@media (max-width: 48rem) {
		.split {
			grid-template-columns: 1fr;
			margin-bottom: 2.5rem;
		}
		.split figure {
			grid-column: 1;
			grid-row: auto;
			margin: 0.25rem 0 1.25rem;
		}
		.split img {
			max-width: 16rem;
			margin-inline: auto;
		}
	}
</style>
