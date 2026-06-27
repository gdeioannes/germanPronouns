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
  // People — small in-character motions (a writing hand, a jog in place, mug
  // steam, drifting Zzz…). Meditator & Yogi instead just breathe (whole-piece).
  'reader', 'student', 'stretch', 'jogger', 'walker', 'coffee',
  'sleeper', 'dreamer', 'petter', 'listener',
  // Garden — every themed piece has an in-character idle motion.
  'gardenpot', 'wateringcan', 'gnome', 'toadstool', 'birdbath', 'flowerbox',
  'topiary', 'sunflower', 'fountain', 'beehive', 'lilypond', 'wheelbarrow',
  'greenhouse', 'rosearch', 'blossomtree',
  // Spa.
  'towelstack', 'spacandles', 'diffuser', 'bathsalts', 'slippers', 'loofah',
  'orchid', 'stonestack', 'hottub', 'saunabucket', 'massagetable', 'footbath',
  'stonebath', 'waterfallwall', 'onsen',
  // Gourmet Kitchen.
  'cuttingboard', 'spicerack', 'fruitbowl', 'coffeemaker', 'blender', 'cookbook',
  'potrack', 'breadbasket', 'espresso', 'standmixer', 'winerack', 'rangehood',
  'kitchenisland', 'smartfridge', 'pizzaoven',
  // Art Studio.
  'easel', 'palette', 'brushjar', 'paintcans', 'sketchpad', 'pottery', 'bust',
  'colorwheel', 'potterywheel', 'abstractart', 'artmannequin', 'draftingtable',
  'kiln', 'marblestatue', 'grandeasel',
  // Game Room.
  'gamepad', 'retroconsole', 'dartboard', 'dicetower', 'neonsign', 'gamingchair',
  'vrheadset', 'boardgame', 'pinball', 'jukebox', 'pooltable', 'foosball',
  'racingsim', 'clawmachine', 'arcadetower',
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

    // A stroked circle outline (for glasses, etc.).
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

    // Filled half-discs: [dome] is the top half (mushroom caps, arches), [bowl]
    // the bottom half (basins, fruit bowls). Flat side sits at [cy].
    void halfDisc(double cx, double cy, double rad, double start, Color color) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx * u, cy * u), radius: rad * u),
        start, math.pi, false,
        paint
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
    void dome(double cx, double cy, double r, Color c) => halfDisc(cx, cy, r, math.pi, c);
    void bowl(double cx, double cy, double r, Color c) => halfDisc(cx, cy, r, 0, c);

    // A stroked arc (handles, ripples, water curves).
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

    // A little person's head: a hair cap, a face, two eyes and a gentle smile —
    // shared by every "People" pose so they read as one calm, friendly cast.
    // [sleeping] draws closed eyes; [glasses] adds round spectacles.
    const skin = Color(0xFFE9B68C);
    const hair = Color(0xFF4A3B30);
    const eye = Color(0xFF2E251F);
    void head(double cx, double cy, double r,
        {bool sleeping = false, bool glasses = false}) {
      circ(cx, cy - r * 0.22, r, hair); // hair (sits a touch higher)
      circ(cx, cy, r * 0.9, skin); // face
      final ey = cy - r * 0.04; // eye line
      final edx = r * 0.34; // eye spacing from centre
      if (sleeping) {
        line(cx - edx - r * 0.14, ey, cx - edx + r * 0.14, ey, 0.012, eye);
        line(cx + edx - r * 0.14, ey, cx + edx + r * 0.14, ey, 0.012, eye);
      } else {
        circ(cx - edx, ey, r * 0.12, eye); // eyes
        circ(cx + edx, ey, r * 0.12, eye);
      }
      if (glasses) {
        ring(cx - edx, ey, r * 0.22, r * 0.045, eye);
        ring(cx + edx, ey, r * 0.22, r * 0.045, eye);
        line(cx - edx + r * 0.2, ey, cx + edx - r * 0.2, ey, 0.008, eye);
      }
      // A soft smile: the lower arc of a small circle (concave up).
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(cx * u, (cy + r * 0.16) * u), radius: r * 0.34 * u),
        0.18 * math.pi,
        0.64 * math.pi,
        false,
        Paint()
          ..color = eye
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.085 * u
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true,
      );
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
      // ── People (calm little characters) ─────────────────────────────────
      // Limbs are round-capped strokes, the torso a soft box, the head a hair
      // cap over a face — all in the item's clothing colour.
      case 'reader': // sits with knees up, reading a book
        box(0.26, 0.84, 0.74, 0.90, 0.03, dark); // floor cushion
        line(0.40, 0.82, 0.58, 0.82, 0.06, base); // thigh
        line(0.58, 0.82, 0.60, 0.70, 0.06, base); // shin (knee up)
        box(0.40, 0.52, 0.60, 0.80, 0.07, base); // torso
        head(0.50, 0.42 + 0.008 * wv(1), 0.095,
            glasses: true); // gentle reading nod, in reading glasses
        line(0.42, 0.58, 0.44, 0.68, 0.04, base); // arm
        line(0.58, 0.58, 0.56, 0.68, 0.04, base); // arm
        box(0.37, 0.62, 0.63, 0.70, 0.008, offWhite); // open book
        line(0.50, 0.62, 0.50, 0.70, 0.006, dark); // spine
      case 'student': // sits writing in a notebook
        {
          box(0.26, 0.84, 0.74, 0.90, 0.03, dark); // mat
          poly(const [
            Offset(0.36, 0.83),
            Offset(0.64, 0.83),
            Offset(0.58, 0.74),
            Offset(0.42, 0.74),
          ], base); // folded legs
          box(0.42, 0.52, 0.60, 0.76, 0.07, base); // torso
          head(0.51, 0.42, 0.095, glasses: true); // studious glasses
          final w = 0.025 * wv(2); // writing hand wiggles across the page
          line(0.45, 0.60, 0.40 + w, 0.72, 0.04, base); // writing arm
          box(0.32, 0.72, 0.50, 0.78, 0.008, offWhite); // notebook
          line(0.39 + w, 0.72, 0.43 + w, 0.68, 0.01, dark); // pencil
        }
      case 'meditator': // cross-legged, hands resting on knees
        box(0.26, 0.84, 0.74, 0.90, 0.03, dark); // mat
        poly(const [
          Offset(0.32, 0.83),
          Offset(0.68, 0.83),
          Offset(0.60, 0.74),
          Offset(0.40, 0.74),
        ], base); // crossed legs
        box(0.43, 0.50, 0.57, 0.76, 0.07, base); // torso
        head(0.50, 0.40, 0.10, sleeping: true); // eyes closed, serene
        line(0.43, 0.58, 0.35, 0.74, 0.04, base); // arm to knee
        line(0.57, 0.58, 0.65, 0.74, 0.04, base); // arm to knee
      case 'yogatree': // tree pose — one leg up, palms together overhead
        line(0.50, 0.62, 0.50, 0.88, 0.055, base); // standing leg
        line(0.50, 0.70, 0.41, 0.78, 0.05, base); // bent thigh
        line(0.41, 0.78, 0.49, 0.70, 0.05, base); // foot to knee
        box(0.43, 0.42, 0.57, 0.64, 0.07, base); // torso
        head(0.50, 0.32, 0.095);
        circ(0.50, 0.222, 0.028, const Color(0xFF4A3B30)); // hair bun on top
        line(0.47, 0.46, 0.50, 0.20, 0.038, base); // arm up
        line(0.53, 0.46, 0.50, 0.20, 0.038, base); // arm up
      case 'stretch': // gentle overhead side stretch
        {
          line(0.46, 0.62, 0.45, 0.88, 0.05, base); // leg
          line(0.54, 0.62, 0.55, 0.88, 0.05, base); // leg
          box(0.43, 0.42, 0.57, 0.64, 0.07, base); // torso
          head(0.53, 0.32, 0.095);
          line(0.46, 0.295, 0.61, 0.295, 0.022, light); // sweatband
          final r = on ? 0.025 * (0.5 + 0.5 * wv(1)) : 0.0; // slow reach up
          line(0.50, 0.46, 0.66, 0.30 - r, 0.038, base); // reaching arms
          line(0.50, 0.48, 0.62, 0.34 - r, 0.038, base);
        }
      case 'jogger': // light jog in place — legs and arms swing in counter-time
        {
          final s = 0.09 * wv(2); // stride swing
          line(0.50, 0.60, 0.46 + s, 0.88, 0.05, base); // leg
          line(0.50, 0.60, 0.54 - s, 0.86, 0.05, base); // leg
          box(0.44, 0.40, 0.60, 0.60, 0.06, base); // torso (slight lean)
          head(0.55, 0.30, 0.09);
          line(0.47, 0.275, 0.63, 0.275, 0.022, light); // sweatband
          line(0.48, 0.46, 0.42 - s, 0.50, 0.038, base); // arm
          line(0.58, 0.46, 0.62 + s, 0.42, 0.038, base); // arm
        }
      case 'walker': // a calm walk in place
        {
          final s = 0.05 * wv(1); // gentle stride
          line(0.50, 0.62, 0.44 + s, 0.88, 0.05, base); // leg
          line(0.50, 0.62, 0.56 - s, 0.88, 0.05, base); // leg
          box(0.44, 0.40, 0.58, 0.64, 0.07, base); // torso
          head(0.51, 0.30, 0.095);
          box(0.45, 0.385, 0.57, 0.42, 0.01, light); // scarf
          box(0.46, 0.40, 0.50, 0.50, 0.01, light); // scarf tail
          line(0.46, 0.46, 0.42 - s, 0.58, 0.038, base); // arm
          line(0.56, 0.46, 0.60 + s, 0.58, 0.038, base); // arm
        }
      case 'coffee': // sits relaxed with a warm mug
        box(0.26, 0.84, 0.74, 0.90, 0.03, dark); // mat
        poly(const [
          Offset(0.34, 0.83),
          Offset(0.66, 0.83),
          Offset(0.60, 0.74),
          Offset(0.40, 0.74),
        ], base); // legs
        box(0.42, 0.52, 0.60, 0.76, 0.07, base); // torso
        head(0.50, 0.42, 0.095);
        line(0.44, 0.60, 0.49, 0.66, 0.038, base); // arm to mug
        line(0.56, 0.60, 0.51, 0.66, 0.038, base); // arm to mug
        box(0.46, 0.63, 0.54, 0.70, 0.015, offWhite); // mug
        line(0.54, 0.65, 0.57, 0.67, 0.012, offWhite); // handle
        steam(0.50, 0.61); // warm steam curling off the mug
      case 'sleeper': // curled on a pillow, Zzz drifting up
        {
          box(0.30, 0.74, 0.86, 0.86, 0.06, base); // body under a blanket
          box(0.20, 0.72, 0.36, 0.82, 0.04, offWhite); // pillow
          head(0.28, 0.68, 0.08, sleeping: true); // peaceful sleeping face
          poly(const [
            Offset(0.20, 0.64),
            Offset(0.37, 0.63),
            Offset(0.26, 0.50),
          ], base); // nightcap
          circ(0.26, 0.50, 0.018, offWhite); // pom-pom
          final z = saw(1); // 0..1 drift cycle
          final dy = on ? -0.10 * z : 0.0; // float up
          final zc = dark.withValues(alpha: on ? math.sin(z * math.pi) : 1.0);
          line(0.64, 0.50 + dy, 0.71, 0.50 + dy, 0.012, zc); // big Z
          line(0.71, 0.50 + dy, 0.64, 0.58 + dy, 0.012, zc);
          line(0.64, 0.58 + dy, 0.71, 0.58 + dy, 0.012, zc);
          line(0.74, 0.42 + dy, 0.79, 0.42 + dy, 0.01, zc); // small z
          line(0.79, 0.42 + dy, 0.74, 0.48 + dy, 0.01, zc);
          line(0.74, 0.48 + dy, 0.79, 0.48 + dy, 0.01, zc);
        }
      case 'dreamer': // lying back, knees up, hands behind the head
        box(0.20, 0.80, 0.78, 0.88, 0.05, base); // body lying
        poly(const [
          Offset(0.64, 0.80),
          Offset(0.78, 0.80),
          Offset(0.76, 0.70),
          Offset(0.68, 0.72),
        ], base); // knees up
        head(0.26, 0.76, 0.08, sleeping: true); // dreaming, eyes closed
        line(0.20, 0.78, 0.30, 0.72, 0.03, base); // arm behind head
        if (on) {
          // Two little dream bubbles drift up from the head and fade away.
          for (var k = 0; k < 2; k++) {
            final d = saw(1, k * 0.5);
            circ(0.30 + 0.03 * k, 0.70 - 0.18 * d, 0.016 + 0.008 * k,
                Colors.white.withValues(alpha: math.sin(d * math.pi) * 0.5));
          }
        }
      case 'petter': // sits gently petting a little cat
        {
          box(0.24, 0.84, 0.76, 0.90, 0.03, dark); // mat
          poly(const [
            Offset(0.32, 0.83),
            Offset(0.62, 0.83),
            Offset(0.56, 0.74),
            Offset(0.38, 0.74),
          ], base); // legs
          box(0.38, 0.54, 0.56, 0.76, 0.07, base); // torso
          head(0.47, 0.44, 0.095);
          final pat = on ? 0.018 * (0.5 + 0.5 * wv(2)) : 0.0; // stroking
          line(0.54, 0.60, 0.66, 0.74 + pat, 0.038, base); // arm pets the cat
          line(0.62, 0.84, 0.56, 0.80, 0.02, dark); // cat tail
          box(0.62, 0.80, 0.76, 0.87, 0.05, dark); // cat body
          circ(0.74, 0.78, 0.045, dark); // cat head
          poly(const [
            Offset(0.71, 0.75),
            Offset(0.72, 0.71),
            Offset(0.745, 0.75),
          ], dark); // cat ear
        }
      case 'listener': // sits back with headphones on
        box(0.26, 0.84, 0.74, 0.90, 0.03, dark); // mat
        poly(const [
          Offset(0.34, 0.83),
          Offset(0.66, 0.83),
          Offset(0.60, 0.74),
          Offset(0.40, 0.74),
        ], base); // legs
        box(0.42, 0.54, 0.58, 0.76, 0.07, base); // torso
        head(0.50, 0.44, 0.10);
        line(0.41, 0.44, 0.50, 0.35, 0.016, dark); // headphone band
        line(0.50, 0.35, 0.59, 0.44, 0.016, dark);
        circ(0.40, 0.47, 0.035, dark); // ear cup
        circ(0.60, 0.47, 0.035, dark); // ear cup
        line(0.44, 0.60, 0.42, 0.72, 0.038, base); // relaxed arm
        line(0.56, 0.60, 0.58, 0.72, 0.038, base); // relaxed arm
        if (on) {
          // A little music note floats up and fades, by the right ear.
          final n = saw(1);
          final ny = 0.42 - 0.20 * n;
          final nc = dark.withValues(alpha: math.sin(n * math.pi) * 0.7);
          circ(0.70, ny, 0.02, nc); // note head
          line(0.719, ny, 0.719, ny - 0.06, 0.01, nc); // stem
        }
      // ── Garden 🌿 ─────────────────────────────────────────────────────────
      case 'gardenpot': // a potted flower whose bloom sways
        {
          poly(const [
            Offset(0.37, 0.62), Offset(0.63, 0.62),
            Offset(0.59, 0.90), Offset(0.41, 0.90),
          ], base);
          box(0.34, 0.57, 0.66, 0.64, 0.02, dark);
          final sx = 0.50 + wv(0.5) * 0.03;
          line(0.50, 0.60, sx, 0.30, 0.022, const Color(0xFF4F8F4A));
          for (var i = 0; i < 5; i++) {
            final a = i * 2 * math.pi / 5 + math.pi / 2;
            circ(sx + 0.075 * math.cos(a), 0.27 + 0.075 * math.sin(a), 0.05,
                const Color(0xFFE7A9C3));
          }
          circ(sx, 0.27, 0.045, const Color(0xFFF2C84B));
        }
      case 'wateringcan': // a drip falls from the spout
        {
          box(0.30, 0.50, 0.60, 0.86, 0.05, base);
          box(0.27, 0.46, 0.63, 0.52, 0.02, dark);
          poly(const [
            Offset(0.58, 0.54), Offset(0.82, 0.40),
            Offset(0.85, 0.47), Offset(0.60, 0.63),
          ], base);
          circ(0.82, 0.42, 0.05, dark);
          line(0.36, 0.49, 0.45, 0.36, 0.03, dark);
          line(0.45, 0.36, 0.55, 0.49, 0.03, dark);
          if (on) {
            final d = saw(1);
            circ(0.82, 0.45 + 0.34 * d, 0.02,
                const Color(0xFF6FB6D6)
                    .withValues(alpha: math.sin(d * math.pi) * 0.85));
          }
        }
      case 'gnome': // a cheery gnome bobbing on his feet
        {
          canvas.save();
          canvas.translate(0, wv(0.6) * 0.013 * u);
          poly(const [
            Offset(0.34, 0.60), Offset(0.66, 0.60),
            Offset(0.70, 0.90), Offset(0.30, 0.90),
          ], const Color(0xFF3B6FB0));
          circ(0.50, 0.50, 0.13, const Color(0xFFE9B68C));
          poly(const [
            Offset(0.39, 0.52), Offset(0.61, 0.52), Offset(0.50, 0.76),
          ], offWhite);
          poly(const [
            Offset(0.34, 0.47), Offset(0.66, 0.47), Offset(0.50, 0.12),
          ], base);
          circ(0.50, 0.45, 0.028, const Color(0xFFD98A6A));
          canvas.restore();
        }
      case 'toadstool': // a toadstool whose cap sways
        {
          final sx = wv(0.5) * 0.02;
          box(0.43, 0.50, 0.57, 0.88, 0.05, offWhite);
          box(0.40, 0.86, 0.60, 0.90, 0.02, dark);
          dome(0.50 + sx, 0.52, 0.22, base);
          circ(0.43 + sx, 0.45, 0.03, offWhite);
          circ(0.57 + sx, 0.46, 0.026, offWhite);
          circ(0.50 + sx, 0.39, 0.03, offWhite);
        }
      case 'birdbath': // ripples spread and a bird bobs on the rim
        {
          box(0.47, 0.52, 0.53, 0.84, 0.01, dark);
          box(0.40, 0.84, 0.60, 0.90, 0.02, dark);
          bowl(0.50, 0.50, 0.18, base);
          box(0.33, 0.46, 0.67, 0.50, 0.02, const Color(0xFF7FC0D8));
          if (on) {
            final r = saw(1);
            ring(0.50, 0.48, 0.03 + 0.06 * r, 0.006,
                const Color(0xFFCDEAF2).withValues(alpha: (1 - r) * 0.6));
          }
          final by = 0.40 + wv(0.8) * 0.012;
          circ(0.62, by, 0.038, const Color(0xFF7A6A60));
          circ(0.655, by - 0.025, 0.024, const Color(0xFF7A6A60));
          poly([
            Offset(0.675, by - 0.03), Offset(0.71, by - 0.018),
            Offset(0.675, by - 0.005),
          ], const Color(0xFFE0A82E));
        }
      case 'flowerbox': // a window box of flowers nodding in the breeze
        {
          box(0.26, 0.62, 0.74, 0.88, 0.03, base);
          box(0.26, 0.62, 0.74, 0.68, 0.03, dark);
          const cols = [Color(0xFFE2574C), Color(0xFFF2C84B), Color(0xFFE86BA8)];
          for (var i = 0; i < 3; i++) {
            final cx = 0.36 + i * 0.14;
            final s = wv(0.6, i * 0.3) * 0.025;
            line(cx, 0.62, cx + s, 0.44, 0.018, const Color(0xFF4F8F4A));
            circ(cx + s, 0.42, 0.06, cols[i]);
            circ(cx + s, 0.42, 0.022, offWhite);
          }
        }
      case 'topiary': // a trimmed bush rustling
        {
          poly(const [
            Offset(0.40, 0.74), Offset(0.60, 0.74),
            Offset(0.57, 0.90), Offset(0.43, 0.90),
          ], const Color(0xFFC07E54));
          final s = wv(0.5) * 0.015;
          circ(0.50 + s, 0.34, 0.20, base);
          circ(0.40 + s, 0.40, 0.10, light);
          circ(0.60 + s, 0.40, 0.10, dark);
        }
      case 'sunflower': // a sunflower swaying on its stem
        {
          poly(const [
            Offset(0.43, 0.70), Offset(0.57, 0.70),
            Offset(0.55, 0.90), Offset(0.45, 0.90),
          ], const Color(0xFFB07A4A));
          final s = wv(0.45) * 0.03;
          line(0.50, 0.70, 0.50 + s, 0.38, 0.026, const Color(0xFF3F8F4A));
          circ(0.44, 0.56, 0.05, const Color(0xFF4F9F5A));
          circ(0.56, 0.50, 0.05, const Color(0xFF4F9F5A));
          final hx = 0.50 + s;
          const hy = 0.34;
          for (var i = 0; i < 12; i++) {
            final a = i * 2 * math.pi / 12;
            poly([
              Offset(hx + 0.10 * math.cos(a), hy + 0.10 * math.sin(a)),
              Offset(hx + 0.18 * math.cos(a - 0.13),
                  hy + 0.18 * math.sin(a - 0.13)),
              Offset(hx + 0.18 * math.cos(a + 0.13),
                  hy + 0.18 * math.sin(a + 0.13)),
            ], base);
          }
          circ(hx, hy, 0.10, const Color(0xFF6B4A2A));
        }
      case 'fountain': // water rises and falls between the tiers
        {
          bowl(0.50, 0.74, 0.30, base);
          box(0.20, 0.72, 0.80, 0.78, 0.02, dark);
          box(0.46, 0.50, 0.54, 0.74, 0.01, dark);
          dome(0.50, 0.52, 0.12, base);
          box(0.24, 0.74, 0.76, 0.80, 0.0, const Color(0xFF8FD0E0));
          if (on) {
            for (var k = 0; k < 2; k++) {
              final d = saw(1.2, k * 0.5);
              final side = k == 0 ? -1 : 1;
              circ(0.50 + side * 0.10, 0.52 + 0.22 * d, 0.018,
                  const Color(0xFFBFE6F0)
                      .withValues(alpha: math.sin(d * math.pi) * 0.8));
            }
            arc(0.50, 0.52, 0.10, math.pi, math.pi, 0.012,
                const Color(0xFFBFE6F0).withValues(alpha: 0.7));
          }
        }
      case 'beehive': // bees orbit a straw skep
        {
          for (var i = 0; i < 4; i++) {
            final w = 0.30 - i * 0.045;
            box(0.50 - w, 0.77 - i * 0.13, 0.50 + w, 0.90 - i * 0.13, 0.06,
                i.isEven ? base : dark);
          }
          dome(0.50, 0.38, 0.135, base);
          circ(0.50, 0.66, 0.03, const Color(0xFF5A4632));
          if (on) {
            for (var k = 0; k < 3; k++) {
              final a = saw(0.6, k / 3.0) * 2 * math.pi;
              circ(0.50 + 0.30 * math.cos(a), 0.40 + 0.16 * math.sin(a), 0.02,
                  const Color(0xFF3A3026));
            }
          }
        }
      case 'lilypond': // ripples cross a lily pond
        {
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.74 * u),
                width: 0.64 * u, height: 0.30 * u),
            paint..color = base..style = PaintingStyle.fill,
          );
          circ(0.38, 0.72, 0.06, const Color(0xFF4F9F5A));
          circ(0.60, 0.78, 0.05, const Color(0xFF4F9F5A));
          circ(0.55, 0.70, 0.035, const Color(0xFFE86BA8));
          if (on) {
            final r = saw(1);
            ring(0.46, 0.74, 0.04 + 0.10 * r, 0.006,
                light.withValues(alpha: (1 - r) * 0.7));
          }
        }
      case 'wheelbarrow': // flowers nod over a wheelbarrow
        {
          poly(const [
            Offset(0.28, 0.52), Offset(0.74, 0.52),
            Offset(0.66, 0.74), Offset(0.36, 0.74),
          ], base);
          box(0.32, 0.50, 0.70, 0.56, 0.02, const Color(0xFF5A4632));
          const cols = [Color(0xFFE2574C), Color(0xFFF2C84B), Color(0xFFE86BA8)];
          for (var i = 0; i < 3; i++) {
            final cx = 0.40 + i * 0.12;
            final s = wv(0.6, i * 0.3) * 0.02;
            circ(cx + s, 0.44, 0.045, cols[i]);
          }
          line(0.74, 0.54, 0.86, 0.72, 0.02, dark);
          line(0.28, 0.56, 0.20, 0.74, 0.02, dark);
          circ(0.34, 0.80, 0.09, dark);
          circ(0.34, 0.80, 0.035, light);
        }
      case 'greenhouse': // a glint sweeps the glass; plants inside
        {
          box(0.26, 0.40, 0.74, 0.90, 0.02, base.withValues(alpha: 0.55));
          poly(const [
            Offset(0.24, 0.40), Offset(0.50, 0.24), Offset(0.76, 0.40),
          ], base.withValues(alpha: 0.7));
          line(0.26, 0.40, 0.26, 0.90, 0.014, offWhite);
          line(0.74, 0.40, 0.74, 0.90, 0.014, offWhite);
          line(0.50, 0.26, 0.50, 0.90, 0.014, offWhite);
          line(0.26, 0.66, 0.74, 0.66, 0.012, offWhite);
          line(0.24, 0.40, 0.50, 0.24, 0.014, offWhite);
          line(0.76, 0.40, 0.50, 0.24, 0.014, offWhite);
          circ(0.38, 0.76, 0.07, const Color(0xFF4F9F5A));
          circ(0.62, 0.80, 0.06, const Color(0xFF3F8F5A));
          if (on) {
            final g = saw(0.6);
            line(0.28 + g * 0.4, 0.44, 0.34 + g * 0.4, 0.44, 0.02,
                offWhite.withValues(alpha: math.sin(g * math.pi) * 0.5));
          }
        }
      case 'rosearch': // climbing roses shimmer over an arch
        {
          box(0.20, 0.32, 0.28, 0.90, 0.02, base);
          box(0.72, 0.32, 0.80, 0.90, 0.02, base);
          arc(0.50, 0.36, 0.26, math.pi, math.pi, 0.05, base);
          for (var i = 0; i < 7; i++) {
            final a = math.pi + (i / 6) * math.pi;
            final rx = 0.50 + 0.26 * math.cos(a);
            final ry = 0.36 + 0.26 * math.sin(a);
            final tw =
                on ? wv(1, i * 0.2) * 0.4 + 0.6 : 0.6;
            circ(rx, ry, 0.035,
                Color.lerp(const Color(0xFFD9748F),
                    const Color(0xFFE8A6B8), tw)!);
          }
          circ(0.24, 0.60, 0.05, const Color(0xFF4F9F5A));
          circ(0.76, 0.66, 0.05, const Color(0xFF4F9F5A));
        }
      case 'blossomtree': // petals drift down from the canopy
        {
          box(0.46, 0.56, 0.54, 0.90, 0.02, const Color(0xFF6D4C41));
          line(0.50, 0.62, 0.36, 0.50, 0.02, const Color(0xFF6D4C41));
          line(0.50, 0.60, 0.64, 0.48, 0.02, const Color(0xFF6D4C41));
          circ(0.50, 0.36, 0.22, base);
          circ(0.33, 0.44, 0.12, light);
          circ(0.67, 0.44, 0.12, dark);
          circ(0.50, 0.50, 0.14, base);
          if (on) {
            for (var k = 0; k < 4; k++) {
              final d = saw(0.5, k / 4.0);
              final px = 0.34 + k * 0.12 + 0.04 * math.sin(d * 6);
              final py = 0.50 + 0.36 * d;
              circ(px, py, 0.016,
                  const Color(0xFFF3C4D6).withValues(alpha: (1 - d) * 0.9));
            }
          }
        }
      // ── Spa 🧖 ──────────────────────────────────────────────────────────────
      case 'towelstack': // folded towels with a sprig that sways
        {
          for (var i = 0; i < 3; i++) {
            box(0.30, 0.78 - i * 0.12, 0.70, 0.88 - i * 0.12, 0.04,
                i.isEven ? base : _shade(base, -0.07));
            line(0.30, 0.83 - i * 0.12, 0.70, 0.83 - i * 0.12, 0.006,
                _shade(base, -0.14));
          }
          final s = wv(0.5) * 0.02;
          line(0.50, 0.54, 0.50 + s, 0.45, 0.012, const Color(0xFF6BA86B));
          circ(0.50 + s, 0.43, 0.03, const Color(0xFF8FBF8F));
        }
      case 'spacandles': // three spa candles flickering
        {
          box(0.22, 0.80, 0.78, 0.88, 0.03, const Color(0xFF8A7A66));
          const tops = [0.62, 0.58, 0.65];
          for (var i = 0; i < 3; i++) {
            final cx = 0.34 + i * 0.16;
            box(cx - 0.05, tops[i], cx + 0.05, 0.81, 0.02, base);
            final f = on ? 1 + wv(6, i * 0.3) * 0.3 : 1.0;
            poly([
              Offset(cx, tops[i] - 0.02 - 0.06 * f),
              Offset(cx - 0.022, tops[i] - 0.01),
              Offset(cx + 0.022, tops[i] - 0.01),
            ], const Color(0xFFF2A03C));
            circ(cx, tops[i] - 0.02, 0.01, const Color(0xFFFFE0A0));
          }
        }
      case 'diffuser': // a reed diffuser breathing out scent
        {
          box(0.40, 0.58, 0.60, 0.86, 0.06, base);
          box(0.44, 0.52, 0.56, 0.60, 0.02, dark);
          for (var i = 0; i < 4; i++) {
            final rx = 0.46 + i * 0.027;
            line(rx, 0.54, rx - 0.04 + i * 0.02, 0.34, 0.01,
                const Color(0xFFB07A4A));
          }
          steam(0.50, 0.42);
        }
      case 'bathsalts': // a jar of bath salts that sparkles
        {
          box(0.36, 0.50, 0.64, 0.88, 0.05, base.withValues(alpha: 0.5));
          box(0.36, 0.66, 0.64, 0.88, 0.05, base);
          box(0.40, 0.44, 0.60, 0.52, 0.02, dark);
          if (on) {
            for (var k = 0; k < 3; k++) {
              final tw = wv(3, k * 0.33) * 0.5 + 0.5;
              circ(0.44 + k * 0.07, 0.74 - k * 0.04, 0.012,
                  offWhite.withValues(alpha: tw));
            }
          }
        }
      case 'slippers': // a pair of slippers with a soft bob
        {
          final b = wv(0.5) * 0.006;
          for (var i = 0; i < 2; i++) {
            final x = 0.26 + i * 0.26;
            box(x, 0.80 + b, x + 0.22, 0.88 + b, 0.04, base);
            arc(x + 0.07, 0.80 + b, 0.07, math.pi, math.pi, 0.03, light);
          }
        }
      case 'loofah': // a loofah swinging on its cord
        {
          final sw = wv(0.7) * 0.03;
          line(0.50, 0.14, 0.50 + sw, 0.42, 0.012, const Color(0xFFB7A07A));
          circ(0.50, 0.14, 0.02, const Color(0xFFB7A07A));
          for (var i = 0; i < 4; i++) {
            circ(0.50 + sw, 0.50 + i * 0.08, 0.10 - i * 0.005,
                i.isEven ? base : light);
          }
        }
      case 'orchid': // an orchid nodding on its stem
        {
          poly(const [
            Offset(0.40, 0.72), Offset(0.60, 0.72),
            Offset(0.57, 0.90), Offset(0.43, 0.90),
          ], const Color(0xFFE6E2DA));
          line(0.50, 0.72, 0.46, 0.40, 0.014, const Color(0xFF4F8F4A));
          circ(0.44, 0.70, 0.06, const Color(0xFF3F8F5A));
          final s = wv(0.5) * 0.02;
          for (var i = 0; i < 3; i++) {
            final fy = 0.36 + i * 0.10;
            final fx = 0.46 - i * 0.02 + s;
            for (var p = 0; p < 5; p++) {
              final a = p * 2 * math.pi / 5;
              circ(fx + 0.035 * math.cos(a), fy + 0.035 * math.sin(a), 0.025,
                  base);
            }
            circ(fx, fy, 0.016, const Color(0xFFE0A82E));
          }
        }
      case 'stonestack': // balanced zen stones breathing
        {
          canvas.save();
          canvas.translate(0, wv(0.4) * 0.006 * u);
          const ws = [0.20, 0.16, 0.12, 0.08];
          var y = 0.84;
          for (var i = 0; i < 4; i++) {
            canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(0.50 * u, y * u),
                  width: ws[i] * 2 * u, height: 0.10 * u),
              paint
                ..color = i.isEven ? base : _shade(base, 0.12)
                ..style = PaintingStyle.fill,
            );
            y -= 0.13;
          }
          canvas.restore();
        }
      case 'hottub': // a bubbling hot tub
        {
          box(0.18, 0.52, 0.82, 0.88, 0.10, dark);
          box(0.22, 0.54, 0.78, 0.66, 0.06, base);
          if (on) {
            for (var k = 0; k < 4; k++) {
              final d = saw(1, k / 4.0);
              circ(0.30 + k * 0.14, 0.62 - 0.10 * d, 0.02 - 0.01 * d,
                  offWhite.withValues(alpha: (1 - d) * 0.7));
            }
          }
          steam(0.40, 0.52);
          steam(0.62, 0.52);
        }
      case 'saunabucket': // a sauna bucket steaming, ladle resting
        {
          poly(const [
            Offset(0.32, 0.56), Offset(0.68, 0.56),
            Offset(0.63, 0.88), Offset(0.37, 0.88),
          ], base);
          for (var i = 1; i < 4; i++) {
            line(0.34, 0.56 + i * 0.08, 0.66, 0.56 + i * 0.08, 0.006, dark);
          }
          arc(0.50, 0.56, 0.18, math.pi, math.pi, 0.014, dark);
          line(0.62, 0.52, 0.78, 0.40, 0.012, const Color(0xFFB7A07A));
          circ(0.80, 0.39, 0.04, const Color(0xFFB7A07A));
          steam(0.48, 0.52);
        }
      case 'massagetable': // a massage table, towel gently settling
        {
          box(0.20, 0.54, 0.80, 0.66, 0.04, base);
          box(0.24, 0.66, 0.30, 0.88, 0.01, dark);
          box(0.70, 0.66, 0.76, 0.88, 0.01, dark);
          circ(0.24, 0.56, 0.05, base);
          final b = wv(0.5) * 0.004;
          box(0.40, 0.49 + b, 0.62, 0.55 + b, 0.03, light);
        }
      case 'footbath': // a foot spa rippling
        {
          box(0.24, 0.62, 0.76, 0.88, 0.06, base);
          box(0.28, 0.60, 0.72, 0.70, 0.04, const Color(0xFF8FD0E0));
          if (on) {
            final r = saw(1);
            ring(0.50, 0.65, 0.04 + 0.12 * r, 0.006,
                offWhite.withValues(alpha: (1 - r) * 0.6));
          }
        }
      case 'stonebath': // a stone bath with shimmering water
        {
          box(0.16, 0.50, 0.84, 0.86, 0.12, base);
          box(0.22, 0.54, 0.78, 0.66, 0.06,
              Color.lerp(const Color(0xFF7FC0D8), const Color(0xFFA8DCE8),
                  0.5 + 0.5 * wv(2))!);
          line(0.30, 0.58, 0.46, 0.58, 0.01, offWhite.withValues(alpha: 0.6));
          box(0.18, 0.84, 0.30, 0.90, 0.02, dark);
          box(0.70, 0.84, 0.82, 0.90, 0.02, dark);
        }
      case 'waterfallwall': // water sheets down a wall feature
        {
          box(0.24, 0.18, 0.76, 0.88, 0.04, base);
          box(0.24, 0.18, 0.76, 0.26, 0.04, dark);
          box(0.20, 0.82, 0.80, 0.90, 0.03, dark);
          for (var k = 0; k < 4; k++) {
            final x = 0.32 + k * 0.12;
            line(x, 0.26, x, 0.82, 0.02,
                const Color(0xFFBFE6F0).withValues(alpha: 0.35));
            if (on) {
              final d = saw(1.4, k / 4.0);
              circ(x, 0.26 + 0.56 * d, 0.02,
                  offWhite.withValues(alpha: math.sin(d * math.pi) * 0.7));
            }
          }
        }
      case 'onsen': // a steaming hot spring among rocks
        {
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.74 * u),
                width: 0.66 * u, height: 0.34 * u),
            paint..color = base..style = PaintingStyle.fill,
          );
          circ(0.22, 0.74, 0.08, const Color(0xFF6E665C));
          circ(0.80, 0.72, 0.07, const Color(0xFF6E665C));
          circ(0.66, 0.84, 0.06, const Color(0xFF7A7268));
          if (on) {
            final r = saw(1);
            ring(0.50, 0.74, 0.06 + 0.14 * r, 0.006,
                offWhite.withValues(alpha: (1 - r) * 0.5));
          }
          steam(0.42, 0.60);
          steam(0.60, 0.62);
        }
      // ── Gourmet Kitchen 🍳 ──────────────────────────────────────────────────
      case 'cuttingboard': // a knife chopping on a round board
        {
          circ(0.46, 0.72, 0.20, base);
          box(0.62, 0.68, 0.84, 0.76, 0.03, base);
          circ(0.40, 0.72, 0.05, const Color(0xFFD9534F));
          circ(0.51, 0.76, 0.045, const Color(0xFFE2574C));
          final ch = on ? math.max(0.0, wv(2)) * 0.05 : 0.0;
          line(0.40, 0.50 - ch, 0.58, 0.40 - ch, 0.02, const Color(0xFFB7C0C7));
          line(0.58, 0.40 - ch, 0.66, 0.36 - ch, 0.03, dark);
        }
      case 'spicerack': // wall jars whose lids catch the light
        {
          box(0.20, 0.66, 0.80, 0.72, 0.02, base);
          box(0.20, 0.40, 0.80, 0.46, 0.02, base);
          const cols = [
            Color(0xFFD9534F), Color(0xFFE0A82E),
            Color(0xFF6BA86B), Color(0xFFB07A4A),
          ];
          for (var i = 0; i < 4; i++) {
            final x = 0.28 + i * 0.13;
            box(x - 0.04, 0.50, x + 0.04, 0.66, 0.01, cols[i]);
            final g = on ? wv(3, i * 0.25) * 0.5 + 0.5 : 0.6;
            box(x - 0.045, 0.47, x + 0.045, 0.50, 0.01,
                offWhite.withValues(alpha: g));
          }
        }
      case 'fruitbowl': // a bowl of fruit gently settling
        {
          bowl(0.50, 0.62, 0.26, base);
          box(0.24, 0.60, 0.76, 0.64, 0.02, dark);
          final b = wv(0.6) * 0.008;
          circ(0.40, 0.54 + b, 0.07, const Color(0xFFE2574C));
          circ(0.56, 0.52 + b * 1.3, 0.075, const Color(0xFFE0A82E));
          circ(0.50, 0.58 + b * 0.7, 0.06, const Color(0xFF6BA86B));
          line(0.40, 0.48 + b, 0.42, 0.44 + b, 0.01, const Color(0xFF4F8F4A));
        }
      case 'coffeemaker': // a drip filter steaming as it brews
        {
          box(0.30, 0.30, 0.70, 0.86, 0.05, base);
          box(0.34, 0.34, 0.66, 0.40, 0.02, dark);
          box(0.36, 0.62, 0.64, 0.84, 0.03, const Color(0xFF2A2A2A));
          box(0.38, 0.66, 0.62, 0.84, 0.04, const Color(0xFF6B3A20));
          if (on) {
            final d = saw(2);
            circ(0.50, 0.58 + 0.04 * d, 0.012,
                const Color(0xFF6B3A20).withValues(alpha: 1 - d));
          }
          steam(0.50, 0.62);
        }
      case 'blender': // whirring blades behind glass
        {
          box(0.40, 0.66, 0.60, 0.86, 0.04, base);
          box(0.36, 0.30, 0.64, 0.66, 0.03, const Color(0x668FB7C0));
          box(0.36, 0.28, 0.64, 0.34, 0.02, dark);
          box(0.40, 0.56, 0.60, 0.64, 0.0, const Color(0x55A8CFA0));
          final r = saw(2) * 2 * math.pi;
          for (var i = 0; i < 3; i++) {
            final a = r + i * math.pi / 1.5;
            line(0.50, 0.58, 0.50 + 0.08 * math.cos(a),
                0.58 + 0.04 * math.sin(a), 0.012, const Color(0xFFB7C0C7));
          }
        }
      case 'cookbook': // an open cookbook with a page that flutters
        {
          line(0.30, 0.86, 0.50, 0.66, 0.02, dark);
          line(0.70, 0.86, 0.50, 0.66, 0.02, dark);
          poly(const [
            Offset(0.26, 0.62), Offset(0.50, 0.56),
            Offset(0.50, 0.78), Offset(0.26, 0.82),
          ], base);
          poly(const [
            Offset(0.74, 0.62), Offset(0.50, 0.56),
            Offset(0.50, 0.78), Offset(0.74, 0.82),
          ], _shade(base, -0.08));
          box(0.30, 0.60, 0.49, 0.78, 0.0, offWhite);
          box(0.51, 0.60, 0.70, 0.78, 0.0, offWhite);
          if (on) {
            final f = wv(1.5) * 0.5 + 0.5;
            poly([
              Offset(0.50, 0.57), Offset(0.50 + 0.12 * f, 0.59),
              Offset(0.50 + 0.12 * f, 0.76), Offset(0.50, 0.77),
            ], offWhite.withValues(alpha: 0.85));
          }
          line(0.34, 0.66, 0.45, 0.66, 0.006, dark);
          line(0.34, 0.70, 0.45, 0.70, 0.006, dark);
        }
      case 'potrack': // copper pots swaying from a wall rail
        {
          box(0.18, 0.34, 0.82, 0.40, 0.02, base);
          const pc = [Color(0xFFC0584F), Color(0xFF566066), Color(0xFFB7C0C7)];
          for (var i = 0; i < 3; i++) {
            final x = 0.32 + i * 0.18;
            final s = wv(0.7, i * 0.3) * 0.02;
            line(x, 0.40, x + s, 0.52, 0.01, dark);
            box(x - 0.07 + s, 0.52, x + 0.07 + s, 0.66, 0.03, pc[i]);
            line(x - 0.10 + s, 0.53, x - 0.07 + s, 0.53, 0.012, dark);
            line(x + 0.07 + s, 0.53, x + 0.10 + s, 0.53, 0.012, dark);
          }
        }
      case 'breadbasket': // baguettes in a basket, one bobbing
        {
          bowl(0.50, 0.74, 0.28, base);
          for (var i = 0; i < 3; i++) {
            final bb = i == 1 && on ? wv(0.8) * 0.01 : 0.0;
            line(0.36 + i * 0.10, 0.66 + bb, 0.50 + i * 0.10, 0.46 + bb, 0.05,
                const Color(0xFFD9A86A));
          }
          line(0.26, 0.72, 0.74, 0.72, 0.006, dark);
          line(0.30, 0.78, 0.70, 0.78, 0.006, dark);
        }
      case 'espresso': // an espresso machine venting steam
        {
          box(0.24, 0.40, 0.76, 0.86, 0.05, base);
          box(0.24, 0.36, 0.76, 0.44, 0.03, dark);
          box(0.34, 0.58, 0.66, 0.64, 0.02, const Color(0xFF3A3A3A));
          line(0.50, 0.64, 0.50, 0.72, 0.02, const Color(0xFF3A3A3A));
          box(0.42, 0.72, 0.58, 0.84, 0.02, offWhite);
          circ(0.66, 0.50, 0.03, const Color(0xFFE2574C));
          if (on) {
            final d = saw(3);
            circ(0.50, 0.72 + 0.04 * d, 0.008,
                const Color(0xFF6B3A20).withValues(alpha: 1 - d));
          }
          steam(0.30, 0.50);
        }
      case 'standmixer': // a stand mixer with a turning beater
        {
          box(0.30, 0.78, 0.70, 0.86, 0.04, base);
          box(0.30, 0.30, 0.40, 0.80, 0.03, base);
          poly(const [
            Offset(0.30, 0.30), Offset(0.64, 0.30),
            Offset(0.68, 0.46), Offset(0.34, 0.46),
          ], base);
          bowl(0.54, 0.62, 0.16, const Color(0xFFB7C0C7));
          final r = saw(2) * 2 * math.pi;
          line(0.54, 0.48, 0.54 + 0.05 * math.cos(r), 0.60 + 0.05 * math.sin(r),
              0.012, dark);
        }
      case 'winerack': // bottles in a rack, one glinting
        {
          box(0.24, 0.40, 0.76, 0.86, 0.03, base);
          for (var i = 0; i < 3; i++) {
            line(0.24, 0.40 + i * 0.16, 0.76, 0.40 + i * 0.16, 0.01, dark);
          }
          const wc = [
            Color(0xFF7A2E3A), Color(0xFF2E5A3A),
            Color(0xFF7A2E3A), Color(0xFF3A3A5A),
          ];
          for (var i = 0; i < 4; i++) {
            final x = 0.32 + i * 0.12;
            box(x - 0.03, 0.44, x + 0.03, 0.62, 0.02, wc[i]);
            circ(x, 0.44, 0.02, wc[i]);
          }
          if (on) {
            final g = saw(0.6);
            line(0.30 + g * 0.3, 0.50, 0.34 + g * 0.3, 0.50, 0.012,
                offWhite.withValues(alpha: math.sin(g * math.pi) * 0.5));
          }
        }
      case 'rangehood': // a hood over a flickering gas burner
        {
          poly(const [
            Offset(0.24, 0.34), Offset(0.76, 0.34),
            Offset(0.66, 0.50), Offset(0.34, 0.50),
          ], base);
          box(0.44, 0.30, 0.56, 0.34, 0.01, dark);
          box(0.30, 0.80, 0.70, 0.86, 0.02, const Color(0xFF566066));
          circ(0.50, 0.80, 0.06, const Color(0xFF3A3A3A));
          if (on) {
            final f = 1 + wv(6) * 0.3;
            poly([
              Offset(0.50, 0.72 - 0.06 * f),
              Offset(0.45, 0.80), Offset(0.55, 0.80),
            ], const Color(0xFF4A8FE0));
          }
        }
      case 'kitchenisland': // an island counter with a stool
        {
          box(0.18, 0.50, 0.82, 0.84, 0.03, base);
          box(0.16, 0.46, 0.84, 0.52, 0.02, const Color(0xFFE6E2DA));
          box(0.66, 0.62, 0.74, 0.66, 0.02, dark);
          line(0.67, 0.66, 0.67, 0.84, 0.012, dark);
          line(0.73, 0.66, 0.73, 0.84, 0.012, dark);
          final b = wv(0.6) * 0.006;
          bowl(0.34, 0.46 + b, 0.06, const Color(0xFFD9534F));
        }
      case 'smartfridge': // a smart fridge with a glowing screen
        {
          box(0.28, 0.16, 0.72, 0.88, 0.05, base);
          line(0.28, 0.50, 0.72, 0.50, 0.01, dark);
          box(0.62, 0.30, 0.68, 0.46, 0.02, dark);
          box(0.62, 0.56, 0.68, 0.72, 0.02, dark);
          box(0.34, 0.22, 0.52, 0.44, 0.02,
              Color.lerp(const Color(0xFF2E6E8E), const Color(0xFF3E8EAE),
                  0.5 + 0.5 * wv(4))!);
          line(0.37, 0.28, 0.49, 0.28, 0.008,
              offWhite.withValues(alpha: 0.7));
          line(0.37, 0.34, 0.46, 0.34, 0.008,
              offWhite.withValues(alpha: 0.5));
        }
      case 'pizzaoven': // a wood-fired oven glowing at the mouth
        {
          box(0.18, 0.78, 0.82, 0.88, 0.02, const Color(0xFF6E5A52));
          box(0.62, 0.40, 0.70, 0.56, 0.02, const Color(0xFF6E5A52));
          steam(0.66, 0.40);
          dome(0.50, 0.78, 0.34, base);
          final glow = on ? 0.5 + 0.5 * wv(5) : 0.6;
          dome(0.50, 0.74, 0.16,
              Color.lerp(const Color(0xFF7A3A1A), const Color(0xFFE8862C),
                  glow)!);
          if (on) {
            final f = 1 + wv(7) * 0.3;
            poly([
              Offset(0.50, 0.66 - 0.06 * f),
              Offset(0.45, 0.74), Offset(0.55, 0.74),
            ], const Color(0xFFF2A03C));
          }
        }
      // ── Art Studio 🎨 ───────────────────────────────────────────────────────
      case 'easel': // a canvas on an easel, the painted sun pulsing
        {
          line(0.50, 0.30, 0.30, 0.88, 0.02, base);
          line(0.50, 0.30, 0.70, 0.88, 0.02, base);
          line(0.55, 0.50, 0.62, 0.88, 0.02, base);
          box(0.34, 0.28, 0.66, 0.58, 0.02, offWhite);
          box(0.34, 0.54, 0.66, 0.58, 0.01, base);
          poly(const [
            Offset(0.38, 0.50), Offset(0.50, 0.36), Offset(0.62, 0.50),
          ], const Color(0xFF6BA86B));
          final p = on ? wv(2) * 0.5 + 0.5 : 0.5;
          circ(0.58, 0.36, 0.03,
              const Color(0xFFE0A82E).withValues(alpha: 0.6 + 0.4 * p));
        }
      case 'palette': // a paint palette whose blobs glisten
        {
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.48 * u, 0.62 * u),
                width: 0.6 * u, height: 0.4 * u),
            paint..color = base..style = PaintingStyle.fill,
          );
          circ(0.58, 0.70, 0.05, _shade(base, -0.18));
          const blobs = [
            Color(0xFFE2574C), Color(0xFFE0A82E), Color(0xFF4A8FE0),
            Color(0xFF6BA86B), Color(0xFF8E68C8),
          ];
          for (var i = 0; i < 5; i++) {
            final a = i * 2 * math.pi / 5;
            final g = on ? wv(3, i * 0.2) * 0.3 + 0.7 : 0.85;
            circ(0.46 + 0.16 * math.cos(a), 0.58 + 0.11 * math.sin(a), 0.035,
                blobs[i].withValues(alpha: g));
          }
          line(0.66, 0.50, 0.84, 0.34, 0.012, const Color(0xFFB07A4A));
          circ(0.66, 0.50, 0.02, const Color(0xFFE2574C));
        }
      case 'brushjar': // brushes leaning in a jar, swaying
        {
          box(0.38, 0.56, 0.62, 0.86, 0.04, base.withValues(alpha: 0.6));
          box(0.38, 0.66, 0.62, 0.86, 0.04, const Color(0x88B0C0C8));
          const bc = [
            Color(0xFFE2574C), Color(0xFF4A8FE0),
            Color(0xFFE0A82E), Color(0xFF6BA86B),
          ];
          for (var i = 0; i < 4; i++) {
            final s = wv(0.7, i * 0.3) * 0.03;
            line(0.44 + i * 0.04, 0.62, 0.40 + i * 0.06 + s, 0.28, 0.012,
                const Color(0xFFB07A4A));
            circ(0.40 + i * 0.06 + s, 0.27, 0.02, bc[i]);
          }
        }
      case 'paintcans': // stacked paint cans, a drip running down
        {
          const cc = [Color(0xFFE2574C), Color(0xFFE0A82E)];
          box(0.28, 0.66, 0.50, 0.86, 0.02, cc[0]);
          box(0.52, 0.66, 0.74, 0.86, 0.02, cc[1]);
          box(0.40, 0.44, 0.62, 0.64, 0.02, base);
          box(0.28, 0.64, 0.50, 0.68, 0.01, dark);
          box(0.52, 0.64, 0.74, 0.68, 0.01, dark);
          box(0.40, 0.42, 0.62, 0.46, 0.01, dark);
          if (on) {
            final d = saw(0.8);
            circ(0.51, 0.64 + 0.2 * d, 0.015, base.withValues(alpha: 1 - d));
          }
        }
      case 'sketchpad': // a pencil sketches a line across the pad
        {
          line(0.32, 0.88, 0.46, 0.56, 0.02, dark);
          line(0.68, 0.88, 0.54, 0.56, 0.02, dark);
          box(0.30, 0.36, 0.70, 0.62, 0.02, offWhite);
          box(0.30, 0.34, 0.70, 0.40, 0.02, base);
          for (var i = 0; i < 6; i++) {
            circ(0.34 + i * 0.06, 0.37, 0.008, dark);
          }
          line(0.36, 0.48, 0.50, 0.44, 0.008, const Color(0xFF888888));
          if (on) {
            final d = saw(1);
            line(0.36, 0.54, 0.36 + 0.28 * d, 0.54, 0.008, dark);
            circ(0.36 + 0.28 * d, 0.54, 0.012, const Color(0xFFE0A82E));
          }
        }
      case 'pottery': // a thrown vase with a soft highlight
        {
          poly(const [
            Offset(0.42, 0.40), Offset(0.58, 0.40), Offset(0.66, 0.62),
            Offset(0.60, 0.86), Offset(0.40, 0.86), Offset(0.34, 0.62),
          ], base);
          box(0.44, 0.34, 0.56, 0.42, 0.02, base);
          final g = on ? wv(1.5) * 0.3 + 0.5 : 0.5;
          line(0.44, 0.56, 0.44, 0.74, 0.01, offWhite.withValues(alpha: g));
          line(0.36, 0.62, 0.64, 0.62, 0.006, dark);
        }
      case 'bust': // a sculpted bust with a faint highlight
        {
          box(0.36, 0.78, 0.64, 0.88, 0.02, dark);
          circ(0.50, 0.50, 0.16, base);
          poly(const [
            Offset(0.40, 0.60), Offset(0.60, 0.60),
            Offset(0.64, 0.78), Offset(0.36, 0.78),
          ], base);
          poly(const [
            Offset(0.50, 0.46), Offset(0.58, 0.50), Offset(0.50, 0.52),
          ], _shade(base, -0.08));
          final g = on ? wv(1.2) * 0.2 + 0.4 : 0.4;
          line(0.42, 0.44, 0.42, 0.54, 0.01, offWhite.withValues(alpha: g));
        }
      case 'colorwheel': // a slowly spinning colour wheel (wall)
        {
          canvas.save();
          canvas.translate(0.50 * u, 0.50 * u);
          if (on) canvas.rotate(t * 2 * math.pi * 0.2);
          const cw = [
            Color(0xFFE2574C), Color(0xFFF08A3C), Color(0xFFF4C430),
            Color(0xFF5BA85A), Color(0xFF4A8FE0), Color(0xFF8E68C8),
          ];
          for (var i = 0; i < 6; i++) {
            canvas.drawArc(
              Rect.fromCircle(center: Offset.zero, radius: 0.30 * u),
              i * math.pi / 3, math.pi / 3, true,
              paint..color = cw[i]..style = PaintingStyle.fill,
            );
          }
          canvas.restore();
          circ(0.50, 0.50, 0.06, offWhite);
        }
      case 'potterywheel': // clay spinning on a pottery wheel
        {
          box(0.30, 0.78, 0.70, 0.86, 0.02, base);
          box(0.46, 0.62, 0.54, 0.80, 0.02, dark);
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.60 * u),
                width: 0.5 * u, height: 0.14 * u),
            paint..color = dark..style = PaintingStyle.fill,
          );
          circ(0.50, 0.54, 0.08, const Color(0xFF9E6B43));
          final a = saw(2) * 2 * math.pi;
          circ(0.50 + 0.04 * math.cos(a), 0.54 + 0.015 * math.sin(a), 0.02,
              const Color(0xFFB98A5A));
        }
      case 'abstractart': // an abstract canvas that shimmers (wall)
        {
          box(0.20, 0.20, 0.80, 0.80, 0.02, base);
          box(0.24, 0.24, 0.76, 0.76, 0.01, offWhite);
          final s = on ? 0.6 + 0.4 * wv(2) : 0.8;
          circ(0.40, 0.42, 0.12, const Color(0xFFE2574C).withValues(alpha: s));
          box(0.52, 0.30, 0.70, 0.62, 0.0,
              const Color(0xFF4A8FE0).withValues(alpha: s * 0.9));
          poly([
            Offset(0.30, 0.70), Offset(0.50, 0.50), Offset(0.66, 0.72),
          ], const Color(0xFFE0A82E).withValues(alpha: s));
        }
      case 'artmannequin': // a wooden artist's mannequin breathing
        {
          canvas.save();
          canvas.translate(0, wv(0.5) * 0.006 * u);
          box(0.44, 0.74, 0.56, 0.86, 0.02, dark);
          line(0.50, 0.74, 0.50, 0.62, 0.02, base);
          circ(0.50, 0.30, 0.07, base);
          box(0.44, 0.36, 0.56, 0.56, 0.04, base);
          circ(0.50, 0.58, 0.05, base);
          line(0.44, 0.40, 0.34, 0.52, 0.03, base);
          line(0.56, 0.40, 0.66, 0.50, 0.03, base);
          line(0.46, 0.62, 0.42, 0.74, 0.03, base);
          line(0.54, 0.62, 0.58, 0.74, 0.03, base);
          canvas.restore();
        }
      case 'draftingtable': // an angled drafting table with a lamp
        {
          poly(const [
            Offset(0.22, 0.40), Offset(0.74, 0.30),
            Offset(0.78, 0.42), Offset(0.26, 0.52),
          ], base);
          box(0.24, 0.50, 0.30, 0.86, 0.02, dark);
          line(0.70, 0.42, 0.72, 0.86, 0.02, dark);
          box(0.30, 0.44, 0.58, 0.50, 0.0, offWhite);
          line(0.66, 0.40, 0.74, 0.24, 0.012, const Color(0xFF566066));
          circ(0.74, 0.22, 0.04, const Color(0xFF566066));
          if (on) {
            final g = 0.4 + 0.4 * wv(4);
            poly([
              Offset(0.74, 0.24), Offset(0.58, 0.44), Offset(0.70, 0.46),
            ], const Color(0xFFF4D88A).withValues(alpha: g));
          }
        }
      case 'kiln': // a kiln glowing through its window
        {
          box(0.28, 0.30, 0.72, 0.86, 0.04, base);
          box(0.28, 0.26, 0.72, 0.34, 0.03, dark);
          final glow = on ? 0.4 + 0.6 * wv(5) : 0.6;
          box(0.40, 0.48, 0.60, 0.70, 0.03,
              Color.lerp(const Color(0xFF7A3A1A), const Color(0xFFF2862C),
                  glow)!);
          box(0.40, 0.48, 0.60, 0.50, 0.01, dark);
          circ(0.50, 0.40, 0.03, const Color(0xFFE2574C));
        }
      case 'marblestatue': // a marble figure on a plinth
        {
          box(0.34, 0.80, 0.66, 0.90, 0.02, _shade(base, -0.10));
          circ(0.50, 0.34, 0.09, base);
          poly(const [
            Offset(0.40, 0.42), Offset(0.60, 0.42),
            Offset(0.66, 0.80), Offset(0.34, 0.80),
          ], base);
          line(0.44, 0.50, 0.42, 0.78, 0.008, _shade(base, -0.12));
          line(0.54, 0.50, 0.56, 0.78, 0.008, _shade(base, -0.12));
          final g = on ? wv(1) * 0.2 + 0.5 : 0.5;
          line(0.46, 0.46, 0.46, 0.60, 0.01, offWhite.withValues(alpha: g));
        }
      case 'grandeasel': // a gilt masterpiece on a grand easel
        {
          line(0.50, 0.20, 0.26, 0.90, 0.026, base);
          line(0.50, 0.20, 0.74, 0.90, 0.026, base);
          line(0.58, 0.55, 0.66, 0.90, 0.026, base);
          box(0.28, 0.20, 0.72, 0.62, 0.03, const Color(0xFFD7A93A));
          box(0.32, 0.24, 0.68, 0.58, 0.01, const Color(0xFF2E3A5A));
          final s = on ? 0.5 + 0.5 * wv(3) : 0.7;
          circ(0.50, 0.40, 0.10,
              const Color(0xFFE8C36A).withValues(alpha: s));
          poly([
            Offset(0.40, 0.54), Offset(0.50, 0.44), Offset(0.60, 0.54),
          ], const Color(0xFFC9A24A).withValues(alpha: s));
          box(0.30, 0.58, 0.70, 0.62, 0.0, const Color(0xFFD7A93A));
        }
      // ── Game Room 🎮 ────────────────────────────────────────────────────────
      case 'gamepad': // a controller whose face buttons blink
        {
          box(0.26, 0.40, 0.74, 0.62, 0.10, base);
          circ(0.30, 0.58, 0.10, base);
          circ(0.70, 0.58, 0.10, base);
          box(0.34, 0.46, 0.40, 0.56, 0.01, dark);
          box(0.31, 0.49, 0.43, 0.53, 0.01, dark);
          const bcol = [
            Color(0xFFE2574C), Color(0xFF5BA85A),
            Color(0xFF4A8FE0), Color(0xFFF4C430),
          ];
          for (var i = 0; i < 4; i++) {
            final a = i * math.pi / 2;
            final bl = on ? wv(2, i * 0.25) * 0.4 + 0.6 : 0.8;
            circ(0.64 + 0.04 * math.cos(a), 0.51 + 0.04 * math.sin(a), 0.022,
                bcol[i].withValues(alpha: bl));
          }
        }
      case 'retroconsole': // a console with a blinking power LED
        {
          box(0.24, 0.56, 0.76, 0.78, 0.03, base);
          box(0.30, 0.46, 0.50, 0.58, 0.02, const Color(0xFF888888));
          box(0.33, 0.40, 0.47, 0.50, 0.02, const Color(0xFFE2574C));
          box(0.56, 0.70, 0.74, 0.80, 0.02, dark);
          final bl = on ? (saw(1.5) < 0.5 ? 1.0 : 0.2) : 0.8;
          circ(0.68, 0.61, 0.02, const Color(0xFF5BA85A).withValues(alpha: bl));
        }
      case 'dartboard': // a dartboard with a pulsing bullseye (wall)
        {
          circ(0.50, 0.50, 0.34, const Color(0xFF2A2A2A));
          circ(0.50, 0.50, 0.30, base);
          circ(0.50, 0.50, 0.20, const Color(0xFFE6E2DA));
          circ(0.50, 0.50, 0.12, base);
          final p = on ? wv(2) * 0.3 + 0.7 : 0.8;
          circ(0.50, 0.50, 0.05,
              const Color(0xFFE2574C).withValues(alpha: p));
          line(0.62, 0.40, 0.80, 0.28, 0.012, const Color(0xFFB7C0C7));
          poly(const [
            Offset(0.62, 0.40), Offset(0.60, 0.45), Offset(0.66, 0.43),
          ], const Color(0xFFE0A82E));
        }
      case 'dicetower': // a die tumbling out of a dice tower
        {
          poly(const [
            Offset(0.36, 0.24), Offset(0.64, 0.24),
            Offset(0.64, 0.74), Offset(0.36, 0.74),
          ], base);
          box(0.36, 0.70, 0.72, 0.80, 0.02, dark);
          box(0.40, 0.24, 0.60, 0.30, 0.01, dark);
          if (on) {
            final d = saw(1);
            canvas.save();
            canvas.translate(0.50 * u, (0.30 + 0.44 * d) * u);
            canvas.rotate(d * math.pi);
            box(-0.05, -0.05, 0.05, 0.05, 0.01, offWhite);
            canvas.restore();
          }
          box(0.58, 0.70, 0.68, 0.78, 0.01, offWhite);
          circ(0.63, 0.74, 0.008, dark);
        }
      case 'neonsign': // a flickering neon sign (wall)
        {
          box(0.18, 0.34, 0.82, 0.66, 0.06, const Color(0xFF2A2A2A));
          final fl = on ? wv(8) * 0.2 + 0.78 : 0.9;
          arc(0.34, 0.50, 0.10, 0, 2 * math.pi, 0.018,
              base.withValues(alpha: fl));
          line(0.50, 0.42, 0.50, 0.58, 0.018, base.withValues(alpha: fl));
          arc(0.66, 0.50, 0.10, math.pi * 0.2, math.pi * 1.6, 0.018,
              base.withValues(alpha: fl));
          circ(0.50, 0.30, 0.02, base.withValues(alpha: fl));
        }
      case 'gamingchair': // a racing-style gaming chair
        {
          box(0.34, 0.20, 0.66, 0.62, 0.05, base);
          box(0.34, 0.20, 0.66, 0.30, 0.04, const Color(0xFF2A2A2A));
          box(0.30, 0.58, 0.70, 0.68, 0.04, base);
          box(0.30, 0.30, 0.36, 0.58, 0.03, const Color(0xFF2A2A2A));
          box(0.64, 0.30, 0.70, 0.58, 0.03, const Color(0xFF2A2A2A));
          line(0.50, 0.68, 0.50, 0.82, 0.02, dark);
          box(0.36, 0.82, 0.64, 0.86, 0.02, dark);
          final r = saw(0.5) * 2 * math.pi;
          circ(0.50, 0.25, 0.02,
              const Color(0xFFE2574C)
                  .withValues(alpha: 0.6 + 0.4 * math.sin(r)));
        }
      case 'vrheadset': // a VR headset on a stand, lenses glowing
        {
          line(0.50, 0.62, 0.50, 0.86, 0.02, dark);
          box(0.40, 0.84, 0.60, 0.88, 0.02, dark);
          box(0.30, 0.44, 0.70, 0.62, 0.06, base);
          box(0.30, 0.46, 0.34, 0.60, 0.03, dark);
          final g = on ? 0.5 + 0.5 * wv(3) : 0.7;
          circ(0.42, 0.53, 0.04,
              const Color(0xFF6FE0E0).withValues(alpha: g));
          circ(0.58, 0.53, 0.04,
              const Color(0xFF6FE0E0).withValues(alpha: g));
        }
      case 'boardgame': // a board game with a token hopping
        {
          box(0.24, 0.54, 0.76, 0.86, 0.03, base);
          box(0.24, 0.50, 0.76, 0.58, 0.02, dark);
          for (var i = 0; i < 4; i++) {
            line(0.30 + i * 0.13, 0.66, 0.30 + i * 0.13, 0.82, 0.006,
                offWhite.withValues(alpha: 0.5));
          }
          line(0.28, 0.74, 0.74, 0.74, 0.006, offWhite.withValues(alpha: 0.5));
          final h = on ? math.sin(saw(1) * math.pi) * 0.08 : 0.0;
          circ(0.40, 0.74 - h, 0.03, const Color(0xFFE2574C));
          circ(0.58, 0.70, 0.03, const Color(0xFF4A8FE0));
          box(0.62, 0.62, 0.70, 0.70, 0.01, offWhite);
          circ(0.66, 0.66, 0.008, dark);
        }
      case 'pinball': // a pinball machine, bumpers flashing
        {
          box(0.30, 0.16, 0.70, 0.40, 0.03, base);
          box(0.33, 0.19, 0.67, 0.34, 0.02, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.28, 0.42), Offset(0.72, 0.42),
            Offset(0.66, 0.86), Offset(0.34, 0.86),
          ], _shade(base, -0.10));
          const bp = [Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFF4A8FE0)];
          for (var i = 0; i < 3; i++) {
            final bl = on ? wv(3, i * 0.33) * 0.5 + 0.5 : 0.8;
            circ(0.42 + i * 0.10, 0.56, 0.035, bp[i].withValues(alpha: bl));
          }
          line(0.42, 0.78, 0.48, 0.82, 0.02, offWhite);
          line(0.58, 0.78, 0.52, 0.82, 0.02, offWhite);
          circ(0.62, 0.70, 0.018, const Color(0xFFD0D6DA));
          line(0.34, 0.86, 0.32, 0.92, 0.02, dark);
          line(0.66, 0.86, 0.68, 0.92, 0.02, dark);
        }
      case 'jukebox': // a jukebox with pulsing light arcs
        {
          dome(0.50, 0.40, 0.26, base);
          box(0.24, 0.40, 0.76, 0.86, 0.04, base);
          const arcCols = [
            Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFF4A8FE0),
          ];
          for (var i = 0; i < 3; i++) {
            final pl = on ? wv(3, i * 0.3) * 0.4 + 0.6 : 0.7;
            arc(0.50, 0.40, 0.16 - i * 0.04, math.pi, math.pi, 0.012,
                arcCols[i].withValues(alpha: pl));
          }
          box(0.34, 0.50, 0.66, 0.66, 0.02, const Color(0xFF2A2A2A));
          box(0.34, 0.70, 0.66, 0.80, 0.02, const Color(0xFF3A3A3A));
          for (var i = 0; i < 5; i++) {
            line(0.37 + i * 0.06, 0.52, 0.37 + i * 0.06, 0.64, 0.01, dark);
          }
        }
      case 'pooltable': // a pool table, balls racked
        {
          box(0.16, 0.50, 0.84, 0.82, 0.04, const Color(0xFF6D4C41));
          box(0.20, 0.54, 0.80, 0.78, 0.02, base);
          for (final p in const [
            Offset(0.22, 0.56), Offset(0.78, 0.56), Offset(0.22, 0.76),
            Offset(0.78, 0.76), Offset(0.50, 0.55), Offset(0.50, 0.77),
          ]) {
            circ(p.dx, p.dy, 0.025, const Color(0xFF1A1A1A));
          }
          const balls = [Color(0xFFF4C430), Color(0xFFE2574C), Color(0xFF4A8FE0)];
          for (var i = 0; i < 3; i++) {
            circ(0.44 + i * 0.06, 0.66, 0.022, balls[i]);
          }
          final gl = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.62, 0.66, 0.022, offWhite);
          circ(0.60, 0.64, 0.006, offWhite.withValues(alpha: gl));
        }
      case 'foosball': // a foosball table with little players
        {
          box(0.18, 0.52, 0.82, 0.80, 0.04, base);
          box(0.22, 0.56, 0.78, 0.76, 0.02, const Color(0xFF3E7D4A));
          const pcol = [Color(0xFFE2574C), Color(0xFF4A8FE0)];
          for (var i = 0; i < 3; i++) {
            final y = 0.60 + i * 0.06;
            final sh = on ? wv(2, i * 0.3) * 0.02 : 0.0;
            line(0.16, y, 0.84, y, 0.008, const Color(0xFFC0C6CA));
            for (var j = 0; j < 3; j++) {
              circ(0.34 + j * 0.16 + sh, y, 0.022, pcol[i % 2]);
            }
          }
          circ(0.50, 0.66, 0.012, offWhite);
        }
      case 'racingsim': // a racing cockpit with a glowing screen
        {
          box(0.20, 0.40, 0.42, 0.84, 0.05, base);
          box(0.20, 0.40, 0.42, 0.50, 0.03, const Color(0xFFE2574C));
          ring(0.50, 0.62, 0.08, 0.02, const Color(0xFF2A2A2A));
          line(0.50, 0.62, 0.50, 0.70, 0.02, const Color(0xFF2A2A2A));
          box(0.56, 0.30, 0.86, 0.56, 0.02, const Color(0xFF2A2A2A));
          box(0.58, 0.32, 0.84, 0.54, 0.01,
              Color.lerp(const Color(0xFF2E5A8E), const Color(0xFF3E7ABE),
                  0.5 + 0.5 * wv(5))!);
          line(0.71, 0.56, 0.71, 0.74, 0.02, dark);
          box(0.62, 0.74, 0.80, 0.78, 0.02, dark);
          box(0.30, 0.82, 0.46, 0.86, 0.02, const Color(0xFF2A2A2A));
        }
      case 'clawmachine': // a claw dips and rises over the prizes
        {
          box(0.24, 0.16, 0.76, 0.86, 0.04, base);
          box(0.28, 0.24, 0.72, 0.60, 0.02, const Color(0x553A6A8E));
          const pr = [
            Color(0xFFE2574C), Color(0xFFF4C430),
            Color(0xFF6BA86B), Color(0xFFE86BA8),
          ];
          for (var i = 0; i < 4; i++) {
            circ(0.34 + i * 0.10, 0.56, 0.04, pr[i]);
          }
          line(0.28, 0.27, 0.72, 0.27, 0.01, dark);
          final d = on ? math.sin(saw(0.7) * 2 * math.pi) * 0.5 + 0.5 : 0.2;
          final cy = 0.30 + 0.18 * d;
          line(0.50, 0.27, 0.50, cy, 0.012, const Color(0xFF888888));
          poly([
            Offset(0.46, cy), Offset(0.54, cy),
            Offset(0.52, cy + 0.05), Offset(0.48, cy + 0.05),
          ], const Color(0xFF888888));
          box(0.28, 0.64, 0.44, 0.80, 0.02, dark);
        }
      case 'arcadetower': // a neon arcade cabinet, marquee + screen pulsing
        {
          box(0.28, 0.14, 0.72, 0.88, 0.04, base);
          final ml = on ? wv(3) * 0.3 + 0.7 : 0.8;
          box(0.30, 0.16, 0.70, 0.26, 0.02,
              const Color(0xFFE86BA8).withValues(alpha: ml));
          box(0.32, 0.30, 0.68, 0.52, 0.02,
              Color.lerp(const Color(0xFF20305A), const Color(0xFF3050A0),
                  0.5 + 0.5 * wv(5))!);
          for (var i = 0; i < 3; i++) {
            box(0.38 + i * 0.09, 0.40, 0.44 + i * 0.09, 0.46, 0.01,
                const Color(0xFF5BE07A));
          }
          box(0.30, 0.56, 0.70, 0.66, 0.02, const Color(0xFF2A2A2A));
          line(0.36, 0.61, 0.36, 0.57, 0.012, dark);
          circ(0.36, 0.565, 0.015, const Color(0xFFE2574C));
          circ(0.46, 0.61, 0.02, const Color(0xFFF4C430));
          circ(0.54, 0.61, 0.02, const Color(0xFF4A8FE0));
          final ng = on ? wv(3, 0.5) * 0.4 + 0.6 : 0.7;
          line(0.28, 0.30, 0.28, 0.82, 0.012,
              const Color(0xFF8E68C8).withValues(alpha: ng));
          line(0.72, 0.30, 0.72, 0.82, 0.012,
              const Color(0xFF8E68C8).withValues(alpha: ng));
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
