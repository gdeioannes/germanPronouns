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
}
