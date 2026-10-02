<script lang="ts">
	// Readable screenplay view of an episode JSON, for reviewing the script
	// without wading through raw JSON. Dev-only, like the rest of the bible.
	import './bible.css';
	import { img } from './data';
	import ep from '$content/stories/ep1_empty_room.json';

	type AnyBeat = Record<string, unknown> & { id: string; type: string };

	// Shipped episode assets are served from static/: story/ep1_x → /img/story/ep1_x.webp.
	const sceneImg = (key: string) => `/${key.replace('story/', 'img/story/')}.webp`;
	const sceneAudio = (key: string) => {
		const base = key.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');
		const pooled = key.includes('{pool:') ? '_0' : '';
		return `/audio/story/${base}${pooled}.mp3`;
	};

	const isLead = (id: string) => (ep.hub.leads as string[]).includes(id);
	const checksAfter = (chapterId: string) => ep.microChecks.filter((m) => m.after === chapterId);
	const seq = (s: unknown) => (Array.isArray(s) ? s.join(' · ') : String(s));

	// --- At-a-glance stats, computed from the script itself. -----------------
	// Seconds per beat: a narrative panel reads in ~20s (with audio); one
	// question ~15s; a cloze/bigText blank ~12s; dialing/sorting ~5s per item
	// plus listening. Micro-checks ~15s. Matches the Step-2 planning budget.
	function beatStats(beat: AnyBeat) {
		let questions = 0;
		let seconds = 0;
		if (beat.type === 'narrative') return { questions, seconds: 20 };
		if (beat.type === 'quiz') {
			const q = (beat.quiz ?? beat) as AnyBeat;
			if (Array.isArray(q.blanks)) {
				questions += q.blanks.length;
				seconds += q.blanks.length * 12;
			}
			if (Array.isArray(beat.questions)) {
				questions += beat.questions.length;
				seconds += beat.questions.length * 15 + 20; // + listening once
			}
			if (beat.question ?? q.question) {
				questions += 1;
				seconds += 15;
			}
			if (beat.sequence) {
				questions += 1;
				const n = Array.isArray(beat.sequence) ? beat.sequence.length : 9;
				seconds += n * 5 + (beat.audio ? 20 : 0);
			}
		}
		return { questions, seconds: Math.max(seconds, 15) };
	}
	const rows = ep.chapters.map((ch) => {
		const beats = ch.beats as AnyBeat[];
		const narr = beats.filter((b) => b.type === 'narrative').length;
		const quizzes = beats.filter((b) => b.type === 'quiz');
		const kinds = [...new Set(quizzes.map((b) => `${b.kind}${b.layout ? `/${b.layout}` : ''}`))];
		let questions = 0;
		let seconds = 0;
		for (const b of beats) {
			const s = beatStats(b);
			questions += s.questions;
			seconds += s.seconds;
		}
		const micro = checksAfter(ch.id).length;
		questions += micro;
		seconds += micro * 15;
		return { ch, narr, quizBeats: quizzes.length, kinds, questions, minutes: seconds / 60 };
	});
	const total = {
		panels: rows.reduce((a, r) => a + r.narr, 0),
		quizBeats: rows.reduce((a, r) => a + r.quizBeats, 0),
		questions: rows.reduce((a, r) => a + r.questions, 0),
		minutes: rows.reduce((a, r) => a + r.minutes, 0),
		critical: ep.chapters.flatMap((c) => c.beats as AnyBeat[]).filter((b) => b.critical).length
	};
	const fmtMin = (m: number) => `${Math.round(m * 10) / 10} min`;
</script>

<main class="bible">
	<p class="crumbs"><a href="/dev/story-bible">← Story Bible</a></p>
	<header class="hero">
		<img class="hero-img" src={img('room_ref_close')} alt="The torn note" />
		<div class="hero-text">
			<p class="eyebrow">Episode script · {ep.course} · {ep.level} (half {ep.half})</p>
			<h1>{ep.title}</h1>
			<p class="lede">
				{ep.tagline} — credibility {ep.credibility}, play floor {ep.minutesFloor} min. Source:
				<code>assets/content/stories/{ep.id}.json</code>.
			</p>
		</div>
	</header>

	<section>
		<h2>At a glance</h2>
		<div class="stats">
			<div class="stat"><strong>{rows.length}</strong><span>chapters</span></div>
			<div class="stat"><strong>{total.panels}</strong><span>story panels</span></div>
			<div class="stat"><strong>{total.quizBeats}</strong><span>exercise beats</span></div>
			<div class="stat"><strong>{total.questions}</strong><span>questions / inputs</span></div>
			<div class="stat"><strong>{total.critical}</strong><span>credibility moments</span></div>
			<div class="stat"><strong>{fmtMin(total.minutes)}</strong><span>est. play (no errors)</span></div>
		</div>
		<div class="table-wrap">
			<table>
				<thead>
					<tr><th>Chapter</th><th>Panels</th><th>Exercises</th><th>Questions</th><th>Kinds</th><th>Est. time</th></tr>
				</thead>
				<tbody>
					{#each rows as r (r.ch.id)}
						<tr>
							<td>{r.ch.title}{isLead(r.ch.id) ? ' *' : ''}</td>
							<td>{r.narr}</td>
							<td>{r.quizBeats}</td>
							<td>{r.questions}</td>
							<td class="kinds">{r.kinds.join(', ') || '—'}</td>
							<td>{fmtMin(r.minutes)}</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
		<p class="intro" style="margin-top:0.75rem">
			* hub lead, playable in any order. Question counts include Maya's micro-texts after the
			chapter. Errors add time (audio replays, chapter retries), so real play sits above the
			estimate — the {ep.minutesFloor}-minute floor holds.
		</p>
	</section>

	<section>
		<h2>Randomization pools</h2>
		<p class="intro">
			One variant per pool is drawn at episode start (and re-drawn on restart), so answers can't be
			memorized. Every <code>{'{pool:…}'}</code> below splices the drawn value.
		</p>
		<div class="pools">
			{#each Object.entries(ep.pools) as [name, values] (name)}
				<div class="pool"><code>{name}</code><span>{(values as string[]).join(' · ')}</span></div>
			{/each}
		</div>
	</section>

	{#each ep.chapters as ch (ch.id)}
		<section>
			<h2>
				{ch.title}
				{#if isLead(ch.id)}<span class="badge lead">hub lead{'clue' in ch ? ` · clue ${ch.clue}` : ''}</span>{/if}
				{#if ep.hub.unlocks === ch.id}<span class="badge locked">unlocks with clues {ep.hub.requiredClues.join('')}</span>{/if}
			</h2>
			{#if Array.isArray((ch as unknown as AnyBeat).studyLinks)}
				<p class="study">Optional training: {((ch as unknown as AnyBeat).studyLinks as string[]).map((s) => s.replace('quest_a1_1_', '')).join(' · ')}</p>
			{/if}
			{#each ch.beats as b (b.id)}
				{@const beat = b as AnyBeat}
				{@const narr =
					beat.type === 'narrative' && !(beat.audio as string | undefined)
						? `/audio/story/ep1_narr_${beat.id}${(beat.text as string).includes('{pool') ? '_0' : ''}.mp3`
						: null}
				<div class="beat" class:critical={beat.critical === true} class:cluecard={beat.type === 'clue'}>
					<div class="beat-head">
						<span class="beat-kind">{beat.type === 'quiz' ? `quiz · ${beat.kind}${beat.layout ? ` (${beat.layout})` : ''}` : beat.type === 'clue' ? 'clue card → notebook' : beat.type}</span>
						{#if beat.critical}<span class="beat-crit">critical — costs credibility</span>{/if}
					</div>
					{#if beat.image || beat.audio || narr}
						<div class="beat-media">
							{#if beat.image}<img class="beat-img" src={sceneImg(beat.image as string)} alt={beat.id} loading="lazy" />{/if}
							{#if beat.audio || narr}
								<div class="beat-audio">
									<audio controls preload="none" src={beat.audio ? sceneAudio(beat.audio as string) : narr}></audio>
									<code class="beat-asset">{beat.audio ?? `narration`}{`${beat.audio ?? beat.text}`.includes('{pool') ? ' (variant 0)' : ''}</code>
								</div>
							{/if}
						</div>
					{/if}
					{#if beat.type === 'narrative'}
						{#if beat.transcript}<p class="transcript">▸ audio (German): <em>{beat.transcript}</em></p>{/if}
						<p class="maya-line">MAYA: “{beat.text}”</p>
					{:else if beat.type === 'clue'}
						{@const entries = beat.entries as { de: string; en: string }[]}
						{#if beat.intro}<p class="maya-line">MAYA: “{beat.intro}”</p>{/if}
						<ul class="entries">
							{#each entries as e (e.de)}
								<li><strong>{e.de}</strong> — {e.en}</li>
							{/each}
						</ul>
					{:else}
						{#if beat.transcript}<p class="transcript">▸ audio says: <em>{beat.transcript}</em></p>{/if}
						{#if beat.passage}<p class="passage">{beat.passage}</p>{/if}
						{#if beat.prompt}<p class="prompt">{beat.prompt}</p>{/if}
						{#if beat.question}<p class="prompt">{beat.question}</p>{/if}
						{#if beat.sequence}<p class="answer">✔ order: {seq(beat.sequence)}</p>{/if}
						{#if Array.isArray(beat.blanks)}
							<ul class="options">
								{#each beat.blanks as bl}
									<li>({bl.n}) {bl.options.join(' / ')} → <strong>{bl.answer}</strong></li>
								{/each}
							</ul>
						{/if}
						{#if Array.isArray(beat.options) && typeof beat.options[0] === 'string'}
							<p class="options">tiles: {beat.options.join(' · ')}</p>
						{:else if Array.isArray(beat.options)}
							<ul class="options">
								{#each beat.options as o}
									<li class:right={o.correct}>{o.correct ? '✔' : '✘'} {o.text}</li>
								{/each}
							</ul>
						{/if}
						{#if Array.isArray(beat.questions)}
							{#each beat.questions as q}
								<p class="prompt">{q.question}</p>
								<ul class="options">
									{#each q.options as o}
										<li class:right={o.correct}>{o.correct ? '✔' : '✘'} {o.text}</li>
									{/each}
								</ul>
							{/each}
						{/if}
						{#if beat.quiz}
							{@const q = beat.quiz as AnyBeat}
							{#if q.passage}<p class="passage">{q.passage}</p>{/if}
							{#if Array.isArray(q.blanks)}
								<ul class="options">
									{#each q.blanks as bl}
										<li>({bl.n}) {bl.options.join(' / ')} → <strong>{bl.answer}</strong></li>
									{/each}
								</ul>
							{/if}
						{/if}
					{/if}
				</div>
			{/each}
			{#each checksAfter(ch.id) as m}
				<div class="beat micro">
					<div class="beat-head"><span class="beat-kind">micro-text from Maya</span></div>
					<p class="maya-line">MAYA (text): “{m.text}”</p>
					<p class="prompt">{m.question}</p>
					<ul class="options">
						{#each m.options as o}
							<li class:right={o.correct}>{o.correct ? '✔' : '✘'} {o.text}</li>
						{/each}
					</ul>
				</div>
			{/each}
		</section>
	{/each}

	<footer>
		<p>
			Hub after <code>{ep.hub.afterChapter}</code>: leads in any order, all clues required for the
			finale. Asset keys (🖼/🔊) are produced in Steps 3–4.
		</p>
	</footer>
</main>

<style>
	.stats {
		display: flex;
		flex-wrap: wrap;
		gap: 0.75rem;
		margin-bottom: 1.25rem;
	}
	.stat {
		display: grid;
		gap: 0.1rem;
		justify-items: center;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		padding: 0.75rem 1.1rem;
		min-width: 7rem;
	}
	.stat strong {
		font-size: var(--step-2);
		color: var(--heading);
		font-variant-numeric: tabular-nums;
	}
	.stat span {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.table-wrap {
		overflow-x: auto;
	}
	table {
		border-collapse: collapse;
		font-size: var(--step--1);
		min-width: 40rem;
	}
	th,
	td {
		text-align: left;
		padding: 0.45rem 0.9rem 0.45rem 0;
		border-bottom: 1px solid var(--line);
		font-variant-numeric: tabular-nums;
	}
	th {
		color: var(--heading);
	}
	td.kinds {
		color: var(--ink-muted);
	}
	.pools {
		display: grid;
		gap: 0.5rem;
		max-width: var(--measure);
	}
	.pool {
		display: grid;
		grid-template-columns: 11rem 1fr;
		gap: 1rem;
		font-size: var(--step--1);
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		padding: 0.5rem 0.75rem;
	}
	.badge {
		font-size: 0.72rem;
		text-transform: uppercase;
		letter-spacing: 0.06em;
		border-radius: 999px;
		padding: 0.2rem 0.6rem;
		margin-left: 0.6rem;
		vertical-align: middle;
	}
	.badge.lead {
		background: var(--accent-soft);
		color: var(--accent);
	}
	.badge.locked {
		background: var(--paper-high);
		color: var(--ink-muted);
	}
	.beat {
		background: var(--surface);
		border: 1px solid var(--line);
		border-left: 3px solid var(--line-strong);
		border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
		padding: 0.75rem 1rem;
		margin-bottom: 0.75rem;
		max-width: 56rem;
	}
	.beat.critical {
		border-left-color: var(--wrong);
	}
	.beat.cluecard {
		border-left-color: var(--forest);
		background: #f2f6f1;
	}
	ul.entries {
		margin: 0.25rem 0;
		padding-left: 1.2rem;
		font-size: var(--step--1);
	}
	.study {
		font-size: var(--step--1);
		color: var(--ink-muted);
		margin: -0.5rem 0 0.75rem;
	}
	.beat.micro {
		border-left-color: var(--ochre);
		background: #fdfaf2;
	}
	.beat-head {
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem 0.9rem;
		align-items: baseline;
		margin-bottom: 0.4rem;
		font-size: var(--step--1);
	}
	.beat-kind {
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		font-size: 0.72rem;
		color: var(--heading);
	}
	.beat-crit {
		color: var(--wrong);
		font-size: 0.72rem;
		font-weight: 600;
	}
	.beat-asset {
		color: var(--ink-muted);
		font-size: 0.75rem;
	}
	.beat-media {
		display: flex;
		flex-wrap: wrap;
		gap: 0.75rem;
		align-items: flex-start;
		margin: 0.4rem 0 0.6rem;
	}
	.beat-img {
		max-width: 20rem;
		width: 100%;
		border-radius: var(--radius-sm);
		border: 1px solid var(--line);
		display: block;
	}
	.beat-audio {
		display: grid;
		gap: 0.25rem;
	}
	.beat-audio audio {
		width: 16rem;
		max-width: 100%;
	}
	.maya-line {
		margin: 0;
		font-style: italic;
	}
	.transcript,
	.passage,
	.prompt {
		margin: 0.25rem 0;
	}
	.passage {
		white-space: pre-line;
		background: var(--surface-alt);
		border-radius: var(--radius-sm);
		padding: 0.5rem 0.75rem;
	}
	.prompt {
		font-weight: 600;
	}
	.answer {
		color: var(--right);
		margin: 0.25rem 0;
	}
	ul.options {
		margin: 0.25rem 0 0.25rem;
		padding-left: 1.2rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	ul.options li.right {
		color: var(--right);
		font-weight: 600;
	}
	p.options {
		font-size: var(--step--1);
		color: var(--ink-muted);
		margin: 0.25rem 0;
	}
</style>
