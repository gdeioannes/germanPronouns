<script lang="ts">
	// The ask: a dark band with a two-line German chat poking out of its top
	// edge, the sentence, and two ways on: WhatsApp straight away, or the share
	// panel with the rest. Set early on a page (the books, before the list) and
	// at the end of every page (SiteFooter).
	import { t } from '$lib/i18n/t';
	import Icon from '$lib/icons/Icon.svelte';
	import { openShare } from '$lib/state/sharePanel.svelte';
	import { shareLink, trackShare, whatsappLink, type ShareWhere } from '$lib/services/share';

	let {
		where,
		text,
		path
	}: {
		where: ShareWhere;
		/** A line to send with the link. */
		text?: string;
		/** The page to share, when it is not this one. */
		path?: string;
	} = $props();

	// Built on the tap: the address and the title are only known in the browser.
	function whatsapp() {
		trackShare(where, 'whatsapp');
		window.open(whatsappLink(text ?? document.title, shareLink(where, path)), '_blank', 'noopener');
	}
</script>

<aside class="nudge">
	<!-- Decoration: what passing it on looks like, in two lines of German. -->
	<div class="talk" aria-hidden="true" lang="de" dir="ltr">
		<span class="b out">Schau mal: gratis!</span>
		<span class="b in">Oh, danke! <Icon name="heart" size="0.95em" /></span>
	</div>
	<p>{t('If you know a friend who needs this, please share it with them.')}</p>
	<div class="go">
		<button type="button" class="wa" onclick={whatsapp}><Icon name="chat" size="1.1em" /> WhatsApp</button>
		<button type="button" class="more" onclick={() => openShare({ where, path, text })}>
			<Icon name="share" size="1.05em" /> {t('More ways')}
		</button>
	</div>
</aside>

<style>
	.nudge {
		position: relative;
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		align-items: center;
		gap: 1rem 1.6rem;
		/* Room above for the chat that pokes out of the band. */
		margin: 2.4rem 0 0;
		padding: 1.3rem 1.5rem;
		border-radius: 18px;
		background:
			radial-gradient(circle at 96% -30%, rgb(201 104 59 / 0.55) 0 7rem, transparent 7.1rem),
			var(--navy);
		color: #fff;
	}

	/* -- the little chat ---------------------------------------------------- */
	.talk {
		display: flex;
		flex-direction: column;
		gap: 0.3rem;
		width: 10.5rem;
		margin-block: -2.3rem -0.2rem;
		font-size: 0.86rem;
		font-weight: 700;
		line-height: 1.2;
	}

	.b {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		width: fit-content;
		padding: 0.5rem 0.75rem;
		border-radius: 14px;
		box-shadow: 0 6px 14px -6px rgb(0 0 0 / 0.5);
		animation: pop var(--slow) var(--ease-spring) both;
	}

	.out {
		align-self: flex-end;
		border-end-end-radius: 3px;
		background: var(--share);
		color: var(--share-ink);
		transform: rotate(-3deg);
	}

	.in {
		border-end-start-radius: 3px;
		background: #fbf5e4;
		color: var(--navy);
		transform: rotate(2deg);
		animation-delay: 0.5s;
	}

	.in :global(svg) {
		color: var(--terracotta);
	}

	@keyframes pop {
		from {
			opacity: 0;
			scale: 0.6;
			translate: 0 0.6rem;
		}
	}

	/* -- the sentence ------------------------------------------------------- */
	.nudge p {
		margin: 0;
		max-width: 30ch;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 600;
		line-height: 1.25;
		color: #fff;
		text-wrap: balance;
	}

	/* -- the two ways on ---------------------------------------------------- */
	.go {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
	}

	.go button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.45rem;
		min-height: 3rem;
		padding: 0 1.2rem;
		border: 2px solid transparent;
		border-radius: 999px;
		font: inherit;
		font-weight: 700;
		white-space: nowrap;
		cursor: pointer;
		transition: transform var(--medium) var(--ease-spring);
	}

	.go button:hover {
		transform: translateY(-2px) scale(1.04);
	}

	.wa {
		background: #25d366;
		color: #06301f;
	}

	.more {
		background: var(--share);
		color: var(--share-ink);
	}

	/* Narrow: the chat on top, then the sentence, then the buttons side by side. */
	@media (max-width: 52rem) {
		.nudge {
			grid-template-columns: 1fr;
			gap: 0.9rem;
			padding: 1.2rem 1.1rem 1.2rem;
		}
		.nudge p {
			max-width: none;
		}
		.go button {
			flex: 1 1 8rem;
		}
	}

	@media print {
		.nudge {
			display: none;
		}
	}
</style>
