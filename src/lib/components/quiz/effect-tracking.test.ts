// A source scan, not a behaviour test — the project has no component-test
// harness, and this bug is invisible to one anyway.
//
// The bug it guards against: `progress.statsFor()` reads the `progress.stats`
// rune *synchronously*, before its first `await`. Calling it inside an
// `$effect` — even from inside an async IIFE, whose head still runs in the
// effect's tracking scope — subscribes that effect to the stats. Every
// answered question writes those stats, so the effect re-runs. In the
// dictation that meant `restart()` fired after every answer and the run went
// back to its first line: the learner heard line one over and over while the
// question counter kept climbing, because the saved spot restored it.
//
// The fix at each call site is `untrack(() => …)`. This test fails if a quiz
// component calls statsFor in an effect without it.

import { readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it } from 'vitest';

const DIR = join(process.cwd(), 'src/lib/components/quiz');

/**
 * Comments out, so prose about `statsFor` — including the explanations at the
 * fixed call sites — is never mistaken for a call.
 */
function stripComments(source: string): string {
	return source.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '');
}

/** The `$effect(` bodies in a source file, by brace matching. */
function effectBodies(source: string): string[] {
	const bodies: string[] = [];
	let from = 0;
	for (;;) {
		const start = source.indexOf('$effect(', from);
		if (start === -1) return bodies;
		let depth = 0;
		let i = source.indexOf('(', start);
		const open = i;
		for (; i < source.length; i++) {
			if (source[i] === '(') depth++;
			else if (source[i] === ')') {
				depth--;
				if (depth === 0) break;
			}
		}
		bodies.push(source.slice(open, i));
		from = i;
	}
}

describe('quiz components: effects that read persisted stats', () => {
	const files = readdirSync(DIR).filter((name) => name.endsWith('.svelte'));

	it('finds the quiz components to scan', () => {
		expect(files.length).toBeGreaterThan(5);
	});

	for (const name of files) {
		const source = stripComments(readFileSync(join(DIR, name), 'utf8'));
		if (!source.includes('statsFor')) continue;

		it(`${name} wraps statsFor in untrack inside every effect`, () => {
			for (const body of effectBodies(source)) {
				if (!body.includes('statsFor')) continue;
				// `untrack` must open before the call, or the synchronous read of
				// progress.stats lands in this effect's dependencies.
				expect(
					body.indexOf('untrack('),
					`${name}: $effect calls progress.statsFor() outside untrack(). ` +
						'That subscribes the effect to progress.stats, so every answer ' +
						're-runs it — see the comment at the top of this file.'
				).toBeGreaterThanOrEqual(0);
				expect(body.indexOf('untrack(')).toBeLessThan(body.indexOf('statsFor'));
			}
		});
	}
});
