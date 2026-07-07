import '../../../models/quiz_content.dart';
import 'hanzi_data.dart';

export 'hanzi_data.dart';

/// The "Hanzi Writing · 汉字" course (English speakers writing Chinese
/// characters): the 1000 most common characters grouped into friendly themed
/// modules (see [hanziCategories]). Each module opens with a short **culture
/// reading** in English — a relaxing page about the theme and the stories
/// behind its characters — followed by [QuizKind.draw] quizzes of at most
/// [kHanziBatchSize] characters each.
const int kHanziBatchSize = 12;

/// Roman numerals for the part titles ("Everyday actions II") — friendlier
/// than rank numbers. Sized for the biggest theme (124 characters → 11 parts
/// at a batch of 12), with headroom.
const List<String> _roman = [
  'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII',
  'IX', 'X', 'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI',
];

/// Splits [all] into the fewest parts of ≤ [kHanziBatchSize], sized as evenly
/// as possible (so a 13-character theme becomes 7+6, never 12+1).
List<List<HanziEntry>> _splitBalanced(List<HanziEntry> all) {
  final parts = (all.length + kHanziBatchSize - 1) ~/ kHanziBatchSize;
  final base = all.length ~/ parts;
  var extra = all.length % parts;
  final out = <List<HanziEntry>>[];
  var i = 0;
  for (var p = 0; p < parts; p++) {
    final take = base + (extra-- > 0 ? 1 : 0);
    out.add(all.sublist(i, i + take));
    i += take;
  }
  return out;
}

/// One draw quiz for part [part] (1-based) of [category].
QuizContent _drawQuiz(
  HanziCategory category,
  int part,
  int partCount,
  List<HanziEntry> entries,
) {
  final id = 'en_zh_hanzi_${category.id}_$part';
  final preview = entries.take(3).map((e) => e.char).join(' ');
  final title = partCount == 1
      ? '${category.title} · $preview …'
      : '${category.title} ${_roman[part - 1]} · $preview …';
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.draw,
    storageKeyPrefix: '${id}_',
    promptLabel: 'Character',
    subjectsLabel: 'Characters',
    subjectColumnLabel: 'Hanzi',
    subjects: [
      for (final e in entries)
        QuizSubjectData(
          key: e.char,
          display: e.char,
          english: '${e.pinyin} · ${e.meaning}',
        ),
    ],
    categories: const [],
    sentences: const [],
    helpMemoryIntro:
        '${entries.length} characters from "${category.title}". Listen, then '
        'draw each one — trace the faint template first; switch to "From '
        'memory" when you are ready to write from sound alone.',
    helpMemoryTips: const [
      HelpMemoryTip(
        kind: 'rule',
        title: 'Stroke order matters',
        text: 'Top before bottom, left before right, horizontal before '
            'vertical crossing it. Following the order builds the muscle '
            'memory that makes characters stick.',
      ),
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Trace → recall',
        text: 'Trace each character a few times, then switch the card to '
            '"From memory" and draw it from the sound alone — the reveal '
            'shows the template under your strokes to compare.',
      ),
    ],
  );
}

/// One culture reading for [category]: a short, relaxing English passage about
/// the theme and the stories behind its characters, with a few easy questions.
QuizContent _cultureQuiz(
  HanziCategory category,
  ({String title, String passage, List<ReadingQuestion> questions}) r,
) {
  final id = 'en_zh_hanzi_${category.id}_culture';
  return QuizContent(
    id: id,
    title: 'Culture: ${r.title}',
    kind: QuizKind.reading,
    storageKeyPrefix: '${id}_',
    promptLabel: 'Question',
    subjectsLabel: 'Questions',
    subjectColumnLabel: 'Question',
    subjects: const [],
    categories: const [],
    sentences: const [],
    readingCategory: 'Culture',
    readingTitle: r.title,
    readingPassage: r.passage,
    readingQuestions: r.questions,
    helpMemoryIntro:
        'A short story about "${category.title}" — where these characters come '
        'from and the culture around them. Read it with a cup of tea; the '
        'questions are easy on purpose.',
    helpMemoryTips: const [
      HelpMemoryTip(
        kind: 'tip',
        title: 'Why the stories help',
        text: 'A character with a story sticks. When you draw 好 knowing it is '
            'a woman beside a child, you are not memorising strokes — you are '
            'retelling the story.',
      ),
    ],
  );
}

/// The per-category culture readings, keyed by [HanziCategory.id].
final Map<String,
        ({String title, String passage, List<ReadingQuestion> questions})>
    _cultureReadings = {
  'essentials': (
    title: 'The little words that run the language',
    passage:
        'Here is the friendliest secret in Chinese: there are no verb endings, '
        'no plurals and no past tense to memorise. Tiny characters do all that '
        'work instead. 的 links words together — it is the single most common '
        'character in the whole language. 了 signals that something has '
        'happened. And 吗, dropped at the end of any sentence, turns it into a '
        'question, like a spoken question mark. These "little words" are the '
        'mortar between the bricks: master this small crew and every sentence '
        'you ever read will feel half-familiar already.',
    questions: [
      ReadingQuestion(
        question: 'What is the most common character in Chinese?',
        options: ['的', '吗', '了'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What does 吗 do at the end of a sentence?',
        options: ['Makes it past tense', 'Turns it into a question', 'Makes it polite'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'How many verb endings does Chinese have?',
        options: ['Six', 'Dozens', 'None'],
        correctIndex: 2,
      ),
    ],
  ),
  'numbers_time': (
    title: 'Counting like a local',
    passage:
        'Chinese numbers are beautifully logical: eleven is simply "ten-one" '
        '(十一) and twenty is "two-ten" (二十) — once you know ten characters, '
        'you can count to 99. Numbers also carry luck. 八 (eight) sounds like '
        'the word for "getting rich", so phone numbers and licence plates full '
        'of eights sell for fortunes — the Beijing Olympics even opened at '
        '8:08 pm on 8/8/2008. 四 (four) sounds like "death", so many buildings '
        'quietly skip their fourth floor. And 年 (year) was once a monster: '
        'legend says the beast Nian raided villages every New Year until '
        'people discovered it feared the colour red and loud firecrackers.',
    questions: [
      ReadingQuestion(
        question: 'How do you say eleven in Chinese?',
        options: ['One-ten', 'Ten-one', 'Two-five-four'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'Why is eight considered lucky?',
        options: [
          'It sounds like "getting rich"',
          'It looks like a dragon',
          'It is the emperor\'s number',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'Why is everything red at New Year?',
        options: [
          'Red is the emperor\'s colour',
          'The monster Nian feared red',
          'It hides firecracker smoke',
        ],
        correctIndex: 1,
      ),
    ],
  ),
  'people': (
    title: 'A person, a family, a king',
    passage:
        '人 (person) is one of the oldest characters still in use: two simple '
        'strokes, a figure striding forward. Put a 女 (woman) next to a 子 '
        '(child) and you get 好 — "good": a three-thousand-year-old picture of '
        'what felt right to the people who invented writing. Family words are '
        'wonderfully precise: Chinese has separate characters for elder and '
        'younger sister, elder and younger brother — in a culture where age '
        'order matters, "sibling" was never precise enough. And 王 (king)? '
        'Three horizontal strokes — heaven, humanity and earth — joined by the '
        'one vertical line that connects all three. That was the job '
        'description.',
    questions: [
      ReadingQuestion(
        question: 'What two parts make up 好 (good)?',
        options: ['Sun and moon', 'Woman and child', 'Heaven and earth'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'Why are there separate words for elder and younger sister?',
        options: [
          'Age order matters in the family',
          'They sound better',
          'A printing accident',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What do the three strokes of 王 (king) represent?',
        options: [
          'Three palaces',
          'Heaven, humanity and earth',
          'Three dynasties',
        ],
        correctIndex: 1,
      ),
    ],
  ),
  'actions': (
    title: 'Verbs that never change',
    passage:
        'Every European language makes you conjugate: go, went, gone. Chinese '
        'verbs never change shape — 去 is "go", "went" and "going", and time '
        'words like "yesterday" or "tomorrow" carry the tense. What Chinese '
        'gives you instead of conjugation tables is picture logic. Look at the '
        'left side of action characters: 打 (hit), 拿 (hold), 推 (push) and 拉 '
        '(pull) all share 扌 — a squeezed-down drawing of a hand. Leg actions '
        'like 跑 (run), 跳 (jump) and 踢 (kick) share the foot radical 足. '
        'Spot the radical and you often know what a new character does before '
        'anyone tells you.',
    questions: [
      ReadingQuestion(
        question: 'How does 去 (go) change in the past tense?',
        options: ['It doesn\'t change', 'It doubles', 'It gains an ending'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What does the radical 扌 mean in 打, 拿 and 推?',
        options: ['Water', 'A hand', 'A knife'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What carries the tense in a Chinese sentence?',
        options: ['Verb endings', 'Time words', 'Word order alone'],
        correctIndex: 1,
      ),
    ],
  ),
  'mind': (
    title: 'The heart of every feeling',
    passage:
        '心 is a drawing of a heart, and it hides inside almost every feeling '
        'in the language — squeezed into the slim form 忄 in 怕 (fear) and 恨 '
        '(hate), or sitting underneath in 想 (to think): a tree, an eye, and a '
        'heart below — gazing into the distance, pondering. Even 懂 (to '
        'understand) keeps a heart on its left, because understanding was '
        'never considered a purely mental act. One famous modern controversy: '
        'when characters were simplified in the 1950s, 愛 (love) lost its '
        'heart — the simplified 爱 no longer contains 心, and calligraphers '
        'have been grumbling about "heartless love" ever since.',
    questions: [
      ReadingQuestion(
        question: 'What does 心 mean?',
        options: ['Head', 'Heart', 'Spirit'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What three parts build 想 (to think)?',
        options: [
          'Tree, eye and heart',
          'Sun, moon and star',
          'Hand, mouth and ear',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What did 爱 (love) lose when it was simplified?',
        options: ['Its sound', 'Its heart (心)', 'Its meaning'],
        correctIndex: 1,
      ),
    ],
  ),
  'qualities': (
    title: 'Painting with opposites',
    passage:
        'Describing words in Chinese love company. 大 (big) is a person with '
        'arms stretched as wide as they will go; 小 (small) is three shy '
        'little strokes. 明 (bright) puts the sun and the moon side by side — '
        'the two brightest things the ancients knew. The practical trick for '
        'learners: study these characters in opposite pairs, because Chinese '
        'glues them together into new words. 大小 ("big-small") means *size*, '
        '长短 ("long-short") means *length*, and 多少 ("many-few") is how you '
        'ask *how much?* Learn one, get its opposite free — and often a third '
        'word as a bonus.',
    questions: [
      ReadingQuestion(
        question: 'What is 大 (big) a picture of?',
        options: [
          'A mountain',
          'A person with arms stretched wide',
          'A big house',
        ],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What two things sit side by side in 明 (bright)?',
        options: ['Fire and water', 'Sun and moon', 'Two suns'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What does the pair 大小 ("big-small") mean?',
        options: ['Size', 'A family', 'Twins'],
        correctIndex: 0,
      ),
    ],
  ),
  'body': (
    title: 'The body, drawn from life',
    passage:
        'Body characters began as sketches. 口 is an open mouth. 目 is an eye '
        'turned upright — you can still see the pupil between the lines. 手 '
        'spreads the fingers of a hand. Here is a spotting trick: when 月 '
        'appears on the LEFT of a character, it usually is not the moon at all '
        'but the old "flesh" radical — that is why 脸 (face), 腿 (leg) and 胸 '
        '(chest) all carry it. And 气 — breath, air, energy — is one of the '
        'central ideas of traditional Chinese medicine: keeping your qi '
        'flowing is considered the very definition of health.',
    questions: [
      ReadingQuestion(
        question: 'What is 目 a picture of?',
        options: ['A window', 'An eye', 'A door'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What does 月 usually mean on the left of body characters?',
        options: ['Moon', 'Flesh', 'Month'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What is 气 in traditional Chinese medicine?',
        options: [
          'Breath and life energy',
          'A kind of tea',
          'A bone',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  'food': (
    title: 'Tea, rice and chopsticks',
    passage:
        'Say "tea" and you are speaking Chinese history. The character 茶 '
        'travelled the world along two routes: overland traders heard the '
        'northern pronunciation "cha" — so Russian, Hindi and Turkish say '
        'chai — while Dutch ships trading with Fujian heard the coastal "te", '
        'giving English *tea* and French *thé*. Your own language remembers '
        'which road the leaves took! At the table, 米 draws scattered grains '
        'of rice, 饭 (cooked rice) simply *is* the word for a meal, and 筷 '
        '(chopsticks) wears the bamboo radical ⺮ on top — because that is '
        'what the first pairs were made of.',
    questions: [
      ReadingQuestion(
        question: 'Why do some languages say "chai" and others "tea"?',
        options: [
          'They took different trade routes from China',
          'They are unrelated words',
          'A translation mistake',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What does 饭 (cooked rice) also mean?',
        options: ['A meal', 'A bowl', 'A kitchen'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'Why does 筷 (chopsticks) carry the bamboo radical?',
        options: [
          'Chopsticks were made of bamboo',
          'Bamboo means "two"',
          'It looks elegant',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  'animals': (
    title: 'The zodiac crew',
    passage:
        'Every animal in this module is famous: together they form the twelve '
        'signs of the Chinese zodiac — rat, ox, tiger, rabbit, dragon, snake, '
        'horse, sheep, monkey, rooster, dog and pig, each ruling one year in a '
        'twelve-year cycle. Ask someone their sign and you have politely asked '
        'their age. The characters themselves are old sketches: 马 still '
        'gallops with its mane flying. And 鱼 (fish) is the star of every New '
        'Year dinner thanks to a pun: it sounds exactly like 余, "surplus" — '
        'eating fish wishes everyone "abundance year after year".',
    questions: [
      ReadingQuestion(
        question: 'How many animals are in the Chinese zodiac?',
        options: ['Eight', 'Ten', 'Twelve'],
        correctIndex: 2,
      ),
      ReadingQuestion(
        question: 'What can you politely learn by asking someone\'s zodiac sign?',
        options: ['Their age', 'Their hometown', 'Their job'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'Why is fish served at New Year?',
        options: [
          'It sounds like the word for "surplus"',
          'Fish are cheap in winter',
          'The dragon demands it',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  'nature': (
    title: 'Mountains and water',
    passage:
        'Look at 山 and you see three peaks; look at 水 and you see a stream '
        'splashing between banks. These two characters matter so much that '
        'Chinese landscape painting is literally called 山水 — '
        '"mountain-water" art, where mist-wrapped peaks dwarf tiny human '
        'figures. Nature here comes in a famous set of five: 金木水火土 — '
        'metal, wood, water, fire and earth — the Five Elements used for '
        'centuries to explain everything from medicine to the calendar '
        '(Japanese still names its weekdays after them). And when the sun 日 '
        'and the moon 月 finally meet in one character, they make 明 — '
        'brightness itself.',
    questions: [
      ReadingQuestion(
        question: 'What does the art term 山水 literally mean?',
        options: ['Mountain-water', 'Sky-earth', 'Mist-forest'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'Which of these is one of the Five Elements?',
        options: ['Wind', 'Wood', 'Ice'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What are 日 and 月 pictures of?',
        options: [
          'The sun and the moon',
          'A door and a window',
          'Fire and water',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  'places': (
    title: 'The Middle Kingdom',
    passage:
        'China calls itself 中国 — the "Middle Kingdom", the land in the '
        'centre. The character 国 (country) is a border drawn around jade, the '
        'emperor\'s treasure. 家 (home) is stranger and sweeter: a pig under a '
        'roof — in ancient villages, a pig in the house meant wealth, food and '
        'a future, so "roof plus pig" simply meant home. Capitals follow a '
        'tidy logic: 北京 (Beijing) is the "northern capital", 南京 (Nanjing) '
        'the "southern capital" — and 东京, the "eastern capital", is how '
        'Chinese writes Tokyo. Once you can read two characters, half the map '
        'of Asia opens up.',
    questions: [
      ReadingQuestion(
        question: 'What does 中国 literally mean?',
        options: ['Great Empire', 'Middle Kingdom', 'Land of Silk'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What is under the roof in 家 (home)?',
        options: ['A child', 'A pig', 'A fire'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'What does 北京 (Beijing) mean?',
        options: ['Northern capital', 'Old city', 'River town'],
        correctIndex: 0,
      ),
    ],
  ),
  'home': (
    title: 'Electric brains and magic boxes',
    passage:
        'Modern Chinese never borrowed words like "computer" — it built them '
        'from old characters, and the results are delightful. 电 '
        '(electricity, originally lightning) plus 脑 (brain) gives 电脑: the '
        '"electric brain" on your desk. 电视 is "electric seeing" — '
        'television. A mobile phone is a 手机, a "hand machine". Even the '
        'humble 门 (door) is a drawing of a doorframe, and you can still see '
        'the two posts. The lesson for learners: every "new" word is a small '
        'riddle built from characters you already know — guessing them is '
        'half the fun.',
    questions: [
      ReadingQuestion(
        question: 'What does 电脑 (computer) literally mean?',
        options: ['Electric brain', 'Metal box', 'Fast writer'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What is a 手机 (mobile phone) literally?',
        options: ['A hand machine', 'A far voice', 'A small screen'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What is 门 a drawing of?',
        options: ['A doorframe', 'A ladder', 'A table'],
        correctIndex: 0,
      ),
    ],
  ),
  'school': (
    title: 'Brush, ink, paper, inkstone',
    passage:
        'For most of Chinese history, beautiful handwriting was not a hobby — '
        'it was THE art form, ranked above painting. A scholar\'s desk held '
        'the "Four Treasures of the Study": brush, ink, paper and inkstone. '
        'The character 书 means both "book" and "to write", and 文 covers '
        'writing, language and culture in a single character — telling you '
        'exactly how much writing mattered. For about 1,300 years, the '
        'imperial civil-service examination let anyone who could master the '
        'classics — and the brush — rise to govern the empire. That is why 考 '
        '(to take an exam) is one of the most emotionally loaded characters '
        'in the language to this day.',
    questions: [
      ReadingQuestion(
        question: 'What were the "Four Treasures of the Study"?',
        options: [
          'Brush, ink, paper and inkstone',
          'Gold, jade, silk and tea',
          'Bell, drum, flute and zither',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What two meanings does 书 carry?',
        options: [
          'Book and to write',
          'School and teacher',
          'Paper and pen',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What could the imperial examination win you?',
        options: [
          'A government career',
          'A free horse',
          'A year of rice',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  'state': (
    title: 'Dynasties and the state',
    passage:
        'Chinese history is counted not in centuries but in dynasties — 朝 — '
        'family lines of emperors: Tang poetry, Song painting, Ming vases. '
        'Each dynasty kept meticulous records, which is why China has one of '
        'the longest unbroken written histories on Earth (史 is the historian '
        'with a writing tablet in hand). A lovely folk story hides in 法 '
        '(law): it carries the water radical 氵on its left, and tradition '
        'says this is because the law, like water, should be perfectly level '
        '— the same for everyone. These are the characters of newspapers and '
        'speeches; learn them and headlines start to open up.',
    questions: [
      ReadingQuestion(
        question: 'How is Chinese history traditionally divided?',
        options: ['By dynasties', 'By wars', 'By centuries'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What radical does 法 (law) carry?',
        options: ['Fire', 'Water', 'Metal'],
        correctIndex: 1,
      ),
      ReadingQuestion(
        question: 'Why water, according to the folk story?',
        options: [
          'Law should be level — the same for everyone',
          'Courts were built by rivers',
          'Ink is made with water',
        ],
        correctIndex: 0,
      ),
    ],
  ),
  'world': (
    title: 'How Germany became "virtue country"',
    passage:
        'How do you write "Germany" in a language with no alphabet? You '
        'borrow characters for their SOUND — and, if you are polite, you pick '
        'flattering ones. So England became 英国, "hero country"; Germany '
        'became 德国, "virtue country"; America became 美国, "beautiful '
        'country"; and France 法国, "law country". The characters in this '
        'little module (克, 罗, 巴, 尼, 阿, 兰…) are the standard sound-'
        'bricks used to spell out foreign names — once you know them, you can '
        'sound out world capitals, footballers and film stars in any Chinese '
        'newspaper.',
    questions: [
      ReadingQuestion(
        question: 'What does 德国 (Germany) literally mean?',
        options: ['Virtue country', 'Iron country', 'East country'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'How are foreign names written in Chinese?',
        options: [
          'With characters borrowed for their sound',
          'In the Latin alphabet',
          'They are translated word by word',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What does 美国 (America) literally mean?',
        options: ['New country', 'Beautiful country', 'Far country'],
        correctIndex: 1,
      ),
    ],
  ),
  'society': (
    title: 'Big ideas from small parts',
    passage:
        'Welcome to the abstract tier — the characters of ideas, systems and '
        'arguments. Chinese builds its big ideas by pairing small concrete '
        'ones, often with a wink. A "thing" is 东西 — literally "east-west", '
        'perhaps everything you could buy at the eastern and western markets. '
        'A "contradiction" is 矛盾, "spear-shield", from the tale of a '
        'merchant who boasted his spear could pierce anything and his shield '
        'could stop anything — until someone asked what would happen if his '
        'spear struck his shield. If you can smile at that, you are already '
        'thinking in Chinese. Take these last characters slowly; every one of '
        'them unlocks dozens of grown-up words.',
    questions: [
      ReadingQuestion(
        question: 'What does 东西 ("east-west") mean in everyday Chinese?',
        options: ['A thing', 'A compass', 'A journey'],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'What two weapons build the word for "contradiction"?',
        options: [
          'Spear and shield',
          'Bow and arrow',
          'Sword and axe',
        ],
        correctIndex: 0,
      ),
      ReadingQuestion(
        question: 'Why did the merchant\'s boast fail?',
        options: [
          'His spear against his own shield was a contradiction',
          'His prices were too high',
          'His shield was stolen',
        ],
        correctIndex: 0,
      ),
    ],
  ),
};

/// The quizzes of one module: the culture reading first, then the draw parts.
List<QuizContent> _moduleQuizzes(HanziCategory c) {
  final parts = _splitBalanced(c.entries);
  return [
    if (_cultureReadings[c.id] != null)
      _cultureQuiz(c, _cultureReadings[c.id]!),
    for (final (i, part) in parts.indexed)
      _drawQuiz(c, i + 1, parts.length, part),
  ];
}

/// One course module per category, in course order.
final List<({HanziCategory category, List<QuizContent> quizzes})>
    enZhHanziModules = [
  for (final c in hanziCategories)
    (category: c, quizzes: _moduleQuizzes(c)),
];

/// Every quiz of the course, module by module.
final List<QuizContent> enZhHanziContent = [
  for (final m in enZhHanziModules) ...m.quizzes,
];
