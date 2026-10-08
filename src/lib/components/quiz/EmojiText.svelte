<script lang="ts">
	// A German line with its helper emojis (domain/emojiText). The emojis are
	// hidden from screen readers, which read the German as written.
	import { emojiSegments } from '$lib/domain/emojiText';

	let { text, lang }: { text: string; lang: string } = $props();

	const segments = $derived(emojiSegments(text));
</script>

<span {lang}
	>{#each segments as s, i (i)}{#if s.kind === 'text'}{s.text}{:else}<span class="emoji" aria-hidden="true"
				>&#32;{s.emoji}</span
			>{/if}{/each}</span
>

<style>
	.emoji {
		font-style: normal;
	}
</style>
