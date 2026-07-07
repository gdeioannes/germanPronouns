/// Combos for the room mini-game: when two pieces that belong together are
/// placed next to each other, something happens between them — bees visit the
/// flowers, the cat dozes off by the fire, a person by the beehive becomes a
/// beekeeper. The effect is *live*: it plays while the pair stays close and
/// stops when they're dragged apart.
///
/// The first time a combo activates it is **discovered** — a little celebration
/// fires and it joins the learner's discoveries list (see `Apartment`). Only
/// discovered combos are ever named; the rest stay a secret to hunt for.
///
/// Sides ([RoomCombo.a] / [RoomCombo.b]) are sets of `ShopItem.glyph`s, so
/// "any person" or "any flower" is one combo, and every colourway of a piece
/// counts. Ids are stable — they're persisted in the discoveries list, so never
/// rename one without a migration.
library;

import 'dart:ui';

// ── Ambient effect ───────────────────────────────────────────────────────────

/// The particle drawn between an active combo's two pieces.
enum ComboShape {
  bee,
  heart,
  note,
  zzz,
  sparkle,
  star,
  bubble,
  steam,
  droplet,
  petal,
  snow,
  splat,
  butterfly,
  ember,
  pixel,
  ripple,
}

/// How a combo's particles move: [orbit] loops around the pair (bees,
/// butterflies), [rise] floats up and fades (steam, notes, hearts), [twinkle]
/// pulses in place (sparkles, stars), [fall] drifts down (snow, droplets).
enum ComboMotion { orbit, rise, twinkle, fall }

/// A combo's ambient effect: which [shape] is drawn, how it moves, and the
/// colours the particles cycle through.
class ComboFx {
  const ComboFx(this.shape, this.motion, this.colors);
  final ComboShape shape;
  final ComboMotion motion;
  final List<Color> colors;
}

// Shared effect palettes.
const _fxBees = ComboFx(ComboShape.bee, ComboMotion.orbit,
    [Color(0xFFF4C430), Color(0xFFE0A82E)]);
const _fxHearts = ComboFx(ComboShape.heart, ComboMotion.rise,
    [Color(0xFFE0577A), Color(0xFFEF7CA0), Color(0xFFF4A8C0)]);
const _fxNotes = ComboFx(ComboShape.note, ComboMotion.rise,
    [Color(0xFF4A4A4A), Color(0xFF3B4D7A), Color(0xFF7E5A86)]);
const _fxZzz = ComboFx(ComboShape.zzz, ComboMotion.rise,
    [Color(0xFF8E9BD8), Color(0xFFB0B8E8)]);
const _fxSparkle = ComboFx(ComboShape.sparkle, ComboMotion.twinkle,
    [Color(0xFFF4C430), Color(0xFFFFE08A), Color(0xFFFFF2C8)]);
const _fxStars = ComboFx(ComboShape.star, ComboMotion.twinkle,
    [Color(0xFFFFE08A), Color(0xFFBFD8FF), Color(0xFFFFF6DA)]);
const _fxBubbles = ComboFx(ComboShape.bubble, ComboMotion.rise,
    [Color(0xFF9AD0E8), Color(0xFFBFE3F2), Color(0xFFE0F2F8)]);
const _fxSteam = ComboFx(ComboShape.steam, ComboMotion.rise,
    [Color(0xFFEDEDED), Color(0xFFDDDDDD)]);
const _fxDroplets = ComboFx(ComboShape.droplet, ComboMotion.fall,
    [Color(0xFF6FB6D8), Color(0xFF9AD0E8)]);
const _fxPetals = ComboFx(ComboShape.petal, ComboMotion.fall,
    [Color(0xFFE69AB8), Color(0xFFF4C7D0), Color(0xFFEF7CA0)]);
const _fxSnow = ComboFx(ComboShape.snow, ComboMotion.fall,
    [Color(0xFFFFFFFF), Color(0xFFE8F2F8)]);
const _fxSplats = ComboFx(ComboShape.splat, ComboMotion.twinkle,
    [Color(0xFFE2574C), Color(0xFF4A8FE0), Color(0xFFF4C430), Color(0xFF5BA85A)]);
const _fxButterflies = ComboFx(ComboShape.butterfly, ComboMotion.orbit,
    [Color(0xFFE86BA8), Color(0xFFF08A3C), Color(0xFF8E68C8)]);
const _fxEmbers = ComboFx(ComboShape.ember, ComboMotion.rise,
    [Color(0xFFFF9A52), Color(0xFFE2574C), Color(0xFFF4C430)]);
const _fxPixels = ComboFx(ComboShape.pixel, ComboMotion.rise,
    [Color(0xFF49E0FF), Color(0xFFFF4D9D), Color(0xFFC46BFF), Color(0xFF7CFF6B)]);
const _fxRipples = ComboFx(ComboShape.ripple, ComboMotion.twinkle,
    [Color(0xFF7FC0D8), Color(0xFFA8D8E8)]);

// ── Glyph groups (reused across combos) ──────────────────────────────────────

/// Every little person in the catalogue — any of them can star in a
/// person-shaped combo.
const Set<String> kComboPeople = {
  'reader', 'student', 'meditator', 'yogatree', 'stretch', 'jogger',
  'walker', 'coffee', 'sleeper', 'dreamer', 'petter', 'listener',
};

const Set<String> _cats = {'pet', 'kitten'};
const Set<String> _dogs = {'dog', 'puppy'};
const Set<String> _flowers = {
  'sunflower', 'tulips', 'daisies', 'lavender', 'roses', 'orchid',
  'flowerbox', 'gardenpot', 'blossomtree',
};
const Set<String> _greenery = {
  'plant', 'fern', 'monstera', 'figtree', 'bonsai', 'snakeplant',
  'bigcactus', 'citrustree', 'palm', 'aloe', 'succulent', 'cactus', 'topiary',
};
const Set<String> _tubs = {'bathtub', 'bubbletub', 'clawtub', 'designertub'};
const Set<String> _comfySeats = {'sofa', 'armchair', 'beanbag'};
const Set<String> _beds = {'bed', 'canopybed', 'bunkbed', 'kidsbed'};
const Set<String> _windows = {
  'window', 'archwindow', 'roundwindow', 'baywindow', 'skylight',
};

// ── The combo model ──────────────────────────────────────────────────────────

/// One discoverable pairing: any piece whose glyph is in [a] placed next to any
/// piece whose glyph is in [b]. Sides may overlap (e.g. flower + flower), but a
/// piece never pairs with itself.
class RoomCombo {
  const RoomCombo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.a,
    required this.b,
    required this.fx,
  });

  /// Stable id (persisted in the discoveries list) — never rename.
  final String id;
  final String name;
  final String emoji;

  /// A playful one-liner shown on the discovery card and in the list.
  final String description;

  final Set<String> a;
  final Set<String> b;
  final ComboFx fx;
}

/// Every combo the room knows. Order is just for authoring; discovery order is
/// what the learner sees.
const List<RoomCombo> roomCombos = [
  // ── Garden life ────────────────────────────────────────────────────────────
  RoomCombo(
    id: 'beekeeper',
    name: 'Beekeeper',
    emoji: '🐝',
    description: 'Someone brave is tending the hive!',
    a: kComboPeople,
    b: {'beehive'},
    fx: _fxBees,
  ),
  RoomCombo(
    id: 'pollination',
    name: 'Pollination',
    emoji: '🌼',
    description: 'The bees found the flowers — the garden is buzzing.',
    a: {'beehive'},
    b: _flowers,
    fx: _fxBees,
  ),
  RoomCombo(
    id: 'green_thumb',
    name: 'Green Thumb',
    emoji: '💧',
    description: 'A little water and everything grows.',
    a: {'wateringcan'},
    b: {..._flowers, ..._greenery},
    fx: _fxDroplets,
  ),
  RoomCombo(
    id: 'butterfly_garden',
    name: 'Butterfly Garden',
    emoji: '🦋',
    description: 'Two flower patches together — the butterflies moved in.',
    a: _flowers,
    b: _flowers,
    fx: _fxButterflies,
  ),
  RoomCombo(
    id: 'gnome_home',
    name: 'Gnome & Home',
    emoji: '🍄',
    description: 'Every gnome dreams of a toadstool of their own.',
    a: {'gnome'},
    b: {'toadstool'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'bird_paradise',
    name: 'Bird Paradise',
    emoji: '🐦',
    description: 'A bath *and* a buffet — the birds are singing about it.',
    a: {'birdbath'},
    b: {'birdfeeder'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'frog_prince',
    name: 'Frog Prince',
    emoji: '🐸',
    description: 'The frog claimed the lily pond. Naturally.',
    a: {'frog'},
    b: {'lilypond'},
    fx: _fxRipples,
  ),
  RoomCombo(
    id: 'duck_pond',
    name: 'Duck Pond',
    emoji: '🦆',
    description: 'Where there is water, there will be a duck.',
    a: {'duck'},
    b: {'lilypond', 'fountain', 'birdbath'},
    fx: _fxRipples,
  ),
  RoomCombo(
    id: 'zen_garden',
    name: 'Zen Garden',
    emoji: '🪷',
    description: 'Stacked stones, a bonsai, and perfect stillness.',
    a: {'stonestack', 'hotstones'},
    b: {'bonsai'},
    fx: _fxPetals,
  ),
  RoomCombo(
    id: 'master_gardener',
    name: 'Master Gardener',
    emoji: '🌱',
    description: 'A greenhouse with something growing beside it — expertise.',
    a: {'greenhouse'},
    b: _flowers,
    fx: _fxSparkle,
  ),
  // ── Pets & friends ─────────────────────────────────────────────────────────
  RoomCombo(
    id: 'unlikely_friends',
    name: 'Unlikely Friends',
    emoji: '🐾',
    description: 'Cat and dog, snuggled up. Miracles happen.',
    a: _cats,
    b: _dogs,
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'fish_watcher',
    name: 'Fish Watcher',
    emoji: '🐟',
    description: 'The cat has found television for cats.',
    a: _cats,
    b: {'fishbowl', 'aquarium', 'fishtank'},
    fx: _fxBubbles,
  ),
  RoomCombo(
    id: 'cheese_heist',
    name: 'Cheese Heist',
    emoji: '🧀',
    description: 'The mouse cannot believe its luck.',
    a: {'mouse'},
    b: {'cheeseboard'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'home_tweet_home',
    name: 'Home Tweet Home',
    emoji: '🎶',
    description: 'The parrot moved in next to its cage — on its own terms.',
    a: {'parrot'},
    b: {'birdcage'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'rubber_ducky',
    name: 'Rubber Ducky',
    emoji: '🛁',
    description: 'Bath time is infinitely better with a duck.',
    a: {'duck'},
    b: _tubs,
    fx: _fxBubbles,
  ),
  RoomCombo(
    id: 'salad_thief',
    name: 'Salad Thief',
    emoji: '🥬',
    description: 'Someone small and slow is eyeing the greens.',
    a: {'turtle', 'bunny'},
    b: {'salad', 'fruitbasket'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'snack_detective',
    name: 'Snack Detective',
    emoji: '🗑️',
    description: 'The dog is *investigating* the bin. Purely professional.',
    a: _dogs,
    b: {'trashcan'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'pet_lover',
    name: 'Best Friend',
    emoji: '💛',
    description: 'Endless pats for a very good friend.',
    a: {'petter'},
    b: {..._cats, ..._dogs, 'bunny', 'hamster', 'duck', 'turtle', 'parrot'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'toasty_cat',
    name: 'Toasty Cat',
    emoji: '🐱',
    description: 'The cat found the fireplace. It lives there now.',
    a: _cats,
    b: {'fireplace'},
    fx: _fxZzz,
  ),
  RoomCombo(
    id: 'hamster_power',
    name: 'Hamster Power',
    emoji: '🎡',
    description: 'The hamster is *sure* it can make the pinwheel spin.',
    a: {'hamster'},
    b: {'pinwheel'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'fish_reunion',
    name: 'Fish Reunion',
    emoji: '🐠',
    description: 'Neighbouring tanks — the fish have so much to bubble about.',
    a: {'aquarium', 'fishtank'},
    b: {'fishbowl'},
    fx: _fxBubbles,
  ),
  // ── People & their passions ────────────────────────────────────────────────
  RoomCombo(
    id: 'bookworm',
    name: 'Bookworm',
    emoji: '📚',
    description: 'So many books, so little time.',
    a: {'reader', 'student'},
    b: {'bookshelf', 'books'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'night_owl',
    name: 'Night Owl',
    emoji: '🦉',
    description: 'One more chapter. Just one more.',
    a: {'student'},
    b: {'lamp', 'arclamp', 'lavalamp'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'concert_pianist',
    name: 'Concert Pianist',
    emoji: '🎹',
    description: 'A private recital, just for the room.',
    a: kComboPeople,
    b: {'piano'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'rock_star',
    name: 'Rock Star',
    emoji: '🎸',
    description: 'The neighbours have opinions about the riffs.',
    a: kComboPeople,
    b: {'guitar'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'drummer',
    name: 'Drummer',
    emoji: '🥁',
    description: 'Keeping the beat — and everyone awake.',
    a: kComboPeople,
    b: {'drum'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'garage_band',
    name: 'Garage Band',
    emoji: '🎵',
    description: 'Guitar plus rhythm section: the band is forming.',
    a: {'guitar'},
    b: {'drum', 'piano'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'pro_gamer',
    name: 'Pro Gamer',
    emoji: '🎮',
    description: 'Just one more level. It is never one more level.',
    a: kComboPeople,
    b: {
      'arcade', 'arcadetower', 'retroconsole', 'modconsole', 'racingsim',
      'pinball', 'gamingchair', 'handheld',
    },
    fx: _fxPixels,
  ),
  RoomCombo(
    id: 'master_chef',
    name: 'Master Chef',
    emoji: '🍳',
    description: 'Something smells amazing in here.',
    a: kComboPeople,
    b: {'stove', 'pizzaoven', 'kitchenisland'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'barista',
    name: 'Barista',
    emoji: '☕',
    description: 'Latte art is being taken very seriously.',
    a: kComboPeople,
    b: {'espresso', 'coffeemaker'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'inner_peace',
    name: 'Inner Peace',
    emoji: '🧘',
    description: 'Breathe in… breathe out… perfectly calm.',
    a: {'meditator', 'yogatree'},
    b: {'spacandles', 'incense', 'diffuser', 'stonestack'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'stargazer',
    name: 'Stargazer',
    emoji: '🔭',
    description: 'Eyes on the sky, head in the clouds.',
    a: kComboPeople,
    b: {'telescope'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'true_artist',
    name: 'True Artist',
    emoji: '🎨',
    description: 'A masterpiece in progress — mind the splatters.',
    a: kComboPeople,
    b: {'easel', 'grandeasel', 'potterywheel', 'draftingtable', 'sculptstand'},
    fx: _fxSplats,
  ),
  RoomCombo(
    id: 'deep_sleep',
    name: 'Deep Sleep',
    emoji: '💤',
    description: 'Do not disturb until further notice.',
    a: {'sleeper', 'dreamer'},
    b: _beds,
    fx: _fxZzz,
  ),
  RoomCombo(
    id: 'champion',
    name: 'Champion',
    emoji: '🏆',
    description: 'All that training paid off.',
    a: {'jogger', 'stretch'},
    b: {'trophy'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'sweet_break',
    name: 'Sweet Break',
    emoji: '🍩',
    description: 'Coffee plus pastry — the international law of breaks.',
    a: {'coffee'},
    b: {'donut', 'croissant', 'cupcake', 'cinnamonroll', 'muffin', 'cookie'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'number_one_fan',
    name: 'Number-One Fan',
    emoji: '🎧',
    description: 'This song? On repeat. Forever.',
    a: {'listener'},
    b: {'recordplayer', 'jukebox', 'radio', 'speaker'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'grandmaster',
    name: 'Grandmaster',
    emoji: '♟️',
    description: 'Thinking twelve moves ahead.',
    a: kComboPeople,
    b: {'chessset', 'boardgame'},
    fx: _fxSparkle,
  ),
  // ── Things that belong together ────────────────────────────────────────────
  RoomCombo(
    id: 'fireside_nook',
    name: 'Fireside Nook',
    emoji: '🔥',
    description: 'A crackling fire and a soft seat — perfection.',
    a: {'fireplace'},
    b: _comfySeats,
    fx: _fxEmbers,
  ),
  RoomCombo(
    id: 'movie_night',
    name: 'Movie Night',
    emoji: '🍿',
    description: 'Lights down, volume up, snacks within reach.',
    a: {'tv'},
    b: _comfySeats,
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'tea_time',
    name: 'Tea Time',
    emoji: '🫖',
    description: 'The pot has found its cup. All is well.',
    a: {'teapot'},
    b: {'mug'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'big_breakfast',
    name: 'Big Breakfast',
    emoji: '🥞',
    description: 'The most important meal, taken very seriously.',
    a: {'toaster'},
    b: {'friedegg', 'breakfastplate', 'pancakes', 'waffle'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'pizzaiolo',
    name: 'Pizzaiolo',
    emoji: '🍕',
    description: 'Wood-fired and fresh out of the oven.',
    a: {'pizzaoven'},
    b: {'pizza'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'perfect_pairing',
    name: 'Perfect Pairing',
    emoji: '🍷',
    description: 'The wine met the cheese. Sophistication achieved.',
    a: {'winebottle'},
    b: {'cheeseboard'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'candlelit_dinner',
    name: 'Candlelit Dinner',
    emoji: '🕯️',
    description: 'Spaghetti by candlelight — very romantic.',
    a: {'candle', 'spacandles'},
    b: {'spaghetti'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'let_it_snow',
    name: 'Let It Snow',
    emoji: '❄️',
    description: 'A snow globe by the fire — instant winter holiday.',
    a: {'snowglobe'},
    b: {'fireplace'},
    fx: _fxSnow,
  ),
  RoomCombo(
    id: 'chill_beats',
    name: 'Chill Beats',
    emoji: '🎼',
    description: 'Warm speakers, soft seat, nowhere to be.',
    a: {'recordplayer', 'jukebox', 'radio', 'speaker'},
    b: _comfySeats,
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'photosynthesis',
    name: 'Photosynthesis',
    emoji: '☀️',
    description: 'The plant is *thriving* under its personal sun.',
    a: {'lamp', 'arclamp'},
    b: {'sunflower', 'plant', 'monstera', 'figtree'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'spa_day',
    name: 'Spa Day',
    emoji: '🧖',
    description: 'Warm water, warm towels, zero worries.',
    a: {'hottub', 'onsen', 'footbath', 'stonebath'},
    b: {'towelstack', 'bathrobe'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'bubble_bath',
    name: 'Bubble Bath',
    emoji: '🫧',
    description: 'Salts in, loofah ready — maximum bubbles.',
    a: _tubs,
    b: {'bathsalts', 'loofah'},
    fx: _fxBubbles,
  ),
  RoomCombo(
    id: 'observatory',
    name: 'Observatory',
    emoji: '🌌',
    description: 'A telescope at the window — the universe awaits.',
    a: {'telescope'},
    b: _windows,
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'world_explorer',
    name: 'World Explorer',
    emoji: '🗺️',
    description: 'Charting the globe by day, the stars by night.',
    a: {'globe'},
    b: {'telescope'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'wind_song',
    name: 'Wind Song',
    emoji: '🎐',
    description: 'The fan keeps the chime singing.',
    a: {'windchime'},
    b: {'fan'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'double_luck',
    name: 'Double Luck',
    emoji: '🍀',
    description: 'A lucky cat and a fortune ball — nothing can go wrong.',
    a: {'fortunecat'},
    b: {'magicball'},
    fx: _fxSparkle,
  ),
];

/// Lookup by [RoomCombo.id], for resolving persisted discovery ids.
final Map<String, RoomCombo> comboById = {
  for (final combo in roomCombos) combo.id: combo,
};

// ── Matching ─────────────────────────────────────────────────────────────────

/// How close two pieces must be to combine, as a fraction of their average
/// drawn size — centre distance ≤ (sizeA + sizeB) / 2 × this. Below 1.0 the
/// pieces have to visibly snuggle up before anything happens.
const double kComboReach = 0.85;

/// The relaxed factor for combos that are already active, so an effect doesn't
/// flicker on/off while a piece is dragged right at the boundary.
const double kComboRelease = 1.05;

/// A placed piece as the combo matcher sees it: instance id, its drawing glyph,
/// and its live centre/size in room pixels.
class PlacedPiece {
  const PlacedPiece({
    required this.iid,
    required this.glyph,
    required this.center,
    required this.size,
  });

  final String iid;
  final String glyph;
  final Offset center;
  final double size;
}

/// One active combo: the [combo] plus the pair of pieces that triggered it (the
/// closest matching pair, so each combo lights up at most once per room).
class ComboMatch {
  const ComboMatch({required this.combo, required this.a, required this.b});

  final RoomCombo combo;
  final PlacedPiece a;
  final PlacedPiece b;

  Offset get midpoint => Offset(
      (a.center.dx + b.center.dx) / 2, (a.center.dy + b.center.dy) / 2);
}

/// Finds every combo currently active among [pieces]: a piece from side `a`
/// within reach of a piece from side `b` (a piece never pairs with itself).
/// Combos whose ids are in [sticky] (already active last frame) use the relaxed
/// [kComboRelease] radius, giving the boundary hysteresis while dragging.
List<ComboMatch> matchCombos(
  List<PlacedPiece> pieces, {
  Set<String> sticky = const {},
}) {
  if (pieces.length < 2) return const [];
  final byGlyph = <String, List<PlacedPiece>>{};
  for (final p in pieces) {
    (byGlyph[p.glyph] ??= []).add(p);
  }
  final matches = <ComboMatch>[];
  for (final combo in roomCombos) {
    if (!combo.a.any(byGlyph.containsKey) ||
        !combo.b.any(byGlyph.containsKey)) {
      continue;
    }
    final factor = sticky.contains(combo.id) ? kComboRelease : kComboReach;
    PlacedPiece? bestA;
    PlacedPiece? bestB;
    var bestGap = 0.0; // only pairs with gap < 0 (inside reach) qualify
    for (final glyphA in combo.a) {
      for (final a in byGlyph[glyphA] ?? const <PlacedPiece>[]) {
        for (final glyphB in combo.b) {
          for (final b in byGlyph[glyphB] ?? const <PlacedPiece>[]) {
            if (a.iid == b.iid) continue;
            final reach = (a.size + b.size) / 2 * factor;
            final gap = (a.center - b.center).distance - reach;
            if (gap < bestGap) {
              bestGap = gap;
              bestA = a;
              bestB = b;
            }
          }
        }
      }
    }
    if (bestA != null && bestB != null) {
      matches.add(ComboMatch(combo: combo, a: bestA, b: bestB));
    }
  }
  return matches;
}
