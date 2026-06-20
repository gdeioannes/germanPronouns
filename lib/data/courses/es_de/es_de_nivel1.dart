import '../../../models/quiz_content.dart';
import 'es_de_builder.dart';

/// Nivel 1 — Lo básico (saludos, números, frases de supervivencia).

final QuizContent esDeSaludos = sentenceCourseQuiz(
  id: 'es_de_saludos',
  title: 'Saludos y cortesía',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Lo primero al viajar: saludar y ser educado. En Alemania la cortesía y '
      'un saludo claro abren muchas puertas. Aprende estas fórmulas de memoria.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Tú (du) vs. usted (Sie)',
      text: 'Con desconocidos, en tiendas y con mayores usa la forma formal '
          '"Sie". El "du" es para amigos, familia y niños.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Cultura',
      text: 'Los alemanes suelen saludar con un apretón de manos firme y '
          'contacto visual. "Tschüss" es informal; "Auf Wiedersehen", formal.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Gracias',
      text: '"Danke" = gracias. Para dar más énfasis: "Danke schön" o "Vielen '
          'Dank". Te responderán "Bitte" (de nada).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hola', answer: 'Hallo', accepted: ['Guten Tag']),
    CourseItem(prompt: 'Buenos días', answer: 'Guten Morgen'),
    CourseItem(prompt: 'Buenas tardes', answer: 'Guten Tag'),
    CourseItem(prompt: 'Buenas noches (despedida)', answer: 'Gute Nacht'),
    CourseItem(prompt: 'Adiós', answer: 'Auf Wiedersehen', accepted: ['Tschüss']),
    CourseItem(prompt: 'Hasta luego', answer: 'Bis später', accepted: ['Bis bald']),
    CourseItem(prompt: 'Por favor', answer: 'Bitte'),
    CourseItem(
      prompt: 'Gracias',
      answer: 'Danke',
      accepted: ['Danke schön', 'Vielen Dank'],
    ),
    CourseItem(prompt: 'De nada', answer: 'Bitte', accepted: ['Gern geschehen']),
    CourseItem(
      prompt: 'Perdón / Disculpe',
      answer: 'Entschuldigung',
      accepted: ['Entschuldigen Sie'],
    ),
    CourseItem(prompt: 'Sí', answer: 'Ja'),
    CourseItem(prompt: 'No', answer: 'Nein'),
    CourseItem(
      prompt: '¿Cómo está usted?',
      answer: 'Wie geht es Ihnen?',
      accepted: ["Wie geht's?"],
    ),
    CourseItem(prompt: 'Me llamo…', answer: 'Ich heiße …'),
    CourseItem(prompt: 'Mucho gusto', answer: 'Freut mich'),
  ],
);

final QuizContent esDeNumeros = vocabCourseQuiz(
  id: 'es_de_numeros',
  title: 'Números y precios',
  promptLabel: 'Número',
  subjectsLabel: 'Números',
  subjectColumnLabel: 'Número',
  categoryLabel: 'En alemán',
  template: 'El número {subject} en alemán: ____',
  intro:
      'Los números son imprescindibles para precios, horarios y direcciones. '
      'Fíjate: a partir de 21 el alemán dice primero las unidades '
      '(einundzwanzig = uno-y-veinte).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Ortografía',
      text: '16 = sechzehn, 17 = siebzehn, 30 = dreißig (con ß). Los precios se '
          'leen con coma: 3,50 € = "drei Euro fünfzig".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Preguntar el precio',
      text: '"¿Cuánto cuesta?" = "Was kostet das?" — muy útil en tiendas y '
          'mercados.',
    ),
  ],
  pairs: const [
    MapEntry('0', 'null'),
    MapEntry('1', 'eins'),
    MapEntry('2', 'zwei'),
    MapEntry('3', 'drei'),
    MapEntry('4', 'vier'),
    MapEntry('5', 'fünf'),
    MapEntry('6', 'sechs'),
    MapEntry('7', 'sieben'),
    MapEntry('8', 'acht'),
    MapEntry('9', 'neun'),
    MapEntry('10', 'zehn'),
    MapEntry('11', 'elf'),
    MapEntry('12', 'zwölf'),
    MapEntry('13', 'dreizehn'),
    MapEntry('16', 'sechzehn'),
    MapEntry('20', 'zwanzig'),
    MapEntry('21', 'einundzwanzig'),
    MapEntry('30', 'dreißig'),
    MapEntry('50', 'fünfzig'),
    MapEntry('100', 'hundert'),
  ],
);

final QuizContent esDeSupervivencia = sentenceCourseQuiz(
  id: 'es_de_supervivencia',
  title: 'Frases de supervivencia',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'En alemán',
  intro:
      'Cuando no entiendes nada, estas frases te salvan. Memorízalas: te '
      'permiten pedir ayuda y que te hablen más despacio.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pide ayuda en inglés',
      text: 'Muchos alemanes hablan inglés. "Sprechen Sie Englisch?" '
          '(¿Habla inglés?) suele funcionar si te atascas.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'WLAN = wifi',
      text: 'En Alemania el wifi se llama "WLAN" (se dice "ve-lan"). El baño '
          'es "die Toilette" o "das WC".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'No entiendo', answer: 'Ich verstehe nicht'),
    CourseItem(prompt: '¿Habla inglés?', answer: 'Sprechen Sie Englisch?'),
    CourseItem(prompt: 'No hablo alemán', answer: 'Ich spreche kein Deutsch'),
    CourseItem(
      prompt: '¿Dónde está el baño?',
      answer: 'Wo ist die Toilette?',
    ),
    CourseItem(
      prompt: '¿Puede ayudarme?',
      answer: 'Können Sie mir helfen?',
    ),
    CourseItem(
      prompt: '¿Cuánto cuesta?',
      answer: 'Was kostet das?',
      accepted: ['Wie viel kostet das?'],
    ),
    CourseItem(prompt: 'Más despacio, por favor', answer: 'Langsamer, bitte'),
    CourseItem(prompt: '¿Cómo se dice…?', answer: 'Wie sagt man …?'),
    CourseItem(prompt: 'No sé', answer: 'Ich weiß nicht'),
    CourseItem(
      prompt: 'Estoy perdido',
      answer: 'Ich habe mich verlaufen',
      accepted: ['Ich bin verloren'],
    ),
    CourseItem(prompt: '¿Tiene wifi?', answer: 'Haben Sie WLAN?'),
    CourseItem(prompt: 'Una pregunta, por favor', answer: 'Eine Frage, bitte'),
  ],
);

/// Listen & repeat: practice saying the most useful Nivel 1 phrases aloud.
final QuizContent esDeHablarBasico = speakRepeatQuiz(
  id: 'es_de_hablar_basico',
  title: 'Hablar: lo básico',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Escucha cada frase en alemán y repítela en voz alta. Si tu micrófono '
      'está disponible, te diremos si te salió bien. Si no, escucha y repite a '
      'tu ritmo y pasa a la siguiente.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Imita el ritmo',
      text: 'No te fijes solo en cada sonido: copia la entonación y el ritmo de '
          'la frase. Sonará mucho más natural.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ch" y la "r"',
      text: '"Ich" suena suave (como un susurro), y la "r" alemana se hace en '
          'la garganta. Repite "Danke" y "Entschuldigung" varias veces.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hola', answer: 'Hallo'),
    CourseItem(prompt: 'Buenos días', answer: 'Guten Morgen'),
    CourseItem(prompt: 'Gracias', answer: 'Danke'),
    CourseItem(prompt: 'Por favor', answer: 'Bitte'),
    CourseItem(prompt: 'Perdón / Disculpe', answer: 'Entschuldigung'),
    CourseItem(prompt: 'Sí', answer: 'Ja'),
    CourseItem(prompt: 'No', answer: 'Nein'),
    CourseItem(prompt: 'Adiós', answer: 'Auf Wiedersehen'),
    CourseItem(prompt: '¿Habla inglés?', answer: 'Sprechen Sie Englisch?'),
    CourseItem(prompt: '¿Cuánto cuesta?', answer: 'Was kostet das?'),
  ],
);

/// Listen & repeat: say the greetings and courtesy formulas aloud.
final QuizContent esDeHablarSaludos = speakRepeatQuiz(
  id: 'es_de_hablar_saludos',
  title: 'Hablar: saludos',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Di en voz alta los saludos y las fórmulas de cortesía. Son lo primero '
      'que usarás al llegar, así que conviene que te salgan solas.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Suena educado',
      text: 'Un "Hallo" o "Danke" con una sonrisa abre puertas. Alarga un poco '
          'el saludo: "Guten Taag".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "sch" y la "ü"',
      text: '"Tschüss" empieza con "ch" fuerte ("chüss") y "schön" lleva "ö". '
          'Repite "Danke schön" hasta que fluya.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hola', answer: 'Hallo'),
    CourseItem(prompt: 'Buenos días', answer: 'Guten Morgen'),
    CourseItem(prompt: 'Por favor', answer: 'Bitte'),
    CourseItem(prompt: 'Gracias', answer: 'Danke'),
    CourseItem(prompt: 'Muchas gracias', answer: 'Danke schön'),
    CourseItem(prompt: 'De nada', answer: 'Bitte'),
    CourseItem(prompt: 'Perdón / Disculpe', answer: 'Entschuldigung'),
    CourseItem(prompt: '¿Cómo está usted?', answer: 'Wie geht es Ihnen?'),
    CourseItem(prompt: 'Me llamo…', answer: 'Ich heiße …'),
    CourseItem(prompt: 'Mucho gusto', answer: 'Freut mich'),
  ],
);

/// Listen & repeat: say the numbers and prices aloud.
final QuizContent esDeHablarNumeros = speakRepeatQuiz(
  id: 'es_de_hablar_numeros',
  title: 'Hablar: números',
  promptLabel: 'Número',
  subjectsLabel: 'Números',
  subjectColumnLabel: 'Alemán',
  intro:
      'Escucha y repite los números. Saber decirlos te ayuda con precios, '
      'andenes y números de habitación.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'La "z" y la "ei"',
      text: '"zwei" suena "tsvái" y "zwanzig" "tsván-tsij". La "z" alemana es '
          'siempre "ts".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Precios con coma',
      text: '"3,50 €" se dice "drei Euro fünfzig": primero los euros, luego los '
          'céntimos.',
    ),
  ],
  items: const [
    CourseItem(prompt: '1', answer: 'eins'),
    CourseItem(prompt: '2', answer: 'zwei'),
    CourseItem(prompt: '3', answer: 'drei'),
    CourseItem(prompt: '4', answer: 'vier'),
    CourseItem(prompt: '5', answer: 'fünf'),
    CourseItem(prompt: '6', answer: 'sechs'),
    CourseItem(prompt: '7', answer: 'sieben'),
    CourseItem(prompt: '8', answer: 'acht'),
    CourseItem(prompt: '10', answer: 'zehn'),
    CourseItem(prompt: '20', answer: 'zwanzig'),
    CourseItem(prompt: '3,50 € (precio)', answer: 'drei Euro fünfzig'),
  ],
);

/// Listen & repeat: say the survival phrases aloud.
final QuizContent esDeHablarSupervivencia = speakRepeatQuiz(
  id: 'es_de_hablar_supervivencia',
  title: 'Hablar: supervivencia',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Repite las frases que te sacan de un apuro: pedir ayuda, decir que no '
      'entiendes o pedir que te hablen más despacio.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Vocaliza',
      text: '"Langsamer, bitte" (más despacio) pierde sentido si la dices '
          'rápido. Pronuncia cada sílaba con calma.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "v" y la "w"',
      text: '"verstehe" suena con "f" ("fer-shtée-e") y "WLAN" se dice "ve-lan". '
          'Practica "Ich verstehe nicht".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'No entiendo', answer: 'Ich verstehe nicht'),
    CourseItem(prompt: '¿Habla inglés?', answer: 'Sprechen Sie Englisch?'),
    CourseItem(prompt: 'No hablo alemán', answer: 'Ich spreche kein Deutsch'),
    CourseItem(prompt: '¿Dónde está el baño?', answer: 'Wo ist die Toilette?'),
    CourseItem(prompt: '¿Puede ayudarme?', answer: 'Können Sie mir helfen?'),
    CourseItem(prompt: 'Más despacio, por favor', answer: 'Langsamer, bitte'),
    CourseItem(prompt: 'No sé', answer: 'Ich weiß nicht'),
    CourseItem(prompt: 'Estoy perdido', answer: 'Ich habe mich verlaufen'),
    CourseItem(prompt: '¿Tiene wifi?', answer: 'Haben Sie WLAN?'),
  ],
);

final List<QuizContent> esDeNivel1 = [
  esDeHablarBasico,
  esDeSaludos,
  esDeHablarSaludos,
  esDeNumeros,
  esDeHablarNumeros,
  esDeSupervivencia,
  esDeHablarSupervivencia,
];
