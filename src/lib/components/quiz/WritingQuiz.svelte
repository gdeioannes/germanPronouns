<script lang="ts">
	// The writing exercise. The learner writes the text here, inside a
	// character bound, and the app renders a prompt that CARRIES that text to
	// their own AI for correction. What comes back is the same delimited report
	// the speaking exercises use, so the score is read the same way and the
	// FIX: lines join the one personal-focus loop.
	//
	// Four stages, one screen each (see Steps): write, copy, correct, score.
	// The last one keeps the corrections on screen: they are the point of the
	// exercise, not the number.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import Steps from './Steps.svelte';
	import { pop } from '$lib/motion';
	import manifest from '$content/speaking/manifest.json';
	import template from '$content/speaking/template.en.json';
	import {
		parseSpeakingFixes,
		parseSpeakingScore,
		speakingGrade,
		speakingMedal
	} from '$lib/domain/progress';
	import {
		fixFitsLevel,
		renderSpeakingPrompt,
		type SpeakingManifest,
		type SpeakingTemplate
	} from '$lib/domain/speakingPrompt';
	import {
		asSpeakingExercise,
		BOLD,
		canSubmit,
		charBoundsFor,
		countChars,
		countWords,
		fillOf,
		GERMAN_KEYS,
		ITALIC,
		markersToHtml,
		serialiseMarkers,
		writingState
	} from '$lib/domain/writing';
	import { SettingsKeys } from '$lib/domain/keys';
	import type { SpeakingFix } from '$lib/domain/progress';
	import { storage } from '$lib/services/storage';
	import { AI_ASSISTANTS, assistantHref } from '$lib/services/aiApps';
	import type { WritingQuiz } from '$lib/content/types';

	let {
		quiz,
		courseId,
		learnLocale,
		uiLang,
		onFinish
	}: {
		quiz: WritingQuiz;
		courseId: string;
		learnLocale: string;
		uiLang: string;
		onFinish: (passed: boolean, score: number) => void;
	} = $props();

	const bounds = $derived(charBoundsFor(quiz.writing, quiz.level));
	const passScore = $derived(
		quiz.writing.passScore ?? (manifest as SpeakingManifest).defaults.passScore
	);

	let text = $state('');
	let prompt = $state('');
	let copied = $state(false);
	let report = $state('');
	let saved = $state<number | null>(null);
	let remembered = $state<SpeakingFix[]>([]);
	let index = $state(0);
	const labels = ['Write', 'Copy', 'Correct', 'Score'];

	// The page is reused from one exercise to the next: start it over.
	$effect(() => {
		quiz.id;
		index = 0;
		copied = false;
		if (box) box.innerHTML = '';
		text = '';
		report = '';
		saved = null;
		remembered = [];
	});

	// Read in the browser only, so the prerendered page keeps the web links.
	let userAgent = $state('');
	$effect(() => {
		userAgent = navigator.userAgent;
	});

	const chars = $derived(countChars(text));
	const words = $derived(countWords(text));
	const fill = $derived(fillOf(text, bounds));
	const fit = $derived(writingState(text, bounds));
	const ready = $derived(canSubmit(text, bounds));

	/**
	 * The compose box. It is a rich-text surface rather than a textarea,
	 * because a textarea can only hold plain characters: emphasis written as
	 * `**fett**` would show the asterisks instead of going bold. What the
	 * learner sees is styled; what the app keeps in `text` is the marker form,
	 * and that is what gets counted, saved and sent.
	 */
	let box = $state<HTMLDivElement | null>(null);

	/** Reads the surface back into the marker text after every change. */
	function sync() {
		if (box) text = serialiseMarkers(box);
	}

	/**
	 * Types `what` in at the caret through the browser's own editing command,
	 * so it joins the undo stack and the caret ends up after it. The toolbar
	 * hands focus straight back, because losing your place in a 900-character
	 * text to fetch an umlaut would be worse than no button.
	 */
	function insert(what: string) {
		const el = box;
		if (!el) return;
		el.focus();
		document.execCommand('insertText', false, what);
		sync();
	}

	/**
	 * A bullet is a hyphen at the start of a line, not markup: it survives into
	 * the prompt as itself, so nothing has to be stripped before the tutor reads
	 * the German.
	 */
	function bullet() {
		const el = box;
		if (!el) return;
		el.focus();
		const at = window.getSelection();
		const atLineStart = at?.anchorOffset === 0;
		if (!atLineStart) document.execCommand('insertLineBreak');
		document.execCommand('insertText', false, '- ');
		sync();
	}

	/**
	 * Bold and italic through the browser's own commands, which already handle
	 * toggling a selection off, applying to the next thing typed when nothing is
	 * selected, and the undo stack.
	 */
	function emphasise(mark: string) {
		const el = box;
		if (!el) return;
		el.focus();
		document.execCommand(mark === BOLD ? 'bold' : 'italic');
		sync();
	}

	/** Pasted text comes in as text: nothing styled from elsewhere gets in. */
	function onPaste(event: ClipboardEvent) {
		event.preventDefault();
		const plain = event.clipboardData?.getData('text/plain') ?? '';
		document.execCommand('insertText', false, plain);
		sync();
	}

	/** The strip, in order: the letters, then emphasis, then the bullet. */
	const TOOLS = [
		...GERMAN_KEYS.map((key) => ({
			text: key,
			label: `Insert ${key}`,
			run: () => insert(key),
			kind: 'letter' as const
		})),
		{ text: 'F', label: 'Bold', run: () => emphasise(BOLD), kind: 'bold' as const },
		{ text: 'K', label: 'Italic', run: () => emphasise(ITALIC), kind: 'italic' as const },
		{ text: 'Punkt', label: 'Start a bullet point', run: bullet, kind: 'wide' as const }
	];

	/** Which key in the strip currently holds the toolbar's single tab stop. */
	let tool0 = $state(0);

	/** Whether the brief above the sheet is open, and whether the sheet fills the screen. */
	let brief = $state(true);
	let expanded = $state(false);

	// The brief has done its job once there is a text to look at, so it folds
	// away and gives the room to the sheet. Only once, and never back over a
	// learner who has opened it again on purpose.
	let folded = false;
	$effect(() => {
		if (folded || text.length < 40) return;
		folded = true;
		brief = false;
	});

	// Escape leaves full screen, the way every other overlay in the app does.
	function onWindowKey(event: KeyboardEvent) {
		if (event.key === 'Escape' && expanded) {
			expanded = false;
			box?.focus();
		}
	}

	function onToolKey(event: KeyboardEvent) {
		const step = event.key === 'ArrowRight' ? 1 : event.key === 'ArrowLeft' ? -1 : 0;
		if (!step && event.key !== 'Home' && event.key !== 'End') return;
		event.preventDefault();
		const last = TOOLS.length - 1;
		tool0 =
			event.key === 'Home'
				? 0
				: event.key === 'End'
					? last
					: (tool0 + step + TOOLS.length) % TOOLS.length;
		// The tab stop moved, so the focus follows it.
		const strip = (event.currentTarget as HTMLElement).querySelectorAll('button');
		(strip[tool0] as HTMLButtonElement | undefined)?.focus();
	}
	const score = $derived(parseSpeakingScore(report));
	const medal = $derived(saved === null ? null : speakingMedal(saved));

	// A draft survives a reload: losing 900 typed characters to a stray tap
	// would be the worst thing this exercise could do.
	const draftKey = $derived(`${quiz.storageKeyPrefix}writing_draft`);
	let loadedDraft = $state('');
	$effect(() => {
		const key = draftKey;
		(async () => {
			const raw = (await storage.get(key)) ?? '';
			// Only seed an untouched box, never overwrite live typing.
			if (raw && !loadedDraft) {
				loadedDraft = raw;
				// The surface is not bound to `text`: setting its value would move
				// the caret on every keystroke. It is filled once, here, from the
				// saved draft, and read back by `sync` from then on.
				if (!text && box) {
					box.innerHTML = markersToHtml(raw);
					text = raw;
				}
			}
		})();
	});
	$effect(() => {
		const key = draftKey;
		const value = text;
		if (!value) return;
		storage.set(key, value);
	});

	// The prompt is rebuilt whenever the text changes, so what the learner
	// copies is always what they wrote. Their recent corrections ride along as
	// PERSONAL FOCUS, filtered to this level or below.
	$effect(() => {
		const body = text;
		(async () => {
			const level = quiz.level ?? 'A1';
			const raw = await storage.get(`${SettingsKeys.speakingFixLogPrefix}${courseId}`);
			const fixes: SpeakingFix[] = raw ? JSON.parse(raw) : [];
			const seen = new Set<string>();
			const focus = fixes
				.filter((f) => fixFitsLevel(f.level, level))
				.filter((f) => !seen.has(f.said) && seen.add(f.said))
				.slice(0, 3);
			prompt = renderSpeakingPrompt({
				exercise: asSpeakingExercise(quiz.writing),
				template: template as SpeakingTemplate,
				manifest: manifest as SpeakingManifest,
				learnLang: learnLocale,
				uiLang,
				cefr: level,
				personalFocus: focus.map((f) => `"${f.said}" -> "${f.correct}"`),
				referenceNotes: flattenHelp(),
				learnerText: body,
				charBounds: bounds
			});
		})();
	});

	/**
	 * The quiz's Help Memory tips as plain text — the prompt's judging
	 * standard. The intro is left out on purpose: it is written for the
	 * learner, not for the tutor.
	 */
	function flattenHelp(): string {
		const parts: string[] = [];
		for (const tip of quiz.help?.tips ?? []) {
			parts.push(tip.title ? `- ${tip.title}: ${tip.text}` : `- ${tip.text}`);
		}
		return parts.join('\n');
	}

	async function copy() {
		await navigator.clipboard.writeText(prompt);
		copied = true;
		setTimeout(() => {
			if (index === 1) index = 2;
		}, 650);
	}

	async function save() {
		if (score === null) return;
		saved = score;

		// The FIX: lines are the whole point: they are what to work on next
		// time. Banked against the level so a later, lower exercise can leave
		// them out, and kept on screen here.
		const fixes = parseSpeakingFixes(report).map((f) => ({ ...f, level: quiz.level ?? 'A1' }));
		remembered = fixes.slice(0, 4);
		if (fixes.length > 0) {
			const key = `${SettingsKeys.speakingFixLogPrefix}${courseId}`;
			const raw = await storage.get(key);
			const existing = raw ? JSON.parse(raw) : [];
			await storage.set(key, JSON.stringify([...fixes, ...existing].slice(0, 40)));
		}

		await storage.set(`${quiz.storageKeyPrefix}writing_best`, String(score));
		// Which prompt wording produced this score, so an old medal stays interpretable.
		await storage.set(`${quiz.storageKeyPrefix}writing_template`, String(manifest.templateVersion));
		// The draft is kept on purpose. "Try again" remounts the exercise, and a
		// learner looking at four corrections wants their own text back to mend,
		// not a blank sheet.
		onFinish(score >= passScore, score);
	}
</script>

<svelte:window onkeydown={onWindowKey} />

<Steps
	count={4}
	bind:index
	{labels}
	marks={[
		ready ? 'done' : null,
		copied ? 'done' : null,
		copied ? 'done' : null,
		saved === null ? null : saved >= passScore ? 'right' : 'wrong'
	]}
>
	{#snippet step(i)}
		{#if i === 0}
			<section class="card fill" class:full={expanded}>
				<!-- The brief folds away once there is a text, because from then on
				     the sheet is what the learner needs the room for. The task is
				     one tap away and never more than that. -->
				<button
					type="button"
					class="brief-toggle"
					aria-expanded={brief}
					aria-controls="writing-brief"
					onclick={() => (brief = !brief)}
				>
					<span class="step tnum">1</span>
					<span class="brief-title">{brief ? 'Write your text' : 'The task'}</span>
					<span class="brief-peek">{brief ? '' : quiz.writing.topic}</span>
					<Icon name={brief ? 'chevronDown' : 'chevronRight'} size="0.9em" />
				</button>

				<div id="writing-brief" class="brief" hidden={!brief}>
					<p class="lede">{quiz.writing.topic}</p>
					{#if quiz.writing.practisePoints.length}
						<ul class="points">
							{#each quiz.writing.practisePoints as point (point)}
								<li>{point}</li>
							{/each}
						</ul>
					{/if}
					{#if quiz.writing.material}
						<pre class="material">{quiz.writing.material}</pre>
					{/if}
				</div>

				<!-- The desk: a toolbar, a sheet of writing paper, and a rail that
				     shows how far the text has to go. Writing German is the point,
				     so the sheet gets the room and the chrome stays quiet. -->
				<div class="desk" class:over={fit === 'over'}>
					<!-- One tab stop for the whole strip, arrow keys between the keys:
					     the ARIA toolbar pattern. Tabbing through eight buttons to
					     reach the writing box would be worse than no toolbar, and
					     taking them out of the tab order altogether would hide them
					     from the keyboard users who need an umlaut key most. -->
					<div
						class="tools"
						role="toolbar"
						aria-label="Writing tools"
						aria-controls="writing-box"
						tabindex="-1"
						onkeydown={onToolKey}
					>
						{#each TOOLS as tool, n (tool.label)}
							<button
								type="button"
								class="key {tool.kind}"
								onclick={tool.run}
								tabindex={n === tool0 ? 0 : -1}
								aria-label={tool.label}
								title={tool.label}
							>
								{#if tool.kind === 'wide'}<Icon name="words" size="0.9em" />{/if}
								{tool.text}
							</button>
						{/each}
						<button
							type="button"
							class="key grow"
							onclick={() => (expanded = !expanded)}
							tabindex="-1"
							aria-label={expanded ? 'Leave full screen' : 'Write full screen'}
							title={expanded ? 'Leave full screen' : 'Write full screen'}
						>
							<Icon name={expanded ? 'close' : 'pen'} size="0.9em" />
						</button>
					</div>

					<!-- contenteditable, not a textarea, so bold and italic are really
					     bold and italic rather than asterisks on screen. `text` stays
					     the marker form underneath. -->
					<div
						class="compose"
						id="writing-box"
						bind:this={box}
						contenteditable="true"
						role="textbox"
						aria-multiline="true"
						aria-label="Your text"
						aria-describedby="writing-count"
						data-placeholder="Schreib hier, auf Deutsch …"
						spellcheck="false"
						oninput={sync}
						onpaste={onPaste}
					></div>

					<div class="rail" aria-hidden="true">
						<div class="rail-fill" style="--fill: {fill}"></div>
					</div>

					<p
						id="writing-count"
						class="count"
						class:short={fit === 'short'}
						class:over={fit === 'over'}
						aria-live="polite"
					>
						<span class="n tnum">{chars}</span>
						{#if fit === 'short'}
							<span>of {bounds.min} characters — keep going</span>
						{:else if fit === 'over'}
							<span>characters — {bounds.max} is the limit, trim it a little</span>
						{:else}
							<span>characters, within {bounds.min}–{bounds.max}</span>
						{/if}
						<span class="words tnum">{words} {words === 1 ? 'word' : 'words'}</span>
					</p>
				</div>

				<button class="btn" onclick={() => (index = 1)} disabled={!ready}>
					<Icon name="arrowRight" size="1em" />
					{ready ? 'Done writing' : 'Finish your text first'}
				</button>
			</section>
		{:else if i === 1}
			<section class="card fill">
				<h3><span class="step tnum">2</span> Copy the correction request</h3>
				<p class="lede">
					This carries your own text. Paste it into your AI assistant and it will
					correct what you wrote, then give you a score and a short list of fixes.
				</p>
				<pre class="prompt">{prompt}</pre>
				<button class="btn" onclick={copy} disabled={!ready}>
					<Icon name={copied ? 'check' : 'copy'} size="1em" />
					{copied ? 'Copied' : 'Copy the request'}
				</button>
			</section>
		{:else if i === 2}
			<section class="card center">
				<h3><span class="step tnum">3</span> Open your assistant</h3>
				<div class="ai-links">
					{#each AI_ASSISTANTS as ai (ai.name)}
						<a href={assistantHref(ai, userAgent)} target="_blank" rel="noopener">
							<span class="ai-name">{ai.name}</span>
							<span class="ai-hint">Opens in a new tab</span>
							<Icon name="external" size="0.9em" />
						</a>
					{/each}
				</div>
				<p class="note">
					{copied
						? 'The request is already on your clipboard — just paste it. No voice needed.'
						: 'Copy the request first (one step back), then paste it into your assistant.'}
				</p>
				<button class="btn btn-ghost" onclick={() => (index = 3)}>
					I have my correction <Icon name="arrowRight" size="1em" />
				</button>
			</section>
		{:else}
			<section class="card fill">
				<h3><span class="step tnum">4</span> Bring the correction back</h3>
				<p class="lede">
					Paste the whole report. The <code>SCORE=</code> line is read
					automatically, and the fixes are saved as your next things to work on.
				</p>
				<textarea
					bind:value={report}
					aria-label="The AI's correction report, or your score"
					rows="5"
					placeholder="Paste the report, or type the score"
				></textarea>

				{#if saved === null}
					<button class="btn" onclick={save} disabled={score === null}>
						<Icon name="check" size="1em" />
						{score === null ? 'Enter a score to save' : `Save ${score} / 100`}
					</button>
				{:else}
					<div class="result" class:pass={saved >= passScore} in:pop>
						<Burst trigger={medal ? 1 : 0} count={30} />
						<p class="score tnum">
							{saved} <span class="of">/ 100</span>
							<span class="grade">grade {speakingGrade(saved)}</span>
						</p>
						{#if medal}
							<p class="medal"><Icon name="trophy" size="1.05em" /> {medal} medal</p>
						{:else}
							<p class="medal">
								No medal yet. Your text is kept — tap Try again below to mend it.
							</p>
						{/if}
					</div>

					{#if remembered.length}
						<!-- The reason the exercise exists: a short list to carry into the
						     next one. Also replayed into later prompts as PERSONAL FOCUS. -->
						<div class="focus" in:pop>
							<h4><Icon name="pen" size="1em" /> Work on these next time</h4>
							<ol>
								{#each remembered as fix, n (n)}
									<li>
										<span class="said">{fix.said}</span>
										<Icon name="arrowRight" size="0.8em" />
										<span class="correct">{fix.correct}</span>
									</li>
								{/each}
							</ol>
							<p class="note">
								Saved. Your next speaking or writing exercise will quietly bring
								one or two of them back.
							</p>
							<p class="note">
								Try again below brings your own text back, so you can mend these
								four and send it round once more.
							</p>
						</div>
					{/if}
				{/if}
			</section>
		{/if}
	{/snippet}
</Steps>

<style>
	.card {
		padding: 1.4rem 1.6rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	/* A section that fills the screen, its one tall part (the compose box, the
	   prompt) taking up the slack. */
	.card.fill {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
		align-items: flex-start;
	}

	.card.center {
		margin: auto 0;
	}

	/* -- full screen -------------------------------------------------------
	   The sheet over everything, for a long text. The brief and the step rail
	   stay reachable: Escape or the button in the toolbar comes back. */
	.card.full {
		position: fixed;
		inset: 0;
		z-index: 60;
		margin: 0;
		border: 0;
		border-radius: 0;
		padding: 0.9rem 1rem 1rem;
		background: var(--surface);
	}

	.card.full .desk {
		margin-bottom: 0.7rem;
	}

	/* A little air between the letters and the emphasis pair. */
	.key.bold {
		margin-left: 0.45rem;
	}

	.card.center .btn {
		margin-top: 1.2rem;
	}

	h3 {
		display: flex;
		align-items: baseline;
		gap: 0.5rem;
		margin: 0 0 0.4rem;
		font-size: var(--step-1);
	}

	.step {
		display: inline-grid;
		place-items: center;
		width: 1.6em;
		height: 1.6em;
		border-radius: 50%;
		background: var(--accent-soft, var(--surface-sunken));
		color: var(--accent-ink);
		font-size: var(--step--1);
	}

	/* -- the brief ---------------------------------------------------------
	   One row that is the heading when open and the task itself when closed,
	   so folding it away costs the learner nothing. */
	.brief-toggle {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		width: 100%;
		margin-bottom: 0.5rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--heading);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 600;
		text-align: left;
		cursor: pointer;
	}

	.brief-title {
		flex: none;
	}

	/* The task, shown on the same line once the brief is closed. */
	.brief-peek {
		flex: 1;
		min-width: 0;
		overflow: hidden;
		font-family: 'Inter Variable', 'Inter', system-ui, sans-serif;
		font-size: var(--step--1);
		font-weight: 400;
		color: var(--ink-muted);
		white-space: nowrap;
		text-overflow: ellipsis;
	}

	.brief-toggle :global(svg) {
		flex: none;
		margin-left: auto;
		color: var(--ink-muted);
	}

	.brief {
		align-self: stretch;
	}

	.lede {
		margin: 0 0 0.5rem;
		font-size: var(--step--1);
		line-height: 1.5;
		color: var(--ink-muted);
	}

	.points {
		margin: 0 0 0.6rem;
		padding-left: 1.1rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.45;
	}

	.points li + li {
		margin-top: 0.1rem;
	}

	.material {
		align-self: stretch;
		margin: 0 0 0.7rem;
		padding: 0.7rem 0.9rem;
		border-radius: var(--radius-sm);
		background: var(--surface-sunken);
		font-size: var(--step--1);
		white-space: pre-wrap;
	}

	textarea {
		align-self: stretch;
		width: 100%;
		padding: 0.7rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: inherit;
		font: inherit;
		resize: vertical;
	}

	/* -- the desk ----------------------------------------------------------
	   Writing a letter should look like writing a letter, not like filling in
	   a form field: a cream sheet with a quiet toolbar above it and a length
	   rail below, framed as one object. */
	.desk {
		align-self: stretch;
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
		margin-bottom: 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: #fdfaf2;
		box-shadow: 0 1px 0 rgba(42, 42, 40, 0.04), 0 6px 18px -14px rgba(31, 58, 95, 0.3);
		overflow: hidden;
		transition: border-color var(--fast) var(--ease-out);
	}

	.desk:focus-within {
		border-color: var(--accent);
	}

	.desk.over {
		border-color: var(--wrong);
	}

	.tools {
		flex: none;
		display: flex;
		align-items: center;
		gap: 0.2rem;
		flex-wrap: wrap;
		padding: 0.4rem 0.5rem;
		border-bottom: 1px solid #efe4cd;
		background: #f8f1e0;
	}

	/* A key the learner cannot type on their own keyboard. Big enough for a
	   thumb, quiet enough to ignore once they have a German layout. */
	.key {
		min-width: 2rem;
		padding: 0.3rem 0.45rem;
		border: 1px solid #e4d6b8;
		border-radius: var(--radius-sm);
		background: var(--paper);
		color: var(--ink);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		line-height: 1.1;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.key.wide {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		margin-left: auto;
		font-family: inherit;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* F for fett and K for kursiv, set in the weight they produce, which is
	   how a German word processor labels them. */
	.key.bold {
		font-weight: 700;
	}

	.key.italic {
		font-style: italic;
	}

	.key.grow {
		display: inline-flex;
		align-items: center;
		min-width: 0;
		padding: 0.35rem 0.45rem;
		color: var(--ink-muted);
	}

	.key:hover {
		background: var(--accent-soft);
	}

	.key:active {
		transform: translateY(1px);
	}

	/* The sheet. Serif, generously leaded, because the learner is writing
	   prose and it should read back to them as prose.

	   `min-height: 0` matters: without it a flex item refuses to shrink below
	   its own content, so a long text grew the box and pushed the counter down
	   the card instead of scrolling inside it. The floor lives on the desk. */
	.compose {
		flex: 1 1 0;
		/* An explicit floor also overrides the automatic minimum that stops a
		   flex item shrinking below its own content, which is what let a long
		   text grow the box and carry the counter down the card. */
		min-height: 7rem;
		overflow-y: auto;
		width: 100%;
		padding: 1rem 1.15rem;
		border: 0;
		border-radius: 0;
		background: transparent;
		color: var(--ink);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		line-height: 1.75;
		resize: none;
	}

	.compose:focus {
		outline: none;
	}

	/* contenteditable has no placeholder attribute of its own. */
	.compose:empty::before {
		content: attr(data-placeholder);
		color: #b4a98f;
		font-style: italic;
		pointer-events: none;
	}

	/* The emphasis the learner applied, shown as emphasis. */
	.compose :global(strong) {
		font-weight: 700;
	}

	.compose :global(em) {
		font-style: italic;
	}

	/* How far there is to go, filling towards the minimum. */
	.rail {
		flex: none;
		height: 3px;
		background: #efe4cd;
	}

	.rail-fill {
		height: 100%;
		width: calc(var(--fill) * 100%);
		background: var(--accent);
		transition: width 200ms var(--ease-out);
	}

	.desk.over .rail-fill {
		background: var(--wrong);
	}

	.count {
		flex: none;
		display: flex;
		align-items: baseline;
		gap: 0.4rem;
		margin: 0;
		/* It is a <p>, and prose is capped at --measure. This one is a status
		   bar, so the cap would stop its background two thirds of the way
		   across and leave the sheet showing through behind the word count. */
		max-width: none;
		padding: 0.45rem 0.9rem 0.55rem;
		background: #f8f1e0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.count .n {
		font-weight: 600;
		color: var(--ink);
	}

	.count .words {
		margin-left: auto;
	}

	.count.over,
	.count.over .n {
		color: var(--wrong);
	}

	.prompt {
		align-self: stretch;
		flex: 1;
		min-height: 0;
		overflow: auto;
		margin: 0 0 0.9rem;
		padding: 0.8rem 0.9rem;
		border-radius: var(--radius-sm);
		background: var(--surface-sunken);
		font-size: var(--step--1);
		white-space: pre-wrap;
	}

	.ai-links {
		display: grid;
		gap: 0.5rem;
	}

	.ai-links a {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.7rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		color: inherit;
		text-decoration: none;
	}

	.ai-name {
		font-weight: 600;
	}

	.ai-hint {
		margin-left: auto;
		font-size: var(--step--2);
		color: var(--ink-muted);
	}

	.note {
		margin: 0.8rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.result {
		position: relative;
		align-self: stretch;
		margin-top: 0.9rem;
		text-align: center;
	}

	/* Centred text in a <p> that prose caps at --measure would centre inside
	   the cap, which on a wide card reads as left of centre. */
	.score,
	.medal {
		max-width: none;
	}

	.score {
		margin: 0;
		font-size: var(--step-3);
		font-weight: 700;
	}

	.of {
		color: var(--ink-muted);
		font-size: var(--step-0);
		font-weight: 400;
	}

	.grade {
		display: block;
		font-size: var(--step--1);
		font-weight: 400;
		color: var(--ink-muted);
	}

	.medal {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 0.35rem;
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* The list to carry forward, set apart from the score so it reads as the
	   substance rather than an afterthought. */
	.focus {
		align-self: stretch;
		margin-top: 1rem;
		padding: 0.9rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-sunken);
	}

	.focus h4 {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0 0 0.5rem;
		font-size: var(--step-0);
	}

	.focus ol {
		margin: 0;
		padding-left: 1.3rem;
		display: grid;
		gap: 0.4rem;
	}

	.focus li {
		display: flex;
		align-items: baseline;
		flex-wrap: wrap;
		gap: 0.35rem;
		font-size: var(--step--1);
	}

	.said {
		text-decoration: line-through;
		color: var(--ink-muted);
	}

	.correct {
		font-weight: 600;
	}
</style>
