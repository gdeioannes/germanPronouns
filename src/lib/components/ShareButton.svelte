<script lang="ts">
	// The share button: one tap sends the page on (services/share). On a phone
	// that is the share sheet; elsewhere the link is copied and the button says
	// so for a moment.
	//
	//   <ShareButton where="quiz" />                     a round icon
	//   <ShareButton where="nav" look="tag" … />         the top bar's labelled button
	//   <ShareButton where="quiz_done" look="btn" … />   the site's filled button (ghost: outlined)
	//
	// With no `path` it shares the page it is on; with no `text`, under the
	// page's own title.
	import { t } from '$lib/i18n/t';
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { share, shareLink, type ShareWhere, type SharedScore } from '$lib/services/share';

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
		tone?: 'muted' | 'light';
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
	let copied = $state(false);
	let timer: ReturnType<typeof setTimeout> | undefined;

	async function onclick() {
		const outcome = await share({ where, url: shareLink(where, path, score), text, props });
		if (outcome !== 'copied') return;
		copied = true;
		announce(t('Link copied'));
		clearTimeout(timer);
		timer = setTimeout(() => (copied = false), 2400);
	}
</script>

{#if look === 'icon'}
	<button
		type="button"
		class="icon-btn"
		class:light={tone === 'light'}
		class:copied
		aria-label={words}
		title={copied ? t('Link copied') : words}
		{onclick}
	>
		<Icon name={copied ? 'check' : 'share'} size="1.15em" />
	</button>
{:else}
	<button type="button" class={look === 'btn' ? 'btn' : look === 'ghost' ? 'btn btn-ghost' : look} class:copied {onclick}>
		<Icon name={copied ? 'check' : 'share'} size="1em" />
		<span>{copied ? t('Link copied') : words}</span>
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
	.icon-btn.copied {
		color: var(--right);
	}
	.icon-btn.light {
		color: rgb(255 255 255 / 0.85);
	}
	.icon-btn.light:hover {
		color: #fff;
		background: rgb(255 255 255 / 0.12);
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
		border: 1px solid var(--accent);
		border-radius: 999px;
		background: var(--accent-soft);
		color: var(--accent-ink);
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
		background: var(--accent-ink);
		color: #fff;
	}

	.pill.copied,
	.tag.copied {
		border-color: var(--right);
		color: var(--right);
	}
</style>
