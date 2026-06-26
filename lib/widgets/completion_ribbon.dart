/// The "completed" mark shared by the course home cards and the navigation
/// drawer: a small flat bookmark ribbon whose color marks the streak tier.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The medal tier a finished quiz's ribbon shows, by streak laps.
enum RibbonTier { bronze, silver, gold }

/// Ribbon tier by streak laps: bronze from the first lap, silver at 3 laps,
/// gold at 5+. Single source of the tier boundaries — both [tierColorForLaps]
/// and the coin reward (`CoinWallet.coinsForLaps`) read it.
RibbonTier ribbonTierForLaps(int laps) {
  if (laps >= 5) return RibbonTier.gold;
  if (laps >= 3) return RibbonTier.silver;
  return RibbonTier.bronze;
}

/// Tier color for a finished quiz, by streak laps: bronze from the first lap,
/// silver at 3 laps, gold at 5+.
Color tierColorForLaps(int laps) {
  switch (ribbonTierForLaps(laps)) {
    case RibbonTier.gold:
      return const Color(0xFFD7A93A); // gold
    case RibbonTier.silver:
      return const Color(0xFFAAB2BE); // silver
    case RibbonTier.bronze:
      return const Color(0xFFC07F49); // bronze
  }
}

/// A simple flat bookmark ribbon: a plain [color] fill with a swallowtail
/// bottom and one small white star — no gradients or sheen. Used as the
/// "completed" mark on a finished quiz.
class BookmarkRibbon extends StatelessWidget {
  const BookmarkRibbon({super.key, required this.color, this.width = 22});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    // IgnorePointer so the ribbon never steals taps from the row/card beneath.
    return IgnorePointer(
      child: CustomPaint(
        size: Size(width, width * 1.82),
        painter: _BookmarkPainter(color),
      ),
    );
  }
}

class _BookmarkPainter extends CustomPainter {
  _BookmarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final notch = h * 0.20;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(w / 2, h - notch)
      ..lineTo(0, h)
      ..close();

    // One soft shadow so the ribbon lifts off the surface; otherwise flat.
    canvas.drawShadow(path, const Color(0x66000000), 2, false);
    canvas.drawPath(path, Paint()..color = color);

    // A small white star near the top.
    canvas.drawPath(
      _starPath(Offset(w / 2, h * 0.32), w * 0.24, w * 0.11, 5),
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_BookmarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A five-pointed star path centered on [c].
Path _starPath(Offset c, double outer, double inner, int points) {
  final path = Path();
  for (var i = 0; i < points * 2; i++) {
    final r = i.isEven ? outer : inner;
    final a = -math.pi / 2 + i * math.pi / points;
    final p = Offset(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r);
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  return path..close();
}
