import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// C2.1 — Estilo e idiomatismo. Spanish → English.
///
/// Big rocks: idioms in real contexts, ellipsis and substitution (so/one/do),
/// subtle modality (dare, needn't, may well), and the English of irony and
/// understatement — the layer where meaning lives between the words.

final QuizContent esEnC21Idioms = esEnFill(
  id: 'es_en_c2_1_idioms',
  title: 'Modismos en contexto',
  intro: 'Los idioms no se traducen: se reconocen y se colocan. Aquí, los '
      'que un nativo culto usa de verdad.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Úsalos enteros o no los uses',
      text: 'Un idiom a medias ("the last drop" por the last straw) delata '
          'más que no usar ninguno. Precisión o abstención.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Fue la gota que colmó el vaso.', answer: 'It was the last **straw**.'),
    CourseItem(prompt: 'Me costó un ojo de la cara.', answer: 'It cost me an arm and a **leg**.'),
    CourseItem(prompt: 'Dio en el clavo.', answer: 'She hit the nail on the **head**.'),
    CourseItem(prompt: 'Estás andando con rodeos. (bush)', answer: 'You are beating around the **bush**.'),
    CourseItem(prompt: 'Se me fue el santo al cielo. (mind)', answer: 'It slipped my **mind**.'),
    CourseItem(prompt: 'Mejor consultarlo con la almohada. (sleep)', answer: 'Let me sleep **on** it.'),
    CourseItem(prompt: 'Eso es pan comido.', answer: 'That is a piece of **cake**.'),
    CourseItem(prompt: 'Estamos en el mismo barco.', answer: 'We are in the same **boat**.'),
    CourseItem(prompt: 'Se le escapó el secreto. (beans)', answer: 'He spilled the **beans**.'),
    CourseItem(prompt: 'A largo plazo, saldrá bien. (run)', answer: 'In the long **run**, it will be fine.'),
    CourseItem(prompt: 'De vez en cuando. (now)', answer: 'Every **now** and then.'),
    CourseItem(prompt: 'Me pillas con la guardia baja. (guard)', answer: 'You caught me off **guard**.'),
    CourseItem(prompt: 'No es santo de mi devoción. (tea)', answer: 'He is not my cup of **tea**.'),
    CourseItem(prompt: 'Crucemos los dedos.', answer: 'Fingers **crossed**.'),
    CourseItem(prompt: 'Al fin y al cabo, es tu decisión. (end)', answer: 'At the **end** of the day, it is your decision.'),
  ],
);

final QuizContent esEnC21Ellipsis = esEnFill(
  id: 'es_en_c2_1_ellipsis',
  title: 'Elipsis y sustitución: so, one, do',
  intro: 'El inglés maduro no repite: I think so · a red one · so do I · '
      'I hope not. Sustituye o calla, como el nativo.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'El kit anti-repetición',
      text: 'so/not tras think, hope, afraid · one/ones por el nombre · '
          'do/does/did por el verbo entero · So do I / Neither do I.',
    ),
  ],
  items: const [
    CourseItem(prompt: '—¿Lloverá? —Creo que sí.', answer: 'I think **so**.'),
    CourseItem(prompt: '—¿Vendrá? —Espero que no.', answer: 'I hope **not**.'),
    CourseItem(prompt: 'Prefiero el rojo. (one)', answer: 'I prefer the red **one**.'),
    CourseItem(prompt: '—Me encanta el jazz. —A mí también.', answer: 'So **do** I.'),
    CourseItem(prompt: '—No como carne. —Yo tampoco.', answer: 'Neither **do** I.'),
    CourseItem(prompt: 'Trabaja más de lo que debería. (does)', answer: 'He works harder than he **should**.'),
    CourseItem(prompt: '—¿Quién lo rompió? —Yo no fui. (didn\'t)', answer: 'I **didn\'t**.'),
    CourseItem(prompt: 'Me temo que sí.', answer: 'I am afraid **so**.'),
    CourseItem(prompt: '—Ella canta muy bien. —Sí, ¿verdad? (does)', answer: 'Yes, she **does**, doesn\'t she?'),
    CourseItem(prompt: 'Estos zapatos y los nuevos. (ones)', answer: 'These shoes and the new **ones**.'),
    CourseItem(prompt: '—¿Has terminado? —Todavía no.', answer: 'Not **yet**.'),
    CourseItem(prompt: '—Estaré allí. —Yo también. (will)', answer: 'So **will** I.'),
    CourseItem(prompt: 'Puede que sí, puede que no.', answer: 'Maybe so, maybe **not**.'),
    CourseItem(prompt: '—¿Te importa? —En absoluto.', answer: 'Not at **all**.'),
    CourseItem(prompt: 'Si tú no vas, yo tampoco. (won\'t)', answer: 'If you don\'t go, I **won\'t** either.'),
  ],
);

final QuizContent esEnC21Modality = esEnFill(
  id: 'es_en_c2_1_modality',
  title: 'Modalidad fina: may well, needn\'t, dare',
  intro: 'Los matices entre poder y deber: may well (bien puede), needn\'t '
      'have (no hacía falta), might as well (ya puestos).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Los cuatro matices de examen',
      text: 'may well = probable · might as well = ya puestos · needn\'t '
          'have done = lo hiciste sin necesidad · didn\'t need to = no '
          'hacía falta (y quizá no lo hiciste).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Bien puede ser verdad.', answer: 'It may **well** be true.'),
    CourseItem(prompt: 'No hacía falta que compraras pan (lo compraste).', answer: 'You **needn\'t** have bought bread.'),
    CourseItem(prompt: 'Ya puestos, quedémonos.', answer: 'We might as **well** stay.'),
    CourseItem(prompt: '¿Cómo te atreves a decir eso?', answer: 'How **dare** you say that?'),
    CourseItem(prompt: 'Puede muy bien que llueva.', answer: 'It **may** well rain.'),
    CourseItem(prompt: 'No necesitas reservar. (needn\'t)', answer: 'You **needn\'t** book.'),
    CourseItem(prompt: 'Deberías haberlo dicho antes.', answer: 'You **should** have said so earlier.'),
    CourseItem(prompt: 'No me atreví a preguntar.', answer: 'I didn\'t **dare** ask.'),
    CourseItem(prompt: 'Podrías al menos haber llamado.', answer: 'You **might** at least have called.'),
    CourseItem(prompt: 'Eso ya lo veremos. (shall)', answer: 'We **shall** see.'),
    CourseItem(prompt: 'Bien pudo haberse perdido la carta.', answer: 'The letter may well have been **lost**.'),
    CourseItem(prompt: 'No tenías por qué esperarme.', answer: 'You **needn\'t** have waited for me.'),
    CourseItem(prompt: 'Más te vale llegar puntual. (had better)', answer: 'You had **better** be on time.'),
    CourseItem(prompt: 'Ya puestos, pide postre también.', answer: 'You might as **well** order dessert too.'),
    CourseItem(prompt: 'Quién iba a saberlo. (was to)', answer: 'How **was** anyone to know?'),
  ],
);

final QuizContent esEnC21Understatement = esEnVocab(
  id: 'es_en_c2_1_understatement',
  title: 'La lítote británica',
  intro: 'El inglés británico dice menos para decir más: not bad = muy '
      'bueno. Descifrar el understatement es C2 puro.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Traduce la intención, no las palabras',
      text: '"Interesting choice" rara vez es un elogio; "quite good" puede '
          'ser tibio; "not bad at all" es entusiasmo británico.',
    ),
  ],
  pairs: const [
    MapEntry('muy bueno (lítote)', 'not bad at all'),
    MapEntry('un problema serio (lítote)', 'a bit of a problem'),
    MapEntry('estoy algo decepcionado (lítote)', 'slightly disappointed'),
    MapEntry('carísimo (lítote)', 'not exactly cheap'),
    MapEntry('me es indiferente', 'I am not bothered'),
    MapEntry('discrepo del todo (suave)', 'I am not sure I agree'),
    MapEntry('eso es discutible', 'that is debatable'),
    MapEntry('llegó tardísimo (lítote)', 'none too early'),
    MapEntry('bastante difícil (lítote)', 'no small task'),
    MapEntry('lo dudo mucho (seco)', 'I rather doubt it'),
  ],
);

final QuizContent esEnC21ListenBanter = esEnListen(
  id: 'es_en_c2_1_listen_banter',
  title: 'Escucha: The dinner party',
  passageTitle: 'A very English dinner',
  passage:
      "Lovely to see you both! Come in — mind the paint, we've had a bit "
      "of a week with the builders. — This wine is not bad at all, where's "
      "it from? — Oh, just the corner shop, but don't tell anyone. — Your "
      "kitchen looks incredible. — Well, it should do: it cost an arm and "
      "a leg, and the builders may well be back next month. — How dare "
      "they leave it unfinished! — Quite. Still, at the end of the day, "
      "we might as well enjoy the chaos. Dinner's ready — fingers crossed "
      "the oven behaved.",
  passageTranslation:
      '¡Qué alegría veros! Pasad — ojo con la pintura, hemos tenido una '
      'semanita con los obreros. — Este vino no está nada mal, ¿de dónde '
      'es? — Oh, de la tienda de la esquina, pero no se lo digas a nadie. '
      '— Vuestra cocina está increíble. — Bueno, más le vale: costó un '
      'ojo de la cara, y bien puede que los obreros vuelvan el mes que '
      'viene. — ¡Cómo se atreven a dejarla sin terminar! — Y que lo digas. '
      'En fin, al fin y al cabo, ya puestos disfrutemos del caos. La cena '
      'está lista: crucemos los dedos para que el horno se haya portado.',
  intro: 'Una cena inglesa: lítotes, idioms y modalidad fina en '
      'conversación real. Escucha lo que se dice… y lo que se quiere decir.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'a bit of a week',
      text: '"Hemos tenido una semanita" = ha sido un caos. Cuando un '
          'británico minimiza, multiplica tú por tres.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What does "not bad at all" mean about the wine?',
      options: ['It is mediocre', 'It is very good', 'It is undrinkable'],
      correctIndex: 1,
      questionTranslation: '¿Qué significa "not bad at all" sobre el vino?',
    ),
    ReadingQuestion(
      question: 'What do we learn about the kitchen?',
      options: [
        'It was very expensive',
        'It was cheap',
        'It is finished',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué sabemos de la cocina?',
    ),
    ReadingQuestion(
      question: 'What might happen next month?',
      options: [
        'The builders may well come back',
        'They will move house',
        'The oven will be replaced',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué puede pasar el mes que viene?',
    ),
  ],
);

final QuizContent esEnC21SpeakingMid = esEnSpeaking(
  id: 'es_en_c2_1_speaking_mid',
  title: 'Conversación: leer entre líneas',
  level: 'C2.1',
  topic: 'A conversation full of understatement and idioms: we chat about '
      'work, houses and plans; I will underplay everything and you must '
      'respond to what I mean, not what I say — and use idioms naturally '
      'yourself.',
  practisePoints: [
    'Decoding understatement and responding to the real meaning',
    'Using three or four idioms naturally, not forced',
    'Fine modality: may well, might as well, needn\'t have',
  ],
  scoringCriteria: [
    'Idioms used accurately and in context',
    'Responses match the implied meaning',
    'Modal nuances correct',
  ],
  priorityErrors: [
    'idioms slightly wrong in wording',
    'literal responses to understatement',
    'over-formal register in casual chat',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: una charla donde nada se dice del todo. '
      'Copia, conversa y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Dos idioms por conversación',
      text: 'Colócalos donde encajen y para. Tres idioms naturales valen '
          'más que diez forzados.',
    ),
  ],
);

final QuizContent esEnC21ReadColumn = esEnRead(
  id: 'es_en_c2_1_read_column',
  title: 'Lectura: The columnist',
  passageTitle: 'On the art of queueing',
  passage:
      "The British queue is not, as visitors sometimes imagine, a line of "
      "people. It is a moral institution. Push in at a bus stop and nobody "
      "will say a word — which is precisely how you will know you have "
      "committed a crime. A muttered \"well, really\" from somewhere behind "
      "you is, in queueing terms, a riot. We are not, it must be said, a "
      "nation given to confrontation. We prefer our fury filtered through "
      "raised eyebrows and the words \"no, no, after you\" delivered at a "
      "temperature slightly below freezing. Foreign friends may well find "
      "this exhausting. It is. But at the end of the day, the queue is the "
      "one place where every Briton, whatever their politics, stands "
      "united — one behind the other, silently judging.",
  passageTranslation:
      'La cola británica no es, como a veces imaginan los visitantes, una '
      'fila de personas. Es una institución moral. Cuélate en una parada '
      'de autobús y nadie dirá una palabra: precisamente así sabrás que '
      'has cometido un crimen. Un «vaya, hombre» murmurado desde atrás '
      'es, en términos de cola, un motín. No somos, todo hay que decirlo, '
      'una nación dada a la confrontación. Preferimos nuestra furia '
      'filtrada por cejas alzadas y un «no, no, usted primero» servido a '
      'una temperatura ligeramente bajo cero. A los amigos extranjeros '
      'bien puede resultarles agotador. Lo es. Pero, al fin y al cabo, la '
      'cola es el único lugar donde todo británico, sea cual sea su '
      'política, permanece unido: uno detrás de otro, juzgando en '
      'silencio.',
  intro: 'Una columna de humor sobre la cola británica: ironía, lítote y '
      'ritmo de columnista.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La ironía estructural',
      text: 'El texto dice "nadie dirá nada" y lo presenta como condena '
          'máxima: la ironía vive en el contraste, no en las palabras.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How do you know you have committed a "crime" in a queue?',
      options: [
        'People shout at you',
        'Nobody says a word',
        'The police arrive',
      ],
      correctIndex: 1,
      questionTranslation: '¿Cómo sabes que has cometido un "crimen" en la cola?',
    ),
    ReadingQuestion(
      question: 'What counts as "a riot" in queueing terms?',
      options: [
        'A muttered "well, really"',
        'A fight',
        'Calling the driver',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué cuenta como "motín" en términos de cola?',
    ),
    ReadingQuestion(
      question: 'What tone does the columnist use throughout?',
      options: ['Angry', 'Ironic and affectionate', 'Neutral and academic'],
      correctIndex: 1,
      questionTranslation: '¿Qué tono usa el columnista?',
    ),
  ],
);

final QuizContent esEnC21Dict = esEnDict(
  id: 'es_en_c2_1_dict',
  title: 'Dictado: habla nativa',
  intro: 'Frases con idioms, elipsis y modalidad fina, dichas a velocidad '
      'natural.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El idiom es un bloque',
      text: 'Si reconoces el arranque (it cost an arm…), el resto del '
          'bloque se escribe solo. Aprende los bloques, no las palabras.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Fue la gota que colmó el vaso.', answer: 'It was the last straw.'),
    CourseItem(prompt: 'Creo que sí, pero no me hagas caso.', answer: 'I think so, but do not take my word for it.'),
    CourseItem(prompt: 'No hacía falta que trajeras nada.', answer: 'You need not have brought anything.'),
    CourseItem(prompt: 'Ya puestos, terminemos hoy.', answer: 'We might as well finish today.'),
    CourseItem(prompt: 'A mí también me sorprendió.', answer: 'So was I surprised.', accepted: ['I was surprised too.']),
    CourseItem(prompt: 'Costó un ojo de la cara.', answer: 'It cost an arm and a leg.'),
    CourseItem(prompt: 'Bien puede que tengan razón.', answer: 'They may well be right.'),
    CourseItem(prompt: 'No está nada mal para empezar.', answer: 'Not bad at all for a start.'),
    CourseItem(prompt: 'Se me fue por completo de la cabeza.', answer: 'It completely slipped my mind.'),
    CourseItem(prompt: 'Al fin y al cabo, salió bien.', answer: 'At the end of the day, it went well.'),
    CourseItem(prompt: '¿Cómo te atreves?', answer: 'How dare you?'),
    CourseItem(prompt: 'Consultémoslo con la almohada.', answer: 'Let us sleep on it.'),
    CourseItem(prompt: 'Espero que no.', answer: 'I hope not.'),
    CourseItem(prompt: 'Estamos todos en el mismo barco.', answer: 'We are all in the same boat.'),
    CourseItem(prompt: 'Más te vale no llegar tarde.', answer: 'You had better not be late.'),
  ],
);

final QuizContent esEnC21BigText = esEnBigText(
  id: 'es_en_c2_1_bigtext',
  title: 'Texto: The review',
  passageTitle: 'Restaurant review: The Golden Fork',
  intro: 'Completa una reseña irónica: idioms, lítotes y modalidad fina.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Lee el tono primero',
      text: 'La reseña elogia frenando y critica sonriendo. Cada hueco '
          'pide la pieza que mantiene esa temperatura.',
    ),
  ],
  template:
      'The Golden Fork is not exactly {{0}} — dinner for two cost an arm '
      'and a {{1}} — but the cooking is not bad at {{2}}. The famous fish '
      'pie may {{3}} be the best in the city, though the waiter who '
      'described it for six full minutes was, shall we say, none too '
      '{{4}}. Service is a bit of a {{5}}: our starters arrived before '
      'the menus, and the wine never arrived at all. "It slipped my '
      '{{6}}," the waiter admitted, which at least had the charm of '
      'honesty. Would I go back? I think {{7}}. The chef clearly knows '
      'his craft, and at the end of the {{8}}, one forgives a great deal '
      'for pastry like that. But I might as {{9}} book somewhere quieter '
      'for the conversation.',
  blanks: [
    inputBlank('cheap'),
    inputBlank('leg'),
    inputBlank('all'),
    inputBlank('well'),
    inputBlank('brief', accepted: ['quick', 'short']),
    inputBlank('problem', accepted: ['mess', 'lottery']),
    inputBlank('mind'),
    inputBlank('so'),
    inputBlank('day'),
    inputBlank('well'),
  ],
  passageTranslation:
      'The Golden Fork no es precisamente barato — la cena para dos costó '
      'un ojo de la cara — pero la cocina no está nada mal. El famoso '
      'pastel de pescado bien puede ser el mejor de la ciudad, aunque el '
      'camarero que lo describió durante seis minutos completos no fue, '
      'digamos, precisamente breve. El servicio es un pequeño problema: '
      'los entrantes llegaron antes que las cartas, y el vino no llegó '
      'jamás. «Se me fue de la cabeza», admitió el camarero, lo que al '
      'menos tuvo el encanto de la honestidad. ¿Volvería? Creo que sí. El '
      'chef claramente domina su oficio y, al fin y al cabo, se perdona '
      'mucho por un hojaldre así. Pero ya puestos reservaré un sitio más '
      'tranquilo para conversar.',
);

final QuizContent esEnC21SpeakingClose = esEnSpeaking(
  id: 'es_en_c2_1_speaking_close',
  title: 'Conversación final: humor y matiz',
  level: 'C2.1',
  topic: 'Tell me about a disaster that turned out fine — a trip, a meal, '
      'a project — told with irony and understatement, British style. Then '
      'we review a plan together and you push back with softened but firm '
      'disagreement.',
  practisePoints: [
    'A story told with understatement and irony',
    'Idioms placed naturally at key moments',
    'Ellipsis in the back-and-forth: so do I, I hope not, neither did we',
    'Firm but soft disagreement',
  ],
  scoringCriteria: [
    'Humour lands through language, not volume',
    'Idioms and litotes accurate',
    'Natural short responses with ellipsis',
  ],
  priorityErrors: [
    'idioms misquoted',
    'irony explained instead of performed',
    'full sentences where a native would use two words',
  ],
  mode: SpeakingMode.conversation,
  intro: 'Cierre del módulo C2.1: cuenta un desastre con flema. Copia, '
      'habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Frena el adjetivo',
      text: 'Donde dirías terrible, di "not ideal". El público C2 oye el '
          'freno y entiende la magnitud.',
    ),
  ],
);

/// C2.1 in chain order.
final List<QuizContent> esEnC2_1 = [
  esEnC21Idioms,
  esEnC21Ellipsis,
  esEnC21Modality,
  esEnC21Understatement,
  esEnC21ListenBanter,
  esEnC21SpeakingMid,
  esEnC21ReadColumn,
  esEnC21Dict,
  esEnC21BigText,
  esEnC21SpeakingClose,
];
