<script lang="ts">
	// The Kiez around Maya's U-Bahn stop, drawn in code (layout data: ./kiez.ts).
	import { NODES, PLACES, STREET_LABELS, type PlaceId } from './kiez';

	let {
		station,
		labels = true,
		streetLabels = true,
		walker = null,
		trail = [],
		found = null,
		shake = null,
		showStreet = null,
		ontap
	}: {
		/** The square's name (the drawn station). */
		station: string;
		/** Show place names; off = icons only (German → picture). */
		labels?: boolean;
		streetLabels?: boolean;
		/** Maya's pin, by node id. */
		walker?: string | null;
		/** Nodes walked so far — drawn as a dashed trail. */
		trail?: string[];
		/** A place to ring as found. */
		found?: PlaceId | null;
		/** A place to shake as wrong. */
		shake?: PlaceId | null;
		/** With street labels off: still name this one street (an arrival). */
		showStreet?: PlaceId | null;
		ontap?: (id: PlaceId, el: Element) => void;
	} = $props();

	const pin = $derived(walker ? NODES[walker] : null);
	const trailPath = $derived(
		trail.length > 1 ? trail.map((n, i) => `${i ? 'L' : 'M'}${NODES[n].x} ${NODES[n].y}`).join(' ') : ''
	);
	const tappable = $derived(Boolean(ontap));
	/** Maya faces along her last step; before the first one, north (the TV tower). */
	const heading = $derived.by(() => {
		if (trail.length < 2) return 0;
		const a = NODES[trail[trail.length - 2]];
		const b = NODES[trail[trail.length - 1]];
		return (Math.atan2(b.x - a.x, a.y - b.y) * 180) / Math.PI;
	});
	const streets = $derived(STREET_LABELS.filter((s) => streetLabels || s.id === showStreet));
</script>

<svg
	class="kiez"
	viewBox="0 0 400 300"
	role="img"
	aria-label="Map of the neighbourhood around {station}">
	<!-- ground -->
	<rect width="400" height="300" fill="#f3ead8" />
	<!-- river + its banks -->
	<path d="M0 78 C 90 70, 150 96, 230 86 S 360 72, 400 84 L400 108 C 330 98, 260 112, 200 108 S 60 96, 0 104 Z" fill="#8fb3c9" stroke="#1f3a5f" stroke-width="1.4" />
	<path d="M20 92 q 10 -3 20 0 M120 95 q 10 -3 20 0 M270 92 q 10 -3 20 0 M340 88 q 10 -3 20 0" stroke="#fbf8f3" stroke-width="1.2" fill="none" opacity="0.8" />

	<!-- blocks of houses -->
	{#each [[14, 120, 82, 22], [130, 112, 54, 26], [14, 166, 82, 36], [130, 164, 54, 38], [216, 112, 160, 26], [14, 230, 82, 56], [216, 230, 160, 56], [14, 8, 166, 56], [252, 8, 134, 56]] as [x, y, w, h]}
		<rect {x} {y} width={w} height={h} rx="3" fill="#ead9c0" stroke="#1f3a5f" stroke-width="1.2" />
	{/each}

	<!-- the park -->
	<rect x="226" y="160" width="152" height="40" rx="8" fill="#7a9a7e" stroke="#1f3a5f" stroke-width="1.4" />
	{#each [[244, 172], [266, 186], [292, 170], [318, 188], [344, 172], [364, 186]] as [x, y]}
		<circle cx={x} cy={y} r="7" fill="#5f8064" stroke="#1f3a5f" stroke-width="1" />
	{/each}

	<!-- streets: cream with an ink edge -->
	<g fill="none" stroke-linecap="round" stroke-linejoin="round">
		<path id="st-all" d="M32 215 H370 M200 215 V292 M200 215 V22 M112 150 H382" stroke="#1f3a5f" stroke-width="15" />
		<path d="M32 215 H370 M200 215 V292 M200 215 V22 M112 150 H382" stroke="#fbf8f3" stroke-width="12" />
	</g>
	<!-- the bridge over the river -->
	<rect x="188" y="80" width="24" height="30" fill="#e7dcc6" stroke="#1f3a5f" stroke-width="1.4" />
	<path d="M188 84 v22 M212 84 v22" stroke="#1f3a5f" stroke-width="2.4" />

	<!-- the square + U-Bahn -->
	<rect x="176" y="196" width="48" height="38" rx="6" fill="#e7dcc6" stroke="#1f3a5f" stroke-width="1.4" />
	<circle cx="200" cy="215" r="6" fill="#7a9a7e" stroke="#1f3a5f" stroke-width="1" />
	<g transform="translate(156 234)">
		<rect width="20" height="20" rx="3" fill="#1f3a5f" />
		<text x="10" y="15.5" text-anchor="middle" font-size="15" font-weight="700" fill="#fbf8f3" font-family="Inter, sans-serif">U</text>
	</g>

	<!-- the bakery: striped awning + pretzel -->
	<g transform="translate(228 236)">
		<rect width="24" height="20" rx="2" fill="#fbf8f3" stroke="#1f3a5f" stroke-width="1.2" />
		<path d="M0 0 h24 v6 h-24 z" fill="#c9683b" stroke="#1f3a5f" stroke-width="1" />
		<path d="M3 0 v6 M9 0 v6 M15 0 v6 M21 0 v6" stroke="#fbf8f3" stroke-width="2" />
		<path d="M7 16 c -4 -6, 3 -8, 5 -3 c 2 -5, 9 -3, 5 3 M8 12 l 8 4 M16 12 l -8 4" fill="none" stroke="#d9a441" stroke-width="2" stroke-linecap="round" />
	</g>

	<!-- the TV tower beyond the river -->
	<g transform="translate(228 8)" stroke="#1f3a5f" stroke-width="1.3">
		<path d="M0 -2 v14" />
		<path d="M-2 12 h4 l1 46 h-6 z" fill="#e7dcc6" />
		<circle cx="0" cy="22" r="7" fill="#8fb3c9" />
		<path d="M-7 22 h14" stroke-width="1" />
	</g>

	<!-- labels -->
	{#if streets.length}
		<g class="street-label" font-family="Inter, sans-serif" font-size="9.5" font-weight="600" fill="#1f3a5f" text-anchor="middle">
			{#each streets as s (s.id)}
				<text
					x={s.x}
					y={s.y}
					class:arrived={s.id === showStreet}
					transform={s.rotate ? `rotate(${s.rotate} ${s.x} ${s.y - 3})` : undefined}>{PLACES[s.id].de}</text>
			{/each}
		</g>
	{/if}
	{#if labels}
		<g font-family="Inter, sans-serif" font-size="10" font-weight="700" fill="#1f3a5f" text-anchor="middle">
			<text x="166" y="268" class="halo">Bahnhof</text>
			<text x="200" y="192" class="halo">{station}</text>
			<text x="240" y="268" class="halo">Bäckerei</text>
			<text x="290" y="197" class="halo">Park</text>
			<text x="168" y="98" class="halo">Brücke</text>
			<text x="268" y="74" class="halo">Fernsehturm</text>
		</g>
	{/if}

	<!-- walked trail + Maya's pin -->
	{#if trailPath}
		<path d={trailPath} fill="none" stroke="#c9683b" stroke-width="3" stroke-dasharray="5 5" stroke-linecap="round" />
	{/if}
	{#if pin}
		<g class="pin" style:transform="translate({pin.x}px, {pin.y}px)">
			<path class="facing" d="M0 -19 L6 -11 L-6 -11 Z" fill="#c9683b" stroke="#1f3a5f" stroke-width="1.2" style:transform="rotate({heading}deg)" />
			<circle r="9" fill="#d9a441" stroke="#1f3a5f" stroke-width="2" />
			<circle r="3" fill="#1f3a5f" />
		</g>
	{/if}

	<!-- tap targets (on top, transparent) -->
	{#if tappable}
		{#each Object.entries(PLACES) as [id, p] (id)}
			<circle
				class="hit"
				class:found={found === id}
				class:shake={shake === id}
				cx={p.x}
				cy={p.y}
				r={p.r}
				role="button"
				tabindex="0"
				aria-label={labels || id === found ? p.de : `Place ${Object.keys(PLACES).indexOf(id) + 1}`}
				onclick={(e) => ontap?.(id as PlaceId, e.currentTarget)}
				onkeydown={(e) => (e.key === 'Enter' || e.key === ' ') && ontap?.(id as PlaceId, e.currentTarget)} />
		{/each}
	{/if}
</svg>

<style>
	.kiez {
		width: 100%;
		height: auto;
		display: block;
		border-radius: var(--radius-sm, 10px);
		border: 2px solid #1f3a5f;
		background: #f3ead8;
		touch-action: manipulation;
	}
	.halo {
		paint-order: stroke;
		stroke: #fbf8f3;
		stroke-width: 3.5px;
	}
	.street-label {
		pointer-events: none;
		font-size: 9.4px;
	}
	.street-label .arrived {
		font-size: 11px;
		font-weight: 800;
		fill: #c9683b;
		paint-order: stroke;
		stroke: #fbf8f3;
		stroke-width: 3px;
	}
	.facing {
		transition: transform 400ms ease;
	}
	.pin {
		transition: transform 700ms cubic-bezier(0.45, 0, 0.25, 1);
	}
	.hit {
		fill: transparent;
		stroke: transparent;
		stroke-width: 3;
		cursor: pointer;
		outline: none;
	}
	.hit:hover,
	.hit:focus-visible {
		stroke: #c9683b;
		stroke-dasharray: 4 4;
	}
	.hit.found {
		stroke: #3f7d4f;
		stroke-dasharray: none;
		fill: rgba(63, 125, 79, 0.15);
		animation: ring 900ms ease-out;
	}
	.hit.shake {
		stroke: #b3402a;
		animation: shake 380ms ease;
	}
	@keyframes ring {
		from {
			stroke-width: 10;
		}
	}
	@keyframes shake {
		25% {
			transform: translateX(-3px);
		}
		75% {
			transform: translateX(3px);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.pin,
		.hit.found,
		.hit.shake {
			transition: none;
			animation: none;
		}
	}
	:global(html[data-effects='calm']) .pin {
		transition-duration: 1ms;
	}
</style>
