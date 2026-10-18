<script lang="ts">
	// The "?" button: opens a short explanation of the screen it sits on, from
	// content/pageHelp. The top bar shows it for its page; the screens without
	// a top bar (a chat, Ja oder Nein?) put it in their own header. With no
	// entry for the page, nothing renders.
	import Icon from '$lib/icons/Icon.svelte';
	import Sheet from '$lib/components/Sheet.svelte';
	import { PAGE_HELP } from '$lib/content/pageHelp';

	let { topic, tone = 'muted' }: { topic: string | null | undefined; tone?: 'muted' | 'light' } = $props();

	const help = $derived(topic ? PAGE_HELP[topic] : undefined);
	let open = $state(false);
	/** The pictures load the first time the panel opens (they pull in the game rules). */
	const visuals = $derived(open ? import('$lib/components/help/HelpVisual.svelte') : null);

	/**
	 * The panel lives at the end of <body>: the sticky top bar is its own
	 * stacking layer, and a panel left inside it would open behind the page.
	 */
	function toBody(node: HTMLElement) {
		document.body.appendChild(node);
		return { destroy: () => node.remove() };
	}
</script>

{#if help}
	<button
		type="button"
		class="help-btn"
		class:light={tone === 'light'}
		aria-haspopup="dialog"
		aria-controls="page-help"
		aria-label="Help: {help.title}"
		title="How this works"
		onclick={() => (open = true)}
	>
		<Icon name="help" size="1.15em" />
	</button>
	<div use:toBody>
	<Sheet bind:open title={help.title} id="page-help">
		<div class="help">
			<p class="intro">{help.intro}</p>
			{#each help.items as item (item.title)}
				<section>
					<h3>{item.title}</h3>
					<p>{item.text}</p>
					{#if item.visual && visuals}
						{#await visuals then V}<V.default kind={item.visual} />{/await}
					{/if}
					{#if item.list?.length}
						<ul>
							{#each item.list as line (line)}<li>{line}</li>{/each}
						</ul>
					{/if}
				</section>
			{/each}
		</div>
	</Sheet>
	</div>
{/if}

<style>
	.help-btn {
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
		transition: background var(--fast) var(--ease-out);
	}
	.help-btn:hover {
		color: var(--heading);
		background: var(--surface-alt);
	}
	.help-btn.light {
		color: rgb(255 255 255 / 0.85);
	}
	.help-btn.light:hover {
		color: #fff;
		background: rgb(255 255 255 / 0.12);
	}
	.help {
		display: grid;
		gap: 1rem;
	}
	.intro {
		margin: 0;
		font-size: var(--step-0);
		color: var(--ink);
	}
	h3 {
		margin: 0 0 0.25rem;
		font-size: var(--step-0);
		color: var(--heading);
	}
	ul {
		margin: 0.4rem 0 0;
		padding-left: 1.1rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.5;
	}
	li + li {
		margin-top: 0.25rem;
	}
	section p {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.55;
	}
</style>
