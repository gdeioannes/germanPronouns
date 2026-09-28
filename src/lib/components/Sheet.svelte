<script lang="ts">
	// A panel that slides in front of the page: from the right on a laptop, up
	// from the bottom on a phone. It is how the quiz page keeps everything that
	// is not the exercise — study notes, links onward — one tap away without
	// taking a pixel of the exercise's screen.
	//
	// Always in the DOM, hidden by CSS when closed rather than removed: what it
	// holds (the explanation, the links to the neighbours) is some of the most
	// useful text on the page, and a prerendered page that left it out would
	// show search engines an empty exercise. Closed, it is `inert`, so it takes
	// no focus and no clicks.
	import Icon from '$lib/icons/Icon.svelte';
	import type { Snippet } from 'svelte';

	let {
		open = $bindable(false),
		title,
		id,
		children,
		footer
	}: {
		open?: boolean;
		title: string;
		id: string;
		children: Snippet;
		/** Pinned under the scrolling body — the panel's way back out. */
		footer?: Snippet;
	} = $props();

	let panel = $state<HTMLElement>();
	/** Where focus was before the panel opened, so closing hands it back. */
	let returnFocus: HTMLElement | null = null;

	$effect(() => {
		if (!open || !panel) return;
		returnFocus = document.activeElement as HTMLElement | null;
		panel.focus({ preventScroll: true });
		return () => returnFocus?.focus({ preventScroll: true });
	});

	function onKey(event: KeyboardEvent) {
		if (open && event.key === 'Escape') {
			event.stopPropagation();
			open = false;
		}
	}
</script>

<svelte:window onkeydown={onKey} />

<div class="sheet" class:open inert={!open}>
	<button
		type="button"
		class="scrim"
		tabindex="-1"
		aria-label="Close {title}"
		onclick={() => (open = false)}
	></button>
	<div
		class="panel"
		{id}
		role="dialog"
		aria-modal="true"
		aria-labelledby="{id}-title"
		tabindex="-1"
		bind:this={panel}
	>
		<header class="bar">
			<span class="grip" aria-hidden="true"></span>
			<h2 id="{id}-title">{title}</h2>
			<button type="button" class="close" aria-label="Close" onclick={() => (open = false)}>
				<Icon name="close" size="1.1em" />
			</button>
		</header>
		<div class="body">
			{@render children()}
		</div>
		{#if footer}
			<footer class="foot">{@render footer()}</footer>
		{/if}
	</div>
</div>

<style>
	.sheet {
		position: fixed;
		inset: 0;
		z-index: 100;
		visibility: hidden;
		/* Stay visible until the slide-out has finished. */
		transition: visibility 0s linear var(--slow);
	}

	.sheet.open {
		visibility: visible;
		transition: none;
	}

	.scrim {
		position: absolute;
		inset: 0;
		border: 0;
		padding: 0;
		background: rgb(20 32 52 / 0.38);
		opacity: 0;
		cursor: default;
		transition: opacity var(--slow) var(--ease-out);
	}

	.open .scrim {
		opacity: 1;
	}

	/* A laptop: a tall column on the right, the exercise still visible (dimmed)
	   beside it, so the notes read as a reference held up next to the work. */
	.panel {
		position: absolute;
		top: 0;
		right: 0;
		bottom: 0;
		display: flex;
		flex-direction: column;
		width: min(34rem, 100%);
		background: var(--surface);
		box-shadow: -18px 0 48px -24px rgb(20 32 52 / 0.45);
		transform: translateX(104%);
		transition: transform var(--slow) var(--ease-out);
		outline: none;
	}

	.open .panel {
		transform: none;
	}

	.bar {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 0.85rem 1rem 0.85rem 1.25rem;
		border-bottom: 1px solid var(--line);
	}

	.grip {
		display: none;
	}

	h2 {
		flex: 1;
		margin: 0;
		font-size: var(--step-1);
	}

	.close {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.4rem;
		height: 2.4rem;
		border: 1px solid var(--line);
		border-radius: 50%;
		background: var(--surface);
		color: var(--ink);
		cursor: pointer;
		transition: border-color var(--fast) var(--ease-out);
	}

	.close:hover {
		border-color: var(--accent);
		color: var(--accent);
	}

	.body {
		flex: 1;
		min-height: 0;
		overflow-y: auto;
		overscroll-behavior: contain;
		padding: 1rem 1.25rem 1.5rem;
	}

	.foot {
		padding: 0.75rem 1.25rem calc(0.75rem + env(safe-area-inset-bottom));
		border-top: 1px solid var(--line);
		background: var(--surface);
	}

	/* A phone: a sheet rising from the bottom edge, with a grip to say so. */
	@media (max-width: 36rem) {
		.panel {
			top: auto;
			left: 0;
			width: 100%;
			max-height: 92dvh;
			border-radius: 18px 18px 0 0;
			box-shadow: 0 -18px 48px -24px rgb(20 32 52 / 0.45);
			transform: translateY(104%);
		}

		.bar {
			position: relative;
			padding-top: 1.1rem;
		}

		.grip {
			display: block;
			position: absolute;
			top: 0.45rem;
			left: 50%;
			width: 2.6rem;
			height: 0.3rem;
			margin-left: -1.3rem;
			border-radius: 999px;
			background: var(--line-strong);
		}
	}
</style>
