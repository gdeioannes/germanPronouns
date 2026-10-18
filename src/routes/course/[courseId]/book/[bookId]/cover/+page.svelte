<script lang="ts">
	// The cover as one sheet: back on the left, spine, front on the right, with
	// bleed all round. The hero scene runs across the front; the back carries
	// the blurb, the can-do list and the barcode area KDP prints over.
	let { data } = $props();
	const b = $derived(data.book);
	const pageStyle = $derived(`<style>@page { size: ${data.width}mm ${data.height}mm; margin: 0; }</style>`);
</script>

<svelte:head>
	<title>{b.title} · cover</title>
	<meta name="robots" content="noindex" />
	{@html pageStyle}
</svelte:head>

<div class="wrap" style="--w:{data.width}mm;--h:{data.height}mm;--spine:{data.spine}mm;--bleed:{data.bleed}mm">
	<section class="back">
		<div class="back-inner">
			<p class="kicker">{b.courseName}</p>
			<h2>Two levels, one book, and the app one scan away.</h2>
			<p class="blurb">{b.title} takes you through {b.parts.map((p) => p.level).join(' and ')} the way the course does on screen: the idea in one line, the rules with their examples and diagrams, the words with their articles, a quick check, and then the practice. Listening, dictation and speaking live in the app; every unit carries a code that opens exactly the recording or the exercise you need.</p>
			<ul class="cando">
				{#each b.parts as part (part.level)}
					<li><b>{part.level} · {part.title}</b><ul>{#each part.canDo.slice(0, 3) as c, i (i)}<li>{c}</li>{/each}</ul></li>
				{/each}
			</ul>
			<div class="site">
				<img class="mark" src="/icons/Icon-192.png" alt="" width="192" height="192" />
				<span><b>languagequiz.org</b><br />The free course this book is part of: every exercise, every recording, the speaking tutor.</span>
			</div>
			<div class="barcode">{#if data.barcode}{@html data.barcode}{/if}</div>
		</div>
	</section>
	<section class="spine">
		<span class="spine-text">{b.title} · {b.subtitle}</span>
	</section>
	<section class="front">
		{#if b.cover}<img class="hero" src="/img/{b.cover}.webp" alt="" />{/if}
		<div class="front-text">
			<p class="brand top"><img class="mark" src="/icons/Icon-192.png" alt="" width="192" height="192" /> languagequiz.org</p>
			<p class="kicker">{b.courseName}</p>
			<h1>{b.title}</h1>
			<p class="sub">{b.subtitle}</p>
			<p class="line">The complete workbook · lessons, exercises, audio by QR</p>
		</div>
	</section>
</div>

<style>
	:global(body) {
		margin: 0;
		background: #ddd;
	}
	.wrap {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', serif;
		--navy: #1f3a5f;
		--accent: #c9683b;
		--cream: #fbf5e4;
		width: var(--w);
		height: var(--h);
		display: grid;
		grid-template-columns: 1fr var(--spine) 1fr;
		background: var(--cream);
		color: var(--navy);
		font-family: Inter, system-ui, sans-serif;
		overflow: hidden;
	}
	.back,
	.front {
		position: relative;
		padding: calc(var(--bleed) + 18mm);
		box-sizing: border-box;
	}
	.back {
		background: var(--navy);
		color: #fff;
	}
	.back-inner {
		display: grid;
		align-content: start;
		gap: 6mm;
		height: 100%;
	}
	.kicker {
		margin: 0;
		font-size: 9pt;
		font-weight: 800;
		letter-spacing: 0.12em;
		text-transform: uppercase;
		opacity: 0.8;
	}
	.back h2 {
		margin: 0;
		font-family: var(--serif);
		font-size: 24pt;
		line-height: 1.15;
		color: #fff;
	}
	.blurb {
		margin: 0;
		font-size: 10.5pt;
		line-height: 1.55;
		opacity: 0.92;
	}
	.cando {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 3mm;
		font-size: 9.5pt;
	}
	.cando ul {
		margin: 1mm 0 0;
		padding-left: 4mm;
		opacity: 0.85;
	}
	.site {
		display: flex;
		align-items: center;
		gap: 4mm;
		font-size: 9.5pt;
		line-height: 1.45;
		opacity: 0.92;
	}
	.mark {
		width: 12mm;
		height: 12mm;
		border-radius: 2.5mm;
		flex: none;
	}
	.brand.top {
		display: flex;
		align-items: center;
		gap: 4mm;
		margin: 0 0 14mm;
		font-size: 20pt;
		font-weight: 800;
		letter-spacing: 0.01em;
		color: var(--navy);
	}
	.brand.top .mark {
		width: 16mm;
		height: 16mm;
		border-radius: 3.5mm;
	}
	.barcode {
		position: absolute;
		right: calc(var(--bleed) + 10mm);
		bottom: calc(var(--bleed) + 10mm);
		width: 50.8mm;
		height: 30.5mm;
		background: #fff;
		display: grid;
		place-items: center;
	}
	.barcode :global(svg) {
		width: 33mm;
		height: auto;
	}
	.spine {
		background: var(--accent);
		display: grid;
		place-items: center;
		overflow: hidden;
	}
	.spine-text {
		writing-mode: vertical-rl;
		transform: rotate(180deg);
		color: #fff;
		font-family: var(--serif);
		font-weight: 700;
		font-size: 11pt;
		white-space: nowrap;
	}
	.front .hero {
		position: absolute;
		left: 0;
		right: 0;
		bottom: 0;
		width: 100%;
		height: 58%;
		object-fit: contain;
		object-position: center bottom;
		padding: 0 10mm 20mm;
		box-sizing: border-box;
	}
	.front-text {
		position: relative;
	}
	.front h1 {
		margin: 4mm 0 2mm;
		font-family: var(--serif);
		font-size: 92pt;
		line-height: 0.95;
		color: var(--accent);
	}
	.front .sub {
		margin: 0;
		font-family: var(--serif);
		font-size: 24pt;
		color: var(--navy);
	}
	.front .line {
		margin: 6mm 0 0;
		font-size: 11pt;
		font-weight: 600;
		color: #6e6458;
	}
</style>
