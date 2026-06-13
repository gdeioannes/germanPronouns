import 'dart:math';

import 'package:flutter/material.dart';

/// A single confetti-like particle used by [FireworksPainter].
class FireworkParticle {
  const FireworkParticle({
    required this.origin,
    required this.direction,
    required this.speed,
    required this.size,
    required this.color,
  });

  final Offset origin;
  final Offset direction;
  final double speed;
  final double size;
  final Color color;
}

/// Paints an expanding, fading burst of [FireworkParticle]s as [progress]
/// goes from 0 to 1.
class FireworksPainter extends CustomPainter {
  const FireworksPainter({required this.progress, required this.particles});

  final double progress;
  final List<FireworkParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;

    final eased = Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));
    final fade = (1 - progress).clamp(0.0, 1.0);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final start = Offset(
        particle.origin.dx * size.width,
        particle.origin.dy * size.height,
      );
      final position = start + (particle.direction * particle.speed * eased);

      // solid rotated square particle (confetti-like)
      paint.color = particle.color.withValues(alpha: 0.95 * fade);
      final side = particle.size * 1.9;
      final rotation =
          atan2(particle.direction.dy, particle.direction.dx) + progress * 8.0;
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: side, height: side),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant FireworksPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.particles != particles;
  }
}
