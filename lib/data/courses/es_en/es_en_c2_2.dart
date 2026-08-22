import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// C2.2 — Maestría. Spanish → English.
///
/// The synthesis module: style editing, register switching at will, the
/// last false friends, rhetorical structure, and the near-native traps that
/// separate excellent from indistinguishable.

final QuizContent esEnC22StyleEdit = esEnFill(
  id: 'es_en_c2_2_style_edit',
  title: 'Edición de estilo: di más con menos',
  intro: 'La maestría es reescribir: convertir frases infladas en prosa '
      'limpia. Elige la versión que un editor dejaría pasar.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Las tres tijeras',
      text: 'Corta el relleno (in order to → to), activa la voz (it was '
          'decided by us → we decided), y elige el verbo preciso (make an '
          'improvement → improve).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'in order to → (conciso)', answer: 'in order to → **to**'),
    CourseItem(prompt: 'make an improvement → (verbo)', answer: 'make an improvement → **improve**'),
    CourseItem(prompt: 'give consideration to → (verbo)', answer: 'give consideration to → **consider**'),
    CourseItem(prompt: 'at this point in time → (conciso)', answer: 'at this point in time → **now**'),
    CourseItem(prompt: 'in the event that → (conciso)', answer: 'in the event that → **if**'),
    CourseItem(prompt: 'a large number of → (conciso)', answer: 'a large number of → **many**'),
    CourseItem(prompt: 'come to a conclusion → (verbo)', answer: 'come to a conclusion → **conclude**'),
    CourseItem(prompt: 'despite the fact that → (conciso)', answer: 'despite the fact that → **although**'),
    CourseItem(prompt: 'La decisión fue tomada por el comité. (activa)', answer: 'The committee **made** the decision.'),
    CourseItem(prompt: 'Se llevó a cabo una investigación. (verbo)', answer: 'They **investigated**.'),
    CourseItem(prompt: 'con el propósito de ayudar → (conciso)', answer: '**to** help'),
    CourseItem(prompt: 'en la mayoría de los casos → (conciso)', answer: 'in most **cases**', accepted: ['usually']),
    CourseItem(prompt: 'poner fin a → (verbo)', answer: '**end**'),
    CourseItem(prompt: 'dar una explicación → (verbo)', answer: '**explain**'),
    CourseItem(prompt: 'es de gran importancia → (directo)', answer: 'it **matters**', accepted: ['it is important']),
  ],
);

final QuizContent esEnC22LastFriends = esEnVocab(
  id: 'es_en_c2_2_last_friends',
  title: 'Los últimos falsos amigos',
  intro: 'La tanda final: los falsos amigos sutiles que sobreviven hasta '
      'el C2 (⚑S25).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Los supervivientes',
      text: 'eventually = finalmente (no "eventualmente") · casualty = '
          'víctima (no casualidad) · compromise = acuerdo (no compromiso '
          'social).',
    ),
  ],
  pairs: const [
    MapEntry('finalmente / al final', 'eventually'),
    MapEntry('eventualmente / quizá', 'possibly'),
    MapEntry('víctima (accidente)', 'casualty'),
    MapEntry('casualidad', 'coincidence'),
    MapEntry('llegar a un acuerdo (mutuo)', 'compromise'),
    MapEntry('compromiso (cita)', 'engagement'),
    MapEntry('darse cuenta', 'realise'),
    MapEntry('realizar (llevar a cabo)', 'carry out'),
    MapEntry('discusión (pelea)', 'argument'),
    MapEntry('debate sereno', 'discussion'),
    MapEntry('molestar', 'bother'),
    MapEntry('acosar (grave)', 'molest'),
  ],
);

final QuizContent esEnC22Rhetoric = esEnFill(
  id: 'es_en_c2_2_rhetoric',
  title: 'Retórica: tricolon, anáfora, contraste',
  intro: 'Las figuras que hacen memorable un discurso inglés: la lista de '
      'tres, la repetición inicial y el giro con but.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La regla del tres',
      text: 'blood, sweat and tears · government of the people, by the '
          'people, for the people. El inglés retórico respira en tríos.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'sangre, sudor y lágrimas', answer: 'blood, sweat and **tears**'),
    CourseItem(prompt: 'Vine, vi, vencí.', answer: 'I came, I saw, I **conquered**.'),
    CourseItem(prompt: 'No preguntes qué puede hacer tu país por ti…', answer: 'Ask **not** what your country can do for you…'),
    CourseItem(prompt: 'del pueblo, por el pueblo, para el pueblo', answer: 'of the people, by the people, **for** the people'),
    CourseItem(prompt: 'No es el fin. Ni siquiera el principio del fin.', answer: 'It is not the end. It is not even the beginning of the **end**.'),
    CourseItem(prompt: 'Tenemos poco que ofrecer salvo esfuerzo. (nothing to offer but)', answer: 'We have **nothing** to offer but effort.'),
    CourseItem(prompt: 'No porque sea fácil, sino porque es difícil.', answer: 'Not because it is easy, but because it is **hard**.'),
    CourseItem(prompt: 'Un paso pequeño para el hombre…', answer: 'One small **step** for man…'),
    CourseItem(prompt: 'Lo único que debemos temer es el propio miedo.', answer: 'The only thing we have to fear is fear **itself**.'),
    CourseItem(prompt: 'Educación, educación, educación. (anáfora)', answer: 'Education, education, **education**.'),
    CourseItem(prompt: 'Nunca tantos debieron tanto a tan pocos.', answer: 'Never was so much owed by so many to so **few**.'),
    CourseItem(prompt: 'Pregunta retórica: ¿Y si no hacemos nada?', answer: 'What **if** we do nothing?'),
    CourseItem(prompt: 'Sencillo de decir, difícil de hacer. (contraste)', answer: 'Easy to say, hard to **do**.'),
    CourseItem(prompt: 'Menos es más.', answer: 'Less is **more**.'),
    CourseItem(prompt: 'No un problema, sino una oportunidad.', answer: 'Not a problem, but an **opportunity**.'),
  ],
);

final QuizContent esEnC22NearNative = esEnFill(
  id: 'es_en_c2_2_near_native',
  title: 'Las últimas trampas',
  intro: 'Los detalles que delatan al 99 %: preposiciones finas, artículos '
      'en abstracciones y los plurales invisibles.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'El radar final',
      text: 'depend ON, married TO, arrive AT/IN · people IS ✗ → people '
          'ARE · the life ✗ → life. Pequeño, visible, decisivo (⚑S16).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Depende del tiempo.', answer: 'It depends **on** the weather.'),
    CourseItem(prompt: 'Está casada con un arquitecto.', answer: 'She is married **to** an architect.'),
    CourseItem(prompt: 'La vida es corta. (sin artículo)', answer: '**Life** is short.'),
    CourseItem(prompt: 'La gente es amable aquí. (plural)', answer: 'People **are** friendly here.'),
    CourseItem(prompt: 'Llegamos al aeropuerto a las dos.', answer: 'We arrived **at** the airport at two.'),
    CourseItem(prompt: 'Sueño con vivir junto al mar.', answer: 'I dream **of** living by the sea.'),
    CourseItem(prompt: 'El dinero no compra la felicidad. (sin artículo)', answer: 'Money can\'t buy **happiness**.'),
    CourseItem(prompt: 'Consiste en tres partes.', answer: 'It consists **of** three parts.'),
    CourseItem(prompt: 'Escucha música. (listen)', answer: 'Listen **to** music.'),
    CourseItem(prompt: 'Las noticias son buenas. (singular)', answer: 'The news **is** good.'),
    CourseItem(prompt: 'Me despedí de ellos. (say goodbye)', answer: 'I said goodbye **to** them.'),
    CourseItem(prompt: 'Es responsable del proyecto.', answer: 'She is responsible **for** the project.'),
    CourseItem(prompt: 'Todo el mundo estaba allí. (singular)', answer: 'Everybody **was** there.'),
    CourseItem(prompt: 'Me casé a los treinta. (get married)', answer: 'I got **married** at thirty.'),
    CourseItem(prompt: 'La felicidad depende de poco. (sin artículo)', answer: '**Happiness** depends on little.'),
  ],
);

final QuizContent esEnC22ListenSpeech = esEnListen(
  id: 'es_en_c2_2_listen_speech',
  title: 'Escucha: The farewell speech',
  passageTitle: 'Mrs. Park says goodbye',
  passage:
      "Colleagues, friends, troublemakers — you know who you are. Twenty "
      "years ago I walked into this school with a box of chalk and no "
      "idea what I was doing. Today I leave with no chalk, thousands of "
      "memories, and still, if I am honest, no idea what I am doing. "
      "Teaching gave me three things: patience I never had, questions I "
      "could not answer, and students who eventually answered them "
      "themselves. That is the secret nobody tells you: you do not teach "
      "people English. You lend them your confidence until they realise "
      "— and realise they do — that it was theirs all along. Thank you, "
      "and mind the paint on your way out.",
  passageTranslation:
      'Colegas, amigos, alborotadores — ya sabéis quiénes sois. Hace '
      'veinte años entré en esta escuela con una caja de tizas y sin idea '
      'de lo que hacía. Hoy me voy sin tizas, con miles de recuerdos y, '
      'si soy sincera, igual de perdida. Enseñar me dio tres cosas: una '
      'paciencia que nunca tuve, preguntas que no sabía responder y '
      'alumnos que finalmente las respondieron solos. Ese es el secreto '
      'que nadie cuenta: no le enseñas inglés a la gente. Le prestas tu '
      'confianza hasta que se dan cuenta — y vaya si se dan cuenta — de '
      'que siempre fue suya. Gracias, y ojo con la pintura al salir.',
  intro: 'Un discurso de despedida con toda la retórica del módulo: '
      'tríos, contrastes y un remate emotivo.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Cuenta los tríos',
      text: 'chalk/memories/no idea · patience/questions/students: el '
          'discurso está construido en treses. Escúchalos llegar.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How long did Mrs. Park teach at the school?',
      options: ['Ten years', 'Twenty years', 'Thirty years'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos años enseñó la señora Park en la escuela?',
    ),
    ReadingQuestion(
      question: 'What three things did teaching give her?',
      options: [
        'Patience, questions and students',
        'Money, fame and chalk',
        'Books, holidays and friends',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué tres cosas le dio la enseñanza?',
    ),
    ReadingQuestion(
      question: 'What is "the secret nobody tells you"?',
      options: [
        'You lend students your confidence until they realise it was theirs',
        'English cannot be taught',
        'Teachers never learn',
      ],
      correctIndex: 0,
      questionTranslation: '¿Cuál es "el secreto que nadie cuenta"?',
    ),
  ],
);

final QuizContent esEnC22SpeakingMid = esEnSpeaking(
  id: 'es_en_c2_2_speaking_mid',
  title: 'Conversación: el editor',
  level: 'C2.2',
  topic: 'You are the editor: I will say bloated, clumsy or ambiguous '
      'sentences and you re-say each one better — tighter, clearer, in the '
      'right register — explaining your choice in one line.',
  practisePoints: [
    'Rewriting wordy sentences concisely on the spot',
    'Choosing register deliberately and saying why',
    'Precision vocabulary over general words',
  ],
  scoringCriteria: [
    'Rewrites genuinely improve the original',
    'Explanations are precise and brief',
    'No meaning lost in the compression',
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
  intro: 'Punto de control: sé el editor. Copia, corrige en voz alta y '
      'trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Verbo primero',
      text: 'Casi toda frase inflada esconde un verbo enterrado en un '
          'nombre. Desentiérralo y la frase se arregla sola.',
    ),
  ],
);

final QuizContent esEnC22ReadFinal = esEnRead(
  id: 'es_en_c2_2_read_final',
  title: 'Lectura: The last lesson',
  passageTitle: 'What fluency actually is',
  passage:
      "There is a persistent myth that fluency is speed. It is not. "
      "Fluency is choice. The fluent speaker is not the one who never "
      "pauses, but the one who pauses where the thought pauses; not the "
      "one who knows every word, but the one who, missing a word, walks "
      "around it so gracefully that nobody notices the gap. Learners "
      "chase native speakers as if imitation were the destination. Yet "
      "the bilingual mind is not a copy of anything: it is a third thing, "
      "with its own geometry — a mind that can watch one language from "
      "the balcony of another. That is what you have built, module by "
      "module. Nobody can take it from you, and — here is the last secret "
      "— nobody else can see how it was made. To them, it will simply "
      "look like magic. To you, it will look like work. Both are right.",
  passageTranslation:
      'Existe el mito persistente de que la fluidez es velocidad. No lo '
      'es. La fluidez es elección. El hablante fluido no es el que nunca '
      'pausa, sino el que pausa donde pausa el pensamiento; no el que '
      'conoce cada palabra, sino el que, al faltarle una, la rodea con '
      'tanta gracia que nadie nota el hueco. Los estudiantes persiguen a '
      'los nativos como si la imitación fuera el destino. Pero la mente '
      'bilingüe no es copia de nada: es una tercera cosa, con geometría '
      'propia — una mente que puede mirar un idioma desde el balcón del '
      'otro. Eso es lo que has construido, módulo a módulo. Nadie puede '
      'quitártelo y — aquí va el último secreto — nadie más puede ver '
      'cómo se hizo. A los demás les parecerá magia. A ti te parecerá '
      'trabajo. Ambos tenéis razón.',
  intro: 'El último texto del curso: sobre qué es realmente la fluidez.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Fluidez = elección',
      text: 'Pausar donde pausa el pensamiento y rodear la palabra que '
          'falta: eso es exactamente lo que ya sabes hacer.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'According to the text, what is fluency?',
      options: ['Speed', 'Choice', 'Imitation'],
      correctIndex: 1,
      questionTranslation: 'Según el texto, ¿qué es la fluidez?',
    ),
    ReadingQuestion(
      question: 'What does the fluent speaker do with a missing word?',
      options: [
        'Stops the conversation',
        'Walks around it gracefully',
        'Switches to Spanish',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué hace el hablante fluido con una palabra que le falta?',
    ),
    ReadingQuestion(
      question: 'What is the bilingual mind, according to the text?',
      options: [
        'A copy of a native mind',
        'A third thing with its own geometry',
        'A translation machine',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué es la mente bilingüe según el texto?',
    ),
  ],
);

final QuizContent esEnC22Dict = esEnDict(
  id: 'es_en_c2_2_dict',
  title: 'Dictado final',
  intro: 'El último dictado: frases largas, registro variable, velocidad '
      'natural. Todo lo que sabes, junto.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Confía en la estructura',
      text: 'A esta altura ya no oyes palabras: oyes estructuras. Deja que '
          'la gramática que conoces rellene lo que el oído pierda.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'La fluidez no es velocidad, sino elección.', answer: 'Fluency is not speed but choice.'),
    CourseItem(prompt: 'Nunca había visto un progreso así.', answer: 'Never had I seen such progress.'),
    CourseItem(prompt: 'Al final, todo esfuerzo encuentra su lugar.', answer: 'Eventually, every effort finds its place.'),
    CourseItem(prompt: 'Habiendo llegado tan lejos, no pares ahora.', answer: 'Having come this far, do not stop now.'),
    CourseItem(prompt: 'Lo que importa es lo que haces a continuación.', answer: 'What matters is what you do next.'),
    CourseItem(prompt: 'Fue el trabajo diario lo que marcó la diferencia.', answer: 'It was the daily work that made the difference.'),
    CourseItem(prompt: 'Bien puede ser el principio, no el final.', answer: 'It may well be the beginning, not the end.'),
    CourseItem(prompt: 'No hacía falta que fuera perfecto.', answer: 'It need not have been perfect.'),
    CourseItem(prompt: 'La gente rara vez nota el hueco.', answer: 'People rarely notice the gap.'),
    CourseItem(prompt: 'Se dice que el último paso es el más corto.', answer: 'It is said that the last step is the shortest.'),
    CourseItem(prompt: 'Dicho esto, siempre hay más que aprender.', answer: 'That said, there is always more to learn.'),
    CourseItem(prompt: 'No es un problema, sino una oportunidad.', answer: 'It is not a problem but an opportunity.'),
    CourseItem(prompt: 'A los demás les parecerá magia.', answer: 'To others it will look like magic.'),
    CourseItem(prompt: 'A ti te parecerá trabajo.', answer: 'To you it will look like work.'),
    CourseItem(prompt: 'Ambos tienen razón.', answer: 'Both are right.'),
  ],
);

final QuizContent esEnC22BigText = esEnBigText(
  id: 'es_en_c2_2_bigtext',
  title: 'Texto: The graduation address',
  passageTitle: 'The graduation address',
  intro: 'El último texto con huecos: retórica, inversión, registro y '
      'las trampas finales — todo el curso en una página.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Cierre de curso',
      text: 'Cada hueco es un módulo que ya dominas. Léelo entero, '
          'disfrútalo, y remata.',
    ),
  ],
  template:
      'Friends, we gather to celebrate not an ending {{0}} a beginning. '
      'Never {{1}} this room held so much hard-won knowledge. You arrived '
      'unable to order a coffee; you leave able to argue, to joke, to '
      '{{2}} between registers as easily as you change shoes. {{3}} is '
      'short, and people {{4}} generous with their patience — so speak, '
      'and speak badly when you must, because it was the mistakes {{5}} '
      'taught you the most. Having climbed this far, you may {{6}} '
      'wonder what comes next. In other {{7}}, everything. Eventually '
      'every learner realises the secret: nobody is finished. Not the '
      'teachers, not the natives, not even the poets. What we call '
      'mastery is simply curiosity {{8}} refused to give {{9}}. '
      'Congratulations — now go and use it.',
  blanks: [
    inputBlank('but'),
    inputBlank('has'),
    inputBlank('switch', accepted: ['move', 'shift']),
    inputBlank('Life'),
    inputBlank('are'),
    inputBlank('that', accepted: ['which']),
    inputBlank('well'),
    inputBlank('words'),
    inputBlank('that', accepted: ['which']),
    inputBlank('up'),
  ],
  passageTranslation:
      'Amigos, nos reunimos para celebrar no un final sino un comienzo. '
      'Nunca ha contenido esta sala tanto conocimiento ganado a pulso. '
      'Llegasteis sin poder pedir un café; os vais sabiendo discutir, '
      'bromear y cambiar de registro con la facilidad con que se cambian '
      'los zapatos. La vida es corta y la gente es generosa con su '
      'paciencia: hablad, y hablad mal cuando haga falta, porque fueron '
      'los errores los que más os enseñaron. Habiendo subido hasta aquí, '
      'bien podéis preguntaros qué viene ahora. En otras palabras: todo. '
      'Al final, todo estudiante descubre el secreto: nadie está '
      'terminado. Ni los profesores, ni los nativos, ni siquiera los '
      'poetas. Lo que llamamos maestría es simplemente curiosidad que se '
      'negó a rendirse. Enhorabuena — ahora salid a usarla.',
);

final QuizContent esEnC22SpeakingClose = esEnSpeaking(
  id: 'es_en_c2_2_speaking_close',
  title: 'Conversación final: la maestría',
  level: 'C2.2',
  topic: 'The final conversation: a wide-ranging, natural discussion '
      'moving between registers — small talk, a debate, a story with '
      'irony, and a formal summing-up — as one continuous conversation. '
      'Show everything.',
  practisePoints: [
    'Register switching on demand, mid-conversation',
    'Rhetorical structure in the summing-up',
    'Idiom, understatement and precise modality',
    'The near-native details: prepositions, articles, agreement',
  ],
  scoringCriteria: [
    'Range: every register visited convincingly',
    'Accuracy at the near-native level',
    'The conversation feels effortless, not performed',
  ],
  targetVocabulary: [
    'eventually', 'that said', 'may well', 'what matters is', 'in short',
  ],
  priorityErrors: [
    'register bleed between sections',
    'the classic survivors: depend on, married to, people are',
    'idioms misquoted',
  ],
  mode: SpeakingMode.conversation,
  intro: 'La conversación final del curso. Todo lo que has construido, en '
      'una sola charla. Copia, habla y trae tu última puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El último consejo',
      text: 'No demuestres el idioma: úsalo. La maestría se nota cuando '
          'dejas de pensar en ella.',
    ),
  ],
);

/// C2.2 in chain order.
final List<QuizContent> esEnC2_2 = [
  esEnC22StyleEdit,
  esEnC22LastFriends,
  esEnC22Rhetoric,
  esEnC22NearNative,
  esEnC22ListenSpeech,
  esEnC22SpeakingMid,
  esEnC22ReadFinal,
  esEnC22Dict,
  esEnC22BigText,
  esEnC22SpeakingClose,
];
