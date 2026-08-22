import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// C1.1 — Abstraction & precision. English → Spanish.
///
/// Big rocks: advanced subjunctive terrain (concessives, aunque + mood
/// shading, compound subjunctive), lo + adjective, nominal style,
/// collocations, and the connectors of cause and consequence.

final QuizContent enEsC11PerfectSubj = enEsFill(
  id: 'en_es_c1_1_perfect_subj',
  title: 'The compound subjunctives: haya/hubiera hecho',
  intro: 'The subjunctive climbs into the perfect: Me alegra que hayas '
      'venido (present perfect subj.) · Si hubiera sabido, habría venido '
      '(pluperfect subj. — the unreal past).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The unreal past formula',
      text: 'si + hubiera + participle, habría + participle. Si hubiera '
          'estudiado, habría aprobado — Spanish\'s third conditional.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I\'m glad you have come. (tú)', answer: 'Me alegra que **hayas** venido.'),
    CourseItem(prompt: 'If I had known, I would have come.', answer: 'Si **hubiera** sabido, habría venido.'),
    CourseItem(prompt: 'I don\'t think they have arrived.', answer: 'No creo que **hayan** llegado.'),
    CourseItem(prompt: 'If you had studied, you would have passed. (tú)', answer: 'Si hubieras estudiado, **habrías** aprobado.'),
    CourseItem(prompt: 'It\'s a pity that he has left.', answer: 'Es una pena que se **haya** ido.'),
    CourseItem(prompt: 'If it hadn\'t rained, we would have gone out.', answer: 'Si no **hubiera** llovido, habríamos salido.'),
    CourseItem(prompt: 'I hope you have slept well. (tú)', answer: 'Espero que **hayas** dormido bien.'),
    CourseItem(prompt: 'We would have arrived earlier if we had left at eight.', answer: 'Habríamos llegado antes si **hubiéramos** salido a las ocho.'),
    CourseItem(prompt: 'I doubt she has read it.', answer: 'Dudo que lo **haya** leído.'),
    CourseItem(prompt: 'If they had told me, I would have helped.', answer: 'Si me lo **hubieran** dicho, habría ayudado.'),
    CourseItem(prompt: 'It surprises me that nobody has complained.', answer: 'Me sorprende que nadie se **haya** quejado.'),
    CourseItem(prompt: 'I wish I had seen it! (ojalá)', answer: '¡Ojalá lo **hubiera** visto!'),
    CourseItem(prompt: 'It\'s possible that they have forgotten.', answer: 'Es posible que se **hayan** olvidado.'),
    CourseItem(prompt: 'Without your help, I wouldn\'t have finished.', answer: 'Sin tu ayuda, no **habría** terminado.'),
    CourseItem(prompt: 'I wish it had lasted longer! (ojalá, durar)', answer: '¡Ojalá **hubiera** durado más!'),
  ],
);

final QuizContent enEsC11LoAbstract = enEsFill(
  id: 'en_es_c1_1_lo_abstract',
  title: 'lo + adjective: the abstract article',
  intro: 'Spanish\'s abstraction machine: lo bueno = the good thing, lo '
      'difícil = the hard part, lo de ayer = that business yesterday.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Instant nouns',
      text: 'lo + any adjective mints an abstract noun: lo importante, '
          'lo curioso, lo mejor. English needs "the … thing"; Spanish '
          'needs two letters.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The good thing is that we have time.', answer: '**Lo** bueno es que tenemos tiempo.'),
    CourseItem(prompt: 'The hard part is starting.', answer: '**Lo** difícil es empezar.'),
    CourseItem(prompt: 'The best (part) is the end.', answer: '**Lo** mejor es el final.'),
    CourseItem(prompt: 'The curious thing is that nobody knew.', answer: '**Lo** curioso es que nadie lo sabía.'),
    CourseItem(prompt: 'That business about yesterday worries me.', answer: '**Lo** de ayer me preocupa.'),
    CourseItem(prompt: 'The important thing is to take part.', answer: '**Lo** importante es participar.'),
    CourseItem(prompt: 'You don\'t know how difficult it is. (lo … que)', answer: 'No sabes **lo** difícil que es.'),
    CourseItem(prompt: 'The strange thing is his silence.', answer: '**Lo** extraño es su silencio.'),
    CourseItem(prompt: 'The worst was the wait.', answer: '**Lo** peor fue la espera.'),
    CourseItem(prompt: 'Do what you can. (lo que)', answer: 'Haz **lo** que puedas.'),
    CourseItem(prompt: 'The modern part of the city.', answer: '**Lo** moderno de la ciudad.'),
    CourseItem(prompt: 'I was surprised by how fast it went. (lo rápido que)', answer: 'Me sorprendió **lo** rápido que fue.'),
    CourseItem(prompt: 'That thing about the tickets is solved.', answer: '**Lo** de las entradas está resuelto.'),
    CourseItem(prompt: 'The essential thing is not to give up.', answer: '**Lo** esencial es no rendirse.'),
    CourseItem(prompt: 'At worst, we\'ll walk. (en lo peor de los casos → en el peor de los casos)', answer: 'En el **peor** de los casos, caminaremos.'),
  ],
);

final QuizContent enEsC11Concessives = enEsFill(
  id: 'en_es_c1_1_concessives',
  title: 'Concessives: por mucho que, a pesar de que',
  intro: 'The art of conceding: por mucho que insistas (however much '
      'you insist), a pesar de que, aun cuando, y eso que. Mood signals '
      'how real the concession is.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'por + adjective/adverb + que',
      text: 'Por difícil que sea (however hard it may be), por mucho '
          'que trabajes — this mould always takes the subjunctive.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'However much you insist, I won\'t go. (tú)', answer: 'Por mucho que **insistas**, no iré.'),
    CourseItem(prompt: 'However hard it may be, we\'ll finish it.', answer: 'Por difícil que **sea**, lo terminaremos.'),
    CourseItem(prompt: 'In spite of the fact that it was raining, we went out.', answer: 'A pesar de que **llovía**, salimos.'),
    CourseItem(prompt: 'However much it costs, buy it. (costar)', answer: 'Por mucho que **cueste**, cómpralo.'),
    CourseItem(prompt: 'Even when nobody believes him, he keeps trying.', answer: 'Aun cuando nadie le **cree**, sigue intentándolo.'),
    CourseItem(prompt: 'However fast you run, you won\'t catch it. (tú)', answer: 'Por rápido que **corras**, no lo alcanzarás.'),
    CourseItem(prompt: 'And that despite the fact that he had studied! (y eso que)', answer: '¡Y **eso** que había estudiado!'),
    CourseItem(prompt: 'However much money he has, he isn\'t happy.', answer: 'Por mucho dinero que **tenga**, no es feliz.'),
    CourseItem(prompt: 'Although I understand it, I don\'t share it.', answer: 'Aunque lo **entiendo**, no lo comparto.'),
    CourseItem(prompt: 'However you look at it, it\'s a mistake. (mirar)', answer: 'Se **mire** como se mire, es un error.'),
    CourseItem(prompt: 'In spite of everything, we are still friends.', answer: 'A **pesar** de todo, seguimos siendo amigos.'),
    CourseItem(prompt: 'However little you sleep, get up early. (tú)', answer: 'Por poco que **duermas**, levántate temprano.'),
    CourseItem(prompt: 'Even if they pay me double, I won\'t accept.', answer: 'Aunque me **paguen** el doble, no aceptaré.'),
    CourseItem(prompt: 'Say what they may, the plan works. (decir)', answer: 'Digan lo que **digan**, el plan funciona.'),
    CourseItem(prompt: 'However strange it may seem, it\'s true.', answer: 'Por extraño que **parezca**, es verdad.'),
  ],
);

final QuizContent enEsC11Collocations = enEsVocab(
  id: 'en_es_c1_1_collocations',
  title: 'Strong collocations',
  intro: 'The word pairs natives reach for without thinking. Knowing '
      'them is sounding natural; missing them is sounding translated.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Don\'t translate the pair',
      text: '"tomar una decisión" (not hacer), "prestar atención" (not '
          'pagar), "dar un paseo" (not tomar). The pair comes whole.',
    ),
  ],
  pairs: const [
    MapEntry('to make a decision', 'tomar una decisión'),
    MapEntry('to pay attention', 'prestar atención'),
    MapEntry('to take a walk', 'dar un paseo'),
    MapEntry('to draw a conclusion', 'sacar una conclusión'),
    MapEntry('to play a role', 'desempeñar un papel'),
    MapEntry('to meet a deadline', 'cumplir un plazo'),
    MapEntry('to run a risk', 'correr un riesgo'),
    MapEntry('to reach an agreement', 'llegar a un acuerdo'),
    MapEntry('to make an effort', 'hacer un esfuerzo'),
    MapEntry('heavy rain', 'una lluvia torrencial'),
    MapEntry('a resounding success', 'un éxito rotundo'),
    MapEntry('in-depth knowledge', 'un conocimiento profundo'),
  ],
);

final QuizContent enEsC11ListenLecture = enEsListen(
  id: 'en_es_c1_1_listen_lecture',
  title: 'Listening: La conferencia',
  passageTitle: '¿Por qué crecen las ciudades?',
  passage:
      '¿Por qué crecen unas ciudades mientras otras se vacían? En '
      'términos generales, los investigadores señalan tres factores. '
      'Primero, el empleo: la gente sigue al trabajo, y las empresas '
      'siguen al talento — un círculo del que es difícil salir. Segundo, '
      'las universidades desempeñan un papel mayor de lo que se creía: '
      'los graduados suelen quedarse donde estudiaron. Tercero, y quizá '
      'sea lo más importante, la vivienda. Por mucho que crezca el '
      'empleo, si no se construyen casas, el crecimiento se va a otra '
      'parte. Lo curioso es que los precios altos expulsan precisamente '
      'a las empresas que iniciaron el círculo.',
  passageTranslation:
      'Why do some cities grow while others empty out? Broadly speaking, '
      'researchers point to three factors. First, employment: people '
      'follow work, and companies follow talent — a circle that is hard '
      'to leave. Second, universities play a bigger role than was '
      'believed: graduates tend to stay where they studied. Third, and '
      'perhaps most importantly, housing. However much employment grows, '
      'if houses are not built, the growth goes elsewhere. The curious '
      'thing is that high prices expel precisely the companies that '
      'started the circle.',
  intro: 'A mini-lecture: concessives, lo + adjective and collocations '
      'in spoken academic Spanish.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for the scaffolding',
      text: 'Primero… Segundo… Tercero, y quizá sea lo más importante… — '
          'the numbered skeleton is your map of any academic audio.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cuántos factores menciona la conferencia?',
      options: ['Dos', 'Tres', 'Cuatro'],
      correctIndex: 1,
      questionTranslation: 'How many factors does the lecture mention?',
    ),
    ReadingQuestion(
      question: '¿Qué suelen hacer los graduados?',
      options: [
        'Irse al extranjero',
        'Quedarse donde estudiaron',
        'Cambiar de carrera',
      ],
      correctIndex: 1,
      questionTranslation: 'What do graduates tend to do?',
    ),
    ReadingQuestion(
      question: '¿Qué factor es quizá el más importante?',
      options: ['El empleo', 'Las universidades', 'La vivienda'],
      correctIndex: 2,
      questionTranslation: 'Which factor is perhaps the most important?',
    ),
  ],
);

final QuizContent enEsC11SpeakingMid = enEsSpeaking(
  id: 'en_es_c1_1_speaking_mid',
  title: 'Conversation: analyse a trend',
  level: 'C1.1',
  topic: 'An analytical discussion in Spanish: pick a trend you know '
      'well (in your city, industry or generation), explain causes and '
      'effects, and qualify your claims like an analyst.',
  practisePoints: [
    'Qualified claims: es posible que, quizá + subjunctive',
    'Concessions: por mucho que…, a pesar de que…',
    'lo + adjective abstractions: lo preocupante es que…',
  ],
  scoringCriteria: [
    'Mood control across triggers and concessives',
    'Formal collocations used accurately',
    'Analysis structured, not listed',
  ],
  priorityErrors: [
    'indicative after por … que',
    'literal English collocations',
    'absolute claims without hedging',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: analyse a trend for a committee, in Spanish. '
      'Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Think in columns',
      text: 'Causas / efectos / matices. One minute per column beats ten '
          'scattered opinions.',
    ),
  ],
);

final QuizContent enEsC11ReadEssay = enEsRead(
  id: 'en_es_c1_1_read_essay',
  title: 'Reading: La paradoja de elegir',
  passageTitle: 'La paradoja de elegir',
  passage:
      'Se suele suponer que cuantas más opciones tenemos, más felices '
      'somos. La evidencia, sin embargo, apunta en otra dirección. En un '
      'estudio célebre, los clientes a quienes se ofrecieron '
      'veinticuatro variedades de mermelada compraron mucho menos que '
      'aquellos a quienes se ofrecieron solo seis. Lo paradójico es que '
      'el aumento de opciones parece elevar el coste de cada decisión: '
      'con tantas alternativas, el miedo a equivocarse pesa más que el '
      'placer de elegir. No se trata de que la variedad sea indeseable '
      '— se trata de que sus beneficios se estancan sorprendentemente '
      'pronto. Por muchas mermeladas que añadamos al estante, la número '
      'veinticuatro rara vez hace más feliz a nadie.',
  passageTranslation:
      'It is usually assumed that the more options we have, the happier '
      'we are. The evidence, however, points in another direction. In a '
      'famous study, customers who were offered twenty-four varieties '
      'of jam bought far less than those offered only six. The '
      'paradoxical thing is that the increase in options seems to raise '
      'the cost of every decision: with so many alternatives, the fear '
      'of choosing wrongly weighs more than the pleasure of choosing. '
      'It is not that variety is undesirable — it is that its benefits '
      'flatten out surprisingly early. However many jams we add to the '
      'shelf, jam number twenty-four rarely makes anyone happier.',
  intro: 'A mini-essay with the module\'s full machinery: impersonal se, '
      'lo + adjective, concessives and hedged claims.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'No se trata de que…',
      text: '"It is not that…" + subjunctive — an elegant way to head '
          'off a misreading before it happens. Steal it for essays.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué pasó con veinticuatro variedades?',
      options: [
        'La gente compró más',
        'La gente compró mucho menos',
        'Se acabó la mermelada',
      ],
      correctIndex: 1,
      questionTranslation: 'What happened with twenty-four varieties?',
    ),
    ReadingQuestion(
      question: '¿Qué parece elevar el aumento de opciones?',
      options: [
        'El coste de cada decisión',
        'El placer de comprar',
        'El precio de la mermelada',
      ],
      correctIndex: 0,
      questionTranslation: 'What does the increase in options seem to raise?',
    ),
    ReadingQuestion(
      question: '¿Piensa el autor que la variedad es indeseable?',
      options: [
        'Sí, totalmente',
        'No — solo que sus beneficios se estancan pronto',
        'El texto no lo dice',
      ],
      correctIndex: 1,
      questionTranslation: 'Does the author think variety is undesirable?',
    ),
  ],
);

final QuizContent enEsC11SpeakFlow = enEsSpeak(
  id: 'en_es_c1_1_speak_flow',
  title: 'Speak: the academic rhythm',
  intro: 'Long sentences with subordinate clauses: the challenge is '
      'breathing where Spanish breathes. Listen for the pauses and copy '
      'them.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pause at the mental comma',
      text: 'La evidencia, sin embargo, apunta… — sin embargo lives '
          'between pauses. Those micro-pauses are formal Spanish\'s '
          'spoken commas.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The evidence, however, points elsewhere.', answer: 'La evidencia, sin embargo, apunta en otra dirección.'),
    CourseItem(prompt: 'Broadly speaking, the trend is clear.', answer: 'En términos generales, la tendencia es clara.'),
    CourseItem(prompt: 'However strange it may seem, it works.', answer: 'Por extraño que parezca, funciona.'),
    CourseItem(prompt: 'The worrying thing is the speed of the change.', answer: 'Lo preocupante es la velocidad del cambio.'),
    CourseItem(prompt: 'It could be argued that the cost matters more.', answer: 'Podría argumentarse que el coste importa más.'),
    CourseItem(prompt: 'This raises an uncomfortable question.', answer: 'Esto plantea una pregunta incómoda.'),
    CourseItem(prompt: 'To a certain extent, both models work.', answer: 'Hasta cierto punto, ambos modelos funcionan.'),
    CourseItem(prompt: 'It is not that it is impossible.', answer: 'No es que sea imposible.'),
  ],
);

final QuizContent enEsC11Dict = enEsDict(
  id: 'en_es_c1_1_dict',
  title: 'Dictation: formal register',
  intro: 'Academic sentences at dictation speed: compound subjunctives, '
      'lo-abstractions and concessives.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Anticipate the structure',
      text: 'Hear "por mucho que" and you already know a subjunctive is '
          'coming. Let the grammar predict the words.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'If I had known, I would have come.', answer: 'Si hubiera sabido, habría venido.'),
    CourseItem(prompt: 'The important thing is not to give up.', answer: 'Lo importante es no rendirse.'),
    CourseItem(prompt: 'However much it costs, it is worth it.', answer: 'Por mucho que cueste, vale la pena.'),
    CourseItem(prompt: 'I\'m glad you have come.', answer: 'Me alegra que hayas venido.'),
    CourseItem(prompt: 'We have to make a decision today.', answer: 'Tenemos que tomar una decisión hoy.'),
    CourseItem(prompt: 'It is usually assumed that more is better.', answer: 'Se suele suponer que más es mejor.'),
    CourseItem(prompt: 'However strange it may seem, it\'s true.', answer: 'Por extraño que parezca, es verdad.'),
    CourseItem(prompt: 'The curious thing is that nobody knew.', answer: 'Lo curioso es que nadie lo sabía.'),
    CourseItem(prompt: 'This plays a fundamental role.', answer: 'Esto desempeña un papel fundamental.'),
    CourseItem(prompt: 'I wish they had told me!', answer: '¡Ojalá me lo hubieran dicho!'),
    CourseItem(prompt: 'In spite of everything, the plan worked.', answer: 'A pesar de todo, el plan funcionó.'),
    CourseItem(prompt: 'It is not that variety is undesirable.', answer: 'No es que la variedad sea indeseable.'),
    CourseItem(prompt: 'We reached an agreement at last.', answer: 'Por fin llegamos a un acuerdo.'),
    CourseItem(prompt: 'You don\'t know how difficult it was.', answer: 'No sabes lo difícil que fue.'),
    CourseItem(prompt: 'Say what they may, the data are clear.', answer: 'Digan lo que digan, los datos son claros.'),
  ],
);

final QuizContent enEsC11BigText = enEsBigText(
  id: 'en_es_c1_1_bigtext',
  title: 'Big text: El informe',
  passageTitle: 'El informe trimestral',
  intro: 'Complete a formal report: compound subjunctives, '
      'lo-abstractions, concessives and collocations.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Report tone',
      text: 'No "creo que" here: this text runs on se supone, lo '
          'preocupante, por mucho que and their formal cousins.',
    ),
  ],
  template:
      'La caída de ventas en la región norte {{0}} un papel central en '
      'los resultados del trimestre. {{1}} preocupante no es la cifra en '
      'sí, sino la tendencia. Si el equipo {{2}} recibido los materiales '
      'a tiempo, los resultados habrían {{3}} otros. Por mucho que se '
      '{{4}} en marketing, sin distribución no hay ventas. Se ha llegado '
      'a un {{5}} con dos nuevos socios, y es posible que la situación '
      '{{6}} mejorado ya en junio. {{7}} pesar de todo, el equipo ha '
      'hecho un gran {{8}}. Digan lo que {{9}}, la recuperación está en '
      'marcha.',
  blanks: [
    inputBlank('desempeña', accepted: ['juega']),
    inputBlank('Lo'),
    inputBlank('hubiera'),
    inputBlank('sido'),
    inputBlank('invierta'),
    inputBlank('acuerdo'),
    inputBlank('haya'),
    inputBlank('A'),
    inputBlank('esfuerzo'),
    inputBlank('digan'),
  ],
  passageTranslation:
      'The fall in sales in the northern region plays a central role in '
      'the quarter\'s results. The worrying thing is not the figure '
      'itself but the trend. If the team had received the materials on '
      'time, the results would have been different. However much is '
      'invested in marketing, without distribution there are no sales. '
      'An agreement has been reached with two new partners, and it is '
      'possible that the situation has already improved by June. In '
      'spite of everything, the team has made a great effort. Say what '
      'they may, the recovery is under way.',
);

final QuizContent enEsC11SpeakingClose = enEsSpeaking(
  id: 'en_es_c1_1_speaking_close',
  title: 'Final conversation: the presentation',
  level: 'C1.1',
  topic: 'Present a topic you know deeply, in Spanish, to an expert '
      'audience (me), then take challenging questions and defend your '
      'analysis with qualified, precise language.',
  practisePoints: [
    'A structured argument: causes, effects, qualifications',
    'Formal register: collocations and lo-abstractions',
    'Concessions under pressure: por mucho que…, aunque sea cierto que…',
    'Unreal pasts where relevant: si hubiéramos…, habríamos…',
  ],
  scoringCriteria: [
    'Register consistently formal',
    'Mood control near-perfect',
    'Claims defended, not repeated',
  ],
  targetVocabulary: [
    'lo preocupante', 'por mucho que', 'desempeñar un papel',
    'sacar conclusiones', 'a pesar de que',
  ],
  priorityErrors: [
    'register drops to casual',
    'indicative in concessive moulds',
    'English collocations translated word by word',
  ],
  mode: SpeakingMode.roleplay,
  intro: 'Module C1.1 closer: a presentation with friendly-hostile '
      'questions. Copy, present, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The elegant concession',
      text: 'Puede que tenga razón hasta cierto punto; sin embargo… — '
          'concede a centimetre to win the metre.',
    ),
  ],
);

/// C1.1 in chain order.
final List<QuizContent> enEsC1_1 = [
  enEsC11PerfectSubj,
  enEsC11LoAbstract,
  enEsC11Concessives,
  enEsC11Collocations,
  enEsC11ListenLecture,
  enEsC11SpeakingMid,
  enEsC11ReadEssay,
  enEsC11SpeakFlow,
  enEsC11Dict,
  enEsC11BigText,
  enEsC11SpeakingClose,
];
