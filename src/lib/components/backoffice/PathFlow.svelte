<script lang="ts">
	// Where people go, in order: three columns (where they landed, the first
	// thing they did, how the day ended) joined by bands as thick as the number
	// of people who took that way. The shares elsewhere in the report are
	// independent of each other; this is the one view of sequence.
	//
	// Interactive: pointing at (or tabbing to) a block traces everyone who
	// passed through it across all three columns; pointing at a band reads
	// that one way. The same numbers are in the table of the commonest paths
	// under the chart.
	import { PATH_STEPS, type Person } from '$lib/domain/analyticsReport';

	let { people }: { people: Person[] } = $props();

	/** As wide as its box, but never so narrow that three columns of labels collide: a phone scrolls sideways. */
	let boxWidth = $state(960);
	const W = $derived(Math.max(700, boxWidth));
	const H = 440;
	const NODE = 12;
	const GAP = 12;
	const TOP = 30;
	const COL_X = $derived([0, (W - NODE) / 2, W - NODE]);
	const TRACE = '#2a78d6';

	type Node = { col: number; name: string; count: number; y: number; h: number };
	type Link = {
		col: number;
		from: Node;
		to: Node;
		count: number;
		/** Top of the band where it leaves its source and where it enters its target. */
		y0: number;
		y1: number;
	};

	const total = $derived(people.length);

	const layout = $derived.by(() => {
		const columns = PATH_STEPS.map((step, col) =>
			step.options
				.map((name) => ({ col, name, count: people.filter((p) => p.path[col] === name).length, y: 0, h: 0 }))
				.filter((n) => n.count > 0)
		);
		const most = Math.max(1, ...columns.map((c) => c.length));
		const k = total ? (H - TOP - GAP * (most - 1)) / total : 0;
		for (const column of columns) {
			let y = TOP;
			for (const n of column) {
				n.y = y;
				n.h = Math.max(1, n.count * k);
				y += n.h + GAP;
			}
		}
		const links: Link[] = [];
		for (let col = 0; col < 2; col++) {
			const outAt = new Map(columns[col].map((n) => [n.name, n.y]));
			const inAt = new Map(columns[col + 1].map((n) => [n.name, n.y]));
			// Source by source, target by target: bands leave and arrive in block order, so they cross least.
			for (const from of columns[col]) {
				for (const to of columns[col + 1]) {
					const count = people.filter((p) => p.path[col] === from.name && p.path[col + 1] === to.name).length;
					if (!count) continue;
					links.push({ col, from, to, count, y0: outAt.get(from.name)!, y1: 0 });
					outAt.set(from.name, outAt.get(from.name)! + count * k);
				}
			}
			for (const to of columns[col + 1]) {
				for (const link of links.filter((l) => l.col === col && l.to === to)) {
					link.y1 = inAt.get(to.name)!;
					inAt.set(to.name, link.y1 + link.count * k);
				}
			}
		}
		return { columns, links, k };
	});

	/** A band from one block's right edge to the next block's left edge, `h` thick. */
	function band(link: Link, h: number): string {
		const x0 = COL_X[link.col] + NODE;
		const x1 = COL_X[link.col + 1];
		const mid = (x0 + x1) / 2;
		const [a, b] = [link.y0, link.y1];
		return `M${x0},${a}C${mid},${a} ${mid},${b} ${x1},${b}L${x1},${b + h}C${mid},${b + h} ${mid},${a + h} ${x0},${a + h}Z`;
	}

	// -- tracing -------------------------------------------------------------------
	let overNode = $state<{ col: number; name: string } | null>(null);
	let overLink = $state<Link | null>(null);
	let pointer = $state({ x: 0, y: 0 });
	let box = $state<HTMLDivElement>();

	/** How many of a band's people also passed through the traced block. */
	function traced(link: Link): number {
		if (overLink) return overLink === link ? link.count : 0;
		if (!overNode) return 0;
		const { col, name } = overNode;
		return people.filter(
			(p) => p.path[link.col] === link.from.name && p.path[link.col + 1] === link.to.name && p.path[col] === name
		).length;
	}

	function track(event: PointerEvent) {
		const r = box!.getBoundingClientRect();
		pointer = { x: event.clientX - r.left, y: event.clientY - r.top };
	}
	function focusNode(event: FocusEvent, n: Node) {
		const r = box!.getBoundingClientRect();
		const b = (event.currentTarget as SVGGElement).getBoundingClientRect();
		pointer = { x: b.left - r.left + b.width / 2, y: b.bottom - r.top };
		overNode = n;
		overLink = null;
	}

	const pct = (a: number, b: number) => (b ? `${Math.round((100 * a) / b)}%` : '–');

	const tip = $derived.by(() => {
		if (overLink) {
			const l = overLink;
			return {
				title: `${l.from.name} → ${l.to.name}`,
				rows: [
					`${l.count} people, ${pct(l.count, total)} of everyone`,
					`${pct(l.count, l.from.count)} of “${l.from.name}”`,
					`${pct(l.count, l.to.count)} of “${l.to.name}”`
				]
			};
		}
		if (overNode) {
			const { col, name } = overNode;
			const through = people.filter((p) => p.path[col] === name);
			// Where these people ended up (or, for the last column, where they started).
			const other = col === 2 ? 0 : 2;
			const split = PATH_STEPS[other].options
				.map((o) => ({ o, n: through.filter((p) => p.path[other] === o).length }))
				.filter((x) => x.n)
				.sort((a, b) => b.n - a.n)
				.slice(0, 4);
			return {
				title: `${PATH_STEPS[col].title}: ${name}`,
				rows: [
					`${through.length} people, ${pct(through.length, total)} of everyone`,
					...split.map((x) => `${pct(x.n, through.length)} ${col === 2 ? 'landed on' : '→'} ${x.o} (${x.n})`)
				]
			};
		}
		return null;
	});

	/** The commonest whole paths: the chart's numbers as a table. */
	const paths = $derived.by(() => {
		const m = new Map<string, { path: [string, string, string]; count: number }>();
		for (const p of people) {
			const key = p.path.join('|');
			const row = m.get(key);
			if (row) row.count++;
			else m.set(key, { path: p.path, count: 1 });
		}
		return [...m.values()].sort((a, b) => b.count - a.count);
	});
	let allPaths = $state(false);
	const shownPaths = $derived(allPaths ? paths : paths.slice(0, 10));
</script>

<div class="flow" bind:this={box}>
	<div class="scroll" bind:clientWidth={boxWidth}>
		<svg viewBox="0 0 {W} {H}" width={W} height={H} role="group" aria-label="Paths through a visit, in three steps">
			{#each PATH_STEPS as step, col (step.title)}
				<text class="head" x={col === 2 ? W : col === 1 ? COL_X[1] + NODE / 2 : 0} y="14" text-anchor={col === 2 ? 'end' : col === 1 ? 'middle' : 'start'}>
					{step.title}
				</text>
			{/each}

			{#each layout.links as l (`${l.col}|${l.from.name}|${l.to.name}`)}
				<!-- svelte-ignore a11y_no_static_element_interactions -->
				<path
					class="band"
					d={band(l, Math.max(1, l.count * layout.k))}
					onpointerenter={() => ((overLink = l), (overNode = null))}
					onpointermove={track}
					onpointerleave={() => (overLink = null)}
				/>
			{/each}
			{#each layout.links as l (`t${l.col}|${l.from.name}|${l.to.name}`)}
				{@const n = traced(l)}
				{#if n}<path class="trace" d={band(l, Math.max(1, n * layout.k))} fill={TRACE} />{/if}
			{/each}

			{#each layout.columns as column, col (col)}
				{#each column as n (n.name)}
					<!-- svelte-ignore a11y_no_noninteractive_tabindex -->
					<g
						class="node"
						class:on={overNode?.col === col && overNode.name === n.name}
						role="img"
						aria-label="{PATH_STEPS[col].title}: {n.name}, {n.count} people, {pct(n.count, total)}"
						tabindex="0"
						onpointerenter={() => ((overNode = n), (overLink = null))}
						onpointermove={track}
						onpointerleave={() => (overNode = null)}
						onfocus={(e) => focusNode(e, n)}
						onblur={() => (overNode = null)}
					>
						<!-- A generous target: the block is 12px wide, the label is part of it. -->
						<rect class="hit" x={col === 2 ? COL_X[2] - 250 : COL_X[col]} y={n.y - 4} width={NODE + 250} height={Math.max(24, n.h + 8)} />
						<rect class="block" x={COL_X[col]} y={n.y} width={NODE} height={n.h} rx="2" />
						<text
							class="label"
							x={col === 2 ? COL_X[2] - 8 : COL_X[col] + NODE + 8}
							y={n.y + Math.max(n.h, 12) / 2}
							dy="0.32em"
							text-anchor={col === 2 ? 'end' : 'start'}
						>
							{n.name} <tspan class="count">{n.count}</tspan> <tspan class="share">{pct(n.count, total)}</tspan>
						</text>
					</g>
				{/each}
			{/each}
		</svg>
	</div>

	{#if tip}
		<div class="tip" class:left={pointer.x > boxWidth * 0.6} style:left="{pointer.x}px" style:top="{pointer.y + 14}px" role="status">
			<strong>{tip.title}</strong>
			{#each tip.rows as r (r)}<span>{r}</span>{/each}
		</div>
	{/if}

	<p class="hint">Point at a block to trace its people through the visit; point at a band to read that one way.</p>

	<div class="table-wrap">
		<table>
			<caption>The commonest paths</caption>
			<thead>
				<tr>
					{#each PATH_STEPS as step (step.title)}<th scope="col">{step.title}</th>{/each}
					<th scope="col" class="end">People</th>
					<th scope="col" class="end">Share</th>
				</tr>
			</thead>
			<tbody>
				{#each shownPaths as p (p.path.join('|'))}
					<tr>
						<td>{p.path[0]}</td>
						<td>{p.path[1]}</td>
						<td>{p.path[2]}</td>
						<td class="tnum end">{p.count}</td>
						<td class="tnum end">{pct(p.count, total)}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
	{#if paths.length > 10}
		<button type="button" class="more" onclick={() => (allPaths = !allPaths)}>
			{allPaths ? 'Show the 10 commonest' : `Show all ${paths.length} paths`}
		</button>
	{/if}
</div>

<style>
	.flow {
		position: relative;
	}

	.scroll {
		overflow-x: auto;
	}

	svg {
		display: block;
		max-width: none;
	}

	.head {
		fill: var(--ink-muted);
		font-size: 12px;
		font-weight: 700;
	}

	.band {
		fill: var(--ink-muted);
		opacity: 0.16;
	}

	.band:hover {
		opacity: 0.3;
	}

	.trace {
		opacity: 0.75;
		pointer-events: none;
	}

	.node {
		cursor: default;
		outline: none;
	}

	.hit {
		fill: transparent;
	}

	.block {
		fill: var(--heading);
	}

	.node.on .block,
	.node:focus-visible .block {
		fill: #2a78d6;
	}

	.node:focus-visible .hit {
		stroke: var(--accent);
		stroke-width: 2;
	}

	.label {
		fill: var(--ink);
		font-size: 13px;
		/* A halo in the surface colour: labels sit on top of the bands. */
		paint-order: stroke;
		stroke: var(--surface);
		stroke-width: 4px;
		stroke-linejoin: round;
	}

	.count {
		font-weight: 700;
		font-variant-numeric: tabular-nums;
	}

	.share {
		fill: var(--ink-muted);
		font-variant-numeric: tabular-nums;
	}

	.tip {
		position: absolute;
		z-index: 5;
		display: grid;
		gap: 0.15rem;
		max-width: 22rem;
		padding: 0.55rem 0.75rem;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: 10px;
		box-shadow: 0 4px 14px rgb(0 0 0 / 0.08);
		font-size: 0.85rem;
		color: var(--ink-muted);
		pointer-events: none;
	}

	.tip.left {
		transform: translateX(-100%);
	}

	.tip strong {
		color: var(--ink);
	}

	.hint {
		margin: 0.4rem 0 1rem;
		font-size: 0.85rem;
		color: var(--ink-muted);
	}

	.table-wrap {
		overflow-x: auto;
	}

	table {
		border-collapse: collapse;
		width: 100%;
		font-size: 0.9rem;
	}

	caption {
		padding-bottom: 0.4rem;
		text-align: start;
		font-weight: 700;
		color: var(--ink-muted);
	}

	th,
	td {
		padding: 0.4rem 0.6rem;
		border-bottom: 1px solid var(--line);
		text-align: start;
		white-space: nowrap;
	}

	thead th {
		font-size: 0.8rem;
		color: var(--ink-muted);
	}

	.end {
		text-align: end;
	}

	tbody tr:last-child td {
		border-bottom: 0;
	}

	.more {
		margin-top: 0.5rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-weight: 600;
		text-decoration: underline;
		cursor: pointer;
	}
</style>
