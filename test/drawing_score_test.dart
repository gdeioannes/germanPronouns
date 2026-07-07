import 'dart:ui' show Offset, Rect;

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/services/drawing_score.dart';
import 'package:german_pronouns_articles/widgets/completion_ribbon.dart';

/// The drawing-overlap scorer: mask rasterization, the two-sided
/// coverage/precision score, the from-memory bounding-box fit, and the
/// overlap → ribbon-tier thresholds (gold 65 / silver 50 / bronze 35).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A wide horizontal pen line through the vertical center.
  List<List<Offset>> hLine({double y = 0.5}) => [
        [Offset(0.1, y), Offset(0.9, y)],
      ];

  // An X spanning the given square region — enough structure that shifting
  // it around is visible to the score.
  List<List<Offset>> cross(double lo, double hi) => [
        [Offset(lo, lo), Offset(hi, hi)],
        [Offset(hi, lo), Offset(lo, hi)],
      ];

  group('ribbonTierForOverlap', () {
    test('gold at 65%, silver at 50%, bronze at 35%, nothing below', () {
      expect(ribbonTierForOverlap(1.0), RibbonTier.gold);
      expect(ribbonTierForOverlap(0.65), RibbonTier.gold);
      expect(ribbonTierForOverlap(0.64), RibbonTier.silver);
      expect(ribbonTierForOverlap(0.50), RibbonTier.silver);
      expect(ribbonTierForOverlap(0.49), RibbonTier.bronze);
      expect(ribbonTierForOverlap(0.35), RibbonTier.bronze);
      expect(ribbonTierForOverlap(0.34), isNull);
      expect(ribbonTierForOverlap(0.0), isNull);
    });
  });

  group('maskFromStrokes', () {
    test('stamps ink along the stroke and nowhere else', () {
      final mask = maskFromStrokes(hLine(), size: 64);
      expect(mask.isEmpty, isFalse);
      // Ink on the line's row, none in the far corner.
      expect(mask.get(32, 32), isTrue);
      expect(mask.get(2, 2), isFalse);
    });

    test('empty strokes give an empty mask', () {
      expect(maskFromStrokes([], size: 64).isEmpty, isTrue);
      expect(maskFromStrokes([[]], size: 64).isEmpty, isTrue);
    });

    test('normalizedBounds boxes the ink', () {
      final bounds = maskFromStrokes(hLine(), size: 64).normalizedBounds()!;
      expect(bounds.left, closeTo(0.1, 0.05));
      expect(bounds.right, closeTo(0.9, 0.05));
      expect(bounds.center.dy, closeTo(0.5, 0.05));
      expect(maskFromStrokes([], size: 64).normalizedBounds(), isNull);
    });
  });

  group('scoreMasks', () {
    test('a perfect trace scores ~100% both ways', () {
      final mask = maskFromStrokes(cross(0.1, 0.9));
      final score = scoreMasks(mask, mask);
      expect(score.coverage, 1.0);
      expect(score.precision, 1.0);
      expect(score.overlap, 1.0);
      expect(score.percent, 100);
    });

    test('a small wobble stays within the tolerance band', () {
      final template = maskFromStrokes(hLine(y: 0.50));
      final ink = maskFromStrokes(hLine(y: 0.53));
      final score = scoreMasks(template, ink);
      expect(score.coverage, greaterThan(0.9));
      expect(score.precision, greaterThan(0.9));
    });

    test('ink far away from the template scores ~0', () {
      final template = maskFromStrokes(hLine(y: 0.2));
      final ink = maskFromStrokes(hLine(y: 0.8));
      expect(scoreMasks(template, ink).overlap, lessThan(0.05));
    });

    test('drawing only half the character caps coverage near 50%', () {
      final template = maskFromStrokes(cross(0.1, 0.9));
      // Only one arm of the X.
      final ink = maskFromStrokes([
        [const Offset(0.1, 0.1), const Offset(0.9, 0.9)],
      ]);
      final score = scoreMasks(template, ink);
      expect(score.precision, greaterThan(0.9));
      expect(score.coverage, closeTo(0.5, 0.12));
      expect(score.overlap, score.coverage);
    });

    test('scribbling over the whole canvas tanks precision', () {
      final template = maskFromStrokes(hLine());
      final scribble = maskFromStrokes([
        for (var y = 0.05; y < 1; y += 0.1)
          [Offset(0.05, y), Offset(0.95, y)],
      ]);
      final score = scoreMasks(template, scribble);
      expect(score.coverage, greaterThan(0.9), reason: 'everything is near ink');
      expect(score.precision, lessThan(0.35), reason: 'most ink is off target');
      expect(ribbonTierForOverlap(score.overlap), isNull);
    });

    test('empty masks score zero', () {
      final some = maskFromStrokes(hLine());
      expect(scoreMasks(some, InkMask(some.size)).overlap, 0);
      expect(scoreMasks(InkMask(some.size), some).overlap, 0);
    });
  });

  group('fitStrokesTo (the from-memory alignment)', () {
    test('a correct shape drawn small and off-center scores high once fitted', () {
      final template = maskFromStrokes(cross(0.15, 0.85));
      // Same X but tiny, tucked into the top-left corner.
      final small = cross(0.05, 0.25);
      final raw = scoreMasks(template, maskFromStrokes(small));
      expect(raw.overlap, lessThan(0.35), reason: 'unaligned it misses');

      final target = template.normalizedBounds()!;
      final fitted = scoreMasks(template, maskFromStrokes(fitStrokesTo(small, target)));
      expect(fitted.overlap, greaterThan(0.8), reason: 'aligned it matches');
    });

    test('keeps aspect ratio (uniform scale) and centers on the target', () {
      // A flat wide shape fitted onto a square target must not stretch tall.
      final flat = [
        [const Offset(0.2, 0.5), const Offset(0.4, 0.5)],
      ];
      const target = Rect.fromLTWH(0.25, 0.25, 0.5, 0.5);
      final fitted = fitStrokesTo(flat, target);
      final ys = [for (final s in fitted) for (final p in s) p.dy];
      // Every point stays on one horizontal line through the target center.
      for (final y in ys) {
        expect(y, closeTo(0.5, 0.001));
      }
      final xs = [for (final s in fitted) for (final p in s) p.dx];
      expect((xs.first + xs.last) / 2, closeTo(0.5, 0.001));
    });

    test('a single dot maps to the target center without blowing up', () {
      final fitted = fitStrokesTo(
        [
          [const Offset(0.9, 0.1)],
        ],
        const Rect.fromLTWH(0.2, 0.2, 0.6, 0.6),
      );
      expect(fitted.single.single.dx, closeTo(0.5, 0.001));
      expect(fitted.single.single.dy, closeTo(0.5, 0.001));
    });
  });

  group('DrawingScorer (glyph rendering end to end)', () {
    test('scores strokes against a rendered glyph without throwing', () async {
      final score = await DrawingScorer.score(
        symbol: '中',
        strokes: [
          [const Offset(0.5, 0.15), const Offset(0.5, 0.85)],
        ],
      );
      expect(score.coverage, inInclusiveRange(0.0, 1.0));
      expect(score.precision, inInclusiveRange(0.0, 1.0));
      // The glyph rendered to something — a vertical center stroke touches it.
      expect(score.coverage + score.precision, greaterThan(0));
    });

    test('empty strokes score zero', () async {
      final score = await DrawingScorer.score(symbol: '中', strokes: []);
      expect(score.overlap, 0);
    });
  });
}
