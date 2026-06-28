// Visual gallery for the Plants shelf. Renders one of every plant glyph (a
// neutral frame of its idle animation) onto a warm room background and writes a
// PNG via the golden machinery, so the drawings can be eyeballed:
//
//   flutter test --update-goldens test/_gallery.dart
//
// then open test/plants_gallery.png. It is NOT a pass/fail golden — it is a
// developer preview, kept out of the normal suite by the leading underscore.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/widgets/flat_furniture.dart';

void main() {
  testWidgets('plants gallery', (tester) async {
    // One representative item per Plants glyph, in catalog order.
    final seen = <String>{};
    final items = [
      for (final i in shopCatalog)
        if (i.category == 'Plants' && seen.add(i.glyph)) i,
    ];

    const anim = AlwaysStoppedAnimation(0.32); // a mid frame of the idle motion

    await tester.binding.setSurfaceSize(const Size(1040, 1000));
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
                      Text(item.glyph,
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
      matchesGoldenFile('plants_gallery.png'),
    );
  });

  // Loop-continuity check: render the pieces that move a pollinator across the
  // whole idle cycle (with a non-zero phase, as the room desyncs each piece). If
  // the motion loops seamlessly the last column (t→1) sits right next to the
  // first (t=0) with no teleport.
  testWidgets('plants loop filmstrip', (tester) async {
    final strip = [
      for (final g in const ['plant', 'monstera', 'citrustree', 'palm'])
        shopCatalog.firstWhere((i) => i.glyph == g),
    ];
    const frames = [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 0.97];

    await tester.binding.setSurfaceSize(const Size(980, 560));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: const Color(0xFFF1E4CE),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in strip)
                Row(
                  children: [
                    for (final f in frames)
                      FlatFurniture(
                        item: item,
                        size: 130,
                        phase: 0.37,
                        animation: AlwaysStoppedAnimation(f),
                      ),
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
      matchesGoldenFile('plants_loop.png'),
    );
  });
}
