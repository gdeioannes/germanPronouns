import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/data/shop_catalog.dart';
import 'package:german_pronouns_articles/models/apartment.dart';
import 'package:german_pronouns_articles/models/coin_wallet.dart';
import 'package:german_pronouns_articles/models/settings_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    CoinWallet.instance.resetForTest();
    Apartment.instance.resetForTest();
  });

  Future<void> loadWith(int coins) async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: coins});
    await CoinWallet.instance.load();
    await Apartment.instance.load();
  }

  test('furniture is revealed when price <= 20% of balance', () async {
    await loadWith(300); // budget = 60: cheap pieces show, the priciest don't

    expect(Apartment.instance.isRevealed(shopCatalog.first.id), isTrue);
    expect(Apartment.instance.isRevealed(shopCatalog.last.id), isFalse);
    expect(Apartment.instance.revealedIds.length,
        inExclusiveRange(0, shopCatalog.length));
  });

  test('revealed furniture stays revealed after the balance drops', () async {
    await loadWith(500);
    final revealedAtPeak = Apartment.instance.revealedIds.length;
    expect(revealedAtPeak, greaterThan(0));

    // Spend everything; the wallet listener refreshes reveals but never removes.
    await CoinWallet.instance.spend(500);
    expect(Apartment.instance.revealedIds.length, revealedAtPeak);
    expect(Apartment.instance.isRevealed(shopCatalog.first.id), isTrue);
  });

  test('earning more reveals more, and it persists', () async {
    await loadWith(20); // budget = 4, nothing affordable yet
    final atStart = Apartment.instance.revealedIds.length;

    await CoinWallet.instance.add(2000); // budget = 404
    expect(Apartment.instance.revealedIds.length, greaterThan(atStart));

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList(SettingsKeys.apartmentRevealed)?.length,
      Apartment.instance.revealedIds.length,
    );
  });

  test('revealAll() reveals every piece (the roomroom cheat)', () async {
    await loadWith(0); // nothing affordable, so nothing revealed yet
    expect(Apartment.instance.revealedIds, isEmpty);

    await Apartment.instance.revealAll();
    expect(Apartment.instance.revealedIds.length, shopCatalog.length);

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList(SettingsKeys.apartmentRevealed)?.length,
      shopCatalog.length,
    );
  });

  test('grant() records ownership and persists', () async {
    await loadWith(100);
    final id = shopCatalog.first.id;

    await Apartment.instance.grant(id);
    expect(Apartment.instance.owns(id), isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList(SettingsKeys.apartmentItems), contains(id));
  });

  test('positions clamp, persist and reload', () async {
    await loadWith(100);
    final id = shopCatalog.first.id;

    await Apartment.instance.setPosition(id, const Offset(1.4, -0.2));
    expect(Apartment.instance.positionOf(id), const Offset(1.0, 0.0));

    await Apartment.instance.setPosition(id, const Offset(0.3, 0.7));
    Apartment.instance.resetForTest();
    CoinWallet.instance.resetForTest();
    await CoinWallet.instance.load();
    await Apartment.instance.load();
    expect(Apartment.instance.positionOf(id), const Offset(0.3, 0.7));
  });
}
