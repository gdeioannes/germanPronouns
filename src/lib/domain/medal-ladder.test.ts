// The medal ladder: pass a run on a step, and the step says the medal.
import { describe, expect, it } from 'vitest';
import {
	emptyLadder,
	ladderMedal,
	ladderStartStep,
	ladderStepEarned,
	parseLadder,
	recordLadderPass,
	scoreMedal
} from './progress';

describe('medal ladder', () => {
	it('earns the step’s medal the first time it is passed, and only then', () => {
		const first = recordLadderPass(emptyLadder(), 1);
		expect(first.earned).toBe('silver');
		expect(ladderMedal(first.record)).toBe('silver');
		expect(recordLadderPass(first.record, 1).earned).toBeNull();
	});

	it('never takes a medal back, and the deck shows its best', () => {
		const gold = recordLadderPass(emptyLadder(), 2).record;
		const thenBronze = recordLadderPass(gold, 0).record;
		expect(ladderMedal(thenBronze)).toBe('gold');
	});

	it('counts an old medal as its steps won, without celebrating them again', () => {
		const old = emptyLadder('silver');
		expect([0, 1, 2].map((i) => ladderStepEarned(old, i))).toEqual([true, true, false]);
		expect(ladderStartStep(old)).toBe(2);
		expect(recordLadderPass(old, 1).earned).toBeNull();
		expect(ladderMedal(old)).toBe('silver');
	});

	it('opens on the easiest step still without its medal', () => {
		expect(ladderStartStep(emptyLadder())).toBe(0);
		const bronze = recordLadderPass(emptyLadder(), 0).record;
		expect(ladderStartStep(bronze)).toBe(1);
		const all = recordLadderPass(recordLadderPass(bronze, 1).record, 2).record;
		expect(ladderStartStep(all)).toBe(2);
	});

	it('reads back what it stored, the streak-era shape, and forgives junk', () => {
		const record = recordLadderPass(emptyLadder('bronze'), 1).record;
		expect(parseLadder(JSON.parse(JSON.stringify(record)))).toEqual(record);
		expect(parseLadder({ streaks: [0, 0, 0], best: [9, 3, 0], legacy: null })).toEqual({
			won: [true, false, false],
			legacy: null
		});
		expect(parseLadder('nope')).toBeNull();
		expect(parseLadder({ won: 'x', legacy: 'platinum' })).toEqual(emptyLadder());
	});
});

describe('score medals', () => {
	it('bronze for passing, silver halfway to full marks, gold for full marks', () => {
		expect(scoreMedal(2, 3, 2 / 3)).toBe('bronze');
		expect(scoreMedal(1, 3, 2 / 3)).toBeNull();
		expect(scoreMedal(5, 6, 2 / 3)).toBe('silver');
		expect(scoreMedal(6, 6, 2 / 3)).toBe('gold');
		expect(scoreMedal(8, 10, 0.8)).toBe('bronze');
		expect(scoreMedal(9, 10, 0.8)).toBe('silver');
		expect(scoreMedal(10, 10, 0.8)).toBe('gold');
		// An AI's score: gold from 90, silver halfway from the pass mark.
		expect(scoreMedal(55, 100, 0.55, 0.9)).toBe('bronze');
		expect(scoreMedal(78, 100, 0.55, 0.9)).toBe('silver');
		expect(scoreMedal(91, 100, 0.55, 0.9)).toBe('gold');
	});
});
