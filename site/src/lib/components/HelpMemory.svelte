<script lang="ts">
	// A quiz's Help Memory: the intro plus its tip cards. Every quiz has one
	// (the Dart gate test enforces it), and it auto-opens on first visit.
	import { SettingsKeys } from '$lib/domain/keys';
	import { storage } from '$lib/services/storage';
	import type { QuizHelp } from '$lib/content/types';

	let { help, quizId }: { help?: QuizHelp; quizId: string } = $props();

	let open = $state(false);

	$effect(() => {
		// First visit to this quiz opens the panel unprompted, so the rules are
		// read before the first question rather than discovered by failing.
		(async () => {
			const raw = await storage.get(SettingsKeys.seenHelpMemory);
			const seen: string[] = raw ? JSON.parse(raw) : [];
			if (!seen.includes(quizId)) {
				open = true;
				await storage.set(
					SettingsKeys.seenHelpMemory,
					JSON.stringify([...seen, quizId])
				);
			}
		})();
	});
</script>

{#if help?.intro || help?.tips?.length}
	<section class="help">
		<button class="toggle" onclick={() => (open = !open)} aria-expanded={open}>
			<span>How this works</span>
			<span class="chevron" class:open aria-hidden="true">›</span>
		</button>

		{#if open}
			<div class="body">
				{#if help.intro}
					<p class="intro">{help.intro}</p>
				{/if}
				{#each help.tips ?? [] as tip (tip.text)}
					<div class="tip">
						{#if tip.title}<h4>{tip.title}</h4>{/if}
						<p>{tip.text}</p>
					</div>
				{/each}
			</div>
		{/if}
	</section>
{/if}

<style>
	.help {
		margin: 0 0 1.5rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
		overflow: hidden;
	}

	.toggle {
		display: flex;
		width: 100%;
		align-items: center;
		justify-content: space-between;
		padding: 0.85rem 1rem;
		border: 0;
		background: none;
		font: inherit;
		font-weight: 700;
		color: var(--ink);
		cursor: pointer;
	}

	.chevron {
		transition: transform 0.15s;
		font-size: 1.2rem;
		color: var(--muted);
	}

	.chevron.open {
		transform: rotate(90deg);
	}

	.body {
		padding: 0 1rem 1rem;
	}

	.intro {
		margin: 0 0 1rem;
		color: var(--ink-soft);
	}

	.tip {
		padding: 0.75rem 0.9rem;
		margin-bottom: 0.6rem;
		border-left: 3px solid var(--accent);
		border-radius: 0 8px 8px 0;
		background: var(--surface-alt);
	}

	.tip h4 {
		margin: 0 0 0.25rem;
		font-size: 0.9rem;
		color: var(--ink);
	}

	.tip p {
		margin: 0;
		font-size: 0.92rem;
		color: var(--ink-soft);
	}
</style>
