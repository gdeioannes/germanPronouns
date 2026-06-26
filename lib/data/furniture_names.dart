/// Furniture words in each language the app teaches — English, German and
/// Spanish — keyed by the drawing/concept ([ShopItem.glyph]), so every colourway
/// of a piece shares one set of translations. German and Spanish include the
/// article, so the room doubles as gender practice.
///
/// Used by the room's double-tap info card, which shows a piece's name in the
/// languages the learner is studying (their active course's pair). Keep a row
/// for every glyph drawn in `FlatFurniture`; [furnitureName] falls back to the
/// English name when one is missing.
library;

/// The supported language codes (matching `UiLang` and course locales).
const List<String> kFurnitureLangs = ['en', 'de', 'es'];

/// Endonym shown as the label for each language column on the info card.
const Map<String, String> kLangLabel = {
  'en': 'English',
  'de': 'Deutsch',
  'es': 'Español',
};

/// glyph → { langCode: word }. German/Spanish carry the article.
const Map<String, Map<String, String>> furnitureNames = {
  'lamp': {'en': 'lamp', 'de': 'die Lampe', 'es': 'la lámpara'},
  'plant': {'en': 'plant', 'de': 'die Pflanze', 'es': 'la planta'},
  'chair': {'en': 'chair', 'de': 'der Stuhl', 'es': 'la silla'},
  'painting': {'en': 'painting', 'de': 'das Bild', 'es': 'el cuadro'},
  'clock': {'en': 'clock', 'de': 'die Uhr', 'es': 'el reloj'},
  'rug': {'en': 'rug', 'de': 'der Teppich', 'es': 'la alfombra'},
  'bookshelf': {'en': 'bookshelf', 'de': 'das Bücherregal', 'es': 'la estantería'},
  'cactus': {'en': 'cactus', 'de': 'der Kaktus', 'es': 'el cactus'},
  'table': {'en': 'table', 'de': 'der Tisch', 'es': 'la mesa'},
  'mirror': {'en': 'mirror', 'de': 'der Spiegel', 'es': 'el espejo'},
  'sofa': {'en': 'sofa', 'de': 'das Sofa', 'es': 'el sofá'},
  'desk': {'en': 'desk', 'de': 'der Schreibtisch', 'es': 'el escritorio'},
  'bed': {'en': 'bed', 'de': 'das Bett', 'es': 'la cama'},
  'vase': {'en': 'vase', 'de': 'die Vase', 'es': 'el jarrón'},
  'tv': {'en': 'TV', 'de': 'der Fernseher', 'es': 'el televisor'},
  'guitar': {'en': 'guitar', 'de': 'die Gitarre', 'es': 'la guitarra'},
  'fireplace': {'en': 'fireplace', 'de': 'der Kamin', 'es': 'la chimenea'},
  'fridge': {'en': 'fridge', 'de': 'der Kühlschrank', 'es': 'la nevera'},
  'stove': {'en': 'stove', 'de': 'der Herd', 'es': 'la cocina'},
  'pet': {'en': 'cat', 'de': 'die Katze', 'es': 'el gato'},
  'wardrobe': {'en': 'wardrobe', 'de': 'der Kleiderschrank', 'es': 'el armario'},
  'aquarium': {'en': 'aquarium', 'de': 'das Aquarium', 'es': 'el acuario'},
  'beanbag': {'en': 'beanbag', 'de': 'der Sitzsack', 'es': 'el puf'},
  'bathtub': {'en': 'bathtub', 'de': 'die Badewanne', 'es': 'la bañera'},
  'stool': {'en': 'stool', 'de': 'der Hocker', 'es': 'el taburete'},
  'armchair': {'en': 'armchair', 'de': 'der Sessel', 'es': 'el sillón'},
  'bench': {'en': 'bench', 'de': 'die Bank', 'es': 'el banco'},
  'ottoman': {'en': 'ottoman', 'de': 'der Polsterhocker', 'es': 'el puf otomano'},
  'nightstand': {'en': 'nightstand', 'de': 'der Nachttisch', 'es': 'la mesita de noche'},
  'dresser': {'en': 'dresser', 'de': 'die Kommode', 'es': 'la cómoda'},
  'cabinet': {'en': 'cabinet', 'de': 'der Schrank', 'es': 'el aparador'},
  'chest': {'en': 'chest', 'de': 'die Truhe', 'es': 'el baúl'},
  'wallshelf': {'en': 'shelf', 'de': 'das Regal', 'es': 'el estante'},
  'coatrack': {'en': 'coat rack', 'de': 'die Garderobe', 'es': 'el perchero'},
  'candle': {'en': 'candle', 'de': 'die Kerze', 'es': 'la vela'},
  'lantern': {'en': 'lantern', 'de': 'die Laterne', 'es': 'el farol'},
  'pendant': {'en': 'pendant light', 'de': 'die Hängelampe', 'es': 'la lámpara colgante'},
  'poster': {'en': 'poster', 'de': 'das Poster', 'es': 'el póster'},
  'photo': {'en': 'photo', 'de': 'das Foto', 'es': 'la foto'},
  'tapestry': {'en': 'tapestry', 'de': 'der Wandteppich', 'es': 'el tapiz'},
  'succulent': {'en': 'succulent', 'de': 'die Sukkulente', 'es': 'la suculenta'},
  'hangingplant': {'en': 'hanging plant', 'de': 'die Hängepflanze', 'es': 'la planta colgante'},
  'palm': {'en': 'palm', 'de': 'die Palme', 'es': 'la palmera'},
  'computer': {'en': 'computer', 'de': 'der Computer', 'es': 'la computadora'},
  'laptop': {'en': 'laptop', 'de': 'der Laptop', 'es': 'el portátil'},
  'arcade': {'en': 'arcade machine', 'de': 'der Spielautomat', 'es': 'la máquina arcade'},
  'speaker': {'en': 'speaker', 'de': 'der Lautsprecher', 'es': 'el altavoz'},
  'radio': {'en': 'radio', 'de': 'das Radio', 'es': 'la radio'},
  'piano': {'en': 'piano', 'de': 'das Klavier', 'es': 'el piano'},
  'microwave': {'en': 'microwave', 'de': 'die Mikrowelle', 'es': 'el microondas'},
  'kettle': {'en': 'kettle', 'de': 'der Wasserkocher', 'es': 'el hervidor'},
  'toaster': {'en': 'toaster', 'de': 'der Toaster', 'es': 'la tostadora'},
  'mug': {'en': 'mug', 'de': 'die Tasse', 'es': 'la taza'},
  'teapot': {'en': 'teapot', 'de': 'die Teekanne', 'es': 'la tetera'},
  'pot': {'en': 'cooking pot', 'de': 'der Topf', 'es': 'la olla'},
  'sink': {'en': 'sink', 'de': 'das Waschbecken', 'es': 'el lavabo'},
  'toilet': {'en': 'toilet', 'de': 'die Toilette', 'es': 'el inodoro'},
  'trashcan': {'en': 'trash can', 'de': 'der Mülleimer', 'es': 'el cubo de basura'},
  'books': {'en': 'books', 'de': 'die Bücher', 'es': 'los libros'},
  'cushion': {'en': 'cushion', 'de': 'das Kissen', 'es': 'el cojín'},
  'globe': {'en': 'globe', 'de': 'der Globus', 'es': 'el globo terráqueo'},
  'trophy': {'en': 'trophy', 'de': 'der Pokal', 'es': 'el trofeo'},
  'fishbowl': {'en': 'fishbowl', 'de': 'das Goldfischglas', 'es': 'la pecera'},
  'fan': {'en': 'fan', 'de': 'der Ventilator', 'es': 'el ventilador'},
  'ladder': {'en': 'ladder', 'de': 'die Leiter', 'es': 'la escalera'},
  'birdcage': {'en': 'birdcage', 'de': 'der Vogelkäfig', 'es': 'la jaula'},
  'drum': {'en': 'drum', 'de': 'die Trommel', 'es': 'el tambor'},
  'telescope': {'en': 'telescope', 'de': 'das Teleskop', 'es': 'el telescopio'},
  'window': {'en': 'window', 'de': 'das Fenster', 'es': 'la ventana'},
  'archwindow': {'en': 'arched window', 'de': 'das Bogenfenster', 'es': 'la ventana de arco'},
  'roundwindow': {'en': 'round window', 'de': 'das Rundfenster', 'es': 'la ventana redonda'},
};

/// The word for [glyph] in [lang], or its English word, or [fallback] (the
/// item's display name) when the glyph isn't in the table.
String furnitureName(String glyph, String lang, {required String fallback}) {
  final row = furnitureNames[glyph];
  if (row == null) return fallback;
  return row[lang] ?? row['en'] ?? fallback;
}
