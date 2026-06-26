import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M9 — Modal & Separable Verbs (A2). Modals send the main verb to the end as
/// an infinitive; separable verbs split and send the prefix to the end. Theme:
/// "Mein Tag" — a daily routine.

const List<HelpMemoryTip> _modalTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The modal frame',
    text: 'The modal is conjugated in position 2; the main verb waits at the end '
        'as an **infinitive**: Ich **kann** Deutsch **sprechen**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Modals: no -t for er',
    text: 'The singular changes its vowel and ich = er: ich **kann**, du '
        '**kannst**, er **kann** · ich **muss**, er **muss** · ich **will**, er '
        '**will**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Separable verbs split',
    text: 'The prefix flies to the end: auf·stehen → Ich stehe um 7 **auf**. '
        'ein·kaufen → Ich kaufe **ein**. an·rufen → Ich rufe dich **an**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Imperative drops the pronoun',
    text: '**Komm!** · **Wartet!** · **Öffnen Sie!** (du usually drops -st: du '
        'kommst → **Komm!**, but: du gibst → **Gib!**).',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'The six modals',
    text: '**können, müssen, wollen, sollen, dürfen, mögen** — plus the polite '
        '**möchte** (would like).',
  ),
];

final QuizContent enDeM9ModalForms = enDeFill(
  id: 'en_de_m9_modal_forms',
  title: 'Modal verb forms',
  intro: 'The six modals: können, müssen, wollen, sollen, dürfen, mögen. They '
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
  ],
);

final QuizContent enDeM9ModalOrder = enDeFill(
  id: 'en_de_m9_modal_order',
  title: 'Modal + main verb at the end',
  intro: 'Put the main verb at the end as an infinitive. The modal sits in '
      'position 2 and does the conjugating.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'I can speak German. (sprechen)', answer: 'Ich kann Deutsch **sprechen**'),
    CourseItem(prompt: 'You must work today. (arbeiten)', answer: 'Du musst heute **arbeiten**'),
    CourseItem(prompt: 'We want to go to the cinema. (gehen)', answer: 'Wir wollen ins Kino **gehen**'),
    CourseItem(prompt: 'May I open the window? (öffnen)', answer: 'Darf ich das Fenster **öffnen**?'),
    CourseItem(prompt: "She can't come. (kommen)", answer: 'Sie kann nicht **kommen**'),
    CourseItem(prompt: 'You should sleep more. (schlafen)', answer: 'Du sollst mehr **schlafen**'),
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
  intro: 'Type the modal verb. Remember the frame: the modal sits in position 2 '
      'and the main verb waits at the very end as an infinitive — Am Wochenende '
      'kann ich endlich ausschlafen.',
  tips: _modalTips,
);

final QuizContent enDeM9Separable = enDeFill(
  id: 'en_de_m9_separable',
  title: 'Separable verbs',
  intro: 'In a main clause a separable verb splits: the conjugated part stays '
      'in position 2 and the prefix goes to the very end.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'I get up at 7. (aufstehen)', answer: 'Ich stehe um 7 Uhr **auf**'),
    CourseItem(prompt: 'She goes shopping. (einkaufen)', answer: 'Sie kauft **ein**'),
    CourseItem(prompt: 'We watch TV. (fernsehen)', answer: 'Wir sehen **fern**'),
    CourseItem(prompt: 'He calls his mother. (anrufen)', answer: 'Er ruft seine Mutter **an**'),
    CourseItem(prompt: 'The train departs. (abfahren)', answer: 'Der Zug fährt **ab**'),
    CourseItem(prompt: 'I tidy up the room. (aufräumen)', answer: 'Ich räume das Zimmer **auf**'),
  ],
);

final QuizContent enDeM9Imperative = enDeFill(
  id: 'en_de_m9_imperative',
  title: 'The imperative',
  intro: 'Commands drop the pronoun. The du-form usually drops the -st ending; '
      'the Sie-form keeps the verb + Sie.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'Come here! (du, kommen)', answer: '**Komm** her!'),
    CourseItem(prompt: 'Be quiet! (du, sein)', answer: '**Sei** leise!'),
    CourseItem(prompt: 'Help me, please! (du, helfen)', answer: '**Hilf** mir bitte!'),
    CourseItem(prompt: 'Open the window! (Sie, öffnen)', answer: '**Öffnen** Sie das Fenster!'),
    CourseItem(prompt: 'Wait! (ihr, warten)', answer: '**Wartet**!'),
    CourseItem(prompt: 'Get up! (du, aufstehen)', answer: '**Steh** auf!'),
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
  intro: 'Type the missing verb form. For separable verbs type only the '
      'conjugated part (the prefix auf/an/fern is already in the sentence); for '
      'modals type the modal.',
  tips: _modalTips,
);

final QuizContent enDeM9Speak = enDeSpeak(
  id: 'en_de_m9_speak',
  title: 'Speak: daily routine',
  intro: 'Say your routine aloud with separable verbs. Keep the prefix at the '
      'end of the spoken sentence.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'I get up at seven.', answer: 'Ich stehe um sieben Uhr auf.'),
    CourseItem(prompt: 'In the afternoon I go shopping.', answer: 'Am Nachmittag kaufe ich ein.'),
    CourseItem(prompt: 'In the evening we watch TV.', answer: 'Am Abend sehen wir fern.'),
    CourseItem(prompt: 'I call my friend.', answer: 'Ich rufe meinen Freund an.'),
    CourseItem(prompt: 'The train departs at eight.', answer: 'Der Zug fährt um acht Uhr ab.'),
  ],
);

final QuizContent enDeM9Dictation = enDeDict(
  id: 'en_de_m9_dictation',
  title: 'Dictation: catch the prefix',
  intro: 'Listen and write the whole sentence — the separable prefix comes at '
      'the very end, so wait for it.',
  tips: _modalTips,
  items: const [
    CourseItem(prompt: 'I get up at seven.', answer: 'Ich stehe um sieben Uhr auf.'),
    CourseItem(prompt: 'She goes shopping.', answer: 'Sie kauft ein.'),
    CourseItem(prompt: 'We watch TV.', answer: 'Wir sehen fern.'),
    CourseItem(prompt: 'He calls his mother.', answer: 'Er ruft seine Mutter an.'),
    CourseItem(prompt: 'I tidy up the room.', answer: 'Ich räume das Zimmer auf.'),
  ],
);

/// M9 — Modal & Separable Verbs, in module order.
final List<QuizContent> enDeM9 = [
  enDeM9ModalForms,
  enDeM9ModalOrder,
  enDeM9BigTextWarmup,
  enDeM9Separable,
  enDeM9Imperative,
  enDeM9Speak,
  enDeM9Dictation,
  enDeM9BigText,
];
