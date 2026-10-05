<script lang="ts">
	// `dialogue` beats: a live conversation as chat bubbles. Characters'
	// lines are voiced (their own cast voice) and play as they appear; Maya's
	// turns are the learner's — pick her line (`choose`) or build it word by
	// word (`build`). Maya's German is text only (the bible: she never speaks
	// German aloud). `aside` lines are Maya's English whispers to the learner.
	import Icon from '$lib/icons/Icon.svelte';
	import TileBuilder from './TileBuilder.svelte';
	import type { Beat, BeatHost, Opt } from './types';

	type Line = {
		who: string;
		name?: string;
		de?: string;
		en?: string;
		text?: string;
		audio?: string;
		rate?: number;
		/** Spoken too fast to follow: the bubble stays a blur. */
		blur?: boolean;
		/** Words Maya scribbles into the notebook as the line is heard. */
		entries?: { de: string; en: string }[];
		choose?: Opt[];
		build?: { sequence: string[]; options?: string[] };
		critical?: boolean;
	};
	let { beat, host }: { beat: Beat; host: BeatHost } = $props();
	const lines = $derived((beat.lines as Line[]) ?? []);

	/** Lines on screen; the last one may be an open Maya turn. */
	let shown = $state(0);
	/** Maya's answered turns, by line index → the text she said. */
	let said = $state<Record<number, string>>({});
	let gloss = $state<Record<number, boolean>>({});
	let reply = $state<string | null>(null);
	let wrongPick = $state<number | null>(null);
	let choices = $state<Opt[]>([]);
	let tiles = $state<string[]>([]);
	let log: HTMLElement | undefined = $state();

	const isTurn = (l: Line | undefined) => Boolean(l && (l.choose || l.build));
	const current = $derived(lines[shown - 1]);
	const open = $derived(isTurn(current) && said[shown - 1] === undefined);
	const finished = $derived(shown >= lines.length && !open);

	function shuffle<T>(list: T[]): T[] {
		return [...list].sort(() => Math.random() - 0.5);
	}
	function reveal() {
		if (shown >= lines.length) return;
		shown += 1;
		const l = lines[shown - 1];
		reply = null;
		wrongPick = null;
		if (l.choose) choices = shuffle(l.choose.map((o) => ({ ...o, text: host.resolve(o.text) })));
		if (l.build) tiles = shuffle((l.build.options ?? l.build.sequence).map((t) => host.resolve(t)));
		if (l.audio) host.play(host.clip(l.audio), l.rate ?? 1);
		if (l.entries) host.note(l.entries);
		queueMicrotask(() => log?.lastElementChild?.scrollIntoView({ block: 'nearest', behavior: 'smooth' }));
		// Asides and lines followed by Maya's turn flow on by themselves.
		if (!isTurn(l) && isTurn(lines[shown])) reveal();
	}
	$effect(() => {
		if (shown === 0) reveal();
	});

	function answered(text: string, el: Element | null) {
		said = { ...said, [shown - 1]: text };
		reply = null;
		host.right(el);
		setTimeout(() => {
			if (shown < lines.length) reveal();
		}, 650);
	}
	function pick(e: MouseEvent, i: number) {
		const o = choices[i];
		if (o.correct) return answered(o.text, e.currentTarget as Element);
		wrongPick = i;
		reply = o.reply ? host.resolve(o.reply) : null;
		host.wrong(e.currentTarget as Element, current?.critical === true);
	}
	const speaker = (l: Line) => l.name ?? l.who;
	/** Too fast to read: squiggles the length of each word (a CSS blur could still be read). */
	const scribble = (t: string) =>
		host
			.resolve(t)
			.split(/\s+/)
			.map((w) => '≈'.repeat(Math.max(2, Math.round(w.length * 0.7))))
			.join(' ');
</script>

{#if beat.prompt}<p class="q">{host.resolve(`${beat.prompt}`)}</p>{/if}

<div class="chat" bind:this={log} aria-live="polite">
	{#each lines.slice(0, shown) as l, i (i)}
		{#if l.who === 'aside'}
			<p class="aside">“{host.resolve(l.text ?? '')}”</p>
		{:else if isTurn(l)}
			{#if said[i] !== undefined}
				<div class="bubble maya-says" lang="de"><span class="who">Maya</span>{said[i]}</div>
			{/if}
		{:else}
			<div class="bubble npc">
				<span class="who">{speaker(l)}</span>
				{#if l.blur && !finished}
					<span class="blur" aria-label="Too fast to follow — listen to it">{scribble(l.de ?? '')}</span>
				{:else}
					<span lang="de">{host.resolve(l.de ?? '')}</span>
				{/if}
				{#if gloss[i] && l.en && !l.blur}<span class="gloss">{host.resolve(l.en)}</span>{/if}
				<span class="tools">
					{#if l.audio}
						<button class="tool" onclick={() => host.play(host.clip(l.audio ?? ''), l.rate ?? 1)} aria-label="Play again" title="Play again">
							<Icon name="repeat" size="0.9em" />
						</button>
					{/if}
					{#if l.en && !l.blur}
						<button class="tool en" onclick={() => (gloss = { ...gloss, [i]: !gloss[i] })} aria-pressed={gloss[i] === true} title="Show the English">EN</button>
					{/if}
				</span>
			</div>
			{#if l.entries}
				<div class="scribble">
					<span class="scribble-head">✎ into the notebook</span>
					{#each l.entries as e (e.de)}
						<span><strong lang="de">{host.resolve(e.de)}</strong> — {host.resolve(e.en)}</span>
					{/each}
				</div>
			{/if}
		{/if}
	{/each}
</div>

{#if open && current?.choose}
	<div class="opts">
		{#each choices as o, i (o.text)}
			<button class="opt" class:wrong={wrongPick === i} lang="de" onclick={(e) => pick(e, i)}>{o.text}</button>
		{/each}
	</div>
	{#if reply}<p class="maya banter-reply">{reply}</p>{/if}
{:else if open && current?.build}
	{#if current.en}<p class="q">{host.resolve(current.en)}</p>{/if}
	{#key shown}
		<TileBuilder
			{tiles}
			target={current.build.sequence.map((w) => host.resolve(w))}
			bubbles
			ontap={() => host.sfx('notebook', 0.5)}
			onright={(el) => answered(current?.build?.sequence.map((w) => host.resolve(w)).join(' ') ?? '', el)}
			onwrong={(el) => host.wrong(el, current?.critical === true)} />
	{/key}
{:else if finished}
	{#if beat.reveal}<p class="maya">“{host.resolve(`${beat.reveal}`)}”</p>{/if}
	<button class="btn" onclick={host.done}>Continue</button>
{:else if !open && shown < lines.length}
	<button class="btn next" onclick={reveal}>Next</button>
{/if}

<style>
	.chat {
		display: grid;
		gap: 0.55rem;
		width: 100%;
	}
	.bubble {
		position: relative;
		max-width: 85%;
		padding: 0.55rem 0.9rem 0.6rem;
		border-radius: 1rem;
		font-size: var(--step-0);
		line-height: 1.4;
		animation: bubble-in 260ms ease;
	}
	.who {
		display: block;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.02em;
		margin-bottom: 0.1rem;
		opacity: 0.8;
	}
	.npc {
		justify-self: start;
		background: var(--surface);
		border: 1.5px solid var(--line-strong);
		border-bottom-left-radius: 0.25rem;
		padding-right: 4.6rem;
	}
	.maya-says {
		justify-self: end;
		background: #d9a441;
		color: #1f2a3a;
		font-weight: 600;
		border-bottom-right-radius: 0.25rem;
	}
	.blur {
		color: var(--ink-muted);
		letter-spacing: -0.08em;
		filter: blur(1.2px);
		user-select: none;
	}
	.gloss {
		display: block;
		color: var(--ink-muted);
		font-style: italic;
		font-size: var(--step--1);
		margin-top: 0.15rem;
	}
	.tools {
		position: absolute;
		top: 0.45rem;
		right: 0.5rem;
		display: flex;
		gap: 0.25rem;
	}
	.tool {
		border: 1px solid var(--line-strong);
		background: var(--surface-alt, transparent);
		color: var(--heading);
		border-radius: 999px;
		min-width: 1.9rem;
		height: 1.9rem;
		display: grid;
		place-items: center;
		cursor: pointer;
		font-size: 0.72rem;
		font-weight: 700;
		padding: 0 0.35rem;
	}
	.tool.en[aria-pressed='true'] {
		background: var(--accent-soft);
		border-color: var(--accent);
	}
	.scribble {
		justify-self: start;
		display: grid;
		gap: 0.1rem;
		background: var(--right-bg);
		border-left: 3px solid var(--right);
		border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
		padding: 0.45rem 0.8rem;
		font-size: var(--step--1);
		animation: bubble-in 260ms ease;
	}
	.scribble-head {
		font-weight: 700;
		color: var(--right);
		text-transform: uppercase;
		letter-spacing: 0.05em;
		font-size: 0.72rem;
	}
	.aside {
		justify-self: center;
		margin: 0.1rem 0;
		font-style: italic;
		color: var(--ink-muted);
		font-size: var(--step--1);
		text-align: center;
		max-width: 90%;
	}
	.next {
		justify-self: start;
	}
	@keyframes bubble-in {
		from {
			opacity: 0;
			transform: translateY(8px) scale(0.98);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.bubble {
			animation: none;
		}
	}
</style>
