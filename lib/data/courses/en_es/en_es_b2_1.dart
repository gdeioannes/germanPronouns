import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// B2.1 — Hypothesis & argument. English → Spanish.
///
/// Big rocks: the past subjunctive with the conditional (si tuviera…
/// daría, ⚑E19), the conditional tense (⚑E21), modal nuance (debería,
/// deber de), relative clauses (⚑E24), and debate language.

final QuizContent enEsB21Conditional = enEsFill(
  id: 'en_es_b2_1_conditional',
  title: 'The conditional: hablaría, sería',
  intro: 'would = one tense in Spanish: infinitive + -ía. hablaría, '
      'comería, viviría. Irregular stems: haría, podría, tendría, diría '
      '(⚑E21).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Same stems as the future',
      text: 'har-, podr-, tendr-, dir-, sabr-, saldr- serve future AND '
          'conditional: haré/haría, podré/podría.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I would travel around the world.', answer: '**Viajaría** por todo el mundo.'),
    CourseItem(prompt: 'She would live by the sea.', answer: '**Viviría** junto al mar.'),
    CourseItem(prompt: 'We would buy a bigger house.', answer: '**Compraríamos** una casa más grande.'),
    CourseItem(prompt: 'I would do it differently. (hacer)', answer: 'Lo **haría** de otra manera.'),
    CourseItem(prompt: 'Could you help me? (poder, usted)', answer: '¿**Podría** ayudarme?'),
    CourseItem(prompt: 'He would have more time. (tener)', answer: '**Tendría** más tiempo.'),
    CourseItem(prompt: 'What would you say? (tú, decir)', answer: '¿Qué **dirías**?'),
    CourseItem(prompt: 'I would like a coffee. (gustar)', answer: 'Me **gustaría** un café.'),
    CourseItem(prompt: 'It would be perfect. (ser)', answer: '**Sería** perfecto.'),
    CourseItem(prompt: 'They would go out more. (salir)', answer: '**Saldrían** más.'),
    CourseItem(prompt: 'I wouldn\'t know what to do. (saber)', answer: 'No **sabría** qué hacer.'),
    CourseItem(prompt: 'You would love this city. (tú, encantar)', answer: 'Te **encantaría** esta ciudad.'),
    CourseItem(prompt: 'There would be less traffic. (haber)', answer: '**Habría** menos tráfico.'),
    CourseItem(prompt: 'We would put it here. (poner)', answer: 'Lo **pondríamos** aquí.'),
    CourseItem(prompt: 'I would come with pleasure. (venir)', answer: '**Vendría** con mucho gusto.'),
  ],
);

final QuizContent enEsB21PastSubj = enEsFill(
  id: 'en_es_b2_1_past_subj',
  title: 'The past subjunctive: tuviera, fuera',
  intro: 'From the ellos preterite, swap -ron for -ra: tuvieron → '
      'tuviera, fueron → fuera, hicieron → hiciera. The key to unreal '
      'sentences (⚑E19).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The -ron trick',
      text: 'Any verb: take the ellos preterite, drop -ron, add '
          '-ra/-ras/-ra/-ramos/-ran. hablaron → hablara. No exceptions.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'If I had money… (tener)', answer: 'Si **tuviera** dinero…'),
    CourseItem(prompt: 'If I were you… (ser)', answer: 'Si yo **fuera** tú…'),
    CourseItem(prompt: 'If we lived on the coast… (vivir)', answer: 'Si **viviéramos** en la costa…'),
    CourseItem(prompt: 'If she knew the truth… (saber)', answer: 'Si **supiera** la verdad…'),
    CourseItem(prompt: 'If you could choose… (tú, poder)', answer: 'Si **pudieras** elegir…'),
    CourseItem(prompt: 'If it weren\'t so late… (ser)', answer: 'Si no **fuera** tan tarde…'),
    CourseItem(prompt: 'If they did more sport… (hacer)', answer: 'Si **hicieran** más deporte…'),
    CourseItem(prompt: 'If he spoke slower… (hablar)', answer: 'Si **hablara** más despacio…'),
    CourseItem(prompt: 'If there were more time… (haber)', answer: 'Si **hubiera** más tiempo…'),
    CourseItem(prompt: 'If you came with me… (tú, venir)', answer: 'Si **vinieras** conmigo…'),
    CourseItem(prompt: 'If I didn\'t work… (trabajar)', answer: 'Si no **trabajara**…'),
    CourseItem(prompt: 'If we went out earlier… (salir)', answer: 'Si **saliéramos** antes…'),
    CourseItem(prompt: 'If she asked me… (pedir → pidiera)', answer: 'Si me lo **pidiera**…'),
    CourseItem(prompt: 'If you saw it… (tú, ver)', answer: 'Si lo **vieras**…'),
    CourseItem(prompt: 'If they gave me the job… (dar → dieran)', answer: 'Si me **dieran** el trabajo…'),
  ],
);

final QuizContent enEsB21SiTuviera = enEsFill(
  id: 'en_es_b2_1_si_tuviera',
  title: 'Unreal si: si tuviera, daría',
  intro: 'The full unreal condition: si + past subjunctive, conditional. '
      'Si tuviera dinero, viajaría = If I had money, I would travel.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Each half has its tense',
      text: 'si tuviera (subjunctive) … daría (conditional). Never '
          'conditional after si: "si tendría" ✗ — the classic error.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'If I had money, I would travel.', answer: 'Si tuviera dinero, **viajaría**.'),
    CourseItem(prompt: 'If I were you, I would accept.', answer: 'Si fuera tú, **aceptaría**.'),
    CourseItem(prompt: 'If we lived here, we would walk more.', answer: 'Si viviéramos aquí, **caminaríamos** más.'),
    CourseItem(prompt: 'What would you do if you won the lottery? (tú)', answer: '¿Qué harías si **ganaras** la lotería?'),
    CourseItem(prompt: 'If he studied more, he would pass.', answer: 'Si **estudiara** más, aprobaría.'),
    CourseItem(prompt: 'I would buy it if it were cheaper.', answer: 'Lo compraría si **fuera** más barato.'),
    CourseItem(prompt: 'If it didn\'t rain, we would go out.', answer: 'Si no **lloviera**, saldríamos.'),
    CourseItem(prompt: 'If she knew, she would get angry.', answer: 'Si lo **supiera**, se enfadaría.'),
    CourseItem(prompt: 'We would live better if we worked less.', answer: '**Viviríamos** mejor si trabajáramos menos.'),
    CourseItem(prompt: 'If I could, I would help you.', answer: 'Si **pudiera**, te ayudaría.'),
    CourseItem(prompt: 'If we had a car, we would go to the mountains.', answer: 'Si **tuviéramos** coche, iríamos a la montaña.'),
    CourseItem(prompt: 'He would be happier if he lived near the sea.', answer: '**Sería** más feliz si viviera cerca del mar.'),
    CourseItem(prompt: 'If I spoke Chinese, I would work in Shanghai.', answer: 'Si **hablara** chino, trabajaría en Shanghái.'),
    CourseItem(prompt: 'Where would you go if you could choose? (tú)', answer: '¿Adónde irías si **pudieras** elegir?'),
    CourseItem(prompt: 'If there were no traffic, we would arrive on time.', answer: 'Si no **hubiera** tráfico, llegaríamos a tiempo.'),
  ],
);

final QuizContent enEsB21Modals = enEsFill(
  id: 'en_es_b2_1_modals',
  title: 'debería, deber de, a lo mejor',
  intro: 'Shades of should and must: debería (should), debe de ser '
      '(must be — deduction), tendría que (would have to), a lo mejor '
      '(maybe).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'deber vs deber de',
      text: 'Debe estudiar = he must study (obligation). Debe de estar '
          'en casa = he must be at home (deduction).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'You should sleep more. (tú)', answer: '**Deberías** dormir más.'),
    CourseItem(prompt: 'He must be tired. (deduction)', answer: '**Debe** de estar cansado.'),
    CourseItem(prompt: 'We should call her.', answer: '**Deberíamos** llamarla.'),
    CourseItem(prompt: 'It must be ten o\'clock already. (deduction)', answer: 'Ya **deben** de ser las diez.'),
    CourseItem(prompt: 'Maybe he\'s at home. (a lo mejor)', answer: 'A lo **mejor** está en casa.'),
    CourseItem(prompt: 'I should have said something. (haber)', answer: 'Debería **haber** dicho algo.'),
    CourseItem(prompt: 'You would have to ask first. (tú)', answer: '**Tendrías** que preguntar primero.'),
    CourseItem(prompt: 'She must have missed the train. (deduction)', answer: '**Debe** de haber perdido el tren.'),
    CourseItem(prompt: 'One should read more. (habría que)', answer: '**Habría** que leer más.'),
    CourseItem(prompt: 'You shouldn\'t work so much. (tú)', answer: 'No **deberías** trabajar tanto.'),
    CourseItem(prompt: 'Perhaps it will rain. (quizá + subj.)', answer: 'Quizá **llueva**.'),
    CourseItem(prompt: 'It must have cost a fortune. (deduction)', answer: '**Debe** de haber costado una fortuna.'),
    CourseItem(prompt: 'I ought to leave now.', answer: '**Debería** irme ya.'),
    CourseItem(prompt: 'Maybe they don\'t know. (a lo mejor)', answer: 'A lo mejor no lo **saben**.'),
    CourseItem(prompt: 'You should try it. (tú, probar)', answer: '**Deberías** probarlo.'),
  ],
);

final QuizContent enEsB21Relatives = enEsFill(
  id: 'en_es_b2_1_relatives',
  title: 'que, quien, lo que, cuyo',
  intro: 'Joining sentences (⚑E24): que for nearly everything, quien '
      'after prepositions for people, lo que = what/which (abstract), '
      'donde for places.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'lo que = the abstract what',
      text: 'Lo que necesito es tiempo = What I need is time. When '
          '"what" isn\'t a question, Spanish says lo que.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The man who called is my boss.', answer: 'El hombre **que** llamó es mi jefe.'),
    CourseItem(prompt: 'What I need is time.', answer: '**Lo que** necesito es tiempo.'),
    CourseItem(prompt: 'The friend with whom I travel.', answer: 'El amigo con **quien** viajo.'),
    CourseItem(prompt: 'The town where I was born.', answer: 'El pueblo **donde** nací.'),
    CourseItem(prompt: 'The book that I read was great.', answer: 'El libro **que** leí fue genial.'),
    CourseItem(prompt: 'That is what I mean.', answer: 'Eso es **lo que** quiero decir.'),
    CourseItem(prompt: 'The woman for whom I work.', answer: 'La mujer para **quien** trabajo.'),
    CourseItem(prompt: 'Everything (that) you say is true.', answer: 'Todo **lo que** dices es verdad.'),
    CourseItem(prompt: 'The restaurant where we had dinner.', answer: 'El restaurante **donde** cenamos.'),
    CourseItem(prompt: 'The writer whose novel won. (cuyo)', answer: 'El escritor **cuya** novela ganó.'),
    CourseItem(prompt: 'The people who live here are friendly.', answer: 'La gente **que** vive aquí es amable.'),
    CourseItem(prompt: 'What worries me most is the cost.', answer: '**Lo que** más me preocupa es el coste.'),
    CourseItem(prompt: 'The day (when) we met, it was raining.', answer: 'El día **que** nos conocimos, llovía.'),
    CourseItem(prompt: 'The neighbour whose dog barks. (cuyo)', answer: 'El vecino **cuyo** perro ladra.'),
    CourseItem(prompt: 'She is the person in whom I trust most.', answer: 'Es la persona en **quien** más confío.'),
  ],
);

final QuizContent enEsB21ListenDebate = enEsListen(
  id: 'en_es_b2_1_listen_debate',
  title: 'Listening: El debate del tranvía',
  passageTitle: '¿Tranvía o más autobuses?',
  passage:
      'Esta noche, en el programa: ¿debería nuestra ciudad construir un '
      'tranvía? «Si tuviéramos tranvía, habría menos coches en el '
      'centro», dice la concejala Ruiz. «Lo que necesitamos no es un '
      'tranvía carísimo, sino más autobuses», responde el señor Ortega, '
      'cuyo barrio quedaría fuera de la línea. «Las obras durarían tres '
      'años y los comercios sufrirían». La concejala admite que las '
      'obras serían molestas, pero insiste: «Si no invirtiéramos ahora, '
      'lo pagaríamos durante décadas». El debate continúa la próxima '
      'semana.',
  passageTranslation:
      'Tonight on the programme: should our city build a tram? "If we '
      'had a tram, there would be fewer cars in the centre," says '
      'councillor Ruiz. "What we need is not a hugely expensive tram but '
      'more buses," replies Mr. Ortega, whose neighbourhood would be '
      'left off the line. "The works would take three years and local '
      'shops would suffer." The councillor admits the works would be '
      'annoying, but insists: "If we didn\'t invest now, we would pay '
      'for it for decades." The debate continues next week.',
  intro: 'A civic debate built on unreal conditions and relative '
      'clauses. Listen for si + -ra … -ría.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The debate skeleton',
      text: 'si tuviéramos… habría…, lo que necesitamos es…, cuyo barrio… '
          '— the module\'s grammar is the argument\'s engine.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué pasaría si hubiera tranvía, según la concejala?',
      options: [
        'Habría menos coches en el centro',
        'Los autobuses desaparecerían',
        'Las tiendas cerrarían',
      ],
      correctIndex: 0,
      questionTranslation: 'What would happen with a tram, according to the councillor?',
    ),
    ReadingQuestion(
      question: '¿Qué prefiere el señor Ortega?',
      options: ['Un tranvía más largo', 'Más autobuses', 'Más parkings'],
      correctIndex: 1,
      questionTranslation: 'What does Mr. Ortega prefer?',
    ),
    ReadingQuestion(
      question: '¿Cuánto durarían las obras?',
      options: ['Un año', 'Tres años', 'Diez años'],
      correctIndex: 1,
      questionTranslation: 'How long would the works take?',
    ),
  ],
);

final QuizContent enEsB21SpeakingMid = enEsSpeaking(
  id: 'en_es_b2_1_speaking_mid',
  title: 'Conversation: what would you do?',
  level: 'B2.1',
  topic: 'A hypothetical conversation in Spanish: what you would do if '
      'you won the lottery, if you could live anywhere, if you were the '
      'mayor of your city for a year.',
  practisePoints: [
    'si + past subjunctive, conditional — full sentences',
    'Softened opinions: debería, habría que',
    'lo que constructions: lo que haría primero es…',
  ],
  scoringCriteria: [
    'The -ra/-ría architecture correct',
    'No conditional after si',
    'Ideas connected, not listed',
  ],
  priorityErrors: [
    '"si tendría"',
    'present tense escaping into hypotheticals',
    'missing subjunctive after quizá',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: dream out loud, in Spanish, with your AI '
      'assistant. Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Your golden opener',
      text: 'Si pudiera elegir, viviría en… — prepare three real wishes '
          'before you start.',
    ),
  ],
);

final QuizContent enEsB21ReadEssay = enEsRead(
  id: 'en_es_b2_1_read_essay',
  title: 'Reading: ¿Y si trabajáramos menos?',
  passageTitle: '¿Y si trabajáramos menos?',
  passage:
      '¿Qué pasaría si la semana laboral tuviera cuatro días? Quienes '
      'defienden la idea dicen que produciríamos lo mismo en menos '
      'horas: descansados, cometeríamos menos errores y las empresas '
      'gastarían menos en oficinas. Lo que muestran los estudios piloto '
      'es prometedor: en las empresas que probaron el modelo, la '
      'productividad no bajó y los empleados, cuyos niveles de estrés se '
      'midieron durante un año, dormían mejor y se enfermaban menos. Sin '
      'embargo, no todo sería tan sencillo. Si un hospital redujera sus '
      'horas, ¿quién atendería a los pacientes del viernes? Habría que '
      'contratar más personal, y eso costaría dinero. A lo mejor la '
      'respuesta no es la misma para todos los sectores. Lo que parece '
      'claro es que la pregunta ya no es ridícula.',
  passageTranslation:
      'What would happen if the working week had four days? Those who '
      'defend the idea say we would produce the same in fewer hours: '
      'rested, we would make fewer mistakes and companies would spend '
      'less on offices. What the pilot studies show is promising: in the '
      'companies that tried the model, productivity didn\'t fall, and '
      'employees, whose stress levels were measured for a year, slept '
      'better and got ill less. However, not everything would be so '
      'simple. If a hospital reduced its hours, who would look after '
      'Friday\'s patients? More staff would have to be hired, and that '
      'would cost money. Maybe the answer is not the same for every '
      'sector. What seems clear is that the question is no longer '
      'ridiculous.',
  intro: 'An opinion piece powered by conditionals, lo que and cuyo — '
      'the B2 argument in written form.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concede, then turn',
      text: 'Sin embargo, no todo sería tan sencillo — the concession '
          'pivot. Every good argument has one; steal this one.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué pasó con la productividad en las empresas piloto?',
      options: ['Bajó mucho', 'No bajó', 'Se duplicó'],
      correctIndex: 1,
      questionTranslation: 'What happened to productivity in the pilot companies?',
    ),
    ReadingQuestion(
      question: '¿Qué problema tendría un hospital?',
      options: [
        'Quién atendería a los pacientes del viernes',
        'Los médicos dormirían demasiado',
        'Las oficinas costarían más',
      ],
      correctIndex: 0,
      questionTranslation: 'What problem would a hospital have?',
    ),
    ReadingQuestion(
      question: '¿Cuál es la conclusión del autor?',
      options: [
        'La idea es ridícula',
        'La pregunta ya no es ridícula',
        'Todos los sectores deberían cambiar ya',
      ],
      correctIndex: 1,
      questionTranslation: 'What is the author\'s conclusion?',
    ),
  ],
);

final QuizContent enEsB21Debate = enEsVocab(
  id: 'en_es_b2_1_debate',
  title: 'Debate language',
  intro: 'The phrases that structure a Spanish argument: agreeing, '
      'conceding, countering.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concede before you counter',
      text: 'Es verdad que…, pero… / Entiendo tu punto, sin embargo… — '
          'the B2 debater gives ground to take more.',
    ),
  ],
  pairs: const [
    MapEntry('on the one hand', 'por un lado'),
    MapEntry('on the other hand', 'por otro lado'),
    MapEntry('however', 'sin embargo'),
    MapEntry('nevertheless', 'no obstante'),
    MapEntry('it\'s true that…, but…', 'es verdad que…, pero…'),
    MapEntry('I see your point', 'entiendo tu punto'),
    MapEntry('in addition', 'además'),
    MapEntry('therefore', 'por lo tanto'),
    MapEntry('according to', 'según'),
    MapEntry('as a result', 'como resultado'),
    MapEntry('in summary', 'en resumen'),
    MapEntry('from my point of view', 'desde mi punto de vista'),
  ],
);

final QuizContent enEsB21Dict = enEsDict(
  id: 'en_es_b2_1_dict',
  title: 'Dictation: hypotheses',
  intro: 'Listen and type: -ra and -ría endings side by side. Hear which '
      'half of the condition you are in.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '-ra vs -ría',
      text: 'tuviera (subjunctive, after si) vs tendría (conditional, '
          'main clause). One syllable apart — train the ear.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'If I had time, I would learn piano.', answer: 'Si tuviera tiempo, aprendería piano.'),
    CourseItem(prompt: 'What would you do in my place?', answer: '¿Qué harías en mi lugar?'),
    CourseItem(prompt: 'You should rest more.', answer: 'Deberías descansar más.'),
    CourseItem(prompt: 'He must be in a meeting.', answer: 'Debe de estar en una reunión.'),
    CourseItem(prompt: 'What I need is time.', answer: 'Lo que necesito es tiempo.'),
    CourseItem(prompt: 'If I were you, I would accept the job.', answer: 'Si fuera tú, aceptaría el trabajo.'),
    CourseItem(prompt: 'There would be less traffic with a tram.', answer: 'Habría menos tráfico con un tranvía.'),
    CourseItem(prompt: 'Maybe they don\'t know it yet.', answer: 'A lo mejor todavía no lo saben.'),
    CourseItem(prompt: 'I would love to travel more.', answer: 'Me encantaría viajar más.'),
    CourseItem(prompt: 'The man whose car is red.', answer: 'El hombre cuyo coche es rojo.'),
    CourseItem(prompt: 'If it weren\'t so late, I would stay.', answer: 'Si no fuera tan tarde, me quedaría.'),
    CourseItem(prompt: 'However, not everything is so simple.', answer: 'Sin embargo, no todo es tan sencillo.'),
    CourseItem(prompt: 'We would have to hire more staff.', answer: 'Tendríamos que contratar más personal.'),
    CourseItem(prompt: 'Perhaps it will rain tomorrow.', answer: 'Quizá llueva mañana.'),
    CourseItem(prompt: 'That is what worries me most.', answer: 'Eso es lo que más me preocupa.'),
  ],
);

final QuizContent enEsB21BigText = enEsBigText(
  id: 'en_es_b2_1_bigtext',
  title: 'Big text: La ciudad ideal',
  passageTitle: 'La ciudad ideal',
  intro: 'Complete an essay of hypotheses: past subjunctive, '
      'conditional, lo que, cuyo and a modal or two.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Which half am I in?',
      text: 'After si → -ra form. Main clause → -ría form. Then check '
          'the relatives: person, thing or abstract lo que?',
    ),
  ],
  template:
      '¿Cómo sería mi ciudad ideal? Si yo {{0}} alcaldesa, lo primero '
      '{{1}} haría sería plantar mil árboles. {{2}} menos coches y más '
      'tranvías, y los niños, {{3}} parques hoy están llenos de tráfico, '
      '{{4}} jugar en la calle. Si los alquileres no {{5}} tan caros, '
      'los jóvenes no se irían. Habría {{6}} invertir mucho dinero, es '
      'verdad; sin {{7}}, lo que hoy parece caro mañana {{8}} barato. A '
      'lo mejor nunca seré alcaldesa. Pero si algún día me {{9}} el '
      'puesto, ya tengo el plan.',
  blanks: [
    inputBlank('fuera'),
    inputBlank('que'),
    inputBlank('Habría'),
    inputBlank('cuyos'),
    inputBlank('podrían'),
    inputBlank('fueran'),
    inputBlank('que'),
    inputBlank('embargo'),
    inputBlank('sería', accepted: ['parecería']),
    inputBlank('dieran', accepted: ['ofrecieran']),
  ],
  passageTranslation:
      'What would my ideal city be like? If I were mayor, the first '
      'thing I would do would be to plant a thousand trees. There would '
      'be fewer cars and more trams, and the children, whose parks today '
      'are full of traffic, could play in the street. If rents weren\'t '
      'so expensive, young people wouldn\'t leave. A lot of money would '
      'have to be invested, it\'s true; however, what seems expensive '
      'today would be cheap tomorrow. Maybe I\'ll never be mayor. But if '
      'one day they gave me the job, I already have the plan.',
);

final QuizContent enEsB21SpeakingClose = enEsSpeaking(
  id: 'en_es_b2_1_speaking_close',
  title: 'Final conversation: the debate',
  level: 'B2.1',
  topic: 'A friendly debate in Spanish: choose a topic (remote work, '
      'cars in city centres, social media), defend your position and '
      'answer my counter-arguments with hypotheses.',
  practisePoints: [
    'Argument structure: por un lado…, sin embargo…, por lo tanto…',
    'Hypotheses: si + -ra, -ría',
    'Softened stance: debería, habría que, a lo mejor',
    'Relatives to define: lo que propongo es…, la gente que…',
  ],
  scoringCriteria: [
    'Conditional architecture accurate',
    'Arguments connected logically',
    'Counter-arguments engaged, not dodged',
  ],
  targetVocabulary: [
    'sin embargo', 'por lo tanto', 'lo que', 'debería', 'si pudiéramos',
  ],
  priorityErrors: [
    'conditional after si',
    'indicative after quizá/es posible que',
    'bare opinions without connectors',
  ],
  mode: SpeakingMode.conversation,
  intro: 'Module B2.1 closer: a real debate, in Spanish. Copy, defend '
      'your corner, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The elegant concession',
      text: 'Es verdad que…, pero si lo miráramos de otra forma… — '
          'concede an inch, take a mile.',
    ),
  ],
);

/// B2.1 in chain order.
final List<QuizContent> enEsB2_1 = [
  enEsB21Conditional,
  enEsB21PastSubj,
  enEsB21SiTuviera,
  enEsB21Modals,
  enEsB21Relatives,
  enEsB21ListenDebate,
  enEsB21SpeakingMid,
  enEsB21ReadEssay,
  enEsB21Debate,
  enEsB21Dict,
  enEsB21BigText,
  enEsB21SpeakingClose,
];
