<script lang="ts">
	// "Recommended for you" — one compact panel, one suggestion, its kind
	// (practise / learn next / mix it up) picked at random rather than chosen.
	// "Next" drops it and brings up a different kind, so a no always shows a
	// new idea rather than the runner-up of the same one. Skips persist, so a
	// dismissed quiz stays dismissed on the next visit.
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { rise } from '$lib/motion';
	import { progress } from '$lib/state/progress.svelte';
	import { storage } from '$lib/services/storage';
	import {
		KIND_LABELS,
		RECOMMENDATION_KINDS,
		pickNext,
		recommend,
		type QuizFacts,
		type Recommendation,
		type RecommendationKind
	} from '$lib/domain/recommend';
	import type { PopulatedCourse } from '$lib/content/types';
	import { untrack } from 'svelte';

	let {
		course,
		ready,
		excludeId
	}: {
		course: PopulatedCourse;
		/** True once the page has loaded progress and the per-quiz stats. */
		ready: boolean;
		/** The "Continue" quiz — it has its own card already. */
		excludeId?: string;
	} = $props();

	// "quiz_" in the key puts it in the set that "start over" wipes.
	const SKIPPED_KEY = 'quiz_recommend_skipped';
	/** Enough memory to cycle usefully without growing forever. */
	const SKIPPED_LIMIT = 60;

	let all = $state<Record<RecommendationKind, Recommendation[]> | null>(null);
	let skipped = $state<string[]>([]);
	let current = $state<Recommendation | null>(null);

	$effect(() => {
		if (!ready) return;
		// Everything below reads rune state it must not subscribe to — a stat
		// written while loading would re-run this and start the load again.
		untrack(() => void load());
	});

	async function load() {
		const facts: Record<string, QuizFacts> = {};
		for (const quiz of course.quizzes) {
			const history = await progress.historyFor(quiz.storageKeyPrefix);
			facts[quiz.id] = {
				done: progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix),
				tier: progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix),
				answered: history.answered,
				mistakeRate: history.mistakeRate
			};
		}
		try {
			const raw = await storage.get(SKIPPED_KEY);
			const parsed = raw ? JSON.parse(raw) : [];
			skipped = Array.isArray(parsed) ? parsed.map(String) : [];
		} catch {
			skipped = [];
		}
		all = recommend(course.quizzes, facts, new Set(excludeId ? [excludeId] : []));
		current = pickNext(all, new Set(skipped), null) ?? freshStart(null);
	}

	/** Every candidate skipped: forget the skips and go round again. */
	function freshStart(from: RecommendationKind | null): Recommendation | null {
		if (!all) return null;
		skipped = [];
		void storage.set(SKIPPED_KEY, '[]');
		return pickNext(all, new Set(), from);
	}

	function skip() {
		if (!all || !current) return;
		skipped = [...skipped.filter((id) => id !== current!.quiz.id), current.quiz.id].slice(
			-SKIPPED_LIMIT
		);
		void storage.set(SKIPPED_KEY, JSON.stringify(skipped));
		const from = current.kind;
		current = pickNext(all, new Set(skipped), from) ?? freshStart(from);
	}

	const hasAny = $derived(all !== null && RECOMMENDATION_KINDS.some((kind) => all![kind].length));
</script>

{#if hasAny && current}
	<!-- One compact panel: which kind was picked is shown, never chosen. -->
	<section class="rec" data-kind={current.kind} aria-label="Recommended for you">
		{#key current.quiz.id}
			<div class="rec-main" in:rise>
				<span class="rec-icon">
					<Icon name={QUIZ_TYPE_ICONS[current.quiz.type]} size="1.1em" />
				</span>
				<div class="rec-body">
					<p class="rec-label">For you · <strong>{KIND_LABELS[current.kind]}</strong></p>
					<p class="rec-title">{current.quiz.title}</p>
					<p class="rec-reason">{current.reason}</p>
				</div>
			</div>
		{/key}
		<div class="rec-actions">
			<a class="rec-go" href="/course/{course.id}/quiz/{current.quiz.id}">
				Go <Icon name="arrowRight" size="1.05em" />
			</a>
			<button
				type="button"
				class="rec-skip"
				onclick={skip}
				aria-label="Next suggestion"
				title="Not this one — suggest something else"
			>
				Next <Icon name="chevronRight" size="1em" />
			</button>
		</div>
	</section>
{/if}

<style>
	/* One colour per kind, used for the accent edge, icon and label. */
	.rec {
		--kind: var(--navy);
		display: flex;
		align-items: center;
		gap: 0.75rem 1rem;
		margin: 1rem 0 0;
		padding: 0.8rem 0.9rem 0.8rem 1rem;
		border: 1px solid var(--line);
		border-left: 4px solid var(--kind);
		border-radius: var(--radius);
		background: var(--surface);
	}
	.rec[data-kind='practise'] {
		--kind: var(--ochre);
	}
	.rec[data-kind='next'] {
		--kind: var(--forest);
	}

	.rec-main {
		display: flex;
		align-items: center;
		gap: 0.8rem;
		flex: 1;
		min-width: 0;
	}

	.rec-icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.1rem;
		height: 2.1rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--kind);
	}

	.rec-body {
		min-width: 0;
	}

	.rec-body p {
		margin: 0;
	}

	.rec-label {
		font-size: 0.7rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.rec-label strong {
		color: var(--kind);
	}

	.rec-title {
		font-weight: 700;
		color: var(--heading);
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.rec-reason {
		font-size: var(--step--1);
		color: var(--ink-muted);
		line-height: 1.4;
	}

	.rec-actions {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		flex: none;
	}

	/* Both buttons wear the kind's colour: Go filled, Next outlined — big
	   enough to read at a glance, and Go clearly the main action. */
	.rec-go,
	.rec-skip {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.65rem 1.25rem;
		border: 2px solid var(--kind);
		border-radius: 999px;
		font: inherit;
		font-weight: 800;
		line-height: 1.2;
		white-space: nowrap;
		text-decoration: none;
		cursor: pointer;
		transition:
			transform var(--fast, 140ms) var(--ease-out, ease-out),
			box-shadow var(--fast, 140ms) var(--ease-out, ease-out),
			background var(--fast, 140ms) var(--ease-out, ease-out);
	}

	.rec-go {
		background: var(--kind);
		color: #fff;
		box-shadow: 0 10px 22px -14px var(--kind);
	}

	.rec-go:hover {
		transform: translateY(-2px);
		box-shadow: 0 14px 26px -14px var(--kind);
	}

	.rec-go :global(.icon) {
		transition: transform var(--medium, 260ms) var(--ease-out, ease-out);
	}

	.rec-go:hover :global(.icon) {
		transform: translateX(3px);
	}

	.rec-skip {
		background: var(--surface);
		color: var(--kind);
	}

	.rec-skip:hover {
		background: var(--surface-alt);
		transform: translateY(-2px);
	}

	.rec-go:active,
	.rec-skip:active {
		transform: translateY(0) scale(0.97);
	}

	/* Phones: the buttons drop under the text instead of squeezing it. */
	@media (max-width: 36rem) {
		.rec {
			flex-wrap: wrap;
		}
		.rec-actions {
			width: 100%;
		}
		.rec-go,
		.rec-skip {
			flex: 1;
			justify-content: center;
		}
		.rec-title {
			white-space: normal;
		}
	}
</style>
