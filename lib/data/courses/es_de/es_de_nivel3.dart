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
      text: 'Muchos alojamientos piden el pasaporte o un documento de identidad '
          'al hacer el check-in.',
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
    CourseItem(prompt: 'Soy de…', answer: 'Ich komme aus …'),
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

/// Listen & repeat: practice saying the most useful Nivel 3 phrases aloud.
final QuizContent esDeHablarSituaciones = speakRepeatQuiz(
  id: 'es_de_hablar_situaciones',
  title: 'Hablar: situaciones',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Escucha y repite frases para emergencias, el alojamiento y la charla '
      'cotidiana. Con el micrófono te decimos si te salió bien; sin él, repite '
      'a tu ritmo y pasa a la siguiente.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Que se entienda',
      text: 'En una emergencia, habla despacio y claro. "Hilfe!" y "Notfall" '
          'deben sonar fuertes y nítidos.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "z" y la "v"',
      text: 'La "z" suena "ts" (Arzt = "artst") y la "v" suena como "f" '
          '(viel = "fíl"). Practícalo con "Viel Glück!".',
    ),
  ],
  items: const [
    CourseItem(prompt: '¡Ayuda!', answer: 'Hilfe!'),
    CourseItem(prompt: 'Es una emergencia', answer: 'Es ist ein Notfall'),
    CourseItem(prompt: 'Necesito un médico', answer: 'Ich brauche einen Arzt'),
    CourseItem(prompt: '¿Dónde está la farmacia?', answer: 'Wo ist die Apotheke?'),
    CourseItem(prompt: 'Lo siento', answer: 'Es tut mir leid'),
    CourseItem(prompt: 'No hay problema', answer: 'Kein Problem'),
    CourseItem(prompt: '¡Buen provecho!', answer: 'Guten Appetit!'),
    CourseItem(prompt: '¡Buena suerte!', answer: 'Viel Glück!'),
    CourseItem(prompt: '¡Que te mejores!', answer: 'Gute Besserung!'),
    CourseItem(prompt: '¿De dónde eres?', answer: 'Woher kommst du?'),
  ],
);

/// Listen & repeat: say the accommodation phrases aloud.
final QuizContent esDeHablarAlojamiento = speakRepeatQuiz(
  id: 'es_de_hablar_alojamiento',
  title: 'Hablar: alojamiento',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Haz el check-in y resuelve problemas de la habitación en voz alta. Son '
      'frases que dirás en la recepción nada más llegar.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ü" de "Frühstück"',
      text: '"Frühstück" (desayuno) lleva dos "ü". Redondea los labios: '
          '"frü-shtük".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Check-in',
      text: '"Ich möchte einchecken" suena "ish möshte áin-tsheken". Dilo con '
          'calma en la recepción.',
    ),
  ],
  items: const [
    // Covers every phrase from "Alojamiento", plus a few extras.
    CourseItem(prompt: 'Tengo una reserva', answer: 'Ich habe eine Reservierung'),
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
    ),
    CourseItem(prompt: 'La llave, por favor', answer: 'Den Schlüssel, bitte'),
    CourseItem(
      prompt: 'No funciona la calefacción',
      answer: 'Die Heizung funktioniert nicht',
    ),
    CourseItem(prompt: '¿Dónde está el ascensor?', answer: 'Wo ist der Aufzug?'),
    CourseItem(prompt: '¿Tienen wifi?', answer: 'Haben Sie WLAN?'),
    // Extras.
    CourseItem(prompt: '¿Hay caja fuerte?', answer: 'Gibt es einen Safe?'),
    CourseItem(prompt: '¿A qué hora es el desayuno?', answer: 'Wann gibt es Frühstück?'),
  ],
);

/// Listen & repeat: say the emergency and health phrases aloud.
final QuizContent esDeHablarEmergencias = speakRepeatQuiz(
  id: 'es_de_hablar_emergencias',
  title: 'Hablar: emergencias',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Practica en voz alta las frases que pueden ser vitales. En una urgencia '
      'tienen que salir fuertes y claras, sin dudar.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Fuerte y claro',
      text: '"Hilfe!" (¡ayuda!) y "Notfall" (emergencia) deben oírse nítidos. '
          'Repítelos hasta que suenen seguros.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "z" de "Arzt"',
      text: '"Arzt" (médico) suena "artst", con la "z" como "ts". Practica "Ich '
          'brauche einen Arzt".',
    ),
  ],
  items: const [
    // Covers every phrase from "Emergencias y salud", plus a few extras.
    CourseItem(prompt: '¡Ayuda!', answer: 'Hilfe!'),
    CourseItem(prompt: 'Es una emergencia', answer: 'Es ist ein Notfall'),
    CourseItem(prompt: 'Llame a una ambulancia', answer: 'Rufen Sie einen Krankenwagen'),
    CourseItem(prompt: 'Llame a la policía', answer: 'Rufen Sie die Polizei'),
    CourseItem(prompt: 'Necesito un médico', answer: 'Ich brauche einen Arzt'),
    CourseItem(prompt: 'Me encuentro mal', answer: 'Mir geht es schlecht'),
    CourseItem(prompt: 'Me duele aquí', answer: 'Es tut hier weh'),
    CourseItem(prompt: '¿Dónde está la farmacia?', answer: 'Wo ist die Apotheke?'),
    CourseItem(prompt: 'Soy alérgico a…', answer: 'Ich bin allergisch gegen …'),
    CourseItem(prompt: 'He perdido mi pasaporte', answer: 'Ich habe meinen Pass verloren'),
    CourseItem(prompt: '¿Dónde está el hospital?', answer: 'Wo ist das Krankenhaus?'),
    // Extras.
    CourseItem(prompt: 'Necesito ayuda', answer: 'Ich brauche Hilfe'),
    CourseItem(prompt: 'Llame a un médico', answer: 'Rufen Sie einen Arzt'),
  ],
);

/// Listen & repeat: say the days, times and appointment phrases aloud.
final QuizContent esDeHablarFechas = speakRepeatQuiz(
  id: 'es_de_hablar_fechas',
  title: 'Hablar: días y horas',
  promptLabel: 'Palabra',
  subjectsLabel: 'Palabras',
  subjectColumnLabel: 'Alemán',
  intro:
      'Di en voz alta los días y las horas. Te sirven para reservas, horarios y '
      'quedar con alguien.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Los días en "-tag"',
      text: 'Casi todos los días terminan en "-tag" ("taag"), con "a" larga: '
          'Montag, Freitag, Samstag.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La hora',
      text: '"Wie spät ist es?" (¿qué hora es?) suena "vii shpeet ist es". La '
          '"sp" se dice "shp".',
    ),
  ],
  items: const [
    // Covers every word from "Días, horas y citas", plus the rest of the week.
    CourseItem(prompt: 'Hoy', answer: 'heute'),
    CourseItem(prompt: 'Mañana (el día siguiente)', answer: 'morgen'),
    CourseItem(prompt: 'Ayer', answer: 'gestern'),
    CourseItem(prompt: 'Lunes', answer: 'Montag'),
    CourseItem(prompt: 'Martes', answer: 'Dienstag'),
    CourseItem(prompt: 'Miércoles', answer: 'Mittwoch'),
    CourseItem(prompt: 'Jueves', answer: 'Donnerstag'),
    CourseItem(prompt: 'Viernes', answer: 'Freitag'),
    CourseItem(prompt: 'Sábado', answer: 'Samstag'),
    CourseItem(prompt: 'Domingo', answer: 'Sonntag'),
    CourseItem(prompt: '¿Qué hora es?', answer: 'Wie spät ist es?'),
    CourseItem(prompt: '¿A qué hora?', answer: 'Um wie viel Uhr?'),
    CourseItem(prompt: 'A las tres', answer: 'um drei'),
    CourseItem(prompt: '¿Cuándo abre?', answer: 'Wann öffnet es?'),
  ],
);

/// Listen & repeat: say the small-talk and culture phrases aloud.
final QuizContent esDeHablarCharla = speakRepeatQuiz(
  id: 'es_de_hablar_charla',
  title: 'Hablar: charla',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Rompe el hielo en voz alta: de dónde eres, buenos deseos y fórmulas de '
      'cortesía para el día a día.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Buenos deseos',
      text: '"Viel Glück!" (¡buena suerte!) y "Gute Besserung!" (¡que te '
          'mejores!) caen muy bien. Dilos con energía.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "w" de "Woher"',
      text: '"Woher kommst du?" (¿de dónde eres?) suena "vo-héer". La "w" '
          'alemana se dice como "v".',
    ),
  ],
  items: const [
    // Covers every phrase from "Charla y cultura", plus a few extras.
    CourseItem(prompt: '¿De dónde eres?', answer: 'Woher kommst du?'),
    CourseItem(prompt: 'Soy de…', answer: 'Ich komme aus …'),
    CourseItem(prompt: '¿Hablas español?', answer: 'Sprichst du Spanisch?'),
    CourseItem(prompt: 'Encantado', answer: 'Sehr erfreut'),
    CourseItem(prompt: '¡Buen provecho!', answer: 'Guten Appetit!'),
    CourseItem(prompt: '¡Feliz cumpleaños!', answer: 'Alles Gute zum Geburtstag'),
    CourseItem(prompt: '¡Buena suerte!', answer: 'Viel Glück!'),
    CourseItem(prompt: '¡Que te mejores!', answer: 'Gute Besserung!'),
    CourseItem(prompt: 'Lo siento', answer: 'Es tut mir leid'),
    CourseItem(prompt: 'No hay problema', answer: 'Kein Problem'),
    // Extras.
    CourseItem(prompt: '¿Cómo te llamas?', answer: 'Wie heißt du?'),
    CourseItem(prompt: 'Gracias por todo', answer: 'Danke für alles'),
  ],
);

final List<QuizContent> esDeNivel3 = [
  esDeHablarSituaciones,
  esDeAlojamiento,
  esDeHablarAlojamiento,
  esDeEmergencias,
  esDeHablarEmergencias,
  esDeFechas,
  esDeHablarFechas,
  esDeCultura,
  esDeHablarCharla,
];
