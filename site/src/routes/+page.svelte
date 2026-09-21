<script lang="ts">
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

	<section>
		<h2>Courses</h2>
		<ul class="courses">
			{#each featured as course (course.id)}
				<li>
					<a href="/course/{course.id}">
						<span class="pair">
							{course.speakFlag} → {course.learnFlag} · {course.level}
						</span>
						<h3>{course.name}</h3>
						<p>{course.tagline}</p>
					</a>
				</li>
			{/each}
		</ul>
	</section>

	<footer>
		<p>
			Content version {catalog.version} · rendered as static HTML at build time
		</p>
	</footer>
</main>

<style>
	:global(body) {
		margin: 0;
		background: #fffdf9;
		color: #2a2a28;
		font:
			16px/1.55 'Inter',
			-apple-system,
			'Segoe UI',
			Roboto,
			sans-serif;
	}

	main {
		max-width: 62rem;
		margin: 0 auto;
		padding: 3rem 1.25rem 4rem;
	}

	.eyebrow {
		margin: 0 0 0.5rem;
		font-size: 0.8rem;
		font-weight: 700;
		letter-spacing: 0.12em;
		text-transform: uppercase;
		color: #c9683b;
	}

	h1 {
		margin: 0 0 0.75rem;
		font-size: clamp(2rem, 5vw, 3rem);
		line-height: 1.15;
		color: #1f3a5f;
	}

	.lede {
		margin: 0;
		max-width: 44rem;
		font-size: 1.1rem;
		color: #4a4a46;
	}

	h2 {
		margin: 3rem 0 1rem;
		font-size: 1.35rem;
		color: #1f3a5f;
	}

	.courses {
		display: grid;
		gap: 1rem;
		grid-template-columns: repeat(auto-fit, minmax(17rem, 1fr));
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.courses a {
		display: block;
		height: 100%;
		padding: 1.25rem;
		border: 1px solid #e6dfd2;
		border-radius: 14px;
		background: #fff;
		color: inherit;
		text-decoration: none;
		transition:
			border-color 0.15s,
			transform 0.15s;
	}

	.courses a:hover {
		border-color: #c9683b;
		transform: translateY(-2px);
	}

	.pair {
		font-size: 0.8rem;
		font-weight: 700;
		color: #6b6b64;
	}

	.courses h3 {
		margin: 0.5rem 0 0.35rem;
		font-size: 1.1rem;
		color: #1f3a5f;
	}

	.courses p {
		margin: 0;
		color: #55554e;
	}

	footer {
		margin-top: 3rem;
		font-size: 0.85rem;
		color: #8a8a82;
	}
</style>
