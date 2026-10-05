<script lang="ts">
	// `hotspot` beats: tap the right thing in the scene. Spots are boxes in
	// percent of the image; a spot with `label` gets German text overlaid on
	// the (blank-drawn) prop — a sign, a bell plate, a chalkboard line — so
	// the picture itself carries the word. Spots without a label are hidden
	// zones ("tap der Fernsehturm in the window"). An optional `crop` (percent
	// of the picture) zooms into one part — a bell panel, a sign — so small
	// props stay tappable on a phone; spots keep full-picture coordinates.
	import type { Beat, BeatHost } from './types';

	/** Scene pictures are 1024×585 (16:9 at the generator's output size). */
	const ASPECT = 585 / 1024;

	type Spot = {
		id: string;
		x: number;
		y: number;
		w: number;
		h: number;
		label?: string;
		style?: string;
		/** Maya's reaction when THIS wrong spot is tapped (else beat.missLine). */
		miss?: string;
	};
	let { beat, host }: { beat: Beat; host: BeatHost } = $props();

	const spots = $derived((beat.spots as Spot[]) ?? []);
	const answer = $derived(host.resolve(`${beat.answer ?? ''}`));
	const sceneImg = (key: string) => `/${key.replace('story/', 'img/story/')}.webp`;
	const crop = $derived((beat.crop as { x: number; y: number; w: number; h: number }) ?? { x: 0, y: 0, w: 100, h: 100 });
	/** Full-picture percent → percent of the (cropped) frame. */
	const fx = (v: number) => ((v - crop.x) / crop.w) * 100;
	const fy = (v: number) => ((v - crop.y) / crop.h) * 100;

	let found = $state(false);
	let wrongId = $state<string | null>(null);
	const missText = $derived(spots.find((s) => s.id === wrongId)?.miss ?? beat.missLine);
	let tries = $state(0);
	function tap(e: MouseEvent, s: Spot) {
		if (found) return;
		if (s.id === answer) {
			found = true;
			host.sfx(`${beat.sound ?? 'notebook'}`, 0.8);
			if (Array.isArray(beat.entries)) host.note(beat.entries as { de: string; en: string }[]);
			host.right(e.currentTarget as Element);
			return;
		}
		tries += 1;
		wrongId = null;
		queueMicrotask(() => (wrongId = s.id));
		host.wrong(e.currentTarget as Element, beat.critical === true);
	}
	// After two misses on a hidden zone, the target starts to glow — finding
	// it is the fun, not the frustration.
	const hint = $derived(!found && tries >= 2);
</script>

{#if beat.prompt}<p class="q">{host.resolve(`${beat.prompt}`)}</p>{/if}
{#if beat.note}
	<!-- A handwritten note to read before tapping (the German is the clue). -->
	<p class="paper" lang="de">{host.resolve(`${beat.note}`)}</p>
{/if}

<div class="hot" class:found style:padding-top="{(crop.h / crop.w) * ASPECT * 100}%">
	<img
		class="hot-img"
		src={sceneImg(`${beat.image}`)}
		alt={host.resolve(`${beat.alt ?? ''}`)}
		style:width="{(100 / crop.w) * 100}%"
		style:left="{fx(0)}%"
		style:top="{fy(0)}%" />
	{#each spots as s (s.id)}
		<button
			class="spot {s.style ?? (s.label ? 'sign' : 'zone')}"
			class:right={found && s.id === answer}
			class:wrong={wrongId === s.id}
			class:hint={hint && s.id === answer}
			style:left="{fx(s.x)}%"
			style:top="{fy(s.y)}%"
			style:width="{(s.w / crop.w) * 100}%"
			style:height="{(s.h / crop.h) * 100}%"
			lang={s.label ? 'de' : undefined}
			aria-label={s.label ? host.resolve(s.label) : `Spot ${spots.indexOf(s) + 1}`}
			onclick={(e) => tap(e, s)}>
			{#if s.label}<span>{host.resolve(s.label)}</span>{/if}
		</button>
	{/each}
</div>

{#if found}
	{#if beat.reveal}<p class="maya">“{host.resolve(`${beat.reveal}`)}”</p>{/if}
	<button class="btn" onclick={host.done}>Continue</button>
{:else if wrongId && missText}
	<p class="maya miss-line">“{host.resolve(`${missText}`)}”</p>
{/if}

<style>
	.hot {
		position: relative;
		width: 100%;
		height: 0;
		overflow: hidden;
		border-radius: var(--radius-sm);
		box-shadow: 0 8px 24px rgb(31 58 95 / 0.12);
		margin: 0 0 0.75rem;
		/* label text scales with the picture, not the screen */
		container-type: inline-size;
	}
	.hot-img {
		position: absolute;
		display: block;
		max-width: none;
		height: auto;
	}
	.spot {
		position: absolute;
		display: grid;
		place-items: center;
		padding: 0;
		cursor: pointer;
		border: 2px solid transparent;
		background: transparent;
		border-radius: 6px;
		font-family: Inter, sans-serif;
		font-weight: 700;
		line-height: 1.05;
		transition: transform 120ms ease, box-shadow 160ms ease;
	}
	.spot span {
		font-size: clamp(0.6rem, 3.1cqw, 1.05rem);
		padding: 0 0.2em;
	}
	/* A blank hanging sign / platform sign: navy board, cream letters. */
	.spot.sign {
		background: #1f3a5f;
		color: #fbf8f3;
		border-color: #fbf8f3;
		box-shadow: 0 1px 0 #0b1a2d;
	}
	/* A brass bell plate. */
	.spot.plate {
		background: #efe3c2;
		color: #1f3a5f;
		border-color: #a07d32;
		font-family: 'Source Serif 4 Variable', Georgia, serif;
		font-weight: 600;
	}
	/* A white enamel house-number plate. */
	.spot.enamel {
		background: #fbfaf6;
		color: #1f3a5f;
		border-color: #1f3a5f;
		border-radius: 50%;
		font-size: 1.2em;
		font-weight: 800;
	}
	/* Chalk on a blackboard. */
	.spot.chalk {
		background: rgba(32, 44, 40, 0.88);
		color: #f4f1e8;
		border-color: transparent;
		font-family: 'Comic Sans MS', 'Segoe Print', cursive;
		font-weight: 400;
	}
	.spot:hover,
	.spot:focus-visible {
		transform: scale(1.04);
		outline: none;
		box-shadow: 0 0 0 3px var(--accent);
	}
	.spot.zone:hover,
	.spot.zone:focus-visible {
		box-shadow: 0 0 0 3px rgba(201, 104, 59, 0.6);
	}
	.spot.right {
		box-shadow: 0 0 0 4px #3f7d4f;
		animation: pop 500ms ease;
	}
	.spot.wrong {
		box-shadow: 0 0 0 3px var(--wrong);
		animation: shake 360ms ease;
	}
	.spot.hint {
		animation: glow 1.4s ease-in-out infinite;
	}
	.paper {
		background: #fffaf0 repeating-linear-gradient(transparent 0 1.55em, rgb(143 179 201 / 0.45) 1.55em calc(1.55em + 1px));
		border: 1px solid #e3d6bd;
		border-left: 3px solid rgb(201 104 59 / 0.5);
		border-radius: 4px;
		box-shadow: 0 6px 16px rgb(31 58 95 / 0.12);
		padding: 0.6rem 1rem 0.5rem;
		margin: 0 0 0.75rem;
		width: 100%;
		white-space: pre-line;
		line-height: 1.55em;
		font-family: 'Segoe Print', 'Bradley Hand', 'Comic Sans MS', cursive;
		color: #1f3a5f;
		transform: rotate(-0.6deg);
	}
	.miss-line {
		color: var(--ink-muted);
	}
	@keyframes pop {
		40% {
			transform: scale(1.12);
		}
	}
	@keyframes shake {
		25% {
			transform: translateX(-4px);
		}
		75% {
			transform: translateX(4px);
		}
	}
	@keyframes glow {
		50% {
			box-shadow: 0 0 0 5px rgba(217, 164, 65, 0.85);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.spot.right,
		.spot.wrong,
		.spot.hint {
			animation: none;
		}
	}
</style>
