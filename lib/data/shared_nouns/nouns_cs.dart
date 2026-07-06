import '../content/noun_collection.dart';
import '../noun_database.dart';
import '../../models/quiz_config.dart';

/// The shared Czech noun list — reference vocabulary for every course that
/// teaches Czech (today: `de_cs`, whose learners speak German). Meanings are
/// German (the course's main language); the `english` gloss stays the
/// canonical fallback. Published to `assets/content/shared/nouns/cs.json`.
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

final NounCollection czechNounCollection = NounCollection(
  // German-first labels: the Word Library chrome of the Czech course is German.
  categoryDisplayNames: const {
    'family': 'Familie (rodina)',
    'food': 'Essen (jídlo)',
    'drinks': 'Getränke (nápoje)',
    'animals': 'Tiere (zvířata)',
    'bodyParts': 'Körper (tělo)',
    'city': 'Stadt (město)',
    'transport': 'Verkehr (doprava)',
    'school': 'Schule (škola)',
    'time': 'Zeit (čas)',
    'nature': 'Natur (příroda)',
    'professions': 'Berufe (povolání)',
  },
  nouns: [
    // Family
    _n('otec', 'm', 'father', 'der Vater', ['family']),
    _n('matka', 'f', 'mother', 'die Mutter', ['family']),
    _n('bratr', 'm', 'brother', 'der Bruder', ['family']),
    _n('sestra', 'f', 'sister', 'die Schwester', ['family']),
    _n('syn', 'm', 'son', 'der Sohn', ['family']),
    _n('dcera', 'f', 'daughter', 'die Tochter', ['family']),
    _n('dědeček', 'm', 'grandfather', 'der Großvater', ['family']),
    _n('babička', 'f', 'grandmother', 'die Großmutter', ['family']),
    _n('rodina', 'f', 'family', 'die Familie', ['family']),
    _n('dítě', 'n', 'child', 'das Kind', ['family']),
    _n('kamarád', 'm', 'friend', 'der Freund', ['family']),
    // Food
    _n('chléb', 'm', 'bread', 'das Brot', ['food']),
    _n('sýr', 'm', 'cheese', 'der Käse', ['food']),
    _n('vejce', 'n', 'egg', 'das Ei', ['food']),
    _n('maso', 'n', 'meat', 'das Fleisch', ['food']),
    _n('ryba', 'f', 'fish', 'der Fisch', ['food']),
    _n('rýže', 'f', 'rice', 'der Reis', ['food']),
    _n('jablko', 'n', 'apple', 'der Apfel', ['food']),
    _n('polévka', 'f', 'soup', 'die Suppe', ['food']),
    _n('brambora', 'f', 'potato', 'die Kartoffel', ['food']),
    _n('salát', 'm', 'salad', 'der Salat', ['food']),
    // Drinks
    _n('voda', 'f', 'water', 'das Wasser', ['drinks']),
    _n('káva', 'f', 'coffee', 'der Kaffee', ['drinks']),
    _n('čaj', 'm', 'tea', 'der Tee', ['drinks']),
    _n('mléko', 'n', 'milk', 'die Milch', ['drinks']),
    _n('pivo', 'n', 'beer', 'das Bier', ['drinks']),
    _n('víno', 'n', 'wine', 'der Wein', ['drinks']),
    _n('džus', 'm', 'juice', 'der Saft', ['drinks']),
    _n('láhev', 'f', 'bottle', 'die Flasche', ['drinks']),
    // Animals
    _n('pes', 'm', 'dog', 'der Hund', ['animals']),
    _n('kočka', 'f', 'cat', 'die Katze', ['animals']),
    _n('kůň', 'm', 'horse', 'das Pferd', ['animals']),
    _n('kráva', 'f', 'cow', 'die Kuh', ['animals']),
    _n('pták', 'm', 'bird', 'der Vogel', ['animals']),
    _n('myš', 'f', 'mouse', 'die Maus', ['animals']),
    _n('ovce', 'f', 'sheep', 'das Schaf', ['animals']),
    _n('prase', 'n', 'pig', 'das Schwein', ['animals']),
    // Body
    _n('hlava', 'f', 'head', 'der Kopf', ['bodyParts']),
    _n('ruka', 'f', 'hand/arm', 'die Hand / der Arm', ['bodyParts']),
    _n('oko', 'n', 'eye', 'das Auge', ['bodyParts']),
    _n('ucho', 'n', 'ear', 'das Ohr', ['bodyParts']),
    _n('nos', 'm', 'nose', 'die Nase', ['bodyParts']),
    _n('noha', 'f', 'leg/foot', 'das Bein / der Fuß', ['bodyParts']),
    _n('srdce', 'n', 'heart', 'das Herz', ['bodyParts']),
    _n('zub', 'm', 'tooth', 'der Zahn', ['bodyParts']),
    // City
    _n('město', 'n', 'city', 'die Stadt', ['city']),
    _n('ulice', 'f', 'street', 'die Straße', ['city']),
    _n('dům', 'm', 'house', 'das Haus', ['city']),
    _n('náměstí', 'n', 'square', 'der Platz', ['city']),
    _n('obchod', 'm', 'shop', 'der Laden', ['city']),
    _n('kostel', 'm', 'church', 'die Kirche', ['city']),
    _n('muzeum', 'n', 'museum', 'das Museum', ['city']),
    _n('park', 'm', 'park', 'der Park', ['city']),
    _n('most', 'm', 'bridge', 'die Brücke', ['city']),
    _n('nádraží', 'n', 'train station', 'der Bahnhof', ['city']),
    // Transport
    _n('auto', 'n', 'car', 'das Auto', ['transport']),
    _n('vlak', 'm', 'train', 'der Zug', ['transport']),
    _n('autobus', 'm', 'bus', 'der Bus', ['transport']),
    _n('letadlo', 'n', 'airplane', 'das Flugzeug', ['transport']),
    _n('kolo', 'n', 'bicycle', 'das Fahrrad', ['transport']),
    _n('loď', 'f', 'ship/boat', 'das Schiff', ['transport']),
    _n('tramvaj', 'f', 'tram', 'die Straßenbahn', ['transport']),
    _n('jízdenka', 'f', 'ticket', 'die Fahrkarte', ['transport']),
    // School
    _n('škola', 'f', 'school', 'die Schule', ['school']),
    _n('kniha', 'f', 'book', 'das Buch', ['school']),
    _n('sešit', 'm', 'notebook', 'das Heft', ['school']),
    _n('tužka', 'f', 'pencil', 'der Bleistift', ['school']),
    _n('stůl', 'm', 'table', 'der Tisch', ['school']),
    _n('židle', 'f', 'chair', 'der Stuhl', ['school']),
    _n('slovo', 'n', 'word', 'das Wort', ['school']),
    _n('otázka', 'f', 'question', 'die Frage', ['school']),
    _n('odpověď', 'f', 'answer', 'die Antwort', ['school']),
    _n('žák', 'm', 'pupil', 'der Schüler', ['school']),
    // Time
    _n('den', 'm', 'day', 'der Tag', ['time']),
    _n('týden', 'm', 'week', 'die Woche', ['time']),
    _n('měsíc', 'm', 'month/moon', 'der Monat / der Mond', ['time']),
    _n('rok', 'm', 'year', 'das Jahr', ['time']),
    _n('hodina', 'f', 'hour', 'die Stunde', ['time']),
    _n('minuta', 'f', 'minute', 'die Minute', ['time']),
    _n('ráno', 'n', 'morning', 'der Morgen', ['time']),
    _n('večer', 'm', 'evening', 'der Abend', ['time']),
    _n('noc', 'f', 'night', 'die Nacht', ['time']),
    _n('víkend', 'm', 'weekend', 'das Wochenende', ['time']),
    // Nature
    _n('slunce', 'n', 'sun', 'die Sonne', ['nature']),
    _n('nebe', 'n', 'sky', 'der Himmel', ['nature']),
    _n('moře', 'n', 'sea', 'das Meer', ['nature']),
    _n('řeka', 'f', 'river', 'der Fluss', ['nature']),
    _n('hora', 'f', 'mountain', 'der Berg', ['nature']),
    _n('strom', 'm', 'tree', 'der Baum', ['nature']),
    _n('květina', 'f', 'flower', 'die Blume', ['nature']),
    _n('les', 'm', 'forest', 'der Wald', ['nature']),
    _n('ostrov', 'm', 'island', 'die Insel', ['nature']),
    // Professions
    _n('lékař', 'm', 'doctor', 'der Arzt', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('učitel', 'm', 'teacher', 'der Lehrer', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('kuchař', 'm', 'cook', 'der Koch', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('číšník', 'm', 'waiter', 'der Kellner', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('prodavač', 'm', 'salesperson', 'der Verkäufer', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
    _n('policista', 'm', 'police officer', 'der Polizist', [
      'professions',
    ], difficulty: NounDifficulty.intermediate),
  ],
);
