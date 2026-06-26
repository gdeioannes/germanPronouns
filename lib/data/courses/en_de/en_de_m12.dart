import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M12 — Full Adjective Declension (B1). All three patterns across all cases:
/// weak (after der-words), mixed (after ein-words), strong (no article). The
/// big text is a typed-input exercise.

const List<HelpMemoryTip> _declTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Three patterns',
    text: '**Weak** (after der/diese/jede): **-e** or **-en**. **Mixed** (after '
        'ein/kein/mein): the adjective shows the gender where ein can\'t. '
        '**Strong** (no article): the adjective takes the article\'s own ending.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Who shows the case?',
    text: 'If a der-/ein-word already marks the case, the adjective relaxes '
        '(**-e/-en**). If nothing marks it, the adjective must — **strong** '
        'endings (-er/-e/-es/-em/-en).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Dative & all plurals → -en',
    text: 'After a der-word, the whole dative and the entire plural is **-en**: '
        '**dem** alt**en** Mann, **den** nett**en** Leut**en**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The masculine trio',
    text: '**der** gut**e** Wein · **ein** gut**er** Wein · gut**er** Wein — '
        'watch the **-r** jump onto the adjective when the article disappears.',
  ),
];

final QuizContent enDeM12Weak = enDeFill(
  id: 'en_de_m12_weak',
  title: 'Weak (after der-words)',
  intro: 'After der/die/das the case is already shown, so the adjective is '
      'weak: -e in the nominative singular and accusative f/n, -en everywhere '
      'else.',
  tips: _declTips,
  items: const [
    CourseItem(prompt: 'the old man (Nom)', answer: 'der **alte** Mann'),
    CourseItem(prompt: 'the old man (Akk)', answer: 'den **alten** Mann'),
    CourseItem(prompt: 'with the old man (Dat)', answer: 'dem **alten** Mann'),
    CourseItem(prompt: 'the new lamp (Nom)', answer: 'die **neue** Lampe'),
    CourseItem(prompt: 'with the new lamp (Dat)', answer: 'der **neuen** Lampe'),
    CourseItem(prompt: 'the small child (Nom)', answer: 'das **kleine** Kind'),
    CourseItem(prompt: 'the nice people (Nom, pl)', answer: 'die **netten** Leute'),
    CourseItem(prompt: 'with the nice people (Dat, pl)', answer: 'den **netten** Leuten'),
  ],
);

final QuizContent enDeM12Mixed = enDeFill(
  id: 'en_de_m12_mixed',
  title: 'Mixed (after ein-words)',
  intro: 'After ein/kein/mein the adjective shows the gender in the three spots '
      'where ein has no ending: nominative m (-er) and nominative/accusative n '
      '(-es).',
  tips: _declTips,
  items: const [
    CourseItem(prompt: 'an old man (Nom)', answer: 'ein **alter** Mann'),
    CourseItem(prompt: 'an old man (Akk)', answer: 'einen **alten** Mann'),
    CourseItem(prompt: 'a new car (Nom)', answer: 'ein **neues** Auto'),
    CourseItem(prompt: 'a new car (Akk)', answer: 'ein **neues** Auto'),
    CourseItem(prompt: 'a nice woman (Nom)', answer: 'eine **nette** Frau'),
    CourseItem(prompt: 'with a nice woman (Dat)', answer: 'einer **netten** Frau'),
    CourseItem(prompt: 'my small dog (Nom)', answer: 'mein **kleiner** Hund'),
    CourseItem(prompt: 'with my small dog (Dat)', answer: 'meinem **kleinen** Hund'),
  ],
);

// 12.2a — warm-up big text (after the weak + mixed quizzes): type the adjective
// ending after der-words (weak) and ein-words (mixed), Nom/Akk.
final QuizContent enDeM12BigTextWarmup = enDeBigText(
  id: 'en_de_m12_bigtext_warmup',
  title: 'Big text (warm-up): Mein Freund Tom',
  passageTitle: 'Mein Freund Tom',
  template:
      'Das ist Tom, mein {{0}} Freund. Er hat einen {{1}} Hund und eine {{2}} '
      'Katze, die den ganzen Tag nur schläft. In seinem Zimmer steht der {{3}} '
      'Schreibtisch immer voller Bücher und leerer Kaffeetassen. Heute trägt Tom '
      'das {{4}} T-Shirt von seiner Lieblingsband und eine {{5}} Jacke. Ehrlich '
      'gesagt ist Tom ein {{6}} Mensch — ein bisschen chaotisch, aber immer für '
      'mich da.',
  blanks: [
    inputBlank('guter', hint: 'gut (mein … Freund, Nom m)'),
    inputBlank('kleinen', hint: 'klein (einen … Hund, Akk m)'),
    inputBlank('faule', hint: 'faul (eine … Katze, Akk f)'),
    inputBlank('alte', hint: 'alt (der … Schreibtisch, Nom m)'),
    inputBlank('rote', hint: 'rot (das … T-Shirt, Akk n)'),
    inputBlank('blaue', hint: 'blau (eine … Jacke, Akk f)'),
    inputBlank('netter', hint: 'nett (ein … Mensch, Nom m)'),
  ],
  passageTranslation:
      'This is Tom, my good friend. He has a small dog and a lazy cat that '
      'sleeps all day long. In his room the old desk is always full of books and '
      'empty coffee cups. Today Tom is wearing the red T-shirt of his favourite '
      'band and a blue jacket. Honestly, Tom is a nice person — a bit chaotic, '
      'but always there for me.',
  intro: 'Type the adjective with its ending. After der/die/das it is weak '
      '(-e/-en); after ein/mein it must show the gender (-er for Nom-m, -es for '
      'Nom/Akk-n). Use the hint in brackets.',
  tips: _declTips,
);

final QuizContent enDeM12Strong = enDeFill(
  id: 'en_de_m12_strong',
  title: 'Strong (no article)',
  intro: 'With no article, the adjective must carry the case ending itself — it '
      'takes (almost) the der/die/das endings.',
  tips: _declTips,
  items: const [
    CourseItem(prompt: 'hot coffee (Nom, m)', answer: '**heißer** Kaffee', accepted: ['heisser Kaffee']),
    CourseItem(prompt: 'cold water (Nom, n)', answer: '**kaltes** Wasser'),
    CourseItem(prompt: 'fresh milk (Akk, f)', answer: '**frische** Milch'),
    CourseItem(prompt: 'good wine (Akk, m)', answer: '**guten** Wein'),
    CourseItem(prompt: 'with cold water (Dat, n)', answer: '**kaltem** Wasser'),
    CourseItem(prompt: 'good friends (Nom, pl)', answer: '**gute** Freunde'),
    CourseItem(prompt: 'big houses (Akk, pl)', answer: '**große** Häuser', accepted: ['grosse Häuser']),
    CourseItem(prompt: 'fresh bread (Nom, n)', answer: '**frisches** Brot'),
  ],
);

final QuizContent enDeM12Mixed2 = enDeFill(
  id: 'en_de_m12_sentences',
  title: 'All three, mixed',
  intro: 'Now mixed across patterns and cases. Decide: der-word, ein-word, or '
      'no article? Then the case.',
  tips: _declTips,
  items: const [
    CourseItem(prompt: 'I drink hot coffee. (no article, Akk m)', answer: 'Ich trinke **heißen** Kaffee', accepted: ['Ich trinke heissen Kaffee']),
    CourseItem(prompt: 'I see the old man. (der, Akk)', answer: 'Ich sehe den **alten** Mann'),
    CourseItem(prompt: 'I help a nice woman. (ein, Dat)', answer: 'Ich helfe einer **netten** Frau'),
    CourseItem(prompt: 'She has a new car. (ein, Akk n)', answer: 'Sie hat ein **neues** Auto'),
    CourseItem(prompt: 'We live in a big house. (ein, Dat n)', answer: 'Wir wohnen in einem **großen** Haus', accepted: ['Wir wohnen in einem grossen Haus']),
    CourseItem(prompt: 'I like fresh bread. (no article, Akk n)', answer: 'Ich mag **frisches** Brot'),
  ],
);

// 12.5 — big text with TYPED inputs: a description packed with adjectives.
final QuizContent enDeM12BigText = enDeBigText(
  id: 'en_de_m12_bigtext',
  title: 'Big text: Auf dem Markt',
  passageTitle: 'Auf dem Markt',
  template:
      'Samstagmorgen auf dem Markt — mein Lieblingsort! Überall gibt es {{0}} '
      'Obst, frisches Gemüse und Brot, das noch warm ist. An einem Stand kaufe '
      'ich {{1}} Äpfel und ein Stück {{2}} Käse, der herrlich riecht. Neben mir '
      'steht eine {{3}} Frau mit einem {{4}} Hund, der jeden Kunden freundlich '
      'begrüßt. Sie trägt einen {{5}} Mantel und einen viel zu großen Hut. Zum '
      'Schluss setze ich mich mit einem {{6}} Kaffee in ein {{7}} Café an der '
      'Ecke und schaue dem bunten Treiben einfach nur zu. So schön kann ein '
      'Morgen sein!',
  blanks: [
    inputBlank('buntes', hint: 'bunt (… Obst, Akk n, no article)'),
    inputBlank('rote', hint: 'rot (… Äpfel, Akk pl, no article)'),
    inputBlank('gelben', hint: 'gelb (ein Stück … Käse, Akk m, no article)'),
    inputBlank('nette', hint: 'nett (eine … Frau, Nom f)'),
    inputBlank('kleinen', hint: 'klein (einem … Hund, Dat m)'),
    inputBlank('roten', hint: 'rot (einen … Mantel, Akk m)'),
    inputBlank('heißen', accepted: ['heissen'], hint: 'heiß (einem … Kaffee, Dat m)'),
    inputBlank('gemütliches', accepted: ['gemuetliches'], hint: 'gemütlich (in ein … Café, Akk n)'),
  ],
  passageTranslation:
      'Saturday morning at the market — my favourite place! Everywhere there is '
      "colourful fruit, fresh vegetables and bread that's still warm. At one "
      'stall I buy red apples and a piece of yellow cheese that smells '
      'wonderful. Next to me stands a nice woman with a small dog that greets '
      'every customer in a friendly way. She is wearing a red coat and a far '
      'too big hat. Finally I sit down with a hot coffee in a cosy café on the '
      'corner and just watch the colourful bustle. A morning can be so lovely!',
  intro: 'Type the full adjective with its ending. Work out the pattern (der-/'
      'ein-/no article) and the case from the hint in brackets.',
  tips: _declTips,
);

final QuizContent enDeM12Dictation = enDeDict(
  id: 'en_de_m12_dictation',
  title: 'Dictation: the endings',
  intro: 'Listen and write each phrase. The unstressed ending carries the whole '
      'grammar — catch it.',
  tips: _declTips,
  items: const [
    CourseItem(prompt: 'I see the old man.', answer: 'Ich sehe den alten Mann.'),
    CourseItem(prompt: 'with a small dog', answer: 'mit einem kleinen Hund'),
    CourseItem(prompt: 'I drink hot coffee.', answer: 'Ich trinke heißen Kaffee.'),
    CourseItem(prompt: 'a new car', answer: 'ein neues Auto'),
    CourseItem(prompt: 'good friends', answer: 'gute Freunde'),
  ],
);

final QuizContent enDeM12Speak = enDeSpeak(
  id: 'en_de_m12_speak',
  title: 'Speak: declined phrases',
  intro: 'Say each phrase aloud across the cases. Hearing der/ein/no-article in '
      'a row builds an instinct for the endings.',
  tips: _declTips,
  items: const [
    CourseItem(prompt: 'the old man', answer: 'der alte Mann'),
    CourseItem(prompt: 'I see the old man.', answer: 'Ich sehe den alten Mann.'),
    CourseItem(prompt: 'with the old man', answer: 'mit dem alten Mann'),
    CourseItem(prompt: 'a hot coffee', answer: 'ein heißer Kaffee'),
    CourseItem(prompt: 'I drink hot coffee.', answer: 'Ich trinke heißen Kaffee.'),
    CourseItem(prompt: 'cold water', answer: 'kaltes Wasser'),
  ],
);

/// M12 — Full Adjective Declension, in module order.
final List<QuizContent> enDeM12 = [
  enDeM12Weak,
  enDeM12Mixed,
  enDeM12BigTextWarmup,
  enDeM12Strong,
  enDeM12Mixed2,
  enDeM12Dictation,
  enDeM12Speak,
  enDeM12BigText,
];
