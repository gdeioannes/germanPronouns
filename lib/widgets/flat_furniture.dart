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
  // ── Wave 2 ────────────────────────────────────────────────────────────────
  'crib', 'kidsbed', 'bunkbed', 'canopybed',
  'paperlantern', 'lavalamp', 'arclamp', 'neonhalo', 'chandelier',
  'snakeplant', 'monstera', 'bigcactus', 'figtree', 'bonsai', 'citrustree',
  'shutterwindow', 'skylight', 'baywindow', 'stainedglass',
  'artswirl', 'artscream', 'artpearl', 'artsunflowers', 'artgothic',
  'artmondrian', 'artwave', 'artlilies',
  'towelwarmer', 'bubbletub', 'rainshower', 'clawtub', 'walkinshower',
  'doublevanity', 'designertub', 'steamsauna',
  'windchime', 'hourglass', 'snowglobe', 'blocktower', 'terrarium',
  'recordplayer',
  'hamster', 'duck', 'bunny', 'turtle', 'puppy', 'dog', 'parrot', 'fishtank',
  'daisies', 'tulips', 'lavender', 'roses',
  'hotstones', 'coldplunge', 'saunacabin',
  'waffleiron', 'airfryer', 'mixerpro',
  'coffeecup', 'donut', 'croissant', 'cupcake', 'taco', 'icecream', 'burger',
  'pizza', 'cake', 'ramen', 'sushi', 'fruitbasket',
  'spraycans', 'sculptstand', 'screenpress',
  'handheld', 'gachapon', 'modconsole',
  // Existing piece given a livelier idle: flies circling the trash can.
  'trashcan',
  // ── Wave 3 ────────────────────────────────────────────────────────────────
  'lollipop', 'friedegg', 'strawberry', 'cookie', 'bagel', 'avocado',
  'chocolatebar', 'fries', 'grapes', 'muffin', 'hotdog', 'watermelon',
  'cinnamonroll', 'popcorn', 'pretzel', 'milkshake', 'sandwich', 'salad',
  'bobatea', 'pancakes', 'cocktail', 'dumplings', 'macarons', 'pie',
  'spaghetti', 'steak', 'winebottle', 'cheeseboard',
  'artpipe', 'artrothko', 'artbird', 'artharing', 'artcomic', 'artkandinsky',
  'artwhistler', 'artpop', 'artbasquiat', 'artapple', 'artballoon',
  'artpollock', 'artnighthawks', 'artpointillism', 'artsunrise', 'artcafe',
  'artmelt', 'artnightwatch', 'artvenus', 'artkiss', 'artmona', 'artarnolfini',
  'artbosch', 'artcreation',
  'pinwheel', 'pennant', 'puzzlecube', 'incense', 'dreamcatcher',
  'kaleidoscope', 'magicball', 'abacus', 'fairylights', 'crystalcluster',
  'newtoncradle', 'musicbox', 'chessset', 'fortunecat',
  // ── Wave 4 ────────────────────────────────────────────────────────────────
  'gummybears', 'baguette', 'candyapple', 'gingerbread', 'churros', 'waffle',
  'soup', 'friedchicken', 'breakfastplate', 'bento',
  'artcave', 'artegypt', 'artredroom', 'artrain', 'artflag', 'artgrid',
  'artmiro', 'artdance', 'artbar', 'artjungle', 'artvanitas', 'artgeisha',
  'artweeping', 'artselfvan', 'artguernica', 'artkahlo', 'artklimttree',
  'artballoondog',
  'snail', 'mouse', 'chick', 'frog', 'kitten',
  'birdfeeder', 'sunlounger', 'gardenswing',
  'eyemask', 'poolfloat', 'bathrobe',
  'juicer', 'toasteroven', 'breadmaker',
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
        if (on) {
          // A couple of flies buzzing little loops above the lid.
          for (var k = 0; k < 2; k++) {
            final a = (t * 1.6 + phase + k * 0.5) * 2 * math.pi;
            final fx = 0.50 + (k == 0 ? -0.08 : 0.10) + 0.05 * math.cos(a);
            final fy = 0.30 + 0.04 * math.sin(a * 1.7);
            circ(fx, fy, 0.012, const Color(0xFF2A2A2A));
          }
        }
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
      // ── Bathroom (water & steam) 🛁 ─────────────────────────────────────────
      case 'rainshower': // a rainfall head pouring water
        {
          box(0.18, 0.18, 0.28, 0.24, 0.02, dark);
          line(0.24, 0.24, 0.50, 0.24, 0.03, dark);
          box(0.40, 0.22, 0.62, 0.30, 0.03, base);
          box(0.30, 0.84, 0.74, 0.90, 0.02, dark);
          for (var k = 0; k < 5; k++) {
            final x = 0.42 + k * 0.045;
            line(x, 0.30, x, 0.84, 0.012,
                const Color(0xFFBFE6F0).withValues(alpha: 0.3));
            if (on) {
              final d = saw(1.6, k / 5.0);
              circ(x, 0.30 + 0.54 * d, 0.014,
                  offWhite.withValues(alpha: math.sin(d * math.pi) * 0.7));
            }
          }
        }
      case 'walkinshower': // a glass walk-in shower running
        {
          box(0.22, 0.16, 0.78, 0.88, 0.02, base.withValues(alpha: 0.32));
          line(0.22, 0.16, 0.22, 0.88, 0.014, offWhite);
          line(0.78, 0.16, 0.78, 0.88, 0.014, offWhite);
          line(0.22, 0.16, 0.78, 0.16, 0.014, offWhite);
          box(0.50, 0.84, 0.80, 0.90, 0.02, dark);
          box(0.62, 0.20, 0.72, 0.26, 0.02, const Color(0xFFB7C0C7));
          line(0.67, 0.18, 0.67, 0.20, 0.02, dark);
          for (var k = 0; k < 3; k++) {
            final x = 0.62 + k * 0.04;
            line(x, 0.26, x, 0.84, 0.01,
                const Color(0xFFBFE6F0).withValues(alpha: 0.3));
            if (on) {
              final d = saw(1.6, k / 3.0);
              circ(x, 0.26 + 0.58 * d, 0.012,
                  offWhite.withValues(alpha: math.sin(d * math.pi) * 0.7));
            }
          }
          box(0.30, 0.46, 0.33, 0.58, 0.01, const Color(0xFFB7C0C7));
        }
      case 'clawtub': // a clawfoot tub, steaming, with ripples
        {
          box(0.20, 0.50, 0.80, 0.80, 0.14, base);
          box(0.24, 0.50, 0.76, 0.62, 0.06, const Color(0xFF8FD0E0));
          for (final x in const [0.26, 0.74]) {
            poly([
              Offset(x - 0.03, 0.80), Offset(x + 0.03, 0.80),
              Offset(x + 0.04, 0.88), Offset(x - 0.04, 0.88),
            ], dark);
          }
          line(0.18, 0.44, 0.18, 0.52, 0.02, const Color(0xFFC0A040));
          arc(0.20, 0.44, 0.04, math.pi, math.pi, 0.02,
              const Color(0xFFC0A040));
          if (on) {
            final r = saw(1);
            ring(0.42, 0.55, 0.03 + 0.08 * r, 0.006,
                offWhite.withValues(alpha: (1 - r) * 0.5));
          }
          steam(0.56, 0.50);
        }
      case 'designertub': // a sculpted designer tub with shimmering water
        {
          box(0.30, 0.78, 0.70, 0.86, 0.02, _shade(base, -0.10));
          poly(const [
            Offset(0.18, 0.56), Offset(0.82, 0.56),
            Offset(0.74, 0.80), Offset(0.26, 0.80),
          ], base);
          box(0.22, 0.54, 0.78, 0.62, 0.05,
              Color.lerp(const Color(0xFF7FC0D8), const Color(0xFFA8DCE8),
                  0.5 + 0.5 * wv(2))!);
          line(0.50, 0.46, 0.50, 0.56, 0.02, const Color(0xFFB7C0C7));
          arc(0.50, 0.46, 0.05, math.pi, math.pi, 0.02,
              const Color(0xFFB7C0C7));
          steam(0.40, 0.52);
          steam(0.60, 0.52);
        }
      case 'doublevanity': // two basins under a mirror, a tap dripping
        {
          box(0.16, 0.56, 0.84, 0.86, 0.03, base);
          box(0.16, 0.52, 0.84, 0.58, 0.02, const Color(0xFFE6E2DA));
          box(0.22, 0.18, 0.78, 0.46, 0.02, dark);
          box(0.25, 0.21, 0.75, 0.43, 0.01,
              const Color(0xFF8FB8C8).withValues(alpha: 0.7));
          for (final x in const [0.34, 0.66]) {
            bowl(x, 0.52, 0.10, offWhite);
            circ(x, 0.50, 0.012, const Color(0xFFB7C0C7));
          }
          if (on) {
            final d = saw(2);
            circ(0.34, 0.52 + 0.04 * d, 0.008,
                const Color(0xFF8FD0E0).withValues(alpha: 1 - d));
          }
        }
      case 'steamsauna': // a sauna cabin billowing steam
        {
          box(0.20, 0.22, 0.80, 0.88, 0.03, base);
          for (var i = 0; i < 6; i++) {
            line(0.20, 0.30 + i * 0.10, 0.80, 0.30 + i * 0.10, 0.006,
                _shade(base, -0.12));
          }
          box(0.26, 0.30, 0.60, 0.40, 0.02,
              const Color(0xFF3A4A5A).withValues(alpha: 0.5));
          box(0.62, 0.40, 0.78, 0.86, 0.02, _shade(base, -0.06));
          line(0.65, 0.62, 0.67, 0.62, 0.02, dark);
          box(0.28, 0.66, 0.44, 0.84, 0.02, const Color(0xFF566066));
          for (var i = 0; i < 3; i++) {
            circ(0.31 + i * 0.05, 0.66, 0.025, const Color(0xFF7A7268));
          }
          steam(0.36, 0.64);
          steam(0.30, 0.36);
          steam(0.50, 0.34);
        }
      case 'towelwarmer': // a heated towel rail, faint heat wisp
        {
          box(0.34, 0.24, 0.40, 0.86, 0.02, base);
          box(0.60, 0.24, 0.66, 0.86, 0.02, base);
          for (var i = 0; i < 5; i++) {
            line(0.40, 0.30 + i * 0.13, 0.60, 0.30 + i * 0.13, 0.02, base);
          }
          box(0.42, 0.44, 0.58, 0.74, 0.02, const Color(0xFFE0EAEC));
          if (on) {
            final h = wv(2) * 0.5 + 0.5;
            line(0.50, 0.42, 0.50, 0.42 - 0.05 * h, 0.006,
                offWhite.withValues(alpha: 0.3));
          }
        }
      case 'bubbletub': // a bubble bath, foam rising and popping
        {
          box(0.18, 0.54, 0.82, 0.84, 0.10, dark);
          box(0.22, 0.56, 0.78, 0.70, 0.06, base);
          for (var i = 0; i < 6; i++) {
            circ(0.28 + i * 0.09, 0.56, 0.05, offWhite);
          }
          circ(0.40, 0.52, 0.05, offWhite);
          circ(0.56, 0.51, 0.05, offWhite);
          if (on) {
            for (var k = 0; k < 4; k++) {
              final d = saw(1, k / 4.0);
              circ(0.32 + k * 0.13, 0.50 - 0.14 * d, 0.018 * (1 - d * 0.5),
                  offWhite.withValues(alpha: (1 - d) * 0.8));
            }
          }
        }
      // ── Food 🍰 ─────────────────────────────────────────────────────────────
      case 'cake': // a layer cake with a flickering candle
        {
          box(0.22, 0.80, 0.78, 0.86, 0.03, const Color(0xFFE6E2DA));
          box(0.30, 0.56, 0.70, 0.82, 0.03, base);
          box(0.30, 0.66, 0.70, 0.70, 0.0, _shade(base, -0.12));
          for (var i = 0; i < 4; i++) {
            circ(0.34 + i * 0.11, 0.56, 0.03, _shade(base, 0.08));
          }
          box(0.49, 0.44, 0.51, 0.56, 0.005, const Color(0xFF4A8FE0));
          final f = on ? 1 + wv(6) * 0.3 : 1.0;
          poly([
            Offset(0.50, 0.40 - 0.04 * f),
            Offset(0.485, 0.45), Offset(0.515, 0.45),
          ], const Color(0xFFF2A03C));
        }
      case 'cupcake': // a cupcake whose cherry sparkles
        {
          poly(const [
            Offset(0.36, 0.62), Offset(0.64, 0.62),
            Offset(0.60, 0.86), Offset(0.40, 0.86),
          ], const Color(0xFFC97FA0));
          for (var i = 0; i < 4; i++) {
            line(0.40 + i * 0.06, 0.62, 0.42 + i * 0.06, 0.86, 0.006,
                _shade(const Color(0xFFC97FA0), -0.12));
          }
          dome(0.50, 0.62, 0.18, base);
          circ(0.50, 0.50, 0.10, base);
          circ(0.50, 0.44, 0.07, base);
          circ(0.50, 0.38, 0.035, const Color(0xFFD9534F));
          if (on) {
            final s = wv(3) * 0.5 + 0.5;
            circ(0.47, 0.36, 0.01, offWhite.withValues(alpha: s));
          }
        }
      case 'pizza': // a whole pizza, steam rising
        {
          circ(0.50, 0.62, 0.30, base);
          circ(0.50, 0.62, 0.25, const Color(0xFFC0392B));
          const top = [Color(0xFFA02818), Color(0xFF6BA86B), Color(0xFFF0E0A0)];
          for (var i = 0; i < 6; i++) {
            final a = i * 2 * math.pi / 6;
            circ(0.50 + 0.15 * math.cos(a), 0.62 + 0.15 * math.sin(a), 0.03,
                top[i % 3]);
          }
          circ(0.50, 0.62, 0.04, const Color(0xFFF0E0A0));
          steam(0.50, 0.36);
        }
      case 'burger': // a stacked burger with a tiny wobble
        {
          final wob = on ? wv(1.5) * 0.01 : 0.0;
          box(0.28, 0.74, 0.72, 0.82, 0.04, base);
          box(0.27, 0.66, 0.73, 0.74, 0.03, const Color(0xFF6B3A20));
          poly(const [
            Offset(0.28, 0.62), Offset(0.72, 0.62),
            Offset(0.66, 0.68), Offset(0.34, 0.68),
          ], const Color(0xFFF4C430));
          for (var i = 0; i < 5; i++) {
            circ(0.31 + i * 0.10, 0.60, 0.04, const Color(0xFF6BA86B));
          }
          dome(0.50, 0.58 + wob, 0.24, base);
          for (var i = 0; i < 3; i++) {
            circ(0.42 + i * 0.08, 0.48 + wob, 0.008, offWhite);
          }
        }
      case 'sushi': // a sushi set on a slate board
        {
          box(0.18, 0.66, 0.82, 0.74, 0.03, const Color(0xFF3A3A3A));
          for (var i = 0; i < 3; i++) {
            final x = 0.30 + i * 0.18;
            box(x - 0.07, 0.58, x + 0.07, 0.66, 0.04, base);
            dome(x, 0.58, 0.07,
                const [Color(0xFFE2745C), Color(0xFFE0A040), Color(0xFF6BA86B)][i]);
            line(x - 0.05, 0.60, x + 0.05, 0.60, 0.012,
                const Color(0xFF2A2A2A));
          }
          circ(0.74, 0.62, 0.05, const Color(0xFF2A2A2A));
          circ(0.74, 0.62, 0.035, base);
          circ(0.74, 0.62, 0.015, const Color(0xFFE2745C));
          if (on) {
            final b = wv(2) * 0.5 + 0.5;
            circ(0.24, 0.54, 0.01, offWhite.withValues(alpha: b));
          }
        }
      case 'icecream': // an ice cream cone with a drip
        {
          poly(const [
            Offset(0.40, 0.56), Offset(0.60, 0.56), Offset(0.50, 0.88),
          ], const Color(0xFFD9A86A));
          for (var i = 1; i < 4; i++) {
            line(0.40 + i * 0.03, 0.56, 0.50, 0.88 - i * 0.02, 0.004,
                _shade(const Color(0xFFD9A86A), -0.15));
          }
          circ(0.43, 0.50, 0.10, base);
          circ(0.57, 0.50, 0.10, const Color(0xFFBFE0D0));
          circ(0.50, 0.40, 0.10, const Color(0xFFF4E0A0));
          circ(0.50, 0.32, 0.02, const Color(0xFFD9534F));
          if (on) {
            final d = saw(1);
            circ(0.38, 0.56 + 0.1 * d, 0.014, base.withValues(alpha: 1 - d));
          }
        }
      case 'donut': // a frosted donut, sprinkles shimmering
        {
          ring(0.50, 0.62, 0.18, 0.14, const Color(0xFFD9A86A));
          ring(0.50, 0.62, 0.18, 0.10, base);
          const sp = [
            Color(0xFFE2574C), Color(0xFF4A8FE0),
            Color(0xFFF4C430), Color(0xFF6BA86B),
          ];
          for (var i = 0; i < 8; i++) {
            final a = i * 2 * math.pi / 8;
            final sh = on ? wv(3, i * 0.12) * 0.4 + 0.6 : 0.8;
            final px = 0.50 + 0.18 * math.cos(a);
            final py = 0.62 + 0.18 * math.sin(a);
            line(px, py, px + 0.02, py - 0.02, 0.012,
                sp[i % 4].withValues(alpha: sh));
          }
        }
      case 'coffeecup': // a to-go coffee, steam rising
        {
          poly(const [
            Offset(0.38, 0.52), Offset(0.62, 0.52),
            Offset(0.58, 0.86), Offset(0.42, 0.86),
          ], base);
          box(0.40, 0.62, 0.60, 0.70, 0.0, const Color(0xFFE6E2DA));
          box(0.36, 0.48, 0.64, 0.54, 0.02, const Color(0xFF8A6A4A));
          box(0.48, 0.42, 0.52, 0.48, 0.01, const Color(0xFF8A6A4A));
          steam(0.50, 0.42);
        }
      case 'croissant': // a flaky croissant
        {
          arc(0.50, 0.66, 0.20, math.pi * 1.15, math.pi * 0.7, 0.10, base);
          for (var i = 0; i < 4; i++) {
            final a = math.pi * 1.15 + i * 0.18;
            line(0.50 + 0.20 * math.cos(a), 0.66 + 0.20 * math.sin(a),
                0.50 + 0.14 * math.cos(a), 0.66 + 0.14 * math.sin(a), 0.012,
                _shade(base, -0.12));
          }
          final g = on ? wv(2) * 0.2 + 0.4 : 0.4;
          line(0.40, 0.54, 0.46, 0.52, 0.01, offWhite.withValues(alpha: g));
        }
      case 'taco': // a taco with a little wobble
        {
          final wob = on ? wv(2) * 0.012 : 0.0;
          bowl(0.50, 0.58 + wob, 0.28, base);
          box(0.34, 0.58 + wob, 0.66, 0.66 + wob, 0.0,
              const Color(0xFF8B4A2A));
          for (var i = 0; i < 5; i++) {
            circ(0.30 + i * 0.10, 0.56 + wob, 0.04,
                const [Color(0xFF6BA86B), Color(0xFFD9534F), Color(0xFFF4C430)][i % 3]);
          }
        }
      case 'ramen': // a steaming ramen bowl with chopsticks
        {
          bowl(0.50, 0.66, 0.30, base);
          box(0.22, 0.62, 0.78, 0.68, 0.0, const Color(0xFFE8C56A));
          circ(0.42, 0.64, 0.04, const Color(0xFFF0E0A0));
          circ(0.56, 0.63, 0.045, const Color(0xFFE6E2DA));
          circ(0.50, 0.64, 0.03, const Color(0xFFC0392B));
          line(0.36, 0.62, 0.40, 0.66, 0.01, const Color(0xFF3F8F4A));
          line(0.60, 0.44, 0.78, 0.62, 0.012, const Color(0xFFB07A4A));
          line(0.64, 0.42, 0.80, 0.60, 0.012, const Color(0xFFB07A4A));
          steam(0.45, 0.58);
          steam(0.58, 0.60);
        }
      case 'fruitbasket': // a basket of fruit gently settling
        {
          bowl(0.50, 0.74, 0.30, base);
          for (var i = 0; i < 3; i++) {
            line(0.30 + i * 0.20, 0.72, 0.30 + i * 0.20, 0.80, 0.006,
                _shade(base, -0.12));
          }
          final b = wv(0.6) * 0.008;
          circ(0.38, 0.62 + b, 0.07, const Color(0xFFE2574C));
          circ(0.54, 0.60 + b * 1.3, 0.075, const Color(0xFFE0A82E));
          circ(0.64, 0.66 + b * 0.7, 0.05, const Color(0xFF8E68C8));
          circ(0.46, 0.66 + b, 0.05, const Color(0xFFF4C430));
          line(0.38, 0.55 + b, 0.40, 0.51 + b, 0.008, const Color(0xFF4F8F4A));
        }
      // ── Pets 🐾 (cute, minimal idle motion) ─────────────────────────────────
      case 'dog': // a sitting dog wagging its tail
        {
          poly(const [
            Offset(0.36, 0.58), Offset(0.60, 0.58),
            Offset(0.64, 0.86), Offset(0.34, 0.86),
          ], base);
          circ(0.42, 0.46, 0.13, base);
          poly(const [
            Offset(0.32, 0.40), Offset(0.40, 0.42), Offset(0.34, 0.56),
          ], _shade(base, -0.12));
          poly(const [
            Offset(0.52, 0.40), Offset(0.44, 0.42), Offset(0.50, 0.56),
          ], _shade(base, -0.12));
          circ(0.42, 0.52, 0.05, _shade(base, 0.12));
          circ(0.42, 0.50, 0.018, const Color(0xFF2A2A2A));
          circ(0.38, 0.45, 0.018, const Color(0xFF2A2A2A));
          circ(0.46, 0.45, 0.018, const Color(0xFF2A2A2A));
          final w = on ? wv(3) * 0.06 : 0.0;
          line(0.60, 0.66, 0.70 + w, 0.58 - w.abs(), 0.03, base);
          circ(0.40, 0.86, 0.04, _shade(base, 0.10));
          circ(0.54, 0.86, 0.04, _shade(base, 0.10));
        }
      case 'puppy': // a little puppy, ears and tail wiggling
        {
          circ(0.50, 0.66, 0.16, base);
          circ(0.50, 0.46, 0.13, base);
          final e = on ? wv(4) * 0.02 : 0.0;
          poly([
            Offset(0.38, 0.38), Offset(0.46, 0.40), Offset(0.40 + e, 0.52),
          ], _shade(base, -0.12));
          poly([
            Offset(0.62, 0.38), Offset(0.54, 0.40), Offset(0.60 - e, 0.52),
          ], _shade(base, -0.12));
          circ(0.50, 0.50, 0.04, _shade(base, 0.14));
          circ(0.50, 0.49, 0.015, const Color(0xFF2A2A2A));
          circ(0.45, 0.45, 0.016, const Color(0xFF2A2A2A));
          circ(0.55, 0.45, 0.016, const Color(0xFF2A2A2A));
          final w = on ? wv(5) * 0.04 : 0.0;
          line(0.62, 0.70, 0.72, 0.64 + w, 0.03, base);
        }
      case 'bunny': // a bunny, ears twitching, nose wiggling
        {
          circ(0.50, 0.68, 0.16, base);
          circ(0.50, 0.50, 0.12, base);
          final tw = on ? wv(4) * 0.015 : 0.0;
          box(0.42 + tw, 0.24, 0.47 + tw, 0.46, 0.025, base);
          box(0.53 - tw, 0.24, 0.58 - tw, 0.46, 0.025, base);
          box(0.435 + tw, 0.27, 0.455 + tw, 0.44, 0.01, const Color(0xFFE6B0C0));
          box(0.545 - tw, 0.27, 0.565 - tw, 0.44, 0.01, const Color(0xFFE6B0C0));
          circ(0.46, 0.49, 0.014, const Color(0xFF2A2A2A));
          circ(0.54, 0.49, 0.014, const Color(0xFF2A2A2A));
          final n = on ? wv(6) * 0.004 : 0.0;
          circ(0.50, 0.55 + n, 0.012, const Color(0xFFE07A8A));
          circ(0.64, 0.72, 0.04, offWhite);
        }
      case 'hamster': // a round hamster nibbling a seed
        {
          circ(0.50, 0.66, 0.20, base);
          circ(0.40, 0.50, 0.06, base);
          circ(0.60, 0.50, 0.06, base);
          circ(0.44, 0.60, 0.018, const Color(0xFF2A2A2A));
          circ(0.56, 0.60, 0.018, const Color(0xFF2A2A2A));
          circ(0.50, 0.66, 0.03, const Color(0xFFE6B0A0));
          box(0.46, 0.70, 0.54, 0.74, 0.01, const Color(0xFFF0E0A0));
          final n = on ? wv(8) * 0.006 : 0.0;
          circ(0.46, 0.74 + n, 0.02, _shade(base, 0.10));
          circ(0.54, 0.74 + n, 0.02, _shade(base, 0.10));
        }
      case 'parrot': // a parrot on a perch, head bobbing
        {
          line(0.30, 0.80, 0.70, 0.80, 0.02, const Color(0xFFB07A4A));
          line(0.50, 0.80, 0.50, 0.88, 0.02, const Color(0xFFB07A4A));
          final bob = on ? wv(2) * 0.012 : 0.0;
          poly([
            Offset(0.46, 0.46 + bob), Offset(0.58, 0.50 + bob),
            Offset(0.54, 0.80), Offset(0.44, 0.80),
          ], base);
          circ(0.48, 0.42 + bob, 0.09, base);
          poly([
            Offset(0.42, 0.42 + bob), Offset(0.34, 0.45 + bob),
            Offset(0.42, 0.48 + bob),
          ], const Color(0xFFF4C430));
          circ(0.50, 0.40 + bob, 0.016, const Color(0xFF2A2A2A));
          poly([
            Offset(0.50, 0.52 + bob), Offset(0.60, 0.58), Offset(0.52, 0.74),
          ], const Color(0xFF4A8FE0));
          poly(const [
            Offset(0.48, 0.78), Offset(0.54, 0.78), Offset(0.58, 0.90),
          ], const Color(0xFFE2574C));
        }
      case 'turtle': // a turtle, head slowly bobbing out
        {
          dome(0.50, 0.74, 0.26, base);
          for (var i = 0; i < 3; i++) {
            line(0.34 + i * 0.16, 0.74, 0.34 + i * 0.16, 0.54, 0.008,
                _shade(base, -0.14));
          }
          arc(0.50, 0.74, 0.16, math.pi, math.pi, 0.008, _shade(base, -0.14));
          final h = on ? wv(0.8) * 0.02 : 0.0;
          circ(0.74 + h, 0.70, 0.07, const Color(0xFF7FA86B));
          circ(0.76 + h, 0.68, 0.012, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.30, 0.74), Offset(0.26, 0.82), Offset(0.34, 0.80),
          ], const Color(0xFF7FA86B));
          poly(const [
            Offset(0.66, 0.74), Offset(0.70, 0.82), Offset(0.62, 0.80),
          ], const Color(0xFF7FA86B));
        }
      case 'fishtank': // a small tank with a fish swimming
        {
          box(0.22, 0.34, 0.78, 0.84, 0.04, base.withValues(alpha: 0.35));
          box(0.22, 0.78, 0.78, 0.84, 0.03, const Color(0xFFD9C28A));
          line(0.22, 0.40, 0.78, 0.40, 0.012, const Color(0xFF8FB7C0));
          for (var i = 0; i < 3; i++) {
            line(0.30 + i * 0.04, 0.78, 0.28 + i * 0.05, 0.56, 0.012,
                const Color(0xFF3F8F5A));
          }
          final fx = on ? 0.34 + 0.32 * (0.5 + 0.5 * math.sin(t * 2 * math.pi)) : 0.5;
          circ(fx, 0.58, 0.05, const Color(0xFFF08A3C));
          poly([
            Offset(fx - 0.05, 0.58), Offset(fx - 0.10, 0.54),
            Offset(fx - 0.10, 0.62),
          ], const Color(0xFFF08A3C));
          circ(fx + 0.02, 0.56, 0.008, const Color(0xFF2A2A2A));
          if (on) {
            final d = saw(1.5);
            circ(0.70, 0.78 - 0.36 * d, 0.012,
                offWhite.withValues(alpha: (1 - d) * 0.6));
          }
        }
      case 'duck': // a little duck gently bobbing
        {
          final bob = on ? wv(1.5) * 0.01 : 0.0;
          poly([
            Offset(0.34, 0.66 + bob), Offset(0.64, 0.62 + bob),
            Offset(0.70, 0.78), Offset(0.30, 0.78),
          ], base);
          circ(0.64, 0.52 + bob, 0.10, base);
          poly([
            Offset(0.72, 0.52 + bob), Offset(0.84, 0.54 + bob),
            Offset(0.72, 0.58 + bob),
          ], const Color(0xFFF08A3C));
          circ(0.66, 0.50 + bob, 0.014, const Color(0xFF2A2A2A));
          poly([
            Offset(0.40, 0.66 + bob), Offset(0.50, 0.62 + bob),
            Offset(0.48, 0.74),
          ], _shade(base, -0.12));
        }
      // ── Décor — stylized homages of famous artworks 🖼️ ─────────────────────
      case 'artswirl': // a swirling starry night
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFFC9A24A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFF1E2A5A));
          for (var i = 0; i < 3; i++) {
            arc(0.34 + i * 0.16, 0.34, 0.07, 0, 2 * math.pi * 0.8, 0.012,
                const Color(0xFF6FA8E0));
          }
          circ(0.70, 0.28, 0.06, const Color(0xFFF2D98A));
          box(0.18, 0.66, 0.82, 0.82, 0.0, const Color(0xFF24406A));
          poly(const [
            Offset(0.24, 0.82), Offset(0.30, 0.44), Offset(0.36, 0.82),
          ], const Color(0xFF12203A));
          final s = on ? wv(2) * 0.3 + 0.7 : 0.8;
          circ(0.30, 0.30, 0.02, const Color(0xFFF2E8A0).withValues(alpha: s));
          circ(0.50, 0.26, 0.015,
              const Color(0xFFF2E8A0).withValues(alpha: s));
        }
      case 'artscream': // a wavy figure under a burning sky
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          for (var i = 0; i < 4; i++) {
            box(0.18, 0.14 + i * 0.10, 0.82, 0.24 + i * 0.10, 0.0,
                Color.lerp(const Color(0xFFE0862E), const Color(0xFFD9534F),
                    i / 3)!);
          }
          box(0.18, 0.54, 0.82, 0.82, 0.0, const Color(0xFF3A5A6A));
          line(0.18, 0.58, 0.82, 0.50, 0.03, const Color(0xFF6B4A2A));
          circ(0.40, 0.46, 0.07, const Color(0xFFD9C0A0));
          box(0.36, 0.50, 0.44, 0.78, 0.04, const Color(0xFF2A2A2A));
          circ(0.38, 0.45, 0.012, const Color(0xFF2A2A2A));
          circ(0.42, 0.45, 0.012, const Color(0xFF2A2A2A));
          ring(0.40, 0.50, 0.02, 0.008, const Color(0xFF2A2A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artpearl': // a girl with a glowing pearl earring
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A2A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFF14141E));
          poly(const [
            Offset(0.34, 0.62), Offset(0.66, 0.62),
            Offset(0.74, 0.82), Offset(0.26, 0.82),
          ], const Color(0xFF2A2A22));
          circ(0.50, 0.46, 0.16, const Color(0xFFE9C6A0));
          poly(const [
            Offset(0.34, 0.42), Offset(0.50, 0.26),
            Offset(0.66, 0.42), Offset(0.62, 0.34),
          ], const Color(0xFF3B6FB0));
          poly(const [
            Offset(0.50, 0.28), Offset(0.66, 0.40), Offset(0.60, 0.30),
          ], const Color(0xFFE0A82E));
          circ(0.46, 0.46, 0.014, const Color(0xFF2A2A2A));
          circ(0.56, 0.46, 0.014, const Color(0xFF2A2A2A));
          final g = on ? wv(2) * 0.3 + 0.7 : 0.8;
          circ(0.46, 0.58, 0.022, offWhite.withValues(alpha: g));
        }
      case 'artsunflowers': // sunflowers in a vase
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFFC9A24A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFE9D7A0));
          poly(const [
            Offset(0.40, 0.62), Offset(0.60, 0.62),
            Offset(0.58, 0.80), Offset(0.42, 0.80),
          ], const Color(0xFFE0A82E));
          line(0.40, 0.66, 0.60, 0.66, 0.012,
              _shade(const Color(0xFFE0A82E), -0.15));
          final s = on ? wv(1.5) * 0.012 : 0.0;
          for (final p in const [
            Offset(0.40, 0.42), Offset(0.56, 0.38), Offset(0.50, 0.54),
          ]) {
            for (var k = 0; k < 8; k++) {
              final a = k * math.pi / 4;
              circ(p.dx + s + 0.05 * math.cos(a), p.dy + 0.05 * math.sin(a),
                  0.022, const Color(0xFFE6A82E));
            }
            circ(p.dx + s, p.dy, 0.03, const Color(0xFF6B4A2A));
            line(p.dx, p.dy + 0.03, 0.50, 0.62, 0.01, const Color(0xFF4F8F4A));
          }
        }
      case 'artgothic': // a stoic farm couple by a gabled house
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFC9C2B0));
          poly(const [
            Offset(0.36, 0.40), Offset(0.50, 0.26), Offset(0.64, 0.40),
          ], const Color(0xFFE6E0D0));
          box(0.40, 0.40, 0.60, 0.52, 0.0, const Color(0xFFE6E0D0));
          box(0.47, 0.42, 0.53, 0.50, 0.0, const Color(0xFF3A4A5A));
          circ(0.40, 0.56, 0.06, const Color(0xFFE9C6A0));
          box(0.35, 0.60, 0.45, 0.82, 0.0, const Color(0xFF2A2A2A));
          circ(0.58, 0.56, 0.06, const Color(0xFFE9C6A0));
          box(0.53, 0.60, 0.63, 0.82, 0.0, const Color(0xFF4A3A3A));
          line(0.40, 0.50, 0.40, 0.82, 0.012, const Color(0xFF6B4A2A));
          for (final dx in const [-0.04, 0.0, 0.04]) {
            line(0.40 + dx, 0.50, 0.40 + dx, 0.46, 0.01,
                const Color(0xFF888888));
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artmondrian': // a grid in primary colours
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.17, 0.13, 0.83, 0.83, 0.0, offWhite);
          box(0.17, 0.13, 0.40, 0.45, 0.0, const Color(0xFFE2574C));
          box(0.62, 0.55, 0.83, 0.83, 0.0, const Color(0xFF4A6FD0));
          box(0.62, 0.13, 0.83, 0.30, 0.0, const Color(0xFFF4C430));
          line(0.40, 0.13, 0.40, 0.83, 0.018, const Color(0xFF1A1A1A));
          line(0.62, 0.13, 0.62, 0.83, 0.018, const Color(0xFF1A1A1A));
          line(0.17, 0.45, 0.83, 0.45, 0.018, const Color(0xFF1A1A1A));
          line(0.40, 0.55, 0.83, 0.55, 0.018, const Color(0xFF1A1A1A));
          if (on) {
            final sw = saw(0.5);
            line(0.17 + sw * 0.66, 0.13, 0.10 + sw * 0.66, 0.83, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artwave': // a great cresting wave with a distant peak
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFE6E0CE));
          poly(const [
            Offset(0.54, 0.56), Offset(0.66, 0.40), Offset(0.78, 0.56),
          ], const Color(0xFF3A5A7A));
          poly(const [
            Offset(0.62, 0.45), Offset(0.66, 0.40), Offset(0.70, 0.45),
          ], offWhite);
          poly([
            Offset(0.18, 0.66), Offset(0.30, 0.50), Offset(0.46, 0.46),
            Offset(0.40, 0.62), Offset(0.50, 0.58), Offset(0.46, 0.72),
            Offset(0.18, 0.82),
          ], base);
          for (var i = 0; i < 4; i++) {
            circ(0.28 + i * 0.05, 0.50 + i * 0.02, 0.02, offWhite);
          }
          box(0.18, 0.74, 0.82, 0.82, 0.0, base);
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artlilies': // soft water lilies on a pond
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFFC9A24A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (var i = 0; i < 5; i++) {
            for (var j = 0; j < 4; j++) {
              circ(0.26 + j * 0.16, 0.24 + i * 0.13, 0.03,
                  Color.lerp(const Color(0xFF6FA890), const Color(0xFF9FC0B0),
                      ((i + j) % 3) / 2)!.withValues(alpha: 0.8));
            }
          }
          for (final p in const [
            Offset(0.36, 0.56), Offset(0.60, 0.66), Offset(0.50, 0.40),
          ]) {
            circ(p.dx, p.dy, 0.05, const Color(0xFF4F8F6A));
            circ(p.dx, p.dy - 0.01, 0.02, const Color(0xFFE7A9C3));
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      // ── Lighting (premium) 💡 ───────────────────────────────────────────────
      case 'chandelier': // a crystal chandelier, candles flickering (ceiling)
        {
          line(0.50, 0.08, 0.50, 0.22, 0.012, const Color(0xFF7A6A4A));
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.40 * u),
                width: 0.6 * u, height: 0.16 * u),
            Paint()
              ..color = base
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.02 * u
              ..isAntiAlias = true,
          );
          for (var i = 0; i < 6; i++) {
            final x = 0.22 + i * 0.112;
            final fl = on ? wv(5, i * 0.2) * 0.3 + 0.7 : 0.8;
            box(x - 0.012, 0.34, x + 0.012, 0.42, 0.005,
                const Color(0xFFE6E0C0));
            circ(x, 0.32, 0.018, const Color(0xFFF2C84B).withValues(alpha: fl));
          }
          for (var i = 0; i < 5; i++) {
            final x = 0.28 + i * 0.11;
            line(x, 0.46, x, 0.54, 0.006, base);
            poly([
              Offset(x - 0.015, 0.54), Offset(x + 0.015, 0.54),
              Offset(x, 0.60),
            ], const Color(0xFFBFE0F0));
          }
          circ(0.50, 0.46, 0.04, base);
        }
      case 'arclamp': // an arc floor lamp with a warm glow
        {
          box(0.16, 0.84, 0.36, 0.90, 0.03, dark);
          line(0.26, 0.86, 0.26, 0.40, 0.02, base);
          arc(0.50, 0.40, 0.24, math.pi, math.pi, 0.02, base);
          poly(const [
            Offset(0.68, 0.40), Offset(0.80, 0.40),
            Offset(0.78, 0.52), Offset(0.70, 0.52),
          ], _shade(base, -0.10));
          final g = on ? 0.4 + 0.4 * wv(3) : 0.5;
          poly([
            Offset(0.70, 0.52), Offset(0.78, 0.52),
            Offset(0.82, 0.70), Offset(0.66, 0.70),
          ], const Color(0xFFF4E0A0).withValues(alpha: g * 0.4));
          circ(0.74, 0.52, 0.03, const Color(0xFFFFF0C0).withValues(alpha: g));
        }
      case 'paperlantern': // a glowing paper lantern, gently swaying
        {
          final s = on ? wv(0.6) * 0.03 : 0.0;
          line(0.50, 0.10, 0.50 + s, 0.26, 0.01, dark);
          final g = on ? 0.7 + 0.2 * wv(2) : 0.8;
          circ(0.50 + s, 0.50, 0.22, base.withValues(alpha: g));
          for (final f in const [-0.12, 0.0, 0.12]) {
            line(0.50 + s + f, 0.30, 0.50 + s + f, 0.70, 0.006,
                _shade(base, -0.12));
          }
          box(0.46 + s, 0.26, 0.54 + s, 0.30, 0.01, dark);
          box(0.46 + s, 0.70, 0.54 + s, 0.74, 0.01, dark);
          poly([
            Offset(0.48 + s, 0.74), Offset(0.52 + s, 0.74),
            Offset(0.50 + s, 0.84),
          ], const Color(0xFFE2574C));
        }
      case 'lavalamp': // a lava lamp with rising blobs
        {
          poly(const [
            Offset(0.40, 0.84), Offset(0.60, 0.84),
            Offset(0.56, 0.70), Offset(0.44, 0.70),
          ], const Color(0xFF888888));
          poly(const [
            Offset(0.40, 0.30), Offset(0.60, 0.30),
            Offset(0.56, 0.16), Offset(0.44, 0.16),
          ], const Color(0xFF888888));
          box(0.40, 0.30, 0.60, 0.70, 0.06, base.withValues(alpha: 0.4));
          if (on) {
            for (var k = 0; k < 3; k++) {
              final d = saw(0.5, k / 3.0);
              circ(0.50, 0.68 - 0.36 * d,
                  0.04 + 0.01 * math.sin(d * math.pi), base);
            }
          } else {
            circ(0.50, 0.58, 0.05, base);
            circ(0.50, 0.44, 0.035, base);
          }
        }
      case 'neonhalo': // a glowing neon ring (wall)
        {
          final g = on ? wv(6) * 0.2 + 0.78 : 0.85;
          ring(0.50, 0.46, 0.26, 0.03, base.withValues(alpha: g));
          ring(0.50, 0.46, 0.26, 0.012, offWhite.withValues(alpha: g));
          box(0.46, 0.70, 0.54, 0.78, 0.02, const Color(0xFF2A2A2A));
        }
      // ── Plants (big statement greenery) 🌿 ──────────────────────────────────
      case 'bigcactus': // a tall saguaro, slow sway
        {
          final s = on ? wv(0.4) * 0.012 : 0.0;
          poly(const [
            Offset(0.40, 0.80), Offset(0.60, 0.80),
            Offset(0.57, 0.90), Offset(0.43, 0.90),
          ], const Color(0xFFC07E54));
          box(0.45 + s * 0.3, 0.22, 0.55 + s * 0.3, 0.80, 0.05, base);
          box(0.30 + s, 0.44, 0.40 + s, 0.50, 0.04, base);
          box(0.30 + s, 0.34, 0.36 + s, 0.50, 0.04, base);
          box(0.60 - s, 0.52, 0.70 - s, 0.58, 0.04, base);
          box(0.64 - s, 0.40, 0.70 - s, 0.58, 0.04, base);
          for (final f in const [0.47, 0.50, 0.53]) {
            line(f + s * 0.3, 0.26, f + s * 0.3, 0.78, 0.004,
                _shade(base, -0.14));
          }
          circ(0.50 + s * 0.3, 0.22, 0.03, const Color(0xFFE2574C));
        }
      case 'figtree': // a fiddle-leaf fig, leaves swaying
        {
          poly(const [
            Offset(0.40, 0.78), Offset(0.60, 0.78),
            Offset(0.57, 0.90), Offset(0.43, 0.90),
          ], const Color(0xFFE6E2DA));
          line(0.50, 0.78, 0.50, 0.36, 0.02, const Color(0xFF7A5A3A));
          final s = on ? wv(0.5) : 0.0;
          for (var i = 0; i < 6; i++) {
            final a = -math.pi / 2 + (i - 2.5) * 0.4;
            final lx = 0.50 + 0.22 * math.cos(a) + s * 0.02 * i;
            final ly = 0.46 + 0.22 * math.sin(a);
            circ(lx, ly, 0.08, i.isEven ? base : _shade(base, 0.06));
          }
          circ(0.50 + s * 0.04, 0.30, 0.09, base);
        }
      case 'monstera': // a monstera, leaves swaying
        {
          poly(const [
            Offset(0.42, 0.80), Offset(0.58, 0.80),
            Offset(0.55, 0.90), Offset(0.45, 0.90),
          ], const Color(0xFFC8975A));
          final s = on ? wv(0.5) * 0.02 : 0.0;
          line(0.50, 0.80, 0.50, 0.50, 0.014, const Color(0xFF3F8F5A));
          for (final p in [
            Offset(0.36 + s, 0.46), Offset(0.64 - s, 0.42),
            Offset(0.50 + s, 0.32), const Offset(0.50, 0.60),
          ]) {
            circ(p.dx, p.dy, 0.12, _shade(base, p.dy < 0.45 ? 0.06 : -0.04));
          }
        }
      case 'bonsai': // a bonsai tree, leaves shimmering
        {
          box(0.28, 0.78, 0.72, 0.86, 0.03, const Color(0xFF6E5A52));
          line(0.50, 0.78, 0.46, 0.56, 0.03, const Color(0xFF6D4C41));
          line(0.46, 0.62, 0.34, 0.52, 0.02, const Color(0xFF6D4C41));
          line(0.46, 0.60, 0.62, 0.50, 0.02, const Color(0xFF6D4C41));
          final s = on ? wv(1) * 0.3 + 0.7 : 0.8;
          circ(0.34, 0.48, 0.10, base.withValues(alpha: s));
          circ(0.60, 0.46, 0.11, base);
          circ(0.48, 0.42, 0.10, base.withValues(alpha: s));
        }
      case 'citrustree': // a lemon tree with fruit, gentle sway
        {
          poly(const [
            Offset(0.40, 0.78), Offset(0.60, 0.78),
            Offset(0.57, 0.90), Offset(0.43, 0.90),
          ], const Color(0xFFC07E54));
          line(0.50, 0.78, 0.50, 0.46, 0.024, const Color(0xFF7A5A3A));
          final s = on ? wv(0.5) * 0.015 : 0.0;
          circ(0.50 + s, 0.36, 0.22, base);
          circ(0.34 + s, 0.44, 0.12, _shade(base, 0.05));
          circ(0.66 + s, 0.44, 0.12, _shade(base, -0.05));
          for (final p in const [
            Offset(0.40, 0.40), Offset(0.60, 0.38),
            Offset(0.50, 0.50), Offset(0.56, 0.30),
          ]) {
            circ(p.dx + s, p.dy, 0.03, const Color(0xFFF4C430));
          }
        }
      case 'snakeplant': // tall snake plant leaves, faint sway
        {
          poly(const [
            Offset(0.40, 0.78), Offset(0.60, 0.78),
            Offset(0.56, 0.90), Offset(0.44, 0.90),
          ], const Color(0xFFC8975A));
          final s = on ? wv(0.5) * 0.015 : 0.0;
          for (var i = 0; i < 5; i++) {
            final x = 0.40 + i * 0.05;
            final tipx = x + (i - 2) * 0.04 + s;
            poly([
              Offset(x - 0.018, 0.78), Offset(x + 0.018, 0.78),
              Offset(tipx + 0.012, 0.22 + i * 0.02),
              Offset(tipx - 0.012, 0.22 + i * 0.02),
            ], i.isEven ? base : _shade(base, 0.06));
          }
        }
      // ── Beds 🛏️ ─────────────────────────────────────────────────────────────
      case 'crib': // a crib with a swaying mobile
        {
          box(0.20, 0.50, 0.80, 0.86, 0.03, base);
          for (var i = 0; i < 7; i++) {
            line(0.24 + i * 0.085, 0.50, 0.24 + i * 0.085, 0.80, 0.01,
                _shade(base, -0.10));
          }
          box(0.22, 0.74, 0.78, 0.82, 0.02, offWhite);
          line(0.30, 0.50, 0.30, 0.32, 0.012, _shade(base, -0.10));
          line(0.30, 0.32, 0.50, 0.30, 0.012, _shade(base, -0.10));
          final s = on ? wv(1.2) * 0.02 : 0.0;
          circ(0.40 + s, 0.38, 0.02, const Color(0xFFE2574C));
          circ(0.48 + s, 0.40, 0.02, const Color(0xFF4A8FE0));
          circ(0.44 + s, 0.42, 0.02, const Color(0xFFF4C430));
        }
      case 'kidsbed': // a car-shaped kids bed
        {
          box(0.18, 0.58, 0.82, 0.82, 0.06, base);
          box(0.22, 0.50, 0.50, 0.60, 0.04, _shade(base, 0.08));
          box(0.24, 0.62, 0.76, 0.72, 0.02, offWhite);
          circ(0.32, 0.84, 0.07, const Color(0xFF2A2A2A));
          circ(0.68, 0.84, 0.07, const Color(0xFF2A2A2A));
          circ(0.32, 0.84, 0.03, const Color(0xFFB7C0C7));
          circ(0.68, 0.84, 0.03, const Color(0xFFB7C0C7));
          circ(0.74, 0.56, 0.03, const Color(0xFFF4C430));
        }
      case 'bunkbed': // a bunk bed with a ladder
        {
          box(0.20, 0.18, 0.26, 0.86, 0.02, base);
          box(0.74, 0.18, 0.80, 0.86, 0.02, base);
          box(0.20, 0.34, 0.80, 0.42, 0.02, base);
          box(0.24, 0.30, 0.72, 0.36, 0.02, offWhite);
          box(0.20, 0.64, 0.80, 0.72, 0.02, base);
          box(0.24, 0.60, 0.72, 0.66, 0.02, offWhite);
          line(0.66, 0.42, 0.66, 0.72, 0.014, _shade(base, -0.10));
          line(0.74, 0.42, 0.74, 0.72, 0.014, _shade(base, -0.10));
          for (var i = 0; i < 3; i++) {
            line(0.66, 0.48 + i * 0.08, 0.74, 0.48 + i * 0.08, 0.012,
                _shade(base, -0.10));
          }
        }
      case 'canopybed': // a four-poster canopy bed, drapes swaying
        {
          box(0.16, 0.20, 0.22, 0.86, 0.02, base);
          box(0.78, 0.20, 0.84, 0.86, 0.02, base);
          box(0.14, 0.18, 0.86, 0.26, 0.02, base);
          final s = on ? wv(0.6) * 0.015 : 0.0;
          poly([
            Offset(0.18, 0.26), Offset(0.30, 0.26),
            Offset(0.26 + s, 0.60), Offset(0.18, 0.58),
          ], const Color(0xFFE6D7E0));
          poly([
            Offset(0.70, 0.26), Offset(0.82, 0.26),
            Offset(0.82, 0.58), Offset(0.74 - s, 0.60),
          ], const Color(0xFFE6D7E0));
          box(0.20, 0.66, 0.80, 0.82, 0.03, _shade(base, 0.06));
          box(0.24, 0.60, 0.46, 0.68, 0.04, offWhite);
          box(0.24, 0.68, 0.76, 0.80, 0.02, const Color(0xFFD8C0D0));
        }
      // ── Windows 🪟 ───────────────────────────────────────────────────────────
      case 'baywindow': // a bay window with drifting clouds (wall)
        {
          box(0.16, 0.20, 0.84, 0.80, 0.02, _shade(base, -0.18));
          box(0.20, 0.24, 0.80, 0.76, 0.0, const Color(0xFF9CC8E0));
          final cx = on ? saw(0.2) : 0.3;
          circ(0.30 + cx * 0.4, 0.38, 0.06, offWhite.withValues(alpha: 0.85));
          circ(0.38 + cx * 0.4, 0.38, 0.05, offWhite.withValues(alpha: 0.85));
          circ(0.60 - cx * 0.3, 0.50, 0.05, offWhite.withValues(alpha: 0.7));
          line(0.38, 0.24, 0.38, 0.76, 0.012, _shade(base, -0.18));
          line(0.62, 0.24, 0.62, 0.76, 0.012, _shade(base, -0.18));
          line(0.20, 0.50, 0.80, 0.50, 0.012, _shade(base, -0.18));
          box(0.14, 0.78, 0.86, 0.84, 0.02, _shade(base, -0.10));
        }
      case 'stainedglass': // a stained-glass window shimmering (wall)
        {
          box(0.22, 0.14, 0.78, 0.86, 0.04, const Color(0xFF2A2A2A));
          const sc = [
            Color(0xFFE2574C), Color(0xFF4A8FE0), Color(0xFFF4C430),
            Color(0xFF6BA86B), Color(0xFF8E68C8),
          ];
          final g = on ? wv(2) * 0.15 + 0.85 : 0.9;
          for (var r = 0; r < 5; r++) {
            for (var c = 0; c < 3; c++) {
              box(0.26 + c * 0.165, 0.20 + r * 0.12,
                  0.40 + c * 0.165, 0.30 + r * 0.12, 0.01,
                  sc[(r * 3 + c) % 5].withValues(alpha: g));
            }
          }
          circ(0.50, 0.50, 0.06, base.withValues(alpha: g));
        }
      case 'skylight': // a skylight with drifting clouds (ceiling)
        {
          box(0.16, 0.20, 0.84, 0.80, 0.03, _shade(base, -0.2));
          box(0.20, 0.24, 0.80, 0.76, 0.0, base);
          line(0.50, 0.24, 0.50, 0.76, 0.012, _shade(base, -0.2));
          line(0.20, 0.50, 0.80, 0.50, 0.012, _shade(base, -0.2));
          final cx = on ? saw(0.18) : 0.4;
          circ(0.28 + cx * 0.5, 0.36, 0.06, offWhite.withValues(alpha: 0.8));
          circ(0.36 + cx * 0.5, 0.36, 0.05, offWhite.withValues(alpha: 0.8));
          circ(0.66 - cx * 0.3, 0.62, 0.05, offWhite.withValues(alpha: 0.6));
        }
      case 'shutterwindow': // a window with louvered shutters (wall)
        {
          box(0.22, 0.20, 0.78, 0.80, 0.02, _shade(base, -0.2));
          box(0.34, 0.24, 0.66, 0.76, 0.0, const Color(0xFF9CC8E0));
          line(0.50, 0.24, 0.50, 0.76, 0.012, _shade(base, -0.2));
          line(0.34, 0.50, 0.66, 0.50, 0.012, _shade(base, -0.2));
          for (final lx in const [0.22, 0.66]) {
            box(lx, 0.22, lx + 0.12, 0.78, 0.02, base);
            for (var i = 0; i < 7; i++) {
              line(lx + 0.01, 0.27 + i * 0.07, lx + 0.11, 0.27 + i * 0.07,
                  0.008, _shade(base, -0.12));
            }
          }
          if (on) {
            final gl = saw(0.5);
            line(0.36 + gl * 0.28, 0.26, 0.36 + gl * 0.28, 0.74, 0.012,
                offWhite.withValues(alpha: math.sin(gl * math.pi) * 0.3));
          }
        }
      // ── Garden flowers 🌷 ────────────────────────────────────────────────────
      case 'tulips': // a row of tulips swaying
        {
          box(0.30, 0.80, 0.70, 0.90, 0.02, const Color(0xFF5A4632));
          const cols = [Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFFE86BA8)];
          for (var i = 0; i < 3; i++) {
            final x = 0.38 + i * 0.12;
            final s = wv(0.6, i * 0.3) * 0.02;
            line(x, 0.80, x + s, 0.50, 0.014, const Color(0xFF4F8F4A));
            poly([
              Offset(x + s - 0.05, 0.46), Offset(x + s + 0.05, 0.46),
              Offset(x + s + 0.04, 0.36), Offset(x + s, 0.40),
              Offset(x + s - 0.04, 0.36),
            ], cols[i]);
            poly([
              Offset(x, 0.68), Offset(x - 0.06, 0.60), Offset(x, 0.62),
            ], const Color(0xFF4F8F4A));
          }
        }
      case 'roses': // a rose bush with blooms nodding
        {
          box(0.34, 0.78, 0.66, 0.90, 0.02, const Color(0xFF6E5A52));
          circ(0.50, 0.62, 0.22, const Color(0xFF3F8F4A));
          circ(0.34, 0.66, 0.12, const Color(0xFF4F9F5A));
          circ(0.66, 0.66, 0.12, const Color(0xFF4F9F5A));
          final s = wv(0.6) * 0.012;
          for (final p in [
            Offset(0.42 + s, 0.54), Offset(0.60 - s, 0.58),
            Offset(0.50 + s, 0.66),
          ]) {
            circ(p.dx, p.dy, 0.055, base);
            circ(p.dx, p.dy, 0.035, _shade(base, 0.10));
            circ(p.dx, p.dy, 0.015, _shade(base, -0.08));
          }
        }
      case 'daisies': // a bunch of daisies swaying in a vase
        {
          box(0.36, 0.62, 0.64, 0.88, 0.04, const Color(0xFF8FB7C0));
          for (var i = 0; i < 3; i++) {
            final x = 0.40 + i * 0.10;
            final s = wv(0.6, i * 0.3) * 0.02;
            line(x, 0.62, x + s, 0.42, 0.012, const Color(0xFF4F8F4A));
            final cx = x + s;
            for (var k = 0; k < 8; k++) {
              final a = k * math.pi / 4;
              circ(cx + 0.05 * math.cos(a), 0.40 + 0.05 * math.sin(a), 0.022,
                  base);
            }
            circ(cx, 0.40, 0.025, const Color(0xFFF4C430));
          }
        }
      case 'lavender': // lavender stalks swaying
        {
          box(0.38, 0.66, 0.62, 0.88, 0.04, const Color(0xFFC0A86A));
          for (var i = 0; i < 5; i++) {
            final x = 0.42 + i * 0.04;
            final s = wv(0.7, i * 0.2) * 0.025;
            line(x, 0.66, x + s, 0.36, 0.01, const Color(0xFF6FA86B));
            for (var k = 0; k < 5; k++) {
              circ(x + s * (1 - k / 5.0), 0.36 + k * 0.045, 0.016, base);
            }
          }
        }
      // ── Spa 🧖 ──────────────────────────────────────────────────────────────
      case 'saunacabin': // a wooden sauna cabin venting steam
        {
          box(0.18, 0.24, 0.82, 0.88, 0.03, base);
          poly(const [
            Offset(0.14, 0.24), Offset(0.50, 0.10), Offset(0.86, 0.24),
          ], _shade(base, -0.10));
          for (var i = 0; i < 5; i++) {
            line(0.18, 0.34 + i * 0.11, 0.82, 0.34 + i * 0.11, 0.006,
                _shade(base, -0.12));
          }
          box(0.54, 0.40, 0.78, 0.86, 0.02, _shade(base, -0.06));
          box(0.58, 0.46, 0.74, 0.60, 0.02,
              const Color(0xFF3A4A5A).withValues(alpha: 0.5));
          circ(0.56, 0.64, 0.01, dark);
          box(0.24, 0.40, 0.46, 0.50, 0.02, _shade(base, 0.08));
          steam(0.34, 0.30);
          steam(0.66, 0.26);
        }
      case 'coldplunge': // an icy cold plunge, ripples + floating ice
        {
          box(0.22, 0.46, 0.78, 0.86, 0.06, _shade(base, -0.18));
          box(0.26, 0.48, 0.74, 0.62, 0.04, base);
          box(0.34, 0.50, 0.42, 0.56, 0.01, offWhite.withValues(alpha: 0.8));
          box(0.56, 0.49, 0.64, 0.55, 0.01, offWhite.withValues(alpha: 0.8));
          if (on) {
            final r = saw(1);
            ring(0.50, 0.55, 0.04 + 0.10 * r, 0.006,
                offWhite.withValues(alpha: (1 - r) * 0.6));
          }
          for (var i = 0; i < 6; i++) {
            circ(0.28 + i * 0.09, 0.47, 0.02, offWhite.withValues(alpha: 0.5));
          }
        }
      case 'hotstones': // a stack of hot stones with rising heat
        {
          var y = 0.78;
          const ws = [0.22, 0.18, 0.14, 0.10];
          for (var i = 0; i < 4; i++) {
            canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(0.50 * u, y * u),
                  width: ws[i] * 2 * u, height: 0.09 * u),
              paint
                ..color = i.isEven ? base : _shade(base, 0.10)
                ..style = PaintingStyle.fill,
            );
            y -= 0.12;
          }
          steam(0.44, 0.34);
          steam(0.56, 0.36);
        }
      // ── Gourmet Kitchen (more appliances) 🍳 ────────────────────────────────
      case 'mixerpro': // a tilt-head stand mixer, beater turning
        {
          box(0.30, 0.80, 0.70, 0.86, 0.03, base);
          box(0.30, 0.40, 0.42, 0.82, 0.04, base);
          poly(const [
            Offset(0.30, 0.40), Offset(0.72, 0.34),
            Offset(0.76, 0.48), Offset(0.34, 0.54),
          ], base);
          circ(0.70, 0.40, 0.04, _shade(base, -0.12));
          bowl(0.56, 0.66, 0.16, const Color(0xFFD8D2C8));
          final r = saw(2) * 2 * math.pi;
          line(0.56, 0.52, 0.56 + 0.04 * math.cos(r), 0.62 + 0.05 * math.sin(r),
              0.012, const Color(0xFFB7C0C7));
        }
      case 'airfryer': // an air fryer, window glowing as it cooks
        {
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.56 * u),
                width: 0.5 * u, height: 0.62 * u),
            paint..color = base..style = PaintingStyle.fill,
          );
          box(0.40, 0.80, 0.60, 0.88, 0.03, _shade(base, -0.12));
          final g = on ? 0.4 + 0.4 * wv(4) : 0.5;
          box(0.40, 0.44, 0.60, 0.64, 0.04,
              Color.lerp(const Color(0xFF6B3A20), const Color(0xFFE8862C), g)!);
          box(0.42, 0.32, 0.58, 0.40, 0.02, const Color(0xFF2A2A2A));
          circ(0.50, 0.36, 0.012, const Color(0xFF5BE07A));
          box(0.44, 0.66, 0.56, 0.70, 0.02, _shade(base, -0.16));
        }
      case 'waffleiron': // a round waffle iron venting steam
        {
          circ(0.50, 0.62, 0.24, base);
          box(0.46, 0.50, 0.78, 0.56, 0.03, base);
          circ(0.50, 0.62, 0.04, _shade(base, -0.16));
          for (var i = -1; i < 2; i++) {
            line(0.40, 0.62 + i * 0.06, 0.60, 0.62 + i * 0.06, 0.006,
                _shade(base, -0.12));
            line(0.50 + i * 0.06, 0.52, 0.50 + i * 0.06, 0.72, 0.006,
                _shade(base, -0.12));
          }
          final g = on ? 0.4 + 0.4 * wv(3) : 0.5;
          circ(0.40, 0.74, 0.012, const Color(0xFFE2574C).withValues(alpha: g));
          steam(0.50, 0.40);
        }
      // ── Art Studio (more disciplines) 🎨 ────────────────────────────────────
      case 'spraycans': // spray cans by a fresh graffiti splat
        {
          circ(0.62, 0.40, 0.12, base.withValues(alpha: 0.85));
          for (var i = 0; i < 6; i++) {
            final a = i * math.pi / 3;
            circ(0.62 + 0.16 * math.cos(a), 0.40 + 0.16 * math.sin(a), 0.03,
                base.withValues(alpha: 0.7));
          }
          const cc = [Color(0xFFE2574C), Color(0xFF4A8FE0), Color(0xFFF4C430)];
          for (var i = 0; i < 3; i++) {
            final x = 0.26 + i * 0.10;
            box(x - 0.04, 0.60, x + 0.04, 0.84, 0.02, cc[i]);
            box(x - 0.03, 0.54, x + 0.03, 0.60, 0.01, const Color(0xFF888888));
            circ(x, 0.52, 0.02, const Color(0xFF888888));
          }
          if (on) {
            final d = saw(1);
            circ(0.62, 0.52 + 0.06 * d, 0.01, base.withValues(alpha: 1 - d));
          }
        }
      case 'sculptstand': // a clay bust taking shape on a stand
        {
          line(0.50, 0.56, 0.34, 0.88, 0.02, base);
          line(0.50, 0.56, 0.66, 0.88, 0.02, base);
          line(0.50, 0.56, 0.50, 0.88, 0.02, base);
          box(0.40, 0.50, 0.60, 0.58, 0.02, _shade(base, -0.10));
          circ(0.50, 0.36, 0.13, const Color(0xFF9E6B43));
          poly(const [
            Offset(0.40, 0.44), Offset(0.60, 0.44),
            Offset(0.64, 0.52), Offset(0.36, 0.52),
          ], const Color(0xFF9E6B43));
          poly(const [
            Offset(0.50, 0.32), Offset(0.56, 0.36), Offset(0.50, 0.40),
          ], Color(0xFF865A38));
          final g = on ? wv(1.5) * 0.2 + 0.4 : 0.4;
          line(0.44, 0.32, 0.44, 0.42, 0.008, offWhite.withValues(alpha: g));
        }
      case 'screenpress': // a screen-printing press, squeegee sweeping
        {
          box(0.20, 0.66, 0.80, 0.74, 0.03, base);
          line(0.24, 0.66, 0.24, 0.40, 0.03, base);
          poly(const [
            Offset(0.24, 0.40), Offset(0.78, 0.46),
            Offset(0.78, 0.58), Offset(0.24, 0.52),
          ], _shade(base, -0.10));
          box(0.30, 0.44, 0.72, 0.54, 0.0,
              const Color(0xFFE6E2DA).withValues(alpha: 0.7));
          poly(const [
            Offset(0.42, 0.70), Offset(0.50, 0.66), Offset(0.58, 0.70),
          ], const Color(0xFFE2574C));
          final x = on ? 0.30 + 0.40 * saw(1) : 0.50;
          line(x, 0.43, x, 0.55, 0.02, const Color(0xFF2A2A2A));
        }
      // ── Game Room (more memorabilia) 🎮 ─────────────────────────────────────
      case 'handheld': // a retro handheld, pixel screen flickering
        {
          box(0.34, 0.30, 0.66, 0.84, 0.06, base);
          box(0.38, 0.36, 0.62, 0.54, 0.02,
              Color.lerp(const Color(0xFF2E5A3A), const Color(0xFF4E8A5A),
                  0.5 + 0.5 * wv(5))!);
          box(0.39, 0.62, 0.45, 0.66, 0.005, dark);
          box(0.40, 0.60, 0.44, 0.68, 0.005, dark);
          circ(0.58, 0.62, 0.02, const Color(0xFFD9534F));
          circ(0.62, 0.66, 0.02, const Color(0xFFD9534F));
          if (on) {
            for (var i = 0; i < 3; i++) {
              final bl = wv(6, i * 0.3) > 0 ? 1.0 : 0.2;
              box(0.42 + i * 0.06, 0.42, 0.45 + i * 0.06, 0.45, 0.0,
                  const Color(0xFF1A3A1A).withValues(alpha: bl));
            }
          }
        }
      case 'modconsole': // a slim console with a glowing strip + controller
        {
          box(0.20, 0.50, 0.80, 0.62, 0.03, base);
          final g = on ? wv(3) * 0.3 + 0.7 : 0.8;
          line(0.24, 0.56, 0.76, 0.56, 0.012,
              const Color(0xFF4A8FE0).withValues(alpha: g));
          circ(0.30, 0.56, 0.02, const Color(0xFF5BE07A).withValues(alpha: g));
          box(0.38, 0.70, 0.62, 0.80, 0.05, _shade(base, 0.10));
          circ(0.40, 0.74, 0.06, _shade(base, 0.10));
          circ(0.60, 0.74, 0.06, _shade(base, 0.10));
          circ(0.55, 0.73, 0.014, const Color(0xFFE2574C));
          circ(0.59, 0.76, 0.014, const Color(0xFF4A8FE0));
        }
      case 'gachapon': // a capsule machine, a capsule dropping
        {
          box(0.30, 0.18, 0.70, 0.50, 0.04, base);
          circ(0.50, 0.34, 0.16, const Color(0x66FFFFFF));
          const cc = [
            Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFF4A8FE0),
            Color(0xFF6BA86B), Color(0xFFE86BA8),
          ];
          for (var i = 0; i < 6; i++) {
            final a = i * 2 * math.pi / 6;
            circ(0.50 + 0.09 * math.cos(a), 0.34 + 0.09 * math.sin(a), 0.03,
                cc[i % 5]);
          }
          box(0.30, 0.50, 0.70, 0.86, 0.04, _shade(base, -0.08));
          box(0.44, 0.56, 0.56, 0.62, 0.01, const Color(0xFF2A2A2A));
          circ(0.50, 0.59, 0.02, const Color(0xFFB7C0C7));
          box(0.40, 0.70, 0.60, 0.80, 0.02, const Color(0xFF2A2A2A));
          if (on) {
            final d = saw(1.2);
            circ(0.50, 0.50 + 0.22 * d, 0.025,
                cc[2].withValues(alpha: 1 - d * 0.5));
          }
        }
      // ── Accessories (animated) ✨ ───────────────────────────────────────────
      case 'hourglass': // an hourglass with falling sand
        {
          box(0.34, 0.20, 0.66, 0.24, 0.02, base);
          box(0.34, 0.78, 0.66, 0.82, 0.02, base);
          line(0.40, 0.24, 0.40, 0.78, 0.014, base);
          line(0.60, 0.24, 0.60, 0.78, 0.014, base);
          poly(const [
            Offset(0.40, 0.26), Offset(0.60, 0.26), Offset(0.50, 0.50),
          ], const Color(0xFFE0C080));
          poly(const [
            Offset(0.50, 0.50), Offset(0.40, 0.76), Offset(0.60, 0.76),
          ], const Color(0xFFE0C080));
          final d = on ? saw(1) : 0.5;
          poly([
            Offset(0.40, 0.76), Offset(0.60, 0.76),
            Offset(0.50, 0.76 - 0.16 * d),
          ], const Color(0xFFE0A82E));
          poly([
            Offset(0.44, 0.26), Offset(0.56, 0.26),
            Offset(0.50, 0.26 + 0.16 * (1 - d)),
          ], const Color(0xFFE0A82E));
          if (on) line(0.50, 0.50, 0.50, 0.74, 0.006, const Color(0xFFE0A82E));
        }
      case 'terrarium': // a glass terrarium with a firefly glow
        {
          bowl(0.50, 0.66, 0.24, const Color(0x55B0D0D8));
          box(0.30, 0.64, 0.70, 0.70, 0.02, const Color(0xFFD9C28A));
          circ(0.42, 0.62, 0.06, base);
          circ(0.56, 0.60, 0.07, _shade(base, 0.06));
          circ(0.40, 0.74, 0.025, const Color(0xFF7FA86B));
          dome(0.50, 0.66, 0.24, const Color(0x33B0D0D8));
          if (on) {
            final g = wv(3) * 0.5 + 0.5;
            circ(0.60, 0.54, 0.012,
                const Color(0xFFF2E89A).withValues(alpha: g));
          }
        }
      case 'recordplayer': // a turntable with a spinning record
        {
          box(0.22, 0.56, 0.78, 0.84, 0.04, base);
          circ(0.46, 0.70, 0.18, const Color(0xFF2A2A2A));
          circ(0.46, 0.70, 0.04, const Color(0xFFE2574C));
          if (on) {
            canvas.save();
            canvas.translate(0.46 * u, 0.70 * u);
            canvas.rotate(t * 2 * math.pi * 0.3);
            circ(0.10, 0.0, 0.012, const Color(0xFF888888));
            canvas.restore();
          }
          line(0.70, 0.58, 0.50, 0.66, 0.012, const Color(0xFFB7C0C7));
          circ(0.70, 0.58, 0.02, const Color(0xFFB7C0C7));
        }
      case 'snowglobe': // a snow globe with drifting snow
        {
          box(0.36, 0.74, 0.64, 0.84, 0.03, base);
          circ(0.50, 0.52, 0.24, const Color(0xFFEAF2F6));
          box(0.42, 0.54, 0.58, 0.64, 0.0, const Color(0xFFD9B08A));
          poly(const [
            Offset(0.40, 0.54), Offset(0.50, 0.44), Offset(0.60, 0.54),
          ], const Color(0xFFC0584F));
          circ(0.40, 0.60, 0.045, const Color(0xFF4F8F4A));
          if (on) {
            for (var k = 0; k < 6; k++) {
              final d = saw(0.7, k / 6.0);
              final sx = 0.38 + k * 0.045 + 0.02 * math.sin(d * 6);
              circ(sx, 0.34 + 0.30 * d, 0.01,
                  offWhite.withValues(alpha: (1 - d) * 0.9));
            }
          }
          ring(0.50, 0.52, 0.24, 0.008,
              const Color(0xFFB7C0C7).withValues(alpha: 0.5));
        }
      case 'windchime': // wind chimes swaying (wall)
        {
          box(0.34, 0.16, 0.66, 0.22, 0.03, base);
          final s = on ? wv(1) * 0.025 : 0.0;
          const cl = [
            Color(0xFFC7AE72), Color(0xFFB7C0C7), Color(0xFFC7AE72),
            Color(0xFFB7C0C7), Color(0xFFC7AE72),
          ];
          const hs = [0.62, 0.70, 0.58, 0.66, 0.60];
          for (var i = 0; i < 5; i++) {
            final x = 0.40 + i * 0.05;
            line(0.50, 0.22, x + s, 0.30, 0.005, dark);
            box(x - 0.014 + s, 0.30, x + 0.014 + s, hs[i], 0.012, cl[i]);
          }
          circ(0.50 + s, 0.50, 0.03, const Color(0xFFD9A86A));
        }
      case 'blocktower': // stacked toy blocks with a tiny wobble
        {
          final wob = on ? wv(1.5) * 0.012 : 0.0;
          const bc = [
            Color(0xFFE2574C), Color(0xFF4A8FE0),
            Color(0xFFF4C430), Color(0xFF6BA86B),
          ];
          const ws = 0.14;
          var y = 0.84;
          for (var i = 0; i < 4; i++) {
            final off = wob * i;
            box(0.50 - ws / 2 + off, y - 0.16, 0.50 + ws / 2 + off, y, 0.02,
                bc[i]);
            circ(0.50 + off, y - 0.08, 0.02, offWhite.withValues(alpha: 0.7));
            y -= 0.16;
          }
        }
      // ── Food (more) 🍔 ──────────────────────────────────────────────────────
      case 'lollipop': // a swirl lollipop slowly turning
        {
          line(0.50, 0.62, 0.50, 0.88, 0.02, offWhite);
          canvas.save();
          canvas.translate(0.50 * u, 0.50 * u);
          if (on) canvas.rotate(t * 2 * math.pi * 0.3);
          circ(0.0, 0.0, 0.18, base);
          for (var i = 0; i < 12; i++) {
            final a = i * 0.6;
            final r = 0.16 * (1 - i / 14);
            circ(r * math.cos(a), r * math.sin(a), 0.02, offWhite);
          }
          canvas.restore();
        }
      case 'friedegg': // a fried egg, yolk wobbling
        {
          circ(0.50, 0.62, 0.22, offWhite);
          circ(0.34, 0.58, 0.10, offWhite);
          circ(0.66, 0.66, 0.09, offWhite);
          final w = on ? wv(2) * 0.01 : 0.0;
          circ(0.52 + w, 0.60, 0.09, base);
          circ(0.49 + w, 0.57, 0.025, _shade(base, 0.2));
        }
      case 'strawberry': // a strawberry, seeds and a glint
        {
          poly(const [
            Offset(0.36, 0.48), Offset(0.64, 0.48), Offset(0.50, 0.84),
          ], base);
          circ(0.42, 0.52, 0.10, base);
          circ(0.58, 0.52, 0.10, base);
          for (var i = 0; i < 6; i++) {
            final a = i * 1.0;
            circ(0.50 + 0.12 * math.cos(a), 0.58 + 0.12 * math.sin(a), 0.01,
                const Color(0xFFF4E0A0));
          }
          poly(const [
            Offset(0.42, 0.46), Offset(0.58, 0.46), Offset(0.50, 0.40),
          ], const Color(0xFF4F8F4A));
          final s = on ? wv(2) * 0.5 + 0.5 : 0.6;
          circ(0.44, 0.54, 0.02, offWhite.withValues(alpha: s));
        }
      case 'cookie': // a cookie with chocolate chips
        {
          circ(0.50, 0.62, 0.24, base);
          for (final c in const [
            Offset(0.42, 0.54), Offset(0.58, 0.58), Offset(0.50, 0.68),
            Offset(0.40, 0.68), Offset(0.62, 0.50),
          ]) {
            circ(c.dx, c.dy, 0.03, const Color(0xFF4A2A18));
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.44, 0.54, 0.012, offWhite.withValues(alpha: s));
        }
      case 'bagel': // a sesame bagel
        {
          ring(0.50, 0.62, 0.18, 0.14, base);
          for (var i = 0; i < 10; i++) {
            final a = i * 2 * math.pi / 10;
            final px = 0.50 + 0.18 * math.cos(a);
            final py = 0.62 + 0.18 * math.sin(a);
            line(px, py, px + 0.015, py, 0.008, const Color(0xFFF0E0C0));
          }
          final s = on ? wv(2) * 0.3 + 0.4 : 0.4;
          circ(0.40, 0.56, 0.012, offWhite.withValues(alpha: s));
        }
      case 'avocado': // a halved avocado with a glint
        {
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.62 * u),
                width: 0.4 * u, height: 0.56 * u),
            paint..color = const Color(0xFF3F6E2A)..style = PaintingStyle.fill,
          );
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.62 * u),
                width: 0.32 * u, height: 0.46 * u),
            paint..color = base..style = PaintingStyle.fill,
          );
          circ(0.50, 0.66, 0.07, const Color(0xFF7A4A2A));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.46, 0.55, 0.012, offWhite.withValues(alpha: s));
        }
      case 'chocolatebar': // a chocolate bar in foil
        {
          box(0.30, 0.40, 0.62, 0.84, 0.02, base);
          for (var r = 0; r < 3; r++) {
            for (var c = 0; c < 2; c++) {
              box(0.33 + c * 0.13, 0.44 + r * 0.13, 0.43 + c * 0.13,
                  0.54 + r * 0.13, 0.01, _shade(base, 0.08));
            }
          }
          box(0.60, 0.36, 0.74, 0.80, 0.02, const Color(0xFFC0C6CA));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          line(0.34, 0.46, 0.40, 0.44, 0.01, offWhite.withValues(alpha: s));
        }
      case 'fries': // a carton of fries
        {
          poly(const [
            Offset(0.34, 0.56), Offset(0.66, 0.56),
            Offset(0.62, 0.86), Offset(0.38, 0.86),
          ], const Color(0xFFD9534F));
          box(0.34, 0.56, 0.66, 0.62, 0.01, const Color(0xFFC0392B));
          final s = on ? wv(2) * 0.01 : 0.0;
          for (var i = 0; i < 5; i++) {
            final x = 0.38 + i * 0.06;
            box(x - 0.018, 0.36 + (i.isEven ? s : -s), x + 0.018, 0.58, 0.01,
                base);
          }
        }
      case 'grapes': // a cluster of grapes
        {
          line(0.50, 0.40, 0.52, 0.32, 0.012, const Color(0xFF6B4A2A));
          poly(const [
            Offset(0.50, 0.36), Offset(0.56, 0.32), Offset(0.50, 0.34),
          ], const Color(0xFF4F8F4A));
          const rows = [3, 3, 2, 1];
          var y = 0.46;
          for (final n in rows) {
            for (var i = 0; i < n; i++) {
              final x = 0.50 - (n - 1) * 0.05 + i * 0.10;
              circ(x, y, 0.05, base);
              circ(x - 0.012, y - 0.012, 0.015, _shade(base, 0.18));
            }
            y += 0.10;
          }
          final s = on ? wv(2) * 0.3 + 0.4 : 0.4;
          circ(0.48, 0.44, 0.01, offWhite.withValues(alpha: s));
        }
      case 'muffin': // a blueberry muffin
        {
          poly(const [
            Offset(0.36, 0.58), Offset(0.64, 0.58),
            Offset(0.60, 0.86), Offset(0.40, 0.86),
          ], const Color(0xFFB07A4A));
          for (var i = 0; i < 4; i++) {
            line(0.40 + i * 0.06, 0.58, 0.42 + i * 0.06, 0.86, 0.006,
                _shade(const Color(0xFFB07A4A), -0.12));
          }
          dome(0.50, 0.58, 0.20, base);
          for (final c in const [
            Offset(0.42, 0.50), Offset(0.56, 0.50), Offset(0.50, 0.44),
          ]) {
            circ(c.dx, c.dy, 0.02, const Color(0xFF6A4A8A));
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.44, 0.50, 0.01, offWhite.withValues(alpha: s));
        }
      case 'hotdog': // a hot dog with a mustard zigzag
        {
          bowl(0.50, 0.62, 0.30, base);
          box(0.26, 0.54, 0.74, 0.62, 0.04, const Color(0xFFC0584F));
          final s = on ? wv(2) * 0.01 : 0.0;
          for (var i = 0; i < 6; i++) {
            line(0.30 + i * 0.07, 0.56 + (i.isEven ? 0.02 : -0.02) + s,
                0.34 + i * 0.07, 0.56 + (i.isEven ? -0.02 : 0.02) + s, 0.012,
                const Color(0xFFF4C430));
          }
        }
      case 'watermelon': // a watermelon slice
        {
          bowl(0.50, 0.50, 0.30, base);
          bowl(0.50, 0.50, 0.26, offWhite);
          bowl(0.50, 0.50, 0.24, const Color(0xFFE2574C));
          for (var i = 0; i < 5; i++) {
            circ(0.34 + i * 0.08, 0.60, 0.012, const Color(0xFF2A2A2A));
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.42, 0.56, 0.01, offWhite.withValues(alpha: s));
        }
      case 'cinnamonroll': // a cinnamon roll with icing
        {
          circ(0.50, 0.64, 0.22, base);
          for (var i = 0; i < 10; i++) {
            final a = i * 0.7;
            final r = 0.18 * (1 - i / 12);
            circ(0.50 + r * math.cos(a), 0.64 + r * math.sin(a), 0.02,
                _shade(base, -0.14));
          }
          final s = on ? wv(2) * 0.01 : 0.0;
          for (var i = 0; i < 3; i++) {
            line(0.40 + i * 0.08, 0.54, 0.42 + i * 0.08 + s, 0.74, 0.01,
                offWhite);
          }
        }
      case 'popcorn': // a tub of popcorn, one kernel popping
        {
          poly(const [
            Offset(0.34, 0.56), Offset(0.66, 0.56),
            Offset(0.62, 0.86), Offset(0.38, 0.86),
          ], base);
          for (var i = 0; i < 4; i++) {
            box(0.34 + i * 0.085, 0.56, 0.385 + i * 0.085, 0.86, 0.0,
                i.isEven ? const Color(0xFFE2574C) : offWhite);
          }
          for (final c in const [
            Offset(0.40, 0.52), Offset(0.50, 0.50), Offset(0.60, 0.52),
            Offset(0.45, 0.46), Offset(0.55, 0.46),
          ]) {
            circ(c.dx, c.dy, 0.04, const Color(0xFFF4E8C0));
          }
          if (on) {
            final d = saw(1);
            circ(0.50, 0.44 - 0.12 * math.sin(d * math.pi), 0.03,
                const Color(0xFFF4E8C0).withValues(alpha: 1 - d * 0.5));
          }
        }
      case 'pretzel': // a salted pretzel
        {
          arc(0.40, 0.52, 0.14, math.pi * 0.2, math.pi * 1.6, 0.04, base);
          arc(0.60, 0.52, 0.14, math.pi * 1.2, math.pi * 1.6, 0.04, base);
          arc(0.50, 0.66, 0.18, 0, math.pi, 0.04, base);
          for (final c in const [
            Offset(0.40, 0.50), Offset(0.60, 0.50), Offset(0.50, 0.74),
          ]) {
            circ(c.dx, c.dy, 0.012, offWhite);
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.45, 0.48, 0.01, offWhite.withValues(alpha: s));
        }
      case 'milkshake': // a milkshake with whipped cream
        {
          poly(const [
            Offset(0.38, 0.50), Offset(0.62, 0.50),
            Offset(0.58, 0.86), Offset(0.42, 0.86),
          ], base.withValues(alpha: 0.85));
          dome(0.50, 0.50, 0.13, offWhite);
          circ(0.50, 0.36, 0.03, const Color(0xFFD9534F));
          line(0.58, 0.40, 0.66, 0.20, 0.02, const Color(0xFFE2574C));
          final s = on ? wv(2) * 0.01 : 0.0;
          circ(0.44 + s, 0.62, 0.02, offWhite.withValues(alpha: 0.5));
        }
      case 'sandwich': // a triangle sandwich
        {
          poly(const [
            Offset(0.28, 0.78), Offset(0.72, 0.78), Offset(0.50, 0.40),
          ], base);
          poly(const [
            Offset(0.34, 0.70), Offset(0.66, 0.70), Offset(0.50, 0.56),
          ], const Color(0xFF6BA86B));
          poly(const [
            Offset(0.38, 0.74), Offset(0.62, 0.74), Offset(0.50, 0.62),
          ], const Color(0xFFE2574C));
          poly(const [
            Offset(0.42, 0.78), Offset(0.58, 0.78), Offset(0.50, 0.70),
          ], const Color(0xFFF4C430));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.44, 0.66, 0.01, offWhite.withValues(alpha: s));
        }
      case 'salad': // a fresh salad bowl
        {
          bowl(0.50, 0.66, 0.28, const Color(0xFFE6E2DA));
          box(0.24, 0.62, 0.76, 0.68, 0.0, const Color(0xFFD8D2C8));
          for (final c in const [
            Offset(0.38, 0.58), Offset(0.50, 0.56), Offset(0.62, 0.58),
            Offset(0.44, 0.62), Offset(0.56, 0.62),
          ]) {
            circ(c.dx, c.dy, 0.05, base);
          }
          circ(0.46, 0.58, 0.025, const Color(0xFFE2574C));
          circ(0.58, 0.60, 0.025, const Color(0xFFE2574C));
          circ(0.50, 0.56, 0.02, const Color(0xFFE0A82E));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.42, 0.56, 0.01, offWhite.withValues(alpha: s));
        }
      case 'bobatea': // bubble tea with boba pearls
        {
          box(0.38, 0.40, 0.62, 0.86, 0.04, base.withValues(alpha: 0.8));
          box(0.38, 0.36, 0.62, 0.42, 0.02, const Color(0xFFE6E2DA));
          line(0.54, 0.40, 0.62, 0.20, 0.022, const Color(0xFFE2574C));
          for (var i = 0; i < 5; i++) {
            final x = 0.42 + (i % 3) * 0.07;
            final y = 0.78 - (i ~/ 3) * 0.06;
            circ(x, y, 0.022, const Color(0xFF3A2A1A));
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.44, 0.50, 0.012, offWhite.withValues(alpha: s));
        }
      case 'pancakes': // a pancake stack with syrup
        {
          box(0.24, 0.78, 0.76, 0.84, 0.03, const Color(0xFFE6E2DA));
          for (var i = 0; i < 3; i++) {
            canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(0.50 * u, (0.74 - i * 0.08) * u),
                  width: 0.46 * u, height: 0.12 * u),
              paint..color = base..style = PaintingStyle.fill,
            );
          }
          box(0.44, 0.46, 0.56, 0.54, 0.02, const Color(0xFFF4C430));
          if (on) {
            final d = saw(1.5);
            circ(0.62, 0.56 + 0.06 * d, 0.01,
                const Color(0xFFB06A2A).withValues(alpha: 1 - d));
          }
        }
      case 'cocktail': // a cocktail with an olive
        {
          line(0.50, 0.56, 0.50, 0.84, 0.02, const Color(0xFFE6E2DA));
          box(0.38, 0.84, 0.62, 0.88, 0.02, const Color(0xFFE6E2DA));
          poly([
            Offset(0.30, 0.34), Offset(0.70, 0.34), Offset(0.50, 0.58),
          ], base.withValues(alpha: 0.6));
          box(0.30, 0.34, 0.70, 0.40, 0.0, base.withValues(alpha: 0.85));
          line(0.50, 0.34, 0.58, 0.26, 0.008, const Color(0xFFB07A4A));
          circ(0.58, 0.25, 0.025, const Color(0xFF6BA84A));
          final s = on ? wv(3) * 0.3 + 0.5 : 0.5;
          circ(0.44, 0.40, 0.012, offWhite.withValues(alpha: s));
        }
      case 'dumplings': // a bamboo steamer of dumplings
        {
          box(0.26, 0.66, 0.74, 0.84, 0.04, const Color(0xFFD9B87A));
          box(0.26, 0.62, 0.74, 0.68, 0.02, const Color(0xFFC8A060));
          for (var i = 0; i < 3; i++) {
            final x = 0.36 + i * 0.14;
            dome(x, 0.66, 0.10, base);
            for (var k = 0; k < 3; k++) {
              line(x - 0.06 + k * 0.06, 0.66, x - 0.04 + k * 0.06, 0.58, 0.006,
                  _shade(base, -0.10));
            }
          }
          steam(0.40, 0.50);
          steam(0.60, 0.52);
        }
      case 'macarons': // a stack of pastel macarons
        {
          const cols = [
            Color(0xFFE7A9C3), Color(0xFFBFE0D0), Color(0xFFF4D88A),
          ];
          var y = 0.78;
          for (var i = 0; i < 3; i++) {
            final c = cols[i];
            canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(0.50 * u, (y - 0.03) * u),
                  width: 0.32 * u, height: 0.10 * u),
              paint..color = c..style = PaintingStyle.fill,
            );
            box(0.36, y - 0.005, 0.64, y + 0.01, 0.0, _shade(c, -0.12));
            canvas.drawOval(
              Rect.fromCenter(
                  center: Offset(0.50 * u, (y + 0.03) * u),
                  width: 0.32 * u, height: 0.10 * u),
              paint..color = c..style = PaintingStyle.fill,
            );
            y -= 0.12;
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.40, 0.74, 0.01, offWhite.withValues(alpha: s));
        }
      case 'pie': // a latticed pie, steaming
        {
          bowl(0.50, 0.70, 0.30, const Color(0xFFD9A86A));
          box(0.20, 0.66, 0.80, 0.72, 0.02, const Color(0xFFC8975A));
          bowl(0.50, 0.66, 0.26, base);
          for (var i = 0; i < 3; i++) {
            line(0.32 + i * 0.12, 0.50, 0.32 + i * 0.12, 0.70, 0.012,
                const Color(0xFFD9A86A));
            line(0.26, 0.56 + i * 0.05, 0.74, 0.56 + i * 0.05, 0.012,
                const Color(0xFFD9A86A));
          }
          steam(0.44, 0.52);
          steam(0.58, 0.54);
        }
      case 'spaghetti': // a plate of spaghetti with meatballs
        {
          box(0.20, 0.70, 0.80, 0.78, 0.04, const Color(0xFFE6E2DA));
          bowl(0.50, 0.70, 0.30, const Color(0xFFE6E2DA));
          dome(0.50, 0.70, 0.26, base);
          for (var i = 0; i < 6; i++) {
            arc(0.50, 0.66, 0.10 + i * 0.02, math.pi, math.pi, 0.006,
                _shade(base, -0.10));
          }
          circ(0.42, 0.58, 0.04, const Color(0xFFB02818));
          circ(0.58, 0.60, 0.04, const Color(0xFFB02818));
          steam(0.50, 0.48);
        }
      case 'steak': // a grilled steak with garnish
        {
          box(0.20, 0.70, 0.80, 0.78, 0.04, const Color(0xFFE6E2DA));
          box(0.30, 0.56, 0.66, 0.72, 0.08, base);
          box(0.30, 0.56, 0.40, 0.72, 0.06, _shade(base, -0.12));
          for (var i = 0; i < 3; i++) {
            line(0.36 + i * 0.08, 0.58, 0.30 + i * 0.08, 0.70, 0.01,
                _shade(base, -0.2));
          }
          circ(0.70, 0.66, 0.04, const Color(0xFF4F8F4A));
          circ(0.74, 0.62, 0.03, const Color(0xFF4F8F4A));
          steam(0.50, 0.50);
        }
      case 'winebottle': // a wine bottle and a poured glass
        {
          box(0.30, 0.34, 0.44, 0.86, 0.04, const Color(0xFF2E4A2E));
          box(0.34, 0.22, 0.40, 0.36, 0.01, const Color(0xFF2E4A2E));
          box(0.34, 0.20, 0.40, 0.24, 0.01, const Color(0xFF6B4A2A));
          box(0.31, 0.50, 0.43, 0.66, 0.0, const Color(0xFFE6E0CE));
          poly([
            Offset(0.56, 0.46), Offset(0.72, 0.46),
            Offset(0.66, 0.62), Offset(0.62, 0.62),
          ], base.withValues(alpha: 0.7));
          line(0.64, 0.62, 0.64, 0.82, 0.014, const Color(0xFFE6E2DA));
          box(0.56, 0.82, 0.72, 0.86, 0.02, const Color(0xFFE6E2DA));
          final s = on ? wv(3) * 0.3 + 0.5 : 0.5;
          circ(0.60, 0.50, 0.012, offWhite.withValues(alpha: s));
        }
      case 'cheeseboard': // a cheese board with grapes
        {
          box(0.18, 0.60, 0.82, 0.80, 0.04, const Color(0xFFB07A4A));
          poly(const [
            Offset(0.26, 0.58), Offset(0.46, 0.58), Offset(0.30, 0.46),
          ], base);
          for (final c in const [Offset(0.34, 0.54), Offset(0.38, 0.52)]) {
            circ(c.dx, c.dy, 0.012, const Color(0xFFB89A30));
          }
          box(0.50, 0.48, 0.66, 0.58, 0.02, const Color(0xFFE6C56A));
          circ(0.72, 0.50, 0.025, const Color(0xFF6A4A8A));
          circ(0.76, 0.54, 0.025, const Color(0xFF6A4A8A));
          circ(0.70, 0.56, 0.025, const Color(0xFF6A4A8A));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.30, 0.52, 0.008, offWhite.withValues(alpha: s));
        }
      // ── Décor — more famous-art homages 🖼️ ──────────────────────────────────
      case 'artpipe': // "this is not a pipe"
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.30, 0.40, 0.40, 0.52, 0.04, const Color(0xFF6B4A2A));
          arc(0.52, 0.46, 0.16, math.pi * 1.1, math.pi * 0.55, 0.03,
              const Color(0xFF6B4A2A));
          for (var i = 0; i < 6; i++) {
            line(0.28 + i * 0.06, 0.70, 0.32 + i * 0.06, 0.70, 0.008,
                const Color(0xFF2A2A2A));
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artrothko': // a colour-field
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.24, 0.20, 0.76, 0.46, 0.0, const Color(0xFFE0A030));
          box(0.24, 0.50, 0.76, 0.76, 0.0, const Color(0xFF7A1E1E));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artbird': // a blue bird on a branch
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFE6E2DA));
          circ(0.46, 0.50, 0.14, base);
          circ(0.40, 0.40, 0.09, base);
          poly(const [
            Offset(0.30, 0.40), Offset(0.40, 0.42), Offset(0.40, 0.38),
          ], const Color(0xFFF4C430));
          circ(0.38, 0.39, 0.012, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.50, 0.50), Offset(0.66, 0.46), Offset(0.56, 0.62),
          ], Color(0xFF2E6FB8));
          line(0.20, 0.70, 0.80, 0.70, 0.01, const Color(0xFF8FB7C0));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artharing': // bold dancing figures
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          const fc = Color(0xFFE2574C);
          circ(0.40, 0.36, 0.05, fc);
          line(0.40, 0.41, 0.40, 0.58, 0.03, fc);
          line(0.40, 0.46, 0.30, 0.40, 0.03, fc);
          line(0.40, 0.46, 0.50, 0.40, 0.03, fc);
          line(0.40, 0.58, 0.32, 0.72, 0.03, fc);
          line(0.40, 0.58, 0.50, 0.70, 0.03, fc);
          for (var i = 0; i < 3; i++) {
            line(0.26 - i * 0.02, 0.30 + i * 0.04, 0.22 - i * 0.02,
                0.30 + i * 0.04, 0.008, fc);
          }
          const bc = Color(0xFF4A8FE0);
          circ(0.64, 0.40, 0.05, bc);
          line(0.64, 0.45, 0.64, 0.62, 0.03, bc);
          line(0.64, 0.50, 0.74, 0.44, 0.03, bc);
          line(0.64, 0.50, 0.56, 0.56, 0.03, bc);
          line(0.64, 0.62, 0.58, 0.74, 0.03, bc);
          line(0.64, 0.62, 0.72, 0.74, 0.03, bc);
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artcomic': // a pop-art comic panel
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (var r = 0; r < 5; r++) {
            for (var c = 0; c < 6; c++) {
              circ(0.22 + c * 0.10, 0.20 + r * 0.12, 0.012,
                  const Color(0xFFD9534F).withValues(alpha: 0.5));
            }
          }
          box(0.40, 0.22, 0.78, 0.42, 0.04, offWhite);
          poly(const [
            Offset(0.42, 0.40), Offset(0.50, 0.40), Offset(0.40, 0.50),
          ], offWhite);
          line(0.44, 0.30, 0.72, 0.30, 0.008, const Color(0xFF2A2A2A));
          line(0.44, 0.35, 0.66, 0.35, 0.008, const Color(0xFF2A2A2A));
          circ(0.40, 0.62, 0.08, const Color(0xFFE9C6A0));
          circ(0.40, 0.62, 0.02, const Color(0xFF2A2A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artkandinsky': // circles, triangles and lines
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, base);
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFEDE7DA));
          circ(0.36, 0.36, 0.10, const Color(0xFFE2574C));
          circ(0.36, 0.36, 0.05, const Color(0xFF4A8FE0));
          poly(const [
            Offset(0.56, 0.28), Offset(0.72, 0.30), Offset(0.62, 0.46),
          ], const Color(0xFFF4C430));
          for (var i = 0; i < 5; i++) {
            line(0.30 + i * 0.02, 0.60, 0.70 + i * 0.02, 0.50, 0.008,
                const Color(0xFF2A2A2A));
          }
          circ(0.64, 0.66, 0.06, const Color(0xFF6BA84A));
          ring(0.50, 0.50, 0.30, 0.006,
              const Color(0xFF8E68C8).withValues(alpha: 0.5));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artwhistler': // a seated figure in profile, in greys
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFF8A8A82));
          box(0.18, 0.14, 0.46, 0.82, 0.0, const Color(0xFF6A6A64));
          box(0.28, 0.40, 0.40, 0.52, 0.0, const Color(0xFF7A6A5A));
          box(0.40, 0.46, 0.66, 0.80, 0.04, const Color(0xFF1A1A1A));
          box(0.40, 0.74, 0.74, 0.80, 0.0, const Color(0xFF1A1A1A));
          circ(0.46, 0.40, 0.06, const Color(0xFFE9C6A0));
          box(0.42, 0.36, 0.52, 0.40, 0.01, offWhite);
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artpop': // a pop-art soup can
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, offWhite);
          box(0.36, 0.24, 0.64, 0.78, 0.02, base);
          box(0.36, 0.40, 0.64, 0.60, 0.0, offWhite);
          box(0.36, 0.24, 0.64, 0.30, 0.0, const Color(0xFFC0392B));
          line(0.40, 0.48, 0.60, 0.48, 0.01, base);
          line(0.42, 0.53, 0.58, 0.53, 0.008, base);
          circ(0.50, 0.68, 0.04, const Color(0xFFE0A030));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artbasquiat': // a crown and scribbles
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A2A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          poly(const [
            Offset(0.34, 0.46), Offset(0.40, 0.30), Offset(0.46, 0.42),
            Offset(0.50, 0.28), Offset(0.54, 0.42), Offset(0.60, 0.30),
            Offset(0.66, 0.46),
          ], const Color(0xFFF4C430));
          for (var i = 0; i < 4; i++) {
            line(0.28 + i * 0.12, 0.60, 0.34 + i * 0.12, 0.70, 0.01,
                const Color(0xFFE2574C));
          }
          line(0.30, 0.72, 0.70, 0.72, 0.008, offWhite);
          circ(0.40, 0.62, 0.02, const Color(0xFF4A8FE0));
          circ(0.60, 0.64, 0.02, const Color(0xFF6BA84A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artapple': // a suited figure with a green apple for a face
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A3A3A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          dome(0.50, 0.32, 0.10, const Color(0xFF1A1A1A));
          box(0.40, 0.32, 0.60, 0.40, 0.0, const Color(0xFF1A1A1A));
          box(0.34, 0.52, 0.66, 0.82, 0.0, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.44, 0.52), Offset(0.56, 0.52), Offset(0.50, 0.66),
          ], offWhite);
          poly(const [
            Offset(0.48, 0.54), Offset(0.52, 0.54), Offset(0.50, 0.66),
          ], const Color(0xFFC0392B));
          circ(0.50, 0.42, 0.07, const Color(0xFF4F9F3A));
          line(0.50, 0.36, 0.52, 0.33, 0.008, const Color(0xFF6B4A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artballoon': // a girl reaching for a heart balloon
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          circ(0.36, 0.50, 0.06, const Color(0xFF2A2A2A));
          box(0.32, 0.56, 0.40, 0.80, 0.0, const Color(0xFF2A2A2A));
          line(0.40, 0.60, 0.52, 0.46, 0.012, const Color(0xFF2A2A2A));
          final s = on ? wv(1) * 0.02 : 0.0;
          circ(0.56 + s, 0.34, 0.04, const Color(0xFFD9534F));
          circ(0.62 + s, 0.34, 0.04, const Color(0xFFD9534F));
          poly([
            Offset(0.53 + s, 0.36), Offset(0.65 + s, 0.36),
            Offset(0.59 + s, 0.46),
          ], const Color(0xFFD9534F));
          line(0.52, 0.46, 0.59 + s, 0.46, 0.006, const Color(0xFF2A2A2A));
        }
      case 'artpollock': // a drip-splatter canvas
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          const sc = [
            Color(0xFF2A2A2A), Color(0xFFE2574C),
            Color(0xFF4A8FE0), Color(0xFFF4C430),
          ];
          for (var i = 0; i < 24; i++) {
            final a = i * 2.39;
            final x = 0.30 + 0.4 * ((i * 0.137) % 1.0);
            final y = 0.22 + 0.5 * ((i * 0.231) % 1.0);
            line(x, y, x + 0.06 * math.cos(a), y + 0.06 * math.sin(a), 0.006,
                sc[i % 4]);
            circ(x, y, 0.008, sc[(i + 1) % 4]);
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artnighthawks': // a lit late-night diner window
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.26, 0.34, 0.74, 0.62, 0.02, const Color(0xFFE8C56A));
          circ(0.36, 0.46, 0.04, const Color(0xFF6B4A2A));
          box(0.33, 0.50, 0.39, 0.62, 0.0, const Color(0xFF6B4A2A));
          circ(0.52, 0.46, 0.04, const Color(0xFFC0392B));
          box(0.49, 0.50, 0.55, 0.62, 0.0, const Color(0xFFC0392B));
          box(0.26, 0.60, 0.74, 0.64, 0.0, const Color(0xFF8A6A3A));
          line(0.20, 0.66, 0.80, 0.66, 0.01, const Color(0xFF3A3A3A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artpointillism': // a dotted park afternoon
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFFC9A24A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (var r = 0; r < 6; r++) {
            for (var c = 0; c < 8; c++) {
              final col = ((r + c) % 4 == 0)
                  ? const Color(0xFF8FBF7A)
                  : ((r + c) % 4 == 1)
                      ? const Color(0xFFE0C060)
                      : const Color(0xFF6FA88A);
              circ(0.22 + c * 0.075, 0.22 + r * 0.10, 0.012, col);
            }
          }
          dome(0.56, 0.46, 0.10, const Color(0xFFE2574C));
          line(0.56, 0.46, 0.56, 0.66, 0.008, const Color(0xFF6B4A2A));
          box(0.52, 0.56, 0.60, 0.70, 0.0, const Color(0xFF2A2A4A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artsunrise': // a hazy harbour sunrise
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF5A4632));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.18, 0.50, 0.82, 0.82, 0.0, const Color(0xFF5A6E82));
          circ(0.42, 0.36, 0.06, const Color(0xFFE2643C));
          for (var i = 0; i < 4; i++) {
            line(0.36, 0.54 + i * 0.06, 0.48, 0.54 + i * 0.06, 0.01,
                const Color(0xFFE2864C).withValues(alpha: 0.7));
          }
          line(0.58, 0.66, 0.66, 0.66, 0.01, const Color(0xFF2A2A2A));
          line(0.62, 0.60, 0.62, 0.66, 0.008, const Color(0xFF2A2A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artcafe': // a café terrace under stars
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF5A4632));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          final st = on ? wv(2) * 0.3 + 0.7 : 0.8;
          for (final p in const [
            Offset(0.30, 0.24), Offset(0.50, 0.20),
            Offset(0.66, 0.28), Offset(0.40, 0.30),
          ]) {
            circ(p.dx, p.dy, 0.012,
                const Color(0xFFF2E8A0).withValues(alpha: st));
          }
          box(0.22, 0.42, 0.58, 0.50, 0.0, const Color(0xFFE6B82E));
          box(0.24, 0.50, 0.56, 0.80, 0.0,
              const Color(0xFFE0A82E).withValues(alpha: 0.6));
          circ(0.34, 0.66, 0.03, const Color(0xFF6B4A2A));
          circ(0.46, 0.70, 0.03, const Color(0xFF6B4A2A));
        }
      case 'artmelt': // melting clocks over a desert
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.18, 0.56, 0.82, 0.82, 0.0, const Color(0xFF8A6A3A));
          poly(const [
            Offset(0.34, 0.46), Offset(0.54, 0.46), Offset(0.50, 0.66),
            Offset(0.40, 0.70), Offset(0.34, 0.60),
          ], const Color(0xFFE6D7A0));
          circ(0.44, 0.52, 0.06, const Color(0xFFF2E8C0));
          line(0.44, 0.52, 0.44, 0.47, 0.006, const Color(0xFF2A2A2A));
          line(0.44, 0.52, 0.48, 0.54, 0.006, const Color(0xFF2A2A2A));
          circ(0.64, 0.62, 0.05, const Color(0xFFC0A86A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artnightwatch': // a golden-lit group portrait
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A1E12));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (var i = 0; i < 3; i++) {
            line(0.30 + i * 0.16, 0.40, 0.34 + i * 0.16, 0.18, 0.006,
                const Color(0xFF6B5A3A));
          }
          box(0.30, 0.46, 0.42, 0.80, 0.0, const Color(0xFF1A1410));
          circ(0.36, 0.42, 0.05, const Color(0xFFC9A06A));
          box(0.46, 0.42, 0.58, 0.80, 0.0, const Color(0xFFC9A040));
          circ(0.52, 0.38, 0.055, const Color(0xFFE9C6A0));
          box(0.60, 0.48, 0.70, 0.80, 0.0, const Color(0xFF2A2018));
          circ(0.65, 0.44, 0.05, const Color(0xFFB89060));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artvenus': // a figure on a scallop shell
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFFC9A24A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.18, 0.60, 0.82, 0.82, 0.0, const Color(0xFF6FA8B0));
          dome(0.50, 0.74, 0.24, const Color(0xFFF2D9C0));
          for (var i = 0; i < 5; i++) {
            line(0.34 + i * 0.08, 0.74, 0.30 + i * 0.10, 0.56, 0.008,
                _shade(const Color(0xFFF2D9C0), -0.12));
          }
          poly(const [
            Offset(0.44, 0.34), Offset(0.56, 0.34), Offset(0.50, 0.46),
          ], const Color(0xFFC98A4A));
          circ(0.50, 0.40, 0.06, const Color(0xFFE9C6A0));
          box(0.46, 0.45, 0.54, 0.66, 0.03, const Color(0xFFE9C6A0));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artkiss': // a golden embracing pair
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF8A6A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFF3A3020));
          poly(const [
            Offset(0.30, 0.80), Offset(0.36, 0.34),
            Offset(0.64, 0.34), Offset(0.70, 0.80),
          ], base);
          for (var r = 0; r < 3; r++) {
            for (var c = 0; c < 3; c++) {
              final col = (r + c).isEven
                  ? const Color(0xFFC0392B)
                  : const Color(0xFF4A6FD0);
              box(0.40 + c * 0.08, 0.46 + r * 0.10, 0.46 + c * 0.08,
                  0.52 + r * 0.10, 0.01, col);
            }
          }
          circ(0.46, 0.36, 0.06, const Color(0xFFE9C6A0));
          circ(0.56, 0.34, 0.055, const Color(0xFFE9C6A0));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artmona': // an enigmatic smiling portrait
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF5A4632));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.38, 0.30, 0.62, 0.58, 0.0, const Color(0xFF3A2A1A));
          box(0.34, 0.54, 0.66, 0.82, 0.0, const Color(0xFF2A2A1A));
          poly(const [
            Offset(0.34, 0.54), Offset(0.50, 0.50), Offset(0.66, 0.54),
            Offset(0.62, 0.66), Offset(0.38, 0.66),
          ], const Color(0xFF2A2A1A));
          circ(0.50, 0.42, 0.10, const Color(0xFFE0B68C));
          box(0.42, 0.70, 0.58, 0.76, 0.03, const Color(0xFFE0B68C));
          arc(0.50, 0.46, 0.05, 0.2 * math.pi, 0.6 * math.pi, 0.006,
              const Color(0xFF6B4A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artarnolfini': // a betrothal couple with a round mirror
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A2A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.28, 0.40, 0.42, 0.82, 0.0, const Color(0xFF1A1A1A));
          box(0.31, 0.30, 0.39, 0.36, 0.0, const Color(0xFF1A1A1A));
          circ(0.35, 0.36, 0.05, const Color(0xFFE9C6A0));
          box(0.54, 0.42, 0.72, 0.82, 0.04, const Color(0xFF3A5A3A));
          circ(0.63, 0.38, 0.05, const Color(0xFFE9C6A0));
          circ(0.50, 0.30, 0.05, const Color(0xFF8A8A7A));
          ring(0.50, 0.30, 0.06, 0.008, const Color(0xFFC0A040));
          circ(0.48, 0.78, 0.03, const Color(0xFF6B4A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artbosch': // a fantastical three-panel garden
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF5A4632));
          box(0.18, 0.14, 0.39, 0.82, 0.0, const Color(0xFF8FB89A));
          box(0.40, 0.14, 0.60, 0.82, 0.0, base);
          box(0.61, 0.14, 0.82, 0.82, 0.0, const Color(0xFF3A2A2A));
          box(0.48, 0.40, 0.52, 0.66, 0.0, const Color(0xFFE7A9C3));
          dome(0.50, 0.40, 0.06, const Color(0xFFE7A9C3));
          for (var i = 0; i < 5; i++) {
            circ(0.43 + i * 0.035, 0.60, 0.012, const Color(0xFFE0B68C));
          }
          line(0.28, 0.66, 0.28, 0.46, 0.01, const Color(0xFF6B4A2A));
          circ(0.28, 0.42, 0.06, const Color(0xFF4F8F4A));
          circ(0.72, 0.40, 0.05, const Color(0xFFE2643C));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artcreation': // two hands almost touching
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.22, 0.54, 0.44, 0.62, 0.04, const Color(0xFFE0B68C));
          poly(const [
            Offset(0.44, 0.54), Offset(0.54, 0.50),
            Offset(0.54, 0.58), Offset(0.44, 0.62),
          ], const Color(0xFFE0B68C));
          dome(0.74, 0.46, 0.16, const Color(0xFFD9CBB0));
          box(0.58, 0.40, 0.78, 0.48, 0.04, const Color(0xFFE0B68C));
          poly(const [
            Offset(0.58, 0.40), Offset(0.48, 0.44),
            Offset(0.48, 0.50), Offset(0.58, 0.48),
          ], const Color(0xFFE0B68C));
          final s = on ? wv(3) * 0.4 + 0.6 : 0.7;
          circ(0.51, 0.50, 0.012, const Color(0xFFFFF0C0).withValues(alpha: s));
        }
      // ── Accessories (more, animated) ✨ ─────────────────────────────────────
      case 'pinwheel': // a spinning pinwheel
        {
          line(0.50, 0.46, 0.50, 0.88, 0.014, const Color(0xFF6B4A2A));
          canvas.save();
          canvas.translate(0.50 * u, 0.42 * u);
          if (on) canvas.rotate(t * 2 * math.pi * 0.6);
          const pc = [
            Color(0xFFE2574C), Color(0xFFF4C430),
            Color(0xFF4A8FE0), Color(0xFF6BA86B),
          ];
          for (var i = 0; i < 4; i++) {
            final a = i * math.pi / 2;
            final path = Path()
              ..moveTo(0, 0)
              ..lineTo(0.16 * u * math.cos(a), 0.16 * u * math.sin(a))
              ..lineTo(0.16 * u * math.cos(a + 0.6),
                  0.16 * u * math.sin(a + 0.6))
              ..close();
            canvas.drawPath(
                path, paint..color = pc[i]..style = PaintingStyle.fill);
          }
          canvas.restore();
          circ(0.50, 0.42, 0.02, dark);
        }
      case 'pennant': // a string of bunting flags fluttering (wall)
        {
          line(0.16, 0.28, 0.84, 0.34, 0.008, const Color(0xFF6B4A2A));
          const pc = [
            Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFF4A8FE0),
            Color(0xFF6BA86B), Color(0xFFE86BA8),
          ];
          for (var i = 0; i < 5; i++) {
            final x = 0.22 + i * 0.14;
            final s = on ? wv(2, i * 0.2) * 0.02 : 0.0;
            poly([
              Offset(x - 0.05, 0.30 + i * 0.012),
              Offset(x + 0.05, 0.30 + i * 0.012),
              Offset(x, 0.46 + s),
            ], pc[i]);
          }
        }
      case 'puzzlecube': // a colour-cube whose face shifts
        {
          const pc = [
            Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFF4A8FE0),
            Color(0xFF6BA86B), Color(0xFFE6E2DA), Color(0xFFF08A3C),
          ];
          final shift = on ? (saw(0.5) < 0.5 ? 0 : 1) : 0;
          for (var c = 0; c < 3; c++) {
            poly([
              Offset(0.32 + c * 0.12, 0.40), Offset(0.36 + c * 0.12, 0.34),
              Offset(0.46 + c * 0.12, 0.34), Offset(0.42 + c * 0.12, 0.40),
            ], _shade(pc[c], 0.10));
          }
          for (var r = 0; r < 3; r++) {
            for (var c = 0; c < 3; c++) {
              box(0.32 + c * 0.12, 0.40 + r * 0.12, 0.42 + c * 0.12,
                  0.50 + r * 0.12, 0.01, pc[(r * 3 + c + shift) % 6]);
            }
          }
        }
      case 'incense': // an incense stick curling smoke
        {
          box(0.30, 0.78, 0.70, 0.84, 0.03, base);
          line(0.40, 0.78, 0.62, 0.40, 0.008, const Color(0xFF6B4A2A));
          circ(0.62, 0.40, 0.012, const Color(0xFFE2574C));
          if (on) {
            for (var k = 0; k < 2; k++) {
              final d = saw(0.6, k * 0.5);
              final y = 0.40 - 0.26 * d;
              final x = 0.62 + 0.04 * math.sin((d + k) * 6);
              circ(x, y, 0.012 + 0.01 * d,
                  const Color(0xFFB0B0B0)
                      .withValues(alpha: math.sin(d * math.pi) * 0.4));
            }
          }
        }
      case 'dreamcatcher': // a dream catcher, feathers swaying (wall)
        {
          ring(0.50, 0.40, 0.20, 0.014, base);
          for (var i = 0; i < 8; i++) {
            final a = i * math.pi / 4;
            line(0.50, 0.40, 0.50 + 0.18 * math.cos(a),
                0.40 + 0.18 * math.sin(a), 0.004, _shade(base, 0.1));
          }
          ring(0.50, 0.40, 0.10, 0.004, _shade(base, 0.1));
          circ(0.50, 0.40, 0.02, const Color(0xFF4A8FE0));
          final s = on ? wv(1) * 0.02 : 0.0;
          for (var i = 0; i < 3; i++) {
            final x = 0.40 + i * 0.10;
            line(x, 0.60, x + s, 0.84, 0.006, const Color(0xFF6B4A2A));
            poly([
              Offset(x + s - 0.02, 0.72), Offset(x + s + 0.02, 0.72),
              Offset(x + s, 0.84),
            ], const Color(0xFFD9A86A));
          }
        }
      case 'kaleidoscope': // a kaleidoscope with a turning pattern
        {
          box(0.30, 0.56, 0.74, 0.66, 0.05, base);
          line(0.40, 0.66, 0.36, 0.82, 0.012, dark);
          line(0.64, 0.66, 0.68, 0.82, 0.012, dark);
          canvas.save();
          canvas.translate(0.30 * u, 0.61 * u);
          if (on) canvas.rotate(t * 2 * math.pi * 0.4);
          const pc = [
            Color(0xFFE2574C), Color(0xFFF4C430), Color(0xFF4A8FE0),
            Color(0xFF6BA86B), Color(0xFF8E68C8), Color(0xFFE86BA8),
          ];
          for (var i = 0; i < 6; i++) {
            canvas.drawArc(
              Rect.fromCircle(center: Offset.zero, radius: 0.06 * u),
              i * math.pi / 3, math.pi / 3, true,
              paint..color = pc[i]..style = PaintingStyle.fill,
            );
          }
          canvas.restore();
        }
      case 'magicball': // a fortune ball, its answer surfacing
        {
          circ(0.50, 0.56, 0.26, base);
          circ(0.50, 0.56, 0.12, const Color(0xFF14143A));
          final g = on ? wv(1.5) * 0.4 + 0.5 : 0.6;
          poly([
            Offset(0.44, 0.50), Offset(0.56, 0.50), Offset(0.50, 0.62),
          ], const Color(0xFF6FA8E0).withValues(alpha: g));
          circ(0.40, 0.46, 0.06, offWhite.withValues(alpha: 0.2));
          box(0.40, 0.80, 0.60, 0.86, 0.03, dark);
        }
      case 'abacus': // an abacus, a bead sliding
        {
          box(0.24, 0.30, 0.76, 0.82, 0.03, base);
          box(0.27, 0.33, 0.73, 0.79, 0.0, _shade(base, 0.10));
          for (var r = 0; r < 4; r++) {
            final y = 0.40 + r * 0.12;
            line(0.27, y, 0.73, y, 0.006, dark);
            for (var b = 0; b < 5; b++) {
              final slide = (r == 1 && on) ? wv(1) * 0.02 : 0.0;
              circ(0.32 + b * 0.085 + slide, y, 0.025,
                  const [Color(0xFFE2574C), Color(0xFF4A8FE0)][r % 2]);
            }
          }
        }
      case 'fairylights': // a string of twinkling bulbs (wall)
        {
          line(0.16, 0.26, 0.84, 0.26, 0.006, const Color(0xFF6B6B6B));
          const bc = [
            Color(0xFFF4C430), Color(0xFFE2574C), Color(0xFF6BA86B),
            Color(0xFF4A8FE0), Color(0xFFE86BA8),
          ];
          for (var i = 0; i < 8; i++) {
            final x = 0.20 + i * 0.085;
            final y = 0.32 + (i.isEven ? 0.06 : 0.02);
            final g = on ? wv(4, i * 0.3) * 0.4 + 0.6 : 0.8;
            line(x, y - 0.06, x, y - 0.02, 0.004, const Color(0xFF6B6B6B));
            circ(x, y, 0.024, bc[i % 5].withValues(alpha: g));
          }
        }
      case 'crystalcluster': // a glittering crystal cluster
        {
          box(0.34, 0.78, 0.66, 0.84, 0.02, const Color(0xFF6E5A52));
          final g = on ? wv(2) * 0.2 + 0.7 : 0.8;
          poly([
            Offset(0.36, 0.78), Offset(0.44, 0.78), Offset(0.38, 0.52),
          ], _shade(base, 0.10).withValues(alpha: g));
          poly([
            Offset(0.52, 0.78), Offset(0.62, 0.78), Offset(0.58, 0.48),
          ], _shade(base, -0.06).withValues(alpha: g));
          poly([
            Offset(0.60, 0.78), Offset(0.68, 0.78), Offset(0.64, 0.58),
          ], base.withValues(alpha: g * 0.9));
          poly([
            Offset(0.42, 0.78), Offset(0.50, 0.78), Offset(0.46, 0.40),
          ], base.withValues(alpha: g));
        }
      case 'newtoncradle': // a Newton's cradle, end ball swinging
        {
          box(0.24, 0.78, 0.76, 0.84, 0.02, base);
          line(0.28, 0.78, 0.28, 0.34, 0.014, base);
          line(0.72, 0.78, 0.72, 0.34, 0.014, base);
          line(0.28, 0.34, 0.72, 0.34, 0.014, base);
          for (var i = 0; i < 5; i++) {
            final x = 0.34 + i * 0.08;
            var bx = x;
            if (i == 0 && on) {
              bx = x - math.max(0.0, math.sin(t * 2 * math.pi)) * 0.08;
            }
            if (i == 4 && on) {
              bx = x + math.max(0.0, -math.sin(t * 2 * math.pi)) * 0.08;
            }
            line(x, 0.34, bx, 0.62, 0.004, const Color(0xFF888888));
            circ(bx, 0.66, 0.04, const Color(0xFFB7C0C7));
          }
        }
      case 'musicbox': // a music box with a spinning ballerina
        {
          box(0.26, 0.58, 0.74, 0.84, 0.04, base);
          box(0.26, 0.54, 0.74, 0.60, 0.02, _shade(base, 0.08));
          poly(const [
            Offset(0.26, 0.54), Offset(0.74, 0.54),
            Offset(0.78, 0.42), Offset(0.30, 0.42),
          ], _shade(base, -0.10));
          canvas.save();
          canvas.translate(0.50 * u, 0.50 * u);
          if (on) canvas.rotate(math.sin(t * 2 * math.pi) * 0.5);
          circ(0.0, -0.06, 0.03, const Color(0xFFE9C6A0));
          final path = Path()
            ..moveTo(-0.06 * u, 0.0)
            ..lineTo(0.06 * u, 0.0)
            ..lineTo(0.0, -0.05 * u)
            ..close();
          canvas.drawPath(
              path, paint..color = const Color(0xFFE7A9C3)..style = PaintingStyle.fill);
          canvas.restore();
          if (on) {
            final d = saw(1);
            circ(0.72, 0.40 - 0.1 * d, 0.012, dark.withValues(alpha: 1 - d));
          }
        }
      case 'chessset': // a chessboard with a couple of pieces
        {
          box(0.22, 0.56, 0.78, 0.84, 0.02, const Color(0xFF6D4C41));
          for (var r = 0; r < 4; r++) {
            for (var c = 0; c < 4; c++) {
              box(0.24 + c * 0.135, 0.58 + r * 0.065, 0.375 + c * 0.135,
                  0.645 + r * 0.065, 0.0,
                  (r + c).isEven
                      ? const Color(0xFFE6D7B8)
                      : const Color(0xFF8A6A4A));
            }
          }
          final b = on ? wv(0.6) * 0.004 : 0.0;
          box(0.36, 0.40 + b, 0.44, 0.56, 0.02, const Color(0xFF2A2A2A));
          circ(0.40, 0.38 + b, 0.04, const Color(0xFF2A2A2A));
          line(0.40, 0.34 + b, 0.40, 0.30 + b, 0.012, const Color(0xFF2A2A2A));
          line(0.37, 0.32 + b, 0.43, 0.32 + b, 0.012, const Color(0xFF2A2A2A));
          circ(0.60, 0.46, 0.04, offWhite);
          poly(const [
            Offset(0.56, 0.56), Offset(0.64, 0.56),
            Offset(0.62, 0.48), Offset(0.58, 0.48),
          ], Color(0xFFECECEC));
        }
      case 'fortunecat': // a lucky cat waving its paw
        {
          poly(const [
            Offset(0.34, 0.86), Offset(0.66, 0.86),
            Offset(0.62, 0.54), Offset(0.38, 0.54),
          ], base);
          circ(0.50, 0.44, 0.18, base);
          poly(const [
            Offset(0.36, 0.40), Offset(0.44, 0.32), Offset(0.44, 0.44),
          ], Color(0xFFF2F2F2));
          poly(const [
            Offset(0.64, 0.40), Offset(0.56, 0.32), Offset(0.56, 0.44),
          ], Color(0xFFF2F2F2));
          poly(const [
            Offset(0.38, 0.39), Offset(0.43, 0.34), Offset(0.43, 0.43),
          ], Color(0xFFE6B0C0));
          poly(const [
            Offset(0.62, 0.39), Offset(0.57, 0.34), Offset(0.57, 0.43),
          ], Color(0xFFE6B0C0));
          circ(0.44, 0.44, 0.014, const Color(0xFF2A2A2A));
          circ(0.56, 0.44, 0.014, const Color(0xFF2A2A2A));
          circ(0.50, 0.48, 0.012, const Color(0xFFE07A8A));
          arc(0.50, 0.54, 0.10, 0.1 * math.pi, 0.7 * math.pi, 0.012,
              const Color(0xFFE2574C));
          circ(0.50, 0.58, 0.022, const Color(0xFFF4C430));
          circ(0.40, 0.66, 0.05, const Color(0xFFE0A82E));
          final w = on ? wv(2) * 0.04 : 0.0;
          circ(0.64, 0.56 - w.abs(), 0.05, base);
        }
      // ── Food (final batch) 🍱 ───────────────────────────────────────────────
      case 'gummybears': // a row of wiggly gummy bears
        {
          const cols = [
            Color(0xFFE2574C), Color(0xFFF4C430),
            Color(0xFF6BA86B), Color(0xFFE86BA8),
          ];
          for (var i = 0; i < 4; i++) {
            final x = 0.30 + i * 0.13;
            final yb = on ? wv(2, i * 0.25) * 0.01 : 0.0;
            circ(x, 0.50 + yb, 0.05, cols[i]);
            box(x - 0.05, 0.54 + yb, x + 0.05, 0.74, 0.03, cols[i]);
            circ(x - 0.05, 0.50 + yb, 0.02, cols[i]);
            circ(x + 0.05, 0.50 + yb, 0.02, cols[i]);
            circ(x - 0.04, 0.74, 0.025, cols[i]);
            circ(x + 0.04, 0.74, 0.025, cols[i]);
            circ(x - 0.02, 0.50 + yb, 0.008, const Color(0xFF2A2A2A));
            circ(x + 0.02, 0.50 + yb, 0.008, const Color(0xFF2A2A2A));
          }
        }
      case 'baguette': // a crusty baguette
        {
          canvas.save();
          canvas.translate(0.50 * u, 0.60 * u);
          canvas.rotate(-0.5);
          box(-0.34, -0.08, 0.34, 0.08, 0.08, base);
          for (var i = 0; i < 4; i++) {
            line(-0.18 + i * 0.12, -0.06, -0.12 + i * 0.12, 0.06, 0.012,
                _shade(base, -0.16));
          }
          canvas.restore();
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.40, 0.50, 0.01, offWhite.withValues(alpha: s));
        }
      case 'candyapple': // a glossy candy apple
        {
          line(0.50, 0.40, 0.50, 0.86, 0.014, const Color(0xFFB0B0B0));
          circ(0.50, 0.50, 0.18, base);
          circ(0.44, 0.44, 0.05, offWhite.withValues(alpha: 0.3));
          line(0.50, 0.34, 0.54, 0.30, 0.008, const Color(0xFF6B4A2A));
          poly(const [
            Offset(0.52, 0.33), Offset(0.58, 0.30), Offset(0.54, 0.36),
          ], const Color(0xFF4F8F4A));
          final s = on ? wv(3) * 0.3 + 0.5 : 0.5;
          circ(0.56, 0.48, 0.012, offWhite.withValues(alpha: s));
        }
      case 'gingerbread': // a smiling gingerbread man
        {
          circ(0.50, 0.34, 0.10, base);
          box(0.42, 0.42, 0.58, 0.66, 0.05, base);
          line(0.42, 0.46, 0.30, 0.56, 0.05, base);
          line(0.58, 0.46, 0.70, 0.56, 0.05, base);
          line(0.46, 0.66, 0.40, 0.82, 0.05, base);
          line(0.54, 0.66, 0.60, 0.82, 0.05, base);
          circ(0.46, 0.33, 0.012, offWhite);
          circ(0.54, 0.33, 0.012, offWhite);
          for (var i = 0; i < 3; i++) {
            circ(0.50, 0.50 + i * 0.05, 0.012, offWhite);
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          arc(0.50, 0.36, 0.04, 0.2 * math.pi, 0.6 * math.pi, 0.006,
              offWhite.withValues(alpha: s));
        }
      case 'churros': // churros with a chocolate dip
        {
          bowl(0.66, 0.74, 0.14, const Color(0xFF6B3A20));
          for (var i = 0; i < 3; i++) {
            final x = 0.30 + i * 0.08;
            final s = on ? wv(2, i * 0.3) * 0.01 : 0.0;
            canvas.save();
            canvas.translate((x + s) * u, 0.56 * u);
            canvas.rotate(0.3);
            box(-0.03, -0.20, 0.03, 0.20, 0.03, base);
            for (var k = 0; k < 5; k++) {
              line(-0.03, -0.16 + k * 0.08, 0.03, -0.16 + k * 0.08, 0.004,
                  _shade(base, -0.14));
            }
            canvas.restore();
          }
        }
      case 'waffle': // a round waffle with butter
        {
          circ(0.50, 0.60, 0.24, base);
          canvas.save();
          canvas.clipPath(Path()
            ..addOval(Rect.fromCircle(
                center: Offset(0.50 * u, 0.60 * u), radius: 0.24 * u)));
          for (var i = -2; i <= 2; i++) {
            line(0.50 + i * 0.08, 0.36, 0.50 + i * 0.08, 0.84, 0.006,
                _shade(base, -0.12));
            line(0.26, 0.60 + i * 0.08, 0.74, 0.60 + i * 0.08, 0.006,
                _shade(base, -0.12));
          }
          canvas.restore();
          box(0.44, 0.46, 0.56, 0.54, 0.02, const Color(0xFFE0A030));
          if (on) {
            final d = saw(1.5);
            circ(0.60, 0.58 + 0.06 * d, 0.01,
                const Color(0xFFB06A2A).withValues(alpha: 1 - d));
          }
        }
      case 'soup': // a steaming soup bowl with a spoon
        {
          bowl(0.50, 0.66, 0.30, const Color(0xFFE6E2DA));
          box(0.20, 0.62, 0.80, 0.68, 0.0, base);
          circ(0.42, 0.64, 0.03, const Color(0xFFE0A030));
          circ(0.56, 0.65, 0.025, const Color(0xFF6BA86B));
          line(0.62, 0.46, 0.74, 0.66, 0.016, const Color(0xFFB7C0C7));
          circ(0.74, 0.66, 0.04, const Color(0xFFB7C0C7));
          steam(0.45, 0.56);
          steam(0.56, 0.58);
        }
      case 'friedchicken': // a crispy drumstick
        {
          circ(0.46, 0.50, 0.16, base);
          circ(0.58, 0.62, 0.10, base);
          for (var i = 0; i < 6; i++) {
            final a = i * 1.0;
            circ(0.46 + 0.10 * math.cos(a), 0.50 + 0.10 * math.sin(a), 0.015,
                _shade(base, -0.10));
          }
          box(0.56, 0.66, 0.74, 0.72, 0.03, offWhite);
          circ(0.74, 0.68, 0.03, offWhite);
          circ(0.74, 0.74, 0.03, offWhite);
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.42, 0.46, 0.012, offWhite.withValues(alpha: s));
        }
      case 'breakfastplate': // a full breakfast plate
        {
          circ(0.50, 0.62, 0.30, base);
          circ(0.50, 0.62, 0.26, const Color(0xFFF4F0E8));
          circ(0.40, 0.56, 0.08, offWhite);
          circ(0.40, 0.56, 0.035, const Color(0xFFF2C430));
          for (var i = 0; i < 2; i++) {
            line(0.52, 0.66 + i * 0.06, 0.66, 0.64 + i * 0.06, 0.03,
                const Color(0xFFC0584F));
          }
          for (final c in const [
            Offset(0.58, 0.54), Offset(0.62, 0.57), Offset(0.56, 0.58),
          ]) {
            circ(c.dx, c.dy, 0.02, const Color(0xFFD9663A));
          }
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.36, 0.52, 0.012, offWhite.withValues(alpha: s));
        }
      case 'bento': // a bento box with compartments
        {
          box(0.22, 0.46, 0.78, 0.82, 0.04, base);
          box(0.24, 0.48, 0.48, 0.80, 0.02, const Color(0xFFECE6DA));
          for (var i = 0; i < 3; i++) {
            box(0.28 + i * 0.06, 0.54, 0.33 + i * 0.06, 0.62, 0.01,
                const Color(0xFF2A2A2A));
          }
          box(0.50, 0.48, 0.78, 0.62, 0.02, const Color(0xFFE2745C));
          box(0.50, 0.64, 0.78, 0.80, 0.02, const Color(0xFF6BA86B));
          circ(0.60, 0.72, 0.025, const Color(0xFFE0A82E));
          circ(0.68, 0.70, 0.025, const Color(0xFFE2574C));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.30, 0.52, 0.012, offWhite.withValues(alpha: s));
        }
      // ── Pets (more) 🐾 ──────────────────────────────────────────────────────
      case 'kitten': // a kitten with a flicking tail
        {
          poly(const [
            Offset(0.38, 0.60), Offset(0.62, 0.60),
            Offset(0.66, 0.84), Offset(0.34, 0.84),
          ], base);
          circ(0.50, 0.50, 0.15, base);
          poly(const [
            Offset(0.38, 0.44), Offset(0.44, 0.34), Offset(0.46, 0.46),
          ], base);
          poly(const [
            Offset(0.62, 0.44), Offset(0.56, 0.34), Offset(0.54, 0.46),
          ], base);
          poly(const [
            Offset(0.40, 0.43), Offset(0.44, 0.37), Offset(0.45, 0.45),
          ], Color(0xFFE6B0C0));
          poly(const [
            Offset(0.60, 0.43), Offset(0.56, 0.37), Offset(0.55, 0.45),
          ], Color(0xFFE6B0C0));
          circ(0.44, 0.50, 0.02, const Color(0xFF2A2A2A));
          circ(0.56, 0.50, 0.02, const Color(0xFF2A2A2A));
          circ(0.50, 0.55, 0.015, const Color(0xFFE07A8A));
          line(0.46, 0.56, 0.34, 0.54, 0.004, dark);
          line(0.54, 0.56, 0.66, 0.54, 0.004, dark);
          final w = on ? wv(2) * 0.05 : 0.0;
          line(0.62, 0.78, 0.74 + w, 0.66, 0.03, base);
        }
      case 'frog': // a frog blinking
        {
          circ(0.50, 0.66, 0.22, base);
          circ(0.40, 0.46, 0.08, base);
          circ(0.60, 0.46, 0.08, base);
          final blink = on && wv(0.8) > 0.9;
          if (!blink) {
            circ(0.40, 0.44, 0.04, offWhite);
            circ(0.60, 0.44, 0.04, offWhite);
            circ(0.40, 0.44, 0.02, const Color(0xFF2A2A2A));
            circ(0.60, 0.44, 0.02, const Color(0xFF2A2A2A));
          } else {
            line(0.36, 0.44, 0.44, 0.44, 0.006, const Color(0xFF2A2A2A));
            line(0.56, 0.44, 0.64, 0.44, 0.006, const Color(0xFF2A2A2A));
          }
          arc(0.50, 0.66, 0.12, 0.1 * math.pi, 0.7 * math.pi, 0.008,
              _shade(base, -0.2));
          circ(0.34, 0.82, 0.04, _shade(base, 0.06));
          circ(0.66, 0.82, 0.04, _shade(base, 0.06));
        }
      case 'mouse': // a little mouse, tail curling
        {
          circ(0.46, 0.62, 0.16, base);
          circ(0.62, 0.54, 0.10, base);
          circ(0.66, 0.46, 0.06, base);
          circ(0.70, 0.50, 0.05, const Color(0xFFE6B0C0));
          circ(0.72, 0.56, 0.012, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.72, 0.54), Offset(0.78, 0.56), Offset(0.72, 0.58),
          ], Color(0xFFE07A8A));
          final w = on ? wv(1.5) * 0.03 : 0.0;
          arc(0.34, 0.70, 0.10, math.pi * 1.3, math.pi, 0.008, base);
          line(0.24, 0.74, 0.18 + w, 0.66, 0.006, base);
        }
      case 'chick': // a fluffy chick, gently bobbing
        {
          final b = on ? wv(2) * 0.01 : 0.0;
          circ(0.50, 0.66 + b, 0.16, base);
          circ(0.50, 0.48 + b, 0.12, base);
          poly([
            Offset(0.50, 0.46 + b), Offset(0.58, 0.49 + b),
            Offset(0.50, 0.52 + b),
          ], const Color(0xFFF08A3C));
          circ(0.46, 0.46 + b, 0.014, const Color(0xFF2A2A2A));
          circ(0.54, 0.46 + b, 0.014, const Color(0xFF2A2A2A));
          line(0.46, 0.82, 0.44, 0.86, 0.008, const Color(0xFFF08A3C));
          line(0.54, 0.82, 0.56, 0.86, 0.008, const Color(0xFFF08A3C));
          poly([
            Offset(0.40, 0.62 + b), Offset(0.48, 0.60 + b), Offset(0.44, 0.72),
          ], _shade(base, -0.08));
        }
      case 'snail': // a snail inching along, antennae waving
        {
          poly(const [
            Offset(0.24, 0.78), Offset(0.62, 0.78),
            Offset(0.58, 0.84), Offset(0.22, 0.84),
          ], Color(0xFFE6C7A6));
          circ(0.26, 0.74, 0.07, const Color(0xFFE6C7A6));
          final a = on ? wv(2) * 0.01 : 0.0;
          line(0.24, 0.68, 0.20 + a, 0.58, 0.006, const Color(0xFFE6C7A6));
          circ(0.20 + a, 0.57, 0.012, const Color(0xFF2A2A2A));
          line(0.28, 0.68, 0.26 + a, 0.58, 0.006, const Color(0xFFE6C7A6));
          circ(0.26 + a, 0.57, 0.012, const Color(0xFF2A2A2A));
          circ(0.50, 0.62, 0.18, base);
          for (var i = 0; i < 8; i++) {
            final ang = i * 0.7;
            final r = 0.15 * (1 - i / 10);
            circ(0.50 + r * math.cos(ang), 0.62 + r * math.sin(ang), 0.012,
                _shade(base, -0.12));
          }
        }
      // ── Garden (more) 🌿 ────────────────────────────────────────────────────
      case 'birdfeeder': // a hanging feeder with a visiting bird
        {
          line(0.50, 0.12, 0.50, 0.30, 0.01, dark);
          poly(const [
            Offset(0.32, 0.34), Offset(0.50, 0.24), Offset(0.68, 0.34),
          ], _shade(base, -0.10));
          box(0.36, 0.34, 0.64, 0.40, 0.0, base);
          box(0.36, 0.40, 0.64, 0.46, 0.0, const Color(0xFFE8C56A));
          line(0.30, 0.43, 0.70, 0.43, 0.006, dark);
          final b = on ? wv(1.5) * 0.01 : 0.0;
          circ(0.32, 0.40 + b, 0.04, const Color(0xFFE2574C));
          circ(0.29, 0.38 + b, 0.025, const Color(0xFFE2574C));
          poly([
            Offset(0.26, 0.38 + b), Offset(0.22, 0.39 + b),
            Offset(0.26, 0.40 + b),
          ], const Color(0xFFE0A82E));
        }
      case 'sunlounger': // a striped sun lounger with a parasol
        {
          poly(const [
            Offset(0.22, 0.66), Offset(0.46, 0.66),
            Offset(0.40, 0.42), Offset(0.20, 0.46),
          ], base);
          box(0.44, 0.62, 0.80, 0.70, 0.02, base);
          line(0.46, 0.70, 0.46, 0.84, 0.014, dark);
          line(0.78, 0.70, 0.78, 0.84, 0.014, dark);
          line(0.22, 0.66, 0.22, 0.82, 0.014, dark);
          for (var i = 0; i < 4; i++) {
            line(0.48 + i * 0.08, 0.62, 0.48 + i * 0.08, 0.70, 0.02,
                i.isEven ? const Color(0xFFE2574C) : offWhite);
          }
          final s = on ? wv(0.6) * 0.02 : 0.0;
          line(0.70, 0.40, 0.70, 0.62, 0.01, const Color(0xFF6B4A2A));
          dome(0.70 + s, 0.40, 0.14, const Color(0xFFE2574C));
        }
      case 'gardenswing': // a garden swing rocking gently
        {
          line(0.18, 0.84, 0.30, 0.20, 0.016, base);
          line(0.42, 0.84, 0.30, 0.20, 0.016, base);
          line(0.82, 0.84, 0.70, 0.20, 0.016, base);
          line(0.58, 0.84, 0.70, 0.20, 0.016, base);
          line(0.30, 0.20, 0.70, 0.20, 0.016, base);
          final s = on ? wv(0.8) * 0.04 : 0.0;
          line(0.38 + s, 0.20, 0.38 + s, 0.56, 0.006, dark);
          line(0.62 + s, 0.20, 0.62 + s, 0.56, 0.006, dark);
          box(0.34 + s, 0.56, 0.66 + s, 0.62, 0.02, _shade(base, 0.08));
          box(0.34 + s, 0.44, 0.38 + s, 0.62, 0.02, _shade(base, 0.08));
          box(0.62 + s, 0.44, 0.66 + s, 0.62, 0.02, _shade(base, 0.08));
          for (var i = 0; i < 4; i++) {
            line(0.36 + s + i * 0.08, 0.44, 0.36 + s + i * 0.08, 0.56, 0.008,
                _shade(base, 0.04));
          }
        }
      // ── Spa (more) 🧖 ───────────────────────────────────────────────────────
      case 'eyemask': // a cosy sleep mask
        {
          canvas.drawOval(
            Rect.fromCenter(
                center: Offset(0.50 * u, 0.56 * u),
                width: 0.5 * u, height: 0.22 * u),
            paint..color = base..style = PaintingStyle.fill,
          );
          arc(0.50, 0.56, 0.30, math.pi * 1.2, math.pi * 0.6, 0.012,
              _shade(base, -0.10));
          arc(0.40, 0.55, 0.05, 0, math.pi, 0.008, offWhite);
          arc(0.60, 0.55, 0.05, 0, math.pi, 0.008, offWhite);
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.36, 0.50, 0.01, offWhite.withValues(alpha: s));
        }
      case 'poolfloat': // a ring float bobbing on water
        {
          box(0.16, 0.74, 0.84, 0.86, 0.04,
              const Color(0xFF7FC0D8).withValues(alpha: 0.5));
          final b = on ? wv(1) * 0.01 * u : 0.0;
          canvas.save();
          canvas.translate(0, b);
          ring(0.50, 0.60, 0.20, 0.10, base);
          for (var i = 0; i < 6; i++) {
            if (i.isEven) {
              arc(0.50, 0.60, 0.20, i * math.pi / 3, math.pi / 3, 0.10,
                  offWhite);
            }
          }
          circ(0.50, 0.60, 0.10, const Color(0xFF8FD0E0).withValues(alpha: 0.5));
          canvas.restore();
        }
      case 'bathrobe': // a fluffy bathrobe on a hanger
        {
          line(0.30, 0.20, 0.70, 0.20, 0.012, dark);
          poly(const [
            Offset(0.50, 0.18), Offset(0.46, 0.24), Offset(0.54, 0.24),
          ], dark);
          final s = on ? wv(0.6) * 0.01 : 0.0;
          poly([
            Offset(0.34, 0.28), Offset(0.66, 0.28),
            Offset(0.70 + s, 0.84), Offset(0.30 + s, 0.84),
          ], base);
          poly(const [
            Offset(0.46, 0.28), Offset(0.50, 0.50), Offset(0.42, 0.40),
          ], _shade(base, -0.08));
          poly(const [
            Offset(0.54, 0.28), Offset(0.50, 0.50), Offset(0.58, 0.40),
          ], _shade(base, -0.08));
          box(0.34 + s * 0.5, 0.54, 0.66 + s * 0.5, 0.60, 0.01,
              _shade(base, -0.12));
          box(0.56 + s, 0.64, 0.66 + s, 0.74, 0.01, _shade(base, -0.06));
        }
      // ── Gourmet Kitchen (more) 🍳 ───────────────────────────────────────────
      case 'juicer': // a citrus juicer
        {
          box(0.34, 0.70, 0.66, 0.84, 0.04, _shade(base, -0.14));
          box(0.36, 0.54, 0.64, 0.72, 0.03, const Color(0x668FB7C0));
          poly(const [
            Offset(0.40, 0.54), Offset(0.60, 0.54), Offset(0.50, 0.36),
          ], base);
          for (var i = 0; i < 4; i++) {
            line(0.44 + i * 0.04, 0.52, 0.50, 0.38, 0.004, _shade(base, -0.14));
          }
          circ(0.66, 0.46, 0.05, const Color(0xFFF4C430));
          final s = on ? wv(2) * 0.3 + 0.5 : 0.5;
          circ(0.42, 0.60, 0.012, offWhite.withValues(alpha: s));
        }
      case 'toasteroven': // a toaster oven glowing inside
        {
          box(0.22, 0.44, 0.78, 0.80, 0.04, base);
          box(0.28, 0.50, 0.66, 0.74, 0.02, const Color(0xFF2A2A2A));
          final g = on ? 0.4 + 0.4 * wv(4) : 0.5;
          box(0.30, 0.52, 0.64, 0.72, 0.0,
              const Color(0xFFE8862C).withValues(alpha: g * 0.5));
          line(0.32, 0.58, 0.62, 0.58, 0.012,
              const Color(0xFFE8862C).withValues(alpha: g));
          box(0.42, 0.60, 0.54, 0.66, 0.01, const Color(0xFFD9A86A));
          circ(0.72, 0.54, 0.025, _shade(base, -0.16));
          circ(0.72, 0.64, 0.025, _shade(base, -0.16));
        }
      case 'breadmaker': // a bread maker, loaf rising + steam
        {
          box(0.28, 0.30, 0.72, 0.84, 0.05, base);
          box(0.34, 0.36, 0.66, 0.40, 0.01, _shade(base, -0.16));
          box(0.40, 0.46, 0.60, 0.62, 0.02, const Color(0xFF2A2A2A));
          box(0.42, 0.50, 0.58, 0.60, 0.02, const Color(0xFFD9A86A));
          box(0.36, 0.68, 0.64, 0.78, 0.02, const Color(0xFF3A3A3A));
          circ(0.42, 0.73, 0.012, const Color(0xFF5BE07A));
          for (var i = 0; i < 3; i++) {
            box(0.50 + i * 0.04, 0.71, 0.53 + i * 0.04, 0.75, 0.005,
                const Color(0xFF888888));
          }
          steam(0.50, 0.30);
        }
      // ── Décor — final art homages 🖼️ ────────────────────────────────────────
      case 'artcave': // an ochre cave painting
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6B4A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          const ink = Color(0xFF4A2A18);
          poly(const [
            Offset(0.30, 0.60), Offset(0.34, 0.44), Offset(0.50, 0.42),
            Offset(0.62, 0.46), Offset(0.66, 0.60), Offset(0.58, 0.58),
            Offset(0.54, 0.66), Offset(0.40, 0.66), Offset(0.36, 0.58),
          ], ink);
          line(0.62, 0.46, 0.70, 0.38, 0.012, ink);
          line(0.62, 0.46, 0.72, 0.42, 0.012, ink);
          circ(0.74, 0.66, 0.04,
              const Color(0xFFC0392B).withValues(alpha: 0.5));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artegypt': // an Egyptian profile figure
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF8A6A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          const sk = Color(0xFFB5763A);
          poly(const [
            Offset(0.40, 0.30), Offset(0.52, 0.30),
            Offset(0.52, 0.40), Offset(0.40, 0.40),
          ], Color(0xFF2A2A4A));
          circ(0.44, 0.34, 0.07, sk);
          poly(const [
            Offset(0.50, 0.30), Offset(0.58, 0.32), Offset(0.50, 0.34),
          ], sk);
          box(0.40, 0.40, 0.50, 0.62, 0.0, sk);
          line(0.50, 0.44, 0.62, 0.50, 0.03, sk);
          box(0.40, 0.62, 0.54, 0.78, 0.0, offWhite);
          box(0.20, 0.66, 0.34, 0.80, 0.0, const Color(0xFF3A5A6A));
          for (var i = 0; i < 3; i++) {
            line(0.23 + i * 0.04, 0.68, 0.23 + i * 0.04, 0.78, 0.006,
                const Color(0xFFE0C060));
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artredroom': // a flat red interior
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (var i = 0; i < 4; i++) {
            for (var j = 0; j < 3; j++) {
              final cx = 0.30 + i * 0.14;
              final cy = 0.26 + j * 0.18;
              arc(cx, cy, 0.03, 0, math.pi, 0.006, const Color(0xFF2E4A8E));
            }
          }
          box(0.58, 0.20, 0.78, 0.46, 0.0, const Color(0xFF6BA86B));
          box(0.58, 0.20, 0.78, 0.24, 0.0, const Color(0xFF8FC0E0));
          line(0.18, 0.62, 0.82, 0.62, 0.012, const Color(0xFF7A1E1E));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artrain': // a rainy boulevard with umbrellas
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A3A3A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.18, 0.62, 0.82, 0.82, 0.0, const Color(0xFF9A9A92));
          box(0.18, 0.14, 0.46, 0.50, 0.0, const Color(0xFFA8A89C));
          dome(0.40, 0.46, 0.10, const Color(0xFF2A2A2A));
          line(0.40, 0.46, 0.40, 0.62, 0.006, const Color(0xFF2A2A2A));
          box(0.37, 0.54, 0.43, 0.66, 0.0, const Color(0xFF3A3A3A));
          dome(0.62, 0.42, 0.09, const Color(0xFF2A2A2A));
          line(0.62, 0.42, 0.62, 0.58, 0.006, const Color(0xFF2A2A2A));
          box(0.59, 0.50, 0.65, 0.64, 0.0, const Color(0xFF4A4A4A));
          if (on) {
            for (var k = 0; k < 5; k++) {
              final d = saw(1.5, k / 5.0);
              final x = 0.26 + k * 0.12;
              line(x, 0.18 + 0.5 * d, x - 0.02, 0.22 + 0.5 * d, 0.004,
                  offWhite.withValues(alpha: 0.3));
            }
          }
        }
      case 'artflag': // stars and stripes
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          for (var i = 0; i < 7; i++) {
            box(0.18, 0.16 + i * 0.094, 0.82, 0.16 + i * 0.094 + 0.047, 0.0,
                i.isEven ? const Color(0xFFC0392B) : offWhite);
          }
          box(0.18, 0.16, 0.46, 0.44, 0.0, base);
          for (var r = 0; r < 3; r++) {
            for (var c = 0; c < 4; c++) {
              circ(0.22 + c * 0.06, 0.20 + r * 0.08, 0.012, offWhite);
            }
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artgrid': // a four-up pop portrait grid
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          const bg = [
            Color(0xFFE86BA8), Color(0xFFF4C430),
            Color(0xFF4A8FE0), Color(0xFF6BA86B),
          ];
          const hair = [
            Color(0xFFF4C430), Color(0xFFE2574C),
            Color(0xFFF2F2F2), Color(0xFF8E68C8),
          ];
          for (var i = 0; i < 4; i++) {
            final qx = 0.18 + (i % 2) * 0.32;
            final qy = 0.14 + (i ~/ 2) * 0.34;
            box(qx, qy, qx + 0.32, qy + 0.34, 0.0, bg[i]);
            circ(qx + 0.16, qy + 0.18, 0.10, const Color(0xFFE9C6A0));
            dome(qx + 0.16, qy + 0.12, 0.11, hair[i]);
            circ(qx + 0.12, qy + 0.17, 0.012, const Color(0xFF2A2A2A));
            circ(qx + 0.20, qy + 0.17, 0.012, const Color(0xFF2A2A2A));
            box(qx + 0.13, qy + 0.23, qx + 0.19, qy + 0.25, 0.0,
                const Color(0xFFC0392B));
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artmiro': // playful surreal shapes
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          line(0.26, 0.30, 0.50, 0.50, 0.006, const Color(0xFF1A1A1A));
          line(0.50, 0.50, 0.70, 0.28, 0.006, const Color(0xFF1A1A1A));
          line(0.50, 0.50, 0.60, 0.70, 0.006, const Color(0xFF1A1A1A));
          circ(0.26, 0.30, 0.05, const Color(0xFFE2574C));
          poly(const [
            Offset(0.46, 0.46), Offset(0.56, 0.46), Offset(0.50, 0.56),
          ], Color(0xFF4A8FE0));
          for (var i = 0; i < 4; i++) {
            final a = i * math.pi / 2;
            line(0.70 + 0.04 * math.cos(a), 0.28 + 0.04 * math.sin(a),
                0.70 - 0.04 * math.cos(a), 0.28 - 0.04 * math.sin(a), 0.006,
                const Color(0xFFF4C430));
          }
          circ(0.60, 0.70, 0.04, const Color(0xFF6BA86B));
          circ(0.34, 0.66, 0.05, const Color(0xFF2A2A2A));
          circ(0.37, 0.64, 0.04, base);
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artdance': // a ring of joined dancers
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A3A4A));
          box(0.18, 0.14, 0.82, 0.50, 0.0, const Color(0xFF3A5A7A));
          box(0.18, 0.50, 0.82, 0.82, 0.0, const Color(0xFF2E5A3A));
          const fc = Color(0xFFB5402A);
          for (var i = 0; i < 5; i++) {
            final a = i * 2 * math.pi / 5 - math.pi / 2;
            final cx = 0.50 + 0.22 * math.cos(a);
            final cy = 0.48 + 0.18 * math.sin(a);
            final nx = 0.50 + 0.22 * math.cos(a + 2 * math.pi / 5);
            final ny = 0.48 + 0.18 * math.sin(a + 2 * math.pi / 5);
            line(cx, cy, nx, ny, 0.012, fc);
            circ(cx, cy - 0.06, 0.035, fc);
            box(cx - 0.025, cy - 0.03, cx + 0.025, cy + 0.10, 0.02, fc);
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artbar': // a barmaid behind a counter of bottles
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, base);
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFF4A4438));
          box(0.18, 0.66, 0.82, 0.74, 0.0, const Color(0xFFC8B89A));
          const bot = [
            Color(0xFF2E5A3A), Color(0xFFC0392B),
            Color(0xFFE0A82E), Color(0xFF6B4A2A),
          ];
          for (var i = 0; i < 4; i++) {
            box(0.24 + i * 0.06 - 0.012, 0.52, 0.24 + i * 0.06 + 0.012, 0.66,
                0.01, bot[i]);
            box(0.62 + i * 0.05 - 0.012, 0.54, 0.62 + i * 0.05 + 0.012, 0.66,
                0.01, bot[i]);
          }
          box(0.42, 0.44, 0.58, 0.66, 0.0, const Color(0xFF2A2A2A));
          box(0.44, 0.44, 0.56, 0.50, 0.0, const Color(0xFFE9C6A0));
          circ(0.50, 0.38, 0.06, const Color(0xFFE9C6A0));
          circ(0.50, 0.50, 0.012, const Color(0xFFE2574C));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artjungle': // a tiger among jungle leaves
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A3A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (final p in const [
            Offset(0.28, 0.30), Offset(0.72, 0.36),
            Offset(0.30, 0.66), Offset(0.70, 0.66),
          ]) {
            poly([
              Offset(p.dx - 0.10, p.dy), Offset(p.dx, p.dy - 0.14),
              Offset(p.dx + 0.10, p.dy),
            ], _shade(base, 0.10));
            line(p.dx, p.dy, p.dx, p.dy - 0.13, 0.006, _shade(base, -0.14));
          }
          circ(0.50, 0.52, 0.14, const Color(0xFFE0902E));
          for (var i = 0; i < 4; i++) {
            line(0.40 + i * 0.06, 0.42, 0.41 + i * 0.06, 0.50, 0.01,
                const Color(0xFF2A2A2A));
          }
          circ(0.44, 0.52, 0.02, const Color(0xFF2A2A2A));
          circ(0.56, 0.52, 0.02, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.47, 0.58), Offset(0.53, 0.58), Offset(0.50, 0.62),
          ], Color(0xFF2A2A2A));
          circ(0.70, 0.26, 0.05, const Color(0xFFF2E8A0));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artvanitas': // a candle-lit vanitas still life
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A2A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.18, 0.70, 0.82, 0.74, 0.0, const Color(0xFF3A2A1A));
          circ(0.46, 0.56, 0.12, const Color(0xFFE6E0D0));
          box(0.40, 0.60, 0.52, 0.70, 0.04, const Color(0xFFE6E0D0));
          circ(0.42, 0.55, 0.022, const Color(0xFF1A1A1A));
          circ(0.50, 0.55, 0.022, const Color(0xFF1A1A1A));
          box(0.64, 0.50, 0.68, 0.70, 0.01, const Color(0xFFE6D7B8));
          final f = on ? 1 + wv(6) * 0.3 : 1.0;
          poly([
            Offset(0.66, 0.46 - 0.04 * f),
            Offset(0.645, 0.50), Offset(0.675, 0.50),
          ], const Color(0xFFF2A03C));
          box(0.26, 0.66, 0.44, 0.70, 0.0, const Color(0xFF7A2E2A));
        }
      case 'artgeisha': // a woodblock-style portrait
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6D4C41));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          dome(0.50, 0.40, 0.16, const Color(0xFF1A1A1A));
          box(0.36, 0.34, 0.64, 0.44, 0.0, const Color(0xFF1A1A1A));
          circ(0.50, 0.42, 0.10, const Color(0xFFF2E8E0));
          circ(0.46, 0.42, 0.01, const Color(0xFF2A2A2A));
          circ(0.54, 0.42, 0.01, const Color(0xFF2A2A2A));
          box(0.485, 0.47, 0.515, 0.49, 0.0, const Color(0xFFC0392B));
          line(0.40, 0.34, 0.34, 0.28, 0.008, const Color(0xFFE0A82E));
          line(0.60, 0.34, 0.66, 0.28, 0.008, const Color(0xFFE0A82E));
          poly(const [
            Offset(0.36, 0.56), Offset(0.64, 0.56),
            Offset(0.72, 0.82), Offset(0.28, 0.82),
          ], Color(0xFFC0584F));
          poly(const [
            Offset(0.46, 0.56), Offset(0.54, 0.56), Offset(0.50, 0.74),
          ], Color(0xFFE0A82E));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artweeping': // a cubist weeping face, a tear falling
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF2A2A2A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          box(0.34, 0.28, 0.52, 0.50, 0.0, const Color(0xFFF4C430));
          poly(const [
            Offset(0.52, 0.28), Offset(0.66, 0.32),
            Offset(0.60, 0.54), Offset(0.52, 0.50),
          ], Color(0xFFE9C6A0));
          poly(const [
            Offset(0.34, 0.28), Offset(0.50, 0.18), Offset(0.66, 0.30),
          ], Color(0xFFC0392B));
          circ(0.42, 0.38, 0.03, offWhite);
          circ(0.42, 0.38, 0.014, const Color(0xFF2A2A2A));
          circ(0.58, 0.40, 0.03, offWhite);
          circ(0.58, 0.40, 0.014, const Color(0xFF2A2A2A));
          poly(const [
            Offset(0.44, 0.56), Offset(0.56, 0.56),
            Offset(0.52, 0.62), Offset(0.48, 0.62),
          ], offWhite);
          for (var i = 0; i < 3; i++) {
            line(0.46 + i * 0.03, 0.57, 0.46 + i * 0.03, 0.61, 0.006,
                const Color(0xFF2A2A2A));
          }
          if (on) {
            final d = saw(1.5);
            circ(0.42, 0.44 + 0.14 * d, 0.012,
                const Color(0xFF6FB6D6).withValues(alpha: 1 - d));
          }
        }
      case 'artselfvan': // a swirly self-portrait
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF5A4632));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (var i = 0; i < 4; i++) {
            arc(0.30 + i * 0.14, 0.26, 0.05, 0, 2 * math.pi * 0.8, 0.008,
                _shade(base, 0.14));
          }
          poly(const [
            Offset(0.34, 0.58), Offset(0.66, 0.58),
            Offset(0.72, 0.82), Offset(0.28, 0.82),
          ], Color(0xFF3A6A8A));
          poly(const [
            Offset(0.40, 0.30), Offset(0.60, 0.30),
            Offset(0.58, 0.44), Offset(0.42, 0.44),
          ], Color(0xFFD96A2A));
          circ(0.50, 0.44, 0.11, const Color(0xFFE0B68C));
          poly(const [
            Offset(0.42, 0.50), Offset(0.58, 0.50), Offset(0.50, 0.60),
          ], Color(0xFFD96A2A));
          circ(0.46, 0.44, 0.012, const Color(0xFF2A2A2A));
          circ(0.54, 0.44, 0.012, const Color(0xFF2A2A2A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artguernica': // a monochrome war mural
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF1A1A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          const blk = Color(0xFF2A2A2A);
          const wht = Color(0xFFE6E2DA);
          poly(const [
            Offset(0.22, 0.40), Offset(0.40, 0.24), Offset(0.36, 0.46),
          ], wht);
          poly(const [
            Offset(0.40, 0.50), Offset(0.60, 0.30), Offset(0.58, 0.56),
          ], blk);
          poly(const [
            Offset(0.56, 0.40), Offset(0.78, 0.36), Offset(0.66, 0.60),
          ], wht);
          circ(0.30, 0.34, 0.05, wht);
          line(0.26, 0.30, 0.22, 0.24, 0.01, blk);
          line(0.34, 0.30, 0.38, 0.24, 0.01, blk);
          circ(0.50, 0.26, 0.04, wht);
          for (var i = 0; i < 8; i++) {
            final a = i * math.pi / 4;
            line(0.50, 0.26, 0.50 + 0.06 * math.cos(a),
                0.26 + 0.06 * math.sin(a), 0.003, blk);
          }
          for (var i = 0; i < 4; i++) {
            line(0.62, 0.68, 0.58 + i * 0.03, 0.60, 0.006, blk);
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artkahlo': // a self-portrait with a flower crown
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF3A2A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, base);
          for (final p in const [
            Offset(0.26, 0.30), Offset(0.74, 0.30), Offset(0.28, 0.62),
          ]) {
            poly([
              Offset(p.dx - 0.06, p.dy), Offset(p.dx, p.dy - 0.10),
              Offset(p.dx + 0.06, p.dy),
            ], _shade(base, -0.12));
          }
          poly(const [
            Offset(0.34, 0.60), Offset(0.66, 0.60),
            Offset(0.72, 0.82), Offset(0.28, 0.82),
          ], Color(0xFF8A2A3A));
          box(0.37, 0.34, 0.63, 0.46, 0.0, const Color(0xFF1A1A1A));
          circ(0.50, 0.46, 0.13, const Color(0xFFE0B68C));
          circ(0.40, 0.32, 0.03, const Color(0xFFE2574C));
          circ(0.50, 0.28, 0.03, const Color(0xFFF4C430));
          circ(0.60, 0.32, 0.03, const Color(0xFFE86BA8));
          line(0.42, 0.44, 0.58, 0.44, 0.012, const Color(0xFF2A2A2A));
          circ(0.45, 0.47, 0.012, const Color(0xFF2A2A2A));
          circ(0.55, 0.47, 0.012, const Color(0xFF2A2A2A));
          box(0.47, 0.53, 0.53, 0.55, 0.0, const Color(0xFFA0302A));
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artklimttree': // a golden tree of spiralling life
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFF6B5A1A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFC9A83A));
          line(0.50, 0.82, 0.50, 0.50, 0.02, const Color(0xFF8A6A2A));
          for (var i = 0; i < 6; i++) {
            final a = i * 1.05;
            final r = 0.06 + i * 0.03;
            arc(0.50, 0.42, r, a, math.pi * 1.4, 0.008,
                const Color(0xFF8A6A2A));
          }
          const dc = [
            Color(0xFFE2574C), Color(0xFF2E5A3A),
            Color(0xFF2A2A2A), Color(0xFFE6E2DA),
          ];
          for (var i = 0; i < 10; i++) {
            final a = i * 0.63;
            final rr = 0.10 + (i % 3) * 0.06;
            circ(0.50 + rr * math.cos(a), 0.42 + rr * math.sin(a * 0.8), 0.016,
                dc[i % 4]);
          }
          if (on) {
            final sw = saw(0.5);
            line(0.18 + sw * 0.64, 0.14, 0.10 + sw * 0.64, 0.82, 0.02,
                offWhite.withValues(alpha: math.sin(sw * math.pi) * 0.10));
          }
        }
      case 'artballoondog': // a glossy balloon dog
        {
          box(0.14, 0.10, 0.86, 0.86, 0.03, const Color(0xFFC9A24A));
          box(0.18, 0.14, 0.82, 0.82, 0.0, const Color(0xFFEDE7DA));
          box(0.30, 0.62, 0.40, 0.74, 0.05, base);
          box(0.50, 0.62, 0.66, 0.74, 0.05, base);
          box(0.36, 0.50, 0.60, 0.62, 0.06, base);
          circ(0.36, 0.56, 0.07, base);
          circ(0.60, 0.56, 0.07, base);
          circ(0.34, 0.70, 0.06, base);
          circ(0.44, 0.70, 0.06, base);
          circ(0.54, 0.70, 0.06, base);
          circ(0.64, 0.70, 0.06, base);
          circ(0.66, 0.46, 0.07, base);
          circ(0.74, 0.50, 0.05, base);
          line(0.62, 0.40, 0.56, 0.32, 0.04, base);
          line(0.70, 0.40, 0.74, 0.32, 0.04, base);
          final g = on ? wv(2) * 0.3 + 0.6 : 0.7;
          circ(0.40, 0.54, 0.02, offWhite.withValues(alpha: g));
          circ(0.66, 0.44, 0.018, offWhite.withValues(alpha: g));
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
