// A practice reminder the learner adds to their own calendar.
//
// The app has no server to send notifications from, so the calendar does the
// reminding: a weekly repeating event on the days and at the time they pick,
// with a link back to the course. Times are "floating" (no timezone), so the
// event rings at 19:00 wherever the learner's device happens to be.

export type Weekday = 'MO' | 'TU' | 'WE' | 'TH' | 'FR' | 'SA' | 'SU';

/** Monday first, as a European learner expects. */
export const WEEKDAYS: { code: Weekday; short: string; long: string }[] = [
	{ code: 'MO', short: 'Mon', long: 'Monday' },
	{ code: 'TU', short: 'Tue', long: 'Tuesday' },
	{ code: 'WE', short: 'Wed', long: 'Wednesday' },
	{ code: 'TH', short: 'Thu', long: 'Thursday' },
	{ code: 'FR', short: 'Fri', long: 'Friday' },
	{ code: 'SA', short: 'Sat', long: 'Saturday' },
	{ code: 'SU', short: 'Sun', long: 'Sunday' }
];

export interface ReminderPlan {
	days: Weekday[];
	/** "HH:MM", 24-hour, as an <input type="time"> gives it. */
	time: string;
	minutes: number;
	title: string;
	/** Where tapping the reminder takes the learner. */
	url: string;
}

const JS_DAY: Record<Weekday, number> = { SU: 0, MO: 1, TU: 2, WE: 3, TH: 4, FR: 5, SA: 6 };

const pad = (n: number) => String(n).padStart(2, '0');

/** Local date-time in the calendar format, without a zone: 20261005T190000. */
function stamp(d: Date): string {
	return (
		`${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}` +
		`T${pad(d.getHours())}${pad(d.getMinutes())}00`
	);
}

/** Days in calendar order, whatever order they were ticked in. */
function ordered(days: Weekday[]): Weekday[] {
	return WEEKDAYS.map((w) => w.code).filter((c) => days.includes(c));
}

/**
 * The first session on or after `now`: a weekly rule still needs a real start,
 * and it has to fall on one of the chosen days or some calendars add a stray
 * extra event on the start date.
 */
export function firstSession(plan: Pick<ReminderPlan, 'days' | 'time'>, now: Date): Date {
	const [h, m] = plan.time.split(':').map(Number);
	const wanted = new Set(plan.days.map((d) => JS_DAY[d]));
	for (let i = 0; i < 8; i++) {
		const d = new Date(now.getFullYear(), now.getMonth(), now.getDate() + i, h, m);
		if (wanted.has(d.getDay()) && d >= now) return d;
	}
	throw new Error('A reminder needs at least one day.');
}

function slot(plan: ReminderPlan, now: Date): [string, string, string] {
	const start = firstSession(plan, now);
	const end = new Date(start.getTime() + plan.minutes * 60_000);
	return [stamp(start), stamp(end), `RRULE:FREQ=WEEKLY;BYDAY=${ordered(plan.days).join(',')}`];
}

function description(plan: ReminderPlan): string {
	return `A few minutes of German. Pick up where you left off: ${plan.url}`;
}

/** Text values in a calendar file escape \ ; , and newlines. */
function escapeText(text: string): string {
	return text.replace(/\\/g, '\\\\').replace(/;/g, '\\;').replace(/,/g, '\\,').replace(/\n/g, '\\n');
}

/** Calendar files cap lines at 75 octets; longer ones continue after CRLF + space. */
function fold(line: string): string {
	const bytes = new TextEncoder().encode(line);
	if (bytes.length <= 75) return line;
	const parts: string[] = [];
	let current = '';
	let size = 0;
	for (const ch of line) {
		const n = new TextEncoder().encode(ch).length;
		if (size + n > (parts.length ? 74 : 75)) {
			parts.push(current);
			current = '';
			size = 0;
		}
		current += ch;
		size += n;
	}
	parts.push(current);
	return parts.join('\r\n ');
}

/** A .ics file for Apple Calendar, Outlook and everything else. */
export function reminderIcs(plan: ReminderPlan, now = new Date()): string {
	const [start, end, rule] = slot(plan, now);
	const created = now.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}/, '');
	const lines = [
		'BEGIN:VCALENDAR',
		'VERSION:2.0',
		'PRODID:-//Language Quiz//Practice reminder//EN',
		'CALSCALE:GREGORIAN',
		'METHOD:PUBLISH',
		'BEGIN:VEVENT',
		`UID:practice-${created}@languagequiz.org`,
		`DTSTAMP:${created}`,
		`DTSTART:${start}`,
		`DTEND:${end}`,
		rule,
		`SUMMARY:${escapeText(plan.title)}`,
		`DESCRIPTION:${escapeText(description(plan))}`,
		`URL:${plan.url}`,
		'BEGIN:VALARM',
		'ACTION:DISPLAY',
		`DESCRIPTION:${escapeText(plan.title)}`,
		'TRIGGER:PT0M',
		'END:VALARM',
		'END:VEVENT',
		'END:VCALENDAR'
	];
	return lines.map(fold).join('\r\n') + '\r\n';
}

/** Opens Google Calendar's "new event" form, filled in and repeating. */
export function reminderGoogleUrl(plan: ReminderPlan, now = new Date()): string {
	const [start, end, rule] = slot(plan, now);
	const params = new URLSearchParams({
		action: 'TEMPLATE',
		text: plan.title,
		dates: `${start}/${end}`,
		details: description(plan),
		recur: rule
	});
	return `https://calendar.google.com/calendar/render?${params}`;
}
