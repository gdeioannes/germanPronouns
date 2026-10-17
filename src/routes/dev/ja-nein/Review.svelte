<script lang="ts">
	// The whole bank as shelves: pick a category, see its five personas and
	// how often each is fed, then every round with its eight questions, a
	// speak button per question, a link that plays that round, and a sample
	// share text. Length checks mirror tool/check-janein.mjs.
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import { JA_NEIN_PATH, isPair, shareText } from '$lib/domain/janein';
	import {
		ALL_QUESTIONS,
		JA_NEIN_CATEGORIES,
		personaOf,
		playedRounds,
		ROUND_LENGTH,
		ROUND_ORDER,
		scoreRound,
		shuffled
	} from '$lib/domain/janeinRounds';
	import { absoluteUrl } from '$lib/seo';

	const MAX_DE = 48;

	let catId = $state(JA_NEIN_CATEGORIES[0]?.id ?? '');
	let query = $state('');
	let vibe = $state<string | 'all'>('all');
	const played = new Set(playedRounds());

	const cat = $derived(JA_NEIN_CATEGORIES.find((c) => c.id === catId) ?? JA_NEIN_CATEGORIES[0]);
	const tally = $derived(
		cat.personas.map((p) => ({
			persona: p,
			ja: cat.rounds.flatMap((r) => r.questions).filter((q) => q.ja === p.id).length,
			nein: cat.rounds.flatMap((r) => r.questions).filter((q) => q.nein === p.id).length
		}))
	);
	const rounds = $derived(
		cat.rounds
			.map((r) => ({
				...r,
				shown: r.questions.filter(
					(q) =>
						(vibe === 'all' || q.ja === vibe || q.nein === vibe) &&
						(!query || `${q.de} ${q.en}`.toLowerCase().includes(query.toLowerCase()))
				)
			}))
			.filter((r) => r.shown.length)
	);

	/** A sample share: the category's first round, alternating answers. */
	const sample = $derived.by(() => {
		const r = cat.rounds[0];
		if (!r) return '';
		const qs = shuffled(r, () => 0.5);
		return shareText(
			scoreRound(
				r,
				qs,
				Array.from({ length: qs.length }, (_, i) => (i % 3 === 1 ? 'nein' : 'ja'))
			),
			absoluteUrl(JA_NEIN_PATH)
		);
	});

	function clearDevice() {
		try {
			localStorage.removeItem('janein_played');
			localStorage.removeItem('janein_personas');
		} catch {
			/* nothing to clear */
		}
		location.reload();
	}
</script>

<main class="review">
	<header>
		<h1>Ja oder Nein? · the shelves</h1>
		<p>
			{JA_NEIN_CATEGORIES.length} categories · {ROUND_ORDER.length} rounds of {ROUND_LENGTH} · {ALL_QUESTIONS.length} questions
			({ALL_QUESTIONS.filter(isPair).length} this-or-that). <a href={JA_NEIN_PATH}>Play the next round</a> ·
			<a href="{JA_NEIN_PATH}/personas">the persona shelf</a> ·
			<button type="button" class="link" onclick={clearDevice}>forget this device's rounds and personas</button>
		</p>
	</header>

	<nav class="cats" aria-label="Categories">
		{#each JA_NEIN_CATEGORIES as c (c.id)}
			<button type="button" class:on={c.id === cat.id} onclick={() => ((catId = c.id), (vibe = 'all'))}>
				{c.emoji} <span lang="de">{c.title}</span>
			</button>
		{/each}
	</nav>

	<section class="personas">
		{#each tally as t (t.persona.id)}
			{@const p = t.persona}
			<button type="button" class="persona" class:on={vibe === p.id} onclick={() => (vibe = vibe === p.id ? 'all' : p.id)}>
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
		<span class="tnum">{rounds.reduce((n, r) => n + r.shown.length, 0)} shown</span>
	</div>

	{#each rounds as r (r.key)}
		<section class="round">
			<h2>
				<a href="{JA_NEIN_PATH}?round={r.key}&go" title="Play this round">{r.title}</a>
				<small>{r.en} · {r.hook} {#if played.has(r.key)}· played{/if}</small>
			</h2>
			<table>
				<thead>
					<tr>
						<th>German</th>
						<th>English</th>
						<th>Ja / right →</th>
						<th>Nein / left →</th>
					</tr>
				</thead>
				<tbody>
					{#each r.shown as q (q.de)}
						<tr>
							<td lang="de" class="de">
								{#if isPair(q)}
									<span class="opt-l">← {q.left.de}</span> · <span class="opt-r">{q.right.de} →</span>
								{:else}
									{q.de}
								{/if}
								<SpeakButton text={q.de} locale="de-DE" />
								{#if q.de.length > MAX_DE}<span class="bad">{q.de.length} chars, max {MAX_DE}</span>{/if}
							</td>
							<td>{q.en}</td>
							<td><span class="vibe">{personaOf(cat, q.ja).emoji} {personaOf(cat, q.ja).title}</span></td>
							<td><span class="vibe">{personaOf(cat, q.nein).emoji} {personaOf(cat, q.nein).title}</span></td>
						</tr>
					{/each}
				</tbody>
			</table>
		</section>
	{/each}

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

	.cats {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin: 1rem 0;
	}

	.cats button {
		padding: 0.35rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		font: inherit;
		cursor: pointer;
	}

	.cats button.on {
		border-color: var(--accent);
		box-shadow: 0 0 0 2px var(--accent-soft);
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

	.round {
		margin: 1.5rem 0;
	}

	.round h2 {
		display: flex;
		flex-wrap: wrap;
		align-items: baseline;
		gap: 0.6rem;
		margin: 0 0 0.4rem;
		font-size: var(--step-1);
	}

	.round h2 small {
		font-size: var(--step--1);
		font-weight: 400;
		color: var(--ink-muted);
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

	.de {
		font-weight: 600;
		color: var(--heading);
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

	.opt-l {
		color: #c2410c;
	}

	.opt-r {
		color: #3730a3;
	}

	.sample pre {
		padding: 0.8rem 1rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font: inherit;
		white-space: pre-wrap;
	}
</style>
