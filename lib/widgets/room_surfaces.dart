/// Flat renderers for the room's surfaces — the wall (wallpaper) and the floor
/// — plus a small [SurfaceSwatch] preview and a [pieceIcon] helper that draws a
/// shop item as either its furniture drawing or a surface swatch.
///
/// Surfaces are bought like any other piece (see `Apartment`); the room paints
/// the most-recently-bought floor / wall, falling back to the cosy default when
/// none is owned.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../data/shop_catalog.dart';
import 'flat_furniture.dart';

/// Shifts a colour's lightness, for flat shades from one base colour.
Color _shade(Color c, double amount) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

/// Paints the wall into [rect] for wallpaper [glyph] in [color] (or the cosy
/// cream default when [glyph]/[color] is null).
void paintWall(Canvas canvas, Rect rect, String? glyph, Color? color) {
  final p = Paint()..isAntiAlias = true;
  final base = color ?? const Color(0xFFF6EAD6);
  final top = _shade(base, 0.045);
  final bottom = _shade(base, -0.045);

  // Base wash (a soft vertical gradient) under every wallpaper.
  p.shader = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, bottom],
  ).createShader(rect);
  canvas.drawRect(rect, p);
  p.shader = null;

  switch (glyph) {
    case 'wallstripes':
      p.color = _shade(base, 0.07);
      const cols = 9;
      final stripeW = rect.width / cols;
      for (var i = 0; i < cols; i += 2) {
        canvas.drawRect(
          Rect.fromLTWH(rect.left + i * stripeW, rect.top, stripeW, rect.height),
          p,
        );
      }
    case 'wallbrick':
      final rows = (rect.height / (rect.width * 0.07)).ceil();
      final brickH = rect.height / rows;
      final brickW = rect.width / 6;
      p
        ..style = PaintingStyle.stroke
        ..strokeWidth = rect.width * 0.006
        ..color = _shade(base, 0.12);
      for (var r = 0; r < rows; r++) {
        final y = rect.top + r * brickH;
        canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), p);
        final offset = r.isEven ? 0.0 : brickW / 2;
        for (var x = offset; x < rect.width; x += brickW) {
          canvas.drawLine(
            Offset(rect.left + x, y),
            Offset(rect.left + x, y + brickH),
            p,
          );
        }
      }
      p.style = PaintingStyle.fill;
    case 'wallgeo':
      {
        final c1 = _shade(base, 0.08);
        final c2 = _shade(base, -0.08);
        const cols = 7;
        final w = rect.width / cols;
        p.style = PaintingStyle.fill;
        var row = 0;
        for (var y = rect.top; y < rect.bottom; y += w) {
          for (var i = 0; i < cols; i++) {
            final x = rect.left + i * w;
            p.color = (i + row).isEven ? c1 : c2;
            final path = Path()
              ..moveTo(x, y + w)
              ..lineTo(x + w / 2, y)
              ..lineTo(x + w, y + w)
              ..close();
            canvas.drawPath(path, p);
          }
          row++;
        }
      }
    case 'walldamask':
      {
        const cols = 4;
        final cell = rect.width / cols;
        p
          ..style = PaintingStyle.fill
          ..color = _shade(base, 0.10);
        var row = 0;
        for (var y = rect.top; y < rect.bottom; y += cell) {
          final xoff = row.isEven ? 0.0 : cell / 2;
          for (var x = rect.left - cell; x < rect.right + cell; x += cell) {
            final cx = x + xoff + cell / 2;
            final cy = y + cell / 2;
            final r = cell * 0.22;
            for (var k = 0; k < 4; k++) {
              final a = k * math.pi / 2;
              canvas.drawOval(
                  Rect.fromCenter(
                      center: Offset(cx + r * math.cos(a), cy + r * math.sin(a)),
                      width: r * 0.9, height: r * 1.5),
                  p);
            }
            canvas.drawCircle(Offset(cx, cy), r * 0.4, p);
          }
          row++;
        }
      }
    case 'wallbotanical':
      {
        const cols = 4;
        final cell = rect.width / cols;
        final leaf = _shade(base, 0.10);
        final stem = _shade(base, -0.06);
        var row = 0;
        for (var y = rect.top; y < rect.bottom; y += cell) {
          final xoff = row.isEven ? 0.0 : cell / 2;
          for (var x = rect.left - cell; x < rect.right + cell; x += cell) {
            final cx = x + xoff + cell / 2;
            final cy = y + cell / 2;
            p
              ..style = PaintingStyle.stroke
              ..strokeWidth = rect.width * 0.004
              ..color = stem;
            canvas.drawLine(
                Offset(cx, cy - cell * 0.3), Offset(cx, cy + cell * 0.3), p);
            p
              ..style = PaintingStyle.fill
              ..color = leaf;
            for (var k = 0; k < 3; k++) {
              final ly = cy - cell * 0.2 + k * cell * 0.2;
              canvas.drawOval(
                  Rect.fromCenter(
                      center: Offset(cx - cell * 0.12, ly),
                      width: cell * 0.2, height: cell * 0.1),
                  p);
              canvas.drawOval(
                  Rect.fromCenter(
                      center: Offset(cx + cell * 0.12, ly),
                      width: cell * 0.2, height: cell * 0.1),
                  p);
            }
          }
          row++;
        }
        p.style = PaintingStyle.fill;
      }
    default: // 'wallsolid' / null — just the wash.
      break;
  }
}

/// Paints the floor into [rect] for flooring [glyph] in [color] (or the warm
/// wood default when [glyph]/[color] is null).
///
/// With [perspective] on (the room — not the little flat shop swatch), the
/// pattern is drawn into its own flat space and then replayed tilted back into
/// the room, so the boards / tiles recede toward the wall and the floor reads as
/// a real receding plane rather than a flat strip.
void paintFloor(Canvas canvas, Rect rect, String? glyph, Color? color,
    {bool perspective = false}) {
  if (perspective) {
    // Record the flat pattern in local space (far edge at the top), then replay
    // it through a perspective tilt pivoting on the far edge — so the far edge
    // stays pinned to the wall seam (no gap) while the near edge swells toward
    // the viewer. The perspective strength scales with the floor height so the
    // foreshortening looks the same at any room size.
    final recorder = ui.PictureRecorder();
    paintFloor(Canvas(recorder), Offset.zero & rect.size, glyph, color);
    final pic = recorder.endRecording();
    final h = rect.height;
    final m = Matrix4.identity()
      ..setEntry(3, 2, 0.9 / h) // size-independent foreshortening
      ..translateByDouble(rect.width / 2, 0.0, 0.0, 1.0)
      ..rotateX(-0.62)
      ..translateByDouble(-rect.width / 2, 0.0, 0.0, 1.0);
    canvas
      ..save()
      ..clipRect(rect)
      ..translate(rect.left, rect.top)
      ..transform(m.storage)
      ..drawPicture(pic)
      ..restore();
    return;
  }
  final p = Paint()..isAntiAlias = true;
  final base = color ?? const Color(0xFFC8A06B);

  void wash(Color a, Color b) {
    p.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [a, b],
    ).createShader(rect);
    canvas.drawRect(rect, p);
    p.shader = null;
  }

  switch (glyph) {
    case 'floortile':
      const cols = 6;
      final cell = rect.width / cols;
      final dark = _shade(base, -0.06);
      final light = _shade(base, 0.08);
      var row = 0;
      for (var y = rect.top; y < rect.bottom; y += cell) {
        var col = 0;
        for (var x = rect.left; x < rect.right; x += cell) {
          p.color = (row + col).isEven ? light : dark;
          canvas.drawRect(Rect.fromLTWH(x, y, cell + 0.5, cell + 0.5), p);
          col++;
        }
        row++;
      }
    case 'floorcarpet':
      wash(_shade(base, 0.05), _shade(base, -0.03));
    case 'floormarble':
      wash(_shade(base, 0.06), _shade(base, -0.02));
      p
        ..style = PaintingStyle.stroke
        ..strokeWidth = rect.width * 0.006
        ..color = _shade(base, -0.16);
      for (final f in const [0.22, 0.5, 0.78]) {
        final y = rect.top + rect.height * f;
        final path = Path()..moveTo(rect.left, y);
        var step = 0;
        for (var x = 0.0; x <= rect.width; x += rect.width * 0.12) {
          path.lineTo(
            rect.left + x,
            y + (step.isEven ? rect.height * 0.03 : 0.0),
          );
          step++;
        }
        canvas.drawPath(path, p);
      }
      p.style = PaintingStyle.fill;
    case 'floorhex':
      {
        final dark = _shade(base, -0.07);
        final light = _shade(base, 0.07);
        final s = rect.width / 7;
        p.style = PaintingStyle.fill;
        var row = 0;
        for (var y = rect.top - s; y < rect.bottom + s; y += s * 0.86) {
          final xoff = row.isEven ? 0.0 : s * 0.75;
          var col = 0;
          for (var x = rect.left - s; x < rect.right + s; x += s * 1.5) {
            final cx = x + xoff;
            p.color = ((row + col) % 3 == 0) ? light : dark;
            final path = Path();
            for (var k = 0; k < 6; k++) {
              final a = k * math.pi / 3;
              final px = cx + s * 0.5 * math.cos(a);
              final py = y + s * 0.5 * math.sin(a);
              k == 0 ? path.moveTo(px, py) : path.lineTo(px, py);
            }
            canvas.drawPath(path..close(), p);
            col++;
          }
          row++;
        }
      }
    case 'floorazulejo':
      {
        const cols = 5;
        final cell = rect.width / cols;
        p.style = PaintingStyle.fill;
        for (var y = rect.top; y < rect.bottom; y += cell) {
          for (var x = rect.left; x < rect.right; x += cell) {
            p.color = const Color(0xFFEDF2F7);
            canvas.drawRect(Rect.fromLTWH(x, y, cell + 0.5, cell + 0.5), p);
            p.color = base;
            final cx = x + cell / 2;
            final cy = y + cell / 2;
            final r = cell * 0.18;
            for (var k = 0; k < 4; k++) {
              final a = k * math.pi / 2;
              canvas.drawCircle(
                  Offset(cx + r * math.cos(a), cy + r * math.sin(a)),
                  r * 0.7, p);
            }
            final path = Path()
              ..moveTo(cx, cy - r)
              ..lineTo(cx + r, cy)
              ..lineTo(cx, cy + r)
              ..lineTo(cx - r, cy)
              ..close();
            canvas.drawPath(path, p);
          }
        }
      }
    case 'floorherringbone':
      {
        final dark = _shade(base, -0.08);
        final light = _shade(base, 0.06);
        final pw = rect.width / 6;
        p.style = PaintingStyle.fill;
        for (var y = rect.top; y < rect.bottom; y += pw * 0.5) {
          var col = 0;
          for (var x = rect.left; x < rect.right; x += pw * 0.5) {
            p.color = col.isEven ? dark : light;
            canvas.save();
            canvas.translate(x + pw * 0.25, y + pw * 0.25);
            canvas.rotate(col.isEven ? math.pi / 4 : -math.pi / 4);
            canvas.drawRect(
                Rect.fromCenter(
                    center: Offset.zero, width: pw * 0.5, height: pw * 0.18),
                p);
            canvas.restore();
            col++;
          }
        }
      }
    default: // 'floorwood' / null — repeating planks (recede well in the room).
      wash(_shade(base, 0.07), _shade(base, -0.05));
      // Evenly-spaced board seams across the whole height, plus offset short
      // joints, so the boards keep their size whatever the floor height — and so
      // they read as many receding boards once the room tilts the floor back.
      final rows = math.max(3, (rect.height / (rect.width * 0.13)).round());
      final boardH = rect.height / rows;
      final boardW = rect.width / 4;
      p
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.6, rect.width * 0.004)
        ..color = _shade(base, -0.20).withValues(alpha: 0.55);
      for (var r = 0; r < rows; r++) {
        final y = rect.top + r * boardH;
        canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), p);
        // Staggered cross-joints between boards, brick-laid.
        final offset = r.isEven ? 0.0 : boardW / 2;
        for (var x = offset; x < rect.width; x += boardW) {
          canvas.drawLine(
            Offset(rect.left + x, y),
            Offset(rect.left + x, y + boardH),
            p..color = _shade(base, -0.14).withValues(alpha: 0.4),
          );
        }
        p.color = _shade(base, -0.20).withValues(alpha: 0.55);
      }
      p.style = PaintingStyle.fill;
  }
}

/// A small rounded preview of a surface item (floor or wall), for shop / giving
/// cards.
class SurfaceSwatch extends StatelessWidget {
  const SurfaceSwatch({super.key, required this.item, required this.size});

  final ShopItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.18),
      child: CustomPaint(
        size: Size.square(size),
        painter: _SwatchPainter(item),
      ),
    );
  }
}

class _SwatchPainter extends CustomPainter {
  _SwatchPainter(this.item);
  final ShopItem item;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    if (item.category == 'Walls') {
      paintWall(canvas, rect, item.glyph, item.color);
    } else {
      paintFloor(canvas, rect, item.glyph, item.color);
    }
  }

  @override
  bool shouldRepaint(_SwatchPainter old) =>
      old.item.id != item.id || old.item.color != item.color;
}

/// Draws shop item [item] at [size] — a surface swatch for floors / walls, the
/// flat furniture drawing otherwise.
Widget pieceIcon(ShopItem item, double size) => item.isSurface
    ? SurfaceSwatch(item: item, size: size)
    : FlatFurniture(item: item, size: size);
