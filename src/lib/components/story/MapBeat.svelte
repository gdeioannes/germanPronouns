<script lang="ts">
	// `map` beats on the Kiez map. Two modes:
	//  - find: Maya names a place (in German), the learner taps it on the map;
	//  - walk: the learner steers Maya's pin with links / rechts / geradeaus,
	//    one junction at a time (the directions are pooled per playthrough).
	import KiezMap from './KiezMap.svelte';
	import type { PlaceId } from './kiez';
	import type { Beat, BeatHost } from './types';

	let { beat, host }: { beat: Beat; host: BeatHost } = $props();

	const station = $derived(host.resolve(`${beat.station ?? ''}`));
	const target = $derived(host.resolve(`${beat.target ?? ''}`) as PlaceId);
	const critical = $derived(beat.critical === true);

	// ---- find
	let found = $state<PlaceId | null>(null);
	let shaking = $state<PlaceId | null>(null);
	function tap(id: PlaceId, el: Element) {
		if (found) return;
		if (id === target) {
			found = id;
			host.sfx('notebook', 0.7);
			if (Array.isArray(beat.entries)) host.note(beat.entries as { de: string; en: string }[]);
			host.right(el);
			return;
		}
		shaking = null;
		queueMicrotask(() => (shaking = id));
		host.wrong(el, critical);
	}

	// ---- walk
	type Walk = { turns: string[]; path: string[] };
	const walk = $derived.by(() => {
		const walks = (beat.walks as Walk[] | undefined) ?? [];
		return walks[host.drawOf(`${beat.walkPool ?? ''}`)] ?? walks[0];
	});
	let step = $state(0);
	let bumped = $state<string | null>(null);
	const DIRECTIONS = ['links', 'geradeaus', 'rechts'];
	function turn(e: MouseEvent, dir: string) {
		if (!walk || step >= walk.turns.length) return;
		if (dir === walk.turns[step]) {
			step += 1;
			bumped = null;
			host.sfx('notebook', 0.5);
			if (step === walk.turns.length) host.right(e.currentTarget as Element);
			return;
		}
		bumped = dir;
		host.wrong(e.currentTarget as Element, critical);
	}
	const arrived = $derived(walk ? step >= walk.turns.length : false);
	const trail = $derived(walk ? walk.path.slice(0, step + 1) : []);
</script>

{#if beat.prompt}<p class="q">{host.resolve(`${beat.prompt}`)}</p>{/if}

{#if beat.mode === 'walk' && walk}
	<KiezMap
		{station}
		labels={beat.labels !== false}
		streetLabels={beat.streetLabels !== false}
		showStreet={arrived ? (host.resolve(`${beat.destination ?? ''}`) as PlaceId) : null}
		walker={trail[trail.length - 1]}
		{trail} />
	{#if !arrived}
		<div class="turns" role="group" aria-label="Which way?">
			{#each DIRECTIONS as d (d)}
				<button class="turn" class:bump={bumped === d} lang="de" onclick={(e) => turn(e, d)}>
					<span class="arrow" aria-hidden="true">{d === 'links' ? '←' : d === 'rechts' ? '→' : '↑'}</span>
					{d}
				</button>
			{/each}
		</div>
		{#if bumped}<p class="maya miss-line">“{host.resolve(`${beat.bumpLine ?? 'Dead end. Wrong turn, partner — what did she say again?'}`)}”</p>{/if}
	{:else}
		{#if beat.reveal}<p class="maya">“{host.resolve(`${beat.reveal}`)}”</p>{/if}
		<button class="btn" onclick={host.done}>Continue</button>
	{/if}
{:else}
	<KiezMap
		{station}
		labels={beat.labels !== false}
		streetLabels={beat.streetLabels !== false}
		{found}
		shake={shaking}
		ontap={tap} />
	{#if found}
		{#if beat.reveal}<p class="maya">“{host.resolve(`${beat.reveal}`)}”</p>{/if}
		<button class="btn" onclick={host.done}>Continue</button>
	{:else if shaking && beat.missLine}
		<p class="maya miss-line">“{host.resolve(`${beat.missLine}`)}”</p>
	{/if}
{/if}

<style>
	.turns {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 0.6rem;
		margin-top: 0.9rem;
	}
	.turn {
		display: grid;
		justify-items: center;
		gap: 0.15rem;
		padding: 0.7rem 0.4rem;
		border: 2px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--heading);
		font-weight: 700;
		font-size: var(--step-0);
		cursor: pointer;
	}
	.turn:hover {
		border-color: var(--accent);
	}
	.turn .arrow {
		font-size: 1.5em;
		line-height: 1;
	}
	.turn.bump {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		animation: bump 360ms ease;
	}
	.miss-line {
		color: var(--ink-muted);
	}
	@keyframes bump {
		25% {
			transform: translateX(-4px);
		}
		75% {
			transform: translateX(4px);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.turn.bump {
			animation: none;
		}
	}
</style>
