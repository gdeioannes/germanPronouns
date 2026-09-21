<script lang="ts">
	import Icon from '$lib/icons/Icon.svelte';
	import { rise } from '$lib/motion';
	import { courses, catalog } from '$lib/content';

	// Read at build time and baked into the HTML below — no runtime fetch, and
	// no hand-maintained copy of this text anywhere. Compare with the Flutter
	// build, where web/index.html carries ~600 lines of duplicated landing copy
	// and JSON-LD purely because the app paints into a canvas.
	const featured = courses;

	const jsonLd = JSON.stringify({
		'@context': 'https://schema.org',
		'@type': 'ItemList',
		name: 'Language Quiz courses',
		itemListElement: featured.map((course, i) => ({
			'@type': 'ListItem',
			position: i + 1,
			item: {
				'@type': 'Course',
				name: course.name,
				description: course.tagline,
				educationalLevel: `CEFR ${course.level}`,
				isAccessibleForFree: true
			}
		}))
	});
</script>

<svelte:head>
	<title>Language Quiz — Free German Course for English Speakers (A1–C2)</title>
	<meta
		name="description"
		content="A free interactive German course for English speakers. Grammar, vocabulary and speaking quizzes with audio, a step-by-step CEFR A1–C2 path — no sign-up needed."
	/>
	{@html `<script type="application/ld+json">${jsonLd}<\/script>`}
</svelte:head>

<main>
	<header>
		<p class="eyebrow">Language Quiz</p>
		<h1>Learn German with free interactive quizzes</h1>
		<p class="lede">
			Quick, focused grammar and vocabulary quizzes. Every sentence has audio,
			speaking exercises give instant feedback, and the course follows the CEFR
			levels from A1 to C2 — pass one sub-level to unlock the next.
		</p>
	</header>

	<nav class="quick">
		<a href="/words"><Icon name="words" size="1.05em" /> Word library</a>
		<a href="/settings"><Icon name="settings" size="1.05em" /> Settings</a>
	</nav>

	<section>
		<h2>Courses</h2>
		<ul class="courses">
			{#each featured as course, i (course.id)}
				<li in:rise={{ delay: 80 + i * 60 }}>
					<a href="/course/{course.id}">
						<span class="pair">
							<span class="flags">{course.speakFlag} {course.learnFlag}</span>
							<span class="level">{course.level}</span>
						</span>
						<h3>{course.name}</h3>
						<p>{course.tagline}</p>
						<span class="go">
							Start <Icon name="arrowRight" size="1em" />
						</span>
					</a>
				</li>
			{/each}
		</ul>
	</section>

	<footer>
		<p>Content version {catalog.version} · rendered as static HTML at build time</p>
	</footer>
</main>

<style>
	main {
		max-width: 62rem;
		margin: 0 auto;
		padding: 4rem 1.25rem 5rem;
	}

	header {
		max-width: 44rem;
	}

	h1 {
		margin: 0 0 0.6rem;
	}

	.lede {
		margin: 0;
		font-size: var(--step-1);
		line-height: 1.6;
		color: var(--ink-muted);
	}

	.quick {
		display: flex;
		gap: 0.6rem;
		margin-top: 1.75rem;
	}

	.quick a {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.45rem 1rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--ink);
		font-size: var(--step--1);
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

	h2 {
		margin: 3.25rem 0 1rem;
		font-size: var(--step-1);
	}

	.courses {
		display: grid;
		gap: 1rem;
		grid-template-columns: repeat(auto-fit, minmax(18rem, 1fr));
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.courses a {
		display: flex;
		flex-direction: column;
		height: 100%;
		padding: 1.4rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		transition:
			border-color var(--medium) var(--ease-out),
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.courses a:hover {
		border-color: var(--accent);
		transform: translateY(-3px);
		box-shadow: 0 10px 28px -16px rgba(31, 58, 95, 0.5);
	}

	.pair {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		margin-bottom: 0.6rem;
	}

	.flags {
		font-size: 1.2rem;
		line-height: 1;
		letter-spacing: 0.08em;
	}

	.level {
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.09em;
		padding: 0.15rem 0.5rem;
		border-radius: 999px;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	.courses h3 {
		margin: 0 0 0.35rem;
		font-size: var(--step-1);
	}

	.courses p {
		margin: 0 0 1.1rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	/* Pinned to the bottom of the card so every card's CTA lines up,
	   whatever the length of its tagline. */
	.go {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		margin-top: auto;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent);
	}

	.courses a:hover .go :global(.icon) {
		transform: translateX(3px);
	}

	.go :global(.icon) {
		transition: transform var(--medium) var(--ease-out);
	}

	footer {
		margin-top: 3.5rem;
		padding-top: 1.25rem;
		border-top: 1px solid var(--line);
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
</style>
