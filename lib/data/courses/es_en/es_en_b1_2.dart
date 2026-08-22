import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// B1.2 — Historias y condiciones. Spanish → English.
///
/// Big rocks: past continuous (was doing) for scene-setting, used to for old
/// habits, conditionals 0/1/2 (⚑S23), relative clauses with who/which/that,
/// and the connectors that hold a story together.

final QuizContent esEnB12PastCont = esEnFill(
  id: 'es_en_b1_2_past_cont',
  title: 'El pasado continuo: was/were + -ing',
  intro: 'La escena de fondo de una historia: I was walking home when… = '
      'iba andando a casa cuando… Es tu imperfecto de ambientación.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Fondo y flash',
      text: 'Fondo largo → was/were + -ing. Acción que irrumpe → past '
          'simple: I was cooking when the phone rang.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Estaba lloviendo cuando salí.', answer: 'It was **raining** when I left.'),
    CourseItem(prompt: 'Yo estaba cocinando cuando sonó el teléfono.', answer: 'I was **cooking** when the phone rang.'),
    CourseItem(prompt: 'Ellos estaban viendo la tele a las diez.', answer: 'They were **watching** TV at ten.'),
    CourseItem(prompt: '¿Qué estabas haciendo anoche?', answer: 'What were you **doing** last night?'),
    CourseItem(prompt: 'Ella estaba durmiendo cuando llegué.', answer: 'She was **sleeping** when I arrived.'),
    CourseItem(prompt: 'Íbamos conduciendo al trabajo.', answer: 'We were **driving** to work.'),
    CourseItem(prompt: 'El sol brillaba aquella mañana. (shine)', answer: 'The sun was **shining** that morning.'),
    CourseItem(prompt: 'Yo no estaba escuchando.', answer: 'I wasn\'t **listening**.'),
    CourseItem(prompt: 'Los niños estaban jugando en el jardín.', answer: 'The children were **playing** in the garden.'),
    CourseItem(prompt: 'Él estaba leyendo mientras yo cocinaba.', answer: 'He was **reading** while I was cooking.'),
    CourseItem(prompt: '¿Estaba ella trabajando ayer a las nueve?', answer: 'Was she **working** at nine yesterday?'),
    CourseItem(prompt: 'Todos estaban esperando el tren.', answer: 'Everybody was **waiting** for the train.'),
    CourseItem(prompt: 'Estaba pensando en ti.', answer: 'I was **thinking** about you.'),
    CourseItem(prompt: 'Estábamos cenando cuando llamaron.', answer: 'We were **having** dinner when they called.'),
    CourseItem(prompt: 'Nevaba cuando despertamos.', answer: 'It was **snowing** when we woke up.'),
  ],
);

final QuizContent esEnB12UsedTo = esEnFill(
  id: 'es_en_b1_2_used_to',
  title: 'used to: antes yo…',
  intro: 'Hábitos y estados del pasado que ya no existen: I used to smoke = '
      'antes fumaba. Negación: didn\'t use to.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'No confundir con be used to',
      text: 'used to + verbo = solía. be used to + -ing = estar '
          'acostumbrado. Aquí trabajamos el primero.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Antes fumaba, ya no.', answer: 'I **used** to smoke.'),
    CourseItem(prompt: 'De niño vivía en el campo.', answer: 'I **used** to live in the countryside.'),
    CourseItem(prompt: 'Ella antes tenía el pelo largo.', answer: 'She **used** to have long hair.'),
    CourseItem(prompt: 'Antes no me gustaba el café.', answer: 'I didn\'t **use** to like coffee.'),
    CourseItem(prompt: '¿Antes jugabas al fútbol?', answer: 'Did you **use** to play football?'),
    CourseItem(prompt: 'Aquí antes había un cine.', answer: 'There **used** to be a cinema here.'),
    CourseItem(prompt: 'Antes trabajábamos juntos.', answer: 'We **used** to work together.'),
    CourseItem(prompt: 'Él solía levantarse temprano.', answer: 'He **used** to get up early.'),
    CourseItem(prompt: 'Antes veíamos esa serie cada semana.', answer: 'We **used** to watch that series every week.'),
    CourseItem(prompt: 'Ella antes no comía pescado.', answer: 'She didn\'t **use** to eat fish.'),
    CourseItem(prompt: 'Antes íbamos a la playa cada verano.', answer: 'We **used** to go to the beach every summer.'),
    CourseItem(prompt: 'Mi abuelo solía contar historias.', answer: 'My grandfather **used** to tell stories.'),
    CourseItem(prompt: '¿Antes vivías aquí?', answer: 'Did you **use** to live here?'),
    CourseItem(prompt: 'Antes esta calle era tranquila.', answer: 'This street **used** to be quiet.'),
    CourseItem(prompt: 'Yo solía leer hasta tarde.', answer: 'I **used** to read late at night.'),
  ],
);

final QuizContent esEnB12SpeakStory = esEnSpeak(
  id: 'es_en_b1_2_speak_story',
  title: 'A hablar: ambientar la historia',
  intro: 'Frases que abren una anécdota. Repite con la entonación de quien '
      'está a punto de contar algo bueno.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La fórmula de oro',
      text: 'It was + tiempo/lugar, I was + -ing, when + pasado simple. Con '
          'esa plantilla abres cualquier historia.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Era una noche fría de enero.', answer: 'It was a cold January night.'),
    CourseItem(prompt: 'Yo volvía a casa del trabajo.', answer: 'I was coming home from work.'),
    CourseItem(prompt: 'De repente oí un ruido.', answer: 'Suddenly I heard a noise.'),
    CourseItem(prompt: 'No vas a creer lo que pasó.', answer: "You won't believe what happened."),
    CourseItem(prompt: 'Mientras esperaba, empezó a llover.', answer: 'While I was waiting, it started to rain.'),
    CourseItem(prompt: 'Al final todo salió bien.', answer: 'In the end everything went well.'),
    CourseItem(prompt: '¿Y sabes qué?', answer: 'And you know what?'),
    CourseItem(prompt: 'Fue el susto de mi vida.', answer: 'It was the fright of my life.'),
  ],
);

final QuizContent esEnB12FirstCond = esEnFill(
  id: 'es_en_b1_2_first_cond',
  title: 'Condicional 1: If it rains…',
  intro: 'Futuro posible: If + presente, will + verbo. If it rains, we will '
      'stay home. El if NUNCA lleva will.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S23 Presente tras if',
      text: 'If it will rain ✗ → If it rains ✓. La mitad del if va en '
          'presente aunque hable del futuro.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Si llueve, nos quedaremos en casa.', answer: 'If it **rains**, we will stay home.'),
    CourseItem(prompt: 'Si estudias, aprobarás.', answer: 'If you study, you **will** pass.'),
    CourseItem(prompt: 'Si llego tarde, llámame.', answer: 'If I **am** late, call me.'),
    CourseItem(prompt: 'Iremos a la playa si hace sol.', answer: 'We will go to the beach if it **is** sunny.'),
    CourseItem(prompt: 'Si él no viene, empezaremos sin él.', answer: 'If he doesn\'t come, we **will** start without him.'),
    CourseItem(prompt: 'Si comes eso, te sentirás mal.', answer: 'If you **eat** that, you will feel ill.'),
    CourseItem(prompt: '¿Qué harás si pierdes el tren?', answer: 'What **will** you do if you miss the train?'),
    CourseItem(prompt: 'Si tengo tiempo, te ayudaré.', answer: 'If I **have** time, I will help you.'),
    CourseItem(prompt: 'Si ella pregunta, dile la verdad.', answer: 'If she **asks**, tell her the truth.'),
    CourseItem(prompt: 'No saldremos si nieva.', answer: 'We won\'t go out if it **snows**.'),
    CourseItem(prompt: 'Si trabajas duro, conseguirás el puesto.', answer: 'If you work hard, you **will** get the job.'),
    CourseItem(prompt: 'Si el agua hierve, se convierte en vapor. (cond. 0)', answer: 'If water **boils**, it turns into steam.'),
    CourseItem(prompt: 'Si mezclas azul y amarillo, obtienes verde.', answer: 'If you **mix** blue and yellow, you get green.'),
    CourseItem(prompt: 'Te llamaré si necesito algo.', answer: 'I will call you if I **need** anything.'),
    CourseItem(prompt: 'Si no te das prisa, llegaremos tarde.', answer: 'If you don\'t hurry, we **will** be late.'),
  ],
);

final QuizContent esEnB12SecondCond = esEnFill(
  id: 'es_en_b1_2_second_cond',
  title: 'Condicional 2: If I had a million…',
  intro: 'Situaciones imaginarias: If + pasado, would + verbo. If I had a '
      'million, I would travel = si tuviera… viajaría.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚑S23 tuviera → had, viajaría → would',
      text: 'El subjuntivo español (tuviera) se vuelve simple pasado inglés '
          '(had); el condicional (viajaría) se vuelve would travel.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'If I were you',
      text: 'Con be imaginario se prefiere were para todos: If I **were** '
          'you, I would accept. Es la forma culta y la más segura.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Si tuviera dinero, viajaría.', answer: 'If I **had** money, I would travel.'),
    CourseItem(prompt: 'Si fuera tú, aceptaría.', answer: 'If I **were** you, I would accept.'),
    CourseItem(prompt: 'Si viviera en la costa, nadaría cada día.', answer: 'If I lived on the coast, I **would** swim every day.'),
    CourseItem(prompt: '¿Qué harías si ganaras la lotería?', answer: 'What **would** you do if you won the lottery?'),
    CourseItem(prompt: 'Si él estudiara más, aprobaría.', answer: 'If he **studied** more, he would pass.'),
    CourseItem(prompt: 'Compraría esa casa si fuera más barata.', answer: 'I would buy that house if it **were** cheaper.'),
    CourseItem(prompt: 'Si no lloviera, saldríamos.', answer: 'If it didn\'t rain, we **would** go out.'),
    CourseItem(prompt: 'Si ella supiera la verdad, se enfadaría.', answer: 'If she **knew** the truth, she would get angry.'),
    CourseItem(prompt: 'Viviríamos mejor si trabajáramos menos.', answer: 'We **would** live better if we worked less.'),
    CourseItem(prompt: 'Si pudiera, te ayudaría.', answer: 'If I **could**, I would help you.'),
    CourseItem(prompt: 'Si tuviéramos coche, iríamos a la montaña.', answer: 'If we **had** a car, we would go to the mountains.'),
    CourseItem(prompt: 'Él sería más feliz si viviera cerca del mar.', answer: 'He would be happier if he **lived** near the sea.'),
    CourseItem(prompt: 'Si yo hablara chino, trabajaría en Shanghái.', answer: 'If I **spoke** Chinese, I would work in Shanghai.'),
    CourseItem(prompt: '¿Adónde irías si pudieras elegir?', answer: 'Where would you go if you **could** choose?'),
    CourseItem(prompt: 'Si no fuera tan tarde, me quedaría.', answer: 'If it **weren\'t** so late, I would stay.'),
  ],
);

final QuizContent esEnB12ListenAccident = esEnListen(
  id: 'es_en_b1_2_listen_accident',
  title: 'Escucha: What happened?',
  passageTitle: 'A small accident',
  passage:
      "I was riding my bike to work when it happened. It was raining, and I "
      "was going quite fast because I was late. Suddenly a cat ran across "
      "the road. I turned quickly, hit the kerb and fell off. A woman who "
      "was walking her dog helped me get up. Nothing was broken, but my "
      "trousers were ruined. Now I always leave home ten minutes earlier — "
      "if you hurry, accidents happen.",
  passageTranslation:
      'Iba en bici al trabajo cuando ocurrió. Llovía, y yo iba bastante '
      'rápido porque llegaba tarde. De repente un gato cruzó la carretera. '
      'Giré bruscamente, choqué con el bordillo y me caí. Una mujer que '
      'paseaba a su perro me ayudó a levantarme. No se rompió nada, pero '
      'mis pantalones quedaron destrozados. Ahora siempre salgo de casa '
      'diez minutos antes: si tienes prisa, los accidentes pasan.',
  intro: 'Una anécdota con fondo continuo y flashes en pasado. Escucha el '
      'was -ing… when…',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El esqueleto de la anécdota',
      text: 'was riding (fondo) + ran, turned, fell (flashes). Ese contraste '
          'es exactamente lo que practica el módulo.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What was the weather like?',
      options: ['Sunny', 'Rainy', 'Snowy'],
      correctIndex: 1,
      questionTranslation: '¿Qué tiempo hacía?',
    ),
    ReadingQuestion(
      question: 'Why did the cyclist fall?',
      options: [
        'A cat ran across the road',
        'The bike broke',
        'A dog attacked him',
      ],
      correctIndex: 0,
      questionTranslation: '¿Por qué se cayó el ciclista?',
    ),
    ReadingQuestion(
      question: 'Who helped him?',
      options: [
        'A police officer',
        'A woman who was walking her dog',
        'Nobody',
      ],
      correctIndex: 1,
      questionTranslation: '¿Quién le ayudó?',
    ),
  ],
);

final QuizContent esEnB12Relatives = esEnFill(
  id: 'es_en_b1_2_relatives',
  title: 'who / which / that / where',
  intro: 'Unir frases: who para personas, which para cosas, where para '
      'lugares. that puede sustituir a who y which.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'El reparto',
      text: 'the man **who** called · the book **which/that** I read · the '
          'town **where** I was born.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'El hombre que llamó es mi jefe.', answer: 'The man **who** called is my boss.'),
    CourseItem(prompt: 'El libro que leí era genial.', answer: 'The book **which** I read was great.', accepted: ['that']),
    CourseItem(prompt: 'La ciudad donde nací es pequeña.', answer: 'The town **where** I was born is small.'),
    CourseItem(prompt: 'La mujer que vive al lado es médica.', answer: 'The woman **who** lives next door is a doctor.'),
    CourseItem(prompt: 'El coche que compré es rojo.', answer: 'The car **which** I bought is red.', accepted: ['that']),
    CourseItem(prompt: 'El restaurante donde cenamos era caro.', answer: 'The restaurant **where** we had dinner was expensive.'),
    CourseItem(prompt: 'La gente que trabaja aquí es amable.', answer: 'The people **who** work here are friendly.'),
    CourseItem(prompt: 'La película que vimos era aburrida.', answer: 'The film **which** we watched was boring.', accepted: ['that']),
    CourseItem(prompt: 'El chico que conocí ayer es de Perú.', answer: 'The boy **who** I met yesterday is from Peru.'),
    CourseItem(prompt: 'La casa donde crecí ya no existe.', answer: 'The house **where** I grew up doesn\'t exist any more.'),
    CourseItem(prompt: 'El tren que va a Leeds sale a las dos.', answer: 'The train **which** goes to Leeds leaves at two.', accepted: ['that']),
    CourseItem(prompt: 'Una profesora que habla cinco idiomas.', answer: 'A teacher **who** speaks five languages.'),
    CourseItem(prompt: 'El día en que nos conocimos llovía. (when)', answer: 'The day **when** we met, it was raining.'),
    CourseItem(prompt: 'El hotel donde nos alojamos tenía piscina.', answer: 'The hotel **where** we stayed had a pool.'),
    CourseItem(prompt: 'La canción que más me gusta es esta.', answer: 'The song **which** I like most is this one.', accepted: ['that']),
  ],
);

final QuizContent esEnB12SpeakingMid = esEnSpeaking(
  id: 'es_en_b1_2_speaking_mid',
  title: 'Conversación: cuéntame una historia',
  level: 'B1.2',
  topic: 'Tell me a real story from your life: something funny, scary or '
      'surprising that happened to you. I will ask about the details.',
  practisePoints: [
    'Setting the scene with was/were + -ing',
    'Telling the events in past simple',
    'Connectors: suddenly, while, in the end',
  ],
  scoringCriteria: [
    'Past continuous vs past simple used correctly',
    'The story has a beginning, middle and end',
    'Connectors used naturally',
  ],
  priorityErrors: [
    'past simple used for background scenes',
    'missing was/were before -ing',
    'story told entirely in present',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: cuéntale una anécdota real a tu asistente de '
      'IA. Copia, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Prepara la escena',
      text: 'It was…, I was -ing…, when… Ensaya la primera frase antes de '
          'empezar: el resto sale rodado.',
    ),
  ],
);

final QuizContent esEnB12ReadStory = esEnRead(
  id: 'es_en_b1_2_read_story',
  title: 'Lectura: The lost wallet',
  passageTitle: 'The lost wallet',
  passage:
      "Last month Emma was travelling to Valencia by train when she noticed "
      "a wallet on the empty seat next to her. Inside there was money, some "
      "cards and an old photo of a family on a beach. There was no phone "
      "number. Emma, who works as a librarian, loves small mysteries. On the "
      "back of the photo someone had written \"Café Mar, 1998\". When she "
      "arrived, she looked for the café, which was still there, and showed "
      "the photo to the owner. \"That's my brother!\" he said. If Emma "
      "hadn't loved mysteries, the wallet would still be in a lost-property "
      "office today.",
  passageTranslation:
      'El mes pasado Emma viajaba a Valencia en tren cuando vio una cartera '
      'en el asiento vacío de al lado. Dentro había dinero, algunas '
      'tarjetas y una foto antigua de una familia en la playa. No había '
      'ningún teléfono. Emma, que trabaja de bibliotecaria, adora los '
      'pequeños misterios. Al dorso de la foto alguien había escrito «Café '
      'Mar, 1998». Al llegar buscó el café, que seguía allí, y enseñó la '
      'foto al dueño. «¡Ese es mi hermano!», dijo. Si a Emma no le '
      'encantaran los misterios, la cartera seguiría hoy en una oficina de '
      'objetos perdidos.',
  intro: 'Una pequeña historia detectivesca con pasado continuo, relativos '
      'y un condicional al final.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Los relativos tejen el texto',
      text: 'who works as a librarian, which was still there: fíjate cómo '
          'los relativos meten información sin abrir otra frase.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where was Emma travelling?',
      options: ['To Valencia', 'To Madrid', 'To Leeds'],
      correctIndex: 0,
      questionTranslation: '¿Adónde viajaba Emma?',
    ),
    ReadingQuestion(
      question: 'What was written on the photo?',
      options: ['A phone number', '"Café Mar, 1998"', 'An address'],
      correctIndex: 1,
      questionTranslation: '¿Qué había escrito en la foto?',
    ),
    ReadingQuestion(
      question: 'Who did the café owner recognise?',
      options: ['His brother', 'His father', 'Emma'],
      correctIndex: 0,
      questionTranslation: '¿A quién reconoció el dueño del café?',
    ),
  ],
);

final QuizContent esEnB12Connectors = esEnVocab(
  id: 'es_en_b1_2_connectors',
  title: 'Conectores de historia',
  intro: 'Las palabras que ordenan un relato, del principio al final.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S25 actually no es actualmente',
      text: 'actually = en realidad. "Actualmente" es currently / these '
          'days. El falso amigo más famoso del inglés.',
    ),
  ],
  pairs: const [
    MapEntry('al principio', 'at first'),
    MapEntry('luego / después', 'then'),
    MapEntry('mientras', 'while'),
    MapEntry('de repente', 'suddenly'),
    MapEntry('así que', 'so'),
    MapEntry('sin embargo', 'however'),
    MapEntry('en realidad', 'actually'),
    MapEntry('actualmente', 'currently'),
    MapEntry('por suerte', 'luckily'),
    MapEntry('desgraciadamente', 'unfortunately'),
    MapEntry('al final', 'in the end'),
    MapEntry('finalmente', 'finally'),
  ],
);

final QuizContent esEnB12Dict = esEnDict(
  id: 'es_en_b1_2_dict',
  title: 'Dictado: la anécdota',
  intro: 'Escucha y escribe frases de narración: was/were + -ing, used to y '
      'condicionales.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S10 was y were átonos',
      text: 'En "I was walking" el was casi desaparece: /wəz/. Si oyes '
          '-ing, busca su was/were delante.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Yo caminaba a casa cuando empezó a llover.', answer: 'I was walking home when it started to rain.'),
    CourseItem(prompt: 'Antes vivíamos en un pueblo.', answer: 'We used to live in a village.'),
    CourseItem(prompt: 'Si llueve, cogeremos un taxi.', answer: 'If it rains, we will take a taxi.'),
    CourseItem(prompt: 'Ella estaba leyendo en el sofá.', answer: 'She was reading on the sofa.'),
    CourseItem(prompt: 'Si fuera rico, no trabajaría.', answer: 'If I were rich, I would not work.'),
    CourseItem(prompt: 'El hombre que llamó era mi vecino.', answer: 'The man who called was my neighbour.'),
    CourseItem(prompt: 'De repente se apagaron las luces.', answer: 'Suddenly the lights went out.'),
    CourseItem(prompt: 'Mientras cocinaba, escuchaba música.', answer: 'While I was cooking, I was listening to music.'),
    CourseItem(prompt: '¿Qué estabas haciendo a medianoche?', answer: 'What were you doing at midnight?'),
    CourseItem(prompt: 'Antes no me gustaban las verduras.', answer: 'I did not use to like vegetables.'),
    CourseItem(prompt: 'La ciudad donde nací está en la costa.', answer: 'The town where I was born is on the coast.'),
    CourseItem(prompt: 'Si tuviera tiempo, aprendería piano.', answer: 'If I had time, I would learn the piano.'),
    CourseItem(prompt: 'Por suerte nadie resultó herido.', answer: 'Luckily nobody was hurt.'),
    CourseItem(prompt: 'Al final encontramos el hotel.', answer: 'In the end we found the hotel.'),
    CourseItem(prompt: 'El tren que esperábamos no llegó.', answer: 'The train that we were waiting for did not arrive.'),
  ],
);

final QuizContent esEnB12BigText = esEnBigText(
  id: 'es_en_b1_2_bigtext',
  title: 'Texto: The night the lights went out',
  passageTitle: 'The night the lights went out',
  intro: 'Completa la historia: pasado continuo, used to, relativos y un '
      'condicional.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Fondo -ing, flash simple',
      text: 'Pinta el fondo con was/were + -ing y dispara los hechos en '
          'pasado simple. El texto alterna los dos sin avisar.',
    ),
  ],
  template:
      'It was a windy night and I {{0}} watching an old film at home. My '
      'street, {{1}} is usually noisy, was completely quiet. Suddenly the '
      'lights {{2}} out. While I {{3}} looking for a candle, someone '
      'knocked on the door. It was my neighbour, Mrs. Vega, {{4}} used '
      '{{5}} be an electrician. "If you {{6}} me your torch, I will check '
      'the fuse box," she said. Ten minutes later the lights came back. '
      'Now, if the lights {{7}} out again, I {{8}} exactly who to call — '
      'the neighbour {{9}} saved my Friday night.',
  blanks: [
    inputBlank('was'),
    inputBlank('which'),
    inputBlank('went'),
    inputBlank('was'),
    inputBlank('who'),
    inputBlank('to'),
    inputBlank('lend', accepted: ['give', 'bring']),
    inputBlank('go'),
    inputBlank('know', accepted: ['will know']),
    inputBlank('who', accepted: ['that']),
  ],
  passageTranslation:
      'Era una noche de viento y yo estaba viendo una película antigua en '
      'casa. Mi calle, que suele ser ruidosa, estaba en completo silencio. '
      'De repente se fue la luz. Mientras buscaba una vela, alguien llamó a '
      'la puerta. Era mi vecina, la señora Vega, que antes era electricista. '
      '«Si me prestas tu linterna, reviso el cuadro de fusibles», dijo. Diez '
      'minutos después volvió la luz. Ahora, si se va la luz otra vez, sé '
      'exactamente a quién llamar: la vecina que salvó mi viernes por la '
      'noche.',
);

final QuizContent esEnB12SpeakingClose = esEnSpeaking(
  id: 'es_en_b1_2_speaking_close',
  title: 'Conversación final: antes y ahora',
  level: 'B1.2',
  topic: 'A conversation about how my life has changed: what I used to do '
      'as a child, a memorable story from those years, and what I would do '
      'differently if I could go back.',
  practisePoints: [
    'used to for old habits',
    'Past continuous + past simple in one story',
    'Second conditional: If I could…, I would…',
    'Relative clauses to describe people and places',
  ],
  scoringCriteria: [
    'used to formed correctly',
    'Scene vs event tenses correct',
    'Second conditional with would + base verb',
  ],
  targetVocabulary: [
    'used to', 'while', 'suddenly', 'would', 'who', 'where',
  ],
  priorityErrors: [
    '"I use to" in the past sense without did',
    'would inside the if-clause',
    'story with no connectors',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo B1.2: tu vida de antes y de ahora, con una '
      'historia en medio. Copia, habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tres actos',
      text: 'Antes (used to), la historia (was -ing… when…), y el sueño '
          '(If I could… I would…). Con ese guion cubres todos los puntos.',
    ),
  ],
);

/// B1.2 in chain order.
final List<QuizContent> esEnB1_2 = [
  esEnB12PastCont,
  esEnB12UsedTo,
  esEnB12SpeakStory,
  esEnB12FirstCond,
  esEnB12SecondCond,
  esEnB12ListenAccident,
  esEnB12Relatives,
  esEnB12SpeakingMid,
  esEnB12ReadStory,
  esEnB12Connectors,
  esEnB12Dict,
  esEnB12BigText,
  esEnB12SpeakingClose,
];
