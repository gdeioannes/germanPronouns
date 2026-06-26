/// The "coins fly to the wallet" animation: a short burst of spinning gold
/// coins that arc from a source point up into the coin-holder badge.
///
/// Driven through an [OverlayEntry] so the coins float above the whole quiz
/// (cards, fireworks, everything) and need no layout space of their own. The
/// quiz calls [playCoinFlight] right after it credits the wallet; the flight is
/// pure eye-candy, so if anything is missing it simply does nothing.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'coin_glyph.dart';

/// Flies [count] coins from [from] (global coordinates) to the centre of the
/// widget identified by [targetKey] — the coin-holder badge. No-op when there
/// is no overlay, nothing to show, or the target isn't laid out yet.
void playCoinFlight(
  BuildContext context, {
  required Offset from,
  required GlobalKey targetKey,
  required int count,
}) {
  if (count <= 0) return;
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  final targetBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
  if (targetBox == null || !targetBox.hasSize) return;
  final to = targetBox.localToGlobal(targetBox.size.center(Offset.zero));

  // Cap the number of sprites so a big reward still reads as a tidy burst.
  final sprites = count.clamp(1, 12);

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _CoinFlightLayer(
      from: from,
      to: to,
      count: sprites,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

/// The full-screen layer that animates one burst of coins, then calls [onDone]
/// so the owning [OverlayEntry] can remove itself.
class _CoinFlightLayer extends StatefulWidget {
  const _CoinFlightLayer({
    required this.from,
    required this.to,
    required this.count,
    required this.onDone,
  });

  final Offset from;
  final Offset to;
  final int count;
  final VoidCallback onDone;

  @override
  State<_CoinFlightLayer> createState() => _CoinFlightLayerState();
}

class _CoinFlightLayerState extends State<_CoinFlightLayer>
    with SingleTickerProviderStateMixin {
  static const _flightMs = 620; // how long a single coin is in the air
  static const _staggerMs = 90; // gap between successive coins launching

  late final AnimationController _controller;
  late final List<_Coin> _coins;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    final totalMs = _flightMs + _staggerMs * (widget.count - 1);
    _controller =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: totalMs),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) widget.onDone();
        });

    // Each coin gets its own launch jitter, arc bulge and spin phase so the
    // burst looks scattered rather than a single coin cloned N times.
    _coins = List.generate(widget.count, (i) {
      final startFraction = (_staggerMs * i) / totalMs;
      final span = _flightMs / totalMs;
      final launch = widget.from +
          Offset(
            (_random.nextDouble() - 0.5) * 36,
            (_random.nextDouble() - 0.5) * 24,
          );
      // Lift the bezier control point above the straight line so coins arc up.
      final mid = Offset.lerp(launch, widget.to, 0.5)!;
      final control = mid +
          Offset(
            (_random.nextDouble() - 0.5) * 80,
            -60 - _random.nextDouble() * 70,
          );
      return _Coin(
        start: startFraction.clamp(0.0, 0.999),
        end: (startFraction + span).clamp(0.0, 1.0),
        launch: launch,
        control: control,
        size: 22 + _random.nextDouble() * 8,
        spinTurns: 2 + _random.nextInt(2),
        spinPhase: _random.nextDouble() * math.pi,
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            children: [
              for (final coin in _coins) _buildCoin(coin, t),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoin(_Coin coin, double t) {
    // This coin's own 0..1 progress within its slice of the timeline.
    final local = ((t - coin.start) / (coin.end - coin.start)).clamp(0.0, 1.0);
    if (t < coin.start) return const SizedBox.shrink();

    final eased = Curves.easeInCubic.transform(local);
    final pos = _bezier(coin.launch, coin.control, widget.to, eased);

    // Pop in at launch, then shrink and fade as it merges into the holder.
    final scale = local < 0.2
        ? Curves.easeOutBack.transform(local / 0.2)
        : 1.0 - 0.45 * (((local - 0.2) / 0.8).clamp(0.0, 1.0));
    final opacity = local < 0.1
        ? local / 0.1
        : (local > 0.85 ? (1 - (local - 0.85) / 0.15) : 1.0);

    final spin = coin.spinPhase + local * coin.spinTurns * 2 * math.pi;

    return Positioned(
      left: pos.dx - coin.size / 2,
      top: pos.dy - coin.size / 2,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015) // a touch of perspective for the flip
            ..scaleByDouble(scale, scale, 1, 1)
            ..rotateY(spin),
          child: CoinGlyph(size: coin.size),
        ),
      ),
    );
  }
}

/// Quadratic bezier point at [t] for control points [p0]→[p1]→[p2].
Offset _bezier(Offset p0, Offset p1, Offset p2, double t) {
  final u = 1 - t;
  return p0 * (u * u) + p1 * (2 * u * t) + p2 * (t * t);
}

/// Per-coin flight parameters, fixed when the burst is built.
class _Coin {
  const _Coin({
    required this.start,
    required this.end,
    required this.launch,
    required this.control,
    required this.size,
    required this.spinTurns,
    required this.spinPhase,
  });

  final double start;
  final double end;
  final Offset launch;
  final Offset control;
  final double size;
  final int spinTurns;
  final double spinPhase;
}
