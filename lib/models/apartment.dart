import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/shop_catalog.dart';
import 'coin_wallet.dart';
import 'settings_keys.dart';

/// The learner's room: the furniture pieces they've placed ([pieces]), which
/// catalogue items have been *revealed* in the shop ([isRevealed] — they became
/// affordable once and now stay), and where each piece sits ([positionOf]).
///
/// Each placed piece is an **instance** with its own id, so the learner can buy
/// several of the same thing and arrange them independently. A piece is revealed
/// when its price is at most 20% of the coin balance, so the shop opens up
/// steadily as the learner earns. A [ChangeNotifier] (like [CoinWallet]) so the
/// room and shop rebuild the moment anything changes; it also listens to the
/// wallet to refresh reveals whenever coins change.
class Apartment extends ChangeNotifier {
  Apartment._();

  static final Apartment instance = Apartment._();

  /// Fraction of the balance an element's price must fit within to be revealed.
  static const double revealFraction = 0.20;

  /// Placed pieces, by instance id → catalogue id ([ShopItem.id]). Insertion
  /// order is the stacking order in the room.
  Map<String, String> _pieces = {};
  Set<String> _revealed = {};
  Map<String, Offset> _positions = {};
  Set<String> _flipped = {};
  bool _night = false;
  bool _animate = true;
  bool _loaded = false;
  int _seq = 0; // disambiguates instance ids minted in the same microsecond

  /// Placed pieces: instance id → catalogue id.
  Map<String, String> get pieces => _pieces;

  /// How many pieces are in the room.
  int get pieceCount => _pieces.length;

  Set<String> get revealedIds => _revealed;

  /// How many copies of catalogue item [catalogId] are placed.
  int countOf(String catalogId) =>
      _pieces.values.where((id) => id == catalogId).length;

  /// Whether at least one [catalogId] is placed.
  bool owns(String catalogId) => _pieces.values.contains(catalogId);

  /// The catalogue id of the floor / wall currently shown — the most recently
  /// bought one of that kind (insertion order = stacking order), or null for the
  /// cosy default. Donating it reveals the previous one underneath.
  String? get currentFloor => _topOfCategory('Floors');
  String? get currentWall => _topOfCategory('Walls');

  String? _topOfCategory(String category) {
    String? top;
    for (final catalogId in _pieces.values) {
      if (shopItemById(catalogId)?.category == category) top = catalogId;
    }
    return top;
  }

  bool isRevealed(String id) => _revealed.contains(id);

  /// Whether the room is shown at night — the lighting overlay darkens the room
  /// and light pieces (lamps, candles, fireplace…) cast warm pools.
  bool get isNight => _night;

  /// Whether the gentle idle animation of room pieces is playing.
  bool get animate => _animate;

  /// Turns the idle animation on/off. Persists + notifies.
  Future<void> setAnimate(bool on) async {
    if (_animate == on) return;
    _animate = on;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SettingsKeys.apartmentAnimate, _animate);
  }

  /// Whether the piece [instanceId] is mirrored horizontally.
  bool isFlipped(String instanceId) => _flipped.contains(instanceId);

  /// Mirrors / un-mirrors the piece [instanceId] horizontally. Persists +
  /// notifies so the room redraws.
  Future<void> toggleFlip(String instanceId) async {
    _flipped = {..._flipped};
    if (!_flipped.add(instanceId)) _flipped.remove(instanceId);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        SettingsKeys.apartmentFlipped, _flipped.toList());
  }

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _pieces = _loadPieces(prefs);
    _revealed =
        (prefs.getStringList(SettingsKeys.apartmentRevealed) ?? const [])
            .toSet();
    _positions = _decodeLayout(prefs.getString(SettingsKeys.apartmentLayout));
    _flipped =
        (prefs.getStringList(SettingsKeys.apartmentFlipped) ?? const []).toSet();
    _night = prefs.getBool(SettingsKeys.apartmentNight) ?? false;
    _animate = prefs.getBool(SettingsKeys.apartmentAnimate) ?? true;
    _loaded = true;
    // Remove-then-add so repeated loads (e.g. after resetForTest) don't stack
    // duplicate listeners.
    CoinWallet.instance.removeListener(_onWalletChanged);
    CoinWallet.instance.addListener(_onWalletChanged);
    await refreshReveals();
  }

  /// Reads the placed pieces, migrating the old "list of catalogue ids" format
  /// (one of each) by giving each piece an instance id equal to its catalogue id
  /// — which keeps its saved position (also keyed that way) intact.
  Map<String, String> _loadPieces(SharedPreferences prefs) {
    final raw = prefs.getString(SettingsKeys.apartmentItems);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return {for (final e in decoded.entries) e.key: e.value as String};
      } catch (_) {
        return {};
      }
    }
    final legacy = prefs.getStringList(SettingsKeys.apartmentItems);
    if (legacy != null) return {for (final id in legacy) id: id};
    return {};
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

  /// Records that the learner bought a [catalogId], adding a fresh instance to
  /// the room (you can own several of the same). Returns the new instance id.
  /// Persists + notifies.
  Future<String> grant(String catalogId) async {
    final instanceId = '$catalogId#${DateTime.now().microsecondsSinceEpoch}-${_seq++}';
    _pieces = {..._pieces, instanceId: catalogId};
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.apartmentItems, _encodePieces());
    return instanceId;
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

  /// The learner gave the piece [instanceId] away in the giving corner: it
  /// leaves the room. Its catalogue item stays revealed, so it can be bought
  /// again. Persists + notifies.
  Future<void> donate(String instanceId) async {
    if (!_pieces.containsKey(instanceId)) return;
    _pieces = {..._pieces}..remove(instanceId);
    _positions = {..._positions}..remove(instanceId);
    _flipped = {..._flipped}..remove(instanceId);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.apartmentItems, _encodePieces());
    await prefs.setString(SettingsKeys.apartmentLayout, _encodeLayout());
    await prefs.setStringList(
        SettingsKeys.apartmentFlipped, _flipped.toList());
  }

  /// Normalized (0..1) position of piece [instanceId] (a [catalogId] copy): where
  /// it was dragged, or a deterministic scattered default.
  Offset positionOf(String instanceId, String catalogId) =>
      _positions[instanceId] ?? _defaultPositionFor(instanceId, catalogId);

  Future<void> setPosition(String instanceId, Offset pos) =>
      setPositions({instanceId: pos});

  /// Records several positions at once and persists in a single write.
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

  /// A stable, scattered default spot derived from the instance id's hash, so
  /// unmoved pieces (even duplicates) spread out rather than stacking. Wall
  /// pieces default high on the wall; everything else stands on the floor.
  static Offset _defaultPositionFor(String instanceId, String catalogId) {
    final h = instanceId.hashCode;
    final x = 0.18 + ((h & 0xFFFF) / 0xFFFF) * 0.64;
    final onWall = shopItemById(catalogId)?.onWall ?? false;
    final y = onWall
        ? 0.20 + (((h >> 16) & 0xFF) / 0xFF) * 0.20 // 0.20–0.40, high on the wall
        : 0.66 + (((h >> 16) & 0xFF) / 0xFF) * 0.18; // 0.66–0.84, on the floor
    return Offset(x, y);
  }

  String _encodePieces() => jsonEncode(_pieces);

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
    _pieces = {};
    _revealed = {};
    _positions = {};
    _flipped = {};
    _night = false;
    _animate = true;
    _loaded = false;
    _seq = 0;
  }
}
