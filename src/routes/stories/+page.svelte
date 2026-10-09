<script lang="ts">
	// Stories: the shelf of Maya's mysteries. The menu's "Stories" lands here,
	// so the learner picks an episode instead of being dropped into one. The
	// list comes from the registry, like the deck's story cards.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { STORY_EPISODES } from '$lib/domain/stories';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const sceneImg = (key: string) => `/${key.replace('story/', 'img/story/')}.webp`;
</script>

<Seo
	title="Stories — Language Quiz"
	description="Maya's Berlin mysteries: playable German stories, one per step of the course. Pick an episode and solve the case with the German you have."
	path="/stories"
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>

	<header>
		<h1>Stories</h1>
		<p class="lede">
			Maya lands in Berlin with no German and a talent for trouble. Each
			episode is a small mystery you solve with the German from the course
			so far: no score, no medal, just the case.
		</p>
	</header>

	<ol class="shelf">
		{#each STORY_EPISODES as ep, i (ep.id)}
			<li>
				<a class="card" href={ep.href}>
					<img src={sceneImg(ep.image)} alt="" loading={i ? 'lazy' : 'eager'} />
					<span class="text">
						<span class="where tnum">Episode {i + 1} · {ep.level}</span>
						<strong>{ep.title}</strong>
						<span class="tag">{ep.tagline}</span>
					</span>
				</a>
			</li>
		{/each}
	</ol>
</main>

<SiteFooter />

<style>
	.shelf {
		list-style: none;
		margin: 1.5rem 0 0;
		padding: 0;
		display: grid;
		gap: 0.9rem;
	}

	.card {
		display: grid;
		grid-template-columns: 9rem 1fr;
		align-items: center;
		gap: 1rem;
		border: 1px solid var(--line);
		border-radius: 1rem;
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		overflow: hidden;
		transition: border-color var(--fast) var(--ease-out);
	}

	.card:hover {
		border-color: var(--line-strong);
	}

	.card img {
		width: 100%;
		aspect-ratio: 1;
		object-fit: cover;
		display: block;
	}

	.text {
		display: grid;
		gap: 0.15rem;
		padding: 0.8rem 1rem 0.8rem 0;
	}

	.where {
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	.text strong {
		font-size: var(--step-1);
		color: var(--heading);
	}

	.tag {
		color: var(--ink-muted);
	}

	@media (max-width: 40rem) {
		.card {
			grid-template-columns: 6rem 1fr;
			gap: 0.7rem;
		}
		.text strong {
			font-size: var(--step-0);
		}
	}
</style>
