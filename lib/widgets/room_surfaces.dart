/// Flat renderers for the room's surfaces — the wall (wallpaper) and the floor
/// — plus a small [SurfaceSwatch] preview and a [pieceIcon] helper that draws a
/// shop item as either its furniture drawing or a surface swatch.
///
/// Surfaces are bought like any other piece (see `Apartment`); the room paints
/// the most-recently-bought floor / wall, falling back to the cosy default when
/// none is owned.
library;

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
    default: // 'wallsolid' / null — just the wash.
      break;
  }
}

/// Paints the floor into [rect] for flooring [glyph] in [color] (or the warm
/// wood default when [glyph]/[color] is null).
void paintFloor(Canvas canvas, Rect rect, String? glyph, Color? color) {
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
    default: // 'floorwood' / null — planks.
      wash(_shade(base, 0.07), _shade(base, -0.05));
      p
        ..style = PaintingStyle.stroke
        ..strokeWidth = rect.width * 0.0045
        ..color = _shade(base, -0.18).withValues(alpha: 0.5);
      for (final f in const [0.30, 0.58, 0.86]) {
        final y = rect.top + rect.height * f;
        canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), p);
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
