import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M11 — Connecting Sentences (A2). Coordinating conjunctions keep the word
/// order; subordinating ones (weil, dass, wenn) kick the verb to the end.

const List<HelpMemoryTip> _connectorTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Two kinds of connector',
    text: '**und, aber, oder, denn** keep normal word order. **weil, dass, '
        'wenn, obwohl** (subordinating) send the conjugated verb to the **END** '
        'of the clause.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'weil kicks, denn does not',
    text: '…, **weil** ich müde **bin** (verb at the end) = …, **denn** ich '
        '**bin** müde (normal order). Same meaning, different word order.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Front clause → verb, comma, verb',
    text: 'If the wenn-clause comes first, the main clause starts with its verb: '
        '**Wenn** es **regnet**, **bleibe** ich zu Hause.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'Always a comma',
    text: 'A subordinate clause is always fenced off with a comma: Ich glaube, '
        '**dass** das stimmt.',
  ),
];

final QuizContent enDeM11Coordinating = enDeFill(
  id: 'en_de_m11_coordinating',
  title: 'und / aber / oder / denn',
  intro: 'These four connect two full sentences and change nothing about the '
      'word order. denn means "because" and keeps normal order.',
  tips: _connectorTips,
  items: const [
    CourseItem(prompt: "I'm tired, but I'm happy.", answer: 'Ich bin müde, **aber** ich bin glücklich'),
    CourseItem(prompt: "I'm learning German, because it's fun. (denn)", answer: 'Ich lerne Deutsch, **denn** es macht Spaß'),
    CourseItem(prompt: 'Do you want tea or coffee?', answer: 'Möchtest du Tee **oder** Kaffee?'),
    CourseItem(prompt: 'She works and he cooks.', answer: 'Sie arbeitet **und** er kocht'),
    CourseItem(prompt: 'I want to come, but I have no time.', answer: 'Ich will kommen, **aber** ich habe keine Zeit'),
  ],
);

final QuizContent enDeM11Weil = enDeFill(
  id: 'en_de_m11_weil',
  title: 'weil (verb to the end)',
  intro: 'weil means "because" and sends the conjugated verb to the very end of '
      'its clause.',
  tips: _connectorTips,
  items: const [
    CourseItem(prompt: "I stay home because I'm sick. (… ich krank …)", answer: 'Ich bleibe zu Hause, weil ich krank **bin**'),
    CourseItem(prompt: 'She is happy because she has holidays.', answer: 'Sie ist glücklich, weil sie Ferien **hat**'),
    CourseItem(prompt: 'We learn German because we live in Berlin.', answer: 'Wir lernen Deutsch, weil wir in Berlin **wohnen**'),
    CourseItem(prompt: 'I practise because I want to get better.', answer: 'Ich übe, weil ich besser werden **will**'),
    CourseItem(prompt: "I can't come because I have no time.", answer: 'Ich kann nicht kommen, weil ich keine Zeit **habe**'),
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
  intro: 'Type the connector. und, aber, oder and denn keep normal word order; '
      'weil sends the verb to the very end (…, weil das Wetter schön war).',
  tips: _connectorTips,
);

final QuizContent enDeM11Dass = enDeFill(
  id: 'en_de_m11_dass',
  title: 'dass',
  intro: 'dass ("that") introduces a reported thought or fact — and again the '
      'verb goes to the end.',
  tips: _connectorTips,
  items: const [
    CourseItem(prompt: 'I think that he is nice.', answer: 'Ich denke, dass er nett **ist**'),
    CourseItem(prompt: 'She says that she has time.', answer: 'Sie sagt, dass sie Zeit **hat**'),
    CourseItem(prompt: 'I know that you live in Berlin.', answer: 'Ich weiß, dass du in Berlin **wohnst**'),
    CourseItem(prompt: "It's good that you are here.", answer: 'Es ist gut, dass du hier **bist**'),
  ],
);

final QuizContent enDeM11Wenn = enDeFill(
  id: 'en_de_m11_wenn',
  title: 'wenn',
  intro: 'wenn means "when/if". The verb goes to the end of the wenn-clause; if '
      'that clause comes first, the main clause then starts with its verb.',
  tips: _connectorTips,
  items: const [
    CourseItem(prompt: 'When it rains, I stay home. (Wenn es …)', answer: 'Wenn es **regnet**, bleibe ich zu Hause'),
    CourseItem(prompt: 'When I have time, I read.', answer: 'Wenn ich Zeit **habe**, lese ich'),
    CourseItem(prompt: 'If you want, we can go.', answer: 'Wenn du **willst**, können wir gehen'),
    CourseItem(prompt: 'When the film begins, we are quiet.', answer: 'Wenn der Film **beginnt**, sind wir leise'),
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
  intro: 'Type the right connector. The word order is your clue: a verb at the '
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
  intro: 'Listen and answer. Catch the reason (weil …) and what Anna does next.',
  tips: _connectorTips,
  questions: const [
    ReadingQuestion(
      question: 'Warum bleibt Anna zu Hause?',
      options: ['Weil sie krank ist', 'Weil sie Ferien hat', 'Weil sie müde ist'],
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
  intro: 'Listen and write each sentence, including the comma. Remember the '
      'verb sits at the end of a weil/dass/wenn clause.',
  tips: _connectorTips,
  items: const [
    CourseItem(prompt: "I stay home because I'm sick.", answer: 'Ich bleibe zu Hause, weil ich krank bin.'),
    CourseItem(prompt: 'I think that he is nice.', answer: 'Ich denke, dass er nett ist.'),
    CourseItem(prompt: 'When it rains, I read.', answer: 'Wenn es regnet, lese ich.'),
    CourseItem(prompt: 'She says that she has time.', answer: 'Sie sagt, dass sie Zeit hat.'),
    CourseItem(prompt: "I'm happy, but I'm tired.", answer: 'Ich bin glücklich, aber ich bin müde.'),
  ],
);

/// M11 — Connecting Sentences, in module order.
final List<QuizContent> enDeM11 = [
  enDeM11Coordinating,
  enDeM11Weil,
  enDeM11BigTextWarmup,
  enDeM11Dass,
  enDeM11Wenn,
  enDeM11Listening,
  enDeM11Dictation,
  enDeM11BigText,
];
