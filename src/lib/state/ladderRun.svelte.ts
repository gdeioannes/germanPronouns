// The medal ladder as a drill plays it: one per mounted quiz. It holds the
// ladder record, the step the learner is on, and the right answers on each
// step in the current run — LADDER_PASS of them on one step pass it and,
// the first time, earn its medal, celebrated on the spot (the medal flies
// into its pill on the switch). Shared by every drill that climbs a ladder,
// so the rule and the moment are the same everywhere.

import {
	emptyLadder,
	LADDER_PASS,
	LADDER_TIERS,
	ladderMedal,
	ladderStartStep,
	ladderStepEarned,
	RUN_LENGTH,
	TIER_LABELS,
	type LadderRecord,
	type RibbonTier
} from '$lib/domain/progress';
import { celebrateMedal } from '$lib/motion/fx.svelte';
import { progress } from './progress.svelte';

/** One rung as a drill names it: what the learner does there. */
export interface LadderStep {
	label: string;
	/** Finishes "Silver is next: …" — lower-case, a full stop at the end. */
	hint: string;
}

/**
 * One answer on the bar. `half` is a picture-hunt find on a later try: worth
 * half a right answer toward the run's score and the medal, and yellow on
 * the bar.
 */
export type RunMark = 'right' | 'half' | 'wrong';

/** What a mark is worth toward the run's score and the medal. */
export const markValue = (mark: RunMark): number => (mark === 'right' ? 1 : mark === 'half' ? 0.5 : 0);

/** The next medal a finished run can go for, and a tap that starts it. */
export interface ClimbOffer {
	tier: RibbonTier;
	go: () => void;
}

/**
 * One step's run of RUN_LENGTH answers. Each step keeps its own, so a switch
 * shows that step's bar: three answers on bronze, then over to silver, finds
 * silver empty, and bronze still has its three on the way back.
 */
export interface StepRun {
	/** Every answer on this step, in order: the bar. */
	results: RunMark[];
	/** The right answers that count toward the medal (not a repeat-list run); a half is 0.5. */
	counted: number;
	/** The longest streak inside this run. */
	bestInRun: number;
	/** The answers missed, for the summary. */
	missed: string[];
}

const freshRun = (): StepRun => ({ results: [], counted: 0, bestInRun: 0, missed: [] });

/** A saved run, checked: anything malformed, empty or already finished is dropped. */
function savedRun(value: unknown): StepRun {
	const v = (value ?? {}) as Partial<StepRun>;
	const results = Array.isArray(v.results)
		? v.results.filter((r): r is RunMark => r === 'right' || r === 'half' || r === 'wrong')
		: [];
	if (results.length === 0 || results.length >= RUN_LENGTH) return freshRun();
	return {
		results,
		counted: Math.min(Number(v.counted) || 0, results.length),
		bestInRun: Number(v.bestInRun) || 0,
		missed: Array.isArray(v.missed) ? v.missed.filter((m) => typeof m === 'string') : []
	};
}

/** The step each quiz was last played on, this visit — so "Try again" keeps it. */
const lastStep = new Map<string, number>();

export class LadderRun {
	record = $state<LadderRecord>(emptyLadder());
	step = $state(0);
	/** Each step's own run, by step. */
	runs = $state<StepRun[]>([freshRun(), freshRun(), freshRun()]);
	/** The medal this run earned, if it did. */
	earned = $state<RibbonTier | null>(null);

	constructor(
		readonly prefix: string,
		readonly steps: readonly LadderStep[]
	) {
		this.step = lastStep.get(prefix) ?? 0;
	}

	/**
	 * Loads the ladder (saving it the first time, which freezes any medal the
	 * old streak rule gave) and settles the step: the one last played this
	 * visit, else the easiest still without its medal.
	 */
	async open(): Promise<void> {
		this.record = await progress.openLadder(this.prefix);
		this.setStep(lastStep.get(this.prefix) ?? ladderStartStep(this.record));
	}

	setStep(step: number): void {
		this.step = step;
		lastStep.set(this.prefix, step);
	}

	/** The run on the step in play. */
	get current(): StepRun {
		return this.runs[this.step];
	}

	/**
	 * Takes back the runs a saved spot had. A spot from before the runs were
	 * kept per step had one bar for every step; it goes to the step in play.
	 */
	restore(spot: unknown): void {
		const s = (spot ?? {}) as {
			runs?: unknown;
			results?: unknown;
			bestInRun?: unknown;
			stepRight?: unknown;
		};
		if (Array.isArray(s.runs)) {
			this.runs = [0, 1, 2].map((i) => savedRun((s.runs as unknown[])[i]));
		} else if (Array.isArray(s.results)) {
			const counted = Array.isArray(s.stepRight) ? s.stepRight[this.step] : 0;
			const runs = [freshRun(), freshRun(), freshRun()];
			runs[this.step] = savedRun({ results: s.results, bestInRun: s.bestInRun, counted });
			this.runs = runs;
		}
	}

	/** What a spot saves of the runs, so leaving mid-run costs nothing. */
	get saved(): { runs: StepRun[] } {
		return { runs: $state.snapshot(this.runs) };
	}

	/**
	 * The runs left to save once the one in play is finished — it starts over,
	 * the other steps keep theirs — or null when nothing is left half-way.
	 */
	afterFinish(): { runs: StepRun[] } | null {
		const runs = $state.snapshot(this.runs).map((r, i) => (i === this.step ? freshRun() : r));
		return runs.some((r) => r.results.length > 0) ? { runs } : null;
	}

	/**
	 * Logs an answer on the step in play: the bar, the streak inside the run
	 * and, for anything short of right, `miss` for the summary. `counting` is
	 * false for a run that earns nothing (a handful of words on the repeat
	 * list). `correct` may be a RunMark: a `half` counts 0.5. Reaching
	 * LADDER_PASS counted passes the step; returns the medal it earned — and
	 * celebrates it — or null.
	 */
	async answer(
		correct: boolean | RunMark,
		streak: number,
		{ counting = true, miss }: { counting?: boolean; miss?: string } = {}
	): Promise<RibbonTier | null> {
		const mark: RunMark = correct === true ? 'right' : correct === false ? 'wrong' : correct;
		const run = this.current;
		run.results = [...run.results, mark];
		run.bestInRun = Math.max(run.bestInRun, streak);
		if (mark !== 'right' && miss !== undefined) run.missed = [...run.missed, miss];
		if (mark === 'wrong' || !counting) return null;
		const before = run.counted;
		run.counted += markValue(mark);
		// Halves can step over the pass mark (7.5 + 1): crossing it is what counts.
		return before < LADDER_PASS && run.counted >= LADDER_PASS ? this.right() : null;
	}

	get medal(): RibbonTier | null {
		return ladderMedal(this.record);
	}

	get tier(): RibbonTier {
		return LADDER_TIERS[this.step];
	}

	/** The step is passed: record it, and celebrate a medal won the first time. */
	private async right(): Promise<RibbonTier | null> {
		const step = this.step;
		const { earned } = await progress.recordLadderPass(this.prefix, step);
		this.record = progress.ladderFor(this.prefix);
		if (!earned) return null;
		this.earned = earned;
		celebrateMedal(
			earned,
			LADDER_PASS,
			document.querySelector(`[data-medal-slot="${earned}"]`),
			this.passLine(step)
		);
		return earned;
	}

	/**
	 * A whole attempt passed on the step in play — for an exercise checked in
	 * one go (a cloze) rather than answer by answer. Returns the medal it
	 * earned, celebrated with `line` as the stamp's small print, or null.
	 */
	async pass(line: string): Promise<RibbonTier | null> {
		const step = this.step;
		const { earned } = await progress.recordLadderPass(this.prefix, step);
		this.record = progress.ladderFor(this.prefix);
		if (!earned) return null;
		this.earned = earned;
		celebrateMedal(earned, 0, document.querySelector(`[data-medal-slot="${earned}"]`), line);
		return earned;
	}

	/** "8 right on Choose": the stamp's small print. */
	passLine(step = this.step): string {
		return `${LADDER_PASS} right on ${this.steps[step].label}`;
	}

	/** What a screen reader hears when a medal is earned. */
	announcement(tier: RibbonTier): string {
		return `${TIER_LABELS[tier]} medal! ${this.passLine()}.`;
	}

	/**
	 * The medal to try for next, once the step in play is won: the first step
	 * above it still without its medal. Null while this step's medal is still
	 * to win, or when every medal above it is already held.
	 */
	get nextUp(): number | null {
		if (!ladderStepEarned(this.record, this.step)) return null;
		for (let s = this.step + 1; s < this.steps.length; s++) {
			if (!ladderStepEarned(this.record, s)) return s;
		}
		return null;
	}

	/**
	 * The finish bar's "Try for silver": the next medal and the way to it — a
	 * fresh run on that step, started by `restart` (the page's Try again).
	 */
	offer(restart?: () => void): ClimbOffer | null {
		const to = this.nextUp;
		if (to === null) return null;
		return {
			tier: LADDER_TIERS[to],
			go: () => {
				this.climb(to);
				restart?.();
			}
		};
	}

	/** The run summary's ladder block; `onClimb` starts a fresh run one step up. */
	summary(counting: boolean, onClimb: (step: number) => void) {
		const step = this.step;
		const up = this.nextUp;
		return {
			label: this.steps[step].label,
			tier: LADDER_TIERS[step],
			right: this.runs[step].counted,
			at: LADDER_PASS,
			counting,
			earned: ladderStepEarned(this.record, step),
			up:
				up === null
					? null
					: {
							label: this.steps[up].label,
							hint: this.steps[up].hint,
							tier: LADDER_TIERS[up],
							onClimb: () => onClimb(up)
						}
		};
	}

	/** Remembers the step above, for the fresh run "Try for silver" starts. */
	climb(to: number): void {
		lastStep.set(this.prefix, to);
	}
}
