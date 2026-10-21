<script lang="ts">
	// One teaching block on a companion's left page: a grid of tiles, a
	// word-building table, the backwards-number diagram, pairs, a box.
	// Everything is drawn for paper — rules and outlines rather than fills,
	// so it still reads when printed in black and white.
	import { rich, type FlowNode, type LearnBlock } from '$lib/domain/companion';
	import ClockFace from './ClockFace.svelte';
	import Self from './LearnBlock.svelte';

	let { block }: { block: LearnBlock } = $props();

	/** der/die/das/plural heads → their gender colour class, for tables flagged `genders`. */
	const GENDER: Record<string, string> = { der: 'g-m', die: 'g-f', das: 'g-n', plural: 'g-p' };

	// Clock geometry, in a 100 × 100 box centred on 50,50. Angles in minutes
	// round the face (0 = twelve o'clock, 15 = three).
	const at = (minute: number, r: number) => {
		const a = (minute / 60) * 2 * Math.PI;
		return `${(50 + r * Math.sin(a)).toFixed(2)} ${(50 - r * Math.cos(a)).toFixed(2)}`;
	};
	const arc = (from: number, to: number, r: number) => `M${at(from, r)} A${r} ${r} 0 ${to - from > 30 ? 1 : 0} 1 ${at(to, r)}`;
</script>

{#snippet flowNode(n: FlowNode)}
	{#if 'q' in n}
		<div class="fl-q">
			<p class="fl-ask">{@html rich(n.q)}</p>
			<div class="fl-branches">
				<div class="fl-branch"><span class="fl-yn">yes</span>{@render flowNode(n.yes)}</div>
				<div class="fl-branch"><span class="fl-yn">no</span>{@render flowNode(n.no)}</div>
			</div>
		</div>
	{:else}
		<div class="fl-a">
			<b lang="de">{@html rich(n.answer)}</b>
			{#if n.example}<small lang="de">{@html rich(n.example)}</small>{/if}
		</div>
	{/if}
{/snippet}

{#if block.kind === 'columns'}
	<div class="columns">
		{#each block.blocks as b, i (i)}<div><Self block={b} /></div>{/each}
	</div>
{:else if block.kind === 'tiles'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
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
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
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
				<tr>
					{#each block.head as h, i (i)}<th class:en={h.en} class={block.genders ? GENDER[h.text.toLowerCase()] : undefined}>{h.text}</th>{/each}
				</tr>
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
{:else if block.kind === 'slots'}
	{@const width = Math.max(...block.rows.map((r) => r.cells.length), block.head?.length ?? 0)}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<div class="slots" style:--places={width}>
			{#if block.head}
				{#each block.head as h, i (i)}<span class="slot-head" class:hot={block.hot?.includes(i)}>{h}</span>{/each}
				<span></span>
			{/if}
			{#each block.rows as row, r (r)}
				{#each { length: width } as _, i (i)}
					{@const cell = row.cells[i]}
					{#if cell?.de}
						<span class="slot" class:hot={cell.hot || block.hot?.includes(i)}>
							<span lang="de">{@html rich(cell.de)}</span>
							{#if cell.tag}<small>{cell.tag}</small>{/if}
						</span>
					{:else}
						<span></span>
					{/if}
				{/each}
				<span class="slot-en">{row.en ?? ''}</span>
			{/each}
		</div>
	</section>
{:else if block.kind === 'flow'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<div class="flow">{@render flowNode(block.root)}</div>
	</section>
{:else if block.kind === 'merge'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<div class="merges">
			{#each block.rows as row, r (r)}
				<div class="merge">
					<span class="mg-label">{block.labels[0]}</span>
					<span class="mg-in" lang="de">{@html rich(row.a)}</span>
					<span class="mg-to">→</span>
					<span class="mg-piece" lang="de">{@html rich(row.aTo)}</span>
					<span class="mg-join" aria-hidden="true"></span>
					<span class="mg-result" lang="de">{@html rich(row.result)}{#if row.en}<small>{row.en}</small>{/if}</span>
					<span class="mg-label">{block.labels[1]}</span>
					<span class="mg-in" lang="de">{@html rich(row.b)}</span>
					<span class="mg-to">→</span>
					<span class="mg-piece suffix" lang="de">{@html rich(row.bTo)}</span>
				</div>
			{/each}
		</div>
	</section>
{:else if block.kind === 'arrow'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<div class="arrows">
			{#if block.ask}
				<span class="ar-ask" lang="de">{block.ask[0]}</span><span></span><span class="ar-ask" lang="de">{block.ask[1]}</span><span></span>
			{/if}
			{#each block.rows as row, r (r)}
				<span class="ar-end" lang="de">{@html rich(row.who)}</span>
				<span class="ar-line" lang="de">{@html rich(row.verb)}</span>
				<span class="ar-end to" lang="de">{@html rich(row.whom)}</span>
				<span class="ar-en">{row.en ?? ''}</span>
			{/each}
		</div>
	</section>
{:else if block.kind === 'clock'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<div class="clock-row" class:with-dial={block.dial}>
			{#if block.dial}
				<svg class="dial" viewBox="-26 -14 152 128" role="img" aria-label="nach on the right, vor on the left, halb at the bottom">
					<circle cx="50" cy="50" r="40" class="face" />
					<path d={arc(1, 20, 45)} class="zone nach" />
					<path d={arc(40, 59, 45)} class="zone vor" />
					{#each { length: 12 } as _, i (i)}<path d="M{at(i * 5, 40)} L{at(i * 5, i % 3 ? 36 : 33)}" class="tick" />{/each}
					<circle cx="50" cy="90" r="3.4" class="halb-dot" />
					<text x="50" y="-4" class="zone-label">… Uhr</text>
					<text x="112" y="24" class="zone-label nach">nach</text>
					<text x="-12" y="24" class="zone-label vor">vor</text>
					<text x="50" y="108" class="zone-label halb">halb</text>
					<text x="69" y="49" class="dial-small">Viertel</text>
					<text x="69" y="57" class="dial-small">nach</text>
					<text x="31" y="49" class="dial-small">Viertel</text>
					<text x="31" y="57" class="dial-small">vor</text>
				</svg>
			{/if}
			<ol class="clocks" style:--cols={block.cols ?? 4}>
				{#each block.clocks as c (c.time + c.de)}
					<li>
						<span class="face-box"><ClockFace time={c.time} mark={c.mark} /></span>
						<span class="digits tnum">{c.time}</span>
						<span class="clock-de" lang="de">{@html rich(c.de)}</span>
					</li>
				{/each}
			</ol>
		</div>
	</section>
{:else if block.kind === 'pictures'}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<ol class="pictures" style:--cols={block.cols ?? 6}>
			{#each block.items as item (item.image)}
				<li>
					<img src="/img/{item.image}.webp" alt="" width="1024" height="1024" />
					<b lang="de">{@html rich(item.de)}</b>
					{#if item.en}<small>{item.en}</small>{/if}
				</li>
			{/each}
		</ol>
	</section>
{:else if block.kind === 'timeline'}
	{@const x = (v: number) => 100 + v * 22}
	<section class="block">
		<h3>{block.title}{#if block.note}<small>{@html rich(block.note)}</small>{/if}</h3>
		<div class="timeline">
			<span></span>
			<svg viewBox="0 0 200 10" class="tl-axis" role="img" aria-label="past on the left, now in the middle, future on the right">
				<text x="8" y="7" class="tl-end" text-anchor="start">← before</text>
				<text x="100" y="7" class="tl-now">jetzt</text>
				<text x="192" y="7" class="tl-end" text-anchor="end">later →</text>
			</svg>
			{#each block.marks as m, i (i)}
				<span class="tl-label"><b lang="de">{@html rich(m.de)}</b>{#if m.en}<small>{m.en}</small>{/if}</span>
				<svg viewBox="0 0 200 10" role="img" aria-label={m.en ?? m.de}>
					<line x1="8" y1="5" x2="192" y2="5" class="tl-line" />
					<line x1="100" y1="0" x2="100" y2="10" class="tl-nowline" />
					{#if m.at !== undefined}
						<circle cx={x(m.at)} cy="5" r="3" class="tl-dot" />
					{:else if m.from !== undefined && m.to !== undefined}
						<line x1={x(m.from)} y1="5" x2={x(m.to)} y2="5" class="tl-bar" />
					{/if}
				</svg>
			{/each}
		</div>
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

	.build .parts {
		white-space: nowrap;
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

	/* Gender colours, as in the app: a bar over the head and the word in colour.
	   The article word itself stays, so it reads in black and white too. */
	.phrases th.g-m {
		--g: #2e6fb7;
	}

	.phrases th.g-f {
		--g: #c0446a;
	}

	.phrases th.g-n {
		--g: #3f7d4e;
	}

	.phrases th.g-p {
		--g: var(--muted);
	}

	.phrases th[class*='g-'] {
		border-top: 1.2mm solid var(--g);
		padding-top: 1mm;
		color: var(--g);
	}

	/* -- decision tree ------------------------------------------------------- */

	.flow {
		display: flex;
		justify-content: center;
		font-size: 8.5pt;
	}

	.fl-q {
		display: grid;
		justify-items: center;
		width: 100%;
	}

	.fl-ask {
		margin: 0;
		padding: 1mm 2.2mm;
		border: 0.3mm solid var(--navy);
		border-radius: 1mm;
		font-weight: 600;
		line-height: 1.3;
		text-align: center;
	}

	.fl-branches {
		position: relative;
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 3mm;
		width: 100%;
		margin-top: 1.6mm;
	}

	.fl-branches::before {
		content: '';
		position: absolute;
		top: -1.6mm;
		left: 50%;
		height: 1.6mm;
		border-left: 0.3mm solid var(--navy);
	}

	.fl-branch {
		position: relative;
		display: grid;
		justify-items: center;
		align-content: start;
		padding-top: 4.5mm;
	}

	.fl-branch::before {
		content: '';
		position: absolute;
		top: 0;
		left: 50%;
		height: 4.5mm;
		border-left: 0.3mm solid var(--navy);
	}

	.fl-branch::after {
		content: '';
		position: absolute;
		top: 0;
		border-top: 0.3mm solid var(--navy);
	}

	.fl-branch:first-child::after {
		left: 50%;
		right: -1.5mm;
	}

	.fl-branch:last-child::after {
		left: -1.5mm;
		right: 50%;
	}

	.fl-yn {
		position: absolute;
		top: 0.7mm;
		left: calc(50% + 1mm);
		font-size: 6.5pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent);
	}

	.fl-a {
		display: grid;
		justify-items: center;
		padding: 0.8mm 2.5mm 1mm;
		border: 0.5mm solid var(--accent);
		border-radius: 1mm;
		text-align: center;
	}

	.fl-a b {
		font-family: var(--serif);
		font-size: 12pt;
		color: var(--navy);
	}

	.fl-a small {
		font-size: 7.5pt;
		color: var(--muted);
	}

	/* -- two inputs, one word ------------------------------------------------ */

	.merges {
		display: grid;
		gap: 2.4mm;
	}

	.merge {
		display: grid;
		grid-template-columns: auto auto auto auto 4mm 1fr;
		grid-template-rows: auto auto;
		gap: 0.8mm 1.6mm;
		align-items: center;
		font-size: 9.5pt;
	}

	.mg-label {
		font-size: 6.5pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--muted);
	}

	.mg-in {
		font-weight: 600;
	}

	.mg-to {
		color: var(--muted);
	}

	.mg-piece {
		justify-self: start;
		padding: 0.3mm 1.6mm;
		border: 0.3mm solid var(--navy);
		border-radius: 1mm;
		font-weight: 700;
	}

	.mg-piece.suffix {
		border-color: var(--mustard);
		background: var(--mustard-tint);
	}

	/* The bracket that joins the two pieces, pointing at the result. */
	.mg-join {
		grid-row: 1 / 3;
		grid-column: 5;
		align-self: stretch;
		margin: 1.4mm 0;
		border: 0.3mm solid var(--navy);
		border-left: 0;
		border-radius: 0 1.2mm 1.2mm 0;
	}

	.mg-result {
		grid-row: 1 / 3;
		grid-column: 6;
		display: grid;
		font-family: var(--serif);
		font-size: 13pt;
		font-weight: 700;
		color: var(--navy);
	}

	.mg-result small {
		font-family: var(--sans);
		font-size: 7.5pt;
		font-weight: 400;
		color: var(--muted);
	}

	/* -- action arrow -------------------------------------------------------- */

	.arrows {
		display: grid;
		grid-template-columns: auto minmax(18mm, auto) auto 1fr;
		gap: 1.4mm 0;
		align-items: center;
		font-size: 9.5pt;
	}

	.ar-ask {
		justify-self: center;
		font-size: 7.5pt;
		font-weight: 800;
		font-style: italic;
		color: var(--accent);
	}

	.ar-end {
		justify-self: center;
		padding: 0.8mm 2mm;
		border: 0.3mm solid var(--navy);
		border-radius: 1mm;
		font-weight: 600;
		white-space: nowrap;
	}

	.ar-end.to {
		border: 0.5mm solid var(--accent);
	}

	/* The verb rides on a line with an arrowhead, from the doer to the done-to. */
	.ar-line {
		position: relative;
		margin: 0 1mm;
		padding: 0 3mm 0.6mm 1mm;
		border-bottom: 0.4mm solid var(--navy);
		font-size: 8.5pt;
		font-weight: 600;
		text-align: center;
		white-space: nowrap;
	}

	.ar-line::after {
		content: '';
		position: absolute;
		right: -0.4mm;
		bottom: -1.3mm;
		border: 1.1mm solid transparent;
		border-left: 1.8mm solid var(--navy);
		border-right: 0;
	}

	.ar-en {
		padding-left: 2.5mm;
		font-size: 8.5pt;
		color: var(--muted);
	}

	/* -- clocks -------------------------------------------------------------- */

	.clock-row {
		display: grid;
		gap: 4mm;
		align-items: center;
	}

	.clock-row.with-dial {
		grid-template-columns: 50mm 1fr;
	}

	.clocks {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 2.5mm 2mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.clocks li {
		display: grid;
		justify-items: center;
		text-align: center;
	}

	.face-box {
		width: 15mm;
	}

	.dial .face {
		fill: #fff;
		stroke: var(--navy);
		stroke-width: 2.4;
	}

	.dial .tick {
		stroke: var(--navy);
		stroke-width: 2;
	}

	.digits {
		margin-top: 0.4mm;
		font-size: 7.5pt;
		color: var(--muted);
	}

	.clock-de {
		font-size: 8.5pt;
		font-weight: 700;
		line-height: 1.2;
	}

	.dial .zone {
		fill: none;
		stroke-width: 6;
		stroke-linecap: round;
	}

	.dial .zone.nach {
		stroke: var(--accent);
	}

	.dial .zone.vor {
		stroke: var(--navy);
	}

	.dial .halb-dot {
		fill: var(--mustard);
	}

	.dial text {
		font-family: var(--sans);
		text-anchor: middle;
		fill: var(--muted);
	}

	.dial .zone-label {
		font-size: 9px;
		font-weight: 800;
	}

	.dial .zone-label.nach {
		fill: var(--accent);
	}

	.dial .zone-label.vor {
		fill: var(--navy);
	}

	.dial .zone-label.halb {
		fill: var(--mustard);
	}

	.dial .dial-small {
		font-size: 6.5px;
	}

	/* -- labelled pictures --------------------------------------------------- */

	.pictures {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 2.5mm 3mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.pictures li {
		display: grid;
		justify-items: center;
		align-content: start;
		text-align: center;
	}

	.pictures img {
		width: 100%;
		height: 20mm;
		object-fit: contain;
	}

	.pictures b {
		margin-top: 1mm;
		font-size: 9pt;
		line-height: 1.2;
	}

	.pictures small {
		font-size: 7.5pt;
		color: var(--muted);
	}

	/* -- timeline ------------------------------------------------------------ */

	.timeline {
		display: grid;
		grid-template-columns: 52mm 1fr;
		gap: 1mm 4mm;
		align-items: center;
	}

	.timeline svg {
		display: block;
	}

	.tl-label {
		display: grid;
		font-size: 9.5pt;
	}

	.tl-label small {
		font-size: 7.5pt;
		color: var(--muted);
	}

	.tl-axis text {
		font-family: var(--sans);
		font-size: 4.6px;
		font-weight: 700;
	}

	.tl-end {
		fill: var(--muted);
	}

	.tl-now {
		fill: var(--accent);
		text-anchor: middle;
	}

	.tl-line {
		stroke: var(--rule);
		stroke-width: 1;
	}

	.tl-nowline {
		stroke: var(--accent);
		stroke-width: 1;
		stroke-dasharray: 2 1.5;
	}

	.tl-dot {
		fill: var(--navy);
	}

	.tl-bar {
		stroke: var(--navy);
		stroke-width: 3.6;
		stroke-linecap: round;
	}

	/* -- sentence slots ------------------------------------------------------ */

	.slots {
		display: grid;
		grid-template-columns: repeat(var(--places), auto) 1fr;
		gap: 1.4mm 1.4mm;
		align-items: stretch;
		font-size: 10pt;
	}

	.slot-head {
		font-size: 7pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-align: center;
		text-transform: uppercase;
		color: var(--muted);
	}

	.slot-head.hot {
		color: var(--accent);
	}

	.slot {
		display: grid;
		align-content: center;
		justify-items: center;
		padding: 0.8mm 2mm;
		border: 0.3mm solid var(--navy);
		border-radius: 1mm;
		font-weight: 600;
		white-space: nowrap;
	}

	.slot.hot {
		border: 0.5mm solid var(--accent);
	}

	.slot small {
		font-size: 6.5pt;
		font-weight: 500;
		color: var(--muted);
	}

	.slot-en {
		align-self: center;
		padding-left: 1.5mm;
		font-size: 8.5pt;
		color: var(--muted);
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
