import { describe, expect, it } from 'vitest';
import { buildReport, mergeExports, parseCsv, readExport } from './analyticsReport';

const HEAD =
	'"timestamp","user_id","session_id","event_name","string_props","numeric_props","os_name","country_code","country_name","region_name"';

/** One CSV row; props are written the way Aptabase exports them (JSON with doubled quotes). */
function row(
	time: string,
	user: string,
	name: string,
	props: Record<string, string> = {},
	nums: Record<string, number> = {},
	country = 'FR'
): string {
	const q = (o: object) => `"${JSON.stringify(o).replaceAll('"', '""')}"`;
	return [`"${time}"`, `"${user}"`, '"s"', `"${name}"`, q(props), q(nums), '"iOS"', `"${country}"`, '"France"', '"Paris"'].join(',');
}

const csv = (rows: string[]) => [HEAD, ...rows].join('\n');

describe('parseCsv', () => {
	it('keeps commas, quotes and newlines inside quoted fields', () => {
		expect(parseCsv('"a,b","say ""hi""","two\nlines"\nx,y,z')).toEqual([
			['a,b', 'say "hi"', 'two\nlines'],
			['x', 'y', 'z']
		]);
	});
});

describe('readExport', () => {
	it('refuses a file that is not an export', () => {
		expect(() => readExport('name,score\nA,1')).toThrow(/not an Aptabase export/);
	});
});

describe('buildReport', () => {
	const events = readExport(
		csv([
			// Day 1 — A: from ChatGPT, downloads, then a reload makes the source "direct".
			row('2026-11-20 10:00:00', 'A', 'screen_view', { source: 'chatgpt.com', route: '/books', days_since_first: '0' }),
			row('2026-11-20 10:01:00', 'A', 'book_download', { source: 'direct', book: 'A1.1', days_since_first: '0' }),
			// Day 1 — B: a book code, starts and finishes an exercise, comes back 40 minutes later.
			row('2026-11-20 11:00:00', 'B', 'quiz_started', { source: 'book', quiz: 'q1', days_since_first: '1-7' }),
			row('2026-11-20 11:05:00', 'B', 'quiz_completed', { source: 'book', quiz: 'q1', done_n: '1-4' }, { seconds: 120, right: 8, total: 10 }),
			row('2026-11-20 11:45:00', 'B', 'screen_view', { source: 'book', route: '/', done_n: '1-4' }),
			// Day 2 — C: opens an exercise, answers two questions, leaves.
			row('2026-11-21 09:00:00', 'C', 'quiz_started', { source: 'direct', quiz: 'q1', days_since_first: '0' }),
			row('2026-11-21 09:02:00', 'C', 'quiz_left', { source: 'direct', quiz: 'q1' }, { answered: 2, seconds: 60 }),
			// Day 2 — the owner: opened the back office.
			row('2026-11-21 12:00:00', 'ME', 'screen_view', { source: 'direct', route: '/backoffice' }, {}, 'DE')
		])
	);

	it('counts people, not events, and leaves the owner out', () => {
		const r = buildReport(events);
		expect(r.total).toBe(3);
		expect(r.ownLeftOut).toBe(1);
		expect(r.events).toBe(7);
		const count = (label: string) => r.funnel.find((f) => f.label.startsWith(label))?.count;
		expect(count('Downloaded')).toBe(1);
		expect(count('Opened an exercise')).toBe(2);
		expect(count('Answered')).toBe(2);
		expect(count('Finished an exercise')).toBe(1);
		expect(count('Came back the same day')).toBe(1);
		expect(count('Had been here')).toBe(1);
	});

	it('credits a person to their first known source, and counts the drift', () => {
		const r = buildReport(events);
		expect(r.sources.find((s) => s.source === 'chatgpt.com')).toMatchObject({ people: 1, downloaded: 1 });
		expect(r.sourceDrift).toEqual({ drifted: 1, of: 5 });
	});

	it('reads time and score off finished runs', () => {
		const q = buildReport(events).quizzes[0];
		expect(q).toMatchObject({ quiz: 'q1', started: 2, answered: 2, completed: 1, seconds: 120 });
		expect(q.score).toBeCloseTo(0.8);
	});

	it('narrows to a date range, and lists every day in it', () => {
		const r = buildReport(events, { from: '2026-11-21', to: '2026-11-21' });
		expect(r.total).toBe(1);
		expect(r.days.map((d) => d.day)).toEqual(['2026-11-21']);
		expect(buildReport(events).days).toHaveLength(2);
	});

	it('narrows to one source', () => {
		const r = buildReport(events, { source: 'book' });
		expect(r.total).toBe(1);
		expect(r.people[0].stage).toBe('1-4');
	});

	it('reads each visit as a path: landed, first thing, how it ended', () => {
		const path = (id: string) => buildReport(events).people.find((p) => p.id === id)?.path;
		expect(path('A')).toEqual(['Books page', 'Downloaded a book', 'Left with the download']);
		expect(path('B')).toEqual(['A book code', 'Opened an exercise', 'Finished an exercise']);
		expect(path('C')).toEqual(['Another page', 'Opened an exercise', 'Opened an exercise, did not finish']);
	});

	it('can count the owner too', () => {
		expect(buildReport(events, { includeOwn: true }).total).toBe(4);
	});

	it('knows when the tracking update starts', () => {
		expect(buildReport(events).updateDay).toBe('2026-11-20');
	});
});

describe('mergeExports', () => {
	it('counts an event that is in two files once', () => {
		const a = readExport(csv([row('2026-11-20 10:00:00', 'A', 'screen_view', { route: '/' })]));
		const b = readExport(
			csv([row('2026-11-20 10:00:00', 'A', 'screen_view', { route: '/' }), row('2026-12-01 10:00:00', 'A', 'screen_view', { route: '/' })])
		);
		expect(mergeExports([a, b])).toHaveLength(2);
	});
});
