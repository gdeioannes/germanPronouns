import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M9 — Modal & Separable Verbs (A2). Modals send the main verb to the end as
/// an infinitive; separable verbs split and send the prefix to the end. Theme:
/// "Mein Tag" — a daily routine.

const List<HelpMemoryTip> _modalTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The modal frame',
    text:
        'The modal is conjugated in position 2; the main verb waits at the end '
        'as an **infinitive**: Ich **kann** Deutsch **sprechen**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Modals: no -t for er',
    text:
        'The singular changes its vowel and ich = er: ich **kann**, du '
        '**kannst**, er **kann** · ich **muss**, er **muss** · ich **will**, er '
        '**will**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Separable verbs split',
    text:
        'The prefix flies to the end: auf·stehen → Ich stehe um 7 **auf**. '
        'ein·kaufen → Ich kaufe **ein**. an·rufen → Ich rufe dich **an**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Imperative drops the pronoun',
    text:
        '**Komm!** · **Wartet!** · **Öffnen Sie!** (du usually drops -st: du '
        'kommst → **Komm!**, but: du gibst → **Gib!**).',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'The six modals',
    text:
        '**können, müssen, wollen, sollen, dürfen, mögen** — plus the polite '
        '**möchte** (would like).',
  ),
];

final QuizContent enDeM9ModalForms = enDeFill(
  id: 'en_de_m9_modal_forms',
  title: 'Modal verb forms',
  intro:
      'The six modals: können, müssen, wollen, sollen, dürfen, mögen. They '
      'change their vowel in the singular and the ich/er forms are identical.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'I can (können)', answer: 'ich **kann**'),
    CourseItem(prompt: 'you can (du)', answer: 'du **kannst**'),
    CourseItem(prompt: 'he must (müssen)', answer: 'er **muss**'),
    CourseItem(prompt: 'we want (wollen)', answer: 'wir **wollen**'),
    CourseItem(prompt: 'I should (sollen)', answer: 'ich **soll**'),
    CourseItem(prompt: 'you may (dürfen, du)', answer: 'du **darfst**'),
    CourseItem(prompt: 'I like (mögen)', answer: 'ich **mag**'),
    CourseItem(prompt: 'I would like (möchte)', answer: 'ich **möchte**'),
    CourseItem(prompt: 'she can (können)', answer: 'sie **kann**'),
    CourseItem(prompt: 'you must (müssen, du)', answer: 'du **musst**'),
    CourseItem(prompt: 'he wants (wollen)', answer: 'er **will**'),
    CourseItem(prompt: 'you all may (dürfen, ihr)', answer: 'ihr **dürft**'),
    CourseItem(prompt: 'they must (müssen)', answer: 'sie **müssen**'),
    CourseItem(prompt: 'you all should (sollen, ihr)', answer: 'ihr **sollt**'),
    CourseItem(prompt: 'we would like (möchten)', answer: 'wir **möchten**'),
  ],
);

final QuizContent enDeM9ModalOrder = enDeFill(
  id: 'en_de_m9_modal_order',
  title: 'Modal + main verb at the end',
  intro:
      'Put the main verb at the end as an infinitive. The modal sits in '
      'position 2 and does the conjugating.',
  tips: _modalTips,
  items: const [
    CourseItem(
      prompt: 'I can speak German. (sprechen)',
      answer: 'Ich kann Deutsch **sprechen**',
    ),
    CourseItem(
      prompt: 'You must work today. (arbeiten)',
      answer: 'Du musst heute **arbeiten**',
    ),
    CourseItem(
      prompt: 'We want to go to the cinema. (gehen)',
      answer: 'Wir wollen ins Kino **gehen**',
    ),
    CourseItem(
      prompt: 'May I open the window? (öffnen)',
      answer: 'Darf ich das Fenster **öffnen**?',
    ),
    CourseItem(
      prompt: "She can't come. (kommen)",
      answer: 'Sie kann nicht **kommen**',
    ),
    CourseItem(
      prompt: 'You should sleep more. (schlafen)',
      answer: 'Du sollst mehr **schlafen**',
    ),
    CourseItem(
      prompt: 'He wants to buy a car. (kaufen)',
      answer: 'Er will ein Auto **kaufen**',
    ),
    CourseItem(
      prompt: 'I must get up early. (aufstehen)',
      answer: 'Ich muss früh **aufstehen**',
    ),
    CourseItem(
      prompt: 'We may stay here. (bleiben)',
      answer: 'Wir dürfen hier **bleiben**',
    ),
    CourseItem(
      prompt: 'She would like to drink a coffee. (trinken)',
      answer: 'Sie möchte einen Kaffee **trinken**',
    ),
    CourseItem(
      prompt: 'They can help us. (helfen)',
      answer: 'Sie können uns **helfen**',
    ),
    CourseItem(
      prompt: 'You all must learn German. (lernen, ihr)',
      answer: 'Ihr müsst Deutsch **lernen**',
    ),
    CourseItem(
      prompt: 'I want to eat something. (essen)',
      answer: 'Ich will etwas **essen**',
    ),
    CourseItem(
      prompt: 'One may not smoke here. (rauchen)',
      answer: 'Man darf hier nicht **rauchen**',
    ),
    CourseItem(
      prompt: 'We should visit grandma. (besuchen)',
      answer: 'Wir sollen Oma **besuchen**',
    ),
  ],
);

// 9.2a — warm-up big text (after the modal quizzes): type the modal. It sits in
// position 2; the main verb waits at the end as an infinitive.
final QuizContent enDeM9BigTextWarmup = enDeBigText(
  id: 'en_de_m9_bigtext_warmup',
  title: 'Big text (warm-up): Endlich Wochenende',
  passageTitle: 'Endlich Wochenende',
  template:
      'Endlich Freitag! Am Wochenende {{0}} ich endlich ausschlafen — kein '
      'Wecker, kein Stress! Samstagmorgen {{1}} ich vielleicht joggen gehen, '
      'aber ehrlich gesagt {{2}} ich lieber im warmen Bett bleiben. Meine '
      'Freundin {{3}} unbedingt ins Kino gehen, also treffen wir uns am Abend. '
      '„{{4}} du eigentlich auch Popcorn?", fragt sie mich jedes Mal. Am Sonntag '
      '{{5}} ich dann leider für eine Prüfung lernen — das {{6}} leider sein, '
      'auch wenn ich überhaupt keine Lust habe.',
  blanks: [
    inputBlank('kann', hint: 'können → ich …'),
    inputBlank('will', hint: 'wollen → ich …'),
    inputBlank('möchte', hint: 'möchten → ich …'),
    inputBlank('will', hint: 'wollen → sie …'),
    inputBlank('Magst', accepted: ['magst'], hint: 'mögen → du …'),
    inputBlank('muss', hint: 'müssen → ich …'),
    inputBlank('muss', hint: 'müssen → das …'),
  ],
  passageTranslation:
      'Finally Friday! At the weekend I can finally sleep in — no alarm, no '
      "stress! On Saturday morning I might go jogging, but honestly I'd rather "
      'stay in my warm bed. My girlfriend really wants to go to the cinema, so '
      "we'll meet in the evening. \"Do you actually fancy popcorn too?\" she asks "
      'me every time. On Sunday I unfortunately have to study for an exam — that '
      "has to be done, even though I really don't feel like it.",
  intro:
      'Type the modal verb. Remember the frame: the modal sits in position 2 '
      'and the main verb waits at the very end as an infinitive — Am Wochenende '
      'kann ich endlich ausschlafen.',
  tips: _modalTips,
);

final QuizContent enDeM9Separable = enDeFill(
  id: 'en_de_m9_separable',
  title: 'Separable verbs',
  intro:
      'In a main clause a separable verb splits: the conjugated part stays '
      'in position 2 and the prefix goes to the very end.',
  tips: _modalTips,
  items: const [
    CourseItem(
      prompt: 'I get up at 7. (aufstehen)',
      answer: 'Ich stehe um 7 Uhr **auf**',
    ),
    CourseItem(
      prompt: 'She goes shopping. (einkaufen)',
      answer: 'Sie kauft **ein**',
    ),
    CourseItem(
      prompt: 'We watch TV. (fernsehen)',
      answer: 'Wir sehen **fern**',
    ),
    CourseItem(
      prompt: 'He calls his mother. (anrufen)',
      answer: 'Er ruft seine Mutter **an**',
    ),
    CourseItem(
      prompt: 'The train departs. (abfahren)',
      answer: 'Der Zug fährt **ab**',
    ),
    CourseItem(
      prompt: 'I tidy up the room. (aufräumen)',
      answer: 'Ich räume das Zimmer **auf**',
    ),
    CourseItem(
      prompt: 'The film starts at eight. (anfangen)',
      answer: 'Der Film fängt um acht **an**',
    ),
    CourseItem(
      prompt: 'I bring a cake. (mitbringen)',
      answer: 'Ich bringe einen Kuchen **mit**',
    ),
    CourseItem(
      prompt: 'She invites her friends. (einladen)',
      answer: 'Sie lädt ihre Freunde **ein**',
    ),
    CourseItem(
      prompt: 'We come back on Friday. (zurückkommen)',
      answer: 'Wir kommen am Freitag **zurück**',
    ),
    CourseItem(
      prompt: 'He closes the door. (zumachen)',
      answer: 'Er macht die Tür **zu**',
    ),
    CourseItem(
      prompt: 'I pick you up at six. (abholen)',
      answer: 'Ich hole dich um sechs **ab**',
    ),
    CourseItem(
      prompt: 'The shop opens at nine. (aufmachen)',
      answer: 'Das Geschäft macht um neun **auf**',
    ),
    CourseItem(
      prompt: 'She turns off the light. (ausmachen)',
      answer: 'Sie macht das Licht **aus**',
    ),
    CourseItem(
      prompt: 'We go out tonight. (ausgehen)',
      answer: 'Wir gehen heute Abend **aus**',
    ),
  ],
);

final QuizContent enDeM9Imperative = enDeFill(
  id: 'en_de_m9_imperative',
  title: 'The imperative',
  intro:
      'Commands drop the pronoun. The du-form usually drops the -st ending; '
      'the Sie-form keeps the verb + Sie.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'Come here! (du, kommen)', answer: '**Komm** her!'),
    CourseItem(prompt: 'Be quiet! (du, sein)', answer: '**Sei** leise!'),
    CourseItem(
      prompt: 'Help me, please! (du, helfen)',
      answer: '**Hilf** mir bitte!',
    ),
    CourseItem(
      prompt: 'Open the window! (Sie, öffnen)',
      answer: '**Öffnen** Sie das Fenster!',
    ),
    CourseItem(prompt: 'Wait! (ihr, warten)', answer: '**Wartet**!'),
    CourseItem(prompt: 'Get up! (du, aufstehen)', answer: '**Steh** auf!'),
    CourseItem(
      prompt: 'Take the bus! (du, nehmen)',
      answer: '**Nimm** den Bus!',
    ),
    CourseItem(
      prompt: 'Speak more slowly! (du, sprechen)',
      answer: '**Sprich** langsamer!',
    ),
    CourseItem(
      prompt: 'Please come in! (Sie, kommen)',
      answer: '**Kommen** Sie bitte herein!',
    ),
    CourseItem(
      prompt: 'Eat your vegetables! (ihr, essen)',
      answer: '**Esst** euer Gemüse!',
    ),
    CourseItem(
      prompt: 'Drink more water! (du, trinken)',
      answer: '**Trink** mehr Wasser!',
    ),
    CourseItem(
      prompt: 'Give me the book! (du, geben)',
      answer: '**Gib** mir das Buch!',
    ),
    CourseItem(
      prompt: 'Please wait here! (Sie, warten)',
      answer: '**Warten** Sie bitte hier!',
    ),
    CourseItem(prompt: 'Be nice! (ihr, sein)', answer: '**Seid** nett!'),
    CourseItem(
      prompt: 'Buy the tickets! (du, kaufen)',
      answer: '**Kauf** die Tickets!',
    ),
  ],
);

// 9.5 — big text with TYPED inputs: produce the modal / separable-verb form in
// a daily routine (base verb shown as the hint).
final QuizContent enDeM9BigText = enDeBigText(
  id: 'en_de_m9_bigtext',
  title: 'Big text: Mein Tag',
  passageTitle: 'Mein Tag',
  template:
      'Mein Montag ist immer randvoll! Um halb sieben klingelt der Wecker, und '
      'ich {{0}} sofort auf — na ja, fast sofort. Zuerst {{1}} ich unbedingt '
      'einen Kaffee trinken, sonst funktioniere ich einfach nicht. Auf dem Weg '
      'zur Arbeit {{2}} ich kurz meine Mutter an und frage, wie es ihr geht. '
      'Den ganzen Vormittag {{3}} ich am Computer arbeiten, das ist manchmal '
      'ganz schön anstrengend. Am Nachmittag {{4}} ich endlich Deutsch lernen — '
      'mein Lieblingsteil des Tages! Am Abend {{5}} wir alle zusammen fern und '
      'lachen über schlechte Serien. Um elf {{6}} ich todmüde ins Bett und '
      'schlafe sofort ein.',
  blanks: [
    inputBlank('stehe', hint: 'aufstehen → ich …'),
    inputBlank('will', hint: 'wollen → ich …'),
    inputBlank('rufe', hint: 'anrufen → ich …'),
    inputBlank('muss', hint: 'müssen → ich …'),
    inputBlank('kann', hint: 'können → ich …'),
    inputBlank('sehen', hint: 'fernsehen → wir …'),
    inputBlank('gehe', hint: 'gehen → ich …'),
  ],
  passageTranslation:
      "My Monday is always jam-packed! At half past six the alarm rings, and I "
      'get up immediately — well, almost immediately. First I really want to '
      "drink a coffee, otherwise I simply don't function. On the way to work I "
      'quickly call my mother and ask how she is. All morning I have to work at '
      'the computer, which is sometimes pretty exhausting. In the afternoon I '
      'can finally study German — my favourite part of the day! In the evening '
      'we all watch TV together and laugh about bad series. At eleven I go to '
      'bed dead tired and fall asleep at once.',
  intro:
      'Type the missing verb form. For separable verbs type only the '
      'conjugated part (the prefix auf/an/fern is already in the sentence); for '
      'modals type the modal.',
  tips: _modalTips,
);

final QuizContent enDeM9Speak = enDeSpeak(
  id: 'en_de_m9_speak',
  title: 'Speak: daily routine',
  intro:
      'Say your routine aloud with separable verbs. Keep the prefix at the '
      'end of the spoken sentence.',
  tips: _modalTips,
  items: const [
    CourseItem(
      prompt: 'I get up at seven.',
      answer: 'Ich stehe um sieben Uhr auf.',
    ),
    CourseItem(
      prompt: 'In the afternoon I go shopping.',
      answer: 'Am Nachmittag kaufe ich ein.',
    ),
    CourseItem(
      prompt: 'In the evening we watch TV.',
      answer: 'Am Abend sehen wir fern.',
    ),
    CourseItem(
      prompt: 'I call my friend.',
      answer: 'Ich rufe meinen Freund an.',
    ),
    CourseItem(
      prompt: 'The train departs at eight.',
      answer: 'Der Zug fährt um acht Uhr ab.',
    ),
  ],
);

final QuizContent enDeM9Dictation = enDeDict(
  id: 'en_de_m9_dictation',
  title: 'Dictation: catch the prefix',
  intro:
      'Listen and write the whole sentence — the separable prefix comes at '
      'the very end, so wait for it.',
  tips: _modalTips,
  items: const [
    CourseItem(
      prompt: 'I get up at seven.',
      answer: 'Ich stehe um sieben Uhr auf.',
    ),
    CourseItem(prompt: 'She goes shopping.', answer: 'Sie kauft ein.'),
    CourseItem(prompt: 'We watch TV.', answer: 'Wir sehen fern.'),
    CourseItem(
      prompt: 'He calls his mother.',
      answer: 'Er ruft seine Mutter an.',
    ),
    CourseItem(
      prompt: 'I tidy up the room.',
      answer: 'Ich räume das Zimmer auf.',
    ),
    CourseItem(
      prompt: 'The train departs at eight.',
      answer: 'Der Zug fährt um acht Uhr ab.',
    ),
    CourseItem(
      prompt: 'The film starts now.',
      answer: 'Der Film fängt jetzt an.',
    ),
    CourseItem(
      prompt: 'I can speak German.',
      answer: 'Ich kann Deutsch sprechen.',
    ),
    CourseItem(
      prompt: 'We must work today.',
      answer: 'Wir müssen heute arbeiten.',
    ),
    CourseItem(
      prompt: 'She wants to go to the cinema.',
      answer: 'Sie will ins Kino gehen.',
    ),
    CourseItem(
      prompt: 'I pick you up at six.',
      answer: 'Ich hole dich um sechs ab.',
    ),
    CourseItem(
      prompt: 'Please close the door.',
      answer: 'Mach bitte die Tür zu.',
    ),
    CourseItem(
      prompt: 'We go out tonight.',
      answer: 'Wir gehen heute Abend aus.',
    ),
    CourseItem(
      prompt: 'May I open the window?',
      answer: 'Darf ich das Fenster öffnen?',
    ),
    CourseItem(
      prompt: 'She invites her friends.',
      answer: 'Sie lädt ihre Freunde ein.',
    ),
  ],
);

/// M9 — Modal & Separable Verbs, in module order.

/// Speaking: run this conversation in your own AI assistant and bring the
/// score back (see `SpeakingQuizPage`).
final QuizContent enDeM9Speaking = enDeSpeaking(
  id: 'en_de_m9_speaking',
  title: 'Your day, your plans, your rules',
  level: 'A2',
  topic:
      'Mein Tag: what I have to do, what I want to do, what I am allowed to do, and how my day is organised.',
  practisePoints: [
    'Modal + infinitive at the end: Ich muss heute arbeiten.',
    'The modal forms: kann, muss, will, darf, soll, möchte',
    'Separable verbs split: Ich stehe um sieben auf.',
    'Separable verbs after a modal stay whole: Ich muss früh aufstehen.',
  ],
  targetVocabulary: [
    'müssen',
    'können',
    'dürfen',
    'aufstehen',
    'anfangen',
    'einkaufen',
  ],
  scoringCriteria: [
    'the modal form for the person',
    'the infinitive at the end',
    'the separable prefix at the end',
  ],
  priorityErrors: [
    'wrong modal form',
    'infinitive not at the end',
    'separable prefix in the wrong place',
  ],
  intro:
      'Talk through your day with an AI. Copy the exercise into your own assistant, turn on voice mode, and say what you must, can and want.',
  tips: _modalTips,
);

/// Mid-module speaking checkpoint: a shorter, question-driven run over
/// what the module has taught up to this point, before the second half
/// adds the rest. The closing exercise covers the module as a whole.
final QuizContent enDeM9SpeakingCheck = enDeSpeaking(
  id: 'en_de_m9_speaking_check',
  title: 'Checkpoint: what must you do today?',
  level: 'A2',
  topic: 'Quick questions about today: what I must, can and want to do.',
  practisePoints: [
    'Modal forms: kann, muss, will, darf',
    'The infinitive at the very end',
    'Answering with the modal, not just the verb',
  ],
  targetVocabulary: ['müssen', 'können', 'wollen', 'dürfen', 'heute'],
  scoringCriteria: [
    'the modal form for the person',
    'the infinitive at the end',
    'a complete modal sentence',
  ],
  priorityErrors: ['wrong modal form', 'infinitive not at the end'],
  mode: SpeakingMode.interview,
  session: SpeakingSession(durationMinutes: 3, minExchanges: 6),
  report: SpeakingReport(maxWords: 150, maxCorrections: 3),
  intro:
      'A short checkpoint on what this module has covered so far. Copy it into your AI assistant, turn on voice mode, and answer its questions - three minutes is enough.',
  tips: _modalTips,
);

final List<QuizContent> enDeM9 = [
  enDeM9ModalForms,
  enDeM9ModalOrder,
  enDeM9BigTextWarmup,
  enDeM9Separable,
  enDeM9SpeakingCheck,
  enDeM9Imperative,
  enDeM9Speak,
  enDeM9Dictation,
  enDeM9BigText,
  enDeM9Speaking,
];
