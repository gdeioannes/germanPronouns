import 'dart:math';

/// Draws the next item from [pool] using a persistent shuffle bag ([bag]).
///
/// A shuffle bag hands every option out exactly once, in random order, before
/// any option can appear again — so over one cycle the learner sees the whole
/// pool with no early repeats (unlike plain `Random.nextInt`, which clusters).
/// A small [randomChance] of a pure-uniform pick keeps the order from feeling
/// mechanical once a cycle has been memorized.
///
/// The one hard guarantee, honoured on **every** path (bag draw, cycle seam,
/// and the occasional uniform pick): whenever [pool] holds any option other
/// than [avoidRepeat] — the item shown on the previous turn — the result is
/// never [avoidRepeat]. So the same question can never come up twice in a row.
/// A back-to-back repeat happens only when it is unavoidable: a pool of one, or
/// a pool whose every entry equals [avoidRepeat].
///
/// [bag] must be a dedicated, caller-owned list per pool; it is mutated in
/// place (drained and refilled) so the cycle survives across calls. [pool] is
/// not mutated. Pass the [random] source so callers can seed it in tests.
T drawFromShuffleBag<T>(
  List<T> bag,
  List<T> pool, {
  T? avoidRepeat,
  double randomChance = 0.12,
  required Random random,
}) {
  if (pool.isEmpty) {
    throw ArgumentError('drawFromShuffleBag: pool must not be empty');
  }
  if (pool.length == 1) return pool.first;

  // Whether the pool offers anything other than the just-shown item. When it
  // doesn't (e.g. only one distinct value is enabled), a back-to-back repeat is
  // the only possible outcome and we accept it.
  final canAvoidRepeat =
      avoidRepeat != null && pool.any((item) => item != avoidRepeat);

  // An occasional pure-uniform pick keeps selection from feeling mechanical,
  // but it must still respect the no-immediate-repeat rule.
  if (random.nextDouble() < randomChance) {
    var pick = pool[random.nextInt(pool.length)];
    var guard = 0;
    while (canAvoidRepeat && pick == avoidRepeat && guard++ < 16) {
      pick = pool[random.nextInt(pool.length)];
    }
    return pick;
  }

  // Drop stale items (the enabled pool can shrink between calls) and refill +
  // reshuffle when the bag runs dry.
  bag.removeWhere((item) => !pool.contains(item));
  if (bag.isEmpty) {
    bag.addAll(pool);
    bag.shuffle(random);
  }

  // Never hand back the just-shown item. It can sit at the front of the bag at
  // a cycle refill *or* because an out-of-bag uniform pick left it there, so
  // this guard runs on every draw — not only on refill.
  if (canAvoidRepeat && bag.first == avoidRepeat) {
    if (bag.length == 1) {
      // The lone leftover is the repeat; start a fresh cycle so a non-repeat
      // alternative exists to swap in (the abandoned leftover was already seen).
      bag
        ..clear()
        ..addAll(pool)
        ..shuffle(random);
    }
    // Swap the front with the first non-repeat deeper in the bag.
    var i = 1;
    while (i < bag.length && bag[i] == avoidRepeat) {
      i++;
    }
    if (i < bag.length) {
      final swapped = bag[0];
      bag[0] = bag[i];
      bag[i] = swapped;
    }
  }
  return bag.removeAt(0);
}
