import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// A1.2 — Daily life. English → Spanish.
///
/// Big rocks: the regular present (-ar/-er/-ir, ⚑E9) with dropped pronouns
/// (⚑E10), estar and the first ser/estar contrast (⚑E11), gustar (⚑E12),
/// reflexive routine verbs (⚑E13), family, days and times (⚑E26).

final QuizContent enEsA12ArVerbs = enEsFill(
  id: 'en_es_a1_2_ar_verbs',
  title: 'The -ar present: hablo, hablas…',
  intro: 'Regular -ar verbs swap -ar for personal endings: hablo, hablas, '
      'habla, hablamos, hablan. The ending IS the subject (⚑E9).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The -ar endings',
      text: '-o, -as, -a, -amos, -an (Spain adds -áis ⚑E28). Learn them '
          'as a song: hablo-hablas-habla…',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '⚑E10 No pronoun needed',
      text: 'Trabajo en Madrid = I work in Madrid. Adding yo is emphasis, '
          'not grammar.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I speak Spanish.', answer: '**Hablo** español.'),
    CourseItem(prompt: 'You work here. (tú)', answer: '**Trabajas** aquí.'),
    CourseItem(prompt: 'She studies medicine.', answer: 'Ella **estudia** medicina.'),
    CourseItem(prompt: 'We buy bread.', answer: '**Compramos** pan.'),
    CourseItem(prompt: 'They dance very well.', answer: '**Bailan** muy bien.'),
    CourseItem(prompt: 'I need a coffee.', answer: '**Necesito** un café.'),
    CourseItem(prompt: 'He works in a hospital.', answer: '**Trabaja** en un hospital.'),
    CourseItem(prompt: 'Do you speak English? (tú)', answer: '¿**Hablas** inglés?'),
    CourseItem(prompt: 'We travel in summer.', answer: '**Viajamos** en verano.'),
    CourseItem(prompt: 'She sings in the shower.', answer: '**Canta** en la ducha.'),
    CourseItem(prompt: 'I cook on Sundays.', answer: '**Cocino** los domingos.'),
    CourseItem(prompt: 'They study at night.', answer: '**Estudian** por la noche.'),
    CourseItem(prompt: 'You (formal) work a lot.', answer: 'Usted **trabaja** mucho.'),
    CourseItem(prompt: 'We speak Spanish at home.', answer: '**Hablamos** español en casa.'),
    CourseItem(prompt: 'I buy fruit at the market.', answer: '**Compro** fruta en el mercado.'),
  ],
);

final QuizContent enEsA12ErIrVerbs = enEsFill(
  id: 'en_es_a1_2_er_ir_verbs',
  title: 'The -er / -ir present: como, vivo…',
  intro: '-er and -ir verbs share almost all endings: como, comes, come, '
      'comemos, comen · vivo, vives, vive, vivimos, viven.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Only nosotros differs',
      text: 'comemos (-er) vs vivimos (-ir) — everywhere else the two '
          'families match. One table, two verbs.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I eat at two.', answer: '**Como** a las dos.'),
    CourseItem(prompt: 'You live here. (tú)', answer: '**Vives** aquí.'),
    CourseItem(prompt: 'She reads a lot.', answer: 'Ella **lee** mucho.'),
    CourseItem(prompt: 'We live in London.', answer: '**Vivimos** en Londres.'),
    CourseItem(prompt: 'They drink coffee.', answer: '**Beben** café.'),
    CourseItem(prompt: 'He writes emails.', answer: '**Escribe** correos.'),
    CourseItem(prompt: 'Where do you live? (tú)', answer: '¿Dónde **vives**?'),
    CourseItem(prompt: 'We eat together.', answer: '**Comemos** juntos.'),
    CourseItem(prompt: 'I read the newspaper.', answer: '**Leo** el periódico.'),
    CourseItem(prompt: 'She learns fast. (aprender)', answer: '**Aprende** rápido.'),
    CourseItem(prompt: 'They open at nine. (abrir)', answer: '**Abren** a las nueve.'),
    CourseItem(prompt: 'I write to my grandmother.', answer: '**Escribo** a mi abuela.'),
    CourseItem(prompt: 'Do you drink tea? (tú)', answer: '¿**Bebes** té?'),
    CourseItem(prompt: 'We learn Spanish. (aprender)', answer: '**Aprendemos** español.'),
    CourseItem(prompt: 'He lives with his parents.', answer: '**Vive** con sus padres.'),
  ],
);

final QuizContent enEsA12Estar = enEsFill(
  id: 'en_es_a1_2_estar',
  title: 'estar: location and states',
  intro: 'Spanish has TWO verbs "to be". estar = where things are and how '
      'they feel right now: estoy en casa, estoy cansado (⚑E11).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The first rule of ser/estar',
      text: 'WHERE and HOW-right-now → estar. WHO/WHAT something is → '
          'ser. Madrid está en España, pero Madrid es una ciudad.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am at home.', answer: '**Estoy** en casa.'),
    CourseItem(prompt: 'Where are you? (tú)', answer: '¿Dónde **estás**?'),
    CourseItem(prompt: 'She is tired.', answer: '**Está** cansada.'),
    CourseItem(prompt: 'We are in the café.', answer: '**Estamos** en el café.'),
    CourseItem(prompt: 'The keys are on the table.', answer: 'Las llaves **están** en la mesa.'),
    CourseItem(prompt: 'I am very happy today. (contento)', answer: '**Estoy** muy contento hoy.'),
    CourseItem(prompt: 'The coffee is cold. (right now)', answer: 'El café **está** frío.'),
    CourseItem(prompt: 'He is ill. (enfermo)', answer: '**Está** enfermo.'),
    CourseItem(prompt: 'The bank is closed.', answer: 'El banco **está** cerrado.'),
    CourseItem(prompt: 'Madrid is in Spain.', answer: 'Madrid **está** en España.'),
    CourseItem(prompt: 'But Madrid is a city. (ser!)', answer: 'Pero Madrid **es** una ciudad.'),
    CourseItem(prompt: 'She is a teacher. (ser!)', answer: '**Es** profesora.'),
    CourseItem(prompt: 'The soup is hot. (right now)', answer: 'La sopa **está** caliente.'),
    CourseItem(prompt: 'We are nervous. (nervioso)', answer: '**Estamos** nerviosos.'),
    CourseItem(prompt: 'How are you? (tú)', answer: '¿Cómo **estás**?'),
  ],
);

final QuizContent enEsA12Gustar = enEsFill(
  id: 'en_es_a1_2_gustar',
  title: 'me gusta: liking, backwards',
  intro: 'gustar works backwards: Me gusta el café = coffee pleases me. '
      'Singular thing → gusta, plural things → gustan (⚑E12).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E12 The verb agrees with the THING',
      text: 'Me gusta el café (one thing) · Me gustan los libros (many '
          'things). Never "yo gusto café".',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Change the person, not the verb',
      text: 'me/te/le/nos/les gusta(n): le gusta = he or she likes. The '
          'front pronoun carries who.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I like coffee.', answer: 'Me **gusta** el café.'),
    CourseItem(prompt: 'I like books.', answer: 'Me **gustan** los libros.'),
    CourseItem(prompt: 'Do you like music? (tú)', answer: '¿Te **gusta** la música?'),
    CourseItem(prompt: 'She likes to dance.', answer: 'Le **gusta** bailar.'),
    CourseItem(prompt: 'We like Mexican food.', answer: 'Nos **gusta** la comida mexicana.'),
    CourseItem(prompt: 'They like sports.', answer: 'Les **gustan** los deportes.'),
    CourseItem(prompt: 'I don\'t like Mondays.', answer: 'No me **gustan** los lunes.'),
    CourseItem(prompt: 'He likes coffee with milk.', answer: 'Le **gusta** el café con leche.'),
    CourseItem(prompt: 'Do you like animals? (tú)', answer: '¿Te **gustan** los animales?'),
    CourseItem(prompt: 'I like this city a lot.', answer: 'Me **gusta** mucho esta ciudad.'),
    CourseItem(prompt: 'We like to travel.', answer: 'Nos **gusta** viajar.'),
    CourseItem(prompt: 'She doesn\'t like fish.', answer: 'No le **gusta** el pescado.'),
    CourseItem(prompt: 'I like the blue chairs.', answer: 'Me **gustan** las sillas azules.'),
    CourseItem(prompt: 'They like to read.', answer: 'Les **gusta** leer.'),
    CourseItem(prompt: 'And I love chocolate! (encantar)', answer: '¡Y me **encanta** el chocolate!'),
  ],
);

final QuizContent enEsA12SpeakRoutine = enEsSpeak(
  id: 'en_es_a1_2_speak_routine',
  title: 'Speak: my routine',
  intro: 'Daily routine phrases with reflexive verbs. Listen and repeat, '
      'keeping every vowel pure.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '⚑E13 The little me/se',
      text: 'me levanto, se ducha — routine verbs carry a reflexive '
          'pronoun. It is part of the verb: say it every time.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I get up at seven.', answer: 'Me levanto a las siete.'),
    CourseItem(prompt: 'I have breakfast at home.', answer: 'Desayuno en casa.'),
    CourseItem(prompt: 'I shower in the morning.', answer: 'Me ducho por la mañana.'),
    CourseItem(prompt: 'She wakes up early.', answer: 'Se despierta temprano.'),
    CourseItem(prompt: 'I go to work by bus.', answer: 'Voy al trabajo en autobús.'),
    CourseItem(prompt: 'We have lunch at two.', answer: 'Comemos a las dos.'),
    CourseItem(prompt: 'He goes to bed late.', answer: 'Se acuesta tarde.'),
    CourseItem(prompt: 'I brush my teeth.', answer: 'Me lavo los dientes.'),
  ],
);

final QuizContent enEsA12Days = enEsVocab(
  id: 'en_es_a1_2_days',
  title: 'Days & times · Los días',
  intro: 'The days of the week — lowercase in Spanish! — and the parts of '
      'the day.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E26 el lunes = on Monday',
      text: 'No preposition: el lunes trabajo = on Monday I work; los '
          'lunes = on Mondays. And days are NOT capitalised.',
    ),
  ],
  pairs: const [
    MapEntry('Monday', 'lunes'),
    MapEntry('Tuesday', 'martes'),
    MapEntry('Wednesday', 'miércoles'),
    MapEntry('Thursday', 'jueves'),
    MapEntry('Friday', 'viernes'),
    MapEntry('Saturday', 'sábado'),
    MapEntry('Sunday', 'domingo'),
    MapEntry('in the morning', 'por la mañana'),
    MapEntry('in the afternoon', 'por la tarde'),
    MapEntry('at night', 'por la noche'),
  ],
);

final QuizContent enEsA12ListenDay = enEsListen(
  id: 'en_es_a1_2_listen_day',
  title: 'Listening: Un día normal',
  passageTitle: 'El día de Lucía',
  passage:
      'Lucía trabaja en un hospital. Se levanta a las seis y desayuna un '
      'café con pan. Trabaja de siete a tres. Por la tarde estudia inglés '
      'y los martes nada en la piscina. Por la noche cena con su familia '
      'y lee un poco. Se acuesta a las once.',
  passageTranslation:
      'Lucía works in a hospital. She gets up at six and has coffee with '
      'bread for breakfast. She works from seven to three. In the '
      'afternoon she studies English, and on Tuesdays she swims in the '
      'pool. At night she has dinner with her family and reads a little. '
      'She goes to bed at eleven.',
  intro: 'Lucía\'s routine. Listen for the times and the days.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'a las + hour',
      text: 'se levanta a las seis, a las tres — "a las" flags every time '
          'of day. Use it as your anchor while listening.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿A qué hora se levanta Lucía?',
      options: ['A las cinco', 'A las seis', 'A las siete'],
      correctIndex: 1,
      questionTranslation: 'What time does Lucía get up?',
    ),
    ReadingQuestion(
      question: '¿Qué hace los martes?',
      options: ['Nada en la piscina', 'Estudia francés', 'Cena fuera'],
      correctIndex: 0,
      questionTranslation: 'What does she do on Tuesdays?',
    ),
    ReadingQuestion(
      question: '¿A qué hora se acuesta?',
      options: ['A las diez', 'A las once', 'A las doce'],
      correctIndex: 1,
      questionTranslation: 'What time does she go to bed?',
    ),
  ],
);

final QuizContent enEsA12Tener = enEsFill(
  id: 'en_es_a1_2_tener',
  title: 'tener and ir: two essential irregulars',
  intro: 'tener (tengo, tienes, tiene…) = to have — also age, hunger and '
      'hurry. ir (voy, vas, va…) = to go, and "voy a" = I\'m going to.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'tener expressions',
      text: 'tener hambre (hungry), tener sed (thirsty), tener prisa (in '
          'a hurry), tener … años (age): Spanish HAS these states.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I have two sisters.', answer: '**Tengo** dos hermanas.'),
    CourseItem(prompt: 'She has a cat.', answer: '**Tiene** un gato.'),
    CourseItem(prompt: 'I am hungry. (tener)', answer: '**Tengo** hambre.'),
    CourseItem(prompt: 'We are thirsty. (tener)', answer: '**Tenemos** sed.'),
    CourseItem(prompt: 'How old are you? (tú)', answer: '¿Cuántos años **tienes**?'),
    CourseItem(prompt: 'I go to the market.', answer: '**Voy** al mercado.'),
    CourseItem(prompt: 'She goes to school.', answer: '**Va** a la escuela.'),
    CourseItem(prompt: 'We go to the cinema on Fridays.', answer: '**Vamos** al cine los viernes.'),
    CourseItem(prompt: 'They have a small house.', answer: '**Tienen** una casa pequeña.'),
    CourseItem(prompt: 'I am in a hurry. (tener)', answer: '**Tengo** prisa.'),
    CourseItem(prompt: 'Where are you going? (tú)', answer: '¿Adónde **vas**?'),
    CourseItem(prompt: 'He is thirty years old.', answer: '**Tiene** treinta años.'),
    CourseItem(prompt: 'Do you have time? (tú)', answer: '¿**Tienes** tiempo?'),
    CourseItem(prompt: 'I go home at six.', answer: '**Voy** a casa a las seis.'),
    CourseItem(prompt: 'They go to the beach in summer.', answer: '**Van** a la playa en verano.'),
  ],
);

final QuizContent enEsA12SpeakingMid = enEsSpeaking(
  id: 'en_es_a1_2_speaking_mid',
  title: 'Conversation: my day',
  level: 'A1.2',
  topic: 'A slow, simple chat in Spanish about my daily routine: when I '
      'get up, what I eat, my work or studies, my week.',
  practisePoints: [
    'Present tense verbs in first person: me levanto, trabajo, como',
    'Times and days: a las siete, los lunes',
    'Likes with me gusta / me gustan',
  ],
  scoringCriteria: [
    'Verb endings match the person',
    'gustar agreement correct',
    'Days and times idiomatic (el lunes, a las dos)',
  ],
  priorityErrors: [
    '"yo gusto" instead of me gusta',
    'subject pronouns overused',
    'wrong verb endings',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: tell your AI assistant about your day, in Spanish. '
      'Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Short and complete',
      text: 'Me levanto a las siete. Trabajo en casa. Verb + time — that '
          'is all this level asks.',
    ),
  ],
);

final QuizContent enEsA12ReadWeek = enEsRead(
  id: 'en_es_a1_2_read_week',
  title: 'Reading: La semana de Daniel',
  passageTitle: 'La semana de Daniel',
  passage:
      'Daniel es de Toronto, pero vive en la Ciudad de México. Trabaja '
      'desde casa con su computadora. De lunes a viernes se levanta a '
      'las ocho, bebe un café grande y trabaja hasta las cinco. Le gusta '
      'mucho su trabajo. Los sábados va al mercado y compra fruta, pan y '
      'flores. Los domingos no trabaja: desayuna tarde, lee y llama a su '
      'familia en Canadá. Le encantan los domingos.',
  passageTranslation:
      'Daniel is from Toronto, but he lives in Mexico City. He works from '
      'home on his computer. From Monday to Friday he gets up at eight, '
      'drinks a big coffee and works until five. He likes his job a lot. '
      'On Saturdays he goes to the market and buys fruit, bread and '
      'flowers. On Sundays he doesn\'t work: he has a late breakfast, '
      'reads and calls his family in Canada. He loves Sundays.',
  intro: 'Daniel\'s week. Notice the third-person endings and le '
      'gusta/le encantan.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'computadora vs ordenador',
      text: 'Latin America says computadora, Spain says ordenador (⚑E28). '
          'Both are correct — recognise both.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde trabaja Daniel?',
      options: ['En una oficina', 'Desde casa', 'En un café'],
      correctIndex: 1,
      questionTranslation: 'Where does Daniel work?',
    ),
    ReadingQuestion(
      question: '¿Qué compra los sábados?',
      options: [
        'Fruta, pan y flores',
        'Café y leche',
        'Libros y periódicos',
      ],
      correctIndex: 0,
      questionTranslation: 'What does he buy on Saturdays?',
    ),
    ReadingQuestion(
      question: '¿Qué hace los domingos?',
      options: [
        'Trabaja mucho',
        'Va al mercado',
        'Lee y llama a su familia',
      ],
      correctIndex: 2,
      questionTranslation: 'What does he do on Sundays?',
    ),
  ],
);

final QuizContent enEsA12Family = enEsVocab(
  id: 'en_es_a1_2_family',
  title: 'Family · La familia',
  intro: 'The close family. Note: padres = parents, parientes = relatives '
      '— the false friend cuts both ways (⚑E25).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Masculine plural covers both',
      text: 'los padres = mum and dad, los hermanos = brothers and '
          'sisters, los hijos = children. The masculine plural is the '
          'mixed-group default.',
    ),
  ],
  pairs: const [
    MapEntry('mother', 'la madre'),
    MapEntry('father', 'el padre'),
    MapEntry('parents', 'los padres'),
    MapEntry('brother', 'el hermano'),
    MapEntry('sister', 'la hermana'),
    MapEntry('son', 'el hijo'),
    MapEntry('daughter', 'la hija'),
    MapEntry('grandfather', 'el abuelo'),
    MapEntry('grandmother', 'la abuela'),
    MapEntry('husband', 'el marido'),
    MapEntry('wife', 'la esposa'),
    MapEntry('relatives', 'los parientes'),
  ],
);

final QuizContent enEsA12Dict = enEsDict(
  id: 'en_es_a1_2_dict',
  title: 'Dictation: the routine',
  intro: 'Listen and type. Watch for verb endings and reflexive pronouns '
      '— they carry the meaning.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'The ending is the subject',
      text: 'trabajo / trabaja — one letter tells you who acts. If you '
          'miss the last vowel, you miss the person.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I get up at seven.', answer: 'Me levanto a las siete.'),
    CourseItem(prompt: 'She works in a hospital.', answer: 'Trabaja en un hospital.'),
    CourseItem(prompt: 'We have breakfast at eight.', answer: 'Desayunamos a las ocho.'),
    CourseItem(prompt: 'I like coffee with milk.', answer: 'Me gusta el café con leche.'),
    CourseItem(prompt: 'He drinks a lot of water.', answer: 'Bebe mucha agua.'),
    CourseItem(prompt: 'Do you speak Spanish?', answer: '¿Hablas español?'),
    CourseItem(prompt: 'My sister studies at night.', answer: 'Mi hermana estudia por la noche.'),
    CourseItem(prompt: 'They live in a small house.', answer: 'Viven en una casa pequeña.'),
    CourseItem(prompt: 'I am hungry.', answer: 'Tengo hambre.'),
    CourseItem(prompt: 'We go to the cinema on Fridays.', answer: 'Vamos al cine los viernes.'),
    CourseItem(prompt: 'I don\'t like Mondays.', answer: 'No me gustan los lunes.'),
    CourseItem(prompt: 'She goes to bed at eleven.', answer: 'Se acuesta a las once.'),
    CourseItem(prompt: 'Where do you live?', answer: '¿Dónde vives?'),
    CourseItem(prompt: 'The keys are on the table.', answer: 'Las llaves están en la mesa.'),
    CourseItem(prompt: 'I read the newspaper in the morning.', answer: 'Leo el periódico por la mañana.'),
  ],
);

final QuizContent enEsA12BigText = enEsBigText(
  id: 'en_es_a1_2_bigtext',
  title: 'Big text: Un martes normal',
  passageTitle: 'Un martes normal',
  intro: 'Fill the gaps: present-tense endings, estar, gustar and the '
      'reflexive pronouns.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Who does each verb?',
      text: 'Match every gap to its subject first, then pick the ending. '
          'And remember: me gusta + singular, me gustan + plural.',
    ),
  ],
  template:
      'Los martes {{0}} levanto a las siete. Desayuno café y {{1}} al '
      'trabajo en autobús. {{2}} en una oficina en el centro. Mi '
      'compañera Sofía {{3}} de Bogotá; hablamos español en la comida. '
      'Por la tarde {{4}} inglés en una academia. Me {{5}} las clases, '
      'pero los deberes no me {{6}}. Por la noche mi esposa y yo {{7}} '
      'juntos y vemos una serie. {{8}} cansados, pero contentos. Me '
      '{{9}} a las once.',
  blanks: [
    inputBlank('me'),
    inputBlank('voy'),
    inputBlank('Trabajo'),
    inputBlank('es'),
    inputBlank('estudio'),
    inputBlank('gustan'),
    inputBlank('gustan'),
    inputBlank('cenamos', accepted: ['comemos', 'cocinamos']),
    inputBlank('Estamos'),
    inputBlank('acuesto'),
  ],
  passageTranslation:
      'On Tuesdays I get up at seven. I have coffee for breakfast and go '
      'to work by bus. I work in an office in the centre. My colleague '
      'Sofía is from Bogotá; we speak Spanish at lunch. In the afternoon '
      'I study English at an academy. I like the classes, but I don\'t '
      'like the homework. At night my wife and I have dinner together '
      'and watch a series. We are tired but happy. I go to bed at '
      'eleven.',
);

final QuizContent enEsA12SpeakingClose = enEsSpeaking(
  id: 'en_es_a1_2_speaking_close',
  title: 'Final conversation: my week',
  level: 'A1.2',
  topic: 'An interview in Spanish about my typical week: routine from '
      'Monday to Sunday, work or studies, family routines, and what I '
      'like and don\'t like.',
  practisePoints: [
    'Present tense across -ar/-er/-ir verbs',
    'Reflexive routine: me levanto, me acuesto',
    'gustar with singular and plural',
    'ser vs estar in simple sentences',
  ],
  scoringCriteria: [
    'Endings consistently correct',
    'gustar never turned into "yo gusto"',
    'estar for places and states, ser for identity',
  ],
  targetVocabulary: [
    'me levanto', 'trabajo', 'me gusta', 'los lunes', 'por la tarde',
  ],
  priorityErrors: [
    'missing reflexive pronouns',
    'gustar agreement',
    'ser/estar swapped',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module A1.2 closer: an interview about your week, in Spanish. '
      'Copy, speak, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Recycle the module',
      text: 'Me levanto a las siete. Los martes estudio español. The quiz '
          'sentences are exactly the ones you need here.',
    ),
  ],
);

/// A1.2 in chain order.
final List<QuizContent> enEsA1_2 = [
  enEsA12ArVerbs,
  enEsA12ErIrVerbs,
  enEsA12Estar,
  enEsA12Gustar,
  enEsA12SpeakRoutine,
  enEsA12Days,
  enEsA12ListenDay,
  enEsA12Tener,
  enEsA12SpeakingMid,
  enEsA12ReadWeek,
  enEsA12Family,
  enEsA12Dict,
  enEsA12BigText,
  enEsA12SpeakingClose,
];
