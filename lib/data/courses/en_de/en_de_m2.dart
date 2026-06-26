import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M2 — Gender & the Nominative (A1). Every German noun has a gender (der/die/
/// das); in the nominative (the subject) the articles are der/die/das and
/// ein/eine/ein. Theme: introducing "meine Familie".

const List<HelpMemoryTip> _genderTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Three genders, one habit',
    text: 'Every noun has a gender: **der** (m), **die** (f), **das** (n). '
        'Always learn the noun *with* its article — **der** Tisch, **die** '
        'Lampe, **das** Buch.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'Endings that betray the gender',
    text: '→ **die**: -ung, -heit, -keit, -schaft, -ion, and most -e words. '
        '→ **das**: -chen, -lein, -ment, -um. → **der**: -er (doer/tool), -ig, '
        '-ling, -or.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'ein / eine / kein',
    text: 'Nominative: **ein** (m/n), **eine** (f). Negate a noun with kein: '
        '**kein** Hund (m), **keine** Zeit (f), **kein** Auto (n), **keine** '
        'Kinder (pl).',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'der/die/das = er/sie/es',
    text: 'In the nominative the article echoes the pronoun: der → **er**, '
        'die → **sie**, das → **es**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Endings beat meaning',
    text: '**das** Mädchen and **das** Kind are neuter because of the noun '
        '(-chen, das Kind), not the person. Grammar wins over logic.',
  ),
];

final QuizContent enDeM2Articles = enDeFill(
  id: 'en_de_m2_articles',
  title: 'der / die / das',
  intro: 'Give each noun its gender. There is no fool-proof rule, so the goal '
      'is to learn the article as part of the word.',
  tips: _genderTips,
  items: const [
    CourseItem(prompt: 'the dog (m)', answer: '**der** Hund'),
    CourseItem(prompt: 'the cat (f)', answer: '**die** Katze'),
    CourseItem(prompt: 'the child (n)', answer: '**das** Kind'),
    CourseItem(prompt: 'the man', answer: '**der** Mann'),
    CourseItem(prompt: 'the woman', answer: '**die** Frau'),
    CourseItem(prompt: 'the house', answer: '**das** Haus'),
    CourseItem(prompt: 'the table', answer: '**der** Tisch'),
    CourseItem(prompt: 'the book', answer: '**das** Buch'),
  ],
);

final QuizContent enDeM2GenderEndings = enDeFill(
  id: 'en_de_m2_gender_endings',
  title: 'Gender by ending',
  intro: 'Some endings almost always fix the gender. Learn these patterns and '
      'you can guess the article for thousands of nouns.',
  tips: _genderTips,
  items: const [
    CourseItem(prompt: 'the newspaper (Zeitung → -ung)', answer: '**die** Zeitung'),
    CourseItem(prompt: 'the apartment (Wohnung → -ung)', answer: '**die** Wohnung'),
    CourseItem(prompt: 'the freedom (Freiheit → -heit)', answer: '**die** Freiheit'),
    CourseItem(prompt: 'the friendship (Freundschaft → -schaft)', answer: '**die** Freundschaft'),
    CourseItem(prompt: 'the girl (Mädchen → -chen)', answer: '**das** Mädchen'),
    CourseItem(prompt: 'the little house (Häuschen → -chen)', answer: '**das** Häuschen'),
    CourseItem(prompt: 'the teacher/m (Lehrer → -er)', answer: '**der** Lehrer'),
    CourseItem(prompt: 'the computer (-er)', answer: '**der** Computer'),
  ],
);

final QuizContent enDeM2Ein = enDeFill(
  id: 'en_de_m2_ein',
  title: 'ein / eine / kein',
  intro: 'The indefinite article in the nominative: ein (m/n), eine (f). "kein" '
      '(not a / no) takes the same endings, plus -e for feminine and plural.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Nominative ein-words',
      text: 'm: ein / kein · f: eine / keine · n: ein / kein · pl: — / keine.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'kein negates a noun',
      text: 'Use kein, not nicht, to negate a noun: Das ist kein Hund. Ich habe '
          'keine Zeit.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'That is a man.', answer: 'Das ist **ein** Mann'),
    CourseItem(prompt: 'That is a woman.', answer: 'Das ist **eine** Frau'),
    CourseItem(prompt: 'That is a house.', answer: 'Das ist **ein** Haus'),
    CourseItem(prompt: 'That is no dog. (m)', answer: 'Das ist **kein** Hund'),
    CourseItem(prompt: 'That is no good idea. (f)', answer: 'Das ist **keine** gute Idee'),
    CourseItem(prompt: 'That is no problem. (n)', answer: 'Das ist **kein** Problem'),
    CourseItem(prompt: 'Here is a child.', answer: 'Hier ist **ein** Kind'),
    CourseItem(prompt: 'There is a lamp. (f)', answer: 'Da ist **eine** Lampe'),
  ],
);

final QuizContent enDeM2Pronouns = enDeFill(
  id: 'en_de_m2_pronouns',
  title: 'Personal pronouns (nominative)',
  intro: 'The subject pronouns. German "sie" does triple duty — she, they, and '
      '(capitalised) the formal "you" — so context and the verb tell them '
      'apart.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The set',
      text: 'ich, du, er, sie, es, wir, ihr, sie, Sie.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Three "sie"',
      text: 'sie = she (sie ist), sie = they (sie sind), Sie = you formal '
          '(always capitalised).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I', answer: 'ich'),
    CourseItem(prompt: 'you (informal)', answer: 'du'),
    CourseItem(prompt: 'he', answer: 'er'),
    CourseItem(prompt: 'she', answer: 'sie'),
    CourseItem(prompt: 'it', answer: 'es'),
    CourseItem(prompt: 'we', answer: 'wir'),
    CourseItem(prompt: 'you (plural, informal)', answer: 'ihr'),
    CourseItem(prompt: 'they', answer: 'sie'),
    CourseItem(prompt: 'you (formal)', answer: 'Sie'),
  ],
);

// 2.3a — warm-up big text (after the two gender quizzes): pure der/die/das in
// context, before ein/kein and pronouns are added.
final QuizContent enDeM2BigTextWarmup = enDeBigText(
  id: 'en_de_m2_bigtext_warmup',
  title: 'Big text (warm-up): Mein Zimmer',
  passageTitle: 'Mein Zimmer',
  template:
      'Willkommen in meinem Chaos! {{0}} Tisch ist voll mit Büchern, und {{1}} '
      'Lampe daneben funktioniert schon lange nicht mehr. {{2}} Buch ganz oben '
      'lese ich gerade — es ist so spannend, dass ich nachts nicht schlafe! In '
      'der Ecke steht {{3}} Stuhl, aber dort sitzt nie ein Mensch, denn {{4}} '
      'Katze schläft den ganzen Tag darauf. {{5}} Fenster ist offen, {{6}} '
      'Computer brummt leise, und irgendwo piept {{7}} Handy. {{8}} Zimmer ist '
      'winzig und total unordentlich, aber ehrlich: Es ist mein kleines '
      'Königreich.',
  blanks: [
    inputBlank('Der', hint: 'der/die/das (Tisch)'),
    inputBlank('die', hint: 'der/die/das (Lampe)'),
    inputBlank('Das', hint: 'der/die/das (Buch)'),
    inputBlank('der', hint: 'der/die/das (Stuhl)'),
    inputBlank('die', hint: 'der/die/das (Katze)'),
    inputBlank('Das', hint: 'der/die/das (Fenster)'),
    inputBlank('der', hint: 'der/die/das (Computer)'),
    inputBlank('das', hint: 'der/die/das (Handy)'),
    inputBlank('Das', hint: 'der/die/das (Zimmer)'),
  ],
  passageTranslation:
      'Welcome to my chaos! The table is covered in books, and the lamp next to '
      'it stopped working ages ago. The book right on top is the one I am '
      'reading at the moment — it is so exciting that I cannot sleep at night! '
      'In the corner there is a chair, but nobody ever sits there, because the '
      'cat sleeps on it all day long. The window is open, the computer is '
      'humming quietly, and somewhere a phone is beeping. The room is tiny and '
      'a complete mess, but honestly: it is my little kingdom.',
  intro: 'Type the gender article (der/die/das) for each noun. Everything is a '
      'subject (nominative), so this is pure gender practice — say each noun '
      'with its article in your head before you type.',
  tips: _genderTips,
);

// 2.8 — mastery big text (module capstone): gender der/die/das plus the
// indefinite ein/eine and a nominative pronoun — the whole module in context.
final QuizContent enDeM2BigText = enDeBigText(
  id: 'en_de_m2_bigtext',
  title: 'Big text: Meine Familie',
  passageTitle: 'Meine Familie',
  template:
      'Das ist ein Foto von meiner verrückten Familie! {{0}} Mann ganz links '
      'ist mein Vater. Er ist Polizist und sehr streng, aber zu Hause kocht er '
      'am liebsten und singt dabei furchtbar laut. {{1}} Frau neben ihm ist '
      'meine Mutter. Sie ist Ärztin und meistens ruhig — nur wenn mein Vater '
      'singt, lacht sie und schüttelt den Kopf. {{2}} Mädchen mit der roten '
      'Brille bin ich. {{3}} Junge daneben ist mein kleiner Bruder; {{4}} Kind '
      'isst den ganzen Tag und träumt nur vom Fußball. Hinten seht ihr {{5}} '
      'Haus mit dem grünen Dach — dort wohnen wir alle zusammen. {{6}} Garten '
      'ist winzig, aber meine Mutter liebt ihn über alles. Und {{7}} Hund? '
      '{{8}} Hund heißt Bello, frisst heimlich die Hausschuhe und ist trotzdem '
      'der König der Familie. Habt ihr auch {{9}} Haustier? Wir haben übrigens '
      'noch {{10}} Katze, aber {{11}} mag den frechen Bello überhaupt nicht!',
  blanks: [
    inputBlank('Der', hint: 'der/die/das (Mann)'),
    inputBlank('Die', hint: 'der/die/das (Frau)'),
    inputBlank('Das', hint: 'der/die/das (Mädchen!)'),
    inputBlank('Der', hint: 'der/die/das (Junge)'),
    inputBlank('das', hint: 'der/die/das (Kind)'),
    inputBlank('das', hint: 'der/die/das (Haus)'),
    inputBlank('Der', hint: 'der/die/das (Garten)'),
    inputBlank('der', hint: 'der/die/das (Hund)'),
    inputBlank('Der', hint: 'der/die/das (Hund)'),
    inputBlank('ein', hint: 'ein/eine (Haustier, n)'),
    inputBlank('eine', hint: 'ein/eine (Katze, f)'),
    inputBlank('sie', hint: 'er/sie/es? (die Katze)'),
  ],
  passageTranslation:
      'This is a photo of my crazy family! The man on the far left is my '
      'father. He is a police officer and very strict, but at home he loves '
      'cooking most of all and sings terribly loudly while he does. The woman '
      'next to him is my mother. She is a doctor and usually calm — only when '
      'my father sings does she laugh and shake her head. The girl with the red '
      'glasses is me. The boy next to me is my little brother; the child eats '
      'all day and dreams only of football. At the back you can see the house '
      'with the green roof — that is where we all live together. The garden is '
      'tiny, but my mother loves it more than anything. And the dog? The dog is '
      'called Bello, secretly eats the slippers, and is still the king of the '
      'family. Do you have a pet too? By the way, we also have a cat, but she '
      "doesn't like cheeky Bello at all!",
  intro: 'Now the whole module in one text: type the gender article '
      '(der/die/das), the indefinite article (ein/eine), or the right pronoun. '
      'Everything is a subject (nominative) — and watch out for das Mädchen, '
      'neuter even though it means a girl!',
  tips: _genderTips,
);

final QuizContent enDeM2Speak = enDeSpeak(
  id: 'en_de_m2_speak',
  title: 'Speak: article + noun',
  intro: 'Say each noun together with its article — the best way to lock in the '
      'gender is to always hear and speak them as one unit.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Always pair them',
      text: 'Never learn "Hund" — learn "der Hund". The article is part of the '
          'word.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'the dog', answer: 'der Hund'),
    CourseItem(prompt: 'the cat', answer: 'die Katze'),
    CourseItem(prompt: 'the child', answer: 'das Kind'),
    CourseItem(prompt: 'the table', answer: 'der Tisch'),
    CourseItem(prompt: 'the lamp', answer: 'die Lampe'),
    CourseItem(prompt: 'the book', answer: 'das Buch'),
    CourseItem(prompt: 'the apple', answer: 'der Apfel'),
    CourseItem(prompt: 'the flower', answer: 'die Blume'),
  ],
);

final QuizContent enDeM2Dictation = enDeDict(
  id: 'en_de_m2_dictation',
  title: 'Dictation: article + noun',
  intro: 'Listen and write the article and the noun. The article you hear tells '
      'you the gender — including the tricky das Mädchen.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Hear the article',
      text: 'der / die / das sound different — let the article you hear decide '
          'the spelling and the gender.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'the dog', answer: 'der Hund'),
    CourseItem(prompt: 'the cat', answer: 'die Katze'),
    CourseItem(prompt: 'the girl', answer: 'das Mädchen'),
    CourseItem(prompt: 'the computer', answer: 'der Computer'),
    CourseItem(prompt: 'the newspaper', answer: 'die Zeitung'),
    CourseItem(prompt: 'the house', answer: 'das Haus'),
  ],
);

/// M2 — Gender & the Nominative, in module order.
final List<QuizContent> enDeM2 = [
  enDeM2Articles,
  enDeM2GenderEndings,
  enDeM2BigTextWarmup,
  enDeM2Ein,
  enDeM2Pronouns,
  enDeM2Speak,
  enDeM2Dictation,
  enDeM2BigText,
];
