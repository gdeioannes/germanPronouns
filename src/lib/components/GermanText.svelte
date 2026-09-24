<script lang="ts">
	// German text with its nouns recognised: coloured by gender, and tappable
	// for the article and the translation.
	//
	// The port of `_highlightNounSpans` and `_showNounInfoDialog` from the Dart
	// quiz_page.dart: tokenise on runs of letters, look each one up (dictionary
	// form or inflected), colour it by gender and open its article and meaning
	// on a tap.
	//
	// Switched off, this renders the sentence as plain text — no colour, no
	// underline, nothing to tap, and the collection is never fetched. Off has to
	// mean the feature is gone, not merely grey: the underlines were still
	// marking up the exercise.
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { nouns } from '$lib/state/nouns.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import type { NounInfo } from '$lib/domain/vocab';

	let { text }: { text: string } = $props();

	// `loaded` guards the first frames: until the setting has been read back
	// from storage the defaults are in force, and a learner who turned word help
	// off would watch it flick on and off again — which reads as "it didn't
	// save". Plain text until we actually know.
	const on = $derived(progress.loaded && progress.wordHelp);

	$effect(() => {
		if (on) nouns.load();
	});

	/** The text as alternating plain runs and recognised nouns. */
	const parts = $derived.by(() => {
		const out: { text: string; info: NounInfo | null }[] = [];
		if (!on) return [{ text, info: null }];
		let last = 0;
		for (const match of text.matchAll(/\p{L}+/gu)) {
			const at = match.index;
			if (at > last) out.push({ text: text.slice(last, at), info: null });
			out.push({ text: match[0], info: nouns.lookup(match[0]) });
			last = at + match[0].length;
		}
		if (last < text.length) out.push({ text: text.slice(last), info: null });
		return out;
	});

	/** Which noun's panel is open, by its position in `parts`. */
	let openAt = $state<number | null>(null);

	function headline(info: NounInfo): string {
		// "der Hund ¨-e" — the article and the plural ending, as the Dart panel
		// showed it. Two notations carry no information for a learner reading a
		// headline: "—" is a noun with no plural, "-" one whose plural is spelt
		// the same. Both print as a bare dash after the word, so neither is shown.
		const ending = info.noun.plural;
		const plural = ending && ending !== '—' && ending !== '-' ? ` ${ending}` : '';
		return `${info.article} ${info.noun.noun}${plural}`;
	}
</script>

{#each parts as part, i (i)}{#if part.info}<span class="noun-wrap"
			><button
				type="button"
				class="noun"
				style="color:{GENDER_COLORS[part.info.noun.gender]}"
				aria-expanded={openAt === i}
				onclick={() => (openAt = openAt === i ? null : i)}
				onblur={() => (openAt = null)}>{part.text}</button
			>{#if openAt === i}
				<span class="panel" role="tooltip">
					<span class="head" style="color:{GENDER_COLORS[part.info.noun.gender]}"
						>{headline(part.info)}</span
					>
					<span class="meaning">{part.info.noun.english}</span>
				</span>
			{/if}</span
		>{:else}{part.text}{/if}{/each}

<style>
	.noun-wrap {
		position: relative;
		display: inline-block;
	}

	/* A button, so it is reachable by keyboard and announced as pressable, but
	   styled as the word it is — nothing about the sentence should look like a
	   form control. */
	.noun {
		padding: 0;
		border: 0;
		background: none;
		font: inherit;
		color: inherit;
		font-weight: 800;
		cursor: pointer;
		border-bottom: 1px dotted currentColor;
	}

	/* The panel is absolutely positioned and centred under the word. It is the
	   one thing here allowed to escape the line box — it is transient, and
	   anchoring it to its noun is the whole point. */
	.panel {
		position: absolute;
		top: calc(100% + 0.3rem);
		left: 50%;
		z-index: 5;
		transform: translateX(-50%);
		display: grid;
		gap: 0.1rem;
		min-width: max-content;
		max-width: 14rem;
		padding: 0.5rem 0.7rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface);
		box-shadow: 0 10px 28px -12px rgba(31, 58, 95, 0.45);
		font-family: 'Inter Variable', 'Inter', sans-serif;
		font-size: 0.8rem;
		font-weight: 400;
		line-height: 1.35;
		text-align: left;
		white-space: normal;
	}

	.head {
		font-weight: 800;
	}

	.meaning {
		color: var(--ink-muted);
	}
</style>
