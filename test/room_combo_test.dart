import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/data/combo_catalog.dart';
import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/models/apartment.dart';
import 'package:german_pronouns_articles/models/coin_wallet.dart';
import 'package:german_pronouns_articles/models/settings_keys.dart';
import 'package:german_pronouns_articles/pages/apartment_page.dart';

/// A placed piece for the matcher: 100 px pieces, so the pairing reach is
/// (100 + 100) / 2 × [kComboReach] = 85 px (and 105 px once sticky).
PlacedPiece _at(String iid, String glyph, double x, [double y = 0]) =>
    PlacedPiece(iid: iid, glyph: glyph, center: Offset(x, y), size: 100);

void main() {
  group('combo catalog', () {
    test('has a healthy number of combos with unique, stable ids', () {
      expect(roomCombos.length, greaterThanOrEqualTo(40));
      final ids = {for (final c in roomCombos) c.id};
      expect(ids.length, roomCombos.length, reason: 'duplicate combo id');
    });

    test('every combo names, describes and illustrates itself', () {
      for (final c in roomCombos) {
        expect(c.name, isNotEmpty, reason: c.id);
        expect(c.emoji, isNotEmpty, reason: c.id);
        expect(c.description, isNotEmpty, reason: c.id);
        expect(c.fx.colors, isNotEmpty, reason: c.id);
        expect(c.a, isNotEmpty, reason: c.id);
        expect(c.b, isNotEmpty, reason: c.id);
      }
    });

    test('every combo glyph is a real catalogue drawing', () {
      final knownGlyphs = {for (final item in shopCatalog) item.glyph};
      for (final c in roomCombos) {
        for (final glyph in {...c.a, ...c.b}) {
          expect(knownGlyphs, contains(glyph),
              reason: 'combo ${c.id} references unknown glyph "$glyph"');
        }
      }
    });

    test('combo sides never reference surfaces (floors/walls)', () {
      for (final c in roomCombos) {
        for (final glyph in {...c.a, ...c.b}) {
          final category = shopCategoryOf(glyph);
          expect(category, isNot(anyOf('Floors', 'Walls')),
              reason: 'combo ${c.id} uses surface glyph "$glyph"');
        }
      }
    });
  });

  group('matchCombos', () {
    test('a person next to the beehive makes the beekeeper', () {
      final matches = matchCombos([
        _at('p1', 'reader', 0),
        _at('b1', 'beehive', 80),
      ]);
      expect(matches.map((m) => m.combo.id), contains('beekeeper'));
    });

    test('nothing matches when the pieces are apart', () {
      final matches = matchCombos([
        _at('p1', 'reader', 0),
        _at('b1', 'beehive', 300),
      ]);
      expect(matches, isEmpty);
    });

    test('sticky combos keep matching a little further out (hysteresis)', () {
      // 95 px: outside the 85 px pairing reach, inside the 105 px release.
      final pieces = [_at('p1', 'reader', 0), _at('b1', 'beehive', 95)];
      expect(matchCombos(pieces), isEmpty);
      expect(
        matchCombos(pieces, sticky: const {'beekeeper'})
            .map((m) => m.combo.id),
        contains('beekeeper'),
      );
    });

    test('a piece never pairs with itself on a symmetric combo', () {
      // butterfly_garden is flowers × flowers — one lone flower is not a pair.
      expect(matchCombos([_at('f1', 'tulips', 0)]), isEmpty);
      expect(
        matchCombos([_at('f1', 'tulips', 0), _at('f2', 'daisies', 60)])
            .map((m) => m.combo.id),
        contains('butterfly_garden'),
      );
    });

    test('each combo lights up once, on its closest pair', () {
      final matches = matchCombos([
        _at('p1', 'reader', 0),
        _at('b1', 'beehive', 80),
        _at('b2', 'beehive', 40),
      ]);
      final beekeeper =
          matches.where((m) => m.combo.id == 'beekeeper').toList();
      expect(beekeeper, hasLength(1));
      expect(beekeeper.single.b.iid, 'b2'); // the nearer hive
    });

    test('colourways count — any glyph on a side triggers it', () {
      // The cat ('pet') by any fireplace colourway is still the toasty cat.
      final matches = matchCombos([
        _at('c1', 'pet', 0),
        _at('f1', 'fireplace', 70),
      ]);
      expect(matches.map((m) => m.combo.id), contains('toasty_cat'));
    });
  });

  group('Apartment combo discoveries', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      CoinWallet.instance.resetForTest();
      Apartment.instance.resetForTest();
      await CoinWallet.instance.load();
      await Apartment.instance.load();
    });

    test('discoverCombo is new once, then already known', () async {
      expect(Apartment.instance.discoveredCombos, isEmpty);
      expect(await Apartment.instance.discoverCombo('beekeeper'), isTrue);
      expect(await Apartment.instance.discoverCombo('beekeeper'), isFalse);
      expect(Apartment.instance.isComboDiscovered('beekeeper'), isTrue);
      expect(Apartment.instance.discoveredCombos, ['beekeeper']);
    });

    test('discoveries keep their order and survive a reload', () async {
      await Apartment.instance.discoverCombo('tea_time');
      await Apartment.instance.discoverCombo('beekeeper');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList(SettingsKeys.apartmentCombos),
          ['tea_time', 'beekeeper']);

      Apartment.instance.resetForTest();
      CoinWallet.instance.resetForTest();
      await CoinWallet.instance.load();
      await Apartment.instance.load();
      expect(Apartment.instance.discoveredCombos, ['tea_time', 'beekeeper']);
    });
  });

  group('discovery flow in the room', () {
    testWidgets('partners placed together celebrate, then join the list',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        SettingsKeys.coinBalance: 0,
        SettingsKeys.apartmentAnimate: false,
      });
      CoinWallet.instance.resetForTest();
      Apartment.instance.resetForTest();
      await CoinWallet.instance.load();
      await Apartment.instance.load();
      // A reader right next to the beehive — the beekeeper combo.
      final reader = await Apartment.instance.grant('reader_sage');
      final hive = await Apartment.instance.grant('beehive');
      await Apartment.instance.setPositions({
        reader: const Offset(0.40, 0.5),
        hive: const Offset(0.44, 0.5),
      });

      await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
      await tester.pump(); // the post-frame discovery fires
      await tester.pump(); // …and its celebration appears

      expect(find.text('New discovery!'), findsOneWidget);
      expect(find.text('Beekeeper'), findsOneWidget);
      expect(Apartment.instance.isComboDiscovered('beekeeper'), isTrue);

      await tester.pumpAndSettle(); // let the confetti finish
      expect(find.text('New discovery!'), findsNothing);

      // The trophy sheet lists the find — and only the find — plus the count.
      await tester.tap(find.byTooltip('Your discoveries'));
      await tester.pumpAndSettle();
      expect(find.text('Beekeeper'), findsOneWidget);
      expect(
        find.text('1 of ${roomCombos.length} discovered'),
        findsOneWidget,
      );
    });
  });
}
