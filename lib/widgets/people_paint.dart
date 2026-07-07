/// The shared flat-illustration toolkit behind every code-drawn figure in the
/// app: the geometry primitives (soft-lit boxes, discs, polys, round-capped
/// lines) and the People cast's body parts (head, hands, shoes) with their
/// skin/hair palette. [FlatFurniture]'s ~200 room pieces and the standalone
/// [PersonScene] illustrations both paint through this kit, so the whole cast
/// reads as one warm, hand-drawn family — tune the style here, not per-case.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shifts a color's lightness by [amount] (-1..1) to get flat shades from one
/// base color.
Color shade(Color c, double amount) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
      .toColor();
}

// The People cast's palette. A handful of skin tones and hair colours so the
// little characters read as different individuals rather than one cloned
// figure — each pose picks a pair via [FlatPaintKit.head]'s skinTone/hairColor.
const Color kSkin = Color(0xFFE9B68C);
const Color kHair = Color(0xFF4A3B30);
const Color kEye = Color(0xFF2E251F);
const Color kBlush = Color(0x24D77B62); // a faint warm cheek
const List<Color> kSkinTones = [
  Color(0xFFF2CDA6), Color(0xFFE9B68C), Color(0xFFCF9468), Color(0xFF9C6B45),
];
const List<Color> kHairColors = [
  Color(0xFF3A2C22), Color(0xFF6E4A2B), Color(0xFF211D19),
  Color(0xFFB98A3E), Color(0xFF8C8C8C),
];

/// Paints flat, softly top-lit shapes into a square drawing box of side [u]
/// on [canvas], with all coordinates given in 0..1 unit space.
///
/// The caller owns [paint] (a plain `Paint()..isAntiAlias = true`); every
/// primitive fully sets the fields it draws with, and the shared instance
/// keeps the paint-state sequence identical wherever the kit is used.
class FlatPaintKit {
  FlatPaintKit(this.canvas, this.u, this.paint);

  final Canvas canvas;
  final double u;
  final Paint paint;

  // ── Soft, consistent volume ─────────────────────────────────────────────
  // The whole set is lit from the top (a hair to the left), so every solid
  // shape is filled with a gentle gradient along that light instead of a dead
  // flat colour: a lighter crown, the true color through the middle, a soft
  // shaded foot.
  Shader vshade(Rect r, Color c, double hi, double lo) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [shade(c, hi), c, shade(c, -lo)],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(r);

  /// A box fill. Tall panels get the light gradient; very thin slivers
  /// (handles, keys, ledges) and anything asking to stay [flat] keep a crisp
  /// solid fill.
  void box(double l, double t, double r, double b, double rad, Color color,
      {bool flat = false}) {
    final rect = Rect.fromLTRB(l * u, t * u, r * u, b * u);
    paint.style = PaintingStyle.fill;
    if (flat || (b - t) < 0.05) {
      paint
        ..shader = null
        ..color = color;
    } else {
      paint.shader = vshade(rect, color, 0.10, 0.12);
    }
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(rad * u)),
        paint);
    paint.shader = null;
  }

  /// A disc. Bigger discs are shaded as little spheres (the light pooling
  /// toward the top-left); tiny dots (eyes, knobs) stay solid so they read
  /// crisp.
  void circ(double cx, double cy, double rad, Color color,
      {bool flat = false}) {
    final center = Offset(cx * u, cy * u);
    final rr = rad * u;
    paint.style = PaintingStyle.fill;
    if (flat || rad < 0.035) {
      paint
        ..shader = null
        ..color = color;
    } else {
      paint.shader = RadialGradient(
        center: const Alignment(-0.4, -0.5),
        radius: 1.05,
        colors: [shade(color, 0.17), color, shade(color, -0.14)],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: rr));
    }
    canvas.drawCircle(center, rr, paint);
    paint.shader = null;
  }

  void poly(List<Offset> pts, Color color, {bool flat = false}) {
    final path = Path()
      ..addPolygon([for (final o in pts) Offset(o.dx * u, o.dy * u)], true);
    paint.style = PaintingStyle.fill;
    if (flat) {
      paint
        ..shader = null
        ..color = color;
    } else {
      paint.shader = vshade(path.getBounds(), color, 0.09, 0.11);
    }
    canvas.drawPath(path, paint);
    paint.shader = null;
  }

  void line(double x1, double y1, double x2, double y2, double w, Color c) {
    canvas.drawLine(
      Offset(x1 * u, y1 * u),
      Offset(x2 * u, y2 * u),
      paint
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * u
        ..strokeCap = StrokeCap.round,
    );
  }

  /// A stroked circle outline (for glasses, etc.).
  void ring(double cx, double cy, double rad, double w, Color color) {
    canvas.drawCircle(
      Offset(cx * u, cy * u),
      rad * u,
      paint
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * u,
    );
  }

  /// Filled half-discs: [dome] is the top half (mushroom caps, arches),
  /// [bowl] the bottom half (basins, fruit bowls). Flat side sits at [cy].
  void halfDisc(double cx, double cy, double rad, double start, Color color) {
    final rect =
        Rect.fromCircle(center: Offset(cx * u, cy * u), radius: rad * u);
    paint.style = PaintingStyle.fill;
    if (rad < 0.04) {
      paint
        ..shader = null
        ..color = color;
    } else {
      paint.shader = vshade(rect, color, 0.10, 0.12);
    }
    canvas.drawArc(rect, start, math.pi, false, paint);
    paint.shader = null;
  }

  void dome(double cx, double cy, double r, Color c) =>
      halfDisc(cx, cy, r, math.pi, c);
  void bowl(double cx, double cy, double r, Color c) =>
      halfDisc(cx, cy, r, 0, c);

  /// A stroked arc (handles, ripples, water curves).
  void arc(double cx, double cy, double rad, double start, double sweep,
      double w, Color color) {
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx * u, cy * u), radius: rad * u),
      start, sweep, false,
      paint
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * u
        ..strokeCap = StrokeCap.round,
    );
  }

  /// A little person's head: a neck tucked into the torso, ears, a face under
  /// a chosen hairstyle, two eyes, soft cheeks and a gentle smile. Shared by
  /// every pose so the whole cast reads as one warm, hand-drawn family, while
  /// [skinTone]/[hairColor]/[style] let each be its own person. [sleeping]
  /// shuts the eyes; [glasses] adds round spectacles; [neck]/[ears] can be
  /// turned off when a pose (lying down, a hood) hides them. Hair [style]s:
  /// short, side, bun, pony, long, curly, bald.
  void head(double cx, double cy, double r,
      {bool sleeping = false,
      bool glasses = false,
      bool neck = true,
      bool ears = true,
      String style = 'short',
      Color? skinTone,
      Color? hairColor}) {
    final sk = skinTone ?? kSkin;
    final hc = hairColor ?? kHair;
    final fr = r * 0.92; // face radius
    final ey = cy + r * 0.04; // eye line (sits a hair below centre)
    final edx = r * 0.32; // eye spacing from centre
    // Neck — a short skin column under the chin that sinks into the torso, so
    // the head rests on the body rather than floating over it.
    if (neck) {
      box(cx - r * 0.23, cy + r * 0.52, cx + r * 0.23, cy + r * 1.28,
          r * 0.16, shade(sk, -0.07));
    }
    // Ears, level with the eyes (drawn first so hair/face frame them).
    if (ears) {
      circ(cx - fr, cy + r * 0.08, r * 0.17, sk);
      circ(cx + fr, cy + r * 0.08, r * 0.17, sk);
    }
    // Back hair — a soft mass behind the face; long styles fall past the jaw.
    if (style == 'long') {
      box(cx - fr * 1.05, cy - r * 0.05, cx + fr * 1.05, cy + r * 1.08,
          fr * 0.7, hc);
    }
    if (style != 'bald') circ(cx, cy - r * 0.16, fr * 1.12, hc); // crown
    circ(cx, cy + r * 0.07, fr, sk); // face (low, so the crown shows on top)
    // Front hairline + style accents, on top of the face.
    switch (style) {
      case 'bald':
        break;
      case 'curly':
        for (var i = -2; i <= 2; i++) {
          circ(cx + i * fr * 0.44, cy - r * 0.48 + i.abs() * r * 0.06,
              fr * 0.36, hc);
        }
      case 'bun':
        circ(cx, cy - r * 0.7, r * 0.26, hc); // top knot
        arc(cx, cy + r * 0.05, fr * 0.84, math.pi * 1.16, math.pi * 0.68,
            r * 0.2, hc);
      case 'pony':
        poly([
          Offset(cx + fr * 0.78, cy - r * 0.34),
          Offset(cx + fr * 1.32, cy + r * 0.04),
          Offset(cx + fr * 1.12, cy + r * 0.5),
          Offset(cx + fr * 0.74, cy + r * 0.08),
        ], hc); // ponytail off the back
        arc(cx, cy + r * 0.05, fr * 0.84, math.pi * 1.16, math.pi * 0.68,
            r * 0.2, hc);
      case 'side':
        poly([
          Offset(cx - fr * 0.95, cy - r * 0.18),
          Offset(cx + fr * 0.2, cy - r * 0.56),
          Offset(cx + fr * 0.98, cy - r * 0.12),
          Offset(cx + fr * 0.1, cy - r * 0.28),
        ], hc); // a swept fringe
      default: // short, long
        arc(cx, cy + r * 0.05, fr * 0.84, math.pi * 1.16, math.pi * 0.68,
            r * 0.2, hc); // a clean fringe band
    }
    // Soft cheeks — a touch of warmth low on the face.
    circ(cx - r * 0.5, cy + r * 0.34, r * 0.17, kBlush, flat: true);
    circ(cx + r * 0.5, cy + r * 0.34, r * 0.17, kBlush, flat: true);
    // Eyes — open dots with a tiny catch-light, or content closed curves.
    if (sleeping) {
      arc(cx - edx, ey - r * 0.04, r * 0.17, math.pi * 0.18, math.pi * 0.64,
          0.012, kEye);
      arc(cx + edx, ey - r * 0.04, r * 0.17, math.pi * 0.18, math.pi * 0.64,
          0.012, kEye);
    } else {
      circ(cx - edx, ey, r * 0.13, kEye);
      circ(cx + edx, ey, r * 0.13, kEye);
      circ(cx - edx - r * 0.04, ey - r * 0.05, r * 0.04, Colors.white,
          flat: true); // catch-light
      circ(cx + edx - r * 0.04, ey - r * 0.05, r * 0.04, Colors.white,
          flat: true);
    }
    if (glasses) {
      ring(cx - edx, ey, r * 0.24, r * 0.045, kEye);
      ring(cx + edx, ey, r * 0.24, r * 0.045, kEye);
      line(cx - edx + r * 0.22, ey, cx + edx - r * 0.22, ey, 0.008, kEye);
    }
    // A soft smile: the lower arc of a small circle (concave up).
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(cx * u, (cy + r * 0.32) * u), radius: r * 0.3 * u),
      0.2 * math.pi,
      0.6 * math.pi,
      false,
      Paint()
        ..color = kEye
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.08 * u
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true,
    );
  }

  // Limb terminators, so arms and legs finish in hands and shoes instead of
  // blunt round stumps. [hand] is a soft skin disc; [shoe] a small rounded
  // sole pointing toward [dir] (+1 right, −1 left), in the outfit's dark tone.
  void hand(double x, double y, {Color? c, double r = 0.026}) =>
      circ(x, y, r, c ?? kSkin);

  void shoe(double x, double y, double dir, Color c) {
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset((x + dir * 0.02) * u, y * u),
          width: 0.075 * u,
          height: 0.038 * u),
      paint
        ..style = PaintingStyle.fill
        ..shader = null
        ..color = c,
    );
  }
}
