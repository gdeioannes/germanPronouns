<script lang="ts">
	// "Know someone who is learning German?" for the grammar charts: the same
	// tinted send-it-on card as the book download panel (FeedbackCard), with a
	// WhatsApp button and the share button. Used at the top of /charts and
	// beside the feedback stars on a chart's own page.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import ShareButton from '$lib/components/ShareButton.svelte';
	import { shareLink, trackShare, whatsappLink } from '$lib/services/share';

	let {
		path,
		code,
		text
	}: {
		/** The page to send, e.g. "/charts/imperative". */
		path: string;
		/** A short tag for analytics, e.g. "chart-imperative". */
		code: string;
		/** The line sent with the link. */
		text: string;
	} = $props();

	// The link needs the page's origin, so it is made in the browser.
	let wa = $state('#');
	onMount(() => (wa = whatsappLink(text, shareLink('chart', path))));
</script>

<div class="send-on">
	<p class="send-on-q">Know someone who is learning German?</p>
	<div class="row">
		<a class="btn wa" href={wa} target="_blank" rel="noopener" onclick={() => trackShare('chart', 'whatsapp', { code })}>
			<Icon name="chat" size="1em" /> WhatsApp
		</a>
		<ShareButton where="chart" look="ghost" label="Share" {text} {path} props={{ code }} />
	</div>
</div>

<style>
	.send-on {
		display: flex;
		flex-direction: column;
		justify-content: center;
		gap: 0.7rem;
		padding: 1rem 1.1rem 1.1rem;
		border-radius: calc(var(--radius) + 4px);
		background: var(--accent-soft);
		min-width: 0;
	}
	.send-on-q {
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 1.2rem;
		font-weight: 600;
		line-height: 1.25;
		color: var(--heading);
	}
	.row {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}
	.row > :global(*) {
		flex: 1 1 8rem;
	}
	/* The green of WhatsApp, with dark text: white on it is too faint to read. */
	.wa {
		background: #25d366;
		color: #06301f;
	}
</style>
