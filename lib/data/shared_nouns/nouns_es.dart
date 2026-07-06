import '../content/noun_collection.dart';
import '../noun_database.dart';
import '../../models/quiz_config.dart';

/// The shared Spanish noun list — reference vocabulary for every course that
/// teaches Spanish (today: `de_es`, whose learners speak German). Meanings are
/// German (the course's main language); the `english` gloss stays the
/// canonical fallback. Published to `assets/content/shared/nouns/es.json`.
GermanNoun _n(
  String noun,
  String gender,
  String english,
  String de,
  List<String> categories, {
  NounDifficulty difficulty = NounDifficulty.beginner,
}) => GermanNoun(
  noun: noun,
  gender: gender,
  english: english,
  categories: categories,
  difficulty: difficulty,
  declensionSafe: true,
  meanings: {'de': de},
);

final NounCollection spanishNounCollection = NounCollection(
  // German-first labels: the Word Library chrome of a Spanish course is German.
  categoryDisplayNames: const {
    'family': 'Familie (la familia)',
    'food': 'Essen (la comida)',
    'drinks': 'Getränke (las bebidas)',
    'animals': 'Tiere (los animales)',
    'bodyParts': 'Körper (el cuerpo)',
    'clothing': 'Kleidung (la ropa)',
    'city': 'Stadt (la ciudad)',
    'transport': 'Verkehr (el transporte)',
    'school': 'Schule (la escuela)',
    'time': 'Zeit (el tiempo)',
    'nature': 'Natur (la naturaleza)',
    'professions': 'Berufe (las profesiones)',
  },
  nouns: [
    // Family
    _n('padre', 'm', 'father', 'der Vater', ['family']),
    _n('madre', 'f', 'mother', 'die Mutter', ['family']),
    _n('hermano', 'm', 'brother', 'der Bruder', ['family']),
    _n('hermana', 'f', 'sister', 'die Schwester', ['family']),
    _n('hijo', 'm', 'son', 'der Sohn', ['family']),
    _n('hija', 'f', 'daughter', 'die Tochter', ['family']),
    _n('abuelo', 'm', 'grandfather', 'der Großvater', ['family']),
    _n('abuela', 'f', 'grandmother', 'die Großmutter', ['family']),
    _n('tío', 'm', 'uncle', 'der Onkel', ['family']),
    _n('tía', 'f', 'aunt', 'die Tante', ['family']),
    _n('niño', 'm', 'child/boy', 'das Kind / der Junge', ['family']),
    _n('familia', 'f', 'family', 'die Familie', ['family']),
    _n('amigo', 'm', 'friend', 'der Freund', ['family']),
    // Food
    _n('pan', 'm', 'bread', 'das Brot', ['food']),
    _n('queso', 'm', 'cheese', 'der Käse', ['food']),
    _n('huevo', 'm', 'egg', 'das Ei', ['food']),
    _n('carne', 'f', 'meat', 'das Fleisch', ['food']),
    _n('pescado', 'm', 'fish (as food)', 'der Fisch (Speise)', ['food']),
    _n('arroz', 'm', 'rice', 'der Reis', ['food']),
    _n('manzana', 'f', 'apple', 'der Apfel', ['food']),
    _n('plátano', 'm', 'banana', 'die Banane', ['food']),
    _n('tomate', 'm', 'tomato', 'die Tomate', ['food']),
    _n('patata', 'f', 'potato', 'die Kartoffel', ['food']),
    _n('ensalada', 'f', 'salad', 'der Salat', ['food']),
    _n('sopa', 'f', 'soup', 'die Suppe', ['food']),
    // Drinks
    _n('agua', 'f', 'water', 'das Wasser', ['drinks']),
    _n('café', 'm', 'coffee', 'der Kaffee', ['drinks']),
    _n('té', 'm', 'tea', 'der Tee', ['drinks']),
    _n('leche', 'f', 'milk', 'die Milch', ['drinks']),
    _n('zumo', 'm', 'juice', 'der Saft', ['drinks']),
    _n('vino', 'm', 'wine', 'der Wein', ['drinks']),
    _n('cerveza', 'f', 'beer', 'das Bier', ['drinks']),
    _n('botella', 'f', 'bottle', 'die Flasche', ['drinks']),
    // Animals
    _n('perro', 'm', 'dog', 'der Hund', ['animals']),
    _n('gato', 'm', 'cat', 'die Katze', ['animals']),
    _n('caballo', 'm', 'horse', 'das Pferd', ['animals']),
    _n('vaca', 'f', 'cow', 'die Kuh', ['animals']),
    _n('pájaro', 'm', 'bird', 'der Vogel', ['animals']),
    _n('pez', 'm', 'fish', 'der Fisch', ['animals']),
    _n('ratón', 'm', 'mouse', 'die Maus', ['animals']),
    _n('oveja', 'f', 'sheep', 'das Schaf', ['animals']),
    // Body
    _n('cabeza', 'f', 'head', 'der Kopf', ['bodyParts']),
    _n('mano', 'f', 'hand', 'die Hand', ['bodyParts']),
    _n('ojo', 'm', 'eye', 'das Auge', ['bodyParts']),
    _n('oreja', 'f', 'ear', 'das Ohr', ['bodyParts']),
    _n('boca', 'f', 'mouth', 'der Mund', ['bodyParts']),
    _n('nariz', 'f', 'nose', 'die Nase', ['bodyParts']),
    _n('brazo', 'm', 'arm', 'der Arm', ['bodyParts']),
    _n('pierna', 'f', 'leg', 'das Bein', ['bodyParts']),
    _n('pie', 'm', 'foot', 'der Fuß', ['bodyParts']),
    _n('corazón', 'm', 'heart', 'das Herz', ['bodyParts']),
    // Clothing
    _n('camisa', 'f', 'shirt', 'das Hemd', ['clothing']),
    _n('camiseta', 'f', 't-shirt', 'das T-Shirt', ['clothing']),
    _n('pantalón', 'm', 'trousers', 'die Hose', ['clothing']),
    _n('falda', 'f', 'skirt', 'der Rock', ['clothing']),
    _n('vestido', 'm', 'dress', 'das Kleid', ['clothing']),
    _n('zapato', 'm', 'shoe', 'der Schuh', ['clothing']),
    _n('abrigo', 'm', 'coat', 'der Mantel', ['clothing']),
    _n('sombrero', 'm', 'hat', 'der Hut', ['clothing']),
    // City
    _n('ciudad', 'f', 'city', 'die Stadt', ['city']),
    _n('calle', 'f', 'street', 'die Straße', ['city']),
    _n('casa', 'f', 'house', 'das Haus', ['city']),
    _n('plaza', 'f', 'square', 'der Platz', ['city']),
    _n('mercado', 'm', 'market', 'der Markt', ['city']),
    _n('tienda', 'f', 'shop', 'der Laden', ['city']),
    _n('iglesia', 'f', 'church', 'die Kirche', ['city']),
    _n('museo', 'm', 'museum', 'das Museum', ['city']),
    _n('banco', 'm', 'bank', 'die Bank', ['city']),
    _n('parque', 'm', 'park', 'der Park', ['city']),
    _n('hospital', 'm', 'hospital', 'das Krankenhaus', ['city']),
    // Transport
    _n('coche', 'm', 'car', 'das Auto', ['transport']),
    _n('tren', 'm', 'train', 'der Zug', ['transport']),
    _n('autobús', 'm', 'bus', 'der Bus', ['transport']),
    _n('avión', 'm', 'airplane', 'das Flugzeug', ['transport']),
    _n('bicicleta', 'f', 'bicycle', 'das Fahrrad', ['transport']),
    _n('barco', 'm', 'ship/boat', 'das Schiff', ['transport']),
    _n('taxi', 'm', 'taxi', 'das Taxi', ['transport']),
    _n('billete', 'm', 'ticket', 'die Fahrkarte', ['transport']),
    // School
    _n('escuela', 'f', 'school', 'die Schule', ['school']),
    _n('libro', 'm', 'book', 'das Buch', ['school']),
    _n('cuaderno', 'm', 'notebook', 'das Heft', ['school']),
    _n('lápiz', 'm', 'pencil', 'der Bleistift', ['school']),
    _n('mesa', 'f', 'table', 'der Tisch', ['school']),
    _n('silla', 'f', 'chair', 'der Stuhl', ['school']),
    _n('palabra', 'f', 'word', 'das Wort', ['school']),
    _n('pregunta', 'f', 'question', 'die Frage', ['school']),
    _n('respuesta', 'f', 'answer', 'die Antwort', ['school']),
    _n('examen', 'm', 'exam', 'die Prüfung', ['school']),
    // Time
    _n('día', 'm', 'day', 'der Tag', ['time']),
    _n('semana', 'f', 'week', 'die Woche', ['time']),
    _n('mes', 'm', 'month', 'der Monat', ['time']),
    _n('año', 'm', 'year', 'das Jahr', ['time']),
    _n('hora', 'f', 'hour', 'die Stunde', ['time']),
    _n('minuto', 'm', 'minute', 'die Minute', ['time']),
    _n('mañana', 'f', 'morning', 'der Morgen', ['time']),
    _n('tarde', 'f', 'afternoon/evening', 'der Nachmittag / der Abend', [
      'time',
    ]),
    _n('noche', 'f', 'night', 'die Nacht', ['time']),
    _n('fin de semana', 'm', 'weekend', 'das Wochenende', ['time']),
    // Nature
    _n('sol', 'm', 'sun', 'die Sonne', ['nature']),
    _n('luna', 'f', 'moon', 'der Mond', ['nature']),
    _n('cielo', 'm', 'sky', 'der Himmel', ['nature']),
    _n('mar', 'm', 'sea', 'das Meer', ['nature']),
    _n('río', 'm', 'river', 'der Fluss', ['nature']),
    _n('montaña', 'f', 'mountain', 'der Berg', ['nature']),
    _n('árbol', 'm', 'tree', 'der Baum', ['nature']),
    _n('flor', 'f', 'flower', 'die Blume', ['nature']),
    _n('playa', 'f', 'beach', 'der Strand', ['nature']),
    _n('isla', 'f', 'island', 'die Insel', ['nature']),
    // Professions
    _n('médico', 'm', 'doctor', 'der Arzt', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('profesor', 'm', 'teacher', 'der Lehrer', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('estudiante', 'm', 'student', 'der Student', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('camarero', 'm', 'waiter', 'der Kellner', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('cocinero', 'm', 'cook', 'der Koch', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('policía', 'm', 'police officer', 'der Polizist', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('vendedor', 'm', 'salesperson', 'der Verkäufer', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('ingeniero', 'm', 'engineer', 'der Ingenieur', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
  ],
);
