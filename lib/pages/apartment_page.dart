import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data/furniture_names.dart';
import '../data/shop_catalog.dart';
import '../models/apartment.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../utils/room_image_export.dart';
import '../widgets/coin_balance_pill.dart';
import '../widgets/coin_glyph.dart';
import '../widgets/flat_furniture.dart';

/// The room mini-game: spend the coins earned in quizzes on flat-design
/// furniture, then drag the pieces around to furnish and decorate a cosy little
/// room. The shop reveals more pieces as the learner gets richer (see
/// [Apartment.refreshReveals]), and the room can be exported as an image to
/// save or copy elsewhere.
///
/// Deliberately warm and calm — a cosy reward for the learning the rest of the
/// app is about.
class ApartmentPage extends StatefulWidget {
  const ApartmentPage({super.key});

  @override
  State<ApartmentPage> createState() => _ApartmentPageState();
}

// Warm, cosy palette shared across the page.
const _cream = Color(0xFFF4E9D8);
const _creamDeep = Color(0xFFE7D3B6);
const _cocoa = Color(0xFF6F5544);
const _cardText = Color(0xFF4A3728);

class _ApartmentPageState extends State<ApartmentPage> {
  // Keys the room's RepaintBoundary so we can grab a picture of just the room.
  final GlobalKey _roomKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🛋️ My Room',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        // No back arrow — the room is a docked panel, not a pushed route.
        automaticallyImplyLeading: false,
        // Solid cocoa (with a gradient overlay that reliably fills) so the white
        // title and action icons are always visible.
        backgroundColor: const Color(0xFF6F5544),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C5E48), Color(0xFF6F5544)],
            ),
          ),
        ),
        elevation: 0,
        actions: [
          // Day / night toggle, so the lighting effect is easy to see.
          ListenableBuilder(
            listenable: Apartment.instance,
            builder: (context, _) {
              final night = Apartment.instance.isNight;
              return IconButton(
                tooltip: night ? 'Switch to day' : 'Switch to night',
                icon: Icon(
                  night ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Apartment.instance.setNight(!night),
              );
            },
          ),
          // The donation spot: opens the Giving Corner to give furniture away.
          IconButton(
            tooltip: 'Give away furniture',
            icon: const Icon(Icons.volunteer_activism_rounded,
                color: Colors.white),
            onPressed: _openGivingCorner,
          ),
          IconButton(
            tooltip: 'Save or copy a picture of your room',
            icon: const Icon(Icons.ios_share_rounded, color: Colors.white),
            onPressed: _exportRoom,
          ),
          const CoinBalancePill(),
          const SizedBox(width: 6),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_cream, _creamDeep],
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListenableBuilder(
            listenable: Listenable.merge([
              Apartment.instance,
              CoinWallet.instance,
            ]),
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, c) {
                  final roomH = (c.maxHeight * 0.52).clamp(220.0, 560.0);
                  final roomW = math.min(c.maxWidth - 24, roomH * 0.82);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                        child: Center(
                          child: SizedBox(
                            width: roomW,
                            height: roomH,
                            child: _RoomCanvas(repaintKey: _roomKey),
                          ),
                        ),
                      ),
                      const Expanded(child: _Shop()),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Giving corner (donation) ───────────────────────────────────────────────

  void _openGivingCorner() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _DonationSheet(),
    );
  }

  // ── Image export ──────────────────────────────────────────────────────────

  Future<void> _exportRoom() async {
    final png = await _captureRoom();
    if (!mounted) return;
    if (png == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text("Couldn't take a picture of the room.")),
        );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ExportSheet(png: png),
    );
  }

  /// Renders the room's RepaintBoundary to PNG bytes, or null if it isn't laid
  /// out yet.
  Future<Uint8List?> _captureRoom() async {
    final boundary =
        _roomKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data?.buffer.asUint8List();
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Room
// ─────────────────────────────────────────────────────────────────────────

/// The room: a cosy flat interior (wall, wood floor, window) where owned
/// furniture can be freely dragged around (pieces may overlap — there's no
/// collision). Wrapped in a [RepaintBoundary] so the page can snapshot it.
class _RoomCanvas extends StatefulWidget {
  const _RoomCanvas({required this.repaintKey});

  final GlobalKey repaintKey;

  @override
  State<_RoomCanvas> createState() => _RoomCanvasState();
}

class _RoomCanvasState extends State<_RoomCanvas> {
  // The piece currently held (brightened + drawn on top), and its live pixel
  // centre while it's being dragged.
  String? _dragId;
  Offset? _dragCenter;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.repaintKey,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFBF6EC), width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final size = Size(c.maxWidth, c.maxHeight);
            // The reference size for a scale-1.0 piece; each piece scales off it.
            final baseTile = (size.shortestSide * 0.2).clamp(40.0, 88.0);
            // Each placed piece is (instanceId, catalogue item); a learner can
            // own several of the same item, each arranged on its own.
            final pieces = [
              for (final e in Apartment.instance.pieces.entries)
                if (shopItemById(e.value) case final item?) (e.key, item),
            ];
            // Draw the held piece last so it floats above the others.
            final ordered = [
              for (final p in pieces) if (p.$1 != _dragId) p,
              for (final p in pieces) if (p.$1 == _dragId) p,
            ];
            // Light cast by any owned light pieces, at their live spots —
            // lamps throw a downward cone, others a soft directional pool.
            final night = Apartment.instance.isNight;
            final lights = <_LightSpec>[
              for (final p in pieces)
                if (_lightFx[p.$2.glyph] case final fx?)
                  _lightSpec(p.$1, p.$2, fx, size, baseTile),
            ];
            return Stack(
              children: [
                const Positioned.fill(child: _CosyRoom()),
                for (final p in ordered) _draggable(p.$1, p.$2, size, baseTile),
                if (night || lights.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _RoomLightingPainter(night: night, lights: lights),
                      ),
                    ),
                  ),
                if (pieces.isEmpty)
                  const _EmptyRoom()
                else
                  const Positioned(left: 12, top: 10, child: _DragHint()),
              ],
            );
          },
        ),
      ),
    );
  }

  Offset _centerPx(String iid, ShopItem item, Size size) {
    if (iid == _dragId && _dragCenter != null) return _dragCenter!;
    final n = Apartment.instance.positionOf(iid, item.id);
    return Offset(n.dx * size.width, n.dy * size.height);
  }

  double _sizeOf(ShopItem item, double baseTile, Size size) =>
      (baseTile * item.scale).clamp(26.0, size.shortestSide * 0.95);

  /// Resolves a light's pixel geometry: a downward cone for beam lights (apex at
  /// the shade), or a soft elliptical pool for the rest.
  _LightSpec _lightSpec(
      String iid, ShopItem item, _LightFx fx, Size size, double baseTile) {
    final s = _sizeOf(item, baseTile, size);
    final c = _centerPx(iid, item, size);
    if (fx.beam) {
      return _LightSpec(
        beam: true,
        at: c + Offset(0, fx.apexDy * s),
        color: fx.color,
        intensity: fx.intensity,
        glow: fx.glow,
        focal: Alignment.center,
        a: s * fx.apexHalf,
        b: s * fx.spread,
        len: s * fx.length,
        soft: s * fx.soft,
        cut: double.infinity,
      );
    }
    return _LightSpec(
      beam: false,
      at: c + Offset(0, fx.dy * s),
      color: fx.color,
      intensity: fx.intensity,
      glow: fx.glow,
      focal: fx.focal,
      a: s * fx.w,
      b: s * fx.h,
      len: 0,
      soft: 0,
      cut: fx.cutBase.isFinite ? c.dy + fx.cutBase * s : double.infinity,
    );
  }

  Widget _draggable(String iid, ShopItem item, Size size, double baseTile) {
    final itemSize = _sizeOf(item, baseTile, size);
    final half = itemSize / 2;
    final isDragging = _dragId == iid;
    final center = _centerPx(iid, item, size);
    final left = (center.dx - half).clamp(0.0, size.width - itemSize);
    final top = (center.dy - half).clamp(0.0, size.height - itemSize);

    return Positioned(
      // Keyed by instance so reordering (held piece drawn last) keeps each
      // gesture on its own piece.
      key: ValueKey(iid),
      left: left,
      top: top,
      child: GestureDetector(
        // Brighten as soon as the piece is touched, before any movement.
        onPanDown: (_) => setState(() {
          _dragId = iid;
          _dragCenter = center;
        }),
        onPanUpdate: (d) {
          final cur = _dragCenter ?? center;
          final c = cur + d.delta;
          setState(() {
            _dragCenter = Offset(
              c.dx.clamp(half, size.width - half),
              c.dy.clamp(half, size.height - half),
            );
          });
        },
        onPanEnd: (_) {
          final c = _dragCenter;
          if (c != null) {
            Apartment.instance.setPosition(
              iid,
              Offset(c.dx / size.width, c.dy / size.height),
            );
          }
          setState(() {
            _dragId = null;
            _dragCenter = null;
          });
        },
        onPanCancel: () => setState(() {
          _dragId = null;
          _dragCenter = null;
        }),
        // Double-tap a piece for its name (and to flip it).
        onDoubleTap: () => _showInfoCard(context, iid, item),
        child: _FurnitureToken(
          item: item,
          size: itemSize,
          highlighted: isDragging,
          flipped: Apartment.instance.isFlipped(iid),
        ),
      ),
    );
  }
}

/// An owned piece in the room: its flat drawing at its own [size], with a soft
/// grounding shadow under floor pieces. Pops in when it's just bought and, while
/// [highlighted] (held), brightens a little — without changing size.
class _FurnitureToken extends StatelessWidget {
  const _FurnitureToken({
    required this.item,
    required this.size,
    this.highlighted = false,
    this.flipped = false,
  });

  final ShopItem item;
  final double size;
  final bool highlighted;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    Widget furniture = FlatFurniture(item: item, size: size);
    if (highlighted) {
      // Tint the drawn pixels toward white so the held piece looks a touch
      // brighter, following its shape (transparent areas stay clear).
      furniture = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color(0x4DFFFFFF),
          BlendMode.srcATop,
        ),
        child: furniture,
      );
    }
    if (flipped) {
      furniture = Transform.scale(scaleX: -1, child: furniture);
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey(item.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Transform.scale(scale: t, child: child),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            if (item.castsShadow)
              Positioned(
                left: 0,
                right: 0,
                bottom: size * 0.07,
                child: Center(
                  child: Container(
                    width: size * 0.66,
                    height: size * 0.10,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.14),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(size * 0.33, size * 0.05)),
                    ),
                  ),
                ),
              ),
            furniture,
          ],
        ),
      ),
    );
  }
}

/// The cosy flat backdrop: a warm wall with a sunny window, a wood floor and a
/// skirting board. Painted, not furniture, so it's part of every snapshot.
class _CosyRoom extends StatelessWidget {
  const _CosyRoom();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CosyRoomPainter(), size: Size.infinite);
  }
}

class _CosyRoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final floorY = h * 0.66;
    final p = Paint()..isAntiAlias = true;

    // Wall — a soft warm cream, slightly deeper toward the floor.
    final wallRect = Rect.fromLTWH(0, 0, w, floorY);
    p.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFBF3E6), Color(0xFFF1E3CC)],
    ).createShader(wallRect);
    canvas.drawRect(wallRect, p);
    p.shader = null;

    // The wall is left bare on purpose — windows (and other décor) are bought
    // in the shop and hung here.

    // Floor — warm wood, a touch lighter at the back.
    final floorRect = Rect.fromLTWH(0, floorY, w, h - floorY);
    p.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFD9B98C), Color(0xFFC59C66)],
    ).createShader(floorRect);
    canvas.drawRect(floorRect, p);
    p.shader = null;

    // Floorboard seams.
    p
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, h * 0.004)
      ..color = const Color(0x1A4A3728);
    for (final f in const [0.30, 0.58, 0.86]) {
      final y = floorY + (h - floorY) * f;
      canvas.drawLine(Offset(0, y), Offset(w, y), p);
    }

    // Skirting board between wall and floor.
    p.style = PaintingStyle.fill;
    final skH = h * 0.024;
    p.color = const Color(0xFFFBF6EC);
    canvas.drawRect(Rect.fromLTWH(0, floorY - skH, w, skH), p);
    p
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, h * 0.003)
      ..color = const Color(0x22000000);
    canvas.drawLine(Offset(0, floorY), Offset(w, floorY), p);
    p.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(_CosyRoomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────
// Lighting
// ─────────────────────────────────────────────────────────────────────────

/// How a light-emitting piece glows. It lifts the night darkness by [intensity]
/// (0..1) and adds a [glow] bloom (0..1) in its [color].
///
/// A [beam] light (a lamp) throws a soft downward cone from its shade: starting
/// [apexDy] × size below the piece centre, [apexHalf] wide at the shade and
/// [spread] wide [length] down (all × the piece's drawn size). A non-beam light
/// (candle, fire, screen) is a soft ellipse [w]×[h] × size, offset by [dy] and
/// biased toward [focal] — so it still has a direction.
class _LightFx {
  const _LightFx({
    required this.color,
    required this.intensity,
    required this.glow,
    this.w = 1,
    this.h = 1,
    this.dy = 0,
    this.focal = Alignment.center,
    this.beam = false,
    this.length = 2.4,
    this.spread = 1,
    this.apexHalf = 0.16,
    this.apexDy = 0,
    this.soft = 0.06,
    this.cutBase = double.infinity,
  });
  final Color color;
  final double intensity;
  final double glow;
  final double w;
  final double h;
  final double dy;
  final Alignment focal;
  final bool beam;
  final double length;
  final double spread;
  final double apexHalf;
  final double apexDy;

  /// Cone edge softness as a fraction of the piece size — small keeps the cone's
  /// polygon edges sharp; 0 makes them razor crisp.
  final double soft;

  /// For pool lights, the surface to clip the glow at, as a fraction of the
  /// piece size below its centre — so a candle's light is cut flat at its base
  /// instead of spilling below it. Infinity means no cut.
  final double cutBase;
}

/// Which pieces give off light, keyed by [ShopItem.glyph]. Lamps cast a downward
/// cone; a candle is a tiny glow, a fire a wide upward wash, screens a cool
/// spill.
const Map<String, _LightFx> _lightFx = {
  'pendant': _LightFx(
      color: Color(0xFFFFE0A0), intensity: 0.55, glow: 0.26, beam: true,
      length: 1.7, spread: 0.85, apexHalf: 0.16, apexDy: 0.05, soft: 0.04),
  'lamp': _LightFx(
      color: Color(0xFFFFD98A), intensity: 0.55, glow: 0.26, beam: true,
      length: 1.6, spread: 0.8, apexHalf: 0.16, apexDy: -0.12, soft: 0.04),
  'lantern': _LightFx(
      color: Color(0xFFFFD98A), intensity: 0.5, glow: 0.26,
      w: 1.0, h: 1.25, dy: 0, focal: Alignment(0, -0.05), cutBase: 0.34),
  'candle': _LightFx(
      color: Color(0xFFFFC97A), intensity: 0.4, glow: 0.24,
      w: 0.7, h: 0.95, dy: 0, focal: Alignment(0, -0.1), cutBase: 0.4),
  'fireplace': _LightFx(
      color: Color(0xFFFF9A52), intensity: 0.65, glow: 0.34,
      w: 1.8, h: 1.4, dy: -0.2, focal: Alignment(0, 0.4)),
  'tv': _LightFx(
      color: Color(0xFF9AD0FF), intensity: 0.4, glow: 0.2,
      w: 1.4, h: 1.1, dy: 0.1),
  'arcade': _LightFx(
      color: Color(0xFF9AD0FF), intensity: 0.4, glow: 0.2,
      w: 1.1, h: 1.2, focal: Alignment(0, -0.3)),
  'aquarium': _LightFx(
      color: Color(0xFF7FE0FF), intensity: 0.4, glow: 0.18,
      w: 1.3, h: 1.0),
};

/// A resolved light to paint, in pixels. For a [beam], [at] is the cone apex,
/// [a] the apex half-width, [b] the base half-width and [len] the cone length.
/// Otherwise [at] is the pool centre, [a]/[b] its half-extents and [focal] its
/// bright spot.
class _LightSpec {
  const _LightSpec({
    required this.beam,
    required this.at,
    required this.a,
    required this.b,
    required this.len,
    required this.soft,
    required this.cut,
    required this.focal,
    required this.color,
    required this.intensity,
    required this.glow,
  });
  final bool beam;
  final Offset at;
  final double a;
  final double b;
  final double len;
  final double soft;

  /// Pixel y at which a pool light's glow is clipped flat (its base), or
  /// infinity for no cut.
  final double cut;
  final Alignment focal;
  final Color color;
  final double intensity;
  final double glow;
}

/// Paints the room's lighting on top of the furniture: at night a dark scrim
/// that each light lifts in its own shape (a soft cone for lamps so the light
/// comes out of the shade, an ellipse otherwise), plus a gentle warm/cool bloom
/// — strong at night, subtle by day — so the effect is visible either way.
class _RoomLightingPainter extends CustomPainter {
  _RoomLightingPainter({required this.night, required this.lights});

  final bool night;
  final List<_LightSpec> lights;

  /// Draws one light, either as a "hole" that lifts the night scrim ([hole]) or
  /// as a colour bloom, scaling its alpha by [mul].
  void _paintLight(Canvas canvas, _LightSpec l,
      {required bool hole, required double mul}) {
    final color = hole ? Colors.white : l.color;
    final alpha = (hole ? l.intensity : l.glow) * mul;
    final paint = Paint()
      ..blendMode = hole ? BlendMode.dstOut : BlendMode.plus;

    if (l.beam) {
      // A trapezoid cone from the shade, softened so it reads as a light beam.
      final apex = l.at;
      final rect = Rect.fromLTRB(
          apex.dx - l.b, apex.dy, apex.dx + l.b, apex.dy + l.len);
      final cone = Path()
        ..moveTo(apex.dx - l.a, apex.dy)
        ..lineTo(apex.dx + l.a, apex.dy)
        ..lineTo(apex.dx + l.b, apex.dy + l.len)
        ..lineTo(apex.dx - l.b, apex.dy + l.len)
        ..close();
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: alpha * 0.4),
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);
      // Keep the cone's polygon edges crisp; only a hair of feather for AA.
      if (l.soft > 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, l.soft);
      }
      canvas.drawPath(cone, paint);
    } else {
      final pool = Rect.fromCenter(
          center: l.at, width: l.a * 2, height: l.b * 2);
      paint.shader = RadialGradient(
        center: l.focal,
        radius: 0.9,
        colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
        stops: const [0.0, 1.0],
      ).createShader(pool);
      // Cut the glow flat at the base (e.g. the surface a candle sits on).
      final clip = l.cut.isFinite;
      if (clip) {
        canvas.save();
        canvas.clipRect(Rect.fromLTRB(pool.left, pool.top, pool.right, l.cut));
      }
      canvas.drawOval(pool, paint);
      if (clip) canvas.restore();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final scrimAlpha = night ? 0.5 : 0.0;
    final bloom = night ? 1.0 : 0.3;

    if (scrimAlpha > 0) {
      canvas.saveLayer(rect, Paint());
      canvas.drawRect(
        rect,
        Paint()..color = const Color(0xFF0A1633).withValues(alpha: scrimAlpha),
      );
      for (final l in lights) {
        _paintLight(canvas, l, hole: true, mul: 1.0);
      }
      canvas.restore();
    }

    for (final l in lights) {
      _paintLight(canvas, l, hole: false, mul: bloom);
    }
  }

  @override
  bool shouldRepaint(_RoomLightingPainter oldDelegate) => true;
}

class _DragHint extends StatelessWidget {
  const _DragHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.open_with_rounded,
            size: 13, color: _cocoa.withValues(alpha: 0.55)),
        const SizedBox(width: 4),
        Text(
          'Drag to rearrange',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _cocoa.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _EmptyRoom extends StatelessWidget {
  const _EmptyRoom();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          '🛋️\nBuy furniture below\nto fill your cosy room!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _cocoa.withValues(alpha: 0.8),
            fontWeight: FontWeight.w800,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Shop
// ─────────────────────────────────────────────────────────────────────────

/// The shop: every revealed furniture item, split into category tabs with an
/// "All" tab in front. Items stay buyable after you own them, so you can buy
/// several of the same. Tapping a card opens the buy confirmation.
class _Shop extends StatelessWidget {
  const _Shop();

  @override
  Widget build(BuildContext context) {
    final forSale = [
      for (final item in shopCatalog)
        if (Apartment.instance.isRevealed(item.id)) item,
    ];

    return DefaultTabController(
      length: shopCategories.length + 1, // "All" + one tab per category
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ShopHeader(),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: _cocoa,
            unselectedLabelColor: _cocoa.withValues(alpha: 0.45),
            indicatorColor: _cocoa,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: [
              const Tab(text: 'All'),
              for (final c in shopCategories) Tab(text: c),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // The All tab (null items → resolves to the full live list).
                const _ShopGrid(
                  items: null,
                  emptyHint: '🪙\nEarn coins in quizzes to\n'
                      'unlock your first furniture!',
                ),
                for (final c in shopCategories)
                  _ShopGrid(
                    items: [for (final i in forSale) if (i.category == c) i],
                    emptyHint: 'Nothing here yet —\nkeep earning coins!',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One tab's grid of shop cards, or a centred hint when it's empty.
class _ShopGrid extends StatelessWidget {
  const _ShopGrid({required this.items, required this.emptyHint});

  /// The cards to show. Null means "everything for sale" (the All tab), resolved
  /// here so the All grid always reflects the live catalogue.
  final List<ShopItem>? items;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    final list = items ??
        [
          for (final item in shopCatalog)
            if (Apartment.instance.isRevealed(item.id)) item,
        ];
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _cocoa.withValues(alpha: 0.8),
              fontWeight: FontWeight.w800,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 132,
        mainAxisExtent: 150,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) => _ShopCard(item: list[i]),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader();

  @override
  Widget build(BuildContext context) {
    final placed = Apartment.instance.pieceCount;
    // Next unlock: the cheapest piece not yet revealed, and the coins needed.
    int? nextCoins;
    for (final item in shopCatalog) {
      if (!Apartment.instance.isRevealed(item.id)) {
        nextCoins = (item.price / Apartment.revealFraction).ceil();
        break;
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          const Text(
            '🛒 Furniture Shop',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: _cocoa,
            ),
          ),
          const Spacer(),
          if (nextCoins != null)
            _Chip(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('next at ',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const CoinGlyph(size: 14, withShadow: false),
                  const SizedBox(width: 3),
                  Text('$nextCoins',
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
            )
          else
            _Chip(
              child: Text(
                  placed == 1 ? '1 piece placed' : '$placed pieces placed',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x33000000)),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: _cardText, fontSize: 12),
        child: child,
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.item});
  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    final canAfford = CoinWallet.instance.balance >= item.price;
    return GestureDetector(
      onTap: () => _showBuyDialog(context, item),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatFurniture(item: item, size: 58),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: _cardText,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: canAfford
                    ? const Color(0xFFFFE08A)
                    : const Color(0xFFE6E0EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CoinGlyph(size: 14, withShadow: false),
                  const SizedBox(width: 4),
                  Text(
                    '${item.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF5A3D00),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Buy confirmation
// ─────────────────────────────────────────────────────────────────────────

void _showBuyDialog(BuildContext context, ShopItem item) {
  showDialog<void>(
    context: context,
    builder: (_) => _BuyDialog(item: item),
  );
}

class _BuyDialog extends StatelessWidget {
  const _BuyDialog({required this.item});
  final ShopItem item;

  Future<void> _buy(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await CoinWallet.instance.spend(item.price);
    if (ok) await Apartment.instance.grant(item.id);
    navigator.pop();
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(ok
              ? 'Added the ${item.name.toLowerCase()} to your room!'
              : 'Not enough coins.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final canAfford = CoinWallet.instance.balance >= item.price;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: _cream,
          border: Border.all(color: const Color(0xFFFBF6EC), width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FlatFurniture(item: item, size: 88),
            ),
            const SizedBox(height: 14),
            Text(
              item.name,
              style: const TextStyle(
                color: _cardText,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.onWall ? 'Hangs on the wall' : 'Stands on the floor',
              style: TextStyle(color: _cocoa.withValues(alpha: 0.7), fontSize: 13),
            ),
            if (!canAfford) ...[
              const SizedBox(height: 10),
              const Text(
                'Not enough coins',
                style: TextStyle(
                  color: Color(0xFFB5524A),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: _cocoa,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: canAfford ? () => _buy(context) : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD54F),
                      foregroundColor: const Color(0xFF5A3D00),
                      disabledBackgroundColor: const Color(0xFFE6E0EE),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Buy for ',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        const CoinGlyph(size: 18, withShadow: false),
                        const SizedBox(width: 4),
                        Text('${item.price}',
                            style: const TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Export sheet
// ─────────────────────────────────────────────────────────────────────────

/// Bottom sheet shown after snapshotting the room: previews the picture and
/// offers to save it (and, where supported, copy it to the clipboard).
class _ExportSheet extends StatelessWidget {
  const _ExportSheet({required this.png});
  final Uint8List png;

  Future<void> _run(
    BuildContext context,
    Future<(bool, String)> Function(Uint8List) action,
  ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final (_, message) = await action(png);
    navigator.pop();
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _cocoa.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'A picture of your room',
              style: TextStyle(
                color: _cardText,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.memory(png, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _run(context, saveRoomImage),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7C5E48),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Save',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                if (canCopyRoomImage) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _run(context, copyRoomImage),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _cocoa,
                        side: const BorderSide(color: Color(0xFF7C5E48)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text('Copy',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Info card (double-tap)
// ─────────────────────────────────────────────────────────────────────────

void _showInfoCard(BuildContext context, String instanceId, ShopItem item) {
  showDialog<void>(
    context: context,
    builder: (_) => _InfoCard(instanceId: instanceId, item: item),
  );
}

/// Shown on double-tap: the piece's name in the languages the learner is
/// studying (their active course's pair), so the room reinforces vocabulary —
/// the learned language first and highlighted — plus a button to flip the piece
/// horizontally.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.instanceId, required this.item});
  final String instanceId;
  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    final course = CourseSession.instance.activeCourse;
    final learn = course.learnLocale.split('-').first; // 'de' / 'es'
    final speak = course.uiLang.name; // 'en' / 'es' / 'de'
    final langs = <(String code, String flag, bool isLearn)>[
      (learn, course.learnFlag, true),
      if (speak != learn) (speak, course.speakFlag, false),
    ];
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(28),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: _cream,
          border: Border.all(color: const Color(0xFFFBF6EC), width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FlatFurniture(item: item, size: 76),
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _cardText,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'What is this called?',
              style: TextStyle(color: _cocoa.withValues(alpha: 0.7), fontSize: 13),
            ),
            const SizedBox(height: 14),
            for (final (code, flag, isLearn) in langs)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _LangLine(
                  flag: flag,
                  label: kLangLabel[code] ?? code,
                  word: furnitureName(item.glyph, code, fallback: item.name),
                  highlight: isLearn,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    // Flip the piece and close, so the result is visible.
                    onPressed: () {
                      Apartment.instance.toggleFlip(instanceId);
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _cocoa,
                      side: const BorderSide(color: Color(0xFF7C5E48)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.flip_rounded, size: 18),
                    label: Text(
                      Apartment.instance.isFlipped(instanceId)
                          ? 'Unflip'
                          : 'Flip',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7C5E48),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Got it',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One language row on the info card: flag, language label and the word, with
/// the learned language highlighted.
class _LangLine extends StatelessWidget {
  const _LangLine({
    required this.flag,
    required this.label,
    required this.word,
    required this.highlight,
  });

  final String flag;
  final String label;
  final String word;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFE9C2) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: highlight ? Border.all(color: const Color(0xFFE0A82E)) : null,
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _cocoa.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  word,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: _cardText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Giving corner (donation)
// ─────────────────────────────────────────────────────────────────────────

/// A cosy donation place: tap an owned piece to give it away. It leaves the room
/// (and, still revealed, returns to the shop), and a flurry of hearts rises from
/// the sharing table — framed as donating to people who'll love it.
class _DonationSheet extends StatefulWidget {
  const _DonationSheet();

  @override
  State<_DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<_DonationSheet> {
  // Bumped on every gift; the sharing table watches it to fire a heart burst.
  int _burstCount = 0;

  void _giveAway(String instanceId, ShopItem item) {
    final messenger = ScaffoldMessenger.of(context);
    Apartment.instance.donate(instanceId);
    setState(() => _burstCount++);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('You gave away the ${item.name.toLowerCase()} 💛  '
              'Someone will love it!'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _cocoa.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '💛 Giving Corner',
                style: TextStyle(
                  color: _cardText,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Give away what you no longer need —\n'
                'someone out there will love it!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _cocoa.withValues(alpha: 0.75),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              _SharingTable(burstCount: _burstCount),
              const SizedBox(height: 8),
              Expanded(
                child: ListenableBuilder(
                  listenable: Apartment.instance,
                  builder: (context, _) {
                    final owned = [
                      for (final e in Apartment.instance.pieces.entries)
                        if (shopItemById(e.value) case final item?)
                          (e.key, item),
                    ];
                    if (owned.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Your room is empty —\nnothing to give away yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _cocoa.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 120,
                        mainAxisExtent: 132,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: owned.length,
                      itemBuilder: (context, i) => _DonationCard(
                        item: owned[i].$2,
                        onGive: () => _giveAway(owned[i].$1, owned[i].$2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The sharing table at the top of the giving corner: a warm pad with a
/// hands-holding-heart icon, from which hearts burst each time [burstCount]
/// increments (i.e. each time a piece is given away).
class _SharingTable extends StatefulWidget {
  const _SharingTable({required this.burstCount});
  final int burstCount;

  @override
  State<_SharingTable> createState() => _SharingTableState();
}

class _SharingTableState extends State<_SharingTable> {
  int _next = 0;
  final Set<int> _bursts = {};

  @override
  void didUpdateWidget(_SharingTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.burstCount > oldWidget.burstCount) {
      setState(() => _bursts.add(_next++));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE3E0),
                  border: Border.all(color: const Color(0xFFEFA9A2), width: 2),
                ),
                child: const Icon(
                  Icons.volunteer_activism_rounded,
                  color: Color(0xFFD9645C),
                  size: 36,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap a piece to give it away',
                style: TextStyle(
                  color: _cocoa.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          for (final b in _bursts)
            _HeartBurst(
              key: ValueKey(b),
              onDone: () {
                if (mounted) setState(() => _bursts.remove(b));
              },
            ),
        ],
      ),
    );
  }
}

/// One owned piece in the giving corner; tapping it gives it away.
class _DonationCard extends StatelessWidget {
  const _DonationCard({required this.item, required this.onGive});
  final ShopItem item;
  final VoidCallback onGive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGive,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatFurniture(item: item, size: 50),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: _cardText,
                fontSize: 12,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, size: 12, color: Color(0xFFD9645C)),
                  SizedBox(width: 4),
                  Text(
                    'Give',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD9645C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A one-shot burst of hearts that rise and fade from the centre, then calls
/// [onDone] so the parent can drop it.
class _HeartBurst extends StatefulWidget {
  const _HeartBurst({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  State<_HeartBurst> createState() => _HeartBurstState();
}

class _HeartBurstState extends State<_HeartBurst>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    Color(0xFFE0577A),
    Color(0xFFEF7CA0),
    Color(0xFFF4A8C0),
    Color(0xFFD9645C),
    Color(0xFFF6B26B),
  ];

  late final AnimationController _c;
  late final List<_Heart> _hearts;

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    _hearts = List.generate(10, (i) {
      return _Heart(
        dx: (rng.nextDouble() - 0.5) * 96,
        rise: 64 + rng.nextDouble() * 78,
        drift: (rng.nextDouble() - 0.5) * 34,
        size: 15 + rng.nextDouble() * 16,
        delay: rng.nextDouble() * 0.32,
        color: _colors[i % _colors.length],
      );
    });
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) widget.onDone();
      })
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [for (final h in _hearts) _heart(h)],
        ),
      ),
    );
  }

  Widget _heart(_Heart h) {
    final raw = (_c.value - h.delay) / (1 - h.delay);
    if (raw <= 0) return const SizedBox.shrink();
    final t = raw.clamp(0.0, 1.0);
    final eased = Curves.easeOut.transform(t);
    final opacity = (t < 0.18 ? t / 0.18 : 1 - (t - 0.18) / 0.82).clamp(0.0, 1.0);
    final dy = -h.rise * eased;
    final dx = h.dx + h.drift * t;
    final scale = 0.5 + 0.6 * Curves.easeOutBack.transform(t);
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Icon(Icons.favorite, color: h.color, size: h.size),
        ),
      ),
    );
  }
}

/// One floating heart's fixed parameters within a burst.
class _Heart {
  const _Heart({
    required this.dx,
    required this.rise,
    required this.drift,
    required this.size,
    required this.delay,
    required this.color,
  });

  final double dx;
  final double rise;
  final double drift;
  final double size;
  final double delay;
  final Color color;
}
