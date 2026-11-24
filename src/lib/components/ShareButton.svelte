<script lang="ts">
	// The share button: one tap opens the share panel (SharePanel, mounted in
	// the root layout) with the message and the ways to send it.
	//
	//   <ShareButton where="quiz" />                     a round icon (tone="accent": tinted)
	//   <ShareButton where="nav" look="tag" … />         the top bar's labelled button
	//   <ShareButton where="quiz_done" look="btn" … />   the site's filled button (ghost: outlined)
	//
	// With no `path` it shares the page it is on; with no `text`, under the
	// page's own title.
	import { t } from '$lib/i18n/t';
	import Icon from '$lib/icons/Icon.svelte';
	import { openShare } from '$lib/state/sharePanel.svelte';
	import type { ShareWhere, SharedScore } from '$lib/services/share';

	let {
		where,
		look = 'icon',
		tone = 'muted',
		label,
		text,
		path,
		score = null,
		props
	}: {
		where: ShareWhere;
		look?: 'icon' | 'pill' | 'tag' | 'btn' | 'ghost';
		/** For the icon: grey, white (on a dark bar), or tinted so it stands out in a full row. */
		tone?: 'muted' | 'light' | 'accent';
		/** The words on (or, for the icon, read out for) the button. */
		label?: string;
		/** A line to send with the link. */
		text?: string;
		/** The page to share, when it is not this one. */
		path?: string;
		/** A score to carry in the link ("a friend got 9 of 10"). */
		score?: SharedScore | null;
		/** Extra analytics properties for the tap. */
		props?: Record<string, string | number>;
	} = $props();

	const words = $derived(label ?? t('Share this page'));

	function onclick() {
		openShare({ where, path, text, score, props });
	}
</script>

{#if look === 'icon'}
	<button type="button" class="icon-btn" class:light={tone === 'light'} class:accent={tone === 'accent'} aria-label={words} title={words} {onclick}>
		<Icon name="share" size="1.15em" />
	</button>
{:else}
	<button type="button" class={look === 'btn' || look === 'ghost' ? 'btn btn-share' : look} {onclick}>
		<Icon name="share" size="1em" />
		<span>{words}</span>
	</button>
{/if}

<style>
	.icon-btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		padding: 0;
		border: 0;
		border-radius: 50%;
		background: transparent;
		color: var(--ink-muted);
		cursor: pointer;
		transition:
			color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}
	.icon-btn:hover {
		color: var(--heading);
		background: var(--surface-alt);
	}
	.icon-btn.light {
		color: rgb(255 255 255 / 0.85);
	}
	.icon-btn.light:hover {
		color: #fff;
		background: rgb(255 255 255 / 0.12);
	}

	/* Icon only, where a labelled button would crowd the row: the same square
	   as the quiz header's tools beside it (2.5rem, 6px corners), but the one
	   filled one, with a ring that spreads out from it three times when the
	   page opens. */
	.icon-btn.accent {
		width: 2.5rem;
		height: 2.5rem;
		font-size: 1.1rem;
		border: 1px solid var(--share-strong);
		border-radius: 6px;
		background: var(--share);
		color: var(--share-ink);
		animation: ring 1.8s var(--ease-out) 0.8s 3;
	}
	.icon-btn.accent:hover {
		background: var(--share-strong);
		color: var(--share-ink);
		transform: translateY(-1px);
	}
	@keyframes ring {
		from {
			box-shadow: 0 0 0 0 rgb(245 196 67 / 0.8);
		}
		to {
			box-shadow: 0 0 0 0.9rem rgb(245 196 67 / 0);
		}
	}
	@media (max-width: 36rem) {
		.icon-btn.accent {
			width: 2.35rem;
			height: 2.35rem;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.icon-btn.accent {
			animation: none;
		}
	}

	.pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.4rem;
		min-height: 2.75rem;
		padding: 0 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}
	.pill:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	/* The top bar's button: the one tinted thing in a row of grey icons, so
	   it is seen without being looked for. */
	.tag {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		height: 2.2rem;
		padding: 0 0.8rem;
		border: 1px solid var(--share-strong);
		border-radius: 999px;
		background: var(--share);
		color: var(--share-ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		white-space: nowrap;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}
	.tag:hover {
		background: var(--share-strong);
	}
</style>
