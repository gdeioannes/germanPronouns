import '../../../models/quiz_content.dart';
import 'en_zh_builder.dart';

/// C1.1 — Precision & Nuance · 精确与辨析 (HSK 5). English → Mandarin.
///
/// Big rocks: near-synonym discrimination (the HSK 5 signature skill), formal
/// causatives 使/令, the formal preposition set 对/对于/关于/由于 (Z29), first
/// 成语 (Z30), and word-building with 化/性/主义 (Z7 as a bridge at scale).

final QuizContent enZhC11Synonyms1 = enZhFill(
  id: 'en_zh_c1_1_synonyms_1',
  title: 'Near-synonyms I: 帮助/帮忙, 突然/忽然',
  intro:
      'HSK 5 lives on pairs that translate identically but behave '
      'differently: one takes an object, the other splits; one is an '
      'adjective too, the other only an adverb.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Test the grammar, not the gloss',
      text: '帮助 + person (帮助我); 帮忙 splits and takes none (帮我一个忙). '
          '突然 can be an adjective (很突然); 忽然 only ever an adverb. The '
          'dictionary meaning is the same — the syntax isn\'t.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'More pairs on this shelf',
      text: '常常 (often, habits) vs 往往 (tends to, patterns + conditions); '
          '一定 (must/surely) vs 肯定 (certainly, can be a verb: 我肯定…).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Thank you for helping me. (takes object)', answer: '谢谢你**帮助**我。', accepted: ['bāngzhù'], hint: 'xièxie nǐ bāngzhù wǒ'),
    CourseItem(prompt: 'Could you do me a favour? (splits: 帮…忙)', answer: '你能帮我一个**忙**吗？', accepted: ['máng'], hint: 'nǐ néng bāng wǒ yí ge máng ma'),
    CourseItem(prompt: 'His decision was very sudden. (adjective slot!)', answer: '他的决定很**突然**。', accepted: ['tūrán'], hint: 'tā de juédìng hěn tūrán'),
    CourseItem(prompt: 'Suddenly it started to rain. (adverb — either works, 忽然 is safest)', answer: '**忽然**下起雨来了。', accepted: ['hūrán', '突然', 'tūrán'], hint: 'hūrán xià qǐ yǔ lái le'),
    CourseItem(prompt: 'People here tend to sleep late. (pattern → 往往)', answer: '这里的人**往往**睡得很晚。', accepted: ['wǎngwǎng'], hint: 'zhèlǐ de rén wǎngwǎng shuì de hěn wǎn'),
    CourseItem(prompt: 'I often go to the library. (habit → 常常)', answer: '我**常常**去图书馆。', accepted: ['chángcháng'], hint: 'wǒ chángcháng qù túshūguǎn'),
    CourseItem(prompt: 'I must (surely) finish it today. (一定)', answer: '我今天**一定**要做完。', accepted: ['yídìng'], hint: 'wǒ jīntiān yídìng yào zuò wán'),
    CourseItem(prompt: 'He will certainly come. (肯定)', answer: '他**肯定**会来。', accepted: ['kěndìng'], hint: 'tā kěndìng huì lái'),
    CourseItem(prompt: 'Your help matters a lot to me. (帮助 as noun)', answer: '你的**帮助**对我很重要。', accepted: ['bāngzhù'], hint: 'nǐ de bāngzhù duì wǒ hěn zhòngyào'),
    CourseItem(prompt: 'Autumn here tends to be dry. (pattern → 往往)', answer: '这里的秋天**往往**很干燥。', accepted: ['wǎngwǎng'], hint: 'zhèlǐ de qiūtiān wǎngwǎng hěn gānzào'),
    CourseItem(prompt: 'This medicine helped him a lot. (帮助 as verb, takes object)', answer: '这个药**帮助**了他很多。', accepted: ['bāngzhù'], hint: 'zhè ge yào bāngzhù le tā hěn duō'),
    CourseItem(prompt: 'I\'m certain he is right. (肯定 as verb)', answer: '我**肯定**他是对的。', accepted: ['kěndìng'], hint: 'wǒ kěndìng tā shì duì de'),
    CourseItem(prompt: 'Everyone was helping out at his home. (splits: 帮忙)', answer: '大家都在他家**帮忙**。', accepted: ['bāngmáng'], hint: 'dàjiā dōu zài tā jiā bāngmáng'),
    CourseItem(prompt: 'The car suddenly stopped. (adverb — 忽然)', answer: '车**忽然**停了。', accepted: ['hūrán', '突然', 'tūrán'], hint: 'chē hūrán tíng le'),
    CourseItem(prompt: 'Success tends to belong to the persistent. (pattern → 往往)', answer: '成功**往往**属于坚持的人。', accepted: ['wǎngwǎng'], hint: 'chénggōng wǎngwǎng shǔyú jiānchí de rén'),
  ],
);

final QuizContent enZhC11ShiLing = enZhFill(
  id: 'en_zh_c1_1_shi_ling',
  title: 'Formal causatives: 使 / 令 / 让',
  intro:
      'Three ways to make something happen to someone: colloquial 让, formal '
      '使, and 令 for triggered emotions (令人吃惊 — astonishing).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Register picks the causative',
      text: 'Speech: 让 (这让我很高兴). Writing: 使 (这使我们的工作更容易). '
          'Fixed emotional frames: 令人 + feeling (令人失望, 令人感动).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The internet has made life more convenient. (formal)', answer: '互联网**使**生活更方便。', accepted: ['shǐ'], hint: 'hùliánwǎng shǐ shēnghuó gèng fāngbiàn'),
    CourseItem(prompt: 'This news is astonishing. (令人 + astonished)', answer: '这个消息**令人**吃惊。', accepted: ['lìng rén', 'lingren'], hint: 'zhè ge xiāoxi lìng rén chījīng'),
    CourseItem(prompt: 'His answer disappointed everyone. (formal 使)', answer: '他的回答**使**大家很失望。', accepted: ['shǐ'], hint: 'tā de huídá shǐ dàjiā hěn shīwàng'),
    CourseItem(prompt: 'The film was very moving. (令人 + moved)', answer: '这部电影很**令人**感动。', accepted: ['lìng rén'], hint: 'zhè bù diànyǐng hěn lìng rén gǎndòng'),
    CourseItem(prompt: 'This made me change my mind. (spoken register)', answer: '这**让**我改变了主意。', accepted: ['ràng'], hint: 'zhè ràng wǒ gǎibiàn le zhǔyi'),
    CourseItem(prompt: 'This experience made him more confident. (formal 使)', answer: '这次经历**使**他更自信。', accepted: ['shǐ'], hint: 'zhè cì jīnglì shǐ tā gèng zìxìn'),
    CourseItem(prompt: 'The result is disappointing. (令人 + disappointed)', answer: '这个结果**令人**失望。', accepted: ['lìng rén', 'lingren'], hint: 'zhè ge jiéguǒ lìng rén shīwàng'),
    CourseItem(prompt: 'The news made everyone excited. (formal 使)', answer: '这个消息**使**大家很激动。', accepted: ['shǐ'], hint: 'zhè ge xiāoxi shǐ dàjiā hěn jīdòng'),
    CourseItem(prompt: 'His story is moving. (令人 + moved)', answer: '他的故事**令人**感动。', accepted: ['lìng rén'], hint: 'tā de gùshi lìng rén gǎndòng'),
    CourseItem(prompt: 'This made us see the importance of time. (spoken 让)', answer: '这**让**我们明白了时间的重要性。', accepted: ['ràng'], hint: 'zhè ràng wǒmen míngbai le shíjiān de zhòngyàoxìng'),
    CourseItem(prompt: 'Globalization has made the world smaller. (formal 使)', answer: '全球化**使**世界变小了。', accepted: ['shǐ'], hint: 'quánqiúhuà shǐ shìjiè biàn xiǎo le'),
    CourseItem(prompt: 'The scenery there is breathtaking. (令人 + 难忘 unforgettable)', answer: '那里的风景**令人**难忘。', accepted: ['lìng rén', 'lingren'], hint: 'nàlǐ de fēngjǐng lìng rén nánwàng'),
    CourseItem(prompt: 'Reading made her vocabulary richer. (formal 使)', answer: '阅读**使**她的词汇更丰富。', accepted: ['shǐ'], hint: 'yuèdú shǐ tā de cíhuì gèng fēngfù'),
    CourseItem(prompt: 'His attitude is worrying. (令人 + worried)', answer: '他的态度**令人**担心。', accepted: ['lìng rén', 'lingren'], hint: 'tā de tàidù lìng rén dānxīn'),
    CourseItem(prompt: 'The music made everyone relax. (spoken 让)', answer: '音乐**让**大家放松了下来。', accepted: ['ràng'], hint: 'yīnyuè ràng dàjiā fàngsōng le xiàlái'),
  ],
);

final QuizContent enZhC11SpeakOpinion = enZhSpeak(
  id: 'en_zh_c1_1_speak_opinion',
  title: 'Speaking: presenting an opinion',
  intro:
      'The skeleton of a spoken argument: state, support, concede, conclude — '
      'in connected, natural Mandarin.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Signpost, then speak',
      text: '在我看来 / 首先 / 另外 / 总的来说 — plant a signpost at each '
          'turn. Chinese listeners navigate arguments by these markers (Z30).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Zài wǒ kàn lái, zhè ge wèntí bìng bù jiǎndān. — In my view, this problem is by no means simple.', answer: '在我看来，这个问题并不简单。'),
    CourseItem(prompt: 'Shǒuxiān, wǒmen yīnggāi tīng tīng bùtóng de yìjiàn. — First, we should hear different opinions.', answer: '首先，我们应该听听不同的意见。'),
    CourseItem(prompt: 'Lìngwài, zhè yě shì yí ge jīhuì. — Besides, this is also an opportunity.', answer: '另外，这也是一个机会。'),
    CourseItem(prompt: 'Dāngrán, měi ge rén de qíngkuàng bù yíyàng. — Of course, everyone\'s situation differs.', answer: '当然，每个人的情况不一样。'),
    CourseItem(prompt: 'Zǒng de lái shuō, wǒ tóngyì zhè ge kànfǎ. — All in all, I agree with this view.', answer: '总的来说，我同意这个看法。'),
  ],
);

final QuizContent enZhC11Prepositions = enZhFill(
  id: 'en_zh_c1_1_prepositions',
  title: '对 / 对于 / 关于 / 由于',
  intro:
      'The formal coverb set: 对/对于 toward (attitude), 关于 about (topic), '
      '由于 owing to (cause). They frame the sentence before its verb.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Aim, topic, cause (Z29)',
      text: '对(于) aims an attitude at something; 关于 labels the topic '
          '(often fronted or in titles); 由于 gives the formal cause — and '
          'pairs happily with 因此.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I\'m very interested in Chinese history. (aim: 对)', answer: '我**对**中国历史很感兴趣。', accepted: ['duì'], hint: 'wǒ duì Zhōngguó lìshǐ hěn gǎn xìngqù'),
    CourseItem(prompt: 'Regarding this question, everyone\'s views differ. (topic)', answer: '**关于**这个问题，大家的看法不同。', accepted: ['guānyú'], hint: 'guānyú zhè ge wèntí, dàjiā de kànfǎ bùtóng'),
    CourseItem(prompt: 'Owing to the weather, the flight was delayed. (formal cause)', answer: '**由于**天气原因，航班延误了。', accepted: ['yóuyú'], hint: 'yóuyú tiānqì yuányīn, hángbān yánwù le'),
    CourseItem(prompt: 'As for beginners, this book is a bit hard. (对于 + group)', answer: '**对于**初学者来说，这本书有点儿难。', accepted: ['duìyú'], hint: 'duìyú chūxuézhě lái shuō, zhè běn shū yǒudiǎnr nán'),
    CourseItem(prompt: 'He wrote a book about the Silk Road. (topic in a title)', answer: '他写了一本**关于**丝绸之路的书。', accepted: ['guānyú'], hint: 'tā xiě le yì běn guānyú Sīchóu zhī lù de shū'),
    CourseItem(prompt: 'Smoking is harmful to health. (aim: 对…有害)', answer: '吸烟**对**健康有害。', accepted: ['duì'], hint: 'xīyān duì jiànkāng yǒuhài'),
    CourseItem(prompt: 'Owing to health reasons, he resigned. (formal cause)', answer: '**由于**身体原因，他辞职了。', accepted: ['yóuyú'], hint: 'yóuyú shēntǐ yuányīn, tā cízhí le'),
    CourseItem(prompt: 'Regarding tomorrow\'s meeting, does anyone have questions?', answer: '**关于**明天的会议，大家有问题吗？', accepted: ['guānyú'], hint: 'guānyú míngtiān de huìyì, dàjiā yǒu wèntí ma'),
    CourseItem(prompt: 'As for this plan, I have a different view. (对于)', answer: '**对于**这个计划，我有不同的看法。', accepted: ['duìyú'], hint: 'duìyú zhè ge jìhuà, wǒ yǒu bùtóng de kànfǎ'),
    CourseItem(prompt: 'He is very strict with himself. (对自己)', answer: '他**对**自己要求很严格。', accepted: ['duì'], hint: 'tā duì zìjǐ yāoqiú hěn yángé'),
    CourseItem(prompt: 'Owing to the traffic jam, we arrived late. (formal cause)', answer: '**由于**堵车，我们到晚了。', accepted: ['yóuyú'], hint: 'yóuyú dǔchē, wǒmen dào wǎn le'),
    CourseItem(prompt: 'Regarding this history, he knows a lot. (topic)', answer: '**关于**这段历史，他知道很多。', accepted: ['guānyú'], hint: 'guānyú zhè duàn lìshǐ, tā zhīdào hěn duō'),
    CourseItem(prompt: 'This change is very important for young people. (对于…来说)', answer: '**对于**年轻人来说，这个变化很重要。', accepted: ['duìyú'], hint: 'duìyú niánqīngrén lái shuō, zhè ge biànhuà hěn zhòngyào'),
    CourseItem(prompt: 'Exercise is good for the body. (aim: 对…有好处)', answer: '运动**对**身体有好处。', accepted: ['duì'], hint: 'yùndòng duì shēntǐ yǒu hǎochù'),
    CourseItem(prompt: 'Owing to price increases, more people are cooking at home. (formal cause)', answer: '**由于**物价上涨，更多人在家做饭。', accepted: ['yóuyú'], hint: 'yóuyú wùjià shàngzhǎng, gèng duō rén zài jiā zuòfàn'),
  ],
);

final QuizContent enZhC11ListenLecture = enZhListen(
  id: 'en_zh_c1_1_listen_lecture',
  title: 'Listening: 讲座 — 城市化',
  passageTitle: '讲座：城市化的两面',
  passage:
      '各位同学，下午好。今天我们谈谈城市化。\n'
      '过去四十年，中国经历了世界上规模最大的城市化：'
      '几亿人从农村搬进了城市。城市化使经济快速发展，'
      '也使几亿人的生活水平得到了很大的提高。\n'
      '但是，对于城市化，我们不能只看到好的一面。'
      '由于人口增长太快，一些大城市出现了交通拥堵、住房紧张等问题。'
      '另外，很多年轻人进城工作，农村只留下了老人和孩子，'
      '这也是一个令人担心的社会问题。\n'
      '总的来说，城市化既带来了机会，也带来了挑战。'
      '关于怎么解决这些问题，我们下节课继续讨论。',
  passageTranslation:
      'Good afternoon, everyone. Today let\'s talk about urbanization.\n'
      'Over the past forty years, China has gone through the largest '
      'urbanization in the world: hundreds of millions of people moved from '
      'the countryside into cities. Urbanization made the economy grow fast '
      'and greatly raised the living standards of hundreds of millions.\n'
      'But we can\'t see only the good side. Because the population grew too '
      'fast, some big cities developed problems like traffic congestion and '
      'housing shortages. Also, with young people leaving for city jobs, only '
      'the old and the young remain in the villages — a worrying social '
      'problem.\n'
      'All in all, urbanization brings both opportunities and challenges. As '
      'for how to solve these problems — we\'ll continue next class.',
  intro:
      'A university-style lecture: the formal register in action — 使, 由于, '
      '对于, 关于, 令人, 既…也.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '既…也 = both…and (formal)',
      text: '既带来了机会，也带来了挑战 — the written cousin of 又…又, '
          'joining two verb phrases in balanced style (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '过去四十年，中国经历了什么？',
      options: ['世界上规模最大的城市化', '人口减少', '经济变慢'],
      correctIndex: 0,
      questionTranslation: 'What has China gone through in the past forty years?',
    ),
    ReadingQuestion(
      question: '大城市出现了什么问题？',
      options: ['交通拥堵、住房紧张', '没有工作', '天气变冷'],
      correctIndex: 0,
      questionTranslation: 'What problems appeared in big cities?',
    ),
    ReadingQuestion(
      question: '农村留下了谁？',
      options: ['老人和孩子', '年轻人', '大学生'],
      correctIndex: 0,
      questionTranslation: 'Who remains in the villages?',
    ),
  ],
);

final QuizContent enZhC11Chengyu = enZhFill(
  id: 'en_zh_c1_1_chengyu',
  title: 'First 成语',
  intro:
      '成语 are four-character set phrases — compressed stories that educated '
      'Chinese sprinkles everywhere. Start with six you can actually use.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚠️ Unpack the four characters (Z30)',
      text: '入乡随俗 enter-village-follow-customs = when in Rome. 半途而废 '
          'half-road-then-quit = give up halfway. Decode character by '
          'character and the phrase sticks.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Placement matters',
      text: 'Most 成语 slot in as predicates or adverbs: 他做事总是马马虎虎 '
          '(careless). Don\'t force them where a plain word belongs — '
          'sprinkled, not shoveled.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'so-so, careless (horse-horse tiger-tiger)', answer: '马马虎虎', accepted: ['mǎmǎhūhū', 'mǎ mǎ hū hū'], hint: 'mǎmǎhūhū'),
    CourseItem(prompt: 'when in Rome… (enter village, follow customs)', answer: '入乡随俗', accepted: ['rù xiāng suí sú', 'ruxiangsuisu'], hint: 'rù xiāng suí sú'),
    CourseItem(prompt: 'to give up halfway (half-road-then-quit)', answer: '半途而废', accepted: ['bàn tú ér fèi'], hint: 'bàn tú ér fèi'),
    CourseItem(prompt: 'crowded with people (people mountain people sea)', answer: '人山人海', accepted: ['rén shān rén hǎi'], hint: 'rén shān rén hǎi'),
    CourseItem(prompt: 'to improve with each passing day (sun-sun new, moon-moon different)', answer: '日新月异', accepted: ['rì xīn yuè yì'], hint: 'rì xīn yuè yì'),
    CourseItem(prompt: 'Learning Chinese, you must not give up halfway.', answer: '学中文不能**半途而废**。', accepted: ['bàn tú ér fèi'], hint: 'xué Zhōngwén bù néng bàn tú ér fèi'),
    CourseItem(prompt: 'exactly the same (one mould, one pattern)', answer: '一模一样', accepted: ['yì mú yí yàng', 'yimuyiyang'], hint: 'yì mú yí yàng'),
    CourseItem(prompt: 'twice the result with half the effort', answer: '事半功倍', accepted: ['shì bàn gōng bèi'], hint: 'shì bàn gōng bèi'),
    CourseItem(prompt: 'perfect in every way (ten-complete ten-beautiful)', answer: '十全十美', accepted: ['shí quán shí měi'], hint: 'shí quán shí měi'),
    CourseItem(prompt: 'The station was crowded with people. (use the 成语!)', answer: '车站里**人山人海**。', accepted: ['rén shān rén hǎi'], hint: 'chēzhàn li rén shān rén hǎi'),
    CourseItem(prompt: 'The twins look exactly the same. (use the 成语!)', answer: '这对双胞胎长得**一模一样**。', accepted: ['yì mú yí yàng', 'yimuyiyang'], hint: 'zhè duì shuāngbāotāi zhǎng de yì mú yí yàng'),
    CourseItem(prompt: 'With a good method, you get twice the result with half the effort.', answer: '方法好，就能**事半功倍**。', accepted: ['shì bàn gōng bèi'], hint: 'fāngfǎ hǎo, jiù néng shì bàn gōng bèi'),
    CourseItem(prompt: 'Nothing in the world is perfect. (use the 成语!)', answer: '世界上没有**十全十美**的东西。', accepted: ['shí quán shí měi'], hint: 'shìjiè shàng méiyǒu shí quán shí měi de dōngxi'),
    CourseItem(prompt: 'Technology develops with each passing day. (use the 成语!)', answer: '科技发展**日新月异**。', accepted: ['rì xīn yuè yì'], hint: 'kējì fāzhǎn rì xīn yuè yì'),
    CourseItem(prompt: 'Abroad, one should follow local customs. (use the 成语!)', answer: '在国外要**入乡随俗**。', accepted: ['rù xiāng suí sú', 'ruxiangsuisu'], hint: 'zài guówài yào rù xiāng suí sú'),
  ],
);

final QuizContent enZhC11Attributives = enZhFill(
  id: 'en_zh_c1_1_attributives',
  title: 'Long attributives: the 的-chain',
  intro:
      'Formal Chinese stacks whole layers before a noun: 一个对中国文化非常'
      '感兴趣的英国学生 — an English student deeply interested in Chinese '
      'culture. Build them layer by layer.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Order inside the stack (Z19)',
      text: 'Possessor → demonstrative+MW → clauses/phrases → adjectives → '
          'noun: 我昨天认识的那位年轻的中国记者. When it gets heavy, one 的 '
          'near the noun can carry several layers.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'an English student who is deeply interested in Chinese culture', answer: '一个对中国文化非常感兴趣**的**英国学生', accepted: ['de'], hint: 'yí ge duì Zhōngguó wénhuà fēicháng gǎn xìngqù de Yīngguó xuésheng'),
    CourseItem(prompt: 'that young journalist I met yesterday', answer: '我昨天认识的**那位**年轻记者', accepted: ['nà wèi'], hint: 'wǒ zuótiān rènshi de nà wèi niánqīng jìzhě'),
    CourseItem(prompt: 'the ability to solve problems (solve-problem 的 ability)', answer: '解决问题**的**能力', accepted: ['de'], hint: 'jiějué wèntí de nénglì'),
    CourseItem(prompt: 'people who were born and grew up in the city', answer: '在城市出生、长大**的**人', accepted: ['de'], hint: 'zài chéngshì chūshēng, zhǎngdà de rén'),
    CourseItem(prompt: 'an unforgettable experience (make-people-unable-to-forget)', answer: '一次令人难忘**的**经历', accepted: ['de'], hint: 'yí cì lìng rén nánwàng de jīnglì'),
    CourseItem(prompt: 'the habit of getting up early', answer: '早起**的**习惯', accepted: ['de'], hint: 'zǎo qǐ de xíguàn'),
    CourseItem(prompt: 'a question that is hard to answer', answer: '一个很难回答**的**问题', accepted: ['de'], hint: 'yí ge hěn nán huídá de wèntí'),
    CourseItem(prompt: 'that Chinese friend who once helped me', answer: '帮助过我的**那位**中国朋友', accepted: ['nà wèi'], hint: 'bāngzhù guo wǒ de nà wèi Zhōngguó péngyou'),
    CourseItem(prompt: 'the opportunity to study abroad', answer: '出国学习**的**机会', accepted: ['de'], hint: 'chūguó xuéxí de jīhuì'),
    CourseItem(prompt: 'the best restaurant in the city', answer: '城里最好**的**饭馆', accepted: ['de'], hint: 'chéng li zuì hǎo de fànguǎn'),
    CourseItem(prompt: 'a friend I can trust (值得信任)', answer: '一个值得信任**的**朋友', accepted: ['de'], hint: 'yí ge zhídé xìnrèn de péngyou'),
    CourseItem(prompt: 'the reason why he resigned (辞职的原因)', answer: '他辞职**的**原因', accepted: ['de'], hint: 'tā cízhí de yuányīn'),
    CourseItem(prompt: 'that big city I have never been to', answer: '我从来没去过的**那个**大城市', accepted: ['nà ge', 'nàge'], hint: 'wǒ cónglái méi qù guo de nà ge dà chéngshì'),
    CourseItem(prompt: 'the courage to admit mistakes (承认错误)', answer: '承认错误**的**勇气', accepted: ['de'], hint: 'chéngrèn cuòwù de yǒngqì'),
    CourseItem(prompt: 'a job that suits young people (适合)', answer: '一份适合年轻人**的**工作', accepted: ['de'], hint: 'yí fèn shìhé niánqīngrén de gōngzuò'),
  ],
);

final QuizContent enZhC11ReadTech = enZhRead(
  id: 'en_zh_c1_1_read_tech',
  title: 'Reading: 科技与生活',
  passageTitle: '科技改变生活',
  passage:
      '过去十年，科技使我们的生活发生了巨大的变化。'
      '移动支付让钱包成为历史；网上购物使人们足不出户就能买到世界各地的商品；'
      '人工智能则开始进入医院、学校和家庭。\n'
      '对于这些变化，人们的态度并不相同。'
      '支持者认为，科技提高了效率，使更多人享受到了方便的服务。'
      '由于看病可以网上挂号，农村的病人再也不用半夜排队了。\n'
      '但也有人担心：老人学不会用智能手机，反而被新技术挡在了门外；'
      '年轻人越来越依赖手机，面对面的交流却越来越少。\n'
      '关于科技，也许最重要的问题不是"它能做什么"，'
      '而是"我们想让它为我们做什么"。技术本身没有好坏，'
      '使用它的方式才决定它的价值。',
  passageTranslation:
      'Over the past decade, technology has transformed our lives. Mobile '
      'payment made wallets history; online shopping lets people buy goods '
      'from all over the world without leaving home; and artificial '
      'intelligence is entering hospitals, schools and homes.\n'
      'Attitudes toward these changes differ. Supporters argue technology '
      'raises efficiency and brings convenient services to more people. '
      'Since hospital registration works online now, rural patients no '
      'longer queue at midnight.\n'
      'But others worry: elderly people who can\'t master smartphones end up '
      'shut out by the new technology, and the young grow ever more dependent '
      'on their phones while face-to-face conversation shrinks.\n'
      'Perhaps the most important question about technology is not "what can '
      'it do" but "what do we want it to do for us". Technology itself is '
      'neither good nor bad — how we use it decides its value.',
  intro:
      'An HSK-5-style essay: balanced argument, formal frames (使, 对于, '
      '由于, 关于, 则, 反而), and a quotable conclusion.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '反而 = contrary to expectation',
      text: '老人…反而被挡在门外 — instead (of being helped), they\'re shut '
          'out. 反而 flags an outcome that flips what the setup promised.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '移动支付让什么成为历史？',
      options: ['钱包', '手机', '医院'],
      correctIndex: 0,
      questionTranslation: 'What did mobile payment make history?',
    ),
    ReadingQuestion(
      question: '有人担心谁被新技术挡在门外？',
      options: ['老人', '年轻人', '学生'],
      correctIndex: 0,
      questionTranslation: 'Who do some worry is shut out by new technology?',
    ),
    ReadingQuestion(
      question: '文章认为，什么决定技术的价值？',
      options: ['使用它的方式', '它的价格', '它的速度'],
      correctIndex: 0,
      questionTranslation: 'According to the essay, what decides technology\'s value?',
    ),
  ],
);

final QuizContent enZhC11Jiran = enZhFill(
  id: 'en_zh_c1_1_jiran',
  title: '既然 / 否则 / …的话',
  intro:
      'Reasoning tools: 既然…就 (since it\'s the case…), 否则 (otherwise), '
      'and the soft conditional tail …的话.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '既然 ≠ 因为 (Z25)',
      text: '因为 gives a cause; 既然 leans on a fact both sides already '
          'accept: 既然你来了，就坐下吧 — since you\'re here anyway. It '
          'still wants its 就/也.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Since you\'re here, (then) stay for dinner.', answer: '**既然**你来了，就留下来吃饭吧。', accepted: ['jìrán'], hint: 'jìrán nǐ lái le, jiù liú xiàlái chīfàn ba'),
    CourseItem(prompt: 'Leave now — otherwise you\'ll be late.', answer: '现在就走，**否则**你会迟到。', accepted: ['fǒuzé'], hint: 'xiànzài jiù zǒu, fǒuzé nǐ huì chídào'),
    CourseItem(prompt: 'If you have time (…的话), give me a call.', answer: '有时间**的话**，给我打个电话。', accepted: ['de huà', 'dehua'], hint: 'yǒu shíjiān de huà, gěi wǒ dǎ ge diànhuà'),
    CourseItem(prompt: 'Since you don\'t like it, (then) why did you buy it?', answer: '既然不喜欢，**就**别买了。', accepted: ['jiù'], hint: 'jìrán bù xǐhuan, jiù bié mǎi le'),
    CourseItem(prompt: 'Book early — otherwise there\'ll be no tickets.', answer: '早点儿订票，**否则**就没有票了。', accepted: ['fǒuzé'], hint: 'zǎodiǎnr dìng piào, fǒuzé jiù méiyǒu piào le'),
    CourseItem(prompt: 'Since it\'s raining, (then) let\'s stay home.', answer: '**既然**下雨了，我们就在家吧。', accepted: ['jìrán'], hint: 'jìrán xià yǔ le, wǒmen jiù zài jiā ba'),
    CourseItem(prompt: 'Hurry — otherwise we\'ll miss the train.', answer: '快点儿，**否则**我们会赶不上火车。', accepted: ['fǒuzé'], hint: 'kuài diǎnr, fǒuzé wǒmen huì gǎn bu shàng huǒchē'),
    CourseItem(prompt: 'If you\'re not busy (…的话), come with us.', answer: '你不忙**的话**，就跟我们一起去吧。', accepted: ['de huà', 'dehua'], hint: 'nǐ bù máng de huà, jiù gēn wǒmen yìqǐ qù ba'),
    CourseItem(prompt: 'Since you know you\'re wrong, (then) apologize. (道歉)', answer: '既然知道错了，**就**道歉吧。', accepted: ['jiù'], hint: 'jìrán zhīdào cuò le, jiù dàoqiàn ba'),
    CourseItem(prompt: 'Wear more clothes — otherwise you\'ll catch a cold.', answer: '多穿点儿衣服，**否则**会感冒。', accepted: ['fǒuzé'], hint: 'duō chuān diǎnr yīfu, fǒuzé huì gǎnmào'),
    CourseItem(prompt: 'Since everyone agrees, (then) let\'s decide it this way.', answer: '**既然**大家都同意，就这么决定吧。', accepted: ['jìrán'], hint: 'jìrán dàjiā dōu tóngyì, jiù zhème juédìng ba'),
    CourseItem(prompt: 'If it\'s convenient for you (…的话), let\'s meet tomorrow.', answer: '你方便**的话**，我们明天见面吧。', accepted: ['de huà', 'dehua'], hint: 'nǐ fāngbiàn de huà, wǒmen míngtiān jiànmiàn ba'),
    CourseItem(prompt: 'Take notes — otherwise you\'ll forget.', answer: '记下来，**否则**你会忘的。', accepted: ['fǒuzé'], hint: 'jì xiàlái, fǒuzé nǐ huì wàng de'),
    CourseItem(prompt: 'Since you\'ve started, (then) see it through. (坚持到底)', answer: '既然开始了，**就**坚持到底吧。', accepted: ['jiù'], hint: 'jìrán kāishǐ le, jiù jiānchí dàodǐ ba'),
    CourseItem(prompt: 'If it rains (…的话), the activity moves indoors. (改在室内)', answer: '下雨**的话**，活动改在室内。', accepted: ['de huà', 'dehua'], hint: 'xià yǔ de huà, huódòng gǎi zài shìnèi'),
  ],
);

final QuizContent enZhC11WordBuilding = enZhFill(
  id: 'en_zh_c1_1_word_building',
  title: 'Word-building: 化 / 性 / 主义',
  intro:
      'Three suffixes unlock hundreds of abstract words: 化 -ization '
      '(现代化), 性 -ness/-ity (重要性), 主义 -ism (乐观主义).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Abstract Lego (Z7)',
      text: '全球 globe + 化 = globalization; 可能 possible + 性 = '
          'possibility; 现实 reality + 主义 = realism. Spot the suffix, '
          'decode the stem — free vocabulary at C1 scale.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'modernization (modern + -ize)', answer: '现代化', accepted: ['xiàndàihuà'], hint: 'xiàndàihuà'),
    CourseItem(prompt: 'globalization', answer: '全球化', accepted: ['quánqiúhuà'], hint: 'quánqiúhuà'),
    CourseItem(prompt: 'importance (important + -ness)', answer: '重要性', accepted: ['zhòngyàoxìng'], hint: 'zhòngyàoxìng'),
    CourseItem(prompt: 'possibility', answer: '可能性', accepted: ['kěnéngxìng'], hint: 'kěnéngxìng'),
    CourseItem(prompt: 'optimism (optimistic + -ism)', answer: '乐观主义', accepted: ['lèguān zhǔyì'], hint: 'lèguān zhǔyì'),
    CourseItem(prompt: 'Urbanization changed the countryside. (city + 化)', answer: '**城市化**改变了农村。', accepted: ['chéngshìhuà'], hint: 'chéngshìhuà gǎibiàn le nóngcūn'),
    CourseItem(prompt: 'informatization (information + -ize)', answer: '信息化', accepted: ['xìnxīhuà'], hint: 'xìnxīhuà'),
    CourseItem(prompt: 'creativity (create + -ness)', answer: '创造性', accepted: ['chuàngzàoxìng'], hint: 'chuàngzàoxìng'),
    CourseItem(prompt: 'safety / security (safe + -ness)', answer: '安全性', accepted: ['ānquánxìng'], hint: 'ānquánxìng'),
    CourseItem(prompt: 'realism (reality + -ism)', answer: '现实主义', accepted: ['xiànshí zhǔyì'], hint: 'xiànshí zhǔyì'),
    CourseItem(prompt: 'digitization (digital + -ize)', answer: '数字化', accepted: ['shùzìhuà'], hint: 'shùzìhuà'),
    CourseItem(prompt: 'necessity (necessary + -ness)', answer: '必要性', accepted: ['bìyàoxìng'], hint: 'bìyàoxìng'),
    CourseItem(prompt: 'aging (of society: old-age + 化)', answer: '老龄化', accepted: ['lǎolínghuà'], hint: 'lǎolínghuà'),
    CourseItem(prompt: 'diversity (many-sort + -ness)', answer: '多样性', accepted: ['duōyàngxìng'], hint: 'duōyàngxìng'),
    CourseItem(prompt: 'individualism (individual + -ism)', answer: '个人主义', accepted: ['gèrén zhǔyì'], hint: 'gèrén zhǔyì'),
  ],
);

final QuizContent enZhC11SpeakFormal = enZhSpeak(
  id: 'en_zh_c1_1_speak_formal',
  title: 'Speaking: formal register delivery',
  intro:
      'Formal Mandarin is slower, evenly paced, fully toned — no swallowed '
      'syllables. Deliver these like a presenter.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Formal = full syllables (Z30)',
      text: 'Casual speech reduces; formal speech pronounces. Every 的, 了, '
          '性 gets its full beat. Slow is not unnatural here — it\'s the '
          'register.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Gèwèi lǎoshī, gèwèi tóngxué, dàjiā hǎo. — Teachers, fellow students: hello.', answer: '各位老师，各位同学，大家好。'),
    CourseItem(prompt: 'Jīntiān wǒ xiǎng tán tán kējì duì shēnghuó de yǐngxiǎng. — Today I\'d like to discuss technology\'s influence on life.', answer: '今天我想谈谈科技对生活的影响。'),
    CourseItem(prompt: 'Yóuyú shíjiān yǒuxiàn, wǒ zhǐ shuō sān diǎn. — As time is limited, I\'ll make three points.', answer: '由于时间有限，我只说三点。'),
    CourseItem(prompt: 'Zhè ge wèntí de zhòngyàoxìng bùyán\'éryù. — The importance of this issue goes without saying.', answer: '这个问题的重要性不言而喻。'),
    CourseItem(prompt: 'Xièxie dàjiā de qīngtīng. — Thank you all for listening.', answer: '谢谢大家的倾听。'),
  ],
);

final QuizContent enZhC11Collocations = enZhFill(
  id: 'en_zh_c1_1_collocations',
  title: 'Collocations: 取得 / 产生 / 造成',
  intro:
      'Formal verbs choose their nouns: 取得 progress/success, 产生 influence/'
      'interest, 造成 problems/losses (bad outcomes only).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ 造成 only breaks things',
      text: '造成损失/问题/污染 ✓ — 造成进步 ✗. Good outcomes are 取得 or '
          '带来. Collocation, not grammar, is what sounds native at C1.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'to make (achieve) great progress', answer: '**取得**很大的进步', accepted: ['qǔdé'], hint: 'qǔdé hěn dà de jìnbù'),
    CourseItem(prompt: 'to have (generate) a deep influence', answer: '**产生**深刻的影响', accepted: ['chǎnshēng'], hint: 'chǎnshēng shēnkè de yǐngxiǎng'),
    CourseItem(prompt: 'to cause serious losses (bad!)', answer: '**造成**严重的损失', accepted: ['zàochéng'], hint: 'zàochéng yánzhòng de sǔnshī'),
    CourseItem(prompt: 'to develop (generate) an interest in music', answer: '对音乐**产生**了兴趣', accepted: ['chǎnshēng'], hint: 'duì yīnyuè chǎnshēng le xìngqù'),
    CourseItem(prompt: 'The storm caused traffic problems.', answer: '暴雨**造成**了交通问题。', accepted: ['zàochéng'], hint: 'bàoyǔ zàochéng le jiāotōng wèntí'),
    CourseItem(prompt: 'She achieved excellent results (成绩).', answer: '她**取得**了很好的成绩。', accepted: ['qǔdé'], hint: 'tā qǔdé le hěn hǎo de chéngjì'),
    CourseItem(prompt: 'to achieve success', answer: '**取得**成功', accepted: ['qǔdé'], hint: 'qǔdé chénggōng'),
    CourseItem(prompt: 'to give rise to a misunderstanding (误会)', answer: '**产生**误会', accepted: ['chǎnshēng'], hint: 'chǎnshēng wùhuì'),
    CourseItem(prompt: 'to cause air pollution (污染 — bad!)', answer: '**造成**空气污染', accepted: ['zàochéng'], hint: 'zàochéng kōngqì wūrǎn'),
    CourseItem(prompt: 'This mistake caused big trouble. (麻烦)', answer: '这个错误**造成**了很大的麻烦。', accepted: ['zàochéng'], hint: 'zhè ge cuòwù zàochéng le hěn dà de máfan'),
    CourseItem(prompt: 'to achieve progress in the negotiations (谈判)', answer: '在谈判中**取得**进展', accepted: ['qǔdé'], hint: 'zài tánpàn zhōng qǔdé jìnzhǎn'),
    CourseItem(prompt: 'His words gave rise to doubts. (怀疑)', answer: '他的话**产生**了怀疑。', accepted: ['chǎnshēng'], hint: 'tā de huà chǎnshēng le huáiyí'),
    CourseItem(prompt: 'The heavy snow caused flight delays. (bad!)', answer: '大雪**造成**了航班延误。', accepted: ['zàochéng'], hint: 'dà xuě zàochéng le hángbān yánwù'),
    CourseItem(prompt: 'to gain everyone\'s trust (信任)', answer: '**取得**大家的信任', accepted: ['qǔdé'], hint: 'qǔdé dàjiā de xìnrèn'),
    CourseItem(prompt: 'This experience generated a positive influence on him.', answer: '这段经历对他**产生**了积极的影响。', accepted: ['chǎnshēng'], hint: 'zhè duàn jīnglì duì tā chǎnshēng le jījí de yǐngxiǎng'),
  ],
);

final QuizContent enZhC11ListenEnvironment = enZhListen(
  id: 'en_zh_c1_1_listen_environment',
  title: 'Listening: 访谈 — 环境',
  passageTitle: '访谈：一位环保工作者',
  passage:
      '记者："李老师，您做环保工作二十年了。在您看来，最大的变化是什么？"\n'
      '李老师："最大的变化是人们的态度。二十年前，很多人觉得环保跟自己没关系。'
      '现在，垃圾分类、少用塑料袋，已经成了很多家庭的习惯。"\n'
      '记者："那么，最让您担心的问题是什么？"\n'
      '李老师："是速度。经济发展得越快，对环境的压力就越大。'
      '如果我们只顾眼前的利益，就会给下一代造成无法挽回的损失。"\n'
      '记者："对于普通人，您有什么建议？"\n'
      '李老师："从小事做起。既然改变世界很难，那就先改变自己的生活方式。"',
  passageTranslation:
      'Reporter: "Teacher Li, you\'ve worked in environmental protection for '
      'twenty years. In your view, what\'s the biggest change?"\n'
      'Li: "The biggest change is people\'s attitude. Twenty years ago, many '
      'felt the environment had nothing to do with them. Now sorting waste '
      'and cutting plastic bags are habits in many households."\n'
      'Reporter: "And what worries you most?"\n'
      'Li: "Speed. The faster the economy grows, the greater the pressure on '
      'the environment. If we only mind immediate gains, we\'ll cause the '
      'next generation irreversible losses."\n'
      'Reporter: "Any advice for ordinary people?"\n'
      'Li: "Start small. Since changing the world is hard, first change your '
      'own way of living."',
  intro:
      'An interview in educated, natural register — 越…越, 造成, 既然, and '
      'the rhetoric of advice.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '从小事做起',
      text: '"Start from the small things" — 从 X 做起 is a set frame for '
          'advice; you\'ll meet it in every Chinese speech about change.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '李老师觉得最大的变化是什么？',
      options: ['人们的态度', '天气', '经济'],
      correctIndex: 0,
      questionTranslation: 'What does Li see as the biggest change?',
    ),
    ReadingQuestion(
      question: '最让李老师担心的是什么？',
      options: ['发展的速度', '塑料袋', '垃圾分类'],
      correctIndex: 0,
      questionTranslation: 'What worries Li most?',
    ),
    ReadingQuestion(
      question: '李老师给普通人的建议是什么？',
      options: ['从小事做起', '多买东西', '搬到农村'],
      correctIndex: 0,
      questionTranslation: 'What is Li\'s advice for ordinary people?',
    ),
  ],
);

final QuizContent enZhC11DictOpinion = enZhDict(
  id: 'en_zh_c1_1_dict_opinion',
  title: 'Dictation: opinion lines',
  intro:
      'Formal sentences now — longer clauses, abstract nouns. Hold the whole '
      'clause before typing; the suffixes 化/性 are your anchors.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚠️ Homophones multiply at C1',
      text: '事/是/市, 化/话/画 — the IME needs the whole word: type '
          '"chengshihua" (城市化) not syllable by syllable, and the right '
          'characters surface.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'In my view, this issue is very important.', answer: '在我看来，这个问题很重要。'),
    CourseItem(prompt: 'Technology has had a deep influence on our lives.', answer: '科技对我们的生活产生了深刻的影响。'),
    CourseItem(prompt: 'Urbanization brought opportunities and also challenges.', answer: '城市化带来了机会，也带来了挑战。'),
    CourseItem(prompt: 'Since you\'ve decided, then do it well.', answer: '既然你决定了，就好好做吧。'),
    CourseItem(prompt: 'Learning a language must not stop halfway. (成语!)', answer: '学语言不能半途而废。'),
    CourseItem(prompt: 'Owing to the weather, the flight was delayed.', answer: '由于天气原因，航班延误了。'),
    CourseItem(prompt: 'Regarding this question, everyone has different views.', answer: '关于这个问题，大家有不同的看法。'),
    CourseItem(prompt: 'This news is astonishing.', answer: '这个消息令人吃惊。'),
    CourseItem(prompt: 'Globalization changed the world.', answer: '全球化改变了世界。'),
    CourseItem(prompt: 'He achieved very good results.', answer: '他取得了很好的成绩。'),
    CourseItem(prompt: 'Smoking is harmful to health.', answer: '吸烟对健康有害。'),
    CourseItem(prompt: 'The station was crowded with people.', answer: '车站里人山人海。'),
    CourseItem(prompt: 'This film is very moving.', answer: '这部电影很令人感动。'),
    CourseItem(prompt: 'Hurry, otherwise we\'ll be late.', answer: '快点儿，否则我们会迟到。'),
    CourseItem(prompt: 'People here tend to sleep very late.', answer: '这里的人往往睡得很晚。'),
  ],
);

final QuizContent enZhC11ReadEssay = enZhRead(
  id: 'en_zh_c1_1_read_essay',
  title: 'Reading: 一篇议论文',
  passageTitle: '慢下来的勇气',
  passage:
      '在这个一切都追求"快"的时代，"慢"几乎成了一个贬义词。'
      '吃饭要快，走路要快，连休息都要"高效率"。'
      '然而，快真的总是好的吗？\n'
      '首先，快容易使人马马虎虎。为了赶时间，我们常常把工作做得又快又糟，'
      '最后不得不花更多的时间去改正错误——欲速则不达，古人早就明白这个道理。\n'
      '其次，快使我们失去了很多东西。由于急着赶路，我们看不见路边的风景；'
      '由于急着回消息，我们听不完朋友的一句话。'
      '生活的意义，往往就藏在这些被我们跳过的细节里。\n'
      '当然，慢不等于懒。该快的时候快，该慢的时候慢，'
      '这才是真正的生活智慧。在人人都跑的时代，'
      '敢于慢下来，反而需要更大的勇气。',
  passageTranslation:
      'In an era that chases "fast" in everything, "slow" has almost become a '
      'dirty word. Eat fast, walk fast — even rest must be "efficient". But '
      'is fast really always good?\n'
      'First, speed breeds carelessness. Racing the clock, we do our work '
      'fast and badly, then spend more time fixing the mistakes — "haste '
      'brings no arrival," as the ancients already knew.\n'
      'Second, speed costs us things. Rushing down the road, we miss the '
      'scenery beside it; rushing to answer messages, we don\'t hear a friend '
      'finish a sentence. Life\'s meaning often hides in exactly the details '
      'we skip.\n'
      'Of course, slow is not lazy. Fast when it should be fast, slow when it '
      'should be slow — that is real wisdom about living. In an age when '
      'everyone runs, daring to slow down takes the greater courage.',
  intro:
      'A model argumentative essay: thesis, two supports, a concession, a '
      'turn — with 成语, 由于, 往往 and 反而 doing the heavy lifting.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '欲速则不达',
      text: '"Desire speed, and you won\'t arrive" — a classical 成语 quoted '
          'mid-essay, exactly how educated prose deploys them (Z30).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '文章说，快容易使人怎么样？',
      options: ['马马虎虎', '更聪明', '更健康'],
      correctIndex: 0,
      questionTranslation: 'According to the essay, what does speed breed?',
    ),
    ReadingQuestion(
      question: '"欲速则不达"是什么意思？',
      options: ['太求快反而到不了', '走得快就到得早', '慢就是懒'],
      correctIndex: 0,
      questionTranslation: 'What does "yù sù zé bù dá" mean?',
    ),
    ReadingQuestion(
      question: '文章认为真正的生活智慧是什么？',
      options: ['该快就快，该慢就慢', '什么都快', '什么都慢'],
      correctIndex: 0,
      questionTranslation: 'What does the essay call real wisdom about living?',
    ),
  ],
);

/// C1.1 in chain order.
final List<QuizContent> enZhC1_1 = [
  enZhC11Synonyms1,
  enZhC11ShiLing,
  enZhC11SpeakOpinion,
  enZhC11Prepositions,
  enZhC11ListenLecture,
  enZhC11Chengyu,
  enZhC11Attributives,
  enZhC11ReadTech,
  enZhC11Jiran,
  enZhC11WordBuilding,
  enZhC11SpeakFormal,
  enZhC11Collocations,
  enZhC11ListenEnvironment,
  enZhC11DictOpinion,
  enZhC11ReadEssay,
];
