<script lang="ts">
	// Three real questions on the landing page, answered in place — the fastest
	// way to show what the course feels like is to let someone do a bit of it.
	// Each answer explains itself, the way every exercise's Help Memory does.
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from './SpeakButton.svelte';

	let { href }: { href: string } = $props();

	const QUESTIONS = [
		{
			before: 'Ich trinke',
			after: 'Kaffee.',
			english: "I'm drinking a coffee.",
			options: ['der', 'den', 'dem'],
			answer: 'den',
			why: 'Kaffee is masculine and the object of trinken, so der becomes den — the accusative.'
		},
		{
			before: 'Wir fahren morgen',
			after: 'Berlin.',
			english: "We're going to Berlin tomorrow.",
			options: ['nach', 'zu', 'in'],
			answer: 'nach',
			why: 'Towns and most countries take nach when you travel to them.'
		},
		{
			before: 'Ich bleibe zu Hause, weil ich krank',
			after: '.',
			english: "I'm staying at home because I'm ill.",
			options: ['bin', 'ist', 'sein'],
			answer: 'bin',
			why: 'weil sends the verb to the end of its clause — and with ich it is bin.'
		}
	];

	let index = $state(0);
	let picked = $state<string | null>(null);
	let score = $state(0);

	const q = $derived(QUESTIONS[index]);
	const done = $derived(index >= QUESTIONS.length);
	const right = $derived(picked === q?.answer);
	const filled = $derived(q ? `${q.before} ${q.answer}${q.after === '.' ? '' : ' '}${q.after}` : '');

	function choose(option: string) {
		if (picked) return;
		picked = option;
		if (option === q.answer) score++;
	}

	function advance() {
		picked = null;
		index++;
	}

	function restart() {
		index = 0;
		score = 0;
		picked = null;
	}
</script>

<div class="try" aria-live="polite">
	<div class="top">
		<a class="tag" {href}>Try it — no sign-up <Icon name="arrowRight" size="0.95em" /></a>
		{#if !done}
			<span class="step tnum">{index + 1} / {QUESTIONS.length}</span>
		{/if}
	</div>

	{#if !done}
		<p class="sentence" lang="de">
			{q.before}
			<span class="gap" class:filled={picked} class:ok={picked && right} class:bad={picked && !right}>
				{picked ? q.answer : '____'}
			</span>{q.after === '.' ? '' : ' '}{q.after}
		</p>
		<p class="english">{q.english}</p>

		<div class="options" role="group" aria-label="Choose the missing word">
			{#each q.options as option (option)}
				<button
					type="button"
					class="option"
					class:chosen={picked === option}
					class:correct={picked && option === q.answer}
					class:wrong={picked === option && option !== q.answer}
					disabled={!!picked}
					onclick={() => choose(option)}
				>
					{option}
				</button>
			{/each}
		</div>

		{#if picked}
			<div class="feedback" class:ok={right}>
				<p>
					<strong>
						{#if right}<Icon name="check" size="1em" /> Right.{:else}<Icon name="close" size="1em" /> It's <em>{q.answer}</em>.{/if}
					</strong>
					{q.why}
				</p>
				<div class="row">
					<SpeakButton text={filled} locale="de-DE" label="Hear the sentence" />
					<button type="button" class="next" onclick={advance}>
						{index + 1 < QUESTIONS.length ? 'Next' : 'See result'}
						<Icon name="arrowRight" size="1em" />
					</button>
				</div>
			</div>
		{/if}
	{:else}
		<div class="result">
			<p class="big tnum">{score} / {QUESTIONS.length}</p>
			<p>
				That's how every exercise works: a short rule, a sentence, instant feedback and
				the audio. The course has hundreds more, from A1 to C2.
			</p>
			<a class="go" {href}>Start the course <Icon name="arrowRight" size="1em" /></a>
			<button type="button" class="again" onclick={restart}>Try again</button>
		</div>
	{/if}
</div>

<style>
	.try {
		position: relative;
		padding: 1.5rem 1.5rem 1.4rem;
		border: 1px solid var(--line);
		border-radius: 20px;
		background: var(--surface);
		box-shadow:
			0 1px 0 rgba(31, 58, 95, 0.04),
			0 24px 48px -28px rgba(31, 58, 95, 0.35);
	}

	.top {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1.1rem;
	}

	.tag {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		text-decoration: none;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
		padding: 0.25rem 0.65rem;
		border-radius: 999px;
		background: var(--accent-soft);
		color: var(--accent);
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}

	.tag:hover {
		background: var(--accent);
		color: #fff;
	}

	.tag :global(.icon) {
		transition: transform var(--fast) var(--ease-out);
	}

	.tag:hover :global(.icon) {
		transform: translateX(2px);
	}

	.step {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.sentence {
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		line-height: 1.35;
		color: var(--heading);
	}

	.gap {
		display: inline-block;
		min-width: 3.2em;
		padding: 0 0.2em;
		border-bottom: 2px solid var(--line-strong);
		color: var(--ink-muted);
		text-align: center;
		transition:
			color var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out);
	}

	.gap.ok {
		color: var(--right);
		border-color: var(--right);
	}

	.gap.bad {
		color: var(--wrong);
		border-color: var(--wrong);
	}

	.english {
		margin: 0.4rem 0 1.2rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.options {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 0.6rem;
	}

	.option {
		padding: 0.7rem 0.5rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font: inherit;
		font-weight: 700;
		color: var(--ink);
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.option:hover:not(:disabled) {
		border-color: var(--accent);
		transform: translateY(-1px);
	}

	.option:disabled {
		cursor: default;
	}

	.option.correct {
		border-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
	}

	.option.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
	}

	.feedback {
		margin-top: 1rem;
		padding: 0.9rem 1rem;
		border-radius: var(--radius-sm);
		background: var(--wrong-bg);
	}

	.feedback.ok {
		background: var(--right-bg);
	}

	.feedback p {
		margin: 0 0 0.7rem;
		font-size: var(--step--1);
		line-height: 1.5;
		color: var(--ink);
	}

	.feedback strong {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		margin-right: 0.25rem;
	}

	.row {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.next,
	.again {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.45rem 0.9rem;
		border: 0;
		border-radius: 999px;
		background: var(--navy);
		color: #fff;
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
	}

	.result {
		text-align: center;
	}

	.result p {
		margin: 0 auto 1rem;
		max-width: 32ch;
		font-size: var(--step--1);
		line-height: 1.55;
		color: var(--ink-muted);
	}

	.result .big {
		margin: 0.2rem 0 0.4rem;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-4);
		color: var(--heading);
	}

	.go {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.7rem 1.3rem;
		border-radius: 999px;
		background: var(--accent);
		color: #fff;
		font-weight: 700;
		text-decoration: none;
	}

	.again {
		display: block;
		margin: 0.8rem auto 0;
		background: none;
		color: var(--ink-muted);
		text-decoration: underline;
	}
</style>
