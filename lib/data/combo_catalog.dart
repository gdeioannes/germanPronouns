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

/// Every famous-art homage on the Décor wall (all the `art*` paintings —
/// NOT `artmannequin`, which is Art Studio furniture). Any two of these side by
/// side make the gallery wall; a gate test keeps this set complete when new
/// art waves land.
const Set<String> _artHomages = {
  'artmondrian', 'artgothic', 'artsunflowers', 'artscream', 'artlilies',
  'artswirl', 'artwave', 'artpearl', 'artpipe', 'artrothko', 'artbird',
  'artharing', 'artcomic', 'artkandinsky', 'artwhistler', 'artpop',
  'artbasquiat', 'artapple', 'artballoon', 'artpollock', 'artnighthawks',
  'artpointillism', 'artsunrise', 'artcafe', 'artmelt', 'artnightwatch',
  'artvenus', 'artkiss', 'artmona', 'artarnolfini', 'artbosch', 'artcreation',
  'artcave', 'artegypt', 'artredroom', 'artrain', 'artflag', 'artgrid',
  'artmiro', 'artdance', 'artbar', 'artjungle', 'artvanitas', 'artgeisha',
  'artweeping', 'artselfvan', 'artguernica', 'artkahlo', 'artklimttree',
  'artballoondog',
};

/// The Van Gogh homages within [_artHomages] — two of them make his corner.
const Set<String> _vanGogh = {
  'artswirl', 'artcafe', 'artsunflowers', 'artselfvan',
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
  // ── Food & drink ───────────────────────────────────────────────────────────
  RoomCombo(
    id: 'combo_meal',
    name: 'Combo Meal',
    emoji: '🍔',
    description: 'Burger and fries — reunited at last.',
    a: {'burger'},
    b: {'fries'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'diner_date',
    name: 'Diner Date',
    emoji: '🥤',
    description: 'One milkshake, two straws. You know the rest.',
    a: {'milkshake'},
    b: {'burger'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'taco_fiesta',
    name: 'Taco Fiesta',
    emoji: '🎉',
    description: 'Tacos and a cocktail — the party found itself.',
    a: {'taco'},
    b: {'cocktail'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'izakaya_night',
    name: 'Izakaya Night',
    emoji: '🍣',
    description: 'Sushi and steaming ramen, side by side. Kanpai!',
    a: {'sushi'},
    b: {'ramen'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'dim_sum',
    name: 'Dim Sum',
    emoji: '🥟',
    description: 'Little baskets, big happiness.',
    a: {'dumplings'},
    b: {'soup'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'birthday_cake',
    name: 'Happy Birthday!',
    emoji: '🎂',
    description: 'A cake and a candle — make a wish.',
    a: {'cake'},
    b: {'candle'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'a_la_mode',
    name: 'À la Mode',
    emoji: '🥧',
    description: 'Warm pie, cold ice cream. Civilisation, perfected.',
    a: {'pie'},
    b: {'icecream'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'choco_dipped',
    name: 'Chocolate-Dipped',
    emoji: '🍓',
    description: 'The strawberry found the chocolate. Fate.',
    a: {'strawberry'},
    b: {'chocolatebar'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'sugar_rush',
    name: 'Sugar Rush',
    emoji: '🍭',
    description: 'That is a *lot* of sugar in one corner.',
    a: {'lollipop'},
    b: {'gummybears', 'candyapple'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'oktoberfest',
    name: 'Oktoberfest',
    emoji: '🥨',
    description: 'Pretzel plus sausage — the oom-pah band is warming up.',
    a: {'pretzel'},
    b: {'hotdog'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'churros_con_chocolate',
    name: 'Churros con Chocolate',
    emoji: '🍫',
    description: 'Crispy churros, warm chocolate — muy bien.',
    a: {'churros'},
    b: {'chocolatebar'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'petit_dejeuner',
    name: 'Petit Déjeuner',
    emoji: '🥐',
    description: 'A croissant and coffee — très français.',
    a: {'croissant'},
    b: {'coffeecup'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'avocado_toast',
    name: 'Avocado Toast',
    emoji: '🥑',
    description: 'The avocado has plans for that toast.',
    a: {'avocado'},
    b: {'toaster', 'bagel'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'tokyo_corner',
    name: 'Tokyo Corner',
    emoji: '🍱',
    description: 'The lucky cat approves of this menu.',
    a: {'fortunecat'},
    b: {'sushi', 'bento', 'ramen'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'chicken_and_waffles',
    name: 'Chicken & Waffles',
    emoji: '🍗',
    description: 'Sweet and savoury made peace long ago.',
    a: {'friedchicken'},
    b: {'waffle'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'picnic',
    name: 'Picnic',
    emoji: '🧺',
    description: 'A baguette and something nice — grab a blanket.',
    a: {'baguette'},
    b: {'cheeseboard', 'winebottle'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'christmas_bakery',
    name: 'Christmas Bakery',
    emoji: '🎄',
    description: 'Gingerbread and falling snow — it smells like December.',
    a: {'gingerbread'},
    b: {'snowglobe'},
    fx: _fxSnow,
  ),
  RoomCombo(
    id: 'snack_attack',
    name: 'Snack Attack',
    emoji: '🍿',
    description: 'Popcorn at the ready — nothing can stop the marathon now.',
    a: {'popcorn'},
    b: {'tv', 'microwave'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'vineyard',
    name: 'Vineyard',
    emoji: '🍇',
    description: 'From these humble grapes, greatness.',
    a: {'grapes'},
    b: {'winebottle'},
    fx: _fxSparkle,
  ),
  // ── Kitchen craft ──────────────────────────────────────────────────────────
  RoomCombo(
    id: 'bake_off',
    name: 'Bake-Off',
    emoji: '🧁',
    description: 'The mixer is on and something wonderful is rising.',
    a: {'standmixer', 'mixerpro', 'breadmaker'},
    b: {'cake', 'pie', 'muffin', 'cupcake'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'fresh_squeeze',
    name: 'Fresh Squeeze',
    emoji: '🍊',
    description: 'The fruit never stood a chance.',
    a: {'juicer'},
    b: {'fruitbowl', 'fruitbasket'},
    fx: _fxDroplets,
  ),
  RoomCombo(
    id: 'smoothie_bar',
    name: 'Smoothie Bar',
    emoji: '🥤',
    description: 'Everything within arm\'s reach goes in the blender.',
    a: {'blender'},
    b: {'strawberry', 'watermelon', 'milkshake'},
    fx: _fxBubbles,
  ),
  RoomCombo(
    id: 'sous_chef',
    name: 'Sous-Chef',
    emoji: '🔪',
    description: 'Mise en place — everything in its place.',
    a: {'cuttingboard'},
    b: {'steak', 'salad'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'secret_recipe',
    name: 'Secret Recipe',
    emoji: '🌶️',
    description: 'A pinch of this, a dash of that. Don\'t ask.',
    a: {'spicerack'},
    b: {'pot', 'stove'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'by_the_book',
    name: 'By the Book',
    emoji: '📖',
    description: 'Step three: do not improvise. (Someone is improvising.)',
    a: {'cookbook'},
    b: {'stove', 'standmixer', 'pot'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'sommelier',
    name: 'Sommelier',
    emoji: '🍷',
    description: 'This one has notes of oak, and of showing off.',
    a: {'winerack'},
    b: {'winebottle'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'proper_brew',
    name: 'Proper Brew',
    emoji: '☕',
    description: 'Kettle first, teapot second. There are rules.',
    a: {'kettle'},
    b: {'teapot'},
    fx: _fxSteam,
  ),
  // ── Home & cosy ────────────────────────────────────────────────────────────
  RoomCombo(
    id: 'looking_good',
    name: 'Looking Good!',
    emoji: '🪞',
    description: 'One more check in the mirror. Still fabulous.',
    a: kComboPeople,
    b: {'mirror'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'off_for_a_stroll',
    name: 'Off for a Stroll',
    emoji: '🧥',
    description: 'Coat on, world out there — let\'s go.',
    a: {'walker'},
    b: {'coatrack'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'five_more_minutes',
    name: 'Five More Minutes',
    emoji: '⏰',
    description: 'The clock and the bed are old enemies.',
    a: {'clock'},
    b: _beds,
    fx: _fxZzz,
  ),
  RoomCombo(
    id: 'extra_comfy',
    name: 'Extra Comfy',
    emoji: '🛋️',
    description: 'A cushion in exactly the right place changes everything.',
    a: {'cushion'},
    b: _comfySeats,
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'library_ladder',
    name: 'Library Ladder',
    emoji: '📚',
    description: 'For the books on the very top shelf — the best ones.',
    a: {'ladder'},
    b: {'bookshelf'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'decorating_day',
    name: 'Decorating Day',
    emoji: '🖌️',
    description: 'A ladder and paint cans. What could go wrong?',
    a: {'ladder'},
    b: {'paintcans'},
    fx: _fxSplats,
  ),
  RoomCombo(
    id: 'lullaby',
    name: 'Lullaby',
    emoji: '🎶',
    description: 'The music box plays, and little eyes grow heavy.',
    a: {'musicbox'},
    b: {'crib'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'playtime',
    name: 'Playtime',
    emoji: '🧸',
    description: 'Blocks stacked sky-high — until the giggling knock-down.',
    a: {'blocktower'},
    b: {'crib', 'kidsbed', 'bunkbed'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'sweet_dreams',
    name: 'Sweet Dreams',
    emoji: '🌙',
    description: 'The dream catcher is on duty tonight.',
    a: {'dreamcatcher'},
    b: _beds,
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'princess_canopy',
    name: 'Fairy-Tale Canopy',
    emoji: '✨',
    description: 'Fairy lights over a canopy bed — storybook approved.',
    a: {'fairylights'},
    b: {'canopybed'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'fresh_cut',
    name: 'Fresh Cut',
    emoji: '💐',
    description: 'Flowers by the vase — someone\'s about to arrange them.',
    a: {'vase'},
    b: {'tulips', 'daisies', 'roses'},
    fx: _fxPetals,
  ),
  RoomCombo(
    id: 'study_session',
    name: 'Study Session',
    emoji: '📝',
    description: 'Head down, notes out — the exam doesn\'t stand a chance.',
    a: {'student', 'reader'},
    b: {'desk'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'grand_salon',
    name: 'Grand Salon',
    emoji: '🎩',
    description: 'A chandelier over the piano — recitals only, please.',
    a: {'chandelier'},
    b: {'piano'},
    fx: _fxNotes,
  ),
  // ── Spa & bath ─────────────────────────────────────────────────────────────
  RoomCombo(
    id: 'throne_reading',
    name: 'Throne Reading',
    emoji: '🚽',
    description: 'Everyone does it. Nobody admits it.',
    a: {'toilet'},
    b: {'books'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'morning_routine',
    name: 'Morning Routine',
    emoji: '🪥',
    description: 'Sink, mirror, and a face that needs five more minutes.',
    a: {'sink'},
    b: {'mirror'},
    fx: _fxBubbles,
  ),
  RoomCombo(
    id: 'hotel_luxury',
    name: 'Hotel Luxury',
    emoji: '🛎️',
    description: 'Slippers and a bathrobe — checkout is never.',
    a: {'slippers'},
    b: {'bathrobe'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'warm_towels',
    name: 'Warm Towels',
    emoji: '♨️',
    description: 'A warm towel changes a person.',
    a: {'towelwarmer'},
    b: {'towelstack'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'deep_relaxation',
    name: 'Deep Relaxation',
    emoji: '💆',
    description: 'Hot stones, soft music, zero thoughts.',
    a: {'massagetable'},
    b: {'hotstones', 'spacandles', 'diffuser'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'sauna_master',
    name: 'Sauna Master',
    emoji: '🧖',
    description: 'One more ladle on the stones. Respect.',
    a: {'saunabucket'},
    b: {'saunacabin', 'steamsauna'},
    fx: _fxSteam,
  ),
  RoomCombo(
    id: 'ice_and_fire',
    name: 'Ice & Fire',
    emoji: '🥶',
    description: 'Hot, then cold, then very much awake.',
    a: {'coldplunge'},
    b: {'saunacabin', 'steamsauna', 'hottub', 'onsen'},
    fx: _fxSnow,
  ),
  RoomCombo(
    id: 'zen_falls',
    name: 'Zen Falls',
    emoji: '💦',
    description: 'Falling water and stacked stones — breathe.',
    a: {'waterfallwall'},
    b: {'stonestack', 'bonsai'},
    fx: _fxRipples,
  ),
  RoomCombo(
    id: 'do_not_disturb',
    name: 'Do Not Disturb',
    emoji: '😴',
    description: 'Eye mask on. The world can wait.',
    a: {'eyemask'},
    b: _beds,
    fx: _fxZzz,
  ),
  RoomCombo(
    id: 'pool_party',
    name: 'Pool Party',
    emoji: '🏖️',
    description: 'A float and a cocktail — summer is officially open.',
    a: {'poolfloat'},
    b: {'cocktail'},
    fx: _fxBubbles,
  ),
  RoomCombo(
    id: 'summer_day',
    name: 'Summer Day',
    emoji: '☀️',
    description: 'A lounger and cold watermelon. Perfection needs so little.',
    a: {'sunlounger'},
    b: {'watermelon'},
    fx: _fxStars,
  ),
  // ── Game room ──────────────────────────────────────────────────────────────
  RoomCombo(
    id: 'console_night',
    name: 'Console Night',
    emoji: '🎮',
    description: 'Controller paired, snacks pending.',
    a: {'gamepad'},
    b: {'tv'},
    fx: _fxPixels,
  ),
  RoomCombo(
    id: 'virtual_tourist',
    name: 'Virtual Tourist',
    emoji: '🥽',
    description: 'Physically here. Mentally on a dragon.',
    a: kComboPeople,
    b: {'vrheadset'},
    fx: _fxPixels,
  ),
  RoomCombo(
    id: 'bullseye',
    name: 'Bullseye',
    emoji: '🎯',
    description: 'Triple twenty. The trophy was earned.',
    a: {'dartboard'},
    b: {'trophy'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'pool_hall',
    name: 'Pool Hall',
    emoji: '🎱',
    description: 'Chalk the cue, drop a coin in the jukebox.',
    a: {'pooltable'},
    b: {'jukebox'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'match_day',
    name: 'Match Day',
    emoji: '⚽',
    description: 'The pennant is up — the table-football derby begins.',
    a: {'foosball'},
    b: {'pennant'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'game_night',
    name: 'Game Night',
    emoji: '🎲',
    description: 'Dice tower loaded. Friendships in danger.',
    a: {'dicetower'},
    b: {'boardgame'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'prize_corner',
    name: 'Prize Corner',
    emoji: '🧸',
    description: 'Two machines, zero chances, endless hope.',
    a: {'clawmachine'},
    b: {'gachapon'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'retro_diner',
    name: 'Retro Diner',
    emoji: '🌟',
    description: 'Neon buzz and pinball chimes — pure 1985.',
    a: {'neonsign'},
    b: {'jukebox', 'pinball'},
    fx: _fxPixels,
  ),
  RoomCombo(
    id: 'battlestation',
    name: 'Battlestation',
    emoji: '🖥️',
    description: 'The chair reclines. The RGB glows. Ready.',
    a: {'computer'},
    b: {'gamingchair'},
    fx: _fxPixels,
  ),
  RoomCombo(
    id: 'stereo_sound',
    name: 'Stereo Sound',
    emoji: '🔊',
    description: 'Two speakers — now the bass has a friend.',
    a: {'speaker'},
    b: {'speaker'},
    fx: _fxNotes,
  ),
  // ── Art studio & gallery ───────────────────────────────────────────────────
  RoomCombo(
    id: 'painters_kit',
    name: 'Painter\'s Kit',
    emoji: '🖌️',
    description: 'Palette and brushes together — inspiration pending.',
    a: {'palette'},
    b: {'brushjar'},
    fx: _fxSplats,
  ),
  RoomCombo(
    id: 'fresh_from_the_kiln',
    name: 'Fresh from the Kiln',
    emoji: '🏺',
    description: 'Still warm. Do not touch. (Everyone touches.)',
    a: {'pottery'},
    b: {'kiln'},
    fx: _fxEmbers,
  ),
  RoomCombo(
    id: 'street_art',
    name: 'Street Art',
    emoji: '🎨',
    description: 'The poster was fine. Now it\'s *art*.',
    a: {'spraycans'},
    b: {'poster'},
    fx: _fxSplats,
  ),
  RoomCombo(
    id: 'life_drawing',
    name: 'Life Drawing',
    emoji: '✏️',
    description: 'The mannequin holds the pose. Forever, if needed.',
    a: {'artmannequin'},
    b: {'sketchpad'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'colour_theory',
    name: 'Colour Theory',
    emoji: '🌈',
    description: 'The wheel says these go together. Science!',
    a: {'colorwheel'},
    b: {'paintcans'},
    fx: _fxSplats,
  ),
  RoomCombo(
    id: 'sculpture_garden',
    name: 'Sculpture Garden',
    emoji: '🏛️',
    description: 'Two statues exchanging very long, very stony looks.',
    a: {'bust'},
    b: {'marblestatue'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'gallery_wall',
    name: 'Gallery Wall',
    emoji: '🖼️',
    description: 'Two masterpieces side by side — your own little museum.',
    a: _artHomages,
    b: _artHomages,
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'van_gogh_corner',
    name: 'Van Gogh Corner',
    emoji: '🌻',
    description: 'Swirls, sunflowers, starry cafés — one artist, one wall.',
    a: _vanGogh,
    b: _vanGogh,
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'picasso_wing',
    name: 'Picasso Wing',
    emoji: '🕊️',
    description: 'Two Picassos together — angles everywhere.',
    a: {'artweeping'},
    b: {'artguernica'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'golden_hour',
    name: 'Golden Hour',
    emoji: '💛',
    description: 'Klimt beside Klimt — the wall is dripping gold.',
    a: {'artkiss'},
    b: {'artklimttree'},
    fx: _fxSparkle,
  ),
  // ── Garden & outdoors ──────────────────────────────────────────────────────
  RoomCombo(
    id: 'landscaper',
    name: 'Landscaper',
    emoji: '🌷',
    description: 'A wheelbarrow full of plans (and soil).',
    a: {'wheelbarrow'},
    b: _flowers,
    fx: _fxDroplets,
  ),
  RoomCombo(
    id: 'rose_garden',
    name: 'Rose Garden',
    emoji: '🌹',
    description: 'The roses found their arch — climbing starts today.',
    a: {'rosearch'},
    b: {'roses'},
    fx: _fxPetals,
  ),
  RoomCombo(
    id: 'garden_wedding',
    name: 'Garden Wedding',
    emoji: '💒',
    description: 'Someone under the rose arch — cue the tears.',
    a: kComboPeople,
    b: {'rosearch'},
    fx: _fxHearts,
  ),
  RoomCombo(
    id: 'lazy_afternoon',
    name: 'Lazy Afternoon',
    emoji: '🍃',
    description: 'A garden swing, a gentle breeze, no plans at all.',
    a: kComboPeople,
    b: {'gardenswing'},
    fx: _fxPetals,
  ),
  RoomCombo(
    id: 'wishing_fountain',
    name: 'Wishing Fountain',
    emoji: '⛲',
    description: 'The gnome has one wish, and it\'s a secret.',
    a: {'gnome'},
    b: {'fountain'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'spring_meadow',
    name: 'Spring Meadow',
    emoji: '🐰',
    description: 'A bunny in the flowers. That\'s it. That\'s the magic.',
    a: {'bunny'},
    b: {'daisies', 'tulips'},
    fx: _fxPetals,
  ),
  RoomCombo(
    id: 'hanami',
    name: 'Hanami',
    emoji: '🌸',
    description: 'A paper lantern under the blossom tree — petal season.',
    a: {'paperlantern'},
    b: {'blossomtree'},
    fx: _fxPetals,
  ),
  RoomCombo(
    id: 'prairie_wind',
    name: 'Prairie Wind',
    emoji: '🌾',
    description: 'The fan keeps the pampas grass dancing.',
    a: {'fan'},
    b: {'pampas'},
    fx: _fxPetals,
  ),
  // ── Pets & people, part two ────────────────────────────────────────────────
  RoomCombo(
    id: 'keyboard_cat',
    name: 'Keyboard Cat',
    emoji: '😹',
    description: 'The cat has an important message: "jjjjjjjjjjjj".',
    a: _cats,
    b: {'laptop', 'computer'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'uh_oh',
    name: 'Uh Oh…',
    emoji: '😼',
    description: 'The cat is beside the vase. It\'s only a matter of time.',
    a: _cats,
    b: {'vase'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'bed_hog',
    name: 'Bed Hog',
    emoji: '🐶',
    description: 'It\'s the dog\'s bed now. You may visit.',
    a: _dogs,
    b: _beds,
    fx: _fxZzz,
  ),
  RoomCombo(
    id: 'repeat_after_me',
    name: 'Repeat After Me',
    emoji: '🦜',
    description: 'The parrot is learning new words too. Slightly faster.',
    a: kComboPeople,
    b: {'parrot'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'running_club',
    name: 'Running Club',
    emoji: '🏃',
    description: 'Two athletes, one route, endless pace debates.',
    a: {'jogger'},
    b: {'walker', 'stretch'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'group_meditation',
    name: 'Group Meditation',
    emoji: '🕉️',
    description: 'Twice the calm. The room\'s pulse just dropped.',
    a: {'meditator'},
    b: {'meditator'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'early_bird',
    name: 'Early Bird',
    emoji: '🐥',
    description: 'The chick found the feeder before anyone was awake.',
    a: {'chick'},
    b: {'birdfeeder'},
    fx: _fxNotes,
  ),
  RoomCombo(
    id: 'tiny_kingdom',
    name: 'Tiny Kingdom',
    emoji: '🏰',
    description: 'A whole world in glass, and a very small monarch.',
    a: {'terrarium'},
    b: {'frog', 'snail'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'forest_floor',
    name: 'Forest Floor',
    emoji: '🐌',
    description: 'A snail and a toadstool — the tiniest fairy tale.',
    a: {'snail'},
    b: {'toadstool'},
    fx: _fxPetals,
  ),
  // ── Curiosities ────────────────────────────────────────────────────────────
  RoomCombo(
    id: 'around_the_world',
    name: 'Around the World',
    emoji: '🌍',
    description: 'Eighty days, one hourglass, no time to lose.',
    a: {'hourglass'},
    b: {'globe'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'speed_chess',
    name: 'Speed Chess',
    emoji: '⏳',
    description: 'Move fast. The sand is not on your side.',
    a: {'hourglass'},
    b: {'chessset'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'fortune_teller',
    name: 'Fortune Teller',
    emoji: '🔮',
    description: 'The crystals and the ball agree: good things ahead.',
    a: {'crystalcluster'},
    b: {'magicball'},
    fx: _fxStars,
  ),
  RoomCombo(
    id: 'rainbow_room',
    name: 'Rainbow Room',
    emoji: '🌈',
    description: 'Kaleidoscope plus crystals — the light went dancing.',
    a: {'kaleidoscope'},
    b: {'crystalcluster'},
    fx: _fxSparkle,
  ),
  RoomCombo(
    id: 'old_meets_new',
    name: 'Old Meets New',
    emoji: '🧮',
    description: 'The abacus would like a word with the computer.',
    a: {'abacus'},
    b: {'computer', 'laptop'},
    fx: _fxPixels,
  ),
  RoomCombo(
    id: 'hall_of_fame',
    name: 'Hall of Fame',
    emoji: '🏅',
    description: 'A pennant over the trophy — champions live here.',
    a: {'pennant'},
    b: {'trophy'},
    fx: _fxStars,
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
