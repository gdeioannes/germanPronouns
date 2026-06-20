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
      text: 'El agua del grifo casi no se sirve; pídela como "Leitungswasser". '
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
      'Para moverte por la ciudad: preguntar el camino, comprar billetes y '
      'coger el tren o el metro.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Valida tu billete',
      text: 'Compra el billete antes de subir y, si hace falta, válidalo. Los '
          'controles ("Kontrolle") multan a quien va sin billete válido.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Transporte',
      text: 'U-Bahn = metro, S-Bahn = cercanías, Straßenbahn = tranvía, '
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
      prompt: 'Un billete a…, por favor',
      answer: 'Eine Fahrkarte nach …, bitte',
    ),
    CourseItem(
      prompt: '¿Dónde compro un billete?',
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

final List<QuizContent> esDeNivel2 = [
  esDeRestaurante,
  esDeDirecciones,
  esDeCompras,
];
