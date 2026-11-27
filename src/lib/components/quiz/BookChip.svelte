<script lang="ts" module>
	/** What the exercise page offers its panels: where this exercise is in the printed book. */
	export interface BookChipData {
		label: string;
		title: string;
		href: string;
		/** A plain tap asks "new tab or here?"; the page owns that dialog. */
		ask: (e: MouseEvent) => void;
	}
	export const BOOK_CHIP = 'book-chip';
</script>

<script lang="ts">
	// "Book · ch. 3": the small chip every exercise panel carries, which opens
	// the page of the printed book the exercise belongs to (in the book's live
	// preview, at the block it practises). The exercise page puts the data in
	// context, so each panel only has to place the chip; a panel used elsewhere
	// (the pinned-questions practice) has no context and shows nothing.
	import { getContext } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';

	let {
		float = false,
		compact = false
	}: {
		/** Sits at the end of the panel's first line instead of in a row of its own. */
		float?: boolean;
		/** In a row that is full on a phone: there the icon alone, the words kept for a screen reader. */
		compact?: boolean;
	} = $props();

	const source = getContext<{ readonly chip: BookChipData | null } | undefined>(BOOK_CHIP);
	const book = $derived(source?.chip ?? null);
</script>

{#if book}
	<a class="book-chip" class:float class:compact href={book.href} title={book.title} onclick={book.ask}>
		<Icon name="bookClosed" size="1em" />
		<span>{book.label}</span>
	</a>
{/if}

<style>
	.book-chip {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		flex: none;
		padding: 0.25rem 0.6rem;
		border: 1px solid var(--line);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink-muted);
		font-family: var(--font-sans, inherit);
		font-size: 0.72rem;
		font-weight: 700;
		font-style: normal;
		line-height: 1.3;
		letter-spacing: 0.03em;
		text-transform: none;
		text-decoration: none;
		white-space: nowrap;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.book-chip:hover,
	.book-chip:focus-visible {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	.book-chip.float {
		float: inline-end;
		/* In a panel laid out as a column a float does nothing: the end of the row then. */
		align-self: flex-end;
		margin-inline-start: 0.75rem;
		margin-block-end: 0.25rem;
	}

	@media (max-width: 36rem) {
		.book-chip.compact {
			padding: 0.3rem 0.45rem;
		}

		.book-chip.compact span {
			position: absolute;
			width: 1px;
			height: 1px;
			overflow: hidden;
			clip-path: inset(50%);
		}
	}
</style>
