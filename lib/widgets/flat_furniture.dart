/// Flat, minimal vector illustrations of the shop furniture — solid shapes in a
/// small palette derived from each item's color, no gradients, no shadows, no
/// icons. Used in both the room and the shop so the whole game looks flat.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/shop_catalog.dart';

/// The size a furniture piece is drawn at in both the room and the shop, so the
/// same item looks identical in both places.
const double kFurnitureSize = 78;

/// Glyphs whose flat drawing has a small "in character" idle animation built
/// into the painter (a flickering flame, a swimming fish, a spinning fan…). The
/// room wires its idle clock into [FlatFurniture] only for these, so every other
/// piece stays a cheap static drawing.
const Set<String> _animatedGlyphs = {
  'candle', 'fireplace', 'lantern', 'pendant', // flames / glow flicker
  'aquarium', 'fishbowl', 'bathtub', // water: fish, bubbles, ripple
  'kettle', 'teapot', 'mug', // rising steam
  'fan', // spinning blades
  'clock', // sweeping second hand
  'tv', 'computer', 'laptop', 'arcade', // screen flicker
  'window', 'archwindow', 'roundwindow', // drifting clouds / shifting sky
};

/// Whether [glyph]'s drawing animates itself when given an idle clock.
bool furnitureHasIdleAnimation(String glyph) => _animatedGlyphs.contains(glyph);

/// Draws [item] as a flat illustration filling a [size]×[size] square.
///
/// When [animation] is supplied the drawing animates in a way that fits the
/// object (see [furnitureHasIdleAnimation]); [phase] (0..1) desyncs one piece
/// from another so identical pieces don't move in lockstep. With no [animation]
/// the drawing is static — the same neutral pose the shop shows.
class FlatFurniture extends StatelessWidget {
  const FlatFurniture({
    super.key,
    required this.item,
    required this.size,
    this.animation,
    this.phase = 0,
  });

  final ShopItem item;
  final double size;
  final Animation<double>? animation;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _FurniturePainter(item, animation: animation, phase: phase),
    );
  }
}

/// Shifts a color's lightness by [amount] (-1..1) to get flat shades from one
/// base color.
Color _shade(Color c, double amount) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
      .toColor();
}

class _FurniturePainter extends CustomPainter {
  _FurniturePainter(this.item, {this.animation, this.phase = 0})
      : super(repaint: animation);

  final ShopItem item;
  final Animation<double>? animation;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final base = item.color;
    final dark = _shade(base, -0.16);
    final light = _shade(base, 0.26);
    final paint = Paint()..isAntiAlias = true;

    // The idle clock (0..1, looping) or null when static. Animated glyphs build
    // their motion from [wv]/[saw], each oscillation reduced to its neutral
    // (resting) value when there's no clock — so the shop and a paused room show
    // the exact same still drawing.
    final on = animation != null;
    final t = animation?.value ?? 0.0;
    double wv(double speed, [double off = 0]) =>
        on ? math.sin((t * speed + phase + off) * 2 * math.pi) : 0.0;
    double saw(double speed, [double off = 0]) =>
        on ? (t * speed + phase + off) % 1.0 : 0.0;

    // A faintly flickering screen tint (mid = the static screen blue 0xFF4A6572)
    // shared by the TV / computer / laptop / arcade drawings.
    final screen = Color.lerp(const Color(0xFF425D6A), const Color(0xFF526D7A),
        0.5 + 0.5 * wv(5))!;

    void box(double l, double t, double r, double b, double rad, Color color) {
      canvas.drawRRect(
        RRect.fromLTRBR(l * u, t * u, r * u, b * u, Radius.circular(rad * u)),
        paint
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }

    void circ(double cx, double cy, double rad, Color color) {
      canvas.drawCircle(
        Offset(cx * u, cy * u),
        rad * u,
        paint
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }

    void poly(List<Offset> pts, Color color) {
      final path = Path()
        ..addPolygon([for (final o in pts) Offset(o.dx * u, o.dy * u)], true);
      canvas.drawPath(
        path,
        paint
          ..color = color
          ..style = PaintingStyle.fill,
      );
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

    // Two soft wisps of steam rising from [cx],[topY] and fading as they climb —
    // for the hot drinks (kettle, teapot, mug). Only when animated.
    void steam(double cx, double topY) {
      if (!on) return;
      for (var k = 0; k < 2; k++) {
        // Integer speed → the wisp resets exactly at the loop boundary, and the
        // sine envelope makes it fade to nothing at both ends, so the restart is
        // invisible (no jump).
        final rise = saw(1, k * 0.5); // 0..1 up the cycle
        final y = topY - 0.22 * rise;
        final x = cx + 0.03 * math.sin((rise + k * 0.5) * 2 * math.pi);
        circ(x, y, 0.02 + 0.02 * rise,
            Colors.white.withValues(alpha: math.sin(rise * math.pi) * 0.4));
      }
    }

    // Every floor piece is grounded near y = 0.90 and uses most of the box
    // height, so the items read as a consistent set rather than one tall lamp
    // next to a tiny table. Wall pieces (painting, clock) are centred instead.
    const offWhite = Color(0xFFFBFAF6);
    switch (item.glyph) {
      case 'lamp':
        box(0.355, 0.84, 0.645, 0.90, 0.02, dark); // base
        box(0.475, 0.34, 0.525, 0.85, 0.0, dark); // pole
        poly(const [
          Offset(0.40, 0.12),
          Offset(0.60, 0.12),
          Offset(0.70, 0.36),
          Offset(0.30, 0.36),
        ], base); // shade
        line(0.43, 0.20, 0.57, 0.20, 0.012, light); // shade highlight
      case 'plant':
        circ(0.50, 0.32, 0.17, base);
        circ(0.33, 0.46, 0.13, light);
        circ(0.67, 0.46, 0.13, dark);
        circ(0.50, 0.47, 0.15, base);
        poly(const [
          Offset(0.35, 0.60),
          Offset(0.65, 0.60),
          Offset(0.59, 0.90),
          Offset(0.41, 0.90),
        ], const Color(0xFFC9885A)); // pot
        box(0.32, 0.55, 0.68, 0.625, 0.02, const Color(0xFFB97548)); // rim
      case 'chair':
        box(0.34, 0.12, 0.62, 0.56, 0.03, base); // backrest
        box(0.30, 0.52, 0.70, 0.63, 0.03, dark); // seat
        box(0.33, 0.63, 0.40, 0.90, 0.014, dark); // leg
        box(0.60, 0.63, 0.67, 0.90, 0.014, dark); // leg
      case 'painting': // wall piece — centred, no feet
        box(0.18, 0.14, 0.82, 0.76, 0.03, dark); // frame
        box(0.23, 0.19, 0.77, 0.71, 0.02, offWhite); // mat
        poly(const [
          Offset(0.27, 0.66),
          Offset(0.47, 0.40),
          Offset(0.67, 0.66),
        ], base); // mountain
        circ(0.64, 0.34, 0.07, light); // sun
      case 'clock': // wall piece — centred
        {
          circ(0.50, 0.45, 0.33, base);
          circ(0.50, 0.45, 0.275, offWhite);
          line(0.50, 0.45, 0.50, 0.22, 0.03, dark); // hour hand
          line(0.50, 0.45, 0.67, 0.50, 0.03, dark); // minute hand
          if (on) {
            final a = (t + phase) * 2 * math.pi - math.pi / 2; // sweeps round
            line(0.50, 0.45, 0.50 + 0.23 * math.cos(a),
                0.45 + 0.23 * math.sin(a), 0.012,
                const Color(0xFFE2574C)); // second hand
          }
          circ(0.50, 0.45, 0.028, dark);
        }
      case 'bookshelf':
        box(0.24, 0.10, 0.76, 0.90, 0.02, base);
        box(0.28, 0.13, 0.72, 0.87, 0.01, light);
        box(0.32, 0.18, 0.38, 0.42, 0.006, const Color(0xFFE57373));
        box(0.385, 0.16, 0.445, 0.42, 0.006, const Color(0xFF64B5F6));
        box(0.45, 0.21, 0.51, 0.42, 0.006, const Color(0xFF81C784));
        box(0.57, 0.17, 0.63, 0.42, 0.006, const Color(0xFFFFB74D));
        box(0.28, 0.42, 0.72, 0.45, 0.0, dark); // shelf
        box(0.33, 0.49, 0.39, 0.84, 0.006, const Color(0xFFBA68C8));
        box(0.40, 0.53, 0.46, 0.84, 0.006, const Color(0xFF4DB6AC));
        box(0.54, 0.50, 0.60, 0.84, 0.006, const Color(0xFFFF8A65));
        box(0.61, 0.55, 0.67, 0.84, 0.006, const Color(0xFF9575CD));
        box(0.28, 0.84, 0.72, 0.87, 0.0, dark); // shelf
      case 'table':
        box(0.12, 0.34, 0.88, 0.44, 0.03, base); // tabletop
        box(0.18, 0.44, 0.82, 0.50, 0.0, dark); // apron
        box(0.21, 0.50, 0.30, 0.90, 0.014, dark); // leg
        box(0.70, 0.50, 0.79, 0.90, 0.014, dark); // leg
      case 'sofa':
        box(0.16, 0.30, 0.84, 0.58, 0.06, base); // back
        box(0.12, 0.46, 0.28, 0.86, 0.06, base); // left arm
        box(0.72, 0.46, 0.88, 0.86, 0.06, base); // right arm
        box(0.16, 0.56, 0.84, 0.86, 0.06, dark); // seat base
        box(0.30, 0.54, 0.49, 0.68, 0.03, light); // cushion
        box(0.51, 0.54, 0.70, 0.68, 0.03, light); // cushion
        box(0.18, 0.86, 0.26, 0.90, 0.01, dark); // foot
        box(0.74, 0.86, 0.82, 0.90, 0.01, dark); // foot
      case 'bed':
        box(0.10, 0.26, 0.21, 0.86, 0.03, dark); // headboard
        box(0.16, 0.50, 0.88, 0.72, 0.03, base); // mattress
        box(0.48, 0.50, 0.88, 0.72, 0.03, dark); // blanket
        box(0.24, 0.42, 0.44, 0.56, 0.03, offWhite); // pillow
        box(0.18, 0.72, 0.24, 0.88, 0.012, dark); // leg
        box(0.80, 0.72, 0.86, 0.88, 0.012, dark); // leg
      case 'tv':
        box(0.14, 0.16, 0.86, 0.62, 0.03, base); // bezel
        box(0.175, 0.195, 0.825, 0.585, 0.02, screen); // screen
        line(0.32, 0.24, 0.24, 0.54, 0.018, Colors.white.withValues(alpha: 0.16));
        box(0.46, 0.62, 0.54, 0.74, 0.006, base); // neck
        box(0.32, 0.74, 0.68, 0.78, 0.01, base); // foot
      case 'pet': // a small cat
        line(0.36, 0.78, 0.22, 0.58, 0.05, base); // tail
        box(0.30, 0.52, 0.70, 0.88, 0.18, base); // body
        circ(0.66, 0.48, 0.18, base); // head
        poly(const [
          Offset(0.55, 0.40),
          Offset(0.59, 0.24),
          Offset(0.65, 0.40),
        ], base); // ear
        poly(const [
          Offset(0.67, 0.40),
          Offset(0.73, 0.24),
          Offset(0.77, 0.40),
        ], base); // ear
        circ(0.69, 0.47, 0.02, dark); // eye
      case 'bathtub':
        {
          box(0.16, 0.44, 0.84, 0.82, 0.16, base); // tub
          box(0.205, 0.475, 0.795, 0.79, 0.12, offWhite); // inside
          final wob = 0.006 * wv(2); // gentle ripple on the surface
          box(0.26, 0.51 + wob, 0.74, 0.64, 0.06, light); // water
          box(0.15, 0.32, 0.195, 0.50, 0.01, dark); // faucet riser
          box(0.15, 0.32, 0.30, 0.355, 0.01, dark); // spout
          box(0.26, 0.82, 0.33, 0.90, 0.01, dark); // foot
          box(0.67, 0.82, 0.74, 0.90, 0.01, dark); // foot
        }
      case 'rug': // flat on the floor
        box(0.08, 0.62, 0.92, 0.90, 0.10, dark);
        box(0.13, 0.66, 0.87, 0.86, 0.08, base);
        box(0.24, 0.71, 0.76, 0.81, 0.05, light);
      case 'cactus':
        box(0.44, 0.24, 0.56, 0.70, 0.06, base); // trunk
        box(0.30, 0.42, 0.45, 0.50, 0.04, base); // left arm
        box(0.30, 0.36, 0.39, 0.50, 0.04, base); // left arm up
        box(0.55, 0.46, 0.70, 0.54, 0.04, base); // right arm
        box(0.61, 0.40, 0.70, 0.54, 0.04, base); // right arm up
        circ(0.50, 0.23, 0.05, const Color(0xFFEC407A)); // flower
        poly(const [
          Offset(0.37, 0.66),
          Offset(0.63, 0.66),
          Offset(0.59, 0.90),
          Offset(0.41, 0.90),
        ], const Color(0xFFC9885A)); // pot
        box(0.34, 0.62, 0.66, 0.685, 0.02, const Color(0xFFB97548));
      case 'mirror': // wall piece
        box(0.30, 0.12, 0.70, 0.80, 0.20, base); // frame
        box(0.355, 0.17, 0.645, 0.75, 0.16, const Color(0xFFD7EAF0)); // glass
        line(0.43, 0.26, 0.37, 0.44, 0.022, Colors.white.withValues(alpha: 0.55));
      case 'desk':
        box(0.12, 0.36, 0.88, 0.45, 0.03, base); // top
        box(0.18, 0.45, 0.82, 0.50, 0.0, dark); // apron
        box(0.20, 0.50, 0.27, 0.90, 0.012, dark); // leg
        box(0.60, 0.50, 0.82, 0.90, 0.02, dark); // drawer cabinet
        line(0.60, 0.66, 0.82, 0.66, 0.012, base); // drawer divider
        circ(0.71, 0.58, 0.018, light); // knob
        circ(0.71, 0.78, 0.018, light); // knob
      case 'vase':
        line(0.50, 0.34, 0.50, 0.58, 0.014, const Color(0xFF4CAF50));
        line(0.40, 0.42, 0.49, 0.57, 0.014, const Color(0xFF4CAF50));
        line(0.60, 0.42, 0.51, 0.57, 0.014, const Color(0xFF4CAF50));
        circ(0.50, 0.28, 0.075, const Color(0xFFEC407A));
        circ(0.37, 0.38, 0.06, const Color(0xFFFFCA28));
        circ(0.63, 0.38, 0.06, const Color(0xFF7E57C2));
        poly(const [
          Offset(0.40, 0.58),
          Offset(0.60, 0.58),
          Offset(0.64, 0.90),
          Offset(0.36, 0.90),
        ], base); // vase body
        box(0.37, 0.55, 0.63, 0.61, 0.02, dark); // rim
      case 'guitar':
        box(0.52, 0.10, 0.62, 0.20, 0.02, dark); // head
        box(0.54, 0.16, 0.60, 0.58, 0.0, dark); // neck
        circ(0.45, 0.52, 0.15, base); // upper bout
        circ(0.44, 0.70, 0.20, base); // lower bout
        circ(0.44, 0.64, 0.055, dark); // sound hole
      case 'fireplace':
        {
          box(0.16, 0.32, 0.84, 0.90, 0.03, base); // body
          box(0.12, 0.30, 0.88, 0.40, 0.02, dark); // mantel
          box(0.30, 0.50, 0.70, 0.90, 0.03, const Color(0xFF2B1B16)); // opening
          final f1 = wv(5); // height flicker
          final f2 = wv(8, 0.4); // lateral lick
          poly([
            Offset(0.41, 0.86),
            Offset(0.50 + 0.02 * f2, 0.58 - 0.03 * f1),
            Offset(0.59, 0.86),
          ], const Color(0xFFFF7043)); // flame
          poly([
            Offset(0.45, 0.86),
            Offset(0.50 + 0.015 * f2, 0.68 - 0.02 * f1),
            Offset(0.55, 0.86),
          ], const Color(0xFFFFCA28)); // inner flame
        }
      case 'fridge':
        box(0.28, 0.12, 0.72, 0.90, 0.05, base);
        box(0.31, 0.15, 0.69, 0.87, 0.03, light);
        box(0.31, 0.40, 0.69, 0.43, 0.0, base); // freezer split
        box(0.63, 0.20, 0.665, 0.35, 0.01, dark); // handle
        box(0.63, 0.48, 0.665, 0.66, 0.01, dark); // handle
      case 'stove':
        box(0.22, 0.30, 0.78, 0.90, 0.03, base);
        box(0.22, 0.30, 0.78, 0.43, 0.02, dark); // cooktop
        circ(0.35, 0.365, 0.05, base); // burner
        circ(0.65, 0.365, 0.05, base); // burner
        box(0.27, 0.50, 0.73, 0.84, 0.03, dark); // oven door
        box(0.31, 0.54, 0.69, 0.58, 0.01, light); // handle
      case 'wardrobe':
        box(0.24, 0.12, 0.76, 0.88, 0.03, base);
        box(0.27, 0.15, 0.72, 0.85, 0.01, light);
        box(0.495, 0.15, 0.505, 0.85, 0.0, base); // door split
        circ(0.45, 0.50, 0.02, dark); // knob
        circ(0.55, 0.50, 0.02, dark); // knob
        box(0.27, 0.88, 0.34, 0.92, 0.01, dark); // foot
        box(0.66, 0.88, 0.73, 0.92, 0.01, dark); // foot
      case 'aquarium':
        {
          box(0.16, 0.34, 0.84, 0.86, 0.04, base); // frame
          box(0.195, 0.37, 0.805, 0.82, 0.03,
              const Color(0xFF4FC3F7)); // water
          const orange = Color(0xFFFF8A50);
          final cx = 0.47 + 0.12 * wv(2); // fish swims side to side
          circ(cx, 0.56, 0.065, orange); // fish
          poly([
            Offset(cx - 0.07, 0.56),
            Offset(cx - 0.125, 0.50),
            Offset(cx - 0.125, 0.62),
          ], orange); // tail
          circ(cx + 0.02, 0.535, 0.013, Colors.white); // eye
          // Bubble rises and fades to nothing at both ends, so its loop restart
          // is invisible; the static drawing keeps the shop's bubble in place.
          if (on) {
            final rise = saw(1);
            circ(0.64, 0.78 - 0.40 * rise, 0.02,
                Colors.white.withValues(alpha: math.sin(rise * math.pi) * 0.7));
          } else {
            circ(0.64, 0.46, 0.02, Colors.white);
          }
        }
      case 'beanbag':
        box(0.20, 0.48, 0.80, 0.90, 0.24, base);
        box(0.30, 0.52, 0.70, 0.66, 0.12, light); // top dent
      case 'stool':
        box(0.30, 0.42, 0.70, 0.56, 0.07, base); // padded seat
        box(0.33, 0.56, 0.39, 0.88, 0.012, dark); // leg
        box(0.61, 0.56, 0.67, 0.88, 0.012, dark); // leg
        box(0.36, 0.70, 0.64, 0.74, 0.01, dark); // stretcher
      case 'armchair':
        box(0.24, 0.30, 0.76, 0.64, 0.08, base); // back
        box(0.18, 0.46, 0.34, 0.84, 0.06, base); // left arm
        box(0.66, 0.46, 0.82, 0.84, 0.06, base); // right arm
        box(0.26, 0.56, 0.74, 0.84, 0.06, dark); // seat base
        box(0.32, 0.52, 0.68, 0.66, 0.04, light); // cushion
        box(0.26, 0.84, 0.34, 0.90, 0.01, dark); // foot
        box(0.66, 0.84, 0.74, 0.90, 0.01, dark); // foot
      case 'bench':
        box(0.16, 0.30, 0.21, 0.62, 0.012, dark); // back post
        box(0.79, 0.30, 0.84, 0.62, 0.012, dark); // back post
        box(0.16, 0.32, 0.84, 0.40, 0.02, base); // back slat
        box(0.14, 0.52, 0.86, 0.62, 0.03, base); // seat
        box(0.18, 0.62, 0.24, 0.90, 0.012, dark); // leg
        box(0.76, 0.62, 0.82, 0.90, 0.012, dark); // leg
      case 'ottoman':
        box(0.22, 0.52, 0.78, 0.82, 0.10, base); // body
        box(0.30, 0.55, 0.70, 0.66, 0.05, light); // top panel
        box(0.27, 0.82, 0.34, 0.88, 0.01, dark); // foot
        box(0.66, 0.82, 0.73, 0.88, 0.01, dark); // foot
      case 'nightstand':
        box(0.30, 0.40, 0.70, 0.86, 0.03, base); // body
        box(0.33, 0.45, 0.67, 0.60, 0.01, light); // drawer
        box(0.33, 0.63, 0.67, 0.78, 0.01, light); // drawer
        circ(0.50, 0.525, 0.018, dark); // knob
        circ(0.50, 0.705, 0.018, dark); // knob
        box(0.31, 0.86, 0.37, 0.90, 0.008, dark); // leg
        box(0.63, 0.86, 0.69, 0.90, 0.008, dark); // leg
      case 'dresser':
        box(0.18, 0.34, 0.82, 0.86, 0.03, base); // body
        box(0.21, 0.38, 0.79, 0.52, 0.01, light); // drawer
        box(0.21, 0.54, 0.79, 0.68, 0.01, light); // drawer
        box(0.21, 0.70, 0.79, 0.83, 0.01, light); // drawer
        circ(0.35, 0.45, 0.016, dark);
        circ(0.65, 0.45, 0.016, dark);
        circ(0.35, 0.61, 0.016, dark);
        circ(0.65, 0.61, 0.016, dark);
        circ(0.35, 0.765, 0.016, dark);
        circ(0.65, 0.765, 0.016, dark);
        box(0.20, 0.86, 0.27, 0.90, 0.008, dark); // foot
        box(0.73, 0.86, 0.80, 0.90, 0.008, dark); // foot
      case 'cabinet':
        box(0.26, 0.20, 0.74, 0.86, 0.03, base); // body
        box(0.29, 0.24, 0.495, 0.82, 0.01, light); // left door
        box(0.505, 0.24, 0.71, 0.82, 0.01, light); // right door
        circ(0.47, 0.52, 0.016, dark); // knob
        circ(0.53, 0.52, 0.016, dark); // knob
        box(0.27, 0.86, 0.34, 0.90, 0.008, dark); // foot
        box(0.66, 0.86, 0.73, 0.90, 0.008, dark); // foot
      case 'chest':
        box(0.20, 0.50, 0.80, 0.84, 0.04, base); // body
        box(0.18, 0.42, 0.82, 0.54, 0.05, dark); // lid
        box(0.20, 0.60, 0.80, 0.64, 0.0, dark); // band
        box(0.46, 0.54, 0.54, 0.66, 0.01, light); // latch
        box(0.22, 0.84, 0.30, 0.88, 0.01, dark); // foot
        box(0.70, 0.84, 0.78, 0.88, 0.01, dark); // foot
      case 'wallshelf': // wall piece
        box(0.18, 0.52, 0.82, 0.58, 0.01, base); // board
        box(0.21, 0.58, 0.25, 0.64, 0.005, dark); // bracket
        box(0.75, 0.58, 0.79, 0.64, 0.005, dark); // bracket
        box(0.30, 0.36, 0.36, 0.52, 0.008, dark); // book
        box(0.37, 0.40, 0.43, 0.52, 0.008, light); // book
        box(0.44, 0.34, 0.50, 0.52, 0.008, dark); // book
        circ(0.62, 0.44, 0.07, light); // plant
        box(0.57, 0.46, 0.67, 0.52, 0.01, dark); // pot
      case 'coatrack':
        box(0.475, 0.16, 0.525, 0.84, 0.012, base); // pole
        line(0.50, 0.24, 0.38, 0.30, 0.02, dark); // hook
        line(0.50, 0.24, 0.62, 0.30, 0.02, dark); // hook
        line(0.50, 0.30, 0.40, 0.36, 0.02, dark); // hook
        line(0.50, 0.30, 0.60, 0.36, 0.02, dark); // hook
        box(0.36, 0.84, 0.64, 0.88, 0.02, dark); // base
      case 'pendant': // wall/ceiling piece — hangs from the top
        line(0.50, 0.06, 0.50, 0.40, 0.012, dark); // cord
        poly(const [
          Offset(0.34, 0.62),
          Offset(0.66, 0.62),
          Offset(0.58, 0.40),
          Offset(0.42, 0.40),
        ], base); // shade
        circ(
          0.50,
          0.64,
          0.05,
          Color.lerp(const Color(0xFFFFE096), const Color(0xFFFFF2BA),
              0.5 + 0.5 * wv(6))!,
        ); // bulb glow
      case 'lantern':
        {
          box(0.34, 0.28, 0.66, 0.34, 0.02, dark); // top
          line(0.50, 0.18, 0.50, 0.28, 0.018, dark); // handle
          box(0.37, 0.34, 0.63, 0.78, 0.03, base); // frame
          // Glass glow pulses between a dim and a bright warm tone (mid = the
          // static FFE9A8) so the flame inside looks alive.
          final glow = Color.lerp(const Color(0xFFFFE096),
              const Color(0xFFFFF2BA), 0.5 + 0.5 * wv(7))!;
          box(0.41, 0.38, 0.59, 0.74, 0.02, glow); // glass glow
          box(0.34, 0.78, 0.66, 0.84, 0.02, dark); // base
        }
      case 'candle':
        {
          box(0.42, 0.44, 0.58, 0.84, 0.02, base); // candle
          box(0.40, 0.84, 0.60, 0.90, 0.01, dark); // holder
          line(0.50, 0.40, 0.50, 0.44, 0.01, dark); // wick
          final flick = wv(6); // flame height flicker
          final sway = wv(9, 0.3); // tip sway
          final w = 0.04 + 0.006 * flick;
          poly([
            Offset(0.50 - w, 0.44),
            Offset(0.50 + 0.012 * sway, 0.30 - 0.02 * flick),
            Offset(0.50 + w, 0.44),
          ], const Color(0xFFFF9A3D)); // flame
          poly([
            Offset(0.48, 0.44),
            Offset(0.50 + 0.008 * sway, 0.36 - 0.012 * flick),
            Offset(0.52, 0.44),
          ], const Color(0xFFFFD54F)); // inner flame
        }
      case 'succulent':
        poly(const [
          Offset(0.40, 0.62),
          Offset(0.60, 0.62),
          Offset(0.57, 0.86),
          Offset(0.43, 0.86),
        ], const Color(0xFFC9885A)); // pot
        box(0.38, 0.58, 0.62, 0.65, 0.02, const Color(0xFFB97548)); // rim
        circ(0.50, 0.50, 0.10, base); // rosette
        circ(0.42, 0.54, 0.06, light);
        circ(0.58, 0.54, 0.06, dark);
        circ(0.50, 0.44, 0.05, light);
      case 'hangingplant': // wall piece — hangs
        line(0.50, 0.10, 0.50, 0.28, 0.01, dark); // hanger
        poly(const [
          Offset(0.40, 0.28),
          Offset(0.60, 0.28),
          Offset(0.56, 0.46),
          Offset(0.44, 0.46),
        ], base); // pot
        line(0.45, 0.46, 0.40, 0.72, 0.016, light); // vine
        line(0.50, 0.46, 0.50, 0.80, 0.016, base); // vine
        line(0.55, 0.46, 0.61, 0.66, 0.016, dark); // vine
        circ(0.40, 0.72, 0.03, light);
        circ(0.50, 0.80, 0.03, base);
        circ(0.61, 0.66, 0.03, dark);
      case 'palm':
        poly(const [
          Offset(0.42, 0.74),
          Offset(0.58, 0.74),
          Offset(0.55, 0.90),
          Offset(0.45, 0.90),
        ], const Color(0xFFC9885A)); // pot
        box(0.485, 0.36, 0.515, 0.76, 0.0, const Color(0xFF8D6E63)); // trunk
        poly(const [
          Offset(0.50, 0.40),
          Offset(0.20, 0.30),
          Offset(0.30, 0.42),
        ], base); // frond
        poly(const [
          Offset(0.50, 0.40),
          Offset(0.80, 0.30),
          Offset(0.70, 0.42),
        ], dark); // frond
        poly(const [
          Offset(0.50, 0.38),
          Offset(0.34, 0.16),
          Offset(0.46, 0.30),
        ], light); // frond
        poly(const [
          Offset(0.50, 0.38),
          Offset(0.66, 0.16),
          Offset(0.54, 0.30),
        ], base); // frond
        poly(const [
          Offset(0.50, 0.40),
          Offset(0.50, 0.14),
          Offset(0.56, 0.28),
        ], dark); // frond
      case 'poster': // wall piece
        box(0.24, 0.12, 0.76, 0.84, 0.02, dark); // thin frame
        box(0.26, 0.15, 0.74, 0.81, 0.01, offWhite); // paper
        circ(0.50, 0.40, 0.15, base); // graphic
        box(0.31, 0.60, 0.69, 0.70, 0.01, dark); // band
      case 'photo': // wall piece
        box(0.28, 0.20, 0.72, 0.76, 0.03, base); // frame
        box(0.32, 0.24, 0.68, 0.66, 0.01, offWhite); // photo
        circ(0.60, 0.36, 0.05, const Color(0xFFFFCA28)); // sun
        poly(const [
          Offset(0.34, 0.62),
          Offset(0.46, 0.44),
          Offset(0.58, 0.62),
        ], dark); // hill
        box(0.32, 0.69, 0.68, 0.73, 0.0, light); // mat
      case 'tapestry': // wall piece
        box(0.26, 0.16, 0.74, 0.20, 0.01, dark); // rod
        box(0.28, 0.20, 0.72, 0.78, 0.02, base); // cloth
        box(0.33, 0.30, 0.67, 0.38, 0.01, light); // pattern
        box(0.33, 0.48, 0.67, 0.56, 0.01, dark); // pattern
        poly(const [Offset(0.30, 0.78), Offset(0.36, 0.78), Offset(0.33, 0.84)], base);
        poly(const [Offset(0.42, 0.78), Offset(0.48, 0.78), Offset(0.45, 0.84)], base);
        poly(const [Offset(0.54, 0.78), Offset(0.60, 0.78), Offset(0.57, 0.84)], base);
        poly(const [Offset(0.64, 0.78), Offset(0.70, 0.78), Offset(0.67, 0.84)], base);
      case 'computer':
        box(0.22, 0.26, 0.78, 0.60, 0.03, base); // monitor
        box(0.255, 0.295, 0.745, 0.565, 0.02, screen); // screen
        box(0.46, 0.60, 0.54, 0.68, 0.006, dark); // neck
        box(0.36, 0.68, 0.64, 0.72, 0.01, dark); // base
        box(0.28, 0.78, 0.72, 0.84, 0.02, dark); // keyboard
      case 'laptop':
        box(0.26, 0.34, 0.74, 0.62, 0.02, base); // lid
        box(0.295, 0.37, 0.705, 0.59, 0.01, screen); // screen
        poly(const [
          Offset(0.22, 0.62),
          Offset(0.78, 0.62),
          Offset(0.82, 0.70),
          Offset(0.18, 0.70),
        ], dark); // keyboard base
      case 'arcade':
        box(0.28, 0.16, 0.72, 0.90, 0.04, base); // cabinet
        box(0.32, 0.22, 0.68, 0.40, 0.02, screen); // screen
        box(0.32, 0.44, 0.68, 0.50, 0.01, light); // marquee
        box(0.34, 0.54, 0.66, 0.64, 0.02, dark); // control panel
        circ(0.42, 0.59, 0.02, const Color(0xFFEF5350)); // button
        circ(0.50, 0.59, 0.02, const Color(0xFFFFCA28)); // button
        circ(0.58, 0.59, 0.02, const Color(0xFF66BB6A)); // button
      case 'speaker':
        box(0.34, 0.22, 0.66, 0.88, 0.03, base); // cabinet
        circ(0.50, 0.40, 0.10, dark); // woofer
        circ(0.50, 0.40, 0.05, light); // woofer cone
        circ(0.50, 0.68, 0.05, dark); // tweeter
      case 'radio':
        box(0.24, 0.46, 0.76, 0.80, 0.04, base); // body
        box(0.28, 0.50, 0.52, 0.76, 0.02, dark); // grille
        circ(0.62, 0.58, 0.04, light); // knob
        circ(0.62, 0.70, 0.04, light); // knob
        line(0.60, 0.46, 0.66, 0.30, 0.012, dark); // antenna
      case 'piano':
        box(0.22, 0.26, 0.78, 0.86, 0.03, base); // body
        box(0.26, 0.30, 0.74, 0.50, 0.02, dark); // top panel
        box(0.24, 0.56, 0.76, 0.66, 0.0, offWhite); // white keys
        box(0.30, 0.56, 0.33, 0.62, 0.0, dark); // black key
        box(0.38, 0.56, 0.41, 0.62, 0.0, dark); // black key
        box(0.50, 0.56, 0.53, 0.62, 0.0, dark); // black key
        box(0.58, 0.56, 0.61, 0.62, 0.0, dark); // black key
        box(0.66, 0.56, 0.69, 0.62, 0.0, dark); // black key
        box(0.24, 0.66, 0.76, 0.70, 0.0, dark); // ledge
        box(0.27, 0.86, 0.33, 0.90, 0.0, dark); // leg
        box(0.67, 0.86, 0.73, 0.90, 0.0, dark); // leg
      case 'microwave':
        box(0.18, 0.40, 0.82, 0.74, 0.03, base); // body
        box(0.22, 0.44, 0.60, 0.70, 0.02, const Color(0xFF4A6572)); // window
        box(0.64, 0.44, 0.78, 0.70, 0.01, dark); // panel
        circ(0.71, 0.50, 0.015, light); // button
        circ(0.71, 0.56, 0.015, light); // button
      case 'kettle':
        steam(0.30, 0.48); // wisps off the spout
        poly(const [
          Offset(0.36, 0.52),
          Offset(0.64, 0.52),
          Offset(0.60, 0.82),
          Offset(0.40, 0.82),
        ], base); // body
        box(0.42, 0.46, 0.58, 0.52, 0.02, dark); // lid
        circ(0.50, 0.44, 0.025, dark); // knob
        line(0.36, 0.58, 0.26, 0.52, 0.03, base); // spout
        box(0.60, 0.50, 0.72, 0.55, 0.02, dark); // handle top
        box(0.68, 0.50, 0.72, 0.70, 0.02, dark); // handle side
        box(0.36, 0.82, 0.64, 0.86, 0.01, dark); // base
      case 'toaster':
        box(0.28, 0.48, 0.72, 0.80, 0.06, base); // body
        box(0.36, 0.40, 0.49, 0.50, 0.01, offWhite); // toast
        box(0.51, 0.40, 0.64, 0.50, 0.01, offWhite); // toast
        box(0.70, 0.56, 0.74, 0.66, 0.01, dark); // lever
        circ(0.36, 0.70, 0.02, dark); // knob
      case 'mug':
        steam(0.48, 0.44); // wisps off the hot drink
        box(0.36, 0.46, 0.60, 0.80, 0.05, base); // cup
        box(0.38, 0.46, 0.58, 0.52, 0.02, light); // drink
        box(0.60, 0.54, 0.70, 0.58, 0.02, base); // handle
        box(0.66, 0.54, 0.70, 0.70, 0.02, base); // handle
        box(0.60, 0.66, 0.70, 0.70, 0.02, base); // handle
      case 'teapot':
        steam(0.32, 0.42); // wisps off the lid
        circ(0.50, 0.62, 0.17, base); // body
        box(0.42, 0.44, 0.58, 0.50, 0.03, base); // lid
        circ(0.50, 0.42, 0.025, dark); // knob
        line(0.34, 0.58, 0.22, 0.52, 0.035, base); // spout
        box(0.64, 0.54, 0.74, 0.58, 0.02, base); // handle
        box(0.70, 0.54, 0.74, 0.70, 0.02, base); // handle
        box(0.64, 0.66, 0.74, 0.70, 0.02, base); // handle
      case 'pot':
        box(0.30, 0.52, 0.70, 0.82, 0.04, base); // body
        box(0.28, 0.48, 0.72, 0.55, 0.02, dark); // rim
        box(0.20, 0.50, 0.30, 0.54, 0.02, dark); // handle
        box(0.70, 0.50, 0.80, 0.54, 0.02, dark); // handle
        box(0.44, 0.40, 0.56, 0.48, 0.02, light); // lid knob
        circ(0.50, 0.40, 0.02, dark);
      case 'sink':
        box(0.28, 0.40, 0.72, 0.50, 0.03, base); // basin
        box(0.31, 0.43, 0.69, 0.48, 0.04, const Color(0xFFD7EAF0)); // water
        box(0.46, 0.50, 0.54, 0.86, 0.02, base); // pedestal
        box(0.485, 0.30, 0.515, 0.40, 0.01, dark); // faucet riser
        box(0.485, 0.30, 0.58, 0.335, 0.01, dark); // spout
      case 'toilet':
        box(0.34, 0.20, 0.66, 0.46, 0.03, base); // tank
        box(0.31, 0.46, 0.69, 0.54, 0.04, base); // seat back
        circ(0.50, 0.62, 0.15, base); // bowl
        circ(0.50, 0.62, 0.09, offWhite); // bowl inside
        box(0.40, 0.78, 0.60, 0.90, 0.02, base); // base
      case 'trashcan':
        poly(const [
          Offset(0.38, 0.46),
          Offset(0.62, 0.46),
          Offset(0.58, 0.86),
          Offset(0.42, 0.86),
        ], base); // bin
        box(0.36, 0.42, 0.64, 0.48, 0.02, dark); // lid
        box(0.46, 0.38, 0.54, 0.42, 0.01, dark); // handle
        line(0.46, 0.50, 0.45, 0.82, 0.008, dark); // ridge
        line(0.54, 0.50, 0.55, 0.82, 0.008, dark); // ridge
      case 'books':
        box(0.26, 0.74, 0.74, 0.84, 0.01, base); // bottom book
        box(0.30, 0.64, 0.78, 0.74, 0.01, dark); // middle book
        box(0.22, 0.54, 0.66, 0.64, 0.01, light); // top book
        line(0.30, 0.56, 0.30, 0.62, 0.006, dark); // page hint
      case 'cushion':
        box(0.26, 0.40, 0.74, 0.80, 0.12, base); // pillow
        box(0.34, 0.48, 0.66, 0.72, 0.08, light); // inner panel
        circ(0.28, 0.42, 0.018, dark); // tassel
        circ(0.72, 0.42, 0.018, dark); // tassel
        circ(0.28, 0.78, 0.018, dark); // tassel
        circ(0.72, 0.78, 0.018, dark); // tassel
      case 'globe':
        circ(0.50, 0.46, 0.22, base); // sphere
        circ(0.43, 0.42, 0.06, light); // land
        circ(0.58, 0.50, 0.05, light); // land
        circ(0.50, 0.40, 0.04, light); // land
        box(0.46, 0.68, 0.54, 0.74, 0.02, dark); // neck
        box(0.40, 0.74, 0.60, 0.80, 0.02, dark); // base
      case 'trophy':
        poly(const [
          Offset(0.38, 0.34),
          Offset(0.62, 0.34),
          Offset(0.58, 0.58),
          Offset(0.42, 0.58),
        ], base); // cup
        box(0.29, 0.36, 0.38, 0.42, 0.02, base); // handle
        box(0.62, 0.36, 0.71, 0.42, 0.02, base); // handle
        box(0.46, 0.58, 0.54, 0.68, 0.0, base); // stem
        box(0.40, 0.68, 0.60, 0.74, 0.02, dark); // base
        box(0.36, 0.74, 0.64, 0.80, 0.02, dark); // base
      case 'fishbowl':
        {
          circ(0.50, 0.58, 0.22, const Color(0xFFCDEAF5)); // water
          final cx = 0.50 + 0.06 * wv(2); // fish swims in the bowl
          circ(cx, 0.56, 0.07, base); // fish
          poly([
            Offset(cx - 0.07, 0.56),
            Offset(cx - 0.14, 0.50),
            Offset(cx - 0.14, 0.62),
          ], base); // tail
          circ(cx + 0.02, 0.54, 0.012, Colors.white); // eye
          if (on) {
            final rise = saw(1, 0.2); // fades at both ends → clean restart
            circ(cx + 0.05, 0.66 - 0.18 * rise, 0.012,
                Colors.white.withValues(alpha: math.sin(rise * math.pi) * 0.7));
          }
          box(0.40, 0.78, 0.60, 0.84, 0.02, dark); // stand
        }
      case 'fan':
        {
          circ(0.50, 0.42, 0.20, dark); // cage
          circ(0.50, 0.42, 0.17, light); // cage inner
          final ang = on ? (t + phase) * 2 * math.pi : 0.0; // blades spin
          final ca = math.cos(ang), sa = math.sin(ang);
          Offset rb(double px, double py) {
            final dx = px - 0.50, dy = py - 0.42; // rotate around the hub
            return Offset(0.50 + dx * ca - dy * sa, 0.42 + dx * sa + dy * ca);
          }
          poly([rb(0.50, 0.42), rb(0.40, 0.28), rb(0.56, 0.32)], base); // blade
          poly([rb(0.50, 0.42), rb(0.64, 0.36), rb(0.58, 0.52)], base); // blade
          poly([rb(0.50, 0.42), rb(0.44, 0.56), rb(0.36, 0.46)], base); // blade
          circ(0.50, 0.42, 0.04, dark); // hub
          box(0.485, 0.62, 0.515, 0.84, 0.012, base); // stem
          box(0.42, 0.84, 0.58, 0.88, 0.02, dark); // base
        }
      case 'ladder':
        line(0.40, 0.18, 0.30, 0.88, 0.025, base); // rail
        line(0.60, 0.18, 0.70, 0.88, 0.025, base); // rail
        line(0.37, 0.40, 0.63, 0.40, 0.02, dark); // step
        line(0.34, 0.58, 0.66, 0.58, 0.02, dark); // step
        line(0.31, 0.76, 0.69, 0.76, 0.02, dark); // step
      case 'birdcage':
        box(0.34, 0.30, 0.66, 0.80, 0.12, base); // cage body
        line(0.50, 0.16, 0.50, 0.30, 0.012, dark); // hook
        circ(0.50, 0.16, 0.03, dark); // ring
        line(0.42, 0.32, 0.42, 0.78, 0.008, light); // bar
        line(0.50, 0.32, 0.50, 0.78, 0.008, light); // bar
        line(0.58, 0.32, 0.58, 0.78, 0.008, light); // bar
        box(0.30, 0.80, 0.70, 0.86, 0.02, dark); // base
        circ(0.50, 0.54, 0.05, const Color(0xFFFFC107)); // bird
      case 'drum':
        box(0.30, 0.46, 0.70, 0.72, 0.04, base); // shell
        box(0.30, 0.42, 0.70, 0.50, 0.04, offWhite); // head
        line(0.33, 0.50, 0.40, 0.70, 0.01, dark); // tension
        line(0.50, 0.50, 0.50, 0.70, 0.01, dark); // tension
        line(0.67, 0.50, 0.60, 0.70, 0.01, dark); // tension
        box(0.32, 0.72, 0.36, 0.82, 0.01, dark); // leg
        box(0.64, 0.72, 0.68, 0.82, 0.01, dark); // leg
      case 'telescope':
        line(0.50, 0.52, 0.34, 0.88, 0.018, dark); // leg
        line(0.50, 0.52, 0.66, 0.88, 0.018, dark); // leg
        line(0.50, 0.52, 0.50, 0.84, 0.018, dark); // leg
        poly(const [
          Offset(0.38, 0.26),
          Offset(0.52, 0.20),
          Offset(0.66, 0.50),
          Offset(0.52, 0.56),
        ], base); // tube
        circ(0.40, 0.28, 0.05, light); // lens end
        circ(0.62, 0.50, 0.03, dark); // eyepiece
      case 'window': // wall piece — classic four-pane
        {
          // Sky tint drifts (mid = the static 0xFFBFE3F2) and the clouds slide
          // gently across the pane — the view "outside" feels alive.
          final sky = Color.lerp(const Color(0xFFB6DEEF),
              const Color(0xFFC8E8F5), 0.5 + 0.5 * wv(1))!;
          final drift = 0.04 * wv(1);
          box(0.16, 0.14, 0.84, 0.84, 0.04, base); // frame
          box(0.21, 0.19, 0.79, 0.79, 0.02, sky); // glass
          circ(0.62 + drift, 0.36, 0.06, Colors.white); // cloud
          circ(0.69 + drift, 0.40, 0.045, Colors.white); // cloud
          box(0.47, 0.19, 0.53, 0.79, 0.0, base); // mullion (vertical)
          box(0.21, 0.46, 0.79, 0.52, 0.0, base); // mullion (horizontal)
          box(0.13, 0.84, 0.87, 0.90, 0.01, dark); // sill
        }
      case 'archwindow': // wall piece — arched top
        {
          final sky = Color.lerp(const Color(0xFFB6DEEF),
              const Color(0xFFC8E8F5), 0.5 + 0.5 * wv(1))!; // sky shifts
          circ(0.50, 0.40, 0.30, base); // arch frame
          box(0.20, 0.40, 0.80, 0.84, 0.0, base); // body frame
          circ(0.50, 0.41, 0.24, sky); // arch glass
          box(0.26, 0.41, 0.74, 0.79, 0.0, sky); // body glass
          box(0.47, 0.17, 0.53, 0.79, 0.0, base); // mullion (vertical)
          box(0.26, 0.55, 0.74, 0.60, 0.0, base); // mullion (horizontal)
          box(0.15, 0.84, 0.85, 0.90, 0.01, dark); // sill
        }
      case 'roundwindow': // wall piece — porthole
        {
          final sky = Color.lerp(const Color(0xFFB6DEEF),
              const Color(0xFFC8E8F5), 0.5 + 0.5 * wv(1))!; // sky shifts
          final drift = 0.035 * wv(1); // cloud drifts
          circ(0.50, 0.46, 0.34, base); // frame
          circ(0.50, 0.46, 0.27, sky); // glass
          circ(0.60 + drift, 0.38, 0.05, Colors.white); // cloud
          box(0.23, 0.43, 0.77, 0.49, 0.0, base); // mullion (horizontal)
          box(0.47, 0.19, 0.53, 0.73, 0.0, base); // mullion (vertical)
          circ(0.50, 0.16, 0.02, dark); // bolt
          circ(0.50, 0.76, 0.02, dark); // bolt
          circ(0.20, 0.46, 0.02, dark); // bolt
          circ(0.80, 0.46, 0.02, dark); // bolt
        }
      default:
        circ(0.5, 0.5, 0.30, base);
    }
  }

  @override
  bool shouldRepaint(_FurniturePainter oldDelegate) =>
      oldDelegate.item.id != item.id ||
      oldDelegate.item.color != item.color ||
      oldDelegate.animation != animation ||
      oldDelegate.phase != phase;
  // While [animation] is non-null the painter also repaints every tick via
  // `super(repaint: animation)`, without the widget rebuilding.
}
