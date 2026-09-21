<script lang="ts">
	// Listen and repeat. Speech recognition is *optional* by design: it is
	// Chrome-leaning on the web and absent in some browsers entirely, so the
	// quiz completes on play-through and never blocks on a microphone. That
	// rule is inherited from the Dart page and matters — it is why this quiz
	// can sit in a gated chain without trapping anyone.
	import SpeakButton from '../SpeakButton.svelte';
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
		<p class="verdict pass">All {total} phrases practised.</p>
		<button class="primary" onclick={restart}>Go again</button>
	</section>
{:else if phrase}
	<section class="card">
		<p class="counter">Phrase {index + 1} of {total}</p>

		<p class="phrase" lang={locale}>
			{phrase.text}
			<SpeakButton text={phrase.text} {locale} />
		</p>
		{#if phrase.translation}
			<p class="translation">{phrase.translation}</p>
		{/if}

		<div class="controls">
			<button class="play" onclick={() => tts.speak(phrase.text, { locale })}>
				▶ Hear it
			</button>
			<button class="play" onclick={() => tts.speak(phrase.text, { locale, rate: 0.6 })}>
				🐢 Slower
			</button>
			{#if micAvailable}
				<button class="play mic" class:listening onclick={listen} disabled={listening}>
					{listening ? '● Listening…' : '🎤 Say it'}
				</button>
			{/if}
		</div>

		{#if heard}
			<p class="heard">
				Heard: <em>{heard}</em>
				{#if matched === true}<span class="ok">✓ close enough</span>
				{:else if matched === false}<span class="off">try once more</span>{/if}
			</p>
		{:else if !micAvailable}
			<p class="no-mic">
				Speech recognition isn't available in this browser — say the phrase out
				loud and move on when you're happy with it.
			</p>
		{/if}

		<button class="primary" onclick={next}>
			{index + 1 >= total ? 'Finish' : 'Next phrase'}
		</button>
	</section>
{/if}

<style>
	.card {
		padding: 1.5rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
	}

	.counter {
		margin: 0 0 1rem;
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--muted);
	}

	.phrase {
		margin: 0;
		font-size: 1.5rem;
		line-height: 1.4;
		color: var(--ink);
	}

	.translation {
		margin: 0.3rem 0 0;
		color: var(--muted);
	}

	.controls {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
		margin: 1.25rem 0 1rem;
	}

	.play {
		padding: 0.55rem 1rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface-alt);
		font: inherit;
		cursor: pointer;
	}

	.play:hover:not(:disabled) {
		border-color: var(--accent);
	}

	.mic.listening {
		border-color: #b4452f;
		color: #b4452f;
	}

	.heard {
		margin: 0 0 1rem;
		color: var(--ink-soft);
	}

	.ok {
		margin-left: 0.5rem;
		font-weight: 700;
		color: #3f7d4e;
	}

	.off {
		margin-left: 0.5rem;
		font-weight: 700;
		color: #b4452f;
	}

	.no-mic {
		margin: 0 0 1rem;
		font-size: 0.9rem;
		color: var(--muted);
	}

	.verdict {
		margin: 0 0 1rem;
		font-weight: 700;
	}

	.verdict.pass {
		color: #3f7d4e;
	}

	.primary {
		padding: 0.6rem 1.25rem;
		border: 0;
		border-radius: 999px;
		background: var(--ink);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}
</style>
