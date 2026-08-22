import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// B2.2 — Nuance & reporting. English → Spanish.
///
/// Big rocks: reported speech and its tense shifts, subjunctive vs
/// indicative triggers side by side, the future and conditional of
/// probability (⚑E21), false friends (⚑E25) and regional variation (⚑E28).

final QuizContent enEsB22Reported = enEsFill(
  id: 'en_es_b2_2_reported',
  title: 'Reported speech: dijo que…',
  intro: 'Reporting shifts the tense back: «Estoy cansada» → Dijo que '
      'estaba cansada. «Vendré» → Dijo que vendría. Same music as '
      'English backshift.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The shifts',
      text: 'presente → imperfecto · pretérito → pluscuamperfecto · '
          'futuro → condicional · imperativo → imperfect subjunctive '
          '(que viniera).',
    ),
  ],
  items: const [
    CourseItem(prompt: '"I am tired" → She said she was tired.', answer: 'Dijo que **estaba** cansada.'),
    CourseItem(prompt: '"I will call you" → He said he would call me.', answer: 'Dijo que me **llamaría**.'),
    CourseItem(prompt: '"I live here" → She said she lived there.', answer: 'Dijo que **vivía** allí.'),
    CourseItem(prompt: '"I saw the film" → He said he had seen the film.', answer: 'Dijo que **había** visto la película.'),
    CourseItem(prompt: '"Come!" → She told me to come. (venir)', answer: 'Me dijo que **viniera**.'),
    CourseItem(prompt: '"I can help" → He said he could help.', answer: 'Dijo que **podía** ayudar.'),
    CourseItem(prompt: '"Don\'t be late" → She told me not to be late.', answer: 'Me dijo que no **llegara** tarde.'),
    CourseItem(prompt: 'Where do you live? → She asked me where I lived.', answer: 'Me preguntó dónde **vivía**.'),
    CourseItem(prompt: 'Are you OK? → He asked me if I was OK.', answer: 'Me preguntó **si** estaba bien.'),
    CourseItem(prompt: '"I have finished" → She said she had finished.', answer: 'Dijo que **había** terminado.'),
    CourseItem(prompt: '"Wait for me" → He asked me to wait for him. (esperar)', answer: 'Me pidió que lo **esperara**.'),
    CourseItem(prompt: '"It will rain" → They said it would rain.', answer: 'Dijeron que **llovería**.'),
    CourseItem(prompt: '"Help me!" → She asked me to help her. (ayudar)', answer: 'Me pidió que la **ayudara**.'),
    CourseItem(prompt: '"I don\'t know" → He admitted he didn\'t know.', answer: 'Admitió que no lo **sabía**.'),
    CourseItem(prompt: '"We did it" → They said they had done it.', answer: 'Dijeron que lo **habían** hecho.'),
  ],
);

final QuizContent enEsB22MoodDuel = enEsFill(
  id: 'en_es_b2_2_mood_duel',
  title: 'Mood duel: indicative or subjunctive?',
  intro: 'The same connector, two moods, two meanings: cuando llega '
      '(habit) vs cuando llegue (future); aunque es caro (it is) vs '
      'aunque sea caro (even if).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'cuando + future = subjunctive',
      text: 'Cuando llegues, llámame — future events after cuando take '
          'the subjunctive. "Cuando llegarás" ✗ is the giveaway error.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'When you arrive (tomorrow), call me. (tú)', answer: 'Cuando **llegues**, llámame.'),
    CourseItem(prompt: 'When he arrives (every day), we have coffee.', answer: 'Cuando **llega**, tomamos café.'),
    CourseItem(prompt: 'Although it IS expensive, I\'ll buy it.', answer: 'Aunque **es** caro, lo compraré.'),
    CourseItem(prompt: 'Even if it may be expensive, I\'ll buy it.', answer: 'Aunque **sea** caro, lo compraré.'),
    CourseItem(prompt: 'I\'ll wait until you finish. (tú)', answer: 'Esperaré hasta que **termines**.'),
    CourseItem(prompt: 'Before you leave, close the window. (tú, irse)', answer: 'Antes de que te **vayas**, cierra la ventana.'),
    CourseItem(prompt: 'I\'ll lend it to you so that you read it. (tú)', answer: 'Te lo presto para que lo **leas**.'),
    CourseItem(prompt: 'As soon as I know, I\'ll tell you. (saber)', answer: 'En cuanto lo **sepa**, te lo digo.'),
    CourseItem(prompt: 'I\'m looking for someone who speaks Chinese. (unknown!)', answer: 'Busco a alguien que **hable** chino.'),
    CourseItem(prompt: 'I know someone who speaks Chinese. (known)', answer: 'Conozco a alguien que **habla** chino.'),
    CourseItem(prompt: 'There is nobody who knows it. (saber)', answer: 'No hay nadie que lo **sepa**.'),
    CourseItem(prompt: 'When I have money, I\'ll travel. (tener)', answer: 'Cuando **tenga** dinero, viajaré.'),
    CourseItem(prompt: 'Unless it rains, we\'ll go. (a menos que)', answer: 'A menos que **llueva**, iremos.'),
    CourseItem(prompt: 'While there is life, there is hope. (haber, general)', answer: 'Mientras **hay** vida, hay esperanza.'),
    CourseItem(prompt: 'Whatever happens, stay calm. (pasar)', answer: 'Pase lo que **pase**, mantén la calma.'),
  ],
);

final QuizContent enEsB22Probability = enEsFill(
  id: 'en_es_b2_2_probability',
  title: 'Guessing with the future: será, estará',
  intro: 'Spanish guesses with the future tense (⚑E21): ¿Qué hora será? '
      '= I wonder what time it is. Estará en casa = he\'s probably home. '
      'Past guesses use the conditional: serían las diez.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The wondering future',
      text: 'Hear a future where no future makes sense? It\'s a guess: '
          'Tendrá unos treinta años = he must be about thirty.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I wonder what time it is.', answer: '¿Qué hora **será**?'),
    CourseItem(prompt: 'He\'s probably at home.', answer: '**Estará** en casa.'),
    CourseItem(prompt: 'She must be about thirty.', answer: '**Tendrá** unos treinta años.'),
    CourseItem(prompt: 'Who could it be? (at the door)', answer: '¿Quién **será**?'),
    CourseItem(prompt: 'It was probably ten o\'clock. (conditional)', answer: '**Serían** las diez.'),
    CourseItem(prompt: 'They\'re probably sleeping.', answer: '**Estarán** durmiendo.'),
    CourseItem(prompt: 'It probably costs a fortune.', answer: '**Costará** una fortuna.'),
    CourseItem(prompt: 'He was probably tired. (conditional)', answer: '**Estaría** cansado.'),
    CourseItem(prompt: 'I wonder where my keys are.', answer: '¿Dónde **estarán** mis llaves?'),
    CourseItem(prompt: 'She probably knows the answer.', answer: '**Sabrá** la respuesta.'),
    CourseItem(prompt: 'It\'s probably about five kilometres.', answer: '**Serán** unos cinco kilómetros.'),
    CourseItem(prompt: 'He probably missed the bus. (perder, past guess)', answer: '**Perdería** el autobús.'),
    CourseItem(prompt: 'I wonder why she said that.', answer: '¿Por qué lo **diría**?'),
    CourseItem(prompt: 'You must be hungry. (tú)', answer: '**Tendrás** hambre.'),
    CourseItem(prompt: 'There are probably a hundred people.', answer: '**Habrá** unas cien personas.'),
  ],
);

final QuizContent enEsB22FalseFriends = enEsVocab(
  id: 'en_es_b2_2_false_friends',
  title: 'False friends · Falsos amigos',
  intro: 'The words that look English and betray you (⚑E25). Learn the '
      'pairs, dodge the embarrassment — or rather, la vergüenza.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'The deadly trio',
      text: 'embarazada = pregnant (embarrassed = avergonzado) · '
          'actualmente = currently · realizar = to carry out (realise = '
          'darse cuenta).',
    ),
  ],
  pairs: const [
    MapEntry('pregnant', 'embarazada'),
    MapEntry('embarrassed', 'avergonzado'),
    MapEntry('currently', 'actualmente'),
    MapEntry('actually', 'en realidad'),
    MapEntry('to carry out', 'realizar'),
    MapEntry('to realise', 'darse cuenta'),
    MapEntry('to attend', 'asistir a'),
    MapEntry('to assist / help', 'ayudar'),
    MapEntry('success', 'el éxito'),
    MapEntry('exit', 'la salida'),
    MapEntry('folder', 'la carpeta'),
    MapEntry('carpet', 'la alfombra'),
  ],
);

final QuizContent enEsB22Regional = enEsVocab(
  id: 'en_es_b2_2_regional',
  title: 'One language, many voices',
  intro: 'Spain vs Latin America: same language, different everyday '
      'words (⚑E28). Learn to recognise both columns.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'vosotros vs ustedes',
      text: 'Spain: vosotros habláis (informal plural). Latin America: '
          'ustedes hablan for everyone. Both correct; pick one, '
          'recognise both. And in Argentina, vos sos = tú eres.',
    ),
  ],
  pairs: const [
    MapEntry('car (Spain)', 'el coche'),
    MapEntry('car (LatAm)', 'el carro'),
    MapEntry('computer (Spain)', 'el ordenador'),
    MapEntry('computer (LatAm)', 'la computadora'),
    MapEntry('mobile phone (Spain)', 'el móvil'),
    MapEntry('cell phone (LatAm)', 'el celular'),
    MapEntry('juice (Spain)', 'el zumo'),
    MapEntry('juice (LatAm)', 'el jugo'),
    MapEntry('to drive (Spain)', 'conducir'),
    MapEntry('to drive (LatAm)', 'manejar'),
    MapEntry('cool / great (Spain)', 'genial'),
    MapEntry('cool / great (Mexico)', 'padre'),
  ],
);

final QuizContent enEsB22ListenVoicemail = enEsListen(
  id: 'en_es_b2_2_listen_voicemail',
  title: 'Listening: El mensaje de voz',
  passageTitle: 'Tres mensajes',
  passage:
      'Mensaje uno: «Hola, soy Carmen. Te llamé ayer pero no '
      'contestaste. Estarás ocupadísima. Llámame cuando puedas, es sobre '
      'la cena del sábado.» Mensaje dos: «Buenas tardes, le llamamos de '
      'la clínica dental. La doctora dijo que viniera el jueves en lugar '
      'del martes. Confirme, por favor.» Mensaje tres: «¡Emma! Me dijo '
      'Nico que habías conseguido el trabajo. ¡Enhorabuena! Sabía que lo '
      'conseguirías. Cuando lo celebres, avísame — pago yo.»',
  passageTranslation:
      'Message one: "Hi, it\'s Carmen. I called you yesterday but you '
      'didn\'t answer. You must be really busy. Call me when you can, '
      'it\'s about Saturday\'s dinner." Message two: "Good afternoon, '
      'we\'re calling from the dental clinic. The doctor said to come on '
      'Thursday instead of Tuesday. Please confirm." Message three: '
      '"Emma! Nico told me you had got the job. Congratulations! I knew '
      'you would get it. When you celebrate, let me know — I\'m paying."',
  intro: 'Three voicemails: probability futures, reported speech and '
      'cuando + subjunctive, straight from real life.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Estarás ocupadísima',
      text: 'A wondering future ("you must be busy") in the wild — plus '
          'dijo que viniera and cuando puedas. The module, on your phone.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Sobre qué llama Carmen?',
      options: [
        'Sobre la cena del sábado',
        'Sobre el trabajo',
        'Sobre el dentista',
      ],
      correctIndex: 0,
      questionTranslation: 'What is Carmen calling about?',
    ),
    ReadingQuestion(
      question: '¿Qué dijo la doctora?',
      options: [
        'Que viniera el jueves',
        'Que viniera el martes',
        'Que no viniera',
      ],
      correctIndex: 0,
      questionTranslation: 'What did the doctor say?',
    ),
    ReadingQuestion(
      question: '¿Qué había conseguido Emma?',
      options: ['Un coche', 'El trabajo', 'Una casa'],
      correctIndex: 1,
      questionTranslation: 'What had Emma got?',
    ),
  ],
);

final QuizContent enEsB22SpeakingMid = enEsSpeaking(
  id: 'en_es_b2_2_speaking_mid',
  title: 'Conversation: they told me that…',
  level: 'B2.2',
  topic: 'Gossip and messages, in Spanish: advice people have given you, '
      'things your family used to tell you, and a recent piece of news '
      'someone told you — all reported.',
  practisePoints: [
    'dijo que + shifted tense',
    'me pidió que + past subjunctive',
    'Guessing about the speakers: estaría cansado, tendría prisa',
  ],
  scoringCriteria: [
    'Tense shifts consistent',
    'Requests reported with -ra forms',
    'Natural connectors between reported items',
  ],
  priorityErrors: [
    'unshifted tenses after dijo que',
    'infinitive instead of subjunctive after pedir que',
    'decir/pedir confused',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: retell what others said, in Spanish. Copy, speak, '
      'bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Your ammunition',
      text: 'Mi abuela siempre me decía que… / Un amigo me dijo que '
          'vendría… Prepare three memories before you start.',
    ),
  ],
);

final QuizContent enEsB22ReadEmail = enEsRead(
  id: 'en_es_b2_2_read_email',
  title: 'Reading: El malentendido',
  passageTitle: 'El malentendido',
  passage:
      'El viernes, el jefe de Mateo le dijo que la fecha de entrega se '
      'había movido. Mateo entendió que tendría una semana más, así que '
      'dejó las pruebas finales para el lunes y pasó el fin de semana '
      'descansando. El lunes, su compañera le preguntó si había enviado '
      'el informe. «Sabías que la fecha era hoy, ¿no?», le dijo. Resulta '
      'que «adelantar» y «aplazar» no son lo mismo. Mateo se dio cuenta '
      'de su error demasiado tarde y le pidió al jefe que le diera un '
      'día más. «Te lo doy», respondió el jefe, «pero la próxima vez, '
      'cuando algo no esté claro, pregunta». Actualmente, Mateo tiene '
      'una regla de oro: si un mensaje puede entenderse de dos maneras, '
      'pregunta — aunque parezca una pregunta tonta.',
  passageTranslation:
      'On Friday, Mateo\'s boss told him the deadline had been moved. '
      'Mateo understood he would have one more week, so he left the '
      'final tests for Monday and spent the weekend resting. On Monday, '
      'his colleague asked him if he had sent the report. "You knew the '
      'deadline was today, right?" she said. It turns out that "to move '
      'up" and "to postpone" are not the same thing. Mateo realised his '
      'mistake too late and asked his boss to give him one more day. '
      '"You\'ve got it," the boss replied, "but next time, when '
      'something isn\'t clear, ask." Currently, Mateo has a golden rule: '
      'if a message can be understood two ways, ask — even if it seems '
      'a silly question.',
  intro: 'An office misunderstanding told through reported speech, mood '
      'switches and two false friends used correctly.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'darse cuenta ≠ realizar',
      text: 'se dio cuenta de su error = he realised his mistake. '
          'realizar would mean he "carried out" the mistake — a very '
          'different Monday.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué entendió Mateo?',
      options: [
        'Que tendría una semana más',
        'Que la fecha era el lunes',
        'Que no había informe',
      ],
      correctIndex: 0,
      questionTranslation: 'What did Mateo understand?',
    ),
    ReadingQuestion(
      question: '¿Qué le pidió Mateo al jefe?',
      options: [
        'Que le diera un día más',
        'Que cambiara el proyecto',
        'Que despidiera a su compañera',
      ],
      correctIndex: 0,
      questionTranslation: 'What did Mateo ask his boss?',
    ),
    ReadingQuestion(
      question: '¿Cuál es la regla de oro de Mateo ahora?',
      options: [
        'Trabajar los fines de semana',
        'Preguntar cuando algo no esté claro',
        'No leer los mensajes',
      ],
      correctIndex: 1,
      questionTranslation: 'What is Mateo\'s golden rule now?',
    ),
  ],
);

final QuizContent enEsB22SpeakSoften = enEsSpeak(
  id: 'en_es_b2_2_speak_soften',
  title: 'Speak: softening the message',
  intro: 'Adult Spanish asks in curves: podrías, me gustaría, ¿te '
      'importaría? Listen to the diplomatic melody and copy it.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The conditional is courtesy',
      text: '¿Podrías…? ¿Te importaría…? Querría… — the conditional '
          'tense IS the Spanish "please" beyond por favor.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Could you send me the report?', answer: '¿Podrías mandarme el informe?'),
    CourseItem(prompt: 'Would you mind opening the window?', answer: '¿Te importaría abrir la ventana?'),
    CourseItem(prompt: 'I was wondering if you could help me.', answer: 'Me preguntaba si podrías ayudarme.'),
    CourseItem(prompt: 'Would it be possible to change the date?', answer: '¿Sería posible cambiar la fecha?'),
    CourseItem(prompt: 'I\'d rather not do it today.', answer: 'Preferiría no hacerlo hoy.'),
    CourseItem(prompt: 'Perhaps we could meet on Thursday.', answer: 'Quizá podríamos vernos el jueves.'),
    CourseItem(prompt: 'Sorry to bother you…', answer: 'Perdona que te moleste…'),
    CourseItem(prompt: 'I\'m not entirely sure about that.', answer: 'No estoy del todo seguro de eso.'),
  ],
);

final QuizContent enEsB22Dict = enEsDict(
  id: 'en_es_b2_2_dict',
  title: 'Dictation: messages and nuance',
  intro: 'Longer sentences: reported speech, probability futures and '
      'mood switches at natural speed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Divide and conquer',
      text: 'Hold the first half in memory, replay for the second. '
          'Training, not exam.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'She said she would arrive late.', answer: 'Dijo que llegaría tarde.'),
    CourseItem(prompt: 'He asked me if I had finished.', answer: 'Me preguntó si había terminado.'),
    CourseItem(prompt: 'She asked me to wait for her.', answer: 'Me pidió que la esperara.'),
    CourseItem(prompt: 'Call me when you can.', answer: 'Llámame cuando puedas.'),
    CourseItem(prompt: 'You must be very busy.', answer: 'Estarás muy ocupado.'),
    CourseItem(prompt: 'Although it may be expensive, I\'ll buy it.', answer: 'Aunque sea caro, lo compraré.'),
    CourseItem(prompt: 'I realised my mistake.', answer: 'Me di cuenta de mi error.'),
    CourseItem(prompt: 'It was probably ten o\'clock.', answer: 'Serían las diez.'),
    CourseItem(prompt: 'I\'m looking for someone who speaks German.', answer: 'Busco a alguien que hable alemán.'),
    CourseItem(prompt: 'They told me not to worry.', answer: 'Me dijeron que no me preocupara.'),
    CourseItem(prompt: 'As soon as I know, I\'ll tell you.', answer: 'En cuanto lo sepa, te lo diré.'),
    CourseItem(prompt: 'Currently I work from home.', answer: 'Actualmente trabajo desde casa.'),
    CourseItem(prompt: 'Whatever happens, stay calm.', answer: 'Pase lo que pase, mantén la calma.'),
    CourseItem(prompt: 'I knew you would get it.', answer: 'Sabía que lo conseguirías.'),
    CourseItem(prompt: 'Could you repeat that, please?', answer: '¿Podrías repetirlo, por favor?'),
  ],
);

final QuizContent enEsB22BigText = enEsBigText(
  id: 'en_es_b2_2_bigtext',
  title: 'Big text: La cadena de mensajes',
  passageTitle: 'La cadena de mensajes',
  intro: 'Complete the message chain: reported speech, mood duels and a '
      'probability future.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Follow the chain',
      text: 'Each character reports the previous one: watch the tense '
          'shift at every link.',
    ),
  ],
  template:
      'El lunes Emma le {{0}} a su equipo que la clienta quería cambios. '
      'Tom entendió que la clienta {{1}} descontenta y le dijo a Daniel '
      'que {{2}} que rehacer el diseño. Daniel dijo que era imposible: '
      'no {{3}} tiempo. «Hablaste tú misma con ella, ¿no?», preguntó. '
      '«Pues no. Su asistente me dijo que la clienta {{4}} visto los '
      'borradores», admitió Emma. «{{5}} ocupada, como siempre». Al '
      'final, resulta que a la clienta le encantaba el diseño y solo '
      'había pedido que {{6}} un color. «La próxima vez», suspiró '
      'Daniel, «cuando alguien os {{7}} un mensaje confuso, preguntad '
      '— {{8}} que parezca una tontería. Lo que hoy es un comentario, '
      'mañana {{9}} una crisis».',
  blanks: [
    inputBlank('dijo'),
    inputBlank('estaba'),
    inputBlank('tendrían', accepted: ['tenían']),
    inputBlank('había', accepted: ['quedaba']),
    inputBlank('había'),
    inputBlank('Estaría'),
    inputBlank('cambiaran', accepted: ['cambiara']),
    inputBlank('mande', accepted: ['envíe', 'escriba']),
    inputBlank('aunque'),
    inputBlank('será'),
  ],
  passageTranslation:
      'On Monday Emma told her team that the client wanted changes. Tom '
      'understood the client was unhappy and told Daniel they would '
      'have to redo the design. Daniel said it was impossible: there '
      'was no time. "You spoke to her yourself, right?" he asked. '
      '"Well, no. Her assistant told me the client had seen the '
      'drafts," Emma admitted. "She was probably busy, as always." In '
      'the end, it turns out the client loved the design and had only '
      'asked them to change one colour. "Next time," Daniel sighed, '
      '"when someone sends you a confusing message, ask — even if it '
      'seems silly. What is a comment today will be a crisis tomorrow."',
);

final QuizContent enEsB22SpeakingClose = enEsSpeaking(
  id: 'en_es_b2_2_speaking_close',
  title: 'Final conversation: retell and refine',
  level: 'B2.2',
  topic: 'A long conversation in Spanish where you retell things: a '
      'recent conversation, advice from your childhood, a '
      'misunderstanding that ended well — plus guesses about why people '
      'acted as they did.',
  practisePoints: [
    'Clean reported speech with shifted tenses',
    'me pidió que + past subjunctive',
    'Probability futures and conditionals: estaría, será',
    'Softened requests in conversation',
  ],
  scoringCriteria: [
    'Reported structures accurate',
    'Mood choices right after cuando/aunque',
    'Courteous conditional used naturally',
  ],
  targetVocabulary: [
    'dijo que', 'me pidió que', 'cuando pueda', 'estaría', 'en realidad',
  ],
  priorityErrors: [
    'unshifted reported tenses',
    'indicative after antes de que / para que',
    'false friends: actualmente, realizar, embarazada',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module B2.2 closer — the end of the B levels. Retell, refine, '
      'guess. Copy, speak, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The reporter\'s rhythm',
      text: 'Me dijo que…, así que…, y resulta que… — chain your report '
          'with those three and it will flow like a native\'s.',
    ),
  ],
);

/// B2.2 in chain order.
final List<QuizContent> enEsB2_2 = [
  enEsB22Reported,
  enEsB22MoodDuel,
  enEsB22Probability,
  enEsB22FalseFriends,
  enEsB22Regional,
  enEsB22ListenVoicemail,
  enEsB22SpeakingMid,
  enEsB22ReadEmail,
  enEsB22SpeakSoften,
  enEsB22Dict,
  enEsB22BigText,
  enEsB22SpeakingClose,
];
