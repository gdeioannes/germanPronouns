<script lang="ts">
	// The AI-handoff speaking exercise: render a prompt, the learner runs it in
	// their own assistant in voice mode, then pastes the report back. The app
	// reads the SCORE= line, awards the medal and banks the FIX: corrections.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
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
		renderSpeakingPrompt,
		resolveSession,
		type SpeakingManifest,
		type SpeakingTemplate
	} from '$lib/domain/speakingPrompt';
	import { SettingsKeys } from '$lib/domain/keys';
	import { storage } from '$lib/services/storage';
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

	const score = $derived(parseSpeakingScore(report));
	const medal = $derived(saved === null ? null : speakingMedal(saved));

	$effect(() => {
		(async () => {
			// The learner's recent corrections ride along as PERSONAL FOCUS, so
			// the AI weaves one or two back in and reports on improvement.
			const raw = await storage.get(`${SettingsKeys.speakingFixLogPrefix}${courseId}`);
			const fixes: { said: string; correct: string }[] = raw ? JSON.parse(raw) : [];
			prompt = renderSpeakingPrompt({
				exercise: quiz.speaking,
				template: template as SpeakingTemplate,
				manifest: manifest as SpeakingManifest,
				learnLang: learnLocale,
				uiLang,
				cefr: quiz.level ?? 'A1',
				personalFocus: fixes.slice(0, 3).map((f) => `"${f.said}" -> "${f.correct}"`),
				referenceNotes: flattenHelp()
			});
		})();
	});

	/** The quiz's Help Memory as plain text — the prompt's COURSE NOTES. */
	function flattenHelp(): string {
		const parts: string[] = [];
		if (quiz.help?.intro) parts.push(quiz.help.intro.trim());
		for (const tip of quiz.help?.tips ?? []) {
			parts.push(tip.title ? `- ${tip.title}: ${tip.text}` : `- ${tip.text}`);
		}
		return parts.join('\n');
	}

	async function copy() {
		await navigator.clipboard.writeText(prompt);
		copied = true;
	}

	async function save() {
		if (score === null) return;
		saved = score;

		// A pasted report carries more than the score: its FIX: lines are the
		// learner's actual mistakes. Bank them for the personal-focus loop.
		const fixes = parseSpeakingFixes(report);
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

<section class="card">
	<h3><span class="step tnum">1</span> Copy the exercise</h3>
	<p class="lede">
		This exercise runs in your own AI assistant, in voice mode — about
		{session.durationMinutes} minutes. Copy the prompt, paste it there, and
		follow its instructions.
	</p>
	<pre class="prompt">{prompt}</pre>
	<button class="btn" onclick={copy}>
		<Icon name={copied ? 'check' : 'copy'} size="1em" />
		{copied ? 'Copied' : 'Copy the prompt'}
	</button>
</section>

{#if copied}
	<section class="card" in:pop={{ from: 0.94 }}>
			<h3><span class="step tnum">2</span> Open your assistant</h3>
		<div class="ai-links">
			{#each [['Claude', 'https://claude.ai/new'], ['ChatGPT', 'https://chatgpt.com/'], ['Gemini', 'https://gemini.google.com/app']] as [name, url] (name)}
				<a href={url} target="_blank" rel="noopener">
					{name}<Icon name="external" size="0.9em" />
				</a>
			{/each}
		</div>
		<p class="note">The prompt is already on your clipboard — just paste it.</p>
	</section>
{/if}

<section class="card">
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

<style>
	.card {
		padding: 1.4rem 1.6rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
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
		font-family: 'Inter', sans-serif;
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
		max-height: 15rem;
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

	.note {
		margin: 0.8rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	textarea {
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
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
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
		font-family: 'Inter', sans-serif;
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
