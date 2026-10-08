<script lang="ts">
	// The progress panel: what the ring beside the deck chip opens. The ring
	// shows one number — the current sub-level — and this is the rest: the
	// whole course, accuracy, medals, every sub-level and exercise type, and
	// the topics that are going well or need work.
	//
	// Every figure is printed as text; the bars only repeat it, so nothing is
	// read from colour or length alone.
	import Sheet from '$lib/components/Sheet.svelte';
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import { account } from '$lib/state/account.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { typeLabel } from '$lib/domain/deck';
	import { ALMOST_THROUGH, percentOf, type LevelProgress, type ProgressStats } from '$lib/domain/stats';

	let {
		open = $bindable(false),
		stats,
		current
	}: {
		open?: boolean;
		stats: ProgressStats;
		/** The sub-level the deck is dealing from. */
		current: LevelProgress | undefined;
	} = $props();

	const R = 16;
	const C = 2 * Math.PI * R;

	const levelPct = $derived(current ? percentOf(current) : 0);
	const fresh = $derived(stats.answers === 0 && stats.course.done === 0);
	const medalTotal = $derived(stats.medals.gold + stats.medals.silver + stats.medals.bronze);

	const nudge = $derived.by(() => {
		if (!current || current.total === 0) return '';
		const left = current.total - current.done;
		if (left === 0) return `${current.level} is done. Pick the next level in your deck to keep going.`;
		if (current.done / current.total >= ALMOST_THROUGH)
			return `Almost through ${current.level} — ${left} to go.`;
		if (current.done === 0) return `Your first ${current.level} exercise is waiting in the deck.`;
		return `${left} exercises left at ${current.level}.`;
	});

	const lastPlayed = $derived(
		stats.daysSincePlayed === null
			? null
			: stats.daysSincePlayed === 0
				? 'today'
				: stats.daysSincePlayed === 1
					? 'yesterday'
					: `${stats.daysSincePlayed} days ago`
	);

	/** "A1.2 · Im Alltag" → "Im Alltag": the eyebrow already names the level. */
	const levelName = $derived(current ? current.title.replace(/^[A-C]\d(\.\d)?\s*[·:–-]\s*/i, '') : '');

	const pct = (value: number | null) => (value === null ? '–' : `${Math.round(value * 100)}%`);
	const capital = (text: string) => text.charAt(0).toUpperCase() + text.slice(1);
</script>

<Sheet bind:open title="Your progress" id="progress-panel">
	{#if current}
		<section class="hero" aria-label="Current level">
			<svg class="big-ring" viewBox="0 0 40 40" aria-hidden="true">
				<circle class="track" cx="20" cy="20" r={R} />
				<circle
					class="arc"
					class:started={current.done > 0}
					cx="20"
					cy="20"
					r={R}
					stroke-dasharray="{(levelPct / 100) * C} {C}"
				/>
			</svg>
			<div class="hero-text">
				<p class="eyebrow-sm">Now at <strong class="tnum">{current.level}</strong></p>
				<p class="hero-title">{levelName}</p>
				<p class="hero-num tnum">
					{current.done > 0 && levelPct === 0 ? '<1' : levelPct}<span>%</span>
					<small>{current.done} of {current.total} done</small>
				</p>
			</div>
		</section>
		{#if nudge}<p class="nudge">{nudge}</p>{/if}
	{/if}

	<div class="tiles">
		<div class="tile">
			<span class="tile-label">Whole course</span>
			<span class="tile-value tnum">{stats.course.done > 0 && percentOf(stats.course) === 0 ? '<1' : percentOf(stats.course)}%</span>
			<span class="tile-sub tnum">{stats.course.done} / {stats.course.total} exercises</span>
		</div>
		<div class="tile">
			<span class="tile-label">Right answers</span>
			<span class="tile-value tnum">{pct(stats.accuracy)}</span>
			<span class="tile-sub tnum">
				{#if stats.recentAccuracy !== null}lately {pct(stats.recentAccuracy)}{:else}no answers yet{/if}
			</span>
		</div>
		<div class="tile">
			<span class="tile-label">Answers given</span>
			<span class="tile-value tnum">{stats.answers.toLocaleString('en')}</span>
			<span class="tile-sub tnum">
				{stats.playedThisWeek} exercise{stats.playedThisWeek === 1 ? '' : 's'} this week
			</span>
		</div>
		<div class="tile">
			<span class="tile-label">Medals</span>
			<span class="tile-value tnum">{medalTotal}</span>
			<span class="medals tnum">
				<span title="Gold"><RibbonBadge tier="gold" width={11} /> {stats.medals.gold}</span>
				<span title="Silver"><RibbonBadge tier="silver" width={11} /> {stats.medals.silver}</span>
				<span title="Bronze"><RibbonBadge tier="bronze" width={11} /> {stats.medals.bronze}</span>
			</span>
		</div>
	</div>

	{#if fresh}
		<p class="note">Finish your first exercise and this panel fills in: accuracy, medals, your strong topics and the ones to work on.</p>
	{:else}
		<ul class="facts">
			{#if lastPlayed}
				<li><Icon name="flame" size="1.05em" /> Last practised {lastPlayed}</li>
			{/if}
			<li>
				<Icon name="repeat" size="1.05em" />
				{#if stats.reviewsDue > 0}
					{stats.reviewsDue} finished exercise{stats.reviewsDue === 1 ? ' is' : 's are'} due a refresh — they come round in your deck.
				{:else}
					Nothing due for review right now.
				{/if}
			</li>
		</ul>
	{/if}

	{#if stats.strengths.length || stats.weakSpots.length}
		<div class="topics">
			{#if stats.strengths.length}
				<section>
					<h3>Going well</h3>
					<ul>
						{#each stats.strengths as t (t.topic)}
							<li><span>{capital(t.label)}</span> <strong class="tnum good">{pct(t.accuracy)}</strong></li>
						{/each}
					</ul>
				</section>
			{/if}
			{#if stats.weakSpots.length}
				<section>
					<h3>Worth another go</h3>
					<ul>
						{#each stats.weakSpots as t (t.topic)}
							<li><span>{capital(t.label)}</span> <strong class="tnum">{pct(t.accuracy)}</strong></li>
						{/each}
					</ul>
				</section>
			{/if}
		</div>
	{/if}

	<h3 class="section">Levels</h3>
	<ul class="bars">
		{#each stats.levels as l (l.level)}
			{@const p = percentOf(l)}
			<li class:current={l.level === current?.level} class:complete={l.total > 0 && l.done === l.total}>
				<span class="bar-name tnum">{l.level}</span>
				<span class="bar" style="--p:{p}%" aria-hidden="true"><span></span></span>
				<span class="bar-num tnum">{l.done} / {l.total}</span>
			</li>
		{/each}
	</ul>

	<h3 class="section">By exercise type</h3>
	<ul class="bars types">
		{#each stats.types as t (t.type)}
			{@const p = percentOf(t)}
			<li>
				<span class="bar-name">
					<Icon name={QUIZ_TYPE_ICONS[t.type]} size="1em" />
					<span>
						{capital(typeLabel(t.type))}
						{#if t.accuracy !== null}<small class="tnum">{pct(t.accuracy)} right</small>{/if}
					</span>
				</span>
				<span class="bar" style="--p:{p}%" aria-hidden="true"><span></span></span>
				<span class="bar-num tnum">{t.done} / {t.total}</span>
			</li>
		{/each}
	</ul>

	<!-- Last, and deliberately here: this panel is the page about the learner's
	     progress, so it is the honest place to say where that progress lives. -->
	{#if account.available}
		<h3 class="section">Keep it safe</h3>
		<AccountCard heading={false} />
	{/if}

	{#snippet footer()}
		<button type="button" class="close-btn" onclick={() => (open = false)}>Back to the deck</button>
	{/snippet}
</Sheet>

<style>
	.hero {
		display: flex;
		align-items: center;
		gap: 1rem;
	}

	.big-ring {
		flex: none;
		width: 5.5rem;
		height: 5.5rem;
		transform: rotate(-90deg);
	}

	.big-ring circle {
		fill: none;
		stroke-width: 5;
	}

	.track {
		stroke: var(--paper-high);
	}

	.arc {
		stroke: var(--accent);
		stroke-linecap: round;
		opacity: 0;
	}

	.arc.started {
		opacity: 1;
	}

	.hero-text p {
		margin: 0;
	}

	.eyebrow-sm {
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.eyebrow-sm strong {
		color: var(--accent-ink);
	}

	.hero-title {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		font-weight: 700;
		line-height: 1.2;
		color: var(--heading);
	}

	.hero-num {
		margin-top: 0.15rem !important;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 700;
		color: var(--heading);
		line-height: 1.1;
	}

	.hero-num > span {
		font-size: 0.55em;
		color: var(--ink-muted);
	}

	.hero-num small {
		margin-left: 0.5rem;
		font-family: 'Inter Variable', 'Inter', system-ui, sans-serif;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.nudge {
		margin: 0.8rem 0 0;
		padding: 0.6rem 0.8rem;
		border-radius: var(--radius-sm);
		background: var(--accent-soft);
		color: var(--heading);
		font-size: var(--step--1);
		font-weight: 600;
	}

	.tiles {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.6rem;
		margin: 1rem 0 0;
	}

	.tile {
		display: flex;
		flex-direction: column;
		gap: 0.1rem;
		padding: 0.75rem 0.85rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.tile-label {
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.tile-value {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 700;
		line-height: 1.15;
		color: var(--heading);
	}

	.tile-sub {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.medals {
		display: flex;
		gap: 0.6rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink);
	}

	.medals > span {
		display: inline-flex;
		align-items: center;
		gap: 0.2rem;
	}

	.note {
		margin: 1rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.5;
	}

	.facts {
		display: grid;
		gap: 0.4rem;
		margin: 1rem 0 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
		color: var(--ink);
	}

	.facts li {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
	}

	.facts :global(.icon) {
		margin-top: 0.1em;
		color: var(--accent-ink);
	}

	.topics {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.6rem 1rem;
		margin: 1.2rem 0 0;
	}

	.topics h3,
	.section {
		margin: 0 0 0.4rem;
		font-family: inherit;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.section {
		margin-top: 1.4rem;
	}

	.topics ul {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.3rem;
		font-size: var(--step--1);
	}

	.topics li {
		display: flex;
		justify-content: space-between;
		gap: 0.5rem;
	}

	.topics strong {
		color: var(--heading);
	}

	.topics strong.good {
		color: var(--right);
	}

	/* One row per sub-level or type: name, a thin bar, the count. */
	.bars {
		display: grid;
		gap: 0.45rem;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
	}

	.bars li {
		display: grid;
		grid-template-columns: 3rem 1fr 4.5rem;
		align-items: center;
		gap: 0.6rem;
	}

	.bars.types li {
		grid-template-columns: 8.5rem 1fr 4.5rem;
	}

	.bar-name small {
		display: block;
		font-weight: 600;
		font-size: 0.85em;
		color: var(--ink-muted);
	}

	.bar-name {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		font-weight: 700;
		color: var(--ink);
		white-space: nowrap;
	}

	.bar {
		height: 0.45rem;
		border-radius: 999px;
		background: var(--paper-high);
		overflow: hidden;
	}

	.bar > span {
		display: block;
		width: var(--p);
		height: 100%;
		border-radius: 999px;
		background: var(--navy);
	}

	.bar-num {
		text-align: right;
		color: var(--ink-muted);
		white-space: nowrap;
	}

	.bars li.current .bar-name,
	.bars li.current .bar-num {
		color: var(--accent-ink);
	}

	.bars li.current .bar > span {
		background: var(--accent);
	}

	.bars li.complete .bar > span {
		background: var(--right);
	}

	.close-btn {
		display: block;
		width: 100%;
		padding: 0.8rem 1rem;
		border: 0;
		border-radius: 999px;
		background: var(--heading);
		color: var(--surface);
		font: inherit;
		font-weight: 800;
		cursor: pointer;
	}

	.close-btn:hover {
		background: var(--accent-ink);
	}

</style>
