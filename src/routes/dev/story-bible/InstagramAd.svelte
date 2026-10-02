<script lang="ts">
	// The story-mode Instagram ad: the finished carousel, the idea behind each
	// slide, and the regeneration recipe. Files: assets/images/promo/instagram/
	// (committed JPGs + kept raw art); generator: tool/gen-promo-ig.mjs.
	import './bible.css';

	const ads = import.meta.glob('/assets/images/promo/instagram/*.jpg', {
		eager: true,
		query: '?url',
		import: 'default'
	}) as Record<string, string>;
	const ad = (id: string) => ads[`/assets/images/promo/instagram/${id}.jpg`];

	const slides = [
		{
			id: 'promo_ig_3_invite',
			title: '1 · Spielst du mit?',
			idea: 'The invite. Maya looks straight at you and hands you the torn note — you are the assistant she is recruiting. The A1.1 requirement is framed as reassurance ("a little German is all you need"), never as a gate.'
		},
		{
			id: 'promo_ig_b_mystery',
			title: '2 · Jonas ist weg.',
			idea: 'The premise. The evidence of Episode 1 laid out on the desk — torn note, locked phone, map, string — selling the mystery itself: your flatmate vanished overnight, follow the clues.'
		},
		{
			id: 'promo_ig_c_learn',
			title: '3 · Spiel. Und lerne.',
			idea: 'The payoff. Over Maya’s shoulder at the case board: every clue is a tiny German exercise — read, listen, type — and the CTA to play Episode 1 free on languagequiz.org.'
		}
	];
</script>

<main class="bible">
	<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
	<header class="hero">
		<img class="hero-img" src={ad('promo_ig_3_invite')} alt="Spielst du mit? ad slide" />
		<div class="hero-text">
			<p class="eyebrow">Marketing · Episode 1</p>
			<h1>Instagram Ad</h1>
			<p class="lede">
				A three-slide square carousel (1080×1080) promoting story mode: an invitation to play and
				practise a little German, in the canon ligne claire style and palette.
			</p>
		</div>
	</header>

	<section>
		<h2>The carousel</h2>
		<div class="grid two">
			{#each slides as s (s.id)}
				<figure>
					<img src={ad(s.id)} alt={s.title} loading="lazy" />
					<figcaption>
						<strong>{s.title}</strong>
						<span>{s.idea}</span>
					</figcaption>
				</figure>
			{/each}
		</div>
	</section>

	<section>
		<h2>How it's made (and remade)</h2>
		<ul class="rules">
			<li>
				<strong>Art:</strong> Gemini, prompted with the story manifest's style preamble and
				<code>{'{maya}'}</code>/<code>{'{room}'}</code> blocks, plus three existing story webps as
				strict style and character references. Square composition with the lower half carrying the
				subject and the upper 45% left calm for the caption.
			</li>
			<li>
				<strong>Text:</strong> never drawn by the model — stamped afterwards as an SVG overlay
				(Source Serif 4 display over Inter, brand navy/mustard/terracotta) over a top-down navy
				gradient.
			</li>
			<li>
				<strong>Regenerate:</strong> <code>node tool/gen-promo-ig.mjs</code> re-stamps captions from
				the kept <code>*_raw.png</code> art with no API calls; add an id and
				<code>--force</code> to redraw one slide's art. Files land in
				<code>assets/images/promo/instagram/</code>.
			</li>
		</ul>
	</section>
</main>
