import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// B1.2 — Stories & conditions. English → Spanish.
///
/// Big rocks: preterite/imperfect mastery in longer narration, the past
/// perfect (había hecho), realistic si-clauses, se-constructions (⚑E23),
/// double object pronouns (se lo), and narration connectors.

final QuizContent enEsB12PastPerfect = enEsFill(
  id: 'en_es_b1_2_past_perfect',
  title: 'The past perfect: había hecho',
  intro: 'The past before the past: Cuando llegué, el tren ya había '
      'salido = when I arrived, the train had already left. había + '
      'participle.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The irregular participles',
      text: 'hecho (hacer), visto (ver), dicho (decir), escrito '
          '(escribir), puesto (poner), vuelto (volver), abierto (abrir), '
          'roto (romper).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The train had already left.', answer: 'El tren ya **había** salido.'),
    CourseItem(prompt: 'I had never seen the sea.', answer: 'Nunca **había** visto el mar.'),
    CourseItem(prompt: 'She had done everything. (hacer)', answer: 'Lo había **hecho** todo.'),
    CourseItem(prompt: 'We had eaten before.', answer: '**Habíamos** comido antes.'),
    CourseItem(prompt: 'They had already gone. (irse)', answer: 'Ya se **habían** ido.'),
    CourseItem(prompt: 'He had written the letter. (escribir)', answer: 'Había **escrito** la carta.'),
    CourseItem(prompt: 'I had forgotten the keys. (olvidar)', answer: '**Había** olvidado las llaves.'),
    CourseItem(prompt: 'Someone had opened the window. (abrir)', answer: 'Alguien había **abierto** la ventana.'),
    CourseItem(prompt: 'She had put everything in place. (poner)', answer: 'Había **puesto** todo en su sitio.'),
    CourseItem(prompt: 'We had never spoken of it.', answer: 'Nunca **habíamos** hablado de eso.'),
    CourseItem(prompt: 'The glass had broken. (romperse)', answer: 'El vaso se había **roto**.'),
    CourseItem(prompt: 'They had said the opposite. (decir)', answer: 'Habían **dicho** lo contrario.'),
    CourseItem(prompt: 'He had returned before ten. (volver)', answer: 'Había **vuelto** antes de las diez.'),
    CourseItem(prompt: 'When you called, I had already left home.', answer: 'Cuando llamaste, ya **había** salido de casa.'),
    CourseItem(prompt: 'I had seen that film. (ver)', answer: 'Había **visto** esa película.'),
  ],
);

final QuizContent enEsB12SiClauses = enEsFill(
  id: 'en_es_b1_2_si_clauses',
  title: 'Realistic si: si llueve, me quedo',
  intro: 'Real conditions use the indicative: si + present, present or '
      'future. Si llueve, nos quedamos en casa. No subjunctive after '
      'realistic si!',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'si + present = indicative',
      text: '"Si llueva" ✗ — realistic si never takes present '
          'subjunctive. Si llueve ✓. (The past subjunctive si comes at '
          'B2.)',
    ),
  ],
  items: const [
    CourseItem(prompt: 'If it rains, we\'ll stay home.', answer: 'Si **llueve**, nos quedamos en casa.'),
    CourseItem(prompt: 'If you study, you\'ll pass. (tú)', answer: 'Si **estudias**, aprobarás.'),
    CourseItem(prompt: 'If I have time, I\'ll help you.', answer: 'Si **tengo** tiempo, te ayudo.'),
    CourseItem(prompt: 'If she comes, tell me. (venir)', answer: 'Si **viene**, dímelo.'),
    CourseItem(prompt: 'We\'ll go to the beach if it\'s sunny.', answer: 'Iremos a la playa si **hace** sol.'),
    CourseItem(prompt: 'If you don\'t hurry, we\'ll be late. (tú)', answer: 'Si no te **das** prisa, llegaremos tarde.'),
    CourseItem(prompt: 'If you eat that, you\'ll feel ill. (tú)', answer: 'Si **comes** eso, te sentirás mal.'),
    CourseItem(prompt: 'If there\'s no bread, buy rice. (haber)', answer: 'Si no **hay** pan, compra arroz.'),
    CourseItem(prompt: 'If he calls, I\'m not here!', answer: 'Si **llama**, ¡no estoy!'),
    CourseItem(prompt: 'If you want, we can go out. (tú)', answer: 'Si **quieres**, podemos salir.'),
    CourseItem(prompt: 'If I finish early, I\'ll call you.', answer: 'Si **termino** temprano, te llamo.'),
    CourseItem(prompt: 'If the shop is open, I\'ll buy milk.', answer: 'Si la tienda **está** abierta, compro leche.'),
    CourseItem(prompt: 'If they don\'t come, we\'ll start without them.', answer: 'Si no **vienen**, empezamos sin ellos.'),
    CourseItem(prompt: 'If you ask her, she\'ll say yes. (tú, preguntar)', answer: 'Si le **preguntas**, dirá que sí.'),
    CourseItem(prompt: 'If everything goes well, we\'ll celebrate. (ir)', answer: 'Si todo **va** bien, lo celebraremos.'),
  ],
);

final QuizContent enEsB12Se = enEsFill(
  id: 'en_es_b1_2_se',
  title: 'se: impersonal and accidental',
  intro: 'The magic se (⚑E23): se habla español (impersonal "one"), se '
      'venden casas (passive), and se me olvidó (the famous no-fault '
      'accident).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The no-fault se',
      text: 'Se me olvidó, se me cayó, se me rompió — Spanish blames the '
          'object, not you. "It forgot itself on me."',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Spanish is spoken here.', answer: '**Se** habla español aquí.'),
    CourseItem(prompt: 'Houses for sale. (vender)', answer: '**Se** venden casas.'),
    CourseItem(prompt: 'I forgot the keys. (no-fault)', answer: '**Se** me olvidaron las llaves.'),
    CourseItem(prompt: 'How do you say this in Spanish?', answer: '¿Cómo **se** dice esto en español?'),
    CourseItem(prompt: 'The glass fell (on me). (caer)', answer: '**Se** me cayó el vaso.'),
    CourseItem(prompt: 'One eats well in this city.', answer: '**Se** come bien en esta ciudad.'),
    CourseItem(prompt: 'My phone broke (on me).', answer: '**Se** me rompió el teléfono.'),
    CourseItem(prompt: 'You can\'t smoke here. (poder)', answer: 'No **se** puede fumar aquí.'),
    CourseItem(prompt: 'The door opened. (abrirse)', answer: '**Se** abrió la puerta.'),
    CourseItem(prompt: 'I ran out of time. (acabar)', answer: '**Se** me acabó el tiempo.'),
    CourseItem(prompt: 'English is spoken in many countries.', answer: '**Se** habla inglés en muchos países.'),
    CourseItem(prompt: 'We forgot the bread. (no-fault)', answer: '**Se** nos olvidó el pan.'),
    CourseItem(prompt: 'How is this dish prepared? (preparar)', answer: '¿Cómo **se** prepara este plato?'),
    CourseItem(prompt: 'The lights went out. (apagarse)', answer: '**Se** apagaron las luces.'),
    CourseItem(prompt: 'That is not said. (impersonal)', answer: 'Eso no **se** dice.'),
  ],
);

final QuizContent enEsB12SeLo = enEsFill(
  id: 'en_es_b1_2_se_lo',
  title: 'Two pronouns: se lo di',
  intro: 'Indirect + direct together: me lo, te la, nos los… and the '
      'twist: le/les + lo becomes SE lo. Se lo di = I gave it to '
      'him/her/them (⚑E17).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'le + lo → se lo',
      text: 'Two l-pronouns can\'t touch: "le lo" ✗ → se lo ✓. Order is '
          'always indirect-before-direct.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I gave it to him. (el libro)', answer: '**Se** lo di.'),
    CourseItem(prompt: 'She told it to me. (la verdad)', answer: 'Me **la** dijo.'),
    CourseItem(prompt: 'Can you lend it to me? (tú, el coche)', answer: '¿Me **lo** prestas?'),
    CourseItem(prompt: 'I\'ll send it to you tomorrow. (tú, la foto)', answer: 'Te **la** mando mañana.'),
    CourseItem(prompt: 'We gave them to her. (las flores)', answer: 'Se **las** dimos.'),
    CourseItem(prompt: 'He bought it for us. (el pan)', answer: 'Nos **lo** compró.'),
    CourseItem(prompt: 'Don\'t tell it to them! (tú, el secreto)', answer: '¡No **se** lo digas!'),
    CourseItem(prompt: 'I\'m going to give it to you. (tú, attached)', answer: 'Voy a **dártelo**.'),
    CourseItem(prompt: 'She explained it to me. (la regla)', answer: 'Me **la** explicó.'),
    CourseItem(prompt: 'Bring it to me, please. (tú, el agua)', answer: '**Tráemela**, por favor.'),
    CourseItem(prompt: 'I already told it to you. (tú, eso)', answer: 'Ya te **lo** dije.'),
    CourseItem(prompt: 'They sold it to us. (la casa)', answer: 'Nos **la** vendieron.'),
    CourseItem(prompt: 'I want to show it to you. (tú, el barrio, attached)', answer: 'Quiero **enseñártelo**.'),
    CourseItem(prompt: 'Give it to her! (tú, el regalo)', answer: '¡**Dáselo**!'),
    CourseItem(prompt: 'He didn\'t return it to me. (el dinero)', answer: 'No me **lo** devolvió.'),
  ],
);

final QuizContent enEsB12Connectors = enEsVocab(
  id: 'en_es_b1_2_connectors',
  title: 'Story connectors',
  intro: 'The words that hold a Spanish story together, from the opener '
      'to the punchline.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E25 actualmente ≠ actually',
      text: 'actualmente = currently. "Actually" is en realidad. The '
          'false friend strikes in both languages.',
    ),
  ],
  pairs: const [
    MapEntry('at first', 'al principio'),
    MapEntry('then / afterwards', 'después'),
    MapEntry('while', 'mientras'),
    MapEntry('suddenly', 'de repente'),
    MapEntry('so / therefore', 'así que'),
    MapEntry('however', 'sin embargo'),
    MapEntry('actually / in fact', 'en realidad'),
    MapEntry('currently', 'actualmente'),
    MapEntry('luckily', 'por suerte'),
    MapEntry('unfortunately', 'por desgracia'),
    MapEntry('in the end', 'al final'),
    MapEntry('it turns out that…', 'resulta que…'),
  ],
);

final QuizContent enEsB12ListenAnecdote = enEsListen(
  id: 'en_es_b1_2_listen_anecdote',
  title: 'Listening: La llave perdida',
  passageTitle: 'La llave perdida',
  passage:
      'El viernes pasado me pasó algo increíble. Volvía a casa cansado y, '
      'cuando busqué la llave, no estaba. Se me había caído en algún '
      'sitio. Llamé a mi compañera de piso, pero no contestó. Así que me '
      'senté a esperar en la escalera. Entonces la vecina abrió su puerta '
      'y me dijo: «¿Buscas esto? La encontré en el ascensor esta mañana». '
      '¡Había llevado mi llave en el bolsillo todo el día! Por suerte, '
      'todo acabó bien. Ahora siempre la guardo en el mismo bolsillo.',
  passageTranslation:
      'Last Friday something incredible happened to me. I was coming home '
      'tired and, when I looked for my key, it wasn\'t there. I had '
      'dropped it somewhere. I called my flatmate, but she didn\'t '
      'answer. So I sat down to wait on the stairs. Then the neighbour '
      'opened her door and said: "Looking for this? I found it in the '
      'lift this morning." She had carried my key in her pocket all day! '
      'Luckily, everything ended well. Now I always keep it in the same '
      'pocket.',
  intro: 'A full anecdote: two pasts, a past perfect, a no-fault se and '
      'the connectors in action.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'se me había caído',
      text: 'The no-fault se meets the past perfect: "it had fallen from '
          'me". Spanish stacks its machinery neatly — listen for it.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué había pasado con la llave?',
      options: [
        'Se le había caído',
        'Se la robaron',
        'La dejó en el trabajo',
      ],
      correctIndex: 0,
      questionTranslation: 'What had happened to the key?',
    ),
    ReadingQuestion(
      question: '¿Quién encontró la llave?',
      options: ['Su compañera de piso', 'La vecina', 'El portero'],
      correctIndex: 1,
      questionTranslation: 'Who found the key?',
    ),
    ReadingQuestion(
      question: '¿Dónde la encontró?',
      options: ['En la escalera', 'En el ascensor', 'En la calle'],
      correctIndex: 1,
      questionTranslation: 'Where did she find it?',
    ),
  ],
);

final QuizContent enEsB12SpeakingMid = enEsSpeaking(
  id: 'en_es_b1_2_speaking_mid',
  title: 'Conversation: tell me a story',
  level: 'B1.2',
  topic: 'Tell me a real story from your life in Spanish: something '
      'funny, scary or surprising. I will ask about the details and what '
      'had happened before.',
  practisePoints: [
    'Scene in imperfect, events in preterite',
    'One step further back: ya había…',
    'Connectors: de repente, así que, al final',
  ],
  scoringCriteria: [
    'The two pasts each doing their job',
    'Past perfect used at least once',
    'Story flows with connectors',
  ],
  priorityErrors: [
    'single flat past for everything',
    'present leaking into narration',
    'missing reflexive/object pronouns',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: tell your AI assistant a real anecdote, in '
      'Spanish. Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Rehearse the first line',
      text: 'Era…, estaba…, cuando de repente… Prepare the opening; the '
          'rest rolls on its own.',
    ),
  ],
);

final QuizContent enEsB12ReadStory = enEsRead(
  id: 'en_es_b1_2_read_story',
  title: 'Reading: La maleta equivocada',
  passageTitle: 'La maleta equivocada',
  passage:
      'Cuando Daniel llegó al hotel de Lima, abrió la maleta y se quedó '
      'helado: dentro había vestidos, zapatos de tacón y un sombrero '
      'rojo. ¡Se había llevado la maleta equivocada! En el aeropuerto, '
      'una mujer con una maleta idéntica había recogido la suya. Por '
      'suerte, dentro del sombrero había una tarjeta con un teléfono. La '
      'llamó y resulta que la mujer, una cantante de tango argentina, '
      'estaba en el mismo barrio. Se encontraron en un café, '
      'intercambiaron las maletas y ella le regaló dos entradas para su '
      'concierto. «Si no te hubieras equivocado de maleta», le dijo '
      'riendo, «nunca habrías escuchado tango en vivo». Y tenía razón: '
      'fue la mejor noche del viaje.',
  passageTranslation:
      'When Daniel arrived at his hotel in Lima, he opened the suitcase '
      'and froze: inside there were dresses, high-heeled shoes and a red '
      'hat. He had taken the wrong suitcase! At the airport, a woman '
      'with an identical case had picked up his. Luckily, inside the hat '
      'there was a card with a phone number. He called it, and it turns '
      'out the woman, an Argentinian tango singer, was in the same '
      'neighbourhood. They met in a café, exchanged suitcases and she '
      'gave him two tickets to her concert. "If you hadn\'t taken the '
      'wrong suitcase," she said, laughing, "you would never have heard '
      'live tango." And she was right: it was the best night of the '
      'trip.',
  intro: 'A travel mix-up with past perfects, se lo pronouns and a peek '
      'at the B2 conditional.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'resulta que…',
      text: '"It turns out that…" — the connector every Spanish '
          'storyteller leans on for the twist. Steal it.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué había dentro de la maleta?',
      options: [
        'Vestidos, zapatos y un sombrero rojo',
        'Sus propias cosas',
        'Libros y regalos',
      ],
      correctIndex: 0,
      questionTranslation: 'What was inside the suitcase?',
    ),
    ReadingQuestion(
      question: '¿Quién tenía la maleta de Daniel?',
      options: [
        'Una cantante de tango',
        'Un taxista',
        'El hotel',
      ],
      correctIndex: 0,
      questionTranslation: 'Who had Daniel\'s suitcase?',
    ),
    ReadingQuestion(
      question: '¿Qué le regaló la mujer?',
      options: [
        'Un sombrero',
        'Dos entradas para su concierto',
        'Una cena',
      ],
      correctIndex: 1,
      questionTranslation: 'What did the woman give him?',
    ),
  ],
);

final QuizContent enEsB12SpeakSounds = enEsSpeak(
  id: 'en_es_b1_2_speak_sounds',
  title: 'Speak: linking like a native',
  intro: 'Spanish links words into one river: los-o-jos, mi-sa-mi-go. '
      'Listen to the flow and copy it whole.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Vowels merge across words',
      text: 'mi amigo sounds like mia-migo; va a hacer like va-cer. '
          'Don\'t chop between words — surf the vowels.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'My friend is coming to eat.', answer: 'Mi amigo viene a comer.'),
    CourseItem(prompt: 'It\'s going to start now.', answer: 'Va a empezar ahora.'),
    CourseItem(prompt: 'Where is the exit?', answer: '¿Dónde está la salida?'),
    CourseItem(prompt: 'We forgot the wine!', answer: '¡Se nos olvidó el vino!'),
    CourseItem(prompt: 'I had never been here.', answer: 'Nunca había estado aquí.'),
    CourseItem(prompt: 'It turns out it was true.', answer: 'Resulta que era verdad.'),
    CourseItem(prompt: 'If you want, I\'ll tell you the story.', answer: 'Si quieres, te cuento la historia.'),
    CourseItem(prompt: 'In the end everything worked out.', answer: 'Al final todo salió bien.'),
  ],
);

final QuizContent enEsB12Dict = enEsDict(
  id: 'en_es_b1_2_dict',
  title: 'Dictation: the anecdote',
  intro: 'Longer narrative sentences: two pasts, se-constructions and '
      'double pronouns at natural speed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Chunk it',
      text: 'Write the first half from memory, replay for the second. '
          'This is training, not an exam.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'When I arrived, the train had already left.', answer: 'Cuando llegué, el tren ya había salido.'),
    CourseItem(prompt: 'I forgot the keys.', answer: 'Se me olvidaron las llaves.'),
    CourseItem(prompt: 'If it rains, we\'ll stay home.', answer: 'Si llueve, nos quedamos en casa.'),
    CourseItem(prompt: 'I gave it to him yesterday.', answer: 'Se lo di ayer.'),
    CourseItem(prompt: 'It was raining while we waited.', answer: 'Llovía mientras esperábamos.'),
    CourseItem(prompt: 'Suddenly the lights went out.', answer: 'De repente se apagaron las luces.'),
    CourseItem(prompt: 'I had never seen anything like it.', answer: 'Nunca había visto nada igual.'),
    CourseItem(prompt: 'It turns out she was my neighbour.', answer: 'Resulta que era mi vecina.'),
    CourseItem(prompt: 'Houses are sold here.', answer: 'Aquí se venden casas.'),
    CourseItem(prompt: 'Can you lend it to me?', answer: '¿Me lo prestas?'),
    CourseItem(prompt: 'Luckily, everything ended well.', answer: 'Por suerte, todo acabó bien.'),
    CourseItem(prompt: 'My phone broke.', answer: 'Se me rompió el teléfono.'),
    CourseItem(prompt: 'So I sat down to wait.', answer: 'Así que me senté a esperar.'),
    CourseItem(prompt: 'She had carried it in her pocket all day.', answer: 'La había llevado en el bolsillo todo el día.'),
    CourseItem(prompt: 'I already told it to you.', answer: 'Ya te lo dije.'),
  ],
);

final QuizContent enEsB12BigText = enEsBigText(
  id: 'en_es_b1_2_bigtext',
  title: 'Big text: La noche del apagón',
  passageTitle: 'La noche del apagón',
  intro: 'Complete the blackout story: two pasts, past perfect, se and '
      'double pronouns.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Read, then layer',
      text: 'First pass: understand the story. Second pass: paint '
          '(imperfect), click (preterite), and one step back (había).',
    ),
  ],
  template:
      'Era una noche de viento y yo {{0}} una película antigua en casa. '
      'De repente {{1}} apagaron las luces. Mientras {{2}} una vela, '
      'alguien llamó a la puerta. Era mi vecina, la señora Vega, que '
      'antes {{3}} electricista. «¿Tienes una linterna? Préstamela y te '
      '{{4}} arreglo», dijo. Se la {{5}} y en diez minutos volvió la '
      'luz. Resulta que un cable viejo {{6}} roto. «Si mañana no '
      '{{7}} luz otra vez», me dijo, «llámame y te {{8}} ayudo». Por '
      'suerte, no {{9}} necesario. ¡Qué vecina!',
  blanks: [
    inputBlank('veía', accepted: ['miraba']),
    inputBlank('se'),
    inputBlank('buscaba'),
    inputBlank('era'),
    inputBlank('lo'),
    inputBlank('presté', accepted: ['di']),
    inputBlank('se había', accepted: ['había']),
    inputBlank('hay'),
    inputBlank('la', accepted: ['lo']),
    inputBlank('fue'),
  ],
  passageTranslation:
      'It was a windy night and I was watching an old film at home. '
      'Suddenly the lights went out. While I was looking for a candle, '
      'someone knocked at the door. It was my neighbour, señora Vega, '
      'who used to be an electrician. "Do you have a torch? Lend it to '
      'me and I\'ll fix it for you," she said. I lent it to her and in '
      'ten minutes the light came back. It turns out an old cable had '
      'broken. "If there\'s no light again tomorrow," she told me, '
      '"call me and I\'ll help you." Luckily, it wasn\'t necessary. What '
      'a neighbour!',
);

final QuizContent enEsB12SpeakingClose = enEsSpeaking(
  id: 'en_es_b1_2_speaking_close',
  title: 'Final conversation: then and now',
  level: 'B1.2',
  topic: 'A conversation in Spanish about how your life has changed: '
      'what you used to do as a child, a memorable story from those '
      'years, and your realistic plans if things go well.',
  practisePoints: [
    'Imperfect for old habits: vivía, jugaba, era',
    'A full anecdote with both pasts and one había',
    'Realistic si-clauses: si todo va bien…',
    'se and double pronouns where natural',
  ],
  scoringCriteria: [
    'Tense architecture of the story correct',
    'si + present indicative (no false subjunctive)',
    'Pronouns in the right order and place',
  ],
  targetVocabulary: [
    'cuando era…', 'de repente', 'ya había', 'resulta que', 'si puedo',
  ],
  priorityErrors: [
    'subjunctive after realistic si',
    'flat single past',
    '"le lo" instead of se lo',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module B1.2 closer: your then and your now, in Spanish. Copy, '
      'speak, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Three acts',
      text: 'Before (imperfect), the story (both pasts), the future (si '
          'todo va bien, voy a…). That script covers every point.',
    ),
  ],
);

/// B1.2 in chain order.
final List<QuizContent> enEsB1_2 = [
  enEsB12PastPerfect,
  enEsB12SiClauses,
  enEsB12Se,
  enEsB12SeLo,
  enEsB12Connectors,
  enEsB12ListenAnecdote,
  enEsB12SpeakingMid,
  enEsB12ReadStory,
  enEsB12SpeakSounds,
  enEsB12Dict,
  enEsB12BigText,
  enEsB12SpeakingClose,
];
