import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// B2.1 — Argumentos e hipótesis. Spanish → English.
///
/// Big rocks: the third and mixed conditionals, modals of deduction (must /
/// might / can't have), the passive voice (⚑S28), formal linking words, and
/// the first big batch of false friends (⚑S25).

final QuizContent esEnB21ThirdCond = esEnFill(
  id: 'es_en_b2_1_third_cond',
  title: 'Condicional 3: lo que pudo ser',
  intro: 'El pasado imaginario: If + had + participio, would have + '
      'participio. If I had known, I would have come = si lo hubiera '
      'sabido, habría venido.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚑S23 La equivalencia exacta',
      text: 'hubiera sabido → had known · habría venido → would have come. '
          'Las dos mitades españolas tienen su molde fijo.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Si lo hubiera sabido, habría venido.', answer: 'If I **had** known, I would have come.'),
    CourseItem(prompt: 'Si hubieras estudiado, habrías aprobado.', answer: 'If you had studied, you **would** have passed.'),
    CourseItem(prompt: 'Habríamos llegado antes si hubiéramos salido temprano.', answer: 'We would have arrived earlier if we had **left** early.'),
    CourseItem(prompt: 'Si ella hubiera visto el correo, habría respondido.', answer: 'If she had **seen** the email, she would have replied.'),
    CourseItem(prompt: 'Si no hubiera llovido, habríamos ido a la playa.', answer: 'If it hadn\'t **rained**, we would have gone to the beach.'),
    CourseItem(prompt: 'Él habría aceptado si le hubieran pagado más.', answer: 'He would have **accepted** if they had paid him more.'),
    CourseItem(prompt: 'Si hubiéramos reservado, habríamos tenido mesa.', answer: 'If we had **booked**, we would have had a table.'),
    CourseItem(prompt: '¿Qué habrías hecho si te hubieran despedido?', answer: 'What would you have **done** if they had fired you?'),
    CourseItem(prompt: 'Si me hubieras llamado, te habría ayudado.', answer: 'If you had called me, I would have **helped** you.'),
    CourseItem(prompt: 'No habríamos perdido el vuelo si hubiéramos cogido un taxi.', answer: 'We wouldn\'t have **missed** the flight if we had taken a taxi.'),
    CourseItem(prompt: 'Si él hubiera dicho la verdad, nada habría pasado.', answer: 'If he had **told** the truth, nothing would have happened.'),
    CourseItem(prompt: 'Habría comprado la casa si hubiera tenido el dinero.', answer: 'I would have bought the house if I had **had** the money.'),
    CourseItem(prompt: 'Mixto: si hubiera estudiado, ahora tendría trabajo.', answer: 'If I had studied, I **would** have a job now.'),
    CourseItem(prompt: 'Mixto: si fuera valiente, habría dicho algo.', answer: 'If I **were** brave, I would have said something.'),
    CourseItem(prompt: 'Si hubieran escuchado, habrían entendido.', answer: 'If they had **listened**, they would have understood.'),
  ],
);

final QuizContent esEnB21Deduction = esEnFill(
  id: 'es_en_b2_1_deduction',
  title: 'Deducir: must / might / can\'t',
  intro: 'Deducciones: must be (debe de ser, casi seguro), might be (puede '
      'que sea), can\'t be (no puede ser). Sobre el pasado: must have been…',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'deber de ≠ deber',
      text: '"Debe de estar en casa" (deducción) = He **must** be at home. '
          '"Debe estudiar" (obligación) = He must study. El inglés usa must '
          'para ambos, el contexto decide.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Debe de estar cansado.', answer: 'He **must** be tired.'),
    CourseItem(prompt: 'Puede que llueva más tarde.', answer: 'It **might** rain later.'),
    CourseItem(prompt: 'No puede ser verdad.', answer: 'It **can\'t** be true.'),
    CourseItem(prompt: 'Debe de haber salido ya.', answer: 'She must have **left** already.'),
    CourseItem(prompt: 'Puede que haya perdido el tren.', answer: 'He might have **missed** the train.'),
    CourseItem(prompt: 'No pueden haber terminado tan pronto.', answer: 'They can\'t have **finished** so soon.'),
    CourseItem(prompt: 'Debes de tener hambre.', answer: 'You **must** be hungry.'),
    CourseItem(prompt: 'Puede que esté en una reunión.', answer: 'She **might** be in a meeting.'),
    CourseItem(prompt: 'Ese no puede ser su coche: no conduce.', answer: 'That **can\'t** be his car: he doesn\'t drive.'),
    CourseItem(prompt: 'Deben de ser las diez ya.', answer: 'It **must** be ten o\'clock already.'),
    CourseItem(prompt: 'Puede que no le guste el plan.', answer: 'She **might** not like the plan.'),
    CourseItem(prompt: 'Debe de haber costado una fortuna.', answer: 'It must have **cost** a fortune.'),
    CourseItem(prompt: 'No puede haberlo olvidado.', answer: 'He can\'t have **forgotten** it.'),
    CourseItem(prompt: 'Puede que hayan cambiado de idea.', answer: 'They might have **changed** their minds.'),
    CourseItem(prompt: 'Debe de conocerla de la universidad.', answer: 'He **must** know her from university.'),
  ],
);

final QuizContent esEnB21Passive = esEnFill(
  id: 'es_en_b2_1_passive',
  title: 'La pasiva: be + participio',
  intro: 'Cuando importa el hecho, no el autor: The bridge was built in '
      '1900. El español prefiere "se construyó"; el inglés ama su pasiva '
      '(⚑S28).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S28 El "se" impersonal se vuelve pasiva',
      text: '"Se habla inglés" → English **is spoken**. "Se vendió la casa" '
          '→ The house **was sold**. Piensa en pasiva, no en se.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Aquí se habla inglés.', answer: 'English **is** spoken here.'),
    CourseItem(prompt: 'El puente fue construido en 1900.', answer: 'The bridge **was** built in 1900.'),
    CourseItem(prompt: 'Estas naranjas se cultivan en Valencia.', answer: 'These oranges **are** grown in Valencia.'),
    CourseItem(prompt: 'La carta fue enviada ayer.', answer: 'The letter **was** sent yesterday.'),
    CourseItem(prompt: 'El museo fue diseñado por un arquitecto famoso.', answer: 'The museum was **designed** by a famous architect.'),
    CourseItem(prompt: 'Me robaron la cartera. (pasiva)', answer: 'My wallet **was** stolen.'),
    CourseItem(prompt: 'La cena se sirve a las ocho.', answer: 'Dinner **is** served at eight.'),
    CourseItem(prompt: 'Las entradas se vendieron en una hora.', answer: 'The tickets **were** sold in an hour.'),
    CourseItem(prompt: 'El problema será resuelto mañana.', answer: 'The problem will be **solved** tomorrow.'),
    CourseItem(prompt: 'Este libro fue escrito hace un siglo.', answer: 'This book was **written** a century ago.'),
    CourseItem(prompt: 'La reunión ha sido cancelada.', answer: 'The meeting has been **cancelled**.'),
    CourseItem(prompt: 'Se están construyendo pisos nuevos.', answer: 'New flats are being **built**.'),
    CourseItem(prompt: 'El ladrón fue detenido por la policía.', answer: 'The thief was **arrested** by the police.'),
    CourseItem(prompt: 'Se me invitó a la boda.', answer: 'I **was** invited to the wedding.'),
    CourseItem(prompt: 'La película fue dirigida por una mujer.', answer: 'The film was **directed** by a woman.'),
  ],
);

final QuizContent esEnB21FalseFriends = esEnVocab(
  id: 'es_en_b2_1_false_friends',
  title: 'Falsos amigos I',
  intro: 'Palabras que parecen español y no lo son. Cada una de estas ha '
      'hecho tropezar a miles de hispanohablantes (⚑S25).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Los tres mortales',
      text: 'embarrassed = avergonzado (embarazada = pregnant) · actually = '
          'en realidad · sensible = sensato (sensible = sensitive).',
    ),
  ],
  pairs: const [
    MapEntry('avergonzado', 'embarrassed'),
    MapEntry('embarazada', 'pregnant'),
    MapEntry('en realidad', 'actually'),
    MapEntry('sensato', 'sensible'),
    MapEntry('sensible', 'sensitive'),
    MapEntry('asistir (a un evento)', 'attend'),
    MapEntry('ayudar', 'assist'),
    MapEntry('éxito', 'success'),
    MapEntry('salida', 'exit'),
    MapEntry('carpeta', 'folder'),
    MapEntry('alfombra', 'carpet'),
    MapEntry('constipado (resfriado)', 'a cold'),
  ],
);

final QuizContent esEnB21Linkers = esEnFill(
  id: 'es_en_b2_1_linkers',
  title: 'although, despite, however…',
  intro: 'Los conectores del argumento: contraste, causa y consecuencia. '
      'Cada uno con su gramática propia.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'although + frase, despite + nombre/-ing',
      text: 'Although it rained, we went out · Despite the rain / Despite '
          'raining… Mezclarlos es el error B2 clásico.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Aunque llovía, salimos.', answer: '**Although** it was raining, we went out.'),
    CourseItem(prompt: 'A pesar de la lluvia, salimos.', answer: '**Despite** the rain, we went out.'),
    CourseItem(prompt: 'Estaba cansado; sin embargo, siguió.', answer: 'He was tired; **however**, he continued.'),
    CourseItem(prompt: 'No fui porque estaba enfermo.', answer: 'I didn\'t go **because** I was ill.'),
    CourseItem(prompt: 'Debido al tráfico, llegamos tarde.', answer: '**Due** to the traffic, we arrived late.'),
    CourseItem(prompt: 'Por lo tanto, necesitamos un plan.', answer: '**Therefore**, we need a plan.'),
    CourseItem(prompt: 'A pesar de estar cansada, terminó.', answer: '**Despite** being tired, she finished.'),
    CourseItem(prompt: 'Aunque es caro, lo compraré.', answer: '**Although** it is expensive, I will buy it.'),
    CourseItem(prompt: 'Además, el hotel tenía piscina.', answer: '**Moreover**, the hotel had a pool.', accepted: ['Furthermore']),
    CourseItem(prompt: 'Mientras que Juan lee, Ana ve la tele. (contraste)', answer: '**While** Juan reads, Ana watches TV.', accepted: ['Whereas']),
    CourseItem(prompt: 'Como resultado, las ventas subieron.', answer: 'As a **result**, sales went up.'),
    CourseItem(prompt: 'En cambio, su hermano es muy tímido.', answer: 'In **contrast**, his brother is very shy.'),
    CourseItem(prompt: 'A pesar de que avisamos, nadie vino.', answer: '**Even** though we warned them, nobody came.'),
    CourseItem(prompt: 'Por esta razón, cancelamos el viaje.', answer: 'For this **reason**, we cancelled the trip.'),
    CourseItem(prompt: 'Así pues, la reunión se pospone.', answer: '**Therefore**, the meeting is postponed.'),
  ],
);

final QuizContent esEnB21ListenNews = esEnListen(
  id: 'es_en_b2_1_listen_news',
  title: 'Escucha: The local news',
  passageTitle: 'News at six',
  passage:
      "Good evening. A new bridge was opened in the city centre this "
      "morning. It was designed by a local team and was built in only two "
      "years. Although the project was criticised at first because of its "
      "cost, most residents now say it must have been worth the money: "
      "traffic in the old town has been reduced by forty per cent. The "
      "mayor said that if the bridge hadn't been built, the centre would "
      "have been closed to cars completely.",
  passageTranslation:
      'Buenas tardes. Esta mañana se ha inaugurado un puente nuevo en el '
      'centro. Fue diseñado por un equipo local y se construyó en solo dos '
      'años. Aunque al principio el proyecto fue criticado por su coste, '
      'la mayoría de los vecinos dice ahora que debió de valer la pena: el '
      'tráfico del casco antiguo se ha reducido un cuarenta por ciento. El '
      'alcalde dijo que si el puente no se hubiera construido, el centro se '
      'habría cerrado por completo a los coches.',
  intro: 'Una noticia local cargada de pasivas y un condicional 3 al final.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La pasiva es el idioma de las noticias',
      text: 'was opened, was designed, has been reduced: las noticias '
          'inglesas viven en pasiva. Acostúmbrate a oírla.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How long did the bridge take to build?',
      options: ['Two years', 'Four years', 'Ten years'],
      correctIndex: 0,
      questionTranslation: '¿Cuánto tardó en construirse el puente?',
    ),
    ReadingQuestion(
      question: 'Why was the project criticised at first?',
      options: ['Its cost', 'Its size', 'Its colour'],
      correctIndex: 0,
      questionTranslation: '¿Por qué se criticó el proyecto al principio?',
    ),
    ReadingQuestion(
      question: 'How much has traffic been reduced?',
      options: ['By twenty per cent', 'By forty per cent', 'By sixty per cent'],
      correctIndex: 1,
      questionTranslation: '¿Cuánto se ha reducido el tráfico?',
    ),
  ],
);

final QuizContent esEnB21SpeakingMid = esEnSpeaking(
  id: 'es_en_b2_1_speaking_mid',
  title: 'Conversación: ¿qué habría pasado?',
  level: 'B2.1',
  topic: 'A conversation about decisions and their consequences: a decision '
      'that changed my life, what would have happened if I had chosen '
      'differently, and a mystery or news story I try to explain with '
      'deductions.',
  practisePoints: [
    'Third conditional about my own past',
    'Deductions with must/might/can\'t (have)',
    'Contrast linkers: although, however, despite',
  ],
  scoringCriteria: [
    'Third conditional structure correct',
    'Deduction modals used with the right certainty',
    'Ideas connected with linkers, not just "and"',
  ],
  priorityErrors: [
    '"would have" inside the if-clause',
    'must/might confused with obligation',
    'despite followed by a full clause',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: hipótesis sobre tu propia vida con tu asistente '
      'de IA. Copia, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tu frase de oro',
      text: 'If I hadn\'t …, I would never have … — prepara dos ejemplos '
          'reales de tu vida antes de empezar.',
    ),
  ],
);

final QuizContent esEnB21ReadDebate = esEnRead(
  id: 'es_en_b2_1_read_debate',
  title: 'Lectura: Cars out of the centre?',
  passageTitle: 'Cars out of the centre?',
  passage:
      "Should private cars be banned from city centres? In cities where "
      "this has been tried, air quality has improved and small shops have "
      "actually sold more, not less. Although drivers complain at first, "
      "most get used to the change within a year. However, the policy can't "
      "work alone: if buses and trains aren't improved at the same time, "
      "people who live far from the centre are simply left without options. "
      "In other words, banning cars might be a sensible idea — but only if "
      "public transport is treated as part of the same project.",
  passageTranslation:
      '¿Deberían prohibirse los coches privados en los centros urbanos? En '
      'las ciudades donde se ha probado, la calidad del aire ha mejorado y '
      'las tiendas pequeñas, en realidad, han vendido más, no menos. Aunque '
      'los conductores se quejan al principio, la mayoría se acostumbra al '
      'cambio en un año. Sin embargo, la medida no puede funcionar sola: si '
      'no se mejoran a la vez los autobuses y trenes, la gente que vive '
      'lejos del centro se queda sencillamente sin opciones. En otras '
      'palabras, prohibir los coches podría ser una idea sensata, pero solo '
      'si el transporte público se trata como parte del mismo proyecto.',
  intro: 'Un texto de opinión con estructura de argumento: tesis, '
      'concesión, contraargumento y conclusión.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El mapa del argumento',
      text: 'Although… (concede), However… (gira), In other words… '
          '(concluye). Este esqueleto te servirá para escribir los tuyos.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What happened to small shops in cities that tried the ban?',
      options: ['They sold more', 'They sold less', 'They closed'],
      correctIndex: 0,
      questionTranslation: '¿Qué pasó con las tiendas pequeñas donde se probó?',
    ),
    ReadingQuestion(
      question: 'What must be improved at the same time?',
      options: ['Car parks', 'Public transport', 'Bike lanes'],
      correctIndex: 1,
      questionTranslation: '¿Qué debe mejorarse a la vez?',
    ),
    ReadingQuestion(
      question: 'What is the author\'s conclusion?',
      options: [
        'Cars should never be banned',
        'The ban might be sensible only as part of a bigger project',
        'Drivers never accept changes',
      ],
      correctIndex: 1,
      questionTranslation: '¿Cuál es la conclusión del autor?',
    ),
  ],
);

final QuizContent esEnB21SpeakStress = esEnSpeak(
  id: 'es_en_b2_1_speak_stress',
  title: 'Sonidos: el acento de las palabras',
  intro: 'El acento inglés no se escribe pero cambia el significado (⚑S8). '
      'Escucha dónde cae y repite.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S8 La familia cambia de acento',
      text: 'PHOtograph → phoTOgrapher → photoGRAPHic. La misma raíz, tres '
          'acentos. Apréndelos de oído, no de vista.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'foto / fotógrafo / fotográfico', answer: 'photograph, photographer, photographic'),
    CourseItem(prompt: 'economía / económico', answer: 'economy, economic'),
    CourseItem(prompt: 'política / político', answer: 'politics, political'),
    CourseItem(prompt: 'record: nombre y verbo', answer: 'a REcord, to reCORD'),
    CourseItem(prompt: 'present: nombre y verbo', answer: 'a PREsent, to preSENT'),
    CourseItem(prompt: 'Una frase con dos acentos', answer: 'The photographer recorded an economic report.'),
    CourseItem(prompt: 'hotel y university (no a la española)', answer: 'hotel, university, opportunity'),
  ],
);

final QuizContent esEnB21Dict = esEnDict(
  id: 'es_en_b2_1_dict',
  title: 'Dictado: argumentos',
  intro: 'Escucha y escribe: pasivas, condicionales perfectos y conectores.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S10 have reducido',
      text: 'En "would have gone" el have suena /əv/ ("would\'ve"). '
          'Escríbelo siempre completo: would have.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'El puente fue construido en dos años.', answer: 'The bridge was built in two years.'),
    CourseItem(prompt: 'Si lo hubiera sabido, habría venido.', answer: 'If I had known, I would have come.'),
    CourseItem(prompt: 'Debe de estar en una reunión.', answer: 'She must be in a meeting.'),
    CourseItem(prompt: 'Aunque era tarde, seguimos trabajando.', answer: 'Although it was late, we kept working.'),
    CourseItem(prompt: 'Aquí se habla español.', answer: 'Spanish is spoken here.'),
    CourseItem(prompt: 'Puede que hayan perdido el tren.', answer: 'They might have missed the train.'),
    CourseItem(prompt: 'La reunión ha sido cancelada.', answer: 'The meeting has been cancelled.'),
    CourseItem(prompt: 'A pesar de la lluvia, el concierto siguió.', answer: 'Despite the rain, the concert went on.'),
    CourseItem(prompt: 'No puede haber sido él.', answer: 'It cannot have been him.'),
    CourseItem(prompt: 'Me robaron el pasaporte en el aeropuerto.', answer: 'My passport was stolen at the airport.'),
    CourseItem(prompt: 'Por lo tanto, necesitamos más tiempo.', answer: 'Therefore, we need more time.'),
    CourseItem(prompt: 'Habríamos ganado si hubiéramos jugado mejor.', answer: 'We would have won if we had played better.'),
    CourseItem(prompt: 'Las entradas se venden en línea.', answer: 'The tickets are sold online.'),
    CourseItem(prompt: 'Sin embargo, nadie se quejó.', answer: 'However, nobody complained.'),
    CourseItem(prompt: 'El problema será resuelto pronto.', answer: 'The problem will be solved soon.'),
  ],
);

final QuizContent esEnB21BigText = esEnBigText(
  id: 'es_en_b2_1_bigtext',
  title: 'Texto: The mystery of the empty office',
  passageTitle: 'The mystery of the empty office',
  intro: 'Completa: pasivas, deducciones y condicionales 3.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Detective de gramática',
      text: '¿Quién hizo la acción? Si no importa → pasiva. ¿Es una '
          'suposición? → must/might have. ¿Pasado imaginario? → had + '
          'participio.',
    ),
  ],
  template:
      'When Lucía arrived on Monday, the office was empty. The lights had '
      'been {{0}} on all weekend and a window {{1}} open. "Someone {{2}} '
      'have been here," she thought. Her laptop was still on the desk, so '
      'it {{3}} have been a thief — a thief would have {{4}} it. Then she '
      'saw a note: "The pipes burst on Saturday. Everyone was {{5}} to '
      'work from home. The message was {{6}} to all staff by email." Lucía '
      'sighed. If she {{7}} checked her inbox, she {{8}} have stayed in '
      'bed. Although the walk had woken her up, she would rather have '
      '{{9}} it on a beach.',
  blanks: [
    inputBlank('left'),
    inputBlank('was'),
    inputBlank('must'),
    inputBlank("can't", accepted: ['cannot', 'couldn\'t']),
    inputBlank('taken', accepted: ['stolen']),
    inputBlank('told', accepted: ['asked']),
    inputBlank('sent'),
    inputBlank('had'),
    inputBlank('would'),
    inputBlank('spent'),
  ],
  passageTranslation:
      'Cuando Lucía llegó el lunes, la oficina estaba vacía. Las luces '
      'habían quedado encendidas todo el fin de semana y una ventana estaba '
      'abierta. «Alguien debe de haber estado aquí», pensó. Su portátil '
      'seguía en la mesa, así que no podía haber sido un ladrón: un ladrón '
      'se lo habría llevado. Entonces vio una nota: «Las tuberías '
      'reventaron el sábado. Se pidió a todos trabajar desde casa. El '
      'mensaje se envió a toda la plantilla por correo.» Lucía suspiró. Si '
      'hubiera mirado su bandeja de entrada, se habría quedado en la cama. '
      'Aunque el paseo la había despertado, habría preferido pasarlo en '
      'una playa.',
);

final QuizContent esEnB21SpeakingClose = esEnSpeaking(
  id: 'es_en_b2_1_speaking_close',
  title: 'Conversación final: el debate',
  level: 'B2.1',
  topic: 'A friendly debate: choose a topic like remote work, cars in city '
      'centres or social media, defend your position and answer my '
      'counter-arguments.',
  practisePoints: [
    'Building an argument with although/however/therefore',
    'The passive for general claims: it is said, it has been shown',
    'Hypotheses: conditionals 2 and 3',
    'Polite disagreement: I see your point, but…',
  ],
  scoringCriteria: [
    'Arguments connected logically',
    'Passive and conditional structures correct',
    'Counter-arguments answered, not ignored',
  ],
  targetVocabulary: [
    'although', 'however', 'therefore', 'in my view', 'on the other hand',
  ],
  priorityErrors: [
    'linkers with the wrong grammar (despite + clause)',
    'conditional halves mixed up',
    'false friends: actually, sensible, assist',
  ],
  mode: SpeakingMode.conversation,
  intro: 'Cierre del módulo B2.1: un debate de verdad con tu asistente de '
      'IA. Copia, defiende tu postura y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concede y gira',
      text: 'I see your point; however… — conceder antes de girar es lo que '
          'hace sonar B2 un desacuerdo.',
    ),
  ],
);

/// B2.1 in chain order.
final List<QuizContent> esEnB2_1 = [
  esEnB21ThirdCond,
  esEnB21Deduction,
  esEnB21Passive,
  esEnB21FalseFriends,
  esEnB21Linkers,
  esEnB21ListenNews,
  esEnB21SpeakingMid,
  esEnB21ReadDebate,
  esEnB21SpeakStress,
  esEnB21Dict,
  esEnB21BigText,
  esEnB21SpeakingClose,
];
