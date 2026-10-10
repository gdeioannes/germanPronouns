import { describe, expect, it } from 'vitest';
import {
	ago,
	compact,
	defaultName,
	matchesSearch,
	reportBody,
	reportTitle,
	unreadThreads,
	validName,
	type ForumThread
} from './forum';

const target = {
	courseId: 'de_cert_a1',
	quizId: 'a1_dativ',
	quizTitle: 'Dativ oder Akkusativ?',
	level: 'A1.2',
	question: { number: 7, total: 15, text: 'Ich gebe ____ Mann das Buch.' }
};

describe('report titles and bodies', () => {
	it('names the subject, the exercise and the question', () => {
		expect(reportTitle('bad_key', target)).toBe('Expected answer is wrong — Dativ oder Akkusativ? (Q 7)');
	});

	it('leaves the question out when none is on screen', () => {
		expect(reportTitle('audio', { ...target, question: null })).toBe('Audio problem — Dativ oder Akkusativ?');
	});

	it('puts the learner’s note first and the place after a rule', () => {
		const body = reportBody('  I typed "dem" and it said wrong.  ', target);
		expect(body.startsWith('I typed "dem" and it said wrong.\n\n—\n')).toBe(true);
		expect(body).toContain('Exercise: Dativ oder Akkusativ? (A1.2)');
		expect(body).toContain('Link: /course/de_cert_a1/quiz/a1_dativ');
		expect(body).toContain('Question 7 of 15');
		expect(body).toContain('“Ich gebe ____ Mann das Buch.”');
	});

	it('works with an empty note', () => {
		expect(reportBody('', target).startsWith('—\n')).toBe(true);
	});
});

describe('names', () => {
	it('defaults to the part before the @, never the address', () => {
		expect(defaultName('maya.k@example.com')).toBe('maya.k');
		expect(defaultName(null)).toBe('Learner');
	});

	it('refuses addresses and one-letter names', () => {
		expect(validName('a@b.c')).toBe(false);
		expect(validName('x')).toBe(false);
		expect(validName('Maya')).toBe(true);
	});
});

describe('unread replies', () => {
	const t = (id: string, replyCount: number, notify = true): ForumThread => ({
		id,
		category: 'report',
		title: id,
		body: '',
		authorUid: 'me',
		authorName: 'me',
		createdAt: 0,
		updatedAt: 0,
		replyCount,
		lastReplyAt: null,
		lastReplyName: null,
		status: 'open',
		notify,
		likeCount: 0
	});

	it('counts topics with more replies than were seen, unless notify is off', () => {
		const mine = [t('a', 2), t('b', 1), t('c', 3, false), t('d', 0)];
		expect(unreadThreads(mine, { a: 2 }).map((x) => x.id)).toEqual(['b']);
	});
});

describe('search', () => {
	it('matches every word, anywhere in title, body or exercise', () => {
		const t = {
			title: 'Expected answer is wrong — Dativ',
			body: 'I typed dem',
			quizTitle: 'W-Fragen',
			authorName: 'maya'
		} as ForumThread;
		expect(matchesSearch(t, 'dativ dem')).toBe(true);
		expect(matchesSearch(t, 'w-fragen')).toBe(true);
		expect(matchesSearch(t, 'akkusativ')).toBe(false);
		expect(matchesSearch(t, '  ')).toBe(true);
	});
});

describe('helpers', () => {
	it('drops undefined values for Firestore', () => {
		expect(compact({ a: 1, b: undefined, c: null })).toEqual({ a: 1, c: null });
	});

	it('describes time plainly', () => {
		const now = 1_000_000_000_000;
		expect(ago(now - 10_000, now)).toBe('just now');
		expect(ago(now - 5 * 60_000, now)).toBe('5 min ago');
		expect(ago(now - 3 * 3_600_000, now)).toBe('3 hours ago');
		expect(ago(now - 2 * 86_400_000, now)).toBe('2 days ago');
	});
});
