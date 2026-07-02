import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// A2.2 — Done & Experienced · 完成与经历 (HSK 2b). English → Mandarin.
///
/// Big rocks: 了 as a ✓-stamp, not a past tense (Z14 — the error that never
/// dies), experiential 过 (Z15), the 不/没 negation split (Z17), the
/// measure-word system beyond 个 (Z11), and first comparisons with 比 (Z24).

final QuizContent enZhA22LeDone = enZhFill(
  id: 'en_zh_a2_2_le_done',
  title: '了 №1 — the action is done',
  intro:
      'Verb + 了 stamps an action as completed: 我买了一本书 — I bought a '
      'book. It\'s a ✓-stamp, not a past tense: habits and states never take '
      'it.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'A ✓-stamp, not a tense (Z14)',
      text: 'Ask "did the action complete?" — if yes, stamp the verb: 吃了, '
          '买了, 去了. If you\'re describing a habit or a state, no stamp.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Past ≠ 了',
      text: '昨天我很忙 (yesterday I was busy) has NO 了 — 忙 is a state, '
          'nothing completed. 每天…了 ✗ too: habits aren\'t single completed '
          'events. This is the #1 error at every level.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I bought a book.', answer: '我买**了**一本书。', accepted: ['le'], hint: 'wǒ mǎi le yì běn shū'),
    CourseItem(prompt: 'He drank two cups of coffee.', answer: '他喝**了**两杯咖啡。', accepted: ['le'], hint: 'tā hē le liǎng bēi kāfēi'),
    CourseItem(prompt: 'We ate lunch.', answer: '我们吃**了**午饭。', accepted: ['le'], hint: 'wǒmen chī le wǔfàn'),
    CourseItem(prompt: 'She went to Beijing yesterday.', answer: '她昨天去**了**北京。', accepted: ['le'], hint: 'tā zuótiān qù le Běijīng'),
    CourseItem(prompt: 'Yesterday I was very busy. (state — NO 了!)', answer: '昨天我**很**忙。', accepted: ['hěn'], hint: 'zuótiān wǒ hěn máng'),
    CourseItem(prompt: 'I drink tea every day. (habit — NO 了!)', answer: '我**每天**喝茶。', accepted: ['měitiān'], hint: 'wǒ měitiān hē chá'),
  ],
);

final QuizContent enZhA22LeChange = enZhFill(
  id: 'en_zh_a2_2_le_change',
  title: '了 №2 — the situation is new',
  intro:
      'Sentence-final 了 stamps a CHANGE: 下雨了 — it\'s raining (now); 我累了 '
      '— I\'ve gotten tired. Something is different from before.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'End-of-sentence 了 = "new now" (Z14)',
      text: '他是学生了 — he\'s a student NOW (he wasn\'t). 我不喝咖啡了 — I '
          'don\'t drink coffee ANYMORE. The 了 says: update your picture.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Two 了s, two jobs',
      text: 'Verb-了 = action completed (买了). Sentence-了 = situation '
          'changed (下雨了). One character, two stamps — context tells you '
          'which.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'It\'s raining (now)!', answer: '下雨**了**！', accepted: ['le'], hint: 'xià yǔ le'),
    CourseItem(prompt: 'I\'m tired (I\'ve gotten tired).', answer: '我累**了**。', accepted: ['le'], hint: 'wǒ lèi le'),
    CourseItem(prompt: 'He is a doctor now. (he wasn\'t before)', answer: '他是医生**了**。', accepted: ['le'], hint: 'tā shì yīshēng le'),
    CourseItem(prompt: 'I don\'t drink coffee anymore.', answer: '我不喝咖啡**了**。', accepted: ['le'], hint: 'wǒ bù hē kāfēi le'),
    CourseItem(prompt: 'It\'s twelve o\'clock — time to eat!', answer: '十二点**了**，吃饭吧！', accepted: ['le'], hint: 'shí\'èr diǎn le, chīfàn ba'),
    CourseItem(prompt: 'My younger sister is tall now.', answer: '我妹妹高**了**。', accepted: ['le'], hint: 'wǒ mèimei gāo le'),
  ],
);

final QuizContent enZhA22Mei = enZhFill(
  id: 'en_zh_a2_2_mei',
  title: 'Didn\'t: 没(有) — and the 不/没 split',
  intro:
      'To say something DIDN\'T happen, use 没(有) before the verb — and drop '
      'the 了: 我没买书. 不 keeps its jobs: habits, futures, states.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '没 for done-and-have, 不 for everything else (Z17)',
      text: '没 negates completed events (没去 didn\'t go) and 有. 不 negates '
          'habits (不喝咖啡), futures (明天不去), adjectives (不累) and '
          'willingness.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 没 kills the 了',
      text: '我没买了书 ✗ — once 没 says "not completed", the ✓-stamp 了 must '
          'go: 我没买书. They never appear together.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I didn\'t buy the book.', answer: '我**没**买书。', accepted: ['méi'], hint: 'wǒ méi mǎi shū'),
    CourseItem(prompt: 'He didn\'t come yesterday.', answer: '他昨天**没**来。', accepted: ['méi'], hint: 'tā zuótiān méi lái'),
    CourseItem(prompt: 'We haven\'t eaten yet. (not yet: 还没)', answer: '我们**还没**吃饭。', accepted: ['hái méi', 'haimei'], hint: 'wǒmen hái méi chīfàn'),
    CourseItem(prompt: 'I don\'t drink coffee. (habit → 不)', answer: '我**不**喝咖啡。', accepted: ['bù'], hint: 'wǒ bù hē kāfēi'),
    CourseItem(prompt: 'She isn\'t going tomorrow. (future → 不)', answer: '她明天**不**去。', accepted: ['bú', 'bù'], hint: 'tā míngtiān bú qù'),
    CourseItem(prompt: 'I didn\'t watch TV last night.', answer: '我昨天晚上**没**看电视。', accepted: ['méi'], hint: 'wǒ zuótiān wǎnshang méi kàn diànshì'),
  ],
);

final QuizContent enZhA22SpeakYesterday = enZhSpeak(
  id: 'en_zh_a2_2_speak_yesterday',
  title: 'Speaking: what I did yesterday',
  intro:
      'Tell yesterday\'s story aloud. Feel where 了 lands — and where it '
      'doesn\'t.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Stamp as you speak',
      text: 'As you repeat, mentally tick each completed action at its 了: '
          '起床✓, 买了✓… The state sentences (很忙, 很累) get no tick — hear '
          'the difference (Z14).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Zuótiān wǒ liù diǎn qǐchuáng. — Yesterday I got up at six.', answer: '昨天我六点起床。'),
    CourseItem(prompt: 'Wǒ mǎi le yì běn shū. — I bought a book.', answer: '我买了一本书。'),
    CourseItem(prompt: 'Wǒ hē le liǎng bēi kāfēi. — I drank two coffees.', answer: '我喝了两杯咖啡。'),
    CourseItem(prompt: 'Wǎnshang wǒ méi kàn diànshì. — I didn\'t watch TV in the evening.', answer: '晚上我没看电视。'),
    CourseItem(prompt: 'Zuótiān wǒ hěn máng. — Yesterday I was very busy. (no 了!)', answer: '昨天我很忙。'),
    CourseItem(prompt: 'Wǒ shí diǎn jiù shuìjiào le. — I went to bed at ten already.', answer: '我十点就睡觉了。'),
  ],
);

final QuizContent enZhA22Guo = enZhFill(
  id: 'en_zh_a2_2_guo',
  title: 'Ever done: 过',
  intro:
      'Verb + 过 guo marks life experience: 我去过中国 — I\'ve been to China '
      '(at some point). Negate with 没…过 — and the 过 stays!',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '过 = the passport stamp (Z15)',
      text: '了 stamps ONE completed event; 过 stamps your passport: "this '
          'experience exists in my life". 你吃过北京烤鸭吗? — Have you ever '
          'had Peking duck?',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 没 keeps 过 (unlike 了)',
      text: '我没去过中国 — the 过 survives negation: "the experience is '
          'missing". Compare 我没买书, where 了 disappears.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I have been to China.', answer: '我去**过**中国。', accepted: ['guo', 'guò'], hint: 'wǒ qù guo Zhōngguó'),
    CourseItem(prompt: 'Have you ever eaten Peking duck?', answer: '你吃**过**北京烤鸭吗？', accepted: ['guo', 'guò'], hint: 'nǐ chī guo Běijīng kǎoyā ma'),
    CourseItem(prompt: 'She has never been to Britain.', answer: '她**没**去过英国。', accepted: ['méi'], hint: 'tā méi qù guo Yīngguó'),
    CourseItem(prompt: 'We have seen this film.', answer: '我们看**过**这个电影。', accepted: ['guo', 'guò'], hint: 'wǒmen kàn guo zhè ge diànyǐng'),
    CourseItem(prompt: 'I have studied Chinese before.', answer: '我学**过**中文。', accepted: ['guo', 'guò'], hint: 'wǒ xué guo Zhōngwén'),
    CourseItem(prompt: 'He has never drunk Chinese tea.', answer: '他没喝**过**中国茶。', accepted: ['guo', 'guò'], hint: 'tā méi hē guo Zhōngguó chá'),
  ],
);

final QuizContent enZhA22ListenEaten = enZhListen(
  id: 'en_zh_a2_2_listen_eaten',
  title: 'Listening: 你吃饭了吗?',
  passageTitle: '吃饭了吗？',
  passage:
      '小美："汤姆，你吃午饭了吗？"\n'
      '汤姆："还没呢。我早上只喝了一杯咖啡。"\n'
      '小美："我知道一个很好的饭馆。你吃过中国菜吗？"\n'
      '汤姆："吃过，可是我没吃过北京烤鸭。"\n'
      '小美："那我们今天去吃烤鸭吧！"\n'
      '汤姆："太好了！我们走吧。"',
  passageTranslation:
      'Xiǎoměi: "Tāngmǔ, nǐ chī wǔfàn le ma?"\n'
      'Tāngmǔ: "Hái méi ne. Wǒ zǎoshang zhǐ hē le yì bēi kāfēi."\n'
      'Xiǎoměi: "Wǒ zhīdào yí ge hěn hǎo de fànguǎn. Nǐ chī guo Zhōngguó cài '
      'ma?"\n'
      'Tāngmǔ: "Chī guo, kěshì wǒ méi chī guo Běijīng kǎoyā."\n'
      'Xiǎoměi: "Nà wǒmen jīntiān qù chī kǎoyā ba!"\n'
      'Tāngmǔ: "Tài hǎo le! Wǒmen zǒu ba."\n\n'
      'Xiaomei: "Tom, have you had lunch?"\n'
      'Tom: "Not yet. I only had a coffee this morning."\n'
      'Xiaomei: "I know a great restaurant. Have you ever had Chinese food?"\n'
      'Tom: "I have — but I\'ve never had Peking duck."\n'
      'Xiaomei: "Then let\'s go eat duck today!"\n'
      'Tom: "Great! Let\'s go."',
  intro:
      '你吃饭了吗? is also a classic Chinese greeting. Listen for 了, 过 and '
      '还没 doing their different jobs.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The greeting that isn\'t a question',
      text: '你吃了吗? between neighbours just means "hi". Here it\'s a real '
          'question — context decides.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆吃午饭了吗？',
      options: ['吃了', '还没吃', '不想吃'],
      correctIndex: 1,
      questionTranslation: 'Has Tom had lunch?',
    ),
    ReadingQuestion(
      question: '汤姆早上喝了什么？',
      options: ['一杯茶', '一杯咖啡', '一杯水'],
      correctIndex: 1,
      questionTranslation: 'What did Tom drink in the morning?',
    ),
    ReadingQuestion(
      question: '汤姆吃过什么？',
      options: ['中国菜', '北京烤鸭'],
      correctIndex: 0,
      questionTranslation: 'What has Tom eaten before?',
    ),
  ],
);

final QuizContent enZhA22MeasureWords = enZhFill(
  id: 'en_zh_a2_2_measure_words',
  title: 'The measure-word system',
  intro:
      'Beyond 个: nouns sort by shape and kind. 本 for bound things, 张 for '
      'flat things, 条 for long bendy things, 只 for animals, 杯 cups, 瓶 '
      'bottles, 件 clothes-tops, 双 pairs, 辆 vehicles, 位 people (polite).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Sort by shape (Z11)',
      text: 'Bound pages → 本. Flat sheet → 张. Long & bendy → 条. On legs → '
          '只. Politely human → 位. When truly lost, 个 still works — but each '
          'right suitcase earns you fluency points.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'English does this too',
      text: 'A PAIR of trousers, a SHEET of paper, a CUP of tea — English '
          'partitives are measure words in disguise. Chinese just applies '
          'them to every noun.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'two books (bound → 本)', answer: '两**本**书', accepted: ['běn'], hint: 'liǎng běn shū'),
    CourseItem(prompt: 'a (flat) photo (flat → 张)', answer: '一**张**照片', accepted: ['zhāng'], hint: 'yì zhāng zhàopiàn'),
    CourseItem(prompt: 'a (long) road (long & bendy → 条)', answer: '一**条**路', accepted: ['tiáo'], hint: 'yì tiáo lù'),
    CourseItem(prompt: 'three dogs (animals → 只)', answer: '三**只**狗', accepted: ['zhī'], hint: 'sān zhī gǒu'),
    CourseItem(prompt: 'a bottle of water', answer: '一**瓶**水', accepted: ['píng'], hint: 'yì píng shuǐ'),
    CourseItem(prompt: 'a shirt (clothes-top → 件)', answer: '一**件**衬衫', accepted: ['jiàn'], hint: 'yí jiàn chènshān'),
    CourseItem(prompt: 'a pair of shoes (pairs → 双)', answer: '一**双**鞋', accepted: ['shuāng'], hint: 'yì shuāng xié'),
    CourseItem(prompt: 'two teachers (polite → 位)', answer: '两**位**老师', accepted: ['wèi'], hint: 'liǎng wèi lǎoshī'),
  ],
);

final QuizContent enZhA22Shopping = enZhFill(
  id: 'en_zh_a2_2_shopping',
  title: 'Shopping: 多少钱 / 块 / 毛',
  intro:
      'Money talk: 多少钱? how much? Prices come in 块 kuài (yuan) and 毛 máo '
      '(tenths). Too expensive? 太贵了!',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '太…了 = way too …',
      text: '太贵了! too expensive! 太好了! great! The 太…了 sandwich turns '
          'any adjective up to eleven.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '块 on the street, 元 on the receipt',
      text: 'Spoken prices use 块 (and 毛 for tenths); written prices use '
          '元/角. 二十五块五 = ¥25.50.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'How much is this?', answer: '这个**多少钱**？', accepted: ['duōshao qián'], hint: 'zhè ge duōshao qián'),
    CourseItem(prompt: 'Twenty-five kuai.', answer: '二十五**块**。', accepted: ['kuài'], hint: 'èrshíwǔ kuài'),
    CourseItem(prompt: 'Too expensive!', answer: '太**贵**了！', accepted: ['guì'], hint: 'tài guì le'),
    CourseItem(prompt: 'A little cheaper, OK? (cheap: 便宜)', answer: '**便宜**一点儿，好吗？', accepted: ['piányi'], hint: 'piányi yìdiǎnr, hǎo ma'),
    CourseItem(prompt: 'I want to buy this shirt.', answer: '我想**买**这件衬衫。', accepted: ['mǎi'], hint: 'wǒ xiǎng mǎi zhè jiàn chènshān'),
    CourseItem(prompt: 'Do you sell tea? (sell: 卖 — mind the tone!)', answer: '你们**卖**茶吗？', accepted: ['mài'], hint: 'nǐmen mài chá ma'),
  ],
);

final QuizContent enZhA22ReadShopping = enZhRead(
  id: 'en_zh_a2_2_read_shopping',
  title: 'Reading: 买东西',
  passageTitle: '买东西',
  passage:
      '今天下午汤姆去商店买东西。他想买一件衬衫。\n'
      '汤姆："你好，这件白色的衬衫多少钱？"\n'
      '售货员："一百二十块。"\n'
      '汤姆："太贵了！能便宜一点儿吗？"\n'
      '售货员："一百块，怎么样？"\n'
      '汤姆："好，我买了。我还要两瓶水。"\n'
      '售货员："一共一百零六块。"',
  passageTranslation:
      'Jīntiān xiàwǔ Tāngmǔ qù shāngdiàn mǎi dōngxi. Tā xiǎng mǎi yí jiàn '
      'chènshān.\n'
      'Tāngmǔ: "Nǐ hǎo, zhè jiàn báisè de chènshān duōshao qián?"\n'
      'Shòuhuòyuán: "Yìbǎi èrshí kuài."\n'
      'Tāngmǔ: "Tài guì le! Néng piányi yìdiǎnr ma?"\n'
      'Shòuhuòyuán: "Yìbǎi kuài, zěnmeyàng?"\n'
      'Tāngmǔ: "Hǎo, wǒ mǎi le. Wǒ hái yào liǎng píng shuǐ."\n'
      'Shòuhuòyuán: "Yígòng yìbǎi líng liù kuài."\n\n'
      'This afternoon Tom goes shopping. He wants to buy a shirt.\n'
      'Tom: "Hello, how much is this white shirt?"\n'
      'Shop assistant: "120 kuai."\n'
      'Tom: "Too expensive! Can you make it a bit cheaper?"\n'
      'Assistant: "100 kuai — how about that?"\n'
      'Tom: "OK, I\'ll take it. I also want two bottles of water."\n'
      'Assistant: "Altogether 106 kuai."',
  intro:
      'Tom haggles. Track the measure words (件, 瓶) and the money — and note '
      '零 in 一百零六 (one hundred **and** six).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '零 plugs the gap',
      text: '106 = 一百零六 — the 零 (zero) marks the skipped tens place. '
          '160 would be 一百六(十).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆想买什么？',
      options: ['一件衬衫', '一双鞋', '一本书'],
      correctIndex: 0,
      questionTranslation: 'What does Tom want to buy?',
    ),
    ReadingQuestion(
      question: '衬衫多少钱？（最后）',
      options: ['一百二十块', '一百块', '一百零六块'],
      correctIndex: 1,
      questionTranslation: 'How much is the shirt (in the end)?',
    ),
    ReadingQuestion(
      question: '汤姆还买了什么？',
      options: ['两瓶水', '两杯茶', '两本书'],
      correctIndex: 0,
      questionTranslation: 'What else did Tom buy?',
    ),
  ],
);

final QuizContent enZhA22Bi = enZhFill(
  id: 'en_zh_a2_2_bi',
  title: 'Comparing with 比',
  intro:
      'A 比 B + adjective: 他比我高 — he (compared-to me) is tall(er). No '
      '"-er", no "more" — and crucially, no 很.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ A 比 B tall — and never 很 (Z24)',
      text: '他比我**很**高 ✗. Degree goes AFTER the adjective instead: '
          '高一点儿 a bit taller, 高得多 much taller.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Compare the other way: 没有',
      text: 'B 没有 A 高 = B isn\'t as tall as A. The negative of a '
          '比-sentence flips to 没有…那么/这么.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He is taller than me.', answer: '他**比**我高。', accepted: ['bǐ'], hint: 'tā bǐ wǒ gāo'),
    CourseItem(prompt: 'This shirt is more expensive than that one.', answer: '这件衬衫**比**那件贵。', accepted: ['bǐ'], hint: 'zhè jiàn chènshān bǐ nà jiàn guì'),
    CourseItem(prompt: 'Beijing is a bit colder than Shanghai. (a bit: 一点儿 after adj)', answer: '北京比上海冷**一点儿**。', accepted: ['yìdiǎnr', 'yidianr'], hint: 'Běijīng bǐ Shànghǎi lěng yìdiǎnr'),
    CourseItem(prompt: 'Tea is much cheaper than coffee. (much: 得多)', answer: '茶比咖啡便宜**得多**。', accepted: ['de duō', 'deduo'], hint: 'chá bǐ kāfēi piányi de duō'),
    CourseItem(prompt: 'My older brother is busier than me.', answer: '我哥哥**比**我忙。', accepted: ['bǐ'], hint: 'wǒ gēge bǐ wǒ máng'),
    CourseItem(prompt: 'I am not as tall as him.', answer: '我**没有**他高。', accepted: ['méiyǒu', 'méi yǒu'], hint: 'wǒ méiyǒu tā gāo'),
  ],
);

final QuizContent enZhA22Yidianr = enZhFill(
  id: 'en_zh_a2_2_yidianr',
  title: '一点儿 vs 有点儿',
  intro:
      'Both mean "a little" — but 一点儿 follows adjectives/nouns (便宜一点儿, '
      '一点儿水), while 有点儿 goes before adjectives and always complains: '
      '有点儿贵.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '有点儿 = "a bit too…" (complaint)',
      text: '这个有点儿贵 — hmm, a bit pricey (negative feel). 便宜一点儿 — a '
          'bit cheaper please (request). Before = feeling, after = amount.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'This is a bit expensive. (complaint)', answer: '这个**有点儿**贵。', accepted: ['yǒudiǎnr', 'youdianr'], hint: 'zhè ge yǒudiǎnr guì'),
    CourseItem(prompt: 'A bit cheaper, please. (request)', answer: '便宜**一点儿**。', accepted: ['yìdiǎnr', 'yidianr'], hint: 'piányi yìdiǎnr'),
    CourseItem(prompt: 'I\'m a bit tired.', answer: '我**有点儿**累。', accepted: ['yǒudiǎnr'], hint: 'wǒ yǒudiǎnr lèi'),
    CourseItem(prompt: 'Drink a little water.', answer: '喝**一点儿**水。', accepted: ['yìdiǎnr'], hint: 'hē yìdiǎnr shuǐ'),
    CourseItem(prompt: 'Today is a bit cold.', answer: '今天**有点儿**冷。', accepted: ['yǒudiǎnr'], hint: 'jīntiān yǒudiǎnr lěng'),
  ],
);

final QuizContent enZhA22SpeakBuYi = enZhSpeak(
  id: 'en_zh_a2_2_speak_bu_yi',
  title: 'Sounds: 不 & 一 change tone',
  intro:
      'Two everyday words bend their tone: 不 bù → bú before a 4th tone, and '
      '一 yī → yí before a 4th, yì before the rest. Say them until it\'s '
      'automatic.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚠️ 不 flips before a fall (Z2)',
      text: 'bù + 4th → bú: 不是 bú shì, 不去 bú qù, 不累 bú lèi. Everywhere '
          'else it stays bù: 不高, 不忙, 不喝.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '一 has three faces',
      text: 'Counting: yī (一, 十一). Before a 4th tone: yí (一件, 一个*). '
          'Before tones 1/2/3: yì (一杯, 一瓶, 一本). *个 counts as 4th.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'bú shì, bú qù, bú lèi — 不 before 4th tones', answer: '不是，不去，不累'),
    CourseItem(prompt: 'bù gāo, bù máng, bù hǎo — 不 stays bù', answer: '不高，不忙，不好'),
    CourseItem(prompt: 'yí ge, yí jiàn, yí wèi — 一 before 4th tones', answer: '一个，一件，一位'),
    CourseItem(prompt: 'yì bēi, yì píng, yì běn — 一 before tones 1/2/3', answer: '一杯，一瓶，一本'),
    CourseItem(prompt: 'Wǒ bú shì lǎoshī. — I\'m not a teacher.', answer: '我不是老师。'),
    CourseItem(prompt: 'Wǒ mǎi le yí jiàn chènshān hé yì shuāng xié. — I bought a shirt and a pair of shoes.', answer: '我买了一件衬衫和一双鞋。'),
  ],
);

final QuizContent enZhA22Food = enZhFill(
  id: 'en_zh_a2_2_food',
  title: 'Food & drink',
  intro:
      'The essentials for menus and markets — with their measure words '
      'attached where it helps.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '菜 = dish, not just vegetable',
      text: '中国菜 Chinese food, 做菜 to cook — 菜 covers whole cuisines. '
          '米饭 is the cooked rice on your plate.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'rice (cooked)', answer: '米饭', accepted: ['mǐfàn'], hint: 'mǐfàn'),
    CourseItem(prompt: 'noodles', answer: '面条', accepted: ['miàntiáo'], hint: 'miàntiáo'),
    CourseItem(prompt: 'fruit', answer: '水果', accepted: ['shuǐguǒ'], hint: 'shuǐguǒ'),
    CourseItem(prompt: 'apple', answer: '苹果', accepted: ['píngguǒ'], hint: 'píngguǒ'),
    CourseItem(prompt: 'fish', answer: '鱼', accepted: ['yú'], hint: 'yú'),
    CourseItem(prompt: 'chicken (meat)', answer: '鸡肉', accepted: ['jīròu'], hint: 'jīròu'),
    CourseItem(prompt: 'beer', answer: '啤酒', accepted: ['píjiǔ'], hint: 'píjiǔ'),
    CourseItem(prompt: 'delicious (good-eat)', answer: '好吃', accepted: ['hǎochī'], hint: 'hǎochī'),
  ],
);

final QuizContent enZhA22DictYesterday = enZhDict(
  id: 'en_zh_a2_2_dict_yesterday',
  title: 'Dictation: yesterday',
  intro:
      'Type what you hear — every 了, 过 and 没 included. They\'re short, '
      'unstressed and easy to drop: that\'s exactly why we drill them.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Listen for the small words (Z14/Z15)',
      text: '了, 过, 没, 还 carry the whole meaning of the sentence. If your '
          'typed line misses one, the sentence changed tense — er, aspect.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I bought a book yesterday.', answer: '我昨天买了一本书。'),
    CourseItem(prompt: 'Have you ever been to China?', answer: '你去过中国吗？'),
    CourseItem(prompt: 'He didn\'t come.', answer: '他没来。'),
    CourseItem(prompt: 'It\'s raining!', answer: '下雨了！'),
    CourseItem(prompt: 'We haven\'t eaten yet.', answer: '我们还没吃饭。'),
    CourseItem(prompt: 'This dish is delicious!', answer: '这个菜很好吃！'),
  ],
);

final QuizContent enZhA22ReadWeekend = enZhRead(
  id: 'en_zh_a2_2_read_weekend',
  title: 'Reading: 汤姆的周末',
  passageTitle: '汤姆的周末',
  passage:
      '上个周末汤姆很忙。星期六早上他去了商店，买了一件衬衫和一双鞋。'
      '下午他和小美去饭馆吃了北京烤鸭。汤姆以前没吃过烤鸭，他觉得太好吃了！'
      '星期天他在家学习中文，晚上给妈妈打了电话。'
      '妈妈问："你去过长城吗？"汤姆说："还没去过，我下个月想去。"',
  passageTranslation:
      'Shàng ge zhōumò Tāngmǔ hěn máng. Xīngqīliù zǎoshang tā qù le shāngdiàn, '
      'mǎi le yí jiàn chènshān hé yì shuāng xié. Xiàwǔ tā hé Xiǎoměi qù '
      'fànguǎn chī le Běijīng kǎoyā. Tāngmǔ yǐqián méi chī guo kǎoyā, tā juéde '
      'tài hǎochī le! Xīngqītiān tā zài jiā xuéxí Zhōngwén, wǎnshang gěi māma '
      'dǎ le diànhuà. Māma wèn: "Nǐ qù guo Chángchéng ma?" Tāngmǔ shuō: "Hái '
      'méi qù guo, wǒ xià ge yuè xiǎng qù."\n\n'
      'Last weekend Tom was busy. On Saturday morning he went to the shops and '
      'bought a shirt and a pair of shoes. In the afternoon he and Xiaomei ate '
      'Peking duck at a restaurant. Tom had never had roast duck before — he '
      'thought it was delicious! On Sunday he studied Chinese at home, and in '
      'the evening he phoned his mum. Mum asked: "Have you been to the Great '
      'Wall?" Tom said: "Not yet — I\'d like to go next month."',
  intro:
      'The whole module in one story: 了 for completed actions, 过 for '
      'experiences, 没…过 for the ones still missing.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Three stamps, one story',
      text: '买了 (done), 没吃过 (experience missing), 还没去过 (still not '
          'yet). Find each in the text and say why it\'s not the others.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '汤姆星期六买了什么？',
      options: ['一件衬衫和一双鞋', '一本书和一瓶水', '一个手机'],
      correctIndex: 0,
      questionTranslation: 'What did Tom buy on Saturday?',
    ),
    ReadingQuestion(
      question: '汤姆以前吃过烤鸭吗？',
      options: ['吃过', '没吃过'],
      correctIndex: 1,
      questionTranslation: 'Had Tom eaten roast duck before?',
    ),
    ReadingQuestion(
      question: '汤姆什么时候想去长城？',
      options: ['这个周末', '下个月', '明天'],
      correctIndex: 1,
      questionTranslation: 'When would Tom like to go to the Great Wall?',
    ),
  ],
);

/// A2.2 in chain order.
final List<QuizContent> enZhA2_2 = [
  enZhA22LeDone,
  enZhA22LeChange,
  enZhA22Mei,
  enZhA22SpeakYesterday,
  enZhA22Guo,
  enZhA22ListenEaten,
  enZhA22MeasureWords,
  enZhA22Shopping,
  enZhA22ReadShopping,
  enZhA22Bi,
  enZhA22Yidianr,
  enZhA22SpeakBuYi,
  enZhA22Food,
  enZhA22DictYesterday,
  enZhA22ReadWeekend,
];
