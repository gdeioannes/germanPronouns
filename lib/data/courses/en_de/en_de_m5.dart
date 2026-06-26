import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M5 — Putting the Cases Together (A2). The integration ladder: first find the
/// question (Wer/Wen/Wem), then name the case (Nom/Akk/Dat), then do both, then
/// produce the article, and finally read a connected "big text". The point: the
/// case comes from the job a word does in the sentence.

const List<HelpMemoryTip> _caseTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Three jobs, three questions',
    text: '**Wer?** → the doer → Nominativ. **Wen?/Was?** → the direct object → '
        'Akkusativ. **Wem?** → the receiver → Dativ.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Wer – Wen – Wem',
    text: 'The question word carries the case: We**r** (Nom), We**n** (Akk), '
        'We**m** (Dat) — same order as Nom → Akk → Dat.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'der masculine across the cases',
    text: '**der** Mann (Nom) → **den** Mann (Akk) → **dem** Mann (Dat). The '
        'masculine is where all three show up most clearly.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Same word, different job',
    text: '**der** Vater (Wer? → Nom) vs **der** Mutter (Wem? → Dat): identical '
        'word "der", opposite case. Read the job, not the word.',
  ),
];

// 5.1 — find the question word (Wer? / Wen? / Wem?) for each marked part.
final QuizContent enDeM5Questions = enDeBigText(
  id: 'en_de_m5_questions',
  title: 'Big text: which question? (Wer/Wen/Wem)',
  passageTitle: 'Im Klassenzimmer',
  template:
      'Es ist Montagmorgen, und im Klassenzimmer ist es laut. Der Lehrer {{0}} '
      'fragt den Schüler {{1}} in der letzten Reihe etwas. Aber der Schüler '
      '{{2}} träumt vom Wochenende und antwortet dem Lehrer {{3}} erst nach '
      'einer langen, peinlichen Pause. Die anderen Kinder lachen leise. Dann '
      'kommt die Lehrerin {{4}} herein und hilft dem Kind {{5}} in der ersten '
      'Reihe, das seine Brille verloren hat.',
  blanks: [
    caseBlank('Wer?', options: ['Wer?', 'Wen?', 'Wem?']), // Der Lehrer
    caseBlank('Wen?', options: ['Wer?', 'Wen?', 'Wem?']), // den Schüler
    caseBlank('Wer?', options: ['Wer?', 'Wen?', 'Wem?']), // Der Schüler
    caseBlank('Wem?', options: ['Wer?', 'Wen?', 'Wem?']), // dem Lehrer
    caseBlank('Wer?', options: ['Wer?', 'Wen?', 'Wem?']), // die Lehrerin
    caseBlank('Wem?', options: ['Wer?', 'Wen?', 'Wem?']), // dem Kind
  ],
  passageTranslation:
      "It's Monday morning, and the classroom is loud. The teacher asks the "
      'pupil in the back row something. But the pupil is daydreaming about the '
      'weekend and only answers the teacher after a long, awkward pause. The '
      'other children giggle quietly. Then the (female) teacher comes in and '
      'helps the child in the front row, who has lost their glasses.',
  intro: 'For each marked phrase, choose the question that finds it: Wer? (the '
      'doer), Wen? (the direct object), Wem? (the receiver).',
  tips: _caseTips,
);

// 5.2 — name the case directly.
final QuizContent enDeM5Cases = enDeBigText(
  id: 'en_de_m5_cases',
  title: 'Big text: which case? (Nom/Akk/Dat)',
  passageTitle: 'Das Eis',
  template:
      'Es ist ein heißer Sommertag. Die Mutter {{0}} geht mit ihrem Sohn in die '
      'Stadt und kauft dem Sohn {{1}} ein riesiges Eis {{2}} mit drei Kugeln. '
      'Der Sohn {{3}} strahlt über das ganze Gesicht und dankt der Mutter {{4}} '
      'bestimmt dreimal. Doch nach nur zwei Minuten fällt das Eis {{5}} klatsch '
      'auf den Boden — und der kleine Mann weint bitterlich.',
  blanks: [
    caseBlank('Nominativ'), // Die Mutter (doer)
    caseBlank('Dativ'), // dem Sohn (receiver)
    caseBlank('Akkusativ'), // ein Eis (object)
    caseBlank('Nominativ'), // Der Sohn (doer)
    caseBlank('Dativ'), // der Mutter (danken)
    caseBlank('Nominativ'), // Das Eis (subject of fallen)
  ],
  passageTranslation:
      "It's a hot summer day. The mother goes into town with her son and buys "
      'her son a huge ice cream with three scoops. The son beams all over his '
      'face and thanks his mother at least three times. But after only two '
      'minutes the ice cream falls splat on the ground — and the little man '
      'cries bitterly.',
  intro: 'Now name the case of each marked phrase: Nominativ (doer), Akkusativ '
      '(object) or Dativ (receiver). Note "Das Eis" in the last sentence is the '
      'subject — Nominativ.',
  tips: _caseTips,
);

// 5.3 — both at once.
final QuizContent enDeM5Both = enDeBigText(
  id: 'en_de_m5_both',
  title: 'Big text: question + case',
  passageTitle: 'Im Restaurant',
  template:
      'Am Abend ist das kleine Restaurant bis auf den letzten Platz voll. Der '
      'Kellner {{0}} bringt dem Gast {{1}} am Fenster die heiße Suppe {{2}} und '
      'wünscht einen guten Appetit. Der Gast {{3}} probiert vorsichtig, lächelt '
      'zufrieden und gibt dem Kellner {{4}} am Ende ein großzügiges Trinkgeld '
      '{{5}}. So macht die Arbeit sogar an einem langen Abend Spaß.',
  blanks: [
    caseBlank('Wer? · Nominativ', options: _wqCase), // Der Kellner
    caseBlank('Wem? · Dativ', options: _wqCase), // dem Gast
    caseBlank('Wen? · Akkusativ', options: _wqCase), // die Suppe
    caseBlank('Wer? · Nominativ', options: _wqCase), // Der Gast
    caseBlank('Wem? · Dativ', options: _wqCase), // dem Kellner
    caseBlank('Wen? · Akkusativ', options: _wqCase), // ein Trinkgeld
  ],
  passageTranslation:
      'In the evening the little restaurant is full to the last seat. The '
      'waiter brings the guest by the window the hot soup and wishes them a '
      'good appetite. The guest tries it carefully, smiles contentedly, and at '
      'the end gives the waiter a generous tip. That way the work is fun even '
      'on a long evening.',
  intro: 'Put it together: pick the question and the case for each marked '
      'phrase.',
  tips: _caseTips,
);

const List<String> _wqCase = [
  'Wer? · Nominativ',
  'Wen? · Akkusativ',
  'Wem? · Dativ',
];

// 5.4 — produce the article across all three cases.
final QuizContent enDeM5Produce = enDeFill(
  id: 'en_de_m5_produce',
  title: 'Produce the article (all cases)',
  intro: 'Now you supply the article. Work out the job first (doer / object / '
      'receiver), then choose der/die/das, den/die/das or dem/der/dem.',
  tips: _caseTips,
  items: const [
    CourseItem(prompt: 'The man is nice. (Nom, der Mann)', answer: '**Der** Mann ist nett'),
    CourseItem(prompt: 'I see the man. (Akk)', answer: 'Ich sehe **den** Mann'),
    CourseItem(prompt: 'I help the man. (Dat)', answer: 'Ich helfe **dem** Mann'),
    CourseItem(prompt: 'I see the woman. (Akk, die Frau)', answer: 'Ich sehe **die** Frau'),
    CourseItem(prompt: 'I give the woman the book. (Dat)', answer: 'Ich gebe **der** Frau das Buch'),
    CourseItem(prompt: 'The child plays. (Nom, das Kind)', answer: '**Das** Kind spielt'),
    CourseItem(prompt: 'I give the child a toy. (Dat)', answer: 'Ich gebe **dem** Kind ein Spielzeug'),
    CourseItem(prompt: 'I see the child. (Akk)', answer: 'Ich sehe **das** Kind'),
  ],
);

// 5.5 — the big text (from docs/en_de/m5_cases_text.md): mostly case selects,
// with one typed input — "der Vater" (Nom) vs "der Mutter" (Dat) is the punch
// line: same "der", different case.
final QuizContent enDeM5BigText = enDeBigText(
  id: 'en_de_m5_bigtext',
  title: 'Big text: Ein Montagmorgen',
  passageTitle: 'Ein Montagmorgen',
  template:
      'Es ist wieder Montagmorgen, und im Haus von Familie Becker geht alles '
      'drunter und drüber. Lukas {{0}} steht als Erster auf, noch halb im '
      'Schlaf. In der Küche macht er einen starken Kaffee {{1}} für das '
      'Frühstück. Seine Schwester Mia schläft noch tief, deshalb bringt Lukas '
      'ihr {{2}} den Kaffee direkt ans Bett. „Du bist der beste Bruder der '
      'Welt!", murmelt Mia {{3}} verschlafen. Nach dem Frühstück gibt Mia dem '
      'Hund {{4}} schnell sein Futter und vergisst dabei fast ihre Tasche. Der '
      'Hund {{5}} heißt Bello und wedelt vor Freude mit dem ganzen Körper. Am '
      'Abend, wenn alle müde nach Hause kommen, kocht der Vater {{6}} ein '
      'großes Essen und gibt {{7}} Mutter den ersten, vollen Teller.',
  blanks: [
    caseBlank('Nominativ'), // Lukas
    caseBlank('Akkusativ'), // einen Kaffee
    caseBlank('Dativ'), // ihr
    caseBlank('Nominativ'), // Mia
    caseBlank('Dativ'), // dem Hund
    caseBlank('Nominativ'), // Der Hund
    caseBlank('Nominativ'), // der Vater
    inputBlank('der'), // der Mutter (Dativ) — type the article
  ],
  passageTranslation:
      "It's Monday morning again, and in the Becker family's house everything "
      'is topsy-turvy. Lukas is the first one up, still half asleep. In the '
      'kitchen he makes a strong coffee for breakfast. His sister Mia is still '
      'fast asleep, so Lukas brings her the coffee right to her bed. "You\'re '
      'the best brother in the world!" Mia mumbles sleepily. After breakfast '
      'Mia quickly gives the dog its food and almost forgets her bag while '
      'doing so. The dog is called Bello and wags with his whole body for joy. '
      'In the evening, when everyone comes home tired, the father cooks a big '
      'dinner and gives the mother the first, full plate.',
  intro: 'Choose the case for each marked phrase — and for the last one, type '
      'the article. Watch the trick: "der Vater" (Wer? → Nominativ) vs "der '
      'Mutter" (Wem? → Dativ) — same word, different job.',
  tips: _caseTips,
);

final QuizContent enDeM5Dictation = enDeDict(
  id: 'en_de_m5_dictation',
  title: 'Dictation: mixed cases',
  intro: 'Listen and type each sentence. Every article ending counts — catch '
      'der/die/das, den, and dem.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Endings carry the case',
      text: 'den (Akk m) vs dem (Dat m/n) vs der (Nom m / Dat f) — the ending '
          'tells you the job. Listen carefully.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I give the man the book.', answer: 'Ich gebe dem Mann das Buch.'),
    CourseItem(prompt: 'The woman sees the child.', answer: 'Die Frau sieht das Kind.'),
    CourseItem(prompt: 'I help the friend.', answer: 'Ich helfe dem Freund.'),
    CourseItem(prompt: 'The dog belongs to the child.', answer: 'Der Hund gehört dem Kind.'),
    CourseItem(prompt: 'We buy the children an ice cream.', answer: 'Wir kaufen den Kindern ein Eis.'),
  ],
);

final QuizContent enDeM5Listening = enDeListen(
  id: 'en_de_m5_listening',
  title: 'Listening: who does what to whom?',
  passageTitle: 'Anna und ihr Bruder',
  passage:
      'Anna gibt ihrem Bruder ein Geschenk. Der Bruder dankt Anna und gibt ihr '
      'eine Karte. Dann hilft Anna der Mutter in der Küche.',
  passageTranslation:
      'Anna gives her brother a present. The brother thanks Anna and gives her '
      'a card. Then Anna helps the mother in the kitchen.',
  intro: 'Listen to the little story (you will not see the text) and answer. '
      'You have to track who is the doer, the object and the receiver.',
  tips: _caseTips,
  questions: const [
    ReadingQuestion(
      question: 'Wem gibt Anna ein Geschenk?',
      options: ['Dem Bruder', 'Der Mutter', 'Dem Vater'],
      correctIndex: 0,
      questionTranslation: 'To whom does Anna give a present?',
    ),
    ReadingQuestion(
      question: 'Wer dankt Anna?',
      options: ['Der Bruder', 'Die Mutter', 'Das Kind'],
      correctIndex: 0,
      questionTranslation: 'Who thanks Anna?',
    ),
    ReadingQuestion(
      question: 'Wem hilft Anna in der Küche?',
      options: ['Der Mutter', 'Dem Bruder', 'Dem Vater'],
      correctIndex: 0,
      questionTranslation: 'Whom does Anna help in the kitchen?',
    ),
  ],
);

/// M5 — Putting the Cases Together, in module order.
final List<QuizContent> enDeM5 = [
  enDeM5Questions,
  enDeM5Cases,
  enDeM5Both,
  enDeM5Produce,
  enDeM5BigText,
  enDeM5Dictation,
  enDeM5Listening,
];
