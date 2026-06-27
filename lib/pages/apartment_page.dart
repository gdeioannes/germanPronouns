import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/furniture_names.dart';
import '../data/room_catalog.dart';
import '../data/shop_catalog.dart';
import '../models/apartment.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../utils/room_image_export.dart';
import '../widgets/coin_balance_pill.dart';
import '../widgets/coin_glyph.dart';
import '../widgets/flat_furniture.dart';
import '../widgets/room_surfaces.dart';

/// The room mini-game: spend the coins earned in quizzes on flat-design
/// furniture, then drag the pieces around to furnish and decorate a cosy little
/// room. The shop reveals more pieces as the learner gets richer (see
/// [Apartment.refreshReveals]), and the room can be exported as an image to
/// save or copy elsewhere.
///
/// Deliberately warm and calm — a cosy reward for the learning the rest of the
/// app is about.
class ApartmentPage extends StatefulWidget {
  const ApartmentPage({super.key, this.onClose});

  /// Closes the room when it's docked as a slide-up panel; null when shown as a
  /// standalone page (then no close button is offered).
  final VoidCallback? onClose;

  @override
  State<ApartmentPage> createState() => _ApartmentPageState();
}

// Warm, cosy palette shared across the page (light-mode constants; the
// night-aware versions live in [_Pal] below).
const _cream = Color(0xFFF4E9D8);
const _cocoa = Color(0xFF6F5544);
const _cardText = Color(0xFF4A3728);

/// The room UI palette, which flips to dark when the room is in night mode — so
/// the whole shop/chrome matches the dark room, not just the lighting.
class _Pal {
  const _Pal({
    required this.bgTop,
    required this.bgBottom,
    required this.appBar1,
    required this.appBar2,
    required this.cardBorder,
    required this.panel,
    required this.tabStrip,
    required this.tabInactive,
    required this.card,
    required this.text,
    required this.textSoft,
  });
  final Color bgTop, bgBottom, appBar1, appBar2, cardBorder, panel, tabStrip;
  final Color tabInactive, card, text, textSoft;
}

const _palLight = _Pal(
  bgTop: Color(0xFFF4E9D8),
  bgBottom: Color(0xFFE7D3B6),
  appBar1: Color(0xFF7C5E48),
  appBar2: Color(0xFF6F5544),
  cardBorder: Color(0xFFFBF6EC),
  panel: Color(0xFFF4E8D2),
  tabStrip: Color(0xFFE9D9BD),
  tabInactive: Color(0xFFDCC9A4),
  card: Colors.white,
  text: Color(0xFF6F5544),
  textSoft: Color(0xFF8A7256),
);

const _palDark = _Pal(
  bgTop: Color(0xFF241F2C),
  bgBottom: Color(0xFF16131D),
  appBar1: Color(0xFF2E2839),
  appBar2: Color(0xFF26212F),
  cardBorder: Color(0xFF3A3447),
  panel: Color(0xFF2A2535),
  tabStrip: Color(0xFF1C1925),
  tabInactive: Color(0xFF231F2C),
  card: Color(0xFF332E3F),
  text: Color(0xFFEDE6DA),
  textSoft: Color(0xFFAFA6BC),
);

/// The current palette — dark while the room is in night mode.
_Pal get _pal => Apartment.instance.isNight ? _palDark : _palLight;

class _ApartmentPageState extends State<ApartmentPage>
    with SingleTickerProviderStateMixin {
  // Keys the room's RepaintBoundary so we can grab a picture of just the room.
  final GlobalKey _roomKey = GlobalKey();

  // While true, the room swaps the "Drag to rearrange" hint for the small
  // languagequiz watermark, so the shared picture is branded (not the hint).
  bool _exporting = false;

  // The shop is a draggable sheet that snaps to three rungs: collapsed (the room
  // gets the screen), the default split, and expanded (the shop fills the
  // screen). [_shopFraction] is how much of the body the shop takes; a drag
  // never rests between rungs — on release it snaps to the nearest one.
  static const double _shopCollapsed = 0.13;
  static const double _shopMiddle = 0.48;
  static const double _shopExpanded = 0.9;
  double _shopFraction = _shopMiddle;

  // Eases [_shopFraction] to a rung when a drag ends or the toolbar toggles it.
  // Created in initState (not a lazy `late final`) so it always exists by the
  // time dispose runs, even if the learner never drags.
  late final AnimationController _snapCtrl;
  Animation<double>? _snapAnim;

  @override
  void initState() {
    super.initState();
    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
  }

  @override
  void dispose() {
    _snapCtrl.dispose();
    super.dispose();
  }

  void _onShopDrag(double dy, double total) {
    if (_snapCtrl.isAnimating) _snapCtrl.stop();
    setState(() {
      _shopFraction =
          (_shopFraction - dy / total).clamp(_shopCollapsed, _shopExpanded);
    });
  }

  void _snapShop(double velocity, double total) {
    var f = _shopFraction;
    // A firm flick jumps a rung in its direction; otherwise snap to the nearest.
    if (velocity < -500) {
      f += 0.2; // flicked up → bigger shop
    } else if (velocity > 500) {
      f -= 0.2; // flicked down → smaller shop
    }
    const rungs = [_shopCollapsed, _shopMiddle, _shopExpanded];
    final target =
        rungs.reduce((a, b) => (f - a).abs() <= (f - b).abs() ? a : b);
    _animateShopTo(target);
  }

  void _animateShopTo(double target) {
    _snapAnim = Tween<double>(begin: _shopFraction, end: target).animate(
      CurvedAnimation(parent: _snapCtrl, curve: Curves.easeOutCubic),
    )..addListener(() => setState(() => _shopFraction = _snapAnim!.value));
    _snapCtrl.forward(from: 0);
  }

  /// The toolbar button: collapse the shop to give the room the screen, or
  /// restore the default split.
  void _toggleShop() => _animateShopTo(
        _shopFraction <= _shopCollapsed + 0.01 ? _shopMiddle : _shopCollapsed,
      );

  /// The room area (the room canvas + its selector bar), robust at any height:
  /// the canvas shrinks to fit, so it never overflows when the shop expands.
  Widget _roomArea({required bool compact, required bool roomBig}) {
    final pad = roomBig ? 8.0 : 12.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: pad),
              child: Center(
                child: LayoutBuilder(
                  builder: (context, rc) {
                    const aspect = 0.82;
                    final w = math.max(
                      0.0,
                      math.min(rc.maxWidth, rc.maxHeight * aspect),
                    );
                    if (w < 1) return const SizedBox.shrink();
                    return SizedBox(
                      width: w,
                      height: w / aspect,
                      child: _RoomCanvas(
                        repaintKey: _roomKey,
                        exporting: _exporting,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          _RoomBar(onTap: _openRoomPicker, compact: compact),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // On phones the room is a tall panel with little width to spare, so the
    // toolbar's secondary actions collapse into an overflow menu.
    final compact = MediaQuery.sizeOf(context).width < 700;
    // Rebuild the page (incl. the app bar) when night flips, so the whole room
    // UI switches to the dark palette, not just the lighting.
    return ListenableBuilder(
      listenable: Apartment.instance,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
        title: const Text(
          '🛋️ My Room',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        titleSpacing: widget.onClose != null ? 0 : 8,
        // When docked as a slide-up panel, an explicit close (down) button —
        // the room now covers the whole screen, so there's no app behind to tap.
        automaticallyImplyLeading: false,
        leading: widget.onClose == null
            ? null
            : IconButton(
                tooltip: 'Close the room',
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white),
                onPressed: widget.onClose,
              ),
        // A gradient bar that reliably fills, so the white title/icons stay
        // visible; switches to the dark palette at night.
        backgroundColor: _pal.appBar2,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_pal.appBar1, _pal.appBar2],
            ),
          ),
        ),
        elevation: 0,
        actions: _roomActions(compact),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_pal.bgTop, _pal.bgBottom],
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
              // On phones, shrink the room carousel and hand the freed space to
              // the room and the shop so nothing feels cramped.
              final compact = MediaQuery.sizeOf(context).width < 700;
              // The room sits above the shop; the shop is a draggable sheet that
              // snaps to collapsed / middle / expanded. The room area gets the
              // rest and always keeps at least its selector bar visible.
              return LayoutBuilder(
                builder: (context, c) {
                  final total = c.maxHeight;
                  // Keep at least the room's selector bar on screen, so the room
                  // area never collapses to nothing while the shop expands.
                  final shopH =
                      (total * _shopFraction).clamp(0.0, total - 56.0);
                  final roomH = total - shopH;
                  final roomBig = _shopFraction <= _shopCollapsed + 0.01;
                  return Column(
                    children: [
                      SizedBox(
                        height: roomH,
                        child: _roomArea(compact: compact, roomBig: roomBig),
                      ),
                      SizedBox(
                        height: shopH,
                        // Not const: the shop reads the night-aware palette, so
                        // it must rebuild when night flips.
                        child: _Shop(
                          // Too short to show the full store → a peek bar.
                          collapsed: shopH < 130,
                          onDrag: (dy) => _onShopDrag(dy, total),
                          onDragEnd: (v) => _snapShop(v, total),
                          onToggle: _toggleShop,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
      ),
    );
  }

  // ── Toolbar ────────────────────────────────────────────────────────────────

  /// The room toolbar. On wide screens every control is its own button; on
  /// phones only the "make the room bigger" toggle and the coin pill stay out,
  /// and the rest (play/pause, day/night, give away, share) fold into a single
  /// overflow menu so the bar isn't crammed.
  List<Widget> _roomActions(bool compact) {
    final apt = Apartment.instance;
    final roomBig = _shopFraction <= _shopCollapsed + 0.01;
    final focusButton = IconButton(
      tooltip: roomBig ? 'Show the shop' : 'Make the room bigger',
      icon: Icon(
        roomBig ? Icons.close_fullscreen : Icons.open_in_full,
        color: Colors.white,
      ),
      onPressed: _toggleShop,
    );

    if (compact) {
      return [
        focusButton,
        PopupMenuButton<String>(
          tooltip: 'More room options',
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: _pal.card,
          onSelected: (value) {
            switch (value) {
              case 'animate':
                apt.setAnimate(!apt.animate);
              case 'night':
                apt.setNight(!apt.isNight);
              case 'give':
                _openGivingCorner();
              case 'share':
                _exportRoom();
            }
          },
          itemBuilder: (_) => [
            _overflowItem(
              'animate',
              apt.animate ? Icons.pause_circle_outline : Icons.play_circle_outline,
              apt.animate ? 'Pause animation' : 'Play animation',
            ),
            _overflowItem(
              'night',
              apt.isNight ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              apt.isNight ? 'Switch to day' : 'Switch to night',
            ),
            _overflowItem(
              'give', Icons.volunteer_activism_rounded, 'Give away furniture'),
            _overflowItem(
              'share', Icons.ios_share_rounded, 'Save or copy a picture'),
          ],
        ),
        const CoinBalancePill(),
        const SizedBox(width: 4),
      ];
    }

    return [
      IconButton(
        tooltip: apt.animate ? 'Pause animation' : 'Play animation',
        icon: Icon(
          apt.animate ? Icons.pause_circle_outline : Icons.play_circle_outline,
          color: Colors.white,
        ),
        onPressed: () => apt.setAnimate(!apt.animate),
      ),
      focusButton,
      IconButton(
        tooltip: apt.isNight ? 'Switch to day' : 'Switch to night',
        icon: Icon(
          apt.isNight ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          color: Colors.white,
        ),
        onPressed: () => apt.setNight(!apt.isNight),
      ),
      IconButton(
        tooltip: 'Give away furniture',
        icon: const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
        onPressed: _openGivingCorner,
      ),
      IconButton(
        tooltip: 'Save or copy a picture of your room',
        icon: const Icon(Icons.ios_share_rounded, color: Colors.white),
        onPressed: _exportRoom,
      ),
      const CoinBalancePill(),
      const SizedBox(width: 6),
    ];
  }

  PopupMenuItem<String> _overflowItem(String value, IconData icon, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: _pal.text),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: _pal.text)),
        ],
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

  // ── Buy a new room ─────────────────────────────────────────────────────────

  Future<void> _openRoomPicker() async {
    final movedInto = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _pal.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _RoomPickerSheet(),
    );
    if (movedInto != null && mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text('Welcome to your new $movedInto! ✨')),
        );
    }
  }

  // ── Image export ──────────────────────────────────────────────────────────

  Future<void> _exportRoom() async {
    // Show the watermark instead of the hint, give the logo a moment to decode
    // and paint, then snapshot.
    setState(() => _exporting = true);
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 70));
    await WidgetsBinding.instance.endOfFrame;
    final png = await _captureRoom();
    if (!mounted) return;
    setState(() => _exporting = false);
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
      isScrollControlled: true,
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
  const _RoomCanvas({required this.repaintKey, this.exporting = false});

  final GlobalKey repaintKey;

  /// While true, the room shows the languagequiz watermark instead of the drag
  /// hint, so the snapshot is branded.
  final bool exporting;

  @override
  State<_RoomCanvas> createState() => _RoomCanvasState();
}

class _RoomCanvasState extends State<_RoomCanvas>
    with TickerProviderStateMixin {
  // The piece currently held (brightened + drawn on top), and its live pixel
  // centre (the finger position) while it's being dragged.
  String? _dragId;
  Offset? _dragCenter;

  // The held piece is drawn lifted above the fingertip so the finger never hides
  // it. The lift eases in (0 → [_liftTarget] px) once dragging starts, so it
  // glides up instead of snapping.
  double _liftTarget = 0;
  late final AnimationController _lift = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 170),
  )..addListener(() {
      if (mounted) setState(() {});
    });

  // A slow, looping clock that drives the gentle idle float of room pieces.
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  /// The lift in pixels for a finger at [fingerY] in a room [height] tall, eased
  /// in by [_lift] (0 while not dragging). The lift floats the piece above the
  /// finger so the finger never hides it — but the finger can't reach below the
  /// room's bottom edge, so it scales with how high the finger is: full near the
  /// top, smoothly down to 0 at the floor. That way moving the piece down only
  /// ever shrinks the gap (never grows it), and a piece can still be placed flush
  /// against the bottom. [half] is the piece's half-size (its centre ranges over
  /// [half] .. [height] - [half]).
  double _liftAt(double fingerY, double half, double height) {
    final full = _liftTarget * Curves.easeOut.transform(_lift.value);
    if (full == 0) return 0;
    final travel = height - 2 * half; // the finger's vertical range
    if (travel <= 0) return 0;
    final fromBottom = ((height - half) - fingerY).clamp(0.0, travel);
    return full * (fromBottom / travel);
  }

  @override
  void dispose() {
    _lift.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Run the idle clock only while animation is on (and only matters when
    // pieces are present); pausing it stops the float entirely.
    if (Apartment.instance.animate) {
      if (!_idle.isAnimating) _idle.repeat();
    } else if (_idle.isAnimating) {
      _idle.stop();
    }
    return RepaintBoundary(
      key: widget.repaintKey,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _pal.cardBorder, width: 4),
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
            // The reference size for a scale-1.0 piece — strictly proportional to
            // the room (no clamp), so pieces and the gaps between them keep the
            // same relative size/spacing whenever the room resizes.
            final baseTile = size.shortestSide * 0.21;
            // Each placed piece is (instanceId, catalogue item); a learner can
            // own several of the same item, each arranged on its own. Surfaces
            // (floors / walls) are owned too but change the background instead of
            // being placed, so they're left out of the draggable pieces.
            final pieces = [
              for (final e in Apartment.instance.pieces.entries)
                if (shopItemById(e.value) case final item? when !item.isSurface)
                  (e.key, item),
            ];
            // Draw the held piece last so it floats above the others.
            final ordered = [
              for (final p in pieces) if (p.$1 != _dragId) p,
              for (final p in pieces) if (p.$1 == _dragId) p,
            ];
            // The current floor / wall surfaces (newest bought), falling back to
            // the room theme's own default look when nothing's been bought.
            final theme = Apartment.instance.currentRoom;
            final floor = shopItemById(Apartment.instance.currentFloor ?? '');
            final wall = shopItemById(Apartment.instance.currentWall ?? '');
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
                Positioned.fill(
                  child: _CosyRoom(
                    floorGlyph: floor?.glyph ?? theme.floorGlyph,
                    floorColor: floor?.color ?? theme.floorColor,
                    wallGlyph: wall?.glyph ?? theme.wallGlyph,
                    wallColor: wall?.color ?? theme.wallColor,
                    backdrop: theme.backdrop,
                  ),
                ),
                for (final p in ordered) _draggable(p.$1, p.$2, size, baseTile),
                if (night || lights.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _RoomLightingPainter(
                          night: night,
                          lights: lights,
                          clock: Apartment.instance.animate ? _idle : null,
                        ),
                      ),
                    ),
                  ),
                if (widget.exporting)
                  const Positioned(right: 14, bottom: 12, child: _RoomWatermark())
                // Not const — these read the night-aware palette.
                else if (pieces.isEmpty)
                  _EmptyRoom()
                else
                  Positioned(left: 12, top: 10, child: _DragHint()),
              ],
            );
          },
        ),
      ),
    );
  }

  Offset _centerPx(String iid, ShopItem item, Size size, double half) {
    if (iid == _dragId && _dragCenter != null) {
      // Draw the held piece lifted above the finger (the lift eases in, and
      // tapers near the bottom so the piece can still be placed on the floor).
      final lift = _liftAt(_dragCenter!.dy, half, size.height);
      return Offset(_dragCenter!.dx, _dragCenter!.dy - lift);
    }
    final n = Apartment.instance.positionOf(iid, item.id);
    return Offset(n.dx * size.width, n.dy * size.height);
  }

  double _sizeOf(ShopItem item, double baseTile, Size size) =>
      // Proportional; the wide clamp is only a safety net far outside the normal
      // range, so it never breaks the relative sizing.
      (baseTile * item.scale).clamp(6.0, size.shortestSide * 0.95);

  /// Resolves a light's pixel geometry: a downward cone for beam lights (apex at
  /// the shade), or a soft elliptical pool for the rest.
  _LightSpec _lightSpec(
      String iid, ShopItem item, _LightFx fx, Size size, double baseTile) {
    final s = _sizeOf(item, baseTile, size);
    final c = _centerPx(iid, item, size, s / 2);
    final phase = (iid.hashCode & 0xFFFF) / 0xFFFF;
    if (fx.beam) {
      return _LightSpec(
        beam: true,
        at: c + Offset(fx.apexDx * s, fx.apexDy * s),
        color: fx.color,
        intensity: fx.intensity,
        glow: fx.glow,
        focal: Alignment.center,
        a: s * fx.apexHalf,
        b: s * fx.spread,
        len: s * fx.length,
        soft: s * fx.soft,
        flicker: fx.flicker,
        phase: phase,
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
      flicker: fx.flicker,
      phase: phase,
    );
  }

  Widget _draggable(String iid, ShopItem item, Size size, double baseTile) {
    final itemSize = _sizeOf(item, baseTile, size);
    final half = itemSize / 2;
    final isDragging = _dragId == iid;
    final center = _centerPx(iid, item, size, half);
    final left = (center.dx - half).clamp(0.0, size.width - itemSize);
    final top = (center.dy - half).clamp(0.0, size.height - itemSize);

    return Positioned(
      // Keyed by instance so reordering (held piece drawn last) keeps each
      // gesture on its own piece.
      key: ValueKey(iid),
      left: left,
      top: top,
      child: GestureDetector(
        // Brighten as soon as the piece is touched; the lift above the fingertip
        // glides in once dragging actually starts (so a tap doesn't move it).
        onPanDown: (_) => setState(() {
          _dragId = iid;
          _dragCenter = center;
          _liftTarget = itemSize * 0.5 + 28;
          _lift.value = 0;
        }),
        onPanUpdate: (d) {
          // Ease the lift in on the first movement, then track the finger.
          if (_lift.value == 0 && !_lift.isAnimating) _lift.forward();
          final cur = _dragCenter ?? center;
          // Track the finger's *true* position (don't clamp it here). The piece
          // itself is kept inside the room by the display clamp (left/top below)
          // and the drop clamp in onPanEnd. Clamping the stored position instead
          // would discard any overshoot past an edge, so reversing direction
          // would jump the piece off the edge ahead of the finger, leaving a
          // spurious gap. Keeping the true position pins the piece at the edge
          // until the finger travels back, so they stay aligned.
          setState(() => _dragCenter = cur + d.delta);
        },
        onPanEnd: (_) {
          // Drop where the lifted piece is shown — what you see is where it lands.
          final c = _centerPx(iid, item, size, half);
          Apartment.instance.setPosition(
            iid,
            Offset(
              c.dx.clamp(half, size.width - half) / size.width,
              c.dy.clamp(half, size.height - half) / size.height,
            ),
          );
          // The piece just arranged jumps to the top of the stack and stays
          // there, above everything else.
          Apartment.instance.bringToFront(iid);
          setState(() {
            _dragId = null;
            _dragCenter = null;
            _lift.value = 0;
            _liftTarget = 0;
          });
        },
        onPanCancel: () => setState(() {
          _dragId = null;
          _dragCenter = null;
          _lift.value = 0;
          _liftTarget = 0;
        }),
        // Double-tap a piece for its name (and to flip it).
        onDoubleTap: () => _showInfoCard(context, iid, item),
        child: _idleToken(iid, item, itemSize, isDragging),
      ),
    );
  }

  /// The piece's drawing, given the idle animations that fit it: an in-character
  /// painter animation (flame, fish, fan… — see [furnitureHasIdleAnimation]) for
  /// some, and/or a whole-piece motion (plants sway, hung pieces swing, the cat
  /// breathes — see [_motionFor]). Held or paused pieces are perfectly still.
  Widget _idleToken(String iid, ShopItem item, double itemSize, bool isDragging) {
    final animating = Apartment.instance.animate && !isDragging;
    final glyph = item.glyph;
    final phase = (iid.hashCode & 0xFFFF) / 0xFFFF;

    Widget token = _FurnitureToken(
      item: item,
      size: itemSize,
      highlighted: isDragging,
      flipped: Apartment.instance.isFlipped(iid),
      animation:
          animating && furnitureHasIdleAnimation(glyph) ? _idle : null,
      phase: phase,
    );

    final motion = _motionFor(glyph);
    if (animating && motion != _Motion.none) {
      token = _IdleMotion(
          clock: _idle, seed: iid.hashCode, motion: motion, child: token);
    }
    return token;
  }
}

/// The fitting whole-piece idle motion for a glyph (or [_Motion.none] for the
/// many pieces that should just sit still).
enum _Motion { none, sway, pendulum, breathe }

_Motion _motionFor(String glyph) {
  switch (glyph) {
    // Plants nod in a breeze, pivoting at the pot.
    case 'plant':
    case 'cactus':
    case 'succulent':
    case 'palm':
    case 'vase':
      return _Motion.sway;
    // Hung pieces swing from their cord / hook.
    case 'pendant':
    case 'hangingplant':
    case 'birdcage':
      return _Motion.pendulum;
    // The cat, the meditator and the yogi softly breathe (whole-piece). The
    // other people have their own small in-character motions in the painter.
    case 'pet':
    case 'meditator':
    case 'yogatree':
      return _Motion.breathe;
    default:
      return _Motion.none;
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
    this.animation,
    this.phase = 0,
  });

  final ShopItem item;
  final double size;
  final bool highlighted;
  final bool flipped;

  /// Drives the piece's in-character idle drawing (flame flicker, swimming
  /// fish…); null when paused / held, so it shows the still pose.
  final Animation<double>? animation;
  final double phase;

  @override
  Widget build(BuildContext context) {
    Widget furniture =
        FlatFurniture(item: item, size: size, animation: animation, phase: phase);
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

/// A tiny, slow whole-piece idle motion that suits the object: a plant [sway]ing
/// from its pot, a hung piece swinging like a [pendulum] from its cord, or the
/// cat softly [breathe]ing. Each piece is offset by its [seed] so identical
/// pieces drift out of sync. Always gentle — a few degrees, a couple of percent.
class _IdleMotion extends StatelessWidget {
  const _IdleMotion({
    required this.clock,
    required this.seed,
    required this.motion,
    required this.child,
  });

  final Animation<double> clock; // loops 0..1
  final int seed;
  final _Motion motion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final phase = (seed & 0xFF) / 255.0; // where in the cycle this piece is
    final amp = 0.7 + ((seed >> 8) & 0xFF) / 255.0 * 0.6; // 0.7..1.3
    return AnimatedBuilder(
      animation: clock,
      child: child,
      builder: (context, child) {
        final a = (clock.value + phase) * 2 * math.pi;
        switch (motion) {
          case _Motion.sway:
            // A breeze: rock a little around the base (the pot stays put).
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.rotationZ(math.sin(a) * 0.03 * amp), // ±~1.7°
              child: child,
            );
          case _Motion.pendulum:
            // Swing from the cord / hook at the very top.
            return Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.rotationZ(math.sin(a) * 0.05 * amp), // ±~2.9°
              child: child,
            );
          case _Motion.breathe:
            // Slow in/out, like a sleeping breath.
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.diagonal3Values(
                  1, 1 + math.sin(a) * 0.02 * amp, 1), // ±2% height
              child: child,
            );
          case _Motion.none:
            return child!;
        }
      },
    );
  }
}

/// The cosy flat backdrop: the wall (the bought wallpaper or default cream), the
/// floor (the bought flooring or default wood) and a skirting board between
/// them. Painted, not furniture, so it's part of every snapshot.
class _CosyRoom extends StatelessWidget {
  const _CosyRoom({
    this.floorGlyph,
    this.floorColor,
    this.wallGlyph,
    this.wallColor,
    this.backdrop = RoomBackdrop.none,
  });

  final String? floorGlyph;
  final Color? floorColor;
  final String? wallGlyph;
  final Color? wallColor;
  final RoomBackdrop backdrop;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _CosyRoomPainter(
        floorGlyph: floorGlyph,
        floorColor: floorColor,
        wallGlyph: wallGlyph,
        wallColor: wallColor,
        backdrop: backdrop,
      ),
    );
  }
}

class _CosyRoomPainter extends CustomPainter {
  _CosyRoomPainter({
    this.floorGlyph,
    this.floorColor,
    this.wallGlyph,
    this.wallColor,
    this.backdrop = RoomBackdrop.none,
  });

  final String? floorGlyph;
  final Color? floorColor;
  final String? wallGlyph;
  final Color? wallColor;
  final RoomBackdrop backdrop;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final floorY = h * 0.66;
    final p = Paint()..isAntiAlias = true;

    final wall = Rect.fromLTWH(0, 0, w, floorY);
    paintWall(canvas, wall, wallGlyph, wallColor);
    // The themed motif on the back wall, behind the furniture.
    _paintBackdrop(canvas, wall);
    paintFloor(
        canvas, Rect.fromLTWH(0, floorY, w, h - floorY), floorGlyph, floorColor);

    // Skirting board between wall and floor.
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

  /// Paints the room theme's decorative motif within the wall [r] — flat, soft
  /// and low-contrast so the furniture stays the focus.
  void _paintBackdrop(Canvas canvas, Rect r) {
    final p = Paint()..isAntiAlias = true;
    final w = r.width;
    final h = r.height;
    double px(double f) => r.left + w * f;
    double py(double f) => r.top + h * f;

    void rrect(double l, double t, double rr, double b, double rad, Color c) {
      canvas.drawRRect(
        RRect.fromLTRBR(px(l), py(t), px(rr), py(b), Radius.circular(w * rad)),
        p..color = c,
      );
    }

    void disc(double cx, double cy, double rad, Color c) {
      canvas.drawCircle(Offset(px(cx), py(cy)), w * rad, p..color = c);
    }

    void stroke(double x1, double y1, double x2, double y2, double sw, Color c) {
      canvas.drawLine(
        Offset(px(x1), py(y1)),
        Offset(px(x2), py(y2)),
        p
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * sw
          ..strokeCap = StrokeCap.round,
      );
      p.style = PaintingStyle.fill;
    }

    switch (backdrop) {
      case RoomBackdrop.none:
        break;
      case RoomBackdrop.sun:
        const glow = Color(0x33FFE08A);
        disc(0.5, 0.34, 0.30, glow);
        disc(0.5, 0.34, 0.20, const Color(0x4DFFE7A0));
        disc(0.5, 0.34, 0.12, const Color(0x66FFEFB8));
        for (var i = 0; i < 12; i++) {
          final a = i * math.pi / 6;
          stroke(
            0.5 + math.cos(a) * 0.24,
            0.34 + math.sin(a) * 0.24 * (w / h),
            0.5 + math.cos(a) * 0.30,
            0.34 + math.sin(a) * 0.30 * (w / h),
            0.012,
            const Color(0x33FFD98A),
          );
        }
      case RoomBackdrop.shelves:
        // A bookcase silhouette on the right side of the wall.
        rrect(0.56, 0.08, 0.96, 1.0, 0.01, const Color(0x22000000));
        const spines = [
          Color(0x55C7572E), Color(0x554E7CA8), Color(0x556B9E63),
          Color(0x55C99A3D), Color(0x55865C9C), Color(0x55B5524A),
        ];
        for (var shelf = 0; shelf < 4; shelf++) {
          final t = 0.12 + shelf * 0.22;
          for (var b = 0; b < 6; b++) {
            final x = 0.585 + b * 0.058;
            final hh = 0.16 + ((b + shelf) % 3) * 0.012;
            rrect(x, t + 0.20 - hh, x + 0.045, t + 0.20,
                0.004, spines[(b + shelf) % spines.length]);
          }
          stroke(0.57, t + 0.205, 0.95, t + 0.205, 0.01,
              const Color(0x33000000));
        }
      case RoomBackdrop.trellis:
        const line = Color(0x2638694A);
        for (var i = -6; i < 14; i++) {
          stroke(i * 0.16, 0.0, i * 0.16 + 0.7, 1.0, 0.01, line);
          stroke(i * 0.16, 1.0, i * 0.16 + 0.7, 0.0, 0.01, line);
        }
        disc(0.18, 0.2, 0.035, const Color(0x4D6B9E63));
        disc(0.84, 0.3, 0.04, const Color(0x4D6B9E63));
        disc(0.74, 0.12, 0.03, const Color(0x4D6B9E63));
      case RoomBackdrop.canvas:
        rrect(0.30, 0.14, 0.70, 0.56, 0.015, const Color(0x33000000));
        rrect(0.33, 0.17, 0.67, 0.53, 0.01, const Color(0xCCF7F1E6));
        disc(0.44, 0.30, 0.06, const Color(0x66E2574C));
        rrect(0.52, 0.24, 0.63, 0.46, 0.01, const Color(0x664E7CA8));
        disc(0.58, 0.40, 0.045, const Color(0x66F4C430));
      case RoomBackdrop.drapes:
        // A soft headboard arch behind the centre.
        final arch = Path()
          ..moveTo(px(0.2), py(1.0))
          ..lineTo(px(0.2), py(0.46))
          ..quadraticBezierTo(px(0.5), py(0.18), px(0.8), py(0.46))
          ..lineTo(px(0.8), py(1.0))
          ..close();
        canvas.drawPath(arch, p..color = const Color(0x22FFFFFF));
        // Curtains at the sides.
        rrect(0.0, 0.0, 0.12, 1.0, 0.02, const Color(0x22FFFFFF));
        rrect(0.88, 0.0, 1.0, 1.0, 0.02, const Color(0x22FFFFFF));
        for (final x in const [0.03, 0.06, 0.09, 0.91, 0.94, 0.97]) {
          stroke(x, 0.0, x, 1.0, 0.006, const Color(0x18000000));
        }
      case RoomBackdrop.tiles:
        // A window, top-centre.
        rrect(0.36, 0.12, 0.64, 0.44, 0.02, const Color(0x33000000));
        rrect(0.38, 0.14, 0.62, 0.42, 0.01, const Color(0x66BFE3F2));
        stroke(0.5, 0.14, 0.5, 0.42, 0.01, const Color(0x33000000));
        stroke(0.38, 0.28, 0.62, 0.28, 0.01, const Color(0x33000000));
        // Backsplash tiles just above the floor.
        for (var row = 0; row < 2; row++) {
          for (var col = 0; col < 12; col++) {
            rrect(0.02 + col * 0.082, 0.66 + row * 0.15,
                0.02 + col * 0.082 + 0.072, 0.66 + row * 0.15 + 0.12,
                0.01, const Color(0x22FFFFFF));
          }
        }
      case RoomBackdrop.waves:
        for (var i = 0; i < 5; i++) {
          final y = 0.2 + i * 0.13;
          final path = Path()..moveTo(r.left, py(y));
          for (var x = 0.0; x <= 1.0; x += 0.1) {
            path.quadraticBezierTo(
              px(x + 0.025), py(y + (i.isEven ? 0.03 : -0.03)),
              px(x + 0.05), py(y),
            );
          }
          canvas.drawPath(
            path,
            p
              ..color = const Color(0x33CFEFFB)
              ..style = PaintingStyle.stroke
              ..strokeWidth = w * 0.012,
          );
          p.style = PaintingStyle.fill;
        }
        disc(0.78, 0.22, 0.10, const Color(0x33000000));
        disc(0.78, 0.22, 0.085, const Color(0x66BFE3F2));
      case RoomBackdrop.skyline:
        // A big picture window onto a city skyline.
        rrect(0.1, 0.1, 0.9, 0.92, 0.01, const Color(0x33000000));
        rrect(0.12, 0.12, 0.88, 0.9, 0.005, const Color(0x553A4A6B));
        const b = Color(0x77222B3F);
        rrect(0.16, 0.5, 0.27, 0.9, 0.0, b);
        rrect(0.29, 0.38, 0.39, 0.9, 0.0, b);
        rrect(0.41, 0.56, 0.5, 0.9, 0.0, b);
        rrect(0.52, 0.3, 0.61, 0.9, 0.0, b);
        rrect(0.63, 0.48, 0.73, 0.9, 0.0, b);
        rrect(0.75, 0.4, 0.84, 0.9, 0.0, b);
        for (var i = 0; i < 16; i++) {
          final wx = 0.18 + (i % 8) * 0.08;
          final wy = 0.55 + (i ~/ 8) * 0.12;
          rrect(wx, wy, wx + 0.02, wy + 0.03, 0.0,
              const Color(0x66FFE9A8));
        }
        stroke(0.5, 0.12, 0.5, 0.9, 0.008, const Color(0x33000000));
      case RoomBackdrop.neon:
        for (final spec in const [
          [0.12, Color(0x55FF4D9D)],
          [0.26, Color(0x4D49E0FF)],
          [0.4, Color(0x55C46BFF)],
        ]) {
          final y = spec[0] as double;
          rrect(0.1, y, 0.9, y + 0.05, 0.025, spec[1] as Color);
        }
        disc(0.22, 0.62, 0.06, const Color(0x55FF4D9D));
        disc(0.8, 0.66, 0.05, const Color(0x4D49E0FF));
    }
  }

  @override
  bool shouldRepaint(_CosyRoomPainter oldDelegate) =>
      oldDelegate.floorGlyph != floorGlyph ||
      oldDelegate.floorColor != floorColor ||
      oldDelegate.wallGlyph != wallGlyph ||
      oldDelegate.wallColor != wallColor ||
      oldDelegate.backdrop != backdrop;
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
    this.apexDx = 0,
    this.apexDy = 0,
    this.soft = 0.06,
    this.flicker = false,
  });
  final Color color;
  final double intensity;
  final double glow;
  final double w;
  final double h;

  /// Vertical offset of the light from the piece centre, as a fraction of the
  /// piece size.
  final double dy;
  final Alignment focal;
  final bool beam;
  final double length;
  final double spread;
  final double apexHalf;

  /// Horizontal/vertical offset of a beam's cone apex from the piece centre.
  final double apexDx;
  final double apexDy;

  /// Whether this is a live flame whose cast light should waver (candles,
  /// fireplace, lantern) rather than a steady electric glow.
  final bool flicker;

  /// Cone edge softness as a fraction of the piece size — small keeps the cone's
  /// polygon edges sharp; 0 makes them razor crisp.
  final double soft;
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
      w: 1.0, h: 1.0, dy: 0, flicker: true),
  // The ellipse sits above the flame so its soft bottom edge fades out right at
  // the candle's base — no spill below, and no hard crop line.
  'candle': _LightFx(
      color: Color(0xFFFFC97A), intensity: 0.42, glow: 0.24,
      w: 0.9, h: 0.7, dy: -0.28, flicker: true),
  'fireplace': _LightFx(
      color: Color(0xFFFF9A52), intensity: 0.65, glow: 0.34,
      w: 1.8, h: 1.4, dy: -0.2, focal: Alignment(0, 0.4), flicker: true),
  'tv': _LightFx(
      color: Color(0xFF9AD0FF), intensity: 0.4, glow: 0.2,
      w: 1.4, h: 1.1, dy: 0.1),
  'arcade': _LightFx(
      color: Color(0xFF9AD0FF), intensity: 0.4, glow: 0.2,
      w: 1.1, h: 1.2, focal: Alignment(0, -0.3)),
  'aquarium': _LightFx(
      color: Color(0xFF7FE0FF), intensity: 0.4, glow: 0.18,
      w: 1.3, h: 1.0),
  'fishtank': _LightFx(
      color: Color(0xFF7FE0FF), intensity: 0.36, glow: 0.16,
      w: 1.2, h: 1.0),
  // ── Lighting category — every lamp earns its keep after dark ──────────────
  // The chandelier is the hero ceiling light: a big, soft, warm pool.
  'chandelier': _LightFx(
      color: Color(0xFFFFE0A0), intensity: 0.5, glow: 0.26,
      w: 2.3, h: 1.7, dy: 0.12),
  // Its shade sits to the right of the drawing where the arc reaches over, so
  // the cone casts from there (apexDx), softened so the edges feather out.
  'arclamp': _LightFx(
      color: Color(0xFFFFD98A), intensity: 0.42, glow: 0.22, beam: true,
      length: 1.5, spread: 0.78, apexHalf: 0.13,
      apexDx: 0.24, apexDy: 0.02, soft: 0.11),
  'paperlantern': _LightFx(
      color: Color(0xFFFFE0B0), intensity: 0.4, glow: 0.24,
      w: 1.5, h: 1.5),
  'lavalamp': _LightFx(
      color: Color(0xFFFF7A5C), intensity: 0.34, glow: 0.26,
      w: 1.1, h: 1.5, flicker: true),
  'neonhalo': _LightFx(
      color: Color(0xFFFF8AD0), intensity: 0.38, glow: 0.30,
      w: 1.7, h: 1.7),
  // ── Glowing décor / electronics across the catalogue ──────────────────────
  'fairylights': _LightFx(
      color: Color(0xFFFFE0A0), intensity: 0.36, glow: 0.26,
      w: 2.3, h: 1.1, dy: 0.18, flicker: true),
  'neonsign': _LightFx(
      color: Color(0xFFFF7AC8), intensity: 0.38, glow: 0.28,
      w: 1.9, h: 1.3, dy: 0.08),
  'spacandles': _LightFx(
      color: Color(0xFFFFC97A), intensity: 0.34, glow: 0.22,
      w: 1.0, h: 0.8, dy: -0.18, flicker: true),
  'jukebox': _LightFx(
      color: Color(0xFFFFC07A), intensity: 0.38, glow: 0.24,
      w: 1.4, h: 1.5, dy: -0.08),
  'arcadetower': _LightFx(
      color: Color(0xFFB89AFF), intensity: 0.38, glow: 0.22,
      w: 1.3, h: 1.4, focal: Alignment(0, -0.2)),
  'computer': _LightFx(
      color: Color(0xFF9AD0FF), intensity: 0.36, glow: 0.18,
      w: 1.2, h: 1.0),
  'laptop': _LightFx(
      color: Color(0xFF9AD0FF), intensity: 0.34, glow: 0.18,
      w: 1.1, h: 0.9),
  'pinball': _LightFx(
      color: Color(0xFFFFB0C0), intensity: 0.34, glow: 0.22,
      w: 1.2, h: 1.3, dy: -0.1),
  // Wood-fired / heated pieces throw a warm, wavering ember glow.
  'pizzaoven': _LightFx(
      color: Color(0xFFFF9A52), intensity: 0.48, glow: 0.28,
      w: 1.5, h: 1.2, dy: 0.0, focal: Alignment(0, 0.2), flicker: true),
  'kiln': _LightFx(
      color: Color(0xFFFF9A52), intensity: 0.4, glow: 0.24,
      w: 1.2, h: 1.1, dy: 0.1, flicker: true),
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
    required this.focal,
    required this.color,
    required this.intensity,
    required this.glow,
    this.flicker = false,
    this.phase = 0,
  });
  final bool beam;
  final Offset at;
  final double a;
  final double b;
  final double len;
  final double soft;
  final Alignment focal;
  final Color color;
  final double intensity;
  final double glow;
  final bool flicker;
  final double phase;
}

/// Paints the room's lighting on top of the furniture: at night a dark scrim
/// that each light lifts in its own shape (a soft cone for lamps so the light
/// comes out of the shade, an ellipse otherwise), plus a gentle warm/cool bloom
/// — strong at night, subtle by day — so the effect is visible either way.
class _RoomLightingPainter extends CustomPainter {
  _RoomLightingPainter({required this.night, required this.lights, this.clock})
      : super(repaint: clock);

  final bool night;
  final List<_LightSpec> lights;

  /// The idle clock (0..1, looping) when animation is on, else null. Flame
  /// lights waver their cast light in time with it.
  final Animation<double>? clock;

  /// A gentle multiplier (~0.8–1.2) on a flame light's brightness, layered from
  /// a few sines so it wavers organically; 1.0 (steady) for electric lights or
  /// when paused.
  double _flick(_LightSpec l) {
    final c = clock;
    if (c == null || !l.flicker) return 1.0;
    final t = c.value;
    final n = 0.55 * math.sin((t * 3 + l.phase) * 2 * math.pi) +
        0.30 * math.sin((t * 7 + l.phase * 1.7) * 2 * math.pi) +
        0.15 * math.sin((t * 13 + l.phase * 2.3) * 2 * math.pi);
    return (1.0 + 0.16 * n).clamp(0.78, 1.22);
  }

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
      paint
        ..shader = RadialGradient(
          center: l.focal,
          radius: 0.95,
          colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
          stops: const [0.0, 1.0],
        ).createShader(pool)
        // Soft, feathered edge so the pool melts into the room rather than
        // showing a hard ellipse.
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, math.min(l.a, l.b) * 0.22);
      canvas.drawOval(pool, paint);
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
        _paintLight(canvas, l, hole: true, mul: _flick(l));
      }
      canvas.restore();
    }

    for (final l in lights) {
      _paintLight(canvas, l, hole: false, mul: bloom * _flick(l));
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
            size: 13, color: _pal.text.withValues(alpha: 0.55)),
        const SizedBox(width: 4),
        Text(
          'Drag to rearrange',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _pal.text.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// A small, classy languagequiz wordmark stamped into the corner of a shared
/// room picture (replacing the drag hint while exporting).
class _RoomWatermark extends StatelessWidget {
  const _RoomWatermark();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/QuizLogo-02.svg', height: 16),
          const SizedBox(width: 6),
          const Text(
            'languagequiz',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: _cardText,
            ),
          ),
        ],
      ),
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
            color: _pal.text.withValues(alpha: 0.85),
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
  const _Shop({
    required this.collapsed,
    required this.onDrag,
    required this.onDragEnd,
    required this.onToggle,
  });

  /// When true the panel is too short for the store, so it shows a peek bar
  /// (grab handle + label) instead of the tabs/grid.
  final bool collapsed;

  /// Vertical drag of the grab handle (`delta.dy`) and the fling velocity at its
  /// end, which the page turns into resize + snap.
  final ValueChanged<double> onDrag;
  final ValueChanged<double> onDragEnd;

  /// Tapping the handle toggles between the default split and collapsed.
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final forSale = [
      for (final item in shopCatalog)
        if (Apartment.instance.isRevealed(item.id)) item,
    ];

    // A distinct, slightly darker panel surface (rounded top + soft shadow) so
    // the store lifts off the room background instead of blending into it.
    return Container(
      decoration: BoxDecoration(
        color: _pal.panel,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag this handle to resize the shop (it snaps to collapsed / middle
          // / full); tap it to toggle the room-focused view.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (d) => onDrag(d.primaryDelta ?? 0),
            onVerticalDragEnd: (d) => onDragEnd(d.primaryVelocity ?? 0),
            onTap: onToggle,
            child: SizedBox(
              height: 26,
              child: Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _pal.text.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          if (collapsed)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onToggle,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.storefront_rounded,
                          size: 18, color: _pal.text.withValues(alpha: 0.85)),
                      const SizedBox(width: 8),
                      Text(
                        'Furniture Shop',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _pal.text.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_up_rounded,
                          size: 20, color: _pal.text.withValues(alpha: 0.7)),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(child: _shopStore(forSale)),
        ],
      ),
    );
  }

  Widget _shopStore(List<ShopItem> forSale) {
    return DefaultTabController(
      length: shopCategories.length + 1, // "All" + one tab per category
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Not const — these read the night-aware palette and must rebuild
            // when night flips.
            _ShopHeader(),
            // A darker strip the category tabs sit on. Folder-style tabs: the
            // active one is the content colour at full height (merging into the
            // grid); inactive ones are a touch shorter and darker (recessed). We
            // draw the caps ourselves so each tab can be styled.
            Container(
              color: _pal.tabStrip,
              padding: const EdgeInsets.only(top: 8, left: 6, right: 6),
              child: Builder(
                builder: (context) {
                  final controller = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicator: const BoxDecoration(),
                      dividerColor: Colors.transparent,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                      tabs: [
                        _CategoryTab(
                            label: 'All', selected: controller.index == 0),
                        for (var i = 0; i < shopCategories.length; i++)
                          _CategoryTab(
                            label: shopCategories[i],
                            selected: controller.index == i + 1,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // The All tab (null items → resolves to the full live list).
                  _ShopGrid(
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

/// The room selector: one full-width button showing the current room. Tap it to
/// open the room picker — switch between owned rooms or buy a new one — which is
/// far easier on a phone than cramped paging chevrons. Lives inside the body's
/// [Apartment] listener, so it rebuilds when the room/ownership/night changes.
class _RoomBar extends StatelessWidget {
  const _RoomBar({required this.onTap, this.compact = false});

  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final apt = Apartment.instance;
    final room = apt.currentRoom;
    final count = apt.roomCount;
    final idx = apt.currentRoomIndex;

    return Padding(
      padding: compact
          ? const EdgeInsets.fromLTRB(8, 2, 8, 0)
          : const EdgeInsets.fromLTRB(8, 6, 8, 2),
      child: Material(
        color: _pal.tabStrip,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: compact ? 9 : 11,
            ),
            child: Row(
              children: [
                Text(room.emoji, style: TextStyle(fontSize: compact ? 16 : 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    room.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: compact ? 14 : 15,
                      color: _pal.text,
                    ),
                  ),
                ),
                if (count > 1) ...[
                  Text(
                    '${idx + 1}/$count',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _pal.text.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(Icons.expand_more_rounded, size: 22, color: _pal.text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The room picker: a full, scrollable sheet that always works regardless of how
/// many rooms you own. Owned rooms are tappable to switch into; rooms still for
/// sale show their price and buy on tap. Popped with the new room's name when one
/// is bought (so the page can welcome the learner) or with null on a plain
/// switch.
class _RoomPickerSheet extends StatelessWidget {
  const _RoomPickerSheet();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Apartment.instance, CoinWallet.instance]),
      builder: (context, _) {
        final apt = Apartment.instance;
        final owned = apt.ownedRooms;
        final buyable = apt.buyableRooms;
        final balance = CoinWallet.instance.balance;
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _pal.text.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '🛋️  Your rooms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _pal.text,
                        ),
                      ),
                      const Spacer(),
                      const CoinGlyph(size: 16, withShadow: false),
                      const SizedBox(width: 4),
                      Text(
                        '$balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: _pal.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final r in owned)
                              _OwnedRoomCard(
                                room: r,
                                current: r.id == apt.currentRoomId,
                              ),
                          ],
                        ),
                        if (buyable.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Get more rooms',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: _pal.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'A fresh space to furnish — your other rooms keep '
                            'everything you placed in them.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: _pal.textSoft,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final r in buyable) _RoomShopCard(room: r),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// One owned room in the picker: its preview + name, the current one outlined
/// with a check; tapping any other switches into it and closes the sheet.
class _OwnedRoomCard extends StatelessWidget {
  const _OwnedRoomCard({required this.room, required this.current});

  final RoomTheme room;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: Material(
        color: _pal.card,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: current
              ? null
              : () async {
                  await Apartment.instance.setCurrentRoom(room.id);
                  if (context.mounted) Navigator.of(context).pop();
                },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: current ? const Color(0xFFFFD54F) : _pal.cardBorder,
                width: current ? 2.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: _RoomPreview(room: room),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${room.emoji}  ${room.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: _pal.text,
                          ),
                        ),
                      ),
                      Icon(
                        current
                            ? Icons.check_circle_rounded
                            : Icons.login_rounded,
                        size: 18,
                        color: current
                            ? const Color(0xFFE0A92E)
                            : _pal.text.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomShopCard extends StatelessWidget {
  const _RoomShopCard({required this.room});

  final RoomTheme room;

  @override
  Widget build(BuildContext context) {
    final canAfford = CoinWallet.instance.balance >= room.price;
    return Container(
      width: 158,
      decoration: BoxDecoration(
        color: _pal.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _pal.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: _RoomPreview(room: room),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${room.emoji}  ${room.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    color: _pal.text,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD54F),
                      foregroundColor: const Color(0xFF6B4D1F),
                      disabledBackgroundColor: _pal.tabInactive,
                      disabledForegroundColor:
                          _pal.text.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: canAfford
                        ? () async {
                            await CoinWallet.instance.spend(room.price);
                            await Apartment.instance.buyRoom(room.id);
                            if (context.mounted) {
                              Navigator.of(context).pop(room.name);
                            }
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CoinGlyph(size: 15, withShadow: false),
                        const SizedBox(width: 5),
                        Text(
                          '${room.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
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

/// A little thumbnail of a room: its wall over its floor (theme colours, or the
/// cosy defaults), with the room emoji floating inside.
class _RoomPreview extends StatelessWidget {
  const _RoomPreview({required this.room});

  final RoomTheme room;

  @override
  Widget build(BuildContext context) {
    final wall = room.wallColor ?? const Color(0xFFF1E6D0);
    final floor = room.floorColor ?? const Color(0xFFD8B68A);
    return SizedBox(
      height: 104,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(flex: 62, child: ColoredBox(color: wall)),
              Expanded(flex: 38, child: ColoredBox(color: floor)),
            ],
          ),
          Center(
            child: Text(room.emoji, style: const TextStyle(fontSize: 40)),
          ),
        ],
      ),
    );
  }
}

/// One folder-style category tab: the active one is full height in the content
/// colour (merging into the grid); inactive ones are 4px shorter and a little
/// darker, so they read as recessed.
class _CategoryTab extends StatelessWidget {
  const _CategoryTab({required this.label, required this.selected});

  final String label;
  final bool selected;

  static const double _height = 38;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: selected ? _height : _height - 4,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _pal.panel : _pal.tabInactive,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              color: selected ? _pal.text : _pal.text.withValues(alpha: 0.6),
            ),
          ),
        ),
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
              color: _pal.text.withValues(alpha: 0.8),
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
          Text(
            '🛒 Furniture Shop',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: _pal.text,
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
        color: _pal.card.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _pal.text.withValues(alpha: 0.2)),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: _pal.text, fontSize: 12),
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
          color: _pal.card,
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
            pieceIcon(item, 58),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: _pal.text,
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
              child: pieceIcon(item, 88),
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
    // Cap the preview to a slice of the screen so the Save/Copy buttons below it
    // always stay on screen (above the home indicator), even on short phones.
    final previewMax = MediaQuery.sizeOf(context).height * 0.42;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
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
              constraints: BoxConstraints(maxHeight: previewMax),
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
    final strings = CourseSession.instance.strings;
    final learn = course.learnLocale.split('-').first; // 'de' / 'es'
    final speak = course.uiLang.name; // 'en' / 'es' / 'de'
    final langs = <(String code, String flag, bool isLearn)>[
      (learn, course.learnFlag, true),
      if (speak != learn) (speak, course.speakFlag, false),
    ];
    // The piece's name in the learner's own (UI) language, for snackbars.
    final localName = furnitureName(item.glyph, speak, fallback: item.name);
    final canAfford = CoinWallet.instance.balance >= item.price;
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
              child: pieceIcon(item, 76),
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
              strings.whatIsThisCalled,
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
                          ? strings.unflip
                          : strings.flip,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    // Give this exact piece away (it returns to the shop).
                    onPressed: () {
                      final messenger = ScaffoldMessenger.of(context);
                      Apartment.instance.donate(instanceId);
                      Navigator.of(context).pop();
                      messenger
                        ..clearSnackBars()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              strings.gaveAwayItem.replaceAll('{item}', localName),
                            ),
                          ),
                        );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD9645C),
                      side: const BorderSide(color: Color(0xFFD9645C)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
                    label: Text(strings.giveAway,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Buy another copy of the same piece — shows the cost.
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canAfford
                    ? () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        final ok =
                            await CoinWallet.instance.spend(item.price);
                        if (ok) await Apartment.instance.grant(item.id);
                        navigator.pop();
                        messenger
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(ok
                                ? strings.addedAnotherItem
                                    .replaceAll('{item}', localName)
                                : strings.notEnoughCoins),
                          ));
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  foregroundColor: const Color(0xFF5A3D00),
                  disabledBackgroundColor: const Color(0xFFE6E0EE),
                  disabledForegroundColor: const Color(0xFF9A8FB0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${strings.shopAnother}  ',
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    const CoinGlyph(size: 16, withShadow: false),
                    const SizedBox(width: 4),
                    Text('${item.price}',
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: _cocoa),
              child: Text(strings.gotIt,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
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
            pieceIcon(item, 50),
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
