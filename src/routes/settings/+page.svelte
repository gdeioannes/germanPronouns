<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	// Settings, plus a jump list into the ladder.
	//
	// Nothing is locked any more, so "set your starting point" no longer has to
	// unlock anything — a learner who already speaks some German just goes
	// straight to the level that suits them.
	import Icon from '$lib/icons/Icon.svelte';
	import PracticeReminder from '$lib/components/PracticeReminder.svelte';
	import { rise } from '$lib/motion';
	import { playSound } from '$lib/services/sounds';
	import { forgetFirstSeen } from '$lib/services/analytics';
	import { catalog } from '$lib/content';
	import { loadCourse } from '$lib/content';
	import { buildLadder } from '$lib/domain/ladder';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress, type AnswerRevealMode } from '$lib/state/progress.svelte';
	import { announce, radioKeys } from '$lib/a11y.svelte';
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
		forgetFirstSeen();
		confirmingReset = false;
		message = 'Progress cleared. Every score, streak and medal is gone.';
		announce(message);
	}
</script>

<Seo title="Settings — Language Quiz" description="Your Language Quiz settings." path="/settings" noindex />

<main class="page">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>
	<h1>Settings</h1>

	{#if message}
		<p class="message" in:rise>
			<Icon name="info" size="1.05em" />
			<span>{message}</span>
		</p>
	{/if}

	<PracticeReminder />

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
		<h2>Effects</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.muted}
				onchange={(e) => progress.setMuted(e.currentTarget.checked)}
			/>
			<span>
				<strong>Mute the app</strong>
				<small>
					Silences everything: the sound effects and the voice that reads
					German aloud. Listening and dictation exercises need that voice, so
					unmute before you do one of those.
				</small>
			</span>
		</label>

		<label class="row" class:off={progress.muted}>
			<input
				type="checkbox"
				checked={progress.soundEffects}
				disabled={progress.muted}
				onchange={(e) => {
					progress.setSoundEffects(e.currentTarget.checked);
					if (e.currentTarget.checked) playSound('right');
				}}
			/>
			<span>
				<strong>Sound effects</strong>
				<small>
					A chime for a right answer — climbing higher as your streak grows —
					a soft low note for a miss, and a little fanfare when you finish.
					Separate from the calm setting below, so you can have one without
					the other.
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.calmEffects}
				onchange={(e) => progress.setCalmEffects(e.currentTarget.checked)}
			/>
			<span>
				<strong>Calm effects</strong>
				<small>
					Turns off the flashy extras: confetti, the words of praise that pop
					up after a right answer, the coloured glow at the screen edges, the
					shake after a miss and the flickering streak flame. Right and wrong
					are still shown in the answer itself. Your device's "reduce motion"
					setting does the same.
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.showTranscripts}
				onchange={(e) => progress.setShowTranscripts(e.currentTarget.checked)}
			/>
			<span>
				<strong>Show the text in listening exercises</strong>
				<small>
					For when you can't hear the audio: dictations and listening
					exercises get a "Show the text" button, so you can read what is
					said instead of hearing it.
				</small>
			</span>
		</label>
	</section>

	<section class="card">
		<h2>Answer reveal</h2>
		<p class="lede">
			After you answer, the correct spelling is written into the gap — green
			when you had it, red when you didn't. This is how long it stays before
			the next question. <strong>Wait for me</strong> never moves on by
			itself: press Next or Enter when you're ready.
		</p>
		<div class="segmented" role="radiogroup" aria-label="Answer reveal speed" use:radioKeys>
			{#each [['quick', 'Quick'], ['normal', 'Normal'], ['slow', 'Slow'], ['manual', 'Wait for me']] as [mode, label] (mode)}
				<button
					type="button"
					role="radio"
					aria-checked={progress.answerRevealMode === mode}
					tabindex={progress.answerRevealMode === mode ? 0 : -1}
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

	<section class="card">
		<h2>Privacy</h2>
		<p class="lede">
			This site uses no cookies and collects no personal data. Anonymous usage
			statistics (which pages are visited, and whether a visit comes from a
			search engine or a shared link) are gathered without any identifier,
			via Aptabase in the EU. The only thing kept on your device for
			statistics is the date of your first visit — no name, no ID, nothing
			unique — so we can tell new visitors from returning ones in aggregate.
			Your learning progress stays in this browser and never leaves it.
		</p>
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

	/* A switch that the mute currently overrides. */
	.row.off {
		opacity: 0.55;
		cursor: default;
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

	@media (max-width: 30rem) {
		.segmented button {
			padding: 0.35rem 0.7rem;
			white-space: nowrap;
		}
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
		color: var(--accent-ink);
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
