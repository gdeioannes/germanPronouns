import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/utils/shuffle_bag.dart';

void main() {
  group('drawFromShuffleBag', () {
    test('never returns the same item twice in a row (pools of 2..12)', () {
      // Sweep many seeds so we exercise the ~12% uniform-pick path and cycle
      // seams, not just one lucky RNG stream.
      for (var poolSize = 2; poolSize <= 12; poolSize++) {
        final pool = List<int>.generate(poolSize, (i) => i);
        for (var seed = 0; seed < 200; seed++) {
          final random = Random(seed);
          final bag = <int>[];
          int? previous;
          for (var draw = 0; draw < 500; draw++) {
            final next = drawFromShuffleBag(
              bag,
              pool,
              avoidRepeat: previous,
              random: random,
            );
            expect(pool, contains(next));
            expect(next, isNot(equals(previous)),
                reason: 'pool=$poolSize seed=$seed draw=$draw repeated $next');
            previous = next;
          }
        }
      }
    });

    test('drains the whole pool before repeating any item', () {
      // With the uniform-pick path disabled, a shuffle bag must show every
      // option exactly once per cycle.
      final pool = List<int>.generate(8, (i) => i);
      final bag = <int>[];
      final random = Random(7);
      final firstCycle = <int>{};
      int? previous;
      for (var i = 0; i < pool.length; i++) {
        final next = drawFromShuffleBag(bag, pool,
            avoidRepeat: previous, randomChance: 0, random: random);
        expect(firstCycle.add(next), isTrue, reason: 'repeat within a cycle');
        previous = next;
      }
      expect(firstCycle, pool.toSet());
    });

    test('a single-item pool is returned every time (repeat is unavoidable)',
        () {
      final bag = <String>[];
      final random = Random(1);
      final a = drawFromShuffleBag(bag, const ['only'],
          avoidRepeat: 'only', random: random);
      expect(a, 'only');
    });

    test('a pool shrunk to one enabled item stops throwing / looping', () {
      // Simulates the learner disabling all-but-one subject: no alternative
      // exists, so the same item is allowed to repeat.
      final bag = <int>[3];
      final random = Random(2);
      final next = drawFromShuffleBag(bag, const [3],
          avoidRepeat: 3, random: random);
      expect(next, 3);
    });

    test('empty pool is a programming error', () {
      expect(
        () => drawFromShuffleBag(<int>[], const <int>[], random: Random(0)),
        throwsArgumentError,
      );
    });
  });
}
