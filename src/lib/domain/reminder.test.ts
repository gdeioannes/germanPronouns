import { describe, expect, it } from 'vitest';
import { firstSession, reminderGoogleUrl, reminderIcs, type ReminderPlan } from './reminder';

// Sunday 4 October 2026, 20:00 local time.
const NOW = new Date(2026, 9, 4, 20, 0);

const plan: ReminderPlan = {
	days: ['FR', 'MO', 'WE'],
	time: '19:00',
	minutes: 15,
	title: 'German practice',
	url: 'https://languagequiz.org/course/de_cert_a1'
};

describe('firstSession', () => {
	it('starts on the next chosen day', () => {
		expect(firstSession(plan, NOW)).toEqual(new Date(2026, 9, 5, 19, 0));
	});

	it('uses today when the time is still ahead', () => {
		expect(firstSession({ days: ['SU'], time: '21:30' }, NOW)).toEqual(new Date(2026, 9, 4, 21, 30));
	});

	it('rolls a full week when today’s time has passed', () => {
		expect(firstSession({ days: ['SU'], time: '07:00' }, NOW)).toEqual(new Date(2026, 9, 11, 7, 0));
	});

	it('refuses a reminder with no days', () => {
		expect(() => firstSession({ days: [], time: '07:00' }, NOW)).toThrow();
	});
});

describe('reminderIcs', () => {
	const ics = reminderIcs(plan, NOW);

	it('repeats weekly on the chosen days, in calendar order', () => {
		expect(ics).toContain('RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR');
		expect(ics).toContain('DTSTART:20261005T190000');
		expect(ics).toContain('DTEND:20261005T191500');
	});

	it('uses CRLF line endings and folds every line to 75 octets', () => {
		const lines = ics.split('\r\n');
		expect(ics.replace(/\r\n/g, '')).not.toContain('\n');
		for (const line of lines) expect(new TextEncoder().encode(line).length).toBeLessThanOrEqual(75);
	});

	it('carries the link back to the course', () => {
		expect(ics.replace(/\r\n /g, '')).toContain(plan.url);
	});
});

describe('reminderGoogleUrl', () => {
	it('fills in Google Calendar’s new-event form with the rule', () => {
		const url = new URL(reminderGoogleUrl(plan, NOW));
		expect(url.hostname).toBe('calendar.google.com');
		expect(url.searchParams.get('dates')).toBe('20261005T190000/20261005T191500');
		expect(url.searchParams.get('recur')).toBe('RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR');
	});
});
