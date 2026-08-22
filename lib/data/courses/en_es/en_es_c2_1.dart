import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// C2.1 — Style & idiom. English → Spanish.
///
/// Big rocks: idioms and proverbs in context, diminutives and
/// augmentatives, subtle mood contrasts where the choice changes the
/// meaning, and the Spanish of humour and irony.

final QuizContent enEsC21Idioms = enEsFill(
  id: 'en_es_c2_1_idioms',
  title: 'Idioms in context',
  intro: 'Idioms aren\'t translated; they\'re recognised and placed. '
      'Here are the ones an educated native actually uses.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Whole or not at all',
      text: 'A half-idiom betrays more than none. Precision or '
          'abstention — "meter la pata" never becomes "meter el pie".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I put my foot in it. (meter la…)', answer: 'Metí la **pata**.'),
    CourseItem(prompt: 'It cost an arm and a leg. (un ojo…)', answer: 'Costó un **ojo** de la cara.'),
    CourseItem(prompt: 'You hit the nail on the head. (dar en el…)', answer: 'Diste en el **clavo**.'),
    CourseItem(prompt: 'It\'s a piece of cake. (pan…)', answer: 'Es pan **comido**.'),
    CourseItem(prompt: 'He\'s beating around the bush. (irse por las…)', answer: 'Se va por las **ramas**.'),
    CourseItem(prompt: 'Let\'s sleep on it. (consultarlo con la…)', answer: 'Vamos a consultarlo con la **almohada**.'),
    CourseItem(prompt: 'We\'re all in the same boat. (barco)', answer: 'Estamos todos en el mismo **barco**.'),
    CourseItem(prompt: 'He let the cat out of the bag. (irse de la…)', answer: 'Se fue de la **lengua**.'),
    CourseItem(prompt: 'In the blink of an eye. (abrir y cerrar…)', answer: 'En un abrir y cerrar de **ojos**.'),
    CourseItem(prompt: 'It rained cats and dogs. (a cántaros)', answer: 'Llovió a **cántaros**.'),
    CourseItem(prompt: 'To be over the moon. (en el séptimo…)', answer: 'Estar en el séptimo **cielo**.'),
    CourseItem(prompt: 'You caught me off guard. (con la guardia…)', answer: 'Me pillaste con la guardia **baja**.'),
    CourseItem(prompt: 'Better late than never.', answer: 'Más vale tarde que **nunca**.'),
    CourseItem(prompt: 'The last straw. (la gota que…)', answer: 'La gota que colmó el **vaso**.'),
    CourseItem(prompt: 'No pain, no gain. (el que algo quiere…)', answer: 'El que algo quiere, algo le **cuesta**.'),
  ],
);

final QuizContent enEsC21Diminutives = enEsFill(
  id: 'en_es_c2_1_diminutives',
  title: 'Diminutives & augmentatives',
  intro: '-ito softens, warms or shrinks; -azo enlarges or admires; '
      '-ucho despises. Un cafecito is not just a small coffee — it\'s '
      'an invitation.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Feeling, not size',
      text: 'ahorita (right now-ish, LatAm), despacito (nice and slow), '
          'un golazo (what a goal!). The suffix carries emotion first.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'a little coffee (warm offer)', answer: 'un **cafecito**'),
    CourseItem(prompt: 'nice and slow', answer: '**despacito**'),
    CourseItem(prompt: 'a moment (softened)', answer: 'un **momentito**'),
    CourseItem(prompt: 'grandma (affectionate)', answer: 'la **abuelita**'),
    CourseItem(prompt: 'What a goal! (-azo)', answer: '¡Qué **golazo**!'),
    CourseItem(prompt: 'a huge success (exitazo)', answer: 'un **exitazo**'),
    CourseItem(prompt: 'a dingy hotel (-ucho)', answer: 'un **hotelucho**'),
    CourseItem(prompt: 'right now (LatAm, softened)', answer: '**ahorita**'),
    CourseItem(prompt: 'a little house (cariño)', answer: 'una **casita**'),
    CourseItem(prompt: 'a big word / swear word (-ota)', answer: 'una **palabrota**'),
    CourseItem(prompt: 'a quick little question', answer: 'una **preguntita**'),
    CourseItem(prompt: 'a scare → a huge scare (susto → -azo)', answer: 'un **sustazo**'),
    CourseItem(prompt: 'cheap little bar (-ucho)', answer: 'un **barucho**'),
    CourseItem(prompt: 'a little kiss', answer: 'un **besito**'),
    CourseItem(prompt: 'What a car! (admiring -azo)', answer: '¡Qué **cochazo**!'),
  ],
);

final QuizContent enEsC21MoodMeaning = enEsFill(
  id: 'en_es_c2_1_mood_meaning',
  title: 'Mood changes meaning',
  intro: 'The C2 frontier: sentences where indicative vs subjunctive '
      'changes the MEANING, not the correctness. Busco un piso que '
      'tiene / tenga terraza — two different searches.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Known vs wished-for',
      text: 'Indicative points at something that exists and you know; '
          'subjunctive at something desired or unverified. The verb '
          'form IS the information.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I\'m looking for a flat that HAS a terrace (I saw the ad).', answer: 'Busco un piso que **tiene** terraza.'),
    CourseItem(prompt: 'I\'m looking for a(ny) flat that has a terrace.', answer: 'Busco un piso que **tenga** terraza.'),
    CourseItem(prompt: 'Although it IS expensive (I know), I\'ll buy it.', answer: 'Aunque **es** caro, lo compraré.'),
    CourseItem(prompt: 'Even if it may be expensive, I\'ll buy it.', answer: 'Aunque **sea** caro, lo compraré.'),
    CourseItem(prompt: 'When he comes (habitually), we eat together.', answer: 'Cuando **viene**, comemos juntos.'),
    CourseItem(prompt: 'When he comes (one day), we\'ll eat together.', answer: 'Cuando **venga**, comeremos juntos.'),
    CourseItem(prompt: 'I\'ll marry someone who LOVES the sea (I know her).', answer: 'Me casaré con alguien que **ama** el mar.'),
    CourseItem(prompt: 'I\'ll marry someone (whoever) who loves the sea.', answer: 'Me casaré con alguien que **ame** el mar.'),
    CourseItem(prompt: 'He didn\'t do it because he WAS tired. (real reason)', answer: 'No lo hizo porque **estaba** cansado.'),
    CourseItem(prompt: 'He didn\'t do it because he was tired — but for another reason. (porque + subj.)', answer: 'No lo hizo porque **estuviera** cansado, sino por otra razón.'),
    CourseItem(prompt: 'Maybe he knows (I lean yes). (quizá + ind.)', answer: 'Quizá lo **sabe**.'),
    CourseItem(prompt: 'Maybe he knows (who can tell). (quizá + subj.)', answer: 'Quizá lo **sepa**.'),
    CourseItem(prompt: 'There\'s a waiter who speaks Chinese. (exists)', answer: 'Hay un camarero que **habla** chino.'),
    CourseItem(prompt: 'There\'s no waiter who speaks Chinese.', answer: 'No hay camarero que **hable** chino.'),
    CourseItem(prompt: 'Say it however you want. (como + subj.)', answer: 'Dilo como **quieras**.'),
  ],
);

final QuizContent enEsC21Irony = enEsVocab(
  id: 'en_es_c2_1_irony',
  title: 'Irony & flavour',
  intro: 'The phrases Spanish uses to smile sideways: irony, resignation '
      'and affectionate exaggeration.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Tone flips the meaning',
      text: '¡Qué bonito! can be praise or pure reproach — the eyebrows '
          'decide. Learn to hear the second meaning.',
    ),
  ],
  pairs: const [
    MapEntry('Great, just great… (ironic)', 'Genial, lo que faltaba…'),
    MapEntry('Sure, of course… (sceptical)', 'Ya, claro…'),
    MapEntry('Don\'t even think about it', 'Ni se te ocurra'),
    MapEntry('No way! (disbelief)', '¡No me digas!'),
    MapEntry('What a coincidence… (suspicious)', 'Qué casualidad…'),
    MapEntry('It figures / typical', 'Típico'),
    MapEntry('If only!', '¡Ojalá!'),
    MapEntry('You don\'t say (flat irony)', 'No me diga'),
    MapEntry('That\'s all we needed', 'Lo que nos faltaba'),
    MapEntry('Yeah, right, and pigs fly', 'Sí, y los cerdos vuelan'),
    MapEntry('Nice mess! (menudo)', '¡Menudo lío!'),
    MapEntry('Some help you are… (vaya)', 'Vaya ayuda…'),
  ],
);

final QuizContent enEsC21ListenSobremesa = enEsListen(
  id: 'en_es_c2_1_listen_sobremesa',
  title: 'Listening: La sobremesa',
  passageTitle: 'Una sobremesa muy española',
  passage:
      '¡Qué comidita, doña Rosa! — Nada, cuatro cositas… — ¿Cuatro? '
      'Llevamos tres horas en la mesa. — Eso es la sobremesa, hijo. '
      'Aquí no se come: se conversa con cuchara. — Pues en mi país, '
      'terminas el café y te vas. — ¡Qué horror! Ni se te ocurra hacer '
      'eso aquí. La última vez que un invitado se fue pronto, mi madre '
      'estuvo una semana preguntando si le había pasado algo. — Ya, '
      'claro, y ahora me toca quedarme hasta las siete. — Hasta las '
      'ocho, mínimo. Hay tarta. — Menudo sacrificio. — Oye, que la '
      'tarta la hice yo. — …¿Y si empezamos ahorita?',
  passageTranslation:
      'What a lovely meal, doña Rosa! — Oh, nothing, just a few little '
      'things… — A few? We\'ve been at the table for three hours. — '
      'That\'s the sobremesa, dear. Here one doesn\'t eat: one '
      'converses with a spoon. — Well, in my country, you finish your '
      'coffee and leave. — How awful! Don\'t even think of doing that '
      'here. The last time a guest left early, my mother spent a week '
      'asking if something had happened to him. — Sure, of course, and '
      'now I have to stay until seven. — Until eight, minimum. There\'s '
      'cake. — What a sacrifice. — Hey, I made that cake myself. — '
      '…Shall we start right now-ish?',
  intro: 'An after-lunch conversation full of diminutives, irony and '
      'cultural music. Listen for what is said between the lines.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'cuatro cositas',
      text: 'When a Spanish host says "just a few little things", '
          'multiply by five. The diminutive is modesty theatre.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué es la sobremesa?',
      options: [
        'El postre',
        'La conversación larga después de comer',
        'Una siesta',
      ],
      correctIndex: 1,
      questionTranslation: 'What is the sobremesa?',
    ),
    ReadingQuestion(
      question: '¿Qué pasó la última vez que un invitado se fue pronto?',
      options: [
        'La madre preguntó una semana si le había pasado algo',
        'Nadie lo notó',
        'Se enfadaron para siempre',
      ],
      correctIndex: 0,
      questionTranslation: 'What happened last time a guest left early?',
    ),
    ReadingQuestion(
      question: '¿"Menudo sacrificio" es…?',
      options: ['Una queja seria', 'Ironía', 'Un cumplido formal'],
      correctIndex: 1,
      questionTranslation: '"Menudo sacrificio" is…?',
    ),
  ],
);

final QuizContent enEsC21SpeakingMid = enEsSpeaking(
  id: 'en_es_c2_1_speaking_mid',
  title: 'Conversation: between the lines',
  level: 'C2.1',
  topic: 'A conversation in Spanish full of irony and idioms: we chat '
      'about plans, food and small disasters; I will exaggerate and '
      'joke, and you must respond to what I mean — using idioms and '
      'diminutives naturally yourself.',
  practisePoints: [
    'Decoding irony and answering the real meaning',
    'Three or four idioms placed naturally',
    'Diminutives for warmth, not size',
  ],
  scoringCriteria: [
    'Idioms word-perfect and in context',
    'Responses match the implied meaning',
    'Register playful but accurate',
  ],
  priorityErrors: [
    'idioms slightly misquoted',
    'literal responses to irony',
    'diminutives overused mechanically',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: a chat where nothing is quite literal. Copy, '
      'converse, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Two idioms per chat',
      text: 'Place them where they fit and stop. Three natural idioms '
          'beat ten forced ones.',
    ),
  ],
);

final QuizContent enEsC21ReadColumn = enEsRead(
  id: 'en_es_c2_1_read_column',
  title: 'Reading: El columnista',
  passageTitle: 'Sobre el arte de la sobremesa',
  passage:
      'La sobremesa no es, como imaginan algunos visitantes, el rato '
      'perezoso que sigue al postre. Es una institución nacional. '
      'Levantarse de la mesa al terminar el café no es irse: es '
      'desertar. Que nadie diga nada no significa que no haya pasado '
      'nada — precisamente porque nadie dice nada, sabrás que has '
      'cometido un crimen. Un «¿ya te vas?» murmurado desde la cabecera '
      'equivale, en términos de sobremesa, a un motín. No somos, todo '
      'hay que decirlo, un pueblo dado a la prisa. Preferimos discutir '
      'de política, de fútbol y de si la tarta lleva demasiado azúcar, '
      'todo a la vez y durante tres horas. A los amigos extranjeros '
      'esto puede parecerles agotador. Lo es. Pero en la sobremesa, '
      'todo español, sea cual sea su partido, permanece unido: sentado, '
      'discutiendo, y pidiendo, por supuesto, otro cafecito.',
  passageTranslation:
      'The sobremesa is not, as some visitors imagine, the lazy stretch '
      'after dessert. It is a national institution. Getting up from the '
      'table when the coffee ends is not leaving: it is deserting. That '
      'nobody says anything does not mean nothing has happened — '
      'precisely because nobody says anything, you will know you have '
      'committed a crime. A murmured "leaving already?" from the head '
      'of the table amounts, in sobremesa terms, to a mutiny. We are '
      'not, it must be said, a people given to hurry. We prefer to '
      'argue about politics, football and whether the cake has too much '
      'sugar, all at once and for three hours. To foreign friends this '
      'may seem exhausting. It is. But at the sobremesa, every '
      'Spaniard, whatever their party, stands united: seated, arguing, '
      'and ordering, of course, another cafecito.',
  intro: 'A humour column about the sobremesa: irony, rhythm and one '
      'affectionate diminutive as the punchline.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Structural irony',
      text: 'The column presents silence as maximum condemnation: the '
          'irony lives in the contrast, not in any single word.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Según el texto, ¿qué es levantarse al terminar el café?',
      options: ['Normal', 'Desertar', 'Obligatorio'],
      correctIndex: 1,
      questionTranslation: 'According to the text, what is getting up when the coffee ends?',
    ),
    ReadingQuestion(
      question: '¿Qué equivale a un motín?',
      options: [
        'Un «¿ya te vas?» murmurado',
        'Pedir más tarta',
        'Hablar de política',
      ],
      correctIndex: 0,
      questionTranslation: 'What amounts to a mutiny?',
    ),
    ReadingQuestion(
      question: '¿Qué tono usa el columnista?',
      options: ['Enfadado', 'Irónico y cariñoso', 'Neutro y académico'],
      correctIndex: 1,
      questionTranslation: 'What tone does the columnist use?',
    ),
  ],
);

final QuizContent enEsC21Dict = enEsDict(
  id: 'en_es_c2_1_dict',
  title: 'Dictation: native speech',
  intro: 'Sentences with idioms, diminutives and fine mood contrasts, '
      'at natural speed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The idiom is a block',
      text: 'Recognise the opening (costó un ojo…) and the rest writes '
          'itself. Learn the blocks, not the words.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I put my foot in it at the meeting.', answer: 'Metí la pata en la reunión.'),
    CourseItem(prompt: 'It cost an arm and a leg.', answer: 'Costó un ojo de la cara.'),
    CourseItem(prompt: 'Shall we have a little coffee?', answer: '¿Nos tomamos un cafecito?'),
    CourseItem(prompt: 'Don\'t even think about it!', answer: '¡Ni se te ocurra!'),
    CourseItem(prompt: 'It rained buckets all afternoon.', answer: 'Llovió a cántaros toda la tarde.'),
    CourseItem(prompt: 'I\'m looking for a flat that has a terrace. (any)', answer: 'Busco un piso que tenga terraza.'),
    CourseItem(prompt: 'Even if it may be late, call me.', answer: 'Aunque sea tarde, llámame.'),
    CourseItem(prompt: 'You hit the nail on the head.', answer: 'Diste en el clavo.'),
    CourseItem(prompt: 'What a mess, that\'s all we needed!', answer: '¡Menudo lío, lo que nos faltaba!'),
    CourseItem(prompt: 'Better late than never.', answer: 'Más vale tarde que nunca.'),
    CourseItem(prompt: 'Let\'s sleep on it.', answer: 'Vamos a consultarlo con la almohada.'),
    CourseItem(prompt: 'There\'s nobody who understands him.', answer: 'No hay nadie que lo entienda.'),
    CourseItem(prompt: 'It was a huge success.', answer: 'Fue un exitazo.'),
    CourseItem(prompt: 'In the blink of an eye it was over.', answer: 'En un abrir y cerrar de ojos se acabó.'),
    CourseItem(prompt: 'Say it however you want.', answer: 'Dilo como quieras.'),
  ],
);

final QuizContent enEsC21BigText = enEsBigText(
  id: 'en_es_c2_1_bigtext',
  title: 'Big text: La reseña',
  passageTitle: 'Reseña: El Tenedor de Oro',
  intro: 'Complete an ironic restaurant review: idioms, diminutives and '
      'mood-meaning contrasts.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Read the tone first',
      text: 'The review praises with the brakes on and criticises '
          'smiling. Each gap keeps that temperature.',
    ),
  ],
  template:
      'El Tenedor de Oro no es precisamente barato — la cena costó un '
      '{{0}} de la cara — pero se come de maravilla. Su famoso pastel '
      'de pescado quizá {{1}} el mejor de la ciudad, aunque el camarero '
      'que lo describió durante seis minutos no fue, digamos, breve. El '
      'servicio es otra historia: los entrantes llegaron antes que la '
      'carta y el vino no llegó nunca. «Se me {{2}} por completo», '
      'admitió el camarero, lo cual tuvo al menos el encanto de la '
      'honestidad. ¿Volvería? Creo que {{3}}. No hay chef en el barrio '
      'que {{4}} el hojaldre como este. Eso sí: la próxima vez pediré '
      'el vino en cuanto me {{5}}, y no esperaré a que el camarero dé '
      'en el {{6}} con la carta. Al fin y al {{7}}, se perdona mucho '
      'por un postre así. Un consejo: reserven una mesita {{8}} y '
      'pidan el pastel sin miedo. {{9}} vale tarde que nunca.',
  blanks: [
    inputBlank('ojo'),
    inputBlank('sea'),
    inputBlank('olvidó'),
    inputBlank('sí'),
    inputBlank('haga', accepted: ['prepare', 'trabaje']),
    inputBlank('siente', accepted: ['sienten']),
    inputBlank('clavo'),
    inputBlank('cabo'),
    inputBlank('tranquila', accepted: ['pequeña']),
    inputBlank('Más'),
  ],
  passageTranslation:
      'The Golden Fork is not exactly cheap — dinner cost an arm and a '
      'leg — but the food is wonderful. Its famous fish pie may well be '
      'the best in the city, although the waiter who described it for '
      'six minutes was not, shall we say, brief. The service is another '
      'story: the starters arrived before the menu and the wine never '
      'arrived at all. "It completely slipped my mind," the waiter '
      'admitted, which at least had the charm of honesty. Would I go '
      'back? I think so. There is no chef in the neighbourhood who does '
      'pastry like this one. Mind you: next time I\'ll order the wine '
      'as soon as they seat me, and I won\'t wait for the waiter to hit '
      'the nail on the head with the menu. At the end of the day, one '
      'forgives a great deal for a dessert like that. A tip: book a '
      'quiet little table and order the pie without fear. Better late '
      'than never.',
);

final QuizContent enEsC21SpeakingClose = enEsSpeaking(
  id: 'en_es_c2_1_speaking_close',
  title: 'Final conversation: humour and nuance',
  level: 'C2.1',
  topic: 'Tell me, in Spanish, about a disaster that turned out fine — '
      'a trip, a meal, a project — with irony and colour. Then we '
      'review a plan together and you push back with softened but firm '
      'disagreement.',
  practisePoints: [
    'A story told with irony and idioms',
    'Diminutives and augmentatives for flavour',
    'Mood-meaning contrasts under pressure',
    'Firm but warm disagreement',
  ],
  scoringCriteria: [
    'Humour lands through language',
    'Idioms accurate',
    'Mood choices carry the intended meaning',
  ],
  priorityErrors: [
    'idioms misquoted',
    'irony explained instead of performed',
    'wrong mood flipping the meaning',
  ],
  mode: SpeakingMode.conversation,
  intro: 'Module C2.1 closer: tell a disaster with grace. Copy, speak, '
      'bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Undersell the drama',
      text: 'Where you\'d say terrible, say "un pequeño desastre". The '
          'C2 listener hears the brake and understands the size.',
    ),
  ],
);

/// C2.1 in chain order.
final List<QuizContent> enEsC2_1 = [
  enEsC21Idioms,
  enEsC21Diminutives,
  enEsC21MoodMeaning,
  enEsC21Irony,
  enEsC21ListenSobremesa,
  enEsC21SpeakingMid,
  enEsC21ReadColumn,
  enEsC21Dict,
  enEsC21BigText,
  enEsC21SpeakingClose,
];
