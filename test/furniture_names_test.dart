import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/furniture_names.dart';
import 'package:german_pronouns_articles/data/shop_catalog.dart';

void main() {
  test('catalog grew well past 200 items, all with unique ids', () {
    expect(shopCatalog.length, greaterThan(220));
    final ids = {for (final i in shopCatalog) i.id};
    expect(ids.length, shopCatalog.length); // no duplicate ids
  });

  test('catalog is sorted cheapest first', () {
    for (var i = 1; i < shopCatalog.length; i++) {
      expect(shopCatalog[i].price, greaterThanOrEqualTo(shopCatalog[i - 1].price));
    }
  });

  test('every furniture glyph has a name in every taught language', () {
    // Surfaces (floors/walls) aren't double-tapped for an info card, so they
    // don't need translations.
    final glyphs = {
      for (final i in shopCatalog)
        if (!i.isSurface) i.glyph,
    };
    for (final g in glyphs) {
      final row = furnitureNames[g];
      expect(row, isNotNull, reason: 'no translations for glyph "$g"');
      for (final lang in kFurnitureLangs) {
        expect(row![lang], isNotNull, reason: 'missing $lang for "$g"');
        expect(row[lang], isNotEmpty, reason: 'empty $lang for "$g"');
      }
    }
  });

  test('furnitureName falls back to the given name for unknown glyphs', () {
    expect(furnitureName('table', 'de', fallback: 'X'), 'der Tisch');
    expect(furnitureName('table', 'fr', fallback: 'X'), 'table'); // → en
    expect(furnitureName('not-a-glyph', 'de', fallback: 'Fallback'), 'Fallback');
  });

  test('every category has items and every item maps to a known category', () {
    final present = {for (final i in shopCatalog) i.category};
    for (final c in shopCategories) {
      expect(present, contains(c), reason: 'no items in category "$c"');
    }
    for (final i in shopCatalog) {
      expect(shopCategories, contains(i.category),
          reason: '${i.id} has unknown category "${i.category}"');
    }
  });

  test('windows are in the catalog, on the wall, under Windows', () {
    final windows = [for (final i in shopCatalog) if (i.category == 'Windows') i];
    expect(windows.length, greaterThanOrEqualTo(3));
    expect(windows.every((i) => i.onWall), isTrue);
  });

  test('floors and walls exist and are surfaces', () {
    final floors = [for (final i in shopCatalog) if (i.category == 'Floors') i];
    final walls = [for (final i in shopCatalog) if (i.category == 'Walls') i];
    expect(floors.length, greaterThanOrEqualTo(3));
    expect(walls.length, greaterThanOrEqualTo(3));
    expect([...floors, ...walls].every((i) => i.isSurface), isTrue);
  });
}
