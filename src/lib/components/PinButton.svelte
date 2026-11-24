<script lang="ts">
	// The quiz header's pin: one button, a small menu with the two things
	// there are to pin — the whole exercise, or the question on screen — and
	// the way to everything pinned so far. Filled when either is pinned.
	import Icon from '$lib/icons/Icon.svelte';
	import { t } from '$lib/i18n/t';
	import { announce } from '$lib/a11y.svelte';
	import { questionPinId, quizPinId } from '$lib/domain/pins';
	import { pins, type PinSource } from '$lib/state/pins.svelte';
	import { onMount, tick } from 'svelte';

	let {
		source,
		question
	}: {
		source: PinSource;
		/** The question on screen, as the exercise reports it; null between questions. */
		question: string | null;
	} = $props();

	onMount(() => {
		void pins.load();
	});

	let open = $state(false);
	let wrap = $state<HTMLElement>();
	let toggleEl = $state<HTMLButtonElement>();

	const quizId = $derived(quizPinId(source.courseId, source.quizId));
	const questionId = $derived(question ? questionPinId(source.courseId, source.quizId, question) : null);
	const quizPinned = $derived(pins.has(quizId));
	const questionPinned = $derived(questionId ? pins.has(questionId) : false);

	/** The question, short enough for a menu line. */
	const preview = $derived(
		question ? (question.length > 60 ? `${question.slice(0, 57).trimEnd()}…` : question) : ''
	);

	async function toggleMenu() {
		open = !open;
		if (open) {
			await tick();
			wrap?.querySelector<HTMLElement>('[role="menuitem"]')?.focus();
		}
	}

	function close(refocus = true) {
		open = false;
		if (refocus) toggleEl?.focus();
	}

	async function flipQuiz() {
		if (quizPinned) {
			await pins.unpin(quizId);
			announce(t('Exercise unpinned.'));
		} else {
			await pins.pinQuiz(source);
			announce(t('Exercise pinned. Find it under Pinned in the menu.'));
		}
		close();
	}

	async function flipQuestion() {
		if (!question || !questionId) return;
		if (questionPinned) {
			await pins.unpin(questionId);
			announce(t('Question unpinned.'));
		} else {
			await pins.pinQuestion(source, question);
			announce(t('Question pinned. Find it under Pinned in the menu.'));
		}
		close();
	}

	function onWindowPointer(event: PointerEvent) {
		if (open && wrap && !wrap.contains(event.target as Node)) close(false);
	}

	function onKey(event: KeyboardEvent) {
		if (!open) return;
		if (event.key === 'Escape') {
			event.preventDefault();
			close();
			return;
		}
		if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
			const items = [...(wrap?.querySelectorAll<HTMLElement>('[role="menuitem"]') ?? [])];
			const at = items.indexOf(document.activeElement as HTMLElement);
			const next = items[(at + (event.key === 'ArrowDown' ? 1 : items.length - 1)) % items.length];
			event.preventDefault();
			next?.focus();
		}
	}
</script>

<svelte:window onpointerdown={onWindowPointer} />

<!-- svelte-ignore a11y_no_static_element_interactions -->
<span class="pin-wrap" bind:this={wrap} onkeydown={onKey}>
	<button
		type="button"
		class="tool"
		class:on={quizPinned || questionPinned}
		bind:this={toggleEl}
		aria-haspopup="menu"
		aria-expanded={open}
		aria-label={quizPinned || questionPinned ? t('Pinned') : t('Pin')}
		title={t('Pin this exercise or this question to practise again')}
		onclick={toggleMenu}
	>
		<!-- Icon only: the header is full, and a label here squeezed the
		     exercise title into a sliver. The filled state says "pinned". -->
		<Icon name="pin" size="1.15em" />
	</button>

	{#if open}
		<div class="menu" role="menu" aria-label={t('Pin')}>
			<button type="button" role="menuitem" onclick={flipQuiz}>
				<Icon name={quizPinned ? 'check' : 'pin'} size="1em" />
				<span>
					<strong>{quizPinned ? t('Unpin this exercise') : t('Pin this exercise')}</strong>
					<small>{source.quizTitle}</small>
				</span>
			</button>
			{#if question}
				<button type="button" role="menuitem" onclick={flipQuestion}>
					<Icon name={questionPinned ? 'check' : 'pin'} size="1em" />
					<span>
						<strong>{questionPinned ? t('Unpin this question') : t('Pin this question')}</strong>
						<small lang="de">{preview}</small>
					</span>
				</button>
			{/if}
			<a href="/pinned" role="menuitem" onclick={() => close(false)}>
				<Icon name="arrowRight" size="1em" />
				<span><strong>{t('See everything pinned')}</strong></span>
			</a>
		</div>
	{/if}
</span>

<style>
	.pin-wrap {
		position: relative;
		display: inline-flex;
	}

	/* The same look as the header's other tools (the page styles .tool; these
	   are this component's own copy, since styles don't cross components). */
	.tool {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.5rem;
		height: 2.5rem;
		padding: 0;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
		transition:
			transform 0.15s ease,
			border-color 0.15s ease,
			color 0.15s ease;
	}

	.tool:hover {
		transform: translateY(-1px);
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	.tool.on {
		border-color: var(--accent);
		background: var(--accent-soft);
		color: var(--accent-ink);
	}

	.menu {
		position: absolute;
		inset-block-start: calc(100% + 0.35rem);
		inset-inline-end: 0;
		z-index: 40;
		display: grid;
		width: min(20rem, calc(100vw - 2rem));
		padding: 0.35rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 10px 30px rgb(0 0 0 / 0.14);
	}

	.menu > button,
	.menu > a {
		display: flex;
		gap: 0.6rem;
		align-items: flex-start;
		padding: 0.55rem 0.6rem;
		border: 0;
		border-radius: var(--radius-sm);
		background: none;
		color: var(--ink);
		font: inherit;
		text-align: start;
		text-decoration: none;
		cursor: pointer;
	}

	.menu > button:hover,
	.menu > a:hover,
	.menu > button:focus-visible,
	.menu > a:focus-visible {
		background: var(--surface-alt);
	}

	.menu :global(svg) {
		flex: none;
		margin-top: 0.2rem;
		color: var(--accent-ink);
	}

	.menu strong {
		display: block;
		font-size: var(--step--1);
	}

	.menu small {
		display: block;
		margin-top: 0.1rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		overflow-wrap: anywhere;
	}

	@media (max-width: 36rem) {
		.tool {
			width: 2.35rem;
			height: 2.35rem;
		}
	}
</style>
