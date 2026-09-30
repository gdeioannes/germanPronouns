<script lang="ts">
	// The AI-handoff speaking exercise: render a prompt, the learner runs it in
	// their own assistant in voice mode, then pastes the report back. The app
	// reads the SCORE= line, awards the medal and banks the FIX: corrections.
	//
	// The three stages are three sections of one screen each (see Steps).
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
		resolveSession,
		type SpeakingManifest,
		type SpeakingTemplate
	} from '$lib/domain/speakingPrompt';
	import { SettingsKeys } from '$lib/domain/keys';
	import type { SpeakingFix } from '$lib/domain/progress';
	import { storage } from '$lib/services/storage';
	import { AI_ASSISTANTS, assistantHref } from '$lib/services/aiApps';
	import type { SpeakingQuiz } from '$lib/content/types';

	let {
		quiz,
		courseId,
		learnLocale,
		uiLang,
		onFinish
	}: {
		quiz: SpeakingQuiz;
		courseId: string;
		learnLocale: string;
		uiLang: string;
		onFinish: (passed: boolean, score: number) => void;
	} = $props();

	const session = $derived(resolveSession(quiz.speaking, manifest as SpeakingManifest));

	let prompt = $state('');
	let copied = $state(false);
	let report = $state('');
	let saved = $state<number | null>(null);
	let index = $state(0);
	const labels = ['Copy', 'Talk', 'Score'];

	// The page is reused from one speaking quiz to the next: start it over.
	$effect(() => {
		quiz.id;
		index = 0;
		copied = false;
		report = '';
		saved = null;
	});

	// Read in the browser only, so the prerendered page keeps the web links.
	let userAgent = $state('');
	$effect(() => {
		userAgent = navigator.userAgent;
	});

	const score = $derived(parseSpeakingScore(report));
	const medal = $derived(saved === null ? null : speakingMedal(saved));

	$effect(() => {
		(async () => {
			// The learner's recent corrections ride along as PERSONAL FOCUS, so
			// the AI weaves one or two back in and reports on improvement. Only
			// fixes from this level or below: a B1 Perfekt slip has no place in
			// an A1 interview. Deduplicated, as the same slip recurs.
			const level = quiz.level ?? 'A1';
			const raw = await storage.get(`${SettingsKeys.speakingFixLogPrefix}${courseId}`);
			const fixes: SpeakingFix[] = raw ? JSON.parse(raw) : [];
			const seen = new Set<string>();
			const focus = fixes
				.filter((f) => fixFitsLevel(f.level, level))
				.filter((f) => !seen.has(f.said) && seen.add(f.said))
				.slice(0, 3);
			prompt = renderSpeakingPrompt({
				exercise: quiz.speaking,
				template: template as SpeakingTemplate,
				manifest: manifest as SpeakingManifest,
				learnLang: learnLocale,
				uiLang,
				cefr: level,
				personalFocus: focus.map((f) => `"${f.said}" -> "${f.correct}"`),
				referenceNotes: flattenHelp(),
				pictureDescription: quiz.imageDescription ?? ''
			});
		})();
	});

	/**
	 * The quiz's Help Memory tips as plain text — the prompt's judging
	 * standard. The intro is left out on purpose: it is written for the
	 * learner ("copy this, switch on voice mode…"), not for the tutor.
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
		// Copied is done with: show where to paste it.
		setTimeout(() => {
			if (index === 0) index = 1;
		}, 650);
	}

	async function save() {
		if (score === null) return;
		saved = score;

		// A pasted report carries more than the score: its FIX: lines are the
		// learner's actual mistakes. Bank them for the personal-focus loop.
		// Tagged with the level, so a later, lower session can leave them out.
		const fixes = parseSpeakingFixes(report).map((f) => ({ ...f, level: quiz.level ?? 'A1' }));
		if (fixes.length > 0) {
			const key = `${SettingsKeys.speakingFixLogPrefix}${courseId}`;
			const raw = await storage.get(key);
			const existing = raw ? JSON.parse(raw) : [];
			await storage.set(key, JSON.stringify([...fixes, ...existing].slice(0, 40)));
		}

		await storage.set(`${quiz.storageKeyPrefix}speaking_best`, String(score));
		onFinish(score >= session.passScore, score);
	}
</script>

<Steps count={3} bind:index {labels} marks={[copied ? 'done' : null, copied ? 'done' : null, saved === null ? null : saved >= session.passScore ? 'right' : 'wrong']}>
	{#snippet step(i)}
		{#if i === 0}
			<section class="card fill">
				<h3><span class="step tnum">1</span> Copy the exercise</h3>
				<p class="lede">
					This exercise runs in your own AI assistant, in voice mode — about
					{session.durationMinutes} minutes. Copy the prompt, paste it there, and
					follow its instructions.
				</p>
				{#if quiz.image}
					<!-- The picture the session opens with: the tutor cannot see it, the
					     prompt tells it what is there, and the learner describes it. -->
					<figure class="scene">
						<img src="/img/{quiz.image}.webp" alt={quiz.imageDescription} width="1024" height="768" />
						<figcaption>Start by describing this picture — your assistant will ask you to.</figcaption>
					</figure>
				{/if}
				<pre class="prompt">{prompt}</pre>
				<button class="btn" onclick={copy}>
					<Icon name={copied ? 'check' : 'copy'} size="1em" />
					{copied ? 'Copied' : 'Copy the prompt'}
				</button>
			</section>
		{:else if i === 1}
			<section class="card center">
				<h3><span class="step tnum">2</span> Open your assistant</h3>
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
						? 'The prompt is already on your clipboard — just paste it, switch to voice, and talk.'
						: 'Copy the prompt first (one step back), then paste it into your assistant.'}
				</p>
				<button class="btn btn-ghost" onclick={() => (index = 2)}>
					I have my score <Icon name="arrowRight" size="1em" />
				</button>
			</section>
		{:else}
			<section class="card fill">
				<h3><span class="step tnum">3</span> Bring the score back</h3>
				<p class="lede">
					Paste the whole report the AI gives you (or just the number). The
					<code>SCORE=</code> line is read automatically.
				</p>
				<textarea
					bind:value={report}
					rows="5"
					placeholder="Paste the report, or type the score"
				></textarea>

				{#if saved === null}
					<button class="btn" onclick={save} disabled={score === null}>
						<Icon name="check" size="1em" />
						{score === null ? 'Enter a score to save' : `Save ${score} / 100`}
					</button>
				{:else}
					<div class="result" class:pass={saved >= session.passScore} in:pop>
						<Burst trigger={medal ? 1 : 0} count={30} />
						<p class="score tnum">
							{saved} <span class="of">/ 100</span>
							<span class="grade">grade {speakingGrade(saved)}</span>
						</p>
						{#if medal}
							<p class="medal">
								<Icon name="trophy" size="1.05em" /> {medal} medal
							</p>
						{:else}
							<p class="medal">No medal yet — run it again when you're ready.</p>
						{/if}
					</div>
				{/if}
			</section>
		{/if}
	{/snippet}
</Steps>

<style>
	/* A cream panel, the scene's own paper colour, so picture and caption
	   read as one framed illustration on the white card. */
	.scene {
		margin: 0 0 0.8rem;
		padding: 0.4rem 0.9rem 0.7rem;
		border-radius: var(--radius-sm);
		background: #fbf5e4;
		text-align: center;
	}

	.scene img {
		display: block;
		width: min(100%, 24rem);
		height: auto;
		max-height: min(15rem, 30dvh);
		margin: 0 auto;
		object-fit: cover;
	}

	.scene figcaption {
		margin-top: 0.2rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.card {
		padding: 1.4rem 1.6rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	/* A section that fills the screen, its one tall part (the prompt, the
	   report box) taking up the slack. */
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

	.card.center .btn {
		margin-top: 1.2rem;
	}

	h3 {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		margin: 0 0 0.45rem;
		font-size: var(--step-1);
	}

	/* A numbered step badge, so the three stages read as a sequence. */
	.step {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.6em;
		height: 1.6em;
		flex: none;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-family: 'Inter Variable', 'Inter', sans-serif;
		font-size: 0.62em;
		font-weight: 800;
	}

	.lede {
		margin: 0 0 1.1rem;
		max-width: var(--measure);
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	/* The prompt is machine text the learner copies, never reads closely —
	   so it is set small, monospaced and scroll-capped. */
	.prompt {
		flex: 1;
		min-height: 5rem;
		width: 100%;
		overflow: auto;
		padding: 0.95rem 1.05rem;
		margin: 0 0 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font-family: ui-monospace, 'Cascadia Code', 'SF Mono', Consolas, monospace;
		font-size: 0.78rem;
		line-height: 1.6;
		white-space: pre-wrap;
		color: var(--ink-muted);
	}

	.ai-links {
		display: flex;
		gap: 0.6rem;
		flex-wrap: wrap;
	}

	.ai-links a {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.5rem 1.05rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--ink);
		text-decoration: none;
		font-weight: 600;
		font-size: var(--step--1);
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.ai-links a:hover {
		border-color: var(--accent);
		color: var(--accent);
		transform: translateY(-1px);
	}

	/* Phones keep the compact pills; the hint only earns its space on desktop. */
	.ai-hint {
		display: none;
	}

	/* Desktop: the hand-off step becomes a centred panel of three big tiles,
	   rather than a row of small pills lost in a wide card. */
	@media (min-width: 36rem) {
		.card {
			padding: 2rem 2.4rem;
		}

		.card.center {
			display: flex;
			flex-direction: column;
			align-items: center;
			text-align: center;
			padding: 2.6rem 2.4rem;
		}

		.card.center h3 {
			margin-bottom: 1.6rem;
			font-size: var(--step-2);
		}

		.ai-links {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 1rem;
			width: 100%;
			max-width: 40rem;
		}

		.ai-links a {
			position: relative;
			flex-direction: column;
			align-items: flex-start;
			gap: 0.3rem;
			padding: 1.25rem 1.3rem 1.15rem;
			border-radius: var(--radius);
			background: var(--bg);
			text-align: left;
			box-shadow: 0 1px 0 var(--line);
		}

		.ai-links a:hover {
			transform: translateY(-3px);
			box-shadow: 0 10px 24px -14px var(--navy);
		}

		.ai-links a :global(svg) {
			position: absolute;
			top: 1.15rem;
			right: 1.15rem;
			color: var(--ink-muted);
			transition: color var(--fast) var(--ease-out);
		}

		.ai-links a:hover :global(svg) {
			color: var(--accent);
		}

		.ai-name {
			font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
			font-size: var(--step-1);
			font-weight: 700;
			color: var(--heading);
			transition: color var(--fast) var(--ease-out);
		}

		.ai-links a:hover .ai-name {
			color: var(--accent);
		}

		.ai-hint {
			display: block;
			font-size: 0.78rem;
			font-weight: 500;
			color: var(--ink-muted);
		}

		.card.center .note {
			max-width: 34rem;
			margin-top: 1.4rem;
		}

		.card.center .btn {
			margin-top: 1.6rem;
		}
	}

	.note {
		margin: 0.8rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	textarea {
		flex: 1;
		min-height: 5rem;
		max-height: 16rem;
		width: 100%;
		padding: 0.72rem 0.9rem;
		margin-bottom: 1.1rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--bg);
		font: inherit;
		font-size: var(--step--1);
		resize: vertical;
		transition:
			border-color var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	textarea:focus {
		outline: none;
		border-color: var(--accent);
		box-shadow: 0 0 0 3px var(--accent-soft);
	}

	.result {
		position: relative;
		width: 100%;
		padding: 1rem 1.15rem;
		border-radius: var(--radius-sm);
		background: var(--wrong-bg);
		border: 1px solid var(--wrong);
	}

	.result.pass {
		background: var(--right-bg);
		border-color: var(--right);
	}

	.score {
		display: flex;
		align-items: baseline;
		gap: 0.45rem;
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-3);
		font-weight: 700;
		line-height: 1;
		color: var(--heading);
	}

	.of {
		font-size: 0.5em;
		font-weight: 600;
		color: var(--ink-muted);
	}

	.grade {
		margin-left: auto;
		font-family: 'Inter Variable', 'Inter', sans-serif;
		font-size: 0.34em;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.medal {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0.45rem 0 0;
		font-size: var(--step--1);
		text-transform: capitalize;
		color: var(--ink-muted);
	}
</style>
