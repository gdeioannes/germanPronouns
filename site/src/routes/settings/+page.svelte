<script lang="ts">
	// Settings, plus the "set your starting point" flow.
	//
	// The placement rule carried over from the Dart app: placing opens the
	// levels but awards no medals, and it writes to a SEPARATE unlocked set
	// rather than the completion sets — so the progress ring stays honest about
	// what was actually earned.
	import Icon from '$lib/icons/Icon.svelte';
	import { rise } from '$lib/motion';
	import { catalog } from '$lib/content';
	import { loadCourse } from '$lib/content';
	import { buildLadder } from '$lib/domain/ladder';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
	import type { PopulatedCourse } from '$lib/content/types';

	let course = $state<PopulatedCourse | null>(null);
	let confirmingReset = $state(false);
	let message = $state('');

	$effect(() => {
		(async () => {
			const loaded = await loadCourse(catalog.defaultCourseId);
			course = loaded;
			if (!progress.loaded) await progress.load(loaded.gating ?? DEFAULT_GATING);
		})();
	});

	const ladder = $derived(
		course ? buildLadder(course, () => false, () => false) : []
	);

	/** Opens everything up to and including the chosen level. */
	async function placeAt(levelIndex: number) {
		const refs: string[] = [];
		for (let i = 0; i <= levelIndex; i++) {
			refs.push(...ladder[i].quizzes.map((q) => q.id));
		}
		await progress.setPlacementUnlocked(refs);
		message = `Opened everything up to ${ladder[levelIndex].title}. No medals were awarded — those are still yours to earn.`;
	}

	async function resetEverything() {
		await progress.reset();
		confirmingReset = false;
		message = 'Progress cleared. Every level is locked again except the first.';
	}
</script>

<svelte:head>
	<title>Settings — Language Quiz</title>
	<meta name="robots" content="noindex" />
</svelte:head>

<main class="page">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>
	<h1>Settings</h1>

	{#if message}
		<p class="message" in:rise>
			<Icon name="info" size="1.05em" />
			<span>{message}</span>
		</p>
	{/if}

	<section class="card">
		<h2>Answer checking</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.relaxedCorrection}
				onchange={(e) => progress.setRelaxedCorrection(e.currentTarget.checked)}
			/>
			<span>
				<strong>Relaxed correction</strong>
				<small>
					Accept answers missing an umlaut or accent — useful when your keyboard
					can't reach ä, ö, ü or ß.
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.showFirstLetterHint}
				onchange={(e) => progress.setShowFirstLetterHint(e.currentTarget.checked)}
			/>
			<span>
				<strong>Show the first letter</strong>
				<small>A nudge on every fill-in question.</small>
			</span>
		</label>
	</section>

	<section class="card">
		<h2>Set your starting point</h2>
		<p class="lede">
			Already know some German? Open the ladder at your level. This gives no
			medals and no ribbons — it only unlocks, so your progress ring keeps
			telling the truth.
		</p>
		<ul class="levels">
			{#each ladder as level, i (level.id)}
				<li>
					<span>{level.title}</span>
					<button onclick={() => placeAt(i)}>Start here</button>
				</li>
			{/each}
		</ul>
	</section>

	<section class="card danger">
		<h2>Start over</h2>
		<p class="lede">
			Clears every score, streak and medal in this browser. This cannot be
			undone.
		</p>
		{#if confirmingReset}
			<button class="danger-btn" onclick={resetEverything}>
				<Icon name="trash" size="1em" /> Yes, delete my progress
			</button>
			<button class="btn-quiet" onclick={() => (confirmingReset = false)}>Cancel</button>
		{:else}
			<button class="danger-btn" onclick={() => (confirmingReset = true)}>
				<Icon name="trash" size="1em" /> Delete all progress
			</button>
		{/if}
	</section>
</main>

<style>
	h1 {
		margin: 0 0 1.25rem;
	}

	h2 {
		margin: 0 0 0.6rem;
		font-size: 1.05rem;
	}

	.card {
		padding: 1.35rem 1.6rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.card.danger {
		border-color: var(--wrong);
	}

	.lede {
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.message {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		max-width: none;
		padding: 0.85rem 1.05rem;
		margin-bottom: 1rem;
		border: 1px solid var(--right);
		border-radius: var(--radius-sm);
		background: var(--right-bg);
		color: var(--right);
	}

	.row {
		display: flex;
		gap: 0.7rem;
		align-items: flex-start;
		padding: 0.6rem 0;
		cursor: pointer;
	}

	.row input {
		margin-top: 0.25rem;
	}

	.row small {
		display: block;
		margin-top: 0.1rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.levels {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.levels li {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		padding: 0.45rem 0;
		border-top: 1px solid var(--line);
		font-size: var(--step--1);
	}

	.levels button {
		flex: none;
		padding: 0.32rem 0.9rem;
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
			color var(--fast) var(--ease-out);
	}

	.levels button:hover {
		border-color: var(--accent);
		color: var(--accent);
	}

	.danger-btn {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.58rem 1.2rem;
		border: 0;
		border-radius: 999px;
		background: var(--wrong);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
	}

	.danger-btn:hover {
		transform: translateY(-1px);
	}
</style>
