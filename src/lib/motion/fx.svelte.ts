// The app's "juice": the screen-level reactions to an answer or a finished
// quiz — confetti, a floating word of praise, an edge glow, a shake.
//
// The pieces live in one rune store that FxLayer (mounted once, in the root
// layout) draws, so any component can fire an effect without owning an
// overlay of its own.
//
// All of it is decoration and all of it switches off together: under the
// OS's reduced-motion setting, or the learner's own "Calm effects" setting
// (html[data-effects="calm"], set before first paint in app.html).
//
// Sounds ride along with the same calls but have their own switch (see
// services/sounds.ts): calm visuals don't mean silence, nor the reverse.

import { prefersReducedMotion } from './index';
import { playSound } from '$lib/services/sounds';

/** True when effects should stay quiet: calm setting or OS reduced motion. */
export function effectsCalm(): boolean {
	if (typeof document === 'undefined') return true;
	return document.documentElement.dataset.effects === 'calm' || prefersReducedMotion();
}

/** Applies the calm setting to the page. Called from the progress store. */
export function applyCalmEffects(calm: boolean): void {
	if (typeof document === 'undefined') return;
	if (calm) document.documentElement.dataset.effects = 'calm';
	else delete document.documentElement.dataset.effects;
}

export interface Confetto {
	id: number;
	x: number;
	drift: number;
	size: number;
	delay: number;
	duration: number;
	spin: number;
	color: string;
	round: boolean;
}

export interface Praise {
	id: number;
	text: string;
	/** Streak shown as a small "×N" badge beside the word, when on a run. */
	streak: number;
	x: number;
	y: number;
	big: boolean;
}

const CONFETTI_COLORS = ['#c9683b', '#1f3a5f', '#a9802a', '#3f5d45', '#e0a458', '#7a9cc6'];

const PRAISE = ['Richtig!', 'Super!', 'Genau!', 'Toll!', 'Prima!', 'Klasse!', 'Sehr gut!', 'Stark!'];

/** Milestone words for a streak that hits a round number. */
const MILESTONES: Record<number, string> = {
	5: 'Fünf in Folge!',
	10: 'Zehn am Stück!',
	15: 'Unaufhaltsam!',
	20: 'Wahnsinn!',
	30: 'Legendär!'
};

let nextId = 1;

class Fx {
	confetti = $state<Confetto[]>([]);
	praises = $state<Praise[]>([]);
	/** 'right' / 'wrong' while an edge glow is showing. */
	glow = $state<'right' | 'wrong' | null>(null);
	glowKey = $state(0);
	/** The big centred stamp on a finished quiz. */
	stamp = $state<{ id: number; text: string } | null>(null);
}

export const fx = new Fx();

/** A full-screen confetti rain plus a "Geschafft!" stamp: a finished quiz. */
export function celebrate(text = 'Geschafft!'): void {
	playSound('complete');
	if (effectsCalm()) return;
	const pieces = Array.from({ length: 90 }, () => ({
		id: nextId++,
		x: Math.random() * 100,
		drift: (Math.random() - 0.5) * 160,
		size: 6 + Math.random() * 7,
		delay: Math.random() * 450,
		duration: 1800 + Math.random() * 1200,
		spin: (Math.random() - 0.5) * 1440,
		color: CONFETTI_COLORS[Math.floor(Math.random() * CONFETTI_COLORS.length)],
		round: Math.random() < 0.3
	}));
	fx.confetti = pieces;
	const stamp = { id: nextId++, text };
	fx.stamp = stamp;
	setTimeout(() => {
		if (fx.confetti[0]?.id === pieces[0].id) fx.confetti = [];
	}, 3600);
	setTimeout(() => {
		if (fx.stamp?.id === stamp.id) fx.stamp = null;
	}, 1600);
}

/**
 * Reacts to one answer: a floating word of praise from `anchor` and a green
 * edge glow when right, a red glow when wrong. `streak` is the run after
 * this answer, so round numbers get their own word.
 */
export function react(correct: boolean, anchor: Element | null | undefined, streak = 0): void {
	playSound(correct ? 'right' : 'wrong', streak);
	if (effectsCalm()) return;
	fx.glow = correct ? 'right' : 'wrong';
	fx.glowKey += 1;
	if (!correct) return;

	const rect = anchor?.getBoundingClientRect();
	const milestone = MILESTONES[streak];
	const praise: Praise = {
		id: nextId++,
		text: milestone ?? PRAISE[Math.floor(Math.random() * PRAISE.length)],
		streak: streak >= 3 ? streak : 0,
		x: rect ? rect.left + rect.width / 2 : window.innerWidth / 2,
		y: rect ? rect.top + Math.min(rect.height / 2, 90) : window.innerHeight / 3,
		big: Boolean(milestone)
	};
	fx.praises = [...fx.praises.slice(-2), praise];
	setTimeout(() => {
		fx.praises = fx.praises.filter((p) => p.id !== praise.id);
	}, 1300);
}

/** Action: shakes the node side to side whenever `key` changes (a miss). */
export function shakeOn(node: HTMLElement, key: unknown) {
	let last = key;
	return {
		update(next: unknown) {
			if (next === last) return;
			last = next;
			if (effectsCalm() || typeof node.animate !== 'function') return;
			node.animate(
				[
					{ transform: 'translateX(0)' },
					{ transform: 'translateX(-9px)' },
					{ transform: 'translateX(8px)' },
					{ transform: 'translateX(-5px)' },
					{ transform: 'translateX(3px)' },
					{ transform: 'translateX(0)' }
				],
				{ duration: 380, easing: 'ease-out' }
			);
		}
	};
}

/** Action: a springy bump whenever `key` changes (a streak counter going up). */
export function bumpOn(node: HTMLElement, key: unknown) {
	let last = key;
	return {
		update(next: unknown) {
			if (next === last) return;
			const up = typeof next === 'number' && typeof last === 'number' && next > last;
			last = next;
			if (!up || effectsCalm() || typeof node.animate !== 'function') return;
			node.animate(
				[
					{ transform: 'scale(1)' },
					{ transform: 'scale(1.45)', color: 'var(--accent)' },
					{ transform: 'scale(1)' }
				],
				{ duration: 420, easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)' }
			);
		}
	};
}

/** How hot the streak flame burns: 0 cold, 1 lit, 2 hot, 3 blazing. */
export function heat(streak: number): 0 | 1 | 2 | 3 {
	if (streak >= 15) return 3;
	if (streak >= 7) return 2;
	if (streak > 0) return 1;
	return 0;
}
