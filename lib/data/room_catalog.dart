/// The rooms a learner can own in the apartment mini-game. The first room is the
/// free starter (the cosy loft everyone begins with); the rest are bought with
/// coins and cost a lot — they're a long-term goal, not pocket change.
///
/// Every room is the same standard size, but each has its own *theme*: a default
/// floor and wall look plus a [backdrop] motif painted on the wall, so each room
/// feels different. Furniture is owned **per room** (see `Apartment`), so a piece
/// placed in one room isn't in another, and the giving corner only ever shows the
/// room you're currently in.
library;

import 'package:flutter/material.dart';

/// A flat decorative motif painted on a room's back wall, behind the furniture,
/// to suit the room's theme (see `_CosyRoomPainter`).
enum RoomBackdrop {
  none, // cosy default — just the wall
  sun, // a warm sun (sunroom)
  shelves, // a bookcase silhouette (study, library)
  trellis, // a garden lattice (garden room)
  canvas, // a framed abstract painting (art studio)
  drapes, // a soft headboard arch + curtains (bedroom)
  tiles, // a tiled backsplash + window (kitchen)
  waves, // soft waves + a porthole (spa)
  skyline, // a city-view window (penthouse)
  neon, // glowing neon bars (game room)
}

/// One room the learner can own. [floorGlyph]/[wallGlyph] are surface drawings
/// (see `room_surfaces.dart`); when null the room shows the cosy default look.
class RoomTheme {
  const RoomTheme({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.floorGlyph,
    this.floorColor,
    this.wallGlyph,
    this.wallColor,
    this.backdrop = RoomBackdrop.none,
  });

  /// Stable id (persisted) — never rename without a migration.
  final String id;
  final String name;
  final String emoji;

  /// Coin cost to buy. The starter room is 0 (owned from the start).
  final int price;

  final String? floorGlyph;
  final Color? floorColor;
  final String? wallGlyph;
  final Color? wallColor;

  /// The wall motif painted behind the furniture.
  final RoomBackdrop backdrop;

  bool get isStarter => price == 0;
}

/// The id of the free starter room every learner owns.
const String kStarterRoomId = 'loft';

/// All rooms, starter first, then the buyable ones in ascending price. Prices are
/// deliberately steep — owning a second room is a real milestone.
const List<RoomTheme> roomCatalog = [
  RoomTheme(
    id: kStarterRoomId,
    name: 'Cosy Loft',
    emoji: '🛋️',
    price: 0,
  ),
  RoomTheme(
    id: 'sunroom',
    name: 'Sunroom',
    emoji: '🌞',
    price: 2500,
    floorGlyph: 'floorwood',
    floorColor: Color(0xFFC8A06B),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFFF1E2BE),
    backdrop: RoomBackdrop.sun,
  ),
  RoomTheme(
    id: 'study',
    name: 'Study',
    emoji: '📚',
    price: 4500,
    floorGlyph: 'floorwood',
    floorColor: Color(0xFF6D4C41),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFF8AA37B),
    backdrop: RoomBackdrop.shelves,
  ),
  RoomTheme(
    id: 'garden',
    name: 'Garden Room',
    emoji: '🪴',
    price: 7000,
    floorGlyph: 'floorcarpet',
    floorColor: Color(0xFF8AA37B),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFFCDE3C4),
    backdrop: RoomBackdrop.trellis,
  ),
  RoomTheme(
    id: 'atelier',
    name: 'Art Studio',
    emoji: '🎨',
    price: 11000,
    floorGlyph: 'floortile',
    floorColor: Color(0xFF9AA6AF),
    wallGlyph: 'wallbrick',
    wallColor: Color(0xFFC07E64),
    backdrop: RoomBackdrop.canvas,
  ),
  RoomTheme(
    id: 'bedroom',
    name: 'Bedroom Suite',
    emoji: '🛏️',
    price: 16000,
    floorGlyph: 'floorcarpet',
    floorColor: Color(0xFFE07A9A),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFFEEB5B0),
    backdrop: RoomBackdrop.drapes,
  ),
  RoomTheme(
    id: 'kitchen',
    name: 'Kitchen',
    emoji: '🍳',
    price: 23000,
    floorGlyph: 'floortile',
    floorColor: Color(0xFFE6E2DA),
    wallGlyph: 'wallstripes',
    wallColor: Color(0xFFEAD9C0),
    backdrop: RoomBackdrop.tiles,
  ),
  RoomTheme(
    id: 'library',
    name: 'Library',
    emoji: '📖',
    price: 32000,
    floorGlyph: 'floorwood',
    floorColor: Color(0xFF3E342E),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFF3B4D7A),
    backdrop: RoomBackdrop.shelves,
  ),
  RoomTheme(
    id: 'spa',
    name: 'Spa Bath',
    emoji: '🛁',
    price: 45000,
    floorGlyph: 'floormarble',
    floorColor: Color(0xFFEAE6DE),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFF9BC4E2),
    backdrop: RoomBackdrop.waves,
  ),
  RoomTheme(
    id: 'arcade',
    name: 'Game Room',
    emoji: '🎮',
    price: 60000,
    floorGlyph: 'floorcarpet',
    floorColor: Color(0xFF3B4D7A),
    wallGlyph: 'wallbrick',
    wallColor: Color(0xFF6E5A52),
    backdrop: RoomBackdrop.neon,
  ),
  RoomTheme(
    id: 'penthouse',
    name: 'Penthouse',
    emoji: '🏙️',
    price: 80000,
    floorGlyph: 'floormarble',
    floorColor: Color(0xFFD8D2C8),
    wallGlyph: 'wallsolid',
    wallColor: Color(0xFF4A4A4A),
    backdrop: RoomBackdrop.skyline,
  ),
];

/// The room theme with [id], or null if none (e.g. a stale persisted id).
RoomTheme? roomById(String id) {
  for (final r in roomCatalog) {
    if (r.id == id) return r;
  }
  return null;
}
