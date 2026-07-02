import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// C2.2 — Mastery · 精通 (HSK 7–9, capstone). English → Mandarin.
///
/// Big rocks: 文言 flavor in modern prose (所谓/而已/皆/乃 — Z30 at the
/// ceiling), discourse-level cohesion, weighing frames 与其…不如 / 宁可,
/// translationese repair (write Chinese Chinese, not translated English), and
/// tone & irony control. Capstone: long-form reading, analysis, and speech.

final QuizContent enZhC22Wenyan = enZhFill(
  id: 'en_zh_c2_2_wenyan',
  title: 'Classical flavor: 所谓 / 而已 / 皆 / 乃',
  intro:
      'Modern educated prose keeps a pinch of Classical Chinese: 所谓 '
      '"so-called", 而已 "and nothing more", 皆 "all (written)", 乃 "is '
      'precisely".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'A pinch, not a spoonful (Z30)',
      text: 'These words season a sentence: 所谓成功，不过是坚持而已 — '
          '"so-called success is mere persistence, nothing more." All-文言 '
          'prose is archaic; none at all reads flat at this level.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'So-called success is merely persistence, nothing more.', answer: '**所谓**成功，不过是坚持**而已**。', accepted: ['suǒwèi…éryǐ', 'suowei eryi'], hint: 'suǒwèi chénggōng, búguò shì jiānchí éryǐ'),
    CourseItem(prompt: 'All things change; nothing stays. (written all: 皆)', answer: '万物**皆**变，无一常存。', accepted: ['jiē'], hint: 'wànwù jiē biàn, wú yī cháng cún'),
    CourseItem(prompt: 'This is precisely the crux of the problem. (乃)', answer: '这**乃**是问题的关键。', accepted: ['nǎi'], hint: 'zhè nǎi shì wèntí de guānjiàn'),
    CourseItem(prompt: 'What people call "luck" is often just preparation.', answer: '人们**所谓**的"运气"，往往只是准备。', accepted: ['suǒwèi'], hint: 'rénmen suǒwèi de "yùnqi", wǎngwǎng zhǐshì zhǔnbèi'),
    CourseItem(prompt: 'I was joking, that\'s all. (而已 softens)', answer: '我开个玩笑**而已**。', accepted: ['éryǐ'], hint: 'wǒ kāi ge wánxiào éryǐ'),
  ],
);

final QuizContent enZhC22Cohesion = enZhFill(
  id: 'en_zh_c2_2_cohesion',
  title: 'Discourse cohesion at C2',
  intro:
      'Above the sentence: the devices that stitch paragraphs — 前者/后者, '
      '如上所述, 换言之, 综上所述.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Refer without repeating (Z30)',
      text: '前者…后者 the former…the latter; 换言之 in other words; 综上所述 '
          'to sum up the above. Chinese formal prose tracks references '
          'tightly — these are its pronouns of the paragraph.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The former stresses efficiency; the latter, fairness.', answer: '**前者**强调效率，**后者**强调公平。', accepted: ['qiánzhě…hòuzhě', 'qianzhe houzhe'], hint: 'qiánzhě qiángdiào xiàolǜ, hòuzhě qiángdiào gōngpíng'),
    CourseItem(prompt: 'In other words, quality matters more than quantity.', answer: '**换言之**，质量比数量更重要。', accepted: ['huànyánzhī', 'huan yan zhi'], hint: 'huànyánzhī, zhìliàng bǐ shùliàng gèng zhòngyào'),
    CourseItem(prompt: 'To sum up the above, both approaches have merit.', answer: '**综上所述**，两种方法各有所长。', accepted: ['zōng shàng suǒ shù'], hint: 'zōng shàng suǒ shù, liǎng zhǒng fāngfǎ gè yǒu suǒ cháng'),
    CourseItem(prompt: 'As stated above, the data supports this conclusion.', answer: '**如上所述**，数据支持这一结论。', accepted: ['rú shàng suǒ shù'], hint: 'rú shàng suǒ shù, shùjù zhīchí zhè yī jiélùn'),
    CourseItem(prompt: 'This point will be discussed in detail below. (下文)', answer: '这一点将在**下文**详细讨论。', accepted: ['xiàwén'], hint: 'zhè yì diǎn jiāng zài xiàwén xiángxì tǎolùn'),
  ],
);

final QuizContent enZhC22SpeakSpeech = enZhSpeak(
  id: 'en_zh_c2_2_speak_speech',
  title: 'Speaking: deliver a short speech',
  intro:
      'A one-minute formal speech: opening courtesy, a claim, one story, one '
      'turn, a landing. Deliver it like you own the room.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The speech arc',
      text: 'Chinese speeches open with courtesy (各位…), plant the thesis '
          'early, turn on a 然而/但, and land on an aphorism. Pause a full '
          'beat at each joint.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Gèwèi péngyou, wǎnshang hǎo. — Friends, good evening.', answer: '各位朋友，晚上好。'),
    CourseItem(prompt: 'Jīntiān wǒ xiǎng jiǎng yí ge guānyú jiānchí de gùshi. — Tonight I want to tell a story about persistence.', answer: '今天我想讲一个关于坚持的故事。'),
    CourseItem(prompt: 'Sān nián qián, wǒ lián yí jù Zhōngwén dōu bú huì shuō. — Three years ago, I couldn\'t speak a word of Chinese.', answer: '三年前，我连一句中文都不会说。'),
    CourseItem(prompt: 'Rán\'ér, zhēnzhèng gǎibiàn wǒ de, bìng bú shì tiānfù, ér shì měitiān de liànxí. — Yet what truly changed me was not talent, but daily practice.', answer: '然而，真正改变我的，并不是天赋，而是每天的练习。'),
    CourseItem(prompt: 'Suǒwèi qíjì, búguò shì jiānchí de lìng yí ge míngzi éryǐ. Xièxie dàjiā! — So-called miracles are merely another name for persistence. Thank you!', answer: '所谓奇迹，不过是坚持的另一个名字而已。谢谢大家！'),
  ],
);

final QuizContent enZhC22Weighing = enZhFill(
  id: 'en_zh_c2_2_weighing',
  title: 'Weighing choices: 与其…不如 / 宁可',
  intro:
      'The trade-off frames: 与其 A，不如 B (rather than A, better B) and '
      '宁可 A，也不 B (would sooner A than B).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Compare plans, not things',
      text: '比 compares nouns; 与其…不如 compares courses of action: '
          '与其抱怨，不如行动 — rather than complain, act. 宁可 declares the '
          'painful preference: 宁可累一点，也不放弃.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Rather than complain, better to act.', answer: '**与其**抱怨，**不如**行动。', accepted: ['yǔqí…bùrú', 'yuqi buru'], hint: 'yǔqí bàoyuàn, bùrú xíngdòng'),
    CourseItem(prompt: 'I\'d sooner be a bit tired than give up.', answer: '我**宁可**累一点，**也不**放弃。', accepted: ['nìngkě…yěbù', 'ningke yebu'], hint: 'wǒ nìngkě lèi yìdiǎn, yě bú fàngqì'),
    CourseItem(prompt: 'Rather than wait here, better to go find him.', answer: '与其在这儿等，**不如**去找他。', accepted: ['bùrú'], hint: 'yǔqí zài zhèr děng, bùrú qù zhǎo tā'),
    CourseItem(prompt: 'He would sooner go hungry than eat badly. (宁可…也不)', answer: '他**宁可**饿着，**也不**吃得马虎。', accepted: ['nìngkě'], hint: 'tā nìngkě è zhe, yě bù chī de mǎhu'),
    CourseItem(prompt: 'Rather than force it to be fast, better to do it well.', answer: '与其求快，**不如**求好。', accepted: ['bùrú'], hint: 'yǔqí qiú kuài, bùrú qiú hǎo'),
  ],
);

final QuizContent enZhC22ListenDebate = enZhListen(
  id: 'en_zh_c2_2_listen_debate',
  title: 'Listening: 时事辩论',
  passageTitle: '辩论：人工智能会取代翻译吗？',
  passage:
      '主持人："今天的辩题是：人工智能会不会取代人类翻译？请正方发言。"\n'
      '正方："谢谢主持人。机器翻译的进步有目共睹：速度快、成本低、'
      '错误率逐年下降。日常翻译的大部分工作，机器已经可以胜任。'
      '与其否认现实，不如承认：这个行业正在被重新定义。"\n'
      '反方："对方辩友只看到了效率，却忽略了语言的本质。'
      '翻译不是简单的词语转换，而是文化之间的桥梁。'
      '机器可以翻译"再见"，但它翻译得出"长亭外，古道边"里的离愁吗？'
      '在文学、外交这些领域，人类翻译不但不会被取代，'
      '反而会因为机器的存在而变得更加珍贵。"\n'
      '主持人："双方观点都很精彩。看来问题的关键，'
      '不在于机器能做什么，而在于我们把什么交给机器。"',
  passageTranslation:
      'Debate: Will AI replace human translators?\n'
      'Host: "Today\'s motion: will artificial intelligence replace human '
      'translators? The affirmative side, please."\n'
      'Affirmative: "Thank you. Machine translation\'s progress is plain to '
      'see: fast, cheap, with error rates falling year by year. Machines can '
      'already handle most everyday translation. Rather than deny reality, '
      'better to admit it: this industry is being redefined."\n'
      'Negative: "Our opponents see only efficiency and ignore the nature of '
      'language. Translation is not word-swapping but a bridge between '
      'cultures. A machine can translate \'goodbye\' — but can it translate '
      'the parting sorrow in a classical verse? In literature and diplomacy, '
      'human translators will not be replaced; the machine\'s existence will '
      'make them more precious."\n'
      'Host: "Both sides excellent. It seems the key is not what machines '
      'can do, but what we choose to hand them."',
  intro:
      'A formal debate — 有目共睹, 与其…不如, 不但不…反而, and a rhetorical '
      'question as the knockout blow. Track each side\'s moves.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '对方辩友',
      text: '"Our esteemed opponents" — the fixed courtesy address of '
          'Chinese debate. Attack the argument, honor the person (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '正方的主要理由是什么？',
      options: ['机器又快又便宜，错误越来越少', '机器懂文学', '机器会写诗'],
      correctIndex: 0,
      questionTranslation: 'What is the affirmative side\'s main argument?',
    ),
    ReadingQuestion(
      question: '反方认为翻译的本质是什么？',
      options: ['文化之间的桥梁', '词语转换', '提高速度'],
      correctIndex: 0,
      questionTranslation: 'What does the negative side call translation\'s essence?',
    ),
    ReadingQuestion(
      question: '主持人认为问题的关键在于什么？',
      options: ['我们把什么交给机器', '机器有多快', '谁的声音大'],
      correctIndex: 0,
      questionTranslation: 'What does the host identify as the key question?',
    ),
  ],
);

final QuizContent enZhC22Allusion = enZhFill(
  id: 'en_zh_c2_2_allusion',
  title: 'Allusion: 塞翁失马 & friends',
  intro:
      'Story-成语: each carries a whole parable. Use one and you cite the '
      'story, the moral, and two thousand years of readers nodding along.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Know the story, own the phrase (Z30)',
      text: '塞翁失马(焉知非福): the frontier man\'s lost horse returned '
          'leading more — misfortune may be a blessing. 画蛇添足: the man who '
          'drew legs on his snake lost the wine — don\'t gild the lily.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'a blessing in disguise (the frontier old man loses his horse)', answer: '塞翁失马', accepted: ['sài wēng shī mǎ'], hint: 'sài wēng shī mǎ'),
    CourseItem(prompt: 'to ruin something by adding the superfluous (draw a snake, add feet)', answer: '画蛇添足', accepted: ['huà shé tiān zú'], hint: 'huà shé tiān zú'),
    CourseItem(prompt: 'to make a foolish, rigid plan (carve the boat to find the sword)', answer: '刻舟求剑', accepted: ['kè zhōu qiú jiàn'], hint: 'kè zhōu qiú jiàn'),
    CourseItem(prompt: 'to profess love for what one actually fears (Lord Ye loves dragons)', answer: '叶公好龙', accepted: ['Yè gōng hào lóng'], hint: 'Yè gōng hào lóng'),
    CourseItem(prompt: 'Losing that job? Maybe a blessing in disguise.', answer: '丢了那份工作，也许是**塞翁失马**。', accepted: ['sài wēng shī mǎ'], hint: 'diū le nà fèn gōngzuò, yěxǔ shì sài wēng shī mǎ'),
    CourseItem(prompt: 'The last paragraph ruins it — pure legs-on-a-snake.', answer: '最后一段完全是**画蛇添足**。', accepted: ['huà shé tiān zú'], hint: 'zuìhòu yí duàn wánquán shì huà shé tiān zú'),
  ],
);

final QuizContent enZhC22ReadAnalysis = enZhRead(
  id: 'en_zh_c2_2_read_analysis',
  title: 'Reading: 一篇新闻分析',
  passageTitle: '新闻分析：预制菜进校园之争',
  passage:
      '近日，多地家长对"预制菜进校园"表达担忧，相关话题连续数日占据热搜。'
      '表面上看，这是一场关于食品安全的争论；实际上，'
      '它触及的是一个更深层的问题：公共决策中的信任。\n'
      '预制菜本身并非洪水猛兽。业内人士指出，规范生产的预制菜，'
      '其安全标准未必低于现场烹饪。然而，家长的愤怒并非毫无来由——'
      '真正令他们不安的，是"不知情"：孩子每天吃什么，'
      '竟需要通过网络爆料才能得知。\n'
      '换言之，问题的核心不是"能不能吃"，而是"谁来决定、谁被告知"。'
      '有关部门若只强调检测合格，而回避决策程序的透明，'
      '恐怕难以真正平息质疑。信任如同瓷器，打碎容易，修复极难。\n'
      '综上所述，与其在舆论发酵后被动回应，'
      '不如在决策之初就把家长请到桌前。'
      '毕竟，公共信任才是最经不起"预制"的东西。',
  passageTranslation:
      'News analysis: the school pre-made meals controversy\n'
      'Recently, parents in many cities voiced concern over "pre-made meals '
      'entering school canteens", and the topic dominated trending lists for '
      'days. On the surface it is a food-safety debate; in fact it touches '
      'something deeper: trust in public decision-making.\n'
      'Pre-made meals are no monster in themselves. Industry insiders note '
      'that properly produced ones may meet safety standards no lower than '
      'on-site cooking. Yet the parents\' anger is not groundless — what '
      'truly unsettles them is not knowing: they learned what their children '
      'eat daily only through online exposés.\n'
      'In other words, the core issue is not "is it safe to eat" but "who '
      'decides, and who gets told". If the authorities stress only that '
      'tests were passed while avoiding transparency about the '
      'decision-making process, the doubts will hardly subside. Trust is '
      'like porcelain: easy to shatter, terribly hard to mend.\n'
      'To sum up: rather than respond passively after public opinion boils '
      'over, better to invite the parents to the table when the decision is '
      'first made. Public trust, after all, is the one thing that cannot be '
      '"pre-made".',
  intro:
      'Journalistic analysis at full register: 表面上…实际上, 换言之, '
      '综上所述, a porcelain metaphor, and a wordplay ending. Read for the '
      'argument\'s architecture.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'The pivot: 表面上…实际上',
      text: '"On the surface… in reality" — the analysis genre\'s signature '
          'move: open with the visible dispute, pivot to the structural one '
          '(Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '文章认为争论真正触及的是什么？',
      options: ['公共决策中的信任', '预制菜的味道', '菜的价格'],
      correctIndex: 0,
      questionTranslation: 'What does the analysis say the dispute really touches?',
    ),
    ReadingQuestion(
      question: '最令家长不安的是什么？',
      options: ['不知情', '菜太贵', '孩子不爱吃'],
      correctIndex: 0,
      questionTranslation: 'What most unsettles the parents?',
    ),
    ReadingQuestion(
      question: '文章建议有关部门怎么做？',
      options: ['决策之初就请家长参与', '只公布检测结果', '关闭网络讨论'],
      correctIndex: 0,
      questionTranslation: 'What does the article advise the authorities to do?',
    ),
  ],
);

final QuizContent enZhC22Natural = enZhFill(
  id: 'en_zh_c2_2_natural',
  title: 'Say it in Chinese, not translated English',
  intro:
      'The final boss: translationese (翻译腔). Each item gives the stiff '
      'word-by-word version — produce what a native would actually say.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Kill the imported scaffolding',
      text: 'English needs pronouns, copulas and "when/if" glue everywhere; '
          'Chinese drops them. 当我吃饭的时候 → 吃饭时/吃着饭. "One of the '
          'most…" → …之一 used sparingly, or recast entirely.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Topic first, verbs forward',
      text: 'Natural Chinese fronts the topic and lets verbs run: not '
          '"我认为这是一个非常好的主意" every time — often just 这主意好. '
          'Shorter IS more native (Z28).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Stiff: 我给了他一些建议。Natural: give-him-了 a few suggestions → verb 提', answer: '我给他**提**了几条建议。', accepted: ['tí'], hint: 'wǒ gěi tā tí le jǐ tiáo jiànyì'),
    CourseItem(prompt: 'Stiff: 这个价格是可以被接受的。 Natural: no passive, no copula.', answer: '这个价格**可以接受**。', accepted: ['kěyǐ jiēshòu'], hint: 'zhè ge jiàgé kěyǐ jiēshòu'),
    CourseItem(prompt: 'Stiff: 当我到家的时候，我会给你打电话。 Natural: drop 当…的时候 and the second 我.', answer: '**到家**我就给你打电话。', accepted: ['dào jiā'], hint: 'dào jiā wǒ jiù gěi nǐ dǎ diànhuà'),
    CourseItem(prompt: 'Stiff: 他是一个非常有耐心的人。 Natural: 很有耐心 does it all.', answer: '他**很有耐心**。', accepted: ['hěn yǒu nàixīn'], hint: 'tā hěn yǒu nàixīn'),
    CourseItem(prompt: 'Stiff: 你可以打开窗户吗？ Natural: courtesy via 麻烦/帮 + 把.', answer: '**麻烦**把窗户打开。', accepted: ['máfan'], hint: 'máfan bǎ chuānghu dǎkāi'),
    CourseItem(prompt: 'Stiff: 存在着很多问题。 Natural: existence via 有, topic first.', answer: '问题**还很多**。', accepted: ['hái hěn duō'], hint: 'wèntí hái hěn duō'),
  ],
);

final QuizContent enZhC22Irony = enZhFill(
  id: 'en_zh_c2_2_irony',
  title: 'Tone & irony control',
  intro:
      'Words that flip their charge in context: 真行 (impressed or scathing), '
      '好意思 (how dare you), 可 for wry emphasis. Handle with care.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Praise words are loaded',
      text: '你真行! is "impressive!" — or, after a blunder, "nice going." '
          '你还好意思说! = you\'ve got the nerve to mention it! Context and '
          'prosody decide; when unsure, read the room twice.',
    ),
  ],
  items: const [
    CourseItem(prompt: '"Nice going." (ironic praise after a blunder)', answer: '你可**真行**。', accepted: ['zhēn xíng'], hint: 'nǐ kě zhēn xíng'),
    CourseItem(prompt: 'You\'ve got the nerve to say that?!', answer: '你还**好意思**说？', accepted: ['hǎoyìsi'], hint: 'nǐ hái hǎoyìsi shuō'),
    CourseItem(prompt: 'Oh sure, sure — whatever you say. (mock agreement 是是是)', answer: '**是是是**，您说的都对。', accepted: ['shì shì shì'], hint: 'shì shì shì, nín shuō de dōu duì'),
    CourseItem(prompt: 'That\'s SOME "little problem". (所谓 as scare quotes)', answer: '这就是你**所谓**的"小问题"？', accepted: ['suǒwèi'], hint: 'zhè jiù shì nǐ suǒwèi de "xiǎo wèntí"'),
    CourseItem(prompt: 'I really must thank you, mustn\'t I. (可 + 真得 wry)', answer: '那我**可**真得谢谢你了。', accepted: ['kě'], hint: 'nà wǒ kě zhēn děi xièxie nǐ le'),
  ],
);

final QuizContent enZhC22SpeakRebuttal = enZhSpeak(
  id: 'en_zh_c2_2_speak_rebuttal',
  title: 'Speaking: spontaneous rebuttal',
  intro:
      'Debate-floor moves: concede a point, turn it, land your counter — at '
      'speed, with the courtesy forms intact.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concede-turn-strike',
      text: 'The rebuttal rhythm: 您说得有道理，但是… / 这恰恰说明… — agree '
          'with a sliver, pivot on 但是/恰恰, strike with your point. Speed '
          'comes from the fixed frames.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nín shuō de yǒu dàolǐ, dànshì wèntí méi zhème jiǎndān. — Fair point, but it\'s not that simple.', answer: '您说得有道理，但是问题没这么简单。'),
    CourseItem(prompt: 'Zhè qiàqià shuōmíng le wǒmen de guāndiǎn. — This proves precisely our point.', answer: '这恰恰说明了我们的观点。'),
    CourseItem(prompt: 'Duìfāng biànyǒu hūlüè le yí ge guānjiàn shìshí. — Our opponents have overlooked a key fact.', answer: '对方辩友忽略了一个关键事实。'),
    CourseItem(prompt: 'Tuìyíbùshuō, jíshǐ rúcǐ, jiélùn yě bù chénglì. — Even granting that, the conclusion still fails.', answer: '退一步说，即使如此，结论也不成立。'),
    CourseItem(prompt: 'Guī gēn jié dǐ, zhè shì ge xuǎnzé wèntí, ér fēi jìshù wèntí. — Ultimately this is a question of choice, not of technology.', answer: '归根结底，这是个选择问题，而非技术问题。'),
  ],
);

final QuizContent enZhC22ListenCulture = enZhListen(
  id: 'en_zh_c2_2_listen_culture',
  title: 'Listening: 文化讲座',
  passageTitle: '讲座：汉字为什么没有消失',
  passage:
      '各位好。今天我们谈一个问题：汉字为什么没有消失？\n'
      '一百年前，不少学者曾断言，汉字太难，必将被拼音文字取代。'
      '在打字机时代，这种担忧看似有理：西文打字机噼啪作响，'
      '汉字却连一台像样的打字机都造不出来。\n'
      '然而，历史开了一个玩笑。计算机的出现，非但没有埋葬汉字，'
      '反而给了它新生：今天，输入汉字的速度丝毫不逊于任何拼音文字。'
      '所谓"汉字危机"，就这样烟消云散了。\n'
      '更耐人寻味的是，正是最古老的特性救了汉字——'
      '它记录的是意义，而不仅仅是声音。'
      '正因如此，上海人和广州人口音天差地别，写下来却是同一行字；'
      '我们今天读两千年前的文章，居然还能会心一笑。\n'
      '归根结底，汉字的生命力，乃在于它把整个文明装进了方寸之间。',
  passageTranslation:
      'Lecture: why did Chinese characters not disappear?\n'
      'Greetings. Today\'s question: why didn\'t Chinese characters die out?\n'
      'A century ago, many scholars declared characters too difficult — '
      'surely to be replaced by alphabetic writing. In the typewriter age the '
      'worry seemed reasonable: Western typewriters clattered away, while no '
      'decent Chinese typewriter could even be built.\n'
      'History, however, played a joke. The computer, far from burying the '
      'characters, gave them new life: typing Chinese today is every bit as '
      'fast as typing any alphabet. The so-called "character crisis" '
      'vanished like smoke.\n'
      'More thought-provoking still: it was the most ancient property that '
      'saved them — characters record meaning, not merely sound. That is why '
      'a Shanghainese and a Cantonese, whose accents differ like heaven and '
      'earth, write the very same line; and why we can read essays from two '
      'thousand years ago and still smile in recognition.\n'
      'In the end, the vitality of the characters lies precisely in this: '
      'they pack an entire civilization into a square inch.',
  intro:
      'A culture lecture that answers a question you\'ve lived through this '
      'course: why hanzi survived. Full register: 非但…反而, 所谓, 乃在于.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '非但…反而',
      text: '"Not only did it not…, on the contrary it…" — the strongest '
          'reversal frame in the language: 非但没有埋葬汉字，反而给了它新生.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '一百年前，学者们担心什么？',
      options: ['汉字会被拼音文字取代', '没有人学中文', '书太贵'],
      correctIndex: 0,
      questionTranslation: 'What did scholars worry about a century ago?',
    ),
    ReadingQuestion(
      question: '什么给了汉字新生？',
      options: ['计算机', '打字机', '电视'],
      correctIndex: 0,
      questionTranslation: 'What gave the characters new life?',
    ),
    ReadingQuestion(
      question: '讲座认为汉字记录的是什么？',
      options: ['意义', '只是声音', '只是图画'],
      correctIndex: 0,
      questionTranslation: 'What does the lecture say characters record?',
    ),
  ],
);

final QuizContent enZhC22DictEditorial = enZhDict(
  id: 'en_zh_c2_2_dict_editorial',
  title: 'Dictation: 一段社论',
  intro:
      'The final dictation: editorial-register sentences at broadcast pace. '
      'Everything you\'ve trained — register, idiom, cohesion — lands here.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hold the clause, not the word',
      text: 'At this length, type clause by clause from memory. Your grammar '
          'now predicts the words — trust it, then verify the characters.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'To sum up, reform will not happen overnight. (一蹴而就)', answer: '综上所述，改革不可能一蹴而就。'),
    CourseItem(prompt: 'Rather than treat the symptoms, better to address the root. (治标/治本)', answer: '与其治标，不如治本。'),
    CourseItem(prompt: 'The so-called shortcut is often the longest road.', answer: '所谓捷径，往往是最长的路。'),
    CourseItem(prompt: 'Public trust is easy to shatter and hard to mend.', answer: '公众的信任打碎容易，修复极难。'),
    CourseItem(prompt: 'In the final analysis, this is precisely a question of choice.', answer: '归根结底，这乃是一个选择问题。'),
  ],
);

final QuizContent enZhC22ReadStory = enZhRead(
  id: 'en_zh_c2_2_read_story',
  title: 'Reading: 分析一篇短篇小说',
  passageTitle: '《修表匠》（微型小说）+ 短评',
  passage:
      '【微型小说：修表匠】\n'
      '老周修了四十年表。铺子小得转不开身，墙上却挂满了钟，'
      '每一只都走得分毫不差。\n'
      '如今来修表的人少了。年轻人看时间用手机，"手表？那是装饰品。"\n'
      '这天，一个姑娘拿来一只旧上海牌手表："我爷爷的。走不了了，'
      '师傅您看还有救吗？"\n'
      '老周戴上放大镜，拆开表壳，看了很久。'
      '"零件早就不产了。"他说。姑娘的眼圈红了。\n'
      '"不过，"老周从抽屉最里面摸出一个小铁盒，"我这儿还存着最后一套。"\n'
      '表修好了。姑娘问多少钱，老周摆摆手："我只收修表的钱——'
      '零件不要钱。它等这只表，等了二十年了。"\n\n'
      '【短评】\n'
      '小说不足三百字，却写尽了一个时代。结尾一句是全篇之眼：'
      '等待的不是零件，而是老周自己——等一个还需要他的人。'
      '作者不写一个"惨"字，而失落自现；不写一个"暖"字，而温情自见。'
      '所谓留白，此之谓也。',
  passageTranslation:
      '[Flash fiction: The Watch Mender]\n'
      'Old Zhou has mended watches for forty years. His shop is too small to '
      'turn around in, yet the walls are covered with clocks, every one '
      'keeping perfect time.\n'
      'Few come to mend watches now. The young check their phones: "A watch? '
      'That\'s jewellery."\n'
      'One day a girl brings in an old Shanghai-brand watch: "My '
      'grandfather\'s. It\'s stopped — master, can it be saved?"\n'
      'Old Zhou puts on his loupe, opens the case, looks a long while. "The '
      'parts went out of production years ago," he says. The girl\'s eyes '
      'redden.\n'
      '"However —" Old Zhou reaches into the back of a drawer and brings out '
      'a small tin box, "I still keep one last set."\n'
      'The watch is mended. The girl asks the price. Old Zhou waves a hand: '
      '"I charge only for the mending — the parts are free. They\'ve been '
      'waiting for this watch for twenty years."\n\n'
      '[Brief commentary]\n'
      'In under three hundred characters, the story writes out an entire '
      'era. The final line is the eye of the piece: what waited was not the '
      'parts but Old Zhou himself — waiting for someone who still needed '
      'him. The author writes no word for "sad", yet the loss shows itself; '
      'no word for "warm", yet the tenderness appears. This is what is meant '
      'by leaving blank space.',
  intro:
      'A complete flash story plus a critic\'s note — fiction and analysis in '
      'one sitting. Watch how the commentary reads meaning the story never '
      'states.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '留白 — the unpainted space',
      text: 'From ink painting: what\'s left blank carries the feeling. The '
          'critic\'s 不写一个"惨"字，而失落自现 is the C2 reading skill — '
          'hearing what the text declines to say.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '姑娘拿来的是什么表？',
      options: ['她爷爷的旧上海牌手表', '一只新手表', '一个闹钟'],
      correctIndex: 0,
      questionTranslation: 'What watch does the girl bring?',
    ),
    ReadingQuestion(
      question: '短评认为，"等了二十年"的其实是谁？',
      options: ['老周自己', '零件', '姑娘'],
      correctIndex: 0,
      questionTranslation: 'According to the commentary, who was really waiting twenty years?',
    ),
    ReadingQuestion(
      question: '"留白"在这里指什么？',
      options: ['不直说而让感情自己显现', '纸上留下空白', '写得越少越好'],
      correctIndex: 0,
      questionTranslation: 'What does "leaving blank space" mean here?',
    ),
  ],
);

final QuizContent enZhC22ReadCapstone = enZhRead(
  id: 'en_zh_c2_2_read_capstone',
  title: 'Reading: capstone — 一篇长篇特稿',
  passageTitle: '特稿：横渡者',
  passage:
      '凌晨四点半，五十八岁的陈建国站在江边，把毛巾叠好，放进塑料袋。'
      '江水是黑的，只有对岸的灯，在水面上拉出几道细长的金线。\n'
      '他游这条江，游了四十年。\n'
      '一九八五年，他第一次横渡，是为了省两分钱的轮渡钱。'
      '那时他在对岸的纺织厂上班，一个月工资三十六块。'
      '"游过去，一个月能省下一块二，够给我娘买两斤猪肉。"\n'
      '后来工厂倒了，轮渡停了，江上架起了三座大桥。'
      '地铁从江底穿过，八分钟一班。谁还需要游过去呢？\n'
      '可他还在游。\n'
      '"有人问我，桥都修好了，你游它干什么？"陈建国笑了，'
      '"我说，你们坐地铁，是为了到对岸去。我下水，不是为了对岸。"\n'
      '医生说他的心脏比四十岁的人还好。老伴儿说他犟。'
      '儿子在深圳，视频里劝了十年："爸，危险。"'
      '他嘴上答应着，第二天四点半，闹钟一响，又拎起了塑料袋。\n'
      '这些年，江水见过他结婚，见过他下岗，见过他送走母亲。'
      '水凉的时候，他知道秋天到了；水里漂着柳絮，他知道又是一年春天。'
      '"这条江认识我，"他说这话的时候，天边刚刚发白，'
      '"它比谁都清楚，我这一辈子，没偷过懒。"\n'
      '五点整，他下水了。黑色的江面安静地裂开一道口子，又慢慢合上。'
      '对岸的灯一盏一盏地熄灭，城市醒了。',
  passageTranslation:
      'Feature: The Crosser\n'
      'At half past four in the morning, 58-year-old Chen Jianguo stands at '
      'the river\'s edge, folds his towel and puts it in a plastic bag. The '
      'water is black; only the lights of the far bank pull thin gold '
      'threads across the surface.\n'
      'He has swum this river for forty years.\n'
      'His first crossing, in 1985, was to save the two-cent ferry fare. He '
      'worked then in the textile mill on the far side, at 36 yuan a month. '
      '"Swimming across saved one yuan twenty a month — enough to buy my '
      'mother two catties of pork."\n'
      'Later the mill closed, the ferry stopped, three great bridges rose '
      'over the river. The metro runs beneath it, every eight minutes. Who '
      'still needs to swim across?\n'
      'Yet he still swims.\n'
      '"People ask me — the bridges are built, what do you swim for?" Chen '
      'laughs. "I tell them: you ride the metro to reach the far bank. I '
      'don\'t get in the water for the far bank."\n'
      'The doctor says his heart is younger than a forty-year-old\'s. His '
      'wife says he\'s stubborn. His son in Shenzhen has spent ten years '
      'urging over video calls: "Dad, it\'s dangerous." He agrees out loud — '
      'and the next morning at 4:30, when the alarm rings, picks up the '
      'plastic bag again.\n'
      'Over the years the river has seen him marry, seen him laid off, seen '
      'him bury his mother. When the water turns cold he knows autumn has '
      'come; when willow catkins drift on it, another spring. "This river '
      'knows me," he says, as the horizon just begins to pale. "It knows '
      'better than anyone that in this life of mine, I never once slacked."\n'
      'At five sharp he enters the water. The black surface quietly splits '
      'open a seam, then slowly closes. On the far bank the lights go out '
      'one by one. The city wakes.',
  intro:
      'The capstone read: a full-length feature in literary-journalistic '
      'style. No questions about grammar now — only about meaning, structure '
      'and what\'s left unsaid.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Read it twice',
      text: 'Once for the man, once for the craft: the numbers doing '
          'emotional work (两分钱, 三十六块), the refrain 可他还在游, and an '
          'ending that answers the question without answering it.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '陈建国一九八五年为什么横渡？',
      options: ['为了省轮渡钱', '为了锻炼身体', '为了比赛'],
      correctIndex: 0,
      questionTranslation: 'Why did Chen first swim across in 1985?',
    ),
    ReadingQuestion(
      question: '"我下水，不是为了对岸"是什么意思？',
      options: ['游泳本身就是他生活的意义', '他不会游到对岸', '他讨厌对岸'],
      correctIndex: 0,
      questionTranslation: 'What does "I don\'t get in the water for the far bank" mean?',
    ),
    ReadingQuestion(
      question: '文章的结尾写城市醒了，有什么作用？',
      options: ['把一个人的坚持放回大时代的背景里', '说明天气很好', '表示故事没写完'],
      correctIndex: 0,
      questionTranslation: 'What does the closing image of the waking city do?',
    ),
  ],
);

final QuizContent enZhC22SpeakCapstone = enZhSpeak(
  id: 'en_zh_c2_2_speak_capstone',
  title: 'Speaking: capstone — your view',
  intro:
      'The last exercise of the course: a complete, structured spoken '
      'position on a complex issue — every register tool in play. Then go '
      'find a real person to argue with. 加油！',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'You\'ve built the whole ladder',
      text: 'Tones → 是 → 了 → 把 → 书面语 → irony. This speech uses all of '
          'it. Record yourself, compare with the model, and notice how far '
          '从"你好"到这里 you\'ve come.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Rúguǒ yǒu rén wèn wǒ, xué Zhōngwén zuì nán de shì shénme… — If someone asks me what\'s hardest about learning Chinese…', answer: '如果有人问我，学中文最难的是什么，我不会说是声调，也不会说是汉字。'),
    CourseItem(prompt: 'Zuì nán de, shì gǎnyú kāikǒu — cóng nǐ hǎo kāishǐ. — The hardest is daring to speak — starting from "nǐ hǎo".', answer: '最难的，是敢于开口——从"你好"开始。'),
    CourseItem(prompt: 'Yǔyán bú shì zhīshi, ér shì yì tiáo yào yóu guòqù de jiāng. — A language is not knowledge but a river to be swum.', answer: '语言不是知识，而是一条要游过去的江。'),
    CourseItem(prompt: 'Qiáo zài duō, yě dài tì bù liǎo zìjǐ xià shuǐ. — However many the bridges, they can\'t replace entering the water yourself.', answer: '桥再多，也代替不了自己下水。'),
    CourseItem(prompt: 'Suǒwèi jīngtōng, búguò shì měitiān dōu yuànyì zài xià yí cì shuǐ éryǐ. — So-called mastery is merely being willing to enter the water again, every day.', answer: '所谓精通，不过是每天都愿意再下一次水而已。'),
  ],
);

/// C2.2 in chain order (capstone: three readings, three speakings).
final List<QuizContent> enZhC2_2 = [
  enZhC22Wenyan,
  enZhC22Cohesion,
  enZhC22SpeakSpeech,
  enZhC22Weighing,
  enZhC22ListenDebate,
  enZhC22Allusion,
  enZhC22ReadAnalysis,
  enZhC22Natural,
  enZhC22Irony,
  enZhC22SpeakRebuttal,
  enZhC22ListenCulture,
  enZhC22DictEditorial,
  enZhC22ReadStory,
  enZhC22ReadCapstone,
  enZhC22SpeakCapstone,
];
