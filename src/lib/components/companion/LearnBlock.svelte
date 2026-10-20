<script lang="ts">
	// One teaching block on a companion's left page: a grid of tiles, a
	// word-building table, the backwards-number diagram, pairs, a box.
	// Everything is drawn for paper — rules and outlines rather than fills,
	// so it still reads when printed in black and white.
	import { rich, type LearnBlock } from '$lib/domain/companion';
	import Self from './LearnBlock.svelte';

	let { block }: { block: LearnBlock } = $props();
</script>

{#if block.kind === 'columns'}
	<div class="columns">
		{#each block.blocks as b, i (i)}<div><Self block={b} /></div>{/each}
	</div>
{:else if block.kind === 'tiles'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{block.note}</small>{/if}</h3>
		<ol class="tiles" class:small={block.small} style:--cols={block.cols ?? 6}>
			{#each block.tiles as t (t.big)}
				<li class:mark={t.mark}>
					<span class="big tnum">{t.big}</span>
					<span class="word" lang="de">{@html rich(t.word)}</span>
					{#if t.say}<span class="say">“{t.say}”</span>{/if}
					{#if t.swatch}<span class="swatch" style:background={t.swatch}></span>{/if}
				</li>
			{/each}
		</ol>
	</section>
{:else if block.kind === 'build'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{block.note}</small>{/if}</h3>
		<table class="build">
			<tbody>
				{#each block.rows as row (row.result)}
					<tr>
						<td class="parts" lang="de">
							{#each row.parts as p, i (i)}<span class="part {p.role ?? ''}">{p.text}</span>{/each}
						</td>
						<td class="eq">=</td>
						<td class="result" lang="de">{row.result}</td>
						<td class="en tnum">{row.en}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</section>
{:else if block.kind === 'flip'}
	<section class="block flip">
		<h3>{block.title}</h3>
		<div class="flip-body">
			<svg viewBox="0 0 300 150" role="img" aria-label="{block.number}: {block.unit} und {block.ten}">
				<defs>
					<marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto-start-reverse">
						<path d="M0 0 10 5 0 10z" fill="currentColor" />
					</marker>
				</defs>
				<g class="digits">
					<rect x="104" y="4" width="42" height="46" rx="5" />
					<rect x="154" y="4" width="42" height="46" rx="5" class="first" />
					<text x="125" y="40">{block.number[0]}</text>
					<text x="175" y="40" class="first">{block.number[1]}</text>
				</g>
				<path class="arrow first" d="M175 52 C 170 78, 90 72, 62 92" marker-end="url(#arrow)" />
				<path class="arrow" d="M125 52 C 132 78, 212 72, 240 92" marker-end="url(#arrow)" />
				<g class="words">
					<rect x="18" y="96" width="88" height="28" rx="4" class="first" />
					<rect x="122" y="96" width="56" height="28" rx="4" class="joint" />
					<rect x="194" y="96" width="92" height="28" rx="4" />
					<text x="62" y="115" class="first">{block.unit}</text>
					<text x="150" y="115">und</text>
					<text x="240" y="115">{block.ten}</text>
				</g>
				<text class="sum" x="150" y="145">= {block.unit}und{block.ten}</text>
			</svg>
			<div>
				<p>{@html rich(block.text)}</p>
				<ul class="flip-ex">
					{#each block.examples as ex (ex.n)}
						<li><b class="tnum">{ex.n}</b> <span lang="de">{@html rich(ex.de)}</span>{#if ex.note}<small>{ex.note}</small>{/if}</li>
					{/each}
				</ul>
			</div>
		</div>
	</section>
{:else if block.kind === 'pairs'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<dl class="pairs">
			{#each block.rows as row (row.a)}
				<dt class="tnum">{row.a}</dt>
				<dd lang="de">{@html rich(row.b)}</dd>
			{/each}
		</dl>
	</section>
{:else if block.kind === 'table'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<table class="phrases">
			<thead>
				<tr>{#each block.head as h, i (i)}<th class:en={h.en}>{h.text}</th>{/each}</tr>
			</thead>
			<tbody>
				{#each block.rows as row, r (r)}
					<tr>
						{#each row as cell, i (i)}
							<td class:en={block.head[i]?.en} lang={block.head[i]?.en ? 'en' : 'de'}>{@html rich(cell)}</td>
						{/each}
					</tr>
				{/each}
			</tbody>
		</table>
	</section>
{:else if block.kind === 'words'}
	<section class="block">
		<h3>{block.title}</h3>
		<dl class="words" style:--cols={block.cols ?? 3}>
			{#each block.items as w (w.de)}
				<div><dt lang="de">{w.de}</dt><dd>{w.en}</dd></div>
			{/each}
		</dl>
	</section>
{:else if block.kind === 'tree'}
	{@const P = block.people}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<svg class="tree" viewBox="0 0 300 178" role="img" aria-label={block.title}>
			<path class="link" d="M140 24h20 M150 40v20 M150 60h100 M150 60v18 M250 60v18 M100 94h10 M105 94v34 M50 128h160 M50 128v12 M130 128v12 M210 128v12" />
			{#each [['opa', 110, 8], ['oma', 190, 8], ['vater', 60, 78], ['mutter', 150, 78], ['tante', 250, 78], ['bruder', 50, 140], ['ich', 130, 140], ['schwester', 210, 140]] as [role, x, y] (role)}
				{@const person = P[role as keyof typeof P]}
				<g class="person" class:me={role === 'ich'}>
					<rect x={(x as number) - 38} y={y} width="76" height="34" rx="4" />
					<text x={x} y={(y as number) + 14} class="name">{person.name}</text>
					<text x={x} y={(y as number) + 27} class="role" lang="de">{person.word}</text>
				</g>
			{/each}
		</svg>
	</section>
{:else if block.kind === 'box'}
	<aside class="box {block.tone}" class:has-image={block.image}>
		<p class="label">{block.tone === 'watch' ? 'Watch out' : block.tone === 'culture' ? 'In Germany' : 'Tip'}</p>
		<h4>{block.title}</h4>
		<p>{@html rich(block.text)}</p>
		{#if block.image}<img src="/img/{block.image}.webp" alt="" width="1024" height="1024" />{/if}
	</aside>
{/if}

<style>
	.columns {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 7mm;
		align-items: start;
	}

	.block {
		break-inside: avoid;
	}

	h3 {
		display: flex;
		flex-wrap: wrap;
		align-items: baseline;
		gap: 0 2.5mm;
		margin: 0 0 2mm;
		padding-bottom: 1mm;
		border-bottom: 0.3mm solid var(--navy);
		font-family: var(--serif);
		font-size: 12.5pt;
		font-weight: 700;
		color: var(--navy);
	}

	h3 small {
		font-family: var(--sans);
		font-size: 8pt;
		font-weight: 500;
		color: var(--muted);
	}

	/* -- tiles --------------------------------------------------------------- */

	.tiles {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 1.6mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.tiles li {
		display: grid;
		justify-items: center;
		padding: 1mm 0.5mm 1.2mm;
		border: 0.3mm solid var(--rule);
		border-radius: 1.6mm;
	}

	.tiles.small .big {
		font-size: 13pt;
	}

	.tiles.small .word {
		font-size: 8pt;
	}

	.swatch {
		width: 70%;
		height: 3mm;
		margin-top: 0.8mm;
		border: 0.25mm solid var(--ink);
		border-radius: 0.6mm;
	}

		.tiles li.mark {
		border: 0.45mm solid var(--accent);
	}

	.big {
		font-family: var(--serif);
		font-size: 19pt;
		font-weight: 700;
		line-height: 1;
		color: var(--navy);
	}

	.word {
		margin-top: 0.8mm;
		font-size: 8.8pt;
		font-weight: 700;
	}

	.say {
		white-space: nowrap;
		font-size: 6.5pt;
		font-style: italic;
		color: var(--muted);
	}

	/* -- build --------------------------------------------------------------- */

	.build {
		border-collapse: collapse;
		font-size: 10pt;
	}

	.build td {
		padding: 0.9mm 1.5mm 0.9mm 0;
	}

	.part {
		display: inline-block;
		padding: 0.4mm 1.4mm;
		border: 0.3mm solid var(--navy);
		border-radius: 1mm;
		font-weight: 600;
	}

	.part + .part {
		margin-left: 0.8mm;
	}

	.part.suffix {
		border-color: var(--mustard);
		background: var(--mustard-tint);
	}

	.part.joint {
		border-style: dashed;
	}

	.part.cut {
		border: 0;
		padding: 0.4mm 0;
		color: var(--accent);
		text-decoration: line-through 0.4mm;
	}

	.eq {
		color: var(--muted);
	}

	.result {
		font-weight: 800;
		color: var(--navy);
	}

	.en {
		color: var(--muted);
		font-size: 9pt;
	}

	/* -- flip ---------------------------------------------------------------- */

	.flip-body {
		display: grid;
		grid-template-columns: 62mm 1fr;
		gap: 6mm;
		align-items: center;
	}

	svg {
		width: 100%;
		height: auto;
		color: var(--navy);
	}

	svg rect {
		fill: #fff;
		stroke: var(--navy);
		stroke-width: 1.4;
	}

	svg rect.first {
		stroke: var(--accent);
		stroke-width: 2.2;
	}

	svg rect.joint {
		stroke-dasharray: 4 3;
	}

	svg text {
		font-family: var(--sans);
		font-size: 15px;
		font-weight: 700;
		text-anchor: middle;
		fill: var(--ink);
	}

	.digits text {
		font-family: var(--serif);
		font-size: 34px;
		fill: var(--navy);
	}

	svg text.first {
		fill: var(--accent);
	}

	.arrow {
		fill: none;
		stroke: currentColor;
		stroke-width: 1.6;
	}

	.arrow.first {
		color: var(--accent);
		stroke-width: 2.2;
	}

	.sum {
		font-size: 14px;
		fill: var(--navy);
	}

	.flip p {
		margin: 0;
		font-size: 9.5pt;
		line-height: 1.45;
	}

	.flip-ex {
		margin: 2mm 0 0;
		padding: 0;
		list-style: none;
		font-size: 10pt;
	}

	.flip-ex li {
		padding: 0.6mm 0;
	}

	.flip-ex b {
		display: inline-block;
		width: 7mm;
		color: var(--navy);
	}

	.flip-ex small {
		margin-left: 2mm;
		font-size: 8pt;
		color: var(--muted);
	}

	/* -- pairs --------------------------------------------------------------- */

	.pairs {
		display: grid;
		grid-template-columns: auto 1fr;
		gap: 0.6mm 3.5mm;
		margin: 0;
		font-size: 10pt;
	}

	.pairs dt {
		font-weight: 800;
		color: var(--navy);
		text-align: right;
	}

	.pairs dd {
		margin: 0;
	}

	/* -- phrase table -------------------------------------------------------- */

	.phrases {
		width: 100%;
		border-collapse: collapse;
		font-size: 9.5pt;
	}

	.phrases th {
		padding: 0 2mm 1mm 0;
		font-size: 7.5pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-align: left;
		text-transform: uppercase;
		color: var(--accent);
	}

	.phrases td {
		padding: 1.1mm 2mm 1.1mm 0;
		border-top: 0.2mm solid var(--rule);
		font-weight: 600;
		vertical-align: top;
	}

	.phrases .en {
		font-weight: 400;
		color: var(--muted);
	}

	/* -- family tree --------------------------------------------------------- */

	.tree {
		display: block;
		width: 100%;
		max-width: 125mm;
		margin: 0 auto;
	}

	.tree .link {
		fill: none;
		stroke: var(--navy);
		stroke-width: 1.2;
	}

	.person rect {
		fill: #fff;
		stroke: var(--navy);
		stroke-width: 1.2;
	}

	.person.me rect {
		stroke: var(--accent);
		stroke-width: 2.2;
	}

	.person text {
		font-family: var(--sans);
		text-anchor: middle;
		fill: var(--ink);
	}

	.person .name {
		font-size: 11px;
		font-weight: 800;
	}

	.person .role {
		font-size: 8.5px;
		fill: var(--muted);
	}

		/* -- words --------------------------------------------------------------- */

	.words {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 0.4mm 6mm;
		margin: 0;
		font-size: 9pt;
	}

	.words div {
		display: flex;
		flex-wrap: wrap;
		gap: 0 1.6mm;
		padding: 0.5mm 0;
		border-bottom: 0.2mm dotted var(--rule);
	}

	.words dt {
		font-weight: 700;
	}

	.words dd {
		margin: 0;
		color: var(--muted);
	}

	/* -- boxes --------------------------------------------------------------- */

	.box {
		position: relative;
		padding: 2.6mm 3.5mm 3mm 4mm;
		border-left: 1.2mm solid var(--tone);
		background: var(--tone-tint);
		break-inside: avoid;
	}

	.box.watch {
		--tone: var(--accent);
		--tone-tint: var(--accent-tint);
	}

	.box.culture {
		--tone: var(--sage);
		--tone-tint: var(--sage-tint);
	}

	.box.tip {
		--tone: var(--mustard);
		--tone-tint: var(--mustard-tint);
	}

	.box.has-image {
		padding-right: 26mm;
	}

	.label {
		margin: 0;
		font-size: 7pt;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--tone);
	}

	h4 {
		margin: 0.4mm 0 1mm;
		font-family: var(--serif);
		font-size: 11pt;
		color: var(--navy);
	}

	.box p:not(.label) {
		margin: 0;
		font-size: 9pt;
		line-height: 1.45;
	}

	.box img {
		position: absolute;
		right: 2mm;
		top: 50%;
		width: 23mm;
		height: auto;
		transform: translateY(-50%);
	}

	:global(.companion em.focus) {
		font-style: normal;
		color: var(--accent);
		text-decoration: underline 0.3mm;
		text-underline-offset: 0.6mm;
	}
</style>
