// Ported from lib/utils/shuffle_bag.dart.
//
// A shuffle bag hands every option out exactly once, in random order, before
// any can repeat — so over one cycle the learner sees the whole pool with no
// early repeats (unlike a plain uniform pick, which clusters). A small chance
// of a uniform pick keeps the order from feeling mechanical once a cycle has
// been memorised.
//
// The one hard guarantee, honoured on every path: whenever the pool holds any
// option other than `avoidRepeat`, the result is never `avoidRepeat`. The same
// question can never come up twice in a row unless that is unavoidable.

export interface DrawOptions<T> {
	/** The item shown on the previous turn, never returned again immediately. */
	avoidRepeat?: T;
	/** Chance of an out-of-bag uniform pick. */
	randomChance?: number;
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
 * place (drained and refilled) so the cycle survives across calls. `pool` is
 * never mutated.
 */
export function drawFromShuffleBag<T>(
	bag: T[],
	pool: readonly T[],
	options: DrawOptions<T> = {}
): T {
	const { avoidRepeat, randomChance = 0.12, random = Math.random } = options;

	if (pool.length === 0) throw new Error('drawFromShuffleBag: pool must not be empty');
	if (pool.length === 1) return pool[0];

	// Whether the pool offers anything other than the just-shown item. When it
	// doesn't, a back-to-back repeat is the only possible outcome.
	const canAvoidRepeat =
		avoidRepeat !== undefined && pool.some((item) => item !== avoidRepeat);

	if (random() < randomChance) {
		let pick = pool[Math.floor(random() * pool.length)];
		let guard = 0;
		while (canAvoidRepeat && pick === avoidRepeat && guard++ < 16) {
			pick = pool[Math.floor(random() * pool.length)];
		}
		return pick;
	}

	// Drop stale items (the enabled pool can shrink between calls) and refill
	// when the bag runs dry.
	for (let i = bag.length - 1; i >= 0; i--) {
		if (!pool.includes(bag[i])) bag.splice(i, 1);
	}
	if (bag.length === 0) {
		bag.push(...pool);
		shuffle(bag, random);
	}

	// The just-shown item can sit at the front either at a cycle refill or
	// because an out-of-bag pick left it there, so this guard runs every draw.
	if (canAvoidRepeat && bag[0] === avoidRepeat) {
		if (bag.length === 1) {
			// The lone leftover is the repeat; start a fresh cycle so a
			// non-repeat alternative exists to swap in.
			bag.length = 0;
			bag.push(...pool);
			shuffle(bag, random);
		}
		let i = 1;
		while (i < bag.length && bag[i] === avoidRepeat) i++;
		if (i < bag.length) [bag[0], bag[i]] = [bag[i], bag[0]];
	}

	return bag.shift() as T;
}
