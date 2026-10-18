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

/** The step each quiz was last played on, this visit — so "Try again" keeps it. */
const lastStep = new Map<string, number>();

export class LadderRun {
	record = $state<LadderRecord>(emptyLadder());
	step = $state(0);
	/** Right answers on each step in this run. */
	stepRight = $state<[number, number, number]>([0, 0, 0]);
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

	/** Takes back the per-step counts a saved, unfinished run had. */
	restore(saved: unknown): void {
		if (!Array.isArray(saved)) return;
		this.stepRight = [0, 1, 2].map((i) => Number(saved[i]) || 0) as [number, number, number];
	}

	get medal(): RibbonTier | null {
		return ladderMedal(this.record);
	}

	get tier(): RibbonTier {
		return LADDER_TIERS[this.step];
	}

	/**
	 * One right answer on the step in play. `counting` is false for a run
	 * that earns nothing (a handful of words on the repeat list). Returns the
	 * medal it earned — and celebrates it — or null.
	 */
	async right(counting: boolean): Promise<RibbonTier | null> {
		if (!counting) return null;
		const step = this.step;
		const onStep = [...this.stepRight] as [number, number, number];
		onStep[step] += 1;
		this.stepRight = onStep;
		if (onStep[step] !== LADDER_PASS) return null;
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

	/** The run summary's ladder block; `onClimb` starts a fresh run one step up. */
	summary(counting: boolean, onClimb: (step: number) => void) {
		const step = this.step;
		const up = step + 1 < this.steps.length ? step + 1 : null;
		return {
			label: this.steps[step].label,
			tier: LADDER_TIERS[step],
			right: this.stepRight[step],
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
