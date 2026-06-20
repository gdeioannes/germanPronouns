import '../../../models/quiz_content.dart';
import 'es_de_builder.dart';

/// Nivel 3 — Situaciones (alojamiento, emergencias, fechas, cultura).

final QuizContent esDeAlojamiento = sentenceCourseQuiz(
  id: 'es_de_alojamiento',
  title: 'Alojamiento',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'En el hotel o el albergue: registrarte, preguntar por el desayuno y el '
      'wifi, y resolver problemas en la habitación.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'El desayuno alemán',
      text: 'El "Frühstück" suele ser abundante: panes, embutidos, quesos y '
          'huevo. Pregunta si está incluido.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'El pasaporte',
      text: 'Muchos alojamientos piden el pasaporte o DNI al hacer el check-in.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Tengo una reserva',
      answer: 'Ich habe eine Reservierung',
    ),
    CourseItem(prompt: 'Quisiera hacer el check-in', answer: 'Ich möchte einchecken'),
    CourseItem(prompt: 'Una habitación individual', answer: 'Ein Einzelzimmer'),
    CourseItem(prompt: 'Una habitación doble', answer: 'Ein Doppelzimmer'),
    CourseItem(prompt: 'Para tres noches', answer: 'Für drei Nächte'),
    CourseItem(
      prompt: '¿Está incluido el desayuno?',
      answer: 'Ist das Frühstück inklusive?',
    ),
    CourseItem(
      prompt: '¿A qué hora es la salida?',
      answer: 'Wann muss ich auschecken?',
      accepted: ['Wann ist Check-out?'],
    ),
    CourseItem(prompt: 'La llave, por favor', answer: 'Den Schlüssel, bitte'),
    CourseItem(
      prompt: 'No funciona la calefacción',
      answer: 'Die Heizung funktioniert nicht',
    ),
    CourseItem(prompt: '¿Dónde está el ascensor?', answer: 'Wo ist der Aufzug?'),
    CourseItem(prompt: '¿Tienen wifi?', answer: 'Haben Sie WLAN?'),
  ],
);

final QuizContent esDeEmergencias = sentenceCourseQuiz(
  id: 'es_de_emergencias',
  title: 'Emergencias y salud',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Esperamos que no las necesites, pero estas frases pueden ser vitales: '
      'pedir ayuda, un médico o la farmacia.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Número de emergencias: 112',
      text: 'En Alemania (y toda la UE) el 112 es para ambulancia y bomberos; '
          'la policía es el 110.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La farmacia (Apotheke)',
      text: 'Tiene una gran "A" roja. Las medicinas se compran allí, no en el '
          'supermercado. Los domingos hay farmacia de guardia ("Notdienst").',
    ),
  ],
  items: const [
    CourseItem(prompt: '¡Ayuda!', answer: 'Hilfe!'),
    CourseItem(prompt: 'Es una emergencia', answer: 'Es ist ein Notfall'),
    CourseItem(
      prompt: 'Llame a una ambulancia',
      answer: 'Rufen Sie einen Krankenwagen',
    ),
    CourseItem(prompt: 'Llame a la policía', answer: 'Rufen Sie die Polizei'),
    CourseItem(prompt: 'Necesito un médico', answer: 'Ich brauche einen Arzt'),
    CourseItem(prompt: 'Me encuentro mal', answer: 'Mir geht es schlecht'),
    CourseItem(prompt: 'Me duele aquí', answer: 'Es tut hier weh'),
    CourseItem(prompt: '¿Dónde está la farmacia?', answer: 'Wo ist die Apotheke?'),
    CourseItem(
      prompt: 'Soy alérgico a…',
      answer: 'Ich bin allergisch gegen …',
    ),
    CourseItem(
      prompt: 'He perdido mi pasaporte',
      answer: 'Ich habe meinen Pass verloren',
    ),
    CourseItem(prompt: '¿Dónde está el hospital?', answer: 'Wo ist das Krankenhaus?'),
  ],
);

final QuizContent esDeFechas = sentenceCourseQuiz(
  id: 'es_de_fechas',
  title: 'Días, horas y citas',
  promptLabel: 'Palabra',
  subjectsLabel: 'Palabras',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Para horarios, reservas y citas: los días, decir la hora y preguntar '
      '"¿a qué hora?".',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '"morgen" tiene truco',
      text: '"morgen" = mañana (el día siguiente), pero "der Morgen" / "am '
          'Morgen" = la mañana (parte del día).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La hora',
      text: '"halb drei" = las 2:30 (¡media hacia las tres!), no las 3:30. '
          'Formal: "vierzehn Uhr dreißig".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hoy', answer: 'heute'),
    CourseItem(prompt: 'Mañana (el día siguiente)', answer: 'morgen'),
    CourseItem(prompt: 'Ayer', answer: 'gestern'),
    CourseItem(prompt: 'Lunes', answer: 'Montag'),
    CourseItem(prompt: 'Viernes', answer: 'Freitag'),
    CourseItem(prompt: 'Sábado', answer: 'Samstag'),
    CourseItem(prompt: 'Domingo', answer: 'Sonntag'),
    CourseItem(prompt: '¿Qué hora es?', answer: 'Wie spät ist es?'),
    CourseItem(
      prompt: '¿A qué hora?',
      answer: 'Um wie viel Uhr?',
    ),
    CourseItem(prompt: 'A las tres', answer: 'um drei', accepted: ['um drei Uhr']),
    CourseItem(prompt: '¿Cuándo abre?', answer: 'Wann öffnet es?'),
  ],
);

final QuizContent esDeCultura = sentenceCourseQuiz(
  id: 'es_de_cultura',
  title: 'Charla y cultura',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Para romper el hielo y entender las costumbres. Un poco de charla y de '
      'cultura alemana hacen el viaje mucho más fácil.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Puntualidad',
      text: 'Llegar a la hora es muy importante en Alemania; mejor 5 minutos '
          'antes que 1 tarde.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Domingo tranquilo (Ruhetag)',
      text: 'Los domingos las tiendas cierran y se evita el ruido (¡nada de '
          'taladrar!). Es día de descanso.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Reciclaje',
      text: 'Separar la basura es serio: vidrio, papel, envases (Gelber Sack) y '
          'el depósito de botellas (Pfand).',
    ),
  ],
  items: const [
    CourseItem(
      prompt: '¿De dónde eres?',
      answer: 'Woher kommst du?',
      accepted: ['Woher kommen Sie?'],
    ),
    CourseItem(prompt: 'Soy de España', answer: 'Ich komme aus Spanien'),
    CourseItem(prompt: '¿Hablas español?', answer: 'Sprichst du Spanisch?'),
    CourseItem(
      prompt: 'Encantado',
      answer: 'Sehr erfreut',
      accepted: ['Freut mich'],
    ),
    CourseItem(prompt: '¡Buen provecho!', answer: 'Guten Appetit!'),
    CourseItem(
      prompt: '¡Feliz cumpleaños!',
      answer: 'Alles Gute zum Geburtstag',
    ),
    CourseItem(prompt: '¡Buena suerte!', answer: 'Viel Glück!'),
    CourseItem(prompt: '¡Que te mejores!', answer: 'Gute Besserung!'),
    CourseItem(prompt: 'Lo siento', answer: 'Es tut mir leid'),
    CourseItem(prompt: 'No hay problema', answer: 'Kein Problem'),
  ],
);

final List<QuizContent> esDeNivel3 = [
  esDeAlojamiento,
  esDeEmergencias,
  esDeFechas,
  esDeCultura,
];
