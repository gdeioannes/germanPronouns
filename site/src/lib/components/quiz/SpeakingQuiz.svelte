<script lang="ts">
	// The AI-handoff speaking exercise: render a prompt, the learner runs it in
	// their own assistant in voice mode, then pastes the report back. The app
	// reads the SCORE= line, awards the medal and banks the FIX: corrections.
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
	<h3>1 · Copy the exercise</h3>
	<p class="lede">
		This exercise runs in your own AI assistant, in voice mode — about
		{session.durationMinutes} minutes. Copy the prompt, paste it there, and
		follow its instructions.
	</p>
	<pre class="prompt">{prompt}</pre>
	<button class="primary" onclick={copy}>
		{copied ? '✓ Copied' : 'Copy the prompt'}
	</button>
</section>

{#if copied}
	<section class="card">
		<h3>2 · Open your assistant</h3>
		<div class="ai-links">
			<a href="https://claude.ai/new" target="_blank" rel="noopener">Claude</a>
			<a href="https://chatgpt.com/" target="_blank" rel="noopener">ChatGPT</a>
			<a href="https://gemini.google.com/app" target="_blank" rel="noopener">Gemini</a>
		</div>
		<p class="note">The prompt is already on your clipboard — just paste it.</p>
	</section>
{/if}

<section class="card">
	<h3>3 · Bring the score back</h3>
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
		<button class="primary" onclick={save} disabled={score === null}>
			{score === null ? 'Enter a score to save' : `Save ${score} / 100`}
		</button>
	{:else}
		<div class="result" class:pass={saved >= session.passScore}>
			<p class="score">{saved} / 100 · grade {speakingGrade(saved)}</p>
			{#if medal}
				<p class="medal">{medal} medal</p>
			{:else}
				<p class="medal">No medal yet — run it again when you're ready.</p>
			{/if}
		</div>
	{/if}
</section>

<style>
	.card {
		padding: 1.25rem 1.5rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
	}

	h3 {
		margin: 0 0 0.4rem;
		font-size: 1rem;
		color: var(--ink);
	}

	.lede {
		margin: 0 0 1rem;
		color: var(--ink-soft);
		font-size: 0.93rem;
	}

	.prompt {
		max-height: 16rem;
		overflow: auto;
		padding: 0.9rem;
		margin: 0 0 1rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface-alt);
		font-family: ui-monospace, 'Cascadia Code', Consolas, monospace;
		font-size: 0.8rem;
		line-height: 1.5;
		white-space: pre-wrap;
	}

	.ai-links {
		display: flex;
		gap: 0.6rem;
		flex-wrap: wrap;
	}

	.ai-links a {
		padding: 0.5rem 1rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		color: var(--ink);
		text-decoration: none;
		font-weight: 600;
		font-size: 0.9rem;
	}

	.ai-links a:hover {
		border-color: var(--accent);
	}

	.note {
		margin: 0.75rem 0 0;
		font-size: 0.85rem;
		color: var(--muted);
	}

	textarea {
		width: 100%;
		box-sizing: border-box;
		padding: 0.7rem 0.85rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--bg);
		font: inherit;
		font-size: 0.95rem;
		resize: vertical;
	}

	.result {
		padding: 0.9rem 1rem;
		border-radius: 10px;
		background: #f9ebe7;
		border: 1px solid #e2b4a6;
	}

	.result.pass {
		background: #eaf4ec;
		border-color: #a9cfb3;
	}

	.score {
		margin: 0;
		font-size: 1.2rem;
		font-weight: 800;
		color: var(--ink);
	}

	.medal {
		margin: 0.2rem 0 0;
		text-transform: capitalize;
		color: var(--ink-soft);
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

	.primary:disabled {
		opacity: 0.45;
		cursor: default;
	}
</style>
