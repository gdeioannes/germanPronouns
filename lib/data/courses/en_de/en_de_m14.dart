import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M14 — Relative Clauses (B1). The relative pronoun takes its gender/number
/// from the noun it describes, but its CASE from its job inside the clause.

const List<HelpMemoryTip> _relativeTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Gender from the noun, case from the job',
    text: 'The relative pronoun matches the noun\'s **gender/number**, but takes '
        'its **case** from what it does inside its own clause (subject → Nom, '
        'object → Akk, receiver → Dat).',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Same noun, three cases',
    text: 'Der Mann, **der** hier wohnt (Nom) · Der Mann, **den** ich sehe (Akk) '
        '· Der Mann, **dem** ich helfe (Dat).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Verb to the end + commas',
    text: 'A relative clause is subordinate: the verb goes to the **end**, and '
        'commas fence the clause — Das ist der Mann, der hier **wohnt**.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'They look like der/die/das',
    text: 'Relative pronouns *are* the articles — only the dative plural '
        '**denen** and the genitive **dessen/deren** look different.',
  ),
];

final QuizContent enDeM14Forms = enDeFill(
  id: 'en_de_m14_forms',
  title: 'Relative pronoun forms',
  intro: 'The full set. They match der/die/das almost everywhere — note denen '
      '(dative plural) and dessen/deren (genitive).',
  tips: _relativeTips,
  items: const [
    CourseItem(prompt: 'who/that (m, Nom)', answer: 'der'),
    CourseItem(prompt: 'who/that (f, Nom)', answer: 'die'),
    CourseItem(prompt: 'that (n, Nom)', answer: 'das'),
    CourseItem(prompt: 'whom (m, Akk)', answer: 'den'),
    CourseItem(prompt: 'to whom (m/n, Dat)', answer: 'dem'),
    CourseItem(prompt: 'to whom (f, Dat)', answer: 'der'),
    CourseItem(prompt: 'to whom (pl, Dat)', answer: 'denen'),
    CourseItem(prompt: 'whose (m/n, Gen)', answer: 'dessen'),
  ],
);

final QuizContent enDeM14Case = enDeFill(
  id: 'en_de_m14_case',
  title: 'Case from the verb',
  intro: 'Read the verb inside the clause to choose the case of the pronoun.',
  tips: _relativeTips,
  items: const [
    CourseItem(prompt: 'The man who lives here. (Nom)', answer: 'Der Mann, **der** hier wohnt'),
    CourseItem(prompt: 'The man whom I see. (Akk)', answer: 'Der Mann, **den** ich sehe'),
    CourseItem(prompt: 'The man whom I help. (Dat)', answer: 'Der Mann, **dem** ich helfe'),
    CourseItem(prompt: 'The woman who works here. (Nom)', answer: 'Die Frau, **die** hier arbeitet'),
    CourseItem(prompt: 'The book that I read. (Akk, n)', answer: 'Das Buch, **das** ich lese'),
    CourseItem(prompt: 'The children who play. (Nom, pl)', answer: 'Die Kinder, **die** spielen'),
  ],
);

// 14.2a — warm-up big text (after the form + case quizzes): type the relative
// pronoun. Gender from the noun, case from its job in the clause.
final QuizContent enDeM14BigTextWarmup = enDeBigText(
  id: 'en_de_m14_bigtext_warmup',
  title: 'Big text (warm-up): Meine Nachbarn',
  passageTitle: 'Meine Nachbarn',
  template:
      'In meinem Haus wohnen wirklich viele interessante Leute. Da ist die Frau, '
      '{{0}} jeden Morgen unter der Dusche laut singt. Daneben wohnt der Mann, '
      '{{1}} ich fast jeden Tag im Aufzug treffe. Im dritten Stock lebt das Kind, '
      '{{2}} so wunderschön Klavier spielt. Und nicht zu vergessen der alte Herr, '
      '{{3}} ich manchmal beim Einkaufen helfe. Ganz oben wohnen zwei Studenten, '
      '{{4}} leider jedes Wochenende laute Partys feiern. Langweilig ist es hier '
      'jedenfalls nie!',
  blanks: [
    inputBlank('die', hint: 'die Frau, … singt (Nom f)'),
    inputBlank('den', hint: 'der Mann, … ich treffe (Akk m)'),
    inputBlank('das', hint: 'das Kind, … spielt (Nom n)'),
    inputBlank('dem', hint: 'der Herr, … ich helfe (Dat m)'),
    inputBlank('die', hint: 'die Studenten, … feiern (Nom pl)'),
  ],
  passageTranslation:
      "Many interesting people really do live in my building. There's the woman "
      'who sings loudly in the shower every morning. Next door lives the man '
      'whom I meet in the lift almost every day. On the third floor lives the '
      'child who plays the piano so beautifully. And not to forget the old '
      'gentleman whom I sometimes help with the shopping. Right at the top live '
      'two students who unfortunately throw loud parties every weekend. It is '
      'certainly never boring here!',
  intro: 'Type the relative pronoun. It takes its gender/number from the noun, '
      'but its case from its job in the clause: subject → der/die/das, object → '
      'den, receiver → dem.',
  tips: _relativeTips,
);

final QuizContent enDeM14Preposition = enDeFill(
  id: 'en_de_m14_preposition',
  title: 'Preposition + relative pronoun',
  intro: 'When a preposition belongs to the clause, it stands before the '
      'pronoun and decides the case.',
  tips: _relativeTips,
  items: const [
    CourseItem(prompt: 'The house in which I live. (in + Dat)', answer: 'Das Haus, in **dem** ich wohne'),
    CourseItem(prompt: 'The woman with whom I speak. (mit + Dat)', answer: 'Die Frau, mit **der** ich spreche'),
    CourseItem(prompt: 'The friend for whom I cook. (für + Akk)', answer: 'Der Freund, für **den** ich koche'),
    CourseItem(prompt: 'The city in which she lives. (in + Dat)', answer: 'Die Stadt, in **der** sie wohnt'),
  ],
);

// 14.4 — big text: choose the CASE of each marked relative pronoun.
final QuizContent enDeM14BigText = enDeBigText(
  id: 'en_de_m14_bigtext',
  title: 'Big text: Mein Freund Max',
  passageTitle: 'Mein Freund Max',
  template:
      'Das ist mein bester Freund Max, der {{0}} seit drei Jahren in Berlin '
      'wohnt. Max ist ein echtes Original. Er hat eine ältere Schwester, die '
      '{{1}} Ärztin in einem großen Krankenhaus ist. Letztes Jahr hat er sich '
      'endlich das Auto gekauft, von dem er immer geträumt hat — das alte, rote '
      'Auto, das {{2}} er jetzt überall stolz herumfährt. Der nette Mann, dem '
      '{{3}} ich neulich am Bahnhof geholfen habe, war übrigens sein Vater; so '
      'klein ist die Welt! Und die ruhige Stadt am Meer, in der {{4}} die ganze '
      'Familie jeden Sommer Urlaub macht, möchte ich auch einmal besuchen.',
  blanks: [
    caseBlank('Nominativ'), // der (subject of wohnt)
    caseBlank('Nominativ'), // die (subject of ist)
    caseBlank('Akkusativ'), // das (object of herumfährt)
    caseBlank('Dativ'), // dem (helfen + Dat)
    caseBlank('Dativ'), // der (in + Dat)
  ],
  passageTranslation:
      'This is my best friend Max, who has lived in Berlin for three years. Max '
      'is a real character. He has an older sister, who is a doctor in a big '
      'hospital. Last year he finally bought the car he had always dreamed of — '
      'the old red car that he now proudly drives everywhere. The nice man whom '
      'I helped at the station the other day was, by the way, his father; it is '
      'a small world! And the quiet town by the sea, in which the whole family '
      'goes on holiday every summer, I would like to visit one day too.',
  intro: 'Choose the case of each marked relative pronoun. Look at its job in '
      'the clause: subject (Nom), object (Akk), receiver/after a dative prep '
      '(Dat).',
  tips: _relativeTips,
);

final QuizContent enDeM14Speak = enDeSpeak(
  id: 'en_de_m14_speak',
  title: 'Speak: definitions',
  intro: 'Define jobs with a relative clause: "… ist jemand, der …". Say each '
      'one aloud.',
  tips: _relativeTips,
  items: const [
    CourseItem(prompt: 'A doctor is someone who helps sick people.', answer: 'Ein Arzt ist jemand, der kranken Menschen hilft.'),
    CourseItem(prompt: 'A teacher is someone who teaches children.', answer: 'Ein Lehrer ist jemand, der Kinder unterrichtet.'),
    CourseItem(prompt: 'A cook is someone who makes food.', answer: 'Ein Koch ist jemand, der Essen macht.'),
    CourseItem(prompt: 'A pilot is someone who flies a plane.', answer: 'Ein Pilot ist jemand, der ein Flugzeug fliegt.'),
    CourseItem(prompt: 'A friend is someone you can trust.', answer: 'Ein Freund ist jemand, dem man vertrauen kann.'),
  ],
);

final QuizContent enDeM14Listening = enDeListen(
  id: 'en_de_m14_listening',
  title: 'Listening: Der Mann, der …',
  passageTitle: 'Herr Schmidt',
  passage:
      'Das ist Herr Schmidt. Der Mann, der das blaue Auto fährt, ist mein '
      'Nachbar. Er hat einen Hund, der sehr freundlich ist. Die Frau, die neben '
      'ihm wohnt, ist seine Schwester.',
  passageTranslation:
      'This is Mr Schmidt. The man who drives the blue car is my neighbour. He '
      'has a dog that is very friendly. The woman who lives next to him is his '
      'sister.',
  intro: 'Listen to the profile. Each relative clause adds a detail — track who '
      'is who.',
  tips: _relativeTips,
  questions: const [
    ReadingQuestion(
      question: 'Wer fährt das blaue Auto?',
      options: ['Herr Schmidt', 'Sein Hund', 'Seine Schwester'],
      correctIndex: 0,
      questionTranslation: 'Who drives the blue car?',
    ),
    ReadingQuestion(
      question: 'Wie ist der Hund?',
      options: ['Freundlich', 'Böse', 'Klein'],
      correctIndex: 0,
      questionTranslation: 'What is the dog like?',
    ),
    ReadingQuestion(
      question: 'Wer wohnt neben Herrn Schmidt?',
      options: ['Seine Schwester', 'Sein Bruder', 'Sein Vater'],
      correctIndex: 0,
      questionTranslation: 'Who lives next to Mr Schmidt?',
    ),
  ],
);

/// M14 — Relative Clauses, in module order.
final List<QuizContent> enDeM14 = [
  enDeM14Forms,
  enDeM14Case,
  enDeM14BigTextWarmup,
  enDeM14Preposition,
  enDeM14Speak,
  enDeM14Listening,
  enDeM14BigText,
];
