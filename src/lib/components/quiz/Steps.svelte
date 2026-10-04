<script lang="ts" module>
	export type StepMark = 'done' | 'right' | 'wrong' | null;
</script>

<script lang="ts">
	// A quiz cut into sections that fit one screen each: the passage in pages,
	// then one question at a time, then the check. One section shows; the
	// others wait to its left and right, so moving on slides the current one
	// out and the next one in from the side it was waiting on — back slides
	// the other way, and the direction is never computed, only laid out.
	//
	// Every section stays in the DOM (hidden and inert when not current): the
	// page is prerendered, and questions a crawler cannot see do not exist.
	//
	// Move with the arrows under the stage, the numbered dots, the arrow keys
	// (unless typing), or a horizontal swipe.
	import Icon from '$lib/icons/Icon.svelte';
	import { inDialog } from './keys';
	import { tick, type Snippet } from 'svelte';

	let {
		count,
		index = $bindable(0),
		labels = [],
		marks = [],
		step
	}: {
		count: number;
		index?: number;
		/** What each section is, for the counter and the dots' tooltips. */
		labels?: string[];
		/** Colours a dot: answered, or right/wrong once checked. */
		marks?: StepMark[];
		step: Snippet<[number]>;
	} = $props();

	let viewport = $state<HTMLElement>();

	function go(to: number) {
		index = Math.max(0, Math.min(count - 1, to));
	}

	// Fewer sections than before (a text re-paged to a bigger screen): never
	// point past the end.
	$effect(() => {
		if (index > count - 1) index = Math.max(0, count - 1);
	});

	// A new section starts at its top, whatever the last visit scrolled to.
	$effect(() => {
		index;
		viewport?.querySelector<HTMLElement>(`[data-step="${index}"]`)?.scrollTo({ top: 0 });
	});

	// Focus that sat inside the section just left (its "Continue" button, an
	// option that auto-advanced) would fall to <body> when that section goes
	// inert. Hand it to the new section instead, so a keyboard user carries
	// on from there and a screen reader reads where they arrived.
	let shown = -1;
	$effect(() => {
		const now = index;
		if (shown === -1 || shown === now) {
			shown = now;
			return;
		}
		const left = viewport?.querySelector<HTMLElement>(`[data-step="${shown}"]`);
		shown = now;
		const active = document.activeElement;
		const stranded = !active || active === document.body || (!!left && left.contains(active));
		if (!stranded) return;
		void tick().then(() => {
			const current = viewport?.querySelector<HTMLElement>(`[data-step="${now}"]`);
			// Something in the new section may already have taken focus itself.
			if (!current || current.contains(document.activeElement)) return;
			current.focus({ preventScroll: true });
		});
	});

	function typing(target: EventTarget | null): boolean {
		const el = target as HTMLElement | null;
		return !!el && (el.isContentEditable || ['INPUT', 'TEXTAREA', 'SELECT'].includes(el.tagName));
	}

	function onKey(event: KeyboardEvent) {
		if (event.altKey || event.ctrlKey || event.metaKey || typing(event.target)) return;
		if (inDialog(event.target)) return;
		// Parked off screen (the lesson while the exercise runs, or the other
		// way round): its sections are not the ones the arrows should move.
		if (viewport?.closest('[inert]')) return;
		if (event.key === 'ArrowRight') go(index + 1);
		else if (event.key === 'ArrowLeft') go(index - 1);
		else return;
		event.preventDefault();
	}

	// ---- swipe -------------------------------------------------------------
	let startX = 0;
	let startY = 0;
	let tracking = false;

	function onPointerDown(event: PointerEvent) {
		if (event.pointerType === 'mouse' || typing(event.target)) return;
		tracking = true;
		startX = event.clientX;
		startY = event.clientY;
	}

	function onPointerUp(event: PointerEvent) {
		if (!tracking) return;
		tracking = false;
		const dx = event.clientX - startX;
		const dy = event.clientY - startY;
		// Clearly sideways and far enough — a scroll or a tap never counts.
		if (Math.abs(dx) < 60 || Math.abs(dx) < Math.abs(dy) * 1.5) return;
		go(index + (dx < 0 ? 1 : -1));
	}
</script>

<svelte:window onkeydown={onKey} />

<div class="steps">
	<div
		class="viewport"
		bind:this={viewport}
		onpointerdown={onPointerDown}
		onpointerup={onPointerUp}
		onpointercancel={() => (tracking = false)}
		role="group"
		aria-roledescription="carousel"
		aria-label="Exercise sections"
	>
		{#each { length: count } as _, i (i)}
			<section
				class="step"
				class:before={i < index}
				class:after={i > index}
				data-step={i}
				data-focus-target
				tabindex="-1"
				inert={i !== index}
				aria-hidden={i !== index}
				aria-roledescription="slide"
				aria-label="{i + 1} of {count}{labels[i] ? `: ${labels[i]}` : ''}"
			>
				{@render step(i)}
			</section>
		{/each}
	</div>

	<nav class="rail" aria-label="Sections">
		<button type="button" class="arrow" onclick={() => go(index - 1)} disabled={index === 0} aria-label="Previous section">
			<Icon name="arrowLeft" size="1.1em" />
		</button>

		<div class="middle">
			<span class="counter tnum">
				<strong>{index + 1}</strong> / {count}{#if labels[index]}<span class="label">{` · ${labels[index]}`}</span>{/if}
			</span>
			<div class="dots">
				{#each { length: count } as _, i (i)}
					<button
						type="button"
						class="dot"
						class:current={i === index}
						data-mark={marks[i] ?? ''}
						onclick={() => go(i)}
						aria-label="Section {i + 1}{labels[i] ? `: ${labels[i]}` : ''}"
						aria-current={i === index ? 'step' : undefined}
						title={labels[i]}
					></button>
				{/each}
			</div>
		</div>

		<button type="button" class="arrow next" onclick={() => go(index + 1)} disabled={index === count - 1} aria-label="Next section">
			<Icon name="arrowRight" size="1.1em" />
		</button>
	</nav>
</div>

<style>
	.steps {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
	}

	/* Every section in the same grid cell: the stage is as tall as the screen
	   gives it, and each section scrolls inside itself only if it must. */
	.viewport {
		flex: 1;
		min-height: 0;
		display: grid;
		grid-template: minmax(0, 1fr) / minmax(0, 1fr);
		overflow: hidden;
		touch-action: pan-y;
	}

	.step {
		grid-area: 1 / 1;
		min-height: 0;
		overflow-y: auto;
		overscroll-behavior: contain;
		display: flex;
		flex-direction: column;
		transition:
			transform var(--slow) var(--ease-out),
			opacity var(--slow) var(--ease-out),
			visibility 0s linear 0s;
	}

	.step.before,
	.step.after {
		visibility: hidden;
		opacity: 0;
		pointer-events: none;
		transition:
			transform var(--slow) var(--ease-out),
			opacity var(--medium) var(--ease-out),
			visibility 0s linear var(--slow);
	}

	.step.before {
		transform: translateX(-2.5rem) scale(0.985);
	}

	.step.after {
		transform: translateX(2.5rem) scale(0.985);
	}

	.rail {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		flex: none;
	}

	.arrow {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.75rem;
		height: 2.75rem;
		flex: none;
		border: 1px solid var(--line-strong);
		border-radius: 50%;
		background: var(--surface);
		color: var(--heading);
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out),
			opacity var(--fast) var(--ease-out);
	}

	.arrow.next {
		border-color: var(--heading);
		background: var(--heading);
		color: var(--paper);
	}

	.arrow:hover:not(:disabled) {
		transform: translateY(-1px);
		border-color: var(--accent);
	}

	.arrow.next:hover:not(:disabled) {
		background: var(--accent);
	}

	.arrow:disabled {
		opacity: 0.3;
		cursor: default;
	}

	.middle {
		flex: 1;
		min-width: 0;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.35rem;
	}

	.counter {
		font-size: var(--step--1);
		color: var(--ink-muted);
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		max-width: 100%;
	}

	.counter strong {
		color: var(--heading);
	}

	.dots {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.3rem;
	}

	/* A pill for the current section, dots for the rest: the counter's
	   number, drawn. */
	.dot {
		width: 0.55rem;
		height: 0.55rem;
		padding: 0;
		border: 0;
		border-radius: 999px;
		background: var(--outline);
		cursor: pointer;
		transition:
			width var(--medium) var(--ease-out),
			background var(--medium) var(--ease-out);
	}

	.dot[data-mark='done'] {
		background: var(--navy);
	}

	.dot[data-mark='right'] {
		background: var(--right);
	}

	.dot[data-mark='wrong'] {
		background: var(--wrong);
	}

	.dot.current {
		width: 1.5rem;
		background: var(--accent);
	}

	@media (max-width: 36rem) {
		.label {
			display: none;
		}
	}
</style>
