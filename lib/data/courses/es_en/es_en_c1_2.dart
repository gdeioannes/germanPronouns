import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// C1.2 — Registro y retórica. Spanish → English.
///
/// Big rocks: switching between formal and informal register (⚑S30), cleft
/// sentences for focus, participle clauses for economy, discourse markers,
/// and the verbs of academic writing.

final QuizContent esEnC12Register = esEnFill(
  id: 'es_en_c1_2_register',
  title: 'Registro: de coloquial a formal',
  intro: 'La misma idea, dos trajes: get → receive, ask for → request, '
      'find out → discover. Elegir el traje correcto ES el C1.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La palanca latina',
      text: 'Tu ventaja: el registro formal inglés es latino. request, '
          'obtain, demonstrate te suenan porque son casi español.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'get → (formal) recibir', answer: 'get → **receive**'),
    CourseItem(prompt: 'ask for → (formal) solicitar', answer: 'ask for → **request**'),
    CourseItem(prompt: 'find out → (formal) descubrir', answer: 'find out → **discover**'),
    CourseItem(prompt: 'help → (formal) ayudar', answer: 'help → **assist**'),
    CourseItem(prompt: 'buy → (formal) adquirir', answer: 'buy → **purchase**'),
    CourseItem(prompt: 'show → (formal) demostrar', answer: 'show → **demonstrate**'),
    CourseItem(prompt: 'need → (formal) requerir', answer: 'need → **require**'),
    CourseItem(prompt: 'start → (formal) comenzar', answer: 'start → **commence**'),
    CourseItem(prompt: 'Solicitamos una copia del contrato.', answer: 'We **request** a copy of the contract.'),
    CourseItem(prompt: 'El estudio demuestra un vínculo claro.', answer: 'The study **demonstrates** a clear link.'),
    CourseItem(prompt: 'El puesto requiere experiencia previa.', answer: 'The position **requires** previous experience.'),
    CourseItem(prompt: 'Recibí su carta el lunes.', answer: 'I **received** your letter on Monday.'),
    CourseItem(prompt: 'La empresa adquirió dos edificios.', answer: 'The company **purchased** two buildings.'),
    CourseItem(prompt: 'Descubrimos un error en los datos.', answer: 'We **discovered** an error in the data.'),
    CourseItem(prompt: 'Estaremos encantados de ayudarle.', answer: 'We will be happy to **assist** you.'),
  ],
);

final QuizContent esEnC12Clefts = esEnFill(
  id: 'es_en_c1_2_clefts',
  title: 'Foco: It was… that / What I need is…',
  intro: 'Para enfocar una parte de la frase: It was the price that '
      'surprised me · What I need is time. El español hace lo mismo: "lo '
      'que necesito es…".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Dos moldes',
      text: 'It + be + FOCO + that… (para señalar) · What + frase + be… '
          '(para anunciar). Ambos existen en español: úsalos igual.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Fue el precio lo que me sorprendió.', answer: 'It was the price **that** surprised me.'),
    CourseItem(prompt: 'Lo que necesito es tiempo.', answer: '**What** I need is time.'),
    CourseItem(prompt: 'Fue Ana quien encontró el error.', answer: 'It was Ana **who** found the error.'),
    CourseItem(prompt: 'Lo que más me molesta es el ruido.', answer: '**What** annoys me most is the noise.'),
    CourseItem(prompt: 'Fue en Roma donde nos conocimos.', answer: 'It was in Rome **that** we met.'),
    CourseItem(prompt: 'Lo que hizo fue vender el coche.', answer: 'What he did **was** sell the car.'),
    CourseItem(prompt: 'Fue ayer cuando llegó la noticia.', answer: 'It was yesterday **that** the news arrived.'),
    CourseItem(prompt: 'Lo que importa es la calidad.', answer: '**What** matters is quality.'),
    CourseItem(prompt: 'Fue su tono lo que ofendió a todos.', answer: 'It was his tone **that** offended everyone.'),
    CourseItem(prompt: 'Lo que quiero decir es esto.', answer: '**What** I mean is this.'),
    CourseItem(prompt: 'Fue el gerente quien tomó la decisión.', answer: 'It was the manager **who** made the decision.'),
    CourseItem(prompt: 'Lo que me encanta de Londres son los parques.', answer: '**What** I love about London is the parks.'),
    CourseItem(prompt: 'Fue entonces cuando lo comprendí.', answer: 'It was then **that** I understood.'),
    CourseItem(prompt: 'Lo que falta es un plan claro.', answer: 'What is **missing** is a clear plan.'),
    CourseItem(prompt: 'No fue el dinero, sino el tiempo, lo que faltó.', answer: 'It was not the money but the time **that** was lacking.'),
  ],
);

final QuizContent esEnC12Participles = esEnFill(
  id: 'es_en_c1_2_participles',
  title: 'Frases de participio: Having finished…',
  intro: 'Economía elegante: Having finished the report, she left = '
      'habiendo terminado… · Built in 1900, the bridge… = construido en…',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'El sujeto debe coincidir',
      text: '"Walking home, the rain started" ✗ (la lluvia no caminaba). El '
          'sujeto de la principal debe ser quien hace el participio.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Habiendo terminado el informe, se fue.', answer: '**Having** finished the report, she left.'),
    CourseItem(prompt: 'Construido en 1900, el puente sigue en pie.', answer: '**Built** in 1900, the bridge still stands.'),
    CourseItem(prompt: 'Sin saber qué decir, guardé silencio.', answer: 'Not **knowing** what to say, I stayed silent.'),
    CourseItem(prompt: 'Al vivir cerca, siempre llega el primero.', answer: '**Living** nearby, he always arrives first.'),
    CourseItem(prompt: 'Escrito con prisa, el correo tenía errores.', answer: '**Written** in a hurry, the email had mistakes.'),
    CourseItem(prompt: 'Habiendo perdido el tren, cogimos un taxi.', answer: '**Having** missed the train, we took a taxi.'),
    CourseItem(prompt: 'Vista desde arriba, la ciudad parece un mapa.', answer: '**Seen** from above, the city looks like a map.'),
    CourseItem(prompt: 'Al no tener respuesta, volví a llamar.', answer: '**Having** received no answer, I called again.'),
    CourseItem(prompt: 'Trabajando juntos, terminaron en un día.', answer: '**Working** together, they finished in a day.'),
    CourseItem(prompt: 'Rodeada de montañas, la aldea queda aislada.', answer: '**Surrounded** by mountains, the village is isolated.'),
    CourseItem(prompt: 'Habiendo vivido allí, conozco sus problemas.', answer: '**Having** lived there, I know its problems.'),
    CourseItem(prompt: 'Agotados por el viaje, se durmieron pronto.', answer: '**Exhausted** by the trip, they fell asleep early.'),
    CourseItem(prompt: 'Hablando claro: no hay presupuesto.', answer: '**Speaking** plainly: there is no budget.'),
    CourseItem(prompt: 'Una vez firmado, el contrato es definitivo.', answer: 'Once **signed**, the contract is final.'),
    CourseItem(prompt: 'Al comparar los datos, surge un patrón.', answer: '**Comparing** the data, a pattern emerges.'),
  ],
);

final QuizContent esEnC12Discourse = esEnVocab(
  id: 'es_en_c1_2_discourse',
  title: 'Marcadores del discurso',
  intro: 'Las bisagras del texto culto: para reformular, conceder, '
      'ejemplificar y concluir.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Un set por función',
      text: 'Reformular: in other words · conceder: admittedly · ejemplo: '
          'for instance · concluir: in short. Uno bueno de cada basta.',
    ),
  ],
  pairs: const [
    MapEntry('en otras palabras', 'in other words'),
    MapEntry('es decir', 'that is to say'),
    MapEntry('hay que admitir que', 'admittedly'),
    MapEntry('por ejemplo (formal)', 'for instance'),
    MapEntry('en resumen', 'in short'),
    MapEntry('en cuanto a', 'as for'),
    MapEntry('con respecto a', 'with regard to'),
    MapEntry('no obstante', 'nevertheless'),
    MapEntry('por consiguiente', 'consequently'),
    MapEntry('en último término', 'ultimately'),
    MapEntry('dicho esto', 'that said'),
    MapEntry('en cierto sentido', 'in a sense'),
  ],
);

final QuizContent esEnC12ListenDebateShow = esEnListen(
  id: 'es_en_c1_2_listen_debate',
  title: 'Escucha: The panel discussion',
  passageTitle: 'Should museums be free?',
  passage:
      "Should museums be free? Admittedly, free entry sounds generous — "
      "but somebody always pays. What free museums actually do is shift "
      "the cost from tourists to taxpayers. That said, the evidence from "
      "London is striking: having removed entry fees in 2001, the big "
      "museums saw visits triple, and it was young families, not tourists, "
      "that drove the increase. In other words, the question is not "
      "whether we pay, but what we choose to pay for. Ultimately, a "
      "museum nobody visits is the most expensive museum of all.",
  passageTranslation:
      '¿Deberían ser gratis los museos? Hay que admitir que la entrada '
      'gratuita suena generosa, pero alguien paga siempre. Lo que hacen '
      'realmente los museos gratuitos es trasladar el coste del turista al '
      'contribuyente. Dicho esto, la evidencia de Londres es llamativa: '
      'tras eliminar las entradas en 2001, los grandes museos vieron '
      'triplicarse las visitas, y fueron las familias jóvenes, no los '
      'turistas, quienes impulsaron el aumento. En otras palabras, la '
      'cuestión no es si pagamos, sino qué elegimos pagar. En último '
      'término, un museo que nadie visita es el museo más caro de todos.',
  intro: 'Un panel de debate: marcadores, clefts y participios en audio '
      'real.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Los marcadores son señales de giro',
      text: 'Admittedly (concede), That said (gira), In other words '
          '(resume), Ultimately (cierra). Con oírlos ya tienes el mapa.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What do free museums actually do, according to the speaker?',
      options: [
        'Shift the cost to taxpayers',
        'Lose money for tourists',
        'Reduce quality',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué hacen realmente los museos gratuitos según el ponente?',
    ),
    ReadingQuestion(
      question: 'What happened in London after 2001?',
      options: ['Visits tripled', 'Museums closed', 'Prices rose'],
      correctIndex: 0,
      questionTranslation: '¿Qué pasó en Londres después de 2001?',
    ),
    ReadingQuestion(
      question: 'Who drove the increase in visits?',
      options: ['Tourists', 'Young families', 'Students'],
      correctIndex: 1,
      questionTranslation: '¿Quién impulsó el aumento de visitas?',
    ),
  ],
);

final QuizContent esEnC12SpeakingMid = esEnSpeaking(
  id: 'es_en_c1_2_speaking_mid',
  title: 'Conversación: dos registros',
  level: 'C1.2',
  topic: 'One story, two audiences: first tell me about a problem at work '
      'or in your studies as you would tell a friend; then re-tell exactly '
      'the same events as if reporting formally to a director.',
  practisePoints: [
    'The informal version: phrasal verbs, contractions, casual markers',
    'The formal version: latinate verbs, nominalisations, passives',
    'Keeping the facts identical while the register changes',
  ],
  scoringCriteria: [
    'Clear register contrast between the two versions',
    'Formal vocabulary accurate (request, discover, require)',
    'No register mixing within a version',
  ],
  priorityErrors: [
    'formal words in the casual version and vice versa',
    'phrasal verbs in the formal report',
    'identical wording in both versions',
  ],
  mode: SpeakingMode.roleplay,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: la misma historia en vaqueros y de traje. '
      'Copia, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Cambia el verbo, cambia el traje',
      text: 'find out → discover, ask for → request, sort out → resolve. '
          'Con diez verbos re-vestidos el registro entero gira.',
    ),
  ],
);

final QuizContent esEnC12ReadLetter = esEnRead(
  id: 'es_en_c1_2_read_letter',
  title: 'Lectura: The two emails',
  passageTitle: 'The two emails',
  passage:
      "Version one, to a friend: \"Guess what — the flat above mine flooded "
      "AGAIN and my ceiling's a mess. I've asked the landlord to sort it "
      "out like five times. So annoying!\" Version two, to the landlord: "
      "\"Dear Mr. Hale, I am writing with regard to the water damage to my "
      "ceiling, which occurred on 12 March following a flood in the flat "
      "above. Having reported the issue on five previous occasions, I must "
      "now request that repairs be carried out within fourteen days. "
      "Should the damage remain unaddressed, I will be obliged to contact "
      "the housing authority. Yours sincerely, L. Ortiz.\" Same ceiling, "
      "same water — an entirely different language.",
  passageTranslation:
      'Versión uno, a una amiga: «¿Sabes qué? El piso de arriba se inundó '
      'OTRA VEZ y mi techo está hecho un desastre. Le he pedido al casero '
      'que lo arregle como cinco veces. ¡Qué rabia!» Versión dos, al '
      'casero: «Estimado Sr. Hale: Le escribo con respecto a los daños por '
      'agua en mi techo, ocurridos el 12 de marzo tras una inundación en '
      'el piso superior. Habiendo comunicado el problema en cinco '
      'ocasiones anteriores, me veo obligada a solicitar que las '
      'reparaciones se realicen en un plazo de catorce días. De no '
      'atenderse los daños, me veré obligada a contactar con la autoridad '
      'de vivienda. Atentamente, L. Ortiz.» El mismo techo, la misma agua: '
      'un idioma completamente distinto.',
  intro: 'El mismo problema contado en dos registros. Compara frase a '
      'frase: es la lección entera del módulo.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Roba el molde formal',
      text: 'I am writing with regard to… / Having reported… / I must now '
          'request that… — tres moldes que sirven para cualquier queja '
          'formal de tu vida real.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How many times was the issue reported before?',
      options: ['Three', 'Five', 'Seven'],
      correctIndex: 1,
      questionTranslation: '¿Cuántas veces se había comunicado el problema?',
    ),
    ReadingQuestion(
      question: 'What deadline does the formal email set?',
      options: ['Seven days', 'Fourteen days', 'A month'],
      correctIndex: 1,
      questionTranslation: '¿Qué plazo fija el correo formal?',
    ),
    ReadingQuestion(
      question: 'What will happen if the damage is not repaired?',
      options: [
        'She will contact the housing authority',
        'She will move out',
        'She will stop paying rent',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué pasará si no se reparan los daños?',
    ),
  ],
);

final QuizContent esEnC12Dict = esEnDict(
  id: 'es_en_c1_2_dict',
  title: 'Dictado: prosa culta',
  intro: 'Frases de registro alto al dictado: participios, clefts y '
      'marcadores.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Puntúa mientras escuchas',
      text: 'Los marcadores entre pausas (however, that said) van entre '
          'comas. Oye la pausa, escribe la coma.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Habiendo revisado los datos, cambiamos el plan.', answer: 'Having reviewed the data, we changed the plan.'),
    CourseItem(prompt: 'Fue el silencio lo que más dijo.', answer: 'It was the silence that said the most.'),
    CourseItem(prompt: 'En otras palabras, necesitamos más tiempo.', answer: 'In other words, we need more time.'),
    CourseItem(prompt: 'Lo que propongo es un cambio gradual.', answer: 'What I propose is a gradual change.'),
    CourseItem(prompt: 'Hay que admitir que el riesgo era conocido.', answer: 'Admittedly, the risk was known.'),
    CourseItem(prompt: 'La solicitud debe presentarse por escrito.', answer: 'The request must be submitted in writing.'),
    CourseItem(prompt: 'Una vez firmado, el acuerdo entrará en vigor.', answer: 'Once signed, the agreement will come into force.'),
    CourseItem(prompt: 'No obstante, la junta aprobó el proyecto.', answer: 'Nevertheless, the board approved the project.'),
    CourseItem(prompt: 'Escribo con respecto a su última carta.', answer: 'I am writing with regard to your last letter.'),
    CourseItem(prompt: 'Dicho esto, quedan dudas razonables.', answer: 'That said, reasonable doubts remain.'),
    CourseItem(prompt: 'Al no recibir respuesta, insistimos.', answer: 'Having received no reply, we insisted.'),
    CourseItem(prompt: 'En último término, la decisión es suya.', answer: 'Ultimately, the decision is yours.'),
    CourseItem(prompt: 'El estudio demuestra lo contrario.', answer: 'The study demonstrates the opposite.'),
    CourseItem(prompt: 'Por consiguiente, el plazo se amplía.', answer: 'Consequently, the deadline is extended.'),
    CourseItem(prompt: 'Fue entonces cuando comprendimos el coste.', answer: 'It was then that we understood the cost.'),
  ],
);

final QuizContent esEnC12BigText = esEnBigText(
  id: 'es_en_c1_2_bigtext',
  title: 'Texto: The formal complaint',
  passageTitle: 'The formal complaint',
  intro: 'Completa una carta formal: registro alto, participios, pasivas y '
      'marcadores.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Traje y corbata',
      text: 'Cada hueco pide la opción formal: request, no ask for; '
          'received, no got.',
    ),
  ],
  template:
      'Dear Ms. Serrano, I am writing with {{0}} to the delays affecting '
      'the Line 4 service. {{1}} used this line daily for six years, I '
      'have never experienced disruption on the current scale. Trains are '
      'frequently cancelled without notice; {{2}}, passengers are rarely '
      'informed of alternatives. It was only through a fellow passenger '
      '{{3}} I learned of last week\'s timetable change. I must therefore '
      '{{4}} that a revised timetable be published and that refunds {{5}} '
      'issued for season-ticket holders. {{6}}, the service has improved '
      'slightly since March; {{7}} said, the current situation remains '
      'unacceptable. What passengers ultimately {{8}} is reliability, not '
      'apologies. I look forward to {{9}} your response. Yours sincerely, '
      'M. Duarte.',
  blanks: [
    inputBlank('regard'),
    inputBlank('Having'),
    inputBlank('moreover', accepted: ['furthermore', 'in addition']),
    inputBlank('that'),
    inputBlank('request'),
    inputBlank('be'),
    inputBlank('Admittedly'),
    inputBlank('that'),
    inputBlank('need', accepted: ['want', 'require']),
    inputBlank('receiving'),
  ],
  passageTranslation:
      'Estimada Sra. Serrano: Le escribo con respecto a los retrasos que '
      'afectan al servicio de la Línea 4. Habiendo usado esta línea a '
      'diario durante seis años, nunca había vivido interrupciones de la '
      'escala actual. Los trenes se cancelan con frecuencia sin aviso; '
      'además, rara vez se informa a los pasajeros de alternativas. Solo '
      'por otra pasajera me enteré del cambio de horario de la semana '
      'pasada. Debo por tanto solicitar que se publique un horario '
      'revisado y que se emitan reembolsos para los abonados. Hay que '
      'admitir que el servicio ha mejorado algo desde marzo; dicho esto, '
      'la situación actual sigue siendo inaceptable. Lo que los pasajeros '
      'necesitan, en último término, es fiabilidad, no disculpas. Quedo a '
      'la espera de su respuesta. Atentamente, M. Duarte.',
);

final QuizContent esEnC12SpeakingClose = esEnSpeaking(
  id: 'es_en_c1_2_speaking_close',
  title: 'Conversación final: la reunión formal',
  level: 'C1.2',
  topic: 'A formal meeting roleplay: you present a complaint or proposal '
      'to a director (me), negotiate the details, and close with agreed '
      'next steps — all in high register.',
  practisePoints: [
    'Formal openings and closings: I am writing/calling with regard to…',
    'Requests with formality: I must request that…, Would it be possible…',
    'Cleft sentences to focus the key point',
    'Discourse markers to structure the negotiation',
  ],
  scoringCriteria: [
    'Register formal and consistent',
    'Requests softened yet precise',
    'Clear structure with discourse markers',
  ],
  targetVocabulary: [
    'with regard to', 'request', 'nevertheless', 'that said', 'ultimately',
  ],
  priorityErrors: [
    'casual phrasal verbs in the formal meeting',
    'demands without softening',
    'missing structure markers',
  ],
  mode: SpeakingMode.roleplay,
  intro: 'Cierre del módulo C1.2: una reunión formal de principio a fin. '
      'Copia, negocia y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Abre con el molde',
      text: 'Thank you for seeing me. I\'d like to raise the issue of… — '
          'un arranque así fija el tono de toda la reunión.',
    ),
  ],
);

/// C1.2 in chain order.
final List<QuizContent> esEnC1_2 = [
  esEnC12Register,
  esEnC12Clefts,
  esEnC12Participles,
  esEnC12Discourse,
  esEnC12ListenDebateShow,
  esEnC12SpeakingMid,
  esEnC12ReadLetter,
  esEnC12Dict,
  esEnC12BigText,
  esEnC12SpeakingClose,
];
