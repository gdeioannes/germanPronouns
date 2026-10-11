<script lang="ts">
	// The whole bank as a table, with filters by vibe, a tally of how many Ja
	// and Nein answers feed each persona, length checks against the limits the
	// test enforces, a speak button per question, and a sample share text.
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import {
		JA_NEIN_PATH,
		isPair,
		JA_NEIN_QUESTIONS,
		PERSONAS,
		ROUND_LENGTH,
		scoreJaNein,
		seenJaNein,
		shareText,
		type Vibe
	} from '$lib/domain/janein';
	import { absoluteUrl } from '$lib/seo';

	const VIBES = Object.keys(PERSONAS) as Vibe[];
	const MAX_DE = 48;

	let filter = $state<Vibe | 'all'>('all');
	let query = $state('');
	const seen = seenJaNein();

	const rows = $derived(
		JA_NEIN_QUESTIONS.map((q, i) => ({ ...q, n: i + 1, seen: seen.has(q.de) })).filter(
			(q) =>
				(filter === 'all' || q.ja === filter || q.nein === filter) &&
				(!query || `${q.de} ${q.en}`.toLowerCase().includes(query.toLowerCase()))
		)
	);

	const tally = $derived(
		VIBES.map((v) => ({
			vibe: v,
			ja: JA_NEIN_QUESTIONS.filter((q) => q.ja === v).length,
			nein: JA_NEIN_QUESTIONS.filter((q) => q.nein === v).length
		}))
	);

	/** A sample share: the first ten questions, alternating answers. */
	const sample = $derived(
		shareText(
			scoreJaNein(
				JA_NEIN_QUESTIONS.slice(0, ROUND_LENGTH),
				Array.from({ length: ROUND_LENGTH }, (_, i) => (i % 3 === 1 ? 'nein' : 'ja'))
			),
			absoluteUrl(JA_NEIN_PATH)
		)
	);

	function clearSeen() {
		try {
			localStorage.removeItem('janein_seen');
			localStorage.removeItem('janein_last');
			localStorage.removeItem('janein_first_deal');
		} catch {
			/* nothing to clear */
		}
		location.reload();
	}
</script>

<main class="review">
	<header>
		<h1>Ja oder Nein? · the bank</h1>
		<p>
			{JA_NEIN_QUESTIONS.length} questions ({JA_NEIN_QUESTIONS.filter(isPair).length} this-or-that), {ROUND_LENGTH} a round, {Math.floor(JA_NEIN_QUESTIONS.length / ROUND_LENGTH)} rounds before
			anything repeats. <a href={JA_NEIN_PATH}>Play it</a> · click any question to play a round that starts with it ·
			<button type="button" class="link" onclick={clearSeen}>forget what this device has seen</button>
		</p>
	</header>

	<section class="personas">
		{#each tally as t (t.vibe)}
			{@const p = PERSONAS[t.vibe]}
			<button type="button" class="persona" class:on={filter === t.vibe} onclick={() => (filter = filter === t.vibe ? 'all' : t.vibe)}>
				<span class="emoji">{p.emoji}</span>
				<strong lang="de">{p.title}</strong>
				<span class="counts tnum">Ja feeds it {t.ja}× · Nein feeds it {t.nein}×</span>
				<small>{p.line}</small>
				<small>Word: <span lang="de">{p.word.de}</span>, {p.word.en}</small>
			</button>
		{/each}
	</section>

	<div class="tools">
		<input type="search" placeholder="Search German or English" bind:value={query} />
		<span class="tnum">{rows.length} shown</span>
	</div>

	<table>
		<thead>
			<tr>
				<th>#</th>
				<th>German</th>
				<th>English</th>
				<th>Share line</th>
				<th>Ja / right →</th>
				<th>Nein / left →</th>
				<th>Seen</th>
			</tr>
		</thead>
		<tbody>
			{#each rows as q (q.de)}
				<tr class:seen={q.seen}>
					<td class="tnum">{q.n}</td>
					<td lang="de" class="de">
						<a href="{JA_NEIN_PATH}?q={q.n}" title="Play a round starting with this one">{q.de}</a>
						<SpeakButton text={q.de} locale="de-DE" />
						{#if q.de.length > MAX_DE}<span class="bad">{q.de.length} chars, max {MAX_DE}</span>{/if}
					</td>
					<td>{q.en}</td>
					<td>
						{#if isPair(q)}
							<span class="opt-l">← {q.left.de}</span> · <span class="opt-r">{q.right.de} →</span>
						{:else}
							✅ / ❌ {q.de}
						{/if}
					</td>
					<td><span class="vibe" data-vibe={q.ja}>{PERSONAS[q.ja].emoji} {PERSONAS[q.ja].title}</span></td>
					<td><span class="vibe" data-vibe={q.nein}>{PERSONAS[q.nein].emoji} {PERSONAS[q.nein].title}</span></td>
					<td>{q.seen ? '✓' : ''}</td>
				</tr>
			{/each}
		</tbody>
	</table>

	<section class="sample">
		<h2>Sample share text</h2>
		<pre>{sample}</pre>
	</section>
</main>

<style>
	.review {
		max-width: 80rem;
		margin: 0 auto;
		padding: 1.5rem 1rem 4rem;
	}

	h1 {
		margin: 0;
	}

	header p {
		color: var(--ink-muted);
	}

	.link {
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		text-decoration: underline;
		cursor: pointer;
	}

	.personas {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(14rem, 1fr));
		gap: 0.6rem;
		margin: 1rem 0;
	}

	.persona {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
		padding: 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius);
		background: var(--surface);
		font: inherit;
		text-align: left;
		cursor: pointer;
	}

	.persona.on {
		border-color: var(--accent);
		box-shadow: 0 0 0 2px var(--accent-soft);
	}

	.persona .emoji {
		font-size: 1.6rem;
	}

	.persona small {
		color: var(--ink-muted);
	}

	.tools {
		display: flex;
		align-items: center;
		gap: 0.8rem;
		margin: 0.8rem 0;
	}

	.tools input {
		flex: 1;
		max-width: 24rem;
		padding: 0.5rem 0.7rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		font: inherit;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		font-size: var(--step--1);
	}

	th,
	td {
		padding: 0.45rem 0.5rem;
		border-bottom: 1px solid var(--line);
		text-align: left;
		vertical-align: top;
	}

	th {
		position: sticky;
		top: 0;
		background: var(--surface);
	}

	.de {
		font-weight: 600;
		color: var(--heading);
	}

	.de a {
		color: inherit;
		text-decoration: none;
	}

	.de a:hover {
		color: var(--accent-ink);
		text-decoration: underline;
	}

	tr.seen td {
		background: var(--right-bg);
	}

	.bad {
		display: inline-block;
		margin-left: 0.4rem;
		padding: 0 0.4rem;
		border-radius: 999px;
		background: var(--wrong-bg);
		color: var(--wrong);
		font-weight: 600;
	}

	.vibe {
		white-space: nowrap;
	}

	.vibe[data-vibe='nacht'] {
		color: #4c3fa3;
	}
	.vibe[data-vibe='ordnung'] {
		color: var(--navy);
	}
	.vibe[data-vibe='gemuetlich'] {
		color: var(--ochre-ink);
	}
	.vibe[data-vibe='wild'] {
		color: var(--accent-ink);
	}
	.vibe[data-vibe='natur'] {
		color: var(--forest);
	}

	.opt-l {
		color: #c2410c;
		font-weight: 600;
	}

	.opt-r {
		color: #3730a3;
		font-weight: 600;
	}

	.sample pre {
		padding: 0.8rem 1rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font: inherit;
		white-space: pre-wrap;
	}
</style>
