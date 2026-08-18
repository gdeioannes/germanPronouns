// Visual preview of the candidate room-piece styles, written as a PNG via the
// golden machinery:
//
//   flutter test --update-goldens test/_style_preview.dart
//
// then open test/style_preview.png: one row per style variant (the shipped
// look, then A/B/C — see FlatPaintKit.style), the same twelve representative
// pieces in each. Real Windows fonts are registered under Roboto so the row
// labels render as glyphs instead of flutter_test's Ahem boxes. NOT a
// pass/fail golden — a developer preview, kept out of the suite by the
// underscore.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/widgets/flat_furniture.dart';

Future<void> _load(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File('C:\\Windows\\Fonts\\$f').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    // A family of its own — flutter_test maps the default 'Roboto' to its Ahem
    // stand-in, so the labels ask for 'Label' explicitly.
    await _load('Label', ['arial.ttf', 'arialbd.ttf']);
  });

  testWidgets('furniture style variants', (tester) async {
    // A spread across the shop: soft upholstery, wood, plants, water, screens,
    // a garden character, art & game pieces, and one of the People cast.
    const glyphs = [
      'sofa', 'armchair', 'lamp', 'bookshelf', 'plant', 'bathtub',
      'tv', 'mug', 'gnome', 'easel', 'pooltable', 'reader',
    ];
    final items = [
      for (final g in glyphs) shopCatalog.firstWhere((i) => i.glyph == g),
    ];
    const variants = <int, String>{
      0: 'Current — soft top-light',
      1: 'A — Luminous: warm light, cool shade',
      2: 'B — Keyline: luminous + a thin inked contour',
      3: 'C — Ceramic: luminous + a rim-light sheen',
    };

    await tester.binding.setSurfaceSize(const Size(1900, 740));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: const Color(0xFFF1E4CE),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in variants.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 2),
                  child: Text(
                    e.value,
                    style: const TextStyle(
                        fontFamily: 'Label',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23315E)),
                  ),
                ),
                Row(
                  children: [
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF4E6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FlatFurniture(
                              item: item, size: 150, style: e.key),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('style_preview.png'),
    );
  });

  testWidgets('furniture style variants, close up', (tester) async {
    // The same four variants on four pieces at large size, so the finish of
    // each style (gradient tint, contour weight, rim strength) is easy to
    // judge up close.
    const glyphs = ['sofa', 'plant', 'gnome', 'mug'];
    final items = [
      for (final g in glyphs) shopCatalog.firstWhere((i) => i.glyph == g),
    ];
    const variants = <int, String>{
      0: 'Current',
      1: 'A — Luminous',
      2: 'B — Keyline',
      3: 'C — Ceramic',
    };

    await tester.binding.setSurfaceSize(const Size(1200, 1330));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: const Color(0xFFF1E4CE),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in variants.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 2),
                  child: Text(
                    e.value,
                    style: const TextStyle(
                        fontFamily: 'Label',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23315E)),
                  ),
                ),
                Row(
                  children: [
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF4E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FlatFurniture(
                              item: item, size: 280, style: e.key),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('style_preview_closeup.png'),
    );
  });
}
