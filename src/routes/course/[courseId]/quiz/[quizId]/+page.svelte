<script lang="ts">
	// The quiz page. Dispatches on `quiz.type` to the right renderer — the
	// Svelte equivalent of the Dart DbQuizLoader's kind switch.
	//
	// The exercise owns the screen: the page is exactly one screen tall and
	// never scrolls. Everything that is not the exercise — the study notes, the
	// way to the neighbouring exercises, the site's links — sits behind the two
	// buttons in the header and opens in a panel in front of the quiz (see
	// Sheet). Quizzes with more than a screen of material run as sections
	// instead of a scroll (see quiz/Steps).
	import HelpMemory, { hasStudyNotes } from '$lib/components/HelpMemory.svelte';
	import Lesson from '$lib/components/Lesson.svelte';
	import { buildLesson, hasLesson } from '$lib/domain/lesson';
	import Seo from '$lib/components/Seo.svelte';
	import {
		breadcrumbLd,
		learningResourceLd,
		quizDescription,
		quizTitle,
		shareImage,
		topicOf,
		type Crumb
	} from '$lib/seo';
	import Sheet from '$lib/components/Sheet.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import DoneMark from '$lib/components/DoneMark.svelte';
	import DictationQuiz from '$lib/components/quiz/DictationQuiz.svelte';
	import FillBlankQuiz from '$lib/components/quiz/FillBlankQuiz.svelte';
	import InlineClozeQuiz from '$lib/components/quiz/InlineClozeQuiz.svelte';
	import NumberTasks from '$lib/components/quiz/NumberTasks.svelte';
	import PassageQuiz from '$lib/components/quiz/PassageQuiz.svelte';
	import SpeakRepeatQuiz from '$lib/components/quiz/SpeakRepeatQuiz.svelte';
	import SpeakingQuiz from '$lib/components/quiz/SpeakingQuiz.svelte';
	import VocabularyQuiz from '$lib/components/quiz/VocabularyQuiz.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { fly } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import { isInlineCloze } from '$lib/content/types';
	import { SettingsKeys } from '$lib/domain/keys';
	import { celebrate } from '$lib/motion/fx.svelte';
	import { playSound } from '$lib/services/sounds';
	import { progress } from '$lib/state/progress.svelte';
	import { storage } from '$lib/services/storage';
	import { clearOpened, clearSpot, markOpened } from '$lib/state/resume';
	import { track } from '$lib/services/analytics';
	import { onMount, tick, untrack } from 'svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const { course, quiz, next, previous, related, vocab, position, levelCount, levelTitle, deck } = $derived(data);

	/**
	 * "?from=<quizId>" opens the deck on one exercise's words. Read after
	 * mount: the page is prerendered, so the query is only known in the browser.
	 */
	let focusWord = $state<string | null>(null);
	onMount(() => {
		focusWord = new URLSearchParams(window.location.search).get('from');
	});
	const deckHref = $derived(
		deck && deck.id !== quiz.id ? `/course/${course.id}/quiz/${deck.id}?from=${quiz.id}` : null
	);

	const path = $derived(`/course/${course.id}/quiz/${quiz.id}`);
	const levelPath = $derived(`/course/${course.id}/level/${quiz.level}`);
	const crumbs: Crumb[] = $derived([
		{ name: 'Home', path: '/' },
		{ name: course.name, path: `/course/${course.id}` },
		...(quiz.level ? [{ name: levelTitle ?? quiz.level, path: levelPath }] : []),
		{ name: topicOf(quiz.title), path }
	]);

	const hasNotes = $derived(hasStudyNotes(quiz, vocab));
	let notesOpen = $state(false);
	let moreOpen = $state(false);

	// A quiz with a lesson (the pilot, see domain/lesson) teaches in two modes
	// that take turns on the stage: Learn, then Practise. The lesson replaces
	// the notes panel for it.
	const lessonSteps = $derived(hasLesson(quiz) ? buildLesson(quiz, vocab) : null);
	let mode = $state<'learn' | 'practise'>('learn');
	const learning = $derived(!!lessonSteps && mode === 'learn');

	async function readSeen(): Promise<string[]> {
		try {
			const raw = await storage.get(SettingsKeys.seenHelpMemory);
			return raw ? JSON.parse(raw) : [];
		} catch {
			return [];
		}
	}

	/** Leaves the lesson for the exercise, and remembers it was taught. */
	async function practise() {
		mode = 'practise';
		const id = quiz.id;
		track('lesson_to_practice', { course: course.id, quiz: id });
		await tick();
		document.querySelector<HTMLInputElement>('.stage .exercise input:not([disabled])')?.focus();
		const seen = await readSeen();
		if (!seen.includes(id)) await storage.set(SettingsKeys.seenHelpMemory, JSON.stringify([...seen, id]));
	}

	// A first visit to an exercise opens its notes unprompted, so the rule is
	// read before the first question rather than discovered by failing. They
	// sit in front of the quiz, one tap from gone, so this costs nothing to
	// dismiss. Keyed per quiz: the next exercise opens on its own notes.
	// A lesson quiz instead opens on Learn the first time and on Practise
	// after that — unless it is a game, which always opens on the game: the
	// lesson is there under Learn for whoever wants it.
	/** The quiz the notes were last considered for — each gets one look. */
	let notesCheckedFor: string | null = null;
	$effect(() => {
		const id = quiz.id;
		if (id === notesCheckedFor) return;
		notesCheckedFor = id;
		notesOpen = false;
		moreOpen = false;
		mode = 'learn';
		if (untrack(() => quiz.game)) {
			mode = 'practise';
			return;
		}
		if (untrack(() => lessonSteps)) {
			(async () => {
				const seen = await readSeen();
				if (seen.includes(id) && id === notesCheckedFor) mode = 'practise';
			})();
			return;
		}
		if (!untrack(() => hasNotes)) return;
		(async () => {
			const seen = await readSeen();
			if (seen.includes(id) || id !== notesCheckedFor) return;
			// Recorded before opening, so nothing racing this can open it twice.
			await storage.set(SettingsKeys.seenHelpMemory, JSON.stringify([...seen, id]));
			if (id === notesCheckedFor) notesOpen = true;
		})();
	});

	let finished = $state(false);
	/** The "finished" bar can be waved away to look back over the answers. */
	let doneDismissed = $state(false);
	/** Bumped by "Try again": the exercise remounts and starts over. */
	let attempt = $state(0);

	/**
	 * Try again, for every kind: the exercise is mounted afresh. A drill gets
	 * a fresh bar (its streak is in the store and carries on); a passage or
	 * dictation starts from its first question.
	 */
	function tryAgain() {
		attempt += 1;
		finished = false;
		doneDismissed = false;
	}

	$effect(() => {
		// Remembered so the deck can offer it again if the learner leaves early.
		markOpened(quiz.id);
		finished = false;
		doneDismissed = false;
	});

	$effect(() => {
		if (!progress.loaded) progress.load();
	});

	const ribbon = $derived(
		progress.loaded
			? progress.markFor(quiz.type, quiz.id, quiz.storageKeyPrefix)
			: null
	);

	/** Marks the quiz done — the quest set, the finished bar. Idempotent. */
	async function markDone() {
		if (finished) return;
		finished = true;
		await progress.markCompleted(quiz.type, quiz.id);
		await progress.markQuestCompleted(quiz.id);
		await progress.markPlayed(quiz.storageKeyPrefix);
		clearOpened(quiz.id);
		clearSpot(quiz.storageKeyPrefix);
		track('quiz_completed', { course: course.id, quiz: quiz.id, type: quiz.type });
	}

	/** A play-through kind finished: mark it and celebrate, once per visit. */
	async function complete() {
		if (finished) return;
		await markDone();
		celebrate();
	}

	/**
	 * A drill's run ended. Every finished run marks the exercise, whatever
	 * the score — the mark itself says how it went (done tick, or try again).
	 * A pass gets the fireworks; a weaker run just the chime. The medal, if
	 * the streak earned one, was celebrated on the answer that crossed it.
	 */
	function runFinished(passed: boolean) {
		void markDone();
		doneDismissed = false;
		if (passed) celebrate();
		else playSound('complete');
	}

	const nextHref = $derived(next ? `/course/${course.id}/quiz/${next.id}` : `/course/${course.id}`);
	/** Back to the swipe deck for the next card. */
	const homeHref = $derived(`/course/${course.id}`);
	/** What the finish bar says the exercise was marked as. */
	const markedAs = $derived(ribbon === 'retry' ? 'Marked for another go.' : 'Marked complete.');

	// Finishing never navigates on its own, and Enter is NOT a shortcut out:
	// the quizzes use Enter to skip to the next question, so a learner still
	// in the rhythm of a run would be thrown back to the deck mid-thought.
	// Leaving is always an explicit tap (or Tab + Enter) on the finished bar.
</script>

<Seo
	title={quizTitle(quiz)}
	description={quizDescription(quiz)}
	{path}
	type="article"
	image={quiz.level ? shareImage('level', quiz.level) : undefined}
	imageAlt={quiz.level ? `German ${quiz.level}: ${topicOf(quiz.title)}` : undefined}
	jsonLd={[learningResourceLd(quiz, path, course.name, `/course/${course.id}`), breadcrumbLd(crumbs)]}
/>

<div class="screen" class:with-done={finished && !doneDismissed}>
	<header class="top">
		<a class="back" href="/course/{course.id}" aria-label="Back to your deck" title="Back to your deck">
			<Icon name="arrowLeft" size="1.15em" />
		</a>

		<span class="kind" data-kind={quiz.type} aria-hidden="true">
			<Icon name={QUIZ_TYPE_ICONS[quiz.type]} size="1.1em" />
		</span>

		<div class="title">
			<p class="where tnum">
				{#if quiz.level}{quiz.level}{#if position}{` · ${position} of ${levelCount}`}{/if}{:else}{quiz.type}{/if}
			</p>
			<h1>{quiz.title}</h1>
		</div>

		{#if ribbon}
			<span class="ribbon"><DoneMark mark={ribbon} animate={finished} width={16} /></span>
		{/if}

		<div class="tools">
			{#if lessonSteps}
				<!-- One switch between the two modes: it shows where you are, and a
				     tap flips to the other side. The lesson is half the page, not a
				     footnote to it, so the switch sits where the notes button would. -->
				<button
					type="button"
					class="mode-switch"
					role="switch"
					aria-checked={!learning}
					aria-label="Practise mode"
					title={learning ? 'Switch to the exercise' : 'Switch to the lesson'}
					onclick={() => (learning ? practise() : (mode = 'learn'))}
				>
					<span class="side" class:on={learning}>
						<Icon name="book" size="1em" /><span class="side-label">Learn</span>
					</span>
					<span class="knob" aria-hidden="true"></span>
					<span class="side" class:on={!learning}>
						<Icon name="pen" size="1em" /><span class="side-label">Practise</span>
					</span>
				</button>
			{:else if hasNotes}
				<button
					type="button"
					class="tool notes"
					aria-haspopup="dialog"
					aria-expanded={notesOpen}
					aria-controls="notes-{quiz.id}"
					onclick={() => (notesOpen = true)}
				>
					<Icon name="book" size="1.1em" />
					<span>Notes</span>
				</button>
			{/if}
			<button
				type="button"
				class="tool"
				aria-haspopup="dialog"
				aria-expanded={moreOpen}
				aria-controls="more-{quiz.id}"
				aria-label="More"
				onclick={() => (moreOpen = true)}
			>
				<Icon name="menu" size="1.1em" />
				<span class="tool-label">More</span>
			</button>
		</div>
	</header>

	{#if quiz.status === 'placeholder'}
		<!-- The content is real and complete; the drill behind it is the
		     minimum. Said plainly so nobody mistakes thin for finished. -->
		<p class="preview">Preview — the explanation is complete, the exercise is still being expanded.</p>
	{/if}

	<main class="stage">
		{#if lessonSteps}
			<div class="pane" class:parked={!learning} inert={!learning}>
				<Lesson steps={lessonSteps} locale={course.learnLocale} {deckHref} onPractise={practise} />
			</div>
		{/if}
		<div class="pane exercise" class:parked={learning} inert={learning}>
		{#key attempt}
		{#if quiz.game === 'numberTasks' && quiz.type === 'fillBlank'}
			<NumberTasks {quiz} locale={course.learnLocale} onFinish={complete} />
		{:else if quiz.type === 'fillBlank'}
			<FillBlankQuiz
				{quiz}
				locale={course.learnLocale}
				onAnswer={() => {}}
				onRunFinished={runFinished}
			/>
		{:else if quiz.type === 'reading'}
			<!-- Two shapes share this type: a passage with questions, and the "big
			     text" cloze with inline blanks. The presence of inlineBlanks tells
			     them apart. -->
			{#if isInlineCloze(quiz)}
				<InlineClozeQuiz
					{quiz}
					locale={course.learnLocale}
					onFinish={(passed) => passed && complete()}
				/>
			{:else}
				<PassageQuiz
					{quiz}
					locale={course.learnLocale}
					mode="read"
					onFinish={(passed) => passed && complete()}
				/>
			{/if}
		{:else if quiz.type === 'listening'}
			<PassageQuiz
				{quiz}
				locale={course.learnLocale}
				mode="listen"
				onFinish={(passed) => passed && complete()}
			/>
		{:else if quiz.type === 'dictation'}
			<DictationQuiz
				{quiz}
				locale={course.learnLocale}
				onFinish={(passed) => passed && complete()}
			/>
		{:else if quiz.type === 'speakRepeat'}
			<SpeakRepeatQuiz {quiz} locale={course.learnLocale} onFinish={complete} />
		{:else if quiz.type === 'speaking'}
			<SpeakingQuiz
				{quiz}
				courseId={course.id}
				learnLocale={course.learnLocale}
				uiLang={course.uiLang}
				onFinish={(passed) => passed && complete()}
			/>
		{:else if quiz.type === 'vocabulary'}
			<VocabularyQuiz
				{quiz}
				courseId={course.id}
				locale={course.learnLocale}
				onRunFinished={runFinished}
				{focusWord}
			/>
		{/if}
		{/key}
		</div>
	</main>
</div>

{#if finished && !doneDismissed}
	<!-- Floats over the foot of the exercise rather than pushing it: the page
	     stays one screen. Dismissable, to look back over the answers. -->
	<aside class="done" transition:fly={{ y: 40, duration: 320, easing: cubicOut }}>
		<p class="done-line">
			<Icon name="check" size="1.15em" />
			<span><strong>Finished.</strong> {markedAs}</span>
			<button type="button" class="done-close" aria-label="Hide" onclick={() => (doneDismissed = true)}>
				<Icon name="close" size="1em" />
			</button>
		</p>
		<!-- The same three ways on for every kind of exercise. -->
		<div class="done-actions">
			<button type="button" class="btn" class:btn-ghost={ribbon !== 'retry'} onclick={tryAgain}>
				<Icon name="repeat" size="1em" /> Try again
			</button>
			<a class="btn" class:btn-ghost={ribbon === 'retry'} href={nextHref} title={next ? topicOf(next.title) : 'Back to your deck'}>
				Next quiz <Icon name="arrowRight" size="1em" />
			</a>
			<a class="btn btn-ghost" href={homeHref}>
				<Icon name="cards" size="1em" /> Deal me another card
			</a>
		</div>
	</aside>
{/if}

{#if hasNotes && !lessonSteps}
	<Sheet bind:open={notesOpen} title="Study notes" id="notes-{quiz.id}">
		<HelpMemory {quiz} locale={course.learnLocale} {vocab} {deckHref} />
		{#snippet footer()}
			<button type="button" class="btn to-exercise" onclick={() => (notesOpen = false)}>
				Start the exercise <Icon name="arrowRight" size="1em" />
			</button>
		{/snippet}
	</Sheet>
{/if}

<Sheet bind:open={moreOpen} title="More" id="more-{quiz.id}">
	<!-- Plain links to the neighbours, always in the page: they are how a
	     reader (and a crawler) moves through the course without the course
	     page. -->
	<nav class="pager" aria-label="More exercises">
		{#if previous}
			<a href="/course/{course.id}/quiz/{previous.id}" rel="prev">
				<small>Previous</small>
				<span><Icon name="arrowLeft" size="1em" /> {topicOf(previous.title)}</span>
			</a>
		{/if}
		{#if next}
			<a class="to-next" href="/course/{course.id}/quiz/{next.id}" rel="next">
				<small>Next</small>
				<span>{topicOf(next.title)} <Icon name="arrowRight" size="1em" /></span>
			</a>
		{/if}
	</nav>

	<div class="shortcuts">
		<a href="/course/{course.id}"><Icon name="cards" size="1.05em" /> Your deck</a>
		{#if quiz.level}
			<a href={levelPath}><Icon name="book" size="1.05em" /> {levelTitle ?? quiz.level}</a>
		{/if}
		<a href="/settings" rel="nofollow"><Icon name="settings" size="1.05em" /> Settings</a>
	</div>

	{#if related.length}
		<!-- The nearest exercises in the same level: a reader who came in from
		     a search has somewhere to go besides forward and back. -->
		<section class="related" aria-labelledby="related-heading">
			<h2 id="related-heading">More at {levelTitle ?? quiz.level}</h2>
			<ul>
				{#each related as r (r.id)}
					<li>
						<a href="/course/{course.id}/quiz/{r.id}">
							<span class="kind" data-kind={r.type}><Icon name={QUIZ_TYPE_ICONS[r.type]} size="1em" /></span>
							<span>{topicOf(r.title)}</span>
						</a>
					</li>
				{/each}
			</ul>
			{#if quiz.level}<p><a href={levelPath}>Every {quiz.level} exercise <Icon name="arrowRight" size="1em" /></a></p>{/if}
		</section>
	{/if}

	<SiteFooter />
</Sheet>

<style>
	/* Exactly one screen: the header, then the exercise taking the rest. */
	.screen {
		display: flex;
		flex-direction: column;
		height: 100dvh;
		max-width: 46rem;
		margin: 0 auto;
		padding: 0.6rem 1.25rem calc(0.75rem + env(safe-area-inset-bottom));
	}

	.top {
		display: flex;
		align-items: center;
		gap: 0.65rem;
		flex: none;
		padding-bottom: 0.6rem;
		margin-bottom: 0.75rem;
		border-bottom: 1px solid var(--line);
	}

	.back {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.4rem;
		height: 2.4rem;
		flex: none;
		margin-left: -0.4rem;
		border-radius: 50%;
		color: var(--ink-muted);
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.back:hover {
		background: var(--surface-alt);
		color: var(--accent-ink);
	}

	.title {
		flex: 1;
		min-width: 0;
	}

	.where {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	h1 {
		margin: 0.05rem 0 0;
		font-size: var(--step-1);
		line-height: 1.2;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		line-clamp: 2;
		-webkit-box-orient: vertical;
	}

	.ribbon {
		display: inline-flex;
		flex: none;
	}

	.tools {
		display: flex;
		gap: 0.4rem;
		flex: none;
	}

	.tool {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		height: 2.5rem;
		padding: 0 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--heading);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 700;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.tool:hover {
		transform: translateY(-1px);
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	/* The notes are the one thing worth reaching for mid-exercise: filled, so
	   they are found without being looked for. */
	.tool.notes {
		border-color: var(--accent);
		background: var(--accent-soft);
		color: var(--accent-ink);
	}

	.tool.notes:hover {
		background: var(--accent-ink);
		color: #fff;
	}

	/* Learn ⇄ Practise: one switch. The two labels sit either side of a knob
	   that slides to the live one; the whole thing is a single button, so a
	   tap anywhere flips it. */
	.mode-switch {
		position: relative;
		display: inline-grid;
		grid-template-columns: 1fr 1fr;
		align-items: center;
		height: 2.5rem;
		padding: 0.2rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		font: inherit;
		cursor: pointer;
		transition: border-color var(--fast) var(--ease-out);
	}

	.mode-switch:hover {
		border-color: var(--accent);
	}

	.mode-switch .side {
		position: relative;
		z-index: 1;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.35rem;
		height: 2.1rem;
		padding: 0 0.85rem;
		border-radius: 999px;
		color: var(--ink-muted);
		font-size: var(--step--1);
		font-weight: 700;
		transition: color var(--medium) var(--ease-out);
	}

	.mode-switch .side.on {
		color: var(--paper);
	}

	/* The knob: the filled half, sliding under whichever side is live. */
	.mode-switch .knob {
		position: absolute;
		top: 0.2rem;
		bottom: 0.2rem;
		left: 0.2rem;
		width: calc(50% - 0.2rem);
		border-radius: 999px;
		background: var(--navy);
		transition: transform var(--medium) var(--ease-spring);
	}

	.mode-switch[aria-checked='true'] .knob {
		transform: translateX(100%);
	}

	@media (prefers-reduced-motion: reduce) {
		.mode-switch .knob {
			transition: none;
		}
	}

	/* The lesson and the exercise take turns on the stage; the one waiting is
	   hidden (and inert), still in the page for readers who never run JS. */
	.pane {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
	}

	.pane.parked {
		display: none;
	}

	.preview {
		flex: none;
		margin: -0.25rem 0 0.6rem;
		font-size: var(--step--1);
		color: var(--ochre, #8a6d1f);
		font-weight: 600;
	}

	/* The exercise gets the rest of the screen. A short one sits near the top
	   — centred, it floated in the middle of a tall window with a gulf of
	   empty page above it — and a sectioned one (Steps) fills it. Scrolling
	   here is only a safety net for a very small screen. */
	.stage {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
		justify-content: flex-start;
		padding-top: clamp(0.25rem, 4vh, 2.5rem);
		overflow-y: auto;
	}

	/* The same tinted disc the course-home list uses, so a quiz keeps its
	   identity between the two views. */
	.kind {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		flex: none;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--ink-muted);
	}

	.kind[data-kind='reading'] {
		background: #e6ecf3;
		color: var(--navy);
	}
	.kind[data-kind='fillBlank'] {
		background: #ebe7f4;
		color: #55478a;
	}
	.kind[data-kind='vocabulary'] {
		background: #f9e7ee;
		color: #a33a63;
	}
	.kind[data-kind='speakRepeat'] {
		background: #fbe9e2;
		color: #b5522a;
	}
	.kind[data-kind='speaking'] {
		background: var(--accent-soft);
		color: var(--accent-ink);
	}
	.kind[data-kind='listening'] {
		background: #e8efe9;
		color: var(--forest);
	}
	.kind[data-kind='dictation'] {
		background: #f4eddc;
		color: var(--ochre-ink);
	}

	/* -- finished bar -------------------------------------------------------- */

	/* Room under the exercise while the bar is up, so it covers nothing. */
	.with-done .stage {
		padding-bottom: 8.5rem;
	}

	.done {
		position: fixed;
		left: 50%;
		bottom: calc(1rem + env(safe-area-inset-bottom));
		z-index: 60;
		width: min(44rem, calc(100% - 1.5rem));
		transform: translateX(-50%);
		padding: 0.9rem 1.1rem 1rem;
		border: 1px solid var(--right);
		border-radius: var(--radius);
		background: var(--right-bg);
		box-shadow: 0 18px 40px -18px rgb(20 32 52 / 0.45);
	}

	.done-line {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		margin: 0 0 0.75rem;
		max-width: none;
		color: var(--right);
	}

	.done-close {
		display: inline-flex;
		margin-left: auto;
		padding: 0.3rem;
		border: 0;
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.done-actions {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		flex-wrap: wrap;
	}

	/* -- panels -------------------------------------------------------------- */

	.to-exercise {
		width: 100%;
		justify-content: center;
	}

	.pager {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.6rem;
	}

	.pager a {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
		padding: 0.75rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		color: var(--heading);
		font-weight: 600;
		font-size: var(--step--1);
		text-decoration: none;
		transition: border-color var(--fast) var(--ease-out);
	}

	.pager a:hover {
		border-color: var(--accent);
	}

	.pager a span {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
	}

	.pager small {
		font-size: 0.7rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.pager .to-next {
		grid-column: 2;
		text-align: right;
		align-items: flex-end;
	}

	.shortcuts {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin-top: 1rem;
	}

	.shortcuts a {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.45rem 0.85rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		color: var(--ink);
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
	}

	.shortcuts a:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	.related { margin-top: 1.5rem; padding-top: 1.1rem; border-top: 1px solid var(--line); }
	.related h2 { margin: 0 0 0.5rem; font-size: var(--step-0); }
	.related ul { margin: 0; padding: 0; list-style: none; display: grid; gap: 0.2rem; }
	.related li a { display: flex; align-items: center; gap: 0.6rem; padding: 0.45rem 0.6rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; font-size: var(--step--1); }
	.related li a:hover { background: var(--surface-alt); }
	.related li .kind { width: 1.7rem; height: 1.7rem; }
	.related p { margin: 0.6rem 0 0; font-size: var(--step--1); }
	.related p a { display: inline-flex; align-items: center; gap: 0.3rem; font-weight: 700; text-decoration: none; }

	/* A phone: the header shrinks to one line so the exercise keeps the screen. */
	@media (max-width: 36rem) {
		.screen {
			padding: 0.4rem 0.85rem calc(0.6rem + env(safe-area-inset-bottom));
		}
		.top {
			gap: 0.45rem;
			padding-bottom: 0.45rem;
			margin-bottom: 0.55rem;
		}
		.top > .kind {
			display: none;
		}
		h1 {
			font-size: var(--step-0);
			-webkit-line-clamp: 1;
			line-clamp: 1;
		}
		.tool {
			height: 2.35rem;
			padding: 0 0.7rem;
		}
		.tool-label {
			display: none;
		}
		/* The switch drops to its two icons: the book and the pen carry the
		   meaning, and the header has no room for the words next to a long
		   German title. The button keeps its label for a screen reader. */
		.mode-switch {
			height: 2.35rem;
		}
		.mode-switch .side {
			height: 1.95rem;
			padding: 0 0.75rem;
			font-size: var(--step-0);
		}
		.mode-switch .side-label {
			/* Not display:none — the words stay for a screen reader that reads
			   the switch's two halves rather than its label. */
			position: absolute;
			width: 1px;
			height: 1px;
			overflow: hidden;
			clip-path: inset(50%);
			white-space: nowrap;
		}

		/* Tight to the header: the on-screen keyboard rises over the lower
		   half, and the answer field must stay above it. */
		.stage {
			padding-top: 0.25rem;
		}
		.done-actions .btn {
			flex: 1 1 calc(50% - 0.3rem);
		}
		.done-actions .btn:last-child {
			flex-basis: 100%;
		}
		.with-done .stage {
			padding-bottom: 11rem;
		}
	}
</style>
