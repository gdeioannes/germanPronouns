import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/room_catalog.dart';
import '../data/shop_catalog.dart';
import 'coin_wallet.dart';
import 'settings_keys.dart';

/// The learner's apartment: a set of owned **rooms**, each with its own placed
/// furniture, and a global pool of *revealed* shop items.
///
/// Furniture is owned **per room** ([pieces], [positionOf]…), so the piece-level
/// API ([grant], [donate], [currentFloor]…) always acts on the [currentRoom].
/// Switching rooms ([setCurrentRoom]) or buying one ([buyRoom]) just changes
/// which room those operate on. Reveals ([isRevealed]) and the day/night and
/// animation toggles are global to the whole apartment.
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

  // Per-room state, keyed by room id (see [roomCatalog]).
  Map<String, Map<String, String>> _pieces = {}; // room → (iid → catalogId)
  Map<String, Map<String, Offset>> _positions = {}; // room → (iid → pos)
  Map<String, Set<String>> _flipped = {}; // room → mirrored iids

  // Owned rooms (insertion = display order is taken from [roomCatalog]) and the
  // one currently shown.
  List<String> _ownedRooms = [kStarterRoomId];
  String _currentRoom = kStarterRoomId;

  Set<String> _revealed = {};
  bool _night = false;
  bool _animate = true;
  bool _effects = true;
  bool _loaded = false;
  int _seq = 0; // disambiguates instance ids minted in the same microsecond

  // ── Rooms ──────────────────────────────────────────────────────────────────

  /// The rooms the learner owns, in catalogue (display) order.
  List<RoomTheme> get ownedRooms =>
      [for (final r in roomCatalog) if (_ownedRooms.contains(r.id)) r];

  /// How many rooms the learner owns.
  int get roomCount => _ownedRooms.length;

  /// The room currently shown/edited.
  RoomTheme get currentRoom => roomById(_currentRoom) ?? roomCatalog.first;
  String get currentRoomId => _currentRoom;

  /// Index of the current room within [ownedRooms] (for the carousel).
  int get currentRoomIndex {
    final i = ownedRooms.indexWhere((r) => r.id == _currentRoom);
    return i < 0 ? 0 : i;
  }

  bool ownsRoom(String id) => _ownedRooms.contains(id);

  /// Rooms not yet owned, cheapest first (what the room shop offers).
  List<RoomTheme> get buyableRooms =>
      [for (final r in roomCatalog) if (!_ownedRooms.contains(r.id)) r];

  /// The cheapest room still for sale, or null when every room is owned.
  RoomTheme? get nextRoomForSale =>
      buyableRooms.isEmpty ? null : buyableRooms.first;

  /// Switches to an owned room. Persists + notifies.
  Future<void> setCurrentRoom(String id) async {
    if (_currentRoom == id || !_ownedRooms.contains(id)) return;
    _currentRoom = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.apartmentCurrentRoom, _currentRoom);
  }

  /// Switches to the owned room at [index] in [ownedRooms] (carousel paging).
  Future<void> setCurrentRoomIndex(int index) async {
    final rooms = ownedRooms;
    if (index < 0 || index >= rooms.length) return;
    await setCurrentRoom(rooms[index].id);
  }

  /// Buys the room [id] (the caller spends the coins) and switches to it — a
  /// fresh, empty room to furnish. Persists + notifies.
  Future<void> buyRoom(String id) async {
    if (_ownedRooms.contains(id) || roomById(id) == null) return;
    _ownedRooms = [..._ownedRooms, id];
    _currentRoom = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(SettingsKeys.apartmentRooms, _ownedRooms);
    await prefs.setString(SettingsKeys.apartmentCurrentRoom, _currentRoom);
  }

  // ── Pieces (always the current room) ─────────────────────────────────────────

  /// Placed pieces in the current room: instance id → catalogue id.
  Map<String, String> get pieces => _pieces[_currentRoom] ?? const {};

  /// How many pieces are in the current room.
  int get pieceCount => pieces.length;

  Set<String> get revealedIds => _revealed;

  /// How many copies of catalogue item [catalogId] are placed in this room.
  int countOf(String catalogId) =>
      pieces.values.where((id) => id == catalogId).length;

  /// Whether at least one [catalogId] is placed in this room.
  bool owns(String catalogId) => pieces.values.contains(catalogId);

  /// The catalogue id of the floor / wall currently shown in this room — the
  /// most recently bought surface of that kind (insertion = stacking order), or
  /// null to fall back to the room theme's default look.
  String? get currentFloor => _topOfCategory('Floors');
  String? get currentWall => _topOfCategory('Walls');

  String? _topOfCategory(String category) {
    String? top;
    for (final catalogId in pieces.values) {
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

  /// Whether the GPU-heavy visual effects — blurred contact shadows and blurred
  /// light glows — are drawn. Off = a flatter look but far less GPU work, for
  /// weak devices.
  bool get effects => _effects;

  /// Turns the blur effects on/off. Persists + notifies.
  Future<void> setEffects(bool on) async {
    if (_effects == on) return;
    _effects = on;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SettingsKeys.apartmentEffects, _effects);
  }

  /// Whether the piece [instanceId] (in this room) is mirrored horizontally.
  bool isFlipped(String instanceId) =>
      _flipped[_currentRoom]?.contains(instanceId) ?? false;

  /// Mirrors / un-mirrors the piece [instanceId] in this room. Persists +
  /// notifies so the room redraws.
  Future<void> toggleFlip(String instanceId) async {
    final set = {...?_flipped[_currentRoom]};
    if (!set.add(instanceId)) set.remove(instanceId);
    _flipped = {..._flipped, _currentRoom: set};
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        SettingsKeys.apartmentFlippedRooms, _encodeFlipped());
  }

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();

    _ownedRooms = _loadRooms(prefs);
    _currentRoom = prefs.getString(SettingsKeys.apartmentCurrentRoom) ??
        kStarterRoomId;
    if (!_ownedRooms.contains(_currentRoom)) _currentRoom = _ownedRooms.first;

    // Items used to be stored as a `StringList` (oldest), then a flat JSON map,
    // now a per-room JSON map. Read the JSON string if present, else fall back to
    // the legacy list — guarded, since asking for the wrong type can throw.
    final itemsRaw = _getString(prefs, SettingsKeys.apartmentItems);
    final itemsLegacy = itemsRaw == null
        ? _getStringList(prefs, SettingsKeys.apartmentItems)
        : null;
    _pieces = _decodePieces(itemsRaw, legacy: itemsLegacy);
    _positions =
        _decodeLayout(_getString(prefs, SettingsKeys.apartmentLayout));
    _flipped = _loadFlipped(prefs);

    _revealed =
        (prefs.getStringList(SettingsKeys.apartmentRevealed) ?? const [])
            .toSet();
    _night = prefs.getBool(SettingsKeys.apartmentNight) ?? false;
    _animate = prefs.getBool(SettingsKeys.apartmentAnimate) ?? true;
    _effects = prefs.getBool(SettingsKeys.apartmentEffects) ?? true;
    _loaded = true;
    // Remove-then-add so repeated loads (e.g. after resetForTest) don't stack
    // duplicate listeners.
    CoinWallet.instance.removeListener(_onWalletChanged);
    CoinWallet.instance.addListener(_onWalletChanged);
    await refreshReveals();
  }

  /// Reads a [String] pref, returning null if it's missing or stored as another
  /// type (e.g. an old `StringList` under the same key) rather than throwing.
  static String? _getString(SharedPreferences prefs, String key) {
    try {
      return prefs.getString(key);
    } catch (_) {
      return null;
    }
  }

  static List<String>? _getStringList(SharedPreferences prefs, String key) {
    try {
      return prefs.getStringList(key);
    } catch (_) {
      return null;
    }
  }

  List<String> _loadRooms(SharedPreferences prefs) {
    final saved = prefs.getStringList(SettingsKeys.apartmentRooms);
    final rooms = <String>[
      kStarterRoomId,
      ...?saved?.where((id) => id != kStarterRoomId && roomById(id) != null),
    ];
    return rooms.toSet().toList(); // de-dupe, keep order
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
  /// the current room (you can own several of the same). Returns the new
  /// instance id. Persists + notifies.
  Future<String> grant(String catalogId) async {
    final instanceId =
        '$catalogId#${DateTime.now().microsecondsSinceEpoch}-${_seq++}';
    final room = {...?_pieces[_currentRoom], instanceId: catalogId};
    _pieces = {..._pieces, _currentRoom: room};
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

  /// Moves the piece [instanceId] to the top of the current room's stack (drawn
  /// last, above everything else) — used when the learner finishes dragging it,
  /// so the piece they just arranged stays in front. Persists + notifies.
  Future<void> bringToFront(String instanceId) async {
    final room = _pieces[_currentRoom];
    final catalogId = room?[instanceId];
    if (room == null || catalogId == null) return;
    if (room.keys.last == instanceId) return; // already on top
    final next = {...room}..remove(instanceId);
    next[instanceId] = catalogId; // re-add at the end (top of the stack)
    _pieces = {..._pieces, _currentRoom: next};
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.apartmentItems, _encodePieces());
  }

  /// The learner gave the piece [instanceId] away in the giving corner: it
  /// leaves the current room. Its catalogue item stays revealed, so it can be
  /// bought again. Persists + notifies.
  Future<void> donate(String instanceId) async {
    final room = _pieces[_currentRoom];
    if (room == null || !room.containsKey(instanceId)) return;
    _pieces = {..._pieces, _currentRoom: {...room}..remove(instanceId)};
    final pos = {...?_positions[_currentRoom]}..remove(instanceId);
    _positions = {..._positions, _currentRoom: pos};
    final flip = {...?_flipped[_currentRoom]}..remove(instanceId);
    _flipped = {..._flipped, _currentRoom: flip};
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsKeys.apartmentItems, _encodePieces());
    await prefs.setString(SettingsKeys.apartmentLayout, _encodeLayout());
    await prefs.setString(
        SettingsKeys.apartmentFlippedRooms, _encodeFlipped());
  }

  /// Normalized (0..1) position of piece [instanceId] (a [catalogId] copy) in
  /// this room: where it was dragged, or a deterministic scattered default.
  Offset positionOf(String instanceId, String catalogId) =>
      _positions[_currentRoom]?[instanceId] ??
      _defaultPositionFor(instanceId, catalogId);

  Future<void> setPosition(String instanceId, Offset pos) =>
      setPositions({instanceId: pos});

  /// Records several positions at once (in this room) and persists in one write.
  Future<void> setPositions(Map<String, Offset> positions) async {
    if (positions.isEmpty) return;
    final next = {...?_positions[_currentRoom]};
    for (final e in positions.entries) {
      next[e.key] =
          Offset(e.value.dx.clamp(0.0, 1.0), e.value.dy.clamp(0.0, 1.0));
    }
    _positions = {..._positions, _currentRoom: next};
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

  // ── Encode / decode (per-room JSON, with migration from the old flat data) ──

  String _encodePieces() => jsonEncode(_pieces);

  String _encodeLayout() => jsonEncode({
        for (final room in _positions.entries)
          room.key: {
            for (final e in room.value.entries) e.key: [e.value.dx, e.value.dy],
          },
      });

  String _encodeFlipped() => jsonEncode({
        for (final room in _flipped.entries) room.key: room.value.toList(),
      });

  /// Reads placed pieces. New format is `{roomId: {iid: catalogId}}`; the old
  /// flat `{iid: catalogId}` (or the even older `StringList` of catalogue ids)
  /// is migrated into the starter room.
  static Map<String, Map<String, String>> _decodePieces(String? raw,
      {List<String>? legacy}) {
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        if (decoded.isEmpty) return {};
        if (decoded.values.first is Map) {
          return {
            for (final room in decoded.entries)
              room.key: {
                for (final e in (room.value as Map).entries)
                  e.key as String: e.value as String,
              },
          };
        }
        // Old flat format — one room's worth, put it in the starter room.
        return {
          kStarterRoomId: {
            for (final e in decoded.entries) e.key: e.value as String,
          },
        };
      } catch (_) {
        return {};
      }
    }
    if (legacy != null) {
      return {
        kStarterRoomId: {for (final id in legacy) id: id},
      };
    }
    return {};
  }

  static Map<String, Map<String, Offset>> _decodeLayout(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      if (decoded.isEmpty) return {};
      Offset toOffset(dynamic v) =>
          Offset((v[0] as num).toDouble(), (v[1] as num).toDouble());
      if (decoded.values.first is Map) {
        return {
          for (final room in decoded.entries)
            room.key: {
              for (final e in (room.value as Map).entries)
                e.key as String: toOffset(e.value),
            },
        };
      }
      // Old flat layout → starter room.
      return {
        kStarterRoomId: {
          for (final e in decoded.entries) e.key: toOffset(e.value),
        },
      };
    } catch (_) {
      return {};
    }
  }

  Map<String, Set<String>> _loadFlipped(SharedPreferences prefs) {
    final raw = prefs.getString(SettingsKeys.apartmentFlippedRooms);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return {
          for (final room in decoded.entries)
            room.key: {for (final id in (room.value as List)) id as String},
        };
      } catch (_) {
        return {};
      }
    }
    // Migrate the old flat StringList into the starter room.
    final legacy = prefs.getStringList(SettingsKeys.apartmentFlipped);
    if (legacy != null && legacy.isNotEmpty) {
      return {kStarterRoomId: legacy.toSet()};
    }
    return {};
  }

  /// Test-only reset of the in-memory state (does not touch storage).
  @visibleForTesting
  void resetForTest() {
    _pieces = {};
    _positions = {};
    _flipped = {};
    _ownedRooms = [kStarterRoomId];
    _currentRoom = kStarterRoomId;
    _revealed = {};
    _night = false;
    _animate = true;
    _effects = true;
    _loaded = false;
    _seq = 0;
  }
}
