<script lang="ts">
	// The study notes as a lesson (see domain/lesson): one idea per screen,
	// a question after each rule, the words to hear, the mistakes to spot, and
	// a cheat sheet to finish on. It takes the exercise's place on the page —
	// Learn, then Practise — rather than sliding in over it.
	//
	// Every step is in the DOM (Steps keeps the hidden ones inert): the page is
	// prerendered, and the explanation is the most useful text on it.
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from './SpeakButton.svelte';
	import GermanText from './GermanText.svelte';
	import Steps, { type StepMark } from './quiz/Steps.svelte';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { speakable, splitFocus, spokenWord, type LessonCheck, type LessonStep } from '$lib/domain/lesson';
	import { react } from '$lib/motion/fx.svelte';
	import { tts } from '$lib/services/speech';
	import { announce } from '$lib/a11y.svelte';
	import { tick } from 'svelte';

	let {
		steps,
		locale = 'de-DE',
		deckHref = null,
		onPractise
	}: {
		steps: LessonStep[];
		locale?: string;
		deckHref?: string | null;
		/** Leave the lesson for the exercise. */
		onPractise: () => void;
	} = $props();

	let index = $state(0);
	/** The answer picked on each check step, by step index. */
	let picked = $state<Record<number, string>>({});
	/** The furthest step reached — what counts as "read" on the dots. */
	let reached = $state(0);
	let showEnglish = $state(false);

	$effect(() => {
		if (index > reached) reached = index;
	});

	const checks = $derived(
		steps.flatMap((s, i) => (s.kind === 'check' ? [{ i, check: s.check }] : []))
	);
	const rightCount = $derived(checks.filter(({ i, check }) => picked[i] === check.answer).length);
	const answeredCount = $derived(checks.filter(({ i }) => picked[i] !== undefined).length);

	const marks: StepMark[] = $derived(
		steps.map((s, i) => {
			if (s.kind === 'check') {
				const p = picked[i];
				return p === undefined ? null : p === s.check.answer ? 'right' : 'wrong';
			}
			return i < reached ? 'done' : null;
		})
	);

	const ruleCount = $derived(steps.filter((s) => s.kind === 'rule').length);
	/** About twenty seconds a screen — honest enough to say out loud. */
	const minutes = $derived(Math.max(1, Math.round(steps.length / 3)));

	function pick(step: number, check: LessonCheck, option: string, event: MouseEvent) {
		if (picked[step] !== undefined) return;
		picked = { ...picked, [step]: option };
		const right = option === check.answer;
		react(right, event.currentTarget as Element);
		announce(
			right
				? [{ text: 'Richtig!', lang: locale }, ...(check.why ? [{ text: check.why }] : [])]
				: [{ text: `Not quite — it's` }, { text: check.answer, lang: check.germanOptions ? locale : undefined }, ...(check.why ? [{ text: check.why }] : [])]
		);
		// The options just went disabled; focus moves on to the feedback.
		const group = (event.currentTarget as HTMLElement).closest('.options');
		void tick().then(() => {
			const feedback = group?.parentElement?.querySelector<HTMLElement>('.feedback');
			(feedback?.querySelector<HTMLElement>('button') ?? feedback)?.focus({ preventScroll: true });
		});
	}

	function say(text: string) {
		tts.speak(text, { locale });
	}

	/** Tables longer than this start folded on the cheat sheet. */
	const TABLE_OPEN_ROWS = 6;

	const KIND_LABEL: Record<string, string> = {
		rule: 'Rule',
		warning: 'Watch out',
		mnemonic: 'Memory trick',
		exam: 'In the exam'
	};
</script>

<!-- A lesson example is German, so every word in it is tappable for the
     English, and the focus words the lesson is teaching stay marked on top of
     that: the mark says "this is the bit that matters", the tap says what the
     word means. -->
{#snippet german(text: string, focus?: string[])}
	{#each splitFocus(text, focus) as part, p (p)}{#if part.hit}<mark><GermanText text={part.text} /></mark>{:else}<GermanText text={part.text} />{/if}{/each}
{/snippet}

{#snippet gapped(text: string)}
	{#each text.split('____') as piece, p (p)}{#if p > 0}<span class="gap" aria-label="blank"></span>{/if}{piece}{/each}
{/snippet}

<div class="lesson">
	<Steps count={steps.length} bind:index labels={steps.map((s) => s.label)} {marks}>
		{#snippet step(i)}
			{@const s = steps[i]}
			<div class="page" data-kind={s.kind}>
				{#if s.kind === 'hook'}
					<p class="eyebrow">
						Lesson · {ruleCount} {ruleCount === 1 ? 'rule' : 'rules'} · about {minutes} min
					</p>
					<h2 class="hook">{s.hook}</h2>

					{#if s.roadmap.length}
						<ol class="roadmap">
							{#each s.roadmap as point, n (n)}
								<li><span class="num tnum">{n + 1}</span>{point}</li>
							{/each}
						</ol>
					{/if}

					{#if s.more}
						<details class="more">
							<summary>Why this matters <Icon name="chevronDown" size="0.9em" /></summary>
							<p>{s.more}</p>
						</details>
					{/if}

					<div class="actions">
						<button type="button" class="btn" onclick={() => (index = 1)}>
							Start the lesson <Icon name="arrowRight" size="1em" />
						</button>
						<button type="button" class="btn-quiet" onclick={onPractise}>I know this — practise now</button>
					</div>
				{:else if s.kind === 'rule'}
					{@const kind = s.tip.kind ?? 'rule'}
					<p class="eyebrow" data-tone={kind}>
						{KIND_LABEL[kind] ?? 'Rule'} · {s.number} of {s.of}
					</p>
					{#if s.tip.title}<h2>{s.tip.title}</h2>{/if}
					<p class="rule-text">{s.tip.text}</p>

					{#if s.tip.examples?.length}
						<ul class="examples">
							{#each s.tip.examples as ex, e (e)}
								<li>
									<SpeakButton text={speakable(ex.de)} {locale} />
									<span class="pair">
										<span class="de" lang={locale}>{@render german(ex.de, ex.focus)}</span>
										<span class="en">{ex.en}</span>
									</span>
								</li>
							{/each}
						</ul>
					{/if}

					{#if s.tip.trap}
						<p class="trap">
							<Icon name="info" size="1.05em" />
							<span>{s.tip.trap.replace(/^E\d+\s*[—-]\s*/, '')}</span>
						</p>
					{/if}
				{:else if s.kind === 'check'}
					{@const c = s.check}
					{@const answer = picked[i]}
					<p class="eyebrow" data-tone="check">{c.eyebrow}</p>
					<h2 class="question" lang={c.question.includes('____') ? locale : undefined}>
						{@render gapped(c.question)}
					</h2>

					{#if c.listen}
						<button type="button" class="listen" onclick={() => say(c.listen!)}>
							<Icon name="volume" size="1.4em" />
							<span>Play</span>
						</button>
					{/if}

					<div
						class="options"
						class:german={c.germanOptions}
						class:stack={c.options.some((o) => o.length > 14)}
						style="--cols:{c.options.length === 4 ? 2 : c.options.length}"
						role="group"
						aria-label="Answers"
					>
						{#each c.options as option, o (o)}
							<button
								type="button"
								class="option"
								class:right={answer !== undefined && option === c.answer}
								class:wrong={answer === option && option !== c.answer}
								class:dim={answer !== undefined && option !== c.answer && option !== answer}
								disabled={answer !== undefined}
								lang={c.germanOptions ? locale : undefined}
								onclick={(e) => pick(i, c, option, e)}
							>
								{option}
								{#if answer !== undefined && option === c.answer}<Icon name="check" size="1em" />{/if}
								{#if answer === option && option !== c.answer}<Icon name="close" size="1em" />{/if}
							</button>
						{/each}
					</div>

					{#if answer !== undefined}
						<div class="feedback" class:ok={answer === c.answer} tabindex="-1" data-focus-target>
							<p class="verdict">{#if answer === c.answer}<span lang={locale}>Richtig!</span>{:else}Not quite — it's <span lang={c.germanOptions ? locale : undefined}>{c.answer}</span>.{/if}</p>
							{#if c.why}<p class="why">{c.why}</p>{/if}
							{#if i < steps.length - 1}
								<button type="button" class="btn" onclick={() => (index = i + 1)}>
									Continue <Icon name="arrowRight" size="1em" />
								</button>
							{/if}
						</div>
					{/if}
				{:else if s.kind === 'words'}
					<p class="eyebrow">Words · tap to hear</p>
					<h2>The words you need</h2>
					<ul class="words">
						{#each s.words as w, k (k)}
							<li>
								<button
									type="button"
									class="word"
									style={w.gender ? `--g:${GENDER_COLORS[w.gender]}` : ''}
									onclick={() => say(spokenWord(w))}
								>
									<span class="w-de" lang={locale}>
										{#if w.article}<span class="article">{w.article}</span>{/if}{w.de}
									</span>
									<span class="w-en">{w.en}{#if w.plural}<span class="plural">{' · pl. '}<b lang={locale}>{w.plural}</b></span>{/if}</span>
								</button>
							</li>
						{/each}
					</ul>
					{#if deckHref}
						<a class="practise-link" href={deckHref}>
							<Icon name="cards" size="1em" /> Practise these words as flashcards
						</a>
					{/if}
				{:else if s.kind === 'context'}
					<p class="eyebrow">In context</p>
					<h2>Hear it in a real exchange</h2>
					<div class="context">
						<SpeakButton text={speakable(s.context.de)} {locale} label="Play the exchange" />
						<p class="de" lang={locale}>{@render german(s.context.de, s.context.focus)}</p>
					</div>
					<button type="button" class="reveal" aria-expanded={showEnglish} onclick={() => (showEnglish = !showEnglish)}>
						{showEnglish ? 'Hide' : 'Show'} the English
					</button>
					<!-- Hidden by CSS, not removed: the translation stays in the page. -->
					<p class="context-en" class:shown={showEnglish}>{s.context.en}</p>
				{:else if s.kind === 'recap'}
					<p class="eyebrow">Cheat sheet</p>
					<h2>What to take with you</h2>
					{#if checks.length && answeredCount}
						<p class="score">
							<strong class="tnum">{rightCount} / {checks.length}</strong> checks right{rightCount === checks.length ? ' — you are ready.' : '. The exercise will lock it in.'}
						</p>
					{/if}
					<ul class="points">
						{#each s.points as point, n (n)}
							<li><Icon name="check" size="1em" /><span>{point}</span></li>
						{/each}
					</ul>

					{#if s.remember.length}
						<div class="remember">
							<p class="mini-head"><Icon name="bolt" size="0.95em" /> How to remember it</p>
							<ul>
								{#each s.remember as aid, a (a)}<li>{aid}</li>{/each}
							</ul>
						</div>
					{/if}

					{#if s.table}
						<!-- A short table is shown; a long one folds, so the way on
						     stays on screen. Folded, it is still in the page. -->
						<details class="table-wrap" open={s.table.rows.length <= TABLE_OPEN_ROWS}>
							<summary class="mini-head">{s.table.caption ?? "The full table"} · {s.table.rows.length} rows <Icon name="chevronDown" size="0.95em" /></summary>
							<table>
								<thead><tr>{#each s.table.columns as col, c (c)}<th scope="col">{col}</th>{/each}</tr></thead>
								<tbody>
									{#each s.table.rows as row, r (r)}
										<tr style={row.gender ? `color:${GENDER_COLORS[row.gender]}` : ''}>
											{#each row.cells as cell, c (c)}{#if c === 0}<th scope="row">{cell}</th>{:else}<td>{cell}</td>{/if}{/each}
										</tr>
									{/each}
								</tbody>
							</table>
						</details>
					{:else if s.derived}
						<details class="table-wrap" open={s.derived.rows.length <= TABLE_OPEN_ROWS}>
							<summary class="mini-head">The full table · {s.derived.rows.length} rows <Icon name="chevronDown" size="0.95em" /></summary>
							<table>
								<thead>
									<tr>
										<th scope="col">{s.derived.subjectHeader}</th>
										{#each s.derived.columns as col, c (c)}<th scope="col">{col}</th>{/each}
									</tr>
								</thead>
								<tbody>
									{#each s.derived.rows as row, r (r)}
										<tr>
											<th scope="row" style={s.derived.colorByGender && row.gender ? `color:${GENDER_COLORS[row.gender]}` : ''}>
												{#if row.article}<span class="article">{row.article}</span>{/if}{row.subject}
											</th>
											{#each row.cells as cell, c (c)}<td>{cell}</td>{/each}
										</tr>
									{/each}
								</tbody>
							</table>
						</details>
					{/if}

					{#if s.exam}
						<p class="exam"><Icon name="trophy" size="1em" /> <span>{s.exam}</span></p>
					{/if}

					<div class="actions sticky">
						<button type="button" class="btn big" onclick={onPractise}>
							Start practising <Icon name="arrowRight" size="1em" />
						</button>
					</div>
				{/if}
			</div>
		{/snippet}
	</Steps>
</div>

<style>
	.lesson {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
	}

	/* One idea per screen, set like a page of a good textbook: a small-caps
	   eyebrow, a serif headline, and room around it. The page fills the
	   stage, so a short idea reads as a page with space, not half a screen
	   left over — and its action sits at the foot, under the thumb. */
	.page {
		flex: 1 0 auto;
		display: flex;
		flex-direction: column;
		gap: 0.9rem;
		max-width: 38rem;
		width: 100%;
		margin: 0 auto;
		padding: 1.4rem 1.35rem 1.35rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.page[data-kind='hook'] {
		border-top: 6px solid var(--accent);
	}

	.page[data-kind='recap'] {
		border-top: 6px solid var(--navy);
	}

	.eyebrow {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.eyebrow[data-tone='warning'] {
		color: var(--wrong);
	}
	.eyebrow[data-tone='mnemonic'] {
		color: var(--ochre-ink);
	}
	.eyebrow[data-tone='check'] {
		color: var(--navy);
	}

	h2 {
		margin: 0;
		font-size: var(--step-2, 1.6rem);
		line-height: 1.2;
		color: var(--heading);
	}

	.hook {
		font-size: clamp(1.6rem, 1.2rem + 2vw, 2.4rem);
		line-height: 1.15;
		text-wrap: balance;
	}

	/* -- hook ------------------------------------------------------------- */

	.roadmap {
		margin: 0.3rem 0 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.5rem;
	}

	.roadmap li {
		display: flex;
		align-items: baseline;
		gap: 0.7rem;
		font-weight: 600;
		color: var(--ink);
	}

	.num {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex: none;
		width: 1.6rem;
		height: 1.6rem;
		border-radius: 50%;
		background: var(--navy);
		color: var(--paper);
		font-size: 0.8rem;
		font-weight: 700;
	}

	.more summary {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink-muted);
		cursor: pointer;
		list-style: none;
	}

	.more summary::-webkit-details-marker {
		display: none;
	}

	.more[open] summary :global(svg) {
		transform: rotate(180deg);
	}

	.more p {
		margin: 0.5rem 0 0;
		font-size: var(--step--1);
		line-height: 1.6;
		color: var(--ink-muted);
	}

	.actions {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.6rem 1.1rem;
		margin-top: auto;
		padding-top: 0.4rem;
	}

	.btn.big {
		width: 100%;
		padding: 0.85rem 1.3rem;
		font-size: var(--step-0);
	}

	/* -- rule ------------------------------------------------------------- */

	/* The rule is the point of the screen: full ink, full size. */
	.rule-text {
		margin: 0;
		font-size: var(--step-0);
		line-height: 1.6;
		color: var(--ink);
	}

	.examples {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.55rem;
	}

	.examples li {
		display: flex;
		align-items: flex-start;
		gap: 0.75rem;
		padding: 0.8rem 0.95rem;
		border-radius: var(--radius-sm, 10px);
		background: var(--surface-alt);
	}

	.examples :global(.speak) {
		flex: none;
		margin-top: 0.15rem;
	}

	.pair {
		display: grid;
		gap: 0.15rem;
	}

	.de {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		line-height: 1.35;
		color: var(--ink);
	}

	.en {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* The word the example exists to show. */
	mark {
		padding: 0 0.12em;
		border-radius: 3px;
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-weight: 700;
		box-shadow: inset 0 -2px 0 var(--accent);
	}

	.trap {
		display: flex;
		gap: 0.55rem;
		align-items: flex-start;
		margin: 0;
		padding: 0.75rem 0.9rem;
		border-radius: var(--radius-sm, 10px);
		background: var(--wrong-bg);
		color: var(--wrong);
		font-size: var(--step--1);
		font-weight: 600;
		line-height: 1.5;
	}

	.trap :global(svg) {
		flex: none;
		margin-top: 0.1rem;
	}

	/* -- check ------------------------------------------------------------ */

	.question {
		font-size: var(--step-2, 1.6rem);
	}

	.gap {
		display: inline-block;
		width: 3.2em;
		height: 0.9em;
		margin: 0 0.15em;
		border-bottom: 3px solid var(--accent);
		vertical-align: baseline;
	}

	.listen {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		align-self: flex-start;
		padding: 0.8rem 1.4rem;
		border: 0;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font: inherit;
		font-weight: 700;
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
	}

	.listen:hover {
		transform: translateY(-1px) scale(1.02);
	}

	/* Short answers in one row (two by two for four); sentences stacked, so
	   none of them is squeezed into a column a word wide. */
	.options {
		display: grid;
		grid-template-columns: repeat(var(--cols, 2), minmax(0, 1fr));
		gap: 0.6rem;
	}

	.options.stack {
		grid-template-columns: minmax(0, 1fr);
	}

	.options.stack .option {
		justify-content: space-between;
		text-align: left;
	}

	.option {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.45rem;
		min-height: 3.4rem;
		padding: 0.7rem 1rem;
		border: 2px solid var(--line-strong);
		border-radius: var(--radius-sm, 10px);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: var(--step-0);
		font-weight: 600;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out),
			opacity var(--fast) var(--ease-out);
	}

	.options.german .option {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 600;
	}

	.option:hover:not(:disabled) {
		border-color: var(--navy);
		transform: translateY(-2px);
	}

	.option:disabled {
		cursor: default;
	}

	.option.right {
		border-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
	}

	.option.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
	}

	.option.dim {
		opacity: 0.45;
	}

	.feedback {
		display: grid;
		gap: 0.45rem;
		justify-items: start;
		padding: 0.9rem 1rem;
		border-left: 4px solid var(--wrong);
		border-radius: 0 var(--radius-sm, 10px) var(--radius-sm, 10px) 0;
		background: var(--wrong-bg);
		animation: rise var(--medium, 220ms) var(--ease-out);
	}

	.feedback.ok {
		border-left-color: var(--right);
		background: var(--right-bg);
	}

	.verdict {
		margin: 0;
		font-weight: 800;
		color: var(--wrong);
	}

	.feedback.ok .verdict {
		color: var(--right);
	}

	.why {
		margin: 0;
		color: var(--ink);
		line-height: 1.5;
	}

	.feedback .btn {
		margin-top: 0.3rem;
	}

	@keyframes rise {
		from {
			opacity: 0;
			transform: translateY(6px);
		}
	}

	/* -- words ------------------------------------------------------------ */

	.words {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(8.5rem, 1fr));
		gap: 0.5rem;
	}

	.word {
		display: grid;
		gap: 0.1rem;
		width: 100%;
		padding: 0.6rem 0.75rem;
		border: 1px solid var(--line);
		border-left: 4px solid var(--g, var(--navy));
		border-radius: var(--radius-sm, 10px);
		background: var(--surface);
		text-align: left;
		font: inherit;
		cursor: pointer;
		transition:
			transform var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out);
	}

	.word:hover {
		transform: translateY(-2px);
		border-color: var(--g, var(--navy));
	}

	.w-de {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 600;
		color: var(--g, var(--ink));
	}

	/* The plural rides on the meaning line, so a long noun keeps its own line. */
	.plural b {
		font-weight: 700;
		color: var(--ink);
	}

	.article {
		margin-right: 0.3ch;
		font-weight: 400;
		opacity: 0.85;
	}

	.w-en {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.practise-link {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
		text-decoration: none;
	}

	.practise-link:hover {
		text-decoration: underline;
	}

	/* -- context ---------------------------------------------------------- */

	.context {
		display: flex;
		align-items: flex-start;
		gap: 0.8rem;
		padding: 1.1rem 1.15rem;
		border-radius: var(--radius, 14px);
		background: var(--surface-alt);
	}

	.context :global(.speak) {
		flex: none;
		margin-top: 0.2rem;
	}

	.context .de {
		margin: 0;
		line-height: 1.5;
	}

	.reveal {
		align-self: flex-start;
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
	}

	.context-en {
		display: none;
		margin: 0;
		color: var(--ink-muted);
		line-height: 1.5;
	}

	.context-en.shown {
		display: block;
	}

	/* -- recap ------------------------------------------------------------ */

	.score {
		margin: 0;
		padding: 0.7rem 0.9rem;
		border-radius: var(--radius-sm, 10px);
		background: var(--accent-soft);
		color: var(--ink);
	}

	.score strong {
		color: var(--accent-ink);
		font-size: var(--step-1);
	}

	.points {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.45rem;
	}

	.points li {
		display: flex;
		align-items: baseline;
		gap: 0.55rem;
		font-weight: 600;
		color: var(--ink);
	}

	.points :global(svg) {
		flex: none;
		color: var(--right);
	}

	.mini-head {
		display: flex;
		align-items: center;
		gap: 0.35rem;
		margin: 0 0 0.4rem;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.remember {
		padding: 0.8rem 0.95rem;
		border-left: 3px solid var(--ochre);
		border-radius: 0 var(--radius-sm, 10px) var(--radius-sm, 10px) 0;
		background: var(--surface-alt);
	}

	.remember ul {
		margin: 0;
		padding-left: 1.1rem;
		font-size: var(--step--1);
		line-height: 1.5;
	}

	.table-wrap {
		overflow-x: auto;
	}

	.table-wrap summary {
		cursor: pointer;
		list-style: none;
	}

	.table-wrap summary::-webkit-details-marker {
		display: none;
	}

	.table-wrap[open] summary :global(svg) {
		transform: rotate(180deg);
	}

	/* The way out of the lesson never scrolls away under a long cheat sheet. */
	.actions.sticky {
		position: sticky;
		bottom: 0;
		padding-bottom: 0.2rem;
		background: linear-gradient(to top, var(--surface) 70%, transparent);
	}

	table {
		border-collapse: collapse;
		width: 100%;
		font-size: var(--step--1);
	}

	th,
	td {
		padding: 0.4rem 0.7rem;
		text-align: left;
		border-bottom: 1px solid var(--line);
		white-space: nowrap;
	}

	thead th {
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.exam {
		display: flex;
		gap: 0.5rem;
		align-items: baseline;
		margin: 0;
		padding: 0.6rem 0.8rem;
		border-radius: 10px;
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-size: var(--step--1);
		font-weight: 600;
	}

	@media (max-width: 36rem) {
		.page {
			padding: 1.1rem 1rem 1rem;
		}
		h2 {
			font-size: var(--step-1);
		}
		.hook {
			font-size: 1.55rem;
		}
		.question {
			font-size: var(--step-1);
		}
		.de {
			font-size: var(--step-0);
		}
		.examples li {
			padding: 0.65rem 0.75rem;
		}
		.word {
			padding: 0.45rem 0.6rem;
		}
		.w-de {
			font-size: var(--step-0);
		}
	}
</style>
