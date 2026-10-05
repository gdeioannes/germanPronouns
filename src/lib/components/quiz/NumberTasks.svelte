<script lang="ts">
	// The first quiz's task menu: small real-life jobs that need numbers, picked
	// by interest. Finishing any one completes the quiz; the others stay open
	// with a tick.
	import BarTask from './BarTask.svelte';
	import CallTask from './CallTask.svelte';
	import UbahnTask from './UbahnTask.svelte';
	import NumberBoardQuiz from './NumberBoardQuiz.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { imageGuard } from './imageGuard';
	import callContent from '$content/tasks/call_after_party.json';
	import barContent from '$content/tasks/order_the_round.json';
	import ubahnContent from '$content/tasks/last_ubahn.json';
	import type { CallTaskContent } from '$lib/domain/callTask';
	import type { BarTaskContent } from '$lib/domain/barTask';
	import type { UbahnTaskContent } from '$lib/domain/ubahnTask';
	import type { FillBlankQuiz } from '$lib/content/types';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { untrack } from 'svelte';

	let {
		quiz,
		locale,
		onFinish
	}: {
		quiz: FillBlankQuiz;
		locale: string;
		onFinish: () => void;
	} = $props();

	type TaskId = 'call' | 'board' | 'round' | 'ubahn';

	interface TaskCard {
		id: TaskId;
		title: string;
		blurb: string;
		time?: string;
		image?: string;
		emoji: string;
		soon?: boolean;
		first?: boolean;
	}

	const TASKS: TaskCard[] = [
		{
			id: 'call',
			title: 'Call Kim after the party',
			blurb: 'A smudged number on your hand, a hangover and 3% battery.',
			time: '≈ 1 min',
			image: '/img/story/task_call_hand.webp',
			emoji: '📱',
			first: true
		},
		{
			id: 'round',
			title: 'Order the round',
			blurb: 'A loud bar, a thirsty crowd, German fingers.',
			time: '≈ 1 min',
			image: '/img/story/task_bar_round.webp',
			emoji: '🍺'
		},
		{
			id: 'ubahn',
			title: 'Last U-Bahn home',
			blurb: "2 a.m., the platform keeps changing, the train won't wait.",
			time: '≈ 1 min',
			image: '/img/story/task_ubahn_night.webp',
			emoji: '🚇'
		},
		{
			id: 'board',
			title: 'Number board',
			blurb: 'Hear a number, tap it. Plain practice.',
			time: '≈ 2 min',
			emoji: '🔢'
		}
	];

	const doneKey = untrack(() => `${quiz.storageKeyPrefix}tasks_done`);
	let done = $state<string[]>([]);
	let open = $state<TaskId | null>(null);
	/** Pictures that failed to load (not generated yet) fall back to the emoji. */
	let broken = $state<string[]>([]);

	$effect(() => {
		(async () => {
			try {
				done = JSON.parse((await storage.get(doneKey)) ?? '[]');
			} catch {
				done = [];
			}
		})();
	});

	function choose(task: TaskCard) {
		if (task.soon) return;
		open = task.id;
		track('number_task_pick', { quiz: quiz.id, task: task.id });
	}

	async function finished(id: TaskId) {
		if (!done.includes(id)) {
			done = [...done, id];
			await storage.set(doneKey, JSON.stringify(done));
		}
		onFinish();
	}
</script>

<div class="tasks">
	{#if open}
		<button type="button" class="back" onclick={() => (open = null)}>
			<Icon name="arrowLeft" size="1em" /> All tasks
		</button>
		{#if open === 'call'}
			<CallTask
				task={callContent as CallTaskContent}
				{locale}
				quizId={quiz.id}
				onFinish={() => finished('call')}
				onBack={() => (open = null)}
			/>
		{:else if open === 'round'}
			<BarTask
				task={barContent as BarTaskContent}
				{locale}
				quizId={quiz.id}
				onFinish={() => finished('round')}
				onBack={() => (open = null)}
			/>
		{:else if open === 'ubahn'}
			<UbahnTask
				task={ubahnContent as UbahnTaskContent}
				{locale}
				quizId={quiz.id}
				onFinish={() => finished('ubahn')}
				onBack={() => (open = null)}
			/>
		{:else if open === 'board'}
			<NumberBoardQuiz {quiz} {locale} onFinish={() => finished('board')} />
		{/if}
	{:else}
		<header class="head">
			<h2>Pick a mission</h2>
			<p>Real moments where German numbers matter. Finish any one.</p>
		</header>
		<ul class="cards">
			{#each TASKS as task (task.id)}
				<li>
					<button
						type="button"
						class="card"
						class:soon={task.soon}
						class:first={task.first}
						disabled={task.soon}
						onclick={() => choose(task)}
					>
						{#if task.image && !broken.includes(task.id)}
							<img src={task.image} alt="" use:imageGuard={() => (broken = [...broken, task.id])} />
						{:else}
							<span class="emoji" aria-hidden="true">{task.emoji}</span>
						{/if}
						<span class="text">
							<span class="title">
								{#if task.image && !broken.includes(task.id)}<span aria-hidden="true">{task.emoji}</span>{/if}
								{task.title}
							</span>
							<span class="blurb">{task.blurb}</span>
							<span class="meta">
								{#if task.soon}
									<Icon name="lock" size="0.9em" /> Coming soon
								{:else}
									{#if done.includes(task.id)}<span class="tick"><Icon name="check" size="0.9em" /> Done</span>{:else if task.first}<span class="badge">Start here</span>{/if}
									{task.time}
								{/if}
							</span>
						</span>
					</button>
				</li>
			{/each}
		</ul>
	{/if}
</div>

<style>
	.tasks {
		display: flex;
		flex-direction: column;
		gap: 0.8rem;
		width: 100%;
		max-width: 32rem;
		margin: 0 auto;
	}

	.head h2 {
		margin: 0;
		font-size: var(--step-3);
	}

	.head p {
		margin: 0.2rem 0 0;
		color: var(--ink-muted);
	}

	.cards {
		display: grid;
		gap: 0.6rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.card {
		display: flex;
		align-items: stretch;
		gap: 0.85rem;
		width: 100%;
		padding: 0.6rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		color: inherit;
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			transform var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out);
	}

	.card:hover:not(:disabled) {
		transform: translateY(-2px);
		border-color: var(--accent);
	}

	.card.first {
		border-color: var(--accent);
		box-shadow: 0 10px 24px -16px rgb(162 76 38 / 0.6);
	}

	.card.soon {
		opacity: 0.6;
		cursor: default;
		border-style: dashed;
	}

	.card img,
	.emoji {
		flex: none;
		width: 5.5rem;
		height: 5.5rem;
		border-radius: var(--radius-sm);
		object-fit: cover;
		background: var(--surface-alt);
	}

	.emoji {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		font-size: 2.3rem;
	}

	.text {
		display: flex;
		flex-direction: column;
		justify-content: center;
		gap: 0.2rem;
		min-width: 0;
	}

	.title {
		font-weight: 700;
		color: var(--heading);
		line-height: 1.25;
	}

	.blurb {
		font-size: var(--step--1);
		color: var(--ink);
	}

	.meta {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		font-size: 0.78rem;
		font-weight: 600;
		color: var(--ink-muted);
	}

	.badge {
		padding: 0.05rem 0.5rem;
		border-radius: 999px;
		background: var(--accent);
		color: #fff;
	}

	.tick {
		display: inline-flex;
		align-items: center;
		gap: 0.2rem;
		color: var(--right);
	}

	.back {
		align-self: flex-start;
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.2rem 0;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
	}

	.back:hover {
		color: var(--accent-ink);
	}
</style>
