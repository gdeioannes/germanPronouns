// Visual gallery for the People characters. Renders one of every People glyph
// (a neutral frame of its idle motion) onto a warm room background and writes a
// PNG via the golden machinery, so the drawings can be eyeballed:
//
//   flutter test --update-goldens test/_people_gallery.dart
//
// then open test/people_gallery.png. It is NOT a pass/fail golden — it is a
// developer preview, kept out of the normal suite by the leading underscore.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/widgets/flat_furniture.dart';

void main() {
  testWidgets('people gallery', (tester) async {
    final seen = <String>{};
    final items = [
      for (final i in shopCatalog)
        if (i.category == 'People' && seen.add(i.glyph)) i,
    ];

    const anim = AlwaysStoppedAnimation(0.32); // a mid frame of the idle motion

    await tester.binding.setSurfaceSize(const Size(1040, 1100));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: const Color(0xFFF1E4CE),
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final item in items)
                SizedBox(
                  width: 232,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF4E6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FlatFurniture(
                          item: item,
                          size: 200,
                          animation: anim,
                        ),
                      ),
                      Text('${item.glyph}  ·  ${item.name}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('people_gallery.png'),
    );
  });
}
