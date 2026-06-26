import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/models/apartment.dart';
import 'package:german_pronouns_articles/models/coin_wallet.dart';
import 'package:german_pronouns_articles/models/settings_keys.dart';
import 'package:german_pronouns_articles/pages/apartment_page.dart';
import 'package:german_pronouns_articles/widgets/flat_furniture.dart';

void main() {
  // Balance 25 -> budget 5 -> exactly the cheapest piece (price 5) is in the
  // shop, so its card is easy to find and tap.
  final item = shopCatalog.first;

  Future<void> pumpShop(WidgetTester tester, {int coins = 25}) async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: coins});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('buying a piece spends the coins and adds it to the room',
      (tester) async {
    await pumpShop(tester);
    expect(Apartment.instance.isRevealed(item.id), isTrue);

    // Open the buy dialog from the shop card (labelled with the item name).
    await tester.tap(find.text(item.name).first);
    await tester.pumpAndSettle();

    // The dialog's only FilledButton is the Buy button.
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(Apartment.instance.owns(item.id), isTrue);
    expect(CoinWallet.instance.balance, 25 - item.price);
  });

  testWidgets("can't buy a piece you can no longer afford", (tester) async {
    // Reveal lots at a high balance, then spend down so a revealed piece is
    // unaffordable; the buy dialog disables its Buy button.
    await pumpShop(tester, coins: 500);
    await CoinWallet.instance.spend(CoinWallet.instance.balance - 1);
    await tester.pumpAndSettle();

    await tester.tap(find.text(item.name).first);
    await tester.pumpAndSettle();

    expect(find.text('Not enough coins'), findsOneWidget);
    final buyButton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(buyButton.onPressed, isNull);
    expect(Apartment.instance.owns(item.id), isFalse);
  });

  testWidgets('double-tapping a room piece shows its name card', (tester) async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 50});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    // Own the table so it sits in the room (the room's pieces are built before
    // the shop, so the first FlatFurniture is in the room).
    await Apartment.instance.grant('table');
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    final piece = find.byType(FlatFurniture).first;
    await tester.tap(piece);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(piece);
    await tester.pumpAndSettle();

    // The card shows the word in the learned language (German, by default).
    expect(find.text('Got it'), findsOneWidget);
    expect(find.text('der Tisch'), findsOneWidget);
  });
}
