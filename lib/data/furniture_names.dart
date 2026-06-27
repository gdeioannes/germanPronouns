/// Furniture words in each language the app teaches — English, German, Spanish
/// and Czech — keyed by the drawing/concept ([ShopItem.glyph]), so every
/// colourway of a piece shares one set of translations. German and Spanish
/// include the article, so the room doubles as gender practice; Czech has no
/// articles, so it carries the bare nominative noun.
///
/// Used by the room's double-tap info card, which shows a piece's name in the
/// languages the learner is studying (their active course's pair). Keep a row
/// for every glyph drawn in `FlatFurniture`; [furnitureName] falls back to the
/// English name when one is missing.
library;

/// The supported language codes (matching `UiLang` and course locales).
const List<String> kFurnitureLangs = ['en', 'de', 'es', 'cs'];

/// Endonym shown as the label for each language column on the info card.
const Map<String, String> kLangLabel = {
  'en': 'English',
  'de': 'Deutsch',
  'es': 'Español',
  'cs': 'Čeština',
};

/// glyph → { langCode: word }. German/Spanish carry the article.
const Map<String, Map<String, String>> furnitureNames = {
  'lamp': {'en': 'lamp', 'de': 'die Lampe', 'es': 'la lámpara', 'cs': 'lampa'},
  'plant': {'en': 'plant', 'de': 'die Pflanze', 'es': 'la planta', 'cs': 'rostlina'},
  'chair': {'en': 'chair', 'de': 'der Stuhl', 'es': 'la silla', 'cs': 'židle'},
  'painting': {'en': 'painting', 'de': 'das Bild', 'es': 'el cuadro', 'cs': 'obraz'},
  'clock': {'en': 'clock', 'de': 'die Uhr', 'es': 'el reloj', 'cs': 'hodiny'},
  'rug': {'en': 'rug', 'de': 'der Teppich', 'es': 'la alfombra', 'cs': 'koberec'},
  'bookshelf': {'en': 'bookshelf', 'de': 'das Bücherregal', 'es': 'la estantería', 'cs': 'knihovna'},
  'cactus': {'en': 'cactus', 'de': 'der Kaktus', 'es': 'el cactus', 'cs': 'kaktus'},
  'table': {'en': 'table', 'de': 'der Tisch', 'es': 'la mesa', 'cs': 'stůl'},
  'mirror': {'en': 'mirror', 'de': 'der Spiegel', 'es': 'el espejo', 'cs': 'zrcadlo'},
  'sofa': {'en': 'sofa', 'de': 'das Sofa', 'es': 'el sofá', 'cs': 'pohovka'},
  'desk': {'en': 'desk', 'de': 'der Schreibtisch', 'es': 'el escritorio', 'cs': 'psací stůl'},
  'bed': {'en': 'bed', 'de': 'das Bett', 'es': 'la cama', 'cs': 'postel'},
  'vase': {'en': 'vase', 'de': 'die Vase', 'es': 'el jarrón', 'cs': 'váza'},
  'tv': {'en': 'TV', 'de': 'der Fernseher', 'es': 'el televisor', 'cs': 'televize'},
  'guitar': {'en': 'guitar', 'de': 'die Gitarre', 'es': 'la guitarra', 'cs': 'kytara'},
  'fireplace': {'en': 'fireplace', 'de': 'der Kamin', 'es': 'la chimenea', 'cs': 'krb'},
  'fridge': {'en': 'fridge', 'de': 'der Kühlschrank', 'es': 'la nevera', 'cs': 'lednice'},
  'stove': {'en': 'stove', 'de': 'der Herd', 'es': 'la cocina', 'cs': 'sporák'},
  'pet': {'en': 'cat', 'de': 'die Katze', 'es': 'el gato', 'cs': 'kočka'},
  'wardrobe': {'en': 'wardrobe', 'de': 'der Kleiderschrank', 'es': 'el armario', 'cs': 'šatní skříň'},
  'aquarium': {'en': 'aquarium', 'de': 'das Aquarium', 'es': 'el acuario', 'cs': 'akvárium'},
  'beanbag': {'en': 'beanbag', 'de': 'der Sitzsack', 'es': 'el puf', 'cs': 'sedací vak'},
  'bathtub': {'en': 'bathtub', 'de': 'die Badewanne', 'es': 'la bañera', 'cs': 'vana'},
  'stool': {'en': 'stool', 'de': 'der Hocker', 'es': 'el taburete', 'cs': 'stolička'},
  'armchair': {'en': 'armchair', 'de': 'der Sessel', 'es': 'el sillón', 'cs': 'křeslo'},
  'bench': {'en': 'bench', 'de': 'die Bank', 'es': 'el banco', 'cs': 'lavice'},
  'ottoman': {'en': 'ottoman', 'de': 'der Polsterhocker', 'es': 'el puf otomano', 'cs': 'taburet'},
  'nightstand': {'en': 'nightstand', 'de': 'der Nachttisch', 'es': 'la mesita de noche', 'cs': 'noční stolek'},
  'dresser': {'en': 'dresser', 'de': 'die Kommode', 'es': 'la cómoda', 'cs': 'komoda'},
  'cabinet': {'en': 'cabinet', 'de': 'der Schrank', 'es': 'el aparador', 'cs': 'skříňka'},
  'chest': {'en': 'chest', 'de': 'die Truhe', 'es': 'el baúl', 'cs': 'truhla'},
  'wallshelf': {'en': 'shelf', 'de': 'das Regal', 'es': 'el estante', 'cs': 'police'},
  'coatrack': {'en': 'coat rack', 'de': 'die Garderobe', 'es': 'el perchero', 'cs': 'věšák'},
  'candle': {'en': 'candle', 'de': 'die Kerze', 'es': 'la vela', 'cs': 'svíčka'},
  'lantern': {'en': 'lantern', 'de': 'die Laterne', 'es': 'el farol', 'cs': 'lucerna'},
  'pendant': {'en': 'pendant light', 'de': 'die Hängelampe', 'es': 'la lámpara colgante', 'cs': 'závěsná lampa'},
  'poster': {'en': 'poster', 'de': 'das Poster', 'es': 'el póster', 'cs': 'plakát'},
  'photo': {'en': 'photo', 'de': 'das Foto', 'es': 'la foto', 'cs': 'fotografie'},
  'tapestry': {'en': 'tapestry', 'de': 'der Wandteppich', 'es': 'el tapiz', 'cs': 'tapiserie'},
  'succulent': {'en': 'succulent', 'de': 'die Sukkulente', 'es': 'la suculenta', 'cs': 'sukulent'},
  'hangingplant': {'en': 'hanging plant', 'de': 'die Hängepflanze', 'es': 'la planta colgante', 'cs': 'závěsná rostlina'},
  'palm': {'en': 'palm', 'de': 'die Palme', 'es': 'la palmera', 'cs': 'palma'},
  'computer': {'en': 'computer', 'de': 'der Computer', 'es': 'la computadora', 'cs': 'počítač'},
  'laptop': {'en': 'laptop', 'de': 'der Laptop', 'es': 'el portátil', 'cs': 'notebook'},
  'arcade': {'en': 'arcade machine', 'de': 'der Spielautomat', 'es': 'la máquina arcade', 'cs': 'hrací automat'},
  'speaker': {'en': 'speaker', 'de': 'der Lautsprecher', 'es': 'el altavoz', 'cs': 'reproduktor'},
  'radio': {'en': 'radio', 'de': 'das Radio', 'es': 'la radio', 'cs': 'rádio'},
  'piano': {'en': 'piano', 'de': 'das Klavier', 'es': 'el piano', 'cs': 'klavír'},
  'microwave': {'en': 'microwave', 'de': 'die Mikrowelle', 'es': 'el microondas', 'cs': 'mikrovlnná trouba'},
  'kettle': {'en': 'kettle', 'de': 'der Wasserkocher', 'es': 'el hervidor', 'cs': 'rychlovarná konvice'},
  'toaster': {'en': 'toaster', 'de': 'der Toaster', 'es': 'la tostadora', 'cs': 'topinkovač'},
  'mug': {'en': 'mug', 'de': 'die Tasse', 'es': 'la taza', 'cs': 'hrnek'},
  'teapot': {'en': 'teapot', 'de': 'die Teekanne', 'es': 'la tetera', 'cs': 'čajník'},
  'pot': {'en': 'cooking pot', 'de': 'der Topf', 'es': 'la olla', 'cs': 'hrnec'},
  'sink': {'en': 'sink', 'de': 'das Waschbecken', 'es': 'el lavabo', 'cs': 'umyvadlo'},
  'toilet': {'en': 'toilet', 'de': 'die Toilette', 'es': 'el inodoro', 'cs': 'toaleta'},
  'trashcan': {'en': 'trash can', 'de': 'der Mülleimer', 'es': 'el cubo de basura', 'cs': 'odpadkový koš'},
  'books': {'en': 'books', 'de': 'die Bücher', 'es': 'los libros', 'cs': 'knihy'},
  'cushion': {'en': 'cushion', 'de': 'das Kissen', 'es': 'el cojín', 'cs': 'polštář'},
  'globe': {'en': 'globe', 'de': 'der Globus', 'es': 'el globo terráqueo', 'cs': 'globus'},
  'trophy': {'en': 'trophy', 'de': 'der Pokal', 'es': 'el trofeo', 'cs': 'pohár'},
  'fishbowl': {'en': 'fishbowl', 'de': 'das Goldfischglas', 'es': 'la pecera', 'cs': 'kulaté akvárium'},
  'fan': {'en': 'fan', 'de': 'der Ventilator', 'es': 'el ventilador', 'cs': 'ventilátor'},
  'ladder': {'en': 'ladder', 'de': 'die Leiter', 'es': 'la escalera', 'cs': 'žebřík'},
  'birdcage': {'en': 'birdcage', 'de': 'der Vogelkäfig', 'es': 'la jaula', 'cs': 'ptačí klec'},
  'drum': {'en': 'drum', 'de': 'die Trommel', 'es': 'el tambor', 'cs': 'buben'},
  'telescope': {'en': 'telescope', 'de': 'das Teleskop', 'es': 'el telescopio', 'cs': 'dalekohled'},
  'window': {'en': 'window', 'de': 'das Fenster', 'es': 'la ventana', 'cs': 'okno'},
  'archwindow': {'en': 'arched window', 'de': 'das Bogenfenster', 'es': 'la ventana de arco', 'cs': 'obloukové okno'},
  'roundwindow': {'en': 'round window', 'de': 'das Rundfenster', 'es': 'la ventana redonda', 'cs': 'kulaté okno'},
  // People — the calm characters. Named for who they are or what they're doing,
  // so double-tapping one still teaches a useful word.
  'reader': {'en': 'reader', 'de': 'der Leser', 'es': 'el lector', 'cs': 'čtenář'},
  'student': {'en': 'student', 'de': 'der Student', 'es': 'el estudiante', 'cs': 'student'},
  'meditator': {'en': 'meditation', 'de': 'die Meditation', 'es': 'la meditación', 'cs': 'meditace'},
  'yogatree': {'en': 'yoga', 'de': 'das Yoga', 'es': 'el yoga', 'cs': 'jóga'},
  'stretch': {'en': 'stretching', 'de': 'das Dehnen', 'es': 'el estiramiento', 'cs': 'protahování'},
  'jogger': {'en': 'jogger', 'de': 'der Jogger', 'es': 'el corredor', 'cs': 'běžec'},
  'walker': {'en': 'walk', 'de': 'der Spaziergang', 'es': 'el paseo', 'cs': 'procházka'},
  'coffee': {'en': 'coffee', 'de': 'der Kaffee', 'es': 'el café', 'cs': 'káva'},
  'sleeper': {'en': 'sleep', 'de': 'der Schlaf', 'es': 'el sueño', 'cs': 'spánek'},
  'dreamer': {'en': 'dreamer', 'de': 'der Träumer', 'es': 'el soñador', 'cs': 'snílek'},
  'petter': {'en': 'pet lover', 'de': 'der Tierfreund', 'es': 'el amante de los animales', 'cs': 'milovník zvířat'},
  'listener': {'en': 'music', 'de': 'die Musik', 'es': 'la música', 'cs': 'hudba'},
};

/// The word for [glyph] in [lang], or its English word, or [fallback] (the
/// item's display name) when the glyph isn't in the table.
String furnitureName(String glyph, String lang, {required String fallback}) {
  final row = furnitureNames[glyph];
  if (row == null) return fallback;
  return row[lang] ?? row['en'] ?? fallback;
}
