import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest A1.1 — Primeros pasos (Erste Schritte). Deutsch → Spanisch.

final QuizContent deEsA11Saludos = deEsFill(
  id: 'de_es_a1_1_saludos',
  title: 'Saludos y cortesía',
  intro: 'Die wichtigsten spanischen Begrüßungen und Höflichkeitsfloskeln – '
      'lerne sie auswendig.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '¿ und ¡',
      text: 'Spanisch öffnet Fragen und Ausrufe mit einem umgekehrten Zeichen: '
          '¿Qué tal? · ¡Hola!',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hallo', answer: 'Hola'),
    CourseItem(prompt: 'Guten Morgen', answer: 'Buenos días'),
    CourseItem(prompt: 'Guten Tag (nachmittags)', answer: 'Buenas tardes'),
    CourseItem(prompt: 'Gute Nacht', answer: 'Buenas noches'),
    CourseItem(prompt: 'Auf Wiedersehen', answer: 'Adiós'),
    CourseItem(prompt: 'Tschüss / Bis später', answer: 'Hasta luego'),
    CourseItem(prompt: 'Bitte', answer: 'Por favor'),
    CourseItem(prompt: 'Danke', answer: 'Gracias', accepted: ['Muchas gracias']),
    CourseItem(prompt: 'Entschuldigung', answer: 'Perdón', accepted: ['Disculpe']),
    CourseItem(prompt: "Wie geht's?", answer: '¿Qué tal?', accepted: ['¿Cómo estás?']),
    CourseItem(prompt: 'Gut, danke', answer: 'Bien, gracias'),
    CourseItem(prompt: 'Ja', answer: 'Sí'),
    CourseItem(prompt: 'Nein', answer: 'No'),
  ],
);

final QuizContent deEsA11Alfabeto = deEsSpeak(
  id: 'de_es_a1_1_alfabeto',
  title: 'El alfabeto y los sonidos',
  intro: 'Höre die typischen spanischen Laute und sprich sie nach.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Dein Vorteil',
      text: 'Das spanische j/g [x] kennst du schon aus dem deutschen ach-Laut '
          '(»Bach«).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Die fünf reinen Vokale', answer: 'a, e, i, o, u'),
    CourseItem(prompt: 'j wie deutsches ach-ch', answer: 'jamón, Jerez, jirafa'),
    CourseItem(prompt: 'gerolltes r', answer: 'perro, carro, río'),
    CourseItem(prompt: 'c und z wie englisches th', answer: 'cielo, cinco, zapato'),
    CourseItem(prompt: 'der ñ-Laut', answer: 'España, niño, mañana'),
    CourseItem(prompt: 'g hart / weich / stumm', answer: 'gato, gente, guitarra'),
    CourseItem(prompt: 'stummes h', answer: 'hola, hospital, ahora'),
    CourseItem(prompt: 'qu wie k', answer: 'queso, quién, aquí'),
  ],
);

final QuizContent deEsA11Pronombres = deEsFill(
  id: 'de_es_a1_1_pronombres',
  title: 'Pronombres personales',
  intro: 'Die spanischen Personalpronomen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Pro-Drop',
      text: 'Pronomen meist weglassen: »Soy Anna«, nicht »Yo soy Anna«. Ein '
          'Subjekt »es« gibt es nicht (»llueve« = es regnet).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich', answer: 'yo'),
    CourseItem(prompt: 'du (informell)', answer: 'tú'),
    CourseItem(prompt: 'er', answer: 'él'),
    CourseItem(prompt: 'sie (Einzahl)', answer: 'ella'),
    CourseItem(prompt: 'wir', answer: 'nosotros', accepted: ['nosotras']),
    CourseItem(prompt: 'ihr', answer: 'vosotros', accepted: ['vosotras']),
    CourseItem(prompt: 'sie (Plural)', answer: 'ellos', accepted: ['ellas']),
    CourseItem(prompt: 'Sie (höflich)', answer: 'usted'),
    CourseItem(prompt: 'Sie (höflich, Plural)', answer: 'ustedes'),
  ],
);

final QuizContent deEsA11Ser = deEsFill(
  id: 'de_es_a1_1_ser',
  title: 'El verbo «ser»',
  intro: 'Das Verb »ser« (sein) für Identität, Herkunft und Beruf.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ser',
      text: '»ser« für bleibende Dinge: wer/was du bist, woher du kommst, dein '
          'Beruf. Das zweite »sein« (estar) kommt in A1.2.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich bin', answer: 'soy'),
    CourseItem(prompt: 'du bist', answer: 'eres'),
    CourseItem(prompt: 'er/sie ist', answer: 'es'),
    CourseItem(prompt: 'wir sind', answer: 'somos'),
    CourseItem(prompt: 'ihr seid', answer: 'sois'),
    CourseItem(prompt: 'sie sind', answer: 'son'),
    CourseItem(prompt: 'Ich bin Anna.', answer: 'Soy Anna.'),
    CourseItem(prompt: 'Bist du Student?', answer: '¿Eres estudiante?'),
    CourseItem(prompt: 'Er ist aus Berlin.', answer: 'Es de Berlín.'),
    CourseItem(prompt: 'Wir sind Deutsche.', answer: 'Somos alemanes.'),
    CourseItem(prompt: 'Es ist wichtig.', answer: 'Es importante.'),
  ],
);

final QuizContent deEsA11SprechenVorstellung = deEsSpeak(
  id: 'de_es_a1_1_sprechen_vorstellung',
  title: 'Hablar: ¿Cómo te llamas?',
  intro: 'Stell dich auf Spanisch vor – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Alter mit tener',
      text: 'Alter mit »tener«: »tengo veinte años« (wörtlich »ich habe 20 '
          'Jahre«). Sprecherin: encantada, Sprecher: encantado.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hallo, ich heiße Anna.', answer: 'Hola, me llamo Anna.'),
    CourseItem(prompt: 'Wie heißt du?', answer: '¿Cómo te llamas?'),
    CourseItem(prompt: 'Ich komme aus Deutschland.', answer: 'Soy de Alemania.'),
    CourseItem(prompt: 'Woher kommst du?', answer: '¿De dónde eres?'),
    CourseItem(prompt: 'Ich bin Student/in.', answer: 'Soy estudiante.'),
    CourseItem(prompt: 'Ich bin 20 Jahre alt.', answer: 'Tengo veinte años.'),
    CourseItem(prompt: 'Sehr erfreut.', answer: 'Encantado.'),
    CourseItem(prompt: 'Freut mich.', answer: 'Mucho gusto.'),
  ],
);

final QuizContent deEsA11Numeros = deEsVocab(
  id: 'de_es_a1_1_numeros',
  title: 'Números 0–20',
  intro: 'Die Zahlen 0 bis 20 auf Spanisch.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Schreibweise',
      text: '16–19 werden zusammengeschrieben: dieciséis (mit Akzent), '
          'diecisiete, dieciocho, diecinueve.',
    ),
  ],
  pairs: const [
    MapEntry('0', 'cero'),
    MapEntry('1', 'uno'),
    MapEntry('2', 'dos'),
    MapEntry('3', 'tres'),
    MapEntry('4', 'cuatro'),
    MapEntry('5', 'cinco'),
    MapEntry('6', 'seis'),
    MapEntry('7', 'siete'),
    MapEntry('8', 'ocho'),
    MapEntry('9', 'nueve'),
    MapEntry('10', 'diez'),
    MapEntry('11', 'once'),
    MapEntry('12', 'doce'),
    MapEntry('13', 'trece'),
    MapEntry('14', 'catorce'),
    MapEntry('15', 'quince'),
    MapEntry('16', 'dieciséis'),
    MapEntry('17', 'diecisiete'),
    MapEntry('18', 'dieciocho'),
    MapEntry('19', 'diecinueve'),
    MapEntry('20', 'veinte'),
  ],
);

final QuizContent deEsA11Nacionalidades = deEsFill(
  id: 'de_es_a1_1_nacionalidades',
  title: 'Países y nacionalidades',
  intro: 'Länder, Sprachen und Nationalitäten.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Kleinschreibung',
      text: 'Sprachen und Nationalitäten klein: »soy alemán«, »hablo español«. '
          'Länder groß: Alemania.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Deutschland', answer: 'Alemania'),
    CourseItem(prompt: 'ein Deutscher', answer: 'un alemán'),
    CourseItem(prompt: 'eine Deutsche', answer: 'una alemana'),
    CourseItem(prompt: 'Deutsch (Sprache)', answer: 'el alemán'),
    CourseItem(prompt: 'Spanien', answer: 'España'),
    CourseItem(prompt: 'Spanisch', answer: 'el español', accepted: ['el castellano']),
    CourseItem(prompt: 'Frankreich', answer: 'Francia'),
    CourseItem(prompt: 'Österreich', answer: 'Austria'),
    CourseItem(prompt: 'die Schweiz', answer: 'Suiza'),
    CourseItem(prompt: 'Italien', answer: 'Italia'),
    CourseItem(prompt: 'England', answer: 'Inglaterra'),
    CourseItem(prompt: 'Ich spreche Deutsch.', answer: 'Hablo alemán.'),
  ],
);

final QuizContent deEsA11Genero = deEsFill(
  id: 'de_es_a1_1_genero',
  title: 'Género: el/la, un/una',
  intro: 'Das grammatische Geschlecht und die Artikel el/la, un/una.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Nur zwei Genera',
      text: '-o meist maskulin, -a meist feminin. Achtung: Das Genus weicht oft '
          'vom Deutschen ab – die Sonne → el sol, der Tisch → la mesa.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'der Mann', answer: 'el hombre'),
    CourseItem(prompt: 'die Frau', answer: 'la mujer'),
    CourseItem(prompt: 'das Buch', answer: 'el libro'),
    CourseItem(prompt: 'das Haus', answer: 'la casa'),
    CourseItem(prompt: 'der Tisch', answer: 'la mesa'),
    CourseItem(prompt: 'die Sonne', answer: 'el sol'),
    CourseItem(prompt: 'der Mond', answer: 'la luna'),
    CourseItem(prompt: 'der Apfel', answer: 'la manzana'),
    CourseItem(prompt: 'das Wasser', answer: 'el agua'),
    CourseItem(prompt: 'die Blume', answer: 'la flor'),
    CourseItem(prompt: 'die Stadt', answer: 'la ciudad'),
  ],
);

final QuizContent deEsA11LesenPresentacion = deEsRead(
  id: 'de_es_a1_1_lesen_presentacion',
  title: 'Leer: ¡Hola! Me llamo Anna',
  passageTitle: '¡Hola! Me llamo Anna',
  passage:
      '¡Hola! Me llamo Anna. Soy de Hamburgo, en Alemania. Tengo veintidós '
      'años. Soy estudiante de medicina. Hablo alemán, inglés y un poco de '
      'español. Ahora vivo en Madrid con dos amigas. Me gusta mucho la ciudad. '
      '¿Y tú? ¿Cómo te llamas?',
  passageTranslation:
      'Hallo! Ich heiße Anna. Ich komme aus Hamburg, in Deutschland. Ich bin 22 '
      'Jahre alt. Ich bin Medizinstudentin. Ich spreche Deutsch, Englisch und '
      'ein bisschen Spanisch. Jetzt wohne ich in Madrid mit zwei Freundinnen. '
      'Die Stadt gefällt mir sehr. Und du? Wie heißt du?',
  intro: 'Lies einen kurzen spanischen Steckbrief.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Lesestrategie',
      text: 'Suche Schlüsselwörter (Hamburgo, medicina, amigas) – du musst nicht '
          'jedes Wort übersetzen.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿De dónde es Anna?',
      options: ['De Madrid', 'De Hamburgo', 'De Berlín'],
      correctIndex: 1,
      questionTranslation: 'Woher kommt Anna?',
    ),
    ReadingQuestion(
      question: '¿Cuántos años tiene?',
      options: ['12', '22', '20'],
      correctIndex: 1,
      questionTranslation: 'Wie alt ist sie?',
    ),
    ReadingQuestion(
      question: '¿Qué estudia?',
      options: ['Medicina', 'Idiomas', 'Música'],
      correctIndex: 0,
      questionTranslation: 'Was studiert sie?',
    ),
    ReadingQuestion(
      question: '¿Con quién vive en Madrid?',
      options: ['Sola', 'Con su familia', 'Con dos amigas'],
      correctIndex: 2,
      questionTranslation: 'Mit wem wohnt sie in Madrid?',
    ),
  ],
);

final QuizContent deEsA11Profesiones = deEsFill(
  id: 'de_es_a1_1_profesiones',
  title: 'Profesiones',
  intro: 'Berufe auf Spanisch.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Beruf ohne Artikel',
      text: '»Soy médico« (nicht »soy un médico«) – wie im Deutschen »Ich bin '
          'Arzt«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'der Arzt', answer: 'el médico'),
    CourseItem(prompt: 'die Ärztin', answer: 'la médica'),
    CourseItem(prompt: 'der Lehrer', answer: 'el profesor'),
    CourseItem(prompt: 'die Lehrerin', answer: 'la profesora'),
    CourseItem(prompt: 'der/die Student/in', answer: 'el estudiante', accepted: ['la estudiante']),
    CourseItem(prompt: 'der Kellner', answer: 'el camarero'),
    CourseItem(prompt: 'die Kellnerin', answer: 'la camarera'),
    CourseItem(prompt: 'der Ingenieur', answer: 'el ingeniero'),
    CourseItem(prompt: 'der Anwalt', answer: 'el abogado'),
    CourseItem(prompt: 'der Koch', answer: 'el cocinero'),
    CourseItem(prompt: 'arbeitslos', answer: 'desempleado', accepted: ['en paro']),
  ],
);

final QuizContent deEsA11VerbosAr = deEsFill(
  id: 'de_es_a1_1_verbos_ar',
  title: 'Verbos regulares en -ar',
  intro: 'Regelmäßige Verben auf -ar im Präsens.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Endungen',
      text: '-ar: -o / -as / -a / -amos / -áis / -an. Subjektpronomen weglassen.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich spreche (hablar)', answer: 'hablo'),
    CourseItem(prompt: 'du sprichst', answer: 'hablas'),
    CourseItem(prompt: 'er/sie spricht', answer: 'habla'),
    CourseItem(prompt: 'wir sprechen', answer: 'hablamos'),
    CourseItem(prompt: 'ihr sprecht', answer: 'habláis'),
    CourseItem(prompt: 'sie sprechen', answer: 'hablan'),
    CourseItem(prompt: 'ich arbeite (trabajar)', answer: 'trabajo'),
    CourseItem(prompt: 'sie studiert (estudiar)', answer: 'estudia'),
    CourseItem(prompt: 'wir reisen (viajar)', answer: 'viajamos'),
    CourseItem(prompt: 'sie kaufen (comprar)', answer: 'compran'),
    CourseItem(prompt: 'Ich spreche Spanisch.', answer: 'Hablo español.'),
  ],
);

final QuizContent deEsA11SprechenNumeros = deEsSpeak(
  id: 'de_es_a1_1_sprechen_numeros',
  title: 'Hablar: números y deletrear',
  intro: 'Zahlen sprechen und buchstabieren.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'c/z = [θ]',
      text: 'Sprich »cinco«, »once«, »doce« mit dem englischen th-Laut.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Zählen 1–5', answer: 'uno, dos, tres, cuatro, cinco'),
    CourseItem(prompt: 'Zählen 6–10', answer: 'seis, siete, ocho, nueve, diez'),
    CourseItem(prompt: '11–13', answer: 'once, doce, trece'),
    CourseItem(prompt: 'Meine Nummer ist…', answer: 'Mi número es seis, ocho, dos, cuatro.'),
    CourseItem(prompt: 'Wie alt bist du?', answer: '¿Cuántos años tienes?'),
    CourseItem(prompt: 'Ich bin 30.', answer: 'Tengo treinta años.'),
    CourseItem(prompt: 'Wie schreibt man das?', answer: '¿Cómo se escribe?'),
  ],
);

final QuizContent deEsA11LesenCompanera = deEsRead(
  id: 'de_es_a1_1_lesen_companera',
  title: 'Leer: Mi compañera de piso',
  passageTitle: 'Mi compañera de piso',
  passage:
      'Mi compañera de piso se llama Sofía. Es española, de Valencia. Tiene '
      'veinticuatro años y es enfermera. Es muy simpática y habla un poco de '
      'alemán. Por las mañanas toma café con leche y por las tardes practica '
      'yoga. Los fines de semana cocinamos juntas. ¡Me gusta mucho vivir con '
      'ella!',
  passageTranslation:
      'Meine Mitbewohnerin heißt Sofía. Sie ist Spanierin, aus Valencia. Sie '
      'ist 24 Jahre alt und Krankenschwester. Sie ist sehr nett und spricht ein '
      'bisschen Deutsch. Morgens trinkt sie Milchkaffee und nachmittags macht '
      'sie Yoga. Am Wochenende kochen wir zusammen. Ich wohne sehr gern mit '
      'ihr!',
  intro: 'Lies über Annas Mitbewohnerin.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'un poco de',
      text: '»un poco de« = ein bisschen. Suche wieder Schlüsselwörter '
          '(Valencia, enfermera).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cómo se llama la compañera?',
      options: ['Sofía', 'Anna', 'Lucía'],
      correctIndex: 0,
      questionTranslation: 'Wie heißt die Mitbewohnerin?',
    ),
    ReadingQuestion(
      question: '¿De dónde es?',
      options: ['De Madrid', 'De Valencia', 'De Alemania'],
      correctIndex: 1,
      questionTranslation: 'Woher kommt sie?',
    ),
    ReadingQuestion(
      question: '¿Qué profesión tiene?',
      options: ['Profesora', 'Enfermera', 'Médica'],
      correctIndex: 1,
      questionTranslation: 'Welchen Beruf hat sie?',
    ),
    ReadingQuestion(
      question: '¿Qué hacen los fines de semana?',
      options: ['Practican yoga', 'Cocinan juntas', 'Estudian'],
      correctIndex: 1,
      questionTranslation: 'Was machen sie am Wochenende?',
    ),
  ],
);

final QuizContent deEsA11SprechenClase = deEsSpeak(
  id: 'de_es_a1_1_sprechen_clase',
  title: 'Hablar: en clase de español',
  intro: 'Nützliche Sätze für den Spanischunterricht.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Im Unterricht',
      text: '»¿Cómo se dice…?« ist dein bester Freund – nutze ihn ständig.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wie sagt man …?', answer: '¿Cómo se dice ... en español?'),
    CourseItem(prompt: 'Man sagt …', answer: 'Se dice ...'),
    CourseItem(prompt: 'Können Sie wiederholen?', answer: '¿Puede repetir, por favor?'),
    CourseItem(prompt: 'Langsamer, bitte.', answer: 'Más despacio, por favor.'),
    CourseItem(prompt: 'Ich verstehe nicht.', answer: 'No entiendo.'),
    CourseItem(prompt: 'Was bedeutet …?', answer: '¿Qué significa ...?'),
    CourseItem(prompt: 'Wie schreibt man das?', answer: '¿Cómo se escribe?'),
  ],
);

/// Quest A1.1 in chain order (interleaved knowledge / audio / reading).
final List<QuizContent> deEsA1_1 = [
  deEsA11Saludos,
  deEsA11Alfabeto,
  deEsA11Pronombres,
  deEsA11Ser,
  deEsA11SprechenVorstellung,
  deEsA11Numeros,
  deEsA11Nacionalidades,
  deEsA11Genero,
  deEsA11LesenPresentacion,
  deEsA11Profesiones,
  deEsA11VerbosAr,
  deEsA11SprechenNumeros,
  deEsA11LesenCompanera,
  deEsA11SprechenClase,
];
