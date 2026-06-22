import 'package:flutter/material.dart';

/// The two overlapping circular flags that represent a course's
/// "speak X → learn Y" language pair.
///
/// This is the single, centralized way the app renders a course's flags:
/// every screen (course switcher, selector, home, intro) uses it, so a style
/// change here propagates everywhere.
class CourseFlagPair extends StatelessWidget {
  const CourseFlagPair({
    super.key,
    required this.speakFlag,
    required this.learnFlag,
    this.diameter = 22,
    this.ringColor,
  });

  /// Emoji flag of the language the learner speaks (drawn in front, on the left).
  final String speakFlag;

  /// Emoji flag of the language being learned (drawn behind, on the right).
  final String learnFlag;

  /// Diameter of each circular flag.
  final double diameter;

  /// Color of the ring around each flag; also fills the gap where they overlap.
  /// Defaults to the theme surface for a clean "sticker" edge on any background.
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final overlap = diameter * 0.30;
    final ring = ringColor ?? Theme.of(context).colorScheme.surface;

    return SizedBox(
      width: diameter * 2 - overlap,
      height: diameter,
      child: Stack(
        children: [
          // Learn flag: behind, on the right.
          Positioned(
            left: diameter - overlap,
            child: CountryFlag(emoji: learnFlag, size: diameter, ringColor: ring),
          ),
          // Speak flag: in front, on the left.
          CountryFlag(emoji: speakFlag, size: diameter, ringColor: ring),
        ],
      ),
    );
  }
}

/// A single minimal, flat, vector-drawn country flag clipped to a circle.
///
/// Takes the same emoji flag string the `Course` model stores (e.g. `🇩🇪`),
/// converts it to its ISO 3166 code and paints a clean flat flag. Unknown
/// codes fall back to rendering the original emoji so nothing ever disappears.
class CountryFlag extends StatelessWidget {
  const CountryFlag({
    super.key,
    required this.emoji,
    this.size = 20,
    this.ringColor,
    this.ringWidth = 1.5,
  });

  /// The emoji flag (two regional-indicator code points), e.g. `🇪🇸`.
  final String emoji;

  /// Diameter of the circle in logical pixels.
  final double size;

  /// Ring color drawn around the circle. Defaults to the theme surface.
  final Color? ringColor;

  /// Ring thickness; pass 0 to omit the ring.
  final double ringWidth;

  @override
  Widget build(BuildContext context) {
    final iso = _isoFromFlagEmoji(emoji);
    final ring = ringColor ?? Theme.of(context).colorScheme.surface;

    final Widget face;
    if (iso == null || !_known.contains(iso)) {
      // Fallback: show the original emoji centered.
      face = Center(child: Text(emoji, style: TextStyle(fontSize: size * 0.9)));
    } else {
      // Paint the 3:2 flag scaled to cover the circle, cropping the sides.
      face = FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 30,
          height: 20,
          child: CustomPaint(painter: _FlagPainter(iso)),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: ringWidth > 0 ? Border.all(color: ring, width: ringWidth) : null,
      ),
      child: ClipOval(child: face),
    );
  }
}

const Set<String> _known = {'DE', 'ES', 'GB'};

/// Converts a flag emoji (two regional-indicator symbols) into its ISO code,
/// e.g. `🇩🇪` → `DE`. Returns null if the string isn't a flag emoji.
String? _isoFromFlagEmoji(String flag) {
  final runes = flag.runes.toList();
  if (runes.length < 2) return null;
  const base = 0x1F1E6; // Regional Indicator Symbol Letter A.
  final a = runes[0] - base;
  final b = runes[1] - base;
  if (a < 0 || a > 25 || b < 0 || b > 25) return null;
  return '${String.fromCharCode(0x41 + a)}${String.fromCharCode(0x41 + b)}';
}

class _FlagPainter extends CustomPainter {
  const _FlagPainter(this.iso);

  final String iso;

  @override
  void paint(Canvas canvas, Size size) {
    switch (iso) {
      case 'DE':
        _paintGermany(canvas, size);
      case 'ES':
        _paintSpain(canvas, size);
      case 'GB':
        _paintUnitedKingdom(canvas, size);
    }
  }

  void _paintGermany(Canvas canvas, Size size) {
    final band = size.height / 3;
    final w = size.width;
    canvas
      ..drawRect(Rect.fromLTWH(0, 0, w, band), Paint()..color = const Color(0xFF000000))
      ..drawRect(Rect.fromLTWH(0, band, w, band), Paint()..color = const Color(0xFFDD0000))
      ..drawRect(Rect.fromLTWH(0, band * 2, w, band), Paint()..color = const Color(0xFFFFCE00));
  }

  void _paintSpain(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas
      ..drawRect(Offset.zero & size, Paint()..color = const Color(0xFFAA151B))
      ..drawRect(
        Rect.fromLTWH(0, h * 0.25, w, h * 0.5),
        Paint()..color = const Color(0xFFF1BF00),
      );
  }

  void _paintUnitedKingdom(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    const white = Color(0xFFFFFFFF);
    const red = Color(0xFFC8102E);

    // Blue field.
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF012169));

    // Diagonal saltires: white under, red over.
    final whiteDiag = Paint()
      ..color = white
      ..strokeWidth = h * 0.30
      ..style = PaintingStyle.stroke;
    final redDiag = Paint()
      ..color = red
      ..strokeWidth = h * 0.12
      ..style = PaintingStyle.stroke;
    for (final paint in [whiteDiag, redDiag]) {
      canvas
        ..drawLine(Offset.zero, Offset(w, h), paint)
        ..drawLine(Offset(w, 0), Offset(0, h), paint);
    }

    // Straight cross of St George: white border, then red on top.
    final whiteCross = Paint()..color = white;
    canvas
      ..drawRect(Rect.fromCenter(center: center, width: h * 0.40, height: h), whiteCross)
      ..drawRect(Rect.fromCenter(center: center, width: w, height: h * 0.40), whiteCross);
    final redCross = Paint()..color = red;
    canvas
      ..drawRect(Rect.fromCenter(center: center, width: h * 0.22, height: h), redCross)
      ..drawRect(Rect.fromCenter(center: center, width: w, height: h * 0.22), redCross);
  }

  @override
  bool shouldRepaint(_FlagPainter oldDelegate) => oldDelegate.iso != iso;
}
