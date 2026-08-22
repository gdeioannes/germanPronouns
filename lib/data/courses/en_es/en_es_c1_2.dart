import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// C1.2 — Register & rhetoric. English → Spanish.
///
/// Big rocks: the formal usted register (⚑E30), written-Spanish
/// connectors, topicalised word orders (⚑E29), the courtesy conditional
/// and subjunctive-heavy politeness, and the verbs of formal writing.

final QuizContent enEsC12Register = enEsFill(
  id: 'en_es_c1_2_register',
  title: 'Register: from street to office',
  intro: 'The same idea in two suits: pedir → solicitar, empezar → '
      'iniciar, dar → proporcionar. Choosing the right suit IS the C1.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Formal Spanish loves length',
      text: 'Where English formalises with Latin, Spanish formalises '
          'with longer Latin: acabar → finalizar, usar → utilizar.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'pedir → (formal) to request', answer: 'pedir → **solicitar**'),
    CourseItem(prompt: 'empezar → (formal) to initiate', answer: 'empezar → **iniciar**'),
    CourseItem(prompt: 'dar → (formal) to provide', answer: 'dar → **proporcionar**'),
    CourseItem(prompt: 'acabar → (formal) to finalise', answer: 'acabar → **finalizar**'),
    CourseItem(prompt: 'hacer → (formal) to carry out', answer: 'hacer → **realizar**'),
    CourseItem(prompt: 'decir → (formal) to state', answer: 'decir → **señalar**', accepted: ['indicar', 'afirmar']),
    CourseItem(prompt: 'necesitar → (formal) to require', answer: 'necesitar → **requerir**'),
    CourseItem(prompt: 'conseguir → (formal) to obtain', answer: 'conseguir → **obtener**'),
    CourseItem(prompt: 'We request a copy of the contract.', answer: '**Solicitamos** una copia del contrato.'),
    CourseItem(prompt: 'The study carried out in May shows…', answer: 'El estudio **realizado** en mayo muestra…'),
    CourseItem(prompt: 'The post requires previous experience.', answer: 'El puesto **requiere** experiencia previa.'),
    CourseItem(prompt: 'We will provide the necessary information.', answer: '**Proporcionaremos** la información necesaria.'),
    CourseItem(prompt: 'The works will be finalised in March.', answer: 'Las obras se **finalizarán** en marzo.'),
    CourseItem(prompt: 'The report states three problems.', answer: 'El informe **señala** tres problemas.'),
    CourseItem(prompt: 'They obtained excellent results.', answer: '**Obtuvieron** resultados excelentes.'),
  ],
);

final QuizContent enEsC12Usted = enEsFill(
  id: 'en_es_c1_2_usted',
  title: 'The usted register',
  intro: 'Formal address end to end (⚑E30): usted + third person, le '
      'pronouns, and the courtesy moulds: ¿Sería tan amable de…? Le '
      'agradecería que…',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Le agradecería que + past subjunctive',
      text: 'The written-courtesy chain: Le agradecería que me enviara… '
          '— conditional + que + -ra form. Learn it whole.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Could you (usted) help me?', answer: '¿**Podría** usted ayudarme?'),
    CourseItem(prompt: 'Would you (usted) be so kind as to wait?', answer: '¿Sería tan **amable** de esperar?'),
    CourseItem(prompt: 'I would appreciate it if you sent me the report. (usted)', answer: 'Le agradecería que me **enviara** el informe.'),
    CourseItem(prompt: 'Please (usted), come in. (pasar)', answer: '**Pase**, por favor.'),
    CourseItem(prompt: 'Don\'t worry (usted).', answer: 'No se **preocupe**.'),
    CourseItem(prompt: 'Allow me to introduce myself. (permitir)', answer: '**Permítame** presentarme.'),
    CourseItem(prompt: 'Take a seat (usted).', answer: '**Siéntese**, por favor.'),
    CourseItem(prompt: 'I inform you (usted) that the date has changed.', answer: 'Le **informo** de que la fecha ha cambiado.'),
    CourseItem(prompt: 'If you (usted) need anything, call me.', answer: 'Si **necesita** algo, llámeme.'),
    CourseItem(prompt: 'What do you (usted) think? (parecer)', answer: '¿Qué le **parece**?'),
    CourseItem(prompt: 'Excuse me (usted), where is the exit?', answer: '**Disculpe**, ¿dónde está la salida?'),
    CourseItem(prompt: 'I would be grateful if you confirmed. (usted, confirmar)', answer: 'Le agradecería que lo **confirmara**.'),
    CourseItem(prompt: 'Wait a moment (usted), please.', answer: '**Espere** un momento, por favor.'),
    CourseItem(prompt: 'Follow me (usted), please. (seguir)', answer: '**Sígame**, por favor.'),
    CourseItem(prompt: 'Don\'t hesitate (usted) to contact us. (dudar)', answer: 'No **dude** en contactarnos.'),
  ],
);

final QuizContent enEsC12WordOrder = enEsFill(
  id: 'en_es_c1_2_word_order',
  title: 'Topicalising: fronting for focus',
  intro: 'Spanish moves the spotlight by moving words (⚑E29): Eso lo '
      'sabía yo · Fue en Roma donde nos conocimos · Lo que necesito es '
      'tiempo.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Fronted object doubles the pronoun',
      text: 'El libro **lo** compré ayer — when the object jumps to the '
          'front, its pronoun must appear before the verb.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The book, I bought it yesterday. (fronted)', answer: 'El libro **lo** compré ayer.'),
    CourseItem(prompt: 'That, I already knew. (fronted)', answer: 'Eso ya **lo** sabía.'),
    CourseItem(prompt: 'It was in Rome that we met.', answer: 'Fue en Roma **donde** nos conocimos.'),
    CourseItem(prompt: 'What I need is time.', answer: '**Lo que** necesito es tiempo.'),
    CourseItem(prompt: 'It was Ana who found the error.', answer: 'Fue Ana **quien** encontró el error.'),
    CourseItem(prompt: 'The keys, I gave them to Pedro. (fronted)', answer: 'Las llaves se **las** di a Pedro.'),
    CourseItem(prompt: 'It was then that I understood.', answer: 'Fue entonces **cuando** lo entendí.'),
    CourseItem(prompt: 'Money, he has plenty. (fronted)', answer: 'Dinero **no** le falta.'),
    CourseItem(prompt: 'What matters is the quality.', answer: '**Lo que** importa es la calidad.'),
    CourseItem(prompt: 'To María, I told her everything. (fronted)', answer: 'A María se **lo** conté todo.'),
    CourseItem(prompt: 'It was the price that surprised me.', answer: 'Fue el precio **lo que** me sorprendió.'),
    CourseItem(prompt: 'The film, we saw it on Sunday. (fronted)', answer: 'La película **la** vimos el domingo.'),
    CourseItem(prompt: 'What he did was sell the car.', answer: '**Lo que** hizo fue vender el coche.'),
    CourseItem(prompt: 'It was the manager who decided.', answer: 'Fue el gerente **quien** lo decidió.'),
    CourseItem(prompt: 'That story, nobody believes it. (fronted)', answer: 'Esa historia no se **la** cree nadie.'),
  ],
);

final QuizContent enEsC12Discourse = enEsVocab(
  id: 'en_es_c1_2_discourse',
  title: 'Written-Spanish connectors',
  intro: 'The hinges of formal prose: reformulating, conceding, '
      'exemplifying and concluding.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'One per function',
      text: 'Reformulate: es decir · concede: si bien · example: por '
          'ejemplo → tales como · conclude: en definitiva. One good one '
          'of each is enough.',
    ),
  ],
  pairs: const [
    MapEntry('that is to say', 'es decir'),
    MapEntry('in other words', 'dicho de otro modo'),
    MapEntry('although / while (formal)', 'si bien'),
    MapEntry('such as', 'tales como'),
    MapEntry('with regard to', 'en cuanto a'),
    MapEntry('regarding (formal)', 'respecto a'),
    MapEntry('nevertheless', 'no obstante'),
    MapEntry('consequently', 'por consiguiente'),
    MapEntry('in short / ultimately', 'en definitiva'),
    MapEntry('that said', 'dicho esto'),
    MapEntry('indeed / in fact', 'de hecho'),
    MapEntry('to sum up', 'en resumen'),
  ],
);

final QuizContent enEsC12ListenPanel = enEsListen(
  id: 'en_es_c1_2_listen_panel',
  title: 'Listening: La mesa redonda',
  passageTitle: '¿Museos gratuitos?',
  passage:
      '¿Deberían ser gratuitos los museos? Si bien la entrada gratuita '
      'suena generosa, alguien paga siempre. Lo que hacen los museos '
      'gratuitos, en realidad, es trasladar el coste del turista al '
      'contribuyente. Dicho esto, la evidencia de Londres es llamativa: '
      'tras eliminarse las entradas en 2001, las visitas se '
      'triplicaron, y fueron las familias jóvenes, no los turistas, '
      'quienes impulsaron el aumento. Es decir, la cuestión no es si '
      'pagamos, sino qué decidimos pagar. En definitiva, un museo que '
      'nadie visita es el museo más caro de todos.',
  passageTranslation:
      'Should museums be free? While free entry sounds generous, '
      'somebody always pays. What free museums actually do is shift the '
      'cost from the tourist to the taxpayer. That said, the evidence '
      'from London is striking: after fees were removed in 2001, visits '
      'tripled, and it was young families, not tourists, who drove the '
      'increase. In other words, the question is not whether we pay, '
      'but what we choose to pay for. Ultimately, a museum nobody '
      'visits is the most expensive museum of all.',
  intro: 'A panel discussion: si bien, dicho esto, clefts and the '
      'formal connectors, spoken.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Connectors are turn signals',
      text: 'Si bien (concede), Dicho esto (turn), Es decir (rephrase), '
          'En definitiva (close). Hear them and you own the map.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué hacen en realidad los museos gratuitos?',
      options: [
        'Trasladan el coste al contribuyente',
        'Pierden dinero para los turistas',
        'Bajan la calidad',
      ],
      correctIndex: 0,
      questionTranslation: 'What do free museums actually do?',
    ),
    ReadingQuestion(
      question: '¿Qué pasó en Londres después de 2001?',
      options: [
        'Las visitas se triplicaron',
        'Los museos cerraron',
        'Subieron los precios',
      ],
      correctIndex: 0,
      questionTranslation: 'What happened in London after 2001?',
    ),
    ReadingQuestion(
      question: '¿Quiénes impulsaron el aumento?',
      options: ['Los turistas', 'Las familias jóvenes', 'Los estudiantes'],
      correctIndex: 1,
      questionTranslation: 'Who drove the increase?',
    ),
  ],
);

final QuizContent enEsC12SpeakingMid = enEsSpeaking(
  id: 'en_es_c1_2_speaking_mid',
  title: 'Conversation: two registers',
  level: 'C1.2',
  topic: 'One story, two audiences, in Spanish: first tell me about a '
      'problem at work as you would tell a friend (tú, casual); then '
      're-tell exactly the same events as a formal report to a director '
      '(usted, formal).',
  practisePoints: [
    'The casual version: tú, colloquial connectors, relaxed vocabulary',
    'The formal version: usted, solicitar/realizar/señalar, courtesy moulds',
    'Keeping facts identical while the register flips',
  ],
  scoringCriteria: [
    'Clear register contrast',
    'usted forms consistent (verbs AND pronouns)',
    'No register bleed within a version',
  ],
  priorityErrors: [
    'tú forms leaking into the usted version',
    'casual vocabulary in the report',
    'identical wording in both versions',
  ],
  mode: SpeakingMode.roleplay,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: the same story in jeans and in a suit. Copy, '
      'speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Swap the verbs, swap the suit',
      text: 'pedir → solicitar, arreglar → resolver, empezar → iniciar. '
          'Re-dress ten verbs and the whole register turns.',
    ),
  ],
);

final QuizContent enEsC12ReadLetters = enEsRead(
  id: 'en_es_c1_2_read_letters',
  title: 'Reading: Los dos correos',
  passageTitle: 'Los dos correos',
  passage:
      'Versión uno, a una amiga: «¿Sabes qué? ¡El piso de arriba se '
      'inundó OTRA VEZ y mi techo está hecho un desastre! Le he pedido '
      'al casero mil veces que lo arregle. ¡Qué rabia!» Versión dos, al '
      'casero: «Estimado Sr. Vidal: Me dirijo a usted en relación con '
      'los daños causados en el techo de mi vivienda el 12 de marzo, a '
      'raíz de una inundación en el piso superior. Habiendo comunicado '
      'esta incidencia en cinco ocasiones anteriores, me veo obligada a '
      'solicitar que las reparaciones se realicen en un plazo de '
      'catorce días. De no atenderse la solicitud, me veré en la '
      'necesidad de contactar con la oficina municipal de vivienda. '
      'Atentamente, L. Ortiz.» El mismo techo, la misma agua — otro '
      'idioma.',
  passageTranslation:
      'Version one, to a friend: "You know what? The flat upstairs '
      'flooded AGAIN and my ceiling is a disaster! I\'ve asked the '
      'landlord a thousand times to fix it. So annoying!" Version two, '
      'to the landlord: "Dear Mr. Vidal: I am writing to you regarding '
      'the damage caused to the ceiling of my home on 12 March, '
      'following a flood in the flat above. Having reported this issue '
      'on five previous occasions, I am obliged to request that the '
      'repairs be carried out within fourteen days. Should this request '
      'not be attended to, I will find it necessary to contact the '
      'municipal housing office. Yours sincerely, L. Ortiz." The same '
      'ceiling, the same water — another language.',
  intro: 'The same problem in two registers. Compare line by line: this '
      'is the whole module in one page.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Steal the formal moulds',
      text: 'Me dirijo a usted en relación con… / Me veo obligada a '
          'solicitar que… — two moulds that serve every formal complaint '
          'of your real life.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cuántas veces había comunicado el problema?',
      options: ['Tres', 'Cinco', 'Mil'],
      correctIndex: 1,
      questionTranslation: 'How many times had she reported the problem?',
    ),
    ReadingQuestion(
      question: '¿Qué plazo fija el correo formal?',
      options: ['Siete días', 'Catorce días', 'Un mes'],
      correctIndex: 1,
      questionTranslation: 'What deadline does the formal email set?',
    ),
    ReadingQuestion(
      question: '¿Qué hará si no atienden la solicitud?',
      options: [
        'Contactar con la oficina municipal de vivienda',
        'Mudarse',
        'Dejar de pagar el alquiler',
      ],
      correctIndex: 0,
      questionTranslation: 'What will she do if the request is not attended to?',
    ),
  ],
);

final QuizContent enEsC12Dict = enEsDict(
  id: 'en_es_c1_2_dict',
  title: 'Dictation: cultivated prose',
  intro: 'High-register sentences at dictation speed: courtesy chains, '
      'clefts and formal connectors.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Punctuate as you hear',
      text: 'Connectors between pauses (no obstante, dicho esto) sit '
          'between commas. Hear the pause, write the comma.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am writing to you regarding your letter.', answer: 'Me dirijo a usted en relación con su carta.'),
    CourseItem(prompt: 'I would appreciate it if you confirmed the date.', answer: 'Le agradecería que confirmara la fecha.'),
    CourseItem(prompt: 'What I propose is a gradual change.', answer: 'Lo que propongo es un cambio gradual.'),
    CourseItem(prompt: 'Nevertheless, the board approved the project.', answer: 'No obstante, la junta aprobó el proyecto.'),
    CourseItem(prompt: 'That is to say, we need more time.', answer: 'Es decir, necesitamos más tiempo.'),
    CourseItem(prompt: 'The request must be submitted in writing.', answer: 'La solicitud debe presentarse por escrito.'),
    CourseItem(prompt: 'It was then that we understood the cost.', answer: 'Fue entonces cuando entendimos el coste.'),
    CourseItem(prompt: 'While it is true, it is not the whole truth.', answer: 'Si bien es cierto, no es toda la verdad.'),
    CourseItem(prompt: 'Don\'t hesitate to contact us.', answer: 'No dude en contactarnos.'),
    CourseItem(prompt: 'That said, reasonable doubts remain.', answer: 'Dicho esto, quedan dudas razonables.'),
    CourseItem(prompt: 'Ultimately, the decision is yours. (usted)', answer: 'En definitiva, la decisión es suya.'),
    CourseItem(prompt: 'The works will be carried out in March.', answer: 'Las obras se realizarán en marzo.'),
    CourseItem(prompt: 'Consequently, the deadline is extended.', answer: 'Por consiguiente, el plazo se amplía.'),
    CourseItem(prompt: 'In fact, the results improved.', answer: 'De hecho, los resultados mejoraron.'),
    CourseItem(prompt: 'Allow me to introduce myself.', answer: 'Permítame presentarme.'),
  ],
);

final QuizContent enEsC12BigText = enEsBigText(
  id: 'en_es_c1_2_bigtext',
  title: 'Big text: La reclamación formal',
  passageTitle: 'La reclamación formal',
  intro: 'Complete a formal letter: high register, courtesy '
      'subjunctives, passives and connectors.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Suit and tie',
      text: 'Every gap asks for the formal option: solicitar not pedir; '
          'realicen not hagan.',
    ),
  ],
  template:
      'Estimada Sra. Serrano: Me dirijo a usted en {{0}} con los '
      'retrasos que afectan a la línea 4. {{1}} bien el servicio ha '
      'mejorado desde marzo, la situación actual sigue siendo '
      'inaceptable. Los trenes se cancelan sin previo aviso; es {{2}}, '
      'los pasajeros rara vez reciben información sobre alternativas. '
      'Fue por otra pasajera {{3}} me enteré del cambio de horarios. Me '
      'veo obligada a {{4}} que se publique un horario revisado y que '
      'se {{5}} los reembolsos correspondientes a los abonados. Le '
      '{{6}} que estudiara además la frecuencia de los fines de semana. '
      '{{7}} esto, quiero reconocer la amabilidad del personal. Lo que '
      'los pasajeros necesitan, en {{8}}, es fiabilidad, no disculpas. '
      'Quedo a la espera de su respuesta. No {{9}} en contactarme. '
      'Atentamente, M. Duarte.',
  blanks: [
    inputBlank('relación'),
    inputBlank('Si'),
    inputBlank('decir', accepted: ['más']),
    inputBlank('como', accepted: ['que']),
    inputBlank('solicitar'),
    inputBlank('realicen', accepted: ['emitan', 'efectúen']),
    inputBlank('agradecería'),
    inputBlank('Dicho'),
    inputBlank('definitiva'),
    inputBlank('dude'),
  ],
  passageTranslation:
      'Dear Ms. Serrano: I am writing to you regarding the delays '
      'affecting Line 4. While the service has improved since March, '
      'the current situation remains unacceptable. Trains are cancelled '
      'without notice; that is to say, passengers rarely receive '
      'information about alternatives. It was through another passenger '
      'that I learned of the timetable change. I am obliged to request '
      'that a revised timetable be published and that the corresponding '
      'refunds be issued to season-ticket holders. I would also be '
      'grateful if you considered the weekend frequency. That said, I '
      'want to acknowledge the kindness of the staff. What passengers '
      'need, ultimately, is reliability, not apologies. I await your '
      'reply. Do not hesitate to contact me. Yours sincerely, M. '
      'Duarte.',
);

final QuizContent enEsC12SpeakingClose = enEsSpeaking(
  id: 'en_es_c1_2_speaking_close',
  title: 'Final conversation: the formal meeting',
  level: 'C1.2',
  topic: 'A formal meeting roleplay in Spanish: you present a complaint '
      'or proposal to a director (me, usted register), negotiate '
      'details, and close with agreed next steps — all in high register.',
  practisePoints: [
    'Formal openings: me dirijo a usted…, quisiera plantear…',
    'Courtesy requests: le agradecería que + -ra',
    'Cleft sentences to focus the key point',
    'Formal connectors structuring the negotiation',
  ],
  scoringCriteria: [
    'usted register airtight',
    'Requests softened yet precise',
    'Clear structure with formal connectors',
  ],
  targetVocabulary: [
    'quisiera', 'le agradecería que', 'no obstante', 'en definitiva',
    'solicitar',
  ],
  priorityErrors: [
    'tú forms in the formal meeting',
    'demands without courtesy moulds',
    'casual connectors (bueno, pues) in the summary',
  ],
  mode: SpeakingMode.roleplay,
  intro: 'Module C1.2 closer: a formal meeting from start to finish. '
      'Copy, negotiate, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Open with the mould',
      text: 'Gracias por recibirme. Quisiera plantear el tema de… — an '
          'opening like that sets the tone for the whole meeting.',
    ),
  ],
);

/// C1.2 in chain order.
final List<QuizContent> enEsC1_2 = [
  enEsC12Register,
  enEsC12Usted,
  enEsC12WordOrder,
  enEsC12Discourse,
  enEsC12ListenPanel,
  enEsC12SpeakingMid,
  enEsC12ReadLetters,
  enEsC12Dict,
  enEsC12BigText,
  enEsC12SpeakingClose,
];
