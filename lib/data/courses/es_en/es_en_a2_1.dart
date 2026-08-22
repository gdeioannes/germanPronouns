import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// A2.1 — El pasado. Spanish → English.
///
/// Big rocks: the past simple — regular -ed with its three sounds (⚑S7),
/// the key irregulars, did-support for questions/negation (⚑S14), there
/// was/were, and ago (⚑S20). One English past covers pretérito e imperfecto.

final QuizContent esEnA21RegularPast = esEnFill(
  id: 'es_en_a2_1_regular_past',
  title: 'El pasado regular: -ed',
  intro: 'El pasado regular añade -ed para TODAS las personas: I worked, she '
      'worked, they worked. Un solo pasado para "trabajé" y "trabajaba".',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Un pasado para dos españoles',
      text: 'worked = trabajé Y trabajaba. El inglés no distingue pretérito e '
          'imperfecto con la forma del verbo: lo hace con el contexto.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Ortografía',
      text: 'live→lived (ya hay e), study→studied (y→ied), stop→stopped '
          '(consonante doblada).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Trabajé ayer.', answer: 'I **worked** yesterday.'),
    CourseItem(prompt: 'Ella vivió en París.', answer: 'She **lived** in Paris.'),
    CourseItem(prompt: 'Jugamos al fútbol el sábado.', answer: 'We **played** football on Saturday.'),
    CourseItem(prompt: 'Él estudió medicina.', answer: 'He **studied** medicine.'),
    CourseItem(prompt: 'Ellos visitaron a sus abuelos.', answer: 'They **visited** their grandparents.'),
    CourseItem(prompt: 'Cociné pasta anoche.', answer: 'I **cooked** pasta last night.'),
    CourseItem(prompt: 'La película terminó a las diez.', answer: 'The film **finished** at ten.'),
    CourseItem(prompt: 'Ella abrió la ventana.', answer: 'She **opened** the window.'),
    CourseItem(prompt: 'Hablamos con el profesor.', answer: 'We **talked** to the teacher.'),
    CourseItem(prompt: 'Él paró el coche.', answer: 'He **stopped** the car.'),
    CourseItem(prompt: 'Escuché música toda la tarde.', answer: 'I **listened** to music all afternoon.'),
    CourseItem(prompt: 'Ellos caminaron al centro.', answer: 'They **walked** to the centre.'),
    CourseItem(prompt: 'Ella cerró la puerta.', answer: 'She **closed** the door.'),
    CourseItem(prompt: 'El tren llegó tarde.', answer: 'The train **arrived** late.'),
    CourseItem(prompt: 'Ayudé a mi madre.', answer: 'I **helped** my mother.'),
  ],
);

final QuizContent esEnA21SpeakEd = esEnSpeak(
  id: 'es_en_a2_1_speak_ed',
  title: 'Sonidos: los tres -ed',
  intro: 'La terminación -ed tiene TRES pronunciaciones: /t/, /d/ y /ɪd/. '
      'Nunca es "workED" con e española.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚑S7 La regla del oído',
      text: 'Tras sonido sordo → /t/ (worked). Tras sonoro → /d/ (lived). '
          'Solo tras t/d → /ɪd/ (wanted, needed).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'No añadas sílaba',
      text: 'worked es UNA sílaba más /t/: "workt". Decir "wor-ked" delata al '
          'instante.',
    ),
  ],
  items: const [
    CourseItem(prompt: '-ed como /t/', answer: 'worked, stopped, watched, cooked'),
    CourseItem(prompt: '-ed como /d/', answer: 'lived, played, opened, listened'),
    CourseItem(prompt: '-ed como /ɪd/', answer: 'wanted, needed, visited, started'),
    CourseItem(prompt: 'Frase con /t/', answer: 'I worked and cooked yesterday.'),
    CourseItem(prompt: 'Frase con /d/', answer: 'She played and listened to music.'),
    CourseItem(prompt: 'Frase con /ɪd/', answer: 'They wanted and needed help.'),
    CourseItem(prompt: 'Todo junto', answer: 'We watched a film, played cards and visited Emma.'),
  ],
);

final QuizContent esEnA21Irregulars = esEnFill(
  id: 'es_en_a2_1_irregulars',
  title: 'Irregulares imprescindibles I',
  intro: 'Los verbos más usados son irregulares: go→went, have→had, see→saw. '
      'No hay truco: se aprenden usándolos.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'El top 10',
      text: 'go→went · have→had · see→saw · do→did · make→made · get→got · '
          'come→came · take→took · eat→ate · buy→bought.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Fui al cine ayer.', answer: 'I **went** to the cinema yesterday.'),
    CourseItem(prompt: 'Ella tuvo una idea.', answer: 'She **had** an idea.'),
    CourseItem(prompt: 'Vimos a Emma en el parque.', answer: 'We **saw** Emma in the park.'),
    CourseItem(prompt: 'Él hizo la cena. (make)', answer: 'He **made** dinner.'),
    CourseItem(prompt: 'Compré pan esta mañana.', answer: 'I **bought** bread this morning.'),
    CourseItem(prompt: 'Ellos vinieron tarde.', answer: 'They **came** late.'),
    CourseItem(prompt: 'Ella se llevó mi paraguas. (take)', answer: 'She **took** my umbrella.'),
    CourseItem(prompt: 'Comimos pizza anoche.', answer: 'We **ate** pizza last night.'),
    CourseItem(prompt: 'Él consiguió el trabajo. (get)', answer: 'He **got** the job.'),
    CourseItem(prompt: 'Hice mis deberes. (do)', answer: 'I **did** my homework.'),
    CourseItem(prompt: 'Ella escribió una carta.', answer: 'She **wrote** a letter.'),
    CourseItem(prompt: 'Leí ese libro el año pasado.', answer: 'I **read** that book last year.'),
    CourseItem(prompt: 'Él dijo la verdad. (tell)', answer: 'He **told** the truth.'),
    CourseItem(prompt: 'Encontramos las llaves. (find)', answer: 'We **found** the keys.'),
    CourseItem(prompt: 'Ella durmió diez horas.', answer: 'She **slept** ten hours.'),
  ],
);

final QuizContent esEnA21TimeWords = esEnVocab(
  id: 'es_en_a2_1_time_words',
  title: 'Palabras de pasado',
  intro: 'Las expresiones que sitúan tu historia en el tiempo.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S20 ago va DETRÁS',
      text: '"hace dos años" = two years **ago** — el ago se pospone: '
          'nunca "ago two years".',
    ),
  ],
  pairs: const [
    MapEntry('ayer', 'yesterday'),
    MapEntry('anoche', 'last night'),
    MapEntry('la semana pasada', 'last week'),
    MapEntry('el año pasado', 'last year'),
    MapEntry('hace dos días', 'two days ago'),
    MapEntry('hace mucho tiempo', 'a long time ago'),
    MapEntry('entonces / en aquella época', 'then'),
    MapEntry('de repente', 'suddenly'),
    MapEntry('después', 'afterwards'),
    MapEntry('al final', 'in the end'),
  ],
);

final QuizContent esEnA21DidQuestions = esEnFill(
  id: 'es_en_a2_1_did_questions',
  title: 'Preguntas y negación con did',
  intro: 'En pasado el ayudante es did para todos: Did you go? · I didn\'t '
      'go. Y el verbo vuelve a su forma base.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S14 did se lleva el pasado',
      text: 'Did you went? ✗ → Did you go? ✓ · I didn\'t saw ✗ → I didn\'t '
          'see ✓. El pasado ya está en did.',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Fuiste al cine?', answer: '**Did** you go to the cinema?'),
    CourseItem(prompt: 'No vi la película.', answer: 'I **didn\'t** see the film.'),
    CourseItem(prompt: '¿Trabajó ella ayer?', answer: '**Did** she work yesterday?'),
    CourseItem(prompt: 'No compramos nada.', answer: 'We **didn\'t** buy anything.'),
    CourseItem(prompt: '¿Comieron ellos en casa?', answer: '**Did** they eat at home?'),
    CourseItem(prompt: 'Él no vino a la fiesta.', answer: 'He **didn\'t** come to the party.'),
    CourseItem(prompt: '¿Dormiste bien?', answer: '**Did** you sleep well?'),
    CourseItem(prompt: 'Ella no dijo nada. (say)', answer: 'She **didn\'t** say anything.'),
    CourseItem(prompt: '¿Viste a Tom?', answer: '**Did** you see Tom?'),
    CourseItem(prompt: 'No hice los deberes.', answer: 'I **didn\'t** do my homework.'),
    CourseItem(prompt: '¿Llegó tarde el tren?', answer: '**Did** the train arrive late?'),
    CourseItem(prompt: 'No entendí la pregunta.', answer: 'I **didn\'t** understand the question.'),
    CourseItem(prompt: '¿Llamaste a tu madre?', answer: '**Did** you call your mother?'),
    CourseItem(prompt: 'Ellos no encontraron la casa.', answer: 'They **didn\'t** find the house.'),
    CourseItem(prompt: '¿Te gustó la comida?', answer: '**Did** you like the food?'),
  ],
);

final QuizContent esEnA21ListenTrip = esEnListen(
  id: 'es_en_a2_1_listen_trip',
  title: 'Escucha: The trip to Edinburgh',
  passageTitle: 'A weekend in Edinburgh',
  passage:
      "Last weekend Emma and I went to Edinburgh by train. We arrived on "
      "Friday evening and walked to a small hotel near the castle. On "
      "Saturday we visited the castle and took a lot of photos. It rained in "
      "the afternoon, so we went to a museum. We ate fish and chips for "
      "dinner. On Sunday we came home, tired but happy.",
  passageTranslation:
      'El fin de semana pasado Emma y yo fuimos a Edimburgo en tren. '
      'Llegamos el viernes por la tarde y caminamos hasta un hotel pequeño '
      'cerca del castillo. El sábado visitamos el castillo e hicimos muchas '
      'fotos. Por la tarde llovió, así que fuimos a un museo. Cenamos fish '
      'and chips. El domingo volvimos a casa, cansados pero contentos.',
  intro: 'Un viaje de fin de semana, contado en pasado. Escucha qué hicieron '
      'cada día.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Caza los irregulares',
      text: 'went, took, ate, came: los pasados irregulares del quiz anterior '
          'aparecen aquí en acción.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How did they travel to Edinburgh?',
      options: ['By car', 'By train', 'By plane'],
      correctIndex: 1,
      questionTranslation: '¿Cómo viajaron a Edimburgo?',
    ),
    ReadingQuestion(
      question: 'Why did they go to a museum?',
      options: ['It rained', 'It was free', 'Emma loves art'],
      correctIndex: 0,
      questionTranslation: '¿Por qué fueron a un museo?',
    ),
    ReadingQuestion(
      question: 'When did they come home?',
      options: ['On Saturday', 'On Sunday', 'On Friday'],
      correctIndex: 1,
      questionTranslation: '¿Cuándo volvieron a casa?',
    ),
  ],
);

final QuizContent esEnA21WasWere = esEnFill(
  id: 'es_en_a2_1_was_were',
  title: 'was / were y there was / there were',
  intro: 'El pasado de be: I/he/she/it was · you/we/they were. Y "había": '
      'there was (singular), there were (plural).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'había = there was/were',
      text: 'There was a problem (uno) · There were many people (varios). El '
          'inglés concuerda con lo que hay.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Yo estaba cansado.', answer: 'I **was** tired.'),
    CourseItem(prompt: 'Ellos estaban en casa.', answer: 'They **were** at home.'),
    CourseItem(prompt: 'La película fue genial.', answer: 'The film **was** great.'),
    CourseItem(prompt: 'Había un problema.', answer: 'There **was** a problem.'),
    CourseItem(prompt: 'Había muchas personas.', answer: 'There **were** many people.'),
    CourseItem(prompt: '¿Dónde estabas?', answer: 'Where **were** you?'),
    CourseItem(prompt: 'El hotel era pequeño.', answer: 'The hotel **was** small.'),
    CourseItem(prompt: 'No estábamos allí.', answer: 'We **weren\'t** there.'),
    CourseItem(prompt: 'Ella no estaba contenta.', answer: 'She **wasn\'t** happy.'),
    CourseItem(prompt: 'Había dos camas en la habitación.', answer: 'There **were** two beds in the room.'),
    CourseItem(prompt: '¿Fue difícil el examen?', answer: '**Was** the exam difficult?'),
    CourseItem(prompt: 'Mis padres eran profesores.', answer: 'My parents **were** teachers.'),
    CourseItem(prompt: 'No había leche.', answer: 'There **wasn\'t** any milk.'),
    CourseItem(prompt: 'El tiempo era horrible.', answer: 'The weather **was** horrible.'),
    CourseItem(prompt: '¿Había mucha gente?', answer: '**Were** there many people?'),
  ],
);

final QuizContent esEnA21Food = esEnVocab(
  id: 'es_en_a2_1_food',
  title: 'Comida · Food',
  intro: 'Vocabulario básico de comida para contar qué comiste.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'fish, dos sentidos',
      text: 'fish = pez y pescado; meat = carne (de comer). Y chips en Reino '
          'Unido son patatas fritas; en EE. UU. se dice fries (⚑S29).',
    ),
  ],
  pairs: const [
    MapEntry('pan', 'bread'),
    MapEntry('leche', 'milk'),
    MapEntry('huevo', 'egg'),
    MapEntry('queso', 'cheese'),
    MapEntry('carne', 'meat'),
    MapEntry('pescado (comida)', 'fish'),
    MapEntry('pollo', 'chicken'),
    MapEntry('arroz', 'rice'),
    MapEntry('verduras', 'vegetables'),
    MapEntry('manzana', 'apple'),
    MapEntry('agua', 'water'),
    MapEntry('zumo / jugo', 'juice'),
  ],
);

final QuizContent esEnA21SpeakingMid = esEnSpeaking(
  id: 'es_en_a2_1_speaking_mid',
  title: 'Conversación: ayer',
  level: 'A2.1',
  topic: 'A simple chat about what I did yesterday and last weekend: where I '
      'went, what I ate, who I saw.',
  practisePoints: [
    'Past simple of regular verbs with a clear -ed',
    'Key irregulars: went, had, saw, ate, came',
    'Time expressions: yesterday, last week, two days ago',
  ],
  scoringCriteria: [
    'Correct past forms, regular and irregular',
    'did used correctly in questions and negatives',
    'Time expressions placed correctly (ago after the period)',
  ],
  priorityErrors: [
    'present used instead of past',
    '"Did you went" — double past marking',
    'the -ed pronounced as an extra Spanish syllable',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: cuéntale tu día de ayer a tu asistente de IA y '
      'trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Prepara tres frases ancla',
      text: 'Yesterday I went to… I had lunch with… In the evening I '
          'watched… Con tres anclas la conversación fluye.',
    ),
  ],
);

final QuizContent esEnA21ReadBio = esEnRead(
  id: 'es_en_a2_1_read_bio',
  title: 'Lectura: Grandma\'s story',
  passageTitle: "Grandma's story",
  passage:
      "My grandmother was born in a small village in 1950. Her family didn't "
      "have much money, but they were happy. She went to school in the "
      "mornings and helped on the farm in the afternoons. When she was "
      "twenty, she moved to the city and found a job in a shoe factory. "
      "There she met my grandfather. They got married in 1975 and had three "
      "children. She always says those years were the best of her life.",
  passageTranslation:
      'Mi abuela nació en un pueblo pequeño en 1950. Su familia no tenía '
      'mucho dinero, pero eran felices. Iba a la escuela por las mañanas y '
      'ayudaba en la granja por las tardes. A los veinte años se mudó a la '
      'ciudad y encontró trabajo en una fábrica de zapatos. Allí conoció a '
      'mi abuelo. Se casaron en 1975 y tuvieron tres hijos. Siempre dice que '
      'aquellos años fueron los mejores de su vida.',
  intro: 'Una biografía corta. Observa cómo un solo pasado inglés cuenta lo '
      'que el español reparte entre "iba/ayudaba" y "se mudó/encontró".',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'was born = nació',
      text: 'En inglés "nacer" es pasivo: She **was born** in 1950 — '
          'literalmente "fue nacida". Fíjate y úsalo tal cual.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where was the grandmother born?',
      options: ['In the city', 'In a small village', 'In a factory'],
      correctIndex: 1,
      questionTranslation: '¿Dónde nació la abuela?',
    ),
    ReadingQuestion(
      question: 'What did she do when she was twenty?',
      options: [
        'She moved to the city',
        'She got married',
        'She bought a farm',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué hizo a los veinte años?',
    ),
    ReadingQuestion(
      question: 'How many children did they have?',
      options: ['Two', 'Three', 'Four'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos hijos tuvieron?',
    ),
  ],
);

final QuizContent esEnA21Ago = esEnFill(
  id: 'es_en_a2_1_ago',
  title: 'ago, last y when',
  intro: '"hace + tiempo" = tiempo + ago. "pasado/a" = last. Y when une dos '
      'momentos: When I was ten…',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S20 Sin hace, sin have',
      text: '"Hace dos años" NO usa el verbo hacer: two years ago. Tampoco '
          '"it makes two years" — ese calco no existe.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Llegué hace dos horas.', answer: 'I arrived two hours **ago**.'),
    CourseItem(prompt: 'Se mudaron hace un año.', answer: 'They moved a year **ago**.'),
    CourseItem(prompt: 'La vi la semana pasada.', answer: 'I saw her **last** week.'),
    CourseItem(prompt: 'Fuimos a México el verano pasado.', answer: 'We went to Mexico **last** summer.'),
    CourseItem(prompt: 'Cuando tenía diez años, vivía aquí.', answer: '**When** I was ten, I lived here.'),
    CourseItem(prompt: 'Él llamó hace cinco minutos.', answer: 'He called five minutes **ago**.'),
    CourseItem(prompt: 'Anoche llovió. (last)', answer: 'It rained **last** night.'),
    CourseItem(prompt: 'Empecé este trabajo hace tres meses.', answer: 'I started this job three months **ago**.'),
    CourseItem(prompt: 'Cuando era joven, jugaba al tenis.', answer: '**When** I was young, I played tennis.'),
    CourseItem(prompt: 'Compraron la casa hace mucho tiempo.', answer: 'They bought the house a long time **ago**.'),
    CourseItem(prompt: 'El mes pasado estuve enfermo.', answer: 'I was ill **last** month.'),
    CourseItem(prompt: 'Cuando llegué, no había nadie.', answer: '**When** I arrived, there was nobody.'),
    CourseItem(prompt: 'Nos conocimos hace diez años.', answer: 'We met ten years **ago**.'),
    CourseItem(prompt: 'El domingo pasado cociné paella.', answer: '**Last** Sunday I cooked paella.'),
    CourseItem(prompt: 'Cuando era niña, tenía un gato.', answer: '**When** I was a child, I had a cat.'),
  ],
);

final QuizContent esEnA21SpeakStory = esEnSpeak(
  id: 'es_en_a2_1_speak_story',
  title: 'A hablar: contar una historia',
  intro: 'Frases de narración en pasado. Repite marcando los pasados '
      'irregulares.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S1 Vocal de was y saw',
      text: 'was suena /wɒz/ y saw /sɔː/ — vocal larga y oscura, no "sao".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'El sábado pasado fui a la playa.', answer: 'Last Saturday I went to the beach.'),
    CourseItem(prompt: 'Hacía un tiempo estupendo.', answer: 'The weather was wonderful.'),
    CourseItem(prompt: 'Vi a mis amigos allí.', answer: 'I saw my friends there.'),
    CourseItem(prompt: 'Comimos helado.', answer: 'We ate ice cream.'),
    CourseItem(prompt: 'Después dimos un paseo.', answer: 'Afterwards we took a walk.'),
    CourseItem(prompt: 'De repente empezó a llover.', answer: 'Suddenly it started to rain.'),
    CourseItem(prompt: 'Corrimos al coche.', answer: 'We ran to the car.'),
    CourseItem(prompt: 'Fue un día genial.', answer: 'It was a great day.'),
  ],
);

final QuizContent esEnA21Dict = esEnDict(
  id: 'es_en_a2_1_dict',
  title: 'Dictado: en pasado',
  intro: 'Escucha y escribe. La clave está en oír la diferencia entre '
      'presente y pasado: work / worked, is / was.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S7 El -ed final es corto',
      text: 'walked suena "walkt" — una consonante pegada al final. Si no la '
          'oyes, la frase te sonará a presente.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ayer trabajé mucho.', answer: 'Yesterday I worked a lot.'),
    CourseItem(prompt: 'Ella fue al mercado.', answer: 'She went to the market.'),
    CourseItem(prompt: 'Vimos una película anoche.', answer: 'We watched a film last night.'),
    CourseItem(prompt: 'Él compró un coche nuevo.', answer: 'He bought a new car.'),
    CourseItem(prompt: 'No encontré mis llaves.', answer: 'I did not find my keys.'),
    CourseItem(prompt: '¿Dormiste bien?', answer: 'Did you sleep well?'),
    CourseItem(prompt: 'Había mucha gente en la calle.', answer: 'There were many people in the street.'),
    CourseItem(prompt: 'La fiesta fue fantástica.', answer: 'The party was fantastic.'),
    CourseItem(prompt: 'Llegamos hace una hora.', answer: 'We arrived an hour ago.'),
    CourseItem(prompt: 'Ella escribió tres cartas.', answer: 'She wrote three letters.'),
    CourseItem(prompt: 'Los niños jugaron en el parque.', answer: 'The children played in the park.'),
    CourseItem(prompt: 'No dije nada.', answer: 'I did not say anything.'),
    CourseItem(prompt: 'Él vino a casa tarde.', answer: 'He came home late.'),
    CourseItem(prompt: 'Cuando era niño, vivía en Chile.', answer: 'When I was a child, I lived in Chile.'),
    CourseItem(prompt: 'Hicieron muchas fotos.', answer: 'They took a lot of photos.'),
  ],
);

final QuizContent esEnA21BigText = esEnBigText(
  id: 'es_en_a2_1_bigtext',
  title: 'Texto: A strange Monday',
  passageTitle: 'A strange Monday',
  intro: 'Completa la historia con los pasados que faltan: regulares, '
      'irregulares, was/were y did.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Primero lee, luego rellena',
      text: 'Lee la historia entera una vez. Después decide verbo a verbo: '
          '¿regular (-ed), irregular, o was/were?',
    ),
  ],
  template:
      'Last Monday {{0}} a strange day. I {{1}} up late because my alarm '
      '{{2}} not work. I {{3}} breakfast in two minutes and ran to the bus '
      'stop, but the bus {{4}} early — I {{5}} it. So I walked to work and '
      '{{6}} at ten. My boss {{7}} not angry; the office was empty! Then I '
      'remembered: it was a holiday. I {{8}} home, {{9}} a big coffee and '
      'watched films all day.',
  blanks: [
    inputBlank('was'),
    inputBlank('got'),
    inputBlank('did'),
    inputBlank('had', accepted: ['ate']),
    inputBlank('left', accepted: ['came', 'was']),
    inputBlank('missed'),
    inputBlank('arrived'),
    inputBlank('was'),
    inputBlank('went', accepted: ['walked', 'came']),
    inputBlank('made', accepted: ['had']),
  ],
  passageTranslation:
      'El lunes pasado fue un día extraño. Me levanté tarde porque el '
      'despertador no funcionó. Desayuné en dos minutos y corrí a la parada, '
      'pero el autobús salió antes: lo perdí. Así que fui andando al trabajo '
      'y llegué a las diez. Mi jefe no estaba enfadado; ¡la oficina estaba '
      'vacía! Entonces lo recordé: era festivo. Volví a casa, me hice un '
      'café grande y vi películas todo el día.',
);

final QuizContent esEnA21SpeakingClose = esEnSpeaking(
  id: 'es_en_a2_1_speaking_close',
  title: 'Conversación final: mi historia',
  level: 'A2.1',
  topic: 'Tell me about your past: your childhood, your school, a trip you '
      'loved, and what you did last weekend. I will ask follow-up questions.',
  practisePoints: [
    'Past simple, regular and irregular, in connected sentences',
    'was/were and there was/were for descriptions',
    'Time expressions: when I was…, ago, last…',
    'Questions with did answered naturally',
  ],
  scoringCriteria: [
    'Past forms accuracy',
    'Story order with then, afterwards, in the end',
    'Understandable -ed pronunciation',
  ],
  targetVocabulary: [
    'went', 'was born', 'moved', 'met', 'ago', 'suddenly',
  ],
  priorityErrors: [
    'present instead of past',
    'double past after did/didn\'t',
    'missing subject pronouns',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo A2.1: una entrevista sobre tu pasado en tu '
      'asistente de IA. Copia, habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Una historia, tres tiempos',
      text: 'Sitúa (When I was…), narra (I went, I saw) y cierra (In the '
          'end…). Esa estructura vale para cualquier anécdota.',
    ),
  ],
);

/// A2.1 in chain order.
final List<QuizContent> esEnA2_1 = [
  esEnA21RegularPast,
  esEnA21SpeakEd,
  esEnA21Irregulars,
  esEnA21TimeWords,
  esEnA21DidQuestions,
  esEnA21ListenTrip,
  esEnA21WasWere,
  esEnA21Food,
  esEnA21SpeakingMid,
  esEnA21ReadBio,
  esEnA21Ago,
  esEnA21SpeakStory,
  esEnA21Dict,
  esEnA21BigText,
  esEnA21SpeakingClose,
];
