import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import '../widgets/completion_ribbon.dart';

/// Scores a hand-drawn character against its printed template by rasterizing
/// both into small square ink masks and measuring how well they overlap.
///
/// The score is two-sided so it can't be gamed:
///  * **coverage** — the fraction of the template's ink that has learner ink
///    nearby (*did you draw all of it?*). Scribbling everywhere maxes this out…
///  * **precision** — the fraction of the learner's ink that lies near the
///    template (*did you stay on it?*). …but tanks this one.
///
/// [overlap] (the reward metric) is the lower of the two. "Nearby" is a
/// tolerance band of [DrawingScorer.tolerance] of the canvas side, because
/// finger strokes are fat and wobbly while font strokes are thin.
class DrawingScore {
  const DrawingScore({
    required this.coverage,
    required this.precision,
  });

  /// Fraction (0..1) of template ink with learner ink within tolerance.
  final double coverage;

  /// Fraction (0..1) of learner ink lying within tolerance of the template.
  final double precision;

  /// The combined score (0..1): the weaker of [coverage] and [precision].
  double get overlap => min(coverage, precision);

  /// [overlap] as a whole percentage, for display.
  int get percent => (overlap * 100).round();
}

/// The ribbon tier a drawing's [DrawingScore.overlap] earns: gold at 65%,
/// silver at 50%, bronze at 35% — below that the drawing counts as missed and
/// earns nothing.
RibbonTier? ribbonTierForOverlap(double overlap) {
  if (overlap >= 0.65) return RibbonTier.gold;
  if (overlap >= 0.50) return RibbonTier.silver;
  if (overlap >= 0.35) return RibbonTier.bronze;
  return null;
}

/// The run's final ribbon: the tier the *most* cards earned (null = a missed
/// card). Mostly golds → gold, mostly silvers → silver, and so on; when
/// misses outnumber every tier the run earns nothing. Ties go to the better
/// outcome, so "missed" only wins outright.
RibbonTier? majorityTier(Iterable<RibbonTier?> outcomes) {
  final counts = <RibbonTier?, int>{};
  for (final o in outcomes) {
    counts[o] = (counts[o] ?? 0) + 1;
  }
  RibbonTier? best;
  var bestCount = 0;
  for (final o in const [
    RibbonTier.gold,
    RibbonTier.silver,
    RibbonTier.bronze,
    null,
  ]) {
    final c = counts[o] ?? 0;
    if (c > bestCount) {
      best = o;
      bestCount = c;
    }
  }
  return best;
}

/// A square boolean raster: `true` cells are ink. The working resolution of
/// the whole scorer — big enough that stroke shapes survive, small enough
/// that the distance transform is a couple of ms.
class InkMask {
  InkMask(this.size) : cells = List<bool>.filled(size * size, false);

  final int size;
  final List<bool> cells;

  bool get(int x, int y) => cells[y * size + x];
  void set(int x, int y) {
    if (x >= 0 && y >= 0 && x < size && y < size) cells[y * size + x] = true;
  }

  bool get isEmpty => !cells.contains(true);

  /// Bounding box of the ink in normalized (0..1) coordinates, or null when
  /// the mask is empty.
  Rect? normalizedBounds() {
    int minX = size, minY = size, maxX = -1, maxY = -1;
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        if (!get(x, y)) continue;
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
    if (maxX < 0) return null;
    return Rect.fromLTRB(
      minX / size,
      minY / size,
      (maxX + 1) / size,
      (maxY + 1) / size,
    );
  }
}

/// Distance (in cells) from every cell to the nearest ink cell of [mask] — a
/// two-pass chamfer transform (1 / √2 move costs), accurate enough for a
/// tolerance check. An empty mask yields all-infinity.
List<double> distanceField(InkMask mask) {
  final n = mask.size;
  final dist = List<double>.filled(n * n, double.infinity);
  for (var i = 0; i < n * n; i++) {
    if (mask.cells[i]) dist[i] = 0;
  }
  const diag = 1.41421356;
  // Forward pass: propagate from the top-left neighbors…
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final i = y * n + x;
      var d = dist[i];
      if (x > 0) d = min(d, dist[i - 1] + 1);
      if (y > 0) {
        d = min(d, dist[i - n] + 1);
        if (x > 0) d = min(d, dist[i - n - 1] + diag);
        if (x < n - 1) d = min(d, dist[i - n + 1] + diag);
      }
      dist[i] = d;
    }
  }
  // …backward pass: and from the bottom-right ones.
  for (var y = n - 1; y >= 0; y--) {
    for (var x = n - 1; x >= 0; x--) {
      final i = y * n + x;
      var d = dist[i];
      if (x < n - 1) d = min(d, dist[i + 1] + 1);
      if (y < n - 1) {
        d = min(d, dist[i + n] + 1);
        if (x < n - 1) d = min(d, dist[i + n + 1] + diag);
        if (x > 0) d = min(d, dist[i + n - 1] + diag);
      }
      dist[i] = d;
    }
  }
  return dist;
}

/// Rasterizes learner [strokes] (polylines in normalized 0..1 coordinates,
/// the format `DrawQuizPage` keeps them in) into an [InkMask], stamping a
/// disc of [radius] (fraction of the side) along each segment — the same
/// relative pen width the canvas paints with.
InkMask maskFromStrokes(
  List<List<Offset>> strokes, {
  int size = DrawingScorer.gridSize,
  double radius = 0.015,
}) {
  final mask = InkMask(size);
  final r = max(1.0, radius * size);
  void stamp(Offset p) {
    final cx = p.dx * size, cy = p.dy * size;
    for (var y = (cy - r).floor(); y <= (cy + r).ceil(); y++) {
      for (var x = (cx - r).floor(); x <= (cx + r).ceil(); x++) {
        final dx = x + 0.5 - cx, dy = y + 0.5 - cy;
        if (dx * dx + dy * dy <= r * r) mask.set(x, y);
      }
    }
  }

  for (final stroke in strokes) {
    if (stroke.isEmpty) continue;
    stamp(stroke.first);
    for (var i = 1; i < stroke.length; i++) {
      final a = stroke[i - 1], b = stroke[i];
      final steps = max(1, ((b - a).distance * size / (r / 2)).ceil());
      for (var s = 1; s <= steps; s++) {
        stamp(Offset.lerp(a, b, s / steps)!);
      }
    }
  }
  return mask;
}

/// Compares learner ink against the template: coverage from the template's
/// side, precision from the ink's side, both within [tolerance] (fraction of
/// the side). Empty ink scores zero.
DrawingScore scoreMasks(
  InkMask template,
  InkMask ink, {
  double tolerance = DrawingScorer.tolerance,
}) {
  if (template.isEmpty || ink.isEmpty) {
    return const DrawingScore(coverage: 0, precision: 0);
  }
  final tol = tolerance * template.size;
  final distToInk = distanceField(ink);
  final distToTemplate = distanceField(template);
  var templateCells = 0, covered = 0, inkCells = 0, onTarget = 0;
  for (var i = 0; i < template.cells.length; i++) {
    if (template.cells[i]) {
      templateCells++;
      if (distToInk[i] <= tol) covered++;
    }
    if (ink.cells[i]) {
      inkCells++;
      if (distToTemplate[i] <= tol) onTarget++;
    }
  }
  return DrawingScore(
    coverage: covered / templateCells,
    precision: onTarget / inkCells,
  );
}

/// Fits [strokes] onto [target] (the template's bounding box, normalized):
/// the ink's bounding box is scaled uniformly (aspect kept, so a squashed
/// shape stays squashed) and centered onto the target. This is what makes the
/// from-memory mode scorable — a correct character drawn small or off-center
/// aligns with the template before the overlap runs.
List<List<Offset>> fitStrokesTo(List<List<Offset>> strokes, Rect target) {
  final points = strokes.expand((s) => s);
  if (points.isEmpty) return strokes;
  var minX = 1.0, minY = 1.0, maxX = 0.0, maxY = 0.0;
  for (final p in points) {
    minX = min(minX, p.dx);
    minY = min(minY, p.dy);
    maxX = max(maxX, p.dx);
    maxY = max(maxY, p.dy);
  }
  // A dot or a perfectly flat line still gets a sane scale.
  final w = max(maxX - minX, 0.01), h = max(maxY - minY, 0.01);
  final scale = min(target.width / w, target.height / h);
  final inkCenter = Offset((minX + maxX) / 2, (minY + maxY) / 2);
  Offset map(Offset p) => target.center + (p - inkCenter) * scale;
  return [
    for (final stroke in strokes) [for (final p in stroke) map(p)],
  ];
}

/// Lays out the template character exactly the way the drawing canvas paints
/// it (same font size rule, centered), so the scorer and the visible template
/// can never drift apart. [side] is the square canvas side in pixels.
TextPainter templateGlyphPainter(String symbol, double side, Color color) {
  return TextPainter(
    text: TextSpan(
      text: symbol,
      style: TextStyle(
        // Rune count, not grapheme clusters: template symbols are hanzi, one
        // rune each, and this keeps the service off the characters package.
        fontSize: side * 0.72 / symbol.runes.length.clamp(1, 3),
        color: color,
        fontWeight: FontWeight.w400,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
}

/// The scoring entry point the quiz page calls.
class DrawingScorer {
  DrawingScorer._();

  /// Side of the square working raster.
  static const int gridSize = 128;

  /// How far (as a fraction of the canvas side) learner ink may sit from the
  /// template ink and still count — the wobble allowance.
  static const double tolerance = 0.05;

  /// Rendered template masks, keyed by symbol (the glyph never changes, and a
  /// quiz replays the same characters on every run and restart).
  static final Map<String, Future<InkMask>> _glyphCache = {};

  /// Scores [strokes] (normalized 0..1) against [symbol]'s printed form.
  /// [alignToTemplate] is the from-memory mode: the drawing is first fitted
  /// onto the template's bounding box (see [fitStrokesTo]), forgiving wrong
  /// placement and size — tracing is positional, so it compares in place.
  static Future<DrawingScore> score({
    required String symbol,
    required List<List<Offset>> strokes,
    bool alignToTemplate = false,
  }) async {
    if (strokes.every((s) => s.isEmpty)) {
      return const DrawingScore(coverage: 0, precision: 0);
    }
    final template = await (_glyphCache[symbol] ??= _renderGlyph(symbol));
    var ink = strokes;
    if (alignToTemplate) {
      final bounds = template.normalizedBounds();
      if (bounds != null) ink = fitStrokesTo(strokes, bounds);
    }
    return scoreMasks(template, maskFromStrokes(ink));
  }

  /// Draws the glyph offscreen at [gridSize]² and thresholds its alpha into
  /// an [InkMask].
  static Future<InkMask> _renderGlyph(String symbol) async {
    const side = gridSize;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter =
        templateGlyphPainter(symbol, side.toDouble(), const Color(0xFF000000));
    painter.paint(
      canvas,
      Offset((side - painter.width) / 2, (side - painter.height) / 2),
    );
    final image = await recorder.endRecording().toImage(side, side);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final mask = InkMask(side);
      for (var i = 0; i < side * side; i++) {
        if (bytes!.getUint8(i * 4 + 3) > 127) mask.cells[i] = true;
      }
      return mask;
    } finally {
      image.dispose();
    }
  }
}
