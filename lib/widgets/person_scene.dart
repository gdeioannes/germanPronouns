/// Standalone illustrations of the app's little People cast — the same warm,
/// flat, softly-lit figures that live in the room, composed into small scenes
/// for the app's key moments: a welcome chat on the course finder, a searching
/// figure on empty states, per-goal vignettes on the course intro, a
/// celebration when something unlocks.
///
/// Everything is painted through the shared [FlatPaintKit], so the cast reads
/// as one family wherever it appears; no image assets are involved.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/brand_palette.dart';
import 'people_paint.dart';

/// The scenes on offer. Each is a small self-contained illustration; [chat]
/// is wider than tall (two figures talking), the rest are square.
enum PersonSceneKind {
  /// A friendly greeter, one hand raised in a wave.
  wave,

  /// Two people in conversation under speech bubbles — the app's "languages
  /// are people talking" hero image.
  chat,

  /// Someone peering through a magnifying glass, a question mark floating by
  /// — for "nothing found" empty states.
  search,

  /// Holding a certificate overhead — the certification goal.
  certificate,

  /// Sitting cross-legged over a book — the grammar goal.
  study,

  /// Showing off big flashcards — the vocabulary goal.
  flashcards,

  /// Scanning the horizon beside a planted flag — the discover goal.
  explore,

  /// Arms up in a shower of confetti — celebrations.
  celebrate,

  /// Four people saying hello in four languages — the login poster's cast.
  /// Composed for a dark brand field but works on light surfaces too.
  greeters,
}

/// The vignette for a course goal key (see `Course.goal`); a friendly wave
/// for goals without a scene of their own.
PersonSceneKind personSceneForGoal(String? goal) => switch (goal) {
      'certification' => PersonSceneKind.certificate,
      'grammar' => PersonSceneKind.study,
      'vocabulary' => PersonSceneKind.flashcards,
      'discover' => PersonSceneKind.explore,
      _ => PersonSceneKind.wave,
    };

/// One [PersonSceneKind] drawn at a given [height] (width follows the scene's
/// aspect ratio). Purely decorative by default — wrap in [Semantics] where a
/// label is useful.
class PersonScene extends StatelessWidget {
  const PersonScene(this.kind, {super.key, required this.height});

  final PersonSceneKind kind;
  final double height;

  /// Width:height. The chat and greeters scenes need room for several
  /// figures and their bubbles.
  static double aspectOf(PersonSceneKind kind) => switch (kind) {
        PersonSceneKind.chat => 1.7,
        PersonSceneKind.greeters => 2.7,
        _ => 1.0,
      };

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(height * aspectOf(kind), height),
        painter: _PersonScenePainter(kind),
      ),
    );
  }
}

// Outfit colors — the brand palette, so the scenes wear the app's identity.
const Color _navy = Color(kBrandNavy);
const Color _terracotta = Color(kBrandTerracotta);
const Color _forest = Color(kBrandForest);
const Color _ochre = Color(kBrandOchre);
const Color _offWhite = Color(0xFFFBFAF6);
const Color _bubble = Color(0xFFF3EEE4); // warm paper for speech bubbles
const Color _ink = Color(0xFF2A2A28);

class _PersonScenePainter extends CustomPainter {
  // Repaint when system/fallback fonts finish loading: the greeting bubbles
  // draw real text, and on web the CJK glyphs (你好) arrive via an async
  // Noto fallback download — without this the first paint's tofu boxes would
  // stick forever on a static CustomPaint.
  _PersonScenePainter(this.kind)
      : super(repaint: PaintingBinding.instance.systemFonts);

  final PersonSceneKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    // Unit space is the square of the scene's height; wide scenes simply use
    // x coordinates past 1.0.
    final u = size.height;
    final k = FlatPaintKit(canvas, u, Paint()..isAntiAlias = true);

    switch (kind) {
      case PersonSceneKind.wave:
        _wave(k);
      case PersonSceneKind.chat:
        _chat(k);
      case PersonSceneKind.search:
        _search(k);
      case PersonSceneKind.certificate:
        _certificate(k);
      case PersonSceneKind.study:
        _study(k);
      case PersonSceneKind.flashcards:
        _flashcards(k);
      case PersonSceneKind.explore:
        _explore(k);
      case PersonSceneKind.celebrate:
        _celebrate(k);
      case PersonSceneKind.greeters:
        _greeters(k);
    }
  }

  /// A standing figure: two legs with shoes and a soft-box torso, ready for a
  /// head and arms. [cx] is the body's centre, [top] the torso's top edge.
  void _body(FlatPaintKit k, double cx, double top, Color outfit,
      {double halfW = 0.07, double lean = 0}) {
    final hipY = top + 0.20;
    k.line(cx - 0.03, hipY, cx - 0.05 + lean, 0.88, 0.052, outfit);
    k.line(cx + 0.03, hipY, cx + 0.05 + lean, 0.88, 0.052, outfit);
    k.shoe(cx - 0.05 + lean, 0.885, -1, shade(outfit, -0.22));
    k.shoe(cx + 0.05 + lean, 0.885, 1, shade(outfit, -0.22));
    k.box(cx - halfW, top, cx + halfW, top + 0.22, 0.085, outfit);
  }

  /// A rounded speech bubble with a little tail toward [tailX],[tailY] and
  /// three "talking" dots, so it reads in any language.
  void _speechBubble(FlatPaintKit k, double l, double t, double r, double b,
      double tailX, double tailY, List<Color> dots) {
    final cx = (l + r) / 2;
    final cy = (t + b) / 2;
    k.poly([
      Offset(cx - 0.05, cy),
      Offset(cx + 0.05, cy),
      Offset(tailX, tailY),
    ], _bubble, flat: true);
    k.box(l, t, r, b, 0.07, _bubble, flat: true);
    final step = (r - l) / (dots.length + 1);
    for (final (i, c) in dots.indexed) {
      k.circ(l + step * (i + 1), cy, 0.022, c, flat: true);
    }
  }

  void _wave(FlatPaintKit k) {
    const outfit = _terracotta;
    _body(k, 0.50, 0.43, outfit);
    k.head(0.50, 0.325, 0.095,
        style: 'curly', skinTone: kSkinTones[2], hairColor: kHairColors[0]);
    k.line(0.45, 0.48, 0.395, 0.60, 0.042, outfit); // relaxed arm
    k.hand(0.39, 0.61, c: kSkinTones[2]);
    k.line(0.55, 0.48, 0.665, 0.335, 0.042, outfit); // waving arm
    k.hand(0.67, 0.325, c: kSkinTones[2]);
    // Two little motion arcs around the waving hand.
    k.arc(0.67, 0.325, 0.075, -math.pi * 0.55, math.pi * 0.5, 0.014,
        shade(outfit, 0.18));
    k.arc(0.67, 0.325, 0.115, -math.pi * 0.45, math.pi * 0.35, 0.012,
        shade(outfit, 0.26));
  }

  void _chat(FlatPaintKit k) {
    // Staggered bubbles first, so the figures overlap their tails slightly.
    _speechBubble(k, 0.30, 0.08, 0.72, 0.28, 0.46, 0.36,
        const [_navy, _terracotta, _ochre]);
    _speechBubble(k, 0.98, 0.16, 1.40, 0.36, 1.24, 0.44,
        const [_forest, _ochre, _navy]);
    // Left speaker — forest outfit, gesturing toward the other.
    _body(k, 0.44, 0.49, _forest);
    k.head(0.44, 0.385, 0.09,
        style: 'short', skinTone: kSkinTones[1], hairColor: kHairColors[1]);
    k.line(0.38, 0.54, 0.34, 0.64, 0.042, _forest); // resting arm
    k.hand(0.335, 0.65, c: kSkinTones[1]);
    k.line(0.50, 0.54, 0.585, 0.49, 0.042, _forest); // gesturing arm
    k.hand(0.59, 0.485, c: kSkinTones[1]);
    // Right speaker — terracotta outfit, long hair, answering gesture.
    _body(k, 1.26, 0.49, _terracotta);
    k.head(1.26, 0.385, 0.09,
        style: 'long', skinTone: kSkinTones[3], hairColor: kHairColors[2]);
    k.line(1.32, 0.54, 1.36, 0.64, 0.042, _terracotta); // resting arm
    k.hand(1.365, 0.65, c: kSkinTones[3]);
    k.line(1.20, 0.54, 1.115, 0.49, 0.042, _terracotta); // gesturing arm
    k.hand(1.11, 0.485, c: kSkinTones[3]);
  }

  void _search(FlatPaintKit k) {
    const outfit = _navy;
    _body(k, 0.44, 0.45, outfit, lean: 0.01);
    k.head(0.46, 0.335, 0.09,
        style: 'side', skinTone: kSkinTones[0], hairColor: kHairColors[3]);
    k.line(0.38, 0.50, 0.35, 0.61, 0.042, outfit); // arm behind
    k.hand(0.345, 0.62, c: kSkinTones[0]);
    k.line(0.52, 0.50, 0.625, 0.435, 0.042, outfit); // arm to the glass
    k.hand(0.63, 0.43, c: kSkinTones[0]);
    // The magnifying glass — handle from the hand, a faint lens, a firm rim.
    k.line(0.63, 0.43, 0.675, 0.395, 0.024, shade(outfit, -0.2));
    k.circ(0.725, 0.345, 0.075, const Color(0x1A1F3A5F), flat: true); // lens
    k.ring(0.725, 0.345, 0.075, 0.02, shade(outfit, -0.2));
    // A floating question mark: a curl, a stem, a dot.
    k.arc(0.84, 0.16, 0.045, math.pi * 0.9, math.pi * 1.35, 0.018, _ochre);
    k.line(0.855, 0.195, 0.85, 0.235, 0.018, _ochre);
    k.circ(0.848, 0.275, 0.014, _ochre, flat: true);
  }

  void _certificate(FlatPaintKit k) {
    const outfit = _forest;
    // The certificate held overhead: a sheet, two text lines, a ribbon seal.
    k.box(0.28, 0.10, 0.72, 0.33, 0.02, _offWhite);
    k.line(0.35, 0.17, 0.65, 0.17, 0.014, shade(_ink, 0.45));
    k.line(0.35, 0.225, 0.56, 0.225, 0.012, shade(_ink, 0.52));
    k.poly(const [
      Offset(0.615, 0.27), Offset(0.655, 0.27),
      Offset(0.665, 0.345), Offset(0.635, 0.315), Offset(0.605, 0.345),
    ], _terracotta, flat: true); // ribbon tails
    k.circ(0.635, 0.265, 0.032, _ochre); // seal
    _body(k, 0.50, 0.44, outfit);
    k.head(0.50, 0.335, 0.09,
        style: 'bun', skinTone: kSkinTones[1], hairColor: kHairColors[3]);
    k.line(0.45, 0.48, 0.36, 0.33, 0.042, outfit); // arms up to the sheet
    k.line(0.55, 0.48, 0.64, 0.33, 0.042, outfit);
    k.hand(0.355, 0.325, c: kSkinTones[1]);
    k.hand(0.645, 0.325, c: kSkinTones[1]);
  }

  void _study(FlatPaintKit k) {
    // The reader pose from the room cast: sitting knees-up over an open book.
    const outfit = _navy;
    k.box(0.27, 0.85, 0.73, 0.905, 0.028, shade(outfit, -0.16)); // cushion
    k.line(0.40, 0.835, 0.57, 0.835, 0.07, outfit); // thigh
    k.line(0.57, 0.835, 0.585, 0.70, 0.07, outfit); // shin (knee up)
    k.shoe(0.40, 0.845, -1, shade(outfit, -0.22)); // tucked foot
    k.box(0.41, 0.55, 0.59, 0.83, 0.085, outfit); // torso
    k.head(0.50, 0.45, 0.093,
        glasses: true,
        style: 'short',
        skinTone: kSkinTones[3],
        hairColor: kHairColors[2]);
    k.line(0.43, 0.60, 0.42, 0.69, 0.042, outfit); // arm
    k.line(0.57, 0.60, 0.58, 0.69, 0.042, outfit); // arm
    k.poly(const [
      Offset(0.36, 0.72), Offset(0.50, 0.665),
      Offset(0.50, 0.61), Offset(0.355, 0.655),
    ], _offWhite); // left page
    k.poly(const [
      Offset(0.64, 0.72), Offset(0.50, 0.665),
      Offset(0.50, 0.61), Offset(0.645, 0.655),
    ], _offWhite); // right page
    k.hand(0.40, 0.70, c: kSkinTones[3]); // hands hold the covers
    k.hand(0.60, 0.70, c: kSkinTones[3]);
  }

  void _flashcards(FlatPaintKit k) {
    const outfit = _ochre;
    // Two big flashcards, the front one showing a word-like line pair.
    k.box(0.22, 0.30, 0.48, 0.50, 0.03, const Color(0xFFF0E3C8)); // back card
    k.box(0.16, 0.24, 0.44, 0.45, 0.03, _offWhite); // front card
    k.circ(0.235, 0.315, 0.032, _terracotta); // the "picture"
    k.line(0.30, 0.31, 0.395, 0.31, 0.016, shade(_ink, 0.45)); // the "word"
    k.line(0.215, 0.395, 0.385, 0.395, 0.013, shade(_ink, 0.55));
    // The presenter, holding the cards out.
    _body(k, 0.62, 0.46, outfit);
    k.head(0.62, 0.35, 0.09,
        style: 'pony', skinTone: kSkinTones[2], hairColor: kHairColors[4]);
    k.line(0.56, 0.51, 0.465, 0.43, 0.042, outfit); // arm to the cards
    k.hand(0.46, 0.425, c: kSkinTones[2]);
    k.line(0.68, 0.51, 0.72, 0.62, 0.042, outfit); // relaxed arm
    k.hand(0.725, 0.63, c: kSkinTones[2]);
  }

  void _explore(FlatPaintKit k) {
    const outfit = _terracotta;
    // A soft hill, a planted flag, and a scout scanning the horizon.
    k.dome(0.55, 0.90, 0.42, const Color(0xFFE3EAD9));
    k.line(0.72, 0.22, 0.72, 0.87, 0.016, const Color(0xFF6E4A2B)); // pole
    k.poly(const [
      Offset(0.728, 0.22), Offset(0.90, 0.28), Offset(0.728, 0.35),
    ], _navy); // pennant
    _body(k, 0.42, 0.45, outfit);
    k.head(0.42, 0.34, 0.09,
        style: 'short', skinTone: kSkinTones[0], hairColor: kHairColors[1]);
    k.line(0.48, 0.50, 0.63, 0.46, 0.042, outfit); // hand on the pole
    k.hand(0.635, 0.455, c: kSkinTones[0]);
    k.line(0.37, 0.49, 0.345, 0.375, 0.042, outfit); // hand shading the eyes
    k.hand(0.35, 0.365, c: kSkinTones[0]);
  }

  void _celebrate(FlatPaintKit k) {
    const outfit = _terracotta;
    _body(k, 0.50, 0.43, outfit);
    k.head(0.50, 0.32, 0.095,
        style: 'curly', skinTone: kSkinTones[3], hairColor: kHairColors[0]);
    k.line(0.45, 0.47, 0.345, 0.30, 0.042, outfit); // arms up in a V
    k.line(0.55, 0.47, 0.655, 0.30, 0.042, outfit);
    k.hand(0.34, 0.29, c: kSkinTones[3]);
    k.hand(0.66, 0.29, c: kSkinTones[3]);
    // Confetti — dots and slips in the brand colors raining around the figure.
    const confetti = [_navy, _ochre, _forest, _terracotta];
    const spots = [
      Offset(0.18, 0.22), Offset(0.28, 0.10), Offset(0.44, 0.16),
      Offset(0.60, 0.09), Offset(0.76, 0.18), Offset(0.86, 0.32),
      Offset(0.14, 0.42), Offset(0.84, 0.52),
    ];
    for (final (i, o) in spots.indexed) {
      if (i.isEven) {
        k.circ(o.dx, o.dy, 0.016, confetti[i % confetti.length], flat: true);
      } else {
        k.box(o.dx - 0.014, o.dy - 0.02, o.dx + 0.014, o.dy + 0.02, 0.008,
            confetti[i % confetti.length], flat: true);
      }
    }
  }

  /// A speech bubble sized to its [text] (bold, navy on warm paper), with a
  /// little tail down to the speaker. The greeting is real text so the cast
  /// literally says hello in each course language.
  void _greetingBubble(FlatPaintKit k, double cx, double bottomY, double tailX,
      double tailY, String text) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        // 'Roboto' resolves on web/Android and falls back to the platform
        // face elsewhere; it also lets the dev preview register a real font
        // under this name (flutter_test otherwise draws Ahem boxes).
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 0.105 * k.u,
          fontWeight: FontWeight.w800,
          color: _navy,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final w = tp.width / k.u + 0.15;
    final h = tp.height / k.u + 0.08;
    final t = bottomY - h;
    k.poly([
      Offset(cx - 0.05, bottomY - 0.02),
      Offset(cx + 0.05, bottomY - 0.02),
      Offset(tailX, tailY),
    ], _bubble, flat: true);
    k.box(cx - w / 2, t, cx + w / 2, bottomY, 0.09, _bubble, flat: true);
    tp.paint(
      k.canvas,
      Offset(cx * k.u - tp.width / 2, (t + bottomY) / 2 * k.u - tp.height / 2),
    );
  }

  void _greeters(FlatPaintKit k) {
    // Four figures, four languages — outfits chosen to pop on the brand navy
    // (no navy outfit here) while still reading on light surfaces.
    _greetingBubble(k, 0.40, 0.30, 0.44, 0.40, 'Hallo!');
    _greetingBubble(k, 1.02, 0.22, 1.06, 0.32, '¡Hola!');
    _greetingBubble(k, 1.66, 0.30, 1.70, 0.40, '你好');
    _greetingBubble(k, 2.28, 0.22, 2.32, 0.32, 'Hi!');
    // 1 · Waving, terracotta.
    _body(k, 0.40, 0.49, _terracotta);
    k.head(0.40, 0.385, 0.088,
        style: 'short', skinTone: kSkinTones[1], hairColor: kHairColors[0]);
    k.line(0.34, 0.54, 0.31, 0.65, 0.042, _terracotta);
    k.hand(0.305, 0.66, c: kSkinTones[1]);
    k.line(0.46, 0.54, 0.55, 0.42, 0.042, _terracotta); // waving arm
    k.hand(0.555, 0.41, c: kSkinTones[1]);
    // 2 · Bun and glasses, forest.
    _body(k, 1.02, 0.49, _forest);
    k.head(1.02, 0.385, 0.088,
        glasses: true,
        style: 'bun',
        skinTone: kSkinTones[0],
        hairColor: kHairColors[3]);
    k.line(0.96, 0.54, 0.90, 0.46, 0.042, _forest); // raised open hand
    k.hand(0.895, 0.45, c: kSkinTones[0]);
    k.line(1.08, 0.54, 1.12, 0.65, 0.042, _forest);
    k.hand(1.125, 0.66, c: kSkinTones[0]);
    // 3 · Curly, ochre.
    _body(k, 1.66, 0.49, _ochre);
    k.head(1.66, 0.385, 0.088,
        style: 'curly', skinTone: kSkinTones[3], hairColor: kHairColors[2]);
    k.line(1.60, 0.54, 1.57, 0.65, 0.042, _ochre);
    k.hand(1.565, 0.66, c: kSkinTones[3]);
    k.line(1.72, 0.54, 1.81, 0.42, 0.042, _ochre); // waving arm
    k.hand(1.815, 0.41, c: kSkinTones[3]);
    // 4 · Long hair, light paper outfit.
    const paper = Color(0xFFE8E1D2);
    _body(k, 2.28, 0.49, paper);
    k.head(2.28, 0.385, 0.088,
        style: 'long', skinTone: kSkinTones[2], hairColor: kHairColors[1]);
    k.line(2.22, 0.54, 2.16, 0.46, 0.042, paper); // raised open hand
    k.hand(2.155, 0.45, c: kSkinTones[2]);
    k.line(2.34, 0.54, 2.38, 0.65, 0.042, paper);
    k.hand(2.385, 0.66, c: kSkinTones[2]);
  }

  @override
  bool shouldRepaint(_PersonScenePainter oldDelegate) =>
      oldDelegate.kind != kind;
}
