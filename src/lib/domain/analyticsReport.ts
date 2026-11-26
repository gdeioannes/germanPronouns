// The analytics, counted in PEOPLE instead of events: the numbers behind the
// back office's Analytics page (and the same sums as tool/analytics-page.mjs).
//
// The input is Aptabase's CSV export. There is no way to read the events
// from the browser otherwise: the key in the site can only write.
//
// "A person" is a visitor-day: one Aptabase user id, which rotates daily. So
// one learner on five days is five people here. Every caveat of that kind is
// spelled out on the page itself (see the route's notes).

export type AnalyticsEvent = {
	/** Milliseconds, UTC. */
	t: number;
	/** The UTC day, YYYY-MM-DD. */
	day: string;
	user: string;
	name: string;
	/** String props (source, route, quiz, done_n …). */
	p: Record<string, string>;
	/** Numeric props (answered, seconds, right, total …). */
	n: Record<string, number>;
	country: string;
	region: string;
	os: string;
};

/** Splits CSV text into rows of fields; quoted fields may hold commas, quotes and newlines. */
export function parseCsv(text: string): string[][] {
	const rows: string[][] = [];
	let row: string[] = [];
	let field = '';
	let quoted = false;
	for (let i = 0; i < text.length; i++) {
		const c = text[i];
		if (quoted) {
			if (c === '"') {
				if (text[i + 1] === '"') {
					field += '"';
					i++;
				} else quoted = false;
			} else field += c;
		} else if (c === '"') quoted = true;
		else if (c === ',') {
			row.push(field);
			field = '';
		} else if (c === '\n') {
			row.push(field);
			rows.push(row);
			row = [];
			field = '';
		} else if (c !== '\r') field += c;
	}
	if (field || row.length) {
		row.push(field);
		rows.push(row);
	}
	return rows;
}

function props(raw: string | undefined): Record<string, unknown> {
	try {
		const parsed = JSON.parse(raw || '{}');
		return parsed && typeof parsed === 'object' ? parsed : {};
	} catch {
		return {};
	}
}

/**
 * Reads one Aptabase export. Throws when the file is not one (no timestamp,
 * user_id and event_name columns), so a wrong file says so instead of
 * showing an empty report.
 */
export function readExport(text: string): AnalyticsEvent[] {
	const rows = parseCsv(text.replace(/^﻿/, ''));
	const head = rows.shift() ?? [];
	const col = (name: string) => head.indexOf(name);
	const [iT, iU, iN] = [col('timestamp'), col('user_id'), col('event_name')];
	if (iT < 0 || iU < 0 || iN < 0) throw new Error('This is not an Aptabase export (no timestamp, user_id, event_name columns).');
	const [iS, iNum, iC, iCc, iR, iOs] = ['string_props', 'numeric_props', 'country_name', 'country_code', 'region_name', 'os_name'].map(col);
	const events: AnalyticsEvent[] = [];
	for (const r of rows) {
		if (r.length < head.length) continue;
		const t = Date.parse(r[iT].replace(' ', 'T') + 'Z');
		if (Number.isNaN(t)) continue;
		const p: Record<string, string> = {};
		for (const [k, v] of Object.entries(props(r[iS]))) p[k] = String(v);
		const n: Record<string, number> = {};
		for (const [k, v] of Object.entries(props(r[iNum]))) if (typeof v === 'number') n[k] = v;
		events.push({
			t,
			day: r[iT].slice(0, 10),
			user: r[iU],
			name: r[iN],
			p,
			n,
			country: r[iC] || r[iCc] || '',
			region: r[iR] ?? '',
			os: r[iOs] ?? ''
		});
	}
	return events;
}

/** Several exports as one list, in time order, an event in two files counted once. */
export function mergeExports(lists: AnalyticsEvent[][]): AnalyticsEvent[] {
	const seen = new Set<string>();
	const all: AnalyticsEvent[] = [];
	for (const e of lists.flat()) {
		const key = `${e.t}|${e.user}|${e.name}|${e.p.route ?? ''}|${e.p.quiz ?? ''}|${e.p.book ?? ''}|${e.n.step ?? ''}|${e.n.answered ?? ''}`;
		if (seen.has(key)) continue;
		seen.add(key);
		all.push(e);
	}
	return all.sort((a, b) => a.t - b.t);
}

export type Person = {
	id: string;
	day: string;
	events: number;
	source: string;
	where: string;
	os: string;
	returning: boolean;
	downloaded: boolean;
	bookOnline: boolean;
	started: boolean;
	answered: boolean;
	completed: boolean;
	/** Distinct exercises finished that day. */
	completedN: number;
	/** Visits that day: a new one starts after 30 minutes of nothing. */
	visits: number;
	/** First to last event, in minutes. */
	minutes: number;
	/** Exercises finished so far, as a bucket ('' before the tracking update). */
	stage: string;
	/** The visit in three steps: where they landed, the first thing they did, how it ended (see PATH_STEPS). */
	path: [string, string, string];
};

/**
 * The three steps of a visit's path, each with its possible answers in the
 * order they are drawn. A person has exactly one answer per step.
 */
export const PATH_STEPS = [
	{
		title: 'Landed on',
		options: ['Books page', 'Home page', 'A book code', 'The book online', 'An exercise', 'Another page']
	},
	{
		title: 'First thing they did',
		options: [
			'Downloaded a book',
			'Opened the online reader',
			'Opened a chapter page',
			'Opened an exercise',
			'Looked at other pages',
			'Nothing more'
		]
	},
	{
		title: 'How the day ended',
		options: [
			'Finished an exercise',
			'Opened an exercise, did not finish',
			'Used a chapter page',
			'Left with the download',
			'Only read online',
			'Left with nothing'
		]
	}
] as const;

const isBookOnline = (route: string | undefined) => /^\/course\/[^/]+\/book2\//.test(withoutLang(route));

/** Where they landed, what they did first, and how it ended, for one visitor-day's events (in time order). */
function pathOf(es: AnalyticsEvent[], source: string): [string, string, string] {
	const landingIndex = es.findIndex((e) => e.name === 'screen_view');
	const route = withoutLang(es[landingIndex]?.p.route);
	const landing =
		route.startsWith('/b/') || route.startsWith('/play/quest') || source === 'book'
			? 'A book code'
			: route === '/books' || route.startsWith('/books/')
				? 'Books page'
				: route === '/'
					? 'Home page'
					: isBookOnline(route)
						? 'The book online'
						: /^\/course\/[^/]+\/quiz\//.test(route)
							? 'An exercise'
							: 'Another page';

	let first = '';
	for (let i = 0; i < es.length && !first; i++) {
		const e = es[i];
		if (e.name === 'book_download') first = 'Downloaded a book';
		else if (e.name === 'quiz_started') first = 'Opened an exercise';
		else if (e.name === 'book_page_used' || (e.name === 'screen_view' && i !== landingIndex && isChapterPage(e.p.route)))
			first = 'Opened a chapter page';
		// The reader shows the whole book as pages; a chapter page is the book's page in the app.
		else if (e.name === 'screen_view' && i !== landingIndex && isBookOnline(e.p.route)) first = 'Opened the online reader';
	}
	if (!first) {
		const pages = new Set(es.filter((e) => e.name === 'screen_view').map((e) => e.p.route));
		first = pages.size > 1 ? 'Looked at other pages' : 'Nothing more';
	}

	const has = (name: string) => es.some((e) => e.name === name);
	const end = has('quiz_completed')
		? 'Finished an exercise'
		: has('quiz_started')
			? 'Opened an exercise, did not finish'
			: has('book_page_used') || es.some((e, i) => e.name === 'screen_view' && isChapterPage(e.p.route) && i !== landingIndex)
				? 'Used a chapter page'
				: has('book_download')
					? 'Left with the download'
					: es.some((e, i) => e.name === 'screen_view' && isBookOnline(e.p.route) && i !== landingIndex)
						? 'Only read online'
						: 'Left with nothing';
	return [landing, first, end];
}

export type DayRow = {
	day: string;
	people: number;
	returning: number;
	downloaded: number;
	started: number;
	completed: number;
	events: number;
	/** The most events one person sent that day. */
	busiest: number;
};

export type SourceRow = { source: string; people: number; downloaded: number; started: number; completed: number };

export type QuizRow = {
	quiz: string;
	started: number;
	answered: number;
	completed: number;
	/** Median seconds of a finished run; null before the tracking update. */
	seconds: number | null;
	/** Average share right, 0–1; null when no finished run carried a score. */
	score: number | null;
};

export type EventRow = { name: string; events: number; people: number };

export type Report = {
	from: string;
	to: string;
	days: DayRow[];
	people: Person[];
	total: number;
	events: number;
	/** Visitor-days left out as the owner's own, in the range. */
	ownLeftOut: number;
	funnel: { label: string; count: number }[];
	sources: SourceRow[];
	quizzes: QuizRow[];
	stages: { stage: string; people: number; downloaded: number; completed: number }[];
	busiest: Person[];
	byEvent: EventRow[];
	/** Share of all events sent by the three busiest people, 0–1. */
	topThreeShare: number;
	/** Events labelled "direct" although the same person arrived from a known source that day. */
	sourceDrift: { drifted: number; of: number };
	/** Events a month at the pace of the range's last 7 full days (null under 7 days of data). */
	monthlyPace: number | null;
	/** The first day carrying the 2026-11 tracking update's values (done_n), or null. */
	updateDay: string | null;
};

const STAGES = ['0', '1-4', '5-19', '20-49', '50+'];
const VISIT_GAP_MS = 30 * 60 * 1000;

const withoutLang = (route: string | undefined) => (route ? route.replace(/^\/(ar|tr|uk|fr|es)(?=\/|$)/, '') || '/' : '');
const isChapterPage = (route: string | undefined) => /^\/course\/[^/]+\/book2\/[A-C]\d\.\d\/.+/.test(withoutLang(route));

/**
 * The owner's own visitor-days: anyone who opened the back office, and
 * Germany with a first visit 8+ days ago (the owner's phones, which never
 * sign in). The second rule can also catch a loyal learner in Germany; the
 * page says so, and marking the owner's devices with ?internal=1 retires it.
 */
export function ownVisitors(events: AnalyticsEvent[]): Set<string> {
	const own = new Set<string>();
	for (const e of events) {
		if (
			e.p.route?.startsWith('/backoffice') ||
			((e.p.days_since_first === '8-30' || e.p.days_since_first === '30+') && /^(DE|Germany)$/.test(e.country))
		)
			own.add(e.user);
	}
	return own;
}

function median(xs: number[]): number | null {
	if (!xs.length) return null;
	return [...xs].sort((a, b) => a - b)[xs.length >> 1];
}

/** Every UTC day from `from` to `to`, inclusive. */
function daysBetween(from: string, to: string): string[] {
	const out: string[] = [];
	for (let t = Date.parse(from + 'T00:00:00Z'); t <= Date.parse(to + 'T00:00:00Z') && out.length < 800; t += 86_400_000) {
		out.push(new Date(t).toISOString().slice(0, 10));
	}
	return out;
}

export function buildReport(
	all: AnalyticsEvent[],
	options: {
		from?: string;
		to?: string;
		includeOwn?: boolean;
		/** Only the people who came from this source (their first known one of the day). */
		source?: string;
	} = {}
): Report {
	const first = all[0]?.day ?? '';
	const last = all.at(-1)?.day ?? '';
	const from = options.from && options.from > first ? options.from : first;
	const to = options.to && options.to < last ? options.to : last;
	const inRange = all.filter((e) => e.day >= from && e.day <= to);
	// The id is a new one each day, so the range's own events decide.
	const own = options.includeOwn ? new Set<string>() : ownVisitors(inRange);

	const byUser = new Map<string, AnalyticsEvent[]>();
	for (const e of inRange) {
		if (own.has(e.user)) continue;
		const list = byUser.get(e.user);
		if (list) list.push(e);
		else byUser.set(e.user, [e]);
	}

	type Tally = { started: Set<string>; answered: Set<string>; done: Set<string>; secs: number[]; share: number[] };
	const quizTally = new Map<string, Tally>();
	const tally = (id: string): Tally => {
		let v = quizTally.get(id);
		if (!v) quizTally.set(id, (v = { started: new Set(), answered: new Set(), done: new Set(), secs: [], share: [] }));
		return v;
	};
	const eventTally = new Map<string, { events: number; people: Set<string> }>();
	let drifted = 0;
	let sourced = 0;

	const people: Person[] = [];
	for (const [id, es] of byUser) {
		const has = (name: string) => es.some((e) => e.name === name);
		const firstKnown = es.find((e) => e.p.source && e.p.source !== 'direct');
		const source = (firstKnown ?? es[0]).p.source || 'direct';
		if (options.source && source !== options.source) continue;
		if (firstKnown) {
			for (const e of es) {
				if (e.t < firstKnown.t) continue;
				sourced++;
				if (e.p.source === 'direct') drifted++;
			}
		}
		for (const e of es) {
			let row = eventTally.get(e.name);
			if (!row) eventTally.set(e.name, (row = { events: 0, people: new Set() }));
			row.events++;
			row.people.add(id);

			const quiz = e.p.quiz;
			if (!quiz) continue;
			if (e.name === 'quiz_started') tally(quiz).started.add(id);
			// Before the update an answered question was a quiz_progress mark;
			// since then quiz_left and quiz_completed carry the count.
			if ((e.name === 'quiz_progress' || e.name === 'quiz_left') && (e.n.answered ?? 0) >= 1) tally(quiz).answered.add(id);
			if (e.name === 'quiz_completed') {
				const v = tally(quiz);
				v.done.add(id);
				v.answered.add(id);
				if (e.n.seconds) v.secs.push(e.n.seconds);
				if (e.n.total) v.share.push((e.n.right ?? 0) / e.n.total);
			}
		}
		people.push({
			id,
			day: es[0].day,
			events: es.length,
			source,
			where: [es[0].country, es[0].region].filter(Boolean).join(', '),
			os: es[0].os || '?',
			returning: es.some((e) => e.p.days_since_first && e.p.days_since_first !== '0'),
			downloaded: has('book_download'),
			bookOnline: has('book_page_used') || es.some((e) => isChapterPage(e.p.route)),
			started: has('quiz_started'),
			answered:
				has('quiz_completed') ||
				es.some((e) => (e.name === 'quiz_progress' || e.name === 'quiz_left') && (e.n.answered ?? 0) >= 1),
			completed: has('quiz_completed'),
			completedN: new Set(es.filter((e) => e.name === 'quiz_completed').map((e) => e.p.quiz)).size,
			visits: 1 + es.filter((e, i) => i > 0 && e.t - es[i - 1].t > VISIT_GAP_MS).length,
			minutes: Math.round((es[es.length - 1].t - es[0].t) / 60_000),
			stage: es[es.length - 1].p.done_n ?? '',
			path: pathOf(es, source)
		});
	}

	const total = people.length;
	const events = people.reduce((s, p) => s + p.events, 0);
	const n = (f: (p: Person) => boolean) => people.filter(f).length;

	const days: DayRow[] = (from && to ? daysBetween(from, to) : []).map((day) => {
		const ps = people.filter((p) => p.day === day);
		return {
			day,
			people: ps.length,
			returning: ps.filter((p) => p.returning).length,
			downloaded: ps.filter((p) => p.downloaded).length,
			started: ps.filter((p) => p.started).length,
			completed: ps.filter((p) => p.completed).length,
			events: ps.reduce((s, p) => s + p.events, 0),
			busiest: Math.max(0, ...ps.map((p) => p.events))
		};
	});

	const sourceMap = new Map<string, SourceRow>();
	for (const p of people) {
		let row = sourceMap.get(p.source);
		if (!row) sourceMap.set(p.source, (row = { source: p.source, people: 0, downloaded: 0, started: 0, completed: 0 }));
		row.people++;
		if (p.downloaded) row.downloaded++;
		if (p.started) row.started++;
		if (p.completed) row.completed++;
	}

	const busiest = [...people].sort((a, b) => b.events - a.events).slice(0, 10);
	const staged = people.filter((p) => p.stage);

	// The pace of the last 7 full days of the range (its last day may be partial).
	const full = days.slice(-8, -1);
	const monthlyPace =
		full.length === 7
			? Math.round((inRange.filter((e) => e.day >= full[0].day && e.day <= full[6].day).length / 7) * 30)
			: null;

	return {
		from,
		to,
		days,
		people,
		total,
		events,
		ownLeftOut: own.size,
		funnel: [
			{ label: 'Visited (tapped at least once)', count: total },
			{ label: 'Downloaded a book', count: n((p) => p.downloaded) },
			{ label: 'Used the book online (chapter page)', count: n((p) => p.bookOnline) },
			{ label: 'Opened an exercise', count: n((p) => p.started) },
			{ label: 'Answered at least one question', count: n((p) => p.answered) },
			{ label: 'Finished an exercise', count: n((p) => p.completed) },
			{ label: 'Finished three or more', count: n((p) => p.completedN >= 3) },
			{ label: 'Came back the same day (30+ min later)', count: n((p) => p.visits > 1) },
			{ label: 'Had been here on an earlier day', count: n((p) => p.returning) }
		],
		sources: [...sourceMap.values()].sort((a, b) => b.people - a.people),
		quizzes: [...quizTally]
			.map(([quiz, v]) => ({
				quiz,
				started: v.started.size,
				answered: v.answered.size,
				completed: v.done.size,
				seconds: median(v.secs),
				score: v.share.length ? v.share.reduce((a, b) => a + b, 0) / v.share.length : null
			}))
			.filter((q) => q.started > 0)
			.sort((a, b) => b.started - a.started),
		stages: STAGES.filter((s) => staged.some((p) => p.stage === s)).map((stage) => {
			const ps = staged.filter((p) => p.stage === stage);
			return {
				stage,
				people: ps.length,
				downloaded: ps.filter((p) => p.downloaded).length,
				completed: ps.filter((p) => p.completed).length
			};
		}),
		busiest,
		byEvent: [...eventTally]
			.map(([name, v]) => ({ name, events: v.events, people: v.people.size }))
			.sort((a, b) => b.events - a.events),
		topThreeShare: events ? busiest.slice(0, 3).reduce((s, p) => s + p.events, 0) / events : 0,
		sourceDrift: { drifted, of: sourced },
		monthlyPace,
		updateDay: all.find((e) => e.p.done_n !== undefined)?.day ?? null
	};
}
