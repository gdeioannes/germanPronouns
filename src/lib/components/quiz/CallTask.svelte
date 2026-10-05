<script lang="ts">
	// "Call Kim after the party" — the first number task, played on a phone
	// (see domain/callTask). It opens on the lock screen with Kim's voice
	// message; the chat thread keeps every voice note, call and hint; the
	// battery drains as you go, faster with every wrong call.
	//
	// Rounds come in two kinds: dial the smudged digits ('fill'), or pick the
	// one of three near-identical numbers they actually said ('pick'). A right
	// number moves the chase on (Tom → Kim's office → Kim); a wrong one rings a
	// stranger — five to collect, kept across plays — and costs nothing but 1%.
	import Burst from '../Burst.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { imageGuard } from './imageGuard';
	import {
		checkCall,
		erase,
		expected,
		keepRight,
		meet,
		numberCells,
		pickWrongCaller,
		press,
		type CallLine,
		type CallTaskContent,
		type WrongCaller
	} from '$lib/domain/callTask';
	import { announce } from '$lib/a11y.svelte';
	import { react, shakeOn } from '$lib/motion/fx.svelte';
	import ClipControls from './ClipControls.svelte';
	import { playClip, playSfx, stopClip, toggleClip, voice } from '$lib/services/clips.svelte';
	import { isMuted } from '$lib/services/mute';
	import { storage } from '$lib/services/storage';
	import { track } from '$lib/services/analytics';
	import { tick, untrack } from 'svelte';

	let {
		task,
		locale,
		quizId,
		onFinish,
		onBack
	}: {
		task: CallTaskContent;
		locale: string;
		quizId: string;
		onFinish: () => void;
		onBack: () => void;
	} = $props();

	const rounds = untrack(() => task.rounds);
	const MET_KEY = 'call_after_party_strangers';

	type Entry =
		| { id: number; kind: 'voice'; line: CallLine }
		| { id: number; kind: 'text'; text: string; en?: string }
		| { id: number; kind: 'call'; label: string; ok: boolean }
		| { id: number; kind: 'note'; text: string };
	type NewEntry =
		| { kind: 'voice'; line: CallLine }
		| { kind: 'text'; text: string; en?: string }
		| { kind: 'call'; label: string; ok: boolean }
		| { kind: 'note'; text: string };

	let phase = $state<'lock' | 'chat' | 'calling' | 'oncall' | 'done'>('lock');
	let r = $state(0);
	const round = $derived(rounds[r]);
	const hide = $derived(round.hide ?? []);
	const cells = $derived(numberCells(round.number, hide));
	const want = $derived(expected(round.number, hide));

	let log = $state<Entry[]>([]);
	let nextId = 0;
	function add(entry: NewEntry): Entry {
		const full = { ...entry, id: nextId++ } as Entry;
		log = [...log, full];
		return full;
	}

	// fill
	let typed = $state<string[]>((rounds[0].hide ?? []).map(() => ''));
	let locked = $state<number[]>([]);
	let hinted = $state<number[]>([]);
	let flash = $state<number[]>([]);
	// pick
	let crossed = $state<string[]>([]);
	let fails = $state(0);
	let run = $state(0);

	// the call screen
	let dialled = $state('');
	let callee = $state<{ line: CallLine; face: string; stranger: WrongCaller | null } | null>(null);
	let canHangUp = $state(false);
	let lastWrong: number | null = null;
	let pendingWrong: number[] = [];

	// the phone
	let battery = $state(5);
	let minutes = $state(40);
	const clock = $derived(`11:${String(minutes).padStart(2, '0')}`);
	let met = $state<string[]>([]);
	let open = $state<number[]>([]);
	let threadEl = $state<HTMLElement>();
	let dockEl = $state<HTMLElement>();
	let burst = $state(0);
	let missKey = $state(0);
	let noWallpaper = $state(false);

	const full = $derived(typed.every((d) => d !== ''));

	let alive = true;
	$effect(() => {
		(async () => {
			try {
				met = JSON.parse((await storage.get(MET_KEY)) ?? '[]');
			} catch {
				met = [];
			}
		})();
		// The battery runs down while you play — a little pressure, never a fail.
		const drain = setInterval(() => {
			if (phase === 'lock' || phase === 'done') return;
			battery = Math.max(1, battery - 1);
			minutes = Math.min(59, minutes + 1);
		}, 20000);
		return () => {
			alive = false;
			clearInterval(drain);
			stopClip();
		};
	});

	// New messages scroll into view.
	$effect(() => {
		void log.length;
		tick().then(() => threadEl?.scrollTo({ top: threadEl.scrollHeight, behavior: 'smooth' }));
	});

	const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

	/** Rough length of a voice note, for its label. */
	const duration = (line: CallLine) => `0:${String(Math.max(3, Math.round(line.de.length / 13))).padStart(2, '0')}`;
	/** Fixed bar heights, so every voice note has the same lively waveform. */
	const BARS = Array.from({ length: 22 }, (_, i) => 28 + ((i * 37) % 64));
	const FACES: Record<string, string> = { kim: 'K', tom: 'T', empfang: 'B' };

	/** Is this line the one playing (or paused) right now? */
	const on = (line: CallLine, status: 'playing' | 'paused') => voice.id === line.audio && voice.status === status;

	/** A voice note arrives in the thread and plays. Muted, its text opens. */
	async function voiceNote(line: CallLine) {
		const entry = add({ kind: 'voice', line });
		if (isMuted()) open = [...open, entry.id];
		await playClip(line.audio, { text: line.de, locale });
	}

	/** The round's prompt, as a note in the thread. */
	function prompt() {
		add({ kind: 'note', text: round.prompt });
	}

	async function unlock() {
		phase = 'chat';
		track('number_task', { quiz: quizId, task: task.id, step: 'open' });
		add({ kind: 'note', text: 'Saturday 02:14' });
		await voiceNote(round.clip);
		if (!alive) return;
		for (const message of round.texts ?? []) {
			await sleep(700);
			add({ kind: 'text', text: message.de, en: message.en });
		}
		await sleep(300);
		prompt();
	}

	function key(digit: string) {
		if (phase !== 'chat' || full) return;
		void playSfx(`dial_${digit}`, 0.6);
		flash = [];
		typed = press(typed, digit);
	}

	function back() {
		if (phase !== 'chat') return;
		flash = [];
		typed = erase(typed, locked);
	}

	async function ring() {
		await Promise.all([
			(async () => {
				await playSfx('ring', 0.7);
				await sleep(350);
				await playSfx('ring', 0.7);
			})(),
			sleep(1500)
		]);
	}

	/** Dials: the typed digits (fill) or the chosen number (pick). */
	async function call(choice?: string) {
		if (phase !== 'chat') return;
		let right: boolean;
		if (round.kind === 'pick') {
			if (!choice || crossed.includes(choice)) return;
			right = choice === round.number;
			dialled = choice;
			pendingWrong = [];
			if (!right) crossed = [...crossed, choice];
		} else {
			if (!full) return;
			const result = checkCall(round.number, hide, typed);
			right = result.correct;
			pendingWrong = result.wrong;
			const digits = [...round.number.replace(/\D/g, '')];
			hide.forEach((pos, k) => (digits[pos] = typed[k]));
			dialled = round.number.replace(/\d/g, () => digits.shift() ?? '');
		}
		stopClip();
		canHangUp = false;
		callee = null;
		phase = 'calling';
		announce(`Calling ${dialled}…`);
		await ring();
		if (!alive) return;

		if (right) {
			const last = r === rounds.length - 1;
			const line = last ? task.ending : rounds[r + 1].clip;
			callee = { line, face: FACES[line.who] ?? '🙂', stranger: null };
			run += 1;
			burst += 1;
			react(true, dockEl, run);
			track('number_task', { quiz: quizId, task: task.id, step: 'round_ok', round: r + 1 });
		} else {
			const pick = pickWrongCaller(task.wrong.length, lastWrong);
			lastWrong = pick;
			const stranger = task.wrong[pick];
			callee = { line: stranger, face: stranger.emoji, stranger };
			met = meet(met, stranger.who);
			void storage.set(MET_KEY, JSON.stringify(met));
			battery = Math.max(1, battery - 1);
			run = 0;
			missKey += 1;
			react(false, dockEl);
			track('number_task', { quiz: quizId, task: task.id, step: 'wrong_call', round: r + 1, who: stranger.who });
		}
		phase = 'oncall';
		announce([
			{ text: `${callee.line.name}:` },
			{ text: callee.line.de, lang: locale },
			...(callee.stranger ? [{ text: callee.stranger.caption }] : [])
		]);
		// Hanging up is open after a moment, not after the whole line: you can cut
		// the grandma off mid-rant. A right call's voice note stays in the thread.
		void playClip(callee.line.audio, { text: callee.line.de, locale });
		await sleep(1500);
		if (!alive) return;
		canHangUp = true;
	}

	/** Back to the chat: the call goes in the log, and the game moves on. */
	async function hangUp() {
		if (!callee || !canHangUp) return;
		stopClip();
		const { line, stranger } = callee;
		phase = 'chat';
		if (stranger) {
			add({ kind: 'call', label: `Wrong number · ${stranger.name}`, ok: false });
			fails += 1;
			if (round.kind === 'fill') {
				typed = keepRight(typed, pendingWrong);
				locked = typed.flatMap((d, i) => (d ? [i] : []));
				flash = [...pendingWrong];
				if (fails >= 2 && pendingWrong.length) {
					const k = pendingWrong[0];
					typed[k] = want[k];
					locked = [...locked, k];
					hinted = [...hinted, k];
					flash = flash.filter((i) => i !== k);
					add({ kind: 'note', text: 'One digit filled in for you. Listen again for the rest.' });
				}
			}
			return;
		}
		add({ kind: 'call', label: `Call · ${line.name}`, ok: true });
		if (r === rounds.length - 1) {
			add({ kind: 'voice', line });
			phase = 'done';
			track('number_task', { quiz: quizId, task: task.id, step: 'finish' });
			onFinish();
			return;
		}
		// What they just said is the next number: it goes in the thread to replay.
		r += 1;
		typed = hide.map(() => '');
		locked = [];
		hinted = [];
		flash = [];
		crossed = [];
		fails = 0;
		add({ kind: 'voice', line });
		prompt();
	}

	function restart() {
		r = 0;
		log = [];
		typed = hide.map(() => '');
		locked = [];
		hinted = [];
		flash = [];
		crossed = [];
		fails = 0;
		battery = 5;
		minutes = 40;
		phase = 'lock';
	}

	const KEYS = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
</script>

<div class="phone" class:dark={phase === 'lock' || phase === 'calling' || phase === 'oncall'}>
	<div class="statusbar tnum" aria-hidden="true">
		<span>{clock}</span>
		<span class="batt" class:low={battery <= 2}>
			{battery}% <span class="cell"><span style:width="{battery * 4}%"></span></span>
		</span>
	</div>

	{#if phase === 'lock'}
		<div class="lock">
			{#if !noWallpaper}
				<img class="wallpaper" src="/img/story/task_call_hand.webp" alt="" use:imageGuard={() => (noWallpaper = true)} />
			{/if}
			<div class="lock-inner">
				<p class="lock-time tnum">{clock}</p>
				<p class="lock-date">Sunday</p>
				<p class="lock-story">{task.intro}</p>
				<button type="button" class="notif" onclick={unlock}>
					<span class="app">🎤</span>
					<span class="notif-text">
						<strong>Kim 🎉</strong>
						<span>Voice message · {duration(round.clip)}</span>
					</span>
					<span class="notif-time">02:14</span>
				</button>
				<div class="notif quiet" aria-hidden="true">
					<span class="app">🪫</span>
					<span class="notif-text"><strong>Battery low</strong><span>{battery}% left</span></span>
				</div>
				<p class="lock-hint">Tap the voice message</p>
			</div>
		</div>
	{:else if phase === 'calling' || phase === 'oncall'}
		<div class="callscreen" use:shakeOn={missKey}>
			<p class="call-state">{phase === 'calling' ? 'Calling…' : callee?.stranger ? 'Wrong number' : 'Connected'}</p>
			<div class="avatar" class:ringing={phase === 'calling'} class:stranger={!!callee?.stranger}>
				{phase === 'calling' ? '📞' : callee?.face}
			</div>
			<p class="callee-name tnum">{phase === 'calling' ? dialled : callee?.line.name}</p>
			{#if phase === 'oncall' && callee}
				<p class="call-line" lang={locale}>{callee.line.de}</p>
				<p class="call-en">{callee.line.en}</p>
				<ClipControls id={callee.line.audio} text={callee.line.de} {locale} label="Play again" dark />
				{#if callee.stranger}<p class="caption">{callee.stranger.caption}</p>{/if}
				<button type="button" class="hangup" disabled={!canHangUp} onclick={hangUp} aria-label="Hang up">
					<span aria-hidden="true">📵</span>
				</button>
				<span class="hangup-label">{canHangUp ? 'Hang up' : ' '}</span>
			{/if}
		</div>
	{:else if phase === 'done'}
		<div class="finale">
			<p class="bubble text kim-text">{task.endingText}</p>
			<p class="fin-title">Kim picked up! 🎉</p>
			<p class="fin-sub">Strangers you met on the way · {met.length}/{task.wrong.length}</p>
			<ul class="collection">
				{#each task.wrong as s (s.who)}
					<li class:met={met.includes(s.who)} title={met.includes(s.who) ? s.name : 'Not met yet'}>
						<span aria-hidden="true">{met.includes(s.who) ? s.emoji : '❔'}</span>
						<span class="sr-only">{met.includes(s.who) ? s.name : 'Not met yet'}</span>
					</li>
				{/each}
			</ul>
			{#if met.length < task.wrong.length}<p class="fin-tip">Dial wrong on purpose next time to meet them all 😉</p>{/if}
			<div class="fin-actions">
				<button type="button" class="btn btn-ghost" onclick={restart}>Play again</button>
				<button type="button" class="btn" onclick={onBack}>Back to the tasks</button>
			</div>
		</div>
	{:else}
		<header class="thread-head">
			<span class="face">K</span>
			<span><strong>Kim 🎉</strong><small>from the party</small></span>
		</header>

		<ol class="thread" bind:this={threadEl}>
			{#each log as entry (entry.id)}
				<li class="entry is-{entry.kind}">
					{#if entry.kind === 'voice'}
						<div class="bubble voice" class:playing={on(entry.line, 'playing')} class:paused={on(entry.line, 'paused')}>
							<span class="speaker">{entry.line.name}</span>
							<div class="vrow">
								<button
									type="button"
									class="vplay"
									aria-label="{on(entry.line, 'playing') ? 'Pause' : on(entry.line, 'paused') ? 'Resume' : 'Play'} {entry.line.name}'s voice message"
									onclick={() => toggleClip(entry.line.audio, { text: entry.line.de, locale })}
								>
									<Icon name={on(entry.line, 'playing') ? 'pause' : 'play'} size="1em" />
								</button>
								<span class="wave" aria-hidden="true">
									{#each BARS as h, i (i)}<span style:height="{h}%" style:animation-delay="{(i % 7) * 90}ms"></span>{/each}
								</span>
								<span class="dur tnum">{duration(entry.line)}</span>
								<button
									type="button"
									class="vagain"
									aria-label="Replay {entry.line.name}'s voice message from the start"
									title="Replay from the start"
									onclick={() => playClip(entry.line.audio, { text: entry.line.de, locale })}
								>
									<Icon name="repeat" size="0.95em" />
								</button>
							</div>
							<button
								type="button"
								class="totext"
								aria-expanded={open.includes(entry.id)}
								onclick={() => (open = open.includes(entry.id) ? open.filter((x) => x !== entry.id) : [...open, entry.id])}
							>
								{open.includes(entry.id) ? 'Hide text' : 'Show text'}
							</button>
							{#if open.includes(entry.id)}
								<p class="vtext" lang={locale}>{entry.line.de}</p>
								<p class="ven">{entry.line.en}</p>
							{/if}
						</div>
					{:else if entry.kind === 'text'}
						<p class="bubble text"><span lang={locale}>{entry.text}</span>{#if entry.en}<small>{entry.en}</small>{/if}</p>
					{:else if entry.kind === 'call'}
						<p class="callentry" class:bad={!entry.ok}>{entry.ok ? '📞' : '📵'} {entry.label}</p>
					{:else}
						<p class="note">{entry.text}</p>
					{/if}
				</li>
			{/each}
		</ol>

		<div class="dock" bind:this={dockEl}>
			<Burst trigger={burst} count={18} />
			{#if round.kind === 'pick'}
				<p class="where">{round.where}</p>
				<div class="options" role="group" aria-label="Which number?">
					{#each round.options ?? [] as option (option)}
						<button
							type="button"
							class="option tnum"
							class:crossed={crossed.includes(option)}
							disabled={crossed.includes(option)}
							onclick={() => call(option)}
						>
							<span aria-hidden="true">📞</span>
							{option}
						</button>
					{/each}
				</div>
			{:else}
				<div class="numrow">
					<span class="where">{round.where}</span>
					<div class="number tnum" role="group" aria-label="The number so far">
						{#each cells as cell, i (i)}
							{#if cell.kind === 'space'}<span class="gap"></span>
							{:else if cell.kind === 'digit'}<span class="d">{cell.digit}</span>
							{:else}<span
									class="slot"
									class:filled={typed[cell.slot] !== ''}
									class:next={typed.indexOf('') === cell.slot}
									class:wrong={flash.includes(cell.slot)}
									class:hint={hinted.includes(cell.slot)}
									>{typed[cell.slot] || ''}</span
								>{/if}
						{/each}
					</div>
				</div>
				<div class="keypad" role="group" aria-label="Phone keypad">
					{#each KEYS as k (k)}
						<button type="button" class="key tnum" disabled={full} onclick={() => key(k)}>{k}</button>
					{/each}
					<button type="button" class="key aux" aria-label="Delete" onclick={back}>⌫</button>
					<button type="button" class="key tnum" disabled={full} onclick={() => key('0')}>0</button>
					<button type="button" class="key dial" disabled={!full} aria-label="Call" onclick={() => call()}>
						<span aria-hidden="true">📞</span>
					</button>
				</div>
			{/if}
		</div>
	{/if}
</div>

<style>
	/* The phone: one screen, its own status bar, the chat scrolling inside. */
	.phone {
		--phone-bg: #f4efe6;
		display: flex;
		flex-direction: column;
		width: 100%;
		max-width: 25rem;
		height: min(46rem, calc(100dvh - 8.5rem));
		min-height: 30rem;
		margin: 0 auto;
		overflow: hidden;
		border: 6px solid #1b1f27;
		border-radius: 2rem;
		background: var(--phone-bg);
		box-shadow: 0 20px 40px -24px rgb(20 32 52 / 0.6);
	}

	.phone.dark {
		--phone-bg: #11161f;
		color: #f5f1ea;
	}

	.statusbar {
		display: flex;
		justify-content: space-between;
		flex: none;
		padding: 0.35rem 1.1rem 0.25rem;
		font-size: 0.78rem;
		font-weight: 700;
	}

	.batt {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
	}

	.batt.low {
		color: var(--wrong);
		animation: blink 1.2s steps(2, start) infinite;
	}

	.cell {
		position: relative;
		width: 1.3rem;
		height: 0.62rem;
		border: 1.5px solid currentColor;
		border-radius: 0.18rem;
	}

	.cell span {
		position: absolute;
		inset: 1px auto 1px 1px;
		border-radius: 0.08rem;
		background: currentColor;
		min-width: 2px;
	}

	@keyframes blink {
		to {
			opacity: 0.35;
		}
	}

	/* -- lock screen ---------------------------------------------------------- */

	.lock {
		position: relative;
		flex: 1;
		display: flex;
		overflow: hidden;
	}

	.wallpaper {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
		filter: brightness(0.45) saturate(0.8);
	}

	.lock-inner {
		position: relative;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.55rem;
		width: 100%;
		padding: 1.5rem 1rem 1rem;
		text-align: center;
	}

	.lock-time {
		margin: 0;
		font-size: 3.6rem;
		font-weight: 300;
		line-height: 1;
	}

	.lock-date {
		margin: 0 0 0.4rem;
		font-weight: 600;
		opacity: 0.85;
	}

	.lock-story {
		margin: 0 0 0.6rem;
		font-size: var(--step--1);
		opacity: 0.9;
	}

	.notif {
		display: flex;
		align-items: center;
		gap: 0.65rem;
		width: 100%;
		padding: 0.7rem 0.85rem;
		border: 0;
		border-radius: 1rem;
		background: rgb(255 255 255 / 0.88);
		color: #1b1f27;
		font: inherit;
		text-align: left;
		cursor: pointer;
		animation: arrive 500ms var(--ease-spring) both;
	}

	.notif:hover {
		background: #fff;
	}

	.notif.quiet {
		background: rgb(255 255 255 / 0.55);
		cursor: default;
		animation-delay: 150ms;
	}

	@keyframes arrive {
		from {
			opacity: 0;
			transform: translateY(-10px) scale(0.97);
		}
	}

	.app {
		font-size: 1.4rem;
	}

	.notif-text {
		display: flex;
		flex-direction: column;
		flex: 1;
		font-size: var(--step--1);
	}

	.notif-time {
		font-size: 0.75rem;
		opacity: 0.6;
	}

	.lock-hint {
		margin: auto 0 0;
		font-size: var(--step--1);
		opacity: 0.75;
		animation: pulse-text 1.6s ease-in-out infinite;
	}

	@keyframes pulse-text {
		50% {
			opacity: 0.35;
		}
	}

	/* -- chat ----------------------------------------------------------------- */

	.thread-head {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		flex: none;
		padding: 0.45rem 0.9rem 0.6rem;
		border-bottom: 1px solid rgb(0 0 0 / 0.08);
	}

	.thread-head small {
		display: block;
		font-size: 0.72rem;
		color: var(--ink-muted);
	}

	.face {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.1rem;
		height: 2.1rem;
		border-radius: 50%;
		background: var(--accent);
		color: #fff;
		font-weight: 800;
	}

	.thread {
		flex: 1;
		min-height: 0;
		display: flex;
		flex-direction: column;
		gap: 0.45rem;
		margin: 0;
		padding: 0.8rem 0.8rem 0.6rem;
		overflow-y: auto;
		list-style: none;
	}

	.entry {
		display: flex;
		animation: arrive 320ms var(--ease-out) both;
	}

	.entry.is-note,
	.entry.is-call {
		justify-content: center;
	}

	.bubble {
		max-width: 88%;
		margin: 0;
		padding: 0.5rem 0.7rem;
		border-radius: 1rem 1rem 1rem 0.3rem;
		background: #fff;
		box-shadow: 0 1px 1px rgb(0 0 0 / 0.08);
	}

	.speaker {
		display: block;
		font-size: 0.7rem;
		font-weight: 700;
		color: var(--accent-ink);
	}

	.vrow {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		min-width: 13rem;
	}

	.vplay {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex: none;
		width: 2.1rem;
		height: 2.1rem;
		border: 0;
		border-radius: 50%;
		background: var(--accent);
		color: #fff;
		cursor: pointer;
	}

	.wave {
		display: flex;
		align-items: center;
		gap: 2px;
		flex: 1;
		height: 1.6rem;
	}

	.wave span {
		flex: 1;
		border-radius: 2px;
		background: #c9b9a8;
	}

	.playing .wave span,
	.paused .wave span {
		background: var(--accent);
		animation: wave 0.7s ease-in-out infinite alternate;
	}

	/* Paused: the waveform freezes mid-movement. */
	.paused .wave span {
		animation-play-state: paused;
	}

	.vagain {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex: none;
		width: 1.9rem;
		height: 1.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		cursor: pointer;
	}

	@keyframes wave {
		to {
			transform: scaleY(0.35);
		}
	}

	.dur {
		font-size: 0.72rem;
		color: var(--ink-muted);
	}

	.totext {
		padding: 0.15rem 0 0;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: 0.72rem;
		text-decoration: underline;
		cursor: pointer;
	}

	.vtext {
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--heading);
	}

	.ven {
		margin: 0.15rem 0 0;
		font-size: 0.75rem;
		color: var(--ink-muted);
	}

	.text {
		font-size: var(--step-0);
	}

	.text small {
		display: block;
		font-size: 0.72rem;
		color: var(--ink-muted);
	}

	.note {
		max-width: 92%;
		margin: 0.2rem 0;
		padding: 0.3rem 0.7rem;
		border-radius: 999px;
		background: rgb(31 58 95 / 0.08);
		color: var(--heading);
		font-size: 0.78rem;
		font-weight: 600;
		text-align: center;
	}

	.callentry {
		margin: 0;
		font-size: 0.75rem;
		font-weight: 600;
		color: var(--right);
	}

	.callentry.bad {
		color: var(--wrong);
	}

	/* -- dock: number + keypad / options / finale ----------------------------- */

	.dock {
		position: relative;
		flex: none;
		display: flex;
		flex-direction: column;
		gap: 0.45rem;
		padding: 0.6rem 0.75rem 0.75rem;
		border-top: 1px solid rgb(0 0 0 / 0.08);
		background: #fbf8f3;
	}

	.numrow {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.1rem;
	}

	.where {
		margin: 0;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		text-align: center;
	}

	.number {
		display: flex;
		align-items: center;
		gap: 0.08rem;
		font-size: clamp(1.25rem, 5.6vw, 1.65rem);
		font-weight: 700;
		color: var(--heading);
	}

	.gap {
		width: 0.4em;
	}

	.d,
	.slot {
		display: inline-flex;
		justify-content: center;
		width: 0.8em;
	}

	.slot {
		height: 1.2em;
		align-items: center;
		border-radius: 0.25em;
		background: radial-gradient(circle at 50% 55%, rgb(31 58 95 / 0.35), rgb(31 58 95 / 0.12) 60%, transparent 75%);
		color: var(--accent-ink);
	}

	.slot.filled {
		background: var(--accent-soft);
	}

	.slot.next {
		box-shadow: inset 0 -3px 0 var(--accent);
	}

	.slot.wrong {
		background: var(--wrong-bg);
		box-shadow: inset 0 -3px 0 var(--wrong);
	}

	.slot.hint {
		background: var(--right-bg);
		color: var(--right);
	}

	.keypad {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 0.35rem;
	}

	.key {
		min-height: 2.75rem;
		border: 0;
		border-radius: 999px;
		background: #ebe4d8;
		color: var(--heading);
		font: inherit;
		font-size: var(--step-1);
		font-weight: 700;
		cursor: pointer;
		transition:
			transform var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out);
	}

	.key:active:not(:disabled) {
		transform: scale(0.94);
		background: #dcd2c2;
	}

	.key:disabled {
		opacity: 0.45;
		cursor: default;
	}

	.key.aux {
		background: none;
		color: var(--ink-muted);
	}

	.key.dial {
		background: #2f9e5b;
		color: #fff;
		opacity: 1;
	}

	.key.dial:disabled {
		background: #ebe4d8;
		opacity: 0.6;
	}

	.options {
		display: grid;
		gap: 0.4rem;
	}

	.option {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 0.6rem;
		padding: 0.75rem;
		border: 2px solid var(--line-strong);
		border-radius: 0.9rem;
		background: #fff;
		color: var(--heading);
		font: inherit;
		font-size: var(--step-1);
		font-weight: 700;
		cursor: pointer;
	}

	.option:hover:not(:disabled) {
		border-color: #2f9e5b;
	}

	.option.crossed {
		opacity: 0.45;
		text-decoration: line-through;
		cursor: default;
	}

	/* The ending, at the top of the phone: the page's "finished" bar rises
	   over the bottom of the screen. */
	.finale {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.5rem;
		padding: 1rem 1rem 1.2rem;
		text-align: center;
		overflow-y: auto;
	}

	.kim-text {
		align-self: flex-start;
		margin-bottom: 0.6rem;
		animation: arrive 400ms var(--ease-out) both;
	}

	.fin-title {
		margin: 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-2);
		font-weight: 700;
		color: var(--heading);
	}

	.fin-sub,
	.fin-tip {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.collection {
		display: flex;
		gap: 0.4rem;
		margin: 0.1rem 0;
		padding: 0;
		list-style: none;
	}

	.collection li {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.6rem;
		height: 2.6rem;
		border: 2px dashed var(--line-strong);
		border-radius: 50%;
		font-size: 1.3rem;
		opacity: 0.55;
	}

	.collection li.met {
		border-style: solid;
		border-color: var(--accent);
		background: var(--accent-soft);
		opacity: 1;
	}

	.fin-actions {
		display: flex;
		gap: 0.5rem;
		margin-top: 0.3rem;
	}

	/* -- the call screen ------------------------------------------------------ */

	.callscreen {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.6rem;
		padding: 1.4rem 1.1rem 1.2rem;
		background: linear-gradient(180deg, #1d2a3d, #11161f);
		text-align: center;
		overflow-y: auto;
	}

	.call-state {
		margin: 0;
		font-size: var(--step--1);
		letter-spacing: 0.08em;
		text-transform: uppercase;
		opacity: 0.75;
	}

	.avatar {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 5.5rem;
		height: 5.5rem;
		border-radius: 50%;
		background: var(--accent);
		color: #fff;
		font-size: 2.4rem;
		font-weight: 800;
	}

	.avatar.stranger {
		background: #3a4558;
	}

	.avatar.ringing {
		background: #2f9e5b;
		animation: ringing 1s ease-out infinite;
	}

	@keyframes ringing {
		0% {
			box-shadow: 0 0 0 0 rgb(47 158 91 / 0.6);
		}
		100% {
			box-shadow: 0 0 0 1.4rem rgb(47 158 91 / 0);
		}
	}

	.callee-name {
		margin: 0;
		font-size: var(--step-1);
		font-weight: 700;
	}

	.call-line {
		margin: 0.4rem 0 0;
		padding: 0.6rem 0.85rem;
		border-radius: 1rem;
		background: rgb(255 255 255 / 0.1);
		font-size: var(--step-0);
		font-weight: 600;
		line-height: 1.4;
	}

	.call-en {
		margin: 0;
		font-size: 0.8rem;
		opacity: 0.7;
	}

	.caption {
		margin: 0.3rem 0 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-1);
		font-weight: 700;
		line-height: 1.25;
		color: #ffb48a;
	}

	.hangup {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 4rem;
		height: 4rem;
		margin-top: auto;
		border: 0;
		border-radius: 50%;
		background: #d9443a;
		font-size: 1.6rem;
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
	}

	.hangup:disabled {
		opacity: 0.35;
		cursor: default;
	}

	.hangup:hover:not(:disabled) {
		transform: scale(1.06);
	}

	.hangup-label {
		font-size: 0.75rem;
		opacity: 0.7;
		min-height: 1em;
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
		white-space: nowrap;
	}

	@media (prefers-reduced-motion: reduce) {
		.playing .wave span,
		.avatar.ringing,
		.lock-hint,
		.batt.low {
			animation: none;
		}
	}
</style>
