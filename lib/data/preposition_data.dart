import 'dart:math';

import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';

/// One of the 27 German prepositions covered by the quiz.
class PrepositionInfo {
  const PrepositionInfo({
    required this.preposition,
    required this.englishClue,
    required this.caseGroup,
    required this.englishMeaning,
    required this.usageNotes,
  });

  /// The preposition itself, lowercase (e.g. "durch") — also the answer the
  /// user types into the blank.
  final String preposition;

  /// Always-visible English clue about this preposition's meaning, shown as
  /// the quiz prompt (e.g. "through (movement through a place)...").
  final String englishClue;

  /// 'accusative', 'dative', 'genitive', or 'two-way'.
  final String caseGroup;

  /// Short English meaning(s), shown in the Help Memory table.
  final String englishMeaning;

  /// Usage explanation and the case(s) this preposition is associated with,
  /// shown in the Help Memory table.
  final String usageNotes;
}

/// One fill-in-the-blank sentence for the Prepositions quiz. [sentence]
/// contains a "____" blank; [accepted] holds every preposition (1-3,
/// lowercase) that correctly fills it.
class PrepositionSentence {
  const PrepositionSentence({
    required this.target,
    required this.sentence,
    required this.accepted,
    required this.english,
    required this.hint,
  });

  /// The preposition (matching [PrepositionInfo.preposition]) this sentence
  /// is filed under for question selection.
  final String target;

  final String sentence;
  final Set<String> accepted;

  /// English translation of [sentence] with the blank filled.
  final String english;

  /// Hidden German case/usage hint for this specific sentence, revealed via
  /// the eye icon.
  final String hint;
}

/// Display names for [PrepositionInfo.caseGroup] keys, used for the
/// Settings filter chips.
const Map<String, String> prepositionCaseGroupNames = {
  'accusative': 'Accusative (Akkusativ)',
  'dative': 'Dative (Dativ)',
  'genitive': 'Genitive (Genitiv)',
  'two-way': 'Two-Way (Wechselpräposition)',
};

const List<PrepositionInfo> prepositionInfos = [
  // Accusative — always take the accusative case.
  PrepositionInfo(
    preposition: 'durch',
    englishClue: 'through (movement through a place) / by means of',
    caseGroup: 'accusative',
    englishMeaning: 'through; by means of',
    usageNotes:
        'Always accusative. Used for movement through a space ("durch den '
        'Park") or the means/cause of something ("durch harte Arbeit").',
  ),
  PrepositionInfo(
    preposition: 'für',
    englishClue: 'for (intended recipient, purpose, or duration)',
    caseGroup: 'accusative',
    englishMeaning: 'for',
    usageNotes:
        'Always accusative. Marks the recipient or purpose of something '
        '("ein Geschenk für dich") or a planned duration ("für zwei '
        'Wochen").',
  ),
  PrepositionInfo(
    preposition: 'gegen',
    englishClue: 'against (opposition, collision) / around (approximate time)',
    caseGroup: 'accusative',
    englishMeaning: 'against; around (time)',
    usageNotes:
        'Always accusative. Used for opposition or contact ("gegen die '
        'Wand") and approximate clock times ("gegen acht Uhr").',
  ),
  PrepositionInfo(
    preposition: 'ohne',
    englishClue: 'without',
    caseGroup: 'accusative',
    englishMeaning: 'without',
    usageNotes:
        'Always accusative, though the article is often dropped entirely '
        '("ohne Geld").',
  ),
  PrepositionInfo(
    preposition: 'um',
    englishClue: 'around (a place) / at (a specific clock time)',
    caseGroup: 'accusative',
    englishMeaning: 'around; at (clock time)',
    usageNotes:
        'Always accusative. Used for surrounding/encircling ("um den '
        'Tisch") and exact clock times ("um acht Uhr").',
  ),
  PrepositionInfo(
    preposition: 'bis',
    englishClue: 'until (a point in time) / as far as (a place)',
    caseGroup: 'accusative',
    englishMeaning: 'until; up to; as far as',
    usageNotes:
        'Always accusative when followed by an article, but is often used '
        'alone before time/place names without one ("bis Montag", "bis '
        'Berlin").',
  ),

  // Dative — always take the dative case.
  PrepositionInfo(
    preposition: 'aus',
    englishClue: 'out of / from (origin or material)',
    caseGroup: 'dative',
    englishMeaning: 'out of; from; made of',
    usageNotes:
        'Always dative. Used for origin ("aus Deutschland") and material '
        '("aus Holz").',
  ),
  PrepositionInfo(
    preposition: 'bei',
    englishClue: "at/near (someone's place) / during (an activity)",
    caseGroup: 'dative',
    englishMeaning: 'at; near; with; during',
    usageNotes:
        'Always dative. Used for location near a person or place ("bei '
        'meiner Oma") and simultaneous activities ("beim Essen").',
  ),
  PrepositionInfo(
    preposition: 'mit',
    englishClue: 'with (accompaniment or means/tool)',
    caseGroup: 'dative',
    englishMeaning: 'with; by (means of transport)',
    usageNotes:
        'Always dative. Used for accompaniment ("mit Freunden") and the '
        'means by which something is done ("mit dem Bus").',
  ),
  PrepositionInfo(
    preposition: 'nach',
    englishClue: 'after (in time/sequence) / to (a place, esp. cities & countries)',
    caseGroup: 'dative',
    englishMeaning: 'after; to; according to',
    usageNotes:
        'Always dative. Used for time sequence ("nach der Arbeit") and '
        'direction toward places ("nach Hause", "nach Berlin").',
  ),
  PrepositionInfo(
    preposition: 'seit',
    englishClue: 'since/for (a point in time continuing to now)',
    caseGroup: 'dative',
    englishMeaning: 'since; for (a duration up to now)',
    usageNotes:
        'Always dative. Marks an action continuing from a point in the '
        'past to the present ("seit zwei Jahren") — used with the present '
        'tense in German.',
  ),
  PrepositionInfo(
    preposition: 'von',
    englishClue: 'from/of (origin, possession, or the agent in passive)',
    caseGroup: 'dative',
    englishMeaning: 'from; of; by',
    usageNotes:
        'Always dative. Used for origin ("von Berlin"), possession ("das '
        'Auto von meinem Bruder"), and the agent in passive constructions '
        '("von ihm geschrieben").',
  ),
  PrepositionInfo(
    preposition: 'zu',
    englishClue: 'to (direction toward a person/place) / for (purpose/occasion)',
    caseGroup: 'dative',
    englishMeaning: 'to; for (an occasion)',
    usageNotes:
        'Always dative. Used for direction toward people or specific '
        'places ("zu meiner Freundin", "zur Schule") and occasions ("zum '
        'Geburtstag").',
  ),

  // Genitive — formal/written German; dative is common colloquially.
  PrepositionInfo(
    preposition: 'während',
    englishClue: 'during (a time period)',
    caseGroup: 'genitive',
    englishMeaning: 'during',
    usageNotes:
        'Takes the genitive in formal/written German ("während des '
        'Sommers"), though the dative is common in casual speech.',
  ),
  PrepositionInfo(
    preposition: 'wegen',
    englishClue: 'because of / due to',
    caseGroup: 'genitive',
    englishMeaning: 'because of; due to',
    usageNotes:
        'Takes the genitive in formal German ("wegen des Regens"), though '
        'the dative is very common colloquially ("wegen dem Regen").',
  ),
  PrepositionInfo(
    preposition: 'trotz',
    englishClue: 'despite / in spite of',
    caseGroup: 'genitive',
    englishMeaning: 'despite; in spite of',
    usageNotes:
        'Takes the genitive in formal German ("trotz des Wetters"), though '
        'the dative is common colloquially.',
  ),
  PrepositionInfo(
    preposition: 'statt',
    englishClue: 'instead of',
    caseGroup: 'genitive',
    englishMeaning: 'instead of',
    usageNotes:
        'Takes the genitive ("statt eines Mantels"), though the dative '
        "also occurs informally. Often a shortened form of 'anstatt'.",
  ),
  PrepositionInfo(
    preposition: 'innerhalb',
    englishClue: 'within / inside of (a time period or space)',
    caseGroup: 'genitive',
    englishMeaning: 'within; inside of',
    usageNotes:
        'Takes the genitive ("innerhalb eines Monats"), describing a time '
        'period or a bounded space.',
  ),

  // Two-way (Wechselpräpositionen) — accusative for "wohin?" (direction),
  // dative for "wo?" (location).
  PrepositionInfo(
    preposition: 'an',
    englishClue: 'at/on (a vertical surface or edge) / to (a specific time)',
    caseGroup: 'two-way',
    englishMeaning: 'at; on (vertical surfaces); to',
    usageNotes:
        'Two-way: accusative for movement onto a vertical surface ("an die '
        'Wand hängen"), dative for location at/on it ("an der Wand '
        'hängen"). Also used for days/dates with the dative ("am Montag").',
  ),
  PrepositionInfo(
    preposition: 'auf',
    englishClue: 'on/onto (a horizontal surface)',
    caseGroup: 'two-way',
    englishMeaning: 'on; onto; on top of',
    usageNotes:
        'Two-way: accusative for placing something onto a horizontal '
        'surface ("auf den Tisch legen"), dative for its location there '
        '("auf dem Tisch liegen").',
  ),
  PrepositionInfo(
    preposition: 'hinter',
    englishClue: 'behind',
    caseGroup: 'two-way',
    englishMeaning: 'behind',
    usageNotes:
        'Two-way: accusative for moving to a position behind something '
        '("hinter das Haus"), dative for being located behind it ("hinter '
        'dem Haus").',
  ),
  PrepositionInfo(
    preposition: 'in',
    englishClue: 'in/into (an enclosed space)',
    caseGroup: 'two-way',
    englishMeaning: 'in; into',
    usageNotes:
        'Two-way: accusative for movement into an enclosed space ("in das '
        'Kino gehen"), dative for being located inside it ("in dem Garten '
        'sein").',
  ),
  PrepositionInfo(
    preposition: 'neben',
    englishClue: 'next to / beside',
    caseGroup: 'two-way',
    englishMeaning: 'next to; beside',
    usageNotes:
        'Two-way: accusative for moving to a position beside something '
        '("neben den Schreibtisch stellen"), dative for being located '
        'beside it ("neben dem Sofa liegen").',
  ),
  PrepositionInfo(
    preposition: 'über',
    englishClue: 'over/above (a position) / about (a topic)',
    caseGroup: 'two-way',
    englishMeaning: 'over; above; about (a topic)',
    usageNotes:
        'Two-way: accusative for movement over/across something ("über die '
        'Brücke fahren"), dative for a stationary position above it '
        '("über dem Tisch hängen"). Always accusative when meaning "about" '
        'a topic ("über das Wetter sprechen").',
  ),
  PrepositionInfo(
    preposition: 'unter',
    englishClue: 'under / below / among',
    caseGroup: 'two-way',
    englishMeaning: 'under; below; among',
    usageNotes:
        'Two-way: accusative for moving to a position underneath ("unter '
        'das Bett laufen"), dative for being located underneath ("unter '
        'dem Bett liegen").',
  ),
  PrepositionInfo(
    preposition: 'vor',
    englishClue: 'in front of (position) / ago / before (in time)',
    caseGroup: 'two-way',
    englishMeaning: 'in front of; before; ago',
    usageNotes:
        'Two-way: accusative for moving in front of something ("vor das '
        'Haus stellen"), dative for a stationary position in front of it '
        '("vor dem Haus stehen"). Always dative when expressing time '
        '("vor zwei Jahren" = two years ago).',
  ),
  PrepositionInfo(
    preposition: 'zwischen',
    englishClue: 'between',
    caseGroup: 'two-way',
    englishMeaning: 'between',
    usageNotes:
        'Two-way: accusative for moving to a position between two things '
        '("zwischen die Bücher legen"), dative for being located between '
        'them ("zwischen den Büchern liegen").',
  ),
];

final List<String> prepositionSubjects = prepositionInfos
    .map((p) => p.preposition)
    .toList();

final List<String> prepositionSubjectDisplays = prepositionInfos
    .map((p) => p.englishClue)
    .toList();

final List<List<String>> prepositionSubjectCategories = prepositionInfos
    .map((p) => [p.caseGroup])
    .toList();

final Map<String, PrepositionInfo> _prepositionByKey = {
  for (final p in prepositionInfos) p.preposition: p,
};

/// Bank of fill-in-the-blank sentences, 2-3 per preposition. Sentences for
/// the two-way (Wechselpräpositionen) group are split between "wohin?"
/// (accusative) and "wo?" (dative) usages, with a few accepting more than
/// one valid preposition.
const List<PrepositionSentence> prepositionSentenceBank = [
  // durch
  PrepositionSentence(
    target: 'durch',
    sentence: 'Wir gehen ____ den Wald, weil der Weg kürzer ist.',
    accepted: {'durch'},
    english: 'We walk through the forest because the path is shorter.',
    hint: 'Bewegung hindurch → immer Akkusativ ("durch" + Akkusativ).',
  ),
  PrepositionSentence(
    target: 'durch',
    sentence: 'Er hat den Preis ____ harte Arbeit gewonnen.',
    accepted: {'durch'},
    english: 'He won the prize through hard work.',
    hint: 'Mittel/Ursache → "durch" + Akkusativ.',
  ),

  PrepositionSentence(
    target: 'durch',
    sentence: 'Der Einbrecher kletterte ____ das offene Fenster.',
    accepted: {'durch'},
    english: 'The burglar climbed in through the open window.',
    hint: 'Bewegung hindurch → "durch" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'durch',
    sentence: 'Sie hat die Prüfung ____ viel Üben bestanden.',
    accepted: {'durch'},
    english: 'She passed the exam through a lot of practice.',
    hint: 'Mittel/Ursache → "durch" + Akkusativ.',
  ),

  // für
  PrepositionSentence(
    target: 'für',
    sentence: 'Das Geschenk ist ____ meine Schwester.',
    accepted: {'für'},
    english: 'The gift is for my sister.',
    hint: 'Empfänger/Bestimmung → "für" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'für',
    sentence: 'Wir bleiben ____ zwei Wochen in Spanien.',
    accepted: {'für'},
    english: "We're staying for two weeks in Spain.",
    hint: 'Geplante Zeitdauer → "für" + Akkusativ.',
  ),

  PrepositionSentence(
    target: 'für',
    sentence: 'Ich habe ein Buch ____ dich gekauft.',
    accepted: {'für'},
    english: 'I bought a book for you.',
    hint: 'Empfänger → "für" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'für',
    sentence: 'Er arbeitet ____ eine große Firma.',
    accepted: {'für'},
    english: 'He works for a big company.',
    hint: 'Zweck/Zugehörigkeit → "für" + Akkusativ.',
  ),

  // gegen
  PrepositionSentence(
    target: 'gegen',
    sentence: 'Das Auto ist ____ die Wand gefahren.',
    accepted: {'gegen'},
    english: 'The car drove into the wall.',
    hint: 'Zusammenstoß/Gegen-Bewegung → "gegen" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'gegen',
    sentence: 'Wir treffen uns ____ acht Uhr.',
    accepted: {'gegen'},
    english: "We're meeting around eight o'clock.",
    hint: 'Ungefähre Uhrzeit → "gegen" + Akkusativ.',
  ),

  PrepositionSentence(
    target: 'gegen',
    sentence: 'Die Mannschaft spielt heute ____ den Tabellenführer.',
    accepted: {'gegen'},
    english: 'The team is playing against the league leaders today.',
    hint: 'Gegnerschaft → "gegen" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'gegen',
    sentence: 'Ich nehme eine Tablette ____ die Kopfschmerzen.',
    accepted: {'gegen'},
    english: 'I take a pill for the headache.',
    hint: 'Mittel gegen etwas → "gegen" + Akkusativ.',
  ),

  // ohne
  PrepositionSentence(
    target: 'ohne',
    sentence: 'Sie verlässt nie das Haus ____ ihren Schlüssel.',
    accepted: {'ohne'},
    english: 'She never leaves the house without her key.',
    hint: 'Immer Akkusativ — Artikel ist hier vorhanden.',
  ),
  PrepositionSentence(
    target: 'ohne',
    sentence: 'Er trinkt seinen Kaffee ____ Zucker, weil er Diabetes hat.',
    accepted: {'ohne'},
    english: 'He drinks his coffee without sugar because he has diabetes.',
    hint:
        'Immer Akkusativ — hier ohne Artikel (unbestimmte Menge). Der '
        'Kontext (Diabetes) macht "ohne" eindeutig.',
  ),

  PrepositionSentence(
    target: 'ohne',
    sentence: 'Ich trinke meinen Tee ____ Milch.',
    accepted: {'ohne'},
    english: 'I drink my tea without milk.',
    hint: 'Immer Akkusativ — hier ohne Artikel.',
  ),
  PrepositionSentence(
    target: 'ohne',
    sentence: 'Sie ging ____ einen Mantel in den kalten Schnee.',
    accepted: {'ohne'},
    english: 'She went out into the cold snow without a coat.',
    hint: 'Fehlen von etwas → "ohne" + Akkusativ.',
  ),

  // um
  PrepositionSentence(
    target: 'um',
    sentence: 'Die Kinder sitzen ____ den Tisch.',
    accepted: {'um'},
    english: 'The children are sitting around the table.',
    hint: 'Räumlich umschließend → "um" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'um',
    sentence: 'Der Film beginnt ____ zwanzig Uhr.',
    accepted: {'um'},
    english: 'The film starts at eight pm.',
    hint: 'Genaue Uhrzeit → "um" + Akkusativ.',
  ),

  PrepositionSentence(
    target: 'um',
    sentence: 'Wir saßen alle ____ das Lagerfeuer.',
    accepted: {'um'},
    english: 'We were all sitting around the campfire.',
    hint: 'Räumlich umschließend → "um" + Akkusativ.',
  ),
  PrepositionSentence(
    target: 'um',
    sentence: 'Der Unterricht endet pünktlich ____ vierzehn Uhr.',
    accepted: {'um'},
    english: 'The lesson ends punctually at two pm.',
    hint: 'Genaue Uhrzeit ("pünktlich") → "um" + Akkusativ.',
  ),

  // bis
  PrepositionSentence(
    target: 'bis',
    sentence: 'Ich bin ____ Freitag im Urlaub.',
    accepted: {'bis'},
    english: "I'm on vacation until Friday.",
    hint: 'Zeitpunkt als Grenze → "bis" (+ Akkusativ, oft ohne Artikel).',
  ),
  PrepositionSentence(
    target: 'bis',
    sentence: 'Wir fahren mit dem Zug nur ____ Hamburg, nicht weiter.',
    accepted: {'bis'},
    english: "We're only taking the train as far as Hamburg, no further.",
    hint: 'Räumliche Grenze → "bis" (ohne Artikel bei Städtenamen).',
  ),

  PrepositionSentence(
    target: 'bis',
    sentence: 'Das Geschäft ist ____ zwanzig Uhr geöffnet.',
    accepted: {'bis'},
    english: 'The shop is open until eight pm.',
    hint: 'Zeitpunkt als Grenze → "bis" + Akkusativ (ohne Artikel).',
  ),
  PrepositionSentence(
    target: 'bis',
    sentence: 'Der Bus fährt nur ____ zur nächsten Haltestelle.',
    accepted: {'bis'},
    english: 'The bus only goes as far as the next stop.',
    hint: 'Räumliche Grenze → "bis" ("bis zu" = bis + zu).',
  ),

  // aus
  PrepositionSentence(
    target: 'aus',
    sentence: 'Meine Großmutter kommt ____ Italien.',
    accepted: {'aus'},
    english: 'My grandmother comes from Italy.',
    hint: 'Herkunft → "aus" + Dativ.',
  ),
  PrepositionSentence(
    target: 'aus',
    sentence: 'Der Tisch ist ____ Holz gemacht.',
    accepted: {'aus'},
    english: 'The table is made of wood.',
    hint: 'Material → "aus" + Dativ.',
  ),

  PrepositionSentence(
    target: 'aus',
    sentence: 'Er nimmt das Geld ____ der Tasche.',
    accepted: {'aus'},
    english: 'He takes the money out of the bag.',
    hint: 'Bewegung von innen heraus → "aus" + Dativ.',
  ),
  PrepositionSentence(
    target: 'aus',
    sentence: 'Der Ring ist ____ reinem Gold.',
    accepted: {'aus'},
    english: 'The ring is made of pure gold.',
    hint: 'Material → "aus" + Dativ.',
  ),

  // bei
  PrepositionSentence(
    target: 'bei',
    sentence: 'Am Wochenende bin ich ____ meinen Eltern zu Besuch.',
    accepted: {'bei'},
    english: "On the weekend I'm visiting at my parents' place.",
    hint: 'Bei einer Person/Ort → "bei" + Dativ ("zu Besuch bei").',
  ),
  PrepositionSentence(
    target: 'bei',
    sentence: '____ dem Frühstück lese ich gleichzeitig die Zeitung.',
    accepted: {'bei'},
    english: 'During breakfast I read the newspaper at the same time.',
    hint: 'Gleichzeitige Tätigkeit → "bei" + Dativ ("beim" = bei + dem).',
  ),

  PrepositionSentence(
    target: 'bei',
    sentence: 'Ich war gestern ____ meinem Arzt.',
    accepted: {'bei'},
    english: "I was at my doctor's yesterday.",
    hint: 'Bei einer Person/Ort → "bei" + Dativ.',
  ),
  PrepositionSentence(
    target: 'bei',
    sentence: '____ der Arbeit höre ich gleichzeitig Musik.',
    accepted: {'bei'},
    english: 'While working I listen to music at the same time.',
    hint: 'Gleichzeitige Tätigkeit → "bei" + Dativ.',
  ),

  // mit
  PrepositionSentence(
    target: 'mit',
    sentence: 'Ich fahre ____ dem Bus zur Arbeit.',
    accepted: {'mit'},
    english: 'I take the bus to work.',
    hint: 'Verkehrsmittel/Mittel → "mit" + Dativ.',
  ),
  PrepositionSentence(
    target: 'mit',
    sentence: 'Sie geht ____ ihrem Hund spazieren.',
    accepted: {'mit'},
    english: 'She goes for a walk with her dog.',
    hint: 'Begleitung → "mit" + Dativ.',
  ),

  PrepositionSentence(
    target: 'mit',
    sentence: 'Ich schreibe den Brief ____ einem Kugelschreiber.',
    accepted: {'mit'},
    english: 'I write the letter with a pen.',
    hint: 'Werkzeug/Mittel → "mit" + Dativ.',
  ),
  PrepositionSentence(
    target: 'mit',
    sentence: 'Sie spielt gern ____ ihren Freunden.',
    accepted: {'mit'},
    english: 'She likes playing with her friends.',
    hint: 'Begleitung → "mit" + Dativ.',
  ),

  // nach
  PrepositionSentence(
    target: 'nach',
    sentence: '____ der Arbeit gehe ich ins Fitnessstudio.',
    accepted: {'nach'},
    english: 'After work I go to the gym.',
    hint: 'Zeitliche Reihenfolge → "nach" + Dativ.',
  ),
  PrepositionSentence(
    target: 'nach',
    sentence: 'Wir fliegen morgen ____ Berlin.',
    accepted: {'nach'},
    english: "We're flying to Berlin tomorrow.",
    hint: 'Richtung zu Stadt/Land → "nach" + Dativ (ohne Artikel).',
  ),

  PrepositionSentence(
    target: 'nach',
    sentence: '____ dem langen Konzert waren wir alle müde.',
    accepted: {'nach'},
    english: 'After the long concert we were all tired.',
    hint: 'Zeitliche Reihenfolge → "nach" + Dativ.',
  ),
  PrepositionSentence(
    target: 'nach',
    sentence: 'Im Sommer fliegen wir ____ Italien.',
    accepted: {'nach'},
    english: 'In summer we fly to Italy.',
    hint: 'Richtung zu Land → "nach" + Dativ (ohne Artikel).',
  ),

  // seit
  PrepositionSentence(
    target: 'seit',
    sentence: 'Ich lerne ____ drei Jahren Deutsch.',
    accepted: {'seit'},
    english: "I've been learning German for three years.",
    hint: 'Andauernde Zeitspanne bis jetzt → "seit" + Dativ.',
  ),
  PrepositionSentence(
    target: 'seit',
    sentence: '____ dem Unfall trägt er eine Brille.',
    accepted: {'seit'},
    english: 'Since the accident he wears glasses.',
    hint: 'Zeitpunkt in der Vergangenheit bis heute → "seit" + Dativ.',
  ),

  PrepositionSentence(
    target: 'seit',
    sentence: '____ einer Woche habe ich jeden Tag Kopfschmerzen.',
    accepted: {'seit'},
    english: "For a week I've had a headache every day.",
    hint: 'Andauernd bis jetzt (Präsens) → "seit" + Dativ.',
  ),
  PrepositionSentence(
    target: 'seit',
    sentence: 'Wir kennen uns ____ unserer Schulzeit.',
    accepted: {'seit'},
    english: "We've known each other since our school days.",
    hint: 'Zeitpunkt in der Vergangenheit bis heute → "seit" + Dativ.',
  ),

  // von
  PrepositionSentence(
    target: 'von',
    sentence: 'Das ist ein Geschenk ____ meinem besten Freund.',
    accepted: {'von'},
    english: "That's a gift from my best friend.",
    hint: 'Herkunft/Besitz → "von" + Dativ.',
  ),
  PrepositionSentence(
    target: 'von',
    sentence: 'Das Buch wurde ____ einem berühmten Autor geschrieben.',
    accepted: {'von'},
    english: 'The book was written by a famous author.',
    hint: 'Agens im Passiv → "von" + Dativ.',
  ),

  PrepositionSentence(
    target: 'von',
    sentence: 'Ich habe einen Brief ____ meiner Tante bekommen.',
    accepted: {'von'},
    english: 'I received a letter from my aunt.',
    hint: 'Herkunft → "von" + Dativ.',
  ),
  PrepositionSentence(
    target: 'von',
    sentence: 'Das ist das Auto ____ meinem Vater.',
    accepted: {'von'},
    english: "That's my father's car.",
    hint: 'Besitz → "von" + Dativ.',
  ),

  // zu
  PrepositionSentence(
    target: 'zu',
    sentence: 'Heute Abend gehen wir ____ unserer Tante.',
    accepted: {'zu'},
    english: "Tonight we're going to our aunt's.",
    hint: 'Richtung zu einer Person → "zu" + Dativ.',
  ),
  PrepositionSentence(
    target: 'zu',
    sentence: 'Was schenkst du ihm ____ seinem Geburtstag?',
    accepted: {'zu'},
    english: 'What are you giving him for his birthday?',
    hint: 'Anlass → "zu" + Dativ ("zu seinem Geburtstag").',
  ),

  PrepositionSentence(
    target: 'zu',
    sentence: 'Nach der Schule gehe ich ____ meinem Freund.',
    accepted: {'zu'},
    english: "After school I go to my friend's.",
    hint: 'Richtung zu einer Person → "zu" + Dativ.',
  ),
  PrepositionSentence(
    target: 'zu',
    sentence: '____ Weihnachten besuchen wir die Großeltern.',
    accepted: {'zu'},
    english: 'For Christmas we visit our grandparents.',
    hint: 'Anlass → "zu" + Dativ.',
  ),

  // während
  PrepositionSentence(
    target: 'während',
    sentence: '____ des Sommers arbeite ich in einem Café.',
    accepted: {'während'},
    english: 'During the summer I work in a café.',
    hint: 'Zeitraum → "während" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'während',
    sentence: '____ der Pause sprechen wir über das Projekt.',
    accepted: {'während'},
    english: 'During the break we talk about the project.',
    hint: 'Zeitraum → "während" + Genitiv.',
  ),

  PrepositionSentence(
    target: 'während',
    sentence: '____ der Vorlesung hat er die ganze Zeit geschlafen.',
    accepted: {'während'},
    english: 'During the lecture he slept the whole time.',
    hint: 'Zeitraum → "während" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'während',
    sentence: '____ des Films klingelte plötzlich mein Handy.',
    accepted: {'während'},
    english: 'During the film my phone suddenly rang.',
    hint: 'Zeitraum → "während" + Genitiv.',
  ),

  // wegen
  PrepositionSentence(
    target: 'wegen',
    sentence: '____ des schlechten Wetters bleiben wir zu Hause.',
    accepted: {'wegen'},
    english: "Because of the bad weather we're staying home.",
    hint:
        'Grund/Ursache → "wegen" + Genitiv (umgangssprachlich oft Dativ).',
  ),
  PrepositionSentence(
    target: 'wegen',
    sentence: 'Sie kam ____ ihrer Krankheit nicht zur Schule.',
    accepted: {'wegen'},
    english: "She didn't come to school because of her illness.",
    hint: 'Grund → "wegen" + Genitiv.',
  ),

  PrepositionSentence(
    target: 'wegen',
    sentence: '____ des Sturms fiel der Unterricht aus.',
    accepted: {'wegen'},
    english: 'Because of the storm the lesson was cancelled.',
    hint: 'Grund/Ursache → "wegen" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'wegen',
    sentence: 'Er wurde ____ seines Fehlers kritisiert.',
    accepted: {'wegen'},
    english: 'He was criticised because of his mistake.',
    hint: 'Grund → "wegen" + Genitiv.',
  ),

  // trotz
  PrepositionSentence(
    target: 'trotz',
    sentence: '____ des Regens gehen wir spazieren.',
    accepted: {'trotz'},
    english: "Despite the rain we're going for a walk.",
    hint: 'Einschränkender Gegensatz → "trotz" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'trotz',
    sentence: '____ seiner Erkältung ging er zur Arbeit.',
    accepted: {'trotz'},
    english: 'Despite his cold he went to work.',
    hint: 'Gegensatz → "trotz" + Genitiv.',
  ),

  PrepositionSentence(
    target: 'trotz',
    sentence: '____ des Lärms konnte ich gut schlafen.',
    accepted: {'trotz'},
    english: 'Despite the noise I was able to sleep well.',
    hint: 'Einschränkender Gegensatz → "trotz" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'trotz',
    sentence: '____ seines hohen Alters läuft er jeden Tag.',
    accepted: {'trotz'},
    english: 'Despite his old age he runs every day.',
    hint: 'Gegensatz → "trotz" + Genitiv.',
  ),

  // statt
  PrepositionSentence(
    target: 'statt',
    sentence: '____ eines Mantels trug sie nur eine Jacke.',
    accepted: {'statt'},
    english: 'Instead of a coat she wore only a jacket.',
    hint: 'Ersatz/Alternative → "statt" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'statt',
    sentence: 'Er bestellte Tee ____ Kaffee.',
    accepted: {'statt'},
    english: 'He ordered tea instead of coffee.',
    hint: 'Alternative → "statt" (+ Genitiv, hier ohne Artikel).',
  ),

  PrepositionSentence(
    target: 'statt',
    sentence: '____ eines Autos kaufte er ein Fahrrad.',
    accepted: {'statt'},
    english: 'Instead of a car he bought a bicycle.',
    hint: 'Ersatz/Alternative → "statt" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'statt',
    sentence: 'Sie trank Wasser ____ eines Bieres.',
    accepted: {'statt'},
    english: 'She drank water instead of a beer.',
    hint: 'Alternative → "statt" + Genitiv.',
  ),

  // innerhalb
  PrepositionSentence(
    target: 'innerhalb',
    sentence: '____ eines Monats müssen Sie antworten.',
    accepted: {'innerhalb'},
    english: 'Within a month you must respond.',
    hint: 'Zeitspanne als Grenze → "innerhalb" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'innerhalb',
    sentence: '____ der Stadt gibt es viele Parks.',
    accepted: {'innerhalb'},
    english: 'Within the city there are many parks.',
    hint: 'Räumliche Begrenzung → "innerhalb" + Genitiv.',
  ),

  PrepositionSentence(
    target: 'innerhalb',
    sentence: '____ einer Woche müssen wir umziehen.',
    accepted: {'innerhalb'},
    english: 'Within a week we have to move out.',
    hint: 'Zeitspanne als Grenze → "innerhalb" + Genitiv.',
  ),
  PrepositionSentence(
    target: 'innerhalb',
    sentence: '____ des Gebäudes ist das Rauchen verboten.',
    accepted: {'innerhalb'},
    english: 'Smoking is forbidden within the building.',
    hint: 'Räumliche Begrenzung → "innerhalb" + Genitiv.',
  ),

  // an
  PrepositionSentence(
    target: 'an',
    sentence: 'Er hängt das Bild ____ die Wand.',
    accepted: {'an'},
    english: 'He hangs the picture on the wall.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "an die Wand".',
  ),
  PrepositionSentence(
    target: 'an',
    sentence: 'Das Poster hängt ____ der Wand.',
    accepted: {'an'},
    english: 'The poster is hanging on the wall.',
    hint: 'Wo? → Ort/Lage (Dativ): "an der Wand".',
  ),
  PrepositionSentence(
    target: 'an',
    sentence: 'Das Schild steht ____ der Straße.',
    accepted: {'an'},
    english: 'The sign stands by the street.',
    hint: 'Wo? → Ort/Lage (Dativ): "an der Straße".',
  ),

  PrepositionSentence(
    target: 'an',
    sentence: 'Häng den Kalender ____ die Tür.',
    accepted: {'an'},
    english: 'Hang the calendar on the door.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "an die Tür".',
  ),
  PrepositionSentence(
    target: 'an',
    sentence: '____ dem Montag habe ich frei.',
    accepted: {'an'},
    english: 'On Monday I have the day off.',
    hint: 'Tag/Datum → "an" + Dativ ("am Montag").',
  ),

  // auf
  PrepositionSentence(
    target: 'auf',
    sentence: 'Leg das Buch ____ den Tisch.',
    accepted: {'auf'},
    english: 'Put the book on the table.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "auf den Tisch".',
  ),
  PrepositionSentence(
    target: 'auf',
    sentence: 'Das Buch liegt ____ dem Tisch.',
    accepted: {'auf'},
    english: 'The book is lying on the table.',
    hint: 'Wo? → Ort/Lage (Dativ): "auf dem Tisch".',
  ),
  PrepositionSentence(
    target: 'auf',
    sentence: 'Wir sehen uns ____ der Party.',
    accepted: {'auf'},
    english: "We'll see each other at the party.",
    hint: 'Wo? → feste Wendung "auf der Party" (Dativ).',
  ),

  PrepositionSentence(
    target: 'auf',
    sentence: 'Stell die Teller ____ den Tisch.',
    accepted: {'auf'},
    english: 'Put the plates on the table.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "auf den Tisch".',
  ),
  PrepositionSentence(
    target: 'auf',
    sentence: 'Die Katze sitzt ____ dem Dach.',
    accepted: {'auf'},
    english: 'The cat is sitting on the roof.',
    hint: 'Wo? → Ort/Lage (Dativ): "auf dem Dach".',
  ),

  // hinter
  PrepositionSentence(
    target: 'hinter',
    sentence: 'Der Hund läuft ____ das Haus.',
    accepted: {'hinter'},
    english: 'The dog runs behind the house.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "hinter das Haus".',
  ),
  PrepositionSentence(
    target: 'hinter',
    sentence: 'Die Mülltonnen stehen ____ dem Haus.',
    accepted: {'hinter'},
    english: 'The trash bins are behind the house.',
    hint: 'Wo? → Ort/Lage (Dativ): "hinter dem Haus".',
  ),

  PrepositionSentence(
    target: 'hinter',
    sentence: 'Versteck dich schnell ____ den Vorhang!',
    accepted: {'hinter'},
    english: 'Quickly hide behind the curtain!',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "hinter den Vorhang".',
  ),
  PrepositionSentence(
    target: 'hinter',
    sentence: 'Die Garage liegt ____ dem Haus, nicht davor.',
    accepted: {'hinter'},
    english: 'The garage is behind the house, not in front of it.',
    hint: 'Wo? → Ort/Lage (Dativ): "hinter dem Haus" ("nicht davor").',
  ),

  // in
  PrepositionSentence(
    target: 'in',
    sentence: 'Wir gehen heute Abend ____ das Kino.',
    accepted: {'in'},
    english: "We're going to the cinema tonight.",
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "in das Kino".',
  ),
  PrepositionSentence(
    target: 'in',
    sentence: 'Die Kinder spielen ____ dem Garten.',
    accepted: {'in'},
    english: 'The children are playing in the garden.',
    hint: 'Wo? → Ort/Lage (Dativ): "in dem Garten".',
  ),
  PrepositionSentence(
    target: 'in',
    sentence: 'Das Geschäft befindet sich ____ der Stadtmitte.',
    accepted: {'in'},
    english: 'The shop is located in the city center.',
    hint: 'Wo? → Ort/Lage (Dativ): "in der Stadtmitte".',
  ),

  PrepositionSentence(
    target: 'in',
    sentence: 'Sie legt die Milch ____ den Kühlschrank.',
    accepted: {'in'},
    english: 'She puts the milk into the fridge.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "in den Kühlschrank".',
  ),
  PrepositionSentence(
    target: 'in',
    sentence: 'Wir wohnen ____ einer kleinen Stadt.',
    accepted: {'in'},
    english: 'We live in a small town.',
    hint: 'Wo? → Ort/Lage (Dativ): "in einer Stadt".',
  ),

  // neben
  PrepositionSentence(
    target: 'neben',
    sentence: 'Stell den Stuhl ____ den Schreibtisch.',
    accepted: {'neben'},
    english: 'Put the chair next to the desk.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "neben den Schreibtisch".',
  ),
  PrepositionSentence(
    target: 'neben',
    sentence: 'Der Hund liegt ____ dem Sofa.',
    accepted: {'neben'},
    english: 'The dog is lying next to the sofa.',
    hint: 'Wo? → Ort/Lage (Dativ): "neben dem Sofa".',
  ),

  PrepositionSentence(
    target: 'neben',
    sentence: 'Komm und setz dich ____ mich!',
    accepted: {'neben'},
    english: 'Come and sit down next to me!',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "neben mich".',
  ),
  PrepositionSentence(
    target: 'neben',
    sentence: 'Im Kino saß ich ____ meiner besten Freundin.',
    accepted: {'neben'},
    english: 'At the cinema I sat next to my best friend.',
    hint: 'Wo? → Ort/Lage (Dativ): "neben meiner Freundin".',
  ),

  // über
  PrepositionSentence(
    target: 'über',
    sentence: 'Wir fahren ____ die Brücke.',
    accepted: {'über'},
    english: "We're driving over the bridge.",
    hint:
        'Wohin?/Bewegung über etwas hinweg → Akkusativ: "über die Brücke".',
  ),
  PrepositionSentence(
    target: 'über',
    sentence: 'Die Lampe hängt ____ dem Esstisch.',
    accepted: {'über'},
    english: 'The lamp hangs above the dining table.',
    hint: 'Wo? → Ort/Lage (Dativ): "über dem Tisch".',
  ),
  PrepositionSentence(
    target: 'über',
    sentence: 'Wir haben lange ____ das Wetter gesprochen.',
    accepted: {'über'},
    english: 'We talked about the weather for a long time.',
    hint:
        'Thema/Gesprächsgegenstand → "über" + immer Akkusativ (keine '
        'Wechselpräposition-Bedeutung hier).',
  ),

  PrepositionSentence(
    target: 'über',
    sentence: 'Das Flugzeug fliegt hoch ____ die Wolken.',
    accepted: {'über'},
    english: 'The plane flies high up over the clouds.',
    hint: 'Wohin?/Bewegung darüber hinweg → Akkusativ: "über die Wolken".',
  ),
  PrepositionSentence(
    target: 'über',
    sentence: 'Wir lesen ein Buch ____ die deutsche Geschichte.',
    accepted: {'über'},
    english: 'We are reading a book about German history.',
    hint: 'Thema → "über" + immer Akkusativ.',
  ),

  // unter
  PrepositionSentence(
    target: 'unter',
    sentence: 'Die Katze läuft ____ das Bett.',
    accepted: {'unter'},
    english: 'The cat runs under the bed.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "unter das Bett".',
  ),
  PrepositionSentence(
    target: 'unter',
    sentence: 'Die Schuhe liegen ____ dem Bett.',
    accepted: {'unter'},
    english: 'The shoes are lying under the bed.',
    hint: 'Wo? → Ort/Lage (Dativ): "unter dem Bett".',
  ),

  PrepositionSentence(
    target: 'unter',
    sentence: 'Der Ball rollte ____ das Auto.',
    accepted: {'unter'},
    english: 'The ball rolled under the car.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "unter das Auto".',
  ),
  PrepositionSentence(
    target: 'unter',
    sentence: 'Wir saßen ____ einem großen Baum im Schatten.',
    accepted: {'unter'},
    english: 'We sat in the shade under a big tree.',
    hint: 'Wo? → Ort/Lage (Dativ): "unter einem Baum".',
  ),

  // vor
  PrepositionSentence(
    target: 'vor',
    sentence: 'Sie stellt das Fahrrad ____ das Haus.',
    accepted: {'vor'},
    english: 'She puts the bike in front of the house.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "vor das Haus".',
  ),
  PrepositionSentence(
    target: 'vor',
    sentence: 'Das Fahrrad steht ____ dem Haus.',
    accepted: {'vor'},
    english: 'The bike is standing in front of the house.',
    hint: 'Wo? → Ort/Lage (Dativ): "vor dem Haus".',
  ),
  PrepositionSentence(
    target: 'vor',
    sentence: 'Das war ____ zwei Jahren.',
    accepted: {'vor'},
    english: 'That was two years ago.',
    hint:
        'Zeitangabe "vor" + Dativ = "ago" (bei Zeit immer Dativ, keine '
        'Wahlmöglichkeit).',
  ),

  PrepositionSentence(
    target: 'vor',
    sentence: '____ einer Stunde hat es noch geregnet.',
    accepted: {'vor'},
    english: 'An hour ago it was still raining.',
    hint: 'Zeitangabe "vor" + Dativ = "ago" (bei Zeit immer Dativ).',
  ),
  PrepositionSentence(
    target: 'vor',
    sentence: 'Wir treffen uns ____ dem Eingang des Kinos.',
    accepted: {'vor'},
    english: 'We are meeting in front of the cinema entrance.',
    hint: 'Wo? → Ort/Lage (Dativ): "vor dem Eingang".',
  ),

  // zwischen
  PrepositionSentence(
    target: 'zwischen',
    sentence: 'Stell die Vase ____ die beiden Bücher.',
    accepted: {'zwischen'},
    english: 'Put the vase between the two books.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "zwischen die Bücher".',
  ),
  PrepositionSentence(
    target: 'zwischen',
    sentence: 'Das Auto parkt ____ den beiden Häusern.',
    accepted: {'zwischen'},
    english: 'The car is parked between the two houses.',
    hint: 'Wo? → Ort/Lage (Dativ): "zwischen den Häusern".',
  ),
  PrepositionSentence(
    target: 'zwischen',
    sentence: 'Er setzte sich ____ die beiden Mädchen.',
    accepted: {'zwischen'},
    english: 'He sat down between the two girls.',
    hint: 'Wohin? → Richtung/Bewegung (Akkusativ): "zwischen die Mädchen".',
  ),
  PrepositionSentence(
    target: 'zwischen',
    sentence: 'Die Kirche steht ____ dem Rathaus und der Schule.',
    accepted: {'zwischen'},
    english: 'The church stands between the town hall and the school.',
    hint: 'Wo? → Ort/Lage (Dativ): "zwischen dem Rathaus und der Schule".',
  ),
];

final Map<String, PrepositionSentence> _sentenceByText = {
  for (final s in prepositionSentenceBank) s.sentence: s,
};

final Map<String, List<PrepositionSentence>> _sentencesByTarget = () {
  final map = <String, List<PrepositionSentence>>{
    for (final p in prepositionInfos) p.preposition: <PrepositionSentence>[],
  };
  for (final s in prepositionSentenceBank) {
    map[s.target]!.add(s);
  }
  return map;
}();

/// Picks a random sentence whose [PrepositionSentence.target] matches
/// [nominative] (the preposition currently being quizzed).
String pickPrepositionSentence({
  required String caseLabel,
  required String nominative,
  required String answer,
  required Random random,
}) {
  final candidates = _sentencesByTarget[nominative]!;
  return candidates[random.nextInt(candidates.length)].sentence;
}

/// Returns every preposition accepted as correct for [sentence].
Set<String> acceptablePrepositionAnswers(String sentence) =>
    _sentenceByText[sentence]?.accepted ?? const {};

/// Returns the hidden German case/usage hint for [sentence].
String? prepositionSentenceHint(String sentence) =>
    _sentenceByText[sentence]?.hint;

/// Builds the multi-section explanation for a Prepositions quiz question.
String buildPrepositionExplanation({
  required String caseLabel,
  required String nominative,
  required String answer,
  required String sentence,
}) {
  final entry = _sentenceByText[sentence]!;
  final info = _prepositionByKey[nominative]!;
  final alternates = entry.accepted.where((a) => a != nominative).toList();

  final sections = [
    'Example: $sentence',
    'English: ${entry.english}',
    'Answer: "$answer" — ${info.englishMeaning}.',
    'Usage: ${info.usageNotes}',
  ];

  if (alternates.isNotEmpty) {
    final alternateDetails = alternates
        .map((a) => '"$a" (${_prepositionByKey[a]!.englishMeaning})')
        .join(', ');
    sections.add('Also accepted here: $alternateDetails.');
  }

  return sections.join('\n\n');
}

final List<QuizCategoryDefinition> prepositionQuizCategories = [
  QuizCategoryDefinition(
    label: 'Präposition',
    values: prepositionSubjects,
    group: 'Präposition',
  ),
];

const Map<String, double> prepositionGroupChanceWeights = {'Präposition': 1};

List<EndingPatternTable> _buildPrepositionEndingPatternTables() {
  const titles = {
    'accusative': 'Accusative Prepositions (immer Akkusativ)',
    'dative': 'Dative Prepositions (immer Dativ)',
    'genitive': 'Genitive Prepositions (immer Genitiv)',
    'two-way': 'Two-Way Prepositions (Wechselpräpositionen)',
  };
  const notes = {
    'two-way': [
      'Wechselpräpositionen take the accusative when answering "wohin?" '
          '(movement/direction toward a place) and the dative when '
          'answering "wo?" (location/position).',
      '"über" meaning "about" (a topic) is always accusative, regardless '
          'of movement.',
      '"vor" meaning "ago" (time) is always dative.',
    ],
    'genitive': [
      'In casual spoken German, "wegen", "trotz", "während", and "statt" '
          'are often used with the dative instead of the genitive.',
    ],
  };

  return [
    for (final group in const ['accusative', 'dative', 'genitive', 'two-way'])
      EndingPatternTable(
        title: titles[group]!,
        cornerLabel: 'Präposition',
        columnLabels: const ['English Meaning', 'Usage Notes'],
        rowLabels: [
          for (final p in prepositionInfos)
            if (p.caseGroup == group) p.preposition,
        ],
        rows: [
          for (final p in prepositionInfos)
            if (p.caseGroup == group) [p.englishMeaning, p.usageNotes],
        ],
        notes: notes[group],
      ),
  ];
}

final List<EndingPatternTable> prepositionEndingPatternTables =
    _buildPrepositionEndingPatternTables();

final QuizConfig prepositionQuizConfig = QuizConfig(
  title: 'German Prepositions Quiz',
  storageKeyPrefix: 'preposition_',
  promptLabel: 'Preposition',
  subjectsLabel: 'Prepositions',
  subjectColumnLabel: 'Preposition',
  subjects: prepositionSubjects,
  subjectDisplays: prepositionSubjectDisplays,
  subjectCategories: prepositionSubjectCategories,
  categoryDisplayNames: prepositionCaseGroupNames,
  categories: prepositionQuizCategories,
  groupWeights: prepositionGroupChanceWeights,
  pickSentence: pickPrepositionSentence,
  buildExplanation: buildPrepositionExplanation,
  acceptableAnswersForSentence: acceptablePrepositionAnswers,
  sentenceHint: prepositionSentenceHint,
  helpMemoryTables: const [],
  endingPatternTables: prepositionEndingPatternTables,
  helpMemorySubtitle:
      'All 27 prepositions grouped by case, with English meanings and '
      'usage notes — exportable as a PDF study sheet.',
  currentPage: AppPage.prepositions,
);
