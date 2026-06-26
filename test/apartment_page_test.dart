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
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: coins, SettingsKeys.apartmentAnimate: false});
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

  testWidgets('can buy the same piece more than once', (tester) async {
    // A roomy (phone-tall) window so the shop grid isn't cramped and the card
    // stays clear of the "added to your room" snackbar between buys.
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpShop(tester); // 25 coins; only the cheapest piece is revealed

    // Buy the cheapest piece twice from its shop card.
    for (var n = 0; n < 2; n++) {
      await tester.tap(find.text(item.name).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
    }

    expect(Apartment.instance.countOf(item.id), 2);
    expect(CoinWallet.instance.balance, 25 - item.price * 2);
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
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: 50, SettingsKeys.apartmentAnimate: false});
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

  testWidgets('a room piece can be flipped from its card', (tester) async {
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: 50, SettingsKeys.apartmentAnimate: false});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await Apartment.instance.grant('table');
    final iid = Apartment.instance.pieces.keys.first;
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    final piece = find.byType(FlatFurniture).first;
    await tester.tap(piece);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(piece);
    await tester.pumpAndSettle();

    expect(Apartment.instance.isFlipped(iid), isFalse);
    await tester.tap(find.text('Flip'));
    await tester.pumpAndSettle();
    expect(Apartment.instance.isFlipped(iid), isTrue);
  });

  testWidgets('a room piece can be given away from its card', (tester) async {
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: 50, SettingsKeys.apartmentAnimate: false});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await Apartment.instance.grant('table');
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    final piece = find.byType(FlatFurniture).first;
    await tester.tap(piece);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(piece);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Give away'));
    await tester.pumpAndSettle();
    expect(Apartment.instance.owns('table'), isFalse);
  });

  testWidgets('can buy another of the same piece from its card',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: 50, SettingsKeys.apartmentAnimate: false});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await Apartment.instance.grant('table');
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    final piece = find.byType(FlatFurniture).first;
    await tester.tap(piece);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(piece);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Shop another  '));
    await tester.pumpAndSettle();

    final table = shopItemById('table')!;
    expect(Apartment.instance.countOf('table'), 2);
    expect(CoinWallet.instance.balance, 50 - table.price);
  });

  testWidgets('day/night toggle flips and persists the room mode',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: 50, SettingsKeys.apartmentAnimate: false});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    expect(Apartment.instance.isNight, isFalse);
    await tester.tap(find.byTooltip('Switch to night'));
    await tester.pumpAndSettle();

    expect(Apartment.instance.isNight, isTrue);
    expect(find.byTooltip('Switch to day'), findsOneWidget);
  });

  testWidgets('can buy a new room from the room picker', (tester) async {
    tester.view.physicalSize = const Size(1000, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({
      SettingsKeys.coinBalance: 100000, // enough for a (pricey) room
      SettingsKeys.apartmentAnimate: false,
    });
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    expect(Apartment.instance.roomCount, 1);

    // Open the room picker from the room bar (its trailing chevron).
    await tester.tap(find.byIcon(Icons.expand_more_rounded));
    await tester.pumpAndSettle();
    expect(find.text('🛋️  Your rooms'), findsOneWidget);

    // Buy the first room offered (tap its price button).
    final cheapest = Apartment.instance.buyableRooms.first;
    await tester.tap(find.text('${cheapest.price}').first);
    await tester.pumpAndSettle();

    expect(Apartment.instance.roomCount, 2);
    expect(Apartment.instance.currentRoomId, cheapest.id); // moved straight in
    expect(CoinWallet.instance.balance, 100000 - cheapest.price);
  });

  testWidgets('giving a piece away in the giving corner removes it',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {SettingsKeys.coinBalance: 50, SettingsKeys.apartmentAnimate: false});
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    await Apartment.instance.grant('table');
    await tester.pumpWidget(const MaterialApp(home: ApartmentPage()));
    await tester.pumpAndSettle();

    // Open the giving corner and give the table away.
    await tester.tap(find.byTooltip('Give away furniture'));
    await tester.pumpAndSettle();
    expect(find.text('Tap a piece to give it away'), findsOneWidget);

    await tester.tap(find.text('Table').first);
    await tester.pump(); // run donate + start the heart burst
    expect(Apartment.instance.owns('table'), isFalse);

    await tester.pumpAndSettle(); // let the hearts finish
  });
}
