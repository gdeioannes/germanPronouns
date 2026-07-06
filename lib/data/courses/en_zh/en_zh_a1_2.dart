import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// A1.2 — People & Things · 人与物 (HSK 1b). English → Mandarin.
///
/// Big rocks: 很 + adjective with NO 是 (Z10 — the copula cliff), possession
/// and modification with 的 (Z19), the measure word 个 with 有 (Z11/Z18), and
/// 这/那/哪 with 几 vs 多少.

final QuizContent enZhA12Hen = enZhFill(
  id: 'en_zh_a1_2_hen',
  title: 'Adjectives take 很, never 是',
  intro:
      'To say "she is tall", Chinese drops "is" and glues the adjective on '
      'with 很: 她很高. Adjectives behave like verbs — they need no copula.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '很 is the glue, not "very"',
      text: 'Plain 她很高 just means "she\'s tall" — this 很 is nearly empty. '
          'To actually stress it, use 真 (really) or 非常 (extremely).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 是 + adjective is the classic error (Z10)',
      text: '她是高 ✗ — 是 links nouns only. And a bare 她高 sounds like a '
          'comparison ("SHE\'s the tall one"). Default shape: subject + 很 + '
          'adjective.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'She is tall.', answer: '她**很**高。', accepted: ['hěn'], hint: 'tā hěn gāo'),
    CourseItem(prompt: 'I am busy.', answer: '我**很**忙。', accepted: ['hěn'], hint: 'wǒ hěn máng'),
    CourseItem(prompt: 'Chinese tea is good to drink. (tasty)', answer: '中国茶**很**好喝。', accepted: ['hěn'], hint: 'Zhōngguó chá hěn hǎohē'),
    CourseItem(prompt: 'He is happy.', answer: '他**很**高兴。', accepted: ['hěn'], hint: 'tā hěn gāoxìng'),
    CourseItem(prompt: 'My mum is well.', answer: '我妈妈**很**好。', accepted: ['hěn'], hint: 'wǒ māma hěn hǎo'),
    CourseItem(prompt: 'This book is big.', answer: '这本书**很**大。', accepted: ['hěn'], hint: 'zhè běn shū hěn dà'),
    CourseItem(prompt: 'I am not tired. (不 replaces 很)', answer: '我**不**累。', accepted: ['bù'], hint: 'wǒ bú lèi'),
    CourseItem(prompt: 'The tea is hot.', answer: '茶**很**热。', accepted: ['hěn'], hint: 'chá hěn rè'),
    CourseItem(prompt: 'My older sister is pretty.', answer: '我姐姐**很**好看。', accepted: ['hěn'], hint: 'wǒ jiějie hěn hǎokàn'),
    CourseItem(prompt: 'We are tired.', answer: '我们**很**累。', accepted: ['hěn'], hint: 'wǒmen hěn lèi'),
    CourseItem(prompt: 'Is your dad busy? (question keeps 很 out — bare adjective + 吗)', answer: '你爸爸**忙**吗？', accepted: ['máng'], hint: 'nǐ bàba máng ma'),
    CourseItem(prompt: 'This cup of tea is REALLY tasty. (stress with 真)', answer: '这杯茶**真**好喝。', accepted: ['zhēn'], hint: 'zhè bēi chá zhēn hǎohē'),
    CourseItem(prompt: 'Chinese is not difficult. (不 replaces 很)', answer: '中文**不**难。', accepted: ['bù'], hint: 'Zhōngwén bù nán'),
    CourseItem(prompt: 'My home is EXTREMELY far. (stress with 非常)', answer: '我家**非常**远。', accepted: ['fēicháng'], hint: 'wǒ jiā fēicháng yuǎn'),
    CourseItem(prompt: 'Her younger brother is short. (opposite of 高)', answer: '她弟弟**很**矮。', accepted: ['hěn'], hint: 'tā dìdi hěn ǎi'),
  ],
);

final QuizContent enZhA12Family = enZhFill(
  id: 'en_zh_a1_2_family',
  title: 'Family words',
  intro:
      'Chinese family words are precise: older and younger siblings get '
      'different words. The doubled syllables (妈妈, 爸爸) are easy to say and '
      'hear.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Older/younger is built in',
      text: '哥哥 older brother vs 弟弟 younger brother; 姐姐 older sister vs '
          '妹妹 younger sister. There is no plain word for just "brother".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The neutral second syllable',
      text: 'In 妈妈, 爸爸, 哥哥… the second syllable relaxes to a neutral '
          'tone: māma, bàba, gēge.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'mum', answer: '妈妈', accepted: ['māma'], hint: 'māma'),
    CourseItem(prompt: 'dad', answer: '爸爸', accepted: ['bàba'], hint: 'bàba'),
    CourseItem(prompt: 'older brother', answer: '哥哥', accepted: ['gēge'], hint: 'gēge'),
    CourseItem(prompt: 'younger brother', answer: '弟弟', accepted: ['dìdi'], hint: 'dìdi'),
    CourseItem(prompt: 'older sister', answer: '姐姐', accepted: ['jiějie'], hint: 'jiějie'),
    CourseItem(prompt: 'younger sister', answer: '妹妹', accepted: ['mèimei'], hint: 'mèimei'),
    CourseItem(prompt: 'family / home', answer: '家', accepted: ['jiā'], hint: 'jiā'),
    CourseItem(prompt: 'grandpa (father\'s side)', answer: '爷爷', accepted: ['yéye'], hint: 'yéye'),
    CourseItem(prompt: 'grandma (father\'s side)', answer: '奶奶', accepted: ['nǎinai'], hint: 'nǎinai'),
    CourseItem(prompt: 'son', answer: '儿子', accepted: ['érzi'], hint: 'érzi'),
    CourseItem(prompt: 'daughter', answer: '女儿', accepted: ['nǚ\'ér', 'nü\'er', 'nu er', 'nǚ ér'], hint: 'nǚ\'ér'),
    CourseItem(prompt: 'grandpa (mother\'s side)', answer: '外公', accepted: ['wàigōng'], hint: 'wàigōng'),
    CourseItem(prompt: 'grandma (mother\'s side)', answer: '外婆', accepted: ['wàipó'], hint: 'wàipó'),
    CourseItem(prompt: 'parents (both at once)', answer: '父母', accepted: ['fùmǔ'], hint: 'fùmǔ'),
    CourseItem(prompt: 'child / kid', answer: '孩子', accepted: ['háizi'], hint: 'háizi'),
  ],
);

final QuizContent enZhA12De = enZhFill(
  id: 'en_zh_a1_2_de',
  title: 'Possession with 的',
  intro:
      '的 de is the possessive clip: 我的书 = my book, 老师的茶 = the '
      'teacher\'s tea. Close relationships and family often drop it: 我妈妈.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Owner + 的 + thing (Z19)',
      text: 'Whatever describes a noun comes BEFORE it, clipped on with 的. '
          'This little word later carries whole relative clauses — the habit '
          'starts here.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Family drops 的',
      text: '我妈妈 (my mum), 我家 (my home), 我朋友 (my friend) — with close '
          'people the 的 usually disappears.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'my book', answer: '我**的**书', accepted: ['de'], hint: 'wǒ de shū'),
    CourseItem(prompt: 'your tea', answer: '你**的**茶', accepted: ['de'], hint: 'nǐ de chá'),
    CourseItem(prompt: 'the teacher\'s name', answer: '老师**的**名字', accepted: ['de'], hint: 'lǎoshī de míngzi'),
    CourseItem(prompt: 'his phone', answer: '他**的**手机', accepted: ['de'], hint: 'tā de shǒujī'),
    CourseItem(prompt: 'Whose book is this?', answer: '这是**谁的**书？', accepted: ['shéi de', 'shuí de'], hint: 'zhè shì shéi de shū'),
    CourseItem(prompt: 'This is my friend\'s cat.', answer: '这是我朋友**的**猫。', accepted: ['de'], hint: 'zhè shì wǒ péngyou de māo'),
    CourseItem(prompt: 'her cat', answer: '她**的**猫', accepted: ['de'], hint: 'tā de māo'),
    CourseItem(prompt: 'my dad\'s computer', answer: '我爸爸**的**电脑', accepted: ['de'], hint: 'wǒ bàba de diànnǎo'),
    CourseItem(prompt: 'Whose phone is that?', answer: '那是**谁的**手机？', accepted: ['shéi de', 'shuí de'], hint: 'nà shì shéi de shǒujī'),
    CourseItem(prompt: 'the teacher\'s book', answer: '老师**的**书', accepted: ['de'], hint: 'lǎoshī de shū'),
    CourseItem(prompt: 'That car is my older sister\'s. (的 with nothing after it)', answer: '那辆车是我姐姐**的**。', accepted: ['de'], hint: 'nà liàng chē shì wǒ jiějie de'),
    CourseItem(prompt: 'my mum\'s tea', answer: '我妈妈**的**茶', accepted: ['de'], hint: 'wǒ māma de chá'),
    CourseItem(prompt: 'Is this your teacher\'s computer?', answer: '这是你老师**的**电脑吗？', accepted: ['de'], hint: 'zhè shì nǐ lǎoshī de diànnǎo ma'),
    CourseItem(prompt: 'This book is not mine. (mine = 我的)', answer: '这本书不是**我的**。', accepted: ['wǒ de', 'wode'], hint: 'zhè běn shū bú shì wǒ de'),
    CourseItem(prompt: 'my friend\'s younger sister', answer: '我朋友**的**妹妹', accepted: ['de'], hint: 'wǒ péngyou de mèimei'),
  ],
);

final QuizContent enZhA12SpeakFamily = enZhSpeak(
  id: 'en_zh_a1_2_speak_family',
  title: 'Speaking: my family',
  intro: 'Talk about your family — listen and repeat, watching the tones.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'One breath per sentence',
      text: 'These sentences are short on purpose: say each in one relaxed '
          'breath, keeping every syllable\'s tone — speed comes later.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wǒ jiā yǒu sì kǒu rén. — There are four of us in my family.', answer: '我家有四口人。'),
    CourseItem(prompt: 'Zhè shì wǒ bàba. — This is my dad.', answer: '这是我爸爸。'),
    CourseItem(prompt: 'Wǒ māma shì lǎoshī. — My mum is a teacher.', answer: '我妈妈是老师。'),
    CourseItem(prompt: 'Wǒ yǒu yí ge gēge. — I have an older brother.', answer: '我有一个哥哥。'),
    CourseItem(prompt: 'Wǒ méiyǒu mèimei. — I don\'t have a younger sister.', answer: '我没有妹妹。'),
    CourseItem(prompt: 'Wǒmen jiā yǒu yì zhī māo. — Our family has a cat.', answer: '我们家有一只猫。'),
  ],
);

final QuizContent enZhA12YouGe = enZhFill(
  id: 'en_zh_a1_2_you_ge',
  title: '有 + the measure word 个',
  intro:
      '有 yǒu = to have / there is. And counting anything needs a measure '
      'word between the number and the noun: 一**个**人, never 一人.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Every noun brings its suitcase (Z11)',
      text: 'Number (or 这/那) + MEASURE WORD + noun, always. 个 gè is the '
          'all-purpose suitcase — when in doubt, 个. English already does '
          'this with "a CUP of tea, a PAIR of trousers".',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '有 negates with 没 (Z18)',
      text: '我有猫 I have a cat → 我**没**有猫 I don\'t. Never 不有 — 有 is '
          'the one verb that refuses 不.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I have an older brother.', answer: '我有一**个**哥哥。', accepted: ['gè', 'ge'], hint: 'wǒ yǒu yí ge gēge'),
    CourseItem(prompt: 'She has three books. (bound things: 本)', answer: '她有三**本**书。', accepted: ['běn'], hint: 'tā yǒu sān běn shū'),
    CourseItem(prompt: 'We have a cat. (animals: 只)', answer: '我们有一**只**猫。', accepted: ['zhī'], hint: 'wǒmen yǒu yì zhī māo'),
    CourseItem(prompt: 'Do you have a phone?', answer: '你**有**手机吗？', accepted: ['yǒu'], hint: 'nǐ yǒu shǒujī ma'),
    CourseItem(prompt: 'I do NOT have a younger sister.', answer: '我**没有**妹妹。', accepted: ['méiyǒu', 'méi yǒu'], hint: 'wǒ méiyǒu mèimei'),
    CourseItem(prompt: 'There are four people in my family. (家 + 有)', answer: '我家**有**四口人。', accepted: ['yǒu'], hint: 'wǒ jiā yǒu sì kǒu rén'),
    CourseItem(prompt: 'He has two younger sisters.', answer: '他有两**个**妹妹。', accepted: ['gè', 'ge'], hint: 'tā yǒu liǎng ge mèimei'),
    CourseItem(prompt: 'I have two books.', answer: '我有两**本**书。', accepted: ['běn'], hint: 'wǒ yǒu liǎng běn shū'),
    CourseItem(prompt: 'They have a dog. (animals: 只)', answer: '他们有一**只**狗。', accepted: ['zhī'], hint: 'tāmen yǒu yì zhī gǒu'),
    CourseItem(prompt: 'She does NOT have a phone.', answer: '她**没有**手机。', accepted: ['méiyǒu', 'méi yǒu'], hint: 'tā méiyǒu shǒujī'),
    CourseItem(prompt: 'Do you have younger siblings? (verb-not-verb question)', answer: '你**有没有**弟弟妹妹？', accepted: ['yǒu méiyǒu', 'you mei you'], hint: 'nǐ yǒu méiyǒu dìdi mèimei'),
    CourseItem(prompt: 'There is a cat at home. (place + 有 = there is)', answer: '家里**有**一只猫。', accepted: ['yǒu'], hint: 'jiā li yǒu yì zhī māo'),
    CourseItem(prompt: 'I have five cups. (cups as objects: 个)', answer: '我有五**个**杯子。', accepted: ['gè', 'ge'], hint: 'wǒ yǒu wǔ ge bēizi'),
    CourseItem(prompt: 'My teacher has a car. (vehicles: 辆)', answer: '我的老师有一**辆**车。', accepted: ['liàng'], hint: 'wǒ de lǎoshī yǒu yí liàng chē'),
    CourseItem(prompt: 'How many people does the school have? (school = 学校)', answer: '学校**有**多少人？', accepted: ['yǒu'], hint: 'xuéxiào yǒu duōshao rén'),
  ],
);

final QuizContent enZhA12ThisThat = enZhFill(
  id: 'en_zh_a1_2_this_that',
  title: '这 / 那 / 哪',
  intro:
      '这 zhè = this (near), 那 nà = that (far), 哪 nǎ = which (the question '
      'twin). Pointing at things needs the measure word too: 这个, 那本.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'nà = that, nǎ = which?',
      text: 'Same character family, different tone: falling 那 points (that), '
          'dipping 哪 asks (which?). The tone IS the grammar here.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '这/那 + MW + noun',
      text: 'Pointing at a specific thing takes the measure word: 这个人 this '
          'person, 那本书 that book — same suitcase rule as numbers (Z11).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'This is my teacher.', answer: '**这**是我的老师。', accepted: ['zhè'], hint: 'zhè shì wǒ de lǎoshī'),
    CourseItem(prompt: 'That is his book.', answer: '**那**是他的书。', accepted: ['nà'], hint: 'nà shì tā de shū'),
    CourseItem(prompt: 'this person', answer: '这**个**人', accepted: ['gè', 'ge'], hint: 'zhè ge rén'),
    CourseItem(prompt: 'that book', answer: '那**本**书', accepted: ['běn'], hint: 'nà běn shū'),
    CourseItem(prompt: 'Which country are you from? (which-country person)', answer: '你是**哪**国人？', accepted: ['nǎ'], hint: 'nǐ shì nǎ guó rén'),
    CourseItem(prompt: 'Which cup is yours? (cup/glass: 杯)', answer: '**哪**杯是你的？', accepted: ['nǎ'], hint: 'nǎ bēi shì nǐ de'),
    CourseItem(prompt: 'Which person is your teacher?', answer: '**哪**个人是你的老师？', accepted: ['nǎ'], hint: 'nǎ ge rén shì nǐ de lǎoshī'),
    CourseItem(prompt: 'This cup of tea is mine.', answer: '这**杯**茶是我的。', accepted: ['bēi'], hint: 'zhè bēi chá shì wǒ de'),
    CourseItem(prompt: 'That person is my dad.', answer: '**那**个人是我爸爸。', accepted: ['nà'], hint: 'nà ge rén shì wǒ bàba'),
    CourseItem(prompt: 'this cat (animals: 只)', answer: '这**只**猫', accepted: ['zhī'], hint: 'zhè zhī māo'),
    CourseItem(prompt: 'Which book is the teacher\'s?', answer: '**哪**本书是老师的？', accepted: ['nǎ'], hint: 'nǎ běn shū shì lǎoshī de'),
    CourseItem(prompt: 'That computer is not mine.', answer: '**那**个电脑不是我的。', accepted: ['nà'], hint: 'nà ge diànnǎo bú shì wǒ de'),
    CourseItem(prompt: 'Is this cup of tea yours?', answer: '**这**杯茶是你的吗？', accepted: ['zhè'], hint: 'zhè bēi chá shì nǐ de ma'),
    CourseItem(prompt: 'Which car is your dad\'s? (vehicles: 辆)', answer: '哪**辆**车是你爸爸的？', accepted: ['liàng'], hint: 'nǎ liàng chē shì nǐ bàba de'),
    CourseItem(prompt: 'That dog is very small.', answer: '**那**只狗很小。', accepted: ['nà'], hint: 'nà zhī gǒu hěn xiǎo'),
  ],
);

final QuizContent enZhA12ListenFamily = enZhListen(
  id: 'en_zh_a1_2_listen_family',
  title: 'Listening: 我的家',
  passageTitle: '小美的家',
  passage:
      '我家有五口人：爸爸、妈妈、哥哥、妹妹和我。我爸爸是医生，我妈妈是老师。'
      '我哥哥很高，我妹妹很小。我们家有一只猫，它叫花花。我很爱我的家。',
  passageTranslation:
      'Wǒ jiā yǒu wǔ kǒu rén: bàba, māma, gēge, mèimei hé wǒ. Wǒ bàba shì '
      'yīshēng, wǒ māma shì lǎoshī. Wǒ gēge hěn gāo, wǒ mèimei hěn xiǎo. Wǒmen '
      'jiā yǒu yì zhī māo, tā jiào Huāhua. Wǒ hěn ài wǒ de jiā.\n\n'
      'There are five people in my family: dad, mum, my older brother, my '
      'younger sister and me. My dad is a doctor, my mum is a teacher. My '
      'brother is tall; my little sister is small. Our family has a cat called '
      'Huahua. I love my family very much.',
  intro:
      'Listen to Xiaomei describe her family. Catch the counting word 口 and '
      'who does what.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '口 counts family members',
      text: 'Family size uses the measure word 口 (mouth): 五口人 = five '
          'mouths to feed. Anywhere else, people take 个.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '小美家有几口人？',
      options: ['四口人', '五口人', '三口人'],
      correctIndex: 1,
      questionTranslation: 'How many people are in Xiaomei\'s family?',
    ),
    ReadingQuestion(
      question: '她妈妈是做什么的？',
      options: ['医生', '老师', '学生'],
      correctIndex: 1,
      questionTranslation: 'What does her mum do?',
    ),
    ReadingQuestion(
      question: '他们家的猫叫什么？',
      options: ['花花', '小美', '毛毛'],
      correctIndex: 0,
      questionTranslation: 'What is their cat called?',
    ),
  ],
);

final QuizContent enZhA12Things = enZhFill(
  id: 'en_zh_a1_2_things',
  title: 'Everyday things',
  intro:
      'The objects around you — several are transparent compounds: 手机 = '
      'hand-machine (phone), 电脑 = electric-brain (computer).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Compounds are Lego',
      text: '电 electric: 电脑 electric-brain = computer, 电视 electric-see = '
          'TV. Decode the parts and half your vocabulary is free.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'book', answer: '书', accepted: ['shū'], hint: 'shū'),
    CourseItem(prompt: 'phone (hand-machine)', answer: '手机', accepted: ['shǒujī'], hint: 'shǒujī'),
    CourseItem(prompt: 'computer (electric-brain)', answer: '电脑', accepted: ['diànnǎo'], hint: 'diànnǎo'),
    CourseItem(prompt: 'TV (electric-see)', answer: '电视', accepted: ['diànshì'], hint: 'diànshì'),
    CourseItem(prompt: 'tea', answer: '茶', accepted: ['chá'], hint: 'chá'),
    CourseItem(prompt: 'water', answer: '水', accepted: ['shuǐ'], hint: 'shuǐ'),
    CourseItem(prompt: 'table', answer: '桌子', accepted: ['zhuōzi'], hint: 'zhuōzi'),
    CourseItem(prompt: 'chair', answer: '椅子', accepted: ['yǐzi'], hint: 'yǐzi'),
    CourseItem(prompt: 'cup / glass', answer: '杯子', accepted: ['bēizi'], hint: 'bēizi'),
    CourseItem(prompt: 'car', answer: '车', accepted: ['chē'], hint: 'chē'),
    CourseItem(prompt: 'movie (electric-shadow)', answer: '电影', accepted: ['diànyǐng'], hint: 'diànyǐng'),
    CourseItem(prompt: 'clothes', answer: '衣服', accepted: ['yīfu'], hint: 'yīfu'),
    CourseItem(prompt: 'rice / a meal', answer: '米饭', accepted: ['mǐfàn'], hint: 'mǐfàn'),
    CourseItem(prompt: 'money', answer: '钱', accepted: ['qián'], hint: 'qián'),
    CourseItem(prompt: 'door', answer: '门', accepted: ['mén'], hint: 'mén'),
  ],
);

final QuizContent enZhA12JiDuoshao = enZhFill(
  id: 'en_zh_a1_2_ji_duoshao',
  title: 'How many? 几 vs 多少',
  intro:
      'Two ways to ask "how many": 几 for small countable numbers (expects '
      '<10, needs a measure word), 多少 for anything (measure word optional).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '几 + MW, 多少 free',
      text: '几口人? 几本书? — 几 always carries the measure word. 多少钱? '
          '多少人? — 多少 doesn\'t need one.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '几 also tells time',
      text: '几点? = what time? (literally "how-many o\'clock") — coming in '
          'the next module.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'How many people are in your family?', answer: '你家有**几**口人？', accepted: ['jǐ'], hint: 'nǐ jiā yǒu jǐ kǒu rén'),
    CourseItem(prompt: 'How many books do you have?', answer: '你有**几**本书？', accepted: ['jǐ'], hint: 'nǐ yǒu jǐ běn shū'),
    CourseItem(prompt: 'How much is it? (how much money)', answer: '**多少**钱？', accepted: ['duōshao'], hint: 'duōshao qián'),
    CourseItem(prompt: 'How many students does your school have? (big number)', answer: '你们学校有**多少**学生？', accepted: ['duōshao'], hint: 'nǐmen xuéxiào yǒu duōshao xuésheng'),
    CourseItem(prompt: 'How many cats does she have?', answer: '她有**几**只猫？', accepted: ['jǐ'], hint: 'tā yǒu jǐ zhī māo'),
    CourseItem(prompt: 'How many older brothers do you have?', answer: '你有**几**个哥哥？', accepted: ['jǐ'], hint: 'nǐ yǒu jǐ ge gēge'),
    CourseItem(prompt: 'How many cups of tea?', answer: '**几**杯茶？', accepted: ['jǐ'], hint: 'jǐ bēi chá'),
    CourseItem(prompt: 'How many dogs does he have?', answer: '他有**几**只狗？', accepted: ['jǐ'], hint: 'tā yǒu jǐ zhī gǒu'),
    CourseItem(prompt: 'How many teachers does your school have? (big number)', answer: '你们学校有**多少**老师？', accepted: ['duōshao'], hint: 'nǐmen xuéxiào yǒu duōshao lǎoshī'),
    CourseItem(prompt: 'How much money does she have?', answer: '她有**多少**钱？', accepted: ['duōshao'], hint: 'tā yǒu duōshao qián'),
    CourseItem(prompt: 'How many people live in Beijing? (huge number)', answer: '北京有**多少**人？', accepted: ['duōshao'], hint: 'Běijīng yǒu duōshao rén'),
    CourseItem(prompt: 'How many children do you have?', answer: '你有**几**个孩子？', accepted: ['jǐ'], hint: 'nǐ yǒu jǐ ge háizi'),
    CourseItem(prompt: 'How many cars does your family have?', answer: '你家有**几**辆车？', accepted: ['jǐ'], hint: 'nǐ jiā yǒu jǐ liàng chē'),
    CourseItem(prompt: 'What is your phone number? (numbers read digit by digit)', answer: '你的手机号码是**多少**？', accepted: ['duōshao'], hint: 'nǐ de shǒujī hàomǎ shì duōshao'),
    CourseItem(prompt: 'How many cups of water does he drink?', answer: '他喝**几**杯水？', accepted: ['jǐ'], hint: 'tā hē jǐ bēi shuǐ'),
  ],
);

final QuizContent enZhA12ReadHome = enZhRead(
  id: 'en_zh_a1_2_read_home',
  title: 'Reading: 这是我的家',
  passageTitle: '这是我的家',
  passage:
      '你好！我叫汤姆。这是我的家。我家有四口人：爸爸、妈妈、姐姐和我。'
      '我爸爸是英国人，他是医生。我妈妈也是医生。我姐姐是学生，她很高。'
      '我们家有一只狗，它叫Max。我很爱我的家。',
  passageTranslation:
      'Nǐ hǎo! Wǒ jiào Tāngmǔ. Zhè shì wǒ de jiā. Wǒ jiā yǒu sì kǒu rén: bàba, '
      'māma, jiějie hé wǒ. Wǒ bàba shì Yīngguó rén, tā shì yīshēng. Wǒ māma yě '
      'shì yīshēng. Wǒ jiějie shì xuésheng, tā hěn gāo. Wǒmen jiā yǒu yì zhī '
      'gǒu, tā jiào Max. Wǒ hěn ài wǒ de jiā.\n\n'
      'Hello! I\'m Tom. This is my family. There are four of us: dad, mum, my '
      'older sister and me. My dad is British — he\'s a doctor. My mum is a '
      'doctor too. My sister is a student, and she\'s tall. We have a dog '
      'called Max. I love my family very much.',
  intro:
      'Tom introduces his family. Notice 也 (also) sliding in before the verb: '
      '我妈妈**也**是医生.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '也 sits before the verb',
      text: '"Too/also" is 也, and it always lands in front of the verb: '
          '她也是学生 — never at the end like English "too".',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆家有几口人？',
      options: ['三口人', '四口人', '五口人'],
      correctIndex: 1,
      questionTranslation: 'How many people are in Tom\'s family?',
    ),
    ReadingQuestion(
      question: '汤姆的妈妈是做什么的？',
      options: ['老师', '学生', '医生'],
      correctIndex: 2,
      questionTranslation: 'What does Tom\'s mum do?',
    ),
    ReadingQuestion(
      question: '谁很高？',
      options: ['汤姆的姐姐', '汤姆的爸爸', '汤姆'],
      correctIndex: 0,
      questionTranslation: 'Who is tall?',
    ),
  ],
);

final QuizContent enZhA12SpeakSandhi = enZhSpeak(
  id: 'en_zh_a1_2_speak_sandhi',
  title: 'Tones in real words',
  intro:
      'The sandhi rules from A1.1, now inside real phrases — including chains '
      'of third tones. Say them at natural speed.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Sandhi is automatic, pinyin isn\'t (Z2)',
      text: 'Pinyin keeps writing nǐ hǎo with two dips — your mouth converts '
          'the first to a rise. Read pinyin with your ears, not your eyes.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Keep the last dip low',
      text: 'In a 3+3 pair only the FIRST syllable changes. The final third '
          'tone stays a low dip — don\'t lift it.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'wǒ hěn hǎo → "wó hén hǎo" — I\'m fine', answer: '我很好。'),
    CourseItem(prompt: 'nǐ yě hǎo — you\'re good too (another chain)', answer: '你也好。'),
    CourseItem(prompt: 'wǒ xiǎng mǎi shuǐ — I want to buy water', answer: '我想买水。'),
    CourseItem(prompt: 'hěn xiǎo — very small', answer: '很小'),
    CourseItem(prompt: 'jiějie hěn máng — older sister is busy', answer: '姐姐很忙。'),
    CourseItem(prompt: 'wǒ jiā yǒu wǔ kǒu rén — five in my family (careful: 五口 stays 3+3→2+3)', answer: '我家有五口人。'),
  ],
);

final QuizContent enZhA12Bu = enZhFill(
  id: 'en_zh_a1_2_bu',
  title: 'Negation with 不',
  intro:
      '不 bù makes things negative and sits right before the verb or '
      'adjective: 我不忙 — I\'m not busy. (Only 有 refuses it and takes 没.)',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '不 + verb/adjective',
      text: '不是 is not, 不去 doesn\'t go, 不忙 not busy. One word, one slot — '
          'no "don\'t/doesn\'t/isn\'t" zoo (Z9).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '不 changes tone before a 4th tone',
      text: 'bù + 4th tone → bú: 不是 bú shì, 不累 bú lèi. Your ear probably '
          'does it already — now you know why.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am not busy.', answer: '我**不**忙。', accepted: ['bù'], hint: 'wǒ bù máng'),
    CourseItem(prompt: 'He is not a doctor.', answer: '他**不是**医生。', accepted: ['bú shì', 'bu shi'], hint: 'tā bú shì yīshēng'),
    CourseItem(prompt: 'She doesn\'t drink tea.', answer: '她**不**喝茶。', accepted: ['bù'], hint: 'tā bù hē chá'),
    CourseItem(prompt: 'I don\'t have a dog. (有 takes 没!)', answer: '我**没**有狗。', accepted: ['méi'], hint: 'wǒ méiyǒu gǒu'),
    CourseItem(prompt: 'That is not my phone.', answer: '那**不是**我的手机。', accepted: ['bú shì', 'bu shi'], hint: 'nà bú shì wǒ de shǒujī'),
    CourseItem(prompt: 'This tea is not hot.', answer: '这杯茶**不**热。', accepted: ['bú', 'bù'], hint: 'zhè bēi chá bú rè'),
    CourseItem(prompt: 'We are not students.', answer: '我们**不是**学生。', accepted: ['bú shì', 'bu shi'], hint: 'wǒmen bú shì xuésheng'),
    CourseItem(prompt: 'His book is not big.', answer: '他的书**不**大。', accepted: ['bù'], hint: 'tā de shū bú dà'),
    CourseItem(prompt: 'She is not tired.', answer: '她**不**累。', accepted: ['bú', 'bù'], hint: 'tā bú lèi'),
    CourseItem(prompt: 'They don\'t have a computer. (有 takes 没!)', answer: '他们**没**有电脑。', accepted: ['méi'], hint: 'tāmen méiyǒu diànnǎo'),
    CourseItem(prompt: 'I don\'t drink coffee; I drink tea.', answer: '我**不**喝咖啡，我喝茶。', accepted: ['bù'], hint: 'wǒ bù hē kāfēi, wǒ hē chá'),
    CourseItem(prompt: 'Aren\'t you tired? (verb-not-verb question: 累不累)', answer: '你**累不累**？', accepted: ['lèi bu lèi', 'lei bu lei'], hint: 'nǐ lèi bu lèi'),
    CourseItem(prompt: 'He is not Chinese; he is British.', answer: '他**不是**中国人，他是英国人。', accepted: ['bú shì', 'bu shi'], hint: 'tā bú shì Zhōngguó rén'),
    CourseItem(prompt: 'My little sister doesn\'t watch TV.', answer: '我妹妹**不**看电视。', accepted: ['bú', 'bù'], hint: 'wǒ mèimei bú kàn diànshì'),
    CourseItem(prompt: 'This is not water; this is tea.', answer: '这**不是**水，这是茶。', accepted: ['bú shì', 'bu shi'], hint: 'zhè bú shì shuǐ, zhè shì chá'),
  ],
);

final QuizContent enZhA12Colours = enZhFill(
  id: 'en_zh_a1_2_colours',
  title: 'Colours & describing',
  intro:
      'Colours end in 色 sè ("colour"): 红色 red, 蓝色 blue. Describing a noun '
      'puts the colour in front with 的: 红色的车.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Description before the noun (Z19)',
      text: '红色**的**车 a red car, 大**的**桌子 the big table — description + '
          '的 + noun, always in that order.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'red (colour)', answer: '红色', accepted: ['hóngsè'], hint: 'hóngsè'),
    CourseItem(prompt: 'blue (colour)', answer: '蓝色', accepted: ['lánsè'], hint: 'lánsè'),
    CourseItem(prompt: 'white (colour)', answer: '白色', accepted: ['báisè'], hint: 'báisè'),
    CourseItem(prompt: 'black (colour)', answer: '黑色', accepted: ['hēisè'], hint: 'hēisè'),
    CourseItem(prompt: 'big', answer: '大', accepted: ['dà'], hint: 'dà'),
    CourseItem(prompt: 'small', answer: '小', accepted: ['xiǎo'], hint: 'xiǎo'),
    CourseItem(prompt: 'a red car (red + 的 + car)', answer: '红色**的**车', accepted: ['de'], hint: 'hóngsè de chē'),
    CourseItem(prompt: 'green (colour)', answer: '绿色', accepted: ['lǜsè'], hint: 'lǜsè'),
    CourseItem(prompt: 'yellow (colour)', answer: '黄色', accepted: ['huángsè'], hint: 'huángsè'),
    CourseItem(prompt: 'a white cat (white + 的 + cat)', answer: '白色**的**猫', accepted: ['de'], hint: 'báisè de māo'),
    CourseItem(prompt: 'a black phone (black + 的 + phone)', answer: '黑色**的**手机', accepted: ['de'], hint: 'hēisè de shǒujī'),
    CourseItem(prompt: 'My car is blue. (colour as the whole predicate: 是…的)', answer: '我的车是**蓝色**的。', accepted: ['lánsè'], hint: 'wǒ de chē shì lánsè de'),
    CourseItem(prompt: 'What colour is your cup? (what-colour = 什么颜色)', answer: '你的杯子是**什么颜色**的？', accepted: ['shénme yánsè'], hint: 'nǐ de bēizi shì shénme yánsè de'),
    CourseItem(prompt: 'the small chair (small + 的 + chair)', answer: '小**的**椅子', accepted: ['de'], hint: 'xiǎo de yǐzi'),
    CourseItem(prompt: 'She likes the yellow clothes.', answer: '她喜欢**黄色**的衣服。', accepted: ['huángsè'], hint: 'tā xǐhuan huángsè de yīfu'),
  ],
);

final QuizContent enZhA12DictFamily = enZhDict(
  id: 'en_zh_a1_2_dict_family',
  title: 'Dictation: my family',
  intro:
      'Listen and type with your pinyin keyboard. Watch for the measure words '
      '口, 个 and 只 — English ears love to skip them.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Don\'t drop the measure word (Z11)',
      text: 'You will hear 一个哥哥, 一只猫, 四口人 — the little word between '
          'number and noun is obligatory. Type what you hear, not what '
          'English would say.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'There are four people in my family.', answer: '我家有四口人。'),
    CourseItem(prompt: 'I have an older brother.', answer: '我有一个哥哥。'),
    CourseItem(prompt: 'My mum is a teacher.', answer: '我妈妈是老师。'),
    CourseItem(prompt: 'She is very tall.', answer: '她很高。'),
    CourseItem(prompt: 'We have a cat.', answer: '我们有一只猫。'),
    CourseItem(prompt: 'This is my dad\'s phone.', answer: '这是我爸爸的手机。'),
    CourseItem(prompt: 'I don\'t have a younger sister.', answer: '我没有妹妹。'),
    CourseItem(prompt: 'My dad is a doctor.', answer: '我爸爸是医生。'),
    CourseItem(prompt: 'That is a white cat.', answer: '那是一只白色的猫。'),
    CourseItem(prompt: 'Whose book is this?', answer: '这是谁的书？'),
    CourseItem(prompt: 'My grandpa is very well.', answer: '我爷爷很好。'),
    CourseItem(prompt: 'She has two children.', answer: '她有两个孩子。'),
    CourseItem(prompt: 'Which cup is yours?', answer: '哪杯是你的？'),
    CourseItem(prompt: 'Our family\'s car is black.', answer: '我们家的车是黑色的。'),
    CourseItem(prompt: 'How many people are in your family?', answer: '你家有几口人？'),
  ],
);

final QuizContent enZhA12ReadFriend = enZhRead(
  id: 'en_zh_a1_2_read_friend',
  title: 'Reading: 我的朋友小美',
  passageTitle: '我的朋友小美',
  passage:
      '小美是我的好朋友。她是中国人，她家在北京。小美很高，也很好看。'
      '她有一个弟弟，他叫小明。小明很小，他不是学生。'
      '小美家有一只白色的猫。我很喜欢小美的猫，可是我没有猫。',
  passageTranslation:
      'Xiǎoměi shì wǒ de hǎo péngyou. Tā shì Zhōngguó rén, tā jiā zài Běijīng. '
      'Xiǎoměi hěn gāo, yě hěn hǎokàn. Tā yǒu yí ge dìdi, tā jiào Xiǎomíng. '
      'Xiǎomíng hěn xiǎo, tā bú shì xuésheng. Xiǎoměi jiā yǒu yì zhī báisè de '
      'māo. Wǒ hěn xǐhuan Xiǎoměi de māo, kěshì wǒ méiyǒu māo.\n\n'
      'Xiaomei is my good friend. She\'s Chinese and her family lives in '
      'Beijing. Xiaomei is tall and also pretty. She has a younger brother '
      'called Xiaoming. Xiaoming is little; he\'s not a student yet. Xiaomei\'s '
      'family has a white cat. I really like Xiaomei\'s cat — but I don\'t '
      'have a cat.',
  intro:
      'Meet 小美, Tom\'s friend. Everything here uses this module\'s grammar: '
      '很 + adjective, 的, 有/没有, and the measure words 个 and 只.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '可是 = but',
      text: 'The passage ends with 可是 (but) — your first sentence '
          'connector. 但是 is its slightly more formal twin.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '小美家在哪儿？',
      options: ['北京', '伦敦', '上海'],
      correctIndex: 0,
      questionTranslation: 'Where does Xiaomei\'s family live?',
    ),
    ReadingQuestion(
      question: '小美的弟弟叫什么？',
      options: ['小明', '汤姆', '花花'],
      correctIndex: 0,
      questionTranslation: 'What is Xiaomei\'s younger brother called?',
    ),
    ReadingQuestion(
      question: '谁没有猫？',
      options: ['小美', '“我”（汤姆）', '小明'],
      correctIndex: 1,
      questionTranslation: 'Who does not have a cat?',
    ),
  ],
);

/// A1.2 in chain order.
final List<QuizContent> enZhA1_2 = [
  enZhA12Hen,
  enZhA12Family,
  enZhA12De,
  enZhA12SpeakFamily,
  enZhA12YouGe,
  enZhA12ThisThat,
  enZhA12ListenFamily,
  enZhA12Things,
  enZhA12JiDuoshao,
  enZhA12ReadHome,
  enZhA12SpeakSandhi,
  enZhA12Bu,
  enZhA12Colours,
  enZhA12DictFamily,
  enZhA12ReadFriend,
];
