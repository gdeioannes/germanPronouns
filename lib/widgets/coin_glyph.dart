/// The shared gold-coin face used everywhere coins are drawn: the flying coin
/// sprites, the in-quiz coin holder, and the always-visible balance pill.
library;

import 'package:flutter/material.dart';

/// A single round gold coin: radial-gradient disc, raised rim and a star pip.
/// [withShadow] adds a soft glow (on for the flying sprites, off for the small
/// inline glyphs in chips/badges).
class CoinGlyph extends StatelessWidget {
  const CoinGlyph({super.key, required this.size, this.withShadow = true});

  final double size;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.4),
          radius: 0.95,
          colors: [Color(0xFFFFF1A8), Color(0xFFF6C543), Color(0xFFC8870F)],
          stops: [0.0, 0.55, 1.0],
        ),
        border: const Border.fromBorderSide(
          BorderSide(color: Color(0xFFB5750A), width: 1.3),
        ),
        boxShadow: withShadow
            ? const [
                BoxShadow(
                  color: Color(0x66E0A21A),
                  blurRadius: 8,
                  spreadRadius: 0.5,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.star_rounded,
        size: size * 0.5,
        color: const Color(0xFFFFF6CC),
      ),
    );
  }
}
