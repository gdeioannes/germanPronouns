import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// C2.2 — Mastery. English → Spanish.
///
/// The synthesis module: style editing, dialect-aware comprehension, the
/// hardest mood/aspect traps, rhetorical structure, and near-native
/// polish.

final QuizContent enEsC22StyleEdit = enEsFill(
  id: 'en_es_c2_2_style_edit',
  title: 'Style editing: say more with less',
  intro: 'Mastery is rewriting: turning inflated phrases into clean '
      'prose. Choose the version an editor would let through.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The three scissors',
      text: 'Cut the filler (a la hora de → al), free the buried verb '
          '(tomar una determinación → decidir), pick the precise word.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'con el fin de → (concise) to', answer: 'con el fin de → **para**'),
    CourseItem(prompt: 'llevar a cabo → (verb)', answer: 'llevar a cabo → **realizar**', accepted: ['hacer']),
    CourseItem(prompt: 'en el caso de que → (concise)', answer: 'en el caso de que → **si**'),
    CourseItem(prompt: 'tomar una determinación → (verb)', answer: 'tomar una determinación → **decidir**'),
    CourseItem(prompt: 'en la actualidad → (concise)', answer: 'en la actualidad → **hoy**', accepted: ['ahora', 'actualmente']),
    CourseItem(prompt: 'un gran número de → (concise)', answer: 'un gran número de → **muchos**'),
    CourseItem(prompt: 'poner de manifiesto → (verb)', answer: 'poner de manifiesto → **mostrar**', accepted: ['demostrar']),
    CourseItem(prompt: 'a pesar del hecho de que → (concise)', answer: 'a pesar del hecho de que → **aunque**'),
    CourseItem(prompt: 'dar comienzo a → (verb)', answer: 'dar comienzo a → **empezar**', accepted: ['iniciar']),
    CourseItem(prompt: 'hacer entrega de → (verb)', answer: 'hacer entrega de → **entregar**'),
    CourseItem(prompt: 'en las proximidades de → (concise)', answer: 'en las proximidades de → **cerca de**'),
    CourseItem(prompt: 'proceder a la lectura → (verb)', answer: 'proceder a la lectura → **leer**'),
    CourseItem(prompt: 'es de gran importancia → (direct)', answer: 'es de gran importancia → **importa**', accepted: ['es importante']),
    CourseItem(prompt: 'dar por finalizado → (verb)', answer: 'dar por finalizado → **terminar**', accepted: ['acabar']),
    CourseItem(prompt: 'con anterioridad a → (concise)', answer: 'con anterioridad a → **antes de**'),
  ],
);

final QuizContent enEsC22Traps = enEsFill(
  id: 'en_es_c2_2_traps',
  title: 'The last traps',
  intro: 'The details that betray the 99%: ser/estar edge cases, '
      'preterite meaning-changers, gender ambushes and the final '
      'preposition polish.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'The final radar',
      text: 'está muerto (estar!), el agua fría pero las aguas, supe = '
          'I found out, quise = I tried to, no quise = I refused.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He is dead. (estar!)', answer: '**Está** muerto.'),
    CourseItem(prompt: 'The water is cold. (el agua, but…)', answer: '**El** agua está fría.'),
    CourseItem(prompt: 'I found out yesterday. (saber, preterite)', answer: 'Lo **supe** ayer.'),
    CourseItem(prompt: 'I refused to sign. (no querer, preterite)', answer: 'No **quise** firmar.'),
    CourseItem(prompt: 'The exam went well for me. (salir)', answer: 'El examen me **salió** bien.'),
    CourseItem(prompt: 'The soup is delicious (today). (estar)', answer: 'La sopa **está** riquísima.'),
    CourseItem(prompt: 'He is bored. (estar aburrido)', answer: '**Está** aburrido.'),
    CourseItem(prompt: 'He is boring. (ser aburrido)', answer: '**Es** aburrido.'),
    CourseItem(prompt: 'She is ready. (estar lista)', answer: '**Está** lista.'),
    CourseItem(prompt: 'She is clever. (ser lista)', answer: '**Es** lista.'),
    CourseItem(prompt: 'I dreamt about you. (soñar con)', answer: 'Soñé **con**tigo.'),
    CourseItem(prompt: 'It depends on the weather. (depender de)', answer: 'Depende **del** tiempo.'),
    CourseItem(prompt: 'I met him at last. (conocer, preterite)', answer: 'Por fin lo **conocí**.'),
    CourseItem(prompt: 'She got married to an architect. (casarse con)', answer: 'Se casó **con** un arquitecto.'),
    CourseItem(prompt: 'The problem is serious. (el problema!)', answer: '**El** problema es grave.'),
  ],
);

final QuizContent enEsC22Rhetoric = enEsFill(
  id: 'en_es_c2_2_rhetoric',
  title: 'Rhetoric: the music of a speech',
  intro: 'The figures that make Spanish memorable: the rule of three, '
      'anaphora, and the pivot with no…sino.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'no … sino',
      text: 'The rhetorical pivot: No es un problema, sino una '
          'oportunidad. sino (one word) replaces after a negation.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I came, I saw, I conquered.', answer: 'Llegué, vi, **vencí**.'),
    CourseItem(prompt: 'Not a problem, but an opportunity.', answer: 'No es un problema, **sino** una oportunidad.'),
    CourseItem(prompt: 'Blood, sweat and tears.', answer: 'Sangre, sudor y **lágrimas**.'),
    CourseItem(prompt: 'Easy to say, hard to do.', answer: 'Fácil de decir, difícil de **hacer**.'),
    CourseItem(prompt: 'Less is more.', answer: 'Menos es **más**.'),
    CourseItem(prompt: 'It is not the end, not even the beginning of the end.', answer: 'No es el final, ni siquiera el principio del **final**.'),
    CourseItem(prompt: 'Ask not what your country can do for you…', answer: 'No preguntes qué puede hacer tu país **por** ti…'),
    CourseItem(prompt: 'Education, education, education. (anaphora)', answer: 'Educación, educación, **educación**.'),
    CourseItem(prompt: 'Not because it is easy, but because it is hard.', answer: 'No porque sea fácil, **sino** porque es difícil.'),
    CourseItem(prompt: 'What if we do nothing? (rhetorical)', answer: '¿Y si no **hacemos** nada?'),
    CourseItem(prompt: 'The only thing to fear is fear itself.', answer: 'Lo único que debemos temer es al propio **miedo**.'),
    CourseItem(prompt: 'One small step for man…', answer: 'Un pequeño **paso** para el hombre…'),
    CourseItem(prompt: 'Today, not tomorrow. (contrast)', answer: 'Hoy, no **mañana**.'),
    CourseItem(prompt: 'We shall neither forgive nor forget. (ni…ni)', answer: 'No perdonaremos **ni** olvidaremos.'),
    CourseItem(prompt: 'To live is not the same as to exist.', answer: 'Vivir no es lo mismo que **existir**.'),
  ],
);

final QuizContent enEsC22Dialects = enEsVocab(
  id: 'en_es_c2_2_dialects',
  title: 'The voices of Spanish',
  intro: 'The final dialect tour (⚑E28): recognise the accents and '
      'flags of the big regions — comprehension, not imitation.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Markers, not stereotypes',
      text: 'vos tenés (Río de la Plata), ¿qué tú quieres? (Caribbean), '
          'distinción c/z (Spain), ustedes everywhere in LatAm. Hear '
          'them as signposts.',
    ),
  ],
  pairs: const [
    MapEntry('you have (Argentina, vos)', 'vos tenés'),
    MapEntry('you are (Argentina, vos)', 'vos sos'),
    MapEntry('bus (Mexico)', 'el camión'),
    MapEntry('bus (Argentina)', 'el colectivo'),
    MapEntry('bus (Caribbean/Canaries)', 'la guagua'),
    MapEntry('work (colloquial, Mexico)', 'la chamba'),
    MapEntry('work (colloquial, Spain)', 'el curro'),
    MapEntry('cool (Argentina)', 'bárbaro'),
    MapEntry('cool (Colombia)', 'chévere'),
    MapEntry('cool (Spain)', 'guay'),
    MapEntry('a while (Mexico, ahorita system)', 'ahorita'),
    MapEntry('OK / fine (widely, vale in Spain)', 'vale'),
  ],
);

final QuizContent enEsC22ListenSpeech = enEsListen(
  id: 'en_es_c2_2_listen_speech',
  title: 'Listening: El discurso de despedida',
  passageTitle: 'Doña Rosa se despide',
  passage:
      'Vecinos, amigos, alborotadores — ya saben quiénes son. Hace '
      'veinte años abrí esta panadería con un saco de harina y ninguna '
      'idea de lo que hacía. Hoy la dejo sin harina, con miles de '
      'recuerdos y, si soy sincera, con la misma ninguna idea. Este '
      'barrio me dio tres cosas: una paciencia que no tenía, preguntas '
      'que no sabía responder y clientes que, al final, las respondieron '
      'solos. Ese es el secreto que nadie cuenta: uno no vende pan. Uno '
      'presta confianza hasta que la gente se da cuenta — y vaya si se '
      'da cuenta — de que siempre fue suya. Gracias, y cuidado con el '
      'escalón al salir.',
  passageTranslation:
      'Neighbours, friends, troublemakers — you know who you are. '
      'Twenty years ago I opened this bakery with a sack of flour and '
      'no idea what I was doing. Today I leave it with no flour, '
      'thousands of memories and, if I\'m honest, the same no idea. '
      'This neighbourhood gave me three things: a patience I didn\'t '
      'have, questions I couldn\'t answer, and customers who, in the '
      'end, answered them themselves. That is the secret nobody tells '
      'you: you don\'t sell bread. You lend confidence until people '
      'realise — and realise they do — that it was theirs all along. '
      'Thank you, and mind the step on your way out.',
  intro: 'A farewell speech with the module\'s full rhetoric: triads, '
      'contrasts and an emotional closing turn.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Count the triads',
      text: 'harina/recuerdos/ninguna idea · paciencia/preguntas/'
          'clientes: the speech is built in threes. Hear them land.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cuántos años tuvo doña Rosa la panadería?',
      options: ['Diez', 'Veinte', 'Treinta'],
      correctIndex: 1,
      questionTranslation: 'How many years did doña Rosa have the bakery?',
    ),
    ReadingQuestion(
      question: '¿Qué tres cosas le dio el barrio?',
      options: [
        'Paciencia, preguntas y clientes',
        'Dinero, fama y harina',
        'Pan, recuerdos y vacaciones',
      ],
      correctIndex: 0,
      questionTranslation: 'What three things did the neighbourhood give her?',
    ),
    ReadingQuestion(
      question: '¿Cuál es «el secreto que nadie cuenta»?',
      options: [
        'Uno no vende pan: presta confianza',
        'El pan no importa',
        'Los clientes nunca aprenden',
      ],
      correctIndex: 0,
      questionTranslation: 'What is "the secret nobody tells you"?',
    ),
  ],
);

final QuizContent enEsC22SpeakingMid = enEsSpeaking(
  id: 'en_es_c2_2_speaking_mid',
  title: 'Conversation: the editor',
  level: 'C2.2',
  topic: 'You are the editor, in Spanish: I will say bloated, clumsy or '
      'ambiguous sentences and you re-say each one better — tighter, '
      'clearer, in the right register — explaining your choice in one '
      'line.',
  practisePoints: [
    'Rewriting wordy Spanish concisely on the spot',
    'Choosing register deliberately and saying why',
    'Precision vocabulary over general words',
  ],
  scoringCriteria: [
    'Rewrites genuinely improve the original',
    'Explanations precise and brief',
    'No meaning lost in compression',
  ],
  priorityErrors: [
    'rewrites that only shuffle words',
    'register mismatches',
    'over-explanation',
  ],
  mode: SpeakingMode.roleplay,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: be the editor, out loud. Copy, correct, bring '
      'back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Verb first',
      text: 'Almost every inflated phrase hides a verb buried in a '
          'noun. Dig it out and the sentence fixes itself.',
    ),
  ],
);

final QuizContent enEsC22ReadFinal = enEsRead(
  id: 'en_es_c2_2_read_final',
  title: 'Reading: La última lección',
  passageTitle: 'Qué es de verdad la fluidez',
  passage:
      'Existe el mito persistente de que la fluidez es velocidad. No lo '
      'es. La fluidez es elección. El hablante fluido no es el que '
      'nunca pausa, sino el que pausa donde pausa el pensamiento; no el '
      'que conoce todas las palabras, sino el que, al faltarle una, la '
      'rodea con tanta gracia que nadie nota el hueco. Los estudiantes '
      'persiguen a los nativos como si la imitación fuera el destino. '
      'Pero la mente bilingüe no es copia de nada: es una tercera cosa, '
      'con geometría propia — una mente capaz de mirar un idioma desde '
      'el balcón del otro. Eso es lo que has construido, módulo a '
      'módulo. Nadie puede quitártelo y — aquí va el último secreto — '
      'nadie más puede ver cómo se hizo. A los demás les parecerá '
      'magia. A ti te parecerá trabajo. Y los dos tendrán razón.',
  passageTranslation:
      'There is a persistent myth that fluency is speed. It is not. '
      'Fluency is choice. The fluent speaker is not the one who never '
      'pauses, but the one who pauses where the thought pauses; not the '
      'one who knows every word, but the one who, missing a word, walks '
      'around it so gracefully that nobody notices the gap. Learners '
      'chase natives as if imitation were the destination. But the '
      'bilingual mind is not a copy of anything: it is a third thing, '
      'with its own geometry — a mind able to watch one language from '
      'the balcony of the other. That is what you have built, module by '
      'module. Nobody can take it from you and — here is the last '
      'secret — nobody else can see how it was made. To others it will '
      'look like magic. To you it will look like work. And both will '
      'be right.',
  intro: 'The course\'s final text: on what fluency really is.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Fluency = choice',
      text: 'Pausing where the thought pauses and walking around the '
          'missing word: exactly what you already know how to do.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Según el texto, ¿qué es la fluidez?',
      options: ['Velocidad', 'Elección', 'Imitación'],
      correctIndex: 1,
      questionTranslation: 'According to the text, what is fluency?',
    ),
    ReadingQuestion(
      question: '¿Qué hace el hablante fluido con una palabra que le falta?',
      options: [
        'Detiene la conversación',
        'La rodea con gracia',
        'Cambia al inglés',
      ],
      correctIndex: 1,
      questionTranslation: 'What does the fluent speaker do with a missing word?',
    ),
    ReadingQuestion(
      question: '¿Qué es la mente bilingüe según el texto?',
      options: [
        'Una copia de la mente nativa',
        'Una tercera cosa con geometría propia',
        'Una máquina de traducir',
      ],
      correctIndex: 1,
      questionTranslation: 'What is the bilingual mind, according to the text?',
    ),
  ],
);

final QuizContent enEsC22Dict = enEsDict(
  id: 'en_es_c2_2_dict',
  title: 'Final dictation',
  intro: 'The last dictation: long sentences, shifting registers, '
      'natural speed. Everything you know, together.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Trust the structure',
      text: 'By now you don\'t hear words: you hear structures. Let the '
          'grammar you know fill what the ear misses.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Fluency is not speed but choice.', answer: 'La fluidez no es velocidad, sino elección.'),
    CourseItem(prompt: 'However strange it may seem, it works.', answer: 'Por extraño que parezca, funciona.'),
    CourseItem(prompt: 'If I had given up, I would never have arrived.', answer: 'Si me hubiera rendido, nunca habría llegado.'),
    CourseItem(prompt: 'What matters is what you do next.', answer: 'Lo que importa es lo que haces después.'),
    CourseItem(prompt: 'It was the daily work that made the difference.', answer: 'Fue el trabajo diario lo que marcó la diferencia.'),
    CourseItem(prompt: 'Nobody said it would be easy.', answer: 'Nadie dijo que fuera fácil.'),
    CourseItem(prompt: 'Say what they may, you have made it.', answer: 'Digan lo que digan, lo has conseguido.'),
    CourseItem(prompt: 'It is not the end, but the beginning.', answer: 'No es el final, sino el principio.'),
    CourseItem(prompt: 'People rarely notice the gap.', answer: 'La gente rara vez nota el hueco.'),
    CourseItem(prompt: 'That said, there is always more to learn.', answer: 'Dicho esto, siempre hay más que aprender.'),
    CourseItem(prompt: 'To others it will look like magic.', answer: 'A los demás les parecerá magia.'),
    CourseItem(prompt: 'To you it will look like work.', answer: 'A ti te parecerá trabajo.'),
    CourseItem(prompt: 'And both will be right.', answer: 'Y los dos tendrán razón.'),
    CourseItem(prompt: 'Whatever happens, keep speaking.', answer: 'Pase lo que pase, sigue hablando.'),
    CourseItem(prompt: 'Congratulations: now go and use it.', answer: 'Enhorabuena: ahora sal y úsalo.'),
  ],
);

final QuizContent enEsC22BigText = enEsBigText(
  id: 'en_es_c2_2_bigtext',
  title: 'Big text: El discurso de graduación',
  passageTitle: 'El discurso de graduación',
  intro: 'The last gapped text: rhetoric, mood, register and the final '
      'traps — the whole course on one page.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Course closer',
      text: 'Every gap is a module you already own. Read it whole, '
          'enjoy it, and finish.',
    ),
  ],
  template:
      'Amigos: nos reunimos para celebrar no un final, {{0}} un '
      'comienzo. Nunca ha reunido esta sala tanto conocimiento ganado a '
      'pulso. Llegasteis sin poder pedir un café; os vais sabiendo '
      'discutir, bromear y cambiar de registro como quien se cambia de '
      'zapatos. La vida es corta y la gente es generosa con su '
      'paciencia: hablad, y hablad mal cuando haga falta, porque '
      '{{1}} los errores los que más os enseñaron. Por lejos que '
      '{{2}} llegado, os preguntaréis qué viene ahora. Dicho de otro '
      '{{3}}: todo. Al final, todo estudiante {{4}} cuenta del secreto: '
      'nadie está terminado. Ni los profesores, ni los nativos, ni '
      'siquiera los poetas. {{5}} que llamamos maestría es simplemente '
      'curiosidad que no {{6}} rindió. Si alguien os dice que ya no '
      'queda nada por aprender, no le {{7}} caso. Y cuando dudéis, '
      'recordad esta sala: {{8}} lo que digan, el idioma ya es '
      '{{9}}. Enhorabuena — ahora salid a usarlo.',
  blanks: [
    inputBlank('sino'),
    inputBlank('fueron'),
    inputBlank('hayáis', accepted: ['hayan']),
    inputBlank('modo'),
    inputBlank('se da'),
    inputBlank('Lo'),
    inputBlank('se'),
    inputBlank('hagáis', accepted: ['hagan']),
    inputBlank('digan'),
    inputBlank('vuestro', accepted: ['suyo']),
  ],
  passageTranslation:
      'Friends: we gather to celebrate not an ending but a beginning. '
      'Never has this room held so much hard-won knowledge. You arrived '
      'unable to order a coffee; you leave able to argue, to joke, to '
      'switch registers like someone changing shoes. Life is short and '
      'people are generous with their patience: speak, and speak badly '
      'when you must, because it was the mistakes that taught you the '
      'most. However far you have come, you will wonder what comes '
      'next. In other words: everything. In the end, every learner '
      'realises the secret: nobody is finished. Not the teachers, not '
      'the natives, not even the poets. What we call mastery is simply '
      'curiosity that did not give up. If anyone tells you there is '
      'nothing left to learn, pay them no attention. And when you '
      'doubt, remember this room: whatever they say, the language is '
      'already yours. Congratulations — now go out and use it.',
);

final QuizContent enEsC22SpeakingClose = enEsSpeaking(
  id: 'en_es_c2_2_speaking_close',
  title: 'Final conversation: mastery',
  level: 'C2.2',
  topic: 'The final conversation, in Spanish: a wide-ranging natural '
      'discussion moving between registers — small talk, a debate, a '
      'story with irony, and a formal summing-up — as one continuous '
      'conversation. Show everything.',
  practisePoints: [
    'Register switching on demand, mid-conversation',
    'Rhetorical structure in the summing-up',
    'Idiom, irony and precise mood control',
    'The near-native details: ser/estar, moods, clitics, gender',
  ],
  scoringCriteria: [
    'Range: every register visited convincingly',
    'Accuracy at the near-native level',
    'The conversation feels effortless, not performed',
  ],
  targetVocabulary: [
    'en definitiva', 'dicho esto', 'lo que importa', 'por mucho que',
    'sino',
  ],
  priorityErrors: [
    'register bleed between sections',
    'the classic survivors: mood after cuando/aunque, ser/estar',
    'idioms misquoted',
  ],
  mode: SpeakingMode.conversation,
  intro: 'The course\'s final conversation. Everything you have built, '
      'in one talk. Copy, speak, bring back your last score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The last advice',
      text: 'Don\'t demonstrate the language: use it. Mastery shows '
          'when you stop thinking about it.',
    ),
  ],
);

/// C2.2 in chain order.
final List<QuizContent> enEsC2_2 = [
  enEsC22StyleEdit,
  enEsC22Traps,
  enEsC22Rhetoric,
  enEsC22Dialects,
  enEsC22ListenSpeech,
  enEsC22SpeakingMid,
  enEsC22ReadFinal,
  enEsC22Dict,
  enEsC22BigText,
  enEsC22SpeakingClose,
];
