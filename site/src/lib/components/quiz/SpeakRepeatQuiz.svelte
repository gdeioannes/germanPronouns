<script lang="ts">
	// Listen and repeat. Speech recognition is *optional* by design: it is
	// Chrome-leaning on the web and absent in some browsers entirely, so the
	// quiz completes on play-through and never blocks on a microphone. That
	// rule is inherited from the Dart page and matters — it is why this quiz
	// can sit in a gated chain without trapping anyone.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from '../SpeakButton.svelte';
	import { pop, rise } from '$lib/motion';
	import { matchesSpoken } from '$lib/domain/answers';
	import { stt, tts } from '$lib/services/speech';
	import type { SpeakRepeatQuiz } from '$lib/content/types';

	let {
		quiz,
		locale,
		onFinish
	}: {
		quiz: SpeakRepeatQuiz;
		locale: string;
		onFinish: () => void;
	} = $props();

	let index = $state(0);
	let done = $state(false);
	let micAvailable = $state(false);
	let listening = $state(false);
	let heard = $state('');
	let matched = $state<boolean | null>(null);
	let stopListening: (() => void) | null = null;

	const phrase = $derived(quiz.phrases[index]);
	const total = $derived(quiz.phrases.length);

	// Reset when the component is reused for a different quiz.
	$effect(() => {
		quiz.id;
		restart();
	});

	$effect(() => {
		stt.isAvailable().then((ok) => (micAvailable = ok));
	});

	$effect(() => {
		if (phrase && !done) tts.speak(phrase.text, { locale });
	});

	async function listen() {
		if (!phrase || listening) return;
		heard = '';
		matched = null;
		listening = true;
		try {
			stopListening = await stt.listen(locale, (result) => {
				heard = result.transcript;
				if (!result.isFinal) return;
				matched = matchesSpoken(result.transcript, phrase.text);
				listening = false;
			});
		} catch {
			micAvailable = false;
			listening = false;
		}
	}

	function next() {
		stopListening?.();
		stopListening = null;
		listening = false;
		heard = '';
		matched = null;
		if (index + 1 >= total) {
			done = true;
			// Play-through is completion: no score, no gate.
			onFinish();
			return;
		}
		index += 1;
	}

	function restart() {
		index = 0;
		done = false;
		heard = '';
		matched = null;
	}
</script>

{#if done}
	<section class="card">
		<Burst trigger={1} count={30} />
		<p class="verdict pass">
			<Icon name="trophy" size="1.1em" /> All {total} phrases practised.
		</p>
		<button class="btn" onclick={restart}>
			<Icon name="repeat" size="1em" /> Go again
		</button>
	</section>
{:else if phrase}
	<section class="card">
		<p class="eyebrow counter tnum">Phrase {index + 1} of {total}</p>

		<p class="phrase" lang={locale}>
			{phrase.text}
			<SpeakButton text={phrase.text} {locale} />
		</p>
		{#if phrase.translation}
			<p class="translation">{phrase.translation}</p>
		{/if}

		<div class="controls">
			<button class="chip" onclick={() => tts.speak(phrase.text, { locale })}>
				<Icon name="play" size="0.95em" /> Hear it
			</button>
			<button class="chip" onclick={() => tts.speak(phrase.text, { locale, rate: 0.6 })}>
				<Icon name="slow" size="0.95em" /> Slower
			</button>
			{#if micAvailable}
				<button class="chip mic" class:listening onclick={listen} disabled={listening}>
					<Icon name="mic" size="0.95em" />
					{listening ? 'Listening…' : 'Say it'}
				</button>
			{/if}
		</div>

		{#if heard}
			<p class="heard" in:rise>
				<span class="eyebrow">Heard</span>
				<em>{heard}</em>
				{#if matched === true}
					<span class="ok"><Icon name="check" size="0.95em" /> close enough</span>
				{:else if matched === false}
					<span class="off"><Icon name="close" size="0.95em" /> try once more</span>
				{/if}
			</p>
		{:else if !micAvailable}
			<p class="no-mic">
				Speech recognition isn't available in this browser — say the phrase out
				loud and move on when you're happy with it.
			</p>
		{/if}

		<button class="btn" onclick={next}>
			{index + 1 >= total ? 'Finish' : 'Next phrase'}
			<Icon name="arrowRight" size="1em" />
		</button>
	</section>
{/if}

<style>
	.card {
		position: relative;
		padding: 1.75rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.counter {
		margin: 0 0 1.1rem;
	}

	/* The phrase is the whole exercise — set it large, in the serif. */
	.phrase {
		margin: 0;
		max-width: none;
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-3);
		font-variation-settings: 'opsz' 32;
		font-weight: 600;
		line-height: 1.3;
		letter-spacing: -0.012em;
		color: var(--heading);
	}

	.translation {
		margin: 0.35rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.controls {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
		margin: 1.4rem 0 1.1rem;
	}

	.chip {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.48rem 0.95rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.chip:hover:not(:disabled) {
		border-color: var(--accent);
		color: var(--accent);
		transform: translateY(-1px);
	}

	/* While listening the mic pulses, so the live state is obvious without a
	   separate indicator. */
	.mic.listening {
		border-color: var(--wrong);
		color: var(--wrong);
		animation: listening 1.3s var(--ease-out) infinite;
	}

	@keyframes listening {
		0%, 100% { box-shadow: 0 0 0 0 rgba(180, 69, 47, 0.32); }
		70% { box-shadow: 0 0 0 7px rgba(180, 69, 47, 0); }
	}

	.heard {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin: 0 0 1.1rem;
		color: var(--ink-muted);
	}

	.heard em {
		font-style: normal;
		color: var(--ink);
	}

	.ok,
	.off {
		display: inline-flex;
		align-items: center;
		gap: 0.28rem;
		font-weight: 700;
		font-size: var(--step--1);
	}

	.ok {
		color: var(--right);
	}

	.off {
		color: var(--wrong);
	}

	.no-mic {
		margin: 0 0 1.1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.verdict {
		display: flex;
		align-items: center;
		gap: 0.45rem;
		margin: 0 0 1.1rem;
		font-size: var(--step-1);
		font-weight: 700;
	}

	.verdict.pass {
		color: var(--right);
	}
</style>
