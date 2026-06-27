import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/models/coin_wallet.dart';
import 'package:german_pronouns_articles/models/settings_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => CoinWallet.instance.resetForTest());

  test('add() increases the balance and persists it', () async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 10});
    await CoinWallet.instance.load();
    expect(CoinWallet.instance.balance, 10);

    await CoinWallet.instance.add(5);
    expect(CoinWallet.instance.balance, 15);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(SettingsKeys.coinBalance), 15);
  });

  test('add() never decreases the balance (no-op for <= 0)', () async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 7});
    await CoinWallet.instance.load();

    await CoinWallet.instance.add(0);
    await CoinWallet.instance.add(-3);
    expect(CoinWallet.instance.balance, 7);
  });

  test('add() notifies listeners only when coins are actually added', () async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 0});
    await CoinWallet.instance.load();
    var notifications = 0;
    void listener() => notifications++;
    CoinWallet.instance.addListener(listener);

    await CoinWallet.instance.add(2);
    await CoinWallet.instance.add(0);
    CoinWallet.instance.removeListener(listener);

    expect(notifications, 1);
  });

  test('spend() deducts, persists, and refuses to overdraw', () async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 20});
    await CoinWallet.instance.load();

    expect(await CoinWallet.instance.spend(8), isTrue);
    expect(CoinWallet.instance.balance, 12);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(SettingsKeys.coinBalance), 12);

    // Can't spend more than the balance, and a non-positive amount is a no-op.
    expect(await CoinWallet.instance.spend(99), isFalse);
    expect(await CoinWallet.instance.spend(0), isFalse);
    expect(await CoinWallet.instance.spend(-5), isFalse);
    expect(CoinWallet.instance.balance, 12);
  });

  test('spend() can take the balance to exactly zero but never below', () async {
    SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 10});
    await CoinWallet.instance.load();

    expect(await CoinWallet.instance.spend(10), isTrue);
    expect(CoinWallet.instance.balance, 0);
    expect(await CoinWallet.instance.spend(1), isFalse);
    expect(CoinWallet.instance.balance, 0);
  });

  test('rollRibbonCoins pays a random amount in each ribbon tier band', () {
    // Roll many times so every result must land inside the tier's [min, max].
    for (var i = 0; i < 200; i++) {
      final bronze = CoinWallet.rollRibbonCoins(1); // laps 1–2 → bronze
      expect(bronze, inInclusiveRange(10, 30));
      final silver = CoinWallet.rollRibbonCoins(3); // laps 3–4 → silver
      expect(silver, inInclusiveRange(35, 70));
      final gold = CoinWallet.rollRibbonCoins(5); // laps 5+ → gold
      expect(gold, inInclusiveRange(100, 200));
    }
    // Tier boundaries match the ribbon tiers.
    expect(CoinWallet.rollRibbonCoins(2), inInclusiveRange(10, 30)); // bronze
    expect(CoinWallet.rollRibbonCoins(4), inInclusiveRange(35, 70)); // silver
    expect(CoinWallet.rollRibbonCoins(9), inInclusiveRange(100, 200)); // gold
  });

  test('first run seeds the wallet from existing per-quiz scores (clamped)',
      () async {
    // Two quizzes with saved scores, one of them negative from the old points
    // system; only the positive ones count, and the result is persisted.
    SharedPreferences.setMockInitialValues({
      'quiz_score': 12,
      'article_quiz_score': 8,
      'reading_quiz_score': -4,
      'unrelated_key': 99,
    });
    await CoinWallet.instance.load();

    expect(CoinWallet.instance.balance, 20); // 12 + 8, the -4 clamped out
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(SettingsKeys.coinBalance), 20);
  });

  test('an existing coin balance is not re-seeded from scores', () async {
    SharedPreferences.setMockInitialValues({
      SettingsKeys.coinBalance: 3,
      'quiz_score': 50,
    });
    await CoinWallet.instance.load();

    expect(CoinWallet.instance.balance, 3);
  });
}
