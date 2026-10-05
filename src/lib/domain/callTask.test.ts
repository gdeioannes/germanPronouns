import { describe, expect, it } from 'vitest';
import content from '$content/tasks/call_after_party.json';
import {
	checkCall,
	digitsOf,
	erase,
	expected,
	keepRight,
	numberCells,
	meet,
	pickWrongCaller,
	press,
	type CallTaskContent
} from './callTask';

const task = content as CallTaskContent;

describe('numberCells', () => {
	it('keeps spaces and turns hidden digits into numbered slots', () => {
		const cells = numberCells('0176 52', [1, 4]);
		expect(cells).toEqual([
			{ kind: 'digit', digit: '0' },
			{ kind: 'slot', slot: 0 },
			{ kind: 'digit', digit: '7' },
			{ kind: 'digit', digit: '6' },
			{ kind: 'space' },
			{ kind: 'slot', slot: 1 },
			{ kind: 'digit', digit: '2' }
		]);
	});
});

describe('dialling', () => {
	const number = '0176 520 3847';
	const hide = [5, 9];

	it('fills slots in order and erases the last one', () => {
		let typed = ['', ''];
		typed = press(typed, '2');
		typed = press(typed, '4');
		typed = press(typed, '9');
		expect(typed).toEqual(['2', '4']);
		expect(erase(typed)).toEqual(['2', '']);
		expect(erase(typed, [1])).toEqual(['', '4']);
	});

	it('reports the wrong slots and keeps the right ones', () => {
		expect(checkCall(number, hide, ['2', '4'])).toEqual({ correct: true, wrong: [] });
		const result = checkCall(number, hide, ['2', '5']);
		expect(result).toEqual({ correct: false, wrong: [1] });
		expect(keepRight(['2', '5'], result.wrong)).toEqual(['2', '']);
	});
});

describe('meet', () => {
	it('collects each stranger once', () => {
		expect(meet(meet([], 'oma'), 'oma')).toEqual(['oma']);
		expect(meet(['oma'], 'taxi')).toEqual(['oma', 'taxi']);
	});
});

describe('pickWrongCaller', () => {
	it('never repeats the previous stranger', () => {
		expect(pickWrongCaller(3, 1, () => 0.4)).toBe(2);
		expect(pickWrongCaller(3, null, () => 0.4)).toBe(1);
		expect(pickWrongCaller(1, 0)).toBe(0);
	});
});

describe('the content', () => {
	it('reads out exactly the number each round shows (minus any slip it takes back)', () => {
		const words = ['null', 'eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun'];
		for (const round of task.rounds) {
			if (round.correction) expect(round.clip.de).toContain(round.correction);
			const spoken = round.clip.de
				.replace(round.correction ?? '', '')
				.toLowerCase()
				.split(/[^a-zäöüß]+/)
				.filter((w) => words.includes(w))
				.map((w) => String(words.indexOf(w)))
				.join('');
			expect(spoken).toBe(digitsOf(round.number));
			if (round.kind === 'fill') {
				const hide = round.hide ?? [];
				expect(hide.length).toBeGreaterThan(0);
				expect(hide.every((i) => i >= 0 && i < digitsOf(round.number).length)).toBe(true);
				expect(expected(round.number, hide)).toHaveLength(hide.length);
			} else {
				// One right number, the others one sound-alike digit away.
				expect(round.options).toContain(round.number);
				for (const option of round.options ?? []) {
					const diff = [...digitsOf(option)].filter((d, i) => d !== digitsOf(round.number)[i]).length;
					expect(diff).toBeLessThanOrEqual(1);
				}
			}
		}
	});

	it('a self-correcting speaker hides the corrected digit, so the slip is a real trap', () => {
		const tom = task.rounds.find((r) => r.correction)!;
		expect(tom.hide).toContain(8);
	});

	it('has five strangers to collect, each with a face', () => {
		expect(task.wrong).toHaveLength(5);
		expect(new Set(task.wrong.map((w) => w.who)).size).toBe(5);
		expect(task.wrong.every((w) => w.emoji)).toBe(true);
	});
});
