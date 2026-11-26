<script lang="ts">
	// People per day, as lines: everyone, and the three things they did. All
	// four are counts of people, so they share one axis.
	//
	// Interactive: the pointer (or the arrow keys) reads any day off a
	// crosshair, the legend switches a line off and on, and dragging across
	// days narrows the whole report to them. Every value here is also in the
	// "Day by day" table below it, so nothing depends on hovering.
	import type { DayRow } from '$lib/domain/analyticsReport';

	let { days, onrange }: { days: DayRow[]; onrange?: (from: string, to: string) => void } = $props();

	// Colours: a categorical set checked for colour-blind separation on a
	// white surface (in this fixed order). Two of them are light on white, so
	// each line is also named at its end and in the legend.
	const SERIES = [
		{ key: 'people', label: 'People', color: '#2a78d6' },
		{ key: 'downloaded', label: 'Downloaded', color: '#eb6834' },
		{ key: 'started', label: 'Opened an exercise', color: '#1baf7a' },
		{ key: 'completed', label: 'Finished one', color: '#eda100' }
	] as const;
	type Key = (typeof SERIES)[number]['key'];

	let hidden = $state<Key[]>([]);
	const shown = $derived(SERIES.filter((s) => !hidden.includes(s.key)));
	function toggle(key: Key) {
		// The last line stays: an empty chart answers nothing.
		if (!hidden.includes(key) && shown.length === 1) return;
		hidden = hidden.includes(key) ? hidden.filter((k) => k !== key) : [...hidden, key];
	}

	let width = $state(720);
	const H = 280;
	/** On a phone there is no room to name the lines at their ends: the legend does, the end keeps the number. */
	const narrow = $derived(width < 560);
	const M = $derived({ top: 14, right: narrow ? 36 : 150, bottom: 26, left: 40 });
	const plotW = $derived(Math.max(120, width - M.left - M.right));
	const plotH = $derived(H - M.top - M.bottom);

	/** A round number at or above the largest value shown, and its four steps. */
	const top = $derived.by(() => {
		const max = Math.max(1, ...days.flatMap((d) => shown.map((s) => d[s.key])));
		const step = [1, 2, 5, 10, 20, 25, 50, 100, 200, 250, 500, 1000, 2000, 5000].find((s) => s * 4 >= max) ?? Math.ceil(max / 4);
		return step * 4;
	});
	const ticks = $derived([0, 1, 2, 3, 4].map((i) => (top / 4) * i));

	const x = (i: number) => M.left + (days.length > 1 ? (i / (days.length - 1)) * plotW : plotW / 2);
	const y = (v: number) => M.top + plotH - (v / top) * plotH;
	const path = (key: Key) => days.map((d, i) => `${i ? 'L' : 'M'}${x(i).toFixed(1)},${y(d[key]).toFixed(1)}`).join('');

	/** Day labels under the axis: the ends, and a few between. */
	const xTicks = $derived.by(() => {
		const every = Math.max(1, Math.ceil(days.length / Math.max(2, Math.floor(plotW / 70))));
		return days.map((_, i) => i).filter((i) => (i % every === 0 && days.length - 1 - i >= every) || i === days.length - 1);
	});

	/** The names at the line ends, nudged apart so two close lines stay readable. */
	const endLabels = $derived.by(() => {
		if (!days.length) return [];
		const last = days[days.length - 1];
		const placed = shown
			.map((s) => ({ ...s, value: last[s.key], at: y(last[s.key]) }))
			.sort((a, b) => a.at - b.at);
		for (let i = 1; i < placed.length; i++) placed[i].at = Math.max(placed[i].at, placed[i - 1].at + 15);
		const over = placed.length ? placed[placed.length - 1].at - (M.top + plotH) : 0;
		if (over > 0) for (const p of placed) p.at -= over;
		return placed;
	});

	// -- reading a day, and dragging across days ---------------------------------
	let at = $state<number | null>(null);
	let dragFrom = $state<number | null>(null);
	let svg = $state<SVGSVGElement>();

	function indexAt(event: PointerEvent): number {
		const box = svg!.getBoundingClientRect();
		const px = ((event.clientX - box.left) / box.width) * width;
		if (days.length < 2) return 0;
		return Math.min(days.length - 1, Math.max(0, Math.round(((px - M.left) / plotW) * (days.length - 1))));
	}

	function down(event: PointerEvent) {
		if (event.button !== 0) return;
		dragFrom = at = indexAt(event);
		svg?.setPointerCapture(event.pointerId);
	}
	function move(event: PointerEvent) {
		at = indexAt(event);
	}
	function up(event: PointerEvent) {
		const start = dragFrom;
		dragFrom = null;
		if (start === null) return;
		const end = indexAt(event);
		if (end !== start) onrange?.(days[Math.min(start, end)].day, days[Math.max(start, end)].day);
	}
	function leave() {
		if (dragFrom === null) at = null;
	}
	function key(event: KeyboardEvent) {
		if (!days.length) return;
		const step = event.key === 'ArrowRight' ? 1 : event.key === 'ArrowLeft' ? -1 : 0;
		if (event.key === 'Escape') at = null;
		if (!step) return;
		event.preventDefault();
		at = Math.min(days.length - 1, Math.max(0, (at ?? (step > 0 ? -1 : days.length)) + step));
	}

	const day = $derived(at === null ? null : (days[at] ?? null));
	const band = $derived(
		dragFrom === null || at === null || at === dragFrom
			? null
			: { x: x(Math.min(dragFrom, at)), w: Math.abs(x(at) - x(dragFrom)) }
	);
	/** The readout sits beside the crosshair, on whichever side has the room. */
	const tipLeft = $derived(at === null ? 0 : x(at) > M.left + plotW * 0.6 ? x(at) - 12 : x(at) + 12);
	const tipFlip = $derived(at !== null && x(at) > M.left + plotW * 0.6);
</script>

<div class="chart">
	<div class="legend" role="group" aria-label="Lines shown">
		{#each SERIES as s (s.key)}
			<button type="button" aria-pressed={!hidden.includes(s.key)} onclick={() => toggle(s.key)}>
				<span class="key" style:background={s.color}></span>{s.label}
			</button>
		{/each}
	</div>

	<div class="plot" bind:clientWidth={width}>
		<!-- svelte-ignore a11y_no_noninteractive_tabindex, a11y_no_noninteractive_element_interactions -->
		<svg
			bind:this={svg}
			viewBox="0 0 {width} {H}"
			{width}
			height={H}
			role="img"
			aria-label="People per day, with how many downloaded a book, opened an exercise and finished one. Use the left and right arrow keys to read a day."
			tabindex="0"
			onpointerdown={down}
			onpointermove={move}
			onpointerup={up}
			onpointerleave={leave}
			onpointercancel={() => ((dragFrom = null), (at = null))}
			onkeydown={key}
			onblur={() => (at = null)}
		>
			{#each ticks as t (t)}
				<line class="grid" class:base={t === 0} x1={M.left} x2={M.left + plotW} y1={y(t)} y2={y(t)} />
				<text class="tick" x={M.left - 8} y={y(t)} dy="0.32em" text-anchor="end">{t}</text>
			{/each}
			{#each xTicks as i (i)}
				<text class="tick" x={x(i)} y={H - 6} text-anchor={i === days.length - 1 && days.length > 1 ? 'end' : i === 0 ? 'start' : 'middle'}>
					{days[i].day.slice(5)}
				</text>
			{/each}

			{#if band}<rect class="band" x={band.x} y={M.top} width={band.w} height={plotH} />{/if}

			{#each shown as s (s.key)}
				<path class="line" d={path(s.key)} stroke={s.color} />
				{#if days.length === 1}<circle class="dot" cx={x(0)} cy={y(days[0][s.key])} r="4" fill={s.color} />{/if}
			{/each}

			{#each endLabels as l (l.key)}
				<circle class="dot" cx={x(days.length - 1)} cy={y(l.value)} r="4" fill={l.color} />
				<text class="end" x={M.left + plotW + 10} y={l.at} dy="0.32em">{#if !narrow}{l.label}{' '}{/if}<tspan class="end-n">{l.value}</tspan></text>
			{/each}

			{#if at !== null && day}
				<line class="cross" x1={x(at)} x2={x(at)} y1={M.top} y2={M.top + plotH} />
				{#each shown as s (s.key)}
					<circle class="dot" cx={x(at)} cy={y(day[s.key])} r="4.5" fill={s.color} />
				{/each}
			{/if}
		</svg>

		{#if at !== null && day}
			<div class="tip" class:flip={tipFlip} style:left="{tipLeft}px" role="status">
				<strong>{day.day}</strong>
				{#each shown as s (s.key)}
					<span class="row"><span class="stroke" style:background={s.color}></span><b class="tnum">{day[s.key]}</b> {s.label}</span>
				{/each}
				<span class="row sub"><b class="tnum">{day.returning}</b> had been here before</span>
			</div>
		{/if}
	</div>

	{#if onrange && days.length > 1}
		<p class="hint">Drag across the chart to narrow the whole report to those days.</p>
	{/if}
</div>

<style>
	.legend {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin-bottom: 0.5rem;
	}

	.legend button {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		min-height: 2.25rem;
		padding: 0 0.75rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: transparent;
		color: var(--ink);
		font: inherit;
		font-size: 0.85rem;
		cursor: pointer;
	}

	.legend button[aria-pressed='false'] {
		color: var(--ink-muted);
		border-style: dashed;
		text-decoration: line-through;
	}

	.legend button[aria-pressed='false'] .key {
		opacity: 0.25;
	}

	.key {
		width: 1rem;
		height: 3px;
		border-radius: 2px;
	}

	.plot {
		position: relative;
	}

	svg {
		display: block;
		touch-action: pan-y;
		cursor: crosshair;
		user-select: none;
	}

	svg:focus-visible {
		outline: 2px solid var(--accent);
		outline-offset: 2px;
		border-radius: 6px;
	}

	.grid {
		stroke: var(--line);
		stroke-width: 1;
	}

	.grid.base {
		stroke: var(--line-strong);
	}

	.tick {
		fill: var(--ink-muted);
		font-size: 11px;
		font-variant-numeric: tabular-nums;
	}

	.line {
		fill: none;
		stroke-width: 2;
		stroke-linejoin: round;
		stroke-linecap: round;
	}

	.dot {
		stroke: var(--surface);
		stroke-width: 2;
	}

	.end {
		fill: var(--ink);
		font-size: 12px;
	}

	.end-n {
		font-weight: 700;
		font-variant-numeric: tabular-nums;
	}

	.cross {
		stroke: var(--ink-muted);
		stroke-width: 1;
	}

	.band {
		fill: var(--heading);
		opacity: 0.08;
	}

	.tip {
		position: absolute;
		top: 0.5rem;
		display: grid;
		gap: 0.15rem;
		padding: 0.55rem 0.75rem;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: 10px;
		box-shadow: 0 4px 14px rgb(0 0 0 / 0.08);
		font-size: 0.85rem;
		white-space: nowrap;
		pointer-events: none;
	}

	.tip.flip {
		transform: translateX(-100%);
	}

	.row {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		color: var(--ink-muted);
	}

	.row b {
		min-width: 2ch;
		color: var(--ink);
	}

	.row.sub {
		padding-inline-start: 1.15rem;
	}

	.stroke {
		width: 0.75rem;
		height: 3px;
		border-radius: 2px;
	}

	.hint {
		margin: 0.4rem 0 0;
		font-size: 0.85rem;
		color: var(--ink-muted);
	}
</style>
