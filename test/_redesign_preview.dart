// Redesign candidates for the room pieces — real redraws (new silhouettes,
// proportions and detail), not a finish tweak. Five hero pieces, three rows:
//
//   Current            — the shipped drawings, for reference
//   A "Cozy studio"    — frontal like today, but plump continuous silhouettes,
//                        material detail (piping, pleats, glaze, saucer),
//                        accent props (throw pillow, steam, glow)
//   B "Little diorama" — every object gets believable depth: visible top
//                        planes / open rims / cylinders, one consistent
//                        oblique light
//
//   flutter test --update-goldens test/_redesign_preview.dart
//
// then open test/redesign_preview.png. NOT a pass/fail golden — a developer
// preview, kept out of the suite by the underscore.
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/widgets/flat_furniture.dart';
import 'package:german_pronouns_articles/widgets/people_paint.dart';

Future<void> _load(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File('C:\\Windows\\Fonts\\$f').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

const _walnut = Color(0xFF6E4A2B);
const _brass = Color(0xFFC9A24B);
const _mustard = Color(0xFFD9A521);
const _cream = Color(0xFFEFE5CE); // dark enough to read on the warm card
const _coffee = Color(0xFF4A3222);
const _soil = Color(0xFF5A4636);
const _leafDark = Color(0xFF33691E);

class _RedesignPainter extends CustomPainter {
  _RedesignPainter(this.glyph, this.variant, this.base);

  final String glyph;
  final int variant; // 1 = A cozy, 2 = B diorama
  final Color base;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final paint = Paint()..isAntiAlias = true;
    // No outlines anywhere — separation comes from tone contrast and soft
    // occlusion shadows, per the user's call ("I don't like the black edge").
    final kit = FlatPaintKit(canvas, u, paint, style: 1);

    // ── local helpers: kit-style fills for arbitrary paths ─────────────────
    void fillPath(Path pth, Color c, {double hi = 0.10, double lo = 0.12}) {
      paint
        ..style = PaintingStyle.fill
        ..shader = kit.vshade(pth.getBounds(), c, hi, lo);
      canvas.drawPath(pth, paint);
      paint.shader = null;
    }

    Path pl(List<Offset> pts) => Path()
      ..addPolygon([for (final o in pts) Offset(o.dx * u, o.dy * u)], true);

    Path ovalPath(double cx, double cy, double rx, double ry) => Path()
      ..addOval(Rect.fromCenter(
          center: Offset(cx * u, cy * u), width: 2 * rx * u, height: 2 * ry * u));

    void oval(double cx, double cy, double rx, double ry, Color c) =>
        fillPath(ovalPath(cx, cy, rx, ry), c);

    // A soft pool of light: a radial fade to fully transparent, so glows have
    // no visible edge.
    void glow(double cx, double cy, double rx, double ry, Color c, double a) {
      final rect = Rect.fromCenter(
          center: Offset(cx * u, cy * u), width: 2 * rx * u, height: 2 * ry * u);
      paint
        ..style = PaintingStyle.fill
        ..shader = RadialGradient(colors: [
          c.withValues(alpha: a),
          c.withValues(alpha: 0.0),
        ]).createShader(rect);
      canvas.drawOval(rect, paint);
      paint.shader = null;
    }

    // Runs [body] with the canvas rotated by [ang] around (cx, cy), unit coords
    // preserved.
    void rot(double cx, double cy, double ang, void Function() body) {
      canvas.save();
      canvas.translate(cx * u, cy * u);
      canvas.rotate(ang);
      canvas.translate(-cx * u, -cy * u);
      body();
      canvas.restore();
    }

    void box(double l, double t, double r, double b, double rad, Color c,
            {bool flat = false}) =>
        kit.box(l, t, r, b, rad, c, flat: flat);
    void circ(double cx, double cy, double r, Color c, {bool flat = false}) =>
        kit.circ(cx, cy, r, c, flat: flat);
    void line(double x1, double y1, double x2, double y2, double w, Color c) =>
        kit.line(x1, y1, x2, y2, w, c);
    void arc(double cx, double cy, double r, double s, double sw, double w,
            Color c) =>
        kit.arc(cx, cy, r, s, sw, w, c);

    // A leaf as a rotated teardrop with a soft midrib.
    void bigLeaf(double cx, double cy, double w, double h, double ang, Color c) {
      rot(cx, cy, ang, () {
        final pth = Path()
          ..moveTo(cx * u, (cy - h) * u)
          ..cubicTo((cx + w) * u, (cy - h * 0.55) * u, (cx + w * 0.9) * u,
              (cy + h * 0.5) * u, cx * u, (cy + h) * u)
          ..cubicTo((cx - w * 0.9) * u, (cy + h * 0.5) * u, (cx - w) * u,
              (cy - h * 0.55) * u, cx * u, (cy - h) * u)
          ..close();
        fillPath(pth, c, hi: 0.14);
        line(cx, cy - h * 0.8, cx, cy + h * 0.8, 0.008, shade(c, -0.18));
      });
    }

    final c = base;

    switch ('$glyph-$variant') {
      // ══ A — Cozy studio: frontal, plump, detailed ═══════════════════════
      case 'sofa-1':
        // splayed walnut feet
        fillPath(pl(const [
          Offset(0.185, 0.80), Offset(0.245, 0.80),
          Offset(0.235, 0.90), Offset(0.195, 0.90),
        ]), _walnut);
        fillPath(pl(const [
          Offset(0.755, 0.80), Offset(0.815, 0.80),
          Offset(0.805, 0.90), Offset(0.765, 0.90),
        ]), _walnut);
        box(0.10, 0.58, 0.90, 0.82, 0.07, shade(c, -0.06)); // base
        box(0.15, 0.22, 0.85, 0.62, 0.12, c); // rounded back
        // arm rolls: fat cylinders capped with a full round
        circ(0.165, 0.455, 0.088, shade(c, 0.05));
        box(0.077, 0.455, 0.253, 0.80, 0.075, shade(c, 0.05));
        circ(0.835, 0.455, 0.088, shade(c, 0.05));
        box(0.747, 0.455, 0.923, 0.80, 0.075, shade(c, 0.05));
        // deep shadow under the cushions
        box(0.25, 0.645, 0.75, 0.685, 0.02, shade(c, -0.30), flat: true);
        // two plump cushions with piping
        box(0.255, 0.495, 0.495, 0.665, 0.055, shade(c, 0.13));
        box(0.505, 0.495, 0.745, 0.665, 0.055, shade(c, 0.13));
        line(0.285, 0.513, 0.465, 0.513, 0.009, shade(c, 0.30));
        line(0.535, 0.513, 0.715, 0.513, 0.009, shade(c, 0.30));
        // a tilted throw pillow against the left arm
        rot(0.315, 0.455, -0.16, () {
          box(0.24, 0.38, 0.39, 0.53, 0.035, _mustard);
          circ(0.315, 0.455, 0.013, shade(_mustard, -0.28), flat: true);
        });
      case 'armchair-1':
        fillPath(pl(const [
          Offset(0.295, 0.78), Offset(0.35, 0.78),
          Offset(0.335, 0.90), Offset(0.305, 0.90),
        ]), _walnut);
        fillPath(pl(const [
          Offset(0.65, 0.78), Offset(0.705, 0.78),
          Offset(0.695, 0.90), Offset(0.665, 0.90),
        ]), _walnut);
        box(0.24, 0.60, 0.76, 0.80, 0.07, shade(c, -0.07)); // skirt
        box(0.27, 0.14, 0.73, 0.62, 0.17, c); // tall egg back
        box(0.335, 0.21, 0.665, 0.50, 0.11, shade(c, 0.08)); // inner panel
        // a small lumbar pillow instead of tufting (button dots read as a face)
        rot(0.50, 0.455, 0.05, () {
          box(0.385, 0.40, 0.615, 0.51, 0.045, _mustard);
        });
        // arm rolls
        circ(0.245, 0.53, 0.075, shade(c, 0.04));
        box(0.17, 0.53, 0.32, 0.78, 0.065, shade(c, 0.04));
        circ(0.755, 0.53, 0.075, shade(c, 0.04));
        box(0.68, 0.53, 0.83, 0.78, 0.065, shade(c, 0.04));
        box(0.29, 0.625, 0.71, 0.655, 0.015, shade(c, -0.28), flat: true);
        box(0.295, 0.535, 0.705, 0.645, 0.05, shade(c, 0.14)); // cushion
        line(0.325, 0.552, 0.675, 0.552, 0.009, shade(c, 0.30)); // piping
      case 'lamp-1':
        // warm halo behind the shade, fading to nothing
        glow(0.50, 0.30, 0.32, 0.32, const Color(0xFFFFD98F), 0.35);
        // domed walnut base + brass stem with a collar ring
        kit.dome(0.50, 0.885, 0.115, _walnut);
        box(0.40, 0.885, 0.60, 0.905, 0.01, shade(_walnut, -0.12));
        line(0.50, 0.875, 0.50, 0.42, 0.020, _brass);
        circ(0.50, 0.60, 0.022, shade(_brass, -0.10));
        // empire shade with a curved hem
        final hem = Path()
          ..moveTo(0.415 * u, 0.135 * u)
          ..lineTo(0.585 * u, 0.135 * u)
          ..cubicTo(0.60 * u, 0.135 * u, 0.665 * u, 0.30 * u, 0.685 * u,
              0.415 * u)
          ..quadraticBezierTo(0.50 * u, 0.455 * u, 0.315 * u, 0.415 * u)
          ..cubicTo(0.335 * u, 0.30 * u, 0.40 * u, 0.135 * u, 0.415 * u,
              0.135 * u)
          ..close();
        fillPath(hem, c, hi: 0.13);
        // pleats + a lit inner hem
        line(0.445, 0.16, 0.375, 0.405, 0.006, shade(c, -0.12));
        line(0.50, 0.165, 0.50, 0.425, 0.006, shade(c, -0.12));
        line(0.555, 0.16, 0.625, 0.405, 0.006, shade(c, -0.12));
        arc(0.50, 0.405, 0.185, 0.15, math.pi - 0.3, 0.018,
            const Color(0xFFFFE9B8));
        // pull chain with a little bead
        line(0.615, 0.43, 0.63, 0.51, 0.007, shade(_brass, -0.20));
        circ(0.63, 0.525, 0.016, _brass);
      case 'plant-1':
        // stems arcing out of the pot
        arc(0.42, 0.58, 0.16, math.pi * 0.9, math.pi * 0.45, 0.012, _leafDark);
        arc(0.58, 0.58, 0.16, math.pi * 0.65, math.pi * 0.45, 0.012, _leafDark);
        line(0.50, 0.62, 0.50, 0.38, 0.012, _leafDark);
        // back row (darker), then front row of broad leaves
        bigLeaf(0.335, 0.335, 0.085, 0.155, -0.55, shade(c, -0.10));
        bigLeaf(0.665, 0.325, 0.085, 0.155, 0.55, shade(c, -0.08));
        bigLeaf(0.50, 0.235, 0.09, 0.165, 0.0, c);
        bigLeaf(0.41, 0.44, 0.08, 0.14, -0.95, shade(c, 0.09));
        bigLeaf(0.60, 0.455, 0.08, 0.135, 0.95, shade(c, 0.07));
        // one leaf drooping over the rim
        bigLeaf(0.655, 0.575, 0.06, 0.105, 2.35, shade(c, 0.12));
        // glazed pot: soil, tapered body, lip, glaze highlight
        oval(0.50, 0.645, 0.14, 0.032, _soil);
        fillPath(pl(const [
          Offset(0.355, 0.655), Offset(0.645, 0.655),
          Offset(0.60, 0.885), Offset(0.40, 0.885),
        ]), const Color(0xFFC56A45));
        box(0.335, 0.632, 0.665, 0.685, 0.022, const Color(0xFFD07B55));
        circ(0.585, 0.755, 0.018, const Color(0xFFE59A76), flat: true);
      case 'mug-1':
        // saucer with a foot shadow
        oval(0.50, 0.845, 0.24, 0.05, _cream);
        oval(0.50, 0.86, 0.16, 0.022, shade(_cream, -0.16));
        // fat rounded body + thick C-handle
        kit.ring(0.695, 0.615, 0.078, 0.038, shade(c, -0.06));
        box(0.325, 0.46, 0.675, 0.80, 0.075, c);
        // open rim: interior + coffee + a cream swirl
        oval(0.50, 0.465, 0.175, 0.052, shade(c, -0.30));
        oval(0.50, 0.468, 0.145, 0.040, _coffee);
        arc(0.50, 0.468, 0.075, 0.4, 4.2, 0.016, const Color(0xFFE8D7B8));
        // glossy highlight
        line(0.385, 0.53, 0.385, 0.72, 0.022,
            Colors.white.withValues(alpha: 0.28));
        // two calm curls of steam
        arc(0.44, 0.36, 0.045, math.pi * 0.2, math.pi, 0.012,
            Colors.white.withValues(alpha: 0.45));
        arc(0.56, 0.315, 0.05, math.pi * 1.2, math.pi, 0.012,
            Colors.white.withValues(alpha: 0.35));

      // ══ B — Little diorama: visible tops, open rims, one oblique light ══
      case 'sofa-2':
        {
          // One oblique depth everywhere: d = (+0.08, −0.05).
          final top = shade(c, 0.20);
          final side = shade(c, -0.18);
          // backrest slab standing on the seat's rear edge
          fillPath(pl(const [
            Offset(0.20, 0.245), Offset(0.28, 0.195),
            Offset(0.96, 0.195), Offset(0.88, 0.245),
          ]), top);
          fillPath(pl(const [
            Offset(0.88, 0.245), Offset(0.96, 0.195),
            Offset(0.96, 0.43), Offset(0.88, 0.48),
          ]), side);
          box(0.20, 0.245, 0.88, 0.48, 0.03, shade(c, 0.05));
          // seat block, meeting the backrest along its rear edge
          fillPath(pl(const [
            Offset(0.12, 0.52), Offset(0.20, 0.47),
            Offset(0.88, 0.47), Offset(0.80, 0.52),
          ]), top);
          fillPath(pl(const [
            Offset(0.80, 0.52), Offset(0.88, 0.47),
            Offset(0.88, 0.75), Offset(0.80, 0.80),
          ]), side);
          box(0.12, 0.52, 0.80, 0.80, 0.03, c);
          // slim arms rising from the seat's ends
          fillPath(pl(const [
            Offset(0.195, 0.40), Offset(0.275, 0.35),
            Offset(0.275, 0.44), Offset(0.195, 0.49),
          ]), side);
          fillPath(pl(const [
            Offset(0.12, 0.40), Offset(0.20, 0.35),
            Offset(0.275, 0.35), Offset(0.195, 0.40),
          ]), top);
          box(0.12, 0.40, 0.195, 0.52, 0.025, shade(c, 0.03));
          fillPath(pl(const [
            Offset(0.80, 0.40), Offset(0.88, 0.35),
            Offset(0.88, 0.47), Offset(0.80, 0.52),
          ]), side);
          fillPath(pl(const [
            Offset(0.725, 0.40), Offset(0.805, 0.35),
            Offset(0.88, 0.35), Offset(0.80, 0.40),
          ]), top);
          box(0.725, 0.40, 0.80, 0.52, 0.025, shade(c, 0.03));
          // two cushions lying between the arms: lit tops + front slivers
          fillPath(pl(const [
            Offset(0.22, 0.505), Offset(0.29, 0.462),
            Offset(0.51, 0.462), Offset(0.44, 0.505),
          ]), shade(c, 0.28));
          box(0.22, 0.505, 0.44, 0.55, 0.015, shade(c, 0.12));
          fillPath(pl(const [
            Offset(0.475, 0.505), Offset(0.545, 0.462),
            Offset(0.765, 0.462), Offset(0.695, 0.505),
          ]), shade(c, 0.28));
          box(0.475, 0.505, 0.695, 0.55, 0.015, shade(c, 0.12));
          // walnut feet: front pair + a rear one under the side face
          box(0.165, 0.80, 0.205, 0.875, 0.012, _walnut);
          box(0.71, 0.80, 0.75, 0.875, 0.012, _walnut);
          box(0.845, 0.745, 0.88, 0.815, 0.012, shade(_walnut, -0.12));
        }
      case 'armchair-2':
        {
          // Same oblique depth as the sofa: d = (+0.08, −0.05).
          final top = shade(c, 0.20);
          final side = shade(c, -0.18);
          // tall backrest slab
          fillPath(pl(const [
            Offset(0.32, 0.20), Offset(0.40, 0.15),
            Offset(0.82, 0.15), Offset(0.74, 0.20),
          ]), top);
          fillPath(pl(const [
            Offset(0.74, 0.20), Offset(0.82, 0.15),
            Offset(0.82, 0.47), Offset(0.74, 0.52),
          ]), side);
          box(0.32, 0.20, 0.74, 0.52, 0.04, shade(c, 0.05));
          // seat block meeting the backrest's foot
          fillPath(pl(const [
            Offset(0.24, 0.56), Offset(0.32, 0.51),
            Offset(0.74, 0.51), Offset(0.66, 0.56),
          ]), top);
          fillPath(pl(const [
            Offset(0.66, 0.56), Offset(0.74, 0.51),
            Offset(0.74, 0.73), Offset(0.66, 0.78),
          ]), side);
          box(0.24, 0.56, 0.66, 0.78, 0.03, c);
          // arms on both ends
          fillPath(pl(const [
            Offset(0.31, 0.44), Offset(0.39, 0.39),
            Offset(0.39, 0.46), Offset(0.31, 0.51),
          ]), side);
          fillPath(pl(const [
            Offset(0.24, 0.44), Offset(0.32, 0.39),
            Offset(0.39, 0.39), Offset(0.31, 0.44),
          ]), top);
          box(0.24, 0.44, 0.31, 0.56, 0.022, shade(c, 0.03));
          fillPath(pl(const [
            Offset(0.66, 0.44), Offset(0.74, 0.39),
            Offset(0.74, 0.51), Offset(0.66, 0.56),
          ]), side);
          fillPath(pl(const [
            Offset(0.59, 0.44), Offset(0.67, 0.39),
            Offset(0.74, 0.39), Offset(0.66, 0.44),
          ]), top);
          box(0.59, 0.44, 0.66, 0.56, 0.022, shade(c, 0.03));
          // cushion between the arms
          fillPath(pl(const [
            Offset(0.335, 0.545), Offset(0.40, 0.503),
            Offset(0.635, 0.503), Offset(0.57, 0.545),
          ]), shade(c, 0.28));
          box(0.335, 0.545, 0.57, 0.585, 0.015, shade(c, 0.12));
          // feet: front pair + a rear one
          box(0.28, 0.78, 0.315, 0.86, 0.012, _walnut);
          box(0.60, 0.78, 0.635, 0.86, 0.012, _walnut);
          box(0.70, 0.73, 0.735, 0.795, 0.012, shade(_walnut, -0.12));
        }
      case 'lamp-2':
        {
          // base: a squat cylinder
          oval(0.50, 0.845, 0.135, 0.042, shade(_walnut, 0.10));
          box(0.365, 0.845, 0.635, 0.885, 0.02, _walnut);
          final bowl = Path()
            ..addArc(
                Rect.fromCenter(
                    center: Offset(0.50 * u, 0.885 * u),
                    width: 0.27 * u,
                    height: 0.09 * u),
                0, math.pi)
            ..close();
          fillPath(bowl, shade(_walnut, -0.08));
          line(0.50, 0.84, 0.50, 0.40, 0.018, _brass);
          // cone shade: body, glowing open bottom, small lit top
          final cone = pl(const [
            Offset(0.455, 0.155), Offset(0.545, 0.155),
            Offset(0.675, 0.42), Offset(0.325, 0.42),
          ]);
          fillPath(cone, c, hi: 0.14);
          oval(0.50, 0.42, 0.175, 0.05, const Color(0xFFFFE1A0));
          oval(0.50, 0.42, 0.115, 0.032, const Color(0xFFFFF2CE));
          oval(0.50, 0.155, 0.045, 0.016, shade(c, 0.20));
          // light pooling on the floor
          oval(0.50, 0.905, 0.19, 0.035,
              const Color(0xFFFFD98F).withValues(alpha: 0.30));
        }
      case 'plant-2':
        {
          // leaves rise from inside the pot's open rim
          line(0.50, 0.60, 0.50, 0.35, 0.012, _leafDark);
          arc(0.41, 0.56, 0.15, math.pi * 0.9, math.pi * 0.42, 0.012, _leafDark);
          arc(0.59, 0.56, 0.15, math.pi * 0.68, math.pi * 0.42, 0.012,
              _leafDark);
          bigLeaf(0.345, 0.31, 0.082, 0.15, -0.5, shade(c, -0.09));
          bigLeaf(0.655, 0.30, 0.082, 0.15, 0.5, shade(c, -0.07));
          bigLeaf(0.50, 0.215, 0.088, 0.16, 0.0, c);
          bigLeaf(0.425, 0.425, 0.075, 0.13, -0.95, shade(c, 0.09));
          bigLeaf(0.585, 0.44, 0.075, 0.125, 0.95, shade(c, 0.07));
          // pot as a cylinder: open rim ellipse + soil inside
          oval(0.50, 0.615, 0.155, 0.048, const Color(0xFFD07B55));
          oval(0.50, 0.618, 0.125, 0.036, _soil);
          fillPath(pl(const [
            Offset(0.348, 0.625), Offset(0.652, 0.625),
            Offset(0.605, 0.875), Offset(0.395, 0.875),
          ]), const Color(0xFFC56A45));
          final foot = Path()
            ..addArc(
                Rect.fromCenter(
                    center: Offset(0.50 * u, 0.873 * u),
                    width: 0.21 * u,
                    height: 0.07 * u),
                0, math.pi)
            ..close();
          fillPath(foot, shade(const Color(0xFFC56A45), -0.10));
          circ(0.575, 0.73, 0.017, const Color(0xFFE59A76), flat: true);
        }
      case 'mug-2':
        {
          // saucer: ellipse with a visible front lip
          oval(0.50, 0.83, 0.25, 0.055, _cream);
          box(0.25, 0.83, 0.75, 0.865, 0.03, shade(_cream, -0.08));
          // cylinder body + bottom curve
          kit.ring(0.70, 0.60, 0.075, 0.036, shade(c, -0.06));
          box(0.325, 0.45, 0.675, 0.795, 0.045, c);
          final foot = Path()
            ..addArc(
                Rect.fromCenter(
                    center: Offset(0.50 * u, 0.79 * u),
                    width: 0.35 * u,
                    height: 0.10 * u),
                0, math.pi)
            ..close();
          fillPath(foot, shade(c, -0.08));
          // open rim: lit lip, dark interior, coffee with a foam moon
          oval(0.50, 0.455, 0.178, 0.055, shade(c, 0.16));
          oval(0.50, 0.458, 0.148, 0.043, shade(c, -0.34));
          oval(0.50, 0.462, 0.126, 0.035, _coffee);
          arc(0.50, 0.462, 0.07, 0.5, 3.8, 0.015, const Color(0xFFE8D7B8));
          line(0.39, 0.52, 0.39, 0.71, 0.02,
              Colors.white.withValues(alpha: 0.26));
          arc(0.47, 0.35, 0.045, math.pi * 0.2, math.pi, 0.012,
              Colors.white.withValues(alpha: 0.40));
        }
      default:
        circ(0.5, 0.5, 0.3, c);
    }
  }

  @override
  bool shouldRepaint(_RedesignPainter old) =>
      old.glyph != glyph || old.variant != variant || old.base != base;
}

void main() {
  setUpAll(() async {
    await _load('Label', ['arial.ttf', 'arialbd.ttf']);
  });

  testWidgets('redesign candidates', (tester) async {
    const glyphs = ['sofa', 'armchair', 'lamp', 'plant', 'mug'];
    final items = [
      for (final g in glyphs) shopCatalog.firstWhere((i) => i.glyph == g),
    ];
    const rows = <int, String>{
      0: 'Current',
      1: 'A — Cozy studio: plump silhouettes + material detail (frontal, like today)',
      2: 'B — Little diorama: visible tops & open rims, one oblique light',
    };

    await tester.binding.setSurfaceSize(const Size(1220, 850));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: const Color(0xFFF1E4CE),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in rows.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 2),
                  child: Text(
                    e.value,
                    style: const TextStyle(
                        fontFamily: 'Label',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23315E)),
                  ),
                ),
                Row(
                  children: [
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF4E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: e.key == 0
                              ? FlatFurniture(item: item, size: 230)
                              : CustomPaint(
                                  size: const Size.square(230),
                                  painter: _RedesignPainter(
                                      item.glyph, e.key, item.color),
                                ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('redesign_preview.png'),
    );
  });
}
