import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// B2.2 — Matices y reformulación. Spanish → English.
///
/// Big rocks: reported speech with backshift (⚑S24), question tags,
/// wish/if only, phrasal verbs II (⚑S21), the make/do and say/tell splits
/// (⚑S22), and US/UK variation (⚑S29).

final QuizContent esEnB22Reported = esEnFill(
  id: 'es_en_b2_2_reported',
  title: 'Estilo indirecto: she said that…',
  intro: 'Contar lo que alguien dijo: el tiempo retrocede un paso. "I am '
      'tired" → She said she was tired (⚑S24).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'El retroceso',
      text: 'am/is → was · will → would · can → could · have done → had '
          'done · did → had done. Y los deícticos: today → that day.',
    ),
  ],
  items: const [
    CourseItem(prompt: '«Estoy cansada» → Dijo que estaba cansada.', answer: 'She said she **was** tired.'),
    CourseItem(prompt: '«Te llamaré» → Dijo que me llamaría.', answer: 'He said he **would** call me.'),
    CourseItem(prompt: '«Puedo ayudar» → Dijo que podía ayudar.', answer: 'She said she **could** help.'),
    CourseItem(prompt: '«Vivo aquí» → Dijo que vivía allí.', answer: 'He said he **lived** there.'),
    CourseItem(prompt: '«He terminado» → Dijo que había terminado.', answer: 'She said she **had** finished.'),
    CourseItem(prompt: '«Vi la película» → Dijo que había visto la película.', answer: 'He said he had **seen** the film.'),
    CourseItem(prompt: '«Estoy trabajando» → Dijo que estaba trabajando.', answer: 'She said she was **working**.'),
    CourseItem(prompt: '«Iré mañana» → Dijo que iría al día siguiente.', answer: 'He said he would go the **next** day.'),
    CourseItem(prompt: '¿Dónde vives? → Me preguntó dónde vivía.', answer: 'She asked me where I **lived**.'),
    CourseItem(prompt: '¿Estás bien? → Me preguntó si estaba bien.', answer: 'He asked me **if** I was OK.'),
    CourseItem(prompt: '«No lo sé» → Admitió que no lo sabía.', answer: 'She admitted she didn\'t **know**.'),
    CourseItem(prompt: '«Cierra la puerta» → Me pidió que cerrara la puerta.', answer: 'He asked me **to close** the door.'),
    CourseItem(prompt: '«No llegues tarde» → Me dijo que no llegara tarde.', answer: 'She told me **not to** be late.'),
    CourseItem(prompt: '«Lo haré hoy» → Dijo que lo haría ese día.', answer: 'He said he would do it **that** day.'),
    CourseItem(prompt: '¿Has comido? → Me preguntó si había comido.', answer: 'She asked me if I **had** eaten.'),
  ],
);

final QuizContent esEnB22SayTell = esEnFill(
  id: 'es_en_b2_2_say_tell',
  title: 'say / tell y make / do',
  intro: 'Dos parejas que el español funde en una: decir (say sin persona, '
      'tell + persona) y hacer (make crear, do actividad) (⚑S22).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Las reglas cortas',
      text: 'tell **someone** · say (that)… — make a cake/mistake/decision '
          '· do homework/the dishes/your best.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ella me dijo la verdad.', answer: 'She **told** me the truth.'),
    CourseItem(prompt: 'Él dijo que estaba bien.', answer: 'He **said** he was fine.'),
    CourseItem(prompt: 'Cometí un error.', answer: 'I **made** a mistake.'),
    CourseItem(prompt: 'Hice los deberes.', answer: 'I **did** my homework.'),
    CourseItem(prompt: 'Tomó una decisión.', answer: 'She **made** a decision.'),
    CourseItem(prompt: 'Hago la colada los sábados.', answer: 'I **do** the laundry on Saturdays.'),
    CourseItem(prompt: 'No me dijeron nada.', answer: 'They didn\'t **tell** me anything.'),
    CourseItem(prompt: '¿Qué dijo ella?', answer: 'What did she **say**?'),
    CourseItem(prompt: 'Hizo una tarta para mi cumpleaños.', answer: 'She **made** a cake for my birthday.'),
    CourseItem(prompt: 'Haz tu mejor esfuerzo.', answer: '**Do** your best.'),
    CourseItem(prompt: 'Cuéntame una historia.', answer: '**Tell** me a story.'),
    CourseItem(prompt: 'Ganó mucho dinero. (make)', answer: 'He **made** a lot of money.'),
    CourseItem(prompt: 'Ella hizo una pregunta. (ask)', answer: 'She **asked** a question.'),
    CourseItem(prompt: 'Di algo.', answer: '**Say** something.'),
    CourseItem(prompt: 'Hicieron mucho ruido.', answer: 'They **made** a lot of noise.'),
  ],
);

final QuizContent esEnB22Tags = esEnFill(
  id: 'es_en_b2_2_tags',
  title: 'Question tags: …, isn\'t it?',
  intro: 'El "¿verdad?" inglés cambia con cada frase: afirmativa → tag '
      'negativo, negativa → tag positivo, siempre con el auxiliar.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'El espejo',
      text: 'You are Spanish, **aren\'t you?** · She doesn\'t drive, **does '
          'she?** El tag copia el auxiliar y da la vuelta al signo.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Eres español, ¿verdad?', answer: 'You are Spanish, **aren\'t** you?'),
    CourseItem(prompt: 'Ella no conduce, ¿verdad?', answer: 'She doesn\'t drive, **does** she?'),
    CourseItem(prompt: 'Hace frío, ¿no?', answer: 'It is cold, **isn\'t** it?'),
    CourseItem(prompt: 'Viste la película, ¿no?', answer: 'You saw the film, **didn\'t** you?'),
    CourseItem(prompt: 'Puedes nadar, ¿verdad?', answer: 'You can swim, **can\'t** you?'),
    CourseItem(prompt: 'No has comido, ¿verdad?', answer: 'You haven\'t eaten, **have** you?'),
    CourseItem(prompt: 'Vendrás, ¿no?', answer: 'You will come, **won\'t** you?'),
    CourseItem(prompt: 'Ellos viven aquí, ¿verdad?', answer: 'They live here, **don\'t** they?'),
    CourseItem(prompt: 'Él era profesor, ¿no?', answer: 'He was a teacher, **wasn\'t** he?'),
    CourseItem(prompt: 'No está lloviendo, ¿verdad?', answer: 'It isn\'t raining, **is** it?'),
    CourseItem(prompt: 'Ella ha estado en París, ¿no?', answer: 'She has been to Paris, **hasn\'t** she?'),
    CourseItem(prompt: 'No puedes venir, ¿verdad?', answer: 'You can\'t come, **can** you?'),
    CourseItem(prompt: 'Trabajamos mañana, ¿no?', answer: 'We work tomorrow, **don\'t** we?'),
    CourseItem(prompt: 'Él no dijo eso, ¿verdad?', answer: 'He didn\'t say that, **did** he?'),
    CourseItem(prompt: 'Es tu cumpleaños, ¿no?', answer: 'It is your birthday, **isn\'t** it?'),
  ],
);

final QuizContent esEnB22Wish = esEnFill(
  id: 'es_en_b2_2_wish',
  title: 'wish / if only: ojalá',
  intro: 'Ojalá presente → wish + pasado (I wish I had…). Ojalá pasado → '
      'wish + had + participio. Quejas → wish + would.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Un paso atrás siempre',
      text: 'I wish I **have** ✗ → I wish I **had** ✓. El deseo presente se '
          'expresa en pasado; el arrepentimiento, en had + participio.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ojalá tuviera más tiempo.', answer: 'I wish I **had** more time.'),
    CourseItem(prompt: 'Ojalá supiera cocinar.', answer: 'I wish I **knew** how to cook.'),
    CourseItem(prompt: 'Ojalá hubiera estudiado más.', answer: 'I wish I **had** studied more.'),
    CourseItem(prompt: 'Ojalá no hubiera dicho eso.', answer: 'I wish I **hadn\'t** said that.'),
    CourseItem(prompt: 'Ojalá dejara de llover. (would)', answer: 'I wish it **would** stop raining.'),
    CourseItem(prompt: 'Ojalá viviera cerca del mar.', answer: 'I wish I **lived** near the sea.'),
    CourseItem(prompt: 'Ojalá pudiera ayudarte.', answer: 'I wish I **could** help you.'),
    CourseItem(prompt: 'Ojalá fuera viernes.', answer: 'I wish it **were** Friday.'),
    CourseItem(prompt: 'Ojalá me hubieras avisado.', answer: 'I wish you **had** told me.'),
    CourseItem(prompt: 'Ojalá él no condujera tan rápido. (would)', answer: 'I wish he **wouldn\'t** drive so fast.'),
    CourseItem(prompt: 'Ojalá no hiciera tanto frío.', answer: 'I wish it **weren\'t** so cold.'),
    CourseItem(prompt: 'Ojalá hubiéramos reservado antes.', answer: 'I wish we **had** booked earlier.'),
    CourseItem(prompt: 'Si al menos tuviera un mapa…', answer: 'If **only** I had a map…'),
    CourseItem(prompt: 'Ojalá hablara mejor inglés.', answer: 'I wish I **spoke** better English.'),
    CourseItem(prompt: 'Ojalá los vecinos hicieran menos ruido. (would)', answer: 'I wish the neighbours **would** make less noise.'),
  ],
);

final QuizContent esEnB22Phrasals2 = esEnVocab(
  id: 'es_en_b2_2_phrasals2',
  title: 'Phrasal verbs II',
  intro: 'La segunda tanda: los phrasal verbs de la vida adulta — trabajo, '
      'problemas y relaciones (⚑S21).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Separables',
      text: 'turn it down, put it off, sort it out: con pronombre, la '
          'partícula se va detrás. "turn down it" ✗.',
    ),
  ],
  pairs: const [
    MapEntry('rechazar (oferta)', 'turn down'),
    MapEntry('aplazar', 'put off'),
    MapEntry('resolver / arreglar', 'sort out'),
    MapEntry('quedarse sin', 'run out of'),
    MapEntry('ponerse al día', 'catch up'),
    MapEntry('aguantar / soportar', 'put up with'),
    MapEntry('admirar / respetar', 'look up to'),
    MapEntry('inventar(se)', 'make up'),
    MapEntry('averiguar / resultar', 'turn out'),
    MapEntry('cuidar de sí mismo', 'look after yourself'),
    MapEntry('romper (una relación)', 'break up'),
    MapEntry('crecer / criarse', 'grow up'),
  ],
);

final QuizContent esEnB22ListenPodcast = esEnListen(
  id: 'es_en_b2_2_listen_podcast',
  title: 'Escucha: The podcast interview',
  passageTitle: 'A writer on the radio',
  passage:
      "Our guest tonight is the writer Clara Ríos. Clara, you grew up in "
      "two countries, didn't you? — That's right. My family moved to "
      "Canada when I was ten, and I was told on my first day at school "
      "that I would forget my Spanish. I wish they had been right in one "
      "way — I spent years trying to fit in. — And your new novel? — My "
      "editor said it was the best thing I had ever written, which was "
      "kind of her. It turns out that writing about two languages is what "
      "I do best. I put the idea off for a decade, and now I can't put the "
      "pen down.",
  passageTranslation:
      'Nuestra invitada de esta noche es la escritora Clara Ríos. Clara, '
      'creciste en dos países, ¿verdad? — Así es. Mi familia se mudó a '
      'Canadá cuando yo tenía diez años, y el primer día de colegio me '
      'dijeron que olvidaría mi español. Ojalá hubieran tenido razón en '
      'una cosa: pasé años intentando encajar. — ¿Y tu nueva novela? — Mi '
      'editora dijo que era lo mejor que había escrito nunca, muy amable '
      'por su parte. Resulta que escribir sobre dos idiomas es lo que '
      'mejor se me da. Aplacé la idea una década y ahora no puedo soltar '
      'el bolígrafo.',
  intro: 'Una entrevista con estilo indirecto, tags, wish y phrasal verbs '
      'en estado natural.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Reported en vivo',
      text: 'I was told that I would forget…, she said it was… — fíjate en '
          'los retrocesos de tiempo dentro de la charla real.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How old was Clara when her family moved?',
      options: ['Eight', 'Ten', 'Twelve'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos años tenía Clara cuando se mudaron?',
    ),
    ReadingQuestion(
      question: 'What did her editor say about the novel?',
      options: [
        'It was too long',
        'It was the best thing she had ever written',
        'It needed more work',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué dijo su editora de la novela?',
    ),
    ReadingQuestion(
      question: 'How long did she put the idea off?',
      options: ['A year', 'A decade', 'A month'],
      correctIndex: 1,
      questionTranslation: '¿Cuánto tiempo aplazó la idea?',
    ),
  ],
);

final QuizContent esEnB22SpeakingMid = esEnSpeaking(
  id: 'es_en_b2_2_speaking_mid',
  title: 'Conversación: me dijeron que…',
  level: 'B2.2',
  topic: 'Gossip and messages: tell me about advice people have given you, '
      'things your family used to tell you, and a piece of news someone '
      'told you recently — all in reported speech.',
  practisePoints: [
    'Reported statements with backshift: she said she was…',
    'Reported questions and requests: he asked me if… / to…',
    'say vs tell used correctly',
  ],
  scoringCriteria: [
    'Backshift applied consistently',
    'tell + person, say without person',
    'Natural connectors between reported items',
  ],
  priorityErrors: [
    '"she said me"',
    'no backshift after said/told',
    'word order in reported questions',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: cuéntale a tu asistente de IA lo que otros te '
      'han dicho. Copia, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tu munición',
      text: 'My grandmother always told me that… / A friend said he '
          'would… Prepara tres recuerdos antes de empezar.',
    ),
  ],
);

final QuizContent esEnB22UsUk = esEnVocab(
  id: 'es_en_b2_2_us_uk',
  title: 'Reino Unido vs Estados Unidos',
  intro: 'El inglés tiene dos estándares grandes. Este curso usa el '
      'británico, pero debes reconocer ambos (⚑S29).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Ortografía también',
      text: 'colour/color, centre/center, organise/organize, '
          'travelled/traveled. Elige un estándar y sé constante.',
    ),
  ],
  pairs: const [
    MapEntry('ascensor (UK)', 'lift'),
    MapEntry('ascensor (US)', 'elevator'),
    MapEntry('piso / apartamento (UK)', 'flat'),
    MapEntry('apartamento (US)', 'apartment'),
    MapEntry('otoño (UK)', 'autumn'),
    MapEntry('otoño (US)', 'fall'),
    MapEntry('patatas fritas de bolsa (UK)', 'crisps'),
    MapEntry('metro (UK)', 'underground'),
    MapEntry('metro (US)', 'subway'),
    MapEntry('vacaciones (UK)', 'holiday'),
    MapEntry('vacaciones (US)', 'vacation'),
    MapEntry('gasolina (UK)', 'petrol'),
  ],
);

final QuizContent esEnB22ReadEmail = esEnRead(
  id: 'es_en_b2_2_read_email',
  title: 'Lectura: The misunderstood email',
  passageTitle: 'The misunderstood email',
  passage:
      "Mateo's boss told him on Friday that the project deadline had been "
      "moved. Mateo understood that it had been moved back a week, so he "
      "put off the final tests and spent the weekend catching up on sleep. "
      "On Monday, his colleague asked him if he had sent the report. \"You "
      "knew the deadline was today, didn't you?\" she said. It turned out "
      "that \"moved up\" and \"moved back\" are not the same thing at all. "
      "Mateo wishes he had asked one simple question on Friday. Now he "
      "tells this story to every new colleague: if a message can be "
      "understood in two ways, it will be.",
  passageTranslation:
      'El jefe de Mateo le dijo el viernes que la fecha límite del proyecto '
      'se había movido. Mateo entendió que se había retrasado una semana, '
      'así que aplazó las pruebas finales y pasó el fin de semana '
      'recuperando sueño. El lunes su compañera le preguntó si había '
      'enviado el informe. «Sabías que la fecha era hoy, ¿no?», dijo. '
      'Resultó que "moved up" (adelantar) y "moved back" (retrasar) no son '
      'lo mismo en absoluto. Mateo desearía haber hecho una simple '
      'pregunta el viernes. Ahora cuenta esta historia a cada compañero '
      'nuevo: si un mensaje puede entenderse de dos maneras, se entenderá '
      'mal.',
  intro: 'Un malentendido de oficina construido con estilo indirecto, tags '
      'y wish.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pregunta antes de asumir',
      text: 'La moraleja lingüística: move up = adelantar, move back = '
          'retrasar. Los phrasal verbs opuestos son trampas reales.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What did Mateo understand about the deadline?',
      options: [
        'It had been moved back a week',
        'It had been cancelled',
        'It was on Friday',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué entendió Mateo sobre la fecha límite?',
    ),
    ReadingQuestion(
      question: 'What does Mateo wish?',
      options: [
        'That he had asked a question on Friday',
        'That he had slept more',
        'That he had a new boss',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué desearía Mateo?',
    ),
    ReadingQuestion(
      question: 'What lesson does he share with new colleagues?',
      options: [
        'Never work on weekends',
        'Ambiguous messages will be misunderstood',
        'Deadlines never move',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué lección comparte con los nuevos compañeros?',
    ),
  ],
);

final QuizContent esEnB22SpeakSoften = esEnSpeak(
  id: 'es_en_b2_2_speak_soften',
  title: 'A hablar: suavizar el mensaje',
  intro: 'El inglés adulto pide las cosas en curvas: could, would, do you '
      'mind. Escucha la entonación diplomática y repítela.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La curva importa',
      text: 'Could you…? con subida final suena amable; en plano suena a '
          'orden. La melodía ES parte de la cortesía inglesa (⚑S10).',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Podrías mandarme el informe?', answer: 'Could you send me the report?'),
    CourseItem(prompt: '¿Te importaría abrir la ventana?', answer: 'Would you mind opening the window?'),
    CourseItem(prompt: 'Me preguntaba si podrías ayudarme.', answer: 'I was wondering if you could help me.'),
    CourseItem(prompt: '¿Sería posible cambiar la fecha?', answer: 'Would it be possible to change the date?'),
    CourseItem(prompt: 'Preferiría no hacerlo hoy.', answer: "I'd rather not do it today."),
    CourseItem(prompt: 'Quizá podríamos vernos el jueves.', answer: 'Perhaps we could meet on Thursday.'),
    CourseItem(prompt: 'Perdona que te moleste…', answer: 'Sorry to bother you…'),
    CourseItem(prompt: 'No estoy del todo seguro de eso.', answer: "I'm not entirely sure about that."),
  ],
);

final QuizContent esEnB22Dict = esEnDict(
  id: 'es_en_b2_2_dict',
  title: 'Dictado: mensajes y matices',
  intro: 'Escucha y escribe: estilo indirecto, tags y wish. Frases más '
      'largas: retén el principio mientras llega el final.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Divide y vencerás',
      text: 'En frases largas, escribe la primera mitad de memoria y '
          'reproduce otra vez para la segunda. Es entrenamiento, no examen.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ella dijo que llegaría tarde.', answer: 'She said she would be late.'),
    CourseItem(prompt: 'Me preguntó si había terminado.', answer: 'He asked me if I had finished.'),
    CourseItem(prompt: 'Hace frío hoy, ¿verdad?', answer: 'It is cold today, isn\'t it?'),
    CourseItem(prompt: 'Ojalá tuviera más tiempo libre.', answer: 'I wish I had more free time.'),
    CourseItem(prompt: 'Me dijeron que el tren se había cancelado.', answer: 'I was told that the train had been cancelled.'),
    CourseItem(prompt: 'Nos quedamos sin leche.', answer: 'We ran out of milk.'),
    CourseItem(prompt: 'Ella me pidió que cerrara la ventana.', answer: 'She asked me to close the window.'),
    CourseItem(prompt: 'No puedo soportar este ruido.', answer: 'I cannot put up with this noise.'),
    CourseItem(prompt: 'Resultó ser una buena idea.', answer: 'It turned out to be a good idea.'),
    CourseItem(prompt: 'Ojalá no hubiera vendido mi bici.', answer: 'I wish I had not sold my bike.'),
    CourseItem(prompt: 'Él dijo que había vivido en Roma.', answer: 'He said he had lived in Rome.'),
    CourseItem(prompt: 'Viste el partido, ¿no?', answer: 'You watched the match, didn\'t you?'),
    CourseItem(prompt: 'Cometí un error en el informe.', answer: 'I made a mistake in the report.'),
    CourseItem(prompt: 'Me dijo que no me preocupara.', answer: 'She told me not to worry.'),
    CourseItem(prompt: 'Aplazaron la reunión otra vez.', answer: 'They put off the meeting again.'),
  ],
);

final QuizContent esEnB22BigText = esEnBigText(
  id: 'es_en_b2_2_bigtext',
  title: 'Texto: The message chain',
  passageTitle: 'The message chain',
  intro: 'Completa: estilo indirecto, say/tell, tags, wish y phrasal verbs.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Sigue la cadena',
      text: 'Cada personaje reporta al anterior: vigila el retroceso de '
          'tiempos en cada eslabón.',
    ),
  ],
  template:
      'On Monday Emma {{0}} her team that the client wanted changes. Tom '
      'understood that the client {{1}} unhappy, so he told Daniel that '
      'they {{2}} have to redo the design. Daniel {{3}} that it was '
      'impossible — they had run {{4}} of time. "You spoke to the client '
      'yourself, {{5}} you?" he asked Emma. "Well, no. Her assistant told '
      'me she {{6}} seen the drafts," Emma admitted. In the end, the '
      'client loved the design and had only asked them {{7}} change one '
      'colour. "I wish people {{8}} check the original message," Daniel '
      'sighed, "before a small comment {{9}} into a crisis."',
  blanks: [
    inputBlank('told'),
    inputBlank('was'),
    inputBlank('would'),
    inputBlank('said'),
    inputBlank('out'),
    inputBlank("didn't"),
    inputBlank('had'),
    inputBlank('to'),
    inputBlank('would'),
    inputBlank('turns', accepted: ['grows']),
  ],
  passageTranslation:
      'El lunes Emma le dijo a su equipo que el cliente quería cambios. Tom '
      'entendió que el cliente estaba descontento, así que le dijo a Daniel '
      'que tendrían que rehacer el diseño. Daniel dijo que era imposible: '
      'se habían quedado sin tiempo. «Hablaste tú misma con la clienta, '
      '¿no?», le preguntó a Emma. «Pues no. Su asistente me dijo que había '
      'visto los borradores», admitió Emma. Al final, a la clienta le '
      'encantó el diseño y solo les había pedido cambiar un color. «Ojalá '
      'la gente comprobara el mensaje original», suspiró Daniel, «antes de '
      'que un comentario pequeño se convierta en una crisis.»',
);

final QuizContent esEnB22SpeakingClose = esEnSpeaking(
  id: 'es_en_b2_2_speaking_close',
  title: 'Conversación final: contar y matizar',
  level: 'B2.2',
  topic: 'A long conversation where you retell things: a conversation you '
      'had recently, advice you were given as a child, a regret (wish), '
      'and a misunderstanding that turned out fine.',
  practisePoints: [
    'Reported speech with clean backshift',
    'wish / if only for regrets',
    'Question tags to keep the conversation alive',
    'Phrasal verbs from both batches',
  ],
  scoringCriteria: [
    'Reported structures accurate',
    'Regrets formed with wish + past / had + participle',
    'Conversation flows with tags and softeners',
  ],
  targetVocabulary: [
    'told', 'would', 'wish', 'turn out', 'put off', 'sort out',
  ],
  priorityErrors: [
    'said/told confusion',
    'no backshift',
    'tags with the wrong auxiliary',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo B2.2 — y del nivel B. Reconta, matiza y '
      'lamenta con estilo. Copia, habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El truco del tag',
      text: 'Cierra tus frases con un tag de vez en cuando (…, wasn\'t '
          'it?): mantiene al interlocutor dentro y suena muy natural.',
    ),
  ],
);

/// B2.2 in chain order.
final List<QuizContent> esEnB2_2 = [
  esEnB22Reported,
  esEnB22SayTell,
  esEnB22Tags,
  esEnB22Wish,
  esEnB22Phrasals2,
  esEnB22ListenPodcast,
  esEnB22SpeakingMid,
  esEnB22UsUk,
  esEnB22ReadEmail,
  esEnB22SpeakSoften,
  esEnB22Dict,
  esEnB22BigText,
  esEnB22SpeakingClose,
];
