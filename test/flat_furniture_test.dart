import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/widgets/flat_furniture.dart';

void main() {
  testWidgets('every catalog item paints without throwing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: [
              for (final item in shopCatalog) FlatFurniture(item: item, size: 64),
            ],
          ),
        ),
      ),
    );

    // A throwing CustomPainter surfaces as a flutterError on pump; assert none
    // happened and that one painter exists per catalog item.
    expect(tester.takeException(), isNull);
    expect(find.byType(FlatFurniture), findsNWidgets(shopCatalog.length));
  });

  test('the People category has 50+ calm characters', () {
    final people = shopCatalog.where((i) => i.category == 'People').toList();
    expect(people.length, greaterThanOrEqualTo(50));
    // They're placeable characters, not room surfaces, and hang on the floor.
    expect(people.every((i) => !i.isSurface), isTrue);
    expect(people.every((i) => !i.onWall), isTrue);
  });

  test('only in-character glyphs report an idle animation', () {
    // A flame, a fish tank and a fan animate; plain furniture does not.
    expect(furnitureHasIdleAnimation('candle'), isTrue);
    expect(furnitureHasIdleAnimation('aquarium'), isTrue);
    expect(furnitureHasIdleAnimation('fan'), isTrue);
    expect(furnitureHasIdleAnimation('window'), isTrue);
    expect(furnitureHasIdleAnimation('table'), isFalse);
    expect(furnitureHasIdleAnimation('sofa'), isFalse);
  });

  testWidgets('animated glyphs repaint across the idle clock without throwing',
      (tester) async {
    final controller = AnimationController(
      vsync: const TestVSync(),
      duration: const Duration(seconds: 6),
    )..value = 0.0;
    addTearDown(controller.dispose);

    // One piece per animated drawing (flame, fish + bubble, steam, fan, clock,
    // window, screen…), so every animated code path is exercised.
    final glyphs = {for (final i in shopCatalog) i.glyph}
        .where(furnitureHasIdleAnimation);
    final items = [
      for (final g in glyphs) shopCatalog.firstWhere((i) => i.glyph == g),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: [
              for (final item in items)
                FlatFurniture(item: item, size: 80, animation: controller),
            ],
          ),
        ),
      ),
    );

    // Advance the clock through the cycle, including the wrap back to 0.
    for (final v in [0.0, 0.25, 0.5, 0.75, 0.999, 0.0]) {
      controller.value = v;
      await tester.pump();
    }
    expect(tester.takeException(), isNull);
  });
}
