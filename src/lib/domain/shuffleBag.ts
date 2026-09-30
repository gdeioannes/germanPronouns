// Ported from lib/utils/shuffle_bag.dart.
//
// A shuffle bag hands every option out exactly once, in random order, before
// any can repeat — so over one round the learner sees the whole pool with no
// early repeats (unlike a plain uniform pick, which clusters). When the bag
// runs dry it is refilled and shuffled again for the next round.
//
// The one hard guarantee: whenever the pool holds any option other than
// `avoidRepeat`, the result is never `avoidRepeat` — including across the seam
// between two rounds. The same question can never come up twice in a row
// unless that is unavoidable.
//
// Items are compared by identity, so `avoidRepeat` must be the very object the
// pool holds: keep the current question in `$state.raw`, never `$state`, whose
// deep proxy is a different object and silently defeats the guard.

export interface DrawOptions<T> {
	/** The item shown on the previous turn, never returned again immediately. */
	avoidRepeat?: T;
	/** Injectable for deterministic tests. */
	random?: () => number;
}

function shuffle<T>(items: T[], random: () => number): void {
	for (let i = items.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[items[i], items[j]] = [items[j], items[i]];
	}
}

/**
 * Draws the next item from `pool` using the persistent `bag`.
 *
 * `bag` must be a dedicated, caller-owned array per pool; it is mutated in
 * place (drained and refilled) so the round survives across calls. `pool` is
 * never mutated.
 */
export function drawFromShuffleBag<T>(
	bag: T[],
	pool: readonly T[],
	options: DrawOptions<T> = {}
): T {
	const { avoidRepeat, random = Math.random } = options;

	if (pool.length === 0) throw new Error('drawFromShuffleBag: pool must not be empty');
	if (pool.length === 1) return pool[0];

	// Drop stale items (the enabled pool can shrink between calls) and refill
	// when the bag runs dry.
	for (let i = bag.length - 1; i >= 0; i--) {
		if (!pool.includes(bag[i])) bag.splice(i, 1);
	}
	if (bag.length === 0) {
		bag.push(...pool);
		shuffle(bag, random);
	}

	// A fresh round can open with the item that closed the last one; swap it
	// with the next one so the seam never repeats back to back.
	if (avoidRepeat !== undefined && bag[0] === avoidRepeat) {
		let i = 1;
		while (i < bag.length && bag[i] === avoidRepeat) i++;
		if (i < bag.length) [bag[0], bag[i]] = [bag[i], bag[0]];
	}

	return bag.shift() as T;
}
