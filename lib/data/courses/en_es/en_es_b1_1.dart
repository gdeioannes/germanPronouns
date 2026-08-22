import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// B1.1 — Opinions & feelings. English → Spanish.
///
/// Big rocks: the present subjunctive after wishes, emotions and doubt
/// (⚑E18), commands (⚑E20), por vs para (⚑E15), saber vs conocer (⚑E27),
/// health and advice.

final QuizContent enEsB11SubjForms = enEsFill(
  id: 'en_es_b1_1_subj_forms',
  title: 'The present subjunctive: forms',
  intro: 'The subjunctive flips the vowel: hablar → hable, comer → coma, '
      'vivir → viva. It lives after que when someone wants, doubts or '
      'feels (⚑E18).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The vowel flip',
      text: '-ar verbs take -e endings (hable), -er/-ir take -a endings '
          '(coma, viva). Start from the yo form: tengo → tenga.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I want you to speak. (tú)', answer: 'Quiero que **hables**.'),
    CourseItem(prompt: 'I want her to come. (venir → venga)', answer: 'Quiero que **venga**.'),
    CourseItem(prompt: 'I hope you eat well. (tú)', answer: 'Espero que **comas** bien.'),
    CourseItem(prompt: 'I want us to live near the sea.', answer: 'Quiero que **vivamos** cerca del mar.'),
    CourseItem(prompt: 'I hope it doesn\'t rain. (llover → llueva)', answer: 'Espero que no **llueva**.'),
    CourseItem(prompt: 'I want you to have time. (tú, tener)', answer: 'Quiero que **tengas** tiempo.'),
    CourseItem(prompt: 'I hope they arrive early.', answer: 'Espero que **lleguen** temprano.'),
    CourseItem(prompt: 'I want him to do it. (hacer → haga)', answer: 'Quiero que lo **haga**.'),
    CourseItem(prompt: 'I hope you are well. (tú, estar)', answer: 'Espero que **estés** bien.'),
    CourseItem(prompt: 'I want it to be easy. (ser → sea)', answer: 'Quiero que **sea** fácil.'),
    CourseItem(prompt: 'I hope we can go. (poder → podamos)', answer: 'Espero que **podamos** ir.'),
    CourseItem(prompt: 'I want you to know the truth. (tú, saber → sepas)', answer: 'Quiero que **sepas** la verdad.'),
    CourseItem(prompt: 'I hope there is time. (haber → haya)', answer: 'Espero que **haya** tiempo.'),
    CourseItem(prompt: 'I want you all to come. (ustedes)', answer: 'Quiero que **vengan** ustedes.'),
    CourseItem(prompt: 'I hope she says yes. (decir → diga)', answer: 'Espero que **diga** que sí.'),
  ],
);

final QuizContent enEsB11SubjTriggers = enEsFill(
  id: 'en_es_b1_1_subj_triggers',
  title: 'Subjunctive triggers: wish, emotion, doubt',
  intro: 'querer que, esperar que, dudar que, me alegra que, es '
      'importante que → subjunctive. creo que → indicative, but NO creo '
      'que → subjunctive!',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E18 creo vs no creo',
      text: 'Creo que viene (indicative — you believe it). No creo que '
          'venga (subjunctive — doubt switches the mood).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I don\'t think he is coming.', answer: 'No creo que **venga**.'),
    CourseItem(prompt: 'I think he is coming. (indicative!)', answer: 'Creo que **viene**.'),
    CourseItem(prompt: 'I\'m glad you are here. (tú)', answer: 'Me alegra que **estés** aquí.'),
    CourseItem(prompt: 'It\'s important that you practise. (tú)', answer: 'Es importante que **practiques**.'),
    CourseItem(prompt: 'I doubt it\'s true.', answer: 'Dudo que **sea** verdad.'),
    CourseItem(prompt: 'It\'s necessary that we leave now. (salir)', answer: 'Es necesario que **salgamos** ahora.'),
    CourseItem(prompt: 'I\'m afraid it will rain. (temer)', answer: 'Temo que **llueva**.'),
    CourseItem(prompt: 'It\'s better that you rest. (tú, descansar)', answer: 'Es mejor que **descanses**.'),
    CourseItem(prompt: 'I hope everything goes well. (ir → vaya)', answer: 'Espero que todo **vaya** bien.'),
    CourseItem(prompt: 'She wants me to help her.', answer: 'Quiere que la **ayude**.'),
    CourseItem(prompt: 'It\'s a pity you can\'t come. (tú, poder)', answer: 'Es una pena que no **puedas** venir.'),
    CourseItem(prompt: 'I don\'t think it\'s expensive.', answer: 'No creo que **sea** caro.'),
    CourseItem(prompt: 'They want us to work more.', answer: 'Quieren que **trabajemos** más.'),
    CourseItem(prompt: 'It surprises me that he says that. (decir)', answer: 'Me sorprende que **diga** eso.'),
    CourseItem(prompt: 'It\'s possible that she knows. (saber)', answer: 'Es posible que lo **sepa**.'),
  ],
);

final QuizContent enEsB11Commands = enEsFill(
  id: 'en_es_b1_1_commands',
  title: 'Commands: habla / no hables',
  intro: 'Affirmative tú commands = third person (¡habla!, ¡come!). '
      'Negative commands = subjunctive (¡no hables!). Usted always uses '
      'the subjunctive (⚑E20).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The eight irregular tú commands',
      text: 'di (decir), haz (hacer), ve (ir), pon (poner), sal (salir), '
          'sé (ser), ten (tener), ven (venir).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Speak slower! (tú)', answer: '¡**Habla** más despacio!'),
    CourseItem(prompt: 'Don\'t speak so fast! (tú)', answer: '¡No **hables** tan rápido!'),
    CourseItem(prompt: 'Come here! (tú, venir)', answer: '¡**Ven** aquí!'),
    CourseItem(prompt: 'Do your homework! (tú, hacer)', answer: '¡**Haz** tus deberes!'),
    CourseItem(prompt: 'Don\'t worry! (tú, preocuparse)', answer: '¡No te **preocupes**!'),
    CourseItem(prompt: 'Tell me the truth! (tú, decir)', answer: '¡**Dime** la verdad!'),
    CourseItem(prompt: 'Open the window, please. (usted)', answer: '**Abra** la ventana, por favor.'),
    CourseItem(prompt: 'Don\'t eat that! (tú)', answer: '¡No **comas** eso!'),
    CourseItem(prompt: 'Put it here. (tú, poner + lo)', answer: '**Ponlo** aquí.'),
    CourseItem(prompt: 'Leave now! (tú, salir)', answer: '¡**Sal** ahora!'),
    CourseItem(prompt: 'Be good! (tú, ser)', answer: '¡**Sé** bueno!'),
    CourseItem(prompt: 'Don\'t be late! (tú, llegar)', answer: '¡No **llegues** tarde!'),
    CourseItem(prompt: 'Go to bed! (tú, acostarse)', answer: '¡**Acuéstate**!'),
    CourseItem(prompt: 'Wait a moment, please. (usted, esperar)', answer: '**Espere** un momento, por favor.'),
    CourseItem(prompt: 'Don\'t tell him anything! (tú)', answer: '¡No le **digas** nada!'),
  ],
);

final QuizContent enEsB11PorPara = enEsFill(
  id: 'en_es_b1_1_por_para',
  title: 'por vs para',
  intro: 'Both mean "for", never interchangeably (⚑E15). para = '
      'destination/purpose/deadline. por = cause/exchange/through/duration.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Arrow vs cloud',
      text: 'para is an arrow → (goal, recipient, deadline). por is a '
          'cloud around ○ (reason, route, exchange, per).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'This gift is for you.', answer: 'Este regalo es **para** ti.'),
    CourseItem(prompt: 'Thanks for the help.', answer: 'Gracias **por** la ayuda.'),
    CourseItem(prompt: 'I study in order to learn.', answer: 'Estudio **para** aprender.'),
    CourseItem(prompt: 'We walked through the park.', answer: 'Caminamos **por** el parque.'),
    CourseItem(prompt: 'It\'s for tomorrow. (deadline)', answer: 'Es **para** mañana.'),
    CourseItem(prompt: 'I paid ten euros for the book.', answer: 'Pagué diez euros **por** el libro.'),
    CourseItem(prompt: 'The train leaves for Madrid.', answer: 'El tren sale **para** Madrid.'),
    CourseItem(prompt: 'He was off work because of illness.', answer: 'No trabajó **por** enfermedad.'),
    CourseItem(prompt: 'For me, it\'s the best. (opinion)', answer: '**Para** mí, es el mejor.'),
    CourseItem(prompt: 'I\'ll call you in the evening. (por la…)', answer: 'Te llamo **por** la noche.'),
    CourseItem(prompt: 'She works for an NGO. (employer)', answer: 'Trabaja **para** una ONG.'),
    CourseItem(prompt: 'I exchanged it for a bigger one.', answer: 'Lo cambié **por** uno más grande.'),
    CourseItem(prompt: 'We need it for the party.', answer: 'Lo necesitamos **para** la fiesta.'),
    CourseItem(prompt: 'Twice per week.', answer: 'Dos veces **por** semana.'),
    CourseItem(prompt: 'I did it for love. (cause)', answer: 'Lo hice **por** amor.'),
  ],
);

final QuizContent enEsB11SaberConocer = enEsFill(
  id: 'en_es_b1_1_saber_conocer',
  title: 'saber vs conocer',
  intro: 'Two verbs "to know" (⚑E27): saber = facts and skills, conocer '
      '= people and places (to be familiar with).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Fact or friend?',
      text: 'Sé la respuesta (fact) · Sé nadar (skill) · Conozco a María '
          '(person) · Conozco Madrid (place).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I know the answer.', answer: '**Sé** la respuesta.'),
    CourseItem(prompt: 'I know María.', answer: '**Conozco** a María.'),
    CourseItem(prompt: 'I know how to swim.', answer: '**Sé** nadar.'),
    CourseItem(prompt: 'Do you know Madrid? (tú)', answer: '¿**Conoces** Madrid?'),
    CourseItem(prompt: 'She knows three languages. (hablar skills)', answer: '**Sabe** hablar tres idiomas.'),
    CourseItem(prompt: 'We know a good restaurant.', answer: '**Conocemos** un buen restaurante.'),
    CourseItem(prompt: 'I don\'t know where it is.', answer: 'No **sé** dónde está.'),
    CourseItem(prompt: 'Do you know my brother? (tú)', answer: '¿**Conoces** a mi hermano?'),
    CourseItem(prompt: 'He knows how to cook very well.', answer: '**Sabe** cocinar muy bien.'),
    CourseItem(prompt: 'They know the city well.', answer: '**Conocen** bien la ciudad.'),
    CourseItem(prompt: 'Do you know what time it is? (tú)', answer: '¿**Sabes** qué hora es?'),
    CourseItem(prompt: 'I met her last year. (conocer, preterite)', answer: 'La **conocí** el año pasado.'),
    CourseItem(prompt: 'Nobody knows the truth.', answer: 'Nadie **sabe** la verdad.'),
    CourseItem(prompt: 'I know that song. (familiar with)', answer: '**Conozco** esa canción.'),
    CourseItem(prompt: 'I don\'t know how to drive.', answer: 'No **sé** conducir.'),
  ],
);

final QuizContent enEsB11ListenDoctor = enEsListen(
  id: 'en_es_b1_1_listen_doctor',
  title: 'Listening: En la consulta',
  passageTitle: 'En la consulta del médico',
  passage:
      'Buenos días, ¿qué le pasa? — Me duele la cabeza y estoy muy '
      'cansado. — ¿Duerme usted bien? — No mucho, trabajo hasta muy '
      'tarde. — Le recomiendo que duerma ocho horas y que beba más agua. '
      'También es importante que camine un poco cada día. — ¿Necesito '
      'medicinas? — No creo que las necesite. Descanse este fin de '
      'semana y vuelva el lunes si no está mejor.',
  passageTranslation:
      "Good morning, what's wrong? — My head hurts and I'm very tired. — "
      "Do you sleep well? — Not much, I work until very late. — I "
      "recommend that you sleep eight hours and drink more water. It's "
      "also important that you walk a little every day. — Do I need "
      "medicine? — I don't think you need it. Rest this weekend and come "
      "back on Monday if you're not better.",
  intro: 'A doctor\'s appointment full of subjunctive advice: le '
      'recomiendo que…, es importante que…',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'me duele = gustar\'s cousin',
      text: 'Me duele la cabeza — hurts works backwards like gustar: the '
          'head pains me.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué le pasa al paciente?',
      options: [
        'Le duele la cabeza y está cansado',
        'Le duele el estómago',
        'Tiene fiebre',
      ],
      correctIndex: 0,
      questionTranslation: 'What is wrong with the patient?',
    ),
    ReadingQuestion(
      question: '¿Qué recomienda el médico?',
      options: [
        'Que trabaje más',
        'Que duerma ocho horas y beba más agua',
        'Que tome muchas medicinas',
      ],
      correctIndex: 1,
      questionTranslation: 'What does the doctor recommend?',
    ),
    ReadingQuestion(
      question: '¿Cuándo debe volver?',
      options: [
        'El lunes, si no está mejor',
        'Mañana',
        'En un mes',
      ],
      correctIndex: 0,
      questionTranslation: 'When should he come back?',
    ),
  ],
);

final QuizContent enEsB11Health = enEsVocab(
  id: 'en_es_b1_1_health',
  title: 'Health & body · La salud',
  intro: 'The body and how to say what hurts: me duele + singular, me '
      'duelen + plural.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E25 constipado ≠ constipated',
      text: 'estar constipado = to have a cold. Spanish\'s most infamous '
          'false friend — now you know.',
    ),
  ],
  pairs: const [
    MapEntry('head', 'la cabeza'),
    MapEntry('stomach', 'el estómago'),
    MapEntry('throat', 'la garganta'),
    MapEntry('back', 'la espalda'),
    MapEntry('My head hurts.', 'Me duele la cabeza.'),
    MapEntry('fever', 'la fiebre'),
    MapEntry('a cold (illness)', 'un resfriado'),
    MapEntry('cough', 'la tos'),
    MapEntry('to rest', 'descansar'),
    MapEntry('pill', 'la pastilla'),
    MapEntry('to feel ill (encontrarse mal)', 'encontrarse mal'),
    MapEntry('to get better', 'mejorarse'),
  ],
);

final QuizContent enEsB11SpeakingMid = enEsSpeaking(
  id: 'en_es_b1_1_speaking_mid',
  title: 'Conversation: advice',
  level: 'B1.1',
  topic: 'An advice exchange in Spanish: I describe small problems '
      '(tiredness, stress, learning struggles) and you advise me with '
      'recommendations and commands; then you ask my advice for yours.',
  practisePoints: [
    'Recommendations with subjunctive: te recomiendo que duermas…',
    'Commands: haz, no hagas, descansa',
    'es importante / es mejor que + subjunctive',
  ],
  scoringCriteria: [
    'Subjunctive after advice triggers',
    'Command forms correct including irregulars',
    'Natural follow-up questions',
  ],
  priorityErrors: [
    'indicative after quiero que / recomiendo que',
    'negative commands without subjunctive',
    'por/para swapped',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: trade advice with your AI assistant, in Spanish. '
      'Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The advice formula',
      text: 'Te recomiendo que + subjunctive is your power tool: te '
          'recomiendo que camines, que duermas, que no trabajes tanto.',
    ),
  ],
);

final QuizContent enEsB11ReadLetter = enEsRead(
  id: 'en_es_b1_1_read_letter',
  title: 'Reading: La carta de la abuela',
  passageTitle: 'La carta de la abuela',
  passage:
      'Querido Daniel: Me alegra mucho que estés contento en México y '
      'que tu español mejore cada semana. Tu madre quiere que comas '
      'mejor — ¡no vivas solo de tacos! Yo solo espero que seas feliz. '
      'Te recomiendo que conozcas Oaxaca; tu abuelo y yo la visitamos '
      'hace cuarenta años y nunca la olvidamos. Cuando vengas en '
      'diciembre, haz una lista de todo lo que quieres contarme. Y no '
      'esperes tanto para escribir: sabes que tus cartas son mi alegría. '
      'Un abrazo enorme, tu abuela Rose.',
  passageTranslation:
      'Dear Daniel: I am so glad that you are happy in Mexico and that '
      'your Spanish improves every week. Your mother wants you to eat '
      'better — don\'t live on tacos alone! I only hope you are happy. I '
      'recommend that you get to know Oaxaca; your grandfather and I '
      'visited it forty years ago and never forgot it. When you come in '
      'December, make a list of everything you want to tell me. And '
      'don\'t wait so long to write: you know your letters are my joy. A '
      'huge hug, your grandmother Rose.',
  intro: 'A grandmother\'s letter, stitched together with subjunctives, '
      'commands and one saber/conocer pair.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Feelings breed subjunctive',
      text: 'me alegra que estés, quiere que comas, espero que seas — '
          'every emotion pulls the next verb into the subjunctive.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué quiere la madre de Daniel?',
      options: [
        'Que escriba más cartas',
        'Que coma mejor',
        'Que vuelva a Canadá',
      ],
      correctIndex: 1,
      questionTranslation: 'What does Daniel\'s mother want?',
    ),
    ReadingQuestion(
      question: '¿Qué le recomienda la abuela?',
      options: [
        'Que conozca Oaxaca',
        'Que estudie más',
        'Que viva de tacos',
      ],
      correctIndex: 0,
      questionTranslation: 'What does the grandmother recommend?',
    ),
    ReadingQuestion(
      question: '¿Cuándo va a venir Daniel?',
      options: ['En verano', 'En diciembre', 'Nunca'],
      correctIndex: 1,
      questionTranslation: 'When is Daniel going to come?',
    ),
  ],
);

final QuizContent enEsB11SpeakOpinions = enEsSpeak(
  id: 'en_es_b1_1_speak_opinions',
  title: 'Speak: opinions',
  intro: 'Opinion phrases, spoken with conviction — and with the right '
      'mood after each trigger.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Mood switch, out loud',
      text: 'Creo que tiene razón (indicative) vs No creo que tenga razón '
          '(subjunctive). Practise the pair until the switch is automatic.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I think you are right.', answer: 'Creo que tienes razón.'),
    CourseItem(prompt: 'I don\'t think it\'s a good idea.', answer: 'No creo que sea una buena idea.'),
    CourseItem(prompt: 'In my opinion, it\'s too expensive.', answer: 'En mi opinión, es demasiado caro.'),
    CourseItem(prompt: 'I agree with you.', answer: 'Estoy de acuerdo contigo.'),
    CourseItem(prompt: 'I completely disagree.', answer: 'No estoy nada de acuerdo.'),
    CourseItem(prompt: 'It depends.', answer: 'Depende.'),
    CourseItem(prompt: 'I hope you\'re right!', answer: '¡Espero que tengas razón!'),
    CourseItem(prompt: 'That\'s a good point.', answer: 'Es un buen argumento.'),
  ],
);

final QuizContent enEsB11Dict = enEsDict(
  id: 'en_es_b1_1_dict',
  title: 'Dictation: advice and opinions',
  intro: 'Listen and type: the subjunctive vowels are subtle — hable vs '
      'habla is one letter and a whole mood.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Hear the flipped vowel',
      text: 'que hables, que coma, que venga — after que + trigger, '
          'expect the flipped ending and type it.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I want you to come to the party.', answer: 'Quiero que vengas a la fiesta.'),
    CourseItem(prompt: 'I hope everything goes well.', answer: 'Espero que todo vaya bien.'),
    CourseItem(prompt: 'It\'s important that you practise every day.', answer: 'Es importante que practiques todos los días.'),
    CourseItem(prompt: 'I don\'t think it\'s true.', answer: 'No creo que sea verdad.'),
    CourseItem(prompt: 'My head hurts a lot.', answer: 'Me duele mucho la cabeza.'),
    CourseItem(prompt: 'I recommend that you rest.', answer: 'Te recomiendo que descanses.'),
    CourseItem(prompt: 'This gift is for you.', answer: 'Este regalo es para ti.'),
    CourseItem(prompt: 'Thanks for everything.', answer: 'Gracias por todo.'),
    CourseItem(prompt: 'I know how to cook but I don\'t know your city.', answer: 'Sé cocinar pero no conozco tu ciudad.'),
    CourseItem(prompt: 'Don\'t be late!', answer: '¡No llegues tarde!'),
    CourseItem(prompt: 'Tell me the truth.', answer: 'Dime la verdad.'),
    CourseItem(prompt: 'I\'m glad you are here.', answer: 'Me alegra que estés aquí.'),
    CourseItem(prompt: 'We walked through the centre.', answer: 'Caminamos por el centro.'),
    CourseItem(prompt: 'I doubt he knows the answer.', answer: 'Dudo que sepa la respuesta.'),
    CourseItem(prompt: 'Drink more water and walk every day.', answer: 'Bebe más agua y camina todos los días.'),
  ],
);

final QuizContent enEsB11BigText = enEsBigText(
  id: 'en_es_b1_1_bigtext',
  title: 'Big text: Los consejos de doña Rosa',
  passageTitle: 'Los consejos de doña Rosa',
  intro: 'Complete doña Rosa\'s advice: subjunctives, commands, por/para '
      'and saber/conocer.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Trigger-spotting',
      text: 'Find the trigger before each gap (quiero que, es mejor que, '
          'no creo que) — it tells you the mood.',
    ),
  ],
  template:
      'Emma, quiero que me {{0}} bien: la paella no se hace con prisa. '
      'Primero, es importante que el arroz {{1}} bueno. {{2}} el fuego '
      'lento y no lo toques tanto — ¡no {{3}} impaciente! Mi madre '
      'siempre decía: «{{4}} paciencia, hija». No creo que la primera te '
      '{{5}} perfecta, pero espero que lo {{6}} otra vez. Yo {{7}} hacer '
      'paella desde los quince años, y todavía aprendo. Este azafrán es '
      '{{8}} ti — lo compré {{9}} muy poco dinero en el mercado. ¡Suerte!',
  blanks: [
    inputBlank('escuches', accepted: ['oigas']),
    inputBlank('sea'),
    inputBlank('Pon'),
    inputBlank('seas'),
    inputBlank('Ten'),
    inputBlank('salga'),
    inputBlank('intentes', accepted: ['hagas', 'pruebes']),
    inputBlank('sé'),
    inputBlank('para'),
    inputBlank('por'),
  ],
  passageTranslation:
      'Emma, I want you to listen to me carefully: paella is not made in '
      'a hurry. First, it is important that the rice is good. Put the '
      'heat on low and don\'t touch it so much — don\'t be impatient! My '
      'mother always said: "Have patience, my girl." I don\'t think your '
      'first one will come out perfect, but I hope you try again. I have '
      'known how to make paella since I was fifteen, and I am still '
      'learning. This saffron is for you — I bought it for very little '
      'money at the market. Good luck!',
);

final QuizContent enEsB11SpeakingClose = enEsSpeaking(
  id: 'en_es_b1_1_speaking_close',
  title: 'Final conversation: wishes and advice',
  level: 'B1.1',
  topic: 'A longer conversation in Spanish about hopes and advice: what '
      'you want for your future, what you hope for the people you love, '
      'and advice for someone learning your language.',
  practisePoints: [
    'quiero que / espero que + subjunctive',
    'Advice with commands and te recomiendo que…',
    'por vs para in natural sentences',
    'saber vs conocer',
  ],
  scoringCriteria: [
    'Mood switching accurate',
    'Commands correct',
    'por/para chosen correctly',
  ],
  targetVocabulary: [
    'espero que', 'quiero que', 'te recomiendo que', 'para mí', 'conocer',
  ],
  priorityErrors: [
    'indicative after wish/emotion triggers',
    'saber/conocer swapped',
    'por/para swapped',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module B1.1 closer: hopes, wishes and advice, in Spanish. '
      'Copy, speak, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Wish in threes',
      text: 'Espero que mi familia esté bien, que mi español mejore y que '
          'podamos viajar. Three wishes, three subjunctives, done.',
    ),
  ],
);

/// B1.1 in chain order.
final List<QuizContent> enEsB1_1 = [
  enEsB11SubjForms,
  enEsB11SubjTriggers,
  enEsB11Commands,
  enEsB11PorPara,
  enEsB11SaberConocer,
  enEsB11ListenDoctor,
  enEsB11Health,
  enEsB11SpeakingMid,
  enEsB11ReadLetter,
  enEsB11SpeakOpinions,
  enEsB11Dict,
  enEsB11BigText,
  enEsB11SpeakingClose,
];
