<script lang="ts">
	// Backgrounds & scenarios page: how locations are defined as blocks,
	// lit from the lighting vocabulary and rendered; plus the existing ones.
	import './bible.css';
	import { img, scenarios } from './data';
	
</script>

<main class="bible">
	<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
	<header class="hero">
		<img class="hero-img" src={img('room_ref_wide')} alt="Jonas's room, wide reference" />
		<div class="hero-text">
			<p class="eyebrow">Foundation · applies to every module</p>
			<h1>Backgrounds &amp; Scenarios</h1>
			<p class="lede">
				Locations are reusable blocks, like characters: defined once, lit per scene, rendered in
				the canon style.
			</p>
		</div>
	</header>

	<section>
		<h2>How a location is defined</h2>
		<p class="intro">
			A location block pins what never changes; the scene line and the lighting vocabulary supply
			everything that does. Blocks live in <code>assets/images/story_manifest.json</code> and are
			spliced verbatim into prompts, exactly like character blocks.
		</p>
		<ul class="rules">
			<li><strong>The block pins:</strong> architecture (Altbau ceiling, tall window), wall colour, key furniture with colours, floor. Specific colours matter — "sage-green walls, ink-navy wardrobe", never just "a wardrobe".</li>
			<li><strong>The block never contains lighting.</strong> The same room renders as door shaft, lamp cone, dusk window or torch noir depending on the beat.</li>
			<li><strong>The scene line adds:</strong> camera (wide from the doorway, low close-up), who is present, the one action, and which named light.</li>
			<li><strong>Checklist for a new scenario:</strong> block in the manifest → one wide 16:9 reference (no people) → one detail shot → listed in the episode doc. Only then do story scenes use it.</li>
			<li><strong>Props with German text</strong> (notes, forms, signs) are drawn blank — text is overlaid in HTML.</li>
			<li>Episode-specific locations live in that episode's doc (<code>docs/episodes/</code>); a location used by several episodes gets promoted to the bible.</li>
		</ul>
	</section>

	<section>
		<h2>Existing scenarios</h2>
		<div class="grid two">
			{#each scenarios as s (s.id)}
				<figure>
					<img src={s.src ?? img(s.id)} alt={s.name} loading="lazy" />
					<figcaption>
						<strong>{s.name}</strong>
						<span class="when">{s.episode} · block <code>{s.block}</code></span>
						<span>{s.desc}</span>
					</figcaption>
				</figure>
			{/each}
		</div>
		<p class="intro" style="margin-top:1.25rem">
			Every episode lists its locations in its doc — <code>docs/episodes/ep0_lost_in_berlin.md</code>, <code>docs/episodes/ep1_empty_room.md</code>.
		</p>
	</section>

	<footer>
		<p>One wide shot + one detail per scenario before story scenes use it. Generate: <code>npm run images -- --story &lt;id&gt;</code>.</p>
	</footer>
</main>
