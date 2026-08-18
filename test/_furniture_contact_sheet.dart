// Contact sheet of the full furniture catalog in the shipped style, written as
// paged PNGs via the golden machinery:
//
//   flutter test --update-goldens test/_furniture_contact_sheet.dart
//
// then open test/furniture_sheet_*.png and scan for any piece the current
// finish breaks (seams between overlapping shapes, heavy contours on tiny
// details…). Real Windows fonts are registered so the glyph labels are
// readable. NOT a pass/fail golden — a developer preview, kept out of the
// suite by the underscore.
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
    await _load('Label', ['arial.ttf', 'arialbd.ttf']);
  });

  testWidgets('full catalog contact sheet', (tester) async {
    // One item per distinct glyph, in catalog order (colourway variants share
    // a drawing, so one of each is enough).
    final seen = <String>{};
    final items = [
      for (final i in shopCatalog)
        if (seen.add(i.glyph)) i,
    ];
    const anim = AlwaysStoppedAnimation(0.32); // a mid frame of idle motion

    const cols = 8, rows = 6, perPage = cols * rows;
    final pages = (items.length / perPage).ceil();
    await tester.binding.setSurfaceSize(const Size(1024, 850));

    for (var p = 0; p < pages; p++) {
      final page = items.skip(p * perPage).take(perPage).toList();
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
            color: const Color(0xFFF1E4CE),
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final item in page)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF4E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FlatFurniture(
                            item: item,
                            size: 118,
                            animation:
                                furnitureHasIdleAnimation(item.glyph)
                                    ? anim
                                    : null),
                      ),
                      Text(item.glyph,
                          style: const TextStyle(
                              fontFamily: 'Label', fontSize: 11)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('furniture_sheet_${p + 1}.png'),
      );
    }
  });
}
