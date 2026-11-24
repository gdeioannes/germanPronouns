<script lang="ts">
	// A one-time tip in the corner (bottom of the screen on a phone). It never
	// takes focus, so Enter keeps doing what the exercise expects, and it never
	// closes by itself: a tip shown while the learner reads a correction would
	// be gone before they looked. The live region is always in the page, so a
	// screen reader hears the tip politely, after whatever is being said.
	import Icon from '$lib/icons/Icon.svelte';
	import { t } from '$lib/i18n/t';
	import { fly } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import { prefersReducedMotion } from '$lib/motion';

	let {
		open,
		title,
		text,
		actionLabel,
		actionHref,
		ondismiss
	}: {
		open: boolean;
		title: string;
		text: string;
		actionLabel?: string;
		actionHref?: string;
		/** Closing and taking the action both end here: the tip is done. */
		ondismiss: () => void;
	} = $props();

	function onKey(event: KeyboardEvent) {
		if (open && event.key === 'Escape' && !event.defaultPrevented) ondismiss();
	}
</script>

<svelte:window onkeydown={onKey} />

<div class="live" aria-live="polite">
	{#if open}
		<aside
			class="tip"
			aria-label={title}
			transition:fly={{ y: prefersReducedMotion() ? 0 : 24, duration: 260, easing: cubicOut }}
		>
			<Icon name="info" size="1.2em" />
			<div class="body">
				<strong>{title}</strong>
				<p>{text}</p>
				<div class="actions">
					{#if actionLabel && actionHref}
						<a class="action" href={actionHref} onclick={ondismiss}>{actionLabel}</a>
					{/if}
					<button type="button" class="ok" onclick={ondismiss}>{t('Got it')}</button>
				</div>
			</div>
			<button type="button" class="close" aria-label={t('Close')} onclick={ondismiss}>
				<Icon name="close" size="1em" />
			</button>
		</aside>
	{/if}
</div>

<style>
	.live {
		position: fixed;
		inset-inline-end: 1rem;
		inset-block-end: calc(1rem + env(safe-area-inset-bottom));
		z-index: 60;
		width: min(22rem, calc(100vw - 2rem));
		pointer-events: none;
	}

	.tip {
		pointer-events: auto;
		display: flex;
		gap: 0.65rem;
		align-items: flex-start;
		padding: 0.9rem 0.9rem 0.9rem 1rem;
		border: 1px solid var(--line-strong);
		border-inline-start: 4px solid var(--accent);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink);
		box-shadow: 0 10px 30px rgb(0 0 0 / 0.14);
	}

	.tip > :global(svg) {
		flex: none;
		margin-top: 0.1rem;
		color: var(--accent-ink);
	}

	.body {
		flex: 1;
		min-width: 0;
	}

	.body p {
		margin: 0.25rem 0 0.6rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}

	.action,
	.ok {
		padding: 0.35rem 0.8rem;
		border-radius: var(--radius-sm);
		font: inherit;
		font-size: var(--step--1);
		cursor: pointer;
		text-decoration: none;
	}

	.action {
		border: 1px solid var(--accent-ink);
		background: var(--accent-ink);
		color: #fff;
	}

	.ok {
		border: 1px solid var(--line-strong);
		background: none;
		color: var(--ink);
	}

	.close {
		flex: none;
		display: grid;
		place-items: center;
		width: 1.9rem;
		height: 1.9rem;
		margin: -0.35rem -0.35rem 0 0;
		border: 0;
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.close:hover,
	.ok:hover {
		background: var(--surface-alt);
	}

	/* A phone: across the top, so it never covers the Next button below. */
	@media (max-width: 34rem) {
		.live {
			inset-inline: 0.75rem;
			inset-block: calc(0.6rem + env(safe-area-inset-top)) auto;
			width: auto;
		}
	}
</style>
