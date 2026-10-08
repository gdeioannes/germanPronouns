<script module lang="ts">
	// One panel on the whole page at a time. Each sentence is its own instance
	// and only knows about its own words, so without this a learner tapping
	// through a passage left a trail of open panels behind them — the
	// click-away handler saw every tap land on a word and kept its hands off.
	// Whoever opens a panel claims this; everyone else closes theirs.
	let owner = $state<symbol | null>(null);
</script>

<script lang="ts">
	// German text with its words recognised: tap any one of them for the English.
	//
	// This began as the noun colouring ported from the Dart quiz page, and nouns
	// still look exactly as they did — coloured by gender, with a per-gender
	// underline so the three read apart without relying on colour. What changed
	// is everything else in the sentence. A learner reading "Ich habe mich schon
	// damals darüber geärgert" does not need the nouns glossed; they need
	// "damals" and "darüber". So every word the dictionary knows is now tappable,
	// and the non-nouns carry no mark at rest: the sentence has to stay a
	// sentence, not become a field of underlines.
	//
	// Switched off, this renders plain text — no colour, no underline, nothing to
	// tap, and the dictionary is never fetched. Off has to mean the feature is
	// gone, not merely grey: the underlines were still marking up the exercise.
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { dictionary } from '$lib/state/dictionary.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { headlineFor, POS_LABELS, wordHref, type WordInfo } from '$lib/domain/dictionary';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import { announce } from '$lib/a11y.svelte';

	let { text }: { text: string } = $props();

	// `loaded` guards the first frames: until the setting has been read back
	// from storage the defaults are in force, and a learner who turned word help
	// off would watch it flick on and off again — which reads as "it didn't
	// save". Plain text until we actually know.
	const on = $derived(progress.loaded && progress.wordHelp);

	$effect(() => {
		if (on) dictionary.load();
	});

	/** The text as alternating plain runs and recognised words. */
	const parts = $derived.by(() => {
		const out: { text: string; info: WordInfo | null }[] = [];
		if (!on) return [{ text, info: null }];
		let last = 0;
		for (const match of text.matchAll(/\p{L}+/gu)) {
			const at = match.index;
			if (at > last) out.push({ text: text.slice(last, at), info: null });
			out.push({ text: match[0], info: dictionary.lookup(match[0]) });
			last = at + match[0].length;
		}
		if (last < text.length) out.push({ text: text.slice(last), info: null });
		return out;
	});

	/** Which word's panel is open, by its position in `parts`. */
	let openAt = $state<number | null>(null);
	/** Several sentences on a page each have a word 3: ids need telling apart. */
	const uid = Math.random().toString(36).slice(2, 8);
	const me = Symbol();

	// Another sentence opened a panel: ours goes.
	$effect(() => {
		if (owner !== me) openAt = null;
	});

	function toggle(i: number, info: WordInfo) {
		openAt = openAt === i ? null : i;
		if (openAt === i) {
			owner = me;
			announce([
				{ text: headlineFor(info), lang: 'de-DE' },
				{ text: `: ${info.entry.en}`, lang: 'en' }
			]);
		}
	}

	function onKey(event: KeyboardEvent) {
		if (event.key === 'Escape' && openAt !== null) {
			event.stopPropagation();
			openAt = null;
		}
	}

	// The panel used to close on blur, which was right while it held only text.
	// It now holds a listen button and a link to the full entry, and blur fires
	// before the click lands — tapping either one would dismiss the panel instead
	// of working. So it closes when the next interaction happens somewhere else.
	$effect(() => {
		if (openAt === null) return;
		const away = (event: Event) => {
			// Anything inside a tapped word — the word, its panel, the listen
			// button, the link — is handled by that word's own click, so leave it
			// alone. `pointerdown` fires before `click`, which is why this asks
			// where the event is rather than whether focus has left.
			const target = event.target;
			if (target instanceof Element && target.closest('.word-wrap')) return;
			openAt = null;
		};
		document.addEventListener('pointerdown', away);
		document.addEventListener('focusin', away);
		return () => {
			document.removeEventListener('pointerdown', away);
			document.removeEventListener('focusin', away);
		};
	});

	/** The gender colour, for a noun whose gender the collection knows. */
	const colourOf = (info: WordInfo) =>
		info.entry.pos === 'noun' && info.entry.gender ? GENDER_COLORS[info.entry.gender] : null;
</script>

{#each parts as part, i (i)}{#if part.info}{@const colour = colourOf(part.info)}<span
			class="word-wrap"
			><button
				type="button"
				class="word"
				class:noun={colour !== null}
				data-gender={part.info.entry.gender}
				style={colour ? `color:${colour}` : undefined}
				aria-expanded={openAt === i}
				aria-controls={openAt === i ? `word-${uid}-${i}` : undefined}
				onclick={() => toggle(i, part.info!)}
				onkeydown={onKey}>{part.text}</button
			>{#if openAt === i}
				{@const entry = part.info.entry}
				{@const href = wordHref(entry)}
				<span class="panel" id="word-{uid}-{i}">
					<span class="row">
						<span class="head" style={colour ? `color:${colour}` : undefined}
							>{headlineFor(part.info)}</span
						>
						<SpeakButton text={entry.de} locale="de-DE" label="Listen to {entry.de}" />
					</span>
					{#if POS_LABELS[entry.pos]}<span class="pos" lang="en">{POS_LABELS[entry.pos]}</span>{/if}
					<span class="meaning" lang="en">{entry.en}</span>
					{#if href}<a class="more" {href} lang="en">Full entry</a>{/if}
				</span>
			{/if}</span
		>{:else}{part.text}{/if}{/each}

<style>
	.word-wrap {
		position: relative;
		display: inline-block;
	}

	/* A button, so it is reachable by keyboard and announced as pressable, but
	   styled as the word it is — nothing about the sentence should look like a
	   form control. */
	.word {
		padding: 0;
		border: 0;
		border-bottom: 1px solid transparent;
		background: none;
		font: inherit;
		color: inherit;
		cursor: pointer;
	}

	/* Every known word is tappable, but only a noun says so at rest. The others
	   show a faint dotted underline when the pointer or the keyboard reaches
	   them, which is enough to be discovered and little enough that a reading
	   passage still reads as prose. */
	.word:not(.noun):hover,
	.word:not(.noun):focus-visible {
		border-bottom-color: var(--ink-muted);
		border-bottom-style: dotted;
	}

	.word.noun {
		font-weight: 800;
		border-bottom: 1px dotted currentColor;
	}

	/* Colour is not the only cue to gender: each has its own underline, so
	   the three still read apart for anyone who can't tell the colours. */
	.word.noun[data-gender='f'] {
		border-bottom-style: dashed;
	}

	.word.noun[data-gender='n'] {
		border-bottom: 3px double currentColor;
	}

	/* The panel is absolutely positioned and centred under the word. It is the
	   one thing here allowed to escape the line box — it is transient, and
	   anchoring it to its word is the whole point. */
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

	.row {
		display: flex;
		align-items: center;
		gap: 0.4rem;
	}

	.head {
		font-weight: 800;
	}

	.pos {
		font-size: 0.7rem;
		font-variant: all-small-caps;
		letter-spacing: 0.06em;
		color: var(--ink-muted);
	}

	.meaning {
		color: var(--ink-muted);
	}

	.more {
		justify-self: start;
		margin-top: 0.15rem;
		font-size: 0.72rem;
		color: var(--accent-ink);
	}
</style>
