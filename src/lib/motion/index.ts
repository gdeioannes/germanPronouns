// The motion vocabulary. Everything animated in the app comes from here, so
// the whole thing moves with one personality rather than each component
// inventing its own timing.
//
// Two rules the Flutter app also followed:
//   * Motion is decoration. Nothing here carries meaning on its own, so
//     reducing it to nothing loses no information — see `prefersReducedMotion`.
//   * Arrivals ease out; celebrations overshoot slightly.

import { cubicOut, backOut } from 'svelte/easing';
import type { TransitionConfig } from 'svelte/transition';

export const DURATION = { fast: 140, medium: 260, slow: 420 } as const;

/** True when the OS asks for less motion. Safe during SSR (returns false). */
export function prefersReducedMotion(): boolean {
	if (typeof window === 'undefined' || !window.matchMedia) return false;
	return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
}

/** Collapses a duration to nothing when the OS asks for reduced motion. */
export function motionDuration(ms: number): number {
	return prefersReducedMotion() ? 0 : ms;
}

/**
 * The app's standard arrival: a short rise with a fade. Used for feedback
 * lines, verdicts and panels — anything that appears in response to an action.
 */
export function rise(
	node: Element,
	{ y = 8, duration = DURATION.medium, delay = 0 } = {}
): TransitionConfig {
	const existing = getComputedStyle(node).transform;
	const base = existing === 'none' ? '' : existing;
	return {
		delay,
		duration: motionDuration(duration),
		easing: cubicOut,
		css: (t, u) => `transform: ${base} translateY(${u * y}px); opacity: ${t};`
	};
}

/**
 * A celebratory pop — overshoots and settles. Reserved for genuinely good
 * news (a correct answer, a completed quiz), so the overshoot stays meaningful.
 */
export function pop(
	node: Element,
	{ from = 0.82, duration = DURATION.slow, delay = 0 } = {}
): TransitionConfig {
	return {
		delay,
		duration: motionDuration(duration),
		easing: backOut,
		css: (t) => `transform: scale(${from + (1 - from) * t}); opacity: ${Math.min(1, t * 2)};`
	};
}

/** One particle in a celebration burst. */
export interface Spark {
	id: number;
	/** Degrees, 0 = up. */
	angle: number;
	distance: number;
	size: number;
	delay: number;
	color: string;
	spin: number;
}

const SPARK_COLORS = ['#c9683b', '#1f3a5f', '#a9802a', '#3f5d45'];

/**
 * Builds a burst of particles thrown outward from a point.
 *
 * The Flutter app fired confetti on a completed streak lap; this is the same
 * beat. Scaled by `count` so a bigger achievement gets a bigger burst without
 * a second implementation.
 */
export function makeBurst(count = 18, seed = Math.random): Spark[] {
	if (prefersReducedMotion()) return [];
	return Array.from({ length: count }, (_, i) => {
		// Spread evenly around the circle, then jitter, so the burst reads as
		// radial rather than random-clumpy.
		const spread = (360 / count) * i + (seed() - 0.5) * (360 / count);
		return {
			id: i,
			angle: spread,
			distance: 45 + seed() * 55,
			size: 5 + seed() * 5,
			delay: seed() * 90,
			color: SPARK_COLORS[i % SPARK_COLORS.length],
			spin: (seed() - 0.5) * 540
		};
	});
}
