import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/shop_catalog.dart';
import 'coin_wallet.dart';
import 'settings_keys.dart';

/// The learner's room: which furniture they own ([owns]), which pieces have been
/// *revealed* in the shop ([isRevealed] — they became affordable once and now
/// stay), and where each owned piece sits ([positionOf]).
///
/// A piece is revealed when its price is at most 20% of the coin balance, so the
/// shop opens up steadily as the learner earns. A [ChangeNotifier] (like
/// [CoinWallet]) so the room and shop rebuild the moment anything changes; it
/// also listens to the wallet to refresh reveals whenever coins change.
class Apartment extends ChangeNotifier {
  Apartment._();

  static final Apartment instance = Apartment._();

  /// Fraction of the balance an element's price must fit within to be revealed.
  static const double revealFraction = 0.20;

  Set<String> _owned = {};
  Set<String> _revealed = {};
  Map<String, Offset> _positions = {};
  bool _night = false;
  bool _loaded = false;

  Set<String> get ownedIds => _owned;
  Set<String> get revealedIds => _revealed;
  bool owns(String id) => _owned.contains(id);
  bool isRevealed(String id) => _revealed.contains(id);

  /// Whether the room is shown at night — the lighting overlay darkens the room
  /// and light pieces (lamps, candles, fireplace…) cast warm pools.
  bool get isNight => _night;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _owned = (prefs.getStringList(SettingsKeys.apartmentItems) ?? const [])
        .toSet();
    _revealed =
        (prefs.getStringList(SettingsKeys.apartmentRevealed) ?? const [])
            .toSet();
    _positions = _decodeLayout(prefs.getString(SettingsKeys.apartmentLayout));
    _night = prefs.getBool(SettingsKeys.apartmentNight) ?? false;
    _loaded = true;
    // Remove-then-add so repeated loads (e.g. after resetForTest) don't stack
    // duplicate listeners.
    CoinWallet.instance.removeListener(_onWalletChanged);
    CoinWallet.instance.addListener(_onWalletChanged);
    await refreshReveals();
  }

  void _onWalletChanged() {
    refreshReveals();
  }

  /// Reveals any piece now affordable (price ≤ [revealFraction] of the balance)
  /// and keeps it revealed forever. Persists + notifies if anything newly
  /// appeared.
  Future<void> refreshReveals() async {
    final budget = CoinWallet.instance.balance * revealFraction;
    final next = {..._revealed};
    for (final item in shopCatalog) {
      if (item.price <= budget) next.add(item.id);
    }
    if (next.length == _revealed.length) return;
    _revealed = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SettingsKeys.apartmentRevealed, _revealed.toList());
  }

  /// Debug: reveal every piece at once (the "roomroom" cheat), bypassing the
  /// earn-as-you-go reveal gate. Persists + notifies.
  Future<void> revealAll() async {
    final all = {for (final item in shopCatalog) item.id};
    if (_revealed.containsAll(all)) return;
    _revealed = all;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SettingsKeys.apartmentRevealed, _revealed.toList());
  }

  /// Records that the learner bought [id]. Persists + notifies so it drops into
  /// the room and leaves the shop.
  Future<void> grant(String id) async {
    if (_owned.contains(id)) return;
    _owned = {..._owned, id};
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SettingsKeys.apartmentItems, _owned.toList());
  }

  /// Switches the room between day and night. Persists + notifies so the
  /// lighting overlay updates.
  Future<void> setNight(bool night) async {
    if (_night == night) return;
    _night = night;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SettingsKeys.apartmentNight, _night);
  }

  /// The learner gave [id] away in the giving corner: drops ownership so it
  /// leaves the room. It stays revealed, so it returns to the shop to buy again.
  /// Persists + notifies.
  Future<void> donate(String id) async {
    if (!_owned.contains(id)) return;
    _owned = {..._owned}..remove(id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SettingsKeys.apartmentItems, _owned.toList());
  }

  /// Normalized (0..1) position of [id] in the room: where the learner dragged
  /// it, or a deterministic scattered default keyed off the id.
  Offset positionOf(String id) => _positions[id] ?? _defaultPositionFor(id);

  Future<void> setPosition(String id, Offset pos) => setPositions({id: pos});

  /// Records several positions at once and persists in a single write — used
  /// after a drag that pushed neighbours via the collision system.
  Future<void> setPositions(Map<String, Offset> positions) async {
    if (positions.isEmpty) return;
    final next = {..._positions};
    for (final e in positions.entries) {
      next[e.key] = Offset(e.value.dx.clamp(0.0, 1.0), e.value.dy.clamp(0.0, 1.0));
    }
    _positions = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.apartmentLayout, _encodeLayout());
  }

  /// A stable, scattered default spot derived from the id's hash, so unmoved
  /// pieces spread out rather than stacking. Wall pieces (paintings, clock,
  /// mirror) default high on the wall; everything else stands on the floor.
  static Offset _defaultPositionFor(String id) {
    final h = id.hashCode;
    final x = 0.18 + ((h & 0xFFFF) / 0xFFFF) * 0.64;
    final onWall = shopItemById(id)?.onWall ?? false;
    final y = onWall
        ? 0.20 + (((h >> 16) & 0xFF) / 0xFF) * 0.20 // 0.20–0.40, high on the wall
        : 0.66 + (((h >> 16) & 0xFF) / 0xFF) * 0.18; // 0.66–0.84, on the floor
    return Offset(x, y);
  }

  String _encodeLayout() => jsonEncode({
    for (final e in _positions.entries) e.key: [e.value.dx, e.value.dy],
  });

  static Map<String, Offset> _decodeLayout(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return {
        for (final e in decoded.entries)
          e.key: Offset(
            (e.value[0] as num).toDouble(),
            (e.value[1] as num).toDouble(),
          ),
      };
    } catch (_) {
      return {};
    }
  }

  /// Test-only reset of the in-memory state (does not touch storage).
  @visibleForTesting
  void resetForTest() {
    _owned = {};
    _revealed = {};
    _positions = {};
    _night = false;
    _loaded = false;
  }
}
