<script lang="ts">
	// One thematic page per character, tinted with their accent colour:
	// portrait, bio, dress, speech, reactions, gallery and voice auditions.
	import './bible.css';
	import { img, clip, cast } from './data';
	

	let { id }: { id: string } = $props();
	const c = $derived(cast.find((x) => x.id === id));
</script>

{#if !c}
	<main class="bible">
		<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
		<p>No such character. Known: {cast.map((x) => x.id).join(', ')}.</p>
	</main>
{:else}
	<main class="bible" style:--cast-accent={c.accent} style:--cast-accent-soft={c.accentSoft}>
		<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
		<header class="char-hero">
			<img class="char-portrait" src={img(c.portrait)} alt={c.name} />
			<div class="char-head">
				<p class="eyebrow-accent">{c.group} · {c.lang}</p>
				<h1 class="char-name">{c.name}</h1>
				<p class="char-tagline">{c.tagline}</p>
				<p class="char-bio">{c.bio}</p>
			</div>
		</header>

		<section>
			<h2 class="accented">Look &amp; dress</h2>
			<p class="intro">{c.dress}</p>
		</section>

		<section>
			<h2 class="accented">How they speak</h2>
			<p class="intro">{c.speech}</p>
		</section>

		{#if c.reactions.length}
			<section>
				<h2 class="accented">How they react</h2>
				<dl class="react">
					{#each c.reactions as r (r.when)}
						<dt>{r.when}</dt>
						<dd>{r.what}</dd>
					{/each}
				</dl>
			</section>
		{/if}

		<section>
			<h2 class="accented">Voice</h2>
			<p class="intro">{c.voiceNote}</p>
			{#if c.voices.length}
				<div class="cast-clips">
					{#each c.voices as v (v.id)}
						<span class="clip">
							<span>{v.label}</span>
							<audio controls preload="none" src={clip(v.id)}></audio>
						</span>
					{/each}
				</div>
				<p class="intro" style="margin-top:1rem">
					The full audition trail stays in <code>src/lib/assets/story/voices/</code>
					(<code>tool/gen-voice-refs.mjs</code>).
				</p>
			{/if}
		</section>

		<section>
			<h2 class="accented">Gallery</h2>
			<div class="grid four">
				{#each c.gallery as g (g.id)}
					<figure>
						<img src={img(g.id)} alt={`${c.name} — ${g.label}`} loading="lazy" />
						<figcaption><strong>{g.label}</strong></figcaption>
					</figure>
				{/each}
			</div>
		</section>

		<footer>
			<p>
				Block <code>{'{'}{c.id}{'}'}</code> in <code>assets/images/story_manifest.json</code> —
				edit there, then <code>npm run images -- --story --force &lt;image id&gt;</code>.
			</p>
		</footer>
	</main>
{/if}

<style>
	.char-hero {
		display: grid;
		grid-template-columns: minmax(14rem, 1fr) 2fr;
		gap: 1.75rem;
		align-items: center;
		background: var(--cast-accent-soft);
		border-left: 6px solid var(--cast-accent);
		border-radius: var(--radius);
		overflow: hidden;
	}
	.char-portrait {
		width: 100%;
		height: 100%;
		object-fit: cover;
		display: block;
	}
	.char-head {
		padding: 1.5rem 1.75rem 1.5rem 0;
	}
	.eyebrow-accent {
		font-size: var(--step--1);
		text-transform: uppercase;
		letter-spacing: 0.12em;
		color: var(--cast-accent);
		font-weight: 600;
		margin: 0 0 0.4rem;
	}
	.char-name {
		font-size: var(--step-4);
		margin: 0 0 0.3rem;
		color: var(--heading);
	}
	.char-tagline {
		font-weight: 600;
		margin: 0 0 0.75rem;
	}
	.char-bio {
		margin: 0;
		max-width: 52ch;
		color: var(--ink);
	}
	:global(.bible) h2.accented {
		border-bottom-color: var(--cast-accent);
	}
	.react {
		max-width: var(--measure);
		display: grid;
		grid-template-columns: auto 1fr;
		gap: 0.5rem 1.25rem;
		font-size: var(--step--1);
		margin: 0;
	}
	.react dt {
		font-weight: 600;
		color: var(--heading);
	}
	.react dd {
		margin: 0;
	}
	.cast-clips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.75rem;
	}
	.clip {
		display: grid;
		gap: 0.25rem;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--heading);
	}
	.clip audio {
		width: 15rem;
		max-width: 100%;
	}
	@media (max-width: 44rem) {
		.char-hero {
			grid-template-columns: 1fr;
		}
		.char-head {
			padding: 0 1.25rem 1.5rem;
		}
		.react {
			grid-template-columns: 1fr;
			gap: 0.1rem 0;
		}
		.react dd {
			margin-bottom: 0.6rem;
		}
	}
</style>
