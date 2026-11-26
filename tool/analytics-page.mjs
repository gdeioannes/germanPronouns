// The analytics, counted in PEOPLE instead of events.
//
//   node tool/analytics-page.mjs <aptabase-export.csv> [out.html]
//
// Aptabase's own chart draws one line per event name, and a lesson fires a
// dozen events per reader, so three keen learners draw most of every line.
// This page reads the same CSV export and counts visitor-days: one Aptabase
// user id, which rotates daily, so "a visitor" here is one person on one day.
//
// Left out as the owner's own visits (same rule as tool/analytics-report.mjs):
// anyone who opened /backoffice, and Germany with a first visit 8+ days ago.
//
// Nothing is uploaded: the page is one local HTML file, written next to the CSV.

import fs from 'node:fs';
import path from 'node:path';

const src = process.argv[2];
if (!src) {
	console.error('usage: node tool/analytics-page.mjs <aptabase-export.csv> [out.html]');
	process.exit(1);
}
const out = process.argv[3] ?? path.join(path.dirname(src), 'analytics-report.html');

function parseCsv(t) {
	const rows = [];
	let row = [], f = '', q = false;
	for (let i = 0; i < t.length; i++) {
		const c = t[i];
		if (q) {
			if (c === '"') {
				if (t[i + 1] === '"') { f += '"'; i++; } else q = false;
			} else f += c;
		} else if (c === '"') q = true;
		else if (c === ',') { row.push(f); f = ''; }
		else if (c === '\n') { row.push(f); rows.push(row); row = []; f = ''; }
		else if (c !== '\r') f += c;
	}
	if (f || row.length) { row.push(f); rows.push(row); }
	return rows;
}

const rows = parseCsv(fs.readFileSync(src, 'utf8').replace(/^﻿/, ''));
const head = rows.shift();
const json = (s) => { try { return JSON.parse(s || '{}'); } catch { return {}; } };
const ev = rows
	.filter((r) => r.length >= head.length)
	.map((r) => {
		const o = Object.fromEntries(head.map((h, i) => [h, r[i]]));
		o.p = json(o.string_props);
		o.n = json(o.numeric_props);
		o.day = o.timestamp.slice(0, 10);
		o.t = Date.parse(o.timestamp.replace(' ', 'T') + 'Z');
		return o;
	})
	.sort((a, b) => a.t - b.t);

const users = new Map();
for (const e of ev) {
	if (!users.has(e.user_id)) users.set(e.user_id, []);
	users.get(e.user_id).push(e);
}
const internal = new Set();
for (const [u, es] of users) {
	if (
		es.some((e) => e.p.route === '/backoffice') ||
		es.some((e) => ['30+', '8-30'].includes(e.p.days_since_first) && e.country_code === 'DE')
	)
		internal.add(u);
}
/** One entry per visitor-day: [id, events]. */
const people = [...users].filter(([u]) => !internal.has(u));

// ---- helpers ---------------------------------------------------------------
const has = (es, name) => es.some((e) => e.event_name === name);
const norm = (r) => (r ? r.replace(/^\/(ar|tr|uk|fr|es)(?=\/|$)/, '') || '/' : '');
const isChapter = (r) => /^\/course\/[^/]+\/book2\/[A-C]\d\.\d\/.+/.test(norm(r));
/** The source a visitor arrived from: the first one that is not "direct". */
const sourceOf = (es) => (es.find((e) => e.p.source && e.p.source !== 'direct') ?? es[0]).p.source || 'direct';
/** Visits in a day: a new one starts after 30 minutes of nothing (a reload is not a return). */
const visitsOf = (es) => 1 + es.filter((e, i) => i > 0 && e.t - es[i - 1].t > 30 * 60 * 1000).length;
const median = (xs) => (xs.length ? [...xs].sort((a, b) => a - b)[xs.length >> 1] : null);
const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]);
const pct = (a, b) => (b ? Math.round((100 * a) / b) + '%' : '–');
const count = (items, key) => {
	const m = new Map();
	for (const x of items) {
		const k = key(x);
		if (k == null || k === '') continue;
		m.set(k, (m.get(k) ?? 0) + 1);
	}
	return [...m].sort((a, b) => b[1] - a[1]);
};
const mmss = (s) => (s == null ? '–' : s < 60 ? `${s} s` : `${Math.floor(s / 60)} min ${String(s % 60).padStart(2, '0')}`);

/** What one visitor-day did, as flags. */
const facts = people.map(([id, es]) => ({
	id,
	es,
	day: es[0].day,
	source: sourceOf(es),
	returning: es.some((e) => e.p.days_since_first && e.p.days_since_first !== '0'),
	downloaded: has(es, 'book_download'),
	bookOnline: es.some((e) => isChapter(e.p.route)) || has(es, 'book_page_used'),
	started: has(es, 'quiz_started'),
	// Old exports mark an answered question with quiz_progress; new ones say it
	// on quiz_left / quiz_completed.
	answered:
		has(es, 'quiz_completed') ||
		es.some((e) => (e.event_name === 'quiz_progress' || e.event_name === 'quiz_left') && e.n.answered >= 1),
	completed: has(es, 'quiz_completed'),
	completedN: new Set(es.filter((e) => e.event_name === 'quiz_completed').map((e) => e.p.quiz)).size,
	visits: visitsOf(es),
	minutes: Math.round((es.at(-1).t - es[0].t) / 60000)
}));

const days = [...new Set(ev.map((e) => e.day))].sort();
const total = facts.length;
const n = (f) => facts.filter(f).length;

// ---- sections --------------------------------------------------------------
const bar = (value, max, cls = '') =>
	`<span class="bar ${cls}" style="--w:${max ? Math.round((100 * value) / max) : 0}%"></span>`;

function table(headers, body, cls = '') {
	return `<div class="scroll"><table class="${cls}"><thead><tr>${headers
		.map((h, i) => `<th${i ? ' class="num"' : ''}>${esc(h)}</th>`)
		.join('')}</tr></thead><tbody>${body.join('')}</tbody></table></div>`;
}
const row = (cells) => `<tr>${cells.map((c, i) => `<td${i ? ' class="num"' : ''}>${c}</td>`).join('')}</tr>`;

// 1. The funnel.
const funnel = [
	['Visited (tapped at least once)', total],
	['Downloaded a book', n((f) => f.downloaded)],
	['Used the book online (chapter page)', n((f) => f.bookOnline)],
	['Opened an exercise', n((f) => f.started)],
	['Answered at least one question', n((f) => f.answered)],
	['Finished an exercise', n((f) => f.completed)],
	['Finished three or more', n((f) => f.completedN >= 3)],
	['Came back the same day (30+ min later)', n((f) => f.visits > 1)],
	['Was here on an earlier day too', n((f) => f.returning)]
];
const funnelHtml = `<ul class="funnel">${funnel
	.map(
		([label, v]) =>
			`<li><span class="f-label">${esc(label)}</span><span class="f-track">${bar(v, total)}</span><span class="f-n">${v}</span><span class="f-p">${pct(v, total)}</span></li>`
	)
	.join('')}</ul>`;

// 2. Per day.
const perDay = days.map((d) => {
	const fs_ = facts.filter((f) => f.day === d);
	return {
		d,
		people: fs_.length,
		returning: fs_.filter((f) => f.returning).length,
		downloaded: fs_.filter((f) => f.downloaded).length,
		started: fs_.filter((f) => f.started).length,
		completed: fs_.filter((f) => f.completed).length,
		events: fs_.reduce((s, f) => s + f.es.length, 0),
		top: Math.max(0, ...fs_.map((f) => f.es.length))
	};
});
const maxPeople = Math.max(1, ...perDay.map((x) => x.people));
const dayHtml = table(
	['Day', 'People', '', 'Returning', 'Downloaded', 'Opened an exercise', 'Finished one', 'Events', 'Busiest person'],
	perDay.map((x) =>
		row([
			x.d.slice(5),
			x.people,
			`<span class="f-track wide">${bar(x.people, maxPeople)}</span>`,
			x.returning,
			x.downloaded,
			x.started,
			x.completed,
			x.events,
			x.events ? `${x.top} (${pct(x.top, x.events)})` : '–'
		])
	),
	'days'
);

// 3. Sources.
const bySource = count(facts, (f) => f.source).slice(0, 12);
const sourceHtml = table(
	['Came from', 'People', 'Downloaded', 'Opened an exercise', 'Finished one'],
	bySource.map(([s, c]) => {
		const fs_ = facts.filter((f) => f.source === s);
		const of = (k) => { const v = fs_.filter((f) => f[k]).length; return `${v} <small>${pct(v, c)}</small>`; };
		return row([esc(s), c, of('downloaded'), of('started'), of('completed')]);
	})
);

// 4. Exercises: where they lose people.
const quizzes = new Map();
const q = (id) => {
	if (!quizzes.has(id)) quizzes.set(id, { started: new Set(), answered: new Set(), done: new Set(), secs: [], share: [], lessonStops: [] });
	return quizzes.get(id);
};
for (const f of facts) {
	for (const e of f.es) {
		const id = e.p.quiz;
		if (!id) continue;
		if (e.event_name === 'quiz_started') q(id).started.add(f.id);
		if ((e.event_name === 'quiz_progress' || e.event_name === 'quiz_left') && e.n.answered >= 1) q(id).answered.add(f.id);
		if (e.event_name === 'quiz_completed') {
			q(id).done.add(f.id);
			q(id).answered.add(f.id);
			if (e.n.seconds) q(id).secs.push(e.n.seconds);
			if (e.n.total) q(id).share.push(e.n.right / e.n.total);
		}
	}
}
const quizRows = [...quizzes]
	.filter(([, v]) => v.started.size >= 3)
	.sort((a, b) => b[1].started.size - a[1].started.size)
	.slice(0, 30);
const quizHtml = table(
	['Exercise', 'Opened', 'Answered 1+', 'Finished', 'Finish rate', 'Median time', 'Average score'],
	quizRows.map(([id, v]) =>
		row([
			esc(id.replace(/^quest_/, '')),
			v.started.size,
			v.answered.size,
			v.done.size,
			`<span class="f-track">${bar(v.done.size, v.started.size, v.done.size / v.started.size < 0.4 ? 'low' : '')}</span> ${pct(v.done.size, v.started.size)}`,
			mmss(median(v.secs)),
			v.share.length ? Math.round((100 * v.share.reduce((a, b) => a + b, 0)) / v.share.length) + '%' : '–'
		])
	)
);

// 5. Learners or passers-by: how much of the course the browser had done.
const stageOrder = ['0', '1-4', '5-19', '20-49', '50+'];
const stage = (f) => f.es.at(-1).p.done_n;
const staged = facts.filter((f) => stage(f));
const stageHtml = staged.length
	? table(
			['Exercises finished so far', 'People', 'Downloaded', 'Finished one today'],
			stageOrder
				.filter((s) => staged.some((f) => stage(f) === s))
				.map((s) => {
					const fs_ = staged.filter((f) => stage(f) === s);
					return row([s, fs_.length, fs_.filter((f) => f.downloaded).length, fs_.filter((f) => f.completed).length]);
				})
		)
	: '<p class="note">No data yet: this split starts with visits after the 26 Nov 2026 update (the <code>done_n</code> value on every event).</p>';

// 6. The people who do the most.
const heavy = [...facts].sort((a, b) => b.es.length - a.es.length).slice(0, 12);
const heavyHtml = table(
	['Day', 'Where', 'Device', 'Came from', 'Events', 'Finished', 'Time span'],
	heavy.map((f) =>
		row([
			f.day.slice(5),
			esc(`${f.es[0].country_name || f.es[0].country_code}${f.es[0].region_name ? ', ' + f.es[0].region_name : ''}`),
			esc(f.es[0].os_name || '?'),
			esc(f.source),
			f.es.length,
			f.completedN,
			f.minutes < 60 ? `${f.minutes} min` : `${(f.minutes / 60).toFixed(1)} h`
		])
	),
	'words'
);

const allEvents = facts.reduce((s, f) => s + f.es.length, 0);
const last7 = days.slice(-8, -1);
const last7Events = ev.filter((e) => last7.includes(e.day)).length;

const html = `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Analytics in people · ${esc(days[0])} to ${esc(days.at(-1))}</title>
<style>
:root{--bg:#f7f5f0;--card:#fff;--ink:#1f2328;--muted:#646b73;--line:#e3dfd6;--fill:#2f6f5e;--low:#b4552d;--track:#ece8df}
@media (prefers-color-scheme:dark){:root{--bg:#15171a;--card:#1d2024;--ink:#e8e6e1;--muted:#9aa1a9;--line:#2c3036;--fill:#5fb39c;--low:#e08a63;--track:#2a2e33}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);font:15px/1.5 system-ui,-apple-system,"Segoe UI",sans-serif}
main{max-width:1040px;margin:0 auto;padding:32px 20px 64px}
h1{font-size:26px;line-height:1.2;margin:0 0 4px;text-wrap:balance}
h2{font-size:17px;margin:0 0 4px}
.sub,.note{color:var(--muted);margin:0 0 14px;max-width:70ch}
section{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:20px;margin-top:18px}
.tiles{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:12px;margin-top:18px}
.tile{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:14px 16px}
.tile b{display:block;font-size:26px;line-height:1.15;font-variant-numeric:tabular-nums}
.tile span{color:var(--muted);font-size:13px}
.scroll{overflow-x:auto}
table{border-collapse:collapse;width:100%;font-variant-numeric:tabular-nums}
th,td{text-align:left;padding:6px 10px;border-bottom:1px solid var(--line);white-space:nowrap}
th{font-size:12px;font-weight:600;color:var(--muted)}
.num{text-align:right}
.words :is(th,td):nth-child(-n+4){text-align:left}
td small{color:var(--muted);margin-left:4px}
tbody tr:last-child td{border-bottom:0}
.f-track{display:inline-block;width:90px;height:8px;border-radius:4px;background:var(--track);vertical-align:middle;overflow:hidden}
.f-track.wide{width:160px}
.bar{display:block;height:100%;width:var(--w);background:var(--fill);border-radius:4px}
.bar.low{background:var(--low)}
.funnel{list-style:none;margin:0;padding:0;display:grid;gap:8px}
.funnel li{display:grid;grid-template-columns:minmax(180px,300px) 1fr 48px 48px;gap:12px;align-items:center}
.funnel .f-track{width:100%;height:14px;border-radius:7px}
.funnel .bar{border-radius:7px}
.f-n,.f-p{text-align:right;font-variant-numeric:tabular-nums}
.f-p{color:var(--muted)}
code{font-size:13px}
@media (max-width:600px){.funnel li{grid-template-columns:1fr 40px 44px}.funnel .f-track{grid-column:1/-1;order:2}}
</style></head><body><main>
<h1>Analytics, counted in people</h1>
<p class="sub">${esc(days[0])} to ${esc(days.at(-1))} · last event ${esc(ev.at(-1).timestamp)} UTC. A “person” is one visitor on one day (the anonymous id changes daily). ${internal.size} visitor-days left out as your own.</p>

<div class="tiles">
<div class="tile"><b>${total}</b><span>people (visitor-days)</span></div>
<div class="tile"><b>${pct(n((f) => f.downloaded), total)}</b><span>downloaded a book</span></div>
<div class="tile"><b>${pct(n((f) => f.started), total)}</b><span>opened an exercise</span></div>
<div class="tile"><b>${pct(n((f) => f.completed), total)}</b><span>finished an exercise</span></div>
<div class="tile"><b>${pct(n((f) => f.returning), total)}</b><span>had been here on an earlier day</span></div>
<div class="tile"><b>${last7Events.toLocaleString('en')}</b><span>events in the last 7 full days (≈ ${Math.round((last7Events / 7) * 30).toLocaleString('en')} a month)</span></div>
</div>

<section><h2>What people did</h2><p class="sub">Each row is a share of all ${total} people, not a step that requires the one above it.</p>${funnelHtml}</section>
<section><h2>Day by day</h2><p class="sub">“Busiest person” is the most events one visitor sent that day and their share of the day’s total: the reason event charts mislead.</p>${dayHtml}</section>
<section><h2>Where they came from</h2><p class="sub">By the first known source of the day, so a reload no longer turns a ChatGPT visitor into “direct”.</p>${sourceHtml}</section>
<section><h2>Exercises: where people stop</h2><p class="sub">People, not runs. Exercises opened by at least 3 people. Time and score are filled in for runs finished after the 26 Nov 2026 update.</p>${quizHtml}</section>
<section><h2>Passing by, or learning?</h2><p class="sub">How many exercises the visitor’s browser had already finished, as of their last event that day.</p>${stageHtml}</section>
<section><h2>The busiest visitors</h2><p class="sub">${heavy.slice(0, 3).reduce((s, f) => s + f.es.length, 0)} of ${allEvents} events (${pct(heavy.slice(0, 3).reduce((s, f) => s + f.es.length, 0), allEvents)}) come from the top three rows.</p>${heavyHtml}</section>
</main></body></html>`;

fs.writeFileSync(out, html);
console.log(`${total} people, ${allEvents} events → ${out}`);
