import '../../../models/quiz_content.dart';
import 'es_de_builder.dart';

/// Nivel 2 — En la ciudad (restaurante, direcciones y transporte, compras).

final QuizContent esDeRestaurante = sentenceCourseQuiz(
  id: 'es_de_restaurante',
  title: 'En el restaurante',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Comer fuera es de lo mejor de viajar. Con estas frases pides mesa, '
      'comida, bebida y la cuenta sin problemas.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'La propina (Trinkgeld)',
      text: 'Se deja un 5-10%, redondeando. Dilo al pagar en vez de dejarlo en '
          'la mesa: si son 18,50 €, di "20, bitte".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Juntos o separados',
      text: 'Te preguntarán "Zusammen oder getrennt?" (¿junto o separado?). '
          'En Alemania es normal pagar cada uno lo suyo.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Agua',
      text: 'El agua de la llave casi no se sirve; pídela como "Leitungswasser". '
          'Lo normal es agua con gas ("mit Kohlensäure").',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'La carta, por favor',
      answer: 'Die Speisekarte, bitte',
      accepted: ['Die Karte, bitte'],
    ),
    CourseItem(prompt: 'Una mesa para dos', answer: 'Einen Tisch für zwei'),
    CourseItem(
      prompt: 'Quisiera…',
      answer: 'Ich hätte gern …',
      accepted: ['Ich möchte …'],
    ),
    CourseItem(prompt: 'Un café, por favor', answer: 'Einen Kaffee, bitte'),
    CourseItem(prompt: 'Una cerveza', answer: 'Ein Bier'),
    CourseItem(prompt: 'Agua sin gas', answer: 'Stilles Wasser'),
    CourseItem(
      prompt: 'Agua con gas',
      answer: 'Wasser mit Kohlensäure',
      accepted: ['Sprudelwasser'],
    ),
    CourseItem(
      prompt: 'La cuenta, por favor',
      answer: 'Die Rechnung, bitte',
      accepted: ['Zahlen, bitte'],
    ),
    CourseItem(prompt: 'Soy vegetariano', answer: 'Ich bin Vegetarier'),
    CourseItem(prompt: 'Estaba delicioso', answer: 'Es war lecker'),
    CourseItem(prompt: 'Para llevar', answer: 'Zum Mitnehmen'),
    CourseItem(prompt: '¡Salud! (brindis)', answer: 'Prost!'),
  ],
);

final QuizContent esDeDirecciones = sentenceCourseQuiz(
  id: 'es_de_direcciones',
  title: 'Direcciones y transporte',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Para moverte por la ciudad: preguntar el camino, comprar boletos y '
      'tomar el tren o el metro.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Valida tu boleto',
      text: 'Compra el boleto antes de subir y, si hace falta, valídalo. Los '
          'controles ("Kontrolle") multan a quien va sin boleto válido.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Transporte',
      text: 'U-Bahn = metro, S-Bahn = tren suburbano, Straßenbahn = tranvía, '
          'Bahnhof = estación, Gleis = andén.',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Dónde está la estación?', answer: 'Wo ist der Bahnhof?'),
    CourseItem(prompt: 'A la izquierda', answer: 'links', accepted: ['nach links']),
    CourseItem(
      prompt: 'A la derecha',
      answer: 'rechts',
      accepted: ['nach rechts'],
    ),
    CourseItem(prompt: 'Todo recto', answer: 'geradeaus'),
    CourseItem(prompt: '¿Está lejos?', answer: 'Ist es weit?'),
    CourseItem(
      prompt: 'Un boleto a…, por favor',
      answer: 'Eine Fahrkarte nach …, bitte',
    ),
    CourseItem(
      prompt: '¿Dónde compro un boleto?',
      answer: 'Wo kann ich eine Fahrkarte kaufen?',
    ),
    CourseItem(prompt: '¿Cuándo sale el tren?', answer: 'Wann fährt der Zug?'),
    CourseItem(prompt: '¿Qué andén?', answer: 'Welches Gleis?'),
    CourseItem(prompt: 'Quiero ir a…', answer: 'Ich möchte nach … fahren'),
    CourseItem(prompt: '¿Para aquí?', answer: 'Hält er hier?'),
  ],
);

final QuizContent esDeCompras = sentenceCourseQuiz(
  id: 'es_de_compras',
  title: 'Compras',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'En tiendas, mercados y supermercados. Pregunta precios, paga y pide una '
      'bolsa.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Lleva efectivo',
      text: 'No en todos los sitios aceptan tarjeta, sobre todo los pequeños. '
          'El efectivo ("Bargeld") siempre funciona.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Domingos cerrado',
      text: 'Casi todas las tiendas cierran los domingos. Haz la compra el '
          'sábado.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Pfand (depósito)',
      text: 'Por muchas botellas y latas pagas un depósito ("Pfand") que '
          'recuperas al devolverlas en el supermercado. Trae tu propia bolsa.',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Cuánto cuesta?', answer: 'Was kostet das?'),
    CourseItem(prompt: '¿Tienen…?', answer: 'Haben Sie …?'),
    CourseItem(prompt: 'Solo estoy mirando', answer: 'Ich schaue nur'),
    CourseItem(
      prompt: '¿Puedo pagar con tarjeta?',
      answer: 'Kann ich mit Karte zahlen?',
    ),
    CourseItem(prompt: 'En efectivo', answer: 'in bar', accepted: ['bar']),
    CourseItem(prompt: '¿Qué talla?', answer: 'Welche Größe?'),
    CourseItem(prompt: 'Es demasiado caro', answer: 'Das ist zu teuer'),
    CourseItem(prompt: 'Me lo llevo', answer: 'Ich nehme es'),
    CourseItem(prompt: 'Una bolsa, por favor', answer: 'Eine Tüte, bitte'),
    CourseItem(prompt: '¿Dónde está la caja?', answer: 'Wo ist die Kasse?'),
    CourseItem(
      prompt: '¿Está abierto?',
      answer: 'Ist es geöffnet?',
      accepted: ['Haben Sie geöffnet?'],
    ),
  ],
);

/// Listen & repeat: practice saying the most useful Nivel 2 phrases aloud.
final QuizContent esDeHablarCiudad = speakRepeatQuiz(
  id: 'es_de_hablar_ciudad',
  title: 'Hablar: en la ciudad',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Escucha y repite frases para el restaurante, moverte por la ciudad y '
      'hacer compras. Con el micrófono te decimos si te salió bien; sin él, '
      'repite a tu ritmo y pasa a la siguiente.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Las vocales largas',
      text: '"Bahnhof" y "Kaffee" llevan vocales largas. Alárgalas un poco: '
          '"Baahnhof", "Kafee".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ei" y la "ie"',
      text: '"ei" se dice como "ái" (zwei = tsvái) y "ie" como "íi" (Bier = '
          'bíia). Practícalo con "Ein Bier".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'La carta, por favor', answer: 'Die Speisekarte, bitte'),
    CourseItem(prompt: 'Un café, por favor', answer: 'Einen Kaffee, bitte'),
    CourseItem(prompt: 'Una cerveza', answer: 'Ein Bier'),
    CourseItem(prompt: 'La cuenta, por favor', answer: 'Die Rechnung, bitte'),
    CourseItem(prompt: '¡Salud! (brindis)', answer: 'Prost!'),
    CourseItem(prompt: '¿Dónde está la estación?', answer: 'Wo ist der Bahnhof?'),
    CourseItem(prompt: 'A la izquierda', answer: 'links'),
    CourseItem(prompt: 'A la derecha', answer: 'rechts'),
    CourseItem(prompt: 'Todo recto', answer: 'geradeaus'),
    CourseItem(prompt: 'Me lo llevo', answer: 'Ich nehme es'),
  ],
);

/// Listen & repeat: say the restaurant phrases aloud.
final QuizContent esDeHablarRestaurante = speakRepeatQuiz(
  id: 'es_de_hablar_restaurante',
  title: 'Hablar: restaurante',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Pide mesa, comida, bebida y la cuenta en voz alta. Practica hasta que '
      'puedas pedir sin pensarlo.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ei" de "Ein Bier"',
      text: '"ein" se dice "áin" y "Bier" como "bíia". Repite "Ein Bier, bitte" '
          'con ritmo.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Al pagar',
      text: '"Die Rechnung, bitte" (la cuenta). Di "Prost!" al brindar, con la '
          '"o" bien abierta.',
    ),
  ],
  items: const [
    // Covers every phrase from "En el restaurante", plus a few extras.
    CourseItem(prompt: 'La carta, por favor', answer: 'Die Speisekarte, bitte'),
    CourseItem(prompt: 'Una mesa para dos', answer: 'Einen Tisch für zwei'),
    CourseItem(prompt: 'Quisiera…', answer: 'Ich hätte gern …'),
    CourseItem(prompt: 'Un café, por favor', answer: 'Einen Kaffee, bitte'),
    CourseItem(prompt: 'Una cerveza', answer: 'Ein Bier'),
    CourseItem(prompt: 'Agua sin gas', answer: 'Stilles Wasser'),
    CourseItem(prompt: 'Agua con gas', answer: 'Wasser mit Kohlensäure'),
    CourseItem(prompt: 'La cuenta, por favor', answer: 'Die Rechnung, bitte'),
    CourseItem(prompt: 'Soy vegetariano', answer: 'Ich bin Vegetarier'),
    CourseItem(prompt: 'Estaba delicioso', answer: 'Es war lecker'),
    CourseItem(prompt: 'Para llevar', answer: 'Zum Mitnehmen'),
    CourseItem(prompt: '¡Salud! (brindis)', answer: 'Prost!'),
    // Extras.
    CourseItem(prompt: '¿Qué recomienda?', answer: 'Was empfehlen Sie?'),
    CourseItem(prompt: 'Separado, por favor', answer: 'Getrennt, bitte'),
  ],
);

/// Listen & repeat: say the directions and transport phrases aloud.
final QuizContent esDeHablarDirecciones = speakRepeatQuiz(
  id: 'es_de_hablar_direcciones',
  title: 'Hablar: direcciones',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Pregunta el camino y compra boletos en voz alta. Son frases que dirás de '
      'pie y con prisa, así que conviene tenerlas listas.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ch" de "rechts"',
      text: '"rechts" lleva "ch" áspera ("réjts") y "Bahnhof" una "a" larga '
          '("báanhof").',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pregunta corta',
      text: '"Wo ist…?" (¿dónde está…?) te sirve para todo: estación, andén, '
          'parada. Dilo claro.',
    ),
  ],
  items: const [
    // Covers every phrase from "Direcciones y transporte", plus a few extras.
    CourseItem(prompt: '¿Dónde está la estación?', answer: 'Wo ist der Bahnhof?'),
    CourseItem(prompt: 'A la izquierda', answer: 'links'),
    CourseItem(prompt: 'A la derecha', answer: 'rechts'),
    CourseItem(prompt: 'Todo recto', answer: 'geradeaus'),
    CourseItem(prompt: '¿Está lejos?', answer: 'Ist es weit?'),
    CourseItem(
      prompt: 'Un boleto a…, por favor',
      answer: 'Eine Fahrkarte nach …, bitte',
    ),
    CourseItem(
      prompt: '¿Dónde compro un boleto?',
      answer: 'Wo kann ich eine Fahrkarte kaufen?',
    ),
    CourseItem(prompt: '¿Cuándo sale el tren?', answer: 'Wann fährt der Zug?'),
    CourseItem(prompt: '¿Qué andén?', answer: 'Welches Gleis?'),
    CourseItem(prompt: 'Quiero ir a…', answer: 'Ich möchte nach … fahren'),
    CourseItem(prompt: '¿Para aquí?', answer: 'Hält er hier?'),
    // Extras.
    CourseItem(prompt: '¿Está cerca?', answer: 'Ist es in der Nähe?'),
    CourseItem(prompt: 'Un taxi, por favor', answer: 'Ein Taxi, bitte'),
  ],
);

/// Listen & repeat: say the shopping phrases aloud.
final QuizContent esDeHablarCompras = speakRepeatQuiz(
  id: 'es_de_hablar_compras',
  title: 'Hablar: compras',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Pregunta precios, paga y pide una bolsa en voz alta. Practica para no '
      'trabarte en la caja.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La pregunta clave',
      text: '"Was kostet das?" (¿cuánto cuesta?) es la que más usarás. Que salga '
          'redonda.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ü" de "Tüte"',
      text: 'La "ü" se dice con los labios redondeados, entre "u" e "i". '
          'Practica "Eine Tüte, bitte".',
    ),
  ],
  items: const [
    // Covers every phrase from "Compras", plus a few extras.
    CourseItem(prompt: '¿Cuánto cuesta?', answer: 'Was kostet das?'),
    CourseItem(prompt: '¿Tienen…?', answer: 'Haben Sie …?'),
    CourseItem(prompt: 'Solo estoy mirando', answer: 'Ich schaue nur'),
    CourseItem(
      prompt: '¿Puedo pagar con tarjeta?',
      answer: 'Kann ich mit Karte zahlen?',
    ),
    CourseItem(prompt: 'En efectivo', answer: 'in bar'),
    CourseItem(prompt: '¿Qué talla?', answer: 'Welche Größe?'),
    CourseItem(prompt: 'Es demasiado caro', answer: 'Das ist zu teuer'),
    CourseItem(prompt: 'Me lo llevo', answer: 'Ich nehme es'),
    CourseItem(prompt: 'Una bolsa, por favor', answer: 'Eine Tüte, bitte'),
    CourseItem(prompt: '¿Dónde está la caja?', answer: 'Wo ist die Kasse?'),
    CourseItem(prompt: '¿Está abierto?', answer: 'Ist es geöffnet?'),
    // Extras.
    CourseItem(prompt: '¿Puedo probármelo?', answer: 'Kann ich es anprobieren?'),
    CourseItem(prompt: '¿Está en oferta?', answer: 'Ist das im Angebot?'),
  ],
);

final List<QuizContent> esDeNivel2 = [
  esDeHablarCiudad,
  esDeRestaurante,
  esDeHablarRestaurante,
  esDeDirecciones,
  esDeHablarDirecciones,
  esDeCompras,
  esDeHablarCompras,
];
