<script lang="ts">
	// Pictures for the "?" help panels. "anatomy" is a real screenshot of the
	// deck (tool/gen-help-shots.mjs) with numbered markers measured from the
	// page; the diagrams are drawn from the same settings the deck deals with
	// (DECK_PACES, REVIEW_INTERVAL_DAYS, the surprise odds), so they cannot
	// drift from what the deck actually does.
	import { DECK_PACES, DECK_PACE_ORDER, DEFAULT_SIZE } from '$lib/domain/deck';
	import { REVIEW_INTERVAL_DAYS } from '$lib/domain/review';
	import { SURPRISE_BOOST_CHANCE, SURPRISE_CHANCE } from '$lib/domain/surprise';
	import { MAX_INTEREST, PARTIAL_AT, START_INTEREST, UNDERSTOOD_AT, WIN_AT } from '$lib/domain/matchChat';
	import shots from '$lib/content/helpShots.json';

	let { kind }: { kind: string } = $props();

	type Legend = Record<number, { title: string; text: string }>;
	/** The annotated screenshots: which picture, its alt text, and what each number means. */
	const ANATOMIES: Record<string, { shot: keyof typeof shots; alt: string; legend: Legend }> = {
		anatomy: {
			shot: 'deck-anatomy',
			alt: 'The deck: the pace and level chip, the progress ring, the top card and the three buttons under it.',
			legend: {
				1: { title: 'Pace and level', text: 'How the deck deals. Tap to change.' },
				2: { title: 'Progress ring', text: 'How much of this level you have done.' },
				3: { title: 'Why this card', text: 'Continue, Learn next, Practise, Review, Something new…' },
				4: { title: 'Card count', text: 'Where you are in this hand.' },
				5: { title: 'Skip', text: 'Or swipe left: not now.' },
				6: { title: 'Exercise library', text: 'Every exercise, to choose yourself.' },
				7: { title: "Let's go", text: 'Or swipe right: open the exercise.' },
				8: { title: 'Level and type', text: 'Which level the exercise is from, and what kind it is.' }
			}
		},
		'contacts-anatomy': {
			shot: 'contacts-anatomy',
			alt: 'The Schreib mir! contact list: a contact who liked you, open chats, a chat that ended without a like, and blurred characters not met yet.',
			legend: {
				1: { title: 'Met so far', text: 'How many characters you have met, out of all of them.' },
				2: { title: 'Level chips', text: 'Filter the whole list by level.' },
				3: { title: 'A contact', text: 'Someone who liked you. Tap to read your chat again.' },
				4: { title: 'What they know', text: 'The things you told them in the chat.' },
				5: { title: 'Their voice note', text: 'Arrives the Sunday after your chat.' },
				6: { title: 'Weiter', text: 'Carry on a chat you started.' },
				7: { title: 'Schreib!', text: 'Start a chat with someone you met in your deck.' },
				8: { title: 'Met, no like', text: 'A chat that ended without a like, with their last words.' },
				9: { title: 'Not met yet', text: 'They turn up in your deck, one at a time.' }
			}
		},
		'chat-anatomy': {
			shot: 'chat-anatomy',
			alt: 'A Schreib mir! chat with Lena: the interest hearts, the goal, her messages and a photo, a sentence with its score and the correction, and the word tiles.',
			legend: {
				1: { title: 'Interest', text: 'The hearts. Good answers raise them; at zero you are deleted.' },
				2: { title: 'Goal', text: 'What you are trying to get. One chance.' },
				3: { title: 'Messages and photos', text: 'The speaker reads a message aloud, EN shows it in English, and a photo opens big.' },
				4: { title: 'Your score', text: 'How well your sentence was built. Tap it for the details.' },
				5: { title: 'Ah, du meinst', text: 'They understood you, and say it back the right way, with the fix highlighted.' },
				6: { title: 'Your sentence', text: 'Tap a word to take it back. The line under it shows how it reads.' },
				7: { title: 'Word tiles', text: 'Tap to add a word.' },
				8: { title: '. and ?', text: 'End a sentence and start another, or make it a question.' },
				9: { title: 'Send', text: 'Off it goes. No take-backs.' }
			}
		}
	};
	const anat = $derived(ANATOMIES[kind]);
	const pic = $derived(anat ? shots[anat.shot] : null);
	const legend = $derived(pic ? [...pic.markers].sort((a, b) => a.n - b.n) : []);

	/** The hand a pace deals, as the deck counts it: repair and next steps rounded, new takes the rest. */
	const mix = DECK_PACE_ORDER.map((id) => {
		const p = DECK_PACES[id];
		const repair = Math.round(DEFAULT_SIZE * p.quota.repair);
		const next = Math.round(DEFAULT_SIZE * p.quota.explore);
		const spread = [-2, -1, 0, 1, 2].map((o) => p.levels.find((l) => l.offset === o)?.weight ?? 0);
		return { id, label: p.label, repair, fresh: DEFAULT_SIZE - repair - next, next, spread };
	});
	const squares = (m: (typeof mix)[number]) => [
		...Array(m.repair).fill('repair'),
		...Array(m.fresh).fill('fresh'),
		...Array(m.next).fill('next')
	];

	const R = REVIEW_INTERVAL_DAYS;
	const MAX_DAY = R.gold;
	const stops = [
		{ day: R.shaky, label: 'Shaky', tone: 'repair' },
		{ day: R.bronze, label: 'Bronze', tone: 'bronze' },
		{ day: R.silver, label: 'Silver · reading, listening, speaking', tone: 'silver' },
		{ day: R.gold, label: 'Gold', tone: 'gold' }
	];
	const pct = (n: number) => Math.round(n * 100);

	const KINDS = [
		{ icon: '📖', label: 'Story' },
		{ icon: '🎵', label: 'Song' },
		{ icon: '🔀', label: 'Ja oder Nein?' },
		{ icon: '💬', label: 'Schreib mir!' }
	];
</script>

{#if anat && pic}
	<figure class="anatomy">
		<div class="shot" style:aspect-ratio="{pic.width} / {pic.height}">
			<img src="/img/help/{anat.shot}.webp" alt={anat.alt} loading="lazy" />
			{#each pic.markers as m (m.n)}
				<span class="pin" class:above={'side' in m && m.side === 'top'} class:right={'side' in m && m.side === 'right'} style:left="{m.x}%" style:top="{m.y}%" aria-hidden="true">{m.n}</span>
			{/each}
		</div>
		<ol class="legend">
			{#each legend as m (m.n)}
				<li><span class="pin static" aria-hidden="true">{m.n}</span><span><strong>{anat.legend[m.n].title}</strong> {anat.legend[m.n].text}</span></li>
			{/each}
		</ol>
	</figure>
{:else if kind === 'swipe'}
	<figure class="swipe" aria-label="Swipe the card left to skip it, right to open it.">
		<div class="lane">
			<span class="dir no" aria-hidden="true">← Skip<small>not now</small></span>
			<span class="mini-card" aria-hidden="true">
				<span class="mc-label">Learn next</span>
				<span class="mc-title"></span>
				<span class="mc-line"></span>
			</span>
			<span class="dir yes" aria-hidden="true">Let's go →<small>open it</small></span>
		</div>
	</figure>
{:else if kind === 'mix'}
	<figure class="mix">
		<div class="mix-key" aria-hidden="true">
			<span><i class="sq repair"></i> Repair</span>
			<span><i class="sq fresh"></i> New</span>
			<span><i class="sq next"></i> Next steps</span>
		</div>
		{#each mix as m (m.id)}
			<div class="mix-row">
				<span class="mix-label">{m.label}</span>
				<span class="squares" aria-hidden="true">
					{#each squares(m) as s, i (i)}<i class="sq {s}"></i>{/each}
				</span>
				<span class="sr-only">{m.repair} repair, {m.fresh} new, {m.next} next steps out of {DEFAULT_SIZE}.</span>
				<span class="spread" aria-hidden="true" title="New cards by level: two back to two ahead">
					{#each m.spread as w, i (i)}
						<span class="bar-col"><i style:height="{Math.max(w > 0 ? 8 : 0, pct(w))}%" class:own={i === 2}></i></span>
					{/each}
				</span>
			</div>
		{/each}
		<figcaption>
			Each row is one hand of {DEFAULT_SIZE} cards. The little bars show where the new cards come from: two levels back on the left,
			your level in the middle, two levels ahead on the right.
		</figcaption>
	</figure>
{:else if kind === 'review'}
	<figure class="review">
		<div class="track" aria-hidden="true">
			<span class="day0">Finished</span>
			{#each stops as s (s.label)}
				<span class="stop {s.tone}" style:left="{(s.day / MAX_DAY) * 100}%">
					<i></i>
					<b>{s.day === 1 ? '1 day' : `${s.day} days`}</b>
					<small>{s.label}</small>
				</span>
			{/each}
		</div>
		<figcaption class="sr-only">
			A finished exercise comes back after {R.shaky} day if it was shaky, {R.bronze} days with bronze, {R.silver} days with silver
			(and for reading, listening and speaking), {R.gold} days with gold.
		</figcaption>
	</figure>
{:else if kind === 'lifecycle'}
	<figure class="flow life">
		<div class="state"><span class="blur-dot" aria-hidden="true">?</span><span><strong>Noch nicht getroffen.</strong> Blurred, somewhere in the course.</span></div>
		<div class="arrow" aria-hidden="true">↓ <small>turns up in your deck, and you open the card</small></div>
		<div class="state"><span class="tag new">Schreib!</span><span><strong>Offen.</strong> Met, not written to yet.</span></div>
		<div class="arrow" aria-hidden="true">↓ <small>you start the chat</small></div>
		<div class="state"><span class="tag go">Weiter</span><span><strong>Offen.</strong> The chat is running. Leave and come back any time.</span></div>
		<div class="arrow" aria-hidden="true">↓ <small>the chat ends, once and for all</small></div>
		<div class="ends">
			<span class="end win"><b>❤️ Mag dich</b><small>{WIN_AT} or more hearts at the end. A contact, and a voice note on Sunday.</small></span>
			<span class="end mid"><b>🤝 Met, no like</b><small>{PARTIAL_AT} to {WIN_AT - 1} hearts at the end.</small></span>
			<span class="end lost"><b>💔 Deleted</b><small>Under {PARTIAL_AT} at the end, or no hearts left mid-chat.</small></span>
		</div>
	</figure>
{:else if kind === 'interest'}
	<figure class="flow interest">
		<p class="flow-head"><strong>Each sentence you send</strong> gets a score out of 100:</p>
		<div class="bands">
			<span class="band top"><b>100</b><small>Perfect. A good answer earns an extra ❤ on top.</small></span>
			<span class="band ok"><b>{UNDERSTOOD_AT} to 99</b><small>Understood. They answer, and say it back right: „Ah, du meinst…“</small></span>
			<span class="band bad"><b>Under {UNDERSTOOD_AT}</b><small>„Hä?“ They could not follow: one ❤ less.</small></span>
		</div>
		<p class="flow-head"><strong>What you say counts too.</strong> An answer they like adds hearts, one that annoys them takes some away, and one that misses the question costs a heart.</p>
		<div class="meter-scale" aria-hidden="true">
			{#each Array(MAX_INTEREST + 1) as _, i (i)}
				<span class="cell" class:lost={i < PARTIAL_AT} class:mid={i >= PARTIAL_AT && i < WIN_AT} class:win={i >= WIN_AT} class:start={i === START_INTEREST}>{i}</span>
			{/each}
		</div>
		<div class="scale-key" aria-hidden="true">
			<span>💔 0 to {PARTIAL_AT - 1}</span>
			<span>🤝 {PARTIAL_AT} to {WIN_AT - 1}</span>
			<span>❤️ {WIN_AT} to {MAX_INTEREST}</span>
		</div>
		<figcaption>
			You start with {START_INTEREST} hearts (circled), out of {MAX_INTEREST}. Where you stand after the last message decides the ending: under {PARTIAL_AT} they delete you, {PARTIAL_AT} to {WIN_AT - 1} you part as acquaintances, {WIN_AT} or more they like you. At 0 they delete you on the spot.
		</figcaption>
	</figure>
{:else if kind === 'surprise'}
	<figure class="flow">
		<div class="step">
			<span class="step-n">1</span>
			<span><strong>A new hand is dealt.</strong> One roll: does a surprise come?</span>
		</div>
		<div class="odds" aria-hidden="false">
			<span class="odd"><b>{pct(SURPRISE_CHANCE)}%</b> usually</span>
			<span class="odd boost"><b>{pct(SURPRISE_BOOST_CHANCE)}%</b> after a passed run</span>
			<span class="odd sure"><b>100%</b> your very first</span>
		</div>
		<div class="arrow" aria-hidden="true">↓</div>
		<div class="step">
			<span class="step-n">2</span>
			<span><strong>One kind is picked</strong> from those that have something for you:</span>
		</div>
		<div class="kinds">
			{#each KINDS as k (k.label)}<span class="kind"><span aria-hidden="true">{k.icon}</span> {k.label}</span>{/each}
		</div>
		<div class="arrow" aria-hidden="true">↓</div>
		<div class="step">
			<span class="step-n">3</span>
			<span><strong>It goes near the top</strong> of the hand. Never more than one.</span>
		</div>
		<div class="hand" aria-hidden="true">
			<i></i><i class="surprise">★</i><i></i><i></i><i></i><i></i>
		</div>
	</figure>
{/if}

<style>
	figure {
		margin: 0.6rem 0 0;
	}
	/* ---- anatomy -------------------------------------------------------- */
	/* Markers may sit past the picture's edge (a full-width screen has no
	   margin of its own), so the frame is on the image, not the box. */
	.shot {
		position: relative;
		max-width: 19rem;
		margin: 0 auto;
	}
	.shot img {
		display: block;
		width: 100%;
		height: 100%;
		border-radius: var(--radius-sm);
		box-shadow: 0 0 0 1px var(--line), 0 6px 18px -8px rgb(31 58 95 / 0.35);
	}
	.pin {
		position: absolute;
		display: grid;
		place-items: center;
		width: 1.35rem;
		height: 1.35rem;
		border-radius: 50%;
		background: var(--terracotta);
		color: #fff;
		font-size: 0.72rem;
		font-weight: 800;
		box-shadow: 0 0 0 2px #fff, 0 2px 6px rgb(0 0 0 / 0.3);
		transform: translate(-115%, -50%);
	}
	.pin.right {
		transform: translate(15%, -50%);
	}
	.pin.above {
		transform: translate(-50%, -75%);
	}
	.pin.static {
		position: static;
		flex: none;
		transform: none;
	}
	.legend {
		display: grid;
		gap: 0.4rem;
		margin: 0.8rem 0 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.legend li {
		display: flex;
		gap: 0.5rem;
		align-items: flex-start;
	}
	.legend strong {
		color: var(--heading);
	}
	/* ---- swipe ---------------------------------------------------------- */
	.lane {
		display: grid;
		grid-template-columns: 1fr auto 1fr;
		align-items: center;
		gap: 0.5rem;
		padding: 0.8rem 0.4rem;
		border-radius: var(--radius-sm);
		background: var(--paper-mid);
	}
	.dir {
		display: grid;
		font-weight: 800;
		font-size: var(--step--1);
		text-align: center;
	}
	.dir small {
		font-weight: 500;
		color: var(--ink-muted);
	}
	.dir.no {
		color: var(--wrong);
	}
	.dir.yes {
		color: var(--right, #3f7d46);
	}
	.mini-card {
		display: grid;
		gap: 0.3rem;
		width: 5.5rem;
		padding: 0.5rem;
		border-radius: 0.6rem;
		background: var(--surface);
		border-top: 4px solid var(--terracotta);
		box-shadow: 0 6px 14px -6px rgb(31 58 95 / 0.4);
		animation: sway 3.2s ease-in-out infinite;
	}
	.mc-label {
		font-size: 0.5rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--terracotta);
	}
	.mc-title,
	.mc-line {
		height: 0.45rem;
		border-radius: 999px;
		background: var(--heading);
		opacity: 0.8;
	}
	.mc-line {
		width: 70%;
		opacity: 0.3;
	}
	@keyframes sway {
		0%,
		100% {
			transform: translateX(0) rotate(0);
		}
		25% {
			transform: translateX(-0.9rem) rotate(-6deg);
		}
		75% {
			transform: translateX(0.9rem) rotate(6deg);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.mini-card {
			animation: none;
		}
	}
	:global(html[data-effects='calm']) .mini-card {
		animation: none;
	}
	/* ---- mix ------------------------------------------------------------ */
	.mix {
		display: grid;
		gap: 0.55rem;
	}
	.mix-key {
		display: flex;
		flex-wrap: wrap;
		gap: 0.8rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.mix-key span {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
	}
	.mix-row {
		display: grid;
		grid-template-columns: 1fr auto;
		grid-template-areas: 'label label' 'squares spread';
		align-items: end;
		gap: 0.2rem 0.6rem;
	}
	.mix-label {
		grid-area: label;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--heading);
	}
	.squares {
		grid-area: squares;
		display: grid;
		grid-template-columns: repeat(12, 1fr);
		gap: 2px;
	}
	.sq {
		display: inline-block;
		aspect-ratio: 1;
		min-width: 0.75rem;
		border-radius: 3px;
	}
	.mix-key .sq {
		width: 0.75rem;
	}
	.sq.repair {
		background: var(--terracotta);
	}
	.sq.fresh {
		background: var(--heading);
	}
	.sq.next {
		background: var(--ochre, #d9a441);
	}
	.spread {
		grid-area: spread;
		display: flex;
		align-items: flex-end;
		gap: 2px;
		height: 1.4rem;
		padding-bottom: 1px;
		border-bottom: 1px solid var(--line-strong);
	}
	.bar-col {
		display: flex;
		align-items: flex-end;
		width: 0.45rem;
		height: 100%;
	}
	.bar-col i {
		width: 100%;
		border-radius: 2px 2px 0 0;
		background: var(--heading);
		opacity: 0.45;
	}
	.bar-col i.own {
		opacity: 1;
	}
	figcaption {
		font-size: var(--step--2, 0.75rem);
		color: var(--ink-muted);
	}
	/* ---- review --------------------------------------------------------- */
	.track {
		position: relative;
		height: 5.2rem;
		margin: 0 1.2rem 1.4rem 0.4rem;
		border-bottom: 3px solid var(--line-strong);
	}
	.day0 {
		position: absolute;
		left: 0;
		bottom: -1.5rem;
		font-size: 0.68rem;
		font-weight: 700;
		color: var(--ink-muted);
		transform: translateX(-30%);
	}
	.stop {
		position: absolute;
		bottom: -0.45rem;
		display: grid;
		justify-items: center;
		transform: translateX(-50%);
		text-align: center;
		width: 4.5rem;
	}
	.stop i {
		order: 3;
		width: 0.8rem;
		height: 0.8rem;
		border-radius: 50%;
		border: 2px solid #fff;
		background: currentColor;
		box-shadow: 0 1px 4px rgb(0 0 0 / 0.25);
	}
	.stop b {
		font-size: 0.72rem;
		color: var(--heading);
	}
	.stop small {
		font-size: 0.6rem;
		line-height: 1.15;
		color: var(--ink-muted);
		margin-bottom: 0.2rem;
	}
	.stop.repair {
		color: var(--terracotta);
	}
	.stop.bronze {
		color: #b0703c;
	}
	.stop.silver {
		color: #8f99a6;
	}
	.stop.gold {
		color: #d4a017;
	}
	.stop:nth-child(odd) small {
		margin-bottom: 1.6rem;
	}
	/* ---- surprise flow -------------------------------------------------- */
	.flow {
		display: grid;
		gap: 0.45rem;
		padding: 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--paper-mid);
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.flow strong {
		color: var(--heading);
	}
	.step {
		display: flex;
		gap: 0.5rem;
		align-items: flex-start;
	}
	.step-n {
		flex: none;
		display: grid;
		place-items: center;
		width: 1.3rem;
		height: 1.3rem;
		border-radius: 50%;
		background: var(--heading);
		color: #fff;
		font-size: 0.7rem;
		font-weight: 800;
	}
	.odds,
	.kinds {
		display: flex;
		flex-wrap: wrap;
		gap: 0.35rem;
		padding-left: 1.8rem;
	}
	.odd,
	.kind {
		padding: 0.2rem 0.55rem;
		border-radius: 999px;
		background: var(--surface);
		border: 1px solid var(--line);
		color: var(--ink);
		font-size: 0.75rem;
	}
	.odd b {
		color: var(--heading);
	}
	.odd.boost b {
		color: #3f7d46;
	}
	.odd.sure b {
		color: var(--terracotta);
	}
	.arrow {
		padding-left: 0.35rem;
		color: var(--ink-muted);
		line-height: 1;
	}
	/* ---- Schreib mir! lifecycle ---------------------------------------- */
	.state {
		display: flex;
		gap: 0.6rem;
		align-items: center;
	}
	.blur-dot {
		flex: none;
		display: grid;
		place-items: center;
		width: 2rem;
		height: 2.6rem;
		border-radius: 0.4rem;
		background: linear-gradient(135deg, #7d7480, #b7a99b);
		color: #fff;
		font-weight: 800;
	}
	.tag {
		flex: none;
		padding: 0.2rem 0.6rem;
		border-radius: 999px;
		color: #fff;
		font-size: 0.72rem;
		font-weight: 800;
	}
	.tag.new {
		background: linear-gradient(120deg, #c2364a, #ff6b81);
	}
	.tag.go {
		background: #3f7d46;
	}
	.arrow small {
		margin-left: 0.3rem;
		font-size: 0.72rem;
	}
	.ends,
	.bands {
		display: grid;
		gap: 0.35rem;
	}
	.end,
	.band {
		display: grid;
		padding: 0.4rem 0.6rem;
		border-radius: var(--radius-sm);
		background: var(--surface);
		border-left: 4px solid var(--line-strong);
	}
	.end b,
	.band b {
		color: var(--heading);
	}
	.end small,
	.band small {
		font-size: 0.72rem;
	}
	.end.win,
	.band.top {
		border-left-color: #c2364a;
	}
	.end.mid,
	.band.ok {
		border-left-color: #d9a441;
	}
	.end.lost,
	.band.bad {
		border-left-color: #8a8f99;
	}
	.flow-head {
		margin: 0;
	}
	/* ---- interest scale -------------------------------------------------- */
	.meter-scale {
		display: grid;
		grid-template-columns: repeat(11, 1fr);
		gap: 2px;
		margin-top: 0.3rem;
	}
	.cell {
		display: grid;
		place-items: center;
		height: 1.7rem;
		border-radius: 4px;
		color: #fff;
		font-size: 0.7rem;
		font-weight: 800;
	}
	.cell.lost {
		background: #8a8f99;
	}
	.cell.mid {
		background: #d9a441;
	}
	.cell.win {
		background: #c2364a;
	}
	.cell.start {
		box-shadow: 0 0 0 2px var(--paper-mid), 0 0 0 4px var(--heading);
	}
	.scale-key {
		display: flex;
		justify-content: space-between;
		gap: 0.4rem;
		font-size: 0.72rem;
		font-weight: 700;
	}
	.hand {
		display: flex;
		gap: 0.3rem;
		padding-left: 1.8rem;
	}
	.hand i {
		display: grid;
		place-items: center;
		width: 1.5rem;
		height: 2rem;
		border-radius: 0.3rem;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		font-style: normal;
		font-size: 0.8rem;
	}
	.hand i.surprise {
		background: linear-gradient(135deg, #ff4d6d, #d9a441);
		border-color: transparent;
		color: #fff;
	}
</style>
