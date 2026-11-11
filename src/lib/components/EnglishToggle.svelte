<script lang="ts">
	import { t } from '$lib/i18n/t';
	// Asks for the English of a German explanation. Separate from what it opens
	// (EnglishPanel), because the button sits beside the rule's heading and the
	// English belongs under the rule's text.
	// No fallback: it binds to a key of a record, which starts out undefined.
	let { open = $bindable() }: { open?: boolean } = $props();
</script>

<button type="button" class="toggle" aria-expanded={!!open} onclick={() => (open = !open)}>
	{open ? t('Hide English') : t('English')}
</button>

<style>
	.toggle {
		flex: none;
		padding: 0.1rem 0.65rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: transparent;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		cursor: pointer;
	}
	.toggle:hover {
		color: var(--ink);
		border-color: var(--ink-muted);
	}
</style>
