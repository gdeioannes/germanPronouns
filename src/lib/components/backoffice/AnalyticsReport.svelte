<script lang="ts">
	// The back office's analytics report: Aptabase's CSV export, read in this
	// browser and counted in people (domain/analyticsReport). Nothing is
	// uploaded anywhere, and nothing is kept: the file is gone on reload.
	//
	// The notes at the foot are part of the report, not decoration: every
	// number here has a known weakness, and each note says what it is and what
	// is in place (or could be done) about it. The figures inside the notes are
	// worked out from the loaded file and the chosen dates.
	//
	// Charts: every one answers to the pointer and to the keyboard, and every
	// value a chart shows is also in a table on the page.
	import {
		buildReport,
		mergeExports,
		readExport,
		type AnalyticsEvent,
		type QuizRow,
		type SourceRow
	} from '$lib/domain/analyticsReport';
	import DayChart from './DayChart.svelte';
	import PathFlow from './PathFlow.svelte';

	let events = $state.raw<AnalyticsEvent[]>([]);
	let files = $state<string[]>([]);
	let error = $state('');
	let reading = $state(false);
	let from = $state('');
	let to = $state('');
	let includeOwn = $state(false);

	const firstDay = $derived(events[0]?.day ?? '');
	const lastDay = $derived(events.at(-1)?.day ?? '');
	const lastEvent = $derived(events.length ? new Date(events[events.length - 1].t) : null);

	async function pick(event: Event) {
		const input = event.currentTarget as HTMLInputElement;
		const picked = [...(input.files ?? [])];
		if (!picked.length) return;
		reading = true;
		error = '';
		try {
			const lists = await Promise.all(picked.map(async (f) => readExport(await f.text())));
			events = mergeExports(lists);
			files = picked.map((f) => f.name);
			from = events[0]?.day ?? '';
			to = events.at(-1)?.day ?? '';
			source = '';
			if (!events.length) error = 'The file has no events in it.';
		} catch (cause) {
			events = [];
			files = [];
			error = cause instanceof Error ? cause.message : 'Could not read that file.';
		} finally {
			reading = false;
			input.value = '';
		}
	}

	/** A day `back` days before the export's last day, not before its first. */
	function daysBefore(back: number): string {
		const day = new Date(Date.parse(lastDay + 'T00:00:00Z') - back * 86_400_000).toISOString().slice(0, 10);
		return day < firstDay ? firstDay : day;
	}

	function setRange(start: string, end = lastDay) {
		from = start;
		to = end;
	}

	/** One source's people only ('' = everyone). Set from the menu, or by a tap on the source chart. */
	let source = $state('');
	/** Everyone in the dates: the source chart and menu list every source even while one is picked. */
	const overall = $derived(events.length ? buildReport(events, { from, to, includeOwn }) : null);
	const report = $derived(
		overall && source ? buildReport(events, { from, to, includeOwn, source }) : overall
	);

	// -- the source chart --------------------------------------------------------
	const METRICS = [
		{ key: 'people', label: 'People' },
		{ key: 'downloaded', label: 'Downloaded' },
		{ key: 'started', label: 'Opened an exercise' },
		{ key: 'completed', label: 'Finished one' }
	] as const;
	type Metric = (typeof METRICS)[number]['key'];
	let metric = $state<Metric>('people');
	/** The biggest sources, in a fixed order (by people) whatever is being compared. */
	const sourceBars = $derived(overall?.sources.slice(0, 8) ?? []);
	/** People: the count. Anything else: the share of that source's people. */
	const sourceValue = (s: SourceRow) => (metric === 'people' ? s.people : s.people ? s[metric] / s.people : 0);
	const sourceMax = $derived(metric === 'people' ? Math.max(1, ...sourceBars.map((s) => s.people)) : 1);
	const sourceText = (s: SourceRow) =>
		metric === 'people' ? num(s.people) : `${pct(s[metric], s.people)} · ${s[metric]} of ${s.people}`;

	// -- the exercise chart ------------------------------------------------------
	// One hue, light to dark, for three ordered stages of the same people.
	const STAGE_COLORS = { finished: '#104281', answered: '#2a78d6', opened: '#86b6ef' };
	const stagesOf = (q: QuizRow) => [
		{ key: 'finished', label: 'Finished it', count: q.completed, color: STAGE_COLORS.finished },
		{ key: 'answered', label: 'Answered, then left', count: Math.max(0, q.answered - q.completed), color: STAGE_COLORS.answered },
		{ key: 'opened', label: 'Opened it, answered nothing', count: Math.max(0, q.started - q.answered), color: STAGE_COLORS.opened }
	];

	// -- one tooltip for the bar charts ------------------------------------------
	type Tip = { x: number; y: number; title: string; rows: { label: string; value: string; color?: string }[] };
	let tip = $state<Tip | null>(null);
	function showTip(event: PointerEvent | FocusEvent, title: string, rows: Tip['rows']) {
		const box = (event.currentTarget as HTMLElement).getBoundingClientRect();
		const pointer = 'clientX' in event && event.type !== 'focus';
		const x = pointer ? (event as PointerEvent).clientX : box.left + box.width / 2;
		tip = { x: Math.min(x, window.innerWidth - 250), y: box.bottom + 6, title, rows };
	}
	const sourceTip = (s: SourceRow) => [
		{ label: 'people', value: num(s.people) },
		{ label: 'downloaded a book', value: `${s.downloaded} (${pct(s.downloaded, s.people)})` },
		{ label: 'opened an exercise', value: `${s.started} (${pct(s.started, s.people)})` },
		{ label: 'finished one', value: `${s.completed} (${pct(s.completed, s.people)})` }
	];
	const quizTip = (q: QuizRow) => [
		...stagesOf(q).map((s) => ({ label: s.label.toLowerCase(), value: `${s.count} (${pct(s.count, q.started)})`, color: s.color })),
		{ label: 'median time to finish', value: time(q.seconds) },
		{ label: 'average score', value: q.score == null ? '–' : `${Math.round(q.score * 100)}%` }
	];

	const updateDay = $derived(report?.updateDay ?? null);
	const maxPeople = $derived(Math.max(1, ...(report?.days.map((d) => d.people) ?? [])));

	const pct = (a: number, b: number) => (b ? `${Math.round((100 * a) / b)}%` : '–');
	const width = (a: number, b: number) => `${b ? Math.round((100 * a) / b) : 0}%`;
	const num = (x: number) => x.toLocaleString('en');
	const time = (s: number | null) =>
		s == null ? '–' : s < 60 ? `${s} s` : `${Math.floor(s / 60)} min ${String(s % 60).padStart(2, '0')}`;
	const span = (m: number) => (m < 60 ? `${m} min` : `${(m / 60).toFixed(1)} h`);
	const shortQuiz = (id: string) => id.replace(/^quest_/, '');
	/** Under this many people a percentage is one or two people's doing. */
	const FEW = 20;

	const presets = $derived(
		events.length
			? [
					{ label: 'Everything', from: firstDay, to: lastDay },
					{ label: 'Last 7 days', from: daysBefore(6), to: lastDay },
					{ label: 'Last 14 days', from: daysBefore(13), to: lastDay },
					{ label: 'Last 30 days', from: daysBefore(29), to: lastDay },
					...(updateDay ? [{ label: 'Since the tracking update', from: updateDay, to: lastDay }] : [])
				]
			: []
	);
	/** The day (of those with 10+ people) on which one person sent the largest share of the events. */
	const worstDay = $derived(
		report?.days
			.filter((d) => d.people >= 10 && d.events)
			.reduce<(typeof report.days)[number] | null>((w, d) => (!w || d.busiest / d.events > w.busiest / w.events ? d : w), null) ?? null
	);
	/** The first quick range that matches the dates (two can be the same days in a short file). */
	const activePreset = $derived(presets.find((p) => report?.from === p.from && report?.to === p.to));
	const quizRows = $derived(report?.quizzes.filter((q) => q.started >= 3).slice(0, 30) ?? []);
</script>

<section class="load" aria-labelledby="load-head">
	<h2 id="load-head">The export</h2>
	<p class="muted">
		Export the events from Aptabase as CSV (one file per month) and pick it here, or several months together. The file is read in this browser only: nothing is uploaded, and nothing is kept after a reload.
	</p>
	<label class="file">
		<input type="file" accept=".csv,text/csv" multiple onchange={pick} />
		<span class="btn">{events.length ? 'Choose other files' : 'Choose the CSV export'}</span>
	</label>
	{#if reading}<p class="muted" role="status">Reading…</p>{/if}
	{#if error}<p class="err" role="alert">{error}</p>{/if}
	{#if events.length}
		<p class="muted" role="status">
			{files.join(', ')} · {num(events.length)} events · {firstDay} to {lastDay}{#if lastEvent}
				· last event {lastEvent.toISOString().slice(0, 16).replace('T', ' ')} UTC{/if}
		</p>
	{/if}
</section>

{#if report}
	<section class="range" aria-labelledby="range-head">
		<h2 id="range-head">Dates and source</h2>
		<div class="range-row">
			<label>From <input type="date" bind:value={from} min={firstDay} max={to || lastDay} /></label>
			<label>To <input type="date" bind:value={to} min={from || firstDay} max={lastDay} /></label>
			<div class="presets" role="group" aria-label="Quick ranges">
				{#each presets as p (p.label)}
					<button type="button" aria-pressed={p === activePreset} onclick={() => setRange(p.from, p.to)}>
						{p.label}
					</button>
				{/each}
			</div>
		</div>
		<label class="from">
			Came from
			<select bind:value={source}>
				<option value="">Everyone</option>
				{#each overall?.sources.slice(0, 25) ?? [] as s (s.source)}
					<option value={s.source}>{s.source} ({s.people})</option>
				{/each}
			</select>
		</label>
		<label class="check">
			<input type="checkbox" bind:checked={includeOwn} /> Count my own visits too
			<span class="muted">({report.ownLeftOut} visitor-days left out now)</span>
		</label>
	</section>

	{#if !report.total}
		<p class="muted">No visitors between these dates.</p>
	{:else}
		{#if report.total < FEW}
			<p class="warn" role="note">
				Only {report.total} people in this range: read the counts, not the percentages.
			</p>
		{/if}

		<div class="tiles">
			<div class="tile"><b class="tnum">{num(report.total)}</b><span>people (one visitor on one day)</span></div>
			<div class="tile"><b class="tnum">{pct(report.funnel[1].count, report.total)}</b><span>downloaded a book</span></div>
			<div class="tile"><b class="tnum">{pct(report.funnel[3].count, report.total)}</b><span>opened an exercise</span></div>
			<div class="tile"><b class="tnum">{pct(report.funnel[5].count, report.total)}</b><span>finished an exercise</span></div>
			<div class="tile"><b class="tnum">{pct(report.funnel[8].count, report.total)}</b><span>had been here on an earlier day</span></div>
			<div class="tile"><b class="tnum">{num(report.events)}</b><span>events from them</span></div>
		</div>

		<section aria-labelledby="did-head">
			<h2 id="did-head">What people did</h2>
			<p class="muted">Each row is a share of all {num(report.total)} people, not a step that needs the row above it.</p>
			<ul class="funnel">
				{#each report.funnel as f (f.label)}
					<li>
						<span>{f.label}</span>
						<span class="track"><span style:width={width(f.count, report.total)}></span></span>
						<span class="tnum end">{num(f.count)}</span>
						<span class="tnum end muted">{pct(f.count, report.total)}</span>
					</li>
				{/each}
			</ul>
		</section>

		<section aria-labelledby="path-head">
			<h2 id="path-head">Where people go</h2>
			<p class="muted">
				The visit in order: where each person landed, the first thing they did, and how their day ended. A band is as
				thick as the number of people who went that way. Everyone is in exactly one block per column.
			</p>
			<PathFlow people={report.people} />
		</section>

		<section aria-labelledby="day-head">
			<h2 id="day-head">Day by day</h2>
			<p class="muted">
				People per day{source ? ` who came from ${source}` : ''}, and what they did. Days are UTC. In the table,
				“busiest person” is the most events one visitor sent that day, and their share of the day.
			</p>
			<DayChart days={report.days} onrange={(a, b) => setRange(a, b)} />
			<div class="table-wrap">
				<table>
					<thead>
						<tr>
							<th scope="col">Day</th>
							<th scope="col" class="end">People</th>
							<th scope="col"><span class="sr-only">People, as a bar</span></th>
							<th scope="col" class="end">Returning</th>
							<th scope="col" class="end">Downloaded</th>
							<th scope="col" class="end">Opened an exercise</th>
							<th scope="col" class="end">Finished one</th>
							<th scope="col" class="end">Events</th>
							<th scope="col" class="end">Busiest person</th>
						</tr>
					</thead>
					<tbody>
						{#each report.days as d (d.day)}
							<tr>
								<th scope="row" class="tnum">{d.day}</th>
								<td class="tnum end">{d.people}</td>
								<td><span class="track day"><span style:width={width(d.people, maxPeople)}></span></span></td>
								<td class="tnum end">{d.returning}</td>
								<td class="tnum end">{d.downloaded}</td>
								<td class="tnum end">{d.started}</td>
								<td class="tnum end">{d.completed}</td>
								<td class="tnum end">{num(d.events)}</td>
								<td class="tnum end">{d.events ? `${d.busiest} (${pct(d.busiest, d.events)})` : '–'}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</section>

		<section aria-labelledby="src-head">
			<h2 id="src-head">Where they came from</h2>
			<p class="muted">
				By the first known source of the day. Pick what to compare; tap a source to see the whole report for its
				people only.
			</p>
			<div class="seg" role="group" aria-label="Compare sources by">
				{#each METRICS as m (m.key)}
					<button type="button" aria-pressed={metric === m.key} onclick={() => (metric = m.key)}>{m.label}</button>
				{/each}
			</div>
			<ul class="bars">
				{#each sourceBars as s (s.source)}
					<li>
						<button
							type="button"
							class="bar-row"
							aria-pressed={source === s.source}
							onclick={() => (source = source === s.source ? '' : s.source)}
							onpointermove={(e) => showTip(e, s.source, sourceTip(s))}
							onpointerleave={() => (tip = null)}
							onfocus={(e) => showTip(e, s.source, sourceTip(s))}
							onblur={() => (tip = null)}
						>
							<span class="bar-name">{s.source}</span>
							<span class="bar-track"><span class="bar-fill" class:few={metric !== 'people' && s.people < FEW} style:width={width(sourceValue(s), sourceMax)}></span></span>
							<span class="bar-value tnum">{sourceText(s)}</span>
						</button>
					</li>
				{/each}
			</ul>
			{#if metric !== 'people'}
				<p class="muted small">
					Shares are of each source's own people. Pale bars are sources with fewer than {FEW} people, where one
					person moves the share by several points.
				</p>
			{/if}
			{#if source}
				<p class="muted small" role="status">
					The report now shows only people from <strong>{source}</strong>.
					<button type="button" class="link" onclick={() => (source = '')}>Show everyone</button>
				</p>
			{/if}
			<div class="table-wrap">
				<table>
					<thead>
						<tr>
							<th scope="col">Came from</th>
							<th scope="col" class="end">People</th>
							<th scope="col" class="end">Downloaded</th>
							<th scope="col" class="end">Opened an exercise</th>
							<th scope="col" class="end">Finished one</th>
						</tr>
					</thead>
					<tbody>
						{#each (overall ?? report).sources.slice(0, 15) as s (s.source)}
							<tr>
								<th scope="row">{s.source}</th>
								<td class="tnum end">{s.people}</td>
								<td class="tnum end">{s.downloaded} <small>{pct(s.downloaded, s.people)}</small></td>
								<td class="tnum end">{s.started} <small>{pct(s.started, s.people)}</small></td>
								<td class="tnum end">{s.completed} <small>{pct(s.completed, s.people)}</small></td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</section>

		<section aria-labelledby="quiz-head">
			<h2 id="quiz-head">Exercises: where people stop</h2>
			<p class="muted">
				People, not runs; exercises opened by at least 3 people. Time and score exist only for runs finished after
				the tracking update{updateDay ? ` (${updateDay})` : ''}.
			</p>
			{#if quizRows.length}
				<ul class="key-row" aria-label="What the bar's parts mean">
					{#each stagesOf(quizRows[0]) as s (s.key)}
						<li><span class="swatch" style:background={s.color}></span>{s.label}</li>
					{/each}
				</ul>
				<ul class="bars">
					{#each quizRows.slice(0, 12) as q (q.quiz)}
						<li>
							<!-- svelte-ignore a11y_no_noninteractive_tabindex -->
							<div
								class="bar-row"
								role="group"
								tabindex="0"
								aria-label="{shortQuiz(q.quiz)}: {q.completed} of {q.started} finished"
								onpointermove={(e) => showTip(e, shortQuiz(q.quiz), quizTip(q))}
								onpointerleave={() => (tip = null)}
								onfocus={(e) => showTip(e, shortQuiz(q.quiz), quizTip(q))}
								onblur={() => (tip = null)}
							>
								<span class="bar-name">{shortQuiz(q.quiz)}</span>
								<span class="bar-track stack" style:width={width(q.started, quizRows[0].started)}>
									{#each stagesOf(q) as s (s.key)}
										{#if s.count}<span style:flex-grow={s.count} style:background={s.color}></span>{/if}
									{/each}
								</span>
								<span class="bar-value tnum">{q.completed} of {q.started}</span>
							</div>
						</li>
					{/each}
				</ul>
				<p class="muted small">
					Bar length is how many people opened the exercise; the number is how many of them finished it. The 12
					most opened are drawn; the table has up to 30.
				</p>
				<div class="table-wrap">
					<table>
						<thead>
							<tr>
								<th scope="col">Exercise</th>
								<th scope="col" class="end">Opened</th>
								<th scope="col" class="end">Answered 1+</th>
								<th scope="col" class="end">Finished</th>
								<th scope="col" class="end">Finish rate</th>
								<th scope="col" class="end">Median time</th>
								<th scope="col" class="end">Average score</th>
							</tr>
						</thead>
						<tbody>
							{#each quizRows as q (q.quiz)}
								<tr>
									<th scope="row">{shortQuiz(q.quiz)}</th>
									<td class="tnum end">{q.started}</td>
									<td class="tnum end">{q.answered}</td>
									<td class="tnum end">{q.completed}</td>
									<td class="tnum end">{pct(q.completed, q.started)}</td>
									<td class="tnum end">{time(q.seconds)}</td>
									<td class="tnum end">{q.score == null ? '–' : `${Math.round(q.score * 100)}%`}</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			{:else}
				<p class="muted">No exercise was opened by 3 people in this range.</p>
			{/if}
		</section>

		<section aria-labelledby="stage-head">
			<h2 id="stage-head">Passing by, or learning?</h2>
			<p class="muted">How many exercises the visitor's browser had already finished, at their last event of the day.</p>
			{#if report.stages.length}
				<div class="table-wrap">
					<table class="narrow">
						<thead>
							<tr>
								<th scope="col">Exercises finished so far</th>
								<th scope="col" class="end">People</th>
								<th scope="col" class="end">Downloaded</th>
								<th scope="col" class="end">Finished one that day</th>
							</tr>
						</thead>
						<tbody>
							{#each report.stages as s (s.stage)}
								<tr>
									<th scope="row" class="tnum">{s.stage}</th>
									<td class="tnum end">{s.people}</td>
									<td class="tnum end">{s.downloaded}</td>
									<td class="tnum end">{s.completed}</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			{:else}
				<p class="muted">
					Nothing yet in this range: this split needs visits from after the tracking update, which adds the value to
					every event.
				</p>
			{/if}
		</section>

		<section aria-labelledby="busy-head">
			<h2 id="busy-head">The busiest visitors</h2>
			<p class="muted">
				The top three rows sent {pct(Math.round(report.topThreeShare * report.events), report.events)} of all events in
				this range.
			</p>
			<div class="table-wrap">
				<table>
					<thead>
						<tr>
							<th scope="col">Day</th>
							<th scope="col">Where</th>
							<th scope="col">Device</th>
							<th scope="col">Came from</th>
							<th scope="col" class="end">Events</th>
							<th scope="col" class="end">Finished</th>
							<th scope="col" class="end">Time span</th>
						</tr>
					</thead>
					<tbody>
						{#each report.busiest as p (p.id)}
							<tr>
								<th scope="row" class="tnum">{p.day}</th>
								<td>{p.where}</td>
								<td>{p.os}</td>
								<td>{p.source}</td>
								<td class="tnum end">{p.events}</td>
								<td class="tnum end">{p.completedN}</td>
								<td class="tnum end">{span(p.minutes)}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</section>

		<section aria-labelledby="ev-head">
			<h2 id="ev-head">Events against people</h2>
			<p class="muted">
				What Aptabase's own chart draws is the first column. The last column is why its lines cannot be compared.
			</p>
			<div class="table-wrap">
				<table class="narrow">
					<thead>
						<tr>
							<th scope="col">Event</th>
							<th scope="col" class="end">Events</th>
							<th scope="col" class="end">People</th>
							<th scope="col" class="end">Events per person</th>
						</tr>
					</thead>
					<tbody>
						{#each report.byEvent.slice(0, 20) as e (e.name)}
							<tr>
								<th scope="row">{e.name}</th>
								<td class="tnum end">{num(e.events)}</td>
								<td class="tnum end">{e.people}</td>
								<td class="tnum end">{(e.events / e.people).toFixed(1)}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</section>
	{/if}

	<section class="notes" aria-labelledby="notes-head">
		<h2 id="notes-head">What these numbers can and cannot tell you</h2>
		<p class="muted">
			Each note: the problem, then what is in place now or what could be done. Figures are for the dates chosen above.
		</p>

		<dl>
			<div>
				<dt>A “person” is one visitor on one day</dt>
				<dd>
					The anonymous id changes every day, so a learner who studies on five days is five people here, and nobody
					can be followed from one day to the next.
				</dd>
				<dd class="now">
					<strong>Now:</strong> “had been here on an earlier day” and the “exercises finished so far” split come from
					values the visitor's own browser adds to each event.
					<strong>Possible:</strong> a visit counter kept on the device would give real return rates, but the privacy
					notice would have to say so first.
				</dd>
			</div>

			<div>
				<dt>Visitors who never tap are not counted</dt>
				<dd>
					Nothing is sent until the first real tap, click or key press: that keeps bots out, and it also drops anyone
					who opens a page, reads and leaves. A content blocker stops everything. Real traffic is higher than this
					report, and a bounce rate cannot be worked out.
				</dd>
				<dd class="now"><strong>Now:</strong> accepted on purpose. Read every share as “of the people who did something”.</dd>
			</div>

			<div>
				<dt>A PDF opened straight from a link is invisible</dt>
				<dd>
					When ChatGPT or a search engine links directly to a book's PDF, no page of the site runs, so no download
					is counted. The download numbers are a floor.
				</dd>
				<dd class="now">
					<strong>Possible:</strong> Google Search Console and Bing Webmaster Tools show clicks on the PDFs
					themselves (Bing also feeds ChatGPT's search). Neither is set up yet.
				</dd>
			</div>

			<div>
				<dt>Your own visits are guessed, not known</dt>
				<dd>
					Left out: anyone who opened the back office, and anyone in Germany whose first visit was 8 or more days
					ago ({report.ownLeftOut} visitor-days in this range). The second rule can also remove a loyal learner in
					Germany.
				</dd>
				<dd class="now">
					<strong>Now:</strong> a device that opens the back office signed in is marked and sends nothing.
					<strong>Possible:</strong> open the site once with <code>?internal=1</code> on each of your phones; the
					Germany rule can then be dropped. Tick “Count my own visits too” above to see what the rule removes.
				</dd>
			</div>

			<div>
				<dt>A few keen learners draw most of the event lines</dt>
				<dd>
					The three busiest visitors sent {pct(Math.round(report.topThreeShare * report.events), report.events)} of
					all events in this range{#if worstDay}, and on {worstDay.day} a single person sent
						{pct(worstDay.busiest, worstDay.events)} of that day's{/if}. One learner working for hours outweighs
					dozens of short visits, so event counts (and Aptabase's chart) say little about how many people did
					something.
				</dd>
				<dd class="now"><strong>Now:</strong> this report counts people. Use the event table only to watch the quota.</dd>
			</div>

			<div>
				<dt>The source could be lost mid-visit</dt>
				<dd>
					Before the tracking update, a reload turned a visitor from ChatGPT or a book code into “direct”. In this
					range {report.sourceDrift.drifted} of {num(report.sourceDrift.of)} events
					({pct(report.sourceDrift.drifted, report.sourceDrift.of)}) from visitors with a known source are labelled
					“direct”.
				</dd>
				<dd class="now">
					<strong>Now:</strong> the source is kept for the whole tab, and this report credits a person to their first
					known source of the day. A visitor who returns on another day by bookmark still counts as “direct”.
				</dd>
			</div>

			<div>
				<dt>Numbers before and after the tracking update differ</dt>
				<dd>
					{#if updateDay}
						The update first shows in this file on {updateDay}.
					{:else}
						The update is not in this file yet: every visit here is from before it.
					{/if}
					Before it: an event per lesson step and per question mark, no time and no score on a finished exercise,
					and “answered at least one question” is known only from 22 Nov 2026. After it: one <code>quiz_left</code>
					per unfinished visit, and time, score and lesson progress on <code>quiz_completed</code>.
				</dd>
				<dd class="now">
					<strong>Now:</strong> compare like with like: use “Since the tracking update” for time, score and the
					learner split.
				</dd>
			</div>

			<div>
				<dt>Leaving an exercise is reported on a best effort</dt>
				<dd>
					<code>quiz_left</code> is sent when the tab is hidden or closed. A phone can kill a tab without warning
					(the event is lost), and a learner who switches apps and comes back is reported again if they got further.
				</dd>
				<dd class="now"><strong>Now:</strong> this report counts a person once per exercise, whatever was sent.</dd>
			</div>

			<div>
				<dt>“Came back the same day” is an estimate</dt>
				<dd>
					Aptabase's session count starts a new session on every reload. Here a return is 30 minutes of nothing, then
					activity from the same visitor.
				</dd>
				<dd class="now">
					<strong>Possible:</strong> a session id kept for the tab would fix Aptabase's own figure; it also needs the
					privacy notice changed.
				</dd>
			</div>

			<div>
				<dt>Small numbers</dt>
				<dd>
					A row with fewer than {FEW} people moves by several points when one person does something. Most exercises
					and most sources are in that range.
				</dd>
				<dd class="now"><strong>Now:</strong> read counts first, percentages second, and widen the dates before deciding.</dd>
			</div>

			<div>
				<dt>The monthly event quota</dt>
				<dd>
					{#if report.monthlyPace}
						The last 7 full days of this range run at about {num(report.monthlyPace)} events a month.
					{:else}
						Fewer than 7 full days in this range: no monthly pace.
					{/if}
					Past the plan's limit, Aptabase may stop recording, and the days after would look empty.
				</dd>
				<dd class="now">
					<strong>Now:</strong> the update should cut roughly a quarter of the volume (not measured yet). Check the limit of your plan in
					Aptabase's billing page against this pace.
				</dd>
			</div>
		</dl>
	</section>
{/if}

{#if tip}
	<div class="tip" style:left="{tip.x}px" style:top="{tip.y}px" role="status">
		<strong>{tip.title}</strong>
		{#each tip.rows as r (r.label)}
			<span class="tip-row">
				{#if r.color}<span class="stroke" style:background={r.color}></span>{/if}
				<b class="tnum">{r.value}</b>
				{r.label}
			</span>
		{/each}
	</div>
{/if}

<style>
	.from select {
		margin-inline-start: 0.4rem;
		min-height: 2.5rem;
		max-width: 16rem;
		font: inherit;
	}

	.from {
		display: block;
		margin-bottom: 0.75rem;
	}

	.small {
		margin: 0.5rem 0 0.75rem;
		font-size: 0.85rem;
	}

	.link {
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-weight: 600;
		text-decoration: underline;
		cursor: pointer;
	}

	.seg {
		display: inline-flex;
		flex-wrap: wrap;
		gap: 0.25rem;
		padding: 0.25rem;
		margin-bottom: 0.75rem;
		border: 1px solid var(--line);
		border-radius: 999px;
	}

	.seg button {
		min-height: 2.25rem;
		padding: 0 0.9rem;
		border: 0;
		border-radius: 999px;
		background: transparent;
		color: var(--ink-muted);
		font: inherit;
		font-size: 0.9rem;
		font-weight: 600;
		cursor: pointer;
	}

	.seg button[aria-pressed='true'] {
		background: var(--heading);
		color: #fff;
	}

	.bars {
		list-style: none;
		margin: 0 0 0.25rem;
		padding: 0;
		display: grid;
		gap: 2px;
	}

	.bar-row {
		display: grid;
		grid-template-columns: minmax(8rem, 14rem) 1fr minmax(4.5rem, auto);
		align-items: center;
		gap: 0.75rem;
		width: 100%;
		min-height: 2.25rem;
		padding: 0.15rem 0.5rem;
		border: 0;
		border-radius: 8px;
		background: transparent;
		color: var(--ink);
		font: inherit;
		font-size: 0.9rem;
		text-align: start;
	}

	button.bar-row {
		cursor: pointer;
	}

	.bar-row:hover,
	.bar-row:focus-visible {
		background: var(--surface-alt);
	}

	.bar-row:focus-visible {
		outline: 2px solid var(--accent);
		outline-offset: -2px;
	}

	button.bar-row[aria-pressed='true'] {
		background: var(--surface-alt);
		box-shadow: inset 3px 0 0 var(--heading);
		font-weight: 700;
	}

	.bar-name {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.bar-track {
		display: block;
		height: 0.9rem;
	}

	.bar-fill {
		display: block;
		height: 100%;
		min-width: 2px;
		background: #2a78d6;
		border-radius: 0 4px 4px 0;
		transition: width 0.25s ease;
	}

	.bar-fill.few {
		background: #86b6ef;
	}

	.bar-track.stack {
		display: flex;
		gap: 2px;
		min-width: 6px;
	}

	.bar-track.stack span {
		min-width: 2px;
	}

	.bar-track.stack span:last-child {
		border-radius: 0 4px 4px 0;
	}

	.bar-value {
		text-align: end;
		white-space: nowrap;
	}

	.key-row {
		list-style: none;
		margin: 0 0 0.6rem;
		padding: 0;
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem 1.1rem;
		font-size: 0.85rem;
	}

	.key-row li {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
	}

	.swatch {
		width: 0.8rem;
		height: 0.8rem;
		border-radius: 3px;
	}

	.tip {
		position: fixed;
		z-index: 50;
		display: grid;
		gap: 0.15rem;
		max-width: 16rem;
		padding: 0.55rem 0.75rem;
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: 10px;
		box-shadow: 0 4px 14px rgb(0 0 0 / 0.08);
		font-size: 0.85rem;
		pointer-events: none;
	}

	.tip-row {
		display: flex;
		align-items: baseline;
		gap: 0.4rem;
		color: var(--ink-muted);
	}

	.tip-row b {
		color: var(--ink);
		white-space: nowrap;
	}

	.stroke {
		flex: none;
		align-self: center;
		width: 0.75rem;
		height: 3px;
		border-radius: 2px;
	}

	@media (prefers-reduced-motion: reduce) {
		.bar-fill {
			transition: none;
		}
	}

	@media (max-width: 40rem) {
		.bar-row {
			grid-template-columns: 1fr auto;
		}

		.bar-track {
			grid-column: 1 / -1;
			order: 3;
		}
	}

	h2 {
		margin: 0 0 0.35rem;
		font-size: var(--step-1);
	}

	section {
		margin: 0 0 1.25rem;
		padding: 1rem 1.25rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 12px;
	}

	.muted {
		margin: 0 0 0.75rem;
		color: var(--ink-muted);
		max-width: 75ch;
	}

	.err {
		color: var(--wrong);
	}

	.warn {
		margin: 0 0 1.25rem;
		padding: 0.6rem 1rem;
		border: 1px dashed var(--line-strong);
		border-radius: 10px;
	}

	.file input {
		position: absolute;
		opacity: 0;
		width: 1px;
		height: 1px;
	}

	.file input:focus-visible + .btn {
		outline: 2px solid var(--accent);
		outline-offset: 2px;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		min-height: 2.75rem;
		padding: 0 1.1rem;
		border-radius: 999px;
		background: var(--heading);
		color: #fff;
		font-weight: 600;
		cursor: pointer;
	}

	.load .muted:last-child {
		margin: 0.75rem 0 0;
	}

	.range-row {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.75rem 1.25rem;
		margin-bottom: 0.75rem;
	}

	.range-row input {
		margin-inline-start: 0.4rem;
		min-height: 2.5rem;
		padding: 0 0.5rem;
		font: inherit;
	}

	.presets {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}

	.presets button {
		min-height: 2.5rem;
		padding: 0 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: transparent;
		color: var(--heading);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.presets button[aria-pressed='true'] {
		background: var(--heading);
		color: #fff;
	}

	.check {
		display: inline-flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem;
	}

	.check .muted {
		margin: 0;
	}

	.tiles {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(9.5rem, 1fr));
		gap: 0.75rem;
		margin-bottom: 1.25rem;
	}

	.tile {
		padding: 0.85rem 1rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 12px;
	}

	.tile b {
		display: block;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-3);
		line-height: 1.1;
		color: var(--heading);
	}

	.tile span {
		font-size: 0.85rem;
		color: var(--ink-muted);
	}

	.funnel {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		gap: 0.45rem;
	}

	.funnel li {
		display: grid;
		grid-template-columns: minmax(11rem, 19rem) 1fr 3.5rem 3rem;
		align-items: center;
		gap: 0.75rem;
	}

	.track {
		display: inline-block;
		width: 5.5rem;
		height: 0.55rem;
		background: var(--surface-alt);
		border-radius: 99px;
		overflow: hidden;
		vertical-align: middle;
	}

	.funnel .track {
		width: 100%;
		height: 0.85rem;
	}

	.track.day {
		width: 9rem;
	}

	.track span {
		display: block;
		height: 100%;
		background: var(--accent);
		border-radius: 99px;
	}

	.end {
		text-align: end;
	}

	.table-wrap {
		overflow-x: auto;
	}

	table {
		border-collapse: collapse;
		width: 100%;
		font-size: 0.9rem;
	}

	table.narrow {
		width: auto;
		min-width: min(100%, 30rem);
	}

	th,
	td {
		padding: 0.4rem 0.6rem;
		border-bottom: 1px solid var(--line);
		text-align: start;
		white-space: nowrap;
	}

	th.end,
	td.end {
		text-align: end;
	}

	tbody th {
		font-weight: 600;
	}

	thead th {
		font-size: 0.8rem;
		color: var(--ink-muted);
	}

	tbody tr:last-child :is(th, td) {
		border-bottom: 0;
	}

	td small {
		margin-inline-start: 0.25rem;
		color: var(--ink-muted);
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip-path: inset(50%);
		white-space: nowrap;
	}

	.notes dl {
		margin: 0;
		display: grid;
		gap: 1rem;
	}

	.notes dl > div {
		padding-top: 1rem;
		border-top: 1px solid var(--line);
	}

	.notes dt {
		font-weight: 700;
		color: var(--heading);
	}

	.notes dd {
		margin: 0.25rem 0 0;
		max-width: 80ch;
		line-height: 1.55;
	}

	.notes dd.now {
		color: var(--ink-muted);
	}

	.notes dd.now strong {
		color: var(--ink);
	}

	@media (max-width: 40rem) {
		.funnel li {
			grid-template-columns: 1fr 3rem 3rem;
		}

		.funnel .track {
			grid-column: 1 / -1;
			order: 2;
		}
	}
</style>
