/// The furniture catalog for the apartment mini-game: the fixed set of things a
/// learner can buy with coins. Each item is drawn as a flat, minimal vector
/// illustration (see `FlatFurniture`), keyed by [ShopItem.id] — no image assets
/// and no Material icons.
library;

import 'package:flutter/material.dart';

/// One buyable piece of furniture: a stable [id] (used to persist ownership and
/// to pick its flat drawing), a display [name], the [color] it's drawn in, its
/// coin [price], whether it [onWall] (hangs on the wall) so the room places it
/// high by default instead of on the floor, and a [scale] so pieces sit at
/// sensible relative sizes in the room (a plant is smaller than a sofa).
class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.color,
    required this.price,
    this.onWall = false,
    this.scale = 1.0,
    this.shape,
  });

  final String id;
  final String name;
  final Color color;
  final int price;
  final bool onWall;

  /// How big the piece is drawn in the room, relative to the base tile — so the
  /// furniture reads at believable relative sizes rather than all the same. 1.0
  /// is the reference (a table); small décor is well below, big pieces above.
  final double scale;

  /// Which flat drawing in [FlatFurniture] to use, when it differs from [id].
  /// This lets many colourways (e.g. "Oak Table", "Walnut Table") share one
  /// drawing — each rendered in its own [color]. Null means "draw [id]".
  final String? shape;

  /// The drawing key for [FlatFurniture] — the explicit [shape] or, by default,
  /// the [id].
  String get glyph => shape ?? id;

  /// Which shop tab this piece lives under (see [shopCategories]).
  String get category => shopCategoryOf(glyph);

  /// Whether this is a room surface (flooring / wallpaper) rather than a piece
  /// of furniture — surfaces change the room background instead of being placed.
  bool get isSurface => category == 'Floors' || category == 'Walls';

  /// Floor pieces get a soft shadow under them; wall pieces and the flat rug
  /// don't.
  bool get castsShadow => !onWall && glyph != 'rug';
}

/// The "starter" pieces — one of each kind, cheapest first. The rest of the
/// catalogue is colourway variants of these drawings (see [_more]). Ids are
/// stable — never rename one without a migration, or owned items would be
/// orphaned.
const List<ShopItem> _starter = [
  ShopItem(id: 'lamp', name: 'Lamp', color: Color(0xFFF4B63E), price: 5, scale: 0.72),
  ShopItem(id: 'plant', name: 'Plant', color: Color(0xFF4CAF50), price: 8, scale: 0.6),
  ShopItem(id: 'chair', name: 'Chair', color: Color(0xFF8D6E63), price: 10, scale: 0.78),
  ShopItem(
    id: 'painting',
    name: 'Painting',
    color: Color(0xFF7E57C2),
    price: 12,
    onWall: true,
    scale: 0.62,
  ),
  ShopItem(
    id: 'clock',
    name: 'Clock',
    color: Color(0xFF546E7A),
    price: 15,
    onWall: true,
    scale: 0.44,
  ),
  ShopItem(id: 'rug', name: 'Rug', color: Color(0xFFEF6C9C), price: 18, scale: 1.15),
  ShopItem(id: 'bookshelf', name: 'Bookshelf', color: Color(0xFF6D4C41), price: 20, scale: 1.05),
  ShopItem(id: 'cactus', name: 'Cactus', color: Color(0xFF66BB6A), price: 22, scale: 0.58),
  ShopItem(id: 'table', name: 'Table', color: Color(0xFFA1887F), price: 25, scale: 0.95),
  ShopItem(
    id: 'mirror',
    name: 'Mirror',
    color: Color(0xFF90A4AE),
    price: 28,
    onWall: true,
    scale: 0.62,
  ),
  ShopItem(id: 'sofa', name: 'Sofa', color: Color(0xFF5C6BC0), price: 30, scale: 1.35),
  ShopItem(id: 'desk', name: 'Desk', color: Color(0xFF8D6E63), price: 35, scale: 1.0),
  ShopItem(id: 'bed', name: 'Bed', color: Color(0xFFEC6E91), price: 40, scale: 1.4),
  ShopItem(id: 'vase', name: 'Vase', color: Color(0xFF26A69A), price: 45, scale: 0.5),
  ShopItem(id: 'tv', name: 'TV', color: Color(0xFF37474F), price: 50, scale: 0.9),
  ShopItem(id: 'guitar', name: 'Guitar', color: Color(0xFFEF9A3D), price: 55, scale: 0.72),
  ShopItem(id: 'fireplace', name: 'Fireplace', color: Color(0xFFB5524A), price: 60, scale: 1.1),
  ShopItem(id: 'fridge', name: 'Fridge', color: Color(0xFF78909C), price: 65, scale: 1.1),
  ShopItem(id: 'stove', name: 'Stove', color: Color(0xFF607D8B), price: 70, scale: 0.95),
  ShopItem(id: 'pet', name: 'Pet', color: Color(0xFFFB8C00), price: 75, scale: 0.5),
  ShopItem(id: 'wardrobe', name: 'Wardrobe', color: Color(0xFF795548), price: 85, scale: 1.2),
  ShopItem(id: 'aquarium', name: 'Aquarium', color: Color(0xFF29B6F6), price: 90, scale: 0.8),
  ShopItem(id: 'beanbag', name: 'Beanbag', color: Color(0xFFAB47BC), price: 95, scale: 0.78),
  ShopItem(id: 'bathtub', name: 'Bathtub', color: Color(0xFF26C6DA), price: 100, scale: 1.0),
];

// ── Colourways ───────────────────────────────────────────────────────────────
// Like a real furniture catalogue, most pieces come in several colourways: the
// same flat drawing ([ShopItem.shape]) rendered in different colours. Each is
// its own buyable item with a stable `${shape}_${colour}` id.

class _Hue {
  const _Hue(this.key, this.name, this.color);
  final String key;
  final String name;
  final Color color;
}

// Wood finishes (cabinetry, frames, legs).
const _oak = _Hue('oak', 'Oak', Color(0xFFC8A06B));
const _walnut = _Hue('walnut', 'Walnut', Color(0xFF6D4C41));
const _ash = _Hue('ash', 'Ash', Color(0xFFD8C7A6));
const _ebony = _Hue('ebony', 'Ebony', Color(0xFF3E342E));
// Upholstery / painted colours.
const _sage = _Hue('sage', 'Sage', Color(0xFF8AA37B));
const _teal = _Hue('teal', 'Teal', Color(0xFF2E9E9B));
const _mustard = _Hue('mustard', 'Mustard', Color(0xFFE0A82E));
const _rose = _Hue('rose', 'Rose', Color(0xFFE07A9A));
const _navy = _Hue('navy', 'Navy', Color(0xFF3B4D7A));
const _terra = _Hue('terracotta', 'Terracotta', Color(0xFFC96F4A));
const _charcoal = _Hue('charcoal', 'Charcoal', Color(0xFF4A4A4A));
const _cream = _Hue('cream', 'Cream', Color(0xFFE6D7B8));
const _blush = _Hue('blush', 'Blush', Color(0xFFEEB5B0));
const _plum = _Hue('plum', 'Plum', Color(0xFF7E5A86));
// Bright plastics / accents.
const _red = _Hue('red', 'Red', Color(0xFFE2574C));
const _orange = _Hue('orange', 'Orange', Color(0xFFF08A3C));
const _yellow = _Hue('yellow', 'Yellow', Color(0xFFF4C430));
const _green = _Hue('green', 'Green', Color(0xFF5BA85A));
const _blue = _Hue('blue', 'Blue', Color(0xFF4A8FE0));
const _purple = _Hue('purple', 'Purple', Color(0xFF8E68C8));
const _pink = _Hue('pink', 'Pink', Color(0xFFE86BA8));
const _mint = _Hue('mint', 'Mint', Color(0xFF74C9A8));
// Metals / neutrals.
const _white = _Hue('white', 'White', Color(0xFFECECEC));
const _silver = _Hue('silver', 'Silver', Color(0xFFB7C0C7));
const _graphite = _Hue('graphite', 'Graphite', Color(0xFF566066));
const _copper = _Hue('copper', 'Copper', Color(0xFFC07A4A));
const _black = _Hue('black', 'Black', Color(0xFF333333));
// Greens for plants.
const _leaf = _Hue('leaf', 'Leafy', Color(0xFF5BA85A));
const _fern = _Hue('fern', 'Fern', Color(0xFF3F8F5A));
const _emerald = _Hue('emerald', 'Emerald', Color(0xFF2FA37A));

/// Builds one buyable item per [hues] entry: the same [glyph] drawing and
/// [noun], each in its own colour, with prices stepping up from [basePrice].
List<ShopItem> _ways(
  String glyph,
  String noun, {
  required List<_Hue> hues,
  required int basePrice,
  int step = 3,
  double scale = 1.0,
  bool onWall = false,
}) => [
  for (var i = 0; i < hues.length; i++)
    ShopItem(
      id: '${glyph}_${hues[i].key}',
      name: '${hues[i].name} $noun',
      color: hues[i].color,
      price: basePrice + i * step,
      onWall: onWall,
      scale: scale,
      shape: glyph,
    ),
];

/// All the colourway variants, by room area. Glyphs here must have a drawing in
/// `FlatFurniture` (else they fall back to a plain disc).
final List<ShopItem> _more = [
  // Seating.
  ..._ways('sofa', 'Sofa',
      hues: const [_sage, _teal, _mustard, _rose, _navy, _terra, _charcoal, _blush],
      basePrice: 120, step: 9, scale: 1.35),
  ..._ways('armchair', 'Armchair',
      hues: const [_sage, _teal, _mustard, _navy, _terra, _plum],
      basePrice: 90, step: 7, scale: 0.95),
  ..._ways('chair', 'Chair',
      hues: const [_oak, _walnut, _white, _black, _red, _teal],
      basePrice: 24, step: 3, scale: 0.78),
  ..._ways('stool', 'Stool',
      hues: const [_oak, _walnut, _mustard, _teal],
      basePrice: 16, step: 2, scale: 0.6),
  ..._ways('bench', 'Bench',
      hues: const [_oak, _walnut, _ash, _charcoal],
      basePrice: 40, step: 4, scale: 0.95),
  ..._ways('ottoman', 'Ottoman',
      hues: const [_mustard, _teal, _rose, _navy, _cream],
      basePrice: 38, step: 4, scale: 0.62),
  ..._ways('beanbag', 'Beanbag',
      hues: const [_red, _blue, _green, _purple, _pink, _mustard],
      basePrice: 44, step: 4, scale: 0.78),
  // Tables & storage.
  ..._ways('table', 'Table',
      hues: const [_oak, _walnut, _ash, _white],
      basePrice: 50, step: 5, scale: 0.95),
  ..._ways('desk', 'Desk',
      hues: const [_oak, _walnut, _white, _charcoal],
      basePrice: 60, step: 5, scale: 1.0),
  ..._ways('nightstand', 'Nightstand',
      hues: const [_oak, _walnut, _white, _sage],
      basePrice: 36, step: 3, scale: 0.6),
  ..._ways('dresser', 'Dresser',
      hues: const [_oak, _walnut, _white, _sage],
      basePrice: 90, step: 6, scale: 1.1),
  ..._ways('cabinet', 'Cabinet',
      hues: const [_oak, _walnut, _white, _navy],
      basePrice: 80, step: 6, scale: 1.15),
  ..._ways('bookshelf', 'Bookshelf',
      hues: const [_oak, _walnut, _white, _charcoal],
      basePrice: 70, step: 6, scale: 1.05),
  ..._ways('wardrobe', 'Wardrobe',
      hues: const [_oak, _walnut, _white, _sage],
      basePrice: 130, step: 8, scale: 1.2),
  ..._ways('chest', 'Chest',
      hues: const [_walnut, _oak, _terra, _ebony],
      basePrice: 55, step: 5, scale: 0.8),
  ..._ways('coatrack', 'Coat Rack',
      hues: const [_oak, _black, _white],
      basePrice: 30, step: 3, scale: 1.0),
  // Beds.
  ..._ways('bed', 'Bed',
      hues: const [_navy, _sage, _rose, _mustard, _cream],
      basePrice: 170, step: 12, scale: 1.4),
  // Lighting.
  ..._ways('lamp', 'Floor Lamp',
      hues: const [_mustard, _black, _white, _teal],
      basePrice: 26, step: 3, scale: 0.72),
  ..._ways('pendant', 'Pendant Light',
      hues: const [_black, _copper, _white],
      basePrice: 32, step: 3, scale: 0.62, onWall: true),
  ..._ways('lantern', 'Lantern',
      hues: const [_black, _copper, _silver],
      basePrice: 20, step: 2, scale: 0.5),
  ..._ways('candle', 'Candle',
      hues: const [_cream, _rose, _sage, _terra],
      basePrice: 8, step: 1, scale: 0.4),
  // Plants.
  ..._ways('plant', 'Potted Plant',
      hues: const [_leaf, _fern, _emerald],
      basePrice: 14, step: 2, scale: 0.6),
  ..._ways('cactus', 'Cactus',
      hues: const [_leaf, _fern, _emerald],
      basePrice: 18, step: 2, scale: 0.58),
  ..._ways('succulent', 'Succulent',
      hues: const [_leaf, _emerald, _mint],
      basePrice: 10, step: 2, scale: 0.45),
  ..._ways('palm', 'Palm',
      hues: const [_fern, _leaf],
      basePrice: 34, step: 4, scale: 1.0),
  ..._ways('hangingplant', 'Hanging Plant',
      hues: const [_leaf, _fern],
      basePrice: 24, step: 3, scale: 0.7, onWall: true),
  ..._ways('vase', 'Vase',
      hues: const [_teal, _rose, _mustard, _navy, _white],
      basePrice: 16, step: 2, scale: 0.5),
  // Wall décor.
  ..._ways('painting', 'Painting',
      hues: const [_terra, _teal, _mustard, _navy],
      basePrice: 40, step: 4, scale: 0.62, onWall: true),
  ..._ways('poster', 'Poster',
      hues: const [_red, _blue, _mustard, _green, _purple],
      basePrice: 16, step: 2, scale: 0.6, onWall: true),
  ..._ways('photo', 'Framed Photo',
      hues: const [_oak, _black, _white],
      basePrice: 14, step: 2, scale: 0.5, onWall: true),
  ..._ways('mirror', 'Mirror',
      hues: const [_copper, _white, _black],
      basePrice: 50, step: 4, scale: 0.62, onWall: true),
  ..._ways('clock', 'Clock',
      hues: const [_black, _white, _copper, _teal],
      basePrice: 22, step: 2, scale: 0.44, onWall: true),
  ..._ways('tapestry', 'Tapestry',
      hues: const [_terra, _navy, _sage, _plum],
      basePrice: 36, step: 3, scale: 0.7, onWall: true),
  ..._ways('wallshelf', 'Wall Shelf',
      hues: const [_oak, _white, _black],
      basePrice: 28, step: 3, scale: 0.7, onWall: true),
  // Windows (hung on the wall, like other décor).
  ..._ways('window', 'Window',
      hues: const [_white, _oak, _walnut, _black],
      basePrice: 30, step: 4, scale: 0.72, onWall: true),
  ..._ways('archwindow', 'Arched Window',
      hues: const [_white, _oak, _black],
      basePrice: 42, step: 4, scale: 0.78, onWall: true),
  ..._ways('roundwindow', 'Round Window',
      hues: const [_white, _copper, _black],
      basePrice: 38, step: 4, scale: 0.6, onWall: true),
  // Floor.
  ..._ways('rug', 'Rug',
      hues: const [_terra, _navy, _sage, _rose, _mustard, _charcoal],
      basePrice: 40, step: 4, scale: 1.15),
  // Electronics & music.
  ..._ways('tv', 'TV',
      hues: const [_black, _silver],
      basePrice: 90, step: 8, scale: 0.9),
  ..._ways('computer', 'Computer',
      hues: const [_silver, _black],
      basePrice: 100, step: 8, scale: 0.85),
  ..._ways('laptop', 'Laptop',
      hues: const [_silver, _graphite, _rose],
      basePrice: 80, step: 6, scale: 0.6),
  ..._ways('arcade', 'Arcade Machine',
      hues: const [_red, _blue, _purple],
      basePrice: 140, step: 10, scale: 1.1),
  ..._ways('speaker', 'Speaker',
      hues: const [_black, _walnut, _white],
      basePrice: 50, step: 4, scale: 0.7),
  ..._ways('radio', 'Radio',
      hues: const [_terra, _cream, _teal],
      basePrice: 28, step: 3, scale: 0.55),
  ..._ways('piano', 'Piano',
      hues: const [_black, _walnut],
      basePrice: 240, step: 30, scale: 1.2),
  ..._ways('guitar', 'Guitar',
      hues: const [_oak, _walnut, _red, _blue],
      basePrice: 55, step: 4, scale: 0.72),
  ..._ways('drum', 'Drum',
      hues: const [_red, _blue, _yellow],
      basePrice: 50, step: 4, scale: 0.6),
  // Kitchen.
  ..._ways('fridge', 'Fridge',
      hues: const [_white, _silver, _mint],
      basePrice: 120, step: 8, scale: 1.1),
  ..._ways('stove', 'Stove',
      hues: const [_white, _graphite],
      basePrice: 110, step: 8, scale: 0.95),
  ..._ways('microwave', 'Microwave',
      hues: const [_white, _black, _silver],
      basePrice: 50, step: 4, scale: 0.6),
  ..._ways('toaster', 'Toaster',
      hues: const [_silver, _red, _mint],
      basePrice: 22, step: 2, scale: 0.45),
  ..._ways('kettle', 'Kettle',
      hues: const [_silver, _black, _red],
      basePrice: 20, step: 2, scale: 0.45),
  ..._ways('pot', 'Cooking Pot',
      hues: const [_silver, _red, _blue],
      basePrice: 16, step: 2, scale: 0.5),
  ..._ways('teapot', 'Teapot',
      hues: const [_white, _teal, _rose],
      basePrice: 22, step: 2, scale: 0.45),
  ..._ways('mug', 'Mug',
      hues: const [_red, _blue, _green, _yellow, _pink, _white, _black, _teal],
      basePrice: 6, step: 1, scale: 0.38),
  // Bathroom.
  ..._ways('bathtub', 'Bathtub',
      hues: const [_white, _blue, _rose],
      basePrice: 110, step: 8, scale: 1.0),
  ..._ways('toilet', 'Toilet',
      hues: const [_white, _cream],
      basePrice: 70, step: 5, scale: 0.85),
  ..._ways('sink', 'Sink',
      hues: const [_white, _cream],
      basePrice: 55, step: 4, scale: 0.7),
  // Accessories & pets.
  ..._ways('cushion', 'Cushion',
      hues: const [_mustard, _teal, _rose, _navy, _sage, _plum],
      basePrice: 10, step: 1, scale: 0.5),
  ..._ways('books', 'Books',
      hues: const [_red, _teal, _mustard, _navy],
      basePrice: 12, step: 2, scale: 0.5),
  ..._ways('globe', 'Globe',
      hues: const [_blue, _sage, _copper],
      basePrice: 24, step: 3, scale: 0.55),
  ..._ways('trophy', 'Trophy',
      hues: const [_yellow, _silver],
      basePrice: 30, step: 3, scale: 0.5),
  ..._ways('fishbowl', 'Fishbowl',
      hues: const [_orange, _red],
      basePrice: 26, step: 3, scale: 0.55),
  ..._ways('aquarium', 'Aquarium',
      hues: const [_blue, _teal],
      basePrice: 130, step: 8, scale: 0.8),
  ..._ways('birdcage', 'Birdcage',
      hues: const [_white, _black, _copper],
      basePrice: 45, step: 4, scale: 0.85),
  ..._ways('fan', 'Fan',
      hues: const [_white, _black, _mint],
      basePrice: 36, step: 3, scale: 0.7),
  ..._ways('ladder', 'Ladder',
      hues: const [_oak, _white, _red],
      basePrice: 30, step: 3, scale: 1.0),
  ..._ways('telescope', 'Telescope',
      hues: const [_black, _copper],
      basePrice: 130, step: 10, scale: 0.9),
  ..._ways('fireplace', 'Fireplace',
      hues: const [_terra, _charcoal, _cream],
      basePrice: 160, step: 10, scale: 1.1),
  ..._ways('trashcan', 'Trash Can',
      hues: const [_silver, _white, _green],
      basePrice: 14, step: 2, scale: 0.55),
  ..._ways('pet', 'Cat',
      hues: const [_orange, _charcoal, _cream, _white],
      basePrice: 75, step: 5, scale: 0.5),
  // People — calm little characters to bring the room to life: reading,
  // studying, resting, a little gentle yoga and light sport. Each pose comes in
  // a few outfit colours (the colourway tints their clothes).
  ..._ways('reader', 'Reader',
      hues: const [_sage, _teal, _mustard, _navy, _rose],
      basePrice: 50, step: 5, scale: 0.85),
  ..._ways('student', 'Student',
      hues: const [_terra, _plum, _blush, _charcoal, _cream],
      basePrice: 55, step: 5, scale: 0.85),
  ..._ways('meditator', 'Meditator',
      hues: const [_sage, _teal, _mustard, _navy, _rose],
      basePrice: 60, step: 5, scale: 0.85),
  ..._ways('yogatree', 'Yogi',
      hues: const [_terra, _plum, _blush, _charcoal, _cream],
      basePrice: 60, step: 5, scale: 1.05),
  ..._ways('stretch', 'Stretcher',
      hues: const [_sage, _teal, _mustard, _navy, _rose],
      basePrice: 58, step: 5, scale: 1.05),
  ..._ways('jogger', 'Jogger',
      hues: const [_terra, _plum, _blush, _charcoal, _cream],
      basePrice: 62, step: 5, scale: 1.0),
  ..._ways('walker', 'Walker',
      hues: const [_sage, _teal, _mustard, _navy, _rose],
      basePrice: 56, step: 5, scale: 1.05),
  ..._ways('coffee', 'Coffee Break',
      hues: const [_terra, _plum, _blush, _charcoal, _cream],
      basePrice: 64, step: 5, scale: 0.85),
  ..._ways('sleeper', 'Sleeper',
      hues: const [_sage, _teal, _mustard, _navy, _rose],
      basePrice: 52, step: 5, scale: 0.95),
  ..._ways('dreamer', 'Dreamer',
      hues: const [_terra, _plum, _blush, _charcoal, _cream],
      basePrice: 54, step: 5, scale: 0.95),
  ..._ways('petter', 'Pet Lover',
      hues: const [_sage, _teal, _mustard, _navy, _rose],
      basePrice: 66, step: 5, scale: 0.85),
  ..._ways('listener', 'Listener',
      hues: const [_terra, _plum, _blush, _charcoal, _cream],
      basePrice: 58, step: 5, scale: 0.85),
  // Flooring — changes the room's floor. The newest one bought shows; donating
  // it reveals the previous, down to the default wood.
  ..._ways('floorwood', 'Wood Floor',
      hues: const [_oak, _walnut, _ash], basePrice: 60, step: 8),
  ..._ways('floorcarpet', 'Carpet',
      hues: const [_rose, _sage, _navy, _mustard], basePrice: 70, step: 6),
  ShopItem(id: 'floortile', name: 'Tiled Floor', color: Color(0xFF9AA6AF), price: 85),
  ShopItem(id: 'floormarble', name: 'Marble Floor', color: Color(0xFFEAE6DE), price: 130),
  // Wallpaper — changes the room's wall.
  ..._ways('wallsolid', 'Wallpaper',
      hues: const [_cream, _sage, _blue, _blush, _terra], basePrice: 50, step: 5),
  ShopItem(id: 'wallstripes', name: 'Striped Wallpaper', color: Color(0xFFEAD9C0), price: 75),
  ShopItem(id: 'wallbrick', name: 'Brick Wall', color: Color(0xFFC07E64), price: 95),
];

/// One themed piece: a distinct hand-drawn shape (its own glyph = [id]), not a
/// colourway. Themed collections favour unique drawings over recolours, with a
/// rarity-tiered price (easy 20–150, medium 250–700, hard 1k–2.5k, legendary
/// 3k–8k) so the cool stuff is something to save up for.
ShopItem _t(
  String id,
  String name,
  Color color,
  int price, {
  double scale = 1.0,
  bool onWall = false,
}) => ShopItem(
  id: id,
  name: name,
  color: color,
  price: price,
  scale: scale,
  onWall: onWall,
);

/// The five room-themed collections — Garden, Spa, Gourmet Kitchen, Art Studio,
/// Game Room — each ~15 distinct animated pieces on a 4-tier rarity curve.
final List<ShopItem> _themed = [
  // ── Garden 🌿 ──────────────────────────────────────────────────────────────
  _t('gardenpot', 'Flower Pot', const Color(0xFFC96F4A), 25, scale: 0.55),
  _t('wateringcan', 'Watering Can', const Color(0xFF6FA8A0), 40, scale: 0.62),
  _t('gnome', 'Garden Gnome', const Color(0xFFD9534F), 55, scale: 0.6),
  _t('toadstool', 'Toadstool', const Color(0xFFE05252), 70, scale: 0.5),
  _t('birdbath', 'Bird Bath', const Color(0xFFB7B0A3), 90, scale: 0.72),
  _t('flowerbox', 'Flower Box', const Color(0xFF9E6B43), 110, scale: 0.6),
  _t('topiary', 'Topiary', const Color(0xFF4F8F4A), 130, scale: 0.75),
  _t('sunflower', 'Sunflower', const Color(0xFFE6B422), 150, scale: 0.82),
  _t('fountain', 'Fountain', const Color(0xFFAEB4B0), 280, scale: 0.9),
  _t('beehive', 'Beehive', const Color(0xFFE0A82E), 380, scale: 0.7),
  _t('lilypond', 'Lily Pond', const Color(0xFF4F9DAE), 520, scale: 0.85),
  _t('wheelbarrow', 'Wheelbarrow', const Color(0xFF8A8F94), 660, scale: 0.8),
  _t('greenhouse', 'Greenhouse', const Color(0xFF8FC0A9), 1300, scale: 0.95),
  _t('rosearch', 'Rose Arch', const Color(0xFFE6DCC8), 2100, scale: 1.0),
  _t('blossomtree', 'Blossom Tree', const Color(0xFFE69AB8), 6000, scale: 1.1),
  // ── Spa 🧖 ─────────────────────────────────────────────────────────────────
  _t('towelstack', 'Towel Stack', const Color(0xFFD9E2E4), 25, scale: 0.55),
  _t('spacandles', 'Spa Candles', const Color(0xFFE9DCC0), 40, scale: 0.5),
  _t('diffuser', 'Aroma Diffuser', const Color(0xFFB99B7A), 55, scale: 0.55),
  _t('bathsalts', 'Bath Salts', const Color(0xFFB39DD0), 70, scale: 0.5),
  _t('slippers', 'Spa Slippers', const Color(0xFFE0B7C0), 90, scale: 0.5),
  _t('loofah', 'Loofah', const Color(0xFFD9C28A), 110, scale: 0.5),
  _t('orchid', 'Orchid', const Color(0xFFD98AB8), 130, scale: 0.72),
  _t('stonestack', 'Zen Stones', const Color(0xFF7E776E), 150, scale: 0.55),
  _t('hottub', 'Hot Tub', const Color(0xFF5AA0B0), 280, scale: 0.95),
  _t('saunabucket', 'Sauna Bucket', const Color(0xFFB07A4A), 380, scale: 0.6),
  _t('massagetable', 'Massage Table', const Color(0xFFD8CFC2), 520, scale: 0.9),
  _t('footbath', 'Foot Spa', const Color(0xFF6FA8C0), 660, scale: 0.6),
  _t('stonebath', 'Stone Bath', const Color(0xFF9AA0A2), 1300, scale: 1.0),
  _t('waterfallwall', 'Waterfall Wall', const Color(0xFF6FB6C8), 2100, scale: 1.0),
  _t('onsen', 'Hot Spring', const Color(0xFF7BB0A8), 6000, scale: 1.1),
  // ── Gourmet Kitchen 🍳 ──────────────────────────────────────────────────────
  _t('cuttingboard', 'Cutting Board', const Color(0xFFC8975A), 25, scale: 0.55),
  _t('spicerack', 'Spice Rack', const Color(0xFFB07A4A), 40, scale: 0.6, onWall: true),
  _t('fruitbowl', 'Fruit Bowl', const Color(0xFFDCCBB0), 55, scale: 0.55),
  _t('coffeemaker', 'Coffee Maker', const Color(0xFF4A4A4A), 70, scale: 0.6),
  _t('blender', 'Blender', const Color(0xFF6A9FB0), 90, scale: 0.6),
  _t('cookbook', 'Cookbook Stand', const Color(0xFFC0584F), 110, scale: 0.55),
  _t('potrack', 'Pot Rack', const Color(0xFF566066), 130, scale: 0.7, onWall: true),
  _t('breadbasket', 'Bread Basket', const Color(0xFFC8975A), 150, scale: 0.55),
  _t('espresso', 'Espresso Machine', const Color(0xFFB7C0C7), 280, scale: 0.7),
  _t('standmixer', 'Stand Mixer', const Color(0xFFE07A9A), 380, scale: 0.65),
  _t('winerack', 'Wine Rack', const Color(0xFF6D4C41), 520, scale: 0.8),
  _t('rangehood', 'Range Hood', const Color(0xFFB7C0C7), 660, scale: 0.85),
  _t('kitchenisland', 'Kitchen Island', const Color(0xFF3B4D7A), 1300, scale: 1.0),
  _t('smartfridge', 'Smart Fridge', const Color(0xFFB7C0C7), 2100, scale: 1.0),
  _t('pizzaoven', 'Pizza Oven', const Color(0xFFC96F4A), 6000, scale: 1.05),
  // ── Art Studio 🎨 ───────────────────────────────────────────────────────────
  _t('easel', 'Easel', const Color(0xFFC8A06B), 25, scale: 0.85),
  _t('palette', 'Paint Palette', const Color(0xFFC8975A), 40, scale: 0.5),
  _t('brushjar', 'Brush Jar', const Color(0xFFB7C0C7), 55, scale: 0.5),
  _t('paintcans', 'Paint Cans', const Color(0xFF8E68C8), 70, scale: 0.55),
  _t('sketchpad', 'Sketch Pad', const Color(0xFFE6DCC8), 90, scale: 0.55),
  _t('pottery', 'Pottery', const Color(0xFFC96F4A), 110, scale: 0.5),
  _t('bust', 'Sculpture Bust', const Color(0xFFD8D2C8), 130, scale: 0.65),
  _t('colorwheel', 'Color Wheel', const Color(0xFFE2574C), 150, scale: 0.6, onWall: true),
  _t('potterywheel', 'Pottery Wheel', const Color(0xFF7E776E), 280, scale: 0.7),
  _t('abstractart', 'Abstract Canvas', const Color(0xFF7E57C2), 380, scale: 0.7, onWall: true),
  _t('artmannequin', 'Art Mannequin', const Color(0xFFC8A06B), 520, scale: 0.7),
  _t('draftingtable', 'Drafting Table', const Color(0xFF6D4C41), 660, scale: 0.85),
  _t('kiln', 'Kiln', const Color(0xFF8A8F94), 1300, scale: 0.9),
  _t('marblestatue', 'Marble Statue', const Color(0xFFE6E2DA), 2100, scale: 1.0),
  _t('grandeasel', 'Masterpiece Easel', const Color(0xFF6D4C41), 6000, scale: 1.1),
  // ── Game Room 🎮 ────────────────────────────────────────────────────────────
  _t('gamepad', 'Game Controller', const Color(0xFF3B4D7A), 25, scale: 0.5),
  _t('retroconsole', 'Retro Console', const Color(0xFF8A8F94), 40, scale: 0.55),
  _t('dartboard', 'Dartboard', const Color(0xFFC0584F), 55, scale: 0.6, onWall: true),
  _t('dicetower', 'Dice Tower', const Color(0xFF6D4C41), 70, scale: 0.55),
  _t('neonsign', 'Neon Sign', const Color(0xFFE86BA8), 90, scale: 0.6, onWall: true),
  _t('gamingchair', 'Gaming Chair', const Color(0xFFE2574C), 110, scale: 0.82),
  _t('vrheadset', 'VR Headset', const Color(0xFF4A4A4A), 130, scale: 0.55),
  _t('boardgame', 'Board Game', const Color(0xFF4A8FE0), 150, scale: 0.55),
  _t('pinball', 'Pinball Machine', const Color(0xFFE2574C), 280, scale: 0.85),
  _t('jukebox', 'Jukebox', const Color(0xFFC0584F), 380, scale: 0.8),
  _t('pooltable', 'Pool Table', const Color(0xFF2E7D5B), 520, scale: 0.95),
  _t('foosball', 'Foosball Table', const Color(0xFF4A8FE0), 660, scale: 0.9),
  _t('racingsim', 'Racing Sim', const Color(0xFF333333), 1300, scale: 1.0),
  _t('clawmachine', 'Claw Machine', const Color(0xFFE86BA8), 2100, scale: 0.95),
  _t('arcadetower', 'Arcade Tower', const Color(0xFF8E68C8), 6000, scale: 1.1),
];

/// The full catalogue — starter pieces, every colourway, plus the themed
/// collections — sorted cheapest first so the shop grid and the earn-as-you-go
/// reveal both open in price order.
final List<ShopItem> shopCatalog = [
  ..._starter,
  ..._more,
  ..._themed,
]..sort((a, b) => a.price.compareTo(b.price));

/// Lookup by [ShopItem.id], so the room can find an owned piece's metadata (its
/// drawing, price, whether it hangs on the wall) from a persisted id.
final Map<String, ShopItem> shopItemsById = {
  for (final item in shopCatalog) item.id: item,
};

// ── Categories (shop tabs) ───────────────────────────────────────────────────

/// The shop's category tabs, in display order. The room shop shows these as
/// tabs (plus an "All" tab in front — see the apartment page).
const List<String> shopCategories = [
  'Seating',
  'Tables & Storage',
  'Beds',
  'Lighting',
  'Plants',
  'Windows',
  'Décor',
  'Floors',
  'Walls',
  'Electronics',
  'Kitchen',
  'Bathroom',
  'Accessories',
  'Pets',
  'People',
  // Room-themed collections (distinct hand-drawn pieces, tiered by rarity).
  'Garden',
  'Spa',
  'Gourmet Kitchen',
  'Art Studio',
  'Game Room',
];

/// Which category each drawing belongs to. Keyed by [ShopItem.glyph], so every
/// colourway of a piece shares its category.
const Map<String, String> _categoryByGlyph = {
  // Seating.
  'chair': 'Seating', 'stool': 'Seating', 'armchair': 'Seating',
  'bench': 'Seating', 'ottoman': 'Seating', 'beanbag': 'Seating',
  'sofa': 'Seating',
  // Tables & storage.
  'table': 'Tables & Storage', 'desk': 'Tables & Storage',
  'nightstand': 'Tables & Storage', 'dresser': 'Tables & Storage',
  'cabinet': 'Tables & Storage', 'bookshelf': 'Tables & Storage',
  'wardrobe': 'Tables & Storage', 'chest': 'Tables & Storage',
  'coatrack': 'Tables & Storage',
  // Beds.
  'bed': 'Beds',
  // Lighting.
  'lamp': 'Lighting', 'pendant': 'Lighting', 'lantern': 'Lighting',
  'candle': 'Lighting',
  // Plants.
  'plant': 'Plants', 'cactus': 'Plants', 'succulent': 'Plants',
  'palm': 'Plants', 'hangingplant': 'Plants', 'vase': 'Plants',
  // Windows.
  'window': 'Windows', 'archwindow': 'Windows', 'roundwindow': 'Windows',
  // Floors & walls (surfaces).
  'floorwood': 'Floors', 'floortile': 'Floors', 'floorcarpet': 'Floors',
  'floormarble': 'Floors',
  'wallsolid': 'Walls', 'wallstripes': 'Walls', 'wallbrick': 'Walls',
  // Décor.
  'painting': 'Décor', 'poster': 'Décor', 'photo': 'Décor', 'mirror': 'Décor',
  'clock': 'Décor', 'tapestry': 'Décor', 'wallshelf': 'Décor', 'rug': 'Décor',
  // Electronics & music.
  'tv': 'Electronics', 'computer': 'Electronics', 'laptop': 'Electronics',
  'arcade': 'Electronics', 'speaker': 'Electronics', 'radio': 'Electronics',
  'piano': 'Electronics', 'guitar': 'Electronics', 'drum': 'Electronics',
  // Kitchen.
  'fridge': 'Kitchen', 'stove': 'Kitchen', 'microwave': 'Kitchen',
  'toaster': 'Kitchen', 'kettle': 'Kitchen', 'pot': 'Kitchen',
  'teapot': 'Kitchen', 'mug': 'Kitchen',
  // Bathroom.
  'bathtub': 'Bathroom', 'toilet': 'Bathroom', 'sink': 'Bathroom',
  // Accessories.
  'cushion': 'Accessories', 'books': 'Accessories', 'globe': 'Accessories',
  'trophy': 'Accessories', 'fan': 'Accessories', 'ladder': 'Accessories',
  'telescope': 'Accessories', 'fireplace': 'Accessories',
  'trashcan': 'Accessories',
  // Pets.
  'pet': 'Pets', 'fishbowl': 'Pets', 'aquarium': 'Pets', 'birdcage': 'Pets',
  // People (calm little characters).
  'reader': 'People', 'student': 'People', 'meditator': 'People',
  'yogatree': 'People', 'stretch': 'People', 'jogger': 'People',
  'walker': 'People', 'coffee': 'People', 'sleeper': 'People',
  'dreamer': 'People', 'petter': 'People', 'listener': 'People',
  // Garden.
  'gardenpot': 'Garden', 'wateringcan': 'Garden', 'gnome': 'Garden',
  'toadstool': 'Garden', 'birdbath': 'Garden', 'flowerbox': 'Garden',
  'topiary': 'Garden', 'sunflower': 'Garden', 'fountain': 'Garden',
  'beehive': 'Garden', 'lilypond': 'Garden', 'wheelbarrow': 'Garden',
  'greenhouse': 'Garden', 'rosearch': 'Garden', 'blossomtree': 'Garden',
  // Spa.
  'towelstack': 'Spa', 'spacandles': 'Spa', 'diffuser': 'Spa',
  'bathsalts': 'Spa', 'slippers': 'Spa', 'loofah': 'Spa', 'orchid': 'Spa',
  'stonestack': 'Spa', 'hottub': 'Spa', 'saunabucket': 'Spa',
  'massagetable': 'Spa', 'footbath': 'Spa', 'stonebath': 'Spa',
  'waterfallwall': 'Spa', 'onsen': 'Spa',
  // Gourmet Kitchen.
  'cuttingboard': 'Gourmet Kitchen', 'spicerack': 'Gourmet Kitchen',
  'fruitbowl': 'Gourmet Kitchen', 'coffeemaker': 'Gourmet Kitchen',
  'blender': 'Gourmet Kitchen', 'cookbook': 'Gourmet Kitchen',
  'potrack': 'Gourmet Kitchen', 'breadbasket': 'Gourmet Kitchen',
  'espresso': 'Gourmet Kitchen', 'standmixer': 'Gourmet Kitchen',
  'winerack': 'Gourmet Kitchen', 'rangehood': 'Gourmet Kitchen',
  'kitchenisland': 'Gourmet Kitchen', 'smartfridge': 'Gourmet Kitchen',
  'pizzaoven': 'Gourmet Kitchen',
  // Art Studio.
  'easel': 'Art Studio', 'palette': 'Art Studio', 'brushjar': 'Art Studio',
  'paintcans': 'Art Studio', 'sketchpad': 'Art Studio', 'pottery': 'Art Studio',
  'bust': 'Art Studio', 'colorwheel': 'Art Studio',
  'potterywheel': 'Art Studio', 'abstractart': 'Art Studio',
  'artmannequin': 'Art Studio', 'draftingtable': 'Art Studio',
  'kiln': 'Art Studio', 'marblestatue': 'Art Studio', 'grandeasel': 'Art Studio',
  // Game Room.
  'gamepad': 'Game Room', 'retroconsole': 'Game Room', 'dartboard': 'Game Room',
  'dicetower': 'Game Room', 'neonsign': 'Game Room', 'gamingchair': 'Game Room',
  'vrheadset': 'Game Room', 'boardgame': 'Game Room', 'pinball': 'Game Room',
  'pooltable': 'Game Room', 'foosball': 'Game Room', 'jukebox': 'Game Room',
  'racingsim': 'Game Room', 'clawmachine': 'Game Room',
  'arcadetower': 'Game Room',
};

/// The category for [glyph] (falls back to "Accessories" for anything new).
String shopCategoryOf(String glyph) => _categoryByGlyph[glyph] ?? 'Accessories';

/// The catalog item with [id], or null if none (e.g. a stale persisted id).
ShopItem? shopItemById(String id) => shopItemsById[id];
