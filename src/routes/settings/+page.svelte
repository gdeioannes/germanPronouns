<script lang="ts">
	// Settings, plus a jump list into the ladder.
	//
	// Nothing is locked any more, so "set your starting point" no longer has to
	// unlock anything — a learner who already speaks some German just goes
	// straight to the level that suits them.
	import Icon from '$lib/icons/Icon.svelte';
	import { rise } from '$lib/motion';
	import { catalog } from '$lib/content';
	import { loadCourse } from '$lib/content';
	import { buildLadder } from '$lib/domain/ladder';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress, type AnswerRevealMode } from '$lib/state/progress.svelte';
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

	const ladder = $derived(course ? buildLadder(course, () => false) : []);

	async function resetEverything() {
		await progress.reset();
		confirmingReset = false;
		message = 'Progress cleared. Every score, streak and medal is gone.';
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
					On by default: an answer still counts when it's only missing an
					umlaut, an accent, or punctuation like a full stop or apostrophe —
					your keyboard shouldn't decide whether you know the German. The
					correct spelling is still written into the gap afterwards. Turn this
					off to be marked on the exact spelling.
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.wordHelp}
				onchange={(e) => progress.setWordHelp(e.currentTarget.checked)}
			/>
			<span>
				<strong>Word help</strong>
				<small>
					Colours every noun in an exercise by its gender — blue der, red
					die, green das — and lets you tap one for its article, plural and
					meaning. The same switch sits on the exercise itself, so you can
					turn it off mid-quiz when you'd rather be tested than helped.
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
				<small>Starts every fill-in answer off for you.</small>
			</span>
		</label>
	</section>

	<section class="card">
		<h2>Voice</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.voiceOfflineOnly}
				onchange={(e) => progress.setVoiceOfflineOnly(e.currentTarget.checked)}
			/>
			<span>
				<strong>Use this device's voice only</strong>
				<small>
					Sentences are normally read by a neural voice through our audio
					service, which sounds far closer to a native speaker. Tick this to
					keep every sentence on your device instead — the built-in voice is
					more robotic, but nothing is sent anywhere.
				</small>
			</span>
		</label>
	</section>

	<section class="card">
		<h2>Answer reveal</h2>
		<p class="lede">
			After you answer, the correct spelling is written into the gap — green
			when you had it, red when you didn't. This is how long it stays before
			the next question.
		</p>
		<div class="segmented" role="radiogroup" aria-label="Answer reveal speed">
			{#each [['quick', 'Quick'], ['normal', 'Normal'], ['slow', 'Slow']] as [mode, label] (mode)}
				<button
					role="radio"
					aria-checked={progress.answerRevealMode === mode}
					onclick={() => progress.setAnswerRevealMode(mode as AnswerRevealMode)}
				>
					{label}
				</button>
			{/each}
		</div>
	</section>

	<section class="card">
		<h2>Start where you like</h2>
		<p class="lede">
			Every level is open from the start — nothing has to be unlocked. Already
			speak some German? Jump straight in at your level.
		</p>
		<ul class="levels">
			{#each ladder as level (level.id)}
				{#if level.quizzes.length > 0}
					<li>
						<span>{level.title}</span>
						<a href="/course/{course?.id}/quiz/{level.quizzes[0].id}">Start here</a>
					</li>
				{/if}
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

	.segmented {
		display: inline-flex;
		padding: 0.2rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface-alt);
	}

	.segmented button {
		padding: 0.35rem 1.1rem;
		border: 0;
		border-radius: 999px;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.segmented button[aria-checked='true'] {
		background: var(--surface);
		color: var(--ink);
		box-shadow: 0 1px 3px rgba(42, 42, 40, 0.12);
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

	.levels a {
		flex: none;
		padding: 0.32rem 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.levels a:hover {
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
