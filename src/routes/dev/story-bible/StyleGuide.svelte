<script lang="ts">
	// Style & colour page: the ligne claire canon, colour roles, mood rule
	// and the lighting vocabulary. Applies to every gamified quiz image.
	import './bible.css';
	import { img, palette, lighting } from './data';
	
</script>

<main class="bible">
	<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
	<header class="hero">
		<img class="hero-img" src={img('light_ref_doorshaft')} alt="Door-shaft lighting reference" />
		<div class="hero-text">
			<p class="eyebrow">Foundation · applies to every module</p>
			<h1>Style &amp; Colour</h1>
			<p class="lede">
				Detailed ligne claire, like a Tintin album page. Simplicity reads cold in a mystery —
				detail is warmth, lighting does the storytelling.
			</p>
		</div>
	</header>

	<section>
		<h2>The canon</h2>
		<p class="intro">
			Clean medium-weight ink-navy linework, flat colours, natural adult proportions, simple
			expressive faces — and a high level of loving detail everywhere: furnished rooms, patterned
			wallpaper, parquet floors, corduroy ridges, small everyday props. The live prompt wording is
			the <code>style</code> field of <code>assets/images/story_manifest.json</code>; every image
			prompt is <em>style preamble + verbatim character/location blocks + scene line</em>.
		</p>
		<ul class="rules">
			<li>Blocks are copied <strong>verbatim</strong> into every prompt — edit once in the manifest, then regenerate.</li>
			<li><strong>No model-drawn text.</strong> Props that carry readable German are drawn blank; the text is HTML overlaid on the image.</li>
			<li>Bare hands, no gloves (the model invents them at night). Natural proportions, never chibi — pinned inside every character block.</li>
			<li>Scenes 16:9 · portraits and props 1:1 · output to <code>src/lib/assets/story/</code> (dev-only).</li>
		</ul>
	</section>

	<section>
		<h2>Colour — what each one is for</h2>
		<p class="intro">
			Colour is role-based, not decorative: warmth belongs to the investigation, coolness to the
			unexplored. The mood of every image is <strong>warm-against-cool</strong> — one warm source
			(mustard/amber) against cool blue-grey half-light. Never flat daylight, never full darkness.
		</p>
		<div class="swatches">
			{#each palette as c (c.hex)}
				<div class="swatch">
					<span class="chip" style:background={c.hex}></span>
					<div class="swatch-text">
						<strong>{c.name}</strong> <code>{c.hex}</code>
						<span>{c.role}</span>
					</div>
				</div>
			{/each}
		</div>
	</section>

	<section>
		<h2>Lighting vocabulary — one style, four lights</h2>
		<p class="intro">
			Every scene prompt names its light. Lighting is never part of a location block — the same
			room is lit per scene from this vocabulary.
		</p>
		<div class="grid four">
			{#each lighting as l (l.id)}
				<figure>
					<img src={img(l.id)} alt={l.name} loading="lazy" />
					<figcaption>
						<strong>{l.name}</strong>
						<span class="when">{l.when}</span>
						<span>{l.how}</span>
					</figcaption>
				</figure>
			{/each}
		</div>
	</section>

	<footer>
		<p>Regenerate an image: <code>npm run images -- --story &lt;id&gt;</code> (add <code>--force</code> to re-roll).</p>
	</footer>
</main>

<style>
	.swatches {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(17rem, 1fr));
		gap: 1rem;
	}
	.swatch {
		display: grid;
		grid-template-columns: 3.5rem 1fr;
		gap: 0.9rem;
		align-items: start;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		padding: 0.9rem;
	}
	.chip {
		width: 3.5rem;
		height: 3.5rem;
		border-radius: var(--radius-sm);
		border: 1px solid var(--line-strong);
	}
	.swatch-text {
		display: grid;
		gap: 0.15rem;
		font-size: var(--step--1);
	}
	.swatch-text code {
		color: var(--ink-muted);
		margin-left: 0.35rem;
	}
	.swatch-text span {
		color: var(--ink-muted);
	}
</style>
