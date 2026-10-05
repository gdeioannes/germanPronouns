<script lang="ts">
	// `stops` beats: a U-Bahn ride. Each stop plays its announcement
	// ("Nächster Halt: …"); the learner stays on or gets off. The stops are
	// the pool's variants in a shuffled order (the drawn one never first), so
	// the right stop has to be HEARD — the names stay hidden until passed.
	import Icon from '$lib/icons/Icon.svelte';
	import type { Beat, BeatHost } from './types';

	let { beat, host }: { beat: Beat; host: BeatHost } = $props();

	const pool = $derived(`${beat.pool}`);
	const names = $derived(
		[0, 1, 2].map((i) => host.resolve(i === 0 ? `{pool:${pool}}` : `{pool:${pool}:other${i}}`))
	);
	const drawn = $derived(host.drawOf(pool));
	const n = $derived(names.length);
	/** Near-miss stops that are never ours ("Rosenthaler Platz"), with their own clips. */
	const extras = $derived((beat.extraStops as { name: string; audio: string }[] | undefined) ?? []);
	/** Each stop on this ride: an offset from the drawn variant (0 = ours), or -1-i for extra i. */
	let order = $state<number[]>([]);
	let at = $state(0);
	let passed = $state<string[]>([]);
	let done = $state(false);
	let line = $state<string | null>(null);

	function newRide() {
		// offsets 1..n-1 shuffled, the drawn stop (offset 0) somewhere after the first
		const others = [
			...Array.from({ length: n - 1 }, (_, i) => i + 1),
			...extras.map((_, i) => -1 - i)
		].sort(() => Math.random() - 0.5);
		const slot = 1 + Math.floor(Math.random() * others.length);
		order = [...others.slice(0, slot), 0, ...others.slice(slot)];
		at = 0;
		passed = [];
		announce();
	}
	const nameAt = (k: number) => (order[k] < 0 ? extras[-1 - order[k]].name : names[order[k]]);
	const variantAt = (k: number) => (drawn + order[k]) % n;
	function clipAt(k: number): string {
		if (order[k] < 0) return host.clip(extras[-1 - order[k]].audio);
		const base = `${beat.audio}`.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');
		return `/audio/story/${base}_${variantAt(k)}.mp3`;
	}
	function announce() {
		host.sfx('ubahn_chime', 0.6);
		setTimeout(() => host.play(clipAt(at)), 450);
	}
	$effect(() => {
		if (!order.length) newRide();
	});

	function move() {
		passed = [...passed, nameAt(at)];
		if (at + 1 < order.length) {
			at += 1;
			announce();
		} else newRide();
	}
	function getOff(e: MouseEvent) {
		if (order[at] === 0) {
			done = true;
			line = null;
			if (Array.isArray(beat.entries)) host.note(beat.entries as { de: string; en: string }[]);
			passed = [...passed, nameAt(at)];
			host.right(e.currentTarget as Element);
			return;
		}
		line = host.resolve(`${beat.wrongExitLine ?? 'Wrong stop! Back on, back on —'}`);
		host.wrong(e.currentTarget as Element, beat.critical === true);
		move();
	}
	function stay(e: MouseEvent) {
		if (order[at] === 0) {
			line = host.resolve(`${beat.missedLine ?? 'Wait — was that OURS? The doors are closing…'}`);
			host.wrong(e.currentTarget as Element, beat.critical === true);
			// Round the loop: the line runs back past the stop.
			setTimeout(newRide, 900);
			return;
		}
		line = null;
		move();
	}
</script>

{#if beat.prompt}<p class="q">{host.resolve(`${beat.prompt}`)}</p>{/if}

<ol class="line" aria-label="Stops on this ride">
	{#each order as _, k (k)}
		<li class:now={k === at && !done} class:gone={k < at || (done && k <= at)}>
			<span class="dot" aria-hidden="true"></span>
			<span class="name" lang="de">{k < at || (done && k === at) ? nameAt(k) : '?'}</span>
		</li>
	{/each}
</ol>

{#if !done}
	<div class="announce">
		<button class="chip" onclick={() => host.play(clipAt(at))}>
			<Icon name="volume" size="0.95em" /> Play the announcement
		</button>
	</div>
	<div class="choice">
		<button class="stop-btn" onclick={stay}>Stay on</button>
		<button class="stop-btn off" onclick={getOff}>Get off here!</button>
	</div>
	{#if line}<p class="maya banter-reply">“{line}”</p>{/if}
{:else}
	{#if beat.reveal}<p class="maya">“{host.resolve(`${beat.reveal}`)}”</p>{/if}
	<button class="btn" onclick={host.done}>Continue</button>
{/if}

<style>
	.line {
		list-style: none;
		display: flex;
		gap: 0;
		padding: 0.8rem 0 0.4rem;
		margin: 0;
		position: relative;
		width: 100%;
	}
	.line::before {
		content: '';
		position: absolute;
		left: 1rem;
		right: 1rem;
		top: calc(0.8rem + 0.55rem);
		height: 4px;
		background: #d9a441;
		border-radius: 2px;
	}
	.line li {
		flex: 1;
		min-width: 0;
		display: grid;
		justify-items: center;
		gap: 0.35rem;
		position: relative;
	}
	.dot {
		width: 1.1rem;
		height: 1.1rem;
		border-radius: 50%;
		background: var(--surface);
		border: 3px solid #1f3a5f;
		transition: transform 200ms ease, background 200ms ease;
	}
	.now .dot {
		background: #d9a441;
		transform: scale(1.35);
		animation: blink 1.2s ease-in-out infinite;
	}
	.gone .dot {
		background: #1f3a5f;
	}
	.name {
		font-weight: 700;
		color: var(--heading);
		font-size: 0.72rem;
		line-height: 1.15;
		text-align: center;
		overflow-wrap: anywhere;
		hyphens: auto;
		min-height: 1.3em;
	}
	.announce {
		margin-top: 0.4rem;
	}
	.choice {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.6rem;
		width: 100%;
	}
	.stop-btn {
		padding: 0.8rem 0.6rem;
		border: 1.5px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--heading);
		font-size: var(--step-0);
		font-weight: 600;
		cursor: pointer;
		box-shadow: 0 2px 6px rgb(31 58 95 / 0.06);
		transition: transform 120ms ease, border-color 120ms ease;
	}
	.stop-btn:hover {
		border-color: var(--accent);
		transform: translateY(-1px);
	}
	.stop-btn.off {
		font-weight: 800;
		border-color: #d9a441;
		background: #fbf1dc;
		color: #1f2a3a;
	}
	@keyframes blink {
		50% {
			box-shadow: 0 0 0 6px rgba(217, 164, 65, 0.35);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.now .dot {
			animation: none;
		}
	}
</style>
