<script lang="ts">
	// The diagram on a lesson's rule card. One component per shape a German
	// rule takes (a bracket, a case grid, a timeline …), all fed by a few lines
	// of data in the lesson JSON (`tip.visual`), so the same picture teaches
	// the same idea wherever it comes back.
	//
	// Everything is HTML and inline SVG in the app's own tokens: no images to
	// generate, nothing that can drift from the text, and every German word
	// stays real text (tappable, read aloud, in the prerendered page).
	import GermanText from '../GermanText.svelte';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { splitFocus } from '$lib/domain/lesson';
	import { clockHands, spread, timelineX, VISUAL_KINDS } from '$lib/domain/lesson-visual';
	import type { LessonVisual, TreeNode } from '$lib/content/types';

	let { visual, locale = 'de-DE' }: { visual: LessonVisual; locale?: string } = $props();

	const DEFAULT_PERSONS = ['ich', 'du', 'er / sie / es', 'wir', 'ihr', 'sie / Sie'];
	const GENDER_COLS = ['m', 'f', 'n', 'pl'];
	const GENDER_HEAD: Record<string, string> = { m: 'masc.', f: 'fem.', n: 'neut.', pl: 'plural' };

	function genderTint(col: string): string {
		return GENDER_COLORS[col] ?? 'var(--ink-muted)';
	}
	function isHot(hot: [number, number][] | undefined, r: number, c: number): boolean {
		return !!hot?.some(([hr, hc]) => hr === r && hc === c);
	}
	/** How many people a person row stands for — one figure or two. */
	function plural(person: string, row: number, count: number): boolean {
		// The usual six rows: the last three are plural, whatever language the labels are in.
		if (count === 6) return row >= 3;
		return person.startsWith('wir') || person.startsWith('ihr') || person.endsWith('Sie');
	}
	/** Where the marker lands, by preposition, in the 120 × 80 picture. */
	const SPOTS: Record<string, [number, number]> = {
		on: [60, 30], under: [60, 60], over: [60, 10], in: [60, 50], front: [60, 68],
		behind: [72, 28], beside: [86, 63], between: [60, 63], at: [80, 38]
	};
	/** Where a wohin-arrow starts (and, mirrored, where a woher-arrow ends). */
	const ARROW_FROM: Record<string, [number, number]> = {
		under: [6, 62], front: [6, 70], between: [6, 26], beside: [6, 30], at: [6, 20]
	};
</script>

{#snippet german(text: string, focus?: string[])}
	{#each splitFocus(text, focus) as part, p (p)}{#if part.hit}<mark><GermanText text={part.text} /></mark>{:else}<GermanText text={part.text} />{/if}{/each}
{/snippet}

{#snippet marker(mode: string, spot: string, t: [number, number])}
	{@const from = ARROW_FROM[spot] ?? [10, 10]}
	{#if mode === 'wo'}
		<circle class="p-dot" cx={t[0]} cy={t[1]} r={spot === 'front' ? 7.5 : 6} />
	{:else if mode === 'wohin'}
		<path class="p-arrow" d="M {from[0]} {from[1]} Q {(from[0] + t[0]) / 2} {Math.min(from[1], t[1]) - 10} {t[0]} {t[1]}" />
		<circle class="p-dot" cx={t[0]} cy={t[1]} r="4" />
	{:else}
		<circle class="p-dot ghost" cx={t[0]} cy={t[1]} r="4" />
		<path class="p-arrow" d="M {t[0]} {t[1]} Q {(t[0] + 120 - from[0]) / 2} {Math.min(from[1], t[1]) - 10} {120 - from[0]} {from[1]}" />
	{/if}
{/snippet}

{#snippet placeScene(spot: string, mode: string, t: [number, number])}
	{#if spot === 'on' || spot === 'under' || spot === 'over'}
		<line class="p-floor" x1="4" y1="70" x2="116" y2="70" />
		<rect class="p-box" x="32" y="38" width="56" height="7" rx="2" />
		<rect class="p-box" x="37" y="45" width="5" height="25" />
		<rect class="p-box" x="78" y="45" width="5" height="25" />
		{@render marker(mode, spot, t)}
	{:else if spot === 'in'}
		<line class="p-floor" x1="4" y1="70" x2="116" y2="70" />
		<rect class="p-box p-open" x="38" y="36" width="44" height="34" rx="2" />
		{@render marker(mode, spot, t)}
		<rect class="p-box" x="38" y="54" width="44" height="16" rx="2" />
	{:else if spot === 'behind'}
		<line class="p-floor" x1="4" y1="62" x2="116" y2="62" />
		{@render marker(mode, spot, t)}
		<rect class="p-box" x="38" y="32" width="44" height="30" rx="2" />
	{:else if spot === 'front'}
		<line class="p-floor" x1="4" y1="58" x2="116" y2="58" />
		<rect class="p-box" x="38" y="28" width="44" height="30" rx="2" />
		<ellipse class="p-shadow" cx={t[0]} cy="76" rx="9" ry="2.5" />
		{@render marker(mode, spot, t)}
	{:else if spot === 'between'}
		<line class="p-floor" x1="4" y1="70" x2="116" y2="70" />
		<rect class="p-box" x="18" y="40" width="26" height="30" rx="2" />
		<rect class="p-box" x="76" y="40" width="26" height="30" rx="2" />
		{@render marker(mode, spot, t)}
	{:else if spot === 'at'}
		<line class="p-floor" x1="4" y1="70" x2="116" y2="70" />
		<rect class="p-wall" x="88" y="6" width="9" height="64" />
		{@render marker(mode, spot, t)}
	{:else}
		<line class="p-floor" x1="4" y1="70" x2="116" y2="70" />
		<rect class="p-box" x="30" y="40" width="40" height="30" rx="2" />
		{@render marker(mode, spot, t)}
	{/if}
{/snippet}

{#snippet treeNode(node: TreeNode, depth: number)}
	{#if node.answer}
		<div class="leaf">
			<span class="leaf-answer" lang={locale}>{node.answer}</span>
			{#if node.de}<span class="leaf-de" lang={locale}>{node.de}</span>{/if}
		</div>
	{:else}
		<div class="q">{node.q}</div>
		<ul class="branches">
			{#if node.yes}<li><span class="yn yes">yes</span><div class="branch">{@render treeNode(node.yes, depth + 1)}</div></li>{/if}
			{#if node.no}<li><span class="yn no">no</span><div class="branch">{@render treeNode(node.no, depth + 1)}</div></li>{/if}
		</ul>
	{/if}
{/snippet}

{#if VISUAL_KINDS.includes(visual.kind)}
<figure class="visual" data-visual={visual.kind}>
	{#if visual.kind === 'bracket'}
		{@const cols = visual.columns ?? ['Position 1', 'Verb', 'Middle', 'End']}
		{@const hot = visual.hot ?? [1, cols.length - 1]}
		<div class="scroll">
			<div class="bracket" style="--n:{cols.length}">
				{#each cols as col, c (c)}<div class="b-head" class:hot={hot.includes(c)}>{col}</div>{/each}
				{#each visual.rows as row, r (r)}
					{#each cols as _, c (c)}
						{@const cell = row.cells[c] ?? ''}
						<div class="b-cell" class:hot={hot.includes(c)} class:empty={!cell} lang={locale}>{cell}</div>
					{/each}
					{#if row.en}<div class="b-en">{row.en}</div>{/if}
				{/each}
			</div>
		</div>
	{:else if visual.kind === 'caseGrid'}
		{@const cols = visual.columns ?? GENDER_COLS}
		<div class="scroll">
			<table class="grid">
				<thead>
					<tr>
						<th></th>
						{#each cols as col, c (c)}<th scope="col" style="color:{genderTint(col)}">{GENDER_HEAD[col] ?? col}</th>{/each}
					</tr>
				</thead>
				<tbody>
					{#each visual.rows as row, r (r)}
						<tr>
							<th scope="row">{row.label}</th>
							{#each cols as col, c (c)}
								<td
									lang={locale}
									class:hot={isHot(visual.hot, r, c)}
									class:dim={!!visual.hot?.length && !isHot(visual.hot, r, c)}
									style="--g:{genderTint(col)}"
								>{row.cells[c] || '—'}</td>
							{/each}
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	{:else if visual.kind === 'people'}
		{@const persons = visual.persons ?? DEFAULT_PERSONS}
		<div class="scroll">
			<table class="grid people">
				<thead>
					<tr>
						<th></th>
						{#each visual.columns as col, c (c)}<th scope="col" lang={locale}>{col.label}</th>{/each}
					</tr>
				</thead>
				<tbody>
					{#each persons as person, r (r)}
						<tr class:hot-row={visual.hot?.includes(r)} class:dim-row={!!visual.hot?.length && !visual.hot.includes(r)}>
							<th scope="row" lang={locale}>
								<svg class="who" viewBox="0 0 28 16" aria-hidden="true">
									{#if plural(person, r, persons.length)}
										<circle cx="9" cy="5" r="3.2" /><path d="M3 15c0-3.6 2.7-5.6 6-5.6s6 2 6 5.6z" />
										<circle cx="19" cy="5" r="3.2" /><path d="M13 15c0-3.6 2.7-5.6 6-5.6s6 2 6 5.6z" />
									{:else}
										<circle cx="14" cy="5" r="3.4" /><path d="M7.5 15c0-3.8 2.9-5.8 6.5-5.8s6.5 2 6.5 5.8z" />
									{/if}
								</svg>
								{person}
							</th>
							{#each visual.columns as col, c (c)}<td lang={locale}>{col.forms[r] ?? '—'}</td>{/each}
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	{:else if visual.kind === 'timeline'}
		{@const rows = spread(visual.marks)}
		<div class="timeline" style="--rows:{Math.max(1, ...rows.map((m) => m.row + 1))}">
			<div class="t-axis">
				<span class="t-end">{visual.axis?.start ?? 'past'}</span>
				{#if visual.axis?.now !== null}<span class="t-now" style="left:{timelineX(0)}%">{visual.axis?.now ?? 'now'}</span>{/if}
				<span class="t-end future">{visual.axis?.end ?? 'future'}</span>
			</div>
			{#each rows as m, k (k)}
				{#if m.to !== undefined}
					<div
						class="t-span"
						style="left:{timelineX(Math.min(m.at, m.to))}%;width:{Math.abs(timelineX(m.to) - timelineX(m.at))}%;--row:{m.row}"
					></div>
				{:else}
					<div class="t-dot" style="left:{timelineX(m.at)}%;--row:{m.row}"></div>
				{/if}
				{@const lx = timelineX(m.to !== undefined ? (m.at + m.to) / 2 : m.at)}
				<div class="t-label" class:edge-l={lx < 18} class:edge-r={lx > 82} style="left:{timelineX(m.to !== undefined ? (m.at + m.to) / 2 : m.at)}%;--row:{m.row}">
					{#if m.de}<b lang={locale}>{m.de}</b>{/if}
					<span>{m.label}</span>
				</div>
			{/each}
		</div>
	{:else if visual.kind === 'scale'}
		<div class="scale">
			<span class="s-end">{visual.high}</span>
			<ol class="s-points">
				{#each [...visual.points].sort((a, b) => b.at - a.at) as p, k (k)}
					<li>
						<span class="s-bar"><span style="width:{Math.max(4, Math.min(100, p.at))}%"></span></span>
						<span class="s-de" lang={locale}>{p.de}</span>
						{#if p.en}<span class="s-en">{p.en}</span>{/if}
					</li>
				{/each}
			</ol>
			<span class="s-end">{visual.low}</span>
		</div>
	{:else if visual.kind === 'tree'}
		<div class="tree">{@render treeNode(visual.root, 0)}</div>
	{:else if visual.kind === 'pairs'}
		<div class="scroll">
			<table class="pairs">
				<thead><tr><th scope="col">{visual.left}</th><th aria-hidden="true"></th><th scope="col">{visual.right}</th></tr></thead>
				<tbody>
					{#each visual.rows as row, r (r)}
						<tr>
							<td lang={locale}>{row.a}</td>
							<td class="arrow" aria-label="becomes">⇄</td>
							<td lang={locale}>{row.b}</td>
						</tr>
						{#if row.note}<tr class="note"><td colspan="3">{row.note}</td></tr>{/if}
					{/each}
				</tbody>
			</table>
		</div>
	{:else if visual.kind === 'blocks'}
		<ul class="blocks">
			{#each visual.rows as row, r (r)}
				<li>
					<span class="pieces" lang={locale}>
						{#each row.parts as part, k (k)}
							{#if k > 0}<span class="plus" aria-hidden="true">+</span>{/if}
							<span class="piece" data-role={part.role ?? 'stem'}>{part.text}</span>
						{/each}
					</span>
					<span class="eq" aria-hidden="true">=</span>
					<span class="result" lang={locale} style={row.gender ? `color:${genderTint(row.gender)}` : ''}>{row.result}</span>
					{#if row.en}<span class="b-gloss">{row.en}</span>{/if}
				</li>
			{/each}
		</ul>
	{:else if visual.kind === 'clock'}
		<ul class="clocks">
			{#each visual.faces as face, k (k)}
				{@const h = clockHands(face.time)}
				<li>
					<svg viewBox="0 0 100 100" role="img" aria-label={face.digital ?? face.time}>
						<circle class="c-face" cx="50" cy="50" r="46" />
						{#if h.minute > 0}
							<path class="c-wedge" d={h.wedge} />
						{/if}
						{#each Array(12) as _, t (t)}
							<line class="c-tick" x1="50" y1="8" x2="50" y2={t % 3 === 0 ? 15 : 12} transform="rotate({t * 30} 50 50)" />
						{/each}
						<line class="c-hour" x1="50" y1="50" x2="50" y2="27" transform="rotate({h.hourAngle} 50 50)" />
						<line class="c-min" x1="50" y1="50" x2="50" y2="14" transform="rotate({h.minuteAngle} 50 50)" />
						<circle class="c-pin" cx="50" cy="50" r="3" />
					</svg>
					<span class="c-de" lang={locale}>{face.de}</span>
					{#if face.digital}<span class="c-digital tnum">{face.digital}</span>{/if}
				</li>
			{/each}
		</ul>
	{:else if visual.kind === 'places'}
		<ul class="places">
			{#each visual.items as item, k (k)}
				{@const target = SPOTS[item.spot]}
				<li data-mode={item.mode}>
					<svg viewBox="0 0 120 80" aria-hidden="true">
						{@render placeScene(item.spot, item.mode, target)}
					</svg>
					<span class="p-prep" lang={locale}>{item.prep}</span>
					<span class="p-de" lang={locale}>{item.de}</span>
					{#if item.en}<span class="p-en">{item.en}</span>{/if}
				</li>
			{/each}
		</ul>
	{:else if visual.kind === 'moves'}
		<ol class="moves">
			{#each visual.moves as move, k (k)}
				<li>
					<span class="m-num tnum">{k + 1}</span>
					<span class="m-body">
						<span class="m-label">{move.label}</span>
						<span class="m-phrases" lang={locale}>{#each move.de as phrase, p (p)}<span class="chip">{phrase}</span>{/each}</span>
					</span>
				</li>
			{/each}
		</ol>
	{:else if visual.kind === 'pictures'}
		<ul class="pictures" class:wide={visual.wide}>
			{#each visual.items as item, k (k)}
				<li>
					{#if item.image}
						<img src="/img/{item.image}.webp" alt={item.en ?? item.de} loading="lazy" width="512" height={visual.wide ? 384 : 512} />
					{:else}
						<span class="swatch" style="background:{item.color}" aria-hidden="true"></span>
					{/if}
					<span class="pic-de" lang={locale}>{item.de}</span>
					{#if item.en}<span class="pic-en">{item.en}</span>{/if}
				</li>
			{/each}
		</ul>
	{:else if visual.kind === 'textMap'}
		<ol class="textmap">
			{#each visual.blocks as block, k (k)}
				<li>
					<span class="tm-label">{block.label}</span>
					<span class="tm-de" lang={locale}>{@render german(block.de, block.focus)}</span>
				</li>
			{/each}
		</ol>
	{/if}
	{#if visual.caption}<figcaption>{visual.caption}</figcaption>{/if}
</figure>
{/if}

<style>
	.visual {
		margin: 0;
		padding: 0.85rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--paper-low);
		display: grid;
		gap: 0.6rem;
		min-width: 0;
	}

	figcaption {
		font-size: var(--step--1);
		color: var(--ink-muted);
		line-height: 1.45;
	}

	/* A wide diagram scrolls inside its own frame, never the page. */
	.scroll {
		overflow-x: auto;
		min-width: 0;
		-webkit-overflow-scrolling: touch;
		/* Edge shadows that appear only while there is more to scroll to. */
		background:
			linear-gradient(to right, var(--paper-low) 30%, transparent) left / 2rem 100% no-repeat local,
			linear-gradient(to left, var(--paper-low) 30%, transparent) right / 2rem 100% no-repeat local,
			radial-gradient(farthest-side at 0 50%, rgb(0 0 0 / 0.14), transparent) left / 0.7rem 100% no-repeat scroll,
			radial-gradient(farthest-side at 100% 50%, rgb(0 0 0 / 0.14), transparent) right / 0.7rem 100% no-repeat scroll;
	}

	/* -- V1 bracket ------------------------------------------------------- */
	.bracket {
		display: grid;
		grid-template-columns: repeat(var(--n), minmax(min-content, auto));
		gap: 0.3rem;
		font-size: var(--step--1);
	}
	.b-head {
		font-size: 0.68rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		padding: 0 0.3rem;
		line-height: 1.2;
		align-self: end;
	}
	.b-head.hot {
		color: var(--accent-ink);
	}
	.b-cell {
		padding: 0.4rem 0.55rem;
		border-radius: 8px;
		background: var(--surface);
		border: 1px solid var(--line);
		font-family: var(--serif, inherit);
		font-size: var(--step-0);
		color: var(--ink);
		overflow-wrap: normal;
		word-break: normal;
	}
	@media (max-width: 30rem) {
		.b-cell {
			padding: 0.35rem 0.4rem;
			font-size: var(--step--1);
		}
	}
	.b-cell.hot {
		background: var(--accent-soft);
		border-color: var(--accent);
		color: var(--accent-ink);
		font-weight: 700;
	}
	.b-cell.empty {
		background: transparent;
		border-style: dashed;
	}
	.b-en {
		grid-column: 1 / -1;
		margin: -0.1rem 0 0.35rem 0.3rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* -- V2 grid / V13 people -------------------------------------------- */
	.grid {
		border-collapse: separate;
		border-spacing: 0.25rem;
		font-size: var(--step-0);
	}
	.grid th {
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.05em;
		text-transform: uppercase;
		color: var(--ink-muted);
		text-align: left;
		padding: 0 0.4rem;
		white-space: nowrap;
	}
	.grid td {
		padding: 0.4rem 0.6rem;
		border-radius: 8px;
		background: var(--surface);
		border: 1px solid var(--line);
		border-top: 3px solid var(--g, var(--line));
		font-family: var(--serif, inherit);
		white-space: nowrap;
		color: var(--ink);
	}
	@media (max-width: 30rem) {
		.grid {
			border-spacing: 0.18rem;
			font-size: var(--step--1);
		}
		.grid td {
			padding: 0.32rem 0.4rem;
		}
		.grid th {
			padding: 0 0.2rem;
		}
	}
	.grid td.hot {
		background: var(--accent-soft);
		border-color: var(--accent);
		border-top-color: var(--g, var(--accent));
		color: var(--accent-ink);
		font-weight: 700;
	}
	.grid td.dim {
		color: var(--ink-muted);
	}
	.people th[scope='row'] {
		text-transform: none;
		letter-spacing: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink);
	}
	.people thead th {
		text-transform: none;
		letter-spacing: 0;
		font-family: var(--serif, inherit);
		font-size: var(--step-0);
		color: var(--heading);
	}
	.people td {
		border-top-width: 1px;
	}
	.who {
		width: 1.6rem;
		height: 0.95rem;
		vertical-align: -0.12rem;
		margin-right: 0.25rem;
		fill: var(--navy);
		opacity: 0.75;
	}
	.hot-row td {
		background: var(--accent-soft);
		border-color: var(--accent);
		color: var(--accent-ink);
		font-weight: 700;
	}
	.dim-row td,
	.dim-row th {
		opacity: 0.6;
	}

	/* -- V3 timeline ------------------------------------------------------ */
	.timeline {
		position: relative;
		height: calc(3.2rem + var(--rows) * 3.1rem);
		margin: 0 0.4rem;
	}
	.t-axis {
		position: absolute;
		left: 0;
		right: 0;
		top: 1.6rem;
		height: 2px;
		background: var(--navy);
	}
	.t-axis::after {
		content: '';
		position: absolute;
		right: -2px;
		top: -5px;
		border: 6px solid transparent;
		border-left: 9px solid var(--navy);
		border-right: 0;
	}
	.t-end {
		position: absolute;
		top: -1.5rem;
		left: 0;
		font-size: 0.68rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	.t-end.future {
		left: auto;
		right: 0;
	}
	.t-now {
		position: absolute;
		top: -1.5rem;
		transform: translateX(-50%);
		font-size: 0.68rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}
	.t-now::after {
		content: '';
		position: absolute;
		left: 50%;
		top: 1.1rem;
		width: 2px;
		height: 1rem;
		background: var(--accent);
	}
	.t-dot,
	.t-span {
		position: absolute;
		top: calc(1.6rem - 6px);
	}
	.t-dot {
		width: 13px;
		height: 13px;
		margin-left: -6px;
		border-radius: 50%;
		background: var(--accent);
		border: 2px solid var(--surface);
		box-shadow: 0 0 0 1px var(--accent);
	}
	.t-span {
		height: 8px;
		top: calc(1.6rem - 3px - var(--row) * 0px);
		border-radius: 4px;
		background: color-mix(in srgb, var(--accent) 55%, transparent);
	}
	.t-label {
		position: absolute;
		top: calc(2.4rem + var(--row) * 3.1rem);
		transform: translateX(-50%);
		display: grid;
		justify-items: center;
		text-align: center;
		width: max-content;
		max-width: 8rem;
		font-size: 0.78rem;
		line-height: 1.25;
		color: var(--ink-muted);
	}
	.t-label.edge-l {
		transform: none;
		justify-items: start;
		text-align: left;
	}
	.t-label.edge-r {
		transform: translateX(-100%);
		justify-items: end;
		text-align: right;
	}
	.t-label.edge-l::before {
		left: 0;
	}
	.t-label.edge-r::before {
		left: auto;
		right: 0;
	}
	.t-label b {
		font-family: var(--serif, inherit);
		font-size: var(--step-0);
		color: var(--ink);
	}
	.t-label::before {
		content: '';
		position: absolute;
		top: calc(-0.8rem - var(--row) * 3.1rem);
		height: calc(0.7rem + var(--row) * 3.1rem);
		left: 50%;
		width: 1px;
		background: var(--line-strong);
	}

	/* -- V17 scale -------------------------------------------------------- */
	.scale {
		display: grid;
		gap: 0.35rem;
	}
	.s-end {
		font-size: 0.68rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	.s-points {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.4rem;
	}
	.s-points li {
		display: grid;
		grid-template-columns: auto 1fr;
		align-items: baseline;
		gap: 0.15rem 0.6rem;
	}
	.s-points .s-bar {
		grid-column: 1 / -1;
		grid-row: 2;
	}
	.s-bar {
		align-self: center;
		height: 8px;
		border-radius: 4px;
		background: var(--paper-high);
		overflow: hidden;
	}
	.s-bar span {
		display: block;
		height: 100%;
		background: var(--accent);
	}
	.s-de {
		font-family: var(--serif, inherit);
		font-weight: 700;
		color: var(--ink);
	}
	.s-en {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* -- V5 tree ---------------------------------------------------------- */
	.tree {
		font-size: var(--step--1);
	}
	.q {
		display: inline-block;
		padding: 0.4rem 0.65rem;
		border-radius: 8px;
		background: var(--navy);
		color: var(--paper);
		font-weight: 700;
	}
	.branches {
		margin: 0.35rem 0 0 0.9rem;
		padding: 0 0 0 0.8rem;
		list-style: none;
		border-left: 2px solid var(--line-strong);
		display: grid;
		gap: 0.45rem;
	}
	.branches li {
		display: flex;
		align-items: flex-start;
		gap: 0.45rem;
	}
	.yn {
		flex: none;
		margin-top: 0.35rem;
		font-size: 0.68rem;
		font-weight: 800;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}
	.yn.yes {
		color: var(--right);
	}
	.yn.no {
		color: var(--wrong);
	}
	.branch {
		min-width: 0;
	}
	.leaf {
		display: inline-grid;
		padding: 0.35rem 0.65rem;
		border-radius: 8px;
		background: var(--accent-soft);
		border: 1px solid var(--accent);
	}
	.leaf-answer {
		font-family: var(--serif, inherit);
		font-weight: 700;
		font-size: var(--step-0);
		color: var(--accent-ink);
	}
	.leaf-de {
		color: var(--ink-muted);
		font-style: italic;
	}

	/* -- V16 pairs -------------------------------------------------------- */
	.pairs {
		border-collapse: collapse;
		width: 100%;
		font-size: var(--step-0);
	}
	.pairs th {
		font-size: 0.68rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		text-align: left;
		padding: 0 0.4rem 0.3rem;
	}
	.pairs td {
		padding: 0.4rem;
		border-top: 1px solid var(--line);
		font-family: var(--serif, inherit);
		color: var(--ink);
		vertical-align: top;
	}
	.pairs td.arrow {
		color: var(--accent);
		font-weight: 700;
		text-align: center;
		font-family: inherit;
	}
	.pairs tr.note td {
		border-top: 0;
		padding-top: 0;
		font-family: inherit;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* -- V12 blocks ------------------------------------------------------- */
	.blocks {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.55rem;
	}
	.blocks li {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.35rem 0.5rem;
	}
	.pieces {
		display: inline-flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.25rem;
	}
	.piece {
		padding: 0.25rem 0.5rem;
		border-radius: 6px;
		font-family: var(--serif, inherit);
		font-weight: 700;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		color: var(--ink);
	}
	.piece[data-role='prefix'] {
		background: #e8eef6;
		border-color: var(--navy);
		color: var(--navy);
	}
	.piece[data-role='suffix'],
	.piece[data-role='ending'] {
		background: var(--accent-soft);
		border-color: var(--accent);
		color: var(--accent-ink);
	}
	.piece[data-role='joint'] {
		background: #f6efdc;
		border-color: var(--ochre);
		color: var(--ochre-ink);
	}
	.piece[data-role='gone'] {
		text-decoration: line-through;
		color: var(--ink-muted);
		border-style: dashed;
		background: transparent;
	}
	.plus,
	.eq {
		color: var(--ink-muted);
		font-weight: 700;
	}
	.result {
		font-family: var(--serif, inherit);
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}
	.b-gloss {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* -- V8 clock --------------------------------------------------------- */
	.clocks {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(6.5rem, 1fr));
		gap: 0.8rem;
	}
	.clocks li {
		display: grid;
		justify-items: center;
		text-align: center;
		gap: 0.2rem;
	}
	.clocks svg {
		width: 5.5rem;
		height: 5.5rem;
	}
	.c-face {
		fill: var(--surface);
		stroke: var(--navy);
		stroke-width: 3;
	}
	.c-wedge {
		fill: var(--accent-soft);
		stroke: none;
	}
	.c-tick {
		stroke: var(--navy);
		stroke-width: 2;
	}
	.c-hour {
		stroke: var(--navy);
		stroke-width: 5;
		stroke-linecap: round;
	}
	.c-min {
		stroke: var(--accent);
		stroke-width: 3;
		stroke-linecap: round;
	}
	.c-pin {
		fill: var(--navy);
	}
	.c-de {
		font-family: var(--serif, inherit);
		font-weight: 700;
		color: var(--ink);
		line-height: 1.2;
	}
	.c-digital {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* -- V4 places -------------------------------------------------------- */
	.places {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(8.5rem, 1fr));
		gap: 0.7rem;
	}
	.places li {
		display: grid;
		gap: 0.15rem;
		padding: 0.4rem;
		border-radius: 8px;
		background: var(--surface);
		border: 1px solid var(--line);
	}
	.places svg {
		width: 100%;
		height: auto;
	}
	.p-floor {
		stroke: var(--line-strong);
		stroke-width: 2;
	}
	.p-box,
	.p-wall {
		fill: #e9dcc3;
		stroke: var(--navy);
		stroke-width: 2;
	}
	.p-box.p-open {
		fill: #f3ead8;
	}
	.p-dot {
		fill: var(--accent);
		stroke: var(--surface);
		stroke-width: 2;
	}
	.p-shadow {
		fill: var(--line-strong);
	}
	.p-dot.ghost {
		fill: none;
		stroke: var(--navy);
		stroke-dasharray: 2 2;
	}
	.p-arrow {
		fill: none;
		stroke: var(--accent);
		stroke-width: 3;
		stroke-linecap: round;
		stroke-linejoin: round;
	}
	.places li[data-mode='woher'] .p-arrow {
		stroke: var(--navy);
		stroke-dasharray: 5 4;
		marker-end: none;
	}
	.p-prep {
		font-family: var(--serif, inherit);
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--accent-ink);
	}
	.p-de {
		font-family: var(--serif, inherit);
		color: var(--ink);
		line-height: 1.3;
	}
	.p-en {
		font-size: 0.78rem;
		color: var(--ink-muted);
	}

	/* -- V20 moves -------------------------------------------------------- */
	.moves {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.5rem;
	}
	.moves li {
		display: flex;
		gap: 0.6rem;
		align-items: flex-start;
	}
	.m-num {
		flex: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.5rem;
		height: 1.5rem;
		border-radius: 50%;
		background: var(--navy);
		color: var(--paper);
		font-size: 0.78rem;
		font-weight: 700;
	}
	.m-body {
		display: grid;
		gap: 0.25rem;
		min-width: 0;
	}
	.m-label {
		font-weight: 700;
		color: var(--heading);
	}
	.m-phrases {
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem;
	}
	.chip {
		padding: 0.15rem 0.5rem;
		border-radius: 999px;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		font-family: var(--serif, inherit);
		font-size: var(--step--1);
		color: var(--ink);
	}

	/* -- V15 pictures ----------------------------------------------------- */
	.pictures {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(7.5rem, 1fr));
		gap: 0.7rem;
	}
	.pictures.wide {
		grid-template-columns: repeat(auto-fill, minmax(14rem, 1fr));
	}
	.pictures li {
		display: grid;
		gap: 0.2rem;
		align-content: start;
	}
	/* The pictures are drawn on this cream; the tile is the same, so no edge shows. */
	.pictures img {
		width: 100%;
		height: auto;
		border-radius: 8px;
		background: #fbf5e4;
	}
	.swatch {
		display: block;
		aspect-ratio: 1;
		border-radius: 8px;
		border: 1px solid var(--line-strong);
	}
	.pic-de {
		font-family: var(--serif, inherit);
		font-weight: 700;
		color: var(--ink);
		line-height: 1.3;
	}
	.pic-en {
		font-size: 0.78rem;
		color: var(--ink-muted);
	}

	/* -- V11 text map ----------------------------------------------------- */
	.textmap {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.5rem;
	}
	.textmap li {
		display: grid;
		gap: 0.15rem;
		padding-left: 0.7rem;
		border-left: 3px solid var(--accent);
	}
	.tm-label {
		font-size: 0.68rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}
	.tm-de {
		font-family: var(--serif, inherit);
		color: var(--ink);
		line-height: 1.5;
	}
	.tm-de :global(mark) {
		background: var(--accent-soft);
		color: inherit;
		border-radius: 3px;
		padding: 0 0.1em;
	}
</style>
