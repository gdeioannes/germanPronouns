import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M1 — Present Tense & Word Order (A1). The on-ramp: conjugate regular verbs
/// and sein/haben, keep the verb in second position, and ask questions. Theme:
/// meeting Anna and her everyday life — reused in the speaking and the big text.

const List<HelpMemoryTip> _presentTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The six endings',
    text: 'ich -**e**, du -**st**, er/sie/es -**t**, wir -**en**, ihr -**t**, '
        'sie/Sie -**en**. So: ich mach**e**, du mach**st**, er mach**t**, wir '
        'mach**en**, ihr mach**t**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'sein & haben — learn by heart',
    text: 'sein: ich **bin**, du **bist**, er **ist**, wir **sind**, ihr '
        '**seid**, sie **sind**. haben: ich **habe**, du **hast**, er **hat**, '
        'wir **haben**, ihr **habt**, sie **haben**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Verb in position 2 (V2)',
    text: 'The finite verb is always the second element: *Ich **spiele** heute.* '
        '= *Heute **spiele** ich.* Move anything to the front and the verb stays '
        'glued in slot 2.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Stems in -t / -d add -e',
    text: 'After a stem ending in -t or -d, slip in an extra -e so you can hear '
        'it: du arbeit**e**st, er arbeit**e**t, ihr find**e**t.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'One present, no -ing',
    text: 'German has a single present tense: **ich spiele** means both '
        '"I play" and "I am playing".',
  ),
];

final QuizContent enDeM1Regular = enDeFill(
  id: 'en_de_m1_regular',
  title: 'Present tense: regular verbs',
  intro: 'Most German verbs are regular: take the stem and add the ending for '
      'the person. Learn the six endings here and you can use thousands of '
      'verbs.',
  tips: _presentTips,
  items: const [
    CourseItem(prompt: 'I live in Hamburg. (wohnen)', answer: 'Ich **wohne** in Hamburg'),
    CourseItem(prompt: 'You play football. (spielen, du)', answer: 'Du **spielst** Fußball'),
    CourseItem(prompt: 'She makes pizza. (machen)', answer: 'Sie **macht** Pizza'),
    CourseItem(prompt: 'We learn German. (lernen)', answer: 'Wir **lernen** Deutsch'),
    CourseItem(prompt: 'You all live here. (wohnen, ihr)', answer: 'Ihr **wohnt** hier'),
    CourseItem(prompt: 'They play often. (spielen)', answer: 'Sie **spielen** oft'),
    CourseItem(prompt: 'He works a lot. (arbeiten)', answer: 'Er **arbeitet** viel'),
    CourseItem(prompt: 'I find the city beautiful. (finden)', answer: 'Ich **finde** die Stadt schön'),
  ],
);

final QuizContent enDeM1SeinHaben = enDeFill(
  id: 'en_de_m1_sein_haben',
  title: 'sein & haben',
  intro: 'The two most important verbs are irregular, so learn them by heart: '
      'sein (to be) and haben (to have). You will use them constantly.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'sein',
      text: 'ich bin, du bist, er/sie/es ist, wir sind, ihr seid, sie/Sie sind.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'haben',
      text: 'ich habe, du hast, er/sie/es hat, wir haben, ihr habt, sie/Sie '
          'haben.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am tired. (sein)', answer: 'Ich **bin** müde'),
    CourseItem(prompt: 'You are nice. (sein, du)', answer: 'Du **bist** nett'),
    CourseItem(prompt: 'He is at home. (sein)', answer: 'Er **ist** zu Hause'),
    CourseItem(prompt: 'We are students. (sein)', answer: 'Wir **sind** Studenten'),
    CourseItem(prompt: 'You all are funny. (sein, ihr)', answer: 'Ihr **seid** lustig'),
    CourseItem(prompt: 'I have time. (haben)', answer: 'Ich **habe** Zeit'),
    CourseItem(prompt: 'She has a dog. (haben)', answer: 'Sie **hat** einen Hund'),
    CourseItem(prompt: 'You have a car. (haben, du)', answer: 'Du **hast** ein Auto'),
  ],
);

final QuizContent enDeM1WordOrder = enDeFill(
  id: 'en_de_m1_word_order',
  title: 'The verb-second (V2) rule',
  intro: 'In a German statement the conjugated verb is always the second '
      'element. Start with a time or place, and the verb still comes right '
      'after it — then the subject.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Verb in position 2',
      text: 'Whatever comes first (Heute, In Berlin, Am Montag…), the verb is '
          'second and the subject follows it: Heute gehe ich…',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Compare',
      text: 'Ich gehe heute ins Kino. = Heute gehe ich ins Kino. The verb '
          '"gehe" never moves from slot 2.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Today I go to the cinema. (gehen)', answer: 'Heute **gehe** ich ins Kino'),
    CourseItem(prompt: 'Tomorrow we play football. (spielen)', answer: 'Morgen **spielen** wir Fußball'),
    CourseItem(prompt: 'At eight the film begins. (beginnen)', answer: 'Um acht Uhr **beginnt** der Film'),
    CourseItem(prompt: 'On Monday I have time. (haben)', answer: 'Am Montag **habe** ich Zeit'),
    CourseItem(prompt: 'Now he learns German. (lernen)', answer: 'Jetzt **lernt** er Deutsch'),
    CourseItem(prompt: 'In Berlin she works. (arbeiten)', answer: 'In Berlin **arbeitet** sie'),
  ],
);

final QuizContent enDeM1Questions = enDeFill(
  id: 'en_de_m1_questions',
  title: 'Questions (yes/no & W-questions)',
  intro: 'For a yes/no question, put the verb first. For a W-question, the '
      'question word comes first and the verb second.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Two patterns',
      text: 'Yes/no: Verb + subject? (Wohnst du hier?). W-question: '
          'W-word + verb + subject? (Wo wohnst du?).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The W-words',
      text: 'wer (who), was (what), wo (where), wann (when), wie (how), '
          'warum (why).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Do you live here? (wohnen, du)', answer: '**Wohnst** du hier?'),
    CourseItem(prompt: 'Where do you live?', answer: 'Wo **wohnst** du?'),
    CourseItem(prompt: 'What are you doing? (machen)', answer: 'Was **machst** du?'),
    CourseItem(prompt: 'Do you have time? (haben)', answer: '**Hast** du Zeit?'),
    CourseItem(prompt: 'When does the film begin?', answer: 'Wann **beginnt** der Film?'),
    CourseItem(prompt: 'Are you a student? (sein)', answer: '**Bist** du Student?'),
    CourseItem(prompt: 'Why are you learning German?', answer: 'Warum **lernst** du Deutsch?'),
  ],
);

// 1.5 — big text with TYPED inputs: produce the present-tense verb forms inside
// a self-introduction. (No cases yet at M1, so the inline blanks are inputs.)
final QuizContent enDeM1BigTextWarmup = enDeBigText(
  id: 'en_de_m1_bigtext_warmup',
  title: 'Big text (warm-up): Mein neuer Mitbewohner',
  passageTitle: 'Mein neuer Mitbewohner',
  template:
      'Das {{0}} Felix, mein neuer Mitbewohner. Er {{1}} aus Köln und {{2}} 22 '
      'Jahre alt. Felix {{3}} Gitarre — leider auch um Mitternacht! Morgens '
      '{{4}} ich oft müde, aber Felix {{5}} immer gute Laune. Jeden Tag fragt '
      'er: {{6}} du Zeit? Wir {{7}} zusammen Kaffee und {{8}} Musik. Eigentlich '
      '{{9}} er ganz nett.',
  blanks: [
    inputBlank('ist', hint: 'sein → das …'),
    inputBlank('kommt', hint: 'kommen → er …'),
    inputBlank('ist', hint: 'sein → er …'),
    inputBlank('spielt', hint: 'spielen → er …'),
    inputBlank('bin', hint: 'sein → ich …'),
    inputBlank('hat', hint: 'haben → er …'),
    inputBlank('Hast', accepted: ['hast'], hint: 'haben → du …'),
    inputBlank('trinken', hint: 'trinken → wir …'),
    inputBlank('machen', hint: 'machen → wir …'),
    inputBlank('ist', hint: 'sein → er …'),
  ],
  passageTranslation:
      'This is Felix, my new roommate. He comes from Cologne and is 22 years '
      'old. Felix plays the guitar — unfortunately also at midnight! In the '
      "mornings I'm often tired, but Felix is always in a good mood. Every day "
      'he asks: do you have time? We drink coffee together and make music. '
      "Actually he's quite nice.",
  intro: 'Type the present-tense form of each verb (the infinitive is the '
      'hint). A mix of regular verbs and sein/haben — watch the endings: '
      'ich -e/bin/habe, du -st/bist/hast, er -t/ist/hat.',
  tips: _presentTips,
);

final QuizContent enDeM1BigText = enDeBigText(
  id: 'en_de_m1_bigtext',
  title: 'Big text: Das bin ich',
  passageTitle: 'Das bin ich',
  template:
      'Hallo! Ich {{0}} Anna, ich bin 24 Jahre alt und {{1}} seit drei Jahren '
      'in Hamburg. Ich liebe diese Stadt! Jeden Morgen {{2}} ich viel zu früh '
      'auf und {{3}} sofort einen riesigen Kaffee — ohne Kaffee bin ich einfach '
      'kein Mensch. An der Uni {{4}} ich Medizin. Das ist oft anstrengend, aber '
      'es macht mir großen Spaß. Am Wochenende {{5}} ich Fußball mit Freunden, '
      'doch ehrlich gesagt {{6}} ich ziemlich schlecht. Mein Bruder Tom {{7}} '
      'in Berlin und {{8}} dort als Lehrer. Wir telefonieren fast jeden Abend '
      'und lachen über alte Geschichten. Und du? Was {{9}} du in deiner '
      'Freizeit?',
  blanks: [
    inputBlank('heiße', accepted: ['heisse'], hint: 'heißen → ich …'),
    inputBlank('wohne', hint: 'wohnen → ich …'),
    inputBlank('stehe', hint: 'aufstehen → ich …'),
    inputBlank('trinke', hint: 'trinken → ich …'),
    inputBlank('studiere', hint: 'studieren → ich …'),
    inputBlank('spiele', hint: 'spielen → ich …'),
    inputBlank('bin', hint: 'sein → ich …'),
    inputBlank('wohnt', hint: 'wohnen → er …'),
    inputBlank('arbeitet', hint: 'arbeiten → er …'),
    inputBlank('machst', hint: 'machen → du …'),
  ],
  passageTranslation:
      "Hi! I'm Anna, I'm 24 years old and I've lived in Hamburg for three "
      "years. I love this city! Every morning I get up far too early and "
      "immediately drink a huge coffee — without coffee I'm simply not a "
      'person. At university I study medicine. It is often exhausting, but I '
      "really enjoy it. At the weekend I play football with friends, though "
      "honestly I'm pretty bad. My brother Tom lives in Berlin and works there "
      'as a teacher. We phone almost every evening and laugh about old stories. '
      'And you? What do you do in your free time?',
  intro: 'Type the correct present-tense form of each verb (the infinitive is '
      'the hint). Watch the endings: ich -e, du -st, er/sie -t, wir -en.',
  tips: _presentTips,
);

final QuizContent enDeM1Speak = enDeSpeak(
  id: 'en_de_m1_speak',
  title: 'Speak: greetings & introductions',
  intro: 'Say each line aloud. These are the first sentences you need to meet '
      'someone in German.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Formal vs informal',
      text: 'Use "Wie heißt du?" with friends, "Wie heißen Sie?" with '
          'strangers and in formal situations.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hello, my name is Anna.', answer: 'Hallo, ich heiße Anna.'),
    CourseItem(prompt: 'What is your name?', answer: 'Wie heißt du?'),
    CourseItem(prompt: 'I come from Germany.', answer: 'Ich komme aus Deutschland.'),
    CourseItem(prompt: 'I live in Hamburg.', answer: 'Ich wohne in Hamburg.'),
    CourseItem(prompt: 'How are you?', answer: 'Wie geht es dir?'),
    CourseItem(prompt: "I'm fine, thanks.", answer: 'Mir geht es gut, danke.'),
    CourseItem(prompt: 'Nice to meet you.', answer: 'Freut mich.'),
  ],
);

final QuizContent enDeM1Dictation = enDeDict(
  id: 'en_de_m1_dictation',
  title: 'Dictation: short present-tense sentences',
  intro: 'Listen and type each sentence. Catch the verb ending — it tells you '
      'who is doing the action.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Listen for the ending',
      text: 'machst (du) vs macht (er) vs machen (wir) — the ending is the only '
          'difference.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I live in Hamburg.', answer: 'Ich wohne in Hamburg.'),
    CourseItem(prompt: 'What are you doing today?', answer: 'Was machst du heute?'),
    CourseItem(prompt: 'He works in Berlin.', answer: 'Er arbeitet in Berlin.'),
    CourseItem(prompt: 'We learn German.', answer: 'Wir lernen Deutsch.'),
    CourseItem(prompt: 'Do you have time?', answer: 'Hast du Zeit?'),
  ],
);

/// M1 — Present Tense & Word Order, in module order.
final List<QuizContent> enDeM1 = [
  enDeM1Regular,
  enDeM1SeinHaben,
  enDeM1BigTextWarmup,
  enDeM1WordOrder,
  enDeM1Questions,
  enDeM1BigText,
  enDeM1Speak,
  enDeM1Dictation,
];
