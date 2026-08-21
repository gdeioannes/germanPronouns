import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M11 — Connecting Sentences (A2). Coordinating conjunctions keep the word
/// order; subordinating ones (weil, dass, wenn) kick the verb to the end.

const List<HelpMemoryTip> _connectorTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Two kinds of connector',
    text:
        '**und, aber, oder, denn** keep normal word order. **weil, dass, '
        'wenn, obwohl** (subordinating) send the conjugated verb to the **END** '
        'of the clause.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'weil kicks, denn does not',
    text:
        '…, **weil** ich müde **bin** (verb at the end) = …, **denn** ich '
        '**bin** müde (normal order). Same meaning, different word order.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Front clause → verb, comma, verb',
    text:
        'If the wenn-clause comes first, the main clause starts with its verb: '
        '**Wenn** es **regnet**, **bleibe** ich zu Hause.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'Always a comma',
    text:
        'A subordinate clause is always fenced off with a comma: Ich glaube, '
        '**dass** das stimmt.',
  ),
];

final QuizContent enDeM11Coordinating = enDeFill(
  id: 'en_de_m11_coordinating',
  title: 'und / aber / oder / denn',
  intro:
      'These four connect two full sentences and change nothing about the '
      'word order. denn means "because" and keeps normal order.',
  tips: _connectorTips,
  items: const [
    CourseItem(
      prompt: "I'm tired, but I'm happy.",
      answer: 'Ich bin müde, **aber** ich bin glücklich',
    ),
    CourseItem(
      prompt: "I'm learning German, because it's fun. (denn)",
      answer: 'Ich lerne Deutsch, **denn** es macht Spaß',
    ),
    CourseItem(
      prompt: 'Do you want tea or coffee?',
      answer: 'Möchtest du Tee **oder** Kaffee?',
    ),
    CourseItem(
      prompt: 'She works and he cooks.',
      answer: 'Sie arbeitet **und** er kocht',
    ),
    CourseItem(
      prompt: 'I want to come, but I have no time.',
      answer: 'Ich will kommen, **aber** ich habe keine Zeit',
    ),
    CourseItem(
      prompt: 'He cooks and she reads.',
      answer: 'Er kocht **und** sie liest',
    ),
    CourseItem(
      prompt: 'We stay home, because it is raining. (denn)',
      answer: 'Wir bleiben zu Hause, **denn** es regnet',
    ),
    CourseItem(
      prompt: 'Do we take the bus or the train?',
      answer: 'Nehmen wir den Bus **oder** den Zug?',
    ),
    CourseItem(
      prompt: 'The film is long, but exciting.',
      answer: 'Der Film ist lang, **aber** spannend',
    ),
    CourseItem(
      prompt: 'I drink tea and eat cake.',
      answer: 'Ich trinke Tee **und** esse Kuchen',
    ),
    CourseItem(
      prompt: 'She is tired, because she worked a lot. (denn)',
      answer: 'Sie ist müde, **denn** sie hat viel gearbeitet',
    ),
    CourseItem(
      prompt: 'Are you coming along, or are you staying here?',
      answer: 'Kommst du mit, **oder** bleibst du hier?',
    ),
    CourseItem(
      prompt: 'He is nice, but a little shy.',
      answer: 'Er ist nett, **aber** etwas schüchtern',
    ),
    CourseItem(
      prompt: 'I buy bread and she buys cheese.',
      answer: 'Ich kaufe Brot **und** sie kauft Käse',
    ),
    CourseItem(
      prompt: 'We hurry, because the train leaves soon. (denn)',
      answer: 'Wir beeilen uns, **denn** der Zug fährt bald ab',
    ),
  ],
);

final QuizContent enDeM11Weil = enDeFill(
  id: 'en_de_m11_weil',
  title: 'weil (verb to the end)',
  intro:
      'weil means "because" and sends the conjugated verb to the very end of '
      'its clause.',
  tips: _connectorTips,
  items: const [
    CourseItem(
      prompt: "I stay home because I'm sick. (… ich krank …)",
      answer: 'Ich bleibe zu Hause, weil ich krank **bin**',
    ),
    CourseItem(
      prompt: 'She is happy because she has holidays.',
      answer: 'Sie ist glücklich, weil sie Ferien **hat**',
    ),
    CourseItem(
      prompt: 'We learn German because we live in Berlin.',
      answer: 'Wir lernen Deutsch, weil wir in Berlin **wohnen**',
    ),
    CourseItem(
      prompt: 'I practise because I want to get better.',
      answer: 'Ich übe, weil ich besser werden **will**',
    ),
    CourseItem(
      prompt: "I can't come because I have no time.",
      answer: 'Ich kann nicht kommen, weil ich keine Zeit **habe**',
    ),
    CourseItem(
      prompt: 'He takes the bus because it is raining.',
      answer: 'Er nimmt den Bus, weil es **regnet**',
    ),
    CourseItem(
      prompt: 'She drinks tea because coffee is too strong.',
      answer: 'Sie trinkt Tee, weil Kaffee zu stark **ist**',
    ),
    CourseItem(
      prompt: 'We are happy because the weekend is coming.',
      answer: 'Wir freuen uns, weil das Wochenende **kommt**',
    ),
    CourseItem(
      prompt: 'I eat an apple because I am hungry.',
      answer: 'Ich esse einen Apfel, weil ich Hunger **habe**',
    ),
    CourseItem(
      prompt: 'He sleeps because he is very tired.',
      answer: 'Er schläft, weil er sehr müde **ist**',
    ),
    CourseItem(
      prompt: 'She saves money because she wants to travel.',
      answer: 'Sie spart Geld, weil sie reisen **will**',
    ),
    CourseItem(
      prompt: 'We open the window because it is warm.',
      answer: 'Wir öffnen das Fenster, weil es warm **ist**',
    ),
    CourseItem(
      prompt: 'I call you because I have a question.',
      answer: 'Ich rufe dich an, weil ich eine Frage **habe**',
    ),
    CourseItem(
      prompt: 'They stay inside because it is cold.',
      answer: 'Sie bleiben drinnen, weil es kalt **ist**',
    ),
    CourseItem(
      prompt: 'He learns a lot because he wants to pass the exam.',
      answer: 'Er lernt viel, weil er die Prüfung bestehen **will**',
    ),
  ],
);

// 11.2a — warm-up big text (after the coordinating + weil quizzes): type the
// connector. und/aber/oder/denn keep normal order; weil sends the verb to the
// end.
final QuizContent enDeM11BigTextWarmup = enDeBigText(
  id: 'en_de_m11_bigtext_warmup',
  title: 'Big text (warm-up): Mein Wochenende',
  passageTitle: 'Mein Wochenende',
  template:
      'Am Samstag wollte ich eigentlich joggen, {{0}} es hat den ganzen Tag '
      'geregnet. Also bin ich einfach zu Hause geblieben {{1}} habe einen alten '
      'Film geschaut. Am Abend habe ich eine riesige Pizza gegessen, {{2}} ich '
      'hatte wirklich großen Hunger. Der Sonntag war zum Glück besser: Die Sonne '
      'schien, {{3}} ich bin endlich rausgegangen. Ich war richtig glücklich, '
      '{{4}} das Wetter so schön war. Und du — was machst du lieber bei Regen, '
      'lesen {{5}} schlafen?',
  blanks: [
    inputBlank('aber', hint: 'und/aber/oder/denn/weil'),
    inputBlank('und', hint: 'und/aber/oder/denn/weil'),
    inputBlank('denn', hint: 'und/aber/oder/denn/weil'),
    inputBlank('und', hint: 'und/aber/oder/denn/weil'),
    inputBlank('weil', hint: 'Verb am Ende → weil/dass/wenn'),
    inputBlank('oder', hint: 'und/aber/oder/denn/weil'),
  ],
  passageTranslation:
      'On Saturday I actually wanted to go jogging, but it rained all day long. '
      'So I simply stayed at home and watched an old film. In the evening I ate '
      'a huge pizza, because I was really very hungry. Sunday was luckily '
      'better: the sun was shining, and I finally went outside. I was really '
      'happy, because the weather was so nice. And you — what do you prefer to '
      'do when it rains, read or sleep?',
  intro:
      'Type the connector. und, aber, oder and denn keep normal word order; '
      'weil sends the verb to the very end (…, weil das Wetter schön war).',
  tips: _connectorTips,
);

final QuizContent enDeM11Dass = enDeFill(
  id: 'en_de_m11_dass',
  title: 'dass',
  intro:
      'dass ("that") introduces a reported thought or fact — and again the '
      'verb goes to the end.',
  tips: _connectorTips,
  items: const [
    CourseItem(
      prompt: 'I think that he is nice.',
      answer: 'Ich denke, dass er nett **ist**',
    ),
    CourseItem(
      prompt: 'She says that she has time.',
      answer: 'Sie sagt, dass sie Zeit **hat**',
    ),
    CourseItem(
      prompt: 'I know that you live in Berlin.',
      answer: 'Ich weiß, dass du in Berlin **wohnst**',
    ),
    CourseItem(
      prompt: "It's good that you are here.",
      answer: 'Es ist gut, dass du hier **bist**',
    ),
    CourseItem(
      prompt: 'I hope that the weather stays nice.',
      answer: 'Ich hoffe, dass das Wetter schön **bleibt**',
    ),
    CourseItem(
      prompt: 'He believes that we are coming tomorrow.',
      answer: 'Er glaubt, dass wir morgen **kommen**',
    ),
    CourseItem(
      prompt: 'She thinks that the film is boring.',
      answer: 'Sie findet, dass der Film langweilig **ist**',
    ),
    CourseItem(
      prompt: 'We know that he works a lot.',
      answer: 'Wir wissen, dass er viel **arbeitet**',
    ),
    CourseItem(
      prompt: 'I am glad that you are helping me.',
      answer: 'Ich freue mich, dass du mir **hilfst**',
    ),
    CourseItem(
      prompt: 'It is a pity that she cannot come.',
      answer: 'Es ist schade, dass sie nicht kommen **kann**',
    ),
    CourseItem(
      prompt: 'He says that the food tastes good.',
      answer: 'Er sagt, dass das Essen gut **schmeckt**',
    ),
    CourseItem(
      prompt: 'I think that German is fun.',
      answer: 'Ich denke, dass Deutsch Spaß **macht**',
    ),
    CourseItem(
      prompt: 'She hopes that the train comes on time.',
      answer: 'Sie hofft, dass der Zug pünktlich **kommt**',
    ),
    CourseItem(
      prompt: 'We believe that you all can do it.',
      answer: 'Wir glauben, dass ihr das **könnt**',
    ),
    CourseItem(
      prompt: 'I know that they live here.',
      answer: 'Ich weiß, dass sie hier **wohnen**',
    ),
  ],
);

final QuizContent enDeM11Wenn = enDeFill(
  id: 'en_de_m11_wenn',
  title: 'wenn',
  intro:
      'wenn means "when/if". The verb goes to the end of the wenn-clause; if '
      'that clause comes first, the main clause then starts with its verb.',
  tips: _connectorTips,
  items: const [
    CourseItem(
      prompt: 'When it rains, I stay home. (Wenn es …)',
      answer: 'Wenn es **regnet**, bleibe ich zu Hause',
    ),
    CourseItem(
      prompt: 'When I have time, I read.',
      answer: 'Wenn ich Zeit **habe**, lese ich',
    ),
    CourseItem(
      prompt: 'If you want, we can go.',
      answer: 'Wenn du **willst**, können wir gehen',
    ),
    CourseItem(
      prompt: 'When the film begins, we are quiet.',
      answer: 'Wenn der Film **beginnt**, sind wir leise',
    ),
    CourseItem(
      prompt: 'When the sun shines, we go to the park.',
      answer: 'Wenn die Sonne **scheint**, gehen wir in den Park',
    ),
    CourseItem(
      prompt: 'If you are hungry, we eat now.',
      answer: 'Wenn du Hunger **hast**, essen wir jetzt',
    ),
    CourseItem(
      prompt: 'When I am tired, I sleep.',
      answer: 'Wenn ich müde **bin**, schlafe ich',
    ),
    CourseItem(
      prompt: 'If it snows, we stay home.',
      answer: 'Wenn es **schneit**, bleiben wir zu Hause',
    ),
    CourseItem(
      prompt: 'When the weekend comes, we celebrate.',
      answer: 'Wenn das Wochenende **kommt**, feiern wir',
    ),
    CourseItem(
      prompt: 'If you need help, call me.',
      answer: 'Wenn du Hilfe **brauchst**, ruf mich an',
    ),
    CourseItem(
      prompt: 'When grandma visits, she bakes a cake.',
      answer: 'Wenn Oma zu Besuch **kommt**, backt sie einen Kuchen',
    ),
    CourseItem(
      prompt: 'If the shop is open, I buy bread.',
      answer: 'Wenn das Geschäft offen **ist**, kaufe ich Brot',
    ),
    CourseItem(
      prompt: 'When we have holidays, we travel.',
      answer: 'Wenn wir Ferien **haben**, verreisen wir',
    ),
    CourseItem(
      prompt: 'If you all want, we play cards.',
      answer: 'Wenn ihr **wollt**, spielen wir Karten',
    ),
    CourseItem(
      prompt: 'When the music plays, they dance.',
      answer: 'Wenn die Musik **spielt**, tanzen sie',
    ),
  ],
);

// 11.5 — big text with TYPED inputs: type the right connector. The word order
// in each clause is the clue (verb at the end → weil/dass/wenn).
final QuizContent enDeM11BigText = enDeBigText(
  id: 'en_de_m11_bigtext',
  title: 'Big text: Warum lernst du Deutsch?',
  passageTitle: 'Warum lernst du Deutsch?',
  template:
      'Viele Leute fragen mich: „Warum lernst du eigentlich Deutsch? Das ist '
      'doch so schwer!" Also gut, ich erkläre es. Ich lerne Deutsch, {{0}} ich '
      'seit zwei Jahren in Berlin wohne und die Sprache jeden Tag höre. Am '
      'Anfang war es wirklich frustrierend, {{1}} ich habe einfach nicht '
      'aufgegeben. Ich glaube fest, {{2}} Deutsch sehr wichtig für meinen Job '
      'und meine Zukunft ist. {{3}} ich abends Zeit habe, schaue ich deutsche '
      'Serien — oft sogar ohne Untertitel, ziemlich mutig, oder? Und ehrlich '
      'gesagt mag ich diese Sprache, {{4}} sie klingt für mich einfach schön '
      'und logisch. Also: nicht aufgeben, weiterüben!',
  blanks: [
    inputBlank('weil', hint: 'weil/dass/wenn/aber/denn'),
    inputBlank('aber', hint: 'weil/dass/wenn/aber/denn'),
    inputBlank('dass', hint: 'weil/dass/wenn/aber/denn'),
    inputBlank('Wenn', hint: 'weil/dass/wenn/aber/denn'),
    inputBlank('denn', hint: 'weil/dass/wenn/aber/denn'),
  ],
  passageTranslation:
      'Many people ask me: "Why on earth are you learning German? It\'s so '
      'hard!" All right, let me explain. I\'m learning German because I\'ve lived '
      'in Berlin for two years and hear the language every day. At the start it '
      "was really frustrating, but I simply didn't give up. I firmly believe "
      'that German is very important for my job and my future. When I have time '
      'in the evening, I watch German series — often even without subtitles, '
      'pretty brave, right? And honestly, I like this language, because it '
      'sounds beautiful and logical to me. So: don\'t give up, keep practising!',
  intro:
      'Type the right connector. The word order is your clue: a verb at the '
      'end of the clause means weil/dass/wenn; normal order means aber/denn.',
  tips: _connectorTips,
);

final QuizContent enDeM11Listening = enDeListen(
  id: 'en_de_m11_listening',
  title: 'Listening: the weil-reason',
  passageTitle: 'Anna ist krank',
  passage:
      'Anna bleibt heute zu Hause, weil sie krank ist. Sie kann nicht '
      'arbeiten. Morgen geht sie zum Arzt.',
  passageTranslation:
      'Anna is staying home today because she is sick. She cannot work. '
      'Tomorrow she is going to the doctor.',
  intro:
      'Listen and answer. Catch the reason (weil …) and what Anna does next.',
  tips: _connectorTips,
  questions: const [
    ReadingQuestion(
      question: 'Warum bleibt Anna zu Hause?',
      options: [
        'Weil sie krank ist',
        'Weil sie Ferien hat',
        'Weil sie müde ist',
      ],
      correctIndex: 0,
      questionTranslation: 'Why does Anna stay home?',
    ),
    ReadingQuestion(
      question: 'Was kann Anna nicht machen?',
      options: ['Arbeiten', 'Schlafen', 'Essen'],
      correctIndex: 0,
      questionTranslation: 'What can Anna not do?',
    ),
    ReadingQuestion(
      question: 'Was macht sie morgen?',
      options: ['Sie geht zum Arzt', 'Sie geht arbeiten', 'Sie bleibt im Bett'],
      correctIndex: 0,
      questionTranslation: 'What does she do tomorrow?',
    ),
  ],
);

final QuizContent enDeM11Dictation = enDeDict(
  id: 'en_de_m11_dictation',
  title: 'Dictation: subordinate clauses',
  intro:
      'Listen and write each sentence, including the comma. Remember the '
      'verb sits at the end of a weil/dass/wenn clause.',
  tips: _connectorTips,
  items: const [
    CourseItem(
      prompt: "I stay home because I'm sick.",
      answer: 'Ich bleibe zu Hause, weil ich krank bin.',
    ),
    CourseItem(
      prompt: 'I think that he is nice.',
      answer: 'Ich denke, dass er nett ist.',
    ),
    CourseItem(
      prompt: 'When it rains, I read.',
      answer: 'Wenn es regnet, lese ich.',
    ),
    CourseItem(
      prompt: 'She says that she has time.',
      answer: 'Sie sagt, dass sie Zeit hat.',
    ),
    CourseItem(
      prompt: "I'm happy, but I'm tired.",
      answer: 'Ich bin glücklich, aber ich bin müde.',
    ),
    CourseItem(
      prompt: 'We take the bus, because it is raining.',
      answer: 'Wir nehmen den Bus, denn es regnet.',
    ),
    CourseItem(
      prompt: 'He learns German because he lives in Berlin.',
      answer: 'Er lernt Deutsch, weil er in Berlin wohnt.',
    ),
    CourseItem(
      prompt: 'I hope that you are coming.',
      answer: 'Ich hoffe, dass du kommst.',
    ),
    CourseItem(
      prompt: 'If you want, we can go.',
      answer: 'Wenn du willst, können wir gehen.',
    ),
    CourseItem(
      prompt: 'Do you want tea or coffee?',
      answer: 'Möchtest du Tee oder Kaffee?',
    ),
    CourseItem(
      prompt: 'She works and he cooks.',
      answer: 'Sie arbeitet und er kocht.',
    ),
    CourseItem(
      prompt: 'I know that they live here.',
      answer: 'Ich weiß, dass sie hier wohnen.',
    ),
    CourseItem(
      prompt: 'When the sun shines, we go out.',
      answer: 'Wenn die Sonne scheint, gehen wir raus.',
    ),
    CourseItem(
      prompt: 'He is tired because he slept badly.',
      answer: 'Er ist müde, weil er schlecht geschlafen hat.',
    ),
    CourseItem(
      prompt: 'It is a pity that she cannot come.',
      answer: 'Es ist schade, dass sie nicht kommen kann.',
    ),
  ],
);

/// M11 — Connecting Sentences, in module order.

/// Speaking: run this conversation in your own AI assistant and bring the
/// score back (see `SpeakingQuizPage`).
final QuizContent enDeM11Speaking = enDeSpeaking(
  id: 'en_de_m11_speaking',
  title: 'Say why, and say what you think',
  level: 'A2',
  topic:
      'My opinions and reasons: why I like or dislike something, what I think, and what I do when something happens.',
  practisePoints: [
    'weil + verb at the end: ..., weil ich keine Zeit habe.',
    'dass + verb at the end: Ich glaube, dass es gut ist.',
    'wenn for conditions and things that repeat',
    'und/aber/oder/denn keep the normal word order',
  ],
  targetVocabulary: ['weil', 'dass', 'wenn', 'aber', 'denn', 'deshalb'],
  scoringCriteria: [
    'the verb at the end after weil/dass/wenn',
    'normal order after und/aber/oder/denn',
    'the comma before the clause',
  ],
  priorityErrors: [
    'verb not at the end in a subordinate clause',
    'verb moved after aber or und',
    'wrong connector',
  ],
  intro:
      'Give reasons and opinions out loud. Copy the exercise into your AI assistant, turn on voice mode, and explain yourself.',
  tips: _connectorTips,
);

/// Mid-module speaking checkpoint: a shorter, question-driven run over
/// what the module has taught up to this point, before the second half
/// adds the rest. The closing exercise covers the module as a whole.
final QuizContent enDeM11SpeakingCheck = enDeSpeaking(
  id: 'en_de_m11_speaking_check',
  title: 'Checkpoint: and, but, because',
  level: 'A2',
  topic: 'Short answers with a reason attached: why I like or do something.',
  practisePoints: [
    'und, aber, oder, denn keep the normal word order',
    'weil sends the verb to the end',
    'The comma before weil',
  ],
  targetVocabulary: ['und', 'aber', 'denn', 'weil', 'gern'],
  scoringCriteria: [
    'normal order after und/aber/oder/denn',
    'the verb at the end after weil',
    'a reason that fits',
  ],
  priorityErrors: [
    'verb moved after aber or und',
    'verb not at the end after weil',
  ],
  mode: SpeakingMode.interview,
  session: SpeakingSession(durationMinutes: 3, minExchanges: 6),
  report: SpeakingReport(maxWords: 150, maxCorrections: 3),
  intro:
      'A short checkpoint on what this module has covered so far. Copy it into your AI assistant, turn on voice mode, and answer its questions - three minutes is enough.',
  tips: _connectorTips,
);

final List<QuizContent> enDeM11 = [
  enDeM11Coordinating,
  enDeM11Weil,
  enDeM11BigTextWarmup,
  enDeM11Dass,
  enDeM11SpeakingCheck,
  enDeM11Wenn,
  enDeM11Listening,
  enDeM11Dictation,
  enDeM11BigText,
  enDeM11Speaking,
];
