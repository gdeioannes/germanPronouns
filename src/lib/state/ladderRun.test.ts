import { describe, expect, it } from 'vitest';
import { LadderRun } from './ladderRun.svelte';

const STEPS = [
	{ label: 'Choose', hint: '' },
	{ label: 'Type', hint: '' },
	{ label: 'No help', hint: '' }
];

async function rights(run: LadderRun, n: number) {
	for (let i = 0; i < n; i++) await run.answer(true, i + 1);
}

describe('LadderRun: each step keeps its own run', () => {
	it('3 on bronze, 3 on silver, 5 on gold — bronze still has its 3', async () => {
		const run = new LadderRun('test_steps_', STEPS);
		await rights(run, 3);
		run.setStep(1);
		expect(run.current.results).toEqual([]);
		await rights(run, 3);
		run.setStep(2);
		expect(run.current.results).toEqual([]);
		await rights(run, 5);
		run.setStep(0);
		expect(run.current.results).toHaveLength(3);
		expect(run.current.counted).toBe(3);
		expect(run.runs.map((r) => r.results.length)).toEqual([3, 3, 5]);
	});

	it('a miss is kept on its own step', async () => {
		const run = new LadderRun('test_miss_', STEPS);
		await run.answer(false, 0, { miss: 'der Tisch' });
		run.setStep(1);
		expect(run.current.missed).toEqual([]);
		run.setStep(0);
		expect(run.current.missed).toEqual(['der Tisch']);
	});

	it('a repeat-list answer fills the bar but does not count', async () => {
		const run = new LadderRun('test_count_', STEPS);
		await run.answer(true, 1, { counting: false });
		expect(run.current.results).toEqual(['right']);
		expect(run.current.counted).toBe(0);
	});

	it('saves and restores every step, and a finished step starts over', async () => {
		const run = new LadderRun('test_save_', STEPS);
		await rights(run, 2);
		run.setStep(1);
		await rights(run, 4);
		const again = new LadderRun('test_save_', STEPS);
		again.restore(run.saved);
		expect(again.runs.map((r) => r.results.length)).toEqual([2, 4, 0]);
		expect(run.afterFinish()?.runs.map((r) => r.results.length)).toEqual([2, 0, 0]);
	});

	it('nothing left half-way after a finish saves nothing', async () => {
		const run = new LadderRun('test_none_', STEPS);
		await rights(run, 2);
		expect(run.afterFinish()).toBeNull();
	});

	it('an old single-bar spot goes to the step in play', () => {
		const run = new LadderRun('test_legacy_', STEPS);
		run.setStep(1);
		run.restore({ results: ['right', 'wrong', 'right'], bestInRun: 1, stepRight: [0, 2, 0] });
		expect(run.runs.map((r) => r.results.length)).toEqual([0, 3, 0]);
		expect(run.runs[1].counted).toBe(2);
	});
});
